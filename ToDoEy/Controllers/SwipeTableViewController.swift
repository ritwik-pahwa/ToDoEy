//
//  SwipeTableViewController.swift
//  ToDoEy
//
//  Created by Ritwik Pahwa on 21/04/22.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    //Mark:- swipe delegate methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        let editAction = SwipeAction(style: .destructive, title: "Edit") { action, indexPath in
            self.updateAction(at: indexPath)
        }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete_image")
            editAction.image = UIImage(named: "edit-image")
        
            return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .drag
        return options
    }
    
    
    //Marks- TablView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
        
    }
    
    func updateModel(at indexPath: IndexPath){
        //delete code inheritance 
    }
    
    func updateAction(at indexPath: IndexPath){
        //update code inheritance
    }
    
}
