//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Baymurat Abdumuratov on 30/01/24.
//

import SwiftUI




struct FlagImage: View{
    
    var name = ""

    var body: some View{
        Image(name)
//            .clipShape(.capsule)
//            .shadow(radius: 10)
//            
    }
    
}

struct TitleModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
    }
}


struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingScore2 = false
    @State private var totalTrials = 0
    @State private var scoreTitle = ""
    @State public var score: Int = 0
    @State public var messageToUser = ""
    @State public var rotationAngle = 0.0
    @State public var opacityNum: Double = 1
    @State public var scaleDown: Double = 1
   
    
    
    var body: some View {
        
        ZStack{
            RadialGradient(stops: [
                .init(color: .red, location: 0.3),
                .init(color: .blue, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                
                Spacer()
                
                Text("Guess the Flag")
                    .titleStyle()
                VStack(spacing:15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                                .clipShape(.rect(cornerRadius: 10))
                                .rotation3DEffect(
                                    .degrees(number == correctAnswer ? rotationAngle : 0.0), axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .opacity(number == correctAnswer ? 1.0 : opacityNum)
                                .animation(.easeInOut(duration: 1), value: rotationAngle)
                                .scaleEffect(number == correctAnswer ? 1.0 : scaleDown)
                                        
                                
                        }
                       
                    }

                    
                    
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
                
            }
            .padding()
            
            
            
            .alert(scoreTitle, isPresented: $showingScore) {
                if totalTrials == 8 {
                    Button {
                        endingGame()
                    } label: {
                        Text("Restart")
                    }
                } else {
                    Button {
                        askQuestion()
                    } label: {
                        Text("Continue")
                            
                    }
                }
            } message: {
                VStack {
                    Text(messageToUser)
                    Text("Your score: \(score)")
                }
            }
            
            .alert(scoreTitle, isPresented: $showingScore2) {
                Button {
                    endingGame()
                } label: {
                    Text("Restart")
                }
            } message: {
                Text(messageToUser)
            }
        }
    }
    func flagTapped(_ number: Int){
        
        if number == correctAnswer{
            opacityNum = 0.25
            scoreTitle = "Correct"
            
            score += 1
            messageToUser = "Your answer is right🥳🎊. Your score is \(score) "
            totalTrials += 1
        }else{
            scoreTitle = "Wrong"
            messageToUser = "Your answer is correct. It is flag of \(countries[correctAnswer]). Your score is \(score)"
            score += 0
            totalTrials += 1
           
        }
        withAnimation {
            rotationAngle += 360
            scaleDown = 0.8
        }

        showingScore = true
    }
    
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityNum = 1.0
        scaleDown = 1.0
    }
    
    func endingGame(){
       
        scoreTitle = "Game is over"
        showingScore2 = true
        showingScore = false
        messageToUser = "Good luck for your next game!  Your score: \(score)"
        score = 0
        totalTrials = 0
        countries.shuffle()
    
    }
}

extension View{
    func titleStyle() -> some View{
        modifier(TitleModifier())
    }
}

#Preview {
    ContentView()
}
