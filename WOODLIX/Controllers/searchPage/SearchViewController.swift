//
//  CategoryCellController.swift
//  WOODLIX
//
//  Created by 밀가루 on 5/2/24.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate, SearchWordCellDelegate {
    
    // MARK: - Properties
    var wordItems: Array = ["파묘", "시라노", "범죄도시", "신과 함께", "파묘", "시라노", "범죄도시", "신과 함께"]
    
    var showingMovieData: [MovieDataModel] = []
    var updatedMovieData: [(MovieDataModel, Bool, Bool)] = []
    
    var reservable: Bool = false
    var comming: Bool = false
    
    // MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var inSearchWordBox: NSLayoutConstraint!
    @IBOutlet weak var searchWordView: UIView!
    private var searchWordCollectionView: UICollectionView!
    
    @IBOutlet weak var suggestionView: UIView!
    private var suggestionCollectionView: UICollectionView!
    
    @IBOutlet weak var goSearchButton: UIButton!
    
    var inSearchWord: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showingMovieData.shuffle()

        print("showingMovieDatashowingMovieData \(showingMovieData)")
        
        searchWordView.isHidden = true
        setupSuggestionCollectionView()
        setupSearchWordCollectionView()
        searchWordCollectionView.showsHorizontalScrollIndicator = false
        suggestionCollectionView.showsVerticalScrollIndicator = false
        
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        searchBar.tintColor = UIColor(named: "DarkGreyColor")
        searchBar.searchTextField.textColor = UIColor(named: "BackColor")
        searchBar.delegate = self

        goSearchButton.layer.cornerRadius = 12
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(named: "WhiteColor")
            if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = UIColor(named: "DarkGreyColor")
            }
        }

        if !wordItems.isEmpty {
            UIView.animate(withDuration: 0.3) {
                self.searchWordView.isHidden = false
                self.inSearchWord = true
                self.inSearchWordBox.constant += 56
                self.view.layoutIfNeeded()
            }
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupSearchWordCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 80, height: 30)

        searchWordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchWordCollectionView.backgroundColor = .clear
        searchWordCollectionView.dataSource = self
        searchWordCollectionView.delegate = self
        searchWordCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        searchWordCollectionView.register(SearchWordCellController.self, forCellWithReuseIdentifier: "searchWordCell")
        searchWordCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchWordView.addSubview(searchWordCollectionView)

        NSLayoutConstraint.activate([
            searchWordCollectionView.topAnchor.constraint(equalTo: searchWordView.topAnchor, constant: -4),
            searchWordCollectionView.leadingAnchor.constraint(equalTo: searchWordView.leadingAnchor),
            searchWordCollectionView.trailingAnchor.constraint(equalTo: searchWordView.trailingAnchor),
            searchWordCollectionView.bottomAnchor.constraint(equalTo: searchWordView.bottomAnchor)
        ])
    }

    private func setupSuggestionCollectionView() {
        let screenWidth = suggestionView.bounds.width
        
        let cellWidth = (screenWidth - 4 * 4) / 3
        let cellHeight: CGFloat = 140
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        suggestionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        suggestionCollectionView.collectionViewLayout = layout
        suggestionCollectionView.backgroundColor = .clear
        suggestionCollectionView.dataSource = self
        suggestionCollectionView.delegate = self
        suggestionCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        suggestionCollectionView.register(SearchSuggestionCellController.self, forCellWithReuseIdentifier: "searchSuggestionCell")
        suggestionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        suggestionView.addSubview(suggestionCollectionView)

        NSLayoutConstraint.activate([
            suggestionCollectionView.topAnchor.constraint(equalTo: suggestionView.topAnchor),
            suggestionCollectionView.leadingAnchor.constraint(equalTo: suggestionView.leadingAnchor),
            suggestionCollectionView.trailingAnchor.constraint(equalTo: suggestionView.trailingAnchor),
            suggestionCollectionView.bottomAnchor.constraint(equalTo: suggestionView.bottomAnchor)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         goSearchWordTapped()
     }
        
    // MARK: - Button Actions
    @IBAction func goSearchWordTapped() {
        guard let searchString = searchBar.text, !searchString.isEmpty else {
            showAlert(message: "검색어를 입력해주세요.")
            return
        }
        
        SearchAPIManager.fetchDataFromAPI(searchString: searchString) { [weak self] movieData in
            guard let self = self else { return }
            
            var searchResults: [(SearchDataModel, Bool, Bool)] = []

            if !movieData.isEmpty {
                var processedMovieNames: Set<String> = []
                var processedMovieID: Set<String> = []

                for movie in movieData {
                    let movieName = movie.movieNm
                    let movieID = movie.movieCd
                    
                    guard !processedMovieNames.contains(movieName) else {
                        continue
                    }
                    
                    guard !processedMovieID.contains(movieID) else {
                        continue
                    }
                    
                    if movie.prdtStatNm == "개봉" || movie.prdtStatNm == "기타" {
                        comming = false
                        reservable = true
                    } else if movie.prdtStatNm == "개봉예정" {
                        reservable = false
                    }
                    
                    let isWithinOneYear = self.isWithinOneYear(searchMovie: movie)
                    
                    print("영화명: \(movieName), 개봉 여부: \(reservable), 1년 이내 개봉 여부: \(isWithinOneYear)")
                    
                    searchResults.append((movie, reservable, comming))
                    
                    processedMovieNames.insert(movieName)
                }

                var updatedMovieData: [(MovieDataModel, Bool, Bool)] = []

                let dispatchGroup = DispatchGroup()
                
                for (data, reservable, comming) in searchResults {
                    dispatchGroup.enter()
                    MovieAPIManager.fetchDataFromAPI(searchString: data.movieNm) { searchData in
                        let moviesWithReservable = searchData.map { movie in
                            return (movie, reservable, comming)
                        }
                        updatedMovieData.append(contentsOf: moviesWithReservable)
                        dispatchGroup.leave()
                        print("MovieAPIManagersearchDatasearchData \(updatedMovieData)")
                        
                        DispatchQueue.main.async {
                            self.searchBar.resignFirstResponder()
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.updatedMovieData = updatedMovieData
                    self.suggestionCollectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.searchBar.text = ""
                    self.searchBar.resignFirstResponder()
                    self.showAlert(message: "검색어가 일치하지 않습니다.")
                }
            }
        }
    }

    func isWithinOneYear(searchMovie: SearchDataModel) -> Bool {
        guard let prdtYearString = searchMovie.prdtYear, let prdtYear = Int(prdtYearString) else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - prdtYear <= 1
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Gesture Recognizer
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == suggestionCollectionView {
            let cellWidth = (suggestionView.bounds.width - 4 * 4) / 3
            let cellHeight: CGFloat = 140
            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let itemText = wordItems[indexPath.item]
             let itemWidth = itemText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width
             let deleteButtonWidth: CGFloat = 20
             let totalWidth = itemWidth + 28 + deleteButtonWidth + 2
             return CGSize(width: totalWidth, height: 30)
        }
    }
    
    private func estimateWidthForItem(at indexPath: IndexPath) -> CGFloat {
        let itemText = wordItems[indexPath.item]
        let itemWidth = itemText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width
        return itemWidth + 20
    }
    
    func deleteButtonTapped(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            wordItems.remove(at: indexPath.item)
            searchWordCollectionView.reloadData()
            
            if wordItems.isEmpty {
                UIView.animate(withDuration: 0.3) {
                    self.inSearchWord = false
                    self.inSearchWordBox.constant -= 56
                    self.searchWordView.isHidden = true
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == suggestionCollectionView {
            let offsetY = scrollView.contentOffset.y
            let threshold: CGFloat = 20 // 스크롤 임계값
            let maxOffsetY = scrollView.contentSize.height - scrollView.bounds.height

            // 스크롤을 위로 올렸을 때
            if offsetY <= 0 {
                UIView.animate(withDuration: 0.3) {
                    self.inSearchWord = true
                    self.searchWordView.isHidden = false
                    self.inSearchWordBox.constant = 56
                    self.view.layoutIfNeeded()
                }
            }
            // 스크롤을 아래로 내렸을 때
            else if offsetY >= maxOffsetY {
                let bottomInset = max(56 - scrollView.safeAreaInsets.bottom, 0)
                UIView.animate(withDuration: 0.3) {
                    self.inSearchWord = false
                    self.searchWordView.isHidden = true
                    self.inSearchWordBox.constant = -bottomInset
                    self.view.layoutIfNeeded()
                }
            }
            // 중간 지점에 도달했을 때
            else {
                UIView.animate(withDuration: 0.3) {
                    self.inSearchWord = false
                    self.searchWordView.isHidden = true
                    self.inSearchWordBox.constant = 0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestionCollectionView {
            if !updatedMovieData.isEmpty {
                return updatedMovieData.count
            } else {
                return showingMovieData.count
            }
        } else if collectionView == searchWordCollectionView {
            return wordItems.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == suggestionCollectionView {
            if !updatedMovieData.isEmpty {
                guard indexPath.item < updatedMovieData.count else {
                    return UICollectionViewCell()
                }
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchSuggestionCell", for: indexPath) as? SearchSuggestionCellController else {
                    return UICollectionViewCell()
                }
                
                let updatedMovie = updatedMovieData[indexPath.item].0
                let imageUrl = "https://image.tmdb.org/t/p/w500/\(updatedMovie.posterPath ?? "")"
                let title = updatedMovie.title ?? ""
                cell.configure(with: imageUrl, title: title)
                
                return cell
            } else {
                guard indexPath.item < showingMovieData.count else {
                    return UICollectionViewCell()
                }
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchSuggestionCell", for: indexPath) as? SearchSuggestionCellController else {
                    return UICollectionViewCell()
                }
                
                let showingMovie = showingMovieData[indexPath.item]
                let imageUrl = "https://image.tmdb.org/t/p/w500/\(showingMovie.posterPath ?? "")"
                let title = showingMovie.title ?? ""
                cell.configure(with: imageUrl, title: title)
                
                return cell
            }
        } else if collectionView == searchWordCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchWordCell", for: indexPath) as? SearchWordCellController else {
                return UICollectionViewCell()
            }
            
            let word = wordItems[indexPath.item]
            cell.titleLabel.text = word
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == suggestionCollectionView {
            navigateToDetailPage(indexPath: indexPath)
        } else if collectionView == searchWordCollectionView {
            let selectedWord = wordItems[indexPath.item]
            searchBar.text = selectedWord
        }
    }

    private func navigateToDetailPage(indexPath: IndexPath) {
        let targetStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let targetVC = targetStoryboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController else {
            print("Failed to instantiate DetailViewController from Main storyboard.")
            return
        }
        
        if !updatedMovieData.isEmpty {
            let updatedMovie = updatedMovieData[indexPath.item].0
            reservable = updatedMovieData[indexPath.item].1 
            targetVC.selectedItem = (updatedMovie, reservable, comming)
        } else {
            let showingMovie = showingMovieData[indexPath.item]
            targetVC.selectedItem = (showingMovie, reservable, comming)
        }

        targetVC.modalPresentationStyle = .fullScreen
        present(targetVC, animated: true, completion: nil)
    }
    
    func isWithinOneYear(commingSoonMovie: CommingSoonDataModel) -> Bool {
        guard let prdtYear = Int(commingSoonMovie.prdtYear) else { return false }
        let currentYear = Calendar.current.component(.year, from: Date())
        return currentYear - prdtYear <= 1
    }
}
