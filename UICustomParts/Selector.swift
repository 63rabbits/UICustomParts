//
//  Selector.swift
//  UICustomParts
//
//  Created by rabbit on 2025/09/27.
//

import SwiftUI


struct Selector: View {

    @Environment(\.colorScheme) var colorSchema

    var elements = [ "apple", "banana", "mikan" ]
    var selected: String?
    var labelColor: Color?
    var selectColor: Color?
    var backgroundColor: Color?
    var fixedWidth: Bool = true
    var deltaWidth: CGFloat = 10
    var deltaHeight: CGFloat = 10
    var action: (String) -> Void

    @State private var selection = ""
    @State private var elementsSize: [ String: CGSize ] = [:]
    @State private var determinedSize: [ String: CGSize ] = [:]
    @State private var maxWidth: CGFloat = 0
    @State private var maxHeight: CGFloat = 0
    @State private var rectOffset: CGFloat = 0
    @State private var isFirst = true

    var body: some View {

        // default color
        let labelColorToUse = labelColor ?? (colorSchema == .dark ? Color.white : Color.black)
        let selectColorToUse = selectColor ?? (colorSchema == .dark ? Color.gray.opacity(0.5) : Color.white.opacity(0.8))
        let backgroundColorToUse = backgroundColor ?? (colorSchema == .dark ? Color.gray.opacity(0.1) : Color.gray.opacity(0.2))

        VStack {

            ZStack {

                RoundedRectangle(cornerRadius: 5)
                    .fill(selectColorToUse)
                    .frame(width: determinedSize[selection]?.width, height: determinedSize[selection]?.height)
                    .offset(x: rectOffset)
                    .animation(.easeInOut(duration: 0.1), value: rectOffset)

                HStack(spacing: 0) {

                    ForEach(elements, id: \.self) { element in

                        Button(
                            action: {
                                selection = element
                                action(selection)
                            },
                            label: {
                                Text(element)
                                    .foregroundColor(labelColorToUse)
                                    .frame(width: determinedSize[element]?.width, height: determinedSize[element]?.height)
                            }
                        )
                        .buttonStyle(.borderless)
                        .frame(width: determinedSize[element]?.width)
                        .onGeometryChange(for: CGSize.self) { proxy in
                            proxy.size
                        } action: { size in
                            elementsSize[element] = size
                        }

                        if (element != elements.last) {
                            Divider().frame(width: 0, height: maxHeight / 2.0)
                        }
                    }

                }
                .onAppear() {
                    if isFirst && selection == "" {
                        if fixedWidth {
                            maxWidth = elementsSize.values.map { $0.width }.max()! + deltaWidth
                            maxHeight = elementsSize.values.map { $0.height }.max()! + deltaHeight
                            let fixedWidth = CGSize(width: maxWidth, height: maxHeight)
                            for k in elementsSize.keys {
                                determinedSize[k] = fixedWidth
                            }
                        }
                        else {
                            for (k, v) in elementsSize {
                                determinedSize[k] = CGSize(width: v.width + deltaWidth, height: v.height + deltaHeight)
                            }
                        }
                        selection = selected ?? (elements.first ?? "unknown")
                        isFirst = false
                    }
                }

            }
            .padding(2)
        }
        .background(backgroundColorToUse)
        .cornerRadius(5)
        .onChange(of: selection) {
            setRectPosition()
        }

    }

    func setRectPosition() {
        var sum: CGFloat = 0
        for e in elements {
            if e == selection {
                sum += elementsSize[e]!.width / 2.0
                break
            }
            sum += elementsSize[e]!.width
        }
        rectOffset = sum - elementsSize.values.map { $0.width }.reduce(0, +) / 2.0
    }

}
