//
//  ProfileEditViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    let authLoginID = "userIdForKey"
    
    var db = Firestore.firestore()
    let storage = Storage.storage()
    
    var userInfoCollection: CollectionReference!

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageViewBox: UIView!
    @IBOutlet weak var imageEditButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var nameEditField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var dataSaveButton: UIButton!

    var logineedEmail: String = ""
    var userInfoDocID: String = ""
    var uerName: String = ""
    var newUserName: String = ""
    var imageURL: String?
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Auth.auth().currentUser {
            logineedEmail = user.email!
            print("firebase User Email: \(logineedEmail)")
        }
        
        let query = self.db.collection("UserInfo").whereField("email", isEqualTo: logineedEmail)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let profileName = data["profile_name"] as? String {
                        self.uerName = profileName
                    } else {
                        guard let email = data["email"] as? String else {
                            print("Invalid email format")
                            continue
                        }
                        
                        let parts = email.components(separatedBy: "@")
                        if let firstPart = parts.first {
                            self.uerName = firstPart
                        } else {
                            print("Invalid email format")
                        }
                    }
                                    
                    if let profileImageURL = data["profile_image"] as? String {
                        if let url = URL(string: profileImageURL) {
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                if let imageData = data {
                                    DispatchQueue.main.async {
                                        self.previewImage.image = UIImage(data: imageData)
                                    }
                                }
                            }.resume()
                        }
                    } else {
                        self.previewImage.image = UIImage(named: "basicImage")
                    }

                    self.nameEditField.placeholder = self.uerName
                }
            }
        }
        
        imageViewBox.layer.cornerRadius = imageViewBox.frame.width / 2
        imageViewBox.clipsToBounds = true

        nameEditField.tintColor = UIColor(named: "WhiteColor")
        nameEditField.textColor = UIColor(named: "WhiteColor")
        nameEditField.attributedPlaceholder = NSAttributedString(string: "Placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "GreyColor") ?? .gray])
        nameEditField.backgroundColor = UIColor(named: "BackColor")
        nameEditField.layer.cornerRadius = 8
        nameEditField.layer.masksToBounds = true
        nameEditField.clearButtonMode = .whileEditing

        underlineView.backgroundColor = UIColor(named: "GreyColor")

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        dataSaveButton.addTarget(self, action: #selector(dataSaveButtonTapped), for: .touchUpInside)
        imageEditButton.addTarget(self, action: #selector(imageEditButtonTapped), for: .touchUpInside)
    }

    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func dataSaveButtonTapped() {
        newUserName = nameEditField.text ?? ""
        if let imageURL = imageURL {
            uploadImageToStorage()
        } else if newUserName != "" {
            let userRef = db.collection("UserInfo").document(userInfoDocID)
            userRef.updateData(["profile_name": newUserName]) { error in
                if let error = error {
                    print("Error updating user profile name: \(error.localizedDescription)")
                } else {
                    print("User profile name updated successfully")
                    self.showAlert()
                }
            }
        } else {
            print("No changes to save")
        }
    }


    @objc func imageEditButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Image Picker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            previewImage.contentMode = .scaleAspectFit
            previewImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Firebase Storage
    func uploadImageToStorage() {
        guard let image = previewImage.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let imageName = "\(UUID().uuidString).jpg"
        let imageRef = storage.reference().child("profile_images").child(imageName)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard let _ = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.imageURL = downloadURL.absoluteString
                self.updateUserProfile()
            }
        }
    }

    // MARK: - Firestore
    func updateUserProfile() {
        guard let imageURL = imageURL else { return }
        
        let userRef = db.collection("UserInfo").document(userInfoDocID)
        userRef.updateData(["profile_image": imageURL]) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully")
                self.showAlert()
            }
        }
    }

    // MARK: - Alert
    func showAlert() {
        let alertController = UIAlertController(title: "저장 완료", message: "데이터가 성공적으로 저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
