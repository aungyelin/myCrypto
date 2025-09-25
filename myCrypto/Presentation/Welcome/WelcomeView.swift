//
//  WelcomeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            NavigationButton(root: .main) {
                Text("Go to main")
            }
            NavigationButton(sheet: .sheet1) {
                Text("Show sheet 1")
            }
            NavigationButton(fullScreen: .fullScreen1) {
                Text("Show full screen 1")
            }
        }
        .padding()
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        WelcomeView()
    }
}
