//
//  DetailsView.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 24/9/2568 BE.
//

import SwiftUI
import Charts

struct DetailsView: View {
    let currencyID: String
    
    @StateObject private var viewModel = DetailsViewModel()
    @State private var selectedPeriod: String = "1W"
    
    private let periodOptions = ["1H","1D","1W","1M","1Y","All"]
    
    var body: some View {
        VStack(spacing: 16) {
            headerSection
            Divider()
            statsRow
            periodSelector
            chartCard
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if viewModel.isLoading && viewModel.details == nil {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.7))
            } else if let error = viewModel.errorMessage, viewModel.details == nil {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.7))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 15, weight: .bold))
                }
                .tint(.accentColor)
                .accessibilityLabel("Favourite")
            }
        }
        .onAppear {
            if viewModel.details == nil {
                viewModel.load(id: currencyID)
            }
        }
    }
    
    private var headerSection: some View {
        HStack(spacing: 10) {
            if let details = viewModel.details {
                AsyncImage(url: URL(string: details.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        placeholderCircle(letter: details.name.first)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 6) {
                    Text("\(details.name) / \(details.symbol.uppercased())")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                    Text("$" + details.currentPrice.formatted(.number.locale(Locale(identifier: "en_US")).precision(.fractionLength(2))))
                        .font(.system(size: 30, weight: .semibold))
                }

                Spacer(minLength: 8)

                HStack(spacing: 6) {
                    Image(systemName: details.priceChangePercentage24H >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .font(.system(size: 10, weight: .bold))
                        .scaleEffect(x: 1.0, y: 0.6, anchor: .center)
                    Text(String(format: "%.2f%%", abs(details.priceChangePercentage24H)))
                }
                .font(.caption.weight(.semibold))
                .foregroundColor(details.priceChangePercentage24H >= 0 ? .green : .red)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill((details.priceChangePercentage24H >= 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2)))
                )
            } else {
                placeholderCircle(letter: nil)
                VStack(alignment: .leading, spacing: 6) {
                    Text("?/ ?")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                    Text("?")
                        .font(.system(size: 34, weight: .semibold))
                }
                Spacer(minLength: 8)
                Text("?")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                    )
            }
        }
    }
    
    @ViewBuilder
    private func placeholderCircle(letter: Character?) -> some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
            if let char = letter {
                Text(String(char).uppercased())
                    .font(.title.bold())
                    .foregroundColor(.white)
            }
        }
    }
    
    private var statsRow: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("POPULARITY")
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.secondary)
                Text(viewModel.details.map { "#\($0.marketCapRank)" } ?? "#?")
                    .font(.callout.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .center, spacing: 6) {
                Text("MARKET CAP")
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.secondary)
                Text(viewModel.details.map { "$" + abbreviatedNumber(Double($0.marketCap)) } ?? "?")
                    .font(.callout.bold())
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .trailing, spacing: 6) {
                Text("VOLUME")
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.secondary)
                Text(viewModel.details.map { "$" + abbreviatedNumber(Double($0.totalVolume)) } ?? "?")
                    .font(.callout.bold())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var periodSelector: some View {
        HStack(spacing: 8) {
            ForEach(periodOptions, id: \.self) { option in
                Button {
                    selectedPeriod = option
                } label: {
                    Text(option)
                        .font(.footnote.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(
                            Capsule()
                                .fill(selectedPeriod == option ? Color.accentColor : Color.gray.opacity(0.2))
                        )
                        .foregroundColor(selectedPeriod == option ? .white : .primary)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var chartCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(colors: [Color.blue.opacity(0.15), Color.clear], startPoint: .top, endPoint: .bottom)
                )
            
            if !viewModel.pricePoints.isEmpty {
                Chart {
                    ForEach(Array(viewModel.pricePoints.enumerated()), id: \.offset) { idx, point in
                        LineMark(
                            x: .value("Index", idx),
                            y: .value("Price", point.price)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.accentColor)
                        AreaMark(
                            x: .value("Index", idx),
                            y: .value("Price", point.price)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(colors: [Color.blue.opacity(0.15), Color.clear], startPoint: .top, endPoint: .bottom)
                        )
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .padding()
            } else {
                Text("No Chart Data")
                    .foregroundColor(.secondary)
            }
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentColor.opacity(0.8), lineWidth: 1)
        }
        .overlay(alignment: .bottom) {
            minMaxPriceRow
                .padding([.horizontal, .bottom], 12)
        }
    }
    
    private var minMaxPriceRow: some View {
        HStack {
            Text("MIN \(viewModel.minPrice != nil ? String(format: "$%.2f", viewModel.minPrice!) : "?")")
                .font(.footnote.weight(.medium))
            Spacer()
            Text("MAX \(viewModel.maxPrice != nil ? String(format: "$%.2f", viewModel.maxPrice!) : "?")")
                .font(.footnote.weight(.medium))
        }
        .padding(.horizontal, 4)
    }
    
    private func abbreviatedNumber(_ num: Double) -> String {
        let absNum = abs(num)
        let sign = (num < 0) ? "-" : ""
        switch absNum {
        case 1_000_000_000...:
            let formatted = absNum / 1_000_000_000
            return "\(sign)\(String(format: "%.1f b", formatted))"
        case 1_000_000...:
            let formatted = absNum / 1_000_000
            return "\(sign)\(String(format: "%.1f m", formatted))"
        case 1_000...:
            let formatted = absNum / 1_000
            return "\(sign)\(String(format: "%.1f k", formatted))"
        default:
            return "\(sign)\(String(format: "%.0f", absNum))"
        }
    }
}

#Preview {
    NavigationContainer(parentRouter: .previewRouter()) {
        DetailsView(currencyID: "bitcoin")
    }
}

