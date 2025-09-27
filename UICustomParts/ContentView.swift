//
//  ContentView.swift
//  UICustomParts
//
//  Created by rabbit on 2025/09/27.
//

import SwiftUI


struct ContentView: View {

    var body: some View {
        VStack {
            Selector { selected in
                print(selected)
            }
        }
//        .frame(width: 300, height: 100)

    }
}

#Preview("UI Custom Parts") {
    ContentView()
}

