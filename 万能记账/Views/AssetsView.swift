import SwiftUI

struct AssetsView: View {
    let items: [Asset] = .sample

    var totalAssets: Double {
        items.filter { !$0.isLiability }.map { $0.balance }.reduce(0, +)
    }
    var totalLiabilities: Double {
        items.filter { $0.isLiability }.map { abs($0.balance) }.reduce(0, +)
    }
    var netAssets: Double {
        totalAssets - totalLiabilities
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 液态玻璃卡片：净资产 / 总资产 / 总负债
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("净资产")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(netAssets, format: .currency(code: Locale.current.currencyCode ?? "CNY"))
                                .font(.largeTitle.bold())
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            VStack(alignment: .trailing) {
                                Text("总资产")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(totalAssets, format: .currency(code: Locale.current.currencyCode ?? "CNY"))
                                    .font(.headline.bold())
                            }

                            VStack(alignment: .trailing) {
                                Text("总负债")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(totalLiabilities, format: .currency(code: Locale.current.currencyCode ?? "CNY"))
                                    .font(.headline.bold())
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.primary.opacity(0.12), radius: 10, x: 0, y: 6)

                    // 各资产明细
                    VStack(spacing: 12) {
                        ForEach(items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.isLiability ? "负债" : "资产")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(item.balance, format: .currency(code: Locale.current.currencyCode ?? "CNY"))
                                    .font(.body.bold())
                                    .foregroundColor(item.isLiability ? .red : .primary)
                            }
                            .padding()
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("资产")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AssetsView()
}