//
//  ViewController.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 08/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import ImageSlideshow
import FirebaseDatabase
import SVProgressHUD
import SDWebImage

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
//    Variables
    let featuretteImages = ["1", "1", "1", "1", "1"]
    let featureImages = ["1", "1", "1", "1", "1"]
    let musicImages = ["1", "1", "1", "1", "1"]
    let shortImages = ["1", "1", "1", "1", "1"]
    let seriesImages = ["1", "1", "1", "1", "1"]
    
//    Database Refrences
    var featuretteDatabaseReference: DatabaseReference!
    var featureDatabaseReference: DatabaseReference!
    var musicDatabaseReference: DatabaseReference!
    var shortDatabaseReference: DatabaseReference!
    var seriesDatabaseReference: DatabaseReference!
    
//    Arrays to hold data
    var featuretteArray = [DataModel]()
    var featureArray = [DataModel]()
    var musicArray = [DataModel]()
    var shortArray = [DataModel]()
    var seriesArray = [DataModel]()
//    Views
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filmeraaLogo")
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        let searchButton = UIButton()
        searchButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        view.addSubview(searchButton)
        searchButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 40, paddingLeft: 20, paddingBottom: 10, paddingRight: 0, width: 30, height: 30)
        let navDrawerButton = UIButton()
        navDrawerButton.setBackgroundImage(UIImage(named: "navDrawerIcon"), for: .normal)
        view.addSubview(navDrawerButton)
        navDrawerButton.addTarget(self, action: #selector(openNavDrawer), for: .touchUpInside)
        navDrawerButton.anchor(top: view.topAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 10, paddingRight: 20, width: 30, height: 30)
        return view
    }()
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        
        let nameLabel = UILabel()
        nameLabel.text = "Jason Roy"
        nameLabel.textColor = UIColor.white
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 200, height: 20)
        
        let mobileLabel = UILabel()
        mobileLabel.text = "Mobile No: +91786353728"
        mobileLabel.textColor = UIColor.white
        mobileLabel.font = UIFont(name: "Normal", size: 12)
        view.addSubview(mobileLabel)
        mobileLabel.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 220, height: 20)
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "filmeraaLogo")
        view.addSubview(logoImageView)
        logoImageView.anchor(top: mobileLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        view.addSubview(dividerView)
        dividerView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        let subscribeImageView = UIImageView()
        subscribeImageView.image = UIImage(named: "subscribe")
        view.addSubview(subscribeImageView)
        subscribeImageView.anchor(top: dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let subscribeButton = UIButton()
        subscribeButton.setTitle("Subscribe Now", for: .normal)
        subscribeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        subscribeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(subscribeButton)
        subscribeButton.anchor(top: dividerView.bottomAnchor, left: subscribeImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let billingImageView = UIImageView()
        billingImageView.image = UIImage(named: "billing")
        view.addSubview(billingImageView)
        billingImageView.anchor(top: subscribeImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let billingButton = UIButton()
        billingButton.setTitle("Billing History", for: .normal)
        billingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        billingButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(billingButton)
        billingButton.anchor(top: subscribeButton.bottomAnchor, left: billingImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let dividerView2 = UIView()
        dividerView2.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        view.addSubview(dividerView2)
        dividerView2.anchor(top: billingButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        let shareImageView = UIImageView()
        shareImageView.image = UIImage(named: "sharegold")
        view.addSubview(shareImageView)
        shareImageView.anchor(top: dividerView2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let shareButton = UIButton()
        shareButton.setTitle("Share App", for: .normal)
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        shareButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(shareButton)
        shareButton.anchor(top: dividerView2.bottomAnchor, left: shareImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let feedbackImageView = UIImageView()
        feedbackImageView.image = UIImage(named: "feedback")
        view.addSubview(feedbackImageView)
        feedbackImageView.anchor(top: shareImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let feedbackButton = UIButton()
        feedbackButton.setTitle("Submit Feedback", for: .normal)
        feedbackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        feedbackButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(feedbackButton)
        feedbackButton.anchor(top: shareButton.bottomAnchor, left: feedbackImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let dividerView3 = UIView()
        dividerView3.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        view.addSubview(dividerView3)
        dividerView3.anchor(top: feedbackButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        
        let privacyImageView = UIImageView()
        privacyImageView.image = UIImage(named: "privacy")
        view.addSubview(privacyImageView)
        privacyImageView.anchor(top: dividerView3.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let privacyButton = UIButton()
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        privacyButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(privacyButton)
        privacyButton.anchor(top: dividerView3.bottomAnchor, left: privacyImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let termsImageView = UIImageView()
        termsImageView.image = UIImage(named: "terms")
        view.addSubview(termsImageView)
        termsImageView.anchor(top: privacyImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let termsButton = UIButton()
        termsButton.setTitle("Terms of Service", for: .normal)
        termsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        termsButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(termsButton)
        termsButton.anchor(top:privacyButton.bottomAnchor, left: termsImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let helpImageView = UIImageView()
        helpImageView.image = UIImage(named: "help")
        view.addSubview(helpImageView)
        helpImageView.anchor(top: termsImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let helpButton = UIButton()
        helpButton.setTitle("Help & Support", for: .normal)
        helpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        helpButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(helpButton)
        helpButton.anchor(top: termsButton.bottomAnchor, left: helpImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let faqsImageView = UIImageView()
        faqsImageView.image = UIImage(named: "faq")
        view.addSubview(faqsImageView)
        faqsImageView.anchor(top: helpImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let faqsButton = UIButton()
        faqsButton.setTitle("FAQs", for: .normal)
        faqsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        faqsButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(faqsButton)
        faqsButton.anchor(top:helpButton.bottomAnchor, left: faqsImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        let signOutImageView = UIImageView()
        signOutImageView.image = UIImage(named: "signout")
        view.addSubview(signOutImageView)
        signOutImageView.anchor(top: faqsImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        let signOutButton = UIButton()
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signOutButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        view.addSubview(signOutButton)
        signOutButton.anchor(top:faqsButton.bottomAnchor, left: signOutImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        return view
    }()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = "Featurette Films"
        label.sizeToFit()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.text = "Feature Films"
        label.sizeToFit()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel()
        label.text = "Music Videos"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let label4: UILabel = {
        let label = UILabel()
        label.text = "Short Films"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let label5: UILabel = {
        let label = UILabel()
        label.text = "Series"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.sizeToFit()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slideShow: ImageSlideshow = {
        let view = ImageSlideshow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImageInputs([
            ImageSource(image: UIImage(named: "1")!),
            ImageSource(image: UIImage(named: "2")!),
            ImageSource(image: UIImage(named: "1")!),
            ImageSource(image: UIImage(named: "2")!),
            ImageSource(image: UIImage(named: "1")!),
            ImageSource(image: UIImage(named: "1")!)
            ])
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.yellow
        pageIndicator.pageIndicatorTintColor = UIColor.black
        view.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .bottom)
        view.contentScaleMode = .scaleAspectFill
        view.slideshowInterval = 2
        view.zoomEnabled = true

        return view
    }()
    
//    Featurette CollectionView
    let featuretteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    Feature CollectionView
    let featureCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    Music CollectionView
    let musicCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    Short CollectionView
    let shortCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
//    Series CollectionView
    let seriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addTopView()
        setupScrollView()
        setupViews()
        
        featuretteDatabaseReference = Database.database().reference().child("Featurette Films")
        featureDatabaseReference = Database.database().reference().child("Feature Films")
        musicDatabaseReference = Database.database().reference().child("Music Videos")
        shortDatabaseReference = Database.database().reference().child("Short Films")
        seriesDatabaseReference = Database.database().reference().child("Series")
        loadFeaturetteData()
        loadFeatureData()
        loadmusicData()
        loadShortData()
        loadSeriesData()
        
//        Add Nav Drawer
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 0)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(closeNavDrawer))
        swipe.direction = UISwipeGestureRecognizer.Direction.right
        navView.addGestureRecognizer(swipe)
        navView.isHidden = true

    }

   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.setNavigationBarHidden(true, animated: animated)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       navigationController?.setNavigationBarHidden(false, animated: animated)
   }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//        if touch?.view == slideShow{
//            self.navView.isHidden = true
//        }
    }
    
//    CollectionView Delegate and DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.featuretteCollectionView{
            return featuretteArray.count
        }
        if collectionView == self.featureCollectionView{
            return featureArray.count
        }
        if collectionView == self.musicCollectionView{
            return musicArray.count
        }
        if collectionView == self.seriesCollectionView{
            return seriesArray.count
        }
        if collectionView == self.shortCollectionView{
            return shortArray.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.featuretteCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeaturetteCollectionViewCell
//            cell.downloadImage(withUrlString: featuretteArray[indexPath.row].imageUrl)
            cell.imageView.sd_setImage(with: URL(string: featuretteArray[indexPath.row].imageUrl))
            return cell
        }
        
        if collectionView == self.featureCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeatureCollectionViewCell
            cell.imageView.sd_setImage(with: URL(string: featureArray[indexPath.row].imageUrl))
            return cell
        }
        
        if collectionView == self.musicCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MusicCollectionViewCell
            cell.imageView.sd_setImage(with: URL(string: musicArray[indexPath.row].imageUrl))
            return cell
        }
        
        if collectionView == self.seriesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SeriesCollectionViewCell
            cell.imageView.sd_setImage(with: URL(string: seriesArray[indexPath.row].imageUrl))
            return cell
        }
        
        if collectionView == self.shortCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShortCollectionViewCell
            cell.imageView.sd_setImage(with: URL(string: shortArray[indexPath.row].imageUrl))
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.featuretteCollectionView{
            let contentVC = ContentVC()
            contentVC.movieTitle = featuretteArray[indexPath.row].title
            contentVC.movieImageUrl = featuretteArray[indexPath.row].movieImageUrl
            contentVC.trailerId = featuretteArray[indexPath.row].trailerId
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(contentVC, animated: true)
        }
                
        if collectionView == self.featureCollectionView{
            let contentVC = ContentVC()
            contentVC.movieTitle = featureArray[indexPath.row].title
            contentVC.movieImageUrl = featureArray[indexPath.row].movieImageUrl
            contentVC.trailerId = featureArray[indexPath.row].trailerId
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(contentVC, animated: true)
        }
                
        if collectionView == self.musicCollectionView{
            let contentVC = ContentVC()
            contentVC.movieTitle = musicArray[indexPath.row].title
            contentVC.movieImageUrl = musicArray[indexPath.row].movieImageUrl
            contentVC.trailerId = musicArray[indexPath.row].trailerId
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(contentVC, animated: true)
        }
                
        if collectionView == self.seriesCollectionView{
            let contentVC = ContentVC()
             contentVC.movieTitle = seriesArray[indexPath.row].title
             contentVC.movieImageUrl = seriesArray[indexPath.row].movieImageUrl
             contentVC.trailerId = seriesArray[indexPath.row].trailerId
             let backItem = UIBarButtonItem()
             backItem.title = ""
             self.navigationItem.backBarButtonItem = backItem
             self.navigationController?.pushViewController(contentVC, animated: true)
        }
                
        if collectionView == self.shortCollectionView{
            let contentVC = ContentVC()
             contentVC.movieTitle = shortArray[indexPath.row].title
             contentVC.movieImageUrl = shortArray[indexPath.row].movieImageUrl
             contentVC.trailerId = shortArray[indexPath.row].trailerId
             let backItem = UIBarButtonItem()
             backItem.title = ""
             self.navigationItem.backBarButtonItem = backItem
             self.navigationController?.pushViewController(contentVC, animated: true)
        }
       
 
        
        
      
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 1
    }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 1
    }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if collectionView == self.featuretteCollectionView{
            return CGSize(width: 120, height: self.featuretteCollectionView.bounds.height)
        }
        if collectionView == self.featureCollectionView{
            return CGSize(width: 120, height: self.featureCollectionView.bounds.height)
        }
        if collectionView == self.musicCollectionView{
            return CGSize(width: 160, height: self.musicCollectionView.bounds.height)
        }
        if collectionView == self.shortCollectionView{
            return CGSize(width: 120, height: self.shortCollectionView.bounds.height)
        }
        if collectionView == self.seriesCollectionView{
            return CGSize(width: 120, height: self.seriesCollectionView.bounds.height)
        }
    
        return CGSize(width: 0, height: 0)
       
   }

//       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//              return CGSize(width: contentView.frame.width, height: 0)
//       }
    
    func addTopView(){
        view.addSubview(topView)
        topView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 80)
    }
    
    func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .black
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setupViews(){
        contentView.addSubview(slideShow)
        slideShow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        slideShow.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        slideShow.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        slideShow.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        contentView.addSubview(label1)
        label1.topAnchor.constraint(equalTo: slideShow.bottomAnchor, constant: 20).isActive = true
        label1.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        label1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        
        featuretteCollectionView.dataSource = self
        featuretteCollectionView.delegate = self
        featuretteCollectionView.register(FeaturetteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(featuretteCollectionView)
        featuretteCollectionView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 10).isActive = true
        featuretteCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        featuretteCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        featuretteCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        contentView.addSubview(label2)
        label2.topAnchor.constraint(equalTo: featuretteCollectionView.bottomAnchor, constant: 20).isActive = true
        label2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        label2.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.register(FeatureCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(featureCollectionView)
        featureCollectionView.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 10).isActive = true
        featureCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        featureCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        featureCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        contentView.addSubview(label3)
        label3.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        label3.topAnchor.constraint(equalTo: featureCollectionView.bottomAnchor, constant: 20).isActive = true
        label3.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        
        musicCollectionView.delegate = self
        musicCollectionView.dataSource = self
        musicCollectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(musicCollectionView)
        musicCollectionView.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 10).isActive = true
        musicCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        musicCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        musicCollectionView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        contentView.addSubview(label4)
        label4.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        label4.topAnchor.constraint(equalTo: musicCollectionView.bottomAnchor, constant: 20).isActive = true
        label4.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        
        shortCollectionView.delegate = self
        shortCollectionView.dataSource = self
        shortCollectionView.register(ShortCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(shortCollectionView)
        shortCollectionView.topAnchor.constraint(equalTo: label4.bottomAnchor, constant: 10).isActive = true
        shortCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        shortCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        shortCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        contentView.addSubview(label5)
        label5.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        label5.topAnchor.constraint(equalTo: shortCollectionView.bottomAnchor, constant: 20).isActive = true
        label5.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        
        seriesCollectionView.delegate = self
        seriesCollectionView.dataSource = self
        seriesCollectionView.register(SeriesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(seriesCollectionView)
        seriesCollectionView.topAnchor.constraint(equalTo: label5.bottomAnchor, constant: 10).isActive = true
        seriesCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        seriesCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        seriesCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        seriesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
                
    }
    
    func loadFeaturetteData() {
        featuretteDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let title = dict["title"] as! String
                let imageUrl = dict["imageUrl"] as! String
                let movieImageUrl = dict["movieImageUrl"] as! String
                let trailerId = dict["trailerId"] as! String
                let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                self.featuretteArray.append(data)
                self.featuretteCollectionView.reloadData()
                
            }
        })
    }

    func loadFeatureData(){
        featureDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
                  if let dict = snapshot.value as? [String: Any]{
                      let title = dict["title"] as! String
                      let imageUrl = dict["imageUrl"] as! String
                      let movieImageUrl = dict["movieImageUrl"] as! String
                      let trailerId = dict["trailerId"] as! String
                      let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                      self.featureArray.append(data)
                      self.featureCollectionView.reloadData()
                      
                  }
              })
    }
    
    func loadmusicData(){
        musicDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
                  if let dict = snapshot.value as? [String: Any]{
                      let title = dict["title"] as! String
                      let imageUrl = dict["imageUrl"] as! String
                      let movieImageUrl = dict["movieImageUrl"] as! String
                      let trailerId = dict["trailerId"] as! String
                      let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                      self.musicArray.append(data)
                      self.musicCollectionView.reloadData()
                      
                  }
              })
    }
    
    func loadShortData(){
        shortDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
                  if let dict = snapshot.value as? [String: Any]{
                      let title = dict["title"] as! String
                      let imageUrl = dict["imageUrl"] as! String
                      let movieImageUrl = dict["movieImageUrl"] as! String
                      let trailerId = dict["trailerId"] as! String
                      let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                      self.shortArray.append(data)
                      self.shortCollectionView.reloadData()
                      
                  }
              })
    }
    
    func loadSeriesData(){
        seriesDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
                  if let dict = snapshot.value as? [String: Any]{
                      let title = dict["title"] as! String
                      let imageUrl = dict["imageUrl"] as! String
                      let movieImageUrl = dict["movieImageUrl"] as! String
                      let trailerId = dict["trailerId"] as! String
                      let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                      self.seriesArray.append(data)
                      self.seriesCollectionView.reloadData()
                      
                  }
              })
    }
    
    @objc func openNavDrawer(){
        print("Nav Drawer")
        navView.isHidden = false
        
    }
    
    @objc func closeNavDrawer(){
        navView.isHidden = true
    }
    
    @objc func openSearch(){
        let searchVC = SearchVC()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

