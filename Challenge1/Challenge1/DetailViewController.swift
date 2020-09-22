//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Kory Porter on 14/9/20.
//  Copyright © 2020 Kory Porter. All rights reserved.
//

import UIKit

struct SelectedImage {
    var path: String
    var title: String
}

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: SelectedImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "View Picture"
        
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

                
        if let imageToLoad = selectedImage {
            title = imageToLoad.title
            imageView.image = UIImage(named: imageToLoad.path)
            
//            imageView.contentMode = .scaleToFill
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image, selectedImage.title], applicationActivities: [])

        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
