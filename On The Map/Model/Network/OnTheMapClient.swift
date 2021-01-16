//
//  OnTheMapClient.swift
//  On The Map
//
//  Created by Julien Laurent on 1/12/21.
//

import Foundation
class OnTheMapClient {
    
    private init() {}
    
    private static var shareOnTheMapClient: OnTheMapClient = {
        let ontheMapClient = OnTheMapClient()
        return ontheMapClient
    }()

    class func shared() -> OnTheMapClient {
        return shareOnTheMapClient
    }

    struct Auth {
        static var sessionID: String? = nil
        static var key: String = ""
        static var expiration: String? = nil
        static var objectId = ""
        static var studentFirstName = ""
        static var studentLastName = ""
    }
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getLocationList
        case addLocation
        case upDateALocation
        case login
        case signUp
        case delete
        case userInfo
        

        var stringValue: String{
            switch self {
            case .getLocationList:
                return EndPoints.base + "/StudentLocation" //"/StudentLocation?limit=100"
            case .addLocation:
                return EndPoints.base + "/StudentLocation"
            case .upDateALocation:
                return EndPoints.base + "/StudentLocation/"+Auth.objectId
            case .login:
                return EndPoints.base + "/session"
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .delete:
                return EndPoints.base + "/session"
            case .userInfo:
                return EndPoints.base + "/users/" + Auth.key
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    class func login(userEmail: String, userPassword: String, completion: @escaping(Bool, Error?)->Void) {
       let body = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(userPassword)\"}}"
        TaskHelper.taskForPostRequest(url: EndPoints.login.url, responseType: LoginResponse.self, body: body, method: nil) { (response, error) in
            if let response = response{
                Auth.sessionID = response.session.id
                Auth.key = response.account.key
                completion(true, nil)
//                getLoginUserInfo { (success, error) in
//                    if success{
//                        print("sucessfully retrieve user info")
//                    }
//                }
                //MARK: test
                print("session id is retrieved \(Auth.sessionID!)")
            }else{
                completion(false, nil)
                print("unable to retrieve session id")
            }
        }
    }
    
    class func getLoginUserInfo(completion: @escaping (Bool, Error?)->Void) {
        TaskHelper.taskForGetRequest(url: EndPoints.userInfo.url, responseType: UserInfo.self) { (response, error) in
            if let response = response{
                Auth.studentFirstName = response.firstName
                Auth.studentLastName = response.lastName
                completion(true, nil)
            }else{
                print("no user data could be retrieve")
                completion(false, error)
            }
        }
    }
    
    
    class func logout() {
        var request = URLRequest(url: EndPoints.login.url)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if error != nil{
                print("error happen when trying to log out")
                return
            }
            Auth.sessionID = nil
            print(String(data: (data?.subdata(in: 5..<data!.count))!, encoding: .utf8)!)
            print("logout was successfull")
        }
        task.resume()
    }
    
    class func getUsersLocation(completion: @escaping([UserInfo]?, Error?)->Void) {
        TaskHelper.taskForGetRequest(url: EndPoints.getLocationList.url, responseType: UserInfo.self) { (response, error) in
            
//            if error != nil{
//                print("the error happen somewhere here")
//                print(error!)
//            }else{
//                print("no error happen there")
//            }
            
//            if let response = response{
//                completion(response, nil)
//
//            }else{
//                print("no locations is retrieve")
//                completion([], error)
//            }
        }
    }
}
