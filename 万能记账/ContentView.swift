//
//  ContentView.swift
//  万能记账
//
//  Created by 谭琪洋        on 2026/2/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AssetsView()
                .tabItem {
                    Label("资产", systemImage: "wallet.pass.fill")
                }

            PlaceholderView(title: "账本")
                .tabItem {
                    Label("账本", systemImage: "book.fill")
                }

            PlaceholderView(title: "存钱")
                .tabItem {
                    Label("存钱", systemImage: "banknote.fill")
                }

            PlaceholderView(title: "统计")
                .tabItem {
                    Label("统计", systemImage: "chart.pie.fill")
                }
        }
        .accentColor(.primary)
        .background(
            LinearGradient(colors: [Color("AccentColor").opacity(0.06), Color(.systemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
}

struct PlaceholderView: View {
    let title: String
    var body: some View {
        NavigationStack {
            VStack {
                Text(title + " 页面，后续开发")
                    .foregroundStyle(.secondary)
                    .padding()
                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
