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
    
   
    class func postLogin(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (code: String, msg: String, session_id: String, fName: String, lName: String, exhibitorId: String, eventID: String, companyId: String, companyName: String, eventTitle: String, eventLogo: String, q1: String, q2: String, q3: String, q4: String, q5: String) -> ()) {
        
        
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
                postCompleted(code: "Server Error", msg: "Please try Again later.", session_id: "", fName: "", lName: "", exhibitorId: "", eventID: "", companyId: "", companyName: "", eventTitle: "", eventLogo: "", q1: "", q2: "", q3: "", q4: "", q5: "" )
                
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
                        
                        let q1 =                parseResult["Note1Q"] as? String
                        let q2 =                parseResult["Note2Q"] as? String
                        let q3 =                parseResult["Note3Q"] as? String
                        let q4 =                parseResult["Note4Q"] as? String
                        let q5 =                parseResult["Note5Q"] as? String
                        
                        postCompleted(code: code!, msg: message!, session_id: session!, fName: fName!, lName: lName!, exhibitorId: exhibitorID!, eventID: eventID!, companyId: exhiCompID!, companyName: exhiCompName!, eventTitle: eventTitle!, eventLogo: eventLogo!, q1: q1!, q2: q2!, q3: q3!, q4: q4!, q5: q5!)
                        
                    }else {
                        postCompleted(code: code!, msg: message!, session_id: "", fName: "", lName: "", exhibitorId: "", eventID: "", companyId: "", companyName: "", eventTitle: "", eventLogo: "", q1: "", q2: "", q3: "", q4: "", q5: "")
                    }
                    
                    
                }else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(code: "Server Error", msg: "Please try Again later.", session_id: "", fName: "", lName: "", exhibitorId: "", eventID: "", companyId: "", companyName: "", eventTitle: "", eventLogo: "", q1: "", q2: "", q3: "", q4: "", q5: "")
                }
            }
            
        })
        
        task.resume()
    }


    class func fetchData(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (status: String, msg: String, fName: String, lName: String, orgName: String, position: String, mobile: String, note1: String, note2: String, note3: String, note4: String, note5: String) -> ()) {
        
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
                postCompleted(status: "Server Error", msg: "Can't get data", fName: "", lName: "", orgName: "", position: "", mobile: "", note1: "", note2: "", note3: "", note4: "", note5: "")
                
            }else {
                
                if let parseJSON = json {
                    let status = parseJSON["status"] as? String
                    var message = parseJSON["message"] as? String
                    let result = parseJSON["result"] as? NSDictionary
                    
                    if let parseResult = result {
                        
                        let fName =     parseResult["FirstName"] as? String
                        let lName =     parseResult["LastName"] as? String
                        let orgName =   parseResult["Organisation"] as? String
                        let position =  parseResult["Position"] as? String
                        let mobile =    parseResult["MobilePhone"] as? String
                        let note1 =     parseResult["Note1"] as? String
                        let note2 =     parseResult["Note2"] as? String
                        let note3 =     parseResult["Note3"] as? String
                        let note4 =     parseResult["Note4"] as? String
                        let note5 =     parseResult["Note5"] as? String
                        
                        postCompleted(status: status!, msg: message!, fName: fName!, lName: lName!, orgName: orgName!, position: position!, mobile: mobile!, note1: note1!, note2: note2!, note3: note3!, note4: note4!, note5: note5!)
                        
                    }else {
                        postCompleted(status: status!, msg: message!, fName: "", lName: "", orgName: "", position: "", mobile: "", note1: "", note2: "", note3: "", note4: "", note5: "")
                    }
                    
                }else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(status: "Server Error", msg: "Can't get data", fName: "", lName: "", orgName: "", position: "", mobile: "", note1: "", note2: "", note3: "", note4: "", note5: "")
                }
            }
        })
        task.resume()
    }
    
    class func postQuestion(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (status: String, msg: String, q1: String, q2: String, q3: String, q4: String, q5: String) -> ()) {
        
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
                postCompleted(status: "Server Error", msg: "Can't get data", q1: "", q2: "", q3: "", q4: "", q5: "")
                
            }else {
                
                if let parseJSON = json {
                    let status = parseJSON["status"] as? String
                    var message = parseJSON["message"] as? String
                    var result = parseJSON["result"] as? NSDictionary
                    
                    if let parseResult = result {
                        
                        let q1 =     parseResult["Note1Q"] as? String
                        let q2 =     parseResult["Note2Q"] as? String
                        let q3 =     parseResult["Note3Q"] as? String
                        let q4 =     parseResult["Note4Q"] as? String
                        let q5 =     parseResult["Note5Q"] as? String
                        
                        postCompleted(status: status!, msg: message!, q1: q1!, q2: q2!, q3: q3!, q4: q4!, q5: q5!)
                    }else {
                        postCompleted(status: status!, msg: message!, q1: "", q2: "", q3: "", q4: "", q5: "")
                    }
                    
                }else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(status: "Server Error", msg: "Can't get data", q1: "", q2: "", q3: "", q4: "", q5: "")
                }
            }
        })
        task.resume()
    }
    
    
    class func postAnswer(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (status: String, msg: String) -> ()) {
        
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
                postCompleted(status: "Server Error", msg: "Can't get data")
                
            }else {
                
                if let parseJSON = json {
                    let status = parseJSON["status"] as? String
                    var message = parseJSON["message"] as? String
                    var result = parseJSON["result"] as? NSDictionary
                    
                    if let parseResult = result {
                        
                        let q1 =     parseResult["Note1Q"] as? String
                        let q2 =     parseResult["Note2Q"] as? String
                        let q3 =     parseResult["Note3Q"] as? String
                        let q4 =     parseResult["Note4Q"] as? String
                        let q5 =     parseResult["Note5Q"] as? String
                        
                        postCompleted(status: status!, msg: message!)
                    }else {
                        postCompleted(status: status!, msg: message!)
                    }
                    
                }else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                    postCompleted(status: "Server Error", msg: "Can't get data")
                }
            }
        })
        task.resume()
    }
    
    
    class func postSignOut(params : Dictionary<String, AnyObject!>, url : String, postCompleted : (status: String, msg: String) -> ()) {
        
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
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
            
            var msg = "No message"

        })
        task.resume()
    }
    
}





