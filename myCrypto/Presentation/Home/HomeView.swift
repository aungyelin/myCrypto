//
//  HomeView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI
import Charts

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                portfolioSection
                marketStatistics
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .refreshable {
            homeVM.refresh()
        }
        .onAppear {
            homeVM.refresh()
        }
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
            .accessibilityLabel("User Profile")
            
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
            .accessibilityLabel("Notifications")
        }
    }
    
    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Balance card
            VStack(alignment: .leading, spacing: 8) {
                Text("Portfolio Balance")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(alignment: .center, spacing: 12) {
                    Text(homeVM.portfolioBalance.formatted(.currency(code: "USD")))
                        .font(.system(size: 38, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 11, weight: .bold))
                            .scaleEffect(x: 1.0, y: 0.6, anchor: .center)
                        Text(String(format: "%.2f%%", abs(homeVM.portfolioChangePct)))
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.green)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(
                        Capsule()
                            .fill(.green.opacity(0.2))
                            .opacity(0.95)
                    )
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Portfolio increased by \(String(format: "%.2f", abs(homeVM.portfolioChangePct))) percent")
                }
                .accessibilityElement(children: .combine)
            }
            
            // My Portfolio header
            HStack(alignment: .center) {
                Text("My Portfolio")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
                Spacer()
                HStack(spacing: 4) {
                    Text("Monthly")
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.accentColor)
            }
            .padding(.top, 8)
            
            // Portfolio list - 5 random currencies with sparkline
            Group {
                if homeVM.isLoading && homeVM.portfolioItems.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                } else if let error = homeVM.errorMessage, homeVM.portfolioItems.isEmpty {
                    ErrorStateView(message: error) {
                        homeVM.refresh()
                    }
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(homeVM.portfolioItems) { item in
                            PortfolioRow(item: item)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
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
                ErrorStateView(message: error) {
                    homeVM.refresh()
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(homeVM.marketStats, id: \.id) { currency in
                        NavigationButton(push: .details(currencyID: currency.id)) {
                            HStack(spacing: 12) {
                                CachedImage(url: URL(string: currency.image))
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
                                    Text(currency.currentPrice.formatted(.currency(code: "USD")))
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
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(currency.name), \(currency.currentPrice.formatted(.currency(code: "USD")))")
                        .accessibilityValue(currency.priceChangePercentage24H >= 0 ? "Up by \(String(format: "%.2f", currency.priceChangePercentage24H)) percent" : "Down by \(String(format: "%.2f", abs(currency.priceChangePercentage24H))) percent")
                    }
                }
            }
        }
    }
}

private struct PortfolioRow: View {
    let item: PortfolioItem

    var body: some View {
        NavigationButton(push: .details(currencyID: item.currency.id)) {
            HStack(spacing: 12) {
                CachedImage(url: URL(string: item.currency.image))
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.currency.name)
                        .font(.system(size: 16, weight: .semibold))
                    Text(item.currency.symbol.uppercased())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Spacer(minLength: 6)

                Chart {
                    ForEach(Array(item.sparkline.enumerated()), id: \.offset) { (i, y) in
                        LineMark(
                            x: .value("Index", i),
                            y: .value("Price", y)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(lineColor)

                        AreaMark(
                            x: .value("Index", i),
                            y: .value("Price", y)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(LinearGradient(colors: [lineColor.opacity(0.35), .clear], startPoint: .top, endPoint: .bottom))
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .frame(width: 80, height: 20)

                Spacer(minLength: 6)

                VStack(alignment: .trailing, spacing: 2) {
                    Text(item.mockPrice.formatted(.currency(code: "USD")))
                        .font(.system(size: 16, weight: .semibold))

                    HStack(spacing: 4) {
                        Image(systemName: item.mockChangePct >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .scaleEffect(x: 1.0, y: 0.5, anchor: .center)
                        Text(String(format: "%.2f%%", abs(item.mockChangePct)))
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(item.mockChangePct >= 0 ? .green : .red)
                }
            }
            .padding(.vertical, 6)
            .padding(.leading, 1)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(item.currency.name), Portfolio balance \(item.mockPrice.formatted(.currency(code: "USD")))")
        .accessibilityValue(item.mockChangePct >= 0 ? "Up by \(String(format: "%.2f", item.mockChangePct)) percent" : "Down by \(String(format: "%.2f", abs(item.mockChangePct))) percent")
    }

    private var lineColor: Color {
        item.mockChangePct >= 0 ? .green : .red
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

