//
//  TicketingViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class TicketingViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectModalView: UIView!
    
    @IBOutlet weak var selectDateView: UIView!
    @IBOutlet weak var selectTimeView: UIView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var ticketingButtonView: UIView!
    
    private var selectDateCollectionView: UICollectionView!
    private var selectTimeCollectionView: UICollectionView!
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        selectModalView.layer.cornerRadius = 20
        ticketingButtonView.layer.cornerRadius = 12
        
        setupSelectDateCollectionView()
        setupSelectTimeCollectionView()
        
        selectDateCollectionView.showsHorizontalScrollIndicator = false
        selectTimeCollectionView.showsHorizontalScrollIndicator = false
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupSelectDateCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 120, height: 140)
        
        selectDateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectDateCollectionView.backgroundColor = .clear
        selectDateCollectionView.dataSource = self
        selectDateCollectionView.delegate = self
        selectDateCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        selectDateCollectionView.register(TicketDateCellController.self, forCellWithReuseIdentifier: "ticketDateCell")
        selectDateCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectDateView.addSubview(selectDateCollectionView)
        
        NSLayoutConstraint.activate([
            selectDateCollectionView.topAnchor.constraint(equalTo: selectDateView.topAnchor),
            selectDateCollectionView.leadingAnchor.constraint(equalTo: selectDateView.leadingAnchor),
            selectDateCollectionView.trailingAnchor.constraint(equalTo: selectDateView.trailingAnchor),
            selectDateCollectionView.bottomAnchor.constraint(equalTo: selectDateView.bottomAnchor)
        ])
    }
    
    private func setupSelectTimeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 120, height: 50)
        
        selectTimeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectTimeCollectionView.backgroundColor = .clear
        selectTimeCollectionView.dataSource = self
        selectTimeCollectionView.delegate = self
        selectTimeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        selectTimeCollectionView.register(TicketTimeCellController.self, forCellWithReuseIdentifier: "ticketTimeCell")
        selectTimeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectTimeView.addSubview(selectTimeCollectionView)
        
        NSLayoutConstraint.activate([
            selectTimeCollectionView.topAnchor.constraint(equalTo: selectTimeView.topAnchor),
            selectTimeCollectionView.leadingAnchor.constraint(equalTo: selectTimeView.leadingAnchor),
            selectTimeCollectionView.trailingAnchor.constraint(equalTo: selectTimeView.trailingAnchor),
            selectTimeCollectionView.bottomAnchor.constraint(equalTo: selectTimeView.bottomAnchor)
        ])
    }
    

    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension TicketingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectDateCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketDateCell", for: indexPath) as? TicketDateCellController else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
            
            return cell
        } else if collectionView == selectTimeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketTimeCell", for: indexPath) as? TicketTimeCellController else {
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
