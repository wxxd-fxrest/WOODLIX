//
//  DetailCellViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/4/24.
//

import UIKit

class DetailCellController: UICollectionViewCell {
    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 4
    }
    
    // MARK: - Setup
    private func setupCell() {
        backgroundColor = .red // 뷰 배경을 투명으로 설정하여 동그란 모양의 UIView를 보이게 합니다.

        // 동그란 모양의 UIView 생성 및 설정
        let circleView = UIView()
        circleView.backgroundColor = .gray // 색상은 원하는 색상으로 변경하세요.
        circleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleView)
        
        // titleLabel 추가
        addSubview(titleLabel)
        
        // 동그란 모양의 UIView 제약조건 설정
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor), // 동그란 모양을 만들기 위해 높이와 너비를 같게 설정합니다.
            
            // titleLabel 제약조건 설정
            titleLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
        
        // 동그란 모양의 UIView를 titleLabel 위에 추가합니다.
        bringSubviewToFront(circleView)
    }
}
