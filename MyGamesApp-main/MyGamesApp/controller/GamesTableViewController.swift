//
//  GamesTableViewController.swift
//  MyGamesApp
//
//  Created by aluno on 27/04/21.
//  Copyright © 2021 Tiago Borges. All rights reserved.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Game>!
    
    var label = UILabel()
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mensagem default
        label.text = "Você não tem jogos cadastrados"
        label.textAlignment = .center
        
        loadGames()
    }

    func loadGames() {
        // Coredata criou na classe model uma funcao para recuperar o fetch request
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
             
        // definindo criterio da ordenacao de como os dados serao entregues
        let gameTitleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [gameTitleSortDescriptor]
             
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
             
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // se ocorrer mudancas na entidade Console, a atualização automatica não irá ocorrer porque nosso NSFetchResultsController esta monitorando a entidade Game. Caso tiver mudanças na entidade Console precisamos atualizar a tela com a tabela de alguma forma: reloadData :)
      tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "gameSegue" {
            //print("gameSegue")
            let vc = segue.destination as! GameViewController
           
            if let games = fetchedResultController.fetchedObjects {
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
           
        } else if segue.identifier! == "newGameSegue" {
            //print("newGameSegue")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("Tij")
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController?.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
          return cell
        }
             
        cell.prepare(with: game)
        return cell
    }
    

}

extension GamesTableViewController: NSFetchedResultsControllerDelegate {
 
    // sempre que algum objeto for modificado esse metodo sera notificado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     
        switch type {
            case .delete:
                if let indexPath = indexPath {
                    // Delete the row from the data source
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                break
            default:
                tableView.reloadData()
        }
    }
}
