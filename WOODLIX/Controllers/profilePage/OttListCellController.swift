//
//  OttListCellController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/3/24.
//

import UIKit

class OttListCellController: UICollectionViewCell {
    
    // MARK: - Properties
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
        
        NSLayoutConstraint.activate([
            imageBox.topAnchor.constraint(equalTo: topAnchor),
            imageBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBox.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with imageUrl: String) {
        imageBox.image = UIImage(named: "basicImage")
        
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
