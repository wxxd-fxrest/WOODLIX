//
//  MarkViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class WishListViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var wishListView: UIView!
    private var wishListCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWishListCollectionView()
        wishListCollectionView.showsVerticalScrollIndicator = false
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupWishListCollectionView() {
        let screenWidth = wishListView.bounds.width
        
        let cellWidth = (screenWidth - 4 * 4) / 3
        let cellHeight: CGFloat = 140
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        wishListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        wishListCollectionView.backgroundColor = .clear
        wishListCollectionView.dataSource = self
        wishListCollectionView.delegate = self
        wishListCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        wishListCollectionView.register(WishListCellController.self, forCellWithReuseIdentifier: "wishListCell")
        wishListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        wishListView.addSubview(wishListCollectionView)

        NSLayoutConstraint.activate([
            wishListCollectionView.topAnchor.constraint(equalTo: wishListView.topAnchor),
            wishListCollectionView.leadingAnchor.constraint(equalTo: wishListView.leadingAnchor),
            wishListCollectionView.trailingAnchor.constraint(equalTo: wishListView.trailingAnchor),
            wishListCollectionView.bottomAnchor.constraint(equalTo: wishListView.bottomAnchor)
        ])
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension WishListViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == wishListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishListCell", for: indexPath) as? WishListCellController else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
