//
//  SetUpViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class SetUpViewController: UIViewController {
    // MARK: - Properties
    let authLoginID = "userIdForKey"
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableViewBox: UIView!
    @IBOutlet weak var logOutBarView: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    
    private var setUpTableView: UITableView!
    
    let data = ["프로필 수정", "결제 관리", "포인트 충전", "Cell 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarUIdesign()
        
        setUpTableView = UITableView(frame: tableViewBox.bounds, style: .plain)
        setUpTableView.dataSource = self
        setUpTableView.delegate = self
        setUpTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setUpTableView.backgroundColor = UIColor(named: "BackColor")
        
        tableViewBox.addSubview(setUpTableView)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Design
    func tabBarUIdesign() {
        let cornerRadius: CGFloat = 24.0
        logOutBarView.layer.cornerRadius = cornerRadius
        logOutBarView.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = logOutBarView.bounds
        gradientLayer.colors = [UIColor(red: 84/255, green: 148/255, blue: 216/255, alpha: 0.3).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 4.0, y: 0.3)
        
        logOutBarView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped() {
         UserDefaults.standard.removeObject(forKey: authLoginID)
         
         let alert = UIAlertController(title: "로그아웃 완료", message: "로그아웃이 성공적으로 완료되었습니다.", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "확인", style: .default) { _ in
             self.navigateToSignUpPage()
         }
        
         alert.addAction(okAction)
         present(alert, animated: true, completion: nil)
     }
     
     func navigateToSignUpPage() {
         let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
         guard let signUpVC = targetStoryboard.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController else {
             print("Failed to instantiate SignUpViewController from Main storyboard.")
             return
         }
         
         signUpVC.modalPresentationStyle = .fullScreen
         present(signUpVC, animated: true, completion: nil)
     }
}

// MARK: - UITableViewDataSource
extension SetUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "WhiteColor")
        cell.backgroundColor = UIColor(named: "BackColor")
        
        let separator = UIView(frame: CGRect(x: 15, y: cell.frame.height - 1, width: cell.frame.width + 20, height: 0.4))
        separator.backgroundColor = UIColor(named: "DarkGreyColor")
        cell.addSubview(separator)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SetUpViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setUpTableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let signUpVC = targetStoryboard.instantiateViewController(withIdentifier: "ProfileEditView") as? ProfileEditViewController else {
                print("Failed to instantiate SignUpViewController from Main storyboard.")
                return
            }
            
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true, completion: nil)
        case 1:
            let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let signUpVC = targetStoryboard.instantiateViewController(withIdentifier: "PaymentManagementView") as? PaymentManagementViewController else {
                print("Failed to instantiate SignUpViewController from Main storyboard.")
                return
            }
            
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true, completion: nil)
        case 2:
            let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let signUpVC = targetStoryboard.instantiateViewController(withIdentifier: "PointRechargeView") as? PointRechargeViewController else {
                print("Failed to instantiate SignUpViewController from Main storyboard.")
                return
            }
            
            signUpVC.modalPresentationStyle = .fullScreen
            present(signUpVC, animated: true, completion: nil)
        default:
            break
        }
    }
}
