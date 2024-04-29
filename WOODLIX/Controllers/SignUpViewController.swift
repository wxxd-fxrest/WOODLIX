//
//  SignUpViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/25/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

struct UserInfoData: Codable {
    let id: Int
    let password: String
}

class SignUpViewController: UIViewController, UITextFieldDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [UserInfo]() // user
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputIDCheckButton: UIButton!
    @IBOutlet weak var inputPWView: UIView!
    @IBOutlet weak var inputPWCheckView: UIView!
    
    @IBOutlet weak var inputIDLabel: UILabel!
    @IBOutlet weak var inputPWLabel: UILabel!
    @IBOutlet weak var inputPWCheckLabel: UILabel!
    
    @IBOutlet weak var inputID: UITextField!
    @IBOutlet weak var inputPW: UITextField!
    @IBOutlet weak var inputPWCheck: UITextField!
    
    @IBOutlet weak var alertLabel: UILabel!
        
    @IBOutlet weak var showPasswordButton: UIImageView!
    @IBOutlet weak var showPasswordCheckButton: UIImageView!

    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRadius(for: inputIDView)
        setCornerRadius(for: inputPWView)
        setCornerRadius(for: inputIDCheckButton)
        setCornerRadius(for: inputPWCheckView)
        setCornerRadius(for: signUpButton)
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "RedColor")
        
        inputID.delegate = self
        inputPW.delegate = self
        inputPWCheck.delegate = self
        
        inputID.textColor = UIColor(named: "WhiteColor")
        inputPW.textColor = UIColor(named: "WhiteColor")
        inputPWCheck.textColor = UIColor(named: "WhiteColor")
        
        inputID.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        inputPW.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        inputPWCheck.attributedPlaceholder = NSAttributedString(string: "Check Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])

        inputID.clearButtonMode = .always
        inputID.tintColor = UIColor(named: "YellowColor")
        
        inputPW.clearButtonMode = .always
        inputPW.tintColor = UIColor(named: "YellowColor")
        inputPW.isSecureTextEntry = true
        
        inputPWCheck.clearButtonMode = .always
        inputPWCheck.tintColor = UIColor(named: "YellowColor")
        inputPWCheck.isSecureTextEntry = true
        
        inputPW.textContentType = .newPassword
        inputPWCheck.textContentType = .newPassword

        inputID.returnKeyType = .next
        inputPW.returnKeyType = .next
        inputPWCheck.returnKeyType = .done

        inputID.keyboardType = UIKeyboardType.emailAddress
        inputPW.keyboardType = UIKeyboardType.asciiCapable
        inputPWCheck.keyboardType = UIKeyboardType.asciiCapable

        showPasswordButton.isHidden = true
        showPasswordCheckButton.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        showPasswordButton.isUserInteractionEnabled = true
        showPasswordButton.addGestureRecognizer(tapGesture)
        
        let tapCheckGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordVisibility))
        showPasswordCheckButton.isUserInteractionEnabled = true
        showPasswordCheckButton.addGestureRecognizer(tapCheckGesture)

        inputPW.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        inputPWCheck.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

    }
    
    func setCornerRadius(for view: UIView) {
        let cornerRadius: CGFloat = 6
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
         if textField == inputPW {
             let isTextEmpty = textField.text?.isEmpty ?? true
             UIView.transition(with: showPasswordButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                 self.showPasswordButton.isHidden = isTextEmpty
             }, completion: nil)
         } else {
             if textField == inputPWCheck {
                 let isTextEmpty = textField.text?.isEmpty ?? true
                 UIView.transition(with: showPasswordCheckButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                     self.showPasswordCheckButton.isHidden = isTextEmpty
                 }, completion: nil)
             }
         }
     }

    @objc func togglePasswordVisibility() {
        inputPW.isSecureTextEntry.toggle()
        let imageName = inputPW.isSecureTextEntry ? "eye.slash" : "eye"
            self.showPasswordButton.image = UIImage(systemName: imageName)
    }
    
    @IBAction func navigateToMainPage() {
        createUserInfo()
        
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "TabBarView") as? TabBarViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
    
//    func getAllUserInfo() {
//        do {
//            models = try context.fetch(UserInfo.fetchRequest())
////            DispatchQueue.main.async {
////                self.tableView.reloadData()
////            }
//        }
//        catch {
//            // error
//        }
//    }
    
    func createUserInfo() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate not found")
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        guard let id = inputID.text, !id.isEmpty else {
            print("ID is empty")
            return
        }

        guard let password = inputPW.text, !password.isEmpty else {
            print("Password is empty")
            return
        }

        let newUser = UserInfo(context: context)
        newUser.id = id
        newUser.password = password
        
        do {
            try context.save()
            Auth.auth().createUser(withEmail: id, password: password) {result,error in
                if let error = error {
                    print(error)
                }
                
                if let result = result {
                    print(result)
                }
            }
            print("User info saved successfully")
            print("---- User Data ----")
            print("ID: \(newUser.id ?? "")")
            print("Password: \(newUser.password ?? "")")
            print("----")
        } catch {
            print("Error saving user info: \(error)")
            // Handle error
        }
    }

    
//    func deleteUserInfo(item: UserInfo) {
//        context.delete(item)
//        
//        do {
//            try context.save()
////            getAllUserInfo()
//        }
//        catch {
//            // error
//        }
//    }
}
