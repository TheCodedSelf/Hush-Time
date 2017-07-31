//
//  HushTimeBlock.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/06/21.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Foundation
import AppKit

class HushTimeBlock {
    
    private let appNames: [String]
    private let updateStatus: (Time) -> ()
    private var finishTime: Date
    private var timer: Timer?
    private let appOpenerCloser = AppOpenerCloser()
    
    init(appNames: [String],
         time: Time,
         fireOnUpdate:@escaping (Time) -> ()) {
        
        self.appNames = appNames
        self.updateStatus = fireOnUpdate
        
        let durationInSeconds: TimeInterval = time.converted(to: .seconds).value
        self.finishTime = Date(timeIntervalSinceNow: durationInSeconds)
    }
    
    func start() {
        
        killApps()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { _ in
            
            let secondsRemaining =  self.finishTime.timeIntervalSince(Date())
            if secondsRemaining < 1 {
                self.finish()
            } else {
                self.updateStatus(Measurement(value: secondsRemaining, unit: UnitDuration.seconds))
            }
        }
    }
    
    func finish() {
        timer?.invalidate()
        launchApps()
        updateStatus(Measurement(value: 0, unit: UnitDuration.seconds))
    }
    
    private func killApps() {
        
        DispatchQueue.global().async {
            self.appNames.forEach(self.appOpenerCloser.killApp)
        }
    }
    
    private func launchApps() {
        
        DispatchQueue.global().async {
            self.appNames.forEach {
                self.appOpenerCloser.launchApp(named: $0, in: NSWorkspace.shared())
            }
        }
    }
}
