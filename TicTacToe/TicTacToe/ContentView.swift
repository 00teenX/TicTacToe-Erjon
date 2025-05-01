//
//  ContentView.swift
//  TicTacToe
//
//  Created by Erjon on 21.02.2025.
//



import SwiftUI

struct ContentView: View {
    @StateObject private var game = TicTacToeGame()
    @State private var showMenu = false
    @State private var showDifficultyPicker = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Tic Tac Toe")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.top, 20)

                    if !game.isGameActive {
                        Picker("Gegner:", selection: $game.aiEnabled) {
                            Text("Mensch").tag(false)
                            Text("KI").tag(true)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 40)
                        .onChange(of: game.aiEnabled) { _, newValue in
                            if newValue {
                                showDifficultyPicker = true
                            }
                        }
                    }

                    GeometryReader { geometry in
                        let size = min(geometry.size.width, geometry.size.height) * 1.0
                        let cellSize = size / 4

                        VStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { row in
                                HStack(spacing: 8) {
                                    ForEach(0..<3, id: \.self) { col in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                game.makeMove(row: row, col: col)
                                            }
                                        }) {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(UIColor.systemBackground))
                                                .frame(width: cellSize, height: cellSize)
                                                .overlay(
                                                    Text(symbol(for: game.board[row][col]))
                                                        .font(.system(size: cellSize * 0.6, weight: .bold, design: .rounded))
                                                        .foregroundColor(color(for: game.board[row][col]))
                                                )
                                                .shadow(color: Color.primary.opacity(0.1), radius: 4, x: 0, y: 2)
                                        }
                                        .accessibilityLabel(symbol(for: game.board[row][col]))
                                        .accessibilityIdentifier("cell_\(row)_\(col)")
                                        .disabled(game.board[row][col] != .none || game.winner != nil)
                                        .disabled(game.board[row][col] != .none || game.winner != nil)
                                    }
                                }
                            }
                        }
                        .frame(width: size, height: size)
                    }
                    .aspectRatio(1, contentMode: .fit)

                    if let winner = game.winner {
                        Text("\(symbol(for: winner)) gewinnt! 🎉")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.green)
                            .padding(.top, 10)
                            .transition(.opacity.combined(with: .scale))
                    } else if !game.board.flatMap({ $0 }).contains(.none) {
                        Text("Unentschieden! 🤝")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.orange)
                            .padding(.top, 10)
                            .transition(.opacity.combined(with: .scale))
                    }

                    VStack(spacing: 10) {
                        Text("Statistik")
                            .font(.title3)
                            .bold()
                            .padding(.top, 5)

                        HStack(spacing: 20) {
                            Text("X: \(game.winsX)")
                                .font(.title3)
                                .foregroundColor(.blue)
                            Text("O: \(game.winsO)")
                                .font(.title3)
                                .foregroundColor(.red)
                            Text("Unentschieden: \(game.draws)")
                                .font(.title3)
                                .foregroundColor(.orange)
                        }

                        Button(action: {
                            withAnimation(.easeInOut) {
                                game.resetStatistics()
                            }
                        }) {
                            Text("Zurücksetzen")
                                .font(.title3)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(UIColor.systemGray5))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut) {
                            game.resetGame()
                        }
                    }) {
                        Text("Neustart")
                            .font(.title3)
                            .padding()
                            .frame(width: 150)
                            .background(Color(UIColor.systemGray5))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))

                
                if showMenu {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showMenu = false
                            }
                        }

                    VStack(spacing: 15) {
                        Text("Menü")
                            .font(.title2)
                            .bold()
                            .padding(.top, 10)

                        Divider()

                        Button("Weiter") {
                            withAnimation {
                                showMenu = false
                            }
                        }
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(12)

                        Button("Verlassen") {
                            withAnimation {
                                game.resetGame()
                                game.aiEnabled = false
                                showMenu = false
                            }
                        }
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .foregroundColor(.red)
                        .cornerRadius(12)

                        Spacer().frame(height: 12)
                    }
                    .frame(width: 260)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .transition(.scale)
                }
            }
            .animation(.easeInOut, value: showMenu)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showMenu = true }) {
                        Image(systemName: "line.horizontal.3")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showDifficultyPicker) {
                DifficultySelectionView(game: game, showPicker: $showDifficultyPicker)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func symbol(for player: Player) -> String {
        switch player {
        case .x: return "X"
        case .o: return "O"
        case .none: return ""
        }
    }

    func color(for player: Player) -> Color {
        switch player {
        case .x: return .blue
        case .o: return .red
        case .none: return .clear
        }
    }
}
