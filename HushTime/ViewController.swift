//
//  ViewController.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/06/21.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    /*
     1. start to kill
     2. stop to open
     3. timer
     4. change timer in UI
     5. file finder
     6. notification
     7. Ads?
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startHushTime(_ sender: NSButton) {
        let appFinder = AppOpenerCloserImpl()
        appFinder.killApp(named: "Franz")
        appFinder.killApp(named: "Mail")
        appFinder.killApp(named: "Messages")
    }

    @IBAction func stopHushTime(_ sender: NSButton) {
        let appFinder = AppOpenerCloserImpl()
        appFinder.launchApp(named: "Franz")
        appFinder.launchApp(named: "Mail")
        appFinder.launchApp(named: "Messages")
    }
}

