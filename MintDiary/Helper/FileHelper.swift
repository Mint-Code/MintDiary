import Foundation

// MARK: - FileManager扩展
extension FileManager {
    var documentDirectory: URL {
        do {
             return try self.url(for: .documentDirectory, in: .userDomainMask,  appropriateFor: nil, create: true)
          }
          catch let error {
              fatalError("获得本地存储路径失败：\(error.localizedDescription)")
          }
    }
    
    func copyItemToDocumentDirectory(from sourceURL: URL) throws -> URL? {
        let fileName = sourceURL.lastPathComponent
        let destinationURL = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: destinationURL.path) {
            return destinationURL
        } else {
            try self.copyItem(at: sourceURL, to: destinationURL)
            return destinationURL
        }
    }
    
    func removeItemFromDocumentDirectory(url: URL) {
        let fileName = url.lastPathComponent
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        if self.fileExists(atPath: fileUrl.path) {
            do {
                try self.removeItem(at: url)
            } catch let error {
                print("移动文件失败：\(error.localizedDescription)")
            }
        }
    }
}
