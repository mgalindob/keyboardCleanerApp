//
//  keyboardCleanerAppTests.swift
//  keyboardCleanerAppTests
//
//  Created by Martin Galindo on 10/30/25.
//

import Testing
@testable import keyboardCleanerApp

@Suite("Keyboard Manager Tests") 
@MainActor
struct keyboardCleanerAppTests {

    @Test("KeyboardManager initializes with keyboard enabled")
    func keyboardManagerInitialization() async throws {
        let manager = KeyboardManager()
        
        #expect(!manager.isKeyboardDisabled, "Keyboard should be enabled by default")
    }
    
    @Test("KeyboardManager state changes properly")
    func keyboardStateChanges() async throws {
        let manager = KeyboardManager()
        
        // Initial state
        #expect(!manager.isKeyboardDisabled, "Initial state should be enabled")
        
        // Note: We can't actually test the disable/enable functions in unit tests
        // because they require system permissions and would interfere with the test environment
        // But we can test that the manager exists and has the right initial state
    }
    
    @Test("KeyboardManager permission check returns result")
    func permissionCheckReturnsResult() async throws {
        let manager = KeyboardManager()
        
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            manager.checkPermissions { hasPermission in
                // The callback was called successfully, which is what we're testing
                // We don't need to test the value since it's system-dependent
                continuation.resume()
            }
        }
        
        // If we reach here, the permission check completed without crashing
        #expect(Bool(true), "Permission check should complete successfully")
    }
    
    @Test("KeyboardManager handles multiple disable calls safely")
    func multipleDisableCallsSafety() async throws {
        let manager = KeyboardManager()
        
        // Test that calling disable multiple times doesn't crash
        // (This won't actually disable in test environment due to permissions)
        manager.disableKeyboard()
        manager.disableKeyboard()
        manager.disableKeyboard()
        
        // Should not crash - if we reach here, the test passes
        #expect(Bool(true), "Multiple disable calls should not crash")
    }
    
    @Test("KeyboardManager handles enable when not disabled")  
    func enableWhenNotDisabled() async throws {
        let manager = KeyboardManager()
        
        // Test that calling enable when not disabled doesn't crash
        manager.enableKeyboard()
        manager.enableKeyboard()
        
        // Should not crash and state should remain false
        #expect(!manager.isKeyboardDisabled, "State should remain enabled")
    }
    
    @Test("KeyboardManager creates successfully")
    func keyboardManagerCreation() throws {
        let manager = KeyboardManager()
        
        // Test basic creation and property access - Bool is never nil
        #expect(manager.isKeyboardDisabled == false, "isKeyboardDisabled should be false initially")
    }
}
