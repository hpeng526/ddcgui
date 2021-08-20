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
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var popover = NSPopover.init()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.prohibited)
        print("init finish")
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(systemSymbolName: "sun.max", accessibilityDescription: nil)
//        popover.animates = false
        popover.contentViewController = NSHostingController(rootView: ContentView())
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.behavior = .applicationDefined
        statusBarItem.button?.action = #selector(togglePopover(_:))
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        print("togglePopover")
        if let button = self.statusBarItem.button {
            print("botton toggle")
            if popover.isShown {
                print("close")
                popover.performClose(sender)
            } else {
                print("show")
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
