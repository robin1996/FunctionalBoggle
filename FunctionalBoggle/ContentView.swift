//
//  ContentView.swift
//  FunctionalBoggle
//
//  Created by Robin Douglas on 21/05/2020.
//  Copyright © 2020 Robin Douglas. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var engine = BoggleEngine()
    @State private var word = ""
    @State private var state = false

    var body: some View {
        VStack {
            Spacer()
            Text(engine.grid.render())
                .font(.system(size: 30, design: .monospaced))
                .foregroundColor(state ? .green : .black)
            TextField("Enter your word here", text: $word)
                .padding()
            HStack {
                Spacer()
                Button("Shake!", action: engine.shakeGrid)
                    .foregroundColor(.red)
                Spacer()
                Button("Go!", action: testWord)
                Spacer()
            }
            Spacer()
        }
    }

    func testWord() {
        state = engine.test(word: word.lowercased())
    }

}
