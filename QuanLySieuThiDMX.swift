import Foundation

struct SieuThiDMX: Codable, Hashable, Identifiable {
    var id: String
    var maSieuThi: String
    var tenSieuThi: String

    enum CodingKeys: String, CodingKey {
        case id
        case maSieuThi = "ma_sieu_thi"
        case tenSieuThi = "ten_sieu_thi"
    }
}

enum BoNhoSieuThiDMX {
    static let khoa = "dmx.sieu-thi-dang-chon.v1"
    static var idDangChon: String {
        get { UserDefaults.standard.string(forKey: khoa) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: khoa) }
    }

    static func tenTepAnToan(_ id: String) -> String {
        id.replacingOccurrences(of: "[^A-Za-z0-9_-]", with: "_", options: .regularExpression)
    }
}
