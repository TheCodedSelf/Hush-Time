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
    
    init(appNames: [String],
         time: Time,
         fireOnUpdate:@escaping (Time) -> ()) {
        
        self.appNames = appNames
        self.updateStatus = fireOnUpdate
        
        let durationInSeconds: TimeInterval = time.converted(to: .seconds).value
        self.finishTime = Date(timeIntervalSinceNow: durationInSeconds)
    }
    
    func start(with appOpenerCloser: AppOpenerCloser = AppOpenerCloserImpl()) {
        
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
    
    func finish(with appOpenerCloser: AppOpenerCloser = AppOpenerCloserImpl()) {
        timer?.invalidate()
        launchApps(with: appOpenerCloser)
        updateStatus(Measurement(value: 0, unit: UnitDuration.seconds))
    }
    
    private func killApps(with appOpenerCloser: AppOpenerCloser = AppOpenerCloserImpl()) {
        
        DispatchQueue.global().async {
            self.appNames.forEach(appOpenerCloser.killApp)
        }
    }
    
    private func launchApps(with appOpenerCloser: AppOpenerCloser = AppOpenerCloserImpl()) {
        
        DispatchQueue.global().async {
            self.appNames.forEach { appOpenerCloser.launchApp(named: $0, in: NSWorkspace.shared()) }
        }
    }
}
