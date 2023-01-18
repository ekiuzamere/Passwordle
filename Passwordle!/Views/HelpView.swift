//
//  HelpView.swift
//  Passwordle!
//
//  Created by Eki Uzamere on 1/7/23.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text(
"""
It's **WORDLE** with a twist.

Guess the **PASSWORDLE** in 6 tries.

Each guess must be five numbers long. Hit the enter button to submit.

After each guess, the color of the tiles will change to show how close your guess was
to the real password.
"""
                )
                Divider()
                Text("**FOR EXAMPLE:**")
                VStack(alignment: .leading) {
                    Image("Weary")
                        .resizable()
                        .scaledToFit()
                    Text("The number  **1**  is in the password and in the correct spot.")
                    Image("Pills")
                        .resizable()
                        .scaledToFit()
                    Text("The number  **5**  is in the password but in the wrong spot.")
                    Image("Vague")
                        .resizable()
                        .scaledToFit()
                    Text("The number  **8**  is not in the password or in the correct spot.")
                    
                }
                Divider()
                Text("**Tap the NEW Button for a new game.**")
                Spacer()
                
            }
            .frame(width: min(Global.screenWidth - 40, 350))
            .navigationTitle("HOW TO PLAY")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("**X**")
                    }
                }
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

