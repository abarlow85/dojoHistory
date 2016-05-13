//
//  annotationInfoViewController.swift
//  dojoHistory
//
//  Created by Gabe Ratcliff on 5/13/16.
//  Copyright © 2016 Alec Barlow. All rights reserved.
//

import UIKit

class annotationInfoViewController: UIViewController {
    weak var backButtonDelegate: BackButtonDelegate?
    var locationToView: String?
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    @IBOutlet weak var pinBody: UILabel!
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        backButtonDelegate?.backButtonPressedFrom(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = locationToView!
        WikiModel.getInfo(locationToView!, completionHandler: { data, response, error in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    dispatch_async(dispatch_get_main_queue(), {
//                        print(jsonResult["query"])
                        let query = jsonResult["query"]!["pages"]! as! NSDictionary
                        let newQuery = query.allKeys[0]
                        let extract = query["\(newQuery)"]!["extract"]!
                        print(extract)
                        self.pinBody.text = extract as! String
                    })
                }
            }
            catch {
                print("You've failed")
            }
        })
    }

}