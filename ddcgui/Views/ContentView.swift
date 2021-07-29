//
//  ContentView.swift
//  ddcgui
//
//  Created by Peng Huang on 2021/7/29.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var presenter = DDCCtlPresenter.instance
    @State private var isEditing = false
    @State private var tmpVal = Float(0.0)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Brightness:").padding(.leading)
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
                    presenter.setValue(of: Float(newValue)!)
                })
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
                            if !isEditing {
                                presenter.setValue(of: tmpVal)
                            }
                        }
                    ),
                    in: 0...100,
                    onEditingChanged: { editing in
                        print(editing)
                        isEditing = editing
                        if !isEditing {
                            presenter.setValue(of: tmpVal)
                        }
                    }
                )
                
                Button(action: {
                    NSApp.terminate(self)
                }) {
                    Text("Quit")
                        .frame(maxWidth: 40, maxHeight: 30)
                        .foregroundColor(.white)
                    
                }
                .background(Color.red)
                .cornerRadius(6.0)
                Spacer()
            }
        }
        .frame(width: 400, height: 30)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
