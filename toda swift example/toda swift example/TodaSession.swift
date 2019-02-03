//
//  TodaSession.swift
//  l00tqstr
//
//  Created by Humberto Roa on 2/2/19.
//  Copyright © 2019 Humberto Roa. All rights reserved.
//

import Foundation

extension Data {
    /// Append string to Data
    /// - parameter string: The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

enum RequestError: Error {
    case unknownError               // An unknown error occured.
    case invalidUrl                 // The address of the host is invalid.
    case invalidSessionURL          // The session url is nil.
    case hostNotReachable           // The host cannot be reached.
    case noInternetConnection       // There is no internet connection to make the request.
    case noResultData               // There is no data in the response.
    case invalidResultData          // The data in the  response is not readable.
    case httpsRequired              // The host requires https.
    case httpsNotSupported          // The host does not support https connections.
    case unhandledError             // An unhandled error occured.
}

struct RequestData{
    var data: [String: Any]
}


enum RequestResult{
    case success(result: RequestData)                // The result was successful
    case requestError(error:RequestError)      // There was an error making the request
    case responseError(error: RequestError)    // The request was successful, but the response contains an error
}

let apiURL = "https://api.todaqfinance.net";
let apiKey = "9a2bba11-0979-44f5-95fc-9c4fb5c6b29d";

enum EndPoints: String {
    case accountsUrl = "https://api.todaqfinance.net/accounts"
    case transactionsUrl = "https://api.todaqfinance.net/transactions"
    case filesUrl = "https://api.todaqfinance.net/files"
}

typealias completeClosure = ( _ result: RequestResult?, _ response: HTTPURLResponse?) -> Void

class Session{
    static func getAccounts(callback: @escaping completeClosure){
        let urlString = "\(EndPoints.accountsUrl.rawValue)?filter[active]=true&page=1&limit=10"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                if let response = response as? HTTPURLResponse {
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
    static func createAccount(accountData: [String: Any], callback: @escaping completeClosure){
        let urlString = "\(EndPoints.accountsUrl.rawValue)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: accountData)
        print(String(data: jsonData as! Data, encoding: .utf8)!)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                if let response = response as? HTTPURLResponse {
                    print(String(data: responseData as! Data, encoding: .utf8)!)
                    
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
    static func createFile(fileData: [String: Any], callback: @escaping completeClosure){
        let urlString = "\(EndPoints.filesUrl.rawValue)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: fileData)
        print(String(data: jsonData as! Data, encoding: .utf8)!)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                if let response = response as? HTTPURLResponse {
                    print(String(data: responseData as! Data, encoding: .utf8)!)
                    
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
    static func getFile(id: String, callback: @escaping completeClosure){
        let urlString = "\(EndPoints.filesUrl.rawValue)/\(id)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                if let response = response as? HTTPURLResponse {
                    print(String(data: responseData as! Data, encoding: .utf8)!)
                    
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
    static func getAccountFiles(id: String, callback: @escaping completeClosure){
        let urlString = "\(EndPoints.accountsUrl.rawValue)/\(id)/files?page=1&limit=100"
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                print(String(data: responseData as! Data, encoding: .utf8)!)
                
                if let response = response as? HTTPURLResponse {
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
    static func transferFile(transactionData: [String: Any], callback: @escaping completeClosure){
        let urlString = "\(EndPoints.transactionsUrl.rawValue)/"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: transactionData)
        print(String(data: jsonData as! Data, encoding: .utf8)!)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                if let response = response as? HTTPURLResponse {
                    print(String(data: responseData , encoding: .utf8)!)
                    
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
    
    static func getTransaction(id: String, callback: @escaping completeClosure){
        let urlString = "\(EndPoints.transactionsUrl.rawValue)/\(id)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {(data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error making request")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                if let response = response as? HTTPURLResponse {
                    print(String(data: responseData , encoding: .utf8)!)
                    
                    guard let todaData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                    }
                    
                    callback(RequestResult.success(result: RequestData(data: todaData)), response)
                } else {
                    print("Unknown error")
                    return
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
            
        }
        task.resume()
    }
    
}

