import UIKit

enum LoaiTabMuc: Int, CaseIterable {
    case thiDua = 0
    case duPhong1 = 1
    case duPhong2 = 2
    case duPhong3 = 3

    var tieuDe: String {
        switch self {
        case .thiDua: return "Thi đua"
        case .duPhong1: return "Dự phòng 1"
        case .duPhong2: return "Dự phòng 2"
        case .duPhong3: return "Dự phòng 3"
        }
    }
}

enum KieuHienThiBaoCao: Int, Codable, CaseIterable {
    case bangChiTiet = 0
    case theGon = 1

    var tieuDe: String {
        switch self {
        case .bangChiTiet: return "Bảng 8 cột"
        case .theGon: return "Thẻ tiến độ"
        }
    }
}

enum LoaiChiTieuThiDua: String, Codable, CaseIterable {
    case soLuong = "SL"
    case doanhThu = "DT"

    var maBang: String {
        switch self {
        case .soLuong: return "SL"
        case .doanhThu: return "DT"
        }
    }

    var maThe: String {
        switch self {
        case .soLuong: return "SLLK"
        case .doanhThu: return "DTLK"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self))?.uppercased() ?? "DT"
        if raw.contains("SL") {
            self = .soLuong
        } else {
            self = .doanhThu
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
    var tenNganhHangGoc: String
    var tenNganhHang: String
    var loaiChiTieu: LoaiChiTieuThiDua
    var thucHien: Double
    var target: Double
    var phanTramHTGoc: Double?
    var phanTramDuBaoGoc: Double?

    init(
        id: UUID = UUID(),
        tenNganhHangGoc: String? = nil,
        tenNganhHang: String,
        loaiChiTieu: LoaiChiTieuThiDua,
        thucHien: Double,
        target: Double,
        phanTramHTGoc: Double? = nil,
        phanTramDuBaoGoc: Double? = nil
    ) {
        self.id = id
        let goc = tenNganhHangGoc ?? tenNganhHang
        self.tenNganhHangGoc = goc
        self.tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
        self.loaiChiTieu = loaiChiTieu
        self.thucHien = thucHien
        self.target = target
        self.phanTramHTGoc = phanTramHTGoc
        self.phanTramDuBaoGoc = phanTramDuBaoGoc
    }

    var chenhLech: Double {
        thucHien - target
    }

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

struct CaiDatDMX: Codable {
    var kieuHienThi: KieuHienThiBaoCao = .bangChiTiet
    var danhSachCumTuLocBo: [String] = []
    var soCotXuatAnh: Int = 3
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
        tepNgay = thuMuc.appendingPathComponent("du-lieu-dmx-v3.json")
        tepCaiDat = thuMuc.appendingPathComponent("cai-dat-dmx-v3.json")

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
    var caiDat = CaiDatDMX()

    private init() {
        doc()
    }

    func doc() {
        let thuMuc = ThuMucDuLieu.dungChung
        if let cd = thuMuc.doc(CaiDatDMX.self, tu: thuMuc.tepCaiDat) {
            caiDat = cd
        } else {
            thuMuc.ghi(caiDat, vao: thuMuc.tepCaiDat)
        }

        if let giaTri = thuMuc.doc([String: DuLieuNgayDMX].self, tu: thuMuc.tepNgay) {
            cacNgay = giaTri
        } else {
            thuMuc.ghi(cacNgay, vao: thuMuc.tepNgay)
        }
    }

    func duLieu(cho ngay: Date) -> DuLieuNgayDMX {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        if var coSan = cacNgay[khoa] {
            for i in coSan.danhSachThiDua.indices {
                let goc = coSan.danhSachThiDua[i].tenNganhHangGoc
                coSan.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
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

    func luuCaiDat(_ moi: CaiDatDMX) {
        caiDat = moi
        ThuMucDuLieu.dungChung.ghi(moi, vao: ThuMucDuLieu.dungChung.tepCaiDat)
        for (khoa, var dl) in cacNgay {
            for i in dl.danhSachThiDua.indices {
                let goc = dl.danhSachThiDua[i].tenNganhHangGoc
                dl.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            cacNgay[khoa] = dl
        }
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
    }

    /// Chỉ lọc bỏ đúng các cụm từ do người dùng thêm vào trong Cài đặt
    static func apDungLocTuCaiDat(_ tenGoc: String) -> String {
        var s = tenGoc
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let danhSachLoc = KhoDuLieu.dungChung.caiDat.danhSachCumTuLocBo
        for cumTu in danhSachLoc {
            let sach = cumTu.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !sach.isEmpty else { continue }
            s = s.replacingOccurrences(of: sach, with: "", options: .caseInsensitive)
        }

        s = s.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: " -–").union(.whitespacesAndNewlines))
        return s.isEmpty ? tenGoc : s
    }

    static func gopDanhSachThiDua(cu: [DongThiDua], moi: [DongThiDua]) -> [DongThiDua] {
        var ketQua = cu
        for var dongMoi in moi {
            dongMoi.tenNganhHang = apDungLocTuCaiDat(dongMoi.tenNganhHangGoc)
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
    private static let boDinhDangVN: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "vi_VN")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 2
        df.maximumFractionDigits = 2
        return df
    }()

    var chuoiSoVN: String {
        Double.boDinhDangVN.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    var chuoiPhanTramVN: String {
        "\(self.chuoiSoVN)%"
    }

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
