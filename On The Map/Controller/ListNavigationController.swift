//
//  ListNavigationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit

class ListNavigationController: UIViewController {
    
    @IBOutlet weak var userLocationsTBV: UITableView!
    var studentList = [StudentInformation]()
    let tableActivityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocationsTBV.delegate = self
        userLocationsTBV.dataSource = self
        
        navigationItem.title = "On The Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(logoutPressed))
        
       let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(refreshButtonPressed))
        
        let addPinButton = UIBarButtonItem(image: UIImage(named: "icon_pin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addPinButtonPress))
        
        navigationItem.rightBarButtonItems = [refreshButton, addPinButton]
    }
    
    @objc func addPinButtonPress(){
        if let addCurrentUserLocationVC = storyboard?.instantiateViewController(identifier: "AddCurrentUserLocationID"){
            addCurrentUserLocationVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addCurrentUserLocationVC, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUsers()
    }
    
    
    @objc func logoutPressed() {
        OnTheMapClient.logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    //to load the info from all users
    fileprivate func getUsers() {
        studentList.removeAll()
        tableActivityIndicator.center = view.center
        view.addSubview(tableActivityIndicator)
        tableActivityIndicator.startAnimating()
        
        OnTheMapClient.getUsersLocation(completion: {locations, error in
            self.studentList = locations ?? []
            DispatchQueue.main.async {
                self.userLocationsTBV.reloadData()
                self.tableActivityIndicator.stopAnimating()
                self.tableActivityIndicator.isHidden = true
            }
        })
    }
    
    @objc func refreshButtonPressed(){
        getUsers()
        self.userLocationsTBV.reloadData()
    }
}

extension ListNavigationController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let aUser = studentList[indexPath.row]
        
        let first = aUser.firstName
        let last = aUser.lastName
        if !first.isEmpty && !last.isEmpty{
                cell.textLabel?.text = "\(first) \(last)"
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = studentList[indexPath.row].mediaURL{
            if let url = URL(string: urlString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            print("no url")
        }
    }
}
