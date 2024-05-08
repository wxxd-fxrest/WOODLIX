//
//  DetailViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedItem: (movie: MovieDataModel, reservable: Bool, comming: Bool)?

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var topShadowBoxView: UIView!
    @IBOutlet weak var shadowBoxView: UIView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var playButtonIcon: UIImageView!
    @IBOutlet weak var playButtonBackgroundView: UIView!
    
    @IBOutlet weak var overviewBoxView: UIView!
    
    @IBOutlet weak var ticketButtonIcon: UIImageView!
    @IBOutlet weak var ticketButtonLabel: UILabel!
    @IBOutlet weak var ticketingButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(selectedItem.movie.posterPath ?? "")"
            configure(with: imageUrl, title: selectedItem.movie.originalTitle)
            addOverviewLabel(overview: selectedItem.movie.overview)
        }
        
        // reservable = true // 예매 가능
        // reservable = false // 예매 불가능
        // comming = true // comming soon
        if let selectedItem = selectedItem {
            let movie = selectedItem.movie
            let reservable = selectedItem.reservable
            let comming = selectedItem.comming
            
            print("Movie: \(movie)")
            print("Reservable: \(reservable)")
            print("Comming: \(comming)")
            
            if reservable {
                playButtonIcon.isHidden = true
                ticketButtonLabel.text = "바로 예매"
             } else if comming {
                 playButtonIcon.isHidden = true
                 ticketButtonIcon.image = UIImage(named: "Fire")
                 ticketButtonLabel.text = "Comming Soon"
             } else {
                 ticketButtonIcon.image = UIImage(named: "Play")
                 ticketButtonLabel.text = "OTT 구매"
             }
        } else {
            print("Selected item is nil")
        }

        tabBarUIdesign()
        topShadowBoxUIdesign()
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
        gradientLayer.colors = [UIColor(red: 84/255, green: 148/255, blue: 216/255, alpha: 0.5).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 4.0, y: 0.3)
        
        tabBarView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func topShadowBoxUIdesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = topShadowBoxView.bounds
        gradientLayer.colors = [UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 1.0).cgColor, UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 0.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
        
        topShadowBoxView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func shadowBoxUIdesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = shadowBoxView.bounds
        gradientLayer.colors = [UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 1.0).cgColor, UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 0.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1)
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
        if let selectedItem = selectedItem {
            if selectedItem.reservable {
                let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "TicketingView") as? TicketingViewController else {
                    print("Failed to instantiate MainPageViewController from UserStoryboard.")
                    return
                }
                
                targetVC.selectedItem = selectedItem
                targetVC.modalPresentationStyle = .fullScreen
                present(targetVC, animated: true, completion: nil)
            } else if selectedItem.comming {
                let alert = UIAlertController(title: nil, message: "개봉 후 예매가 가능합니다.", preferredStyle: .alert)
                present(alert, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        alert.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let bottomSheetVC = storyboard.instantiateViewController(identifier: "OttPurchaseView") as! OttPurchaseViewController
                bottomSheetVC.selectedItem = selectedItem

                guard let sheet = bottomSheetVC.presentationController as? UISheetPresentationController else {
                    return
                }

                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true

                self.present(bottomSheetVC, animated: true)
            }
        }
    }
}
