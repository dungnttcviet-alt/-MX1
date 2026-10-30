import UIKit

enum LoaiTabChinh: Int, CaseIterable {
    case doanhThuThuc = 0
    case doanhThuLuyKe = 1
    case thiDua = 2

    var tieuDeNgan: String {
        switch self {
        case .doanhThuThuc: return "DT Thực QĐ"
        case .doanhThuLuyKe: return "DT Lũy kế QĐ"
        case .thiDua: return "Thi đua"
        }
    }

    var tieuDeDayDu: String {
        switch self {
        case .doanhThuThuc: return "Doanh thu thực quy đổi"
        case .doanhThuLuyKe: return "Doanh thu lũy kế quy đổi"
        case .thiDua: return "Bảng tổng hợp Thi đua"
        }
    }

    var bieuTuong: String {
        switch self {
        case .doanhThuThuc: return "banknote.fill"
        case .doanhThuLuyKe: return "chart.line.uptrend.xyaxis"
        case .thiDua: return "trophy.fill"
        }
    }
}

enum LoaiChiTieuThiDua: String, Codable, CaseIterable {
    case soLuong = "SL"
    case doanhThu = "DT"

    var nhanDayDu: String {
        switch self {
        case .soLuong: return "Số lượng"
        case .doanhThu: return "Doanh thu"
        }
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

    var chenhLech: Double {
        thucHien - target
    }

    var phanTramHT: Double {
        if target > 0.0001 {
            return (thucHien / target) * 100.0
        }
        return phanTramHTGoc ?? 0
    }

    var phanTramDuBao: Double {
        if let goc = phanTramDuBaoGoc, goc > 0 {
            if let htGoc = phanTramHTGoc, htGoc > 0.1, target > 0.0001 {
                let htMoi = (thucHien / target) * 100.0
                if abs(htMoi - htGoc) > 1.5 {
                    let tyLe = goc / htGoc
                    return htMoi * tyLe
                }
            }
            return goc
        }
        return phanTramHT * TienIchNgay.heSoDuBaoThang()
    }

    var daDat: Bool {
        phanTramHT >= 99.995
    }

    var daHoanThanhDuBao: Bool {
        phanTramDuBao >= 99.995
    }
}

struct DuLieuNgayDMX: Codable {
    var khoaNgay: String
    var capNhatLuc: String
    var thongTinDonVi: String
    var danhSachThiDua: [DongThiDua]
    var tenTepAnhDTThuc: String?
    var tenTepAnhDTLuyKe: String?
}

struct CaiDatDMX: Codable {
    var geminiApiKey: String = ""
    var geminiModel: String = "gemini-2.5-flash"
    var guiKemAnhChoGemini: Bool = true
    var gopCongDonKhiQuetThem: Bool = true
}

final class ThuMucDuLieu {
    static let dungChung = ThuMucDuLieu()

    let thuMuc: URL
    let thuMucAnh: URL
    let tepNgay: URL
    let tepCaiDat: URL

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
        thuMucAnh = thuMuc.appendingPathComponent("AnhDoanhThu", isDirectory: true)
        tepNgay = thuMuc.appendingPathComponent("du-lieu-dmx.json")
        tepCaiDat = thuMuc.appendingPathComponent("cai-dat-dmx.json")

        try? FileManager.default.createDirectory(at: thuMuc, withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: thuMucAnh, withIntermediateDirectories: true)
        taoHuongDanNeuCan()
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
            print("Không thể ghi dữ liệu: \(error.localizedDescription)")
            return false
        }
    }

    func luuAnh(_ anh: UIImage, tenTep: String) -> Bool {
        let duongDan = thuMucAnh.appendingPathComponent(tenTep)
        guard let duLieu = anh.jpegData(compressionQuality: 0.9) else { return false }
        do {
            try duLieu.write(to: duongDan, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    func taiAnh(tenTep: String?) -> UIImage? {
        guard let tenTep = tenTep, !tenTep.isEmpty else { return nil }
        let duongDan = thuMucAnh.appendingPathComponent(tenTep)
        guard let duLieu = try? Data(contentsOf: duongDan) else { return nil }
        return UIImage(data: duLieu)
    }

    func xoaAnh(tenTep: String?) {
        guard let tenTep = tenTep, !tenTep.isEmpty else { return }
        let duongDan = thuMucAnh.appendingPathComponent(tenTep)
        try? FileManager.default.removeItem(at: duongDan)
    }

    private func taoHuongDanNeuCan() {
        let tepHuongDan = thuMuc.appendingPathComponent("HUONG-DAN.txt")
        guard !FileManager.default.fileExists(atPath: tepHuongDan.path) else { return }
        let noiDung = """
        DỮ LIỆU TỔNG HỢP ĐMX
        Sao chép nguyên thư mục DuLieuDMX sang ứng dụng trên máy khác để chuyển toàn bộ lịch sử bảng tổng hợp và hình ảnh doanh thu.
        """
        try? noiDung.write(to: tepHuongDan, atomically: true, encoding: .utf8)
    }
}

final class KhoDuLieu {
    static let dungChung = KhoDuLieu()

    private(set) var cacNgay: [String: DuLieuNgayDMX] = [:]
    var caiDat = CaiDatDMX()

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

        if let giaTri = thuMuc.doc(CaiDatDMX.self, tu: thuMuc.tepCaiDat) {
            caiDat = giaTri
        } else {
            thuMuc.ghi(caiDat, vao: thuMuc.tepCaiDat)
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
            danhSachThiDua: [],
            tenTepAnhDTThuc: nil,
            tenTepAnhDTLuyKe: nil
        )
    }

    func luu(_ duLieu: DuLieuNgayDMX) {
        cacNgay[duLieu.khoaNgay] = duLieu
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
    }

    func luuCaiDat(_ moi: CaiDatDMX) {
        caiDat = moi
        ThuMucDuLieu.dungChung.ghi(moi, vao: ThuMucDuLieu.dungChung.tepCaiDat)
    }

    /// Gộp danh sách thi đua mới quét vào danh sách hiện có, tự động khử trùng lặp tên ngành hàng
    static func gopDanhSachThiDua(cu: [DongThiDua], moi: [DongThiDua]) -> [DongThiDua] {
        var ketQua = cu
        for dongMoi in moi {
            let khoaMoi = chuanHoaTenNganhHang(dongMoi.tenNganhHang)
            guard !khoaMoi.isEmpty else { continue }

            if let viTri = ketQua.firstIndex(where: { chuanHoaTenNganhHang($0.tenNganhHang) == khoaMoi }) {
                let dongCu = ketQua[viTri]
                // Ưu tiên bản ghi có đầy đủ số liệu hơn (ví dụ ảnh trước bị cắt mất dòng số liệu ở đáy màn hình)
                if dongMoi.target > 0 || dongMoi.thucHien > 0 || (dongCu.target == 0 && dongCu.thucHien == 0) {
                    var capNhat = dongMoi
                    capNhat.id = dongCu.id
                    if dongMoi.tenNganhHang.count < dongCu.tenNganhHang.count {
                        capNhat.tenNganhHang = dongCu.tenNganhHang
                    }
                    ketQua[viTri] = capNhat
                }
            } else {
                ketQua.append(dongMoi)
            }
        }
        return ketQua
    }

    static func chuanHoaTenNganhHang(_ ten: String) -> String {
        ten.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
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
    var chuoiSoLieu: String {
        let dinhDang = NumberFormatter()
        dinhDang.locale = Locale(identifier: "en_US")
        dinhDang.numberStyle = .decimal
        if abs(self.rounded() - self) < 0.005 {
            dinhDang.maximumFractionDigits = 0
            dinhDang.minimumFractionDigits = 0
        } else {
            dinhDang.maximumFractionDigits = 2
            dinhDang.minimumFractionDigits = 2
        }
        return dinhDang.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    var chuoiChenhLech: String {
        if abs(self) < 0.005 { return "0" }
        let dau = self > 0 ? "+" : ""
        return "\(dau)\(self.chuoiSoLieu)"
    }

    var chuoiPhanTram: String {
        if abs(self.rounded() - self) < 0.05 {
            return String(format: "%.0f%%", self)
        }
        return String(format: "%.1f%%", self)
    }
}
