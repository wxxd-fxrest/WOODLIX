//
//  AddCardViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class AddCardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var expiryDateField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIView!
    @IBOutlet weak var vccField: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        
        modalPresentationStyle = .overCurrentContext
        
        let desiredHeight: CGFloat = 400 
        let yOffset = UIScreen.main.bounds.height - desiredHeight
        let frame = CGRect(x: 0, y: yOffset, width: UIScreen.main.bounds.width, height: desiredHeight)
        self.view.frame = frame
    }
}
