//
//  SearchWordCellController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

protocol SearchWordCellDelegate: AnyObject {
    func deleteButtonTapped(at indexPath: IndexPath)
}

class SearchWordCellController: UICollectionViewCell {
    weak var delegate: SearchWordCellDelegate?
    var indexPath: IndexPath?

    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(named: "WhiteColor")!
        ]
        let attributedTitle = NSAttributedString(string: "X", attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.backgroundColor = UIColor(named: "DarkGreyColor")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "DarkGreyColor")?.cgColor 
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        return button
    }()

    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
    }
    
    // MARK: - Setup
    private func setupCell() {
        backgroundColor = .red
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
        
        addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Gesture Recognizer
    @objc func deleteButtonTapped(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        delegate?.deleteButtonTapped(at: indexPath)
    }
}
