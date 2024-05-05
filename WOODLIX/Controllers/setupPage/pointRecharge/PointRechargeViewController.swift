//
//  PointRechargeViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class PointRechargeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pointViewBox: UIView!
    @IBOutlet weak var PointRechargeBarView: UIView!
    @IBOutlet weak var pointField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var rechargePointButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUIdesign()
        setupUI()
        setupGestures()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        pointViewBox.layer.cornerRadius = 12
        pointViewBox.clipsToBounds = true
        
        pointField.tintColor = UIColor(named: "WhiteColor")
        pointField.textColor = UIColor(named: "WhiteColor")
        pointField.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "GreyColor") ?? .grey])
        pointField.backgroundColor = UIColor(named: "BackColor")
        pointField.layer.cornerRadius = 8
        pointField.layer.masksToBounds = true
        
        underlineView.backgroundColor = UIColor(named: "GreyColor")
        
        pointField.clearButtonMode = .whileEditing
    }
    
    func tabBarUIdesign() {
        let cornerRadius: CGFloat = 24.0
        PointRechargeBarView.layer.cornerRadius = cornerRadius
        PointRechargeBarView.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = PointRechargeBarView.bounds
        gradientLayer.colors = [UIColor(red: 84/255, green: 148/255, blue: 216/255, alpha: 0.3).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 4.0, y: 0.3)
        
        PointRechargeBarView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Gesture Recognizer
    func setupGestures() {
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Button Actions
    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rechargePointButtonTapped() {
        guard let rechargeAmount = pointField.text, !rechargeAmount.isEmpty else {
            showNoPointAlert()
            return
        }
        
        showConfirmationAlert()
    }
    
    // MARK: - Alert Controllers
    func showConfirmationAlert() {
        let alert = UIAlertController(title: "충전 확인", message: "포인트를 충전하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "예", style: .default) { _ in
            self.showRechargeCompletionAlert()
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }

    func showRechargeCompletionAlert() {
        let completionAlert = UIAlertController(title: "충전 완료", message: "포인트가 성공적으로 충전되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        completionAlert.addAction(okAction)
        present(completionAlert, animated: true, completion: nil)
    }

    func showNoPointAlert() {
        let noPointAlert = UIAlertController(title: "충전할 포인트가 없음", message: "충전하려는 포인트 양을 입력하세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        noPointAlert.addAction(okAction)
        present(noPointAlert, animated: true, completion: nil)
    }
}
