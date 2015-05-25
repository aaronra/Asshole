//
//  JsonToRealm.swift
//  StandTracker
//
//  Created by t0tep on 5/18/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit
import Realm

public class JsonToRealm {
   
    class func postLogin(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (code: Int, msg: String, sessionID: String, clientID: String) -> ()) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr!.description)'")
                postCompleted(code: 500, msg: "Error", sessionID: "", clientID: "")
            }else {
                
                if let parseJSON = json {
                    if let code = parseJSON["code"] as? Int {
                        if let errorMsg = parseJSON["message"] as? String {
                            if let sesID = parseJSON["sessionID"] as? String {
                                if let cliID = parseJSON["clientID"] as? String {
                                    postCompleted(code: code, msg: errorMsg, sessionID: sesID, clientID: cliID)
                                }
                            }
                        }
                    }
                    
                }else {
                    
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(code: 500, msg: "Error", sessionID: "", clientID: "")
                }
            }
            
        })
        task.resume()
    }
    
    
    
    class func fetchData(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (code: String, details: [String], sessionID: String, clientID: String) -> ()) {
        
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr!.description)'")
                postCompleted(code: "Error", details: ["Error"], sessionID: "", clientID: "")
            }else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    if let code = parseJSON["status"] as? String {

                        let result = parseJSON["result"] as? NSDictionary
                        var newArray = Array<String>()
                        
                        if let parseResult = result {
                            let firstName = parseResult["FirstName"] as? String
                            let lastName = parseResult["LastName"] as? String
                            let organisation = parseResult["Organisation"] as? String
                            let position = parseResult["Position"] as? String
                            let mobile = parseResult["MobilePhone"] as? String
                            
                            newArray.append(firstName!)
                            newArray.append(lastName!)
                            newArray.append(organisation!)
                            newArray.append(position!)
                            newArray.append(mobile!)
                            
                            postCompleted(code: code, details: newArray, sessionID: "", clientID: "")
                            
                        }
                    }
                    
                    
                }else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        task.resume()
    }
}
