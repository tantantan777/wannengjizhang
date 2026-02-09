import SwiftUI
import AuthenticationServices

struct UserProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userNickname") private var userNickname: String = "用户"
    
    var body: some View {
        VStack {
            if isLoggedIn {
                loggedInContent
            } else {
                notLoggedInContent
            }
        }
        .navigationTitle("个人中心")
        .navigationBarTitleDisplayMode(.inline)
        // MARK: - 核心修改：隐藏底部 TabBar
        .toolbar(.hidden, for: .tabBar) 
    }
    
    // MARK: - 未登录视图
    var notLoggedInContent: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.secondary)
                
                Text("您尚未登录")
                    .font(.title2.bold())
                
                Text("登录以同步账单数据")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 16) {
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        handleAuthorization(authResults)
                    case .failure(let error):
                        print("登录失败: \(error.localizedDescription)")
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .cornerRadius(10)
                
                Button {
                    withAnimation {
                        userNickname = "测试用户"
                        isLoggedIn = true
                    }
                } label: {
                    Text("开发者模拟登录 (无需 Apple ID)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - 已登录视图
    var loggedInContent: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.blue)
                            .background(.white)
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
            
            Section {
                Button(role: .destructive) {
                    withAnimation {
                        isLoggedIn = false
                    }
                } label: {
                    Label("退出登录", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }
    
    func handleAuthorization(_ result: ASAuthorization) {
        if let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential {
            let givenName = appleIDCredential.fullName?.givenName ?? ""
            let familyName = appleIDCredential.fullName?.familyName ?? ""
            if !givenName.isEmpty {
                self.userNickname = "\(familyName)\(givenName)"
            }
            withAnimation {
                self.isLoggedIn = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserProfileView()
    }
}