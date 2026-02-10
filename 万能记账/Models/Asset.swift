import Foundation
import SwiftUI

// 1. 账户类型 (添加 Codable)
enum AssetType: String, CaseIterable, Identifiable, Codable {
    case money = "资金账户"
    case credit = "信用账户"
    case recharge = "充值账户"
    case investment = "理财账户"
    case receivable = "应收账户"
    case payable = "应付账户"
    
    var id: String { rawValue }
    
    var isLiability: Bool {
        switch self {
        case .credit, .payable: return true
        default: return false
        }
    }
}

// 2. 资产模型 (添加 Codable, Equatable)
struct Asset: Identifiable, Codable, Equatable {
    var id = UUID() // 改为 var，确保解码时能灵活处理，虽然通常 let 也可以
    var name: String
    var balance: Double
    let type: AssetType
    var iconName: String
    var iconColor: String
    
    var note: String = ""
    var currency: String = "CNY"
    var includeInTotal: Bool = true
    var isSelectable: Bool = true
}
