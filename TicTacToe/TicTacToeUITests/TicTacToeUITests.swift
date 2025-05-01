//
//  TicTacToeUITests.swift
//  TicTacToeUITests
//
//  Created by Erjon on 21.02.2025.
//



import XCTest

final class TicTacToeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    /// Test tapping on a cell shows an X or O
    func testTapOnCellShowsSymbol() {
        let cell = app.buttons["cell_0_0"]
        cell.tap()
        XCTAssertTrue(cell.label == "X" || cell.label == "O", "Zelle zeigt kein X oder O nach dem Tippen.")
    }

    /// Test that tapping the Neustart button resets the field
    func testNeustartButtonResetsGame() {
        let cell = app.buttons["cell_0_0"]
        cell.tap()
        app.buttons["Neustart"].tap()

        // Nach dem Neustart sollte das Feld leer sein
        XCTAssertEqual(app.buttons["cell_0_0"].label, "", "Zelle wurde nach Neustart nicht zurückgesetzt.")
    }

    /// Test that the menu appears and can be closed
    func testShowMenuAndCloseIt() {
        app.buttons["line.horizontal.3"].tap()
        XCTAssertTrue(app.staticTexts["Menü"].exists, "Menü sollte angezeigt werden.")

        app.buttons["Weiter"].tap()
        XCTAssertFalse(app.staticTexts["Menü"].exists, "Menü sollte nach 'Weiter' geschlossen sein.")
    }

    /// Test selecting AI and difficulty
    func testSelectAIDifficulty() {
        let segmentedControl = app.segmentedControls.element
        segmentedControl.buttons["KI"].tap()

        XCTAssertTrue(app.staticTexts["Schwierigkeit wählen"].exists, "Schwierigkeit-Auswahl sollte angezeigt werden.")

        app.buttons["Bestätigen"].tap()
        XCTAssertFalse(app.staticTexts["Schwierigkeit wählen"].exists, "Schwierigkeit-Auswahl sollte geschlossen sein.")
    }
}
