import SwiftUI

struct AssetsView: View {
    // MARK: - 核心：引入 AssetManager 进行数据管理
    @StateObject private var manager = AssetManager()
    
    // 列表展开状态控制
    @State private var isExpandedMoney: Bool = true
    @State private var isExpandedCredit: Bool = true
    @State private var isExpandedRecharge: Bool = true
    @State private var isExpandedInvestment: Bool = true
    @State private var isExpandedReceivable: Bool = true
    @State private var isExpandedPayable: Bool = true
    
    // 控制金额是否显示（隐私模式）
    @State private var showAmounts: Bool = true
    
    // MARK: - 计算属性 (基于 manager.assets 进行筛选)
    var moneyAccounts: [Asset] { manager.assets.filter { $0.type == .money } }
    var creditAccounts: [Asset] { manager.assets.filter { $0.type == .credit } }
    var rechargeAccounts: [Asset] { manager.assets.filter { $0.type == .recharge } }
    var investmentAccounts: [Asset] { manager.assets.filter { $0.type == .investment } }
    var receivableAccounts: [Asset] { manager.assets.filter { $0.type == .receivable } }
    var payableAccounts: [Asset] { manager.assets.filter { $0.type == .payable } }
    
    // 统计逻辑
    var totalAssets: Double {
        manager.assets.filter { !$0.type.isLiability && $0.includeInTotal }.map { $0.balance }.reduce(0, +)
    }
    var totalLiabilities: Double {
        manager.assets.filter { $0.type.isLiability && $0.includeInTotal }.map { abs($0.balance) }.reduce(0, +)
    }
    var netAssets: Double { totalAssets - totalLiabilities }
    
    var totalBorrowed: Double {
        payableAccounts.map { abs($0.balance) }.reduce(0, +) +
        creditAccounts.map { abs($0.balance) }.reduce(0, +)
    }
    var totalLent: Double {
        receivableAccounts.map { abs($0.balance) }.reduce(0, +)
    }
    
    // 辅助方法：获取当前货币代码
    var currentCurrencyCode: String {
        if #available(iOS 16, *) {
            return Locale.current.currency?.identifier ?? "CNY"
        } else {
            return Locale.current.currencyCode ?? "CNY"
        }
    }
    
    // MARK: - 核心逻辑：计算需要显示的分组
    // 定义一个临时结构体来辅助渲染
    private struct AssetGroup: Identifiable {
        var id: String { title } // 使用标题作为稳定 ID，防止列表闪烁
        let title: String
        let items: [Asset]
        let isExpanded: Binding<Bool>
    }
    
    // 动态生成只包含“有数据”的分组数组
    private var visibleGroups: [AssetGroup] {
        [
            AssetGroup(title: "资金账户", items: moneyAccounts, isExpanded: $isExpandedMoney),
            AssetGroup(title: "信用账户", items: creditAccounts, isExpanded: $isExpandedCredit),
            AssetGroup(title: "充值账户", items: rechargeAccounts, isExpanded: $isExpandedRecharge),
            AssetGroup(title: "理财账户", items: investmentAccounts, isExpanded: $isExpandedInvestment),
            AssetGroup(title: "应收账户", items: receivableAccounts, isExpanded: $isExpandedReceivable),
            AssetGroup(title: "应付账户", items: payableAccounts, isExpanded: $isExpandedPayable)
        ].filter { !$0.items.isEmpty } // 关键点：过滤掉空的账户列表
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 1. 净资产大卡片
                    netAssetCard
                    
                    // 2. 借入借出概览
                    HStack(spacing: 12) {
                        subCard(title: "总借入", amount: totalBorrowed, icon: "arrow.down", 
                                iconColor: .white, iconBg: .gray)
                        subCard(title: "总借出", amount: totalLent, icon: "arrow.up", 
                                iconColor: .white, iconBg: Color(hex: "56C18E"))
                    }
                    
                    // 3. 动态显示的账户列表
                    if visibleGroups.isEmpty {
                        // 如果所有账户都为空，显示一个友好的空状态
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.largeTitle)
                                .foregroundStyle(.tertiary)
                            Text("暂无账户，点击左上角添加")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 40)
                        .opacity(0.7)
                    } else {
                        VStack(spacing: 8) {
                            // 遍历可见的分组
                            ForEach(Array(visibleGroups.enumerated()), id: \.element.id) { index, group in
                                groupView(title: group.title, items: group.items, isExpanded: group.isExpanded)
                                
                                // 智能分割线：只有当不是最后一个元素时，才显示分割线
                                if index < visibleGroups.count - 1 {
                                    Divider().padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("资产")
            .toolbar {
                // 左上角：添加按钮
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: AddAssetView { newAsset in
                        manager.add(newAsset)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }

                // 右上角：头像入口
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: UserProfileView()) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.primary.opacity(0.1), lineWidth: 1))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }
    
    // 列表组视图生成器
    func groupView(title: String, items: [Asset], isExpanded: Binding<Bool>) -> some View {
        let amount = items.map { abs($0.balance) }.reduce(0, +)
        let label = items.first?.type.isLiability == true ? "欠款" : "余额"
        
        return CustomDisclosureGroup(
            title: title,
            count: items.count,
            amountLabel: label,
            amount: amount,
            items: items,
            isExpanded: isExpanded,
            showAmounts: showAmounts,
            currencyCode: currentCurrencyCode
        )
    }
    
    // MARK: - 净资产卡片
    var netAssetCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("净资产")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button { withAnimation { showAmounts.toggle() } } label: {
                    Image(systemName: showAmounts ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            Text(showAmounts ? (netAssets.formatted(.currency(code: currentCurrencyCode))) : "****")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Text("总资产")
                        .foregroundStyle(.secondary)
                    Text(showAmounts ? (totalAssets.formatted(.currency(code: currentCurrencyCode))) : "****")
                        .foregroundStyle(.secondary)
                }
                .font(.footnote)
                HStack(spacing: 4) {
                    Text("总负债")
                        .foregroundStyle(.secondary)
                    Text(showAmounts ? (totalLiabilities.formatted(.currency(code: currentCurrencyCode))) : "****")
                        .foregroundStyle(.secondary)
                }
                .font(.footnote)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 借入/借出小卡片
    func subCard(title: String, amount: Double, icon: String, iconColor: Color, iconBg: Color) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconBg)
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.caption.bold())
                    .foregroundStyle(iconColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(showAmounts ? (amount.formatted(.currency(code: currentCurrencyCode))) : "****")
                    .font(.callout.bold())
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - 沉浸式列表分组组件
struct CustomDisclosureGroup: View {
    let title: String
    let count: Int
    let amountLabel: String
    let amount: Double
    let items: [Asset]
    @Binding var isExpanded: Bool
    let showAmounts: Bool
    let currencyCode: String
    
    var body: some View {
        VStack(spacing: 0) {
            // 标题栏：保持沉浸式（无背景）
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("\(title)")
                        .font(.body.bold())
                        .foregroundStyle(.primary)
                    Text("(\(count))")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if showAmounts {
                        Text("\(amountLabel): \(amount.formatted(.currency(code: currencyCode)))")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(amountLabel): ****")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
            }
            
            // 展开的内容：卡片式（有背景 + 圆角）
            if isExpanded {
                VStack(spacing: 0) {
                    if items.isEmpty {
                        Text("暂无账户")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            HStack {
                                // 显示自定义的图标和颜色
                                Image(systemName: item.iconName)
                                    .foregroundStyle(Color(item.iconColor) ?? .blue)
                                Text(item.name)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text(showAmounts ? item.balance.formatted(.currency(code: currencyCode)) : "****")
                                    .font(.body)
                                    .foregroundStyle(item.type.isLiability ? Color.red : .primary)
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            
                            // 分割线 (最后一行除外)
                            if index < items.count - 1 {
                                Divider().padding(.leading, 16)
                            }
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .padding(.top, 4)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            }
        }
    }
}

// MARK: - 颜色扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // 字符串转颜色辅助
    init?(_ name: String) {
        switch name {
        case "blue": self = .blue
        case "green": self = .green
        case "red": self = .red
        case "orange": self = .orange
        case "purple": self = .purple
        case "gray": self = .gray
        default: return nil
        }
    }
}

#Preview {
    AssetsView()
}