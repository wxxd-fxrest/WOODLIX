//
//  OttPurchaseViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/8/24.
//

import UIKit

class OttPurchaseViewController: UIViewController {
    var selectedItem: (movie: MovieDataModel, data: APIMovieDataModel, reservable: Bool, coming: Bool)?

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var priceBoxView: UIView!
    @IBOutlet weak var saveButton: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("OttPurchaseViewController \(selectedItem)")
        
        movieNameLabel.text = selectedItem!.movie.originalTitle
        priceBoxView.layer.cornerRadius = 12
        priceBoxView.layer.borderWidth = 1
        priceBoxView.layer.borderColor = UIColor(named: "RedColor")?.cgColor
        priceBoxView.backgroundColor = UIColor(named: "WhiteColor")

        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
    }
}
