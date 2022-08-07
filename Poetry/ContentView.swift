//
//  ContentView.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 07.08.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var poemsViewModel: PoemsViewModel
    
    var body: some View {
        NavigationView {
            List(poemsViewModel.poems, id: \.title) { poem in
                NavigationLink {
                    PoemView(title: poem.title, text: poem.text)
                } label: {
                    PoemTitleCell(text: poem.title)
                }
                .listRowBackground(Color("background"))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var vm: PoemsViewModel = {
        var vm = PoemsViewModel()
        vm.poems = [Poem](repeating: Poem(title: "Я здесь", text: ""), count: 100)
        return vm
    }()
    static var previews: some View {
        ContentView(poemsViewModel: Self.vm)
    }
}
