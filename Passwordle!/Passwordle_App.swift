//
//  Passwordle_App.swift
//  Passwordle!
//
//  Created by Eki Uzamere on 1/7/23.
//

import SwiftUI

@main
struct Passwordle_App: App {
    @StateObject var dm = WordleDataModel()
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(dm)

        }
    }
}
