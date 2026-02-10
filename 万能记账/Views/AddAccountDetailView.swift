import SwiftUI

struct AddAccountDetailView: View {
    // 接收参数
    let template: AddAssetView.AccountTemplate
    let type: AssetType
    
    // MARK: - 关键：定义回调闭包
    var onSave: (Asset) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    // 表单状态
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var balance: String = ""
    @State private var currency: String = "人民币 (CNY)"
    @State private var includeInTotal: Bool = true
    @State private var isSelectable: Bool = true
    
    // 校验必填项
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !currency.isEmpty
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: template.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(template.color)
                    Text(template.name)
                        .font(.headline)
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            
            Section {
                HStack {
                    Text("账户名称")
                        .frame(width: 80, alignment: .leading)
                    TextField("请输入账户名称", text: $name)
                }
                
                HStack {
                    Text("账户备注")
                        .frame(width: 80, alignment: .leading)
                    TextField("点击填写备注（可不填）", text: $note)
                }
            }
            
            Section {
                HStack {
                    Text("账户余额")
                        .frame(width: 80, alignment: .leading)
                    TextField("0.00", text: $balance)
                        .keyboardType(.decimalPad)
                }
                
                NavigationLink {
                    Text("选择币种页面 (待开发)")
                } label: {
                    HStack {
                        Text("账户币种")
                            .frame(width: 80, alignment: .leading)
                        Spacer()
                        Text(currency)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section {
                Toggle("计入总资产", isOn: $includeInTotal)
                Toggle("记账时可被选择", isOn: $isSelectable)
            }
        }
        .navigationTitle("添加账户")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: saveAccount) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(isValid ? Color.blue : Color.gray)
                        .clipShape(Circle())
                }
                .disabled(!isValid)
            }
        }
        .onAppear {
             // 自动填充建议名称（可选）
             // if name.isEmpty { name = template.name }
        }
    }
    
    func saveAccount() {
        let amount = Double(balance) ?? 0.0
        let colorString = colorToString(template.color)
        
        let newAsset = Asset(
            name: name,
            balance: amount,
            type: type,
            iconName: template.icon,
            iconColor: colorString,
            note: note,
            currency: currency,
            includeInTotal: includeInTotal,
            isSelectable: isSelectable
        )
        
        // 调用回调
        onSave(newAsset)
    }
    
    func colorToString(_ color: Color) -> String {
        switch color {
        case .blue: return "blue"
        case .green: return "green"
        case .red: return "red"
        case .orange: return "orange"
        case .purple: return "purple"
        case .gray: return "gray"
        default: return "blue"
        }
    }
}