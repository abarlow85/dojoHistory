//
//  ViewController.swift
//  dojoHistory
//
//  Created by Alec Barlow on 5/12/16.
//  Copyright © 2016 Alec Barlow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        placesNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func placesNotification () {
        // create a corresponding local notification
        var notification = UILocalNotification()
        notification.alertBody = "this is a new place" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate(timeIntervalSinceNow: 10) // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["test": "test place"] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "PLACES_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    
    
}

