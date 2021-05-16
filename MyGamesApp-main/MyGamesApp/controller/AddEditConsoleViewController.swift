//
//  AddEditConsoleViewController.swift
//  MyGamesApp
//
//  Created by aluno on 15/05/21.
//  Copyright © 2021 Tiago Borges. All rights reserved.
//

import UIKit
import Photos

class AddEditConsoleViewController: UIViewController {
    
    var console: Console!
    
    var consolesManager = ConsolesManager.shared
    
    // tip. Lazy somente constroi a classe quando for usar
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self as! UIPickerViewDelegate
        pickerView.dataSource = self as! UIPickerViewDataSource
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consolesManager.loadConsoles(with: context)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareDataLayout()
    }
    
    func prepareDataLayout() {
        if console != nil {
            title = "Editar jogo"
            btAddEdit.setTitle("ALTERAR", for: .normal)
            tfConsole.text = console.name
            
            // tip. alem do console pegamos o indice atual para setar o picker view
//            if let console = game.console, let index = consolesManager.consoles.index(of: console) {
//                tfConsole.text = console.name
//                pickerView.selectRow(index, inComponent: 0, animated: false)
//            }
            ivCover.image = console.cover as? UIImage
            
            if console.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
        }
        
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
//        toolbar.tintColor = UIColor(named: "main")
//        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
//        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
//        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolbar.items = [btCancel, btFlexibleSpace, btDone]
//
//        // tip. faz o text field exibir os dados predefinidos pela picker view
//        tfConsole.inputView = pickerView
//        tfConsole.inputAccessoryView = toolbar
//    }
//
//    @objc func cancel() {
//        tfConsole.resignFirstResponder()
//    }
//
//    @objc func done() {
//        if ConsolesManager.shared.consoles.count > 0 {
//            tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
//            cancel()
//        }
    }
    
    @IBAction func AddEditCover(_ sender: UIButton) {
        // para adicionar uma imagem da biblioteca
        print("para adicionar uma imagem da biblioteca")
        
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    @IBAction func addEditConsole(_ sender: UIButton) {
        // acao salvar novo ou editar existente
        
        if console == nil {
            console = Console(context: context)
        }
        
        console.name = tfConsole.text
        
//        if !tfConsole.text!.isEmpty {
//            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
//            game.console = console
//        }
        console.cover = ivCover.image
        
        do {
            //SALVAR
            try context.save()
            print("salvou")
        } catch {
            print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddEditConsoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConsolesManager.shared.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = ConsolesManager.shared.consoles[row]
        return console.name
    }
}

extension AddEditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivCover.image = pickedImage
                self.ivCover.setNeedsDisplay()
                self.btCover.setTitle(nil, for: .normal)
                self.btCover.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
