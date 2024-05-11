//
//  DetailViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DetailViewController: UIViewController {
    
    var db = Firestore.firestore()
    let storage = Storage.storage()
    
    var userInfoCollection: CollectionReference!

    var selectedItem: (movie: MovieDataModel, data: APIMovieDataModel, reservable: Bool, coming: Bool)?

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var wishButton: UIButton!
    
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
    
    var isWishListed = false

    let heartImage = UIImage(systemName: "heart")
    let heartFillImage = UIImage(systemName: "heart.fill")
    
    var logineedEmail: String = ""
    var userInfoDocID: String = ""

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
        // coming = true // coming soon
        if let selectedItem = selectedItem {
            let movie = selectedItem.movie
            let data = selectedItem.data
            let reservable = selectedItem.reservable
            let coming = selectedItem.coming
            
            print("Movie: \(movie)")
            print("MovieData: \(data)")
            print("Reservable: \(reservable)")
            print("Coming: \(coming)")
            
            if reservable {
                playButtonIcon.isHidden = true
                playButtonBackgroundView.isHidden = true
                ticketButtonLabel.text = "바로 예매"
             } else if coming {
                 var formattedDate: String = ""

                 if let openDate = data.openDt {
                     if openDate.count >= 8 {
                         let monthStartIndex = openDate.index(openDate.startIndex, offsetBy: 4)
                         let monthEndIndex = openDate.index(openDate.startIndex, offsetBy: 6)
                         let month = openDate[monthStartIndex..<monthEndIndex]

                         let dayStartIndex = openDate.index(openDate.startIndex, offsetBy: 6)
                         let dayEndIndex = openDate.index(openDate.startIndex, offsetBy: 8)
                         let day = openDate[dayStartIndex..<dayEndIndex]

                         formattedDate = "\(month)/\(day)"
                         print(formattedDate)
                     } else {
                         formattedDate = ""
                         print("openDate does not have enough characters")
                     }
                 } else {
                     formattedDate = ""
                     print("openDate is nil")
                 }
                 
                 playButtonIcon.isHidden = true
                 playButtonBackgroundView.isHidden = true
                 ticketButtonIcon.image = UIImage(named: "Fire")
                 ticketButtonLabel.text = "\(formattedDate) Coming Soon"
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
        tabBarView.backgroundColor = UIColor(named: "TabColor")?.withAlphaComponent(0.9)
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
    @IBAction func wishListButtonTapped(_ sender: UIButton) {
        isWishListed.toggle()
        
        if isWishListed {
            wishButton.setImage(heartFillImage, for: .normal)
        } else {
            wishButton.setImage(heartImage, for: .normal)
        }
        
        print("Is wish listed: \(isWishListed)")
        let currentStateImage = wishButton.image(for: .normal)
        print("Current button image: \(currentStateImage)")
    }
    
    @IBAction func navigateToMainPage() {
        if let selectedItem = selectedItem {
            if selectedItem.reservable {
                if let user = Auth.auth().currentUser {
                    let userEmail = user.email!
                    print("Firebase User Email: \(userEmail)")

                    // Query the user information based on their email
                    let query = db.collection("UserInfo").whereField("email", isEqualTo: userEmail)

                    query.getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching documents: \(error)")
                            return
                        }
                        
                        guard let document = querySnapshot?.documents.first else {
                            print("User document not found for email: \(userEmail)")
                            return
                        }
                        
                        let userInfoDocID = document.documentID
                        
                        let ticketingQuery = self.db.collection("UserInfo").document(userInfoDocID).collection("Ticketing").whereField("status", isEqualTo: false)
                        
                        ticketingQuery.getDocuments { (ticketingSnapshot, ticketingError) in
                            if let ticketingError = ticketingError {
                                print("Error fetching ticketing documents: \(ticketingError)")
                                return
                            }
                            
                            guard let ticketingSnapshot = ticketingSnapshot else {
                                print("Ticketing snapshot is nil.")
                                return
                            }
                            
                            if !ticketingSnapshot.isEmpty {
                                // User already has a ticket reservation with status=false
                                let alert = UIAlertController(title: "이미 예약된 티켓이 있습니다.", message: "관람 또는 취소 후 다른 영화를 예약하실 수 있습니다.", preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in }
                                alert.addAction(cancelAction)
                                alert.addAction(confirmAction)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "TicketingView") as? TicketingViewController else {
                                    print("Failed to instantiate TicketingViewController.")
                                    return
                                }
                                
                                targetVC.selectedItem = selectedItem
                                targetVC.modalPresentationStyle = .fullScreen
                                self.present(targetVC, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    print("User is not logged in.")
                }
            } else if selectedItem.coming {
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
