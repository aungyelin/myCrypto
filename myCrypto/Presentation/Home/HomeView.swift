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
    
    @State private var portfolioBalance: Double = 12550.50
    @State private var portfolioChange: Double = 1204.12
    @State private var portfolioChangePct: Double = 10.75
    @State private var selectedPortfolioIndices: [Int] = []
    @State private var sparklineData: [Int: [Double]] = [:]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                portfolioSection
                marketStatistics
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .refreshable {
            homeVM.refresh()
        }
        .onAppear {
            homeVM.refresh()
            generatePortfolio(from: homeVM.marketStats)
        }
        .onReceive(homeVM.$marketStats) { newStats in
            generatePortfolio(from: newStats)
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
    
    private var portfolioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Balance card
            VStack(alignment: .leading, spacing: 8) {
                Text("Portfolio Balance")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(alignment: .center, spacing: 12) {
                    Text("$" + portfolioBalance.formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2))))
                        .font(.system(size: 38, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 11, weight: .bold))
                            .scaleEffect(x: 1.0, y: 0.6, anchor: .center)
                        Text(String(format: "%.2f%%", abs(portfolioChangePct)))
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
                }
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
                if homeVM.isLoading && portfolioCurrencies().isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                } else if let error = homeVM.errorMessage, portfolioCurrencies().isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(portfolioCurrencies(), id: \.id) { currency in
                            let idx = indexForCurrency(currency)
                            let points = sparklineData[idx] ?? []
                            PortfolioRow(currency: currency, points: points)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func portfolioCurrencies() -> [Currency] {
        selectedPortfolioIndices.compactMap { idx in
            guard idx >= 0 && idx < homeVM.marketStats.count else { return nil }
            return homeVM.marketStats[idx]
        }
    }
    
    private func indexForCurrency(_ currency: Currency) -> Int {
        return homeVM.marketStats.firstIndex(where: { $0.id == currency.id }) ?? -1
    }
    
    private func generatePortfolio(from stats: [Currency]) {
        guard !stats.isEmpty else { return }
        let count = min(5, stats.count)
        let indices = Array(0..<stats.count).shuffled().prefix(count)
        selectedPortfolioIndices = Array(indices)
        
        var newSpark: [Int: [Double]] = [:]
        for idx in selectedPortfolioIndices {
            guard idx >= 0 && idx < stats.count else { continue }
            let upward = Bool.random()
            newSpark[idx] = randomSparkline(upward: upward)
        }
        sparklineData = newSpark
    }
    
    private func randomSparkline(upward: Bool, count: Int = 20) -> [Double] {
        var values: [Double] = []
        var current = Double.random(in: 0.9...1.1)
        for _ in 0..<count {
            let step = Double.random(in: 0.0...0.04)
            current += (upward ? step : -step) + Double.random(in: -0.02...0.02)
            current = max(0.1, current)
            values.append(current)
        }
        // Normalize to 0...1 range for nicer chart rendering
        if let minV = values.min(), let maxV = values.max(), maxV > minV {
            return values.map { ($0 - minV) / (maxV - minV) }
        }
        return values
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
                        NavigationButton(push: .details(currencyID: currency.id)) {
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
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

private struct PortfolioRow: View {
    let currency: Currency
    let points: [Double]
    
    @State private var mockPrice: Double = 0
    @State private var mockChangePct: Double = 0

    var body: some View {
        NavigationButton(push: .details(currencyID: currency.id)) {
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

                Spacer(minLength: 6)

                Chart {
                    ForEach(Array(points.enumerated()), id: \.offset) { (i, y) in
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
                    Text("$" + mockPrice.formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2))))
                        .font(.system(size: 16, weight: .semibold))

                    HStack(spacing: 4) {
                        Image(systemName: mockChangePct >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            .scaleEffect(x: 1.0, y: 0.5, anchor: .center)
                        Text(String(format: "%.2f%%", abs(mockChangePct)))
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(mockChangePct >= 0 ? .green : .red)
                }
            }
            .padding(.vertical, 6)
            .padding(.leading, 1)
            .contentShape(Rectangle())
            .onAppear {
                if mockPrice == 0 {
                    mockPrice = Double.random(in: 50...20_000)
                    let sign: Double = Bool.random() ? 1 : -1
                    mockChangePct = sign * Double.random(in: 0.1...20.0)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var lineColor: Color {
        mockChangePct >= 0 ? .green : .red
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

