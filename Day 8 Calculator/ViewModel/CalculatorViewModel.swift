//
//  CalculatorViewModel.swift
//  Day 8 Calculator
//
//  Created by Stephen Liddle on 9/26/24.
//

import Foundation

@Observable class CalculatorViewModel {

    // MARK: - Constants

    private struct Constants {
        static let defaultDisplayText = OperationSymbol.zero.rawValue
        static let errorDisplay = "Error"
    }

    // MARK: - Properties

    var preferences = Preferences()

    private var calculatorModel = CalculatorBrain()
    private var soundPlayer = SoundPlayer()
    private var textBeingEdited: String? = Constants.defaultDisplayText

    // MARK: - Model access

    var displayText: String {
        if let text = textBeingEdited {
            text
        } else {
            Constants.errorDisplay
        }
    }

    // MARK: - User intents

    func handleButtonTap(for buttonSpec: ButtonSpec) {
        if preferences.soundIsEnabled {
            Task {
                await soundPlayer.playSound(named: "Click2.m4a")
            }
        }

        switch buttonSpec.type {
            case .compute:
                handleOperationTap(symbol: buttonSpec.symbol)
            case .utility:
                if buttonSpec.symbol == .clear {
                    handleClearTap()
                } else {
                    handleOperationTap(symbol: buttonSpec.symbol)
                }
            case .number, .doubleWide:
                handleNumericTap(digit: buttonSpec.symbol.rawValue)
        }
    }

    // MARK: - Private helpers

    private func handleClearTap() {

    }

    private func handleNumericTap(digit: String) {
        if let text = textBeingEdited {
            textBeingEdited = text + digit
        }
    }

    private func handleOperationTap(symbol: OperationSymbol) {

    }
}
