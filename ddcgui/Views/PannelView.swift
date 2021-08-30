//
//  PannelView.swift
//  ddcgui
//
//  Created by Peng Huang on 2021/7/30.
//

import SwiftUI

struct PannelView: View {
    @State private var isEditing = false
    @State private var tmpVal = Float(0.0)
    @ObservedObject public var presenter: DDCCtlPresenter
    public var idx: Int
    
    init(presenter cur: DDCCtlPresenter, idx index: Int) {
        presenter = cur
        print("init idx \(index)")
        idx = index
        
    }
    
    var body: some View {
        HStack {
            Text("M:\(self.idx) Brightness:").padding(.leading)
            TextField("Number", value: Binding(
                get: {
                    tmpVal
                },
                set: { newValue in
                    if newValue >= 1 && newValue <= 100 {
                        tmpVal = newValue
                    }
                }
            ), formatter: NumberFormatter())
            .onChange(of: "Number", perform: { newValue in
                print("text field change")
                presenter.setList(idx: idx, newVal: Float(newValue) ?? Float(1))
                //                presenter.setValue(of: Float(newValue)!)
            })
            .onAppear{
                print("init brightness \(presenter.getValueList(idx: idx).brightness)")
                tmpVal = presenter.getValueList(idx: idx).brightness
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: 60)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Spacer()
            
            Slider(
                value: Binding(
                    get: {
                        tmpVal
                    },
                    set: { newValue in
                        if newValue >= 1 && newValue <= 100 {
                            tmpVal = newValue
                        }
                    }
                ),
                in: 0...100,
                onEditingChanged: { editing in
                    print(editing)
                    isEditing = editing
                    if !isEditing {
                        presenter.setList(idx: idx, newVal: tmpVal)
                    }
                }
            )
            
            Spacer()
        }
    }
}

struct PannelView_Previews: PreviewProvider {
    static var previews: some View {
        PannelView(presenter: DDCCtlPresenter.instance, idx: 1)
    }
}
