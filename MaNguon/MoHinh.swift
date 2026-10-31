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

    var tieuDe: String {
        switch self {
        case .thiDua: return "Thi đua"
        case .nhanVien: return "Nhân viên"
        case .duPhong2: return "Dự phòng 2"
        case .duPhong3: return "Dự phòng 3"
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
    func gop(voi moi: ThongTinDoanhThu) -> ThongTinDoanhThu {
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

    enum CodingKeys: String, CodingKey {
        case id
        case tenNganhHangGoc
        case tenNganhHang
        case loaiChiTieu
        case thucHien
        case target
        case phanTramHTGoc
        case phanTramDuBaoGoc
    }

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
    var danhSachNhanVien: [NhanVienQuanLy] = CaiDatDMX.nhanVienMau
    var chiaTargetNganhHang: [String: [String]] = [:]

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
        chiaTargetNganhHang: [String: [String]] = [:]
    ) {
        self.kieuHienThi = kieuHienThi
        self.danhSachCumTuLocBo = danhSachCumTuLocBo
        self.soCotXuatAnh = soCotXuatAnh
        self.danhSachNhanVien = danhSachNhanVien
        self.chiaTargetNganhHang = chiaTargetNganhHang
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
    }
}

struct DuLieuNgayDMX: Codable {
    var khoaNgay: String
    var capNhatLuc: String
    var thongTinDonVi: String
    var doanhThu: ThongTinDoanhThu
    var doanhThuRealtime: ThongTinDoanhThu = ThongTinDoanhThu()
    var danhSachThiDua: [DongThiDua]
    var thiDuaNhanVien: [String: [String: Double]] = [:]
    var doanhThuNhanVien: [DoanhThuNhanVienItem] = []

    init(
        khoaNgay: String,
        capNhatLuc: String,
        thongTinDonVi: String,
        doanhThu: ThongTinDoanhThu,
        doanhThuRealtime: ThongTinDoanhThu = ThongTinDoanhThu(),
        danhSachThiDua: [DongThiDua],
        thiDuaNhanVien: [String: [String: Double]] = [:],
        doanhThuNhanVien: [DoanhThuNhanVienItem] = []
    ) {
        self.khoaNgay = khoaNgay
        self.capNhatLuc = capNhatLuc
        self.thongTinDonVi = thongTinDonVi
        self.doanhThu = doanhThu
        self.doanhThuRealtime = doanhThuRealtime
        self.danhSachThiDua = danhSachThiDua
        self.thiDuaNhanVien = thiDuaNhanVien
        self.doanhThuNhanVien = doanhThuNhanVien
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        khoaNgay = (try? c.decode(String.self, forKey: .khoaNgay)) ?? ""
        capNhatLuc = (try? c.decode(String.self, forKey: .capNhatLuc)) ?? ""
        thongTinDonVi = (try? c.decode(String.self, forKey: .thongTinDonVi)) ?? ""
        doanhThu = (try? c.decode(ThongTinDoanhThu.self, forKey: .doanhThu)) ?? ThongTinDoanhThu()
        doanhThuRealtime = (try? c.decode(ThongTinDoanhThu.self, forKey: .doanhThuRealtime)) ?? ThongTinDoanhThu()
        danhSachThiDua = (try? c.decode([DongThiDua].self, forKey: .danhSachThiDua)) ?? []
        thiDuaNhanVien = (try? c.decode([String: [String: Double]].self, forKey: .thiDuaNhanVien)) ?? [:]
        doanhThuNhanVien = (try? c.decode([DoanhThuNhanVienItem].self, forKey: .doanhThuNhanVien)) ?? []
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
        DichVuDongBo.dungChung.dayDuLieuNgay(duLieu)
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

    /// Danh sách tất cả mặt hàng từ ngày 1 đầu tháng đến ngày đang chọn
    func danhSachMatHangThang(den ngay: Date) -> [DongThiDua] {
        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoaDen.prefix(7))
        var cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted()
        if !cacKhoa.contains(khoaDen) {
            cacKhoa.append(khoaDen)
        }

        var map: [String: DongThiDua] = [:]
        var thuTuKhoa: [String] = []
        for khoa in cacKhoa {
            let dl = (khoa == khoaDen) ? duLieu(cho: ngay) : cacNgay[khoa]
            for var dong in dl?.danhSachThiDua ?? [] {
                dong.tenNganhHang = Self.apDungLocTuCaiDat(dong.tenNganhHangGoc)
                let k = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
                guard !k.isEmpty else { continue }
                if map[k] == nil { thuTuKhoa.append(k) }
                map[k] = dong
            }
        }
        return thuTuKhoa.compactMap { map[$0] }
    }

    /// Tổng hợp số thực hiện mới nhất của từng nhân viên theo từng mặt hàng từ ngày 1 đến ngày hiện tại
    func thucHienNhanVienTheoMatHangThang(den ngay: Date) -> [String: [String: Double]] {
        let khoaDen = TienIchNgay.khoa.string(from: ngay)
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
    func danhSachXepHangNhanVien(cho dong: DongThiDua, den ngay: Date) -> [DongXepHangNhanVienNganh] {
        let khoaNganh = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let dsMaDuocChon = caiDat.chiaTargetNganhHang[khoaNganh] ?? caiDat.danhSachNhanVien.map(\.maNV)
        let soNV = dsMaDuocChon.count
        guard soNV > 0 else { return [] }

        let targetCaNhan = dong.target / Double(soNV)
        let bangTH = thucHienNhanVienTheoMatHangThang(den: ngay)[khoaNganh] ?? [:]

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

    /// Bảng tổng hợp nhân viên (Tab Nhân viên trên web)
    func tongHopNhanVien(den ngay: Date, sapXep: KieuSapXepNhanVien = .soMonHoanThanh) -> [TongHopNhanVien] {
        let matHang = danhSachMatHangThang(den: ngay)
        let thucHienTheoNganh = thucHienNhanVienTheoMatHangThang(den: ngay)
        let dlHienTai = duLieu(cho: ngay)
        let dtNVList = dlHienTai.doanhThuNhanVien

        // Nếu ngày hiện tại chưa có doanhThuNhanVien thì lấy bản mới nhất trong tháng
        var dtFallbackTheoMa: [String: DoanhThuNhanVienItem] = [:]
        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoaDen.prefix(7))
        for khoa in cacNgay.keys.sorted() where khoa.hasPrefix(tienTo) && khoa <= khoaDen {
            for item in cacNgay[khoa]?.doanhThuNhanVien ?? [] {
                dtFallbackTheoMa[Self.chuanHoaMaNV(item.maNV)] = item
            }
        }

        let dsNV = caiDat.danhSachNhanVien
        var ketQua: [TongHopNhanVien] = dsNV.map { nv in
            var cacMonGiao: [MonThiDuaNhanVien] = []
            for mh in matHang {
                let khoa = Self.chuanHoaKhoaSoSanh(mh.tenNganhHang)
                let dsMaDuocGiao = caiDat.chiaTargetNganhHang[khoa] ?? dsNV.map(\.maNV)
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
        khoaNganhMacDinh: String? = nil
    ) -> [String: [String: Double]] {
        var ketQua = hienTai
        let matHangThang = danhSachMatHangThang(den: ngay)

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
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
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
