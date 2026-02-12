import SwiftUI

struct UserProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userNickname") private var userNickname: String = "用户"
    @AppStorage("userAvatar") private var userAvatar: String = "person.crop.circle.fill"

    let avatarColors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .red, .yellow, .cyan, .indigo, .mint, .teal, .brown
    ]

    var avatarColor: Color {
        let avatarOptions = [
            "person.crop.circle.fill",
            "face.smiling.fill",
            "face.dashed.fill",
            "person.fill",
            "person.2.fill",
            "star.fill",
            "heart.fill",
            "leaf.fill",
            "flame.fill",
            "moon.fill",
            "sun.max.fill",
            "cloud.fill"
        ]
        if let index = avatarOptions.firstIndex(of: userAvatar) {
            return avatarColors[index % avatarColors.count]
        }
        return .blue
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: userAvatar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(avatarColor)
                            .frame(width: 80, height: 80)
                            .background(avatarColor.opacity(0.2))
                            .clipShape(Circle())
                            .shadow(radius: 5)

                        Text(userNickname)
                            .font(.title3.bold())
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)

            Section {
                NavigationLink(destination: Text("账单导入页面")) { Label("账单导入", systemImage: "square.and.arrow.down") }
                NavigationLink(destination: Text("账单导出页面")) { Label("账单导出", systemImage: "square.and.arrow.up") }
                NavigationLink(destination: Text("截图导入页面")) { Label("截图导入", systemImage: "photo.badge.plus") }
            }

            Section {
                NavigationLink(destination: Text("分类管理页面")) { Label("分类管理", systemImage: "tag") }
                NavigationLink(destination: Text("货币和汇率页面")) { Label("货币和汇率", systemImage: "dollarsign.circle") }
                NavigationLink(destination: Text("外观设置页面")) { Label("外观设置", systemImage: "paintbrush") }
            }

            Section {
                NavigationLink(destination: Text("帮助与反馈页面")) { Label("帮助与反馈", systemImage: "questionmark.circle") }
                NavigationLink(destination: Text("分享给朋友页面")) { Label("分享给朋友", systemImage: "square.and.arrow.up") }
                NavigationLink(destination: Text("语言设置页面")) { Label("语言设置", systemImage: "globe") }
            }
        }
        .navigationTitle("个人中心")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        UserProfileView()
    }
}