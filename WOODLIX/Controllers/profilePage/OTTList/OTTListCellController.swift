//
//  OTTListCellController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class OTTListCellController: UICollectionViewCell {
    
    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "WhiteColor")
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
        
        addSubview(imageBox)
        
        let titleBackgroundView = UIView()
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundView.backgroundColor = .clear
        addSubview(titleBackgroundView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 46)
        gradientLayer.colors = [UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 0.0).cgColor, UIColor(red: 6/255, green: 13/255, blue: 32/255, alpha: 1.0).cgColor]
        titleBackgroundView.layer.addSublayer(gradientLayer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageBox.topAnchor.constraint(equalTo: topAnchor),
            imageBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBox.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
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
