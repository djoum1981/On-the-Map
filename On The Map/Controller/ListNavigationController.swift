//
//  ListNavigationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit

class ListNavigationController: UIViewController {
    
    @IBOutlet weak var userLocationsTBV: UITableView!
    var userInfoList = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocationsTBV.delegate = self
        userLocationsTBV.dataSource = self
        
        navigationItem.title = "On The Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "power"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(logoutPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_refresh"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(refreshButtonPressed))
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
        userInfoList.removeAll()
        OnTheMapClient.getUsersLocation(completion: {locations, error in
            DispatchQueue.main.async {
                self.userInfoList = locations ?? []
                self.userLocationsTBV.reloadData()
            }
        })
    }
    
    
    @objc func refreshButtonPressed(){
        getUsers()
    }
}

extension ListNavigationController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userInfoList.count)
        return userInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let aUser = userInfoList[indexPath.row]
        
        let first = aUser.firstName
        let last = aUser.lastName
            if first != "" && last != ""{
                cell.textLabel?.text = "\(first) \(last)"
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = userInfoList[indexPath.row].mediaURL{
            if let url = URL(string: urlString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            print("no url")
        }
    }
}
