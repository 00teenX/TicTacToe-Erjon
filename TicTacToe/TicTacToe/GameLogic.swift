//
//  GameLogic.swift
//  TicTacToe
//
//  Created by Erjon on 21.02.2025.
//



import Foundation
import UIKit

enum Player {
    case x, o, none
}

enum Difficulty {
    case easy, medium, hard
}

class TicTacToeGame: ObservableObject {
    @Published var board: [[Player]] = Array(repeating: Array(repeating: .none, count: 3), count: 3)
    @Published var currentPlayer: Player = .x
    @Published var winner: Player? = nil
    @Published var isGameActive: Bool = false
    @Published var aiEnabled: Bool = false

    // Statistik für Siege
    @Published var winsX: Int = 0
    @Published var winsO: Int = 0
    @Published var draws: Int = 0

    var difficulty: Difficulty = .easy

    enum HapticEvent {
        case move, win, draw
    }

    func triggerHapticFeedback(for event: HapticEvent) {
        let generator: UIImpactFeedbackGenerator

        switch event {
        case .move:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .win:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        case .draw:
            generator = UIImpactFeedbackGenerator(style: .medium)
        }

        generator.prepare()
        generator.impactOccurred()
    }

    func makeMove(row: Int, col: Int) {
        if board[row][col] == .none && winner == nil {
            board[row][col] = currentPlayer
            triggerHapticFeedback(for: .move)
            isGameActive = true

            if checkWinner() {
                winner = currentPlayer
                isGameActive = false
                triggerHapticFeedback(for: .win)
                updateStatistics(winner: currentPlayer)
            } else if board.flatMap({ $0 }).allSatisfy({ $0 != .none }) {
                winner = nil
                isGameActive = false
                triggerHapticFeedback(for: .draw)
                draws += 1
            } else {
                switchTurn()
            }
        }
    }

    private func updateStatistics(winner: Player) {
        switch winner {
        case .x:
            winsX += 1
        case .o:
            winsO += 1
        case .none:
            draws += 1
        }
    }

    func resetStatistics() {
        winsX = 0
        winsO = 0
        draws = 0
    }

    private func switchTurn() {
        currentPlayer = (currentPlayer == .x) ? .o : .x

        if aiEnabled && currentPlayer == .o {
            makeAIMove()
        }
    }

    private func makeAIMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let move = self.getBestMove()
            self.makeMove(row: move.0, col: move.1)
        }
    }

    func getBestMove() -> (Int, Int) {
        switch difficulty {
        case .easy:
            return randomMove()
        case .medium:
            return blockOrRandomMove()
        case .hard:
            return bestMove()
        }
    }

    private func randomMove() -> (Int, Int) {
        let availableMoves = board.enumerated().flatMap { row, cols in
            cols.enumerated().compactMap { col, player in player == .none ? (row, col) : nil }
        }
        return availableMoves.randomElement() ?? (0, 0)
    }

    private func blockOrRandomMove() -> (Int, Int) {
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col] == .none {
                    board[row][col] = .o
                    if checkWinner() {
                        board[row][col] = .none
                        return (row, col)
                    }
                    board[row][col] = .none
                }
            }
        }
        return randomMove()
    }

    private func bestMove() -> (Int, Int) {
        var bestScore = Int.min
        var move = (0, 0)

        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col] == .none {
                    board[row][col] = .o
                    let score = minimax(depth: 0, isMaximizing: false)
                    board[row][col] = .none
                    if score > bestScore {
                        bestScore = score
                        move = (row, col)
                    }
                }
            }
        }
        return move
    }

    private func minimax(depth: Int, isMaximizing: Bool) -> Int {
        if checkWinner() {
            return isMaximizing ? -1 : 1
        }
        if board.allSatisfy({ row in row.allSatisfy({ $0 != .none }) }) {
            return 0
        }

        if isMaximizing {
            var bestScore = Int.min
            for row in 0..<3 {
                for col in 0..<3 {
                    if board[row][col] == .none {
                        board[row][col] = .o
                        let score = minimax(depth: depth + 1, isMaximizing: false)
                        board[row][col] = .none
                        bestScore = max(bestScore, score)
                    }
                }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for row in 0..<3 {
                for col in 0..<3 {
                    if board[row][col] == .none {
                        board[row][col] = .x
                        let score = minimax(depth: depth + 1, isMaximizing: true)
                        board[row][col] = .none
                        bestScore = min(bestScore, score)
                    }
                }
            }
            return bestScore
        }
    }

    private func checkWinner() -> Bool {
        let winPatterns = [
            [(0,0), (0,1), (0,2)], [(1,0), (1,1), (1,2)], [(2,0), (2,1), (2,2)],
            [(0,0), (1,0), (2,0)], [(0,1), (1,1), (2,1)], [(0,2), (1,2), (2,2)],
            [(0,0), (1,1), (2,2)], [(0,2), (1,1), (2,0)]
        ]

        for pattern in winPatterns {
            let first = board[pattern[0].0][pattern[0].1]
            if first != .none && pattern.allSatisfy({ board[$0.0][$0.1] == first }) {
                return true
            }
        }
        return false
    }

    func resetGame() {
        board = Array(repeating: Array(repeating: .none, count: 3), count: 3)
        currentPlayer = .x
        winner = nil
        isGameActive = false
    }
}
