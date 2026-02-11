import SwiftUI

struct BankSelectionView: View {
    @Environment(\.dismiss) var dismiss

    let type: AssetType
    var onSave: (Asset) -> Void

    // 银行模板
    struct BankTemplate: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color

        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }

    let banks = [
        BankTemplate(name: "中国人民银行", icon: "中国人民银行", color: .red),
        BankTemplate(name: "国家开发银行", icon: "国家开发银行", color: .red),
        BankTemplate(name: "中国光大银行", icon: "中国光大银行", color: .red),
        BankTemplate(name: "中国进出口银行", icon: "中国进出口银行", color: .red),
        BankTemplate(name: "交通银行", icon: "交通银行", color: .red)
 
    ]

    var body: some View {
        List {
            Section(header: Text("选择银行")) {
                ForEach(banks) { bank in
                    NavigationLink(destination: AddAccountDetailView(
                        template: AddAssetView.AccountTemplate(
                            name: bank.name,
                            icon: bank.icon,
                            color: bank.color
                        ),
                        type: type,
                        onSave: onSave
                    )) {
                        HStack(spacing: 12) {
                            Image(bank.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text(bank.name)
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("选择银行")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.grouped)
        .background(Color(.systemGroupedBackground))
    }
}
