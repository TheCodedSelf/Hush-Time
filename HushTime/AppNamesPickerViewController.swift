//
//  AppNamesPickerViewController.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/07/23.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import Cocoa

class AppNamesPickerViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

struct AppNamesPicker {
    
    private let panel: NSOpenPanel = {
        
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["app"]
        panel.allowsMultipleSelection = true
        panel.prompt = NSLocalizedString("Select", comment: "")
        panel.message = NSLocalizedString("Choose applications to close", comment: "")
        return panel
    }()
    
    func pickAppNames(completionHandler: @escaping ([String]) -> ()) {
        
        guard let window = NSApplication.shared().mainWindow else { return }
        
        panel.beginSheetModal(for: window) { [panel = panel] in
            guard $0 == NSFileHandlingPanelOKButton else { return }
            let appNames = panel.urls.map { $0.deletingPathExtension().lastPathComponent }
            completionHandler(appNames)
        }
    }
}
