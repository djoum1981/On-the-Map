//
//  TaskHelper.swift
//  On The Map
//
//  Created by Julien Laurent on 1/13/21.
//

import Foundation
class TaskHelper {
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping(ResponseType?, Error?)->Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //will use to post or put with string input
    class func taskForPostRequest<ResponseType: Decodable>(url: URL, login: Bool, responseType: ResponseType.Type, body: String, method: String?, completion: @escaping(ResponseType?, Error?)->Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method == "PUT" ? "PUT" : "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil{
                print("error happen in \(#function) and the error is: \(error!)")
                completion(nil, error)
            }
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            print("this is how the data look like \(String(data: data, encoding: .utf8) ?? "")")
            print("decoding")
            do{
                let decodedData = try JSONDecoder().decode(responseType.self, from: data)
                print("this is the decoded data: \(decodedData)")
            }catch{
                print(error)
            }
            
            
            do{
                if login{
                    let newData = data.subdata(in: 5..<data.count)
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                    print("this is the decoded new data \(responseObject)")
                    
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }else{
                    let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                    print("this is the decoded new data \(responseObject)")
                    
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
            
        }
        task.resume()
    }
}



