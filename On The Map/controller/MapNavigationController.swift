//
//  MapNavigationController.swift
//  On The Map
//
//  Created by Julien Laurent on 1/11/21.
//

import UIKit

class MapNavigationController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "On The Map"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_pin"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addPinButtonPress))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_refresh"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(refreshButtonPressed))
    }
    

    @objc func addPinButtonPress() {
        // MARK: - post a pin
    }
    
    @objc func refreshButtonPressed(){
        // MARK: - refresh here
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
