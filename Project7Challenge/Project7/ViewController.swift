//
//  ViewController.swift
//  Project7
//
//  Created by Kory Porter on 23/9/20.
//  Copyright © 2020 Kory Porter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credits = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        navigationItem.rightBarButtonItem = credits
        
        let filterButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showFilterModal))
        
        navigationItem.leftBarButtonItem = filterButton
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        showError()
    }
    
    @objc func showFilterModal() {
        let ac = UIAlertController(
            title: "Filter Petitions",
            message: "Enter your filter criteria",
            preferredStyle: .alert
        )
    
        ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            
            self?.filterPetitions(text)
        }))
    
        ac.addTextField()
        
        present(ac, animated: true)
    }
    
    func filterPetitions(_ filter: String) {
        filteredPetitions = petitions.filter({ (petition: Petition) -> Bool in
            return petition.title.contains(filter)
        })
        
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredPetitions.count > 0 {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition: Petition
        
        if filteredPetitions.count > 0 {
            petition = filteredPetitions[indexPath.row]
        } else {
            petition = petitions[indexPath.row]
        }

        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

