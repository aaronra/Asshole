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
    
   
    class func postLogin(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (code: String, msg: String, session_id: String, fName: String, lName: String, exhibitorId: String, eventID: String, companyId: String, companyName: String, eventTitle: String, eventLogo: String ) -> ()) {
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var err: NSError?
        var bodyData = ""
        
        for param in params {
            bodyData += "\(param.0)=\(param.1)&"
        }
        
        println(bodyData)
    
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)

        var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            println("Response: \(response)")
            

            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(strData!)
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            if(err != nil) {
                println("Error--->>>>> \(err!.localizedDescription)")
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: \(jsonStr!.description)")
                postCompleted(code: "Server Error", msg: "Please try Again later.", session_id: "", fName: "", lName: "", exhibitorId: "", eventID: "", companyId: "", companyName: "", eventTitle: "", eventLogo: "" )
                
            }else {
                
                if let parseJSON = json {
                    let code = parseJSON["status"] as? String
                    var message = parseJSON["message"] as? String
                    let session = parseJSON["session_id"] as? String
                    let result = parseJSON["result"] as? NSDictionary
                    
                    if let parseResult = result {
                        
                        let exhibitorID =       parseResult["ExhibitorId"] as? String
                        let fName =             parseResult["ExhibitorFirstName"] as? String
                        let lName =             parseResult["ExhibitorLastName"] as? String
                        let primaryExhibitor =  parseResult["PrimaryExhibitor"] as? String
                        let accessEnabled =     parseResult["AccessEnabled"] as? String
                        let deviceID =          parseResult["DeviceId"] as? String
                        let deviceName =        parseResult["DeviceName"] as? String
                        let secureID =          parseResult["SecureId"] as? String
                        let exhiCompID =        parseResult["ExhibitorCompanyId"] as? String
                        let exhiCompName =      parseResult["ExhibitorCompanyName"] as? String
                        let eventID =           parseResult["EventId"] as? String
                        let eventCode =         parseResult["EventCode"] as? String
                        let eventTitle =        parseResult["EventTitle"] as? String
                        let eventLogo =         parseResult["EventLogo"] as? String
                        
                        postCompleted(code: code!, msg: message!, session_id: session!, fName: fName!, lName: lName!, exhibitorId: exhibitorID!, eventID: eventID!, companyId: exhiCompID!, companyName: exhiCompName!, eventTitle: eventTitle!, eventLogo: eventLogo! )
                        
                    }else {
                        postCompleted(code: code!, msg: message!, session_id: "", fName: "", lName: "", exhibitorId: "", eventID: "", companyId: "", companyName: "", eventTitle: "", eventLogo: "" )
                    }
                    
                    
                }else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(code: "Server Error", msg: "Please try Again later.", session_id: "", fName: "", lName: "", exhibitorId: "", eventID: "", companyId: "", companyName: "", eventTitle: "", eventLogo: "" )
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





