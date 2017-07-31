//
//  AppFinder.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/06/21.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Foundation
import AppKit

class AppOpenerCloser {
    
    private var killedApps = [String]()
    
    func launchApp(named name: String, in workspace: NSWorkspace = NSWorkspace.shared()) {
        guard killedApps.contains(name) else { return }
        workspace.launchApplication(name)
    }
    
    func killApp(named appName: String) {
        
        guard isAppOpen(named: appName) else {
            return
        }
        
        killedApps.append(appName)
        
        var errorInfo: NSDictionary?
        if let scriptObject = NSAppleScript(source: "quit app \"\(appName).app\"") {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&errorInfo)
            if let outputString = output.stringValue {
                print(outputString)
            }
            if let errorInfo = errorInfo {
                print("Error closing app: \(errorInfo)")
            }
        }
    }
    
    private func isAppOpen(named appName: String) -> Bool {
        
        var errorInfo: NSDictionary?
        
        guard let scriptObject = NSAppleScript(source: "tell application \"System Events\" to (name of processes) contains \"\(appName)\"") else {
            return true
        }
        
        let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&errorInfo)
        if let errorInfo = errorInfo {
            print("Error closing app: \(errorInfo)")
            return true
        } else {
            return output.booleanValue
        }
    }
}
