//
//  SignUpViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/25/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    let db = Firestore.firestore()
    var firestore: Firestore!

    let redColor = UIColor(named: "RedColor")
    
    // MARK: - Outlets
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    @IBOutlet weak var inputID: UITextField!
    @IBOutlet weak var inputPW: UITextField!
    @IBOutlet weak var inputPWCheck: UITextField!
    
    @IBOutlet weak var inputIDLabel: UILabel!
    @IBOutlet weak var inputPWLabel: UILabel!
    @IBOutlet weak var inputPWCheckLabel: UILabel!
    
    @IBOutlet weak var inputIDView: UIView!
    @IBOutlet weak var inputPWView: UIView!
    @IBOutlet weak var inputPWCheckView: UIView!

    @IBOutlet weak var showPasswordButton: UIImageView!
    @IBOutlet weak var showPasswordCheckButton: UIImageView!
    
    @IBOutlet weak var inputIDCheckButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Variables
    var IDCheck: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(named: "RedColor")
        
        setCornerRadius(for: inputIDView)
        setCornerRadius(for: inputPWView)
        setCornerRadius(for: inputIDCheckButton)
        setCornerRadius(for: inputPWCheckView)
        setCornerRadius(for: signUpButton)
        
        setupTextFields()
        setupPasswordVisibility()
        setupPasswordAddTarget()
    }
    
    // MARK: - Helper Methods
    func setCornerRadius(for view: UIView) {
        let cornerRadius: CGFloat = 6
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    func setupTextFields() {
        inputID.delegate = self
        inputPW.delegate = self
        inputPWCheck.delegate = self
        
        inputID.textColor = UIColor(named: "WhiteColor")
        inputPW.textColor = UIColor(named: "WhiteColor")
        inputPWCheck.textColor = UIColor(named: "WhiteColor")
        
        // Placeholder text color
        inputID.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        inputPW.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        inputPWCheck.attributedPlaceholder = NSAttributedString(string: "Check Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "GreyColor") ?? .white])
        
        // Clear button and cursor color
        inputID.clearButtonMode = .always
        inputID.tintColor = UIColor(named: "YellowColor")
        
        inputPW.clearButtonMode = .always
        inputPW.tintColor = UIColor(named: "YellowColor")
        inputPW.isSecureTextEntry = true
        
        inputPWCheck.clearButtonMode = .always
        inputPWCheck.tintColor = UIColor(named: "YellowColor")
        inputPWCheck.isSecureTextEntry = true
        
        // Text content type and return key type
        inputPW.textContentType = .newPassword
        inputPWCheck.textContentType = .newPassword
        
        inputID.returnKeyType = .next
        inputPW.returnKeyType = .next
        inputPWCheck.returnKeyType = .done
        
        // Keyboard type
        inputID.keyboardType = UIKeyboardType.emailAddress
        inputPW.keyboardType = UIKeyboardType.asciiCapable
        inputPWCheck.keyboardType = UIKeyboardType.asciiCapable
    }
    
    func setupPasswordVisibility() {
        showPasswordButton.isHidden = true
        showPasswordCheckButton.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePassword))
        showPasswordButton.isUserInteractionEnabled = true
        showPasswordButton.addGestureRecognizer(tapGesture)
        
        let tapCheckGesture = UITapGestureRecognizer(target: self, action: #selector(togglePassword))
        showPasswordCheckButton.isUserInteractionEnabled = true
        showPasswordCheckButton.addGestureRecognizer(tapCheckGesture)
        
        inputPW.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        inputPWCheck.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // Password addTarget
    func setupPasswordAddTarget() {
        inputPW.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        inputPWCheck.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
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
    
    @objc func togglePassword(sender: UITapGestureRecognizer) {
        if sender == showPasswordButton.gestureRecognizers?.first {
            inputPW.isSecureTextEntry.toggle()
            let imageNamePW = inputPW.isSecureTextEntry ? "eye.slash" : "eye"
            self.showPasswordButton.image = UIImage(systemName: imageNamePW)
        } else if sender == showPasswordCheckButton.gestureRecognizers?.first {
            inputPWCheck.isSecureTextEntry.toggle()
            let imageNamePWCheck = inputPWCheck.isSecureTextEntry ? "eye.slash" : "eye"
            self.showPasswordCheckButton.image = UIImage(systemName: imageNamePWCheck)
        }
    }

    
    @IBAction func clickCheckID() {
        guard let id = inputID.text, !id.isEmpty else {
            showError(message: "이메일을 입력해 주세요.", infoLabel: inputIDLabel, textField: inputID)
            return
        }
        checkID(id: id) { isUnique in
            self.IDCheck = isUnique
            if isUnique {
                self.inputIDLabel.text = "중복확인이 완료되었습니다."
                self.inputIDLabel.textColor = UIColor(named: "WhiteColor")
            } else {
                self.showError(message: "이미 존재하는 이메일입니다.", infoLabel: self.inputIDLabel, textField: self.inputID)
            }
        }
    }

    // MARK: - Navigation
    @IBAction func navigateToMainPage() {
        if IDCheck == true {
            guard let id = inputID.text, !id.isEmpty else {
                showError(message: "이메일을 입력해 주세요.", infoLabel: inputIDLabel, textField: inputID)
                return
            }
            
            guard isValidEmail(email: id) else {
                showError(message: "이메일 형식으로 입력해 주세요.", infoLabel: inputIDLabel, textField: inputID)
                return
            }

            guard let password = inputPW.text, !password.isEmpty else {
                showError(message: "비밀번호를 입력해 주세요.", infoLabel: inputPWLabel, textField: inputPW)
                return
            }

            guard isValidPassword(password: password) else {
                showError(message: "6글자 이상, 대/소문자가 포함되어야 합니다.", infoLabel: inputPWLabel, textField: inputPW)
                return
            }
            
            guard let passwordCheck = inputPWCheck.text, !passwordCheck.isEmpty else {
                showError(message: "비밀번호를 다시 입력해 주세요.", infoLabel: inputPWCheckLabel, textField: inputPWCheck)
                return
            }
            
            guard password == passwordCheck else {
                showError(message: "비밀번호가 일치하지 않습니다.", infoLabel: inputPWCheckLabel, textField: inputPWCheck)
                return
            }

            Auth.auth().createUser(withEmail: id, password: password) { result, error in
                if let error = error {
                    print(error)
                }
                
                if let result = result {
                    print(result)
                }
            }
            
            db.collection("UserInfo").addDocument(data: ["email": id])
            
            let alert = UIAlertController(title: "회원가입", message: "회원가입이 완료되었습니다. 다시 한 번 로그인해 주세요.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true) {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "LoginView") as? LoginViewController else {
                                print("Failed to instantiate LoginViewController from Main storyboard.")
                                return
                            }
                            targetVC.modalPresentationStyle = .fullScreen
                            window.rootViewController = targetVC
                        }, completion: nil)
                    }
                }
            }
            alert.addAction(okayAction)

            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "회원가입", message: "이메일 중복확인을 진행해 주세요.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Validation Methods
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - Error Handling Methods
    func showError(message: String, infoLabel: UILabel, textField: UITextField) {
        shakeTextField(textField)
        infoLabel.textColor = redColor
        if textField == inputID {
            inputIDLabel.text = message
        } else if textField == inputPW {
            inputPWLabel.text = message
        } else if textField == inputPWCheck {
            inputPWCheckLabel.text = message
        }
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
    
    // MARK: - Firestore Methods
    func checkID(id: String, completion: @escaping (Bool) -> Void) {
        let userDB = db.collection("UserInfo")
        
        let query = userDB.whereField("email", isEqualTo: id)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                if let documents = querySnapshot?.documents, !documents.isEmpty {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
