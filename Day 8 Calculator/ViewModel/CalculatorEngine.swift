//
//  CalculatorEngine.swift
//  Day 8 Calculator
//
//  Created by Stephen Liddle on 9/26/24.
//

import Foundation

@Observable class CalculatorEngine {

    // MARK: - Constants

    private struct Constants {
        static let decimal = OperationSymbol.decimal.rawValue
        static let defaultDisplayText = OperationSymbol.zero.rawValue
        static let errorDisplayText = "Error"
        static let largeThreshold = 1_000_000_000.0
        static let maxmimumFractionDigits = 8
    }

    // MARK: - Properties

    var preferences = Preferences()

    private var calculator = CalculatorBrain()
    private let decimalFormatter = NumberFormatter()
    private let scientificFormatter = NumberFormatter()
    private var soundPlayer = SoundPlayer()
    private var textBeingEdited: String? = Constants.defaultDisplayText

    // MARK: - Initialization

    init() {
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = Constants.maxmimumFractionDigits

        scientificFormatter.numberStyle = .scientific
        scientificFormatter.maximumFractionDigits = Constants.maxmimumFractionDigits
    }

    // MARK: - Model access

    var activeSymbol: OperationSymbol? {
        calculator.pendingSymbol
    }

    var clearSymbol: String {
        if isClear {
            OperationSymbol.clear.rawValue
        } else {
            OperationSymbol.allClear.rawValue
        }
    }

    var displayText: String {
        if let text = textBeingEdited {
            text
        } else if let value = calculator.accumulator {
            formatted(number: value)
        } else if let value = calculator.pendingLeftOperand {
            formatted(number: value)
        } else {
            Constants.errorDisplayText
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

    private func formatted(number: Double) -> String {
        formatter(for: number).string(from: NSNumber(value: number)) ?? Constants.errorDisplayText
    }

    private func formatter(for value: Double) -> NumberFormatter {
        value > Constants.largeThreshold ? scientificFormatter : decimalFormatter
    }

    private func handleClearTap() {
        if isClear {
            calculator.setAccumulator(nil)

            if calculator.pendingLeftOperand != nil {
                textBeingEdited = nil
            } else {
                textBeingEdited = Constants.defaultDisplayText
            }
        } else {
            calculator.clearAll()
            textBeingEdited = Constants.defaultDisplayText
        }
    }

    private func handleNumericTap(digit: String) {
        if let text = textBeingEdited {
            if digit == Constants.decimal && text.contains(digit) {
                // Ignore extra tap on decimal button
                return
            }

            if digit != Constants.decimal && text == Constants.defaultDisplayText {
                textBeingEdited = digit
            } else {
                textBeingEdited = text + digit
            }
        } else {
            textBeingEdited = digit
        }

        if let updatedText = textBeingEdited {
            calculator.setAccumulator(Double(updatedText))
        }
    }

    private func handleOperationTap(symbol: OperationSymbol) {
        if calculator.accumulator != nil {
            calculator.performOperation(symbol)
            textBeingEdited = nil
        }
    }

    private var isClear: Bool {
        if let text = textBeingEdited, text != Constants.defaultDisplayText {
            true
        } else {
            false
        }
    }
}
