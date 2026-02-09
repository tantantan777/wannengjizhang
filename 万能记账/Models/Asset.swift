import Foundation

struct Asset: Identifiable {
    let id = UUID()
    let name: String
    let balance: Double
    let isLiability: Bool
}

extension Array where Element == Asset {
    static var sample: [Asset] {
        [
            Asset(name: "现金", balance: 15000, isLiability: false),
            Asset(name: "银行卡", balance: 50000, isLiability: false),
            Asset(name: "理财", balance: 20000, isLiability: false),
            Asset(name: "信用卡欠款", balance: -8000, isLiability: true),
            Asset(name: "贷款", balance: -20000, isLiability: true),
        ]
    }
}