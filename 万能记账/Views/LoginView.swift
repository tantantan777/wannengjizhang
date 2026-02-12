import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userNickname") private var userNickname: String = ""
    @AppStorage("userAvatar") private var userAvatar: String = "person.crop.circle.fill"

    @State private var nickname: String = ""
    @State private var selectedAvatar: String = "person.crop.circle.fill"
    @State private var showError: Bool = false

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

    let avatarColors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .red, .yellow, .cyan, .indigo, .mint, .teal, .brown
    ]

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // 标题
            VStack(spacing: 12) {
                Image(systemName: "wallet.pass.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.blue)

                Text("欢迎使用万能记账")
                    .font(.title.bold())

                Text("请设置您的昵称和头像")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // 头像选择
            VStack(spacing: 16) {
                Text("选择头像")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                    ForEach(Array(avatarOptions.enumerated()), id: \.offset) { index, avatar in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedAvatar = avatar
                            }
                        } label: {
                            Image(systemName: avatar)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(avatarColors[index % avatarColors.count])
                                .frame(width: 60, height: 60)
                                .background(
                                    selectedAvatar == avatar
                                        ? avatarColors[index % avatarColors.count].opacity(0.2)
                                        : Color(.systemGray6)
                                )
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedAvatar == avatar
                                                ? avatarColors[index % avatarColors.count]
                                                : Color.clear,
                                            lineWidth: 2
                                        )
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 30)

            // 昵称输入
            VStack(spacing: 12) {
                Text("输入昵称")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("请输入昵称", text: $nickname)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .onChange(of: nickname) { _ in
                        showError = false
                    }

                if showError {
                    Text("请输入昵称")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 30)

            // 登录按钮
            Button {
                login()
            } label: {
                Text("开始使用")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .padding()
    }

    func login() {
        guard !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            withAnimation {
                showError = true
            }
            return
        }

        withAnimation {
            userNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
            userAvatar = selectedAvatar
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView()
}
