//
//  JsonToRealm.swift
//  StandTracker
//
//  Created by t0tep on 5/18/15.
//  Copyright (c) 2015 eventPallete. All rights reserved.
//

import UIKit

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
    
}
