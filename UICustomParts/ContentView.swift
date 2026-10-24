//
//  ContentView.swift
//  UICustomParts
//
//  Created by rabbit on 2025/09/27.
//

import SwiftUI

enum SegmentEnum: String, SegmentPickerElement {
    case one    = "001"
    case two    = "002"
    case three  = "003"
}

struct ContentView: View {
    @State private var selectedSegment: SegmentEnum = .one
    @State private var selectedDate = Date()

    var body: some View {
        
        ScrollView {
            contents
        }
    }
    
    private var contents: some View {
        VStack {
            
            VStack {
                customName("Segment Picker")
                
                Text("SELECT : \(selectedSegment.rawValue)")
                    .font(.title3)
                    .padding()
                
                SegmentPicker(
                    selectedSegment: $selectedSegment
                )
                .frame(width: 300, height: 30)
            }
            .padding()
            
            
            Divider()
            
            
            VStack(spacing: 10) {
                customName("Year Month Picker")
                
                Text("SELECT : \(selectedDate, formatter: dateFormatter)")
                    .font(.title3)
                    .padding()
                
                let startYear = 2025
                let startMonth = 4
                let stopYear = 2030
                let stopMonth = 3
                
                Text(verbatim: "RANGE : \(startYear)/\(startMonth) - \(stopYear)/\(stopMonth)")
                
                YearMonthPicker(selectedDate: $selectedDate,
                                startYear: startYear, startMonth: startMonth,
                                stopYear: stopYear, stopMonth: stopMonth)
                .frame(width: 200)
                
            }
            .padding()
            .padding(.bottom, 200)
            
        }
        
    }
    
    private func customName(_ name: String) -> some View {
        Text("- \(name) -")
            .font(.system(size: 20))
            .foregroundColor(.orange)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        return formatter
    }

}

#Preview("UI Custom Parts") {
    ContentView()
}

