import UIKit

enum LoaiChiTieuThiDua: String, Codable, CaseIterable {
    case soLuong = "SLLK"
    case doanhThu = "DTLK"

    var maNgan: String {
        switch self {
        case .soLuong: return "SLLK"
        case .doanhThu: return "DTLK"
        }
    }
}

struct ThongTinDoanhThu: Codable, Hashable {
    var doanhThuThuc: Double = 0
    var targetThuc: Double = 0
    var doanhThuQuyDoi: Double = 0
    var targetQuyDoi: Double = 0

    var coDuLieu: Bool {
        doanhThuThuc > 0 || targetThuc > 0 || doanhThuQuyDoi > 0 || targetQuyDoi > 0
    }
}

struct DongThiDua: Codable, Hashable, Identifiable {
    var id = UUID()
    var tenNganhHang: String
    var loaiChiTieu: LoaiChiTieuThiDua
    var thucHien: Double
    var target: Double
    var phanTramHTGoc: Double?
    var phanTramDuBaoGoc: Double?

    /// Số còn thiếu (nếu > 0 là còn thiếu, nếu <= 0 là đã đạt/vượt)
    var conThieu: Double {
        max(0, target - thucHien)
    }

    var vuotMuc: Double {
        max(0, thucHien - target)
    }

    var phanTramHT: Double {
        if target > 0.0001 {
            return (thucHien / target) * 100.0
        }
        return phanTramHTGoc ?? 0
    }

    var phanTramDuBao: Double {
        if let goc = phanTramDuBaoGoc, goc > 0 {
            return goc
        }
        return phanTramHT * TienIchNgay.heSoDuBaoThang()
    }

    var daDat: Bool {
        phanTramHT >= 99.995
    }
}

struct DuLieuNgayDMX: Codable {
    var khoaNgay: String
    var capNhatLuc: String
    var thongTinDonVi: String
    var doanhThu: ThongTinDoanhThu
    var danhSachThiDua: [DongThiDua]
}

final class ThuMucDuLieu {
    static let dungChung = ThuMucDuLieu()

    let thuMuc: URL
    let tepNgay: URL

    private let maHoa: JSONEncoder = {
        let boMaHoa = JSONEncoder()
        boMaHoa.outputFormatting = [.prettyPrinted, .sortedKeys]
        return boMaHoa
    }()

    private let giaiMa = JSONDecoder()

    private init() {
        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        thuMuc = documents.appendingPathComponent("DuLieuDMX", isDirectory: true)
        tepNgay = thuMuc.appendingPathComponent("du-lieu-dmx-v2.json")

        try? FileManager.default.createDirectory(at: thuMuc, withIntermediateDirectories: true)
    }

    func doc<T: Decodable>(_ loai: T.Type, tu tep: URL) -> T? {
        guard let duLieu = try? Data(contentsOf: tep) else { return nil }
        return try? giaiMa.decode(loai, from: duLieu)
    }

    @discardableResult
    func ghi<T: Encodable>(_ giaTri: T, vao tep: URL) -> Bool {
        do {
            let duLieu = try maHoa.encode(giaTri)
            try duLieu.write(to: tep, options: .atomic)
            return true
        } catch {
            return false
        }
    }
}

final class KhoDuLieu {
    static let dungChung = KhoDuLieu()

    private(set) var cacNgay: [String: DuLieuNgayDMX] = [:]

    private init() {
        doc()
    }

    func doc() {
        let thuMuc = ThuMucDuLieu.dungChung
        if let giaTri = thuMuc.doc([String: DuLieuNgayDMX].self, tu: thuMuc.tepNgay) {
            cacNgay = giaTri
        } else {
            thuMuc.ghi(cacNgay, vao: thuMuc.tepNgay)
        }
    }

    func duLieu(cho ngay: Date) -> DuLieuNgayDMX {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        if let coSan = cacNgay[khoa] {
            return coSan
        }
        return DuLieuNgayDMX(
            khoaNgay: khoa,
            capNhatLuc: "",
            thongTinDonVi: "",
            doanhThu: ThongTinDoanhThu(),
            danhSachThiDua: []
        )
    }

    func luu(_ duLieu: DuLieuNgayDMX) {
        cacNgay[duLieu.khoaNgay] = duLieu
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
    }

    /// Làm sạch tên ngành hàng: Bỏ toàn bộ phần đầu thừa, chỉ tính từ mốc tháng (VD: "T10 - AUDIO", "T11 - TIVI")
    static func lamSachTenNganhHang(_ tenGoc: String) -> String {
        var s = tenGoc
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Loại bỏ các cụm từ thừa nếu bị lẫn vào
        let cumTuThua = [
            "Công Ty Cổ Phần Đầu Tư Điện Máy Xanh",
            "Công Ty Cổ Phần",
            "Điện Máy Xanh",
            "TỔNG",
            "SỐ LƯỢNG",
            "DOANH THU",
            "TARGET"
        ]
        for cum in cumTuThua {
            s = s.replacingOccurrences(of: cum, with: "", options: .caseInsensitive)
        }

        // Loại bỏ tên siêu thị dạng ĐML_... hoặc địa chỉ nếu nằm ở đầu/cuối
        s = s.replacingOccurrences(
            of: "(ĐML|ĐMX|TGDĐ)_[A-Z0-9_]+(\\s*-\\s*[^T]+)?",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )

        // Tìm mốc tháng dạng "T10 - ...", "T09 - T10 ...", "T11 - ..."
        // Nếu có nhiều mốc tháng (như "T09 - T10 IPHONE"), lấy từ mốc tháng cuối cùng ("T10 ...")
        let mauThang = "(?i)\\bT(0?[1-9]|1[0-2])\\b\\s*[-–]?\\s*"
        if let regex = try? NSRegularExpression(pattern: mauThang) {
            let nsString = s as NSString
            let ketQua = regex.matches(in: s, range: NSRange(location: 0, length: nsString.length))
            if let cuoi = ketQua.last {
                let phanThang = nsString.substring(with: cuoi.range(at: 1))
                let viTriSauThang = cuoi.range.location + cuoi.range.length
                let phanTen = nsString.substring(from: viTriSauThang)
                    .trimmingCharacters(in: CharacterSet(charactersIn: " -–:").union(.whitespacesAndNewlines))
                if !phanTen.isEmpty {
                    let thangChuan = Int(phanThang).map { String(format: "T%02d", $0) } ?? "T\(phanThang)"
                    return "\(thangChuan) - \(phanTen)"
                }
            }
        }

        return s.trimmingCharacters(in: CharacterSet(charactersIn: " -–:").union(.whitespacesAndNewlines))
    }

    /// Gộp danh sách thi đua mới quét vào danh sách hiện có, tự động khử trùng lặp
    static func gopDanhSachThiDua(cu: [DongThiDua], moi: [DongThiDua]) -> [DongThiDua] {
        var ketQua = cu
        for var dongMoi in moi {
            dongMoi.tenNganhHang = lamSachTenNganhHang(dongMoi.tenNganhHang)
            let khoaMoi = chuanHoaKhoaSoSanh(dongMoi.tenNganhHang)
            guard !khoaMoi.isEmpty else { continue }

            if let viTri = ketQua.firstIndex(where: { chuanHoaKhoaSoSanh($0.tenNganhHang) == khoaMoi }) {
                let dongCu = ketQua[viTri]
                if dongMoi.target > 0 || dongMoi.thucHien > 0 || (dongCu.target == 0 && dongCu.thucHien == 0) {
                    dongMoi.id = dongCu.id
                    ketQua[viTri] = dongMoi
                }
            } else {
                ketQua.append(dongMoi)
            }
        }
        return ketQua
    }

    static func chuanHoaKhoaSoSanh(_ ten: String) -> String {
        lamSachTenNganhHang(ten)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
            .uppercased()
    }
}

enum TienIchNgay {
    static var lich: Calendar {
        var lich = Calendar(identifier: .gregorian)
        lich.locale = Locale(identifier: "vi_VN")
        lich.timeZone = .current
        return lich
    }

    static let khoa: DateFormatter = {
        let dinhDang = DateFormatter()
        dinhDang.calendar = lich
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateFormat = "yyyy-MM-dd"
        return dinhDang
    }()

    static let hienThiNgay: DateFormatter = {
        let dinhDang = DateFormatter()
        dinhDang.calendar = lich
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateFormat = "dd/MM/yyyy"
        return dinhDang
    }()

    static let hienThiGioPhut: DateFormatter = {
        let dinhDang = DateFormatter()
        dinhDang.calendar = lich
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateFormat = "HH:mm dd/MM/yyyy"
        return dinhDang
    }()

    static func heSoDuBaoThang(cho ngay: Date = Date()) -> Double {
        let soNgayTrongThang = Double(lich.range(of: .day, in: .month, for: ngay)?.count ?? 30)
        let ngayHienTai = Double(max(1, lich.component(.day, from: ngay)))
        return max(1.0, soNgayTrongThang / ngayHienTai)
    }
}

extension Double {
    private static let boDinhDangVN: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "vi_VN")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 2
        df.maximumFractionDigits = 2
        return df
    }()

    /// Định dạng chuẩn Việt Nam giống ảnh mẫu: 8.541,00 | 787,43 | 1.055,10
    var chuoiSoVN: String {
        Double.boDinhDangVN.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    /// Định dạng phần trăm chuẩn giống ảnh mẫu: 98,10% | 77,60%
    var chuoiPhanTramVN: String {
        "\(self.chuoiSoVN)%"
    }
}
