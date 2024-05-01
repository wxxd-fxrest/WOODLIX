//
//  ViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties
    let scale: CGFloat = 1.2
    
    // MARK: - Outlets
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tiketTabView: UIView!
    @IBOutlet weak var mainTabView: UIView!
    @IBOutlet weak var profileTabView: UIView!
    
    @IBOutlet weak var tiketIcon: UIImageView!
    @IBOutlet weak var mainIcon: UIImageView!
    @IBOutlet weak var profileIcon: UIImageView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUIdesign()
        resetIconOpacity()
        
        DispatchQueue.main.async {
            self.startPage()
        }
    }
    
    // MARK: - UI Design
    func tabBarUIdesign() {
        let cornerRadius: CGFloat = 24.0
        tabBarView.layer.cornerRadius = cornerRadius
        tabBarView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = tabBarView.bounds
        gradientLayer.colors = [UIColor(red: 84/255, green: 148/255, blue: 216/255, alpha: 0.3).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 4.0, y: 0.3)
        
        tabBarView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Navigation
    func startPage() {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "MainView") as? MainViewController else { return }
        contentView.addSubview(viewController.view)
        animateIcon(mainIcon)
        viewController.didMove(toParent: self)
    }

    // MARK: - Animation
    func animateIcon(_ icon: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            icon.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            icon.alpha = 1.0
        }
    }
    
    // MARK: - Tab Button Actions
    @IBAction func onClickTabButton(_ sender: UIButton) {
        let tag = sender.tag
        print(tag)
        
        resetIconScaleAndOpacity()

        if tag == 0 {
            guard let tiketViewController = self.storyboard?.instantiateViewController(identifier: "TiketList") as? TiketListViewController else { return }
            contentView.addSubview(tiketViewController.view)
            animateIcon(tiketIcon)
            tiketViewController.didMove(toParent: self)
        } else if tag == 1 {
            startPage()
        } else if tag == 2 {
            guard let profileViewController = self.storyboard?.instantiateViewController(identifier: "ProfileView") as? ProfileViewController else { return }
            contentView.addSubview(profileViewController.view)
            animateIcon(profileIcon)
            profileViewController.didMove(toParent: self)
        }
    }
    
    // MARK: - Reset
    func resetIconScaleAndOpacity() {
        [tiketIcon, mainIcon, profileIcon].forEach { icon in
            UIView.animate(withDuration: 0.3) {
                icon.transform = .identity
            }
        }
        
        resetIconOpacity()
    }
    
    func resetIconOpacity() {
        [tiketIcon, mainIcon, profileIcon].forEach { icon in
            icon.alpha = 0.8
        }
    }
}
