//
//  YearMonthPicker.swift
//  UICustomParts
//
//  Created by rabbit on 2026/10/22.
//

import SwiftUI

struct YearMonthPicker: View {
    @Binding var selectedDate: Date
    
    @State private var isShowingModal = false
    @State private var currentYear: Int
    @State private var currentMonth: Int
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let ym = YearMonthPicker.getNowYearMonth()
        self._currentYear = State(initialValue: ym.year)
        self._currentMonth = State(initialValue: ym.month)
    }
    
    var body: some View {
        
        HStack {
            Button("Now") {
                let ym = YearMonthPicker.getNowYearMonth()
                currentYear = ym.year
                currentMonth = ym.month
            }
            .frame(width: 50, alignment: .center)
            
            Text("\(selectedDate, formatter: dateFormatter)")
                .frame(width: 80, alignment: .center)
                .font(.system(size: 14))
                .monospaced()
                .onTapGesture { isShowingModal = true }
            
            Button("<") { addMonth(-1) }
            .frame(width: 30, alignment: .center)

            Button(">") { addMonth(1) }
            .frame(width: 30, alignment: .center)
        }
        .focusEffectDisabled()
        .popover(
            isPresented: $isShowingModal,
            attachmentAnchor: .rect(.bounds),
            arrowEdge: .bottom) {
            YearMonthSelector(
                year: currentYear,
                month: currentMonth,
                onSelect: { newYear, newMonth in
                    currentYear = newYear
                    currentMonth = newMonth
                    isShowingModal = false
                }
            )
        }
        .onChange(of: [currentYear, currentMonth]) { oldValue, newValue in
            updateSelectedDate()
        }
    }
    
    static func getNowYearMonth() -> (year: Int, month: Int) {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        let year = components.year ?? 2000
        let month = components.month ?? 1
        return (year, month)
    }
    
    private func addMonth(_ increment: Int) {
        currentMonth += increment
        if (currentMonth < 1) {
            currentMonth = 12
            currentYear -= 1
        }
        else if (currentMonth > 12) {
            currentMonth = 1
            currentYear += 1
        }
        
        if currentYear < 1 {
            currentYear = 1
            currentMonth = 1
        }
        else if currentYear > 9999 {
            currentYear = 9999
            currentMonth = 12
        }
    }

    private func updateSelectedDate() {
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonth
        components.day = 1              // The date is fixed to the 1st.
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM"
        return formatter
    }

}


struct YearMonthSelector: View {
    var onSelect: (Int, Int) -> Void
    
    let prevYear: Int
    let prevMonth: Int
    
    @State private var currentYear: Int
    @State private var currentMonth: Int
    @State private var hoveredItem: Int? = nil
    
    init(year: Int, month: Int, onSelect: @escaping (Int, Int) -> Void) {
        self.prevYear = year
        self.prevMonth = month
        self._currentYear = State(initialValue: year)
        self._currentMonth = State(initialValue: month)
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack() {
            HStack {
                Button("<") { addYear(-1) }
                                
                Text(String(format: "%d", currentYear))
                    .frame(width: 40, alignment: .center)
                    .font(.system(size: 14))
                    .monospaced()

                Button(">") { addYear(1) }
            }
            .focusEffectDisabled()
            
            Divider()
            
            days

        }
        .fixedSize()
        .padding(10)
    }

    private var days: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(25), spacing: 0), count: 6),
                  spacing: 0) {
            
            ForEach(1...12, id: \.self) { index in
                let isSelected = (prevYear == currentYear &&  prevMonth == index)
                
                Text("\(index)")
                    .frame(maxWidth: .infinity)
                    .background(
                        isSelected ? .red :
                            hoveredItem == index ? .blue :
                            Color(.windowBackgroundColor))
                    .foregroundColor(
                        isSelected ? .white :
                            hoveredItem == index ? .white :
                                .primary)
                    .cornerRadius(10)
                    .onHover { hovering in
                        hoveredItem = hovering ? index : nil
                    }
                    .onTapGesture {
                        onSelect(currentYear, index)
                    }
            }
        }
    }
    
    private func addYear(_ increment: Int) {
        currentYear += increment
        if currentYear < 1 {
            currentYear = 1
        }
        else if currentYear > 9999 {
            currentYear = 9999
        }
    }
    
}
