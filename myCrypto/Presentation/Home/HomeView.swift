//
//  HomeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                marketStatistics
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .refreshable {
            homeVM.refresh()
        }
        .onAppear { homeVM.refresh() }
    }
    
    private var header: some View {
        HStack {
            NavigationButton(fullScreen: .profile) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.accent.opacity(0.1))
                    Image("profile")
                }
                .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            NavigationButton(fullScreen: .notification) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.accent.opacity(0.1))
                    Image(systemName: "bell")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 20, weight: .medium))
                }
                .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
        }
    }
    
    private var marketStatistics: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Market Statistics")
                .font(.system(size: 24, weight: .semibold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["24 hrs", "Hot", "Profit", "Rising", "Top", "Gainers", "Losers"], id: \.self) { pill in
                        Text(pill)
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .padding(.vertical, 3)
            
            if homeVM.isLoading && homeVM.marketStats.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 32)
            } else if let error = homeVM.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(homeVM.marketStats, id: \.id) { currency in
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: currency.image)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } else if phase.error != nil {
                                    Color.gray.opacity(0.3)
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(currency.name)
                                    .font(.system(size: 16, weight: .semibold))
                                Text(currency.symbol.uppercased())
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("$" + currency.currentPrice.formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2))))
                                    .font(.system(size: 16, weight: .semibold))
                                
                                HStack(spacing: 4) {
                                    Image(systemName: currency.priceChangePercentage24H >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                        .scaleEffect(x: 1.0, y: 0.5, anchor: .center)
                                    Text(String(format: "%.2f%%", abs(currency.priceChangePercentage24H)))
                                }
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(currency.priceChangePercentage24H >= 0 ? .green : .red)
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.leading, 1)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        MainView()
            .environmentObject(HomeViewModel())
    }
}

