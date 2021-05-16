//
//  ConsoleViewController.swift
//  MyGamesApp
//
//  Created by aluno on 16/05/21.
//  Copyright © 2021 Tiago Borges. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {
    
    @IBOutlet weak var lbConsole: UILabel!
    
    @IBOutlet weak var ivCover: UIImageView!
    
    var console: Console?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbConsole.text = console?.name
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbConsole.text = console?.name
        
        if let image = console?.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditConsoleViewController
        vc.console = console
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
