import SwiftUI


enum GameSelection: String, CaseIterable, Identifiable {
    case guess      = "Precog"
    case overUnder  = "Over-Under"
    case bunco      = "Bunco"
    
    var id: GameSelection {self}
}

enum OverUnderSelection: String, CaseIterable, Identifiable {
    case over      = "Over"
    case under     = "Under"
    
    var id: OverUnderSelection {self}
}



struct ContentView: View {
    
    @State var leftDiceNumber  = 1
    @State var rightDiceNumber = 1
    @State var bothDiceTotal: Int = 1
    @State var userGuess : Float = 2.0
    
    @State var gameSelection: GameSelection = .guess
    @State var presentRules = false
    
    @State var overUnderSelection: OverUnderSelection = .over
    @State var correctGuessOU: Bool = false
    @State var wrongGuessOU: Bool = false
    
    @State var player1ScoreOU: Int = 0
    @State var player2ScoreOU: Int = 0
    
    @State var player1ScoreB: Int = 0
    @State var player2ScoreB: Int = 0
    
    @State var player1TurnOU: Bool = true
    @State var player2TurnOU: Bool = false
    
    @State var player1TurnB: Bool = true
    @State var player2TurnB: Bool = false
    
    @State var resetScores: Bool = false
    @State var useWhiteText: Bool = false
    @State var winValueOU: Int = 3
    @State var winValueB: Int = 20
    
    // add variable to determine which players turn it is... var lastRollCorrect
    
    var body: some View {
        
        ZStack {
            
            Image("background")
                .resizable()
//                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                
                Picker("",selection: $gameSelection) {
                    ForEach(GameSelection.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                } .pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                
                Button("Show Rules") {
                    presentRules = true
                }
                .alert("Rules", isPresented: $presentRules) {
                    Button("OK", role: .cancel) { }
                } message: {
                    if gameSelection == .bunco {
                        Text("How to Play Bunco: Roll dice & add the total to your score. Switch players if a 7 is rolled. Whoever scores 20 points first wins!")
                    } else if gameSelection == .overUnder {
                        Text(" How to Play Over-Under:  Before each roll guess whether total will be over or under 7. A correct guess is worth 1 point & you switch players if your guess is wrong. Your score resets to 0 if a 7 is rolled. The first player to score 3 points wins! ")
                    } else if  gameSelection == .guess {
                        Text("Use the slider below to guess what the total will be when you roll the dice ")
                    }
                }
                
                Image("diceeLogo")
                Spacer()
                
                HStack {
                    DiceView(n:leftDiceNumber)
                    DiceView(n:rightDiceNumber)
                }
                .padding(.horizontal)
                Spacer()
                
                Button(action: {
                    self.leftDiceNumber  = Int.random(in: 1...6)
                    self.rightDiceNumber = Int.random(in: 1...6)
                    bothDiceTotal = self.leftDiceNumber +  self.rightDiceNumber
                    
                    
                    if gameSelection == .overUnder && player1TurnOU == true && ((bothDiceTotal > 7) && (overUnderSelection == .over))  || ((bothDiceTotal < 7) && (overUnderSelection == .under)) {
                        player1ScoreOU += 1
                        
                    } else if gameSelection == .overUnder && player2TurnOU == true && ((bothDiceTotal > 7 && overUnderSelection == .over)   || (bothDiceTotal < 7 && overUnderSelection == .under)) {
                        player2ScoreOU += 1
                        
                        
                    } else if gameSelection == .overUnder && player1TurnOU == true && ((bothDiceTotal < 7) && (overUnderSelection == .over))  || ((bothDiceTotal > 7) && (overUnderSelection == .under)) {
                        player1TurnOU = false
                        player2TurnOU = true
                        
                        
                    } else if gameSelection == .overUnder && player2TurnOU == true && ((bothDiceTotal < 7) && (overUnderSelection == .over))  || ((bothDiceTotal > 7) && (overUnderSelection == .under)) {
                        player2TurnOU = false
                        player1TurnOU = true
                        
                        
                    } else if  gameSelection == .overUnder && player1TurnOU == true && bothDiceTotal == 7 {
                        player1TurnOU = false
                        player2TurnOU = true
                        player1ScoreOU = 0
                        
                        
                    } else if  gameSelection == .overUnder && player2TurnOU == true && bothDiceTotal == 7 {
                        player2ScoreOU = 0
                        player2TurnOU = false
                        player1TurnOU = true
                    }
                       
                       
                       
                       // Bunco Score Functionality...
                if gameSelection == .bunco && player1TurnB == true && bothDiceTotal != 7 {
                    player1ScoreB = player1ScoreB + bothDiceTotal
                    
                } else if gameSelection == .bunco && player2TurnB == true && bothDiceTotal != 7 {
                    player2ScoreB = player2ScoreB + bothDiceTotal
                    
                } else if gameSelection == .bunco && player1TurnB == true && bothDiceTotal == 7 {
                    player1TurnB = false
                    player2TurnB = true
                    player1ScoreB = player1ScoreB
                    player2ScoreB = player2ScoreB
                    
                } else if gameSelection == .bunco && player2TurnB == true && bothDiceTotal == 7 {
                    player2TurnB = false
                    player1TurnB = true
                    player1ScoreB = player1ScoreB
                    player2ScoreB = player2ScoreB
                }
                       
                       }) {
                    
                    Text("Roll   ")
                    
                        .font(.system(size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                if gameSelection == .bunco {
                    
                    HStack {
                        
                        Text("    Player 1 Score:  \(player1ScoreB)      ")
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                            .foregroundColor(player1TurnB ? .white: .gray)
                        
                        
                        Text("   Player 2 Score:  \(player2ScoreB)      ")
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                            .foregroundColor(player2TurnB ? .white: .gray)
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        player1ScoreB = 0
                        player2ScoreB = 0
                        player1TurnB   = true
                        player2TurnB   = false
                        
                    }) {
                        Text("Reset Score       ")
                        
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                    
                    Stepper("           Score Needed to Win: \(winValueB)",value:$winValueB, in: 20...100, step: 5)
                        .font(.system(size: 16))
                        .padding(.horizontal)
                        
                    
                } else if gameSelection == .overUnder {
                    
                    HStack {
                        
                        Text(" Player 1 Score:  \(player1ScoreOU)      ")
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                            .foregroundColor(player1TurnOU ? .white : .gray)
                        
                        Text(" Player 2 Score:  \(player2ScoreOU)      ")
                            .font(.system(size: 18))
                            .fontWeight(.heavy)
                            .foregroundColor(player2TurnOU ? .white : .gray)
                    }
                    
                    Picker("",selection: $overUnderSelection) {
                        ForEach(OverUnderSelection.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    } .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    Button(action: {
                        player1ScoreOU = 0
                        player2ScoreOU = 0
                        player1TurnOU   = true
                        player2TurnOU   = false
                        
                    }) {
                        Text("Reset Score       ")
                        
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(20)
                            .padding(.all)
                    }
                    
//                    Stepper("      Score Needed to Win: \(winValueOU)",value:$winValueOU, in: 3...10, step: 1)
//                        .font(.system(size: 16))
//                        .padding(.horizontal)
                    
                } else if gameSelection == .guess {
                    
                    Slider(value: $userGuess, in: 2...12, step: 1) {
                    }.tint(.red)
                        .padding()
                    
                    
                    Text("Use Slider to Guess Total: \(Int(userGuess))")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                        .padding(.all)
                }
                if gameSelection == .guess && Int(userGuess) == bothDiceTotal {
                    Text ("You WIN!")
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .foregroundColor(.green)
                        .padding(.all)
                }
                
                
            }
            
        }
    }
}

struct DiceView: View {
    
    let n : Int
    
    var body: some View {
        Image("dice\(n)")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding(.all)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

