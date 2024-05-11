//
//  MainViewController.swift
//  WOODLIX
//
//  Created by 밀가루 on 4/25/24.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var searchIcon: UIImageView!

    @IBOutlet weak var boxOfficeView: UIView!
    @IBOutlet weak var comingSoonView: UIView!
    @IBOutlet weak var showingView: UIView!
    @IBOutlet weak var ottView: UIView!
    
    // MARK: - Properties
    let boxofficeList: String = "boxoffice"
    let movieList: String = "movie"
    let today: Date = Date()
    var yesterdayDateString: String = ""
    
    var movieData: [MovieDataModel] = []

    var boxOfficeData: [BoxOfficeDataModel] = []
    var relayBoxOfficeData: [APIMovieDataModel] = []

    var comingSoonData: [APIMovieDataModel] = []
    
    var boxOfficeMovieData: [MovieDataModel] = []
    var comingSoonMovieData: [MovieDataModel] = []
    var showingMovieData: [MovieDataModel] = []
    var ottMovieData: [MovieDataModel] = []
    
    
    var comingSoonMovies: [APIMovieDataModel] = []
    var showingMovies: [APIMovieDataModel] = []
    var ottMovies: [APIMovieDataModel] = []


    private var boxOfficCollectionView: UICollectionView!
    private var comingSoonCollectionView: UICollectionView!
    private var showingCollectionView: UICollectionView!
    private var ottCollectionView: UICollectionView!

    private var tableView: UITableView!

    private var boxOfficeViewHeight: CGFloat = 0
    private var comingSoonViewHeight: CGFloat = 0
    private var showingViewHeight: CGFloat = 0
    private var ottViewHeight: CGFloat = 0

    var activityIndicator: UIActivityIndicatorView!

    // MARK: - Setup Methods
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
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

    private func setupComingSoonCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 140)

        comingSoonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        comingSoonCollectionView.backgroundColor = .clear
        comingSoonCollectionView.dataSource = self
        comingSoonCollectionView.delegate = self
        comingSoonCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        comingSoonCollectionView.register(ComingSoonCellController.self, forCellWithReuseIdentifier: "comingSoonCell")
        comingSoonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        comingSoonView.addSubview(comingSoonCollectionView)

        NSLayoutConstraint.activate([
            comingSoonCollectionView.topAnchor.constraint(equalTo: comingSoonView.topAnchor),
            comingSoonCollectionView.leadingAnchor.constraint(equalTo: comingSoonView.leadingAnchor),
            comingSoonCollectionView.trailingAnchor.constraint(equalTo: comingSoonView.trailingAnchor),
            comingSoonCollectionView.bottomAnchor.constraint(equalTo: comingSoonView.bottomAnchor)
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
        guard let layout = comingSoonCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }

        let itemCount = collectionView(comingSoonCollectionView, numberOfItemsInSection: 0)
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
        
        setupActivityIndicator()

        setupBoxOfficeCollectionView()
        setupComingSoonCollectionView()
        setupShowingCollectionView()
        setupOttCollectionView()
        setupTableView()
        tableView.register(MovieTableViewCellController.self, forCellReuseIdentifier: "tableCell")

        // API 요청 시작 전에 로딩 인디케이터 시작
        activityIndicator.startAnimating()
        
        // MARK: - APIMAnager
        BoxOfficeAPIManager.fetchDataFromAPI { [weak self] boxOfficeData in
            guard let self = self else { return }
            
            self.boxOfficeData = boxOfficeData
            
            var movieData: [MovieDataModel] = []

            var existingIDs: Set<Int64> = Set()
            var existingTitles: Set<String> = Set()
            
            let group = DispatchGroup()
            
            for boxOfficeItem in boxOfficeData {
                // BoxOfficeDataModel에서 필요한 데이터를 가져와서 APIMovieDataModel로 변환
                let relayData = APIMovieDataModel(movieCd: boxOfficeItem.movieCd,
                                                  movieNm: boxOfficeItem.movieNm,
                                                  movieNmEn: "",
                                                  prdtYear: nil,
                                                  openDt: boxOfficeItem.openDt,
                                                  typeNm: "",
                                                  prdtStatNm: "",
                                                  nationAlt: "",
                                                  genreAlt: "",
                                                  repNationNm: "",
                                                  repGenreNm: "",
                                                  rank: boxOfficeItem.rank,
                                                  salesAmt: boxOfficeItem.salesAmt,
                                                  audiCnt: boxOfficeItem.audiCnt)
                
                relayBoxOfficeData.append(relayData)
            }
            
            for boxOfficeItem in boxOfficeData {
                let formattedMovieNm = boxOfficeItem.movieNm.separateCharacterDigitsAndJoinWithSpace()
                print("formattedMovieNmformattedMovieNmformattedMovieNm\(formattedMovieNm)")
                group.enter()
                MovieAPIManager.fetchDataFromAPI(searchString: formattedMovieNm) { result in
                    for movie in result {
                        if !existingIDs.contains(movie.id), !existingTitles.contains(movie.title) {
                            movieData.append(movie)
                            existingIDs.insert(movie.id)
                            existingTitles.insert(movie.title)
                        }
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.boxOfficeMovieData = movieData // 새로운 변수에 저장
                self.boxOfficCollectionView.reloadData()
//                 print("Box Office Movie Data: \(movieData)")
            }
            
            print("BOXOFFICE: \(boxOfficeData)")
//            print("Relay Box Office Data: \(relayBoxOfficeData)")
        }

        ComingSoonAPIManager.fetchDataFromAPI { [weak self] comingSoonData in
            guard let self = self else { return }

            comingSoonMovies = comingSoonData.filter { $0.prdtStatNm == "개봉예정" }
            showingMovies = comingSoonData.filter { $0.prdtStatNm != "개봉예정" && self.isWithinOneYear(comingSoonMovie: $0) }
            ottMovies = comingSoonData.filter { $0.prdtStatNm != "개봉예정" && !self.isWithinOneYear(comingSoonMovie: $0) }

            let group = DispatchGroup()
            
            func fetchDataAndUpdateData(_ movies: [APIMovieDataModel], completion: @escaping ([MovieDataModel]) -> Void) {
                var targetArray: [MovieDataModel] = []
                for movieItem in movies {
                    let formattedMovieNm = movieItem.movieNm.separateCharacterDigitsAndJoinWithSpace()
                    group.enter()
                    MovieAPIManager.fetchDataFromAPI(searchString: formattedMovieNm) { result in
                        for movie in result {
                            targetArray.append(movie)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(targetArray)
                }
            }
            
            fetchDataAndUpdateData(comingSoonMovies) { result in
                self.comingSoonMovieData = result
            }
            
            fetchDataAndUpdateData(showingMovies) { result in
                self.showingMovieData = result
            }
            
            fetchDataAndUpdateData(ottMovies) { result in
                self.ottMovieData = result
            }
            
            group.notify(queue: .main) {
                self.comingSoonMovieData = self.comingSoonMovieData
                self.showingMovieData = self.showingMovieData
                self.ottMovieData = self.ottMovieData
                
                DispatchQueue.main.async {
                    self.comingSoonCollectionView.reloadData()
                    self.showingCollectionView.reloadData()
                    self.ottCollectionView.reloadData()
                    
                    self.activityIndicator.stopAnimating()
                }
                
//                print("COMING SOON: \(comingSoonMovies)")
//                print("SHOWING: \(showingMovies)")
//                print("OTT: \(ottMovies)")
//                
//                print("Coming Soon Movie Data: \(self.comingSoonMovieData)")
//                print("Showing Movie Data: \(self.showingMovieData)")
//                print("OTT Movie Data: \(self.ottMovieData)")
            }
        }
        


        boxOfficCollectionView.showsHorizontalScrollIndicator = false
        comingSoonCollectionView.showsHorizontalScrollIndicator = false
        showingCollectionView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false

        let boxOfficeContentSize = calculateBoxOfficeContentSize()
        let comingSoonContentSize = calculateComingSoonContentSize()
        let showingContentSize = calculateShowingContentSize()
        let ottContentSize = calculateOttContentSize()

        updateTableCellHeights()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(navigateToSearchPage))
        searchIcon.isUserInteractionEnabled = true
        searchIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func isWithinOneYear(comingSoonMovie: APIMovieDataModel) -> Bool {
        guard let prdtYear = Int(comingSoonMovie.prdtYear ?? "0") else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - prdtYear <= 1
    }
   
    private func updateTableCellHeights() {
        let boxOfficeHeight = boxOfficeView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let comingSoonHeight = comingSoonView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let showingHeight = showingView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let ottHeight = ottView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        boxOfficeViewHeight = boxOfficeHeight
        comingSoonViewHeight = comingSoonHeight
        showingViewHeight = showingHeight
        ottViewHeight = ottHeight

        tableView.reloadData()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == boxOfficCollectionView {
            boxOfficeScrollViewDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        } else if scrollView == comingSoonCollectionView {
            comingSoonScrollViewDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
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

    func comingSoonScrollViewDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = comingSoonCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let itemWidth = layout.itemSize.width + layout.minimumInteritemSpacing
        let proposedOffset = targetContentOffset.pointee
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth)
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
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth)
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
        let proposedPageIndex = round((proposedOffset.x + layout.minimumInteritemSpacing) / itemWidth) 
        let targetX = proposedPageIndex * itemWidth

        let updatedTargetOffset = CGPoint(x: targetX, y: proposedOffset.y)
        targetContentOffset.pointee = updatedTargetOffset
    }
    
    // MARK: - Gesture Recognizer
    @objc func navigateToSearchPage() {
        // showingMovieData가 아직 로드되지 않은 경우, 로딩 인디케이터를 표시하고 데이터를 기다림
        guard !showingMovieData.isEmpty else {
            // API 요청 시작 전에 로딩 인디케이터 시작
            activityIndicator.startAnimating()
            return
        }

        // showingMovieData가 이미 로드된 경우, 검색 페이지로 이동
        presentSearchViewController()
    }

    private func presentSearchViewController() {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "SearchView") as? SearchViewController else {
            print("Failed to instantiate MainPageViewController from UserStoryboard.")
            return
        }
        
        targetVC.modalPresentationStyle = .fullScreen
        targetVC.showingMovieData = self.showingMovieData // 여기서 showingMovieData를 전달
        
        present(targetVC, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToDetailPage(collectionView: collectionView, indexPath: indexPath)
    }

    private func navigateToDetailPage(collectionView: UICollectionView, indexPath: IndexPath) {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else {
            print("Failed to instantiate DetailViewController from Main storyboard.")
            return
        }
        
        // 아이템 전달
        var reservable: Bool = false
        var coming: Bool = false
        if collectionView == boxOfficCollectionView {
            reservable = true
            targetVC.selectedItem = (boxOfficeMovieData[indexPath.item], relayBoxOfficeData[indexPath.item], reservable, coming)
        } else if collectionView == comingSoonCollectionView {
            coming = true
            targetVC.selectedItem = (comingSoonMovieData[indexPath.item], comingSoonMovies[indexPath.item], reservable, coming)
        } else if collectionView == showingCollectionView {
            reservable = true
            targetVC.selectedItem = (showingMovieData[indexPath.item], showingMovies[indexPath.item], reservable, coming)
        } else if collectionView == ottCollectionView {
            targetVC.selectedItem = (ottMovieData[indexPath.item], ottMovies[indexPath.item], reservable, coming)
        }

        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
}

// MARK: - CollectionView DataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == boxOfficCollectionView {
            return boxOfficeMovieData.count
        } else if collectionView == comingSoonCollectionView {
            return comingSoonMovieData.count
        } else if collectionView == showingCollectionView {
            return showingMovieData.count
        } else if collectionView == ottCollectionView {
            return ottMovieData.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == boxOfficCollectionView {
            guard indexPath.item < boxOfficeMovieData.count else {
                return UICollectionViewCell()
            }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boxOfficeCell", for: indexPath) as? BoxOfficeCellController else {
                return UICollectionViewCell()
            }
            
            let boxOfficeMovie = boxOfficeMovieData[indexPath.item]
            
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(boxOfficeMovie.posterPath ?? "")"
            let title = boxOfficeMovie.originalTitle ?? ""
            
            cell.configure(with: imageUrl, title: title)
            
            return cell
        } else if collectionView == comingSoonCollectionView {
            guard indexPath.item < comingSoonMovieData.count else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comingSoonCell", for: indexPath) as? ComingSoonCellController else {
                return UICollectionViewCell()
            }
            
            let comingSoonMovie = comingSoonMovieData[indexPath.item]
            
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(comingSoonMovie.posterPath ?? "")"
            let title = comingSoonMovie.originalTitle ?? ""
            
            cell.configure(with: imageUrl, title: title)
            
            return cell
        } else if collectionView == showingCollectionView {
            guard indexPath.item < showingMovieData.count else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showingCell", for: indexPath) as? ShowingCellController else {
                return UICollectionViewCell()
            }

            let showingMovie = showingMovieData[indexPath.item]
            
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(showingMovie.posterPath ?? "")"
            let title = showingMovie.originalTitle ?? ""

            cell.configure(with: imageUrl, title: title)
            
            return cell
        } else if collectionView == ottCollectionView {
            guard indexPath.item < ottMovieData.count else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ottCell", for: indexPath) as? OttCellViewController else {
                return UICollectionViewCell()
            }

            let ottMovie = ottMovieData[indexPath.item] // Corrected typo here
            
            let imageUrl = "https://image.tmdb.org/t/p/w500/\(ottMovie.posterPath ?? "")"
            let title = ottMovie.originalTitle ?? ""
            
            cell.configure(with: imageUrl, title: title)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

}

extension String {
    func separateCharacterDigitsAndJoinWithSpace() -> String {
        var separatedString = ""
        var previousCharacter: Character? = nil
        for character in self {
            if let previous = previousCharacter {
                if previous.isLetter && character.isNumber {
                    separatedString.append(" \(character)")
                } else {
                    separatedString.append(character)
                }
            } else {
                separatedString.append(character)
            }
            previousCharacter = character
        }
        return separatedString
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
            return comingSoonViewHeight
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
            cell.contentView.addSubview(comingSoonView)
            comingSoonView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                comingSoonView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                comingSoonView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                comingSoonView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                comingSoonView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
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
