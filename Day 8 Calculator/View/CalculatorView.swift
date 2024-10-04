//
//  CalculatorView.swift
//  HW4 Calculator UI
//
//  Created by Stephen Liddle on 9/24/24.
//

import SwiftUI

let columnCount = 4
let gridItems = Array<GridItem>(repeating: .init(.flexible()), count: columnCount)

struct CalculatorView: View {

    private struct Constants {
        static let displayFontSize = 90.0
    }

    @Bindable var calculator: CalculatorEngine

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .trailing, spacing: DrawingConstants.buttonSpacing) {
                    accumulatorBody
                    buttonGrid(for: geometry)
                }
                .padding(.leading, DrawingConstants.buttonSpacing)
            }
            .background(.black)
        }
    }

    var accumulatorBody: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                Toggle(
                    "Play sound",
                    isOn: $calculator.preferences.soundIsEnabled
                )
                .foregroundStyle(.white)
                Spacer()
                Text(calculator.displayText)
                    .font(
                        systemFont(
                            for: calculator.displayText,
                            thatFits: geometry.size.width - DrawingConstants.buttonSpacing * 2,
                            desiredSize: Constants.displayFontSize
                        )
                    )
                    .foregroundStyle(.white)
                    .padding(.trailing, DrawingConstants.buttonSpacing)
            }
        }
    }

    func buttonGrid(for geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: gridItems, alignment: .leading, spacing: DrawingConstants.buttonSpacing) {
            ForEach(buttonSpecs, id: \.symbol.rawValue) { buttonSpec in
                if buttonSpec.symbol == .placeholder {
                    Text("")
                } else {
                    CalculatorButton(
                        buttonSpec: buttonSpec,
                        size: geometry.size,
                        calculator: calculator
                    )
                }
            }
        }
    }
}

//#Preview {
//    CalculatorView(calculatorViewModel: CalculatorViewModel())
//}
