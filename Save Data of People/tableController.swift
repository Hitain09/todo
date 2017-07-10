//
//  tableController.swift
//  Save Data of People
//
//  Created by Rishav on 26/04/17.
//  Copyright © 2017 Rishav. All rights reserved.
//

import UIKit
import CoreData

class tableController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var items: [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Data"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func logOut(_ sender: Any) {
        udacityclient.sharedInstance().endUserSession { (success, error) in
            if success {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(error!)
            }
        }
        
    }
    
    func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContexting = appDelegate.dataSaver.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SaveData")
        do {
            items = try managedContexting.fetch(fetchRequest)
        } catch let error as NSError {
            showAlert("Data Not Saved! \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func addData(_ sender: UIBarButtonItem) {
        let prompt = UIAlertController(title: "New Data", message: "Enter todo", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = prompt.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.save(data: nameToSave)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        prompt.addTextField()
        prompt.addAction(save)
        prompt.addAction(cancel)
        present(prompt, animated: true)
    }
    
    func save(data: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.dataSaver.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SaveData",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(data, forKeyPath: "data")
        do {
            try managedContext.save()
            items.append(person)
        } catch let error as NSError {
            showAlert("Data Not Saved! \(error), \(error.userInfo)")
        }
    }
}

extension tableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "data") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.dataSaver.viewContext
        if(editingStyle==UITableViewCellEditingStyle.delete) {
            managedContext.delete(items[indexPath.row])
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try managedContext.save()
            } catch let error as NSError {
                showAlert("Data Not Saved ! \(error), \(error.userInfo)")
            }
        }
    }
}
