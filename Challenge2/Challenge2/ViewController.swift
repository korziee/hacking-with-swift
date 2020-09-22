//
//  ViewController.swift
//  Challenge2
//
//  Created by Kory Porter on 22/9/20.
//  Copyright © 2020 Kory Porter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingListItems = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let menuButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(showActionList)
        )
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonClicked)
        )
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func showActionList() {
        let ac = UIAlertController(
            title: "Action",
            message: "Choose an action",
            preferredStyle: .actionSheet
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Share",
                style: .default,
                handler: { [weak self] _ in
                    self?.shareShoppingList()
                }
            )
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Clear",
                style: .destructive,
                handler: { [weak self] _ in
                    self?.clearShoppingList()
                }
            )
        )
        
        present(ac, animated: true)

    }
    
    func shareShoppingList() {
        let activityController = UIActivityViewController(
            activityItems: [shoppingListItems.joined(separator: "\n")],
            applicationActivities: nil
        )
        
        present(activityController, animated: true)
    }
    
    @objc func clearShoppingList() {
        shoppingListItems = []
        tableView.reloadData()
    }
    
    @objc func addButtonClicked() {
        let ac = UIAlertController(
            title: "Add to shopping cart",
            message: "what do you want to add?",
            preferredStyle: .alert
        )
        
        ac.addTextField()
        
        let action = UIAlertAction(
            title: "Add",
            style: .default
        ) { [weak self, weak ac] _ in
                guard let answer = ac?.textFields?[0].text else { return }
                self?.addToShoppingList(answer)
        }
        
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func addToShoppingList(_ product: String) {
        shoppingListItems.append(product)

        let indexPath = IndexPath(row: shoppingListItems.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = shoppingListItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListItems.count;
    }

}

