//
//  ProfileViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let ottPurchaseListArray: Array = [
        (
            originalTitle: "다섯 번째 방",
             title: "다섯 번째 방",
             id: 1031249,
             posterPath: "/vJrVwiY5I0o5djv19Uy6cdHiv4c.jpg"
        ),
        (
            originalTitle: "설계자",
             title: "설계자",
             id: 865910,
             posterPath: "/9nDQd9YonVDmIrU39FWfyeqTfPY.jpg"
        ),
        (
            originalTitle: "古董局中局",
            title: "4인의 설계자: 불상의 비밀",
            id: 820099,
            posterPath: "/xos9OAANweo7VXfycIlEyuYOplz.jpg"
        ),
        (
            originalTitle: "설계자",
            title: "The Designer", 
            id: 749071,
            posterPath: nil
        ),
        (
            originalTitle: "Mulholland Drive",
            title: "멀홀랜드 드라이브",
            id: 1018,
            posterPath: "/gRS4yRRuhQmg2kBZPPIpzUpljwc.jpg"
        ),
        (
            originalTitle: "Drive",
            title: "드라이브",
            id: 64690,
            posterPath: "/ukDRwCEnVwBVSJ13xpzSzegIi1u.jpg"
        )
    ]
    
    var db = Firestore.firestore()
    let storage = Storage.storage()

    var userInfoCollection: CollectionReference!

    // MARK: - Outlets
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var setUpButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var beforeListView: UIView!
    @IBOutlet weak var ottListView: UIView!
    
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var beforeListButton: UIButton!
    @IBOutlet weak var ottListButton: UIButton!
    
    // MARK: - CollectionViews
    private var beforeListCollectionView: UICollectionView!
    private var ottListCollectionView: UICollectionView!
    
    var logineedEmail: String = ""
    var userInfoDocID: String = ""
    var uerName: String = ""
    var newUserName: String = ""
    var imageURL: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            logineedEmail = user.email!
            print("firebase User Email: \(logineedEmail)")
        }
        
        let query = self.db.collection("UserInfo").whereField("email", isEqualTo: logineedEmail)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let profileName = data["profile_name"] as? String {
                        self.uerName = profileName
                    } else {
                        guard let email = data["email"] as? String else {
                            print("Invalid email format")
                            continue
                        }
                        
                        let parts = email.components(separatedBy: "@")
                        if let firstPart = parts.first {
                            self.uerName = firstPart
                        } else {
                            print("Invalid email format")
                        }
                    }
                                    
                    if let profileImageURL = data["profile_image"] as? String {
                        if let url = URL(string: profileImageURL) {
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                if let imageData = data {
                                    DispatchQueue.main.async {
                                        self.profileImage.image = UIImage(data: imageData)
                                    }
                                }
                            }.resume()
                        }
                    } else {
                        self.profileImage.image = UIImage(named: "basicImage")
                    }

                    self.userNameLabel.text = self.uerName
                }
            }
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true

        setupBeforeListCollectionView()
        setupOttListCollectionView()
        
        wishListButton.addTarget(self, action: #selector(wishListButtonTapped), for: .touchUpInside)
        beforeListButton.addTarget(self, action: #selector(beforeListButtonTapped), for: .touchUpInside)
        ottListButton.addTarget(self, action: #selector(ottListButtonTapped), for: .touchUpInside)
    }

    // MARK: - CollectionView Setup
    private func setupBeforeListCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 200, height: 140)

        beforeListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        beforeListCollectionView.backgroundColor = .clear
        beforeListCollectionView.dataSource = self
        beforeListCollectionView.delegate = self
        beforeListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        beforeListCollectionView.register(BeforeListCellController.self, forCellWithReuseIdentifier: "beforeListCell")
        beforeListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        beforeListView.addSubview(beforeListCollectionView)

        NSLayoutConstraint.activate([
            beforeListCollectionView.topAnchor.constraint(equalTo: beforeListView.topAnchor),
            beforeListCollectionView.leadingAnchor.constraint(equalTo: beforeListView.leadingAnchor),
            beforeListCollectionView.trailingAnchor.constraint(equalTo: beforeListView.trailingAnchor),
            beforeListCollectionView.bottomAnchor.constraint(equalTo: beforeListView.bottomAnchor)
        ])
    }
    
    private func setupOttListCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 130, height: 160)

        ottListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ottListCollectionView.backgroundColor = .clear
        ottListCollectionView.dataSource = self
        ottListCollectionView.delegate = self
        ottListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ottListCollectionView.register(OttListCellController.self, forCellWithReuseIdentifier: "ottListCell")
        ottListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ottListView.addSubview(ottListCollectionView)

        NSLayoutConstraint.activate([
            ottListCollectionView.topAnchor.constraint(equalTo: ottListView.topAnchor),
            ottListCollectionView.leadingAnchor.constraint(equalTo: ottListView.leadingAnchor),
            ottListCollectionView.trailingAnchor.constraint(equalTo: ottListView.trailingAnchor),
            ottListCollectionView.bottomAnchor.constraint(equalTo: ottListView.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == beforeListCollectionView {
            return 10
        } else if collectionView == ottListCollectionView {
            return ottPurchaseListArray.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == beforeListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beforeListCell", for: indexPath) as? BeforeListCellController else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
            
            return cell
        } else if collectionView == ottListCollectionView {
            guard indexPath.item < ottPurchaseListArray.count else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ottListCell", for: indexPath) as? OttListCellController else {
                return UICollectionViewCell()
            }
            
            let ottItem = ottPurchaseListArray[indexPath.item]
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(ottItem.posterPath ?? "")"
            cell.configure(with: imageUrl)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // MARK: - Button Actions
    @objc func wishListButtonTapped() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "WishListView") as? WishListViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
    
    @objc func beforeListButtonTapped() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "BeforeTicketListView") as? BeforeTicketListViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
    
    @objc func ottListButtonTapped() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "OTTListView") as? OTTListViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.ottPurchaseListArray = ottPurchaseListArray
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
    
    @IBAction func navigateToSetUpPage() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "SetUpView") as? SetUpViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}
