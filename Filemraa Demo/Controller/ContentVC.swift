//
//  ContentVC.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 09/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AVKit
import AVFoundation

class ContentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    Variables
    var movieTitle: String = ""
    var movieImageUrl: String = ""
    var trailerId = ""
    var imageCache: NSCache<AnyObject, AnyObject> = NSCache()
    
//    Database Refrences
    var youMayAlsoLikeDatabaseReference: DatabaseReference!
    
//    Array to hold data
    var youMayAlsoLikeArray = [DataModel]()
    
    
//    Views
    let topImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let subscribeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let watchTrailerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch Trailer", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    let clapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "clap"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "view"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "time"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clapsLabel: UILabel = {
        let label = UILabel()
        label.text = "17 Claps"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewsLabel: UILabel = {
           let label = UILabel()
           label.text = "23 Views"
           label.textColor = .white
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let timeLabel: UILabel = {
           let label = UILabel()
           label.text = "23 Mins"
           label.textColor = .white
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let shareLabel: UILabel = {
           let label = UILabel()
           label.text = "Share"
           label.textColor = .white
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
   
    let directorLabel: UILabel = {
        let label = UILabel()
        label.text = "Director :"
        label.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language :"
        label.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let synopsisLabel: UILabel = {
        let label = UILabel()
        label.text = "Synopsis :"
        label.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directorLabelName: UILabel = {
        let label = UILabel()
        label.text = "Akash Goila"
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageLabelName: UILabel = {
        let label = UILabel()
        label.text = "Hindi"
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let synopsisLabelName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 5
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let youMayAlsoLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "You May Also Like"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    //    You May Also Like CollectionView
    let youMayAlsoLikeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let subscribeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 5
        let officialLogoImageView = UIImageView()
        officialLogoImageView.image = UIImage(named: "filmeraaLogo")
        view.addSubview(officialLogoImageView)
        officialLogoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 60)
        let label1 = UILabel()
        label1.text = "What You Get ?"
        label1.textColor = UIColor.white
        label1.textAlignment = .center
        label1.font = UIFont(name: "Normal", size: 18)
        view.addSubview(label1)
        label1.anchor(top: officialLogoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        let label2 = UILabel()
        label2.text = "Unlimited Content."
        label2.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label2.textAlignment = .center
        label2.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label2)
        label2.anchor(top: label1.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        let label3 = UILabel()
        label3.text = "High Quality Videos."
        label3.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label3.textAlignment = .center
        label3.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label3)
        label3.anchor(top: label2.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        let label4 = UILabel()
        label4.text = "No Hidden Fees."
        label4.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label4.textAlignment = .center
        label4.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label4)
        label4.anchor(top: label3.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        let label5 = UILabel()
        label5.text = "No Extra Charges."
        label5.textColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        label5.textAlignment = .center
        label5.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(label5)
        label5.anchor(top: label4.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
       let button = UIButton()
       button.backgroundColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
       button.setTitle("Get a subscription Now", for: .normal)
       button.setTitleColor(UIColor.black, for: .normal)
       button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
       button.layer.cornerRadius = 5
        view.addSubview(button)
        button.anchor(top: label5.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
       return view
    }()
    
    let crossButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "cross"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(disappearSubscriptionView), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationView()
        setUpViews()
        setUpScrollView()
        setUpContentInsideScrollView()
        youMayAlsoLikeDatabaseReference = Database.database().reference().child("You May Also Like")
        loadyouMayAlsoLikeData()
        
        view.addSubview(subscribeView)
        subscribeView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.bounds.width, height: 360)
        subscribeView.addSubview(crossButton)
        crossButton.anchor(top: subscribeView.topAnchor, left: nil, bottom: nil, right: subscribeView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 25, height: 25)
        
        subscribeView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != subscribeView{
            self.subscribeView.isHidden = true
        }
    }
    
    //    CollectionView Delegate and DataSource
     
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         
        return youMayAlsoLikeArray.count
         
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeaturetteCollectionViewCell
         cell.downloadImage(withUrlString: youMayAlsoLikeArray[indexPath.row].imageUrl)
         return cell
         
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         let contentVC = ContentVC()
         contentVC.movieTitle = youMayAlsoLikeArray[indexPath.row].title
         contentVC.movieImageUrl = youMayAlsoLikeArray[indexPath.row].movieImageUrl
         let backItem = UIBarButtonItem()
         backItem.title = ""
         self.navigationItem.backBarButtonItem = backItem
         self.navigationController?.pushViewController(contentVC, animated: true)
         
         
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        return CGSize(width: 120, height: self.youMayAlsoLikeCollectionView.bounds.height)
        
    }
    
    func setUpNavigationView(){
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationItem.title = movieTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        view.backgroundColor = .black
    }
    
    func setUpViews(){
        downloadImage(withUrlString: movieImageUrl)
        view.addSubview(topImageView)
        if #available(iOS 11.0, *) {
            topImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        } else {
            // Fallback on earlier versions
        }
        topImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        topImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(subscribeButton)
        subscribeButton.addTarget(self, action: #selector(getSubscription), for: .touchUpInside)
        subscribeButton.centerXAnchor.constraint(equalTo: topImageView.centerXAnchor).isActive = true
        subscribeButton.centerYAnchor.constraint(equalTo: topImageView.centerYAnchor).isActive = true
        subscribeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(watchTrailerButton)
        watchTrailerButton.addTarget(self, action: #selector(watchTrailer), for: .touchUpInside)
        watchTrailerButton.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        watchTrailerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        watchTrailerButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        watchTrailerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
       
    }
    
     func setUpScrollView(){
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           contentView.translatesAutoresizingMaskIntoConstraints = false
           
           view.addSubview(scrollView)
           scrollView.addSubview(contentView)
           
           scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
           scrollView.topAnchor.constraint(equalTo: watchTrailerButton.bottomAnchor).isActive = true
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
           
           contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
           contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
           contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
           contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
       }
    func setUpContentInsideScrollView(){
        let clapStack = UIStackView(arrangedSubviews: [clapButton])
        clapStack.axis = .vertical
        clapStack.distribution = .fillProportionally
        clapStack.spacing = 3

        let viewStack = UIStackView(arrangedSubviews: [viewButton])
        viewStack.axis = .vertical
        viewStack.distribution = .fillProportionally
        viewStack.spacing = 3


        let timeStack = UIStackView(arrangedSubviews: [timeButton])
        timeStack.axis = .vertical
        timeStack.distribution = .fillProportionally
        timeStack.spacing = 3

        let shareStack = UIStackView(arrangedSubviews: [shareButton])
        shareStack.axis = .vertical
        shareStack.distribution = .fillProportionally
        shareStack.spacing = 3
        
        
        
        let stackView = UIStackView(arrangedSubviews: [clapStack, viewStack, timeStack, shareStack])
        stackView.axis = .horizontal
        stackView.spacing = 70
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 30)
        
        let stackView2 = UIStackView(arrangedSubviews: [clapsLabel, viewsLabel, timeLabel, shareLabel])
        stackView2.axis = .horizontal
        stackView2.spacing = 30
        stackView2.distribution = .fillEqually
        contentView.addSubview(stackView2)
        stackView2.anchor(top: stackView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 0, height: 30)
        
        contentView.addSubview(directorLabel)
        directorLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        directorLabel.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: 20).isActive = true
        directorLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        directorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(languageLabel)
        languageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        languageLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 20).isActive = true
        languageLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        languageLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(synopsisLabel)
        synopsisLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        synopsisLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 20).isActive = true
        synopsisLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        synopsisLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(directorLabelName)
        directorLabelName.leftAnchor.constraint(equalTo: directorLabel.rightAnchor, constant: 20).isActive = true
        directorLabelName.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: 20).isActive = true
        directorLabelName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        directorLabelName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(languageLabelName)
        languageLabelName.leftAnchor.constraint(equalTo: languageLabel.rightAnchor, constant: 20).isActive = true
        languageLabelName.topAnchor.constraint(equalTo: directorLabelName.bottomAnchor, constant: 20).isActive = true
        languageLabelName.widthAnchor.constraint(equalToConstant: 150).isActive = true
        languageLabelName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(synopsisLabelName)
        synopsisLabelName.topAnchor.constraint(equalTo: synopsisLabel.bottomAnchor, constant: 10).isActive = true
        synopsisLabelName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        synopsisLabelName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        
        contentView.addSubview(youMayAlsoLikeLabel)
        youMayAlsoLikeLabel.topAnchor.constraint(equalTo: synopsisLabelName.bottomAnchor, constant: 20).isActive = true
        youMayAlsoLikeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        youMayAlsoLikeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        youMayAlsoLikeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        youMayAlsoLikeCollectionView.dataSource = self
        youMayAlsoLikeCollectionView.delegate = self
        youMayAlsoLikeCollectionView.register(FeaturetteCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(youMayAlsoLikeCollectionView)
        youMayAlsoLikeCollectionView.topAnchor.constraint(equalTo: youMayAlsoLikeLabel.bottomAnchor, constant: 10).isActive = true
        youMayAlsoLikeCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        youMayAlsoLikeCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        youMayAlsoLikeCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        youMayAlsoLikeCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    func loadyouMayAlsoLikeData(){
        youMayAlsoLikeDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: Any]{
                        let title = dict["title"] as! String
                        let imageUrl = dict["imageUrl"] as! String
                        let movieImageUrl = dict["movieImageUrl"] as! String
                        let trailerId = dict["trailerId"] as! String
                        let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                        self.youMayAlsoLikeArray.append(data)
        //                self.featureCollectionView.delegate = self
        //                self.featureCollectionView.dataSource = self
                        self.youMayAlsoLikeCollectionView.reloadData()
                        
                    }
                })
    }

    func downloadImage(withUrlString urlString: String) {
              
              let url = URL(string: urlString)!
              
              if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
                  self.topImageView.image = imageFromCache
                  return
              }
              
              URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                  
                  if error != nil {
                      debugPrint(String(describing: error?.localizedDescription))
                      return
                  }
                  
                  DispatchQueue.main.async {
                      let imageToCache = UIImage(data: data!)
                      self.topImageView.image = imageToCache
                      self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as AnyObject)
                  }
              }).resume()
    }
    
    @objc func getSubscription(){
        print("subscribe")
        subscribeView.isHidden = false
    }

    @objc func watchTrailer(){
        print("Watch Trailer")
        let video = AVPlayer(url: NSURL(string: trailerId)! as URL)
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = video
        present(videoPlayer, animated: true) {
            video.play()
        }
    }
    
    @objc func disappearSubscriptionView(){
        subscribeView.isHidden = true
    }
    
}
