import SwiftUI

struct AssetsView: View {
    // 模拟数据源
    @State private var items: [Asset] = .sample
    
    // 状态控制
    @State private var isExpandedMoney: Bool = false
    @State private var isExpandedCredit: Bool = false
    @State private var isExpandedPayable: Bool = false
    @State private var showAmounts: Bool = true
    
    // MARK: - 计算属性
    var moneyAccounts: [Asset] { items.filter { $0.type == .money } }
    var creditAccounts: [Asset] { items.filter { $0.type == .credit } }
    var payableAccounts: [Asset] { items.filter { $0.type == .payable } }
    
    var totalAssets: Double {
        items.filter { !$0.type.isLiability }.map { $0.balance }.reduce(0, +)
    }
    var totalLiabilities: Double {
        items.filter { $0.type.isLiability }.map { abs($0.balance) }.reduce(0, +)
    }
    var netAssets: Double { totalAssets - totalLiabilities }
    
    var totalBorrowed: Double {
        items.filter { $0.type == .credit || $0.type == .payable }.map { abs($0.balance) }.reduce(0, +)
    }
    var totalLent: Double {
        items.filter { $0.type == .receivable }.map { abs($0.balance) }.reduce(0, +)
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
                    
                    // 3. 账户列表
                    VStack(spacing: 8) {
                        CustomDisclosureGroup(
                            title: "资金账户",
                            count: moneyAccounts.count,
                            amountLabel: "余额",
                            amount: moneyAccounts.map{$0.balance}.reduce(0, +),
                            items: moneyAccounts,
                            isExpanded: $isExpandedMoney,
                            showAmounts: showAmounts
                        )
                        
                        // 仅在两者都折叠时显示分割线，或者始终显示分割线以区分区域
                        // 为了视觉整洁，这里我们保留分割线，但在展开时分割线会在卡片上方
                        Divider().padding(.horizontal)
                        
                        CustomDisclosureGroup(
                            title: "信用账户",
                            count: creditAccounts.count,
                            amountLabel: "欠款",
                            amount: creditAccounts.map{abs($0.balance)}.reduce(0, +),
                            items: creditAccounts,
                            isExpanded: $isExpandedCredit,
                            showAmounts: showAmounts
                        )
                        
                        Divider().padding(.horizontal)
                        
                        CustomDisclosureGroup(
                            title: "应付账户",
                            count: payableAccounts.count,
                            amountLabel: "欠款",
                            amount: payableAccounts.map{abs($0.balance)}.reduce(0, +),
                            items: payableAccounts,
                            isExpanded: $isExpandedPayable,
                            showAmounts: showAmounts
                        )
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("资产")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        print("点击添加")
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
                
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
            Text(showAmounts ? (netAssets.formatted(.currency(code: Locale.current.currencyCode ?? "CNY"))) : "****")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            HStack(spacing: 20) {
                HStack(spacing: 4) {
                    Text("总资产")
                        .foregroundStyle(.secondary)
                    Text(showAmounts ? (totalAssets.formatted(.currency(code: Locale.current.currencyCode ?? "CNY"))) : "****")
                        .foregroundStyle(.secondary)
                }
                .font(.footnote)
                HStack(spacing: 4) {
                    Text("总负债")
                        .foregroundStyle(.secondary)
                    Text(showAmounts ? (totalLiabilities.formatted(.currency(code: Locale.current.currencyCode ?? "CNY"))) : "****")
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
                Text(showAmounts ? (amount.formatted(.currency(code: Locale.current.currencyCode ?? "CNY"))) : "****")
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

// MARK: - 混合风格列表分组组件 (标题沉浸，内容卡片)
struct CustomDisclosureGroup: View {
    let title: String
    let count: Int
    let amountLabel: String
    let amount: Double
    let items: [Asset]
    @Binding var isExpanded: Bool
    let showAmounts: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. 标题栏：保持沉浸式（无背景）
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
                        Text("\(amountLabel): \(amount.formatted(.currency(code: Locale.current.currencyCode ?? "CNY")))")
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
            
            // 2. 展开的内容：卡片式（有背景 + 圆角）
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        HStack {
                            Text(item.name)
                                .font(.body)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(showAmounts ? item.balance.formatted(.currency(code: Locale.current.currencyCode ?? "CNY")) : "****")
                                .font(.body)
                                .foregroundStyle(item.type.isLiability ? Color.red : .primary)
                        }
                        .padding(.vertical, 14) // 增加卡片内部行高，更美观
                        .padding(.horizontal, 16)
                        
                        // 卡片内部的分割线
                        if index < items.count - 1 {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
                // MARK: 关键修改点
                .background(Color(.secondarySystemGroupedBackground)) // 恢复卡片背景（白色/深灰）
                .cornerRadius(16) // 添加圆角
                .padding(.top, 4) // 让卡片和标题栏有一点点间距
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4) // 稍微加点阴影，突出悬浮感
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
}

#Preview {
    AssetsView()
}