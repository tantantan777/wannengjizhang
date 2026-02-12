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
        BankTemplate(name: "ICICI银行", icon: "ICICI银行", color: .red),
        BankTemplate(name: "Skandinaviska Enskilda Banken AB", icon: "Skandinaviska Enskilda Banken AB", color: .red),
        BankTemplate(name: "安顺市商业银行", icon: "安顺市商业银行", color: .red),
        BankTemplate(name: "澳门国际银行", icon: "澳门国际银行", color: .red),
        BankTemplate(name: "澳门商业银行BCM", icon: "澳门商业银行BCM", color: .red),
        BankTemplate(name: "澳新银行ANZ", icon: "澳新银行ANZ", color: .red),
        BankTemplate(name: "巴克莱银行Barclays", icon: "巴克莱银行Barclays", color: .red),
        BankTemplate(name: "巴西银行", icon: "巴西银行", color: .red),
        BankTemplate(name: "比利时联合银行KBC", icon: "比利时联合银行KBC", color: .red),
        BankTemplate(name: "渤海银行", icon: "渤海银行", color: .red),
        BankTemplate(name: "成都银行", icon: "成都银行", color: .red),
        BankTemplate(name: "创兴银行", icon: "创兴银行", color: .red),
        BankTemplate(name: "达州银行", icon: "达州银行", color: .red),
        BankTemplate(name: "大丰银行Tai Fung Bank Limited", icon: "大丰银行Tai Fung Bank Limited", color: .red),
        BankTemplate(name: "大庆市商业银行", icon: "大庆市商业银行", color: .red),
        BankTemplate(name: "大众银行", icon: "大众银行", color: .red),
        BankTemplate(name: "德国商业银行", icon: "德国商业银行", color: .red),
        BankTemplate(name: "德累斯顿银行Dresdner Bank", icon: "德累斯顿银行Dresdner Bank", color: .red),
        BankTemplate(name: "德州银行", icon: "德州银行", color: .red),
        BankTemplate(name: "第一商业银行", icon: "第一商业银行", color: .red),
        BankTemplate(name: "东莞银行", icon: "东莞银行", color: .red),
        BankTemplate(name: "东京三菱银行BTM", icon: "东京三菱银行BTM", color: .red),
        BankTemplate(name: "东营银行", icon: "东营银行", color: .red),
        BankTemplate(name: "法国东方汇理银行CACIB", icon: "法国东方汇理银行CACIB", color: .red),
        BankTemplate(name: "法国里昂信贷银行LCL", icon: "法国里昂信贷银行LCL", color: .red),
        BankTemplate(name: "福建海峡银行", icon: "福建海峡银行", color: .red),
        BankTemplate(name: "富滇银行", icon: "富滇银行", color: .red),
        BankTemplate(name: "甘肃银行", icon: "甘肃银行", color: .red),
        BankTemplate(name: "赣州银行", icon: "赣州银行", color: .red),
        BankTemplate(name: "广东华兴银行", icon: "广东华兴银行", color: .red),
        BankTemplate(name: "广东南粤银行", icon: "广东南粤银行", color: .red),
        BankTemplate(name: "广发银行", icon: "广发银行", color: .red),
        BankTemplate(name: "广州银行", icon: "广州银行", color: .red),
        BankTemplate(name: "贵阳银行", icon: "贵阳银行", color: .red),
        BankTemplate(name: "贵州银行", icon: "贵州银行", color: .red),
        BankTemplate(name: "桂林银行", icon: "桂林银行", color: .red),
        BankTemplate(name: "国家开发银行", icon: "国家开发银行", color: .red),
        BankTemplate(name: "哈密市商业银行", icon: "哈密市商业银行", color: .red),
        BankTemplate(name: "韩国产业银行KDB", icon: "韩国产业银行KDB", color: .red),
        BankTemplate(name: "韩国外换银行KEB", icon: "韩国外换银行KEB", color: .red),
        BankTemplate(name: "汉口银行", icon: "汉口银行", color: .red),
        BankTemplate(name: "杭州联合银行", icon: "杭州联合银行", color: .red),
        BankTemplate(name: "合作金库商业银行", icon: "合作金库商业银行", color: .red),
        BankTemplate(name: "荷兰银行ABN AMRO", icon: "荷兰银行ABN AMRO", color: .red),
        BankTemplate(name: "鹤壁银行", icon: "鹤壁银行", color: .red),
        BankTemplate(name: "恒丰银行", icon: "恒丰银行", color: .red),
        BankTemplate(name: "横滨银行Hamagin", icon: "横滨银行Hamagin", color: .red),
        BankTemplate(name: "湖北银行", icon: "湖北银行", color: .red),
        BankTemplate(name: "湖南三湘银行", icon: "湖南三湘银行", color: .red),
        BankTemplate(name: "湖南银行", icon: "湖南银行", color: .red),
        BankTemplate(name: "湖州市商业银行", icon: "湖州市商业银行", color: .red),
        BankTemplate(name: "华南商业银行", icon: "华南商业银行", color: .red),
        BankTemplate(name: "华侨银行OCBC", icon: "华侨银行OCBC", color: .red),
        BankTemplate(name: "华夏银行", icon: "华夏银行", color: .red),
        BankTemplate(name: "徽商银行", icon: "徽商银行", color: .red),
        BankTemplate(name: "集友银行", icon: "集友银行", color: .red),
        BankTemplate(name: "济宁银行", icon: "济宁银行", color: .red),
        BankTemplate(name: "加拿大丰业银行ScotiaBank", icon: "加拿大丰业银行ScotiaBank", color: .red),
        BankTemplate(name: "加拿大皇家银行RBC", icon: "加拿大皇家银行RBC", color: .red),
        BankTemplate(name: "江苏苏宁银行", icon: "江苏苏宁银行", color: .red),
        BankTemplate(name: "江西银行", icon: "江西银行", color: .red),
        BankTemplate(name: "交通银行", icon: "交通银行", color: .red),
        BankTemplate(name: "焦作市商业银行", icon: "焦作市商业银行", color: .red),
        BankTemplate(name: "金华银行", icon: "金华银行", color: .red),
        BankTemplate(name: "九江银行", icon: "九江银行", color: .red),
        BankTemplate(name: "库尔勒银行", icon: "库尔勒银行", color: .red),
        BankTemplate(name: "昆仑银行", icon: "昆仑银行", color: .red),
        BankTemplate(name: "莱商银行", icon: "莱商银行", color: .red),
        BankTemplate(name: "兰州银行", icon: "兰州银行", color: .red),
        BankTemplate(name: "乐山市商业银行", icon: "乐山市商业银行", color: .red),
        BankTemplate(name: "联昌国际银行CIMB", icon: "联昌国际银行CIMB", color: .red),
        BankTemplate(name: "凉山州商业银行", icon: "凉山州商业银行", color: .red),
        BankTemplate(name: "辽宁振兴银行", icon: "辽宁振兴银行", color: .red),
        BankTemplate(name: "临商银行", icon: "临商银行", color: .red),
        BankTemplate(name: "柳州银行", icon: "柳州银行", color: .red),
        BankTemplate(name: "泸州银行", icon: "泸州银行", color: .red),
        BankTemplate(name: "洛阳银行", icon: "洛阳银行", color: .red),
        BankTemplate(name: "马来亚银行Maybank", icon: "马来亚银行Maybank", color: .red),
        BankTemplate(name: "美国银行BOA", icon: "美国银行BOA", color: .red),
        BankTemplate(name: "绵阳商业银行", icon: "绵阳商业银行", color: .red),
        BankTemplate(name: "名古屋银行The Bank of Nagoya", icon: "名古屋银行The Bank of Nagoya", color: .red),
        BankTemplate(name: "南阳银行", icon: "南阳银行", color: .red),
        BankTemplate(name: "宁夏银行", icon: "宁夏银行", color: .red),
        BankTemplate(name: "攀枝花市商业银行", icon: "攀枝花市商业银行", color: .red),
        BankTemplate(name: "平安银行", icon: "平安银行", color: .red),
        BankTemplate(name: "平顶山银行", icon: "平顶山银行", color: .red),
        BankTemplate(name: "齐鲁银行", icon: "齐鲁银行", color: .red),
        BankTemplate(name: "齐商银行", icon: "齐商银行", color: .red),
        BankTemplate(name: "青岛银行", icon: "青岛银行", color: .red),
        BankTemplate(name: "青海银行", icon: "青海银行", color: .red),
        BankTemplate(name: "曲靖市商业银行", icon: "曲靖市商业银行", color: .red),
        BankTemplate(name: "泉州银行", icon: "泉州银行", color: .red),
        BankTemplate(name: "日照银行", icon: "日照银行", color: .red),
        BankTemplate(name: "瑞典商业银行", icon: "瑞典商业银行", color: .red),
        BankTemplate(name: "三和银行The Sanwa Bank", icon: "三和银行The Sanwa Bank", color: .red),
        BankTemplate(name: "三井住友信托银行SMTB", icon: "三井住友信托银行SMTB", color: .red),
        BankTemplate(name: "桑坦德银行", icon: "桑坦德银行", color: .red),
        BankTemplate(name: "厦门国际银行", icon: "厦门国际银行", color: .red),
        BankTemplate(name: "厦门银行", icon: "厦门银行", color: .red),
        BankTemplate(name: "上海华瑞银行", icon: "上海华瑞银行", color: .red),
        BankTemplate(name: "上海浦东发展银行", icon: "上海浦东发展银行", color: .red),
        BankTemplate(name: "上海商业银行", icon: "上海商业银行", color: .red),
        BankTemplate(name: "上饶银行", icon: "上饶银行", color: .red),
        BankTemplate(name: "深证商业银行", icon: "深证商业银行", color: .red),
        BankTemplate(name: "石嘴山银行", icon: "石嘴山银行", color: .red),
        BankTemplate(name: "四川天府银行", icon: "四川天府银行", color: .red),
        BankTemplate(name: "四川新网银行", icon: "四川新网银行", color: .red),
        BankTemplate(name: "苏格兰皇家银行RBS", icon: "苏格兰皇家银行RBS", color: .red),
        BankTemplate(name: "遂宁银行", icon: "遂宁银行", color: .red),
        BankTemplate(name: "台湾土地银行", icon: "台湾土地银行", color: .red),
        BankTemplate(name: "台湾银行", icon: "台湾银行", color: .red),
        BankTemplate(name: "台湾中小企业银行", icon: "台湾中小企业银行", color: .red),
        BankTemplate(name: "台州银行", icon: "台州银行", color: .red),
        BankTemplate(name: "泰安银行", icon: "泰安银行", color: .red),
        BankTemplate(name: "天津金城银行", icon: "天津金城银行", color: .red),
        BankTemplate(name: "微众银行", icon: "微众银行", color: .red),
        BankTemplate(name: "潍坊银行", icon: "潍坊银行", color: .red),
        BankTemplate(name: "温州民商银行", icon: "温州民商银行", color: .red),
        BankTemplate(name: "温州银行", icon: "温州银行", color: .red),
        BankTemplate(name: "乌鲁木齐银行", icon: "乌鲁木齐银行", color: .red),
        BankTemplate(name: "武汉众邦银行", icon: "武汉众邦银行", color: .red),
        BankTemplate(name: "西安银行", icon: "西安银行", color: .red),
        BankTemplate(name: "西藏银行", icon: "西藏银行", color: .red),
        BankTemplate(name: "新疆汇和银行", icon: "新疆汇和银行", color: .red),
        BankTemplate(name: "新乡市商业银行", icon: "新乡市商业银行", color: .red),
        BankTemplate(name: "信阳银行", icon: "信阳银行", color: .red),
        BankTemplate(name: "兴业银行", icon: "兴业银行", color: .red),
        BankTemplate(name: "许昌银行", icon: "许昌银行", color: .red),
        BankTemplate(name: "雅安市商业银行", icon: "雅安市商业银行", color: .red),
        BankTemplate(name: "烟台银行", icon: "烟台银行", color: .red),
        BankTemplate(name: "宜宾市商业银行", icon: "宜宾市商业银行", color: .red),
        BankTemplate(name: "鄞州银行", icon: "鄞州银行", color: .red),
        BankTemplate(name: "印度国家银行SBI", icon: "印度国家银行SBI", color: .red),
        BankTemplate(name: "云南红塔银行", icon: "云南红塔银行", color: .red),
        BankTemplate(name: "长安银行", icon: "长安银行", color: .red),
        BankTemplate(name: "长城华西银行", icon: "长城华西银行", color: .red),
        BankTemplate(name: "长沙银行", icon: "长沙银行", color: .red),
        BankTemplate(name: "招商银行", icon: "招商银行", color: .red),
        BankTemplate(name: "兆丰国际商业银行Mega Bank", icon: "兆丰国际商业银行Mega Bank", color: .red),
        BankTemplate(name: "浙江稠州商业银行", icon: "浙江稠州商业银行", color: .red),
        BankTemplate(name: "浙江民泰商业银行", icon: "浙江民泰商业银行", color: .red),
        BankTemplate(name: "浙江泰隆商业银行", icon: "浙江泰隆商业银行", color: .red),
        BankTemplate(name: "浙商银行", icon: "浙商银行", color: .red),
        BankTemplate(name: "郑州银行", icon: "郑州银行", color: .red),
        BankTemplate(name: "中国工商银行", icon: "中国工商银行", color: .red),
        BankTemplate(name: "中国光大银行", icon: "中国光大银行", color: .red),
        BankTemplate(name: "中国建设银行", icon: "中国建设银行", color: .red),
        BankTemplate(name: "中国进出口银行", icon: "中国进出口银行", color: .red),
        BankTemplate(name: "中国民生银行", icon: "中国民生银行", color: .red),
        BankTemplate(name: "中国农业发展银行", icon: "中国农业发展银行", color: .red),
        BankTemplate(name: "中国农业银行", icon: "中国农业银行", color: .red),
        BankTemplate(name: "中国人民银行", icon: "中国人民银行", color: .red),
        BankTemplate(name: "中国信托商业银行", icon: "中国信托商业银行", color: .red),
        BankTemplate(name: "中国银行", icon: "中国银行", color: .red),
        BankTemplate(name: "中国邮政储蓄银行", icon: "中国邮政储蓄银行", color: .red),
        BankTemplate(name: "中华开发工业银行", icon: "中华开发工业银行", color: .red),
        BankTemplate(name: "中信银行", icon: "中信银行", color: .red),
        BankTemplate(name: "中原银行", icon: "中原银行", color: .red),
        BankTemplate(name: "重庆三峡银行", icon: "重庆三峡银行", color: .red),
        BankTemplate(name: "重庆银行", icon: "重庆银行", color: .red),
        BankTemplate(name: "周口银行", icon: "周口银行", color: .red),
        BankTemplate(name: "珠海华润银行", icon: "珠海华润银行", color: .red),
        BankTemplate(name: "自贡银行", icon: "自贡银行", color: .red)
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
