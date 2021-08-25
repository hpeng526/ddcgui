//
//  ContentView.swift
//  ddcgui
//
//  Created by Peng Huang on 2021/7/29.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var presenter = DDCCtlPresenter.instance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Monitor Info ").padding(.leading)
                Spacer()
                Button(action: {
                    NSApp.terminate(self)
                }) {
                    Image(systemName: "xmark").frame(width: 15, height: 5, alignment: .center).foregroundColor(.white)
                }
                
                .background(Color.red)
                .cornerRadius(8)
                //                .frame(maxWidth: .infinity)
                //                .background(Color.red)
            }
            Divider()
            ForEach(presenter.valueList, id:\.self) { content in
                PannelView(presenter: presenter, idx:content.id)
            }
            
        }
        .padding(5)
//        .animation(.spring())
        .frame(width: 400)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
