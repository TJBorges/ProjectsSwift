//
//  REST.swift
//  Carangas
//
//  Created by Douglas Frari on 5/10/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}


class REST {
    
    // URL + endpoint
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    // URL TABELA FIPE
    private static let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
    
    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration)
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    // o metodo pode retornar um array de nil se tiver algum erro
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        
        guard let url = URL(string: urlFipe) else {
            onComplete(nil)
            return
        }
        // tarefa criada, mas nao processada
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200 {
                    // obter o valor de data
                    guard let data = data else {
                        onComplete(nil)
                        return
                    }
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        onComplete(brands)
                    } catch {
                        // algum erro ocorreu com os dados
                        onComplete(nil)
                    }
                } else {
                    onComplete(nil)
                }
            } else {
                onComplete(nil)
            }
        }.resume()
        
    } // fim do loadBrands
    
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        
        guard let url = URL(string: REST.basePath) else {
            onError(.url)
            return
        }
        
        Alamofire.request(url).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                
                if response.data == nil {
                    onError(.noData)
                }
                
                do {
                    let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                    
                    onComplete(cars)
                    
                } catch {
                    print(error.localizedDescription)
                    onError(.invalidJSON)
                }
                
            case let .failure(error):
                debugPrint(error)
                onError(.taskError(error: error))
            }
            
        }
        
    }
    
    
    private class func applyOperation(car: Car, operation: RESTOperation,
                                      onComplete: @escaping (Bool) -> Void,
                                      onError: @escaping (CarError) -> Void) {
        
        // o endpoint do servidor para update é: URL/id
        let urlString = basePath + "/" + (car._id ?? "")
        
        guard let url = URL(string: urlString) else {
            //onComplete(false)
            onError(.url)
            return
        }
        //var request = URLRequest(url: url)
        var httpMethod: String = ""
        
        switch operation {
        case .delete:
            httpMethod = "DELETE"
        case .save:
            httpMethod = "POST"
        case .update:
            httpMethod = "PUT"
        }
        
        Alamofire.request(urlString,
                          method: HTTPMethod.init(rawValue: httpMethod),
                          parameters: car,
                          encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                
                switch response.response?.statusCode {
                case 200:
                    onComplete(true)
                default:
                    debugPrint(response.error ?? "Erro ao realizar operação")
                    onError(.taskError(error: response.error!))
                }
        }
        
    }
    
}
