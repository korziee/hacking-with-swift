//
//  ViewController.swift
//  Challenge1
//
//  Created by Kory Porter on 13/9/20.
//  Copyright © 2020 Kory Porter. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flags"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let imageView = cell.imageView {
            // TODO: https://www.appcoda.com/ios-programming-customize-uitableview-storyboard/ to implement better styled images
            imageView.image = UIImage(named: countries[indexPath.row])
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.purple.cgColor
            imageView.layer.cornerRadius = 20
        }

        cell.textLabel?.text = countries[indexPath.row].uppercased()

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            
            vc.selectedImage = SelectedImage(
                path: countries[indexPath.row],
                title: countries[indexPath.row].uppercased()
            )
            
            print("here")
            
            
//            vc.image.image = UIImage(named: countries[indexPath.row])

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Could not instanstiate")
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    
}

