//
//  ConsolesTableViewController.swift
//  MyGamesApp
//
//  Created by aluno on 27/04/21.
//  Copyright © 2021 Tiago Borges. All rights reserved.
//

import UIKit
import CoreData

class ConsolesTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Console>!
    
    var label = UILabel()
    
    var console: Console?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // mensagem default
        label.text = "Você não tem Consoles cadastrados"
        label.textAlignment = .center
        
        loadConsoles()
    }
    
    func loadConsoles() {
        // Coredata criou na classe model uma funcao para recuperar o fetch request
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        
        // definindo criterio da ordenacao de como os dados serao entregues
        let consoleTitleSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [consoleTitleSortDescriptor]
        
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
        if segue.identifier! == "consoleSegue" {
            //print("gameSegue")
            let vc = segue.destination as! ConsoleViewController
            
            if let consoles = fetchedResultController.fetchedObjects {
                vc.console = consoles[tableView.indexPathForSelectedRow!.row]
            }
            
        } else if segue.identifier! == "newConsoleSegue" {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsoleTableViewCell
        
        guard let console = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: console)
        return cell
    }
    
    
}

extension ConsolesTableViewController: NSFetchedResultsControllerDelegate {
    
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
