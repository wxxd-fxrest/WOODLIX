//
//  PaymentManagementViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class PaymentManagementViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addCardBarView: UIView!
    @IBOutlet weak var addCardButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUIdesign()
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Design
    func tabBarUIdesign() {
        let cornerRadius: CGFloat = 24.0
        addCardBarView.layer.cornerRadius = cornerRadius
        addCardBarView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = addCardBarView.bounds
        gradientLayer.colors = [UIColor(red: 84/255, green: 148/255, blue: 216/255, alpha: 0.3).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 4.0, y: 0.3)
        
        addCardBarView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Button Actions
    @IBAction func addCardButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let bottomSheetVC = storyboard.instantiateViewController(identifier: "AddCardView")
        
        guard let sheet = bottomSheetVC.presentationController as? UISheetPresentationController else {
            return
        }
        
        sheet.detents = [.medium()]
        sheet.prefersGrabberVisible = true
        
        self.present(bottomSheetVC, animated: true)
    }
}
