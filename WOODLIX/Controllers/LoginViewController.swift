//
//  LoginViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/25/24.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    let redColor = UIColor(named: "RedColor")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputPWView: UIView!
    
    @IBOutlet weak var inputIDLabel: UILabel!
    @IBOutlet weak var inputPWLabel: UILabel!
    
    @IBOutlet weak var inputID: UITextField!
    @IBOutlet weak var inputPW: UITextField!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var autoCheckView: UIView!
    @IBOutlet weak var autoCheckImageView: UIImageView!
    @IBOutlet weak var showPasswordButton: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    var autoLoginEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRadius(for: inputIDView)
        setCornerRadius(for: inputPWView)
        setCornerRadius(for: loginButton)

        alertLabel.isHidden = true
        
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
        
        showPasswordButton.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        showPasswordButton.isUserInteractionEnabled = true
        showPasswordButton.addGestureRecognizer(tapGesture)
   
        let tapCheckGesture = UITapGestureRecognizer(target: self, action: #selector(autoLoginCheckTapped))
        autoCheckView.addGestureRecognizer(tapCheckGesture)

        
        inputPW.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
         if textField == inputPW {
             let isTextEmpty = textField.text?.isEmpty ?? true
             UIView.transition(with: showPasswordButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                 self.showPasswordButton.isHidden = isTextEmpty
             }, completion: nil)
         }
     }
    
    @objc func togglePasswordVisibility() {
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
        guard let userId = inputID.text, !userId.isEmpty else {
            print("User ID is empty")
            inputIDLabel.textColor = redColor
            shakeTextField(inputID)
            
            return
        }
        
        guard let userPassword = inputPW.text, !userPassword.isEmpty else {
            print("User password is empty")
            inputPWLabel.textColor = redColor
            shakeTextField(inputPW)
            return
        }
        
        let fetchRequest = NSFetchRequest<UserInfo>(entityName: "UserInfo")
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND password == %@", userId, userPassword)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                print("Login successful!")
                inputPW.resignFirstResponder()
                UserDefaults.standard.set(userId, forKey: "userIdForKey")
                // 출력할 사용자 데이터를 가져와서 출력
                for user in results {
                    print("---- User Data ----")
                    print("ID: \(user.id ?? "")")
                    print("PW: \(user.password ?? "")")
             
                    print("----")
                }
                
                let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "TabBarView") as? TabBarViewController else {
                    print("Failed to instantiate MainPageViewController from UserStoryboard.")
                    return
                }
                
                targetVC.modalPresentationStyle = .fullScreen
                present(targetVC, animated: true, completion: nil)
            } else {
                print("Login failed: Invalid user ID or password")
                inputPW.resignFirstResponder()
                shakeTextField(inputID)
                shakeTextField(inputPW)

                inputIDLabel.textColor = redColor
                inputPWLabel.textColor = redColor
                inputID.becomeFirstResponder()
                inputPW.text = ""
                self.showPasswordButton.isHidden = true
                alertLabel.isHidden = false
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
}
