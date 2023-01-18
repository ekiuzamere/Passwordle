//
//  GameView.swift
//  Passwordle!
//
//  Created by Eki Uzamere on 1/7/23.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var dm:  WordleDataModel
    @State private var showHelp = false
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if Global.screenHeight < 600 {
                        Text("")
                    }
                    Spacer()
                    VStack(spacing: 3) {
                        ForEach(0...5, id: \.self) {index in
                            GuessView(guess: $dm.guesses[index])
                                .modifier(Shake(animatableData: CGFloat(dm.incorrectAttempts[index])))
                        }
                    }
                    .frame(width: Global.boardWidth, height: 6 * Global.boardWidth/5)
                    Spacer()
                    Keyboard()
                        .scaleEffect(Global.keyboardScale)
                        .padding(.top)
                    Spacer()
                }
                .disabled(dm.showStats)
                .navigationBarTitleDisplayMode(.inline)
                .disabled(dm.showStats)
                .overlay(alignment: .top) {
                    if let toastText = dm.toastText {
                        ToastView(toastText: toastText)
                            .offset(y: 20)
                    }
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            if !dm.inPlay {
                                Button {
                                    dm.newGame()
                                } label: {
                                    Text("New")
                                        .foregroundColor(.primary)
                                }
                            }
                            Button {
                                showHelp.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        
                        //put VStack here??
                        
                        
                         VStack(spacing: 0) {
                             
                             if dm.unlock {
                                 Image(systemName: "lock.open.fill")
                                     .font(.system(size: 20))
                                     .padding(.top, 60)
                             } else {
                                 Image(systemName: "lock.fill")
                                     .font(.system(size: 20))
                                     .padding(.top, 60)
                             }
                             
                             Text(Date(), style: .time)
                                 .font(.system(size: 34, weight: .thin))
                             Text(Date(), style: .date)
                                 .font(.system(size: 15))
                                 .offset(y: -5)
                    
                         }
                         
                        
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                withAnimation {
                                    dm.showStats.toggle()
                                }
                                
                            } label: {
                                Image(systemName: "chart.bar")
                               // LockScreenButton(image: "camera.fill")
                            }

                        }
                    }
                }
                
            }
            if dm.showStats {
                StatsView()
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleDataModel())
    }
}

