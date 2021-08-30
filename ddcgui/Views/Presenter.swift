//
//  Presenter.swift
//  ddcgui
//
//  Created by Peng Huang on 2021/7/29.
//

import Foundation

struct Monitor:Hashable {
    public var id: Int
    public var brightness = Float(30)
}

public final class DDCCtlPresenter: ObservableObject {
    
    let capturePattern = "[\\s\\S]*found (.*) external display[\\s\\S]*"
    
    static let instance = DDCCtlPresenter()
    
    @Published var monitorCount = 1
    
    var valueList: [Monitor]
    
    init() {
        //        value = 1
        valueList = [Monitor]()
        for i in 1...monitorCount {
            valueList.append(Monitor(id: i))
        }
    }
    
    func getValueList(idx: Int) -> Monitor {
        valueList.filter{$0.id == idx}.first!
    }
    
    func updateMonitor(count: Int) {
        if count >= 1 {
            print("updateMonitor \(count)")
            if monitorCount != count {
                monitorCount = count
                adjustList()
            }
        }
    }
    
    func adjustList() {
        if valueList.count > monitorCount {
            valueList = valueList.filter{$0.id <= monitorCount}
        }
        if valueList.count < monitorCount {
            let from = valueList.count+1
            for i in from...monitorCount {
                print("add \(i)")
                valueList.append(Monitor(id: i))
            }
        }
    }
    
    func setList(idx: Int, newVal: Float) {
        print(idx)
        let id = idx-1
        valueList[id].brightness = newVal
        execDDCCtlCmd(cmd: String(valueList[id].brightness), d: String(valueList[id].id))
    }
    
    //    func setValue(of newValue:Float) {
    //        print("set val")
    //        self.value = Int(newValue)
    //        execDDCCtlCmd(cmd: String(self.value), d: "1")
    //    }
    //
    /**
     D: CGDisplay 99AE8158-9783-8EF1-2611-03EE462B0378 dispID(#722491923) (2560x1440 0°) HiDPI
     D: CGDisplay 28CB857D-7540-1EB8-19F9-57485BDA9D41 dispID(#722490644) (1920x1080 0°) HiDPI
     I: found 2 external displays
     I: polling EDID for #2 (ID 722490644 => IOService:/AppleACPIPlatformExpert/PCI0@0/AppleACPIPCI/PEG0@1/IOPP/EGP0@0/IOPP/EGP1@0/IOPP/GFX0@0/AMDRadeonX6000_AmdRadeonControllerNavi14/ATY,Boa@2)
     I: got edid.serial: 9Q7XS83
     I: got edid.name: DELL U2720Q
     D: action: b: 100
     D: setting VCP control #16 => 100
     */
    func execDDCCtlCmd(cmd: String, d: String) {
        print("start exec sh cmd")
        let process = Process.init()
        let outPipe = Pipe()
        
        process.standardOutput = outPipe
        process.launchPath = "/usr/local/bin/ddcctl"
        process.arguments = ["-d", d, "-b", cmd]
        do {
            try process.run()
            process.waitUntilExit()
            guard process.terminationStatus == 0 else {
                print("exit not 0")
                return
            }
            print("output")
            let output = outPipe.fileHandleForReading.readDataToEndOfFile()
            let str = String(decoding: output, as: UTF8.self)
            //print("read: \(str)")
            
            let regex = try? NSRegularExpression(pattern: capturePattern, options: .caseInsensitive)
            if let matches = regex?.matches(in: str, options: [], range: NSRange(str.startIndex..<str.endIndex, in: str)) {
                print("matches \(matches.count)")
                for first in matches {
                    let get = String(str[Range(first.range(at: 1), in: str)!])
                    print("get \(get)")
                    updateMonitor(count: Int(get) ?? 1)
                }
                
            }
        } catch {
            print("error")
            return
        }
        
    }
}
