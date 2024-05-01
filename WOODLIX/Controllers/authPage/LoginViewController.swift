//
//  LoginViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/25/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    let redColor = UIColor(named: "RedColor")
    let authLoginID = "userIdForKey"
    var autoLoginEnabled = false
    
    // MARK: - Outlets
    @IBOutlet weak var inputID: UITextField!
    @IBOutlet weak var inputPW: UITextField!
    
    @IBOutlet weak var inputIDLabel: UILabel!
    @IBOutlet weak var inputPWLabel: UILabel!
    
    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputPWView: UIView!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var autoCheckView: UIView!
    @IBOutlet weak var autoCheckImageView: UIImageView!
    
    @IBOutlet weak var showPasswordButton: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserDefaults.standard.removeObject(forKey: authLoginID)

        if let lastLoggedInUser = UserDefaults.standard.string(forKey: authLoginID) {
            print("UserDefaults-user: \(lastLoggedInUser)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.navigateToMainPage()
            }
        } else {
            setupUI()
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertLabel.isHidden = true
        inputIDLabel.textColor = .white
        inputPWLabel.textColor = .white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == inputID {
            inputPW.becomeFirstResponder()
        } else if textField == inputPW {
            onClickLogin(self)
        }
        return true
    }
    
    // MARK: - UI Setup
    func setupUI() {
        setCornerRadius(for: inputIDView)
        setCornerRadius(for: inputPWView)
        setCornerRadius(for: loginButton)
        
        inputID.delegate = self
        inputPW.delegate = self
        
        inputID.textColor = UIColor(named: "WhiteColor")
        inputPW.textColor = UIColor(named: "WhiteColor")
        
        inputID.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        inputPW.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        
        inputID.clearButtonMode = .always
        inputID.tintColor = UIColor(named: "YellowColor")
        
        inputPW.clearButtonMode = .always
        inputPW.tintColor = UIColor(named: "YellowColor")
        
        inputPW.isSecureTextEntry = true
        inputID.returnKeyType = .next
        inputPW.returnKeyType = .done
        
        inputID.keyboardType = UIKeyboardType.emailAddress
        inputPW.keyboardType = UIKeyboardType.asciiCapable
        
        alertLabel.isHidden = true
        showPasswordButton.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePassword))
        
        showPasswordButton.isUserInteractionEnabled = true
        
        showPasswordButton.addGestureRecognizer(tapGesture)
        let tapCheckGesture = UITapGestureRecognizer(target: self, action: #selector(autoLoginCheckTapped))
        
        autoCheckView.addGestureRecognizer(tapCheckGesture)
        
        inputPW.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - UITextField Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == inputPW {
            let isTextEmpty = textField.text?.isEmpty ?? true
            UIView.transition(with: showPasswordButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.showPasswordButton.isHidden = isTextEmpty
            }, completion: nil)
        }
    }
    
    // MARK: - Button Actions
    @objc func togglePassword() {
        inputPW.isSecureTextEntry.toggle()
        let imageName = inputPW.isSecureTextEntry ? "eye.slash" : "eye"
            self.showPasswordButton.image = UIImage(systemName: imageName)
    }
    
    @objc func autoLoginCheckTapped() {
        UIView.transition(with: autoCheckImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            if self.autoCheckImageView.image == UIImage(systemName: "checkmark.circle.fill") {
                self.autoCheckImageView.image = UIImage(systemName: "circle")
                self.autoCheckImageView.tintColor = UIColor(named: "DarkGreyColor")
                self.autoLoginEnabled = false
            } else {
                self.autoCheckImageView.image = UIImage(systemName: "checkmark.circle.fill")
                self.autoCheckImageView.tintColor = UIColor(named: "RedColor")
                self.autoLoginEnabled = true
            }
        }, completion: nil)
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        guard let id = inputID.text, !id.isEmpty else {
            print("User ID is empty")
            inputIDLabel.textColor = redColor
            shakeTextField(inputID)
            return
        }
        
        guard let password = inputPW.text, !password.isEmpty else {
            print("User password is empty")
            inputPWLabel.textColor = redColor
            shakeTextField(inputPW)
            return
        }
        
        Auth.auth().signIn(withEmail: id, password: password) {authResult, error in
            if authResult != nil {
                print("로그인 성공")
                if self.autoLoginEnabled == true {
                    UserDefaults.standard.set(id, forKey: self.authLoginID)
                    print("auto Login \(self.authLoginID)")
                }
                self.navigateToMainPage()
            } else {
                print("로그인 실패")
                print("Login failed: Invalid user ID or password")
                self.inputPW.resignFirstResponder()
                self.shakeTextField(self.inputID)
                self.shakeTextField(self.inputPW)
                self.inputIDLabel.textColor = self.redColor
                self.inputPWLabel.textColor = self.redColor
                self.inputID.becomeFirstResponder()
                self.inputPW.text = ""
                self.showPasswordButton.isHidden = true
                self.alertLabel.isHidden = false
            }
        }
    }
    
    // MARK: - Helper Methods
    func setCornerRadius(for view: UIView) {
        let cornerRadius: CGFloat = 6
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    func shakeTextField(_ textField: UITextField) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 5
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 5, y: textField.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 5, y: textField.center.y))
        textField.layer.add(shake, forKey: "position")
    }
    
    func navigateToMainPage() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        targetVC.modalPresentationStyle = .fullScreen
        self.present(targetVC, animated: true, completion: nil)
    }
}
