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
        let urlEnd = "\(query)&redirects="
        let url = NSURL(string: urlStart+urlEnd)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: completionHandler)
        task.resume()
        
    }
    
    
    
}
