//
//  DifficultySelectionView.swift
//  TicTacToe
//
//  Created by Erjon on 21.02.2025.
//



import SwiftUI

struct DifficultySelectionView: View {
    @ObservedObject var game: TicTacToeGame
    @Binding var showPicker: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Schwierigkeit wählen")
                .font(.title2)
                .bold()
                .padding(.top, 10)

            Picker("Schwierigkeit:", selection: $game.difficulty) {
                Text("Leicht").tag(Difficulty.easy)
                Text("Mittel").tag(Difficulty.medium)
                Text("Schwer").tag(Difficulty.hard)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("Bestätigen") {
                withAnimation {
                    showPicker = false
                    game.isGameActive = true
                }
            }
            .font(.title3)
            .frame(maxWidth: 200)
            .padding()
            .background(Color(UIColor.systemGray5))
            .foregroundColor(.blue)
            .cornerRadius(12)

        }
        .frame(maxWidth: 400)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
        .transition(.scale)
    }
}
