//
//  DetailViewController.swift
//  PeekAndPop
//
//  Created by Alice Aponasko on 2/21/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit

let DetailViewControllerID = "DetailViewController"
let PeekDetailViewControllerID = "PeekDetailViewController"

class DetailViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = photoImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
    }

}
