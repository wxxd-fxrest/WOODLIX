//
//  DetailViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedItem: (movie: MovieDataModel, reservable: Bool)?

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var shadowBoxView: UIView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var playButtonBackgroundView: UIView!
    
    @IBOutlet weak var overviewBoxView: UIView!
    
    @IBOutlet weak var ticketingButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
             let imageUrl = "https://image.tmdb.org/t/p/w500/\(selectedItem.movie.posterPath ?? "")"
             configure(with: imageUrl, title: selectedItem.movie.originalTitle)
            addOverviewLabel(overview: selectedItem.movie.overview)
         }
        
        print("selectedItemselectedItem \(selectedItem)")
        tabBarUIdesign()
        shadowBoxUIdesign()

        playButtonBackgroundView.layer.cornerRadius = min(playButtonBackgroundView.bounds.width, playButtonBackgroundView.bounds.height) / 2
        playButtonBackgroundView.clipsToBounds = true

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
    
    func shadowBoxUIdesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = shadowBoxView.bounds
        gradientLayer.colors = [UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 1.0).cgColor, UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 0.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.6)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        shadowBoxView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addOverviewLabel(overview: String) {
        let overviewLabel = UILabel()
        overviewLabel.text = overview
        overviewLabel.font = UIFont.systemFont(ofSize: 14)
        overviewLabel.textColor = UIColor(named: "WhiteColor")
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        overviewBoxView.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: overviewBoxView.topAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: overviewBoxView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: overviewBoxView.trailingAnchor, constant: -20),
            overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: overviewBoxView.bottomAnchor, constant: 20)
        ])
        
        let heightConstraint = overviewBoxView.heightAnchor.constraint(equalTo: overviewLabel.heightAnchor, constant: 40)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }

    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    var selectedItemIndex: Int?
    
    init(selectedItemIndex: Int) {
        self.selectedItemIndex = selectedItemIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectedItemIndex = aDecoder.decodeInteger(forKey: "selectedItemIndex")
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        if let selectedItemIndex = selectedItemIndex {
            aCoder.encode(selectedItemIndex, forKey: "selectedItemIndex")
        }
    }
    
    func configure(with imageUrl: String, title: String) {
        movieImageView.image = UIImage(named: "basicImage")
        titleLabel.text = title
        
        titleLabel.lineBreakMode = .byTruncatingTail
        
        guard let url = URL(string: imageUrl) else {
            print("Invalid image URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.movieImageView.image = image
                    }
                } else {
                    print("Failed to convert data to UIImage")
                }
            }
        }.resume()
    }

    
    // MARK: - Tab Button Actions
    @IBAction func navigateToMainPage() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "TicketingView") as? TicketingViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}
