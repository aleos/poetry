//
//  PoetryApp.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 07.08.2022.
//

import SwiftUI

@main
struct PoetryApp: App {
    @State var poemsViewModel = PoemsViewModel()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(named: "background")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(poemsViewModel: poemsViewModel)
        }
    }
}
