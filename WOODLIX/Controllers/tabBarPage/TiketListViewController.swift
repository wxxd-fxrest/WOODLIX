//
//  TiketListViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/1/24.
//

import UIKit

class TiketListViewController: UIViewController {

    @IBOutlet weak var tiketHeaderView: UIView!
    @IBOutlet weak var tiketBottomView: UIView!
    @IBOutlet weak var tiketMiddleLeftView: UIView!
    @IBOutlet weak var tiketMiddleRightView: UIView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var cinemaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tiketHeaderView.layer.cornerRadius = 12
        tiketBottomView.layer.cornerRadius = 12
        cinemaView.layer.cornerRadius = 4
        
        tiketMiddleLeftView.layer.cornerRadius = tiketMiddleLeftView.bounds.width / 2
        tiketMiddleLeftView.layer.masksToBounds = true
        
        tiketMiddleRightView.layer.cornerRadius = tiketMiddleRightView.bounds.width / 2
        tiketMiddleRightView.layer.masksToBounds = true
        
        let path = UIBezierPath(roundedRect: movieImageView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 12, height: 12))

        // Create a shape layer with the path
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        // Apply the mask to the image view
        movieImageView.layer.mask = maskLayer
    }
}
