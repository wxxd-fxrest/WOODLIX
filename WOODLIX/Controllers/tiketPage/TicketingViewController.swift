//
//  TicketingViewController.swift
//  WOOFLIX
//
//  Created by 밀가루 on 4/24/24.
//

import UIKit

class TicketingViewController: UIViewController, UICollectionViewDelegate {
    var selectedItem: (movie: MovieDataModel, reservable: Bool, comming: Bool)?
    var selectedIndexPath: IndexPath?
    var selectedTimeIndexPath: IndexPath?

    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectModalView: UIView!
    
    @IBOutlet weak var cgvButton: UIButton!
    @IBOutlet weak var magaBoxButton: UIButton!
    @IBOutlet weak var cinemaButton: UIButton!
    
    @IBOutlet weak var selectDateView: UIView!
    @IBOutlet weak var selectTimeView: UIView!
    @IBOutlet weak var selectCGVView: UIView!
    @IBOutlet weak var selectMEGAView: UIView!
    @IBOutlet weak var selectCINEMAView: UIView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var ticketingButtonView: UIView!
    
    private var selectDateCollectionView: UICollectionView!
    private var selectTimeCollectionView: UICollectionView!
    
    var selectedSeatButtons: Set<Int> = []
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicketingViewController \(selectedItem)")
        cgvButton.backgroundColor = UIColor(named: "RedColor")?.withAlphaComponent(0.5)
        magaBoxButton.backgroundColor = UIColor(named: "RedColor")?.withAlphaComponent(0.5)
        cinemaButton.backgroundColor = UIColor(named: "RedColor")?.withAlphaComponent(0.5)
        
        selectCGVView.layer.cornerRadius = 4
        selectMEGAView.layer.cornerRadius = 4
        selectCINEMAView.layer.cornerRadius = 4
        selectModalView.layer.cornerRadius = 20
        ticketingButtonView.layer.cornerRadius = 12
        
        setupSelectDateCollectionView()
        setupSelectTimeCollectionView()
        
        selectDateCollectionView.delegate = self
        selectTimeCollectionView.delegate = self
        
        selectDateCollectionView.showsHorizontalScrollIndicator = false
        selectTimeCollectionView.showsHorizontalScrollIndicator = false
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupSelectDateCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 54, height: 96)
        
        selectDateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectDateCollectionView.backgroundColor = .clear
        selectDateCollectionView.dataSource = self
        selectDateCollectionView.delegate = self
        selectDateCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        selectDateCollectionView.register(TicketDateCellController.self, forCellWithReuseIdentifier: "ticketDateCell")
        selectDateCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectDateView.addSubview(selectDateCollectionView)
        
        NSLayoutConstraint.activate([
            selectDateCollectionView.topAnchor.constraint(equalTo: selectDateView.topAnchor),
            selectDateCollectionView.leadingAnchor.constraint(equalTo: selectDateView.leadingAnchor),
            selectDateCollectionView.trailingAnchor.constraint(equalTo: selectDateView.trailingAnchor),
            selectDateCollectionView.bottomAnchor.constraint(equalTo: selectDateView.bottomAnchor)
        ])
    }
    
    private func setupSelectTimeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 90, height: 44)
        
        selectTimeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        selectTimeCollectionView.backgroundColor = .clear
        selectTimeCollectionView.dataSource = self
        selectTimeCollectionView.delegate = self
        selectTimeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        selectTimeCollectionView.register(TicketTimeCellController.self, forCellWithReuseIdentifier: "ticketTimeCell")
        selectTimeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectTimeView.addSubview(selectTimeCollectionView)
        
        NSLayoutConstraint.activate([
            selectTimeCollectionView.topAnchor.constraint(equalTo: selectTimeView.topAnchor),
            selectTimeCollectionView.leadingAnchor.constraint(equalTo: selectTimeView.leadingAnchor),
            selectTimeCollectionView.trailingAnchor.constraint(equalTo: selectTimeView.trailingAnchor),
            selectTimeCollectionView.bottomAnchor.constraint(equalTo: selectTimeView.bottomAnchor)
        ])
    }
    

    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        for button in [cgvButton, magaBoxButton, cinemaButton] {
            if let button = button {
                button.layer.cornerRadius = 4
                button.backgroundColor = UIColor(named: "RedColor")?.withAlphaComponent(0.5)
            }
        }
        
        sender.layer.cornerRadius = 4
        sender.backgroundColor = UIColor(named: "RedColor")?.withAlphaComponent(1.0)
        
        var selectedButtonText = ""
        if sender == cgvButton {
            selectedButtonText = "CGV"
        } else if sender == magaBoxButton {
            selectedButtonText = "Maga Box"
        } else if sender == cinemaButton {
            selectedButtonText = "롯데 시네마"
        }
        
        print("Selected button: \(selectedButtonText)")
        
        if sender == cgvButton {
            
        } else if sender == magaBoxButton {
            
        } else if sender == cinemaButton {
            
        }
    }

    @IBAction func seatButtonTapped(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else {
            return
        }
        
        let buttonIndex = sender.tag
        
        print("Button text: \(buttonText)")
        
        if selectedSeatButtons.contains(buttonIndex) {
            selectedSeatButtons.remove(buttonIndex)
            sender.backgroundColor = UIColor(named: "WhiteColor")
            sender.setTitleColor(UIColor(named: "BackColor"), for: .normal)
        } else {
            if selectedSeatButtons.count >= 3 {
                showAlert(message: "최대 세 자리까지만 선택이 가능합니다.")
                return
            }
            
            selectedSeatButtons.insert(buttonIndex)
            sender.backgroundColor = UIColor(named: "YellowColor")
            sender.setTitleColor(UIColor(named: "WhiteColor"), for: .normal)
        }
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func ticketingButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "결제 안내", message: "결제를 진행하시겠습니까?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.showCompletionAlert()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.showCancellationNotification()
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }

    func showCancellationNotification() {
        let alert = UIAlertController(title: nil, message: "예매가 취소되었습니다.", preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
        print("Reservation cancelled.")
    }
    
    func showCompletionAlert() {
        let completionAlert = UIAlertController(title: "결제 안내", message: "결제가 완료되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        completionAlert.addAction(okAction)
        present(completionAlert, animated: true, completion: nil)
    }
}

extension TicketingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectDateCollectionView {
            let currentDate = Date()
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: currentDate)!
            return range.count
        } else if collectionView == selectTimeCollectionView {
            return 18
        } else {
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectDateCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketDateCell", for: indexPath) as? TicketDateCellController else {
                return UICollectionViewCell()
            }
            
            let currentDate = Date()
            let calendar = Calendar.current
            let startOfMonth = calendar.startOfDay(for: currentDate)
            let date = calendar.date(byAdding: .day, value: indexPath.item, to: startOfMonth)!
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "M월"
            let monthString = monthFormatter.string(from: date)
            
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d일"
            let dayString = dayFormatter.string(from: date)
            
            cell.monthLabel.text = monthString
            cell.dayLabel.text = dayString
            
            return cell
        } else if collectionView == selectTimeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketTimeCell", for: indexPath) as? TicketTimeCellController else {
                return UICollectionViewCell()
            }
            
            let time = indexPath.item + 7
            let ampm = time < 12 ? "AM" : "PM"
            let displayHour = time <= 12 ? time : time - 12
            
            let timeString = "\(ampm) \(displayHour):00"
            
            cell.titleLabel.text = timeString
            cell.layer.backgroundColor = UIColor(named: "RedColor")?.withAlphaComponent(0.5).cgColor
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectDateCollectionView {
            if let previousSelectedIndexPath = selectedIndexPath {
                if let previousCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? TicketDateCellController {
                    previousCell.layer.backgroundColor = UIColor(named: "WhiteColor")?.cgColor
                    previousCell.monthLabel.textColor = UIColor(named: "DarkGreyColor")
                    previousCell.circleView.backgroundColor = UIColor(named: "RedColor")
                    previousCell.dayLabel.textColor = UIColor(named: "WhiteColor")
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? TicketDateCellController {
                if let bgColor = UIColor(named: "RedColor") {
                    cell.layer.backgroundColor = bgColor.cgColor
                }
                
                if let monthColor = UIColor(named: "WhiteColor") {
                    cell.monthLabel.textColor = monthColor
                }
                
                if let circleColor = UIColor(named: "WhiteColor") {
                    cell.circleView.backgroundColor = circleColor
                }
                
                if let dayColor = UIColor(named: "RedColor") {
                    cell.dayLabel.textColor = dayColor
                }
            }
            
            selectedIndexPath = indexPath
            
            let currentDate = Date()
            let calendar = Calendar.current
            let startOfMonth = calendar.startOfDay(for: currentDate)
            let date = calendar.date(byAdding: .day, value: indexPath.item, to: startOfMonth)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            print("Selected date: \(dateString)")
        } else  if collectionView == selectTimeCollectionView {
            let selectedCell = collectionView.cellForItem(at: indexPath)
            selectedCell?.backgroundColor =  UIColor(named: "RedColor")?.withAlphaComponent(1.0)
            
            if let previousSelectedIndexPath = selectedIndexPath {
                let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath)
                previousSelectedCell?.backgroundColor =  UIColor(named: "RedColor")?.withAlphaComponent(0.5)
            }
            
            selectedIndexPath = indexPath
            
            let time = indexPath.item + 7
            let ampm = time < 12 ? "AM" : "PM"
            let displayHour = time <= 12 ? time : time - 12 
            print("Selected time: \(ampm) \(displayHour):00")
        }
    }
}
