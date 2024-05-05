//
//  BeforeTicketListViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class BeforeTicketListViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var beforeListView: UIView!
    private var beforeListCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBeforeListCollectionView()
        beforeListCollectionView.showsVerticalScrollIndicator = false
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupBeforeListCollectionView() {
        let screenWidth = beforeListView.bounds.width
        
        let cellWidth = screenWidth
        let cellHeight: CGFloat = 200
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        beforeListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        beforeListCollectionView.backgroundColor = .clear
        beforeListCollectionView.dataSource = self
        beforeListCollectionView.delegate = self
        beforeListCollectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        beforeListCollectionView.register(BeforeTicketListCellController.self, forCellWithReuseIdentifier: "beforeTicketListCell")
        beforeListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        beforeListView.addSubview(beforeListCollectionView)

        NSLayoutConstraint.activate([
            beforeListCollectionView.topAnchor.constraint(equalTo: beforeListView.topAnchor),
            beforeListCollectionView.leadingAnchor.constraint(equalTo: beforeListView.leadingAnchor),
            beforeListCollectionView.trailingAnchor.constraint(equalTo: beforeListView.trailingAnchor),
            beforeListCollectionView.bottomAnchor.constraint(equalTo: beforeListView.bottomAnchor)
        ])
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension BeforeTicketListViewController: UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == beforeListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beforeTicketListCell", for: indexPath) as? BeforeTicketListCellController else {
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
