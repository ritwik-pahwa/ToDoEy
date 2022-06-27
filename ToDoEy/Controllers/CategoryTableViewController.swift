//
//  CategoryTableViewController.swift
//  ToDoEy
//
//  Created by Ritwik Pahwa on 20/04/22.
//

import UIKit
import CoreData

class CategoryTableViewController: SwipeTableViewController {

    var catArray = [Category] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.rowHeight = 80.0
    }
    
    //Mark: delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinatioVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinatioVC.selectedCategory = catArray[indexPath.row]
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
    
                let newCategory = Category(context: self.context)
                newCategory.name = TextField.text!

                self.catArray.append(newCategory)

                self.saveCategory()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new category"
            TextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
      
    }
    
    // MARK: - Table view data sourc

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = catArray[indexPath.row].name
        return cell
        
    }
    
    //Mark: data maipulation methods
    
    func saveCategory(){
        do{
            try context.save()
        }
        catch{
            print("error while svaing category - \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            catArray = try context.fetch(request)
        }
        catch{
            print("error while fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    //Mark:- deletion with swipe
    
    override func updateModel(at indexPath: IndexPath){
        self.context.delete(self.catArray[indexPath.row])
        self.catArray.remove(at: indexPath.row)
        self.saveCategory()
    }
    
    //Mark: edit with swipe
    
    override func updateAction(at indexPath: IndexPath) {
        var TextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            self.catArray[indexPath.row].setValue(TextField.text!, forKey: "name")
            self.saveCategory()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new category"
            TextField = alertTextField
        }
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
        
    }
}

