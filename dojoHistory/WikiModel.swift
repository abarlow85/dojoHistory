//
//  WikiModel.swift
//  dojoHistory
//
//  Created by Alec Barlow on 5/13/16.
//  Copyright © 2016 Alec Barlow. All rights reserved.
//

import Foundation

class WikiModel {
    
    static func getInfo(query: String, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        
        let urlStart = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=1&exintro&titles="
        var end = ""
        for i in query.characters{
            if (i == " "){
                end += "%20"
            }
            else{
            end = end + String(i)
            }
        }
        let urlEnd = "\(end)&redirects="
        let url = urlStart + urlEnd
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: url)!, completionHandler: completionHandler)
        task.resume()
        
    }
    
    
    
}
