//
//  HomeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            NavigationButton(push: .notifications) {
                Text("Notification")
            }
            NavigationButton(root: .welcome) {
                Text("Go to Welcome")
            }
        }
    }
}

#Preview {
    HomeView()
}
