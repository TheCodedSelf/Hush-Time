//
//  ViewController.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/06/21.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var remainingTimeLabel: NSTextField!
    
    private var remainingSeconds = 25 * 60 {
        didSet {
            let minutes = "\(remainingSeconds / 60)"
            var seconds = "\(remainingSeconds % 60)"
            let secondsValueIsOnlySingleDigit = seconds.characters.count < 2
            if secondsValueIsOnlySingleDigit {
                seconds = "0\(seconds)"
            }
            remainingTimeLabel.stringValue = "\(minutes):\(seconds)"
        }
    }
    
    private var hushTimeBlock: HushTimeBlock?
    /*
     1. start to kill
     2. stop to open
     3. timer
     -. Show timer in ui
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
        
        hushTimeBlock = HushTimeBlock(appNames: ["Franz", "Mail", "Messages"],
                                      durationInSeconds: 25*60,
                                      fireOnUpdate: { [weak self] remainingSeconds in
                                        self?.remainingSeconds = remainingSeconds
        })
        
        hushTimeBlock?.start()
    }

    @IBAction func stopHushTime(_ sender: NSButton) {
        hushTimeBlock?.finish()
    }
}

