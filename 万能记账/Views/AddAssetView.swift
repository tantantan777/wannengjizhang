import SwiftUI

struct AddAssetView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - 关键：定义回调闭包（这正是报错缺少的部分）
    var onSave: (Asset) -> Void
    
    struct AccountTemplate: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let icon: String
        let color: Color
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }
    
    let moneyAccounts = [
        AccountTemplate(name: "支付宝", icon: "支付宝", color: .blue),
        AccountTemplate(name: "微信钱包", icon: "微信", color: .green),
        AccountTemplate(name: "QQ钱包", icon: "QQ钱包", color: .blue),
        AccountTemplate(name: "抖音钱包", icon: "抖音钱包", color: .black),
        AccountTemplate(name: "PayPal", icon: "PayPal", color: .blue),
        AccountTemplate(name: "钱包", icon: "wallet.pass.fill", color: .brown),
        AccountTemplate(name: "储蓄卡", icon: "creditcard.fill", color: .orange)
    ]
    let creditAccounts = [
        AccountTemplate(name: "蚂蚁花呗", icon: "creditcard.circle.fill", color: .blue),
        AccountTemplate(name: "京东白条", icon: "cart.circle.fill", color: .red)
    ]
    let rechargeAccounts = [
        AccountTemplate(name: "公交卡", icon: "bus.fill", color: .purple),
        AccountTemplate(name: "饭卡", icon: "fork.knife.circle.fill", color: .orange)
    ]
    let investmentAccounts = [
        AccountTemplate(name: "股票", icon: "chart.bar.xaxis", color: .red),
        AccountTemplate(name: "基金", icon: "chart.xyaxis.line", color: .red),
        AccountTemplate(name: "数字货币", icon: "数字货币", color: .orange)
    ]

    var body: some View {
        List {
            sectionView(title: "资金账户", items: moneyAccounts, type: .money)
            sectionView(title: "信用账户", items: creditAccounts, type: .credit)
            sectionView(title: "充值账户", items: rechargeAccounts, type: .recharge)
            sectionView(title: "理财账户", items: investmentAccounts, type: .investment)
        }
        .navigationTitle("选择类型")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.grouped)
        .toolbar(.hidden, for: .tabBar)
        .background(Color(.systemGroupedBackground))
    }
    
    func sectionView(title: String, items: [AccountTemplate], type: AssetType) -> some View {
        Section(header: Text(title)) {
            ForEach(items) { item in
                // MARK: - 关键：将 onSave 传递给下一级页面
                // 如果是储蓄卡，跳转到银行选择页面；否则直接跳转到详情页
                if item.name == "储蓄卡" {
                    NavigationLink(destination: BankSelectionView(type: type, onSave: onSave)) {
                        HStack(spacing: 12) {
                            if item.icon.contains(".") {
                                // 系统图标
                                Image(systemName: item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(item.color)
                            } else {
                                // 自定义svg图标
                                Image(item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            Text(item.name)
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    NavigationLink(destination: AddAccountDetailView(template: item, type: type, onSave: onSave)) {
                        HStack(spacing: 12) {
                            if item.icon.contains(".") {
                                // 系统图标
                                Image(systemName: item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(item.color)
                            } else {
                                // 自定义svg图标
                                Image(item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            Text(item.name)
                                .foregroundStyle(.primary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}