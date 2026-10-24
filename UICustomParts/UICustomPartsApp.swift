//
//  UICustomPartsApp.swift
//  UICustomParts
//
//  Created by rabbit on 2025/09/27.
//

import SwiftUI

@main
struct UICustomPartsApp: App {
    var body: some Scene {
        Window("Sample", id: "main") {
            ContentView()
                .onAppear {
                    setWindowSize(widthRate: 0.5, heightRate: 0.8)
                }
        }
    }
    
    private func setWindowSize(widthRate: Double = 0.5, heightRate: Double = 0.5) {
            guard let screen = NSScreen.main else { return }
            let screenRect = screen.visibleFrame // The area excluding elements such as the menu bar
            
            let targetWidth = screenRect.width * widthRate
            let targetHeight = screenRect.height * heightRate
            
            if let window = NSApplication.shared.windows.first {
                let x = screenRect.origin.x + (screenRect.width - targetWidth) / 2
                let y = screenRect.origin.y + (screenRect.height - targetHeight) / 2
                
                let newRect = NSRect(x: x, y: y, width: targetWidth, height: targetHeight)
                window.setFrame(newRect, display: true, animate: true)
            }
        }
}
