//
//  AppFinder.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/06/21.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Foundation
import AppKit

protocol AppOpenerCloser {
    func killApp(path: String)
    func launchApp(named: String)
}

struct AppOpenerCloserImpl {
    
    func launchApp(named name: String, in workspace: NSWorkspace = NSWorkspace.shared()) {
        workspace.launchApplication(name)
    }
    
    func killApp(named appName: String) {
        
        let myAppleScript = "quit app \"\(appName).app\""
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            if let outputString = output.stringValue {
                print(outputString)
            }
            if let error = error {
                print("error: \(error)")
            }
        }
    }
}
