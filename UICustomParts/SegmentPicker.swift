//
//  SegmentPicker.swift
//  UICustomParts
//
//  Created by rabbit on 2026/10/22.
//
//  Found at the URL below
//  https://khorbushko.github.io/article/2025/09/12/date-range-picker.html
//

import SwiftUI

protocol SegmentPickerElement: Hashable, Identifiable, CaseIterable {

    var id: String { get }
    var title: String? { get }
}

extension SegmentPickerElement
    where Self: RawRepresentable, RawValue == String {
    var id: String {
        rawValue
    }
    var title: String? {
        rawValue.capitalized
    }
}


struct SegmentPicker<T: SegmentPickerElement>: View {
    @Binding var selectedSegment: T
    @Namespace private var animationNamespace
    
    var body: some View {
        container
            .background(.secondary.opacity(0.5))
            .cornerRadius(9)
    }
    
    private var container: some View {
        HStack(spacing: 0) {
            ForEach(Array(T.allCases)) { segment in
                segmentButton(segment)
                if segment != Array(T.allCases).last {
                    Divider()
//                        .background(.black)
                }
            }
        }
    }
    
    private func segmentButton(_ segment: T) -> some View {
        Text(segment.title ?? "")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Capsule())
            .background {
                if segment == selectedSegment {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.primary.opacity(0.3))
                        .matchedGeometryEffect(
                            id: "activeSegment",
                            in: animationNamespace
                        )
                }
            }
            .onTapGesture {
                withAnimation(.snappy) {
                    selectedSegment = segment
                }
            }
    }
}
