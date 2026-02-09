import Foundation

enum AssetType: String, CaseIterable, Identifiable {
    case money = "资金账户"      // 现金、银行卡等 (资产)
    case credit = "信用账户"     // 信用卡、花呗等 (负债)
    case payable = "应付账户"    // 欠别人的钱 (负债 - 总借入)
    case receivable = "借出账户" // 借给别人的钱 (资产 - 总借出)
    
    var id: String { rawValue }
    
    // 是否为负债
    var isLiability: Bool {
        switch self {
        case .credit, .payable:
            return true
        case .money, .receivable:
            return false
        }
    }
}

struct Asset: Identifiable {
    let id = UUID()
    let name: String
    var balance: Double
    let type: AssetType
    
    // 辅助显示：如果是负债，余额通常显示为负数或红色
    var displayBalance: Double {
        return type.isLiability ? -abs(balance) : abs(balance)
    }
}

extension Array where Element == Asset {
    static var sample: [Asset] {
        [
            Asset(name: "现金钱包", balance: 2500, type: .money),
            Asset(name: "招商银行", balance: 50000, type: .money),
            Asset(name: "支付宝余额", balance: 8000, type: .money),
            Asset(name: "交通银行信用卡", balance: 5600, type: .credit), // 欠款
            Asset(name: "花呗", balance: 1200, type: .credit),
            Asset(name: "房贷", balance: 800000, type: .credit),
            Asset(name: "借小明的钱", balance: 5000, type: .payable), // 欠别人的
            Asset(name: "借给老王的钱", balance: 10000, type: .receivable) // 别人欠我的
        ]
    }
}