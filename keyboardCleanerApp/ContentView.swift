//
//  ContentView.swift
//  keyboardCleanerApp
//
//  Created by Martin Galindo on 10/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var keyboardManager = KeyboardManager()
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 10) {
                Image(systemName: keyboardManager.isKeyboardDisabled ? "keyboard.badge.waveform.fill" : "keyboard")
                    .font(.system(size: 60))
                    .foregroundStyle(keyboardManager.isKeyboardDisabled ? .red : .primary)
                
                Text("Keyboard Cleaner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            // Status Display
            VStack(spacing: 15) {
                HStack {
                    Circle()
                        .fill(keyboardManager.isKeyboardDisabled ? Color.red : Color.green)
                        .frame(width: 12, height: 12)
                    
                    Text("Keyboard Status:")
                        .font(.headline)
                    
                    Text(keyboardManager.isKeyboardDisabled ? "DISABLED" : "ENABLED")
                        .font(.headline)
                        .foregroundStyle(keyboardManager.isKeyboardDisabled ? .red : .green)
                        .fontWeight(.bold)
                }
                
                if keyboardManager.isKeyboardDisabled {
                    Text("🧽 Safe to clean your keyboard!")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Control Buttons
            VStack(spacing: 15) {
                Button(action: {
                    if keyboardManager.isKeyboardDisabled {
                        keyboardManager.enableKeyboard()
                    } else {
                        keyboardManager.disableKeyboard()
                    }
                }) {
                    HStack {
                        Image(systemName: keyboardManager.isKeyboardDisabled ? "keyboard" : "keyboard.badge.waveform")
                        Text(keyboardManager.isKeyboardDisabled ? "Enable Keyboard" : "Disable Keyboard")
                    }
                    .frame(maxWidth: 200)
                    .padding()
                    .background(keyboardManager.isKeyboardDisabled ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
                }
                .buttonStyle(.plain)
                
                if keyboardManager.isKeyboardDisabled {
                    Text("⚠️ Use mouse/trackpad to re-enable")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Instructions
            VStack(alignment: .leading, spacing: 5) {
                Text("Instructions:")
                    .font(.headline)
                
                Text("1. Click 'Disable Keyboard' before cleaning")
                Text("2. Clean your keyboard safely")
                Text("3. Use mouse/trackpad to click 'Enable Keyboard'")
                Text("4. Your keyboard will work normally again")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding(40)
        .frame(minWidth: 400, minHeight: 500)
        .alert("Permission Required", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("This app requires accessibility permissions to disable the keyboard. Please grant permission in System Preferences > Privacy & Security > Accessibility.")
        }
        .onAppear {
            keyboardManager.checkPermissions { hasPermission in
                if !hasPermission {
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
