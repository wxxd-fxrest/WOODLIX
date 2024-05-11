//
//  TiketListViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/1/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TiketListViewController: UIViewController {
    // MARK: - Properties
    let db = Firestore.firestore()
    var firestore: Firestore!
    
    @IBOutlet weak var tiketHeaderView: UIView!
    @IBOutlet weak var tiketBottomView: UIView!
    @IBOutlet weak var tiketMiddleLeftView: UIView!
    @IBOutlet weak var tiketMiddleRightView: UIView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var cinemaLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    
    @IBOutlet weak var cancleView: UIView!
    @IBOutlet weak var cancleButton: UIButton!
    
    var date: String = ""
    var time: String = ""
    var price: String = ""
    var seat: String = ""
    var cinemaa: String = ""
    var name: String = ""
    
    var logineedEmail: String = ""
    var userInfoDocID: String = ""
    var ticketingDocID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancleView.isHidden = true
        
        if let user = Auth.auth().currentUser {
            self.logineedEmail = user.email!
            print("firebase User Email: \(self.logineedEmail)")
        }
        
        let query = self.db.collection("UserInfo").whereField("email", isEqualTo: self.logineedEmail)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                guard let querySnapshot = querySnapshot else {
                    print("No documents found for the given email")
                    return
                }
                
                guard !querySnapshot.isEmpty else {
                    print("No documents found for the given email")
                    return
                }
                
                for document in querySnapshot.documents {
                    self.userInfoDocID = document.documentID
                    
                    let ticketingQuery = self.db.collection("UserInfo").document(self.userInfoDocID).collection("Ticketing").whereField("status", isEqualTo: false)
                    
                    ticketingQuery.getDocuments { (ticketingSnapshot, ticketingError) in
                        if let ticketingError = ticketingError {
                            print("Error fetching ticketing documents: \(ticketingError)")
                            return
                        }
                        
                        guard let ticketingSnapshot = ticketingSnapshot else {
                            print("Ticketing snapshot is nil.")
                            return
                        }
                
                        for document in ticketingSnapshot.documents {
                            self.ticketingDocID = document.documentID
                            let ticketingData = document.data()
                            
                            self.cancleView.isHidden = false
                            
                            print("Ticketing data: \(ticketingData)")
                            
                            let movieName = ticketingData["movie_name"] as? String
                            self.movieNameLabel.text = movieName
                            
                            if let seatStringArray = ticketingData["seat"] as? [String] {
                                self.seatLabel.text = seatStringArray.joined(separator: ", ")
                                if let firstSeat = seatStringArray.first {
                                    print("First seat: \(firstSeat)")
                                }
                            } else {
                                print("Seat information not found.")
                            }

                            let ticketType = ticketingData["cinema"] as? String
                                self.cinemaLabel.text = ticketType
                            
                            let ticketDate = ticketingData["date"] as? String
                                self.dateLabel.text = ticketDate
                            
                            let ticketTime = ticketingData["time"] as? String
                                self.timeLabel.text = ticketTime
                            
                            let ticketPrice = ticketingData["price"] as? String
                            self.priceLabel.text = "\(ticketPrice ?? "0") 원"
                            
                            let status = ticketingData["status"] as? Bool
                                print("Status: \(status)")
                            
                            if let movieImageURL = ticketingData["movie_image"] as? String {
                                let fullURLString = "https://image.tmdb.org/t/p/w342/\(movieImageURL)"
                                
                                if let movieImageURL = ticketingData["movie_image"] as? String {
                                    let fullURLString = "https://image.tmdb.org/t/p/w342/\(movieImageURL)"
                                    
                                    if let url = URL(string: fullURLString) {
                                        URLSession.shared.dataTask(with: url) { data, response, error in
                                            if let imageData = data {
                                                DispatchQueue.main.async {
                                                    self.movieImageView.image = UIImage(data: imageData)
                                                }
                                            } else {
                                                DispatchQueue.main.async {
                                                    self.movieImageView.image = UIImage(named: "basicImage")
                                                }
                                            }
                                        }.resume()
                                    } else {
                                        DispatchQueue.main.async {
                                            self.movieImageView.image = UIImage(named: "basicImage")
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.movieImageView.image = UIImage(named: "basicImage")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        

        tiketHeaderView.layer.cornerRadius = 12
        tiketBottomView.layer.cornerRadius = 12
        
        tiketMiddleLeftView.layer.cornerRadius = tiketMiddleLeftView.bounds.width / 2
        tiketMiddleLeftView.layer.masksToBounds = true
        
        tiketMiddleRightView.layer.cornerRadius = tiketMiddleRightView.bounds.width / 2
        tiketMiddleRightView.layer.masksToBounds = true
        
        let path = UIBezierPath(roundedRect: movieImageView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 12, height: 12))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        movieImageView.layer.mask = maskLayer
    }
    
    @IBAction func cancleMovieTapped() {
          let alertController = UIAlertController(title: "예매 취소", message: "예매를 취소하시겠습니까?", preferredStyle: .alert)
          
          let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
              let docRef = self.db.collection("UserInfo").document(self.userInfoDocID).collection("Ticketing").document(self.ticketingDocID)

              docRef.delete { error in
                  if let error = error {
                      print("Error deleting document: \(error)")
                  } else {
                      print("Document successfully deleted")
                      let alert = UIAlertController(title: nil, message: "티켓 취소가 완료되었습니다.", preferredStyle: .alert)
                      self.present(alert, animated: true) {
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                              alert.dismiss(animated: true, completion: nil)
                          }
                      }

                      self.cancleView.isHidden = true
                      
                      self.movieNameLabel.text = "예매된 티켓이 없습니다."
                      self.seatLabel.text = ""
                      self.cinemaLabel.text = ""
                      self.dateLabel.text = ""
                      self.timeLabel.text = ""
                      self.priceLabel.text = ""
                      self.movieImageView.image = UIImage(named: "basicImage")
                  }
              }
          }
          alertController.addAction(yesAction)
          
          let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
          alertController.addAction(noAction)
          
          present(alertController, animated: true, completion: nil)
      }
}


extension UIImage {
    func resized(toHeight newHeight: CGFloat) -> UIImage? {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage
    }
}
