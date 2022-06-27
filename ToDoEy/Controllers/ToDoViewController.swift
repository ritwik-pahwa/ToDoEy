//
//  ViewController.swift
//  ToDoEy
//
//  Created by Ritwik Pahwa on 11/04/22.
//

import UIKit
import CoreData

class ToDoViewController: SwipeTableViewController {

    var a = [Item] ()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Mark - TableView datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = a[indexPath.row].name
        cell.accessoryType = a[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MArk- tableView delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        a[indexPath.row].done  = !a[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.name = TextField.text!
            newItem.done = false
            newItem.categoryRelation = self.selectedCategory
            
            self.a.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new text field"
            TextField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //Mark: model manipulation methods
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context,  \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "categoryRelation.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            a = try context.fetch(request)
        }
        catch{
            print("error fetching data with error \(error)")
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        self.context.delete(self.a[indexPath.row])
        self.a.remove(at: indexPath.row)
        self.saveItems()
    }
    
    override func updateAction(at indexPath: IndexPath) {
        
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.a[indexPath.row].setValue(TextField.text!, forKey: "name")
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "create new text field"
            TextField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
