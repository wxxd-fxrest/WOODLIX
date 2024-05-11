//
//  TicketDateCellController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/4/24.
//

import UIKit

class TicketDateCellController: UICollectionViewCell {
    // MARK: - Properties
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "DarkGreyColor")
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "WhiteColor")
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        layer.cornerRadius = 26
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "TabColor")?.cgColor
    }
    
    // MARK: - Setup
    private func setupCell() {
        circleView.backgroundColor = UIColor(named: "TabColor")
        circleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circleView)
        
        addSubview(monthLabel)
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            monthLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        addSubview(dayLabel)
        NSLayoutConstraint.activate([
            // Month label constraints
            dayLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 24),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            dayLabel.heightAnchor.constraint(equalToConstant: 20),
            
            circleView.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            circleView.widthAnchor.constraint(equalTo: dayLabel.widthAnchor),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor, constant: 2),
        ])
        
        circleView.layer.cornerRadius = 22

        sendSubviewToBack(circleView)
    }
}
