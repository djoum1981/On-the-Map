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
        static var studentFirstName = "John"
        static var studentLastName = "Louis"
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
                return EndPoints.base +  "/StudentLocation?limit=100"
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
        TaskHelper.taskForPostRequest(url: EndPoints.login.url, login: true, responseType: LoginResponse.self, body: body, method: nil) { (response, error) in
            if let response = response{
                Auth.sessionID = response.session.id
                Auth.key = response.account.key
                completion(true, nil)
            }else{
                completion(false, nil)
                print("unable to retrieve session id")
            }
        }
    }
    
    class func getLoginUserInfo(completion: @escaping (Bool, Error?)->Void) {
        TaskHelper.taskForGetRequest(url: EndPoints.userInfo.url, responseType: StudentInformation.self) { (response, error) in
            if let response = response{
                Auth.studentFirstName = response.firstName
                Auth.studentLastName = response.lastName
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            }else{
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
        }
        task.resume()
    }
    
    // to get user location
    class func getUsersLocation(completion: @escaping([StudentInformation]?, Error?)->Void) {
        TaskHelper.taskForGetRequest(url: EndPoints.getLocationList.url, responseType: StudentLocations.self) { (response, error) in
                if let response = response{
                    completion(response.results?.sorted(), nil)
            }else{
                completion([], error)
            }
        }
    }
    
    
    // to post user location
    class func postUserLocation(userInfo: StudentInformation, completion: @escaping (Bool, Error?)->Void ) {
        
        let body = "{\"firstName\":\"\(userInfo.firstName )\",\"lastName\":\"\(userInfo.lastName )\",\"longitude\":\(userInfo.longitude ?? 0.0),\"latitude\": \(userInfo.latitude ?? 0.0),\"mapString\":\"\(userInfo.mapString ?? "")\",\"mediaURL\": \"\(userInfo.mediaURL ?? "")\",\"uniqueKey\":\"\(userInfo.uniqueKey ?? "")\"}"
        
        TaskHelper.taskForPostRequest(url: EndPoints.addLocation.url, login: false, responseType: PostLocationResponse.self, body: body, method: nil) { (response, error) in
            
            if let response = response{
                Auth.objectId = response.objectID
                completion(true, nil)
                print(response)
            }else{
                completion(false, error)
            }
        }
    }
    
    // to update location
    class func updateUserLocation(userInfo: StudentInformation, completion: @escaping(Bool, Error?)->Void){
        let body  = "{\"uniqueKey\": \"\(userInfo.uniqueKey ?? "")\", \"firstName\": \"\(userInfo.firstName )\", \"lastName\": \"\(userInfo.lastName )\",\"mapString\": \"\(userInfo.mapString ?? "")\", \"mediaURL\": \"\(userInfo.mediaURL ?? "")\",\"latitude\": \(userInfo.latitude ?? 0.0), \"longitude\": \(userInfo.longitude ?? 0.0)}"
        
        TaskHelper.taskForPostRequest(url: EndPoints.upDateALocation.url, login: false, responseType:UpdateResponse.self, body: body, method: "PUT") { (response, error) in
            if error != nil{
                print("*** Error in \(#function):\n \(error?.localizedDescription ?? "")")
                return
            }
            if let response = response, response.updatedAt != nil{
                completion(true, nil)
            }else{
                completion(false, error)
            }
        }
    }
}
