//
//  ViewController.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 29.03.22.
//

import UIKit
import SDWebImage
import DropDown

class HomeViewController: UIViewController {
    
    @IBOutlet var dotLabel: UILabel!
    @IBOutlet var dotLabel2: UILabel!
    @IBOutlet var dotLabel3: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    
    var search = ""
    
    // Select Language
    @IBOutlet weak var dropDownButton: UIButton! {
        didSet {
            dropDownButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet var dropDownView: UIView!
    @IBOutlet var dropDownLabel: UILabel!
    let dropDown = DropDown()
    let dropDownValues = ["EN", "RU"]
    var language = "EN"
    
    // Latest News
    var latestNewsModel: LatestNewsModel?
    let latestNews = LatestNewsViewModel()
    
    // Searched News
    var searchNewsModel: SearchNewsModel?
    let searchNews = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // corner radius
        dotLabel.layer.cornerRadius = 10
        dotLabel2.layer.cornerRadius = 8
        dotLabel3.layer.cornerRadius = 5
        dropDownView.layer.cornerRadius = 14
        dropDownLabel.layer.cornerRadius = 14
        
        // DropDown settings
        dropDown.anchorView = dropDownView
        dropDown.dataSource = dropDownValues
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            dropDownLabel.text = dropDownValues[index]
            language = dropDownValues[index]
            NotificationCenter.default.post(name: NSNotification.Name("languageChanged"), object: nil)
        }
        
        // Check whether data is saved or not
        Helper.sharedInstance.newsTitleArray = UserDefaults.standard.array(forKey: "titleDefaults") as? [String]
        
        // Getting current date
        getDate()
        showLatestNews()
        
        // Delgates and Data Sources
        collectionView.delegate = self
        collectionView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.items![0].image = UIImage(systemName: "house.fill")
        self.tabBarController?.tabBar.items![1].image = UIImage(systemName: "bookmark")
        
        NotificationCenter.default.addObserver(self, selector: #selector(showLatestNews), name: NSNotification.Name("languageChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setter: searchBar), name: NSNotification.Name("languageChanged"), object: nil)
    }
    
    func getDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.dateStyle = .long
        dateLabel.text = "\(dateFormatter.string(from: date))"
    }
    
    @objc func showLatestNews() {
        latestNews.showLatestNews(_LatestLanguage: language) { latestNews in
            self.latestNewsModel = latestNews
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
    }
}

// Collection Settings
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestNewsModel?.articles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        cell.collectionTopicLabel.layer.cornerRadius = 10
        cell.collectionImageView.layer.cornerRadius = 16
        cell.collectionTopicLabel.text = self.latestNewsModel?.articles?[indexPath.row].topic ?? "No data"
        cell.collectionTitleLabel.text = self.latestNewsModel?.articles?[indexPath.row].title ?? "No data"
        cell.collectionImageView.sd_setImage(with: URL(string: self.latestNewsModel?.articles?[indexPath.row].media ?? "select"))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsMedia = latestNewsModel?.articles?[indexPath.row].media ?? "select"
        let newsTopic = latestNewsModel?.articles?[indexPath.row].topic ?? "No data"
        let newsTitle = latestNewsModel?.articles?[indexPath.row].title ?? "No data"
        let newsAuthor = latestNewsModel?.articles?[indexPath.row].author ?? "No data"
        let newsExcerpt = latestNewsModel?.articles?[indexPath.row].excerpt ?? "No data"
        let newsSummary = latestNewsModel?.articles?[indexPath.row].summary ?? "No data"
        let newsLink = latestNewsModel?.articles?[indexPath.row].link ?? "No data"
        let newsTwitterAccount = searchNewsModel?.articles?[indexPath.row].twitter_account ?? "No data"
        let newsDate = latestNewsModel?.articles?[indexPath.row].published_date ?? "No data"
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = board.instantiateViewController(withIdentifier: "details") as! DetailsViewController

        detailsVC.mediaAPI = newsMedia
        detailsVC.topicAPI = newsTopic
        detailsVC.titleAPI = newsTitle
        detailsVC.authorAPI = newsAuthor
        detailsVC.excerptAPI = newsExcerpt
        detailsVC.summaryAPI = newsSummary
        detailsVC.linkAPI = newsLink
        detailsVC.twitterAPI = newsTwitterAccount
        detailsVC.dateAPI = newsDate
        
        if Helper.sharedInstance.newsTitleArray?.contains(newsTitle) ?? false {
            detailsVC.saveText = "Saved"
            detailsVC.saveImage = "bookmark.fill"
        } else {
            detailsVC.saveText = "Save"
            detailsVC.saveImage = "bookmark"
        }
        
        detailsVC.modalPresentationStyle = .fullScreen
        self.present(detailsVC, animated: true, completion: nil)
    }
}

// Table Settings
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchNewsModel?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        cell.topicLabel.layer.cornerRadius = 8
        cell.tableImageView.layer.cornerRadius = 18
        cell.topicLabel.text = searchNewsModel?.articles?[indexPath.row].topic ?? "No data"
        cell.titleLabel.text = searchNewsModel?.articles?[indexPath.row].title ?? "No data"
        
        if let stringDate = searchNewsModel?.articles?[indexPath.row].published_date as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let somedate = dateFormatter.date(from: stringDate)!
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let somedateString = dateFormatter.string(from: somedate)
            cell.dateLabel.text = somedateString
        }
        cell.authorLabel.text = searchNewsModel?.articles?[indexPath.row].author ?? "No data"
        cell.tableImageView.sd_setImage(with: URL(string: searchNewsModel?.articles?[indexPath.row].media ?? "select"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsMedia = searchNewsModel?.articles?[indexPath.row].media ?? "select"
        let newsTopic = searchNewsModel?.articles?[indexPath.row].topic ?? "No data"
        let newsTitle = searchNewsModel?.articles?[indexPath.row].title ?? "No data"
        let newsAuthor = searchNewsModel?.articles?[indexPath.row].author ?? "No data"
        let newsExcerpt = searchNewsModel?.articles?[indexPath.row].excerpt ?? "No data"
        let newsSummary = searchNewsModel?.articles?[indexPath.row].summary ?? "No data"
        let newsLink = searchNewsModel?.articles?[indexPath.row].link ?? "No data"
        let newsTwitterAccount = searchNewsModel?.articles?[indexPath.row].twitter_account ?? "No data"
        let newsDate = searchNewsModel?.articles?[indexPath.row].published_date ?? "No data"

        let board = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = board.instantiateViewController(withIdentifier: "details") as! DetailsViewController

        detailsVC.mediaAPI = newsMedia
        detailsVC.topicAPI = newsTopic
        detailsVC.titleAPI = newsTitle
        detailsVC.authorAPI = newsAuthor
        detailsVC.excerptAPI = newsExcerpt
        detailsVC.summaryAPI = newsSummary
        detailsVC.linkAPI = newsLink
        detailsVC.twitterAPI = newsTwitterAccount
        detailsVC.dateAPI = newsDate
        
        if Helper.sharedInstance.newsTitleArray?.contains(newsTitle) ?? false {
            detailsVC.saveText = "Saved"
            detailsVC.saveImage = "bookmark.fill"
        }else {
            detailsVC.saveText = "Save"
            detailsVC.saveImage = "bookmark"
        }
        
        detailsVC.modalPresentationStyle = .fullScreen
        self.present(detailsVC, animated: true, completion: nil)
    }
    
}

// Search Settings
extension HomeViewController: UISearchBarDelegate {

    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search = searchText
//        searchNews.searchForNews(search, SearchLanguage: language) { search in
//            self.searchNewsModel = search
//            DispatchQueue.main.async {
//                self.searchTableView.reloadData()
//            }
//        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchNews.searchForNews(search, SearchLanguage: language) { search in
            self.searchNewsModel = search
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        }
    }
}
