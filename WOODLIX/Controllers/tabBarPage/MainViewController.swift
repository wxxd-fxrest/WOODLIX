//
//  MainViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 4/25/24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    // MARK: - Properties
    let boxofficeList: String = "boxoffice"
    let movieList: String = "movie"
    let today: Date = Date()
    var yesterdayDateString: String = ""

    // MARK: - Outlets
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var searchIcon: UIImageView!

    @IBOutlet weak var boxOfficeView: UIView!
    @IBOutlet weak var commingSoonView: UIView!
    @IBOutlet weak var showingView: UIView!
    @IBOutlet weak var ottView: UIView!
    
    private var boxOfficCollectionView: UICollectionView!
    private var commingSoonCollectionView: UICollectionView!
    private var showingCollectionView: UICollectionView!
    private var ottCollectionView: UICollectionView!

    private var tableView: UITableView!

    private var boxOfficeViewHeight: CGFloat = 0
    private var commingSoonViewHeight: CGFloat = 0
    private var showingViewHeight: CGFloat = 0
    private var ottViewHeight: CGFloat = 0

    // MARK: - Setup Methods
    private func setupBoxOfficeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 190)

        boxOfficCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        boxOfficCollectionView.backgroundColor = .clear
        boxOfficCollectionView.dataSource = self
        boxOfficCollectionView.delegate = self
        boxOfficCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        boxOfficCollectionView.register(BoxOfficeCellController.self, forCellWithReuseIdentifier: "boxOfficeCell")
        boxOfficCollectionView.translatesAutoresizingMaskIntoConstraints = false
        boxOfficeView.addSubview(boxOfficCollectionView)

        NSLayoutConstraint.activate([
            boxOfficCollectionView.topAnchor.constraint(equalTo: boxOfficeView.topAnchor),
            boxOfficCollectionView.leadingAnchor.constraint(equalTo: boxOfficeView.leadingAnchor),
            boxOfficCollectionView.trailingAnchor.constraint(equalTo: boxOfficeView.trailingAnchor),
            boxOfficCollectionView.bottomAnchor.constraint(equalTo: boxOfficeView.bottomAnchor)
        ])
    }

    private func setupCommingSoonCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 140)

        commingSoonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        commingSoonCollectionView.backgroundColor = .clear
        commingSoonCollectionView.dataSource = self
        commingSoonCollectionView.delegate = self
        commingSoonCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        commingSoonCollectionView.register(CommingSoonCellController.self, forCellWithReuseIdentifier: "commingSoonCell")
        commingSoonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        commingSoonView.addSubview(commingSoonCollectionView)

        NSLayoutConstraint.activate([
            commingSoonCollectionView.topAnchor.constraint(equalTo: commingSoonView.topAnchor),
            commingSoonCollectionView.leadingAnchor.constraint(equalTo: commingSoonView.leadingAnchor),
            commingSoonCollectionView.trailingAnchor.constraint(equalTo: commingSoonView.trailingAnchor),
            commingSoonCollectionView.bottomAnchor.constraint(equalTo: commingSoonView.bottomAnchor)
        ])
    }
    
    private func setupShowingCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 140)

        showingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        showingCollectionView.backgroundColor = .clear
        showingCollectionView.dataSource = self
        showingCollectionView.delegate = self
        showingCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        showingCollectionView.register(ShowingCellController.self, forCellWithReuseIdentifier: "showingCell")
        showingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        showingView.addSubview(showingCollectionView)

        NSLayoutConstraint.activate([
            showingCollectionView.topAnchor.constraint(equalTo: showingView.topAnchor),
            showingCollectionView.leadingAnchor.constraint(equalTo: showingView.leadingAnchor),
            showingCollectionView.trailingAnchor.constraint(equalTo: showingView.trailingAnchor),
            showingCollectionView.bottomAnchor.constraint(equalTo: showingView.bottomAnchor)
        ])
    }
    
    private func setupOttCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 140)

        ottCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ottCollectionView.backgroundColor = .clear
        ottCollectionView.dataSource = self
        ottCollectionView.delegate = self
        ottCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        ottCollectionView.register(OttCellViewController.self, forCellWithReuseIdentifier: "ottCell") // Corrected registration
        ottCollectionView.translatesAutoresizingMaskIntoConstraints = false
        ottView.addSubview(ottCollectionView)

        NSLayoutConstraint.activate([
            ottCollectionView.topAnchor.constraint(equalTo: ottView.topAnchor),
            ottCollectionView.leadingAnchor.constraint(equalTo: ottView.leadingAnchor),
            ottCollectionView.trailingAnchor.constraint(equalTo: ottView.trailingAnchor),
            ottCollectionView.bottomAnchor.constraint(equalTo: ottView.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        let bottomInset: CGFloat = 80
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerStackView.topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - Helper Methods
    private func calculateBoxOfficeContentSize() -> CGSize {
        guard let layout = boxOfficCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }

        let itemCount = collectionView(boxOfficCollectionView, numberOfItemsInSection: 0)
        let contentWidth = CGFloat(itemCount) * (layout.itemSize.width + layout.minimumInteritemSpacing)
        return CGSize(width: contentWidth, height: layout.itemSize.height)
    }

    private func calculateComingSoonContentSize() -> CGSize {
        guard let layout = commingSoonCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }

        let itemCount = collectionView(commingSoonCollectionView, numberOfItemsInSection: 0)
        let contentWidth = CGFloat(itemCount) * (layout.itemSize.width + layout.minimumInteritemSpacing)
        return CGSize(width: contentWidth, height: layout.itemSize.height)
    }

    private func calculateShowingContentSize() -> CGSize {
        guard let layout = showingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }

        let itemCount = collectionView(showingCollectionView, numberOfItemsInSection: 0)
        let contentWidth = CGFloat(itemCount) * (layout.itemSize.width + layout.minimumInteritemSpacing)
        return CGSize(width: contentWidth, height: layout.itemSize.height)
    }
    
    private func calculateOttContentSize() -> CGSize {
        guard let layout = ottCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }

        let itemCount = collectionView(ottCollectionView, numberOfItemsInSection: 0)
        let contentWidth = CGFloat(itemCount) * (layout.itemSize.width + layout.minimumInteritemSpacing)
        return CGSize(width: contentWidth, height: layout.itemSize.height)
    }

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBoxOfficeCollectionView()
        setupCommingSoonCollectionView()
        setupShowingCollectionView()
        setupOttCollectionView()
        setupTableView()
        tableView.register(MovieTableViewCellController.self, forCellReuseIdentifier: "tableCell")

        if let formattedDate = formatDateString(today) {
            if let yesterdayDate = subtractOneDay(from: formattedDate) {
                yesterdayDateString = yesterdayDate
                print("Yesterday's date: \(yesterdayDateString)")

                fetchDataFromAPI()
            } else {
                print("Failed to subtract one day.")
            }
        } else {
            print("Invalid date format.")
        }
        
        boxOfficCollectionView.showsHorizontalScrollIndicator = false
        commingSoonCollectionView.showsHorizontalScrollIndicator = false
        showingCollectionView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false

        let boxOfficeContentSize = calculateBoxOfficeContentSize()
        let comingSoonContentSize = calculateComingSoonContentSize()
        let showingContentSize = calculateShowingContentSize()
        let ottContentSize = calculateOttContentSize()

        updateTableCellHeights()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToMainPage))
        searchIcon.isUserInteractionEnabled = true
        searchIcon.addGestureRecognizer(tapGestureRecognizer)
    }

    private func updateTableCellHeights() {
        let boxOfficeHeight = boxOfficeView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let commingSoonHeight = commingSoonView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let showingHeight = showingView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let ottHeight = ottView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        boxOfficeViewHeight = boxOfficeHeight
        commingSoonViewHeight = commingSoonHeight
        showingViewHeight = showingHeight
        ottViewHeight = ottHeight

        tableView.reloadData()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == boxOfficCollectionView {
            boxOfficeScrollViewDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        } else if scrollView == commingSoonCollectionView {
            commingSoonScrollViewDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        } else if scrollView == showingCollectionView {
            showingScrollViewDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        } else if scrollView == ottCollectionView {
            ottScrollViewDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }

    func boxOfficeScrollViewDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = boxOfficCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemWidth = layout.itemSize.width + layout.minimumInteritemSpacing
        let proposedOffset = targetContentOffset.pointee
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth)
        let targetX = proposedPageIndex * itemWidth

        let updatedTargetOffset = CGPoint(x: targetX, y: proposedOffset.y)
        targetContentOffset.pointee = updatedTargetOffset
    }

    func commingSoonScrollViewDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = commingSoonCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemWidth = layout.itemSize.width + layout.minimumInteritemSpacing
        let proposedOffset = targetContentOffset.pointee
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth) // Add layout.minimumInteritemSpacing
        let targetX = proposedPageIndex * itemWidth

        let updatedTargetOffset = CGPoint(x: targetX, y: proposedOffset.y)
        targetContentOffset.pointee = updatedTargetOffset
    }

    func showingScrollViewDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = showingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemWidth = layout.itemSize.width + layout.minimumInteritemSpacing
        let proposedOffset = targetContentOffset.pointee
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth) // Add layout.minimumInteritemSpacing
        let targetX = proposedPageIndex * itemWidth

        let updatedTargetOffset = CGPoint(x: targetX, y: proposedOffset.y)
        targetContentOffset.pointee = updatedTargetOffset
    }
    
    func ottScrollViewDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = ottCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemWidth = layout.itemSize.width + layout.minimumInteritemSpacing
        let proposedOffset = targetContentOffset.pointee
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth) // Add layout.minimumInteritemSpacing
        let targetX = proposedPageIndex * itemWidth

        let updatedTargetOffset = CGPoint(x: targetX, y: proposedOffset.y)
        targetContentOffset.pointee = updatedTargetOffset
    }

    // MARK: - API Methods
    func fetchDataFromAPI() {
        guard let apiKey = getApiKey() else {
            print("API key not found.")
            return
        }

        // Daily box office
        //        let urlString = "http://kobis.or.kr/kobisopenapi/webservice/rest/\(boxofficeList)/searchDailyBoxOfficeList.json?key=\(apiKey)&targetDt=\(yesterdayDateString)"

        //        Movie List
        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/\(movieList)/searchMovieList.json?key=\(apiKey)&curPage=5"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response: \(jsonString)")
                        print("Today: \(self.today)")
                        //                        DispatchQueue.main.async {
                        //                            self.collectionView.reloadData() // Reload collection view data after fetching
                        //                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL")
        }
    }

    func getApiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "ApiKey", ofType: "plist") else {
            print("ApiKey.plist not found.")
            return nil
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("Invalid format of ApiKey.plist.")
            return nil
        }

        guard let apiKey = dict["API_KEY_MOVIE"] as? String else {
            print("ApiKey not found in ApiKey.plist.")
            return nil
        }

        return apiKey
    }

    func formatDateString(_ date: Date) -> String? {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyyMMdd"
        return outputFormatter.string(from: date)
    }

    func subtractOneDay(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMdd"

        if let date = inputFormatter.date(from: dateString) {
            if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: date) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyyMMdd"
                return outputFormatter.string(from: yesterday)
            }
        }

        return nil
    }
    
    // MARK: - Gesture Recognizer
    @objc func navigateToMainPage() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "SearchView") as? SearchViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetailPage(indexPath: indexPath)
    }

    private func navigateToDetailPage(indexPath: IndexPath) {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else {
            print("Failed to instantiate DetailViewController from Main storyboard.")
            return
        }
        
        targetVC.selectedItemIndex = indexPath.row
        
        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}

// MARK: - CollectionView DataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == boxOfficCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boxOfficeCell", for: indexPath) as? BoxOfficeCellController else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
            
            return cell
        } else if collectionView == commingSoonCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commingSoonCell", for: indexPath) as? CommingSoonCellController else {
                return UICollectionViewCell()
            }
            
            cell.titleLabel.text = "123"
            cell.backgroundColor = .red
            
            return cell
        } else if collectionView == showingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showingCell", for: indexPath) as? ShowingCellController else {
                return UICollectionViewCell()
            }

            return cell
        } else if collectionView == ottCollectionView {
            // Handle cell configuration for showingCollectionView
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ottCell", for: indexPath) as? OttCellViewController else {
                return UICollectionViewCell()
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

// MARK: - TableView DataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return boxOfficeViewHeight
        } else if indexPath.row == 1 {
            return commingSoonViewHeight
        } else if indexPath.row == 2 {
            return showingViewHeight
        } else if indexPath.row == 3 {
            return ottViewHeight
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        // Configure the cell
        if indexPath.row == 0 {
            cell.contentView.addSubview(boxOfficeView)
            boxOfficeView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                boxOfficeView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                boxOfficeView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                boxOfficeView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                boxOfficeView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        } else if indexPath.row == 1 {
            cell.contentView.addSubview(commingSoonView)
            commingSoonView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                commingSoonView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                commingSoonView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                commingSoonView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                commingSoonView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        } else if indexPath.row == 2 {
            cell.contentView.addSubview(showingView)
            showingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                showingView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                showingView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                showingView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                showingView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        } else if indexPath.row == 3 {
            cell.contentView.addSubview(ottView)
            ottView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                ottView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                ottView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                ottView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                ottView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
        }

        return cell
    }
}
