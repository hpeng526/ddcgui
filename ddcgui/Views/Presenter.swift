//
//  Presenter.swift
//  ddcgui
//
//  Created by Peng Huang on 2021/7/29.
//

import Foundation

public final class DDCCtlPresenter: ObservableObject {
    static let instance = DDCCtlPresenter()
    
    @Published var value = 10
    
    func setValue(of newValue:Float) {
        print("set val")
        self.value = Int(newValue)
        execDDCCtlCmd(cmd: String(self.value))
    }
    
    func execDDCCtlCmd(cmd: String) {
        print("start exec sh cmd")
        let shTask = Process.launchedProcess(launchPath: "/usr/local/bin/ddcctl", arguments: ["-d", "1", "-b", cmd])
        shTask.waitUntilExit()
    }
}
