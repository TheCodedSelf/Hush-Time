//
//  ViewController.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/06/21.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Cocoa

private enum State {
    case running
    case notRunning
}

class ViewController: NSViewController {

    @IBOutlet private weak var timeSelector: TimeSelector!
    @IBOutlet private weak var remainingTimeLabel: NSTextField!
    
    private var state: State = .notRunning {
        didSet {
            configureViewForCurrentState()
        }
    }
    
    private var remainingTime = Measurement(value: 25, unit: UnitDuration.minutes) {
        didSet {
            configureViewForRemainingSeconds()
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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        configureViewForCurrentState()
    }

    @IBAction func startHushTime(_ sender: NSButton) {
        //TODO what about when time is on 0
        state = .running
        
        remainingTime = timeSelector.value
        
        ProcessInfo.processInfo.disableAutomaticTermination("A timer is running")
        
        hushTimeBlock = HushTimeBlock(appNames: ["Franz", "Mail", "Messages"],
                                      time: timeSelector.value,
                                      fireOnUpdate: { [weak self] in
                                        self?.remainingTime = $0
        })
        
        hushTimeBlock?.start()
    }

    @IBAction func stopHushTime(_ sender: NSButton) {
        
        ProcessInfo.processInfo.enableAutomaticTermination("The timer is complete")
        hushTimeBlock?.finish()
        state = .notRunning
    }
    
    private func configureViewForCurrentState() {
        
        let isRunning = state == .running
        remainingTimeLabel.isHidden = !isRunning
        timeSelector.isHidden = isRunning
    }
    
    private func configureViewForRemainingSeconds() {
        
        guard remainingTime.value > 0 else {
            state = .notRunning
            return
        }
        
        let hours = Int(remainingTime.converted(to: .hours).value)
        let minutes = Int(remainingTime.converted(to: .minutes).value
            .truncatingRemainder(dividingBy: 60))
        let seconds = Int(remainingTime.converted(to: .seconds).value
            .truncatingRemainder(dividingBy: 60))

        func leftPadded(_ integer: Int) -> String {
            let string = "\(integer)"
            let isOnlySingleDigit = string.characters.count < 2
            return isOnlySingleDigit ? "0\(string)" : string
        }
        
        remainingTimeLabel.stringValue =
        "\(leftPadded(hours)):\(leftPadded(minutes)):\(leftPadded(seconds))"
    }
}

