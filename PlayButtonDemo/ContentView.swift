//
//  ContentView.swift
//  PlayButtonDemo
//
//  Created by Hayder Al-Husseini on 30/07/2020.
//  Copyright © 2020 kodeba•se ltd.
//
//  See LICENSE.md for licensing information.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PlayButton {
            print("Hello World")
        }
        .frame(width: 128, height: 128)
        .foregroundColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
