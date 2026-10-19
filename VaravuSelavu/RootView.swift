//
//  RootView.swift
//  VaravuSelavu
//
//  Created by Divya on 19/10/26.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            MonthView()
                .tabItem { Label("Month", systemImage: "calendar") }
            TemplatesView()
                .tabItem { Label("Saved expenses", systemImage: "list.bullet.rectangle") }
        }
    }
}
