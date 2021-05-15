//
//  ViewControllerCoreData.swift
//  MyGamesApp
//
//  Created by aluno on 28/04/21.
//  Copyright © 2021 Tiago Borges. All rights reserved.
//

import UIKit
import CoreData
extension UIViewController {
 
    // propriedade computada que através de uma Extension permite agora que qualquer
    // objeto UIViewController conheça essa propriedade context.
 
    var context: NSManagedObjectContext {
     
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
        // obtem a instancia do Core Data stack
        return appDelegate.persistentContainer.viewContext
    }
}
