//
//  ContentView.swift
//  TicTacToe
//
//  Created by AMStudent on 9/15/21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var audioPlayer: AVAudioPlayer!
    @State var song = 1
   var body: some View {
      Home()
       HStack {
           Button(action: {
               audioPlayer.play()
           }) {
               Text("▶️")
                   .font(.system(size: 60))
                   .fontWeight(.bold)
                   .foregroundColor(.black)
           }
           Button(action: {
               audioPlayer.pause()
           }) {
               Text("⏸")
                   .font(.system(size: 60))
                   .fontWeight(.bold)
                   .foregroundColor(.black)
           }
           
           Button(action: {
               if self.song < 3 {
                   self.song += 1
                   } else {
                       self.song = 1
                   }
                   let sound = Bundle.main.path(forResource: "song\(self.song)" , ofType: "mp3")
                   self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                   self.audioPlayer.play()
           }) {
               Text("➡️")
                   .font(.system(size: 60))
                   .fontWeight(.bold)
                   .foregroundColor(.red)
           }
       }
   }

   }


struct Home: View {
   
    
    // Number of moves we can make
    @State var moves: [String] = Array(repeating: "", count: 9)
    //identfiy our current player
    @State var isPlaying = true
    @State var gameOver = false
    @State var msg = ""
    
    var body: some View {
        
        VStack {

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {

                ForEach(0..<9, id: \.self) {
                    index in

                    ZStack {
                        Color.black

                        Color.black
                            .opacity(moves[index] == "" ? 1 : 0)

                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(randomColor())
                    }
                        .frame(width: getWidth(), height: getWidth())
                        .cornerRadius(10)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .center,
                    anchorZ: 0.0,
                    perspective: 1.0
                    )
                    .onTapGesture(perform: {
                        withAnimation(Animation.easeIn(duration: 0.1)) {
                            if moves [index] == "" {
                            moves[index] = isPlaying ? "X" : "O"
                            isPlaying.toggle()
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        .onChange(of: moves, perform: { value in
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            Alert(title: Text("Winner"), message: Text(msg), dismissButton:
                    .destructive(Text("Play Again"), action: {
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            moves.removeAll()
                            moves = Array(repeating: "", count: 9)
                            isPlaying = true
                        }
                    }))
        })
    }
    func randomColor() -> Color {
        let color = UIColor(red: CGFloat.random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        return Color(color)
    }
    // calculate width of grid
    func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }


func checkWinner() {
    if checkMoves(player: "X") {
        
        msg = "player X won!"
        gameOver.toggle()
    }
    else if checkMoves(player: "O") {
        
        msg = "player O won!"
        gameOver.toggle()
        
    } else {
        let status = moves.contains { (value) -> Bool in
            return value == ""
        }
        if !status {
            msg = "game tied"
            gameOver.toggle()
        }
    }
}
func checkMoves(player: String) -> Bool {
    
    for contestant in stride(from: 0, to: 9, by: 3) {
        if  moves[contestant] == player &&
            moves[contestant+1] == player &&
            moves[contestant+2] == player {
            
            return true
        }
    }
    for contestant in 0...2 {
    if  moves[contestant] == player &&
        moves[contestant+3] == player &&
        moves[contestant+6] == player {
                
                return true
            }
        }
    
    if moves[0] == player && moves [4] == player && moves [8] == player {
        return true
    }
    if moves[2] == player && moves [4] == player && moves [6] == player {
        return true
    }
  return false

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

