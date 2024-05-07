//
//  OttCellViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/2/24.
//

import UIKit

class OttCellViewController: UICollectionViewCell {
    
    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageBox: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        backgroundColor = .clear
        addSubview(titleLabel)
        
        addSubview(imageBox)
        
        NSLayoutConstraint.activate([
            imageBox.topAnchor.constraint(equalTo: topAnchor),
            imageBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBox.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageBox.bottomAnchor, constant: 4),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Configure
    func configure(with imageUrl: String, title: String) {
        imageBox.image = UIImage(named: "basicImage")
        titleLabel.text = title
        
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
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
                        self?.imageBox.image = image
                    }
                } else {
                    print("Failed to convert data to UIImage")
                }
            }
        }.resume() 
    }
}
