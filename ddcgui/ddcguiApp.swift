//
//  ddcguiApp.swift
//  ddcgui
//
//  Created by Peng Huang on 2021/7/29.
//

import SwiftUI

@main
struct ddcguiApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover = NSPopover.init()

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("init finish")
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(systemSymbolName: "sun.max", accessibilityDescription: nil)
        popover.contentViewController = NSHostingController(rootView: ContentView())
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.behavior = .transient
        statusBarItem.button?.action = #selector(togglePopover(_:))
        NSApp.setActivationPolicy(.prohibited)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        
        if let button = self.statusBarItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
