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
    @IBOutlet private weak var selectedAppsSourceList: NSOutlineView!

    //Store this in an ordered set? Maybe use ordered set on will set? Maybe have a separate ordered set var and when that's updated then update this array?
    fileprivate var selectedApps = [String]() {
        didSet {
            selectedAppsSourceList.reloadData()
        }
    }
    
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
     7. Pretty the UI
     8. Icons next to selected apps
 */
    
    override func viewWillAppear() {
        super.viewWillAppear()
        configureViewForCurrentState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAppsSourceList.dataSource = self
        selectedAppsSourceList.delegate = self
    }

    @IBAction func startHushTime(_ sender: NSButton) {
        startHushTimeBlock()
    }
    
    private func startHushTimeBlock() {
        
        //TODO what about when time is on 0
        state = .running
        
        remainingTime = timeSelector.value
        
        ProcessInfo.processInfo.disableAutomaticTermination("A timer is running")
        
        hushTimeBlock = HushTimeBlock(appNames: selectedApps,
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
    
    @IBAction func addAppClicked(_ sender: Any) {
        AppNamesPicker().pickAppNames{ self.selectedApps = $0 }
    }
    
    @IBAction func removeAppClicked(_ sender: Any) {
        
        selectedApps = selectedApps.filter {
            !self.selectedAppsSourceList.isRowSelected(self.selectedApps.index(of: $0) ?? -1)
        }
        selectedAppsSourceList.deselectAll(self)
    }

    private func configureViewForCurrentState() {
        
        let isRunning = state == .running
        remainingTimeLabel.isHidden = !isRunning
        timeSelector.isHidden = isRunning
        selectedAppsSourceList.allowsMultipleSelection = true
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

extension ViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool {
        return false
    }
}
extension ViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return selectedApps.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return selectedApps[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        return item
    }
    
}
