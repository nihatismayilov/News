//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 30.03.22.
//

import UIKit
import SDWebImage
import DropDown
import SafariServices

class DetailsViewController: UIViewController {
    
    var mediaAPI: String?
    var topicAPI: String?
    var titleAPI: String?
    var authorAPI: String?
    var excerptAPI: String?
    var summaryAPI: String?
    var linkAPI: String?
    var twitterAPI: String?
    var dateAPI: String?
    var from: String?
    var saveText: String?
    var saveImage: String?

    @IBOutlet var detailsImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var backButtonView: UIView!
    @IBOutlet var containerTopicLabel: UILabel!
    @IBOutlet var containerTitleLabel: UILabel!
    @IBOutlet var containerAuthorLabel: UILabel!
    @IBOutlet var containerExcerptLabel: UILabel!
    @IBOutlet var containerSummaryLabel: UILabel!
    @IBOutlet var containerReadMoreLabel: UILabel!
    
    // Back Button
    @IBOutlet var backButton: UIButton! {
        didSet { backButton.setTitle("", for: .normal) }
    }
    @IBOutlet var backButtonLabel: UILabel!
    
    // More Button
    @IBOutlet var dropDownView: UIView!
    var showMore = false
    @IBOutlet var dropDownButton: UIButton!
    @IBOutlet var moreView: UIView!
    @IBOutlet var moreSaveLabel: UILabel!
    @IBOutlet var moreSaveImage: UIImageView!
    @IBOutlet var moreSaveButton: UIButton! {
        didSet { moreSaveButton.setTitle("", for: .normal) }
    }
    @IBOutlet var moreShareButton: UIButton! {
        didSet { moreShareButton.setTitle("", for: .normal) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Corner radius settings
        containerTopicLabel.layer.cornerRadius = 10
        dropDownView.layer.cornerRadius = 17.5
        moreView.layer.cornerRadius = 16
        backButtonView.layer.cornerRadius = 16
        containerView.layer.cornerRadius = 32
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        // DropDown Settings
        showDetails()
        
        // Gesture recognizers
        containerReadMoreLabel.isUserInteractionEnabled = true
        let readMoreGesture = UITapGestureRecognizer(target: self, action: #selector(readMoreClicked))
        containerReadMoreLabel.addGestureRecognizer(readMoreGesture)
        
        containerAuthorLabel.isUserInteractionEnabled = true
        let authorGesture = UITapGestureRecognizer(target: self, action: #selector(authorClicked))
        containerAuthorLabel.addGestureRecognizer(authorGesture)
        
        // Back Button Settings
        backButtonLabel.text = titleAPI!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moreSaveLabel.text = saveText
        moreSaveImage.image = UIImage(systemName: saveImage!)
        checkData()
        NotificationCenter.default.addObserver(self, selector: #selector(checkData), name: NSNotification.Name("NewData"), object: nil)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func moreSaveClicked(_ sender: Any) {
        saveButtonClicked()
    }
    
    @IBAction func moreShareClicked(_ sender: Any) {
        moreView.isHidden = true
        showMore = false
        let activityController = UIActivityViewController(activityItems: [linkAPI!], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    @IBAction func dropDownClicked(_ sender: Any) {
        checkData()
        if showMore == false {
            moreView.isHidden = false
            self.showMore = true
        } else {
            moreView.isHidden = true
            self.showMore = false
        }
    }
    
    @objc func checkData() {
        if Helper.sharedInstance.newsTitleArray?.contains(titleAPI ?? "") ?? false {
            moreSaveLabel.text = "Saved"
            moreSaveImage.image = UIImage(systemName: "bookmark.fill")
        }else {
            moreSaveLabel.text = "Save"
            moreSaveImage.image = UIImage(systemName: "bookmark")
        }
    }
    
    @objc func readMoreClicked() {
        if let moreUrl  = linkAPI {
            let safariVC = SFSafariViewController(url: URL(string: moreUrl)!)
            present(safariVC, animated: true)
        }
    }
    
    @objc func authorClicked() {
        if twitterAPI != "No data" && twitterAPI != "" {
            let safariVC = SFSafariViewController(url: URL(string: "https://twitter.com/\(twitterAPI!)")!)
            present(safariVC, animated: true)
        } else {
            makeALert()
        }
    }
    
    func showDetails() {
        detailsImageView.sd_setImage(with: URL(string: mediaAPI ?? "select"))
        containerTopicLabel.text = topicAPI ?? "No data"
        containerTitleLabel.text = titleAPI ?? "No data"
        containerAuthorLabel.text = authorAPI ?? "No data"
        containerExcerptLabel.text = excerptAPI ?? "No data"
        containerSummaryLabel.text = summaryAPI ?? "No data"
    }
    
    func shareButtonClicked() {
        let activityController = UIActivityViewController(activityItems: [linkAPI!], applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    func saveButtonClicked() {
        
        guard let mediaApi = mediaAPI else { return }
        guard let topicApi = topicAPI else { return }
        guard let titleApi = titleAPI else { return }
        guard let authorApi = authorAPI else { return }
        guard let twittedAccountApi = twitterAPI else { return }
        guard let excerptApi = excerptAPI else { return }
        guard let summaryApi = summaryAPI else { return }
        guard let linkApi = linkAPI else { return }
        guard let dateApi = dateAPI else { return }
        
        if Helper.sharedInstance.newsTitleArray?.contains(titleAPI!) ?? false {
            if let mediaIndex = Helper.sharedInstance.newsMediaArray?.firstIndex(of: mediaApi) {
                Helper.sharedInstance.newsMediaArray?.remove(at: mediaIndex)
            }
            if let topicIndex = Helper.sharedInstance.newsTopicArray?.firstIndex(of: topicApi) {
                Helper.sharedInstance.newsTopicArray?.remove(at: topicIndex)
            }
            if let titleIndex = Helper.sharedInstance.newsTitleArray?.firstIndex(of: titleApi) {
                Helper.sharedInstance.newsTitleArray?.remove(at: titleIndex)
            }
            if let authorIndex = Helper.sharedInstance.newsAuthorArray?.firstIndex(of: authorApi) {
                Helper.sharedInstance.newsAuthorArray?.remove(at: authorIndex)
            }
            if let twitterAccountIndex = Helper.sharedInstance.newsTwitterAccountArray?.firstIndex(of: twittedAccountApi) {
                Helper.sharedInstance.newsTwitterAccountArray?.remove(at: twitterAccountIndex)
            }
            if let excerptIndex = Helper.sharedInstance.newsExcerptArray?.firstIndex(of: excerptApi) {
                Helper.sharedInstance.newsExcerptArray?.remove(at: excerptIndex)
            }
            if let summaryIndex = Helper.sharedInstance.newsSummaryArray?.firstIndex(of: summaryApi) {
                Helper.sharedInstance.newsSummaryArray?.remove(at: summaryIndex)
            }
            if let linkIndex = Helper.sharedInstance.newsLinkArray?.firstIndex(of: linkApi) {
                Helper.sharedInstance.newsLinkArray?.remove(at: linkIndex)
            }
            if let dateIndex = Helper.sharedInstance.newsDateArray?.firstIndex(of: dateApi) {
                Helper.sharedInstance.newsDateArray?.remove(at: dateIndex)
            }
            
            moreSaveLabel.text = "Save"
            moreSaveImage.image = UIImage(systemName: "bookmark")
            
            UserDefaults.standard.set(Helper.sharedInstance.newsMediaArray, forKey: "mediaDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsTopicArray, forKey: "topicDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsTitleArray, forKey: "titleDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsAuthorArray, forKey: "authorDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsTwitterAccountArray, forKey: "twitterAccountDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsExcerptArray, forKey: "excerptDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsSummaryArray, forKey: "summaryDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsLinkArray, forKey: "linkDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsDateArray, forKey: "dateDefaults")
        }else {

            Helper.sharedInstance.newsIdArray?.append(titleApi)
            Helper.sharedInstance.newsMediaArray?.append(mediaApi)
            Helper.sharedInstance.newsTopicArray?.append(topicApi)
            Helper.sharedInstance.newsTitleArray?.append(titleApi)
            Helper.sharedInstance.newsAuthorArray?.append(authorApi)
            Helper.sharedInstance.newsTwitterAccountArray?.append(twittedAccountApi)
            Helper.sharedInstance.newsExcerptArray?.append(excerptApi)
            Helper.sharedInstance.newsSummaryArray?.append(summaryApi)
            Helper.sharedInstance.newsLinkArray?.append(linkApi)
            Helper.sharedInstance.newsDateArray?.append(dateApi)
            
            moreSaveLabel.text = "Saved"
            moreSaveImage.image = UIImage(systemName: "bookmark.fill")
            
            UserDefaults.standard.set(Helper.sharedInstance.newsMediaArray, forKey: "mediaDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsTopicArray, forKey: "topicDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsTitleArray, forKey: "titleDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsAuthorArray, forKey: "authorDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsTwitterAccountArray, forKey: "twitterAccountDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsExcerptArray, forKey: "excerptDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsSummaryArray, forKey: "summaryDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsLinkArray, forKey: "linkDefaults")
            UserDefaults.standard.set(Helper.sharedInstance.newsDateArray, forKey: "dateDefaults")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("NewData"), object: nil)
    }
    
    func makeALert() {
        let alert = UIAlertController(title: "Error!", message: "Couldn't find twitter account", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
