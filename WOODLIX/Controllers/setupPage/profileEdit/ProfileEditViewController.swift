//
//  ProfileEditViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/5/24.
//

import UIKit

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    let authLoginID = "userIdForKey"
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageViewBox: UIView!
    @IBOutlet weak var imageEditButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var nameEditField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var dataSaveButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewBox.layer.cornerRadius = imageViewBox.frame.width / 2
        imageViewBox.clipsToBounds = true
        
        nameEditField.tintColor = UIColor(named: "WhiteColor")
        nameEditField.textColor = UIColor(named: "WhiteColor")
        nameEditField.attributedPlaceholder = NSAttributedString(string: "Placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "GreyColor") ?? .grey])
        nameEditField.backgroundColor = UIColor(named: "BackColor")
        nameEditField.layer.cornerRadius = 8
        nameEditField.layer.masksToBounds = true
        nameEditField.clearButtonMode = .whileEditing
        
        underlineView.backgroundColor = UIColor(named: "GreyColor")
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        dataSaveButton.addTarget(self, action: #selector(dataSaveButtonTapped), for: .touchUpInside)
        imageEditButton.addTarget(self, action: #selector(imageEditButtonTapped), for: .touchUpInside)

        if let savedName = UserDefaults.standard.string(forKey: authLoginID) {
            nameEditField.placeholder = savedName
        }
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func dataSaveButtonTapped() {
        showAlert()
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
    
    // MARK: - Alert
    func showAlert() {
        let alertController = UIAlertController(title: "저장 완료", message: "데이터가 성공적으로 저장되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
