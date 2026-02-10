import Foundation
import SwiftUI
import Combine  // MARK: - 必须导入 Combine 框架，否则 @Published 会报错

class AssetManager: ObservableObject {
    // 发布的资产数组，一旦改变，UI 会自动刷新
    @Published var assets: [Asset] = [] {
        didSet {
            save() // 每次数据变动（增删改），自动保存
        }
    }
    
    // 获取文件的存储路径 (Documents/assets.json)
    private var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("assets.json")
    }
    
    init() {
        load() // 初始化时加载数据
    }
    
    // MARK: - 增删改查逻辑
    
    // 添加资产
    func add(_ asset: Asset) {
        assets.append(asset)
    }
    
    // 删除资产 (支持滑动删除等)
    func delete(at offsets: IndexSet) {
        assets.remove(atOffsets: offsets)
    }
    
    // 删除特定资产
    func delete(_ asset: Asset) {
        if let index = assets.firstIndex(of: asset) {
            assets.remove(at: index)
        }
    }
    
    // MARK: - 持久化逻辑 (JSON)
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(assets)
            try data.write(to: fileURL)
            print("数据保存成功: \(fileURL)")
        } catch {
            print("保存失败: \(error.localizedDescription)")
        }
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            assets = try JSONDecoder().decode([Asset].self, from: data)
            print("数据加载成功，共 \(assets.count) 条")
        } catch {
            print("加载失败 (可能是第一次运行): \(error.localizedDescription)")
            assets = [] // 如果加载失败（比如文件不存在），则初始化为空
        }
    }
}