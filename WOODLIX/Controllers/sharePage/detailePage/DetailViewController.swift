//
//  DetailViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var shadowBoxView: UIView!
    
    @IBOutlet weak var playButtonBackgroundView: UIView!
    
    @IBOutlet weak var actorListBoxView: UIView!
    private var actorListCollectionView: UICollectionView!
    
    @IBOutlet weak var ticketingButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUIdesign()
        shadowBoxUIdesign()
        setupActorListCollectionView()
        actorListCollectionView.isScrollEnabled = false
        
        playButtonBackgroundView.layer.cornerRadius = min(playButtonBackgroundView.bounds.width, playButtonBackgroundView.bounds.height) / 2
        playButtonBackgroundView.clipsToBounds = true

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupActorListCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 120, height: 140)
        
        actorListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        actorListCollectionView.backgroundColor = .clear
        actorListCollectionView.dataSource = self
        actorListCollectionView.delegate = self
        actorListCollectionView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        actorListCollectionView.register(DetailCellController.self, forCellWithReuseIdentifier: "detailCell")
        actorListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        actorListBoxView.addSubview(actorListCollectionView)
        
        NSLayoutConstraint.activate([
            actorListCollectionView.topAnchor.constraint(equalTo: actorListBoxView.topAnchor),
            actorListCollectionView.leadingAnchor.constraint(equalTo: actorListBoxView.leadingAnchor),
            actorListCollectionView.trailingAnchor.constraint(equalTo: actorListBoxView.trailingAnchor),
            actorListCollectionView.bottomAnchor.constraint(equalTo: actorListBoxView.bottomAnchor)
        ])
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
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        shadowBoxView.layer.insertSublayer(gradientLayer, at: 0)
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
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == actorListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailCellController else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
            
            return cell
        } else {
            return UICollectionViewCell()
        }
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
