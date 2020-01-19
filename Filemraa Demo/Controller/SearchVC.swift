//
//  SearchVC.swift
//  Filemraa Demo
//
//  Created by Vivek Rai on 14/01/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let imagesArray = ["1", "1", "2", "1", "2", "2"]
    let textArray = ["Great", "Australian", "Summer", "Come on", "Aussies", "Ricky Ponting"]
    //    Database Refrences
    var searchDatabaseReference: DatabaseReference!
    var searchArray = [DataModel]()
    var filteredSearchArray = [DataModel]()
    var inSearchMode = false
    let searchView: UISearchBar = {
        let view = UISearchBar()
        view.barTintColor = UIColor.black
        view.layer.cornerRadius = 5
        var textFieldInsideSearchBar = view.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        view.placeholder = "Search movies, short films..."
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: UITableView.Style.plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationView()
        view.addSubview(searchView)
        if #available(iOS 11.0, *) {
            searchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        } else {
            // Fallback on earlier versions
        }
        searchDatabaseReference = Database.database().reference().child("Search Content")
        searchView.delegate = self
        searchView.returnKeyType = UIReturnKeyType.done
        loadSearchData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.anchor(top: searchView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 19, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredSearchArray.count
        }
        return searchArray.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchCell
        var data = searchArray[indexPath.row]
        if inSearchMode{
            data = filteredSearchArray[indexPath.row]
        }
        cell.movieImageView.sd_setImage(with: URL(string: data.imageUrl))
        cell.titleLabel.text = data.title
        return cell
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentVC = ContentVC()
        contentVC.movieTitle = searchArray[indexPath.row].title
        contentVC.movieImageUrl = searchArray[indexPath.row].movieImageUrl
        contentVC.trailerId = searchArray[indexPath.row].trailerId
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(contentVC, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
       
    
    func setUpNavigationView(){
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        view.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.setNavigationBarHidden(false, animated: animated)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       navigationController?.setNavigationBarHidden(true, animated: animated)
   }
    
    func loadSearchData(){
        searchDatabaseReference.observe(DataEventType.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any]{
                let title = dict["title"] as! String
                let imageUrl = dict["imageUrl"] as! String
                let movieImageUrl = dict["movieImageUrl"] as! String
                let trailerId = dict["trailerId"] as! String
                let data = DataModel(imageUrl: imageUrl, title: title, movieImageUrl: movieImageUrl, trailerId: trailerId)
                self.searchArray.append(data)
                self.tableView.reloadData()
                
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           view.endEditing(true)
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text == nil || searchBar.text == ""{
           inSearchMode = false
           tableView.reloadData()
           view.endEditing(true)
       }else{
           inSearchMode = true
           let text = searchBar.text!
           filteredSearchArray = searchArray.filter({$0.title.range(of: text) != nil})
           tableView.reloadData()
           
       }
   }
}
