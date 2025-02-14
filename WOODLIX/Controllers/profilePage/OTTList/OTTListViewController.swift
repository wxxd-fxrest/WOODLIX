//
//  OTTListViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class OTTListViewController: UIViewController, UICollectionViewDelegate {
    
    var ottPurchaseListArray: [(
        originalTitle: String,
        title: String,
        id: Int,
        posterPath: String?
    )] = []
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ottListView: UIView!
    private var ottListCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ProfileViewController -> OTTListViewController: \(ottPurchaseListArray)")
        
        setupOTTListCollectionView()
        ottListCollectionView.showsVerticalScrollIndicator = false
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupOTTListCollectionView() {
        let screenWidth = ottListView.bounds.width
        
        let cellWidth = screenWidth
        let cellHeight: CGFloat = 200
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        ottListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ottListCollectionView.backgroundColor = .clear
        ottListCollectionView.dataSource = self
        ottListCollectionView.delegate = self
        ottListCollectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        ottListCollectionView.register(OTTListCellController.self, forCellWithReuseIdentifier: "OTTListCell")
        ottListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ottListView.addSubview(ottListCollectionView)

        NSLayoutConstraint.activate([
            ottListCollectionView.topAnchor.constraint(equalTo: ottListView.topAnchor),
            ottListCollectionView.leadingAnchor.constraint(equalTo: ottListView.leadingAnchor),
            ottListCollectionView.trailingAnchor.constraint(equalTo: ottListView.trailingAnchor),
            ottListCollectionView.bottomAnchor.constraint(equalTo: ottListView.bottomAnchor)
        ])
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension OTTListViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ottPurchaseListArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ottListCollectionView {
            guard indexPath.item < ottPurchaseListArray.count else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OTTListCell", for: indexPath) as? OTTListCellController else {
                return UICollectionViewCell()
            }
            
            let commingSoonMovie = ottPurchaseListArray[indexPath.item]
            
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(commingSoonMovie.posterPath ?? "")"
            let title = commingSoonMovie.originalTitle ?? ""
            
            cell.configure(with: imageUrl, title: title)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}
