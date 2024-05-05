//
//  ProfileViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var setUpButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var beforeListView: UIView!
    @IBOutlet weak var ottListView: UIView!
    
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var beforeListButton: UIButton!
    @IBOutlet weak var ottListButton: UIButton!
    
    // MARK: - CollectionViews
    private var beforeListCollectionView: UICollectionView!
    private var ottListCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 10
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ottListCell", for: indexPath) as? OttListCellController else {
                return UICollectionViewCell()
            }
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
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
