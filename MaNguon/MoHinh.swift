import UIKit

enum LoaiCheDoDoanhThu: Int, CaseIterable {
    case luyKe = 0
    case realtime = 1

    var tieuDe: String {
        switch self {
        case .luyKe: return "Lũy kế"
        case .realtime: return "Realtime"
        }
    }
}

enum LoaiTabMuc: Int, CaseIterable {
    case thiDua = 0
    case nhanVien = 1
    case duPhong2 = 2
    case duPhong3 = 3

    static let cacTabCumDuoi: [LoaiTabMuc] = [.thiDua, .nhanVien, .duPhong2]

    var tieuDe: String {
        switch self {
        case .thiDua: return "Thi đua"
        case .nhanVien: return "Nhân viên"
        case .duPhong2: return "📈 Biểu đồ"
        case .duPhong3: return "Dự phòng 3"
        }
    }
}

enum LoaiBieuDoThang: Int, CaseIterable {
    case realtime = 0
    case sucKhoeNhanVien = 1

    var tieuDe: String {
        switch self {
        case .realtime: return "📊 Biểu đồ Realtime"
        case .sucKhoeNhanVien: return "🩺 Biểu đồ Sức khỏe Nhân viên"
        }
    }
}

enum LoaiBieuDoMuc: Int, CaseIterable {
    case bieuDoRealtime = 0
    case bieuDoSucKhoeNhanVien = 1

    var tieuDe: String {
        switch self {
        case .bieuDoRealtime: return "📊 Biểu đồ Realtime"
        case .bieuDoSucKhoeNhanVien: return "❤️ Biểu đồ Sức khỏe nhân viên"
        }
    }
}

enum KieuSapXepNhanVien: Int, CaseIterable {
    case soMonHoanThanh = 0
    case doanhThuQD = 1
    case phanTramTB = 2

    var nhan: String {
        switch self {
        case .soMonHoanThanh: return "🏆 Số môn hoàn thành (Cao → Thấp)"
        case .doanhThuQD: return "🎯 Doanh thu QĐ (Cao → Thấp)"
        case .phanTramTB: return "📈 % HT thi đua TB (Cao → Thấp)"
        }
    }

    var nhanNgan: String {
        switch self {
        case .soMonHoanThanh: return "Số môn HT"
        case .doanhThuQD: return "DT QĐ"
        case .phanTramTB: return "% HT TB"
        }
    }
}

struct NhanVienQuanLy: Codable, Hashable, Identifiable {
    var maNV: String
    var hoTen: String
    var id: String { maNV }

    var nhanMaVaTen: String {
        "\(maNV) - \(hoTen)"
    }
}

struct DoanhThuNhanVienItem: Codable, Hashable {
    var maNV: String
    var hoTen: String
    var soLuong: Double = 0
    var doanhThuThuc: Double = 0
    var doanhThuQD: Double = 0
    var target: Double = 0
    var dtQDKhoanVay: Double = 0
    var dtTraThangQD: Double = 0
    var dtTraGop: Double = 0
    var phanTramHT: Double = 0
    var phanTramQuyDoi: Double = 0
    var phanTramTraGop: Double = 0
    var gioCong: Double = 0
    var soNgayNghi: Double = 0
    var nangSuat: Double = 0

    init(
        maNV: String,
        hoTen: String,
        soLuong: Double = 0,
        doanhThuThuc: Double = 0,
        doanhThuQD: Double = 0,
        target: Double = 0,
        dtQDKhoanVay: Double = 0,
        dtTraThangQD: Double = 0,
        dtTraGop: Double = 0,
        phanTramHT: Double = 0,
        phanTramQuyDoi: Double = 0,
        phanTramTraGop: Double = 0,
        gioCong: Double = 0,
        soNgayNghi: Double = 0,
        nangSuat: Double = 0
    ) {
        self.maNV = maNV
        self.hoTen = hoTen
        self.soLuong = soLuong
        self.doanhThuThuc = doanhThuThuc
        self.doanhThuQD = doanhThuQD
        self.target = target
        self.dtQDKhoanVay = dtQDKhoanVay
        self.dtTraThangQD = dtTraThangQD
        self.dtTraGop = dtTraGop
        self.phanTramHT = phanTramHT
        self.phanTramQuyDoi = phanTramQuyDoi
        self.phanTramTraGop = phanTramTraGop
        self.gioCong = gioCong
        self.soNgayNghi = soNgayNghi
        self.nangSuat = nangSuat
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        maNV = (try? c.decode(String.self, forKey: .maNV)) ?? ""
        hoTen = (try? c.decode(String.self, forKey: .hoTen)) ?? ""
        soLuong = (try? c.decode(Double.self, forKey: .soLuong)) ?? 0
        doanhThuThuc = (try? c.decode(Double.self, forKey: .doanhThuThuc)) ?? 0
        doanhThuQD = (try? c.decode(Double.self, forKey: .doanhThuQD)) ?? 0
        target = (try? c.decode(Double.self, forKey: .target)) ?? 0
        dtQDKhoanVay = (try? c.decode(Double.self, forKey: .dtQDKhoanVay)) ?? 0
        dtTraThangQD = (try? c.decode(Double.self, forKey: .dtTraThangQD)) ?? 0
        dtTraGop = (try? c.decode(Double.self, forKey: .dtTraGop)) ?? 0
        phanTramHT = (try? c.decode(Double.self, forKey: .phanTramHT)) ?? 0
        phanTramQuyDoi = (try? c.decode(Double.self, forKey: .phanTramQuyDoi)) ?? 0
        phanTramTraGop = (try? c.decode(Double.self, forKey: .phanTramTraGop)) ?? 0
        gioCong = (try? c.decode(Double.self, forKey: .gioCong)) ?? 0
        soNgayNghi = (try? c.decode(Double.self, forKey: .soNgayNghi)) ?? 0
        nangSuat = (try? c.decode(Double.self, forKey: .nangSuat)) ?? 0
    }
}

struct DongXepHangNhanVienNganh: Hashable {
    var maNV: String
    var hoTen: String
    var thucHien: Double
    var targetCaNhan: Double
    var phanTramHT: Double
    var chenhLech: Double { thucHien - targetCaNhan }
    var daDat: Bool { phanTramHT >= 99.995 }
}

struct MonThiDuaNhanVien: Hashable {
    var khoaNganh: String
    var tenNganhHang: String
    var loaiChiTieu: LoaiChiTieuThiDua
    var thucHien: Double
    var targetCaNhan: Double
    var phanTramHT: Double
    var phanTramSieuThi: Double
    var conLai: Double { targetCaNhan - thucHien }
    var daDat: Bool { phanTramHT >= 99.995 }
}

struct TongHopNhanVien: Hashable {
    var nhanVien: NhanVienQuanLy
    var soMonDat: Int
    var tongMonGiao: Int
    var phanTramHTTB: Double
    var doanhThuQD: Double
    var soLuongDon: Double
    var dtQDKhoanVay: Double
    var dtTraThangQD: Double
    var cacMonGiao: [MonThiDuaNhanVien]
    var doanhThuCaNhan: DoanhThuNhanVienItem?
}

enum MucDoSucKhoeNV: Int, CaseIterable {
    case khoe = 0
    case kha = 1
    case canChuY = 2
    case yeuBaoDong = 3

    var tieuDe: String {
        switch self {
        case .khoe: return "Khỏe"
        case .kha: return "Khá"
        case .canChuY: return "Cần chú ý"
        case .yeuBaoDong: return "Yếu / Báo động"
        }
    }

    var bieuTuong: String {
        switch self {
        case .khoe: return "🟢"
        case .kha: return "🔵"
        case .canChuY: return "🟠"
        case .yeuBaoDong: return "🔴"
        }
    }

    var mauSac: UIColor {
        switch self {
        case .khoe: return .systemGreen
        case .kha: return .systemBlue
        case .canChuY: return .systemOrange
        case .yeuBaoDong: return .systemRed
        }
    }
}

struct NgaySucKhoeNV: Hashable {
    var khoaNgay: String
    var ngayTrongThang: Int
    var diemSucKhoe: Double
    var doanhThuQD: Double
    var phanTramHTMon: Double
    var laNgayYeu: Bool
}

struct ChiSoSucKhoeNhanVien: Hashable {
    var nhanVien: NhanVienQuanLy
    var tongHopLuyKe: TongHopNhanVien
    var tongHopRealtime: TongHopNhanVien
    var diemSucKhoe: Double
    var phanTramDTQDSoVoiChuan: Double
    var soNgayYeuLienTuc: Int
    var tongSoNgayYeu: Int
    var soNgayCoDuLieu: Int
    var lichSuNgay: [NgaySucKhoeNV]
    var laTop5CanhBao: Bool
    var thuHangCanhBao: Int
    var mucDo: MucDoSucKhoeNV
    var lyDoCanhBao: String

    var tenRutGonBieuDo: String {
        let tu = nhanVien.hoTen.split(separator: " ").map(String.init)
        if tu.count >= 2 {
            return tu.suffix(2).joined(separator: " ")
        }
        return nhanVien.hoTen
    }
}

struct KetQuaPhanTichSucKhoeDoiNgu: Hashable {
    var danhSachTheoCanhBao: [ChiSoSucKhoeNhanVien] = []
    var danhSachTheoDiemCaoThap: [ChiSoSucKhoeNhanVien] = []
    var top5CanhBaoYeu: [ChiSoSucKhoeNhanVien] = []
    var trungBinhDoiDTQD: Double = 0
    var trungBinhDiemSucKhoe: Double = 0
    var soNgayCoDuLieu: Int = 0
    var soNVKhoe: Int = 0
    var soNVKha: Int = 0
    var soNVCanChuY: Int = 0
    var soNVYeu: Int = 0
}

struct DuBaoQuyDoiThang: Hashable {
    var tongDTThucRealtime: Double = 0
    var tongDTQuyDoiRealtime: Double = 0
    var soNgayCoRealtime: Int = 0
    var trungBinhDTThucNgay: Double = 0
    var trungBinhDTQuyDoiNgay: Double = 0
    var duKienDTThucCuoiThang: Double = 0
    var duKienDTQuyDoiCuoiThang: Double = 0
    var mucTieuDTQuyDoiThang: Double = 0
    var tyLeDuKienQuyDoi: Double = 0
    var daDatMucTieuQuyDoi: Bool = false
    var chenhLechQuyDoiDuKien: Double = 0
}

// MARK: - Mô hình Theo dõi Sức bán Nhân viên theo Ngày (Từ Doanh thu Realtime Nhân viên) & Cảnh báo yếu liên tục

struct DuLieuSucBanNgayNhanVien: Hashable {
    var ngay: Date
    var khoaNgay: String
    var ngayTrongThang: Int
    var maNV: String
    var hoTen: String
    var soLuongDon: Double
    var doanhThuThucNV: Double
    var doanhThuQDNV: Double
    var tongDoanhThuThucNgay: Double
    var tongDoanhThuQDNgay: Double
    var tyLeDongGopNgay: Double
    var tyLeChuanBinhQuan: Double
    var coDuLieuNgayCuaDoi: Bool
    var coDuLieuCaNhan: Bool
    var laNgayYeu: Bool
    var chuoiYeuLienTucTaiNgay: Int

    var trangThaiNgay: String {
        guard coDuLieuNgayCuaDoi else { return "--" }
        if laNgayYeu {
            if chuoiYeuLienTucTaiNgay >= 2 {
                return "🚨 Yếu \(chuoiYeuLienTucTaiNgay)N LT"
            }
            return doanhThuQDNV <= 0.001 && doanhThuThucNV <= 0.001 ? "⚠️ 0 số" : "⚠️ Yếu"
        }
        if tyLeDongGopNgay >= tyLeChuanBinhQuan * 1.15 {
            return "🔥 Tốt"
        }
        return "✅ Đạt"
    }
}

struct CanhBaoSucBanNhanVien: Hashable, Identifiable {
    var nhanVien: NhanVienQuanLy
    var id: String { nhanVien.maNV }
    var soNgayCoSoDoi: Int
    var soNgayCoBan: Int
    var soNgayYeu: Int
    var soNgayYeuLienTucHienTai: Int
    var soNgayYeuLienTucDaiNhat: Int
    var khoangNgayYeuLienTuc: String
    var danhSachNgayYeuLienTuc: [Int]
    var tongDoanhThuThucThang: Double
    var tongDoanhThuQDThang: Double
    var tongSoDonThang: Double
    var tyLeDongGopTBThang: Double
    var tyLeChuanBinhQuan: Double

    var soNgayChuoiCanhBao: Int {
        soNgayYeuLienTucHienTai >= 2 ? soNgayYeuLienTucHienTai : soNgayYeuLienTucDaiNhat
    }

    var biCanhBaoNhieuNgayYeu: Bool {
        soNgayChuoiCanhBao >= 2
    }

    var dangYeuLienTucHienTai: Bool {
        soNgayYeuLienTucHienTai >= 2
    }

    /// 2 = Cảnh báo đỏ (Yếu >= 3 ngày liên tục hoặc đang yếu liên tục hiện tại với tỷ lệ thấp), 1 = Cảnh báo cam (2 ngày liên tục), 0 = Ổn định
    var mucDoCanhBao: Int {
        if soNgayYeuLienTucHienTai >= 3 || soNgayYeuLienTucDaiNhat >= 3 {
            return 2
        }
        if soNgayYeuLienTucHienTai >= 2 || soNgayYeuLienTucDaiNhat >= 2 {
            return 1
        }
        return 0
    }

    var nhanTrangThaiNgan: String {
        guard soNgayCoSoDoi > 0 else { return "Chưa có số RT" }
        if soNgayYeuLienTucHienTai >= 3 {
            return "🚨 Đang yếu \(soNgayYeuLienTucHienTai) ngày LT"
        }
        if soNgayYeuLienTucHienTai == 2 {
            return "⚠️ Đang yếu 2 ngày LT"
        }
        if soNgayYeuLienTucDaiNhat >= 2 {
            return "⚠️ Từng yếu \(soNgayYeuLienTucDaiNhat) ngày LT"
        }
        return "✅ Nhịp bán ổn định"
    }

    var tyLeSoVoiChuan: Double {
        guard tyLeChuanBinhQuan > 0.001 else { return 0 }
        return (tyLeDongGopTBThang / tyLeChuanBinhQuan) * 100.0
    }

    var tenRutGon: String {
        let tu = nhanVien.hoTen.split(separator: " ").map(String.init)
        if tu.count >= 2 {
            return tu.suffix(2).joined(separator: " ")
        }
        return nhanVien.hoTen
    }

    var nhanHuyHieuChuoiYeu: String {
        if dangYeuLienTucHienTai {
            return "🚨 Yếu \(soNgayYeuLienTucHienTai) ngày liên tục"
        }
        if soNgayYeuLienTucDaiNhat >= 2 {
            return "⚠️ Yếu \(soNgayYeuLienTucDaiNhat) ngày liên tục"
        }
        if soNgayYeu > 0 {
            return "⚠️ Yếu \(soNgayYeu)/\(max(1, soNgayCoSoDoi)) ngày"
        }
        return "⚠️ Đóng góp thấp (\(tyLeDongGopTBThang.chuoiPhanTram))"
    }

    var moTaChiTietCanhBao: String {
        let trangThaiChuoi: String
        if dangYeuLienTucHienTai {
            trangThaiChuoi = "Đang yếu \(soNgayYeuLienTucHienTai) ngày liên tục"
        } else if soNgayYeuLienTucDaiNhat >= 2 {
            trangThaiChuoi = "Yếu \(soNgayYeuLienTucDaiNhat) ngày liên tục"
        } else if soNgayYeu > 0 {
            trangThaiChuoi = "Yếu \(soNgayYeu)/\(max(1, soNgayCoSoDoi)) ngày"
        } else {
            trangThaiChuoi = "Đóng góp dưới chuẩn"
        }
        let phanNgay = khoangNgayYeuLienTuc.isEmpty ? "" : " (\(khoangNgayYeuLienTuc))"
        return "\(trangThaiChuoi)\(phanNgay) • Đóng góp TB: \(tyLeDongGopTBThang.chuoiPhanTram) (Chuẩn: \(tyLeChuanBinhQuan.chuoiPhanTram))"
    }
}

struct BaoCaoSucBanNhanVienThang {
    var nhanVienDangChon: NhanVienQuanLy
    var danhSachNhanVien: [NhanVienQuanLy]
    var chiTietTheoNgay: [DuLieuSucBanNgayNhanVien]
    var bangChiTietTheoMaNV: [String: [DuLieuSucBanNgayNhanVien]]
    var tongKetNhanVienDangChon: CanhBaoSucBanNhanVien
    var tatCaTongKetNhanVien: [CanhBaoSucBanNhanVien]
    var danhSachCanhBaoYeuLienTuc: [CanhBaoSucBanNhanVien]
    var danhSach5NhanVienYeuLienTuc: [CanhBaoSucBanNhanVien]
    var soNgayCoDuLieuNV: Int
    var tongDTQDToanDoiThang: Double
    var tongDTThucToanDoiThang: Double
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

    var maWeb: String {
        switch self {
        case .bangChiTiet: return "bangChiTiet"
        case .theGon: return "theGon"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let rawInt = try? container.decode(Int.self), let val = KieuHienThiBaoCao(rawValue: rawInt) {
            self = val
        } else if let rawStr = try? container.decode(String.self) {
            self = (rawStr == "theGon") ? .theGon : .bangChiTiet
        } else {
            self = .bangChiTiet
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(maWeb)
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
    var duKienThuc: Double = 0
    var phanTramHTThuc: Double = 0

    var doanhThuQuyDoi: Double = 0
    var targetQuyDoi: Double = 0
    var duKienQuyDoi: Double = 0
    var phanTramHTQuyDoi: Double = 0

    var phanTramTraGop: Double = 0
    var doanhThuTraGop: Double = 0

    var luotKhach: Double = 0
    var soBill: Double = 0
    var phanTramPVTC: Double = 0

    var tangGiamCungKy: Double = 0
    var coTangGiam: Bool = false
    var tb3Thang: Double = 0

    var soNgayDaQua: Int = 0
    var tongSoNgay: Int = 0
    var phanTramTienDoThang: Double = 0

    init(
        doanhThuThuc: Double = 0,
        targetThuc: Double = 0,
        duKienThuc: Double = 0,
        phanTramHTThuc: Double = 0,
        doanhThuQuyDoi: Double = 0,
        targetQuyDoi: Double = 0,
        duKienQuyDoi: Double = 0,
        phanTramHTQuyDoi: Double = 0,
        phanTramTraGop: Double = 0,
        doanhThuTraGop: Double = 0,
        luotKhach: Double = 0,
        soBill: Double = 0,
        phanTramPVTC: Double = 0,
        tangGiamCungKy: Double = 0,
        coTangGiam: Bool = false,
        tb3Thang: Double = 0,
        soNgayDaQua: Int = 0,
        tongSoNgay: Int = 0,
        phanTramTienDoThang: Double = 0
    ) {
        self.doanhThuThuc = doanhThuThuc
        self.targetThuc = targetThuc
        self.duKienThuc = duKienThuc
        self.phanTramHTThuc = phanTramHTThuc
        self.doanhThuQuyDoi = doanhThuQuyDoi
        self.targetQuyDoi = targetQuyDoi
        self.duKienQuyDoi = duKienQuyDoi
        self.phanTramHTQuyDoi = phanTramHTQuyDoi
        self.phanTramTraGop = phanTramTraGop
        self.doanhThuTraGop = doanhThuTraGop
        self.luotKhach = luotKhach
        self.soBill = soBill
        self.phanTramPVTC = phanTramPVTC
        self.tangGiamCungKy = tangGiamCungKy
        self.coTangGiam = coTangGiam
        self.tb3Thang = tb3Thang
        self.soNgayDaQua = soNgayDaQua
        self.tongSoNgay = tongSoNgay
        self.phanTramTienDoThang = phanTramTienDoThang
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        doanhThuThuc = (try? c.decode(Double.self, forKey: .doanhThuThuc)) ?? 0
        targetThuc = (try? c.decode(Double.self, forKey: .targetThuc)) ?? 0
        duKienThuc = (try? c.decode(Double.self, forKey: .duKienThuc)) ?? 0
        phanTramHTThuc = (try? c.decode(Double.self, forKey: .phanTramHTThuc)) ?? 0
        doanhThuQuyDoi = (try? c.decode(Double.self, forKey: .doanhThuQuyDoi)) ?? 0
        targetQuyDoi = (try? c.decode(Double.self, forKey: .targetQuyDoi)) ?? 0
        duKienQuyDoi = (try? c.decode(Double.self, forKey: .duKienQuyDoi)) ?? 0
        phanTramHTQuyDoi = (try? c.decode(Double.self, forKey: .phanTramHTQuyDoi)) ?? 0
        phanTramTraGop = (try? c.decode(Double.self, forKey: .phanTramTraGop)) ?? 0
        doanhThuTraGop = (try? c.decode(Double.self, forKey: .doanhThuTraGop)) ?? 0
        luotKhach = (try? c.decode(Double.self, forKey: .luotKhach)) ?? 0
        soBill = (try? c.decode(Double.self, forKey: .soBill)) ?? 0
        phanTramPVTC = (try? c.decode(Double.self, forKey: .phanTramPVTC)) ?? 0
        tangGiamCungKy = (try? c.decode(Double.self, forKey: .tangGiamCungKy)) ?? 0
        coTangGiam = (try? c.decode(Bool.self, forKey: .coTangGiam)) ?? (tangGiamCungKy != 0)
        tb3Thang = (try? c.decode(Double.self, forKey: .tb3Thang)) ?? 0
        soNgayDaQua = (try? c.decode(Int.self, forKey: .soNgayDaQua)) ?? 0
        tongSoNgay = (try? c.decode(Int.self, forKey: .tongSoNgay)) ?? 0
        phanTramTienDoThang = (try? c.decode(Double.self, forKey: .phanTramTienDoThang)) ?? 0
    }

    var coDuLieu: Bool {
        doanhThuThuc > 0 || targetThuc > 0 || doanhThuQuyDoi > 0 || targetQuyDoi > 0 || luotKhach > 0 || phanTramTraGop > 0
    }

    /// % Quy đổi = (DT Quy đổi - DT Thực) / DT Thực * 100
    var phanTramQuyDoi: Double {
        guard doanhThuThuc > 0, doanhThuQuyDoi > 0 else { return 0 }
        return ((doanhThuQuyDoi - doanhThuThuc) / doanhThuThuc) * 100.0
    }

    /// % Hoàn thành Doanh thu thực
    var phanTramHTThucHienThi: Double {
        if phanTramHTThuc > 0 { return phanTramHTThuc }
        if targetThuc > 0, doanhThuThuc > 0 {
            return (doanhThuThuc / targetThuc) * 100.0
        }
        return 0
    }

    /// % Hoàn thành QĐ dự kiến
    var phanTramHTQDDuKienHienThi: Double {
        if phanTramHTQuyDoi > 0 { return phanTramHTQuyDoi }
        if duKienQuyDoi > 0, targetQuyDoi > 0 {
            return (duKienQuyDoi / targetQuyDoi) * 100.0
        }
        if targetQuyDoi > 0, doanhThuQuyDoi > 0 {
            return (doanhThuQuyDoi / targetQuyDoi) * 100.0
        }
        if phanTramHTThuc > 0 { return phanTramHTThuc }
        if targetThuc > 0, doanhThuThuc > 0 {
            return (doanhThuThuc / targetThuc) * 100.0
        }
        return 0
    }

    /// Gộp dữ liệu từ ảnh mới quét (ví dụ quét ảnh DT thực rồi quét tiếp ảnh DT quy đổi)
    func gop(voi moi: ThongTinDoanhThu, laRealtime: Bool = false) -> ThongTinDoanhThu {
        var kq = self
        if moi.doanhThuThuc > 0 { kq.doanhThuThuc = moi.doanhThuThuc }
        if moi.targetThuc > 0 { kq.targetThuc = moi.targetThuc }
        if moi.duKienThuc > 0 { kq.duKienThuc = moi.duKienThuc }
        if moi.phanTramHTThuc > 0 { kq.phanTramHTThuc = moi.phanTramHTThuc }

        if moi.doanhThuQuyDoi > 0 { kq.doanhThuQuyDoi = moi.doanhThuQuyDoi }
        if moi.targetQuyDoi > 0 { kq.targetQuyDoi = moi.targetQuyDoi }
        if moi.duKienQuyDoi > 0 { kq.duKienQuyDoi = moi.duKienQuyDoi }
        if moi.phanTramHTQuyDoi > 0 { kq.phanTramHTQuyDoi = moi.phanTramHTQuyDoi }

        if moi.phanTramTraGop > 0 { kq.phanTramTraGop = moi.phanTramTraGop }
        if moi.doanhThuTraGop > 0 { kq.doanhThuTraGop = moi.doanhThuTraGop }

        if moi.luotKhach > 0 { kq.luotKhach = moi.luotKhach }
        if moi.soBill > 0 { kq.soBill = moi.soBill }
        if moi.phanTramPVTC > 0 { kq.phanTramPVTC = moi.phanTramPVTC }

        if moi.coTangGiam || moi.tangGiamCungKy != 0 {
            kq.tangGiamCungKy = moi.tangGiamCungKy
            kq.coTangGiam = true
        }
        if moi.tb3Thang > 0 { kq.tb3Thang = moi.tb3Thang }

        if moi.soNgayDaQua > 0 { kq.soNgayDaQua = moi.soNgayDaQua }
        if moi.tongSoNgay > 0 { kq.tongSoNgay = moi.tongSoNgay }
        if moi.phanTramTienDoThang > 0 { kq.phanTramTienDoThang = moi.phanTramTienDoThang }
        return kq
    }
}

struct DongThiDua: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var tenNganhHangGoc: String
    var tenNganhHang: String
    var loaiChiTieu: LoaiChiTieuThiDua
    var thucHien: Double
    var target: Double
    var phanTramHTGoc: Double?
    var phanTramDuBaoGoc: Double?
    var duKienGoc: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case tenNganhHangGoc
        case tenNganhHang
        case loaiChiTieu
        case thucHien
        case target
        case phanTramHTGoc
        case phanTramDuBaoGoc
        case duKienGoc
    }

    init(
        id: UUID = UUID(),
        tenNganhHangGoc: String? = nil,
        tenNganhHang: String,
        loaiChiTieu: LoaiChiTieuThiDua,
        thucHien: Double,
        target: Double,
        phanTramHTGoc: Double? = nil,
        phanTramDuBaoGoc: Double? = nil,
        duKienGoc: Double? = nil
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
        self.duKienGoc = duKienGoc
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let uuid = try? c.decode(UUID.self, forKey: .id) {
            id = uuid
        } else if let str = try? c.decode(String.self, forKey: .id), let uuid = UUID(uuidString: str) {
            id = uuid
        } else {
            id = UUID()
        }
        let ten = (try? c.decode(String.self, forKey: .tenNganhHang)) ?? ""
        let goc = (try? c.decode(String.self, forKey: .tenNganhHangGoc)) ?? ten
        tenNganhHangGoc = goc
        tenNganhHang = ten.isEmpty ? goc : ten
        loaiChiTieu = (try? c.decode(LoaiChiTieuThiDua.self, forKey: .loaiChiTieu)) ?? .doanhThu
        thucHien = (try? c.decode(Double.self, forKey: .thucHien)) ?? 0
        target = (try? c.decode(Double.self, forKey: .target)) ?? 0
        phanTramHTGoc = try? c.decode(Double.self, forKey: .phanTramHTGoc)
        phanTramDuBaoGoc = try? c.decode(Double.self, forKey: .phanTramDuBaoGoc)
        duKienGoc = try? c.decode(Double.self, forKey: .duKienGoc)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id.uuidString.lowercased(), forKey: .id)
        try c.encode(tenNganhHangGoc, forKey: .tenNganhHangGoc)
        try c.encode(tenNganhHang, forKey: .tenNganhHang)
        try c.encode(loaiChiTieu, forKey: .loaiChiTieu)
        try c.encode(thucHien, forKey: .thucHien)
        try c.encode(target, forKey: .target)
        try c.encodeIfPresent(phanTramHTGoc, forKey: .phanTramHTGoc)
        try c.encodeIfPresent(phanTramDuBaoGoc, forKey: .phanTramDuBaoGoc)
        try c.encodeIfPresent(duKienGoc, forKey: .duKienGoc)
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

    var duKien: Double {
        if let dk = duKienGoc, dk > 0 {
            return dk
        }
        if target > 0.0001, phanTramDuBao > 0 {
            return (phanTramDuBao / 100.0) * target
        }
        return thucHien * TienIchNgay.heSoDuBaoThang()
    }

    var chenhLechDuKien: Double {
        duKien - target
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
    var danhSachNhanVien: [NhanVienQuanLy] = CaiDatDMX.nhanVienMau
    var chiaTargetNganhHang: [String: [String]] = [:]
    var mucTieuDoanhThuQDThang: Double = 0

    static let nhanVienMau: [NhanVienQuanLy] = [
        .init(maNV: "24939", hoTen: "Phan Hoàng Sơn"),
        .init(maNV: "201962", hoTen: "Nguyễn Thị Kim Loan"),
        .init(maNV: "261423", hoTen: "Trần Nam Tùng"),
        .init(maNV: "23986", hoTen: "Nguyễn Ngọc Đẩu"),
        .init(maNV: "65255", hoTen: "Nguyễn Thị Thu Thảo"),
        .init(maNV: "285688", hoTen: "Lê Tuấn"),
        .init(maNV: "116719", hoTen: "Đinh Thị Quỳnh Nga"),
        .init(maNV: "186532", hoTen: "Đỗ Thị Mỹ Linh"),
        .init(maNV: "207241", hoTen: "Huỳnh Tấn Thành"),
        .init(maNV: "194649", hoTen: "Nguyễn Hoàn Điện"),
        .init(maNV: "34922", hoTen: "Đỗ Thị Chanh"),
        .init(maNV: "293044", hoTen: "Võ Ngọc Vĩ"),
        .init(maNV: "285681", hoTen: "Hồ Ngọc Châu Ánh"),
        .init(maNV: "280417", hoTen: "Huỳnh Thành Đạt"),
        .init(maNV: "39665", hoTen: "Nguyễn Hữu Kha"),
        .init(maNV: "23997", hoTen: "Lê Thị Kim Phượng")
    ]

    init(
        kieuHienThi: KieuHienThiBaoCao = .bangChiTiet,
        danhSachCumTuLocBo: [String] = [],
        soCotXuatAnh: Int = 3,
        danhSachNhanVien: [NhanVienQuanLy] = CaiDatDMX.nhanVienMau,
        chiaTargetNganhHang: [String: [String]] = [:],
        mucTieuDoanhThuQDThang: Double = 0
    ) {
        self.kieuHienThi = kieuHienThi
        self.danhSachCumTuLocBo = danhSachCumTuLocBo
        self.soCotXuatAnh = soCotXuatAnh
        self.danhSachNhanVien = danhSachNhanVien
        self.chiaTargetNganhHang = chiaTargetNganhHang
        self.mucTieuDoanhThuQDThang = mucTieuDoanhThuQDThang
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        kieuHienThi = (try? c.decode(KieuHienThiBaoCao.self, forKey: .kieuHienThi)) ?? .bangChiTiet
        danhSachCumTuLocBo = (try? c.decode([String].self, forKey: .danhSachCumTuLocBo)) ?? []
        let cot = (try? c.decode(Int.self, forKey: .soCotXuatAnh)) ?? 3
        soCotXuatAnh = (cot >= 1 && cot <= 4) ? cot : 3
        let dsNV = (try? c.decode([NhanVienQuanLy].self, forKey: .danhSachNhanVien)) ?? []
        danhSachNhanVien = dsNV.isEmpty ? Self.nhanVienMau : dsNV
        chiaTargetNganhHang = (try? c.decode([String: [String]].self, forKey: .chiaTargetNganhHang)) ?? [:]
        mucTieuDoanhThuQDThang = (try? c.decode(Double.self, forKey: .mucTieuDoanhThuQDThang)) ?? 0
    }
}

struct DuLieuRealtimeNgayTrongThang: Hashable {
    var ngay: Date
    var khoaNgay: String
    var ngayTrongThang: Int
    var doanhThu: ThongTinDoanhThu

    var doanhThuThuc: Double { doanhThu.doanhThuThuc }
    var targetThuc: Double { doanhThu.targetThuc }
    var doanhThuQuyDoi: Double { doanhThu.doanhThuQuyDoi }
    var targetQuyDoi: Double { doanhThu.targetQuyDoi }
    var phanTramQuyDoi: Double { doanhThu.phanTramQuyDoi }
    var phanTramTraGop: Double { doanhThu.phanTramTraGop }
    var luotKhach: Double { doanhThu.luotKhach }
    var soBill: Double { doanhThu.soBill }
    var coDuLieu: Bool {
        doanhThu.doanhThuThuc > 0 || doanhThu.doanhThuQuyDoi > 0 || doanhThu.luotKhach > 0 || doanhThu.soBill > 0
    }
}

struct DuLieuNgayDMX: Codable {
    var khoaNgay: String
    var capNhatLuc: String
    var thongTinDonVi: String
    var doanhThu: ThongTinDoanhThu
    var doanhThuRealtime: ThongTinDoanhThu = ThongTinDoanhThu()
    var danhSachThiDua: [DongThiDua]
    var danhSachThiDuaRealtime: [DongThiDua] = []
    var thiDuaNhanVien: [String: [String: Double]] = [:]
    var thiDuaNhanVienRealtime: [String: [String: Double]] = [:]
    var doanhThuNhanVien: [DoanhThuNhanVienItem] = []
    var doanhThuNhanVienRealtime: [DoanhThuNhanVienItem] = []

    init(
        khoaNgay: String,
        capNhatLuc: String,
        thongTinDonVi: String,
        doanhThu: ThongTinDoanhThu,
        doanhThuRealtime: ThongTinDoanhThu = ThongTinDoanhThu(),
        danhSachThiDua: [DongThiDua],
        danhSachThiDuaRealtime: [DongThiDua] = [],
        thiDuaNhanVien: [String: [String: Double]] = [:],
        thiDuaNhanVienRealtime: [String: [String: Double]] = [:],
        doanhThuNhanVien: [DoanhThuNhanVienItem] = [],
        doanhThuNhanVienRealtime: [DoanhThuNhanVienItem] = []
    ) {
        self.khoaNgay = khoaNgay
        self.capNhatLuc = capNhatLuc
        self.thongTinDonVi = thongTinDonVi
        self.doanhThu = doanhThu
        self.doanhThuRealtime = doanhThuRealtime
        self.danhSachThiDua = danhSachThiDua
        self.danhSachThiDuaRealtime = danhSachThiDuaRealtime
        self.thiDuaNhanVien = thiDuaNhanVien
        self.thiDuaNhanVienRealtime = thiDuaNhanVienRealtime
        self.doanhThuNhanVien = doanhThuNhanVien
        self.doanhThuNhanVienRealtime = doanhThuNhanVienRealtime
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        khoaNgay = (try? c.decode(String.self, forKey: .khoaNgay)) ?? ""
        capNhatLuc = (try? c.decode(String.self, forKey: .capNhatLuc)) ?? ""
        thongTinDonVi = (try? c.decode(String.self, forKey: .thongTinDonVi)) ?? ""
        doanhThu = (try? c.decode(ThongTinDoanhThu.self, forKey: .doanhThu)) ?? ThongTinDoanhThu()
        doanhThuRealtime = (try? c.decode(ThongTinDoanhThu.self, forKey: .doanhThuRealtime)) ?? ThongTinDoanhThu()
        danhSachThiDua = (try? c.decode([DongThiDua].self, forKey: .danhSachThiDua)) ?? []
        danhSachThiDuaRealtime = (try? c.decode([DongThiDua].self, forKey: .danhSachThiDuaRealtime)) ?? []
        thiDuaNhanVien = (try? c.decode([String: [String: Double]].self, forKey: .thiDuaNhanVien)) ?? [:]
        thiDuaNhanVienRealtime = (try? c.decode([String: [String: Double]].self, forKey: .thiDuaNhanVienRealtime)) ?? [:]
        doanhThuNhanVien = (try? c.decode([DoanhThuNhanVienItem].self, forKey: .doanhThuNhanVien)) ?? []
        doanhThuNhanVienRealtime = (try? c.decode([DoanhThuNhanVienItem].self, forKey: .doanhThuNhanVienRealtime)) ?? []
    }

    func danhSachThiDua(theo cheDo: LoaiCheDoDoanhThu) -> [DongThiDua] {
        switch cheDo {
        case .luyKe: return danhSachThiDua
        case .realtime: return danhSachThiDuaRealtime
        }
    }

    mutating func ganDanhSachThiDua(_ ds: [DongThiDua], theo cheDo: LoaiCheDoDoanhThu) {
        switch cheDo {
        case .luyKe: danhSachThiDua = ds
        case .realtime: danhSachThiDuaRealtime = ds
        }
    }

    func doanhThuNhanVien(theo cheDo: LoaiCheDoDoanhThu) -> [DoanhThuNhanVienItem] {
        switch cheDo {
        case .luyKe: return doanhThuNhanVien
        case .realtime: return doanhThuNhanVienRealtime
        }
    }

    mutating func ganDoanhThuNhanVien(_ ds: [DoanhThuNhanVienItem], theo cheDo: LoaiCheDoDoanhThu) {
        switch cheDo {
        case .luyKe: doanhThuNhanVien = ds
        case .realtime: doanhThuNhanVienRealtime = ds
        }
    }

    func thiDuaNhanVien(theo cheDo: LoaiCheDoDoanhThu) -> [String: [String: Double]] {
        switch cheDo {
        case .luyKe: return thiDuaNhanVien
        case .realtime: return thiDuaNhanVienRealtime
        }
    }

    mutating func ganThiDuaNhanVien(_ bang: [String: [String: Double]], theo cheDo: LoaiCheDoDoanhThu) {
        switch cheDo {
        case .luyKe: thiDuaNhanVien = bang
        case .realtime: thiDuaNhanVienRealtime = bang
        }
    }
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

    /// Lấy Doanh thu Lũy kế cố định của tháng (mỗi lần nhập ở ngày mới sẽ thay thế cho ngày hôm trước)
    func doanhThuLuyKeThang(cho ngay: Date) -> ThongTinDoanhThu {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        if let hienTai = cacNgay[khoa]?.doanhThu, hienTai.coDuLieu {
            return hienTai
        }
        for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) }).sorted(by: >) {
            if let dt = cacNgay[k]?.doanhThu, dt.coDuLieu {
                return dt
            }
        }
        return ThongTinDoanhThu()
    }

    /// Xoá Doanh thu Lũy kế cố định của tháng
    func xoaDoanhThuLuyKeThang(cho ngay: Date) {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        for k in cacNgay.keys where k.hasPrefix(tienTo) {
            cacNgay[k]?.doanhThu = ThongTinDoanhThu()
        }
        var dl = duLieu(cho: ngay)
        dl.doanhThu = ThongTinDoanhThu()
        cacNgay[khoa] = dl
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
        DichVuDongBo.dungChung.dayDuLieuNgay(dl)
    }

    /// Lấy bảng Doanh thu Nhân viên Lũy kế mới nhất trong tháng
    func doanhThuNhanVienLuyKeThang(cho ngay: Date) -> [DoanhThuNhanVienItem] {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        if let hienTai = cacNgay[khoa]?.doanhThuNhanVien, !hienTai.isEmpty {
            return hienTai
        }
        for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 <= khoa }).sorted(by: >) {
            if let ds = cacNgay[k]?.doanhThuNhanVien, !ds.isEmpty {
                return ds
            }
        }
        return []
    }

    /// Xoá Doanh thu Nhân viên Lũy kế của tháng (và tuỳ chọn xoá cả Thi đua NV)
    func xoaDoanhThuNhanVienLuyKeThang(cho ngay: Date, xoaCaThiDuaNV: Bool = false) {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        for k in cacNgay.keys where k.hasPrefix(tienTo) {
            cacNgay[k]?.doanhThuNhanVien = []
            if xoaCaThiDuaNV {
                cacNgay[k]?.thiDuaNhanVien = [:]
            }
        }
        var dl = duLieu(cho: ngay)
        dl.doanhThuNhanVien = []
        if xoaCaThiDuaNV {
            dl.thiDuaNhanVien = [:]
        }
        cacNgay[khoa] = dl
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
        DichVuDongBo.dungChung.dayDuLieuNgay(dl)
    }

    /// Dự báo Doanh thu Thực & Quy đổi cuối tháng từ các ngày Realtime đã có số
    func tinhDuBaoQuyDoiTuRealtime(cho ngay: Date, cheDoDangXem: LoaiCheDoDoanhThu = .luyKe) -> DuBaoQuyDoiThang {
        let lich = TienIchNgay.lich
        let soNgayThang = Double(lich.range(of: .day, in: .month, for: ngay)?.count ?? 30)
        let dsNgay = danhSachRealtimeTheoNgayTrongThang(cho: ngay)
        let dsCoSo = dsNgay.filter { $0.coDuLieu }
        let soNgayCo = dsCoSo.count
        let tongThuc = dsCoSo.reduce(0.0) { $0 + $1.doanhThuThuc }
        let tongQD = dsCoSo.reduce(0.0) { $0 + $1.doanhThuQuyDoi }
        let tbThuc = soNgayCo > 0 ? tongThuc / Double(soNgayCo) : 0
        let tbQD = soNgayCo > 0 ? tongQD / Double(soNgayCo) : 0

        let dtLK = doanhThuLuyKeThang(cho: ngay)
        let dkThuc: Double
        let dkQD: Double
        if soNgayCo > 0 {
            dkThuc = tbThuc * soNgayThang
            dkQD = tbQD * soNgayThang
        } else {
            dkThuc = dtLK.duKienThuc > 0 ? dtLK.duKienThuc : (dtLK.doanhThuThuc * TienIchNgay.heSoDuBaoThang(cho: ngay))
            dkQD = dtLK.duKienQuyDoi > 0 ? dtLK.duKienQuyDoi : (dtLK.doanhThuQuyDoi * TienIchNgay.heSoDuBaoThang(cho: ngay))
        }

        let targetQD = dtLK.targetQuyDoi > 0 ? dtLK.targetQuyDoi : caiDat.mucTieuDoanhThuQDThang
        let tyLeDK = targetQD > 0 ? (dkQD / targetQD) * 100.0 : dtLK.phanTramHTQDDuKienHienThi
        return DuBaoQuyDoiThang(
            tongDTThucRealtime: tongThuc,
            tongDTQuyDoiRealtime: tongQD,
            soNgayCoRealtime: soNgayCo,
            trungBinhDTThucNgay: tbThuc,
            trungBinhDTQuyDoiNgay: tbQD,
            duKienDTThucCuoiThang: dkThuc,
            duKienDTQuyDoiCuoiThang: dkQD,
            mucTieuDTQuyDoiThang: targetQD,
            tyLeDuKienQuyDoi: tyLeDK,
            daDatMucTieuQuyDoi: tyLeDK >= 99.995,
            chenhLechQuyDoiDuKien: dkQD - targetQD
        )
    }

    /// Phân tích tổng hợp Sức khỏe 16 Nhân viên (60% Doanh thu QĐ + 40% Môn thi đua) & Cảnh báo 5 nhân viên yếu nhiều ngày liên tục
    func phanTichSucKhoeNhanVienThang(den ngay: Date) -> KetQuaPhanTichSucKhoeDoiNgu {
        let baoCaoSucBan = baoCaoSucBanNhanVienTheoNgayTrongThang(cho: ngay)
        let dsTongHopLK = tongHopNhanVien(den: ngay, sapXep: .doanhThuQD, cheDo: .luyKe)
        let dsTongHopRT = tongHopNhanVien(den: ngay, sapXep: .doanhThuQD, cheDo: .realtime)

        let mapLK = Dictionary(uniqueKeysWithValues: dsTongHopLK.map { ($0.nhanVien.maNV, $0) })
        let mapRT = Dictionary(uniqueKeysWithValues: dsTongHopRT.map { ($0.nhanVien.maNV, $0) })
        let mapCanhBao = Dictionary(uniqueKeysWithValues: baoCaoSucBan.tatCaTongKetNhanVien.map { ($0.nhanVien.maNV, $0) })

        let dsNV = caiDat.danhSachNhanVien.isEmpty ? CaiDatDMX.nhanVienMau : caiDat.danhSachNhanVien
        let soNV = max(1, dsNV.count)

        let tongDTQDLK = dsTongHopLK.reduce(0.0) { $0 + max(0, $1.doanhThuQD) }
        let tbDoiDTQD: Double
        if tongDTQDLK > 0.001 {
            tbDoiDTQD = tongDTQDLK / Double(soNV)
        } else if baoCaoSucBan.tongDTQDToanDoiThang > 0.001 {
            tbDoiDTQD = baoCaoSucBan.tongDTQDToanDoiThang / Double(soNV)
        } else {
            tbDoiDTQD = 0
        }

        var tamDanhSach: [ChiSoSucKhoeNhanVien] = []
        for nv in dsNV {
            let thLK = mapLK[nv.maNV] ?? TongHopNhanVien(
                nhanVien: nv, soMonDat: 0, tongMonGiao: 0, phanTramHTTB: 0,
                doanhThuQD: 0, soLuongDon: 0, dtQDKhoanVay: 0, dtTraThangQD: 0,
                cacMonGiao: [], doanhThuCaNhan: nil
            )
            let thRT = mapRT[nv.maNV] ?? thLK
            let cb = mapCanhBao[nv.maNV]

            let dtQDCaNhan = thLK.doanhThuQD > 0.001 ? thLK.doanhThuQD : (cb?.tongDoanhThuQDThang ?? 0)
            let ptDTQDSoVoiChuan: Double
            if tbDoiDTQD > 0.001 {
                ptDTQDSoVoiChuan = (dtQDCaNhan / tbDoiDTQD) * 100.0
            } else if let cb, cb.tyLeChuanBinhQuan > 0.001 {
                ptDTQDSoVoiChuan = cb.tyLeSoVoiChuan
            } else {
                ptDTQDSoVoiChuan = 0
            }

            let ptMon = thLK.tongMonGiao > 0 ? thLK.phanTramHTTB : ptDTQDSoVoiChuan
            let diemSKGoc: Double
            if tbDoiDTQD > 0.001 && thLK.tongMonGiao > 0 {
                diemSKGoc = min(150.0, ptDTQDSoVoiChuan * 0.6 + ptMon * 0.4)
            } else if tbDoiDTQD > 0.001 {
                diemSKGoc = min(150.0, ptDTQDSoVoiChuan)
            } else {
                diemSKGoc = min(150.0, ptMon)
            }

            let chiTietNgay = (baoCaoSucBan.bangChiTietTheoMaNV[nv.maNV] ?? []).filter { $0.coDuLieuNgayCuaDoi }
            let lichSu: [NgaySucKhoeNV] = chiTietNgay.map { d in
                let ptNgay = d.tyLeChuanBinhQuan > 0.001 ? (d.tyLeDongGopNgay / d.tyLeChuanBinhQuan) * 100.0 : 0
                let diemNgay = thLK.tongMonGiao > 0 ? (ptNgay * 0.6 + ptMon * 0.4) : ptNgay
                return NgaySucKhoeNV(
                    khoaNgay: d.khoaNgay,
                    ngayTrongThang: d.ngayTrongThang,
                    diemSucKhoe: diemNgay,
                    doanhThuQD: d.doanhThuQDNV,
                    phanTramHTMon: ptMon,
                    laNgayYeu: d.laNgayYeu
                )
            }

            let soNgayYeuLT = cb?.soNgayChuoiCanhBao ?? 0
            let tongNgayYeu = cb?.soNgayYeu ?? 0
            let soNgayCoDL = max(baoCaoSucBan.soNgayCoDuLieuNV, (dtQDCaNhan > 0 || thLK.tongMonGiao > 0) ? 1 : 0)

            let mucDo: MucDoSucKhoeNV
            if soNgayYeuLT >= 2 || diemSKGoc < 50 {
                mucDo = .yeuBaoDong
            } else if diemSKGoc < 65 || soNgayYeuLT == 1 {
                mucDo = .canChuY
            } else if diemSKGoc < 80 {
                mucDo = .kha
            } else {
                mucDo = .khoe
            }

            let lyDo = cb?.moTaChiTietCanhBao ?? "Điểm SK: \(diemSKGoc.chuoiPhanTram) • DT QĐ: \(dtQDCaNhan.chuoiSoLieu)tr"
            tamDanhSach.append(
                ChiSoSucKhoeNhanVien(
                    nhanVien: nv,
                    tongHopLuyKe: thLK,
                    tongHopRealtime: thRT,
                    diemSucKhoe: diemSKGoc,
                    phanTramDTQDSoVoiChuan: ptDTQDSoVoiChuan,
                    soNgayYeuLienTuc: soNgayYeuLT,
                    tongSoNgayYeu: tongNgayYeu,
                    soNgayCoDuLieu: soNgayCoDL,
                    lichSuNgay: lichSu,
                    laTop5CanhBao: false,
                    thuHangCanhBao: 0,
                    mucDo: mucDo,
                    lyDoCanhBao: lyDo
                )
            )
        }

        // Xếp hạng mức độ ưu tiên cảnh báo để lấy Top 5 nhân viên yếu nhiều ngày liên tục
        let sapXepCanhBao: (ChiSoSucKhoeNhanVien, ChiSoSucKhoeNhanVien) -> Bool = { a, b in
            let aYeuLT = a.soNgayYeuLienTuc >= 2
            let bYeuLT = b.soNgayYeuLienTuc >= 2
            if aYeuLT != bYeuLT { return aYeuLT && !bYeuLT }
            if a.soNgayYeuLienTuc != b.soNgayYeuLienTuc { return a.soNgayYeuLienTuc > b.soNgayYeuLienTuc }
            if a.tongSoNgayYeu != b.tongSoNgayYeu { return a.tongSoNgayYeu > b.tongSoNgayYeu }
            if abs(a.diemSucKhoe - b.diemSucKhoe) > 0.01 { return a.diemSucKhoe < b.diemSucKhoe }
            return a.phanTramDTQDSoVoiChuan < b.phanTramDTQDSoVoiChuan
        }

        var theoCanhBao = tamDanhSach.sorted(by: sapXepCanhBao)
        let coDuLieuDoi = theoCanhBao.contains { $0.soNgayCoDuLieu > 0 || $0.diemSucKhoe > 0 }
        var top5: [ChiSoSucKhoeNhanVien] = []
        if coDuLieuDoi {
            let soLuongTop = min(5, theoCanhBao.count)
            for idx in 0..<soLuongTop {
                theoCanhBao[idx].laTop5CanhBao = true
                theoCanhBao[idx].thuHangCanhBao = idx + 1
                if theoCanhBao[idx].mucDo == .khoe || theoCanhBao[idx].mucDo == .kha {
                    if theoCanhBao[idx].soNgayYeuLienTuc >= 2 {
                        theoCanhBao[idx].mucDo = .yeuBaoDong
                    }
                }
                top5.append(theoCanhBao[idx])
            }
        }

        let theoDiemCaoThap = theoCanhBao.sorted {
            if abs($0.diemSucKhoe - $1.diemSucKhoe) > 0.01 { return $0.diemSucKhoe > $1.diemSucKhoe }
            return $0.phanTramDTQDSoVoiChuan > $1.phanTramDTQDSoVoiChuan
        }

        let tbDiemSK = theoCanhBao.isEmpty ? 0 : (theoCanhBao.reduce(0.0) { $0 + $1.diemSucKhoe } / Double(theoCanhBao.count))
        let soKhoe = theoCanhBao.filter { $0.mucDo == .khoe && !$0.laTop5CanhBao }.count
        let soKha = theoCanhBao.filter { $0.mucDo == .kha && !$0.laTop5CanhBao }.count
        let soCanChuY = theoCanhBao.filter { $0.mucDo == .canChuY && !$0.laTop5CanhBao }.count
        let soYeu = theoCanhBao.filter { $0.mucDo == .yeuBaoDong || $0.laTop5CanhBao }.count

        return KetQuaPhanTichSucKhoeDoiNgu(
            danhSachTheoCanhBao: theoCanhBao,
            danhSachTheoDiemCaoThap: theoDiemCaoThap,
            top5CanhBaoYeu: top5,
            trungBinhDoiDTQD: tbDoiDTQD,
            trungBinhDiemSucKhoe: tbDiemSK,
            soNgayCoDuLieu: baoCaoSucBan.soNgayCoDuLieuNV,
            soNVKhoe: soKhoe,
            soNVKha: soKha,
            soNVCanChuY: soCanChuY,
            soNVYeu: soYeu
        )
    }

        /// Danh sách Doanh thu Realtime (Thực & Quy đổi) theo từng ngày trong tháng để vẽ đồ thị cột và bảng tổng hợp
    func danhSachRealtimeTheoNgayTrongThang(cho ngay: Date) -> [DuLieuRealtimeNgayTrongThang] {
        let lich = TienIchNgay.lich
        let nam = lich.component(.year, from: ngay)
        let thang = lich.component(.month, from: ngay)
        let soNgay = lich.range(of: .day, in: .month, for: ngay)?.count ?? 30

        var ketQua: [DuLieuRealtimeNgayTrongThang] = []
        for d in 1...soNgay {
            var comp = DateComponents()
            comp.year = nam
            comp.month = thang
            comp.day = d
            let ngayD = lich.date(from: comp) ?? ngay
            let khoa = String(format: "%04d-%02d-%02d", nam, thang, d)
            let rt = cacNgay[khoa]?.doanhThuRealtime ?? ThongTinDoanhThu()
            ketQua.append(
                DuLieuRealtimeNgayTrongThang(
                    ngay: ngayD,
                    khoaNgay: khoa,
                    ngayTrongThang: d,
                    doanhThu: rt
                )
            )
        }
        return ketQua
    }

    // MARK: - Theo dõi sức bán nhân viên theo ngày (lấy từ Doanh thu Realtime Nhân viên) & Cảnh báo nhiều ngày yếu liên tục

    /// Lấy danh sách Doanh thu Realtime Nhân viên của 1 ngày (ưu tiên `doanhThuNhanVienRealtime`, dự phòng sang `doanhThuNhanVien` nếu toàn tháng chưa quét bản Realtime riêng)
    func danhSachDoanhThuNVRealtimeCuaNgay(khoaNgay: String, coRealtimeNVTrongThang: Bool) -> [DoanhThuNhanVienItem] {
        guard let dl = cacNgay[khoaNgay] else { return [] }
        if !dl.doanhThuNhanVienRealtime.isEmpty {
            return dl.doanhThuNhanVienRealtime
        }
        if !coRealtimeNVTrongThang && !dl.doanhThuNhanVien.isEmpty {
            return dl.doanhThuNhanVien
        }
        return []
    }

    /// Tổng hợp báo cáo sức bán nhân viên theo từng ngày trong tháng & phát hiện nhân viên yếu nhiều ngày liên tục
    func baoCaoSucBanNhanVienTheoNgayTrongThang(cho ngay: Date, maNVChon: String? = nil) -> BaoCaoSucBanNhanVienThang {
        let lich = TienIchNgay.lich
        let nam = lich.component(.year, from: ngay)
        let thang = lich.component(.month, from: ngay)
        let soNgay = lich.range(of: .day, in: .month, for: ngay)?.count ?? 30
        let tienToThang = String(format: "%04d-%02d", nam, thang)

        let dsNVQuanLy = caiDat.danhSachNhanVien.isEmpty ? CaiDatDMX.nhanVienMau : caiDat.danhSachNhanVien
        let soNV = max(1, dsNVQuanLy.count)
        let tyLeChuan = 100.0 / Double(soNV)
        // Ngưỡng ngày yếu: đóng góp < 65% mức bình quân chuẩn (hoặc < 2.5% tổng đội, hoặc 0 doanh thu trong ngày đội có số)
        let nguongYeu = max(2.5, tyLeChuan * 0.65)

        let coRealtimeNVTrongThang = cacNgay.contains { k, v in
            k.hasPrefix(tienToThang) && !v.doanhThuNhanVienRealtime.isEmpty
        }

        struct ThongTinNgayDoi {
            let ngay: Date
            let khoa: String
            let ngayTrongThang: Int
            let dsNV: [DoanhThuNhanVienItem]
            let tongThuc: Double
            let tongQD: Double
            let coDuLieuDoi: Bool
        }

        var cacNgayDoi: [ThongTinNgayDoi] = []
        var tongQDToanDoiThang: Double = 0
        var tongThucToanDoiThang: Double = 0
        var soNgayCoDuLieuNV = 0

        for d in 1...soNgay {
            var comp = DateComponents()
            comp.year = nam
            comp.month = thang
            comp.day = d
            let ngayD = lich.date(from: comp) ?? ngay
            let khoa = String(format: "%04d-%02d-%02d", nam, thang, d)
            let dsNVNgay = danhSachDoanhThuNVRealtimeCuaNgay(khoaNgay: khoa, coRealtimeNVTrongThang: coRealtimeNVTrongThang)

            let tongQDNV = dsNVNgay.reduce(0.0) { $0 + max(0, $1.doanhThuQD) }
            let tongThucNV = dsNVNgay.reduce(0.0) {
                let thuc = $1.doanhThuThuc > 0 ? $1.doanhThuThuc : $1.dtTraThangQD
                return $0 + max(0, thuc)
            }
            let rtSieuThi = cacNgay[khoa]?.doanhThuRealtime ?? ThongTinDoanhThu()

            // Mẫu số tính tỷ lệ đóng góp ngày: ưu tiên tổng DT Realtime của toàn bộ NV trong bảng ngày đó (đảm bảo tổng tỷ lệ = 100%), nếu bảng NV chỉ quét một phần nhỏ hơn RT siêu thị thì dùng max
            let mauSoQD = tongQDNV > 0 ? tongQDNV : rtSieuThi.doanhThuQuyDoi
            let mauSoThuc = tongThucNV > 0 ? tongThucNV : rtSieuThi.doanhThuThuc
            let coSoNV = !dsNVNgay.isEmpty && (tongQDNV > 0 || tongThucNV > 0)

            if coSoNV {
                soNgayCoDuLieuNV += 1
                tongQDToanDoiThang += mauSoQD
                tongThucToanDoiThang += mauSoThuc
            }

            cacNgayDoi.append(
                ThongTinNgayDoi(
                    ngay: ngayD,
                    khoa: khoa,
                    ngayTrongThang: d,
                    dsNV: dsNVNgay,
                    tongThuc: mauSoThuc,
                    tongQD: mauSoQD,
                    coDuLieuDoi: coSoNV
                )
            )
        }

        var bangChiTietTheoMaNV: [String: [DuLieuSucBanNgayNhanVien]] = [:]
        var tatCaTongKet: [CanhBaoSucBanNhanVien] = []

        for nv in dsNVQuanLy {
            var chiTietNV: [DuLieuSucBanNgayNhanVien] = []
            var chuoiHienTai = 0
            var ngayBatDauChuoiHienTai: Int?
            var ngayKetThucChuoiHienTai: Int?
            var dsNgayChuoiHienTai: [Int] = []

            var chuoiDaiNhat = 0
            var ngayBatDauDaiNhat: Int?
            var ngayKetThucDaiNhat: Int?
            var dsNgayDaiNhat: [Int] = []

            var soNgayCoBan = 0
            var soNgayYeu = 0
            var tongThucNVThang: Double = 0
            var tongQDNVThang: Double = 0
            var tongDonNVThang: Double = 0

            for info in cacNgayDoi {
                let khopItem = info.dsNV.first { item in
                    Self.chuanHoaMaNV(item.maNV) == nv.maNV ||
                    Self.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: [nv]) != nil
                }

                let dtQD = max(0, khopItem?.doanhThuQD ?? 0)
                let rawThuc = (khopItem?.doanhThuThuc ?? 0) > 0 ? (khopItem?.doanhThuThuc ?? 0) : (khopItem?.dtTraThangQD ?? 0)
                let dtThuc = max(0, rawThuc)
                let soDon = max(0, khopItem?.soLuong ?? 0)
                let coCaNhan = dtQD > 0.001 || dtThuc > 0.001 || soDon > 0.001

                let tyLeNgay: Double
                if info.tongQD > 0.001 {
                    tyLeNgay = (dtQD / info.tongQD) * 100.0
                } else if info.tongThuc > 0.001 {
                    tyLeNgay = (dtThuc / info.tongThuc) * 100.0
                } else {
                    tyLeNgay = 0
                }

                var laYeu = false
                if info.coDuLieuDoi {
                    tongThucNVThang += dtThuc
                    tongQDNVThang += dtQD
                    tongDonNVThang += soDon
                    if coCaNhan {
                        soNgayCoBan += 1
                    }
                    if (dtQD <= 0.001 && dtThuc <= 0.001) || (tyLeNgay < nguongYeu) {
                        laYeu = true
                        soNgayYeu += 1
                        chuoiHienTai += 1
                        if ngayBatDauChuoiHienTai == nil {
                            ngayBatDauChuoiHienTai = info.ngayTrongThang
                        }
                        ngayKetThucChuoiHienTai = info.ngayTrongThang
                        dsNgayChuoiHienTai.append(info.ngayTrongThang)

                        if chuoiHienTai >= chuoiDaiNhat {
                            chuoiDaiNhat = chuoiHienTai
                            ngayBatDauDaiNhat = ngayBatDauChuoiHienTai
                            ngayKetThucDaiNhat = ngayKetThucChuoiHienTai
                            dsNgayDaiNhat = dsNgayChuoiHienTai
                        }
                    } else {
                        chuoiHienTai = 0
                        ngayBatDauChuoiHienTai = nil
                        ngayKetThucChuoiHienTai = nil
                        dsNgayChuoiHienTai = []
                    }
                }

                chiTietNV.append(
                    DuLieuSucBanNgayNhanVien(
                        ngay: info.ngay,
                        khoaNgay: info.khoa,
                        ngayTrongThang: info.ngayTrongThang,
                        maNV: nv.maNV,
                        hoTen: nv.hoTen,
                        soLuongDon: soDon,
                        doanhThuThucNV: dtThuc,
                        doanhThuQDNV: dtQD,
                        tongDoanhThuThucNgay: info.tongThuc,
                        tongDoanhThuQDNgay: info.tongQD,
                        tyLeDongGopNgay: tyLeNgay,
                        tyLeChuanBinhQuan: tyLeChuan,
                        coDuLieuNgayCuaDoi: info.coDuLieuDoi,
                        coDuLieuCaNhan: coCaNhan,
                        laNgayYeu: laYeu,
                        chuoiYeuLienTucTaiNgay: laYeu ? chuoiHienTai : 0
                    )
                )
            }

            bangChiTietTheoMaNV[nv.maNV] = chiTietNV

            let tyLeTBThang: Double
            if tongQDToanDoiThang > 0.001 {
                tyLeTBThang = (tongQDNVThang / tongQDToanDoiThang) * 100.0
            } else if tongThucToanDoiThang > 0.001 {
                tyLeTBThang = (tongThucNVThang / tongThucToanDoiThang) * 100.0
            } else {
                tyLeTBThang = 0
            }

            let dungChuoiHienTai = chuoiHienTai >= 2
            let dTu = dungChuoiHienTai ? ngayBatDauChuoiHienTai : ngayBatDauDaiNhat
            let dDen = dungChuoiHienTai ? ngayKetThucChuoiHienTai : ngayKetThucDaiNhat
            let dsNgayChuoi = dungChuoiHienTai ? dsNgayChuoiHienTai : dsNgayDaiNhat

            var khoangStr = ""
            if let tu = dTu, let den = dDen {
                if tu == den {
                    khoangStr = String(format: "%02d/%02d", tu, thang)
                } else {
                    khoangStr = String(format: "%02d/%02d → %02d/%02d", tu, thang, den, thang)
                }
            }

            tatCaTongKet.append(
                CanhBaoSucBanNhanVien(
                    nhanVien: nv,
                    soNgayCoSoDoi: soNgayCoDuLieuNV,
                    soNgayCoBan: soNgayCoBan,
                    soNgayYeu: soNgayYeu,
                    soNgayYeuLienTucHienTai: chuoiHienTai,
                    soNgayYeuLienTucDaiNhat: chuoiDaiNhat,
                    khoangNgayYeuLienTuc: khoangStr,
                    danhSachNgayYeuLienTuc: dsNgayChuoi,
                    tongDoanhThuThucThang: tongThucNVThang,
                    tongDoanhThuQDThang: tongQDNVThang,
                    tongSoDonThang: tongDonNVThang,
                    tyLeDongGopTBThang: tyLeTBThang,
                    tyLeChuanBinhQuan: tyLeChuan
                )
            )
        }

        let sapXepMucDoYeu: (CanhBaoSucBanNhanVien, CanhBaoSucBanNhanVien) -> Bool = { a, b in
            if a.biCanhBaoNhieuNgayYeu != b.biCanhBaoNhieuNgayYeu {
                return a.biCanhBaoNhieuNgayYeu && !b.biCanhBaoNhieuNgayYeu
            }
            if a.dangYeuLienTucHienTai != b.dangYeuLienTucHienTai {
                return a.dangYeuLienTucHienTai && !b.dangYeuLienTucHienTai
            }
            if a.soNgayChuoiCanhBao != b.soNgayChuoiCanhBao {
                return a.soNgayChuoiCanhBao > b.soNgayChuoiCanhBao
            }
            if a.soNgayYeu != b.soNgayYeu {
                return a.soNgayYeu > b.soNgayYeu
            }
            return a.tyLeDongGopTBThang < b.tyLeDongGopTBThang
        }

        let dsCanhBao = tatCaTongKet
            .filter { $0.biCanhBaoNhieuNgayYeu }
            .sorted(by: sapXepMucDoYeu)

        // Lấy Top 5 nhân viên yếu nhiều ngày liên tục (ưu tiên chuỗi ngày yếu liên tục >= 2 ngày, nếu chưa đủ 5 thì bổ sung nhân viên có ngày yếu / tỷ lệ đóng góp thấp nhất)
        let dsTop5Yeu: [CanhBaoSucBanNhanVien]
        if soNgayCoDuLieuNV == 0 {
            dsTop5Yeu = []
        } else if dsCanhBao.count >= 5 {
            dsTop5Yeu = Array(dsCanhBao.prefix(5))
        } else {
            let maDaCo = Set(dsCanhBao.map { $0.nhanVien.maNV })
            let boSung = tatCaTongKet
                .filter { !maDaCo.contains($0.nhanVien.maNV) && ($0.soNgayYeu > 0 || $0.tyLeDongGopTBThang < tyLeChuan) }
                .sorted(by: sapXepMucDoYeu)
            dsTop5Yeu = Array((dsCanhBao + boSung).prefix(5))
        }

        let nvChon = dsNVQuanLy.first(where: { $0.maNV == maNVChon }) ?? dsTop5Yeu.first?.nhanVien ?? dsNVQuanLy.first ?? NhanVienQuanLy(maNV: "24939", hoTen: "Phan Hoàng Sơn")
        let chiTietChon = bangChiTietTheoMaNV[nvChon.maNV] ?? []
        let tongKetChon = tatCaTongKet.first(where: { $0.nhanVien.maNV == nvChon.maNV }) ?? CanhBaoSucBanNhanVien(
            nhanVien: nvChon,
            soNgayCoSoDoi: soNgayCoDuLieuNV,
            soNgayCoBan: 0,
            soNgayYeu: 0,
            soNgayYeuLienTucHienTai: 0,
            soNgayYeuLienTucDaiNhat: 0,
            khoangNgayYeuLienTuc: "",
            danhSachNgayYeuLienTuc: [],
            tongDoanhThuThucThang: 0,
            tongDoanhThuQDThang: 0,
            tongSoDonThang: 0,
            tyLeDongGopTBThang: 0,
            tyLeChuanBinhQuan: tyLeChuan
        )

        return BaoCaoSucBanNhanVienThang(
            nhanVienDangChon: nvChon,
            danhSachNhanVien: dsNVQuanLy,
            chiTietTheoNgay: chiTietChon,
            bangChiTietTheoMaNV: bangChiTietTheoMaNV,
            tongKetNhanVienDangChon: tongKetChon,
            tatCaTongKetNhanVien: tatCaTongKet,
            danhSachCanhBaoYeuLienTuc: dsCanhBao,
            danhSach5NhanVienYeuLienTuc: dsTop5Yeu,
            soNgayCoDuLieuNV: soNgayCoDuLieuNV,
            tongDTQDToanDoiThang: tongQDToanDoiThang,
            tongDTThucToanDoiThang: tongThucToanDoiThang
        )
    }

    func duLieu(cho ngay: Date) -> DuLieuNgayDMX {
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        let luyKeThang = doanhThuLuyKeThang(cho: ngay)

        // Tìm target Lũy kế & Realtime gần nhất trong tháng (tách biệt hoàn toàn giữa Lũy kế và Realtime)
        var targetTheoKhoaTrongThang: [String: Double] = [:]
        var targetRealtimeTheoKhoaTrongThang: [String: Double] = [:]
        for kNgay in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 <= khoa }).sorted() {
            guard let dlNgay = cacNgay[kNgay] else { continue }
            for d in dlNgay.danhSachThiDua where d.target > 0 {
                let k1 = Self.chuanHoaKhoaSoSanh(Self.apDungLocTuCaiDat(d.tenNganhHangGoc))
                let k2 = Self.chuanHoaKhoaSoSanh(d.tenNganhHangGoc)
                if !k1.isEmpty { targetTheoKhoaTrongThang[k1] = d.target }
                if !k2.isEmpty { targetTheoKhoaTrongThang[k2] = d.target }
            }
            for d in dlNgay.danhSachThiDuaRealtime where d.target > 0 {
                let k1 = Self.chuanHoaKhoaSoSanh(Self.apDungLocTuCaiDat(d.tenNganhHangGoc))
                let k2 = Self.chuanHoaKhoaSoSanh(d.tenNganhHangGoc)
                if !k1.isEmpty { targetRealtimeTheoKhoaTrongThang[k1] = d.target }
                if !k2.isEmpty { targetRealtimeTheoKhoaTrongThang[k2] = d.target }
            }
        }

        if var coSan = cacNgay[khoa] {
            if !coSan.doanhThu.coDuLieu && luyKeThang.coDuLieu {
                coSan.doanhThu = luyKeThang
            }
            for i in coSan.danhSachThiDua.indices {
                let goc = coSan.danhSachThiDua[i].tenNganhHangGoc
                coSan.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
                if coSan.danhSachThiDua[i].target <= 0 {
                    let k1 = Self.chuanHoaKhoaSoSanh(coSan.danhSachThiDua[i].tenNganhHang)
                    let k2 = Self.chuanHoaKhoaSoSanh(goc)
                    if let t = targetTheoKhoaTrongThang[k1] ?? targetTheoKhoaTrongThang[k2], t > 0 {
                        coSan.danhSachThiDua[i].target = t
                    }
                }
            }
            coSan.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: coSan.danhSachThiDua)

            for i in coSan.danhSachThiDuaRealtime.indices {
                let goc = coSan.danhSachThiDuaRealtime[i].tenNganhHangGoc
                coSan.danhSachThiDuaRealtime[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
                if coSan.danhSachThiDuaRealtime[i].target <= 0 {
                    let k1 = Self.chuanHoaKhoaSoSanh(coSan.danhSachThiDuaRealtime[i].tenNganhHang)
                    let k2 = Self.chuanHoaKhoaSoSanh(goc)
                    if let t = targetRealtimeTheoKhoaTrongThang[k1] ?? targetRealtimeTheoKhoaTrongThang[k2], t > 0 {
                        coSan.danhSachThiDuaRealtime[i].target = t
                    }
                }
            }
            coSan.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: coSan.danhSachThiDuaRealtime)
            return coSan
        }
        return DuLieuNgayDMX(
            khoaNgay: khoa,
            capNhatLuc: "",
            thongTinDonVi: "",
            doanhThu: luyKeThang,
            danhSachThiDua: [],
            danhSachThiDuaRealtime: []
        )
    }

    func luu(_ duLieu: DuLieuNgayDMX) {
        var banLuu = duLieu
        let tienTo = String(banLuu.khoaNgay.prefix(7))
        for i in banLuu.danhSachThiDua.indices {
            let goc = banLuu.danhSachThiDua[i].tenNganhHangGoc
            banLuu.danhSachThiDua[i].tenNganhHang = Self.apDungLocTuCaiDat(goc)
        }
        banLuu.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: banLuu.danhSachThiDua)

        for i in banLuu.danhSachThiDuaRealtime.indices {
            let goc = banLuu.danhSachThiDuaRealtime[i].tenNganhHangGoc
            banLuu.danhSachThiDuaRealtime[i].tenNganhHang = Self.apDungLocTuCaiDat(goc)
        }
        banLuu.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: banLuu.danhSachThiDuaRealtime)

        // Doanh thu Lũy kế là cố định của tháng: khi người dùng nhập vào mỗi ngày sẽ thay thế cho ngày hôm trước trong cùng tháng
        if banLuu.doanhThu.coDuLieu {
            for k in cacNgay.keys where k.hasPrefix(tienTo) {
                cacNgay[k]?.doanhThu = banLuu.doanhThu
            }
        } else {
            // Nếu chưa truyền doanhThu mới vào banLuu nhưng trong tháng đã có Lũy kế thì giữ Lũy kế của tháng
            for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 != banLuu.khoaNgay }).sorted(by: >) {
                if let dtCu = cacNgay[k]?.doanhThu, dtCu.coDuLieu {
                    banLuu.doanhThu = dtCu
                    break
                }
            }
        }

        cacNgay[banLuu.khoaNgay] = banLuu
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
        DichVuDongBo.dungChung.dayDuLieuNgay(banLuu)
    }

    func luuCaiDat(_ moi: CaiDatDMX) {
        caiDat = moi
        ThuMucDuLieu.dungChung.ghi(moi, vao: ThuMucDuLieu.dungChung.tepCaiDat)
        for (khoa, var dl) in cacNgay {
            for i in dl.danhSachThiDua.indices {
                let goc = dl.danhSachThiDua[i].tenNganhHangGoc
                dl.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            dl.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: dl.danhSachThiDua)

            for i in dl.danhSachThiDuaRealtime.indices {
                let goc = dl.danhSachThiDuaRealtime[i].tenNganhHangGoc
                dl.danhSachThiDuaRealtime[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            dl.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: dl.danhSachThiDuaRealtime)
            cacNgay[khoa] = dl
        }
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
        DichVuDongBo.dungChung.dayCaiDat(moi)
    }

    func nhapDuLieuDamMay(caiDat moi: CaiDatDMX?, cacNgay ngayMoi: [String: DuLieuNgayDMX]) {
        if let moi { caiDat = moi }
        for (khoa, var duLieu) in ngayMoi {
            duLieu.khoaNgay = khoa
            for i in duLieu.danhSachThiDua.indices {
                let goc = duLieu.danhSachThiDua[i].tenNganhHangGoc
                duLieu.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            duLieu.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: duLieu.danhSachThiDua)

            for i in duLieu.danhSachThiDuaRealtime.indices {
                let goc = duLieu.danhSachThiDuaRealtime[i].tenNganhHangGoc
                duLieu.danhSachThiDuaRealtime[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            duLieu.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: duLieu.danhSachThiDuaRealtime)
            cacNgay[khoa] = duLieu
        }
        ThuMucDuLieu.dungChung.ghi(caiDat, vao: ThuMucDuLieu.dungChung.tepCaiDat)
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
    }

    func datLaiSauDangXuat() {
        caiDat = CaiDatDMX()
        cacNgay = [:]
        ThuMucDuLieu.dungChung.ghi(caiDat, vao: ThuMucDuLieu.dungChung.tepCaiDat)
        ThuMucDuLieu.dungChung.ghi(cacNgay, vao: ThuMucDuLieu.dungChung.tepNgay)
    }

    /// Danh sách mặt hàng đồng bộ trực tiếp với bảng Thi đua Lũy kế hoặc Realtime của ngày đang chọn
    func danhSachMatHangThang(den ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [DongThiDua] {
        let dlNgay = duLieu(cho: ngay)
        if cheDo == .realtime {
            if !dlNgay.danhSachThiDuaRealtime.isEmpty {
                return dlNgay.danhSachThiDuaRealtime
            }
            let khoaDen = TienIchNgay.khoa.string(from: ngay)
            let tienTo = String(khoaDen.prefix(7))
            for khoa in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 <= khoaDen }).sorted(by: >) {
                if let dl = cacNgay[khoa], !dl.danhSachThiDuaRealtime.isEmpty {
                    var ds = dl.danhSachThiDuaRealtime
                    for i in ds.indices {
                        ds[i].tenNganhHang = Self.apDungLocTuCaiDat(ds[i].tenNganhHangGoc)
                    }
                    return Self.gopDanhSachThiDua(cu: [], moi: ds)
                }
            }
        }

        if !dlNgay.danhSachThiDua.isEmpty {
            return dlNgay.danhSachThiDua
        }

        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoaDen.prefix(7))
        let cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted(by: >)
        for khoa in cacKhoa {
            if let dl = cacNgay[khoa], !dl.danhSachThiDua.isEmpty {
                var ds = dl.danhSachThiDua
                for i in ds.indices {
                    ds[i].tenNganhHang = Self.apDungLocTuCaiDat(ds[i].tenNganhHangGoc)
                }
                return Self.gopDanhSachThiDua(cu: [], moi: ds)
            }
        }
        if !dlNgay.danhSachThiDuaRealtime.isEmpty {
            return dlNgay.danhSachThiDuaRealtime
        }
        return []
    }

    /// Lấy danh sách mã NV được chia Target cho 1 ngành hàng (đồng bộ cả khóa tên đã lọc và khóa tên gốc)
    func danhSachMaNVChiaTarget(cho dong: DongThiDua, trong tapCaiDat: CaiDatDMX? = nil) -> [String] {
        let cd = tapCaiDat ?? caiDat
        let tatCaMa = cd.danhSachNhanVien.map(\.maNV)
        let k1 = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let k2 = Self.chuanHoaKhoaSoSanh(dong.tenNganhHangGoc)
        if let ds = cd.chiaTargetNganhHang[k1] ?? cd.chiaTargetNganhHang[k2] {
            return ds.filter { tatCaMa.contains($0) }
        }
        return tatCaMa
    }

    /// Đồng bộ cập nhật Target & ĐVT (DT/SL) của 1 ngành hàng từ màn hình Chia Target (Cài đặt) sang Bảng Thi Đua
    func capNhatTargetNganhHang(dongGoc: DongThiDua, targetMoi: Double, loaiChiTieuMoi: LoaiChiTieuThiDua? = nil, cho ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) {
        let k1 = Self.chuanHoaKhoaSoSanh(dongGoc.tenNganhHang)
        let k2 = Self.chuanHoaKhoaSoSanh(dongGoc.tenNganhHangGoc)
        var dl = duLieu(cho: ngay)
        var ds = dl.danhSachThiDua(theo: cheDo)
        var daCapNhat = false
        for i in ds.indices {
            let dk1 = Self.chuanHoaKhoaSoSanh(ds[i].tenNganhHang)
            let dk2 = Self.chuanHoaKhoaSoSanh(ds[i].tenNganhHangGoc)
            if ds[i].id == dongGoc.id || dk1 == k1 || dk2 == k2 {
                ds[i].target = targetMoi
                if let loai = loaiChiTieuMoi {
                    ds[i].loaiChiTieu = loai
                }
                daCapNhat = true
            }
        }
        if daCapNhat {
            dl.ganDanhSachThiDua(ds, theo: cheDo)
            luu(dl)
        } else {
            let khoaDen = TienIchNgay.khoa.string(from: ngay)
            let tienTo = String(khoaDen.prefix(7))
            let cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted(by: >)
            for khoa in cacKhoa {
                guard var dlCu = cacNgay[khoa] else { continue }
                var dsCu = dlCu.danhSachThiDua(theo: cheDo)
                guard !dsCu.isEmpty else { continue }
                for i in dsCu.indices {
                    let dk1 = Self.chuanHoaKhoaSoSanh(Self.apDungLocTuCaiDat(dsCu[i].tenNganhHangGoc))
                    let dk2 = Self.chuanHoaKhoaSoSanh(dsCu[i].tenNganhHangGoc)
                    if dk1 == k1 || dk2 == k2 {
                        dsCu[i].target = targetMoi
                        if let loai = loaiChiTieuMoi {
                            dsCu[i].loaiChiTieu = loai
                        }
                    }
                }
                dlCu.ganDanhSachThiDua(dsCu, theo: cheDo)
                luu(dlCu)
                break
            }
        }
    }

    /// Tổng hợp số thực hiện mới nhất của từng nhân viên theo từng mặt hàng từ ngày 1 đến ngày hiện tại
    func thucHienNhanVienTheoMatHangThang(den ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [String: [String: Double]] {
        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        if cheDo == .realtime {
            let dl = duLieu(cho: ngay)
            if !dl.thiDuaNhanVienRealtime.isEmpty {
                return dl.thiDuaNhanVienRealtime
            }
            return dl.thiDuaNhanVien
        }

        let tienTo = String(khoaDen.prefix(7))
        var cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted()
        if !cacKhoa.contains(khoaDen) {
            cacKhoa.append(khoaDen)
        }

        var ketQua: [String: [String: Double]] = [:]
        for khoa in cacKhoa {
            let dl = (khoa == khoaDen) ? duLieu(cho: ngay) : cacNgay[khoa]
            guard let bangNganh = dl?.thiDuaNhanVien else { continue }
            for (khoaNganh, bangNV) in bangNganh {
                ketQua[khoaNganh, default: [:]].merge(bangNV) { _, moi in moi }
            }
        }
        return ketQua
    }

    /// Danh sách xếp hạng nhân viên cho 1 ngành hàng cụ thể (ModalChiTietNganhHang trên web)
    func danhSachXepHangNhanVien(cho dong: DongThiDua, den ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [DongXepHangNhanVienNganh] {
        let khoaNganh = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let dsMaDuocChon = danhSachMaNVChiaTarget(cho: dong)
        let soNV = dsMaDuocChon.count
        guard soNV > 0 else { return [] }

        let targetCaNhan = dong.target / Double(soNV)
        let bangTH = thucHienNhanVienTheoMatHangThang(den: ngay, cheDo: cheDo)[khoaNganh] ?? [:]

        return dsMaDuocChon.map { maNV in
            let nv = caiDat.danhSachNhanVien.first(where: { $0.maNV == maNV }) ?? NhanVienQuanLy(maNV: maNV, hoTen: "NV \(maNV)")
            let thucHien = bangTH[maNV] ?? 0
            let phanTramHT = targetCaNhan > 0.0001 ? (thucHien / targetCaNhan) * 100.0 : 0
            return DongXepHangNhanVienNganh(
                maNV: maNV,
                hoTen: nv.hoTen,
                thucHien: thucHien,
                targetCaNhan: targetCaNhan,
                phanTramHT: phanTramHT
            )
        }.sorted {
            if abs($0.phanTramHT - $1.phanTramHT) > 0.001 {
                return $0.phanTramHT > $1.phanTramHT
            }
            return $0.thucHien > $1.thucHien
        }
    }

    /// Bảng tổng hợp nhân viên (Tab Nhân viên theo chế độ Lũy kế hoặc Realtime)
    func tongHopNhanVien(den ngay: Date, sapXep: KieuSapXepNhanVien = .soMonHoanThanh, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [TongHopNhanVien] {
        let matHang = danhSachMatHangThang(den: ngay, cheDo: cheDo)
        let thucHienTheoNganh = thucHienNhanVienTheoMatHangThang(den: ngay, cheDo: cheDo)
        let dlHienTai = duLieu(cho: ngay)
        let dtNVList = (cheDo == .realtime && !dlHienTai.doanhThuNhanVienRealtime.isEmpty)
            ? dlHienTai.doanhThuNhanVienRealtime
            : dlHienTai.doanhThuNhanVien

        // Nếu chế độ Lũy kế mà ngày hiện tại chưa có doanhThuNhanVien thì lấy bản mới nhất trong tháng
        var dtFallbackTheoMa: [String: DoanhThuNhanVienItem] = [:]
        if cheDo == .luyKe {
            let khoaDen = TienIchNgay.khoa.string(from: ngay)
            let tienTo = String(khoaDen.prefix(7))
            for khoa in cacNgay.keys.sorted() where khoa.hasPrefix(tienTo) && khoa <= khoaDen {
                for item in cacNgay[khoa]?.doanhThuNhanVien ?? [] {
                    dtFallbackTheoMa[Self.chuanHoaMaNV(item.maNV)] = item
                }
            }
        }

        let dsNV = caiDat.danhSachNhanVien
        var ketQua: [TongHopNhanVien] = dsNV.map { nv in
            var cacMonGiao: [MonThiDuaNhanVien] = []
            for mh in matHang {
                let khoa = Self.chuanHoaKhoaSoSanh(mh.tenNganhHang)
                let dsMaDuocGiao = danhSachMaNVChiaTarget(cho: mh)
                guard dsMaDuocGiao.contains(nv.maNV) else { continue }

                let soNguoiNhan = max(1, dsMaDuocGiao.count)
                let targetCaNhan = mh.target / Double(soNguoiNhan)
                let thucHien = thucHienTheoNganh[khoa]?[nv.maNV] ?? 0
                let phanTramHT = targetCaNhan > 0.0001 ? (thucHien / targetCaNhan) * 100.0 : 0
                let phanTramSieuThi = mh.target > 0.0001 ? (mh.thucHien / mh.target) * 100.0 : 0

                cacMonGiao.append(MonThiDuaNhanVien(
                    khoaNganh: khoa,
                    tenNganhHang: mh.tenNganhHang,
                    loaiChiTieu: mh.loaiChiTieu,
                    thucHien: thucHien,
                    targetCaNhan: targetCaNhan,
                    phanTramHT: phanTramHT,
                    phanTramSieuThi: phanTramSieuThi
                ))
            }

            cacMonGiao.sort { $0.phanTramHT > $1.phanTramHT }
            let soMonDat = cacMonGiao.filter(\.daDat).count
            let tongMonGiao = cacMonGiao.count
            let phanTramHTTB = tongMonGiao > 0 ? cacMonGiao.map(\.phanTramHT).reduce(0, +) / Double(tongMonGiao) : 0

            let dtCaNhan = dtNVList.first(where: {
                Self.chuanHoaMaNV($0.maNV) == nv.maNV ||
                Self.khopNhanVienQuetVoiQuanLy(maQuet: $0.maNV, tenQuet: $0.hoTen, dsQuanLy: [nv]) != nil
            }) ?? dtFallbackTheoMa[nv.maNV]

            return TongHopNhanVien(
                nhanVien: nv,
                soMonDat: soMonDat,
                tongMonGiao: tongMonGiao,
                phanTramHTTB: phanTramHTTB,
                doanhThuQD: dtCaNhan?.doanhThuQD ?? 0,
                soLuongDon: dtCaNhan?.soLuong ?? 0,
                dtQDKhoanVay: dtCaNhan?.dtQDKhoanVay ?? 0,
                dtTraThangQD: (dtCaNhan?.dtTraThangQD ?? 0) > 0 ? (dtCaNhan?.dtTraThangQD ?? 0) : (dtCaNhan?.doanhThuThuc ?? 0),
                cacMonGiao: cacMonGiao,
                doanhThuCaNhan: dtCaNhan
            )
        }

        switch sapXep {
        case .soMonHoanThanh:
            ketQua.sort {
                if $0.soMonDat != $1.soMonDat { return $0.soMonDat > $1.soMonDat }
                if abs($0.phanTramHTTB - $1.phanTramHTTB) > 0.001 { return $0.phanTramHTTB > $1.phanTramHTTB }
                return $0.doanhThuQD > $1.doanhThuQD
            }
        case .doanhThuQD:
            ketQua.sort {
                if abs($0.doanhThuQD - $1.doanhThuQD) > 0.001 { return $0.doanhThuQD > $1.doanhThuQD }
                return $0.soMonDat > $1.soMonDat
            }
        case .phanTramTB:
            ketQua.sort {
                if abs($0.phanTramHTTB - $1.phanTramHTTB) > 0.001 { return $0.phanTramHTTB > $1.phanTramHTTB }
                return $0.soMonDat > $1.soMonDat
            }
        }
        return ketQua
    }

    /// Gộp kết quả quét thực hiện nhân viên theo ngành hàng vào dữ liệu ngày
    func gopKetQuaThiDuaNhanVien(
        hienTai: [String: [String: Double]],
        mangKhoiNV: [KetQuaThiDuaNhanVienKhoi],
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        khoaNganhMacDinh: String? = nil
    ) -> [String: [String: Double]] {
        var ketQua = hienTai
        let matHangThang = danhSachMatHangThang(den: ngay, cheDo: cheDo)

        for khoi in mangKhoiNV {
            let tenLoc = Self.apDungLocTuCaiDat(khoi.tenNganhHang)
            var khoaNganh = Self.chuanHoaKhoaSoSanh(tenLoc)

            if !khoaNganh.isEmpty {
                if let khop = matHangThang.first(where: {
                    let k = Self.chuanHoaKhoaSoSanh($0.tenNganhHang)
                    return k == khoaNganh || k.contains(khoaNganh) || khoaNganh.contains(k)
                }) {
                    khoaNganh = Self.chuanHoaKhoaSoSanh(khop.tenNganhHang)
                }
            }
            if (khoaNganh.isEmpty || khoaNganh == "NGANH HANG"), let macDinh = khoaNganhMacDinh, !macDinh.isEmpty {
                khoaNganh = macDinh
            }
            guard !khoaNganh.isEmpty else { continue }

            var bangCu = ketQua[khoaNganh] ?? [:]
            for item in khoi.danhSach {
                let nvKhop = Self.khopNhanVienQuetVoiQuanLy(
                    maQuet: item.maNV,
                    tenQuet: item.hoTen,
                    dsQuanLy: caiDat.danhSachNhanVien
                )
                let maLuu = nvKhop?.maNV ?? Self.chuanHoaMaNV(item.maNV)
                guard !maLuu.isEmpty else { continue }
                if item.thucHien >= 0 {
                    bangCu[maLuu] = item.thucHien
                }
            }
            ketQua[khoaNganh] = bangCu
        }
        return ketQua
    }

    /// Làm sạch ký tự thừa (dấu |, dấu gạch ngang, nhãn DT/SL ở rìa) và lọc bỏ cụm từ trong Cài đặt
    static func apDungLocTuCaiDat(_ tenGoc: String) -> String {
        var s = tenGoc
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "^[\\s\\-–—−•◦○●⊕⊖|¦/\\\\,:;]+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "(?:\\s+|\\s*[\\|¦]\\s*)\\b(DT|SL|5L|0T)\\b\\s*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\.\\.\\.|…", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let danhSachLoc = KhoDuLieu.dungChung.caiDat.danhSachCumTuLocBo
        for cumTu in danhSachLoc {
            let sach = cumTu.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !sach.isEmpty else { continue }
            s = s.replacingOccurrences(of: sach, with: "", options: .caseInsensitive)
        }

        s = s
            .replacingOccurrences(of: "^[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\|\\s*\\|+", with: "|", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return s.isEmpty ? tenGoc.trimmingCharacters(in: .whitespacesAndNewlines) : s
    }

    static func gopDanhSachThiDua(cu: [DongThiDua], moi: [DongThiDua]) -> [DongThiDua] {
        var ketQua = cu
        for var dongMoi in moi {
            dongMoi.tenNganhHang = apDungLocTuCaiDat(dongMoi.tenNganhHangGoc)
            let khoaGocMoi = chuanHoaKhoaSoSanh(dongMoi.tenNganhHangGoc)
            let khoaMoi = khoaGocMoi.isEmpty ? chuanHoaKhoaSoSanh(dongMoi.tenNganhHang) : khoaGocMoi
            guard !khoaMoi.isEmpty else { continue }

            if let viTri = ketQua.firstIndex(where: {
                let kg = chuanHoaKhoaSoSanh($0.tenNganhHangGoc)
                return (kg.isEmpty ? chuanHoaKhoaSoSanh($0.tenNganhHang) : kg) == khoaMoi
            }) {
                var dongCu = ketQua[viTri]
                if dongMoi.tenNganhHangGoc.count > dongCu.tenNganhHangGoc.count && !dongMoi.tenNganhHangGoc.hasSuffix("...") {
                    dongCu.tenNganhHangGoc = dongMoi.tenNganhHangGoc
                    dongCu.tenNganhHang = dongMoi.tenNganhHang
                }
                dongCu.loaiChiTieu = dongMoi.loaiChiTieu
                if dongMoi.thucHien > 0 {
                    dongCu.thucHien = dongMoi.thucHien
                }
                if dongMoi.target > 0 {
                    dongCu.target = dongMoi.target
                }
                if let htGoc = dongMoi.phanTramHTGoc, htGoc > 0 {
                    dongCu.phanTramHTGoc = htGoc
                }
                if let dbGoc = dongMoi.phanTramDuBaoGoc, dbGoc > 0 {
                    dongCu.phanTramDuBaoGoc = dbGoc
                }
                if let dkGoc = dongMoi.duKienGoc, dkGoc > 0 {
                    dongCu.duKienGoc = dkGoc
                }
                ketQua[viTri] = dongCu
            } else {
                ketQua.append(dongMoi)
            }
        }
        return ketQua
    }

    static func chuanHoaKhoaSoSanh(_ ten: String) -> String {
        ten.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .replacingOccurrences(of: "[\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    }

    static func chuanHoaMaNV(_ raw: String) -> String {
        if let range = raw.range(of: "\\d{3,10}", options: .regularExpression) {
            return String(raw[range])
        }
        return raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func khopNhanVienQuetVoiQuanLy(
        maQuet: String,
        tenQuet: String,
        dsQuanLy: [NhanVienQuanLy]
    ) -> NhanVienQuanLy? {
        let maSach = chuanHoaMaNV(maQuet.isEmpty ? tenQuet : maQuet)
        if !maSach.isEmpty {
            if let theoMa = dsQuanLy.first(where: { $0.maNV == maSach }) {
                return theoMa
            }
        }
        let tenKhongSo = tenQuet
            .replacingOccurrences(of: "\\d+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[-–—]", with: " ", options: .regularExpression)
        let tenChuan = chuanHoaKhoaSoSanh(tenKhongSo)
        guard !tenChuan.isEmpty else { return nil }

        for nv in dsQuanLy {
            let nvChuan = chuanHoaKhoaSoSanh(nv.hoTen)
            if nvChuan == tenChuan || nvChuan.hasSuffix(tenChuan) || tenChuan.hasSuffix(nvChuan) || nvChuan.contains(tenChuan) {
                return nv
            }
        }
        return nil
    }

    static func huyChuongHang(_ hang: Int) -> String {
        switch hang {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(hang)"
        }
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

    private static let boDinhDangNguyenVN: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "vi_VN")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 0
        df.maximumFractionDigits = 0
        return df
    }()

    var chuoiSoVN: String {
        Double.boDinhDangVN.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    var chuoiSoNguyenVN: String {
        Double.boDinhDangNguyenVN.string(from: NSNumber(value: self.rounded())) ?? String(format: "%.0f", self)
    }

    var chuoiSoGonVN: String {
        if abs(self.rounded() - self) < 0.005 {
            return chuoiSoNguyenVN
        }
        return chuoiSoVN
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
