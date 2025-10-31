//
//  KeyboardManager.swift
//  keyboardCleanerApp
//
//  Created by Martin Galindo on 10/30/25.
//

import Foundation
import ApplicationServices
import IOKit
import SwiftUI
import Combine

class KeyboardManager: ObservableObject {
    @Published var isKeyboardDisabled = false
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    func checkPermissions(completion: @escaping (Bool) -> Void) {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true]
        let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        DispatchQueue.main.async {
            completion(trusted)
        }
    }
    
    func disableKeyboard() {
        guard !isKeyboardDisabled else { return }
        
        // Check if we have accessibility permissions
        guard AXIsProcessTrusted() else {
            print("Accessibility permissions required")
            return
        }
        
        // Create event tap to intercept keyboard events
        let eventMask = (1 << CGEventType.keyDown.rawValue) | 
                       (1 << CGEventType.keyUp.rawValue) |
                       (1 << CGEventType.flagsChanged.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                // This callback intercepts and blocks keyboard events
                
                // Allow critical system shortcuts for safety
                if type == .keyDown || type == .keyUp {
                    let flags = event.flags
                    let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
                    
                    // Allow Command+Q, Command+Tab, Command+Space, etc.
                    if flags.contains(.maskCommand) {
                        // Allow common system shortcuts
                        switch keyCode {
                        case 12: // Command+Q
                            return Unmanaged.passUnretained(event)
                        case 48: // Command+Tab
                            return Unmanaged.passUnretained(event)
                        case 49: // Command+Space
                            return Unmanaged.passUnretained(event)
                        case 53: // Command+Esc
                            return Unmanaged.passUnretained(event)
                        default:
                            break
                        }
                    }
                    
                    // Allow Option+Command combinations (force quit, etc.)
                    if flags.contains(.maskCommand) && flags.contains(.maskAlternate) {
                        return Unmanaged.passUnretained(event)
                    }
                    
                    // Allow Control+Command combinations
                    if flags.contains(.maskCommand) && flags.contains(.maskControl) {
                        return Unmanaged.passUnretained(event)
                    }
                }
                
                // Allow modifier-only events
                if type == .flagsChanged {
                    return Unmanaged.passUnretained(event)
                }
                
                // Block all other keyboard events by returning nil
                print("Blocked keyboard event - type: \(type), keycode: \(event.getIntegerValueField(.keyboardEventKeycode))")
                return nil
            },
            userInfo: nil
        )
        
        guard let eventTap = eventTap else {
            print("Failed to create event tap")
            return
        }
        
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        DispatchQueue.main.async {
            self.isKeyboardDisabled = true
        }
        
        print("Keyboard disabled - use mouse/trackpad to control the app")
    }
    
    func enableKeyboard() {
        guard isKeyboardDisabled else { return }
        
        // Disable and clean up event tap
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            
            if let runLoopSource = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
                self.runLoopSource = nil
            }
            
            self.eventTap = nil
        }
        
        DispatchQueue.main.async {
            self.isKeyboardDisabled = false
        }
        
        print("Keyboard enabled - normal operation restored")
    }
    
    deinit {
        enableKeyboard()
    }
}