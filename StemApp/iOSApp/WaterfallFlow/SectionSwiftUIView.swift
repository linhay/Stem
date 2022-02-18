//
//  SectionSwiftUIView.swift
//  iOSApp
//
//  Created by linhey on 2022/2/17.
//

import SwiftUI
import Stem

struct SectionSwiftUIView: View {
    var body: some View {
        LazyHGrid(rows: [.init()]) {
            Color.red
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SectionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SectionSwiftUIView()
    }
}
