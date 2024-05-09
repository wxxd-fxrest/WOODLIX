//
//  ViewController.swift
//  WOOFLIX
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    // MARK: - Properties
    let scale: CGFloat = 1.2
    
    // MARK: - Outlets
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var tiketTabView: UIView!
    @IBOutlet weak var mainTabView: UIView!
    @IBOutlet weak var profileTabView: UIView!
    
    @IBOutlet weak var tiketIcon: UIImageView!
    @IBOutlet weak var mainIcon: UIImageView!
    @IBOutlet weak var profileIcon: UIImageView!
    
    var logineedEmail: String = ""
    
    let db = Firestore.firestore()
    
    var userInfoCollection: CollectionReference!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfoCollection = db.collection("UserInfo")
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                if let user = Auth.auth().currentUser {
                    let uid = user.uid
                    let logineedEmail = user.email!
                    print("firebase User ID: \(uid)")
                    print("firebase User Email: \(logineedEmail)")

                    let query = self.userInfoCollection.whereField("email", isEqualTo: logineedEmail)

                    query.getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error fetching documents: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                let documentID = document.documentID
                                let data = document.data()
//                                print("Document ID: \(documentID)")
//                                print("Data: \(data)")
                                
                                if let profileOrNot = data["profile_or_not"] as? Bool {
                                    print("Profile or Not: \(profileOrNot)")
                                    
                                    if profileOrNot == false {
                                        let completionAlert = UIAlertController(title: "반갑습니다.", message: "나만의 프로필을 꾸며보세요!", preferredStyle: .alert)
                                        
                                        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                                            let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "ProfileEditView") as? ProfileEditViewController else {
                                                print("Failed to instantiate ProfileEditViewController from Main storyboard.")
                                                return
                                            }
                                            
                                            targetVC.modalPresentationStyle = .fullScreen
                                            self.present(targetVC, animated: true, completion: nil)
                                        }
                                        
                                        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                                        
                                        completionAlert.addAction(yesAction)
                                        completionAlert.addAction(noAction)
                                        
                                        self.present(completionAlert, animated: true, completion: nil)
                                        
                                        let documentRef = self.userInfoCollection.document(documentID)

                                        documentRef.updateData(["profile_or_not": true]) { error in
                                            if let error = error {
                                                print("Error updating document: \(error)")
                                            } else {
                                                print("Document successfully updated")
                                            }
                                        }
                                    }
                                } else {
                                    print("Profile or Not field is missing or not a boolean value")
                                }
                            }
                        }
                    }
                } else {
                    print("firebase 로그인 정보 없음")
                }
            } else {
                print("firebase 로그 아웃")
            }
        }
        
        tabBarUIdesign()
        resetIconOpacity()
        
        DispatchQueue.main.async {
            self.startPage()
        }
    }
    
    // MARK: - UI Design
    func tabBarUIdesign() {
        let cornerRadius: CGFloat = 24.0
        tabBarView.layer.cornerRadius = cornerRadius
        tabBarView.clipsToBounds = true
        tabBarView.backgroundColor = UIColor(named: "TabColor")?.withAlphaComponent(0.9)
    }
    
    // MARK: - Navigation
    func startPage() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        guard let storyboard = storyboard,
              let viewController = storyboard.instantiateViewController(identifier: "MainView") as? MainViewController else {
            return
        }
        
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.frame = contentView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
        
        animateIcon(mainIcon)
    }


    // MARK: - Animation
    func animateIcon(_ icon: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            icon.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            icon.alpha = 1.0
        }
    }
    
    // MARK: - Tab Button Actions
    @IBAction func onClickTabButton(_ sender: UIButton) {
        let tag = sender.tag
        print(tag)
        
        resetIconScaleAndOpacity()

        if tag == 0 {
            contentView.subviews.forEach { $0.removeFromSuperview() }
            
            guard let storyboard = storyboard,
                  let viewController = storyboard.instantiateViewController(identifier: "TiketList") as? TiketListViewController else {
                return
            }
            
            addChild(viewController)
            contentView.addSubview(viewController.view)
            viewController.view.frame = contentView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewController.didMove(toParent: self)
            
            animateIcon(tiketIcon)
        } else if tag == 1 {
            startPage()
        } else if tag == 2 {
            contentView.subviews.forEach { $0.removeFromSuperview() }
            
            guard let storyboard = storyboard,
                  let viewController = storyboard.instantiateViewController(identifier: "ProfileView") as? ProfileViewController else {
                return
            }
            
            addChild(viewController)
            contentView.addSubview(viewController.view)
            viewController.view.frame = contentView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewController.didMove(toParent: self)
            
            animateIcon(profileIcon)
        }
    }
    
    // MARK: - Reset
    func resetIconScaleAndOpacity() {
        [tiketIcon, mainIcon, profileIcon].forEach { icon in
            UIView.animate(withDuration: 0.3) {
                icon.transform = .identity
            }
        }
        resetIconOpacity()
    }
    
    func resetIconOpacity() {
        [tiketIcon, mainIcon, profileIcon].forEach { icon in
            icon.alpha = 0.8
        }
    }
}
