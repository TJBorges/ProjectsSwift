//
//  ConsoleTableViewCell.swift
//  MyGamesApp
//
//  Created by aluno on 16/05/21.
//  Copyright © 2021 Tiago Borges. All rights reserved.
//

import UIKit
class ConsoleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepare(with console: Console) {
        lbConsole.text = console.name ?? ""
        if let image = console.cover as? UIImage {
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCover")
        }
    }
    
}
