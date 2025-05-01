//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Erjon on 21.02.2025.
//



import XCTest
@testable import TicTacToe

final class TicTacToeGameTests: XCTestCase {

    var game: TicTacToeGame!

    override func setUp() {
        super.setUp()
        game = TicTacToeGame()
    }

    override func tearDown() {
        game = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(game.board.flatMap { $0 }.filter { $0 == .none }.count, 9)
        XCTAssertEqual(game.currentPlayer, .x)
        XCTAssertNil(game.winner)
        XCTAssertFalse(game.isGameActive)
        XCTAssertEqual(game.winsX, 0)
        XCTAssertEqual(game.winsO, 0)
        XCTAssertEqual(game.draws, 0)
    }

    func testMakeMoveSetsCell() {
        game.makeMove(row: 0, col: 0)
        XCTAssertEqual(game.board[0][0], .x)
    }

    func testSwitchTurn() {
        game.makeMove(row: 0, col: 0)
        XCTAssertEqual(game.currentPlayer, .o)
    }

    func testWinDetection() {
        game.board = [
            [.x, .x, .none],
            [.o, .o, .none],
            [.none, .none, .none]
        ]
        game.makeMove(row: 0, col: 2)
        XCTAssertEqual(game.winner, .x)
        XCTAssertFalse(game.isGameActive)
        XCTAssertEqual(game.winsX, 1)
    }

    func testDrawDetection() {
        game.board = [
            [.x, .o, .x],
            [.x, .o, .o],
            [.o, .x, .none]
        ]
        game.currentPlayer = .x
        game.makeMove(row: 2, col: 2)
        XCTAssertNil(game.winner)
        XCTAssertFalse(game.isGameActive)
        XCTAssertEqual(game.draws, 1)
    }

    func testResetGame() {
        game.makeMove(row: 0, col: 0)
        game.resetGame()
        XCTAssertEqual(game.board.flatMap { $0 }.filter { $0 == .none }.count, 9)
        XCTAssertEqual(game.currentPlayer, .x)
        XCTAssertNil(game.winner)
        XCTAssertFalse(game.isGameActive)
    }

    func testResetStatistics() {
        game.winsX = 2
        game.winsO = 1
        game.draws = 3
        game.resetStatistics()
        XCTAssertEqual(game.winsX, 0)
        XCTAssertEqual(game.winsO, 0)
        XCTAssertEqual(game.draws, 0)
    }

    func testBlockOrRandomMoveBlocksWin() {
        game.difficulty = .medium
        game.board = [
            [.x, .x, .none],
            [.none, .o, .none],
            [.none, .none, .none]
        ]
        let move = game.getBestMove()
        XCTAssertEqual(game.board[move.0][move.1], .none)
    }

    func testBestMovePreventsLoss() {
        game.difficulty = .hard
        game.board = [
            [.x, .x, .none],
            [.none, .o, .none],
            [.none, .none, .none]
        ]
        let move = game.getBestMove()
        XCTAssertEqual(move.0, 0)
        XCTAssertEqual(move.1, 2)
    }
}
