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
    
    typealias RemainingSeconds = Int
    
    private let appNames: [String]
    private let updateStatus: (RemainingSeconds) -> ()
    private var secondsRemaining: Int
    
    init(appNames: [String],
         durationInSeconds: Int,
         fireOnUpdate:@escaping (RemainingSeconds) -> ()) {
        self.appNames = appNames
        self.secondsRemaining = durationInSeconds
        self.updateStatus = fireOnUpdate
    }
    
    func start(with appOpenerCloser: AppOpenerCloser = AppOpenerCloserImpl()) {
        
        killApps()
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            if self.secondsRemaining < 1 {
                timer.invalidate()
                self.launchApps()
                return
            }
            self.secondsRemaining -= 1
            self.updateStatus(self.secondsRemaining)
        }
    }
    
    func finish(with appOpenerCloser: AppOpenerCloser = AppOpenerCloserImpl()) {
        secondsRemaining = 0
        updateStatus(secondsRemaining)
        launchApps(with: appOpenerCloser)
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
