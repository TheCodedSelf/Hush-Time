//
//  TimeSelector.swift
//  HushTime
//
//  Created by Keegan Rush on 2017/07/16.
//  Copyright © 2017 TheCodedSelf. All rights reserved.
//

import AppKit

typealias Time = Measurement<UnitDuration>

class TimeSelector: NSView {
    
    //bind changes in the stepper to the textView and vice versa
    
    @IBOutlet private weak var mainView: NSView!
    @IBOutlet fileprivate weak var minuteTextField: NSTextField!
    @IBOutlet fileprivate weak var hourTextField: NSTextField!
    @IBOutlet fileprivate weak var hourStepper: NSStepper!
    @IBOutlet fileprivate weak var minuteStepper: NSStepper!
    
    var value: Time {
        return hours + minutes
    }
    
    private var hours: Time {
        return Measurement(value: Double(hourTextField.stringValue) ?? 0, unit: UnitDuration.hours)
    }
    
    
    private var minutes: Time {
        return Measurement(value: Double(minuteTextField.stringValue) ?? 0, unit: UnitDuration.minutes)
    }
    
    @IBAction func minutesChanged(_ sender: Any) {
        minuteTextField.integerValue = minuteStepper.integerValue
        resetIfInvalid()
    }
    
    @IBAction func hoursChanged(_ sender: Any) {
        hourTextField.integerValue = hourStepper.integerValue
        resetIfInvalid()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    fileprivate func resetIfInvalid() {
        resetHourTextIfNotValidHour()
        resetMinuteTextIfNotValidMinute()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed(String(describing: TimeSelector.self),
                                 owner: self,
                                 topLevelObjects: nil)
        mainView.frame = bounds
        mainView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        layer?.backgroundColor = CGColor.black
        addSubview(mainView)
        layoutSubtreeIfNeeded()
        minuteTextField.delegate = self
        hourTextField.delegate = self
        hourStepper.minValue = 0
        minuteStepper.minValue = 0
        minuteStepper.maxValue = 59
    }
    
    private func resetHourTextIfNotValidHour() {
        
        reset(textField: hourTextField, stepper: hourStepper, ifNot: { $0 > -1} )
    }
    
    private func resetMinuteTextIfNotValidMinute() {
        
        reset(textField: minuteTextField, stepper: minuteStepper, ifNot: { $0 < 60 && $0 > -1 })
    }
    
    private func reset(textField: NSTextField, stepper: NSStepper, ifNot valid: (Int) -> Bool) {
        
        if let field = Int(textField.stringValue), valid(field) {
        } else {
            textField.integerValue = 0
        }
        
        stepper.integerValue = textField.integerValue
        if textField.stringValue.characters.count == 1 {
            textField.stringValue = "0" + textField.stringValue
        }
    }
    
}

extension TimeSelector: NSTextFieldDelegate {
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        resetIfInvalid()
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField == hourTextField {
            if let hour = Int(textField.stringValue) {
                hourStepper.integerValue = hour
            }
        } else if textField == minuteTextField {
            if let minute = Int(textField.stringValue) {
                minuteStepper.integerValue = minute
            }
        }
    }
    
}
