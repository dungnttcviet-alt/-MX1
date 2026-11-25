import UIKit
import Security
import CryptoKit

struct PhienDangNhapDMX: Codable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Int
    var userId: String?
    var tenDangNhap: String
    var laAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
        case userId = "user_id"
        case tenDangNhap = "ten_dang_nhap"
        case laAdmin = "la_admin"
    }
}

struct ThongTinTaiKhoanDMX: Codable, Hashable, Identifiable {
    var id: String
    var tenDangNhap: String
    var email: String
    var laAdmin: Bool
    var ngayTao: String
    var dangNhapCuoi: String

    var laAdminGoc: Bool {
        tenDangNhap.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == DichVuDongBo.taiKhoanAdminGoc
    }
}

private struct LoiMayChu: Codable { var loi: String? }
private struct DangKyThanhCong: Codable { var thanh_cong: Bool? }
private struct DuLieuDamMay: Codable {
    var caiDat: CaiDatDMX?
    var cacNgay: [String: DuLieuNgayDMX]?
}
private struct GoiDongBo: Codable {
    var caiDat: CaiDatDMX?
    var ngay: String?
    var duLieuNgay: DuLieuNgayDMX?
}
private struct YeuCauLienKetLine: Codable {
    var hanhDong: String
    var ma: String
}
private struct PhanHoiLienKetLine: Codable {
    var ok: Bool?
    var tenDangNhap: String?
    var thongBao: String?
}

struct NhomLineDMX: Codable, Hashable {
    var lineGroupId: String
    var tenNhom: String
    var dangHoatDong: Bool
    var batNhacPhanHoi: Bool?
    var soPhutCho: Int?
    enum CodingKeys: String, CodingKey {
        case lineGroupId = "line_group_id"
        case tenNhom = "ten_nhom"
        case dangHoatDong = "dang_hoat_dong"
        case batNhacPhanHoi = "bat_nhac_phan_hoi"
        case soPhutCho = "so_phut_cho"
    }
}

struct LichGuiBaoCaoDMX: Codable, Hashable, Identifiable {
    var id: String
    var lineGroupId: String
    var gio: String
    var cacThu: [Int]
    var cacNoiDung: [String]
    var kieuGui: String?
    var dangHoatDong: Bool
    var sieuThiId: String? = nil
    enum CodingKeys: String, CodingKey {
        case id
        case lineGroupId = "line_group_id"
        case gio
        case cacThu = "cac_thu"
        case cacNoiDung = "cac_noi_dung"
        case kieuGui = "kieu_gui"
        case dangHoatDong = "dang_hoat_dong"
        case sieuThiId = "sieu_thi_id"
    }
}

private struct PhanHoiDanhSachSieuThi: Codable {
    var sieuThi: [SieuThiDMX]
    var sieuThiDangChon: String?
}

private struct YeuCauSieuThi: Codable {
    var hanhDong: String
    var sieuThiId: String?
    var maSieuThi: String?
    var tenSieuThi: String?
}

private struct PhanHoiMaGanNhom: Codable { var ok: Bool?; var ma: String; var soPhut: Int }
private struct PhanHoiDanhSachNhom: Codable { var nhom: [NhomLineDMX]; var lich: [LichGuiBaoCaoDMX] }
private struct PhanHoiThaoTacNhom: Codable { var ok: Bool?; var lich: LichGuiBaoCaoDMX? }
private struct YeuCauLuuAnhBaoCao: Codable {
    var hanhDong: String?
    var loai: String
    var ngay: String
    var nhaCungCap: String
    var duLieuAnhBase64: String?
    var urlBenNgoai: String?
    var duongDanLuuTru: String?
}
private struct PhanHoiLuuAnhBaoCao: Codable {
    var ok: Bool?
    var signedUrl: String?
    var duongDanLuuTru: String?
}

struct PhienTaiAnhBaoCaoDMX {
    var signedURL: URL
    var duongDanLuuTru: String
}

private struct YeuCauNhomLine: Codable {
    var hanhDong: String
    var id: String?
    var lineGroupId: String?
    var gio: String?
    var cacThu: [Int]?
    var cacNoiDung: [String]?
    var kieuGui: String?
    var dangHoatDong: Bool?
    var batNhacPhanHoi: Bool? = nil
    var soPhutCho: Int? = nil
}

// MARK: - Phản hồi từ Supabase Auth & Admin REST API trực tiếp

private struct SupabaseAuthUser: Codable {
    var id: String
    var email: String?
    var userMetadata: [String: String]?
    var createdAt: String?
    var lastSignInAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case userMetadata = "user_metadata"
        case createdAt = "created_at"
        case lastSignInAt = "last_sign_in_at"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? c.decode(String.self, forKey: .id)) ?? ""
        email = try? c.decode(String.self, forKey: .email)
        createdAt = try? c.decode(String.self, forKey: .createdAt)
        lastSignInAt = try? c.decode(String.self, forKey: .lastSignInAt)

        if let dictStr = try? c.decode([String: String].self, forKey: .userMetadata) {
            userMetadata = dictStr
        } else if let rawAny = try? c.decode([String: AnyCodableValue].self, forKey: .userMetadata) {
            var map: [String: String] = [:]
            for (k, v) in rawAny {
                map[k] = v.stringValue
            }
            userMetadata = map
        } else {
            userMetadata = nil
        }
    }
}

private struct AnyCodableValue: Codable {
    let stringValue: String

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) {
            stringValue = s
        } else if let b = try? c.decode(Bool.self) {
            stringValue = b ? "true" : "false"
        } else if let i = try? c.decode(Int.self) {
            stringValue = String(i)
        } else if let d = try? c.decode(Double.self) {
            stringValue = String(d)
        } else {
            stringValue = ""
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        try c.encode(stringValue)
    }
}

private struct DanhSachAdminUsersResponse: Codable {
    var users: [SupabaseAuthUser]?
}

private struct SupabaseAuthResponse: Codable {
    var accessToken: String?
    var refreshToken: String?
    var expiresAt: Int?
    var expiresIn: Int?
    var user: SupabaseAuthUser?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
        case expiresIn = "expires_in"
        case user
    }
}

private struct SupabaseAuthError: Codable {
    var msg: String?
    var message: String?
    var errorDescription: String?
    var code: String?

    enum CodingKeys: String, CodingKey {
        case msg
        case message
        case errorDescription = "error_description"
        case code
    }
}

private struct DongHoSoSupabase: Codable {
    var nguoi_dung_id: String?
    var ten_dang_nhap: String?
    var cai_dat: CaiDatDMX?
    var ngay_cap_nhat: String?
}

private struct DongDuLieuNgaySupabase: Codable {
    var nguoi_dung_id: String?
    var sieu_thi_id: String?
    var ngay: String
    var du_lieu: DuLieuNgayDMX
    var ngay_cap_nhat: String?
}

final class DichVuDongBo {
    static let dungChung = DichVuDongBo()
    static let taiKhoanAdminGoc = "duongnt"

    private let diaChiWeb = URL(string: "https://www.duongnt.io.vn")!
    private let diaChiWorkerR2 = URL(string: "https://dmx-line-bot.thanhduongnmc24.workers.dev")!
    private let diaChiSupabase = URL(string: "https://isxrxeaxytyiydxiwvuc.supabase.co")!
    private let khoaCongKhaiSupabase = "sb_publishable_mafynf1XYupP9W_WeLYSRg_M7cjJXPS"
    private let khoaBiMatSupabase = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzeHJ4ZWF4eXR5aXlkeGl3dnVjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NDQ1OTY1OCwiZXhwIjoyMTAwMDM1NjU4fQ.V7zW8iMiwuKCHGY-1tG1ociK-aeUXwX0BnhqDf1rTo4"
    private let tenBucket = "dmx-du-lieu"
    private let hauToEmailDmx = "@dmx.internal.duongnt.io.vn"

    private let khoaKeychain = "com.thanhduong.tonghopdmx.phien-dang-nhap"
    private let khoaDaDonDepLocal = "com.thanhduong.tonghopdmx.da-don-dep-tai-khoan-cu-v1"
    private let hangDoi = DispatchQueue(label: "com.thanhduong.tonghopdmx.dongbo", qos: .utility)
    private let hangDoiDocSieuThi = DispatchQueue(label: "com.thanhduong.tonghopdmx.sieuthi", qos: .userInitiated)
    private let khoaTrangThai = NSLock()
    private(set) var phien: PhienDangNhapDMX?

    /// Phiên mạng chạy nền độc lập, ưu tiên thấp (.utility) để không bao giờ làm khựng giao diện người dùng
    private lazy var phienMang: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 18
        cfg.timeoutIntervalForResource = 35
        cfg.waitsForConnectivity = false
        let opQueue = OperationQueue()
        opQueue.name = "com.thanhduong.tonghopdmx.network"
        opQueue.qualityOfService = .utility
        opQueue.maxConcurrentOperationCount = 3
        return URLSession(configuration: cfg, delegate: nil, delegateQueue: opQueue)
    }()

    // Bộ đệm gom nhóm & chống dội (debounce) khi đồng bộ dữ liệu lên Supabase để tránh đơ máy
    private var cacNgayChoDay: [String: DuLieuNgayDMX] = [:]
    private var caiDatChoDay: CaiDatDMX?
    private var congViecDayNen: DispatchWorkItem?
    private var dangTaiDuLieu: Bool = false
    private var sieuThiDangTai: String = ""
    private var maLanTaiDuLieu = UUID()
    private var daKhoiTaoAdminTrongPhien: Bool = false
    private var daKiemTraBucket: Bool = false

    var daDangNhap: Bool { phien != nil }
    private(set) var danhSachSieuThi: [SieuThiDMX] = []
    var sieuThiDangChonId: String { BoNhoSieuThiDMX.idDangChon }
    var sieuThiDangChon: SieuThiDMX? { danhSachSieuThi.first { $0.id == sieuThiDangChonId } }
    var tenDangNhap: String { phien?.tenDangNhap ?? "" }
    var laAdmin: Bool {
        let ten = tenDangNhap.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if ten == Self.taiKhoanAdminGoc { return true }
        return phien?.laAdmin == true
    }

    private init() {
        phien = docKeychain()
        if var p = phien, p.tenDangNhap.lowercased() == Self.taiKhoanAdminGoc, p.laAdmin != true {
            p.laAdmin = true
            phien = p
            luuKeychain(p)
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dayNgayKhiUngDungAn),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    @objc private func dayNgayKhiUngDungAn() {
        hangDoi.async { [weak self] in
            guard let self else { return }
            self.congViecDayNen?.cancel()
            self.congViecDayNen = nil
            self.thucThiDayDuLieuGomNhom()
        }
    }

    func taoEmailDmx(_ tenDangNhap: String) -> String {
        let sach = chuanHoaTenDangNhap(tenDangNhap)
        return "\(sach)\(hauToEmailDmx)"
    }

    func chuanHoaTenDangNhap(_ tenDangNhap: String) -> String {
        tenDangNhap
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "[^a-z0-9._-]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

    private func trichTenDangNhap(tu user: SupabaseAuthUser) -> String {
        if let tenMeta = user.userMetadata?["ten_dang_nhap"]?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
           !tenMeta.isEmpty {
            return tenMeta
        }
        if let email = user.email?.lowercased(), email.hasSuffix(hauToEmailDmx) {
            return String(email.dropLast(hauToEmailDmx.count))
        }
        return user.email ?? ""
    }

    private func laUserThuocDMX(_ user: SupabaseAuthUser) -> Bool {
        if user.userMetadata?["ung_dung"] == "dmx" { return true }
        if let email = user.email?.lowercased(), email.hasSuffix(hauToEmailDmx) { return true }
        return false
    }

    private func xacDinhLaAdmin(user: SupabaseAuthUser, tenDangNhap: String) -> Bool {
        if tenDangNhap.lowercased() == Self.taiKhoanAdminGoc { return true }
        let raw = (user.userMetadata?["la_admin"] ?? user.userMetadata?["vai_tro"] ?? "").lowercased()
        return raw == "true" || raw == "1" || raw == "admin"
    }

    // MARK: - 1. Đăng nhập (Tự động set quyền Admin cho duongnt & kiểm tra tài khoản hợp lệ)

    func dangNhap(tenDangNhap: String, matKhau: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        let tenChuan = chuanHoaTenDangNhap(tenDangNhap)
        let email = taoEmailDmx(tenChuan)
        let body: [String: String] = ["email": email, "password": matKhau]

        guiSupabaseAuth(query: "grant_type=password", body: body) { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let authRes):
                guard let token = authRes.accessToken,
                      let refresh = authRes.refreshToken else {
                    hoanTat(.failure(NSError.dmx("Tên đăng nhập hoặc mật khẩu chưa đúng.")))
                    return
                }
                let ungDung = authRes.user?.userMetadata?["ung_dung"] ?? "dmx"
                guard ungDung == "dmx" else {
                    hoanTat(.failure(NSError.dmx("Tài khoản này không thuộc ứng dụng ĐMX.")))
                    return
                }
                let exp = authRes.expiresAt ?? (Int(Date().timeIntervalSince1970) + (authRes.expiresIn ?? 3600))
                let tenHienThi = (authRes.user?.userMetadata?["ten_dang_nhap"] ?? tenChuan).lowercased()
                let quyenAdmin = (tenHienThi == Self.taiKhoanAdminGoc) ||
                    (authRes.user.map { self.xacDinhLaAdmin(user: $0, tenDangNhap: tenHienThi) } ?? false)

                let phienMoi = PhienDangNhapDMX(
                    accessToken: token,
                    refreshToken: refresh,
                    expiresAt: exp,
                    userId: authRes.user?.id,
                    tenDangNhap: tenHienThi,
                    laAdmin: quyenAdmin
                )
                self.phien = phienMoi
                self.luuKeychain(phienMoi)

                if tenHienThi == Self.taiKhoanAdminGoc, let uid = authRes.user?.id, !uid.isEmpty {
                    self.damBaoMetadataAdminChoDuongnt(userId: uid, metadataHienTai: authRes.user?.userMetadata)
                }
                self.thucHienKhoiTaoAdminVaXoaTaiKhoanCuNeuCan()
                hoanTat(.success(()))

            case .failure(let loi):
                if tenChuan == Self.taiKhoanAdminGoc {
                    self.kiemTraVaKhoiTaoDuongntNeuChuaCo(matKhau: matKhau, loiGoc: loi, hoanTat: hoanTat)
                    return
                }
                hoanTat(.failure(loi))
            }
        }
    }

    private func kiemTraVaKhoiTaoDuongntNeuChuaCo(
        matKhau: String,
        loiGoc: Error,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let users):
                let daCoDuongnt = users.contains {
                    self.trichTenDangNhap(tu: $0).lowercased() == Self.taiKhoanAdminGoc
                }
                if daCoDuongnt {
                    DispatchQueue.main.async { hoanTat(.failure(loiGoc)) }
                } else {
                    self.adminTaoTaiKhoanMoi(tenDangNhap: Self.taiKhoanAdminGoc, matKhau: matKhau, laAdmin: true) { kqTao in
                        switch kqTao {
                        case .success:
                            self.dangNhap(tenDangNhap: Self.taiKhoanAdminGoc, matKhau: matKhau, hoanTat: hoanTat)
                        case .failure:
                            DispatchQueue.main.async { hoanTat(.failure(loiGoc)) }
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async { hoanTat(.failure(loiGoc)) }
            }
        }
    }

    // MARK: - 2. Đăng ký tài khoản mới

    func dangKy(tenDangNhap: String, matKhau: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        let tenChuan = chuanHoaTenDangNhap(tenDangNhap)
        let laAdminGoc = (tenChuan == Self.taiKhoanAdminGoc)
        adminTaoTaiKhoanMoi(tenDangNhap: tenChuan, matKhau: matKhau, laAdmin: laAdminGoc) { [weak self] kq in
            switch kq {
            case .success:
                self?.dangNhap(tenDangNhap: tenChuan, matKhau: matKhau, hoanTat: hoanTat)
            case .failure(let loi):
                hoanTat(.failure(loi))
            }
        }
    }

    func dangXuat() {
        khoaTrangThai.lock()
        cacNgayChoDay.removeAll()
        caiDatChoDay = nil
        congViecDayNen?.cancel()
        congViecDayNen = nil
        daKhoiTaoAdminTrongPhien = false
        khoaTrangThai.unlock()

        phien = nil
        xoaKeychain()
        KhoDuLieu.dungChung.datLaiSauDangXuat()
    }

    // MARK: - 3. Quản lý Tài khoản & Phân quyền Admin

    func thucHienKhoiTaoAdminVaXoaTaiKhoanCuNeuCan(batBuoc: Bool = false, hoanTat: (() -> Void)? = nil) {
        khoaTrangThai.lock()
        if daKhoiTaoAdminTrongPhien && !batBuoc {
            khoaTrangThai.unlock()
            hoanTat?()
            return
        }
        daKhoiTaoAdminTrongPhien = true
        khoaTrangThai.unlock()

        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { hoanTat?(); return }
            guard case .success(let tatCaUsers) = kq else {
                hoanTat?()
                return
            }

            let dmxUsers = tatCaUsers.filter { self.laUserThuocDMX($0) }
            let userDuongnt = dmxUsers.first {
                self.trichTenDangNhap(tu: $0).lowercased() == Self.taiKhoanAdminGoc
            }

            if let duongnt = userDuongnt {
                let daLaAdmin = self.xacDinhLaAdmin(user: duongnt, tenDangNhap: Self.taiKhoanAdminGoc)
                if !daLaAdmin || duongnt.userMetadata?["la_admin"] != "true" {
                    self.damBaoMetadataAdminChoDuongnt(userId: duongnt.id, metadataHienTai: duongnt.userMetadata)
                }
            }

            let daDonDepTrenCloud = (userDuongnt?.userMetadata?["da_don_dep_tai_khoan_v1"] == "true")
            let daDonDepLocal = UserDefaults.standard.bool(forKey: self.khoaDaDonDepLocal)

            if !daDonDepTrenCloud && !daDonDepLocal {
                UserDefaults.standard.set(true, forKey: self.khoaDaDonDepLocal)
                self.adminXoaTatCaTaiKhoanKhacGiuDuongnt { [weak self] _ in
                    guard let self else { hoanTat?(); return }
                    if self.daDangNhap && self.tenDangNhap.lowercased() != Self.taiKhoanAdminGoc {
                        DispatchQueue.main.async {
                            self.dangXuat()
                            NotificationCenter.default.post(name: .taiKhoanDMXBiDangXuat, object: nil)
                        }
                    }
                    hoanTat?()
                }
                return
            }

            if self.daDangNhap {
                let tenHienTai = self.tenDangNhap.lowercased()
                let conTonTai = dmxUsers.contains {
                    self.trichTenDangNhap(tu: $0).lowercased() == tenHienTai
                }
                if !conTonTai && tenHienTai != Self.taiKhoanAdminGoc {
                    DispatchQueue.main.async {
                        self.dangXuat()
                        NotificationCenter.default.post(name: .taiKhoanDMXBiDangXuat, object: nil)
                        hoanTat?()
                    }
                    return
                }
                if let uHienTai = dmxUsers.first(where: { self.trichTenDangNhap(tu: $0).lowercased() == tenHienTai }),
                   var p = self.phien {
                    let quyenMoi = self.xacDinhLaAdmin(user: uHienTai, tenDangNhap: tenHienTai)
                    if p.laAdmin != quyenMoi || p.userId != uHienTai.id {
                        p.laAdmin = quyenMoi
                        p.userId = uHienTai.id
                        self.phien = p
                        self.luuKeychain(p)
                    }
                }
            }
            hoanTat?()
        }
    }

    private func damBaoMetadataAdminChoDuongnt(userId: String, metadataHienTai: [String: String]?) {
        var meta = metadataHienTai ?? [:]
        meta["ung_dung"] = "dmx"
        meta["ten_dang_nhap"] = Self.taiKhoanAdminGoc
        meta["la_admin"] = "true"
        meta["vai_tro"] = "admin"
        meta["da_don_dep_tai_khoan_v1"] = "true"
        capNhatUserSupabaseAdmin(userId: userId, matKhauMoi: nil, userMetadata: meta) { _ in }
    }

    func layDanhSachTaiKhoan(hoanTat: @escaping (Result<[ThongTinTaiKhoanDMX], Error>) -> Void) {
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let users):
                var ds: [ThongTinTaiKhoanDMX] = []
                for u in users where self.laUserThuocDMX(u) {
                    let ten = self.trichTenDangNhap(tu: u)
                    guard !ten.isEmpty else { continue }
                    let isAdm = self.xacDinhLaAdmin(user: u, tenDangNhap: ten)
                    if ten.lowercased() == Self.taiKhoanAdminGoc && u.userMetadata?["la_admin"] != "true" {
                        self.damBaoMetadataAdminChoDuongnt(userId: u.id, metadataHienTai: u.userMetadata)
                    }
                    ds.append(ThongTinTaiKhoanDMX(
                        id: u.id,
                        tenDangNhap: ten,
                        email: u.email ?? self.taoEmailDmx(ten),
                        laAdmin: isAdm,
                        ngayTao: self.dinhDangNgayISO(u.createdAt),
                        dangNhapCuoi: self.dinhDangNgayISO(u.lastSignInAt)
                    ))
                }
                ds.sort { a, b in
                    if a.laAdminGoc != b.laAdminGoc { return a.laAdminGoc }
                    if a.laAdmin != b.laAdmin { return a.laAdmin }
                    return a.tenDangNhap.localizedCaseInsensitiveCompare(b.tenDangNhap) == .orderedAscending
                }
                DispatchQueue.main.async { hoanTat(.success(ds)) }
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            }
        }
    }

    func adminTaoTaiKhoanMoi(
        tenDangNhap: String,
        matKhau: String,
        laAdmin: Bool,
        hoanTat: @escaping (Result<ThongTinTaiKhoanDMX, Error>) -> Void
    ) {
        let tenChuan = chuanHoaTenDangNhap(tenDangNhap)
        guard tenChuan.range(of: "^[a-z0-9][a-z0-9._-]{2,39}$", options: .regularExpression) != nil else {
            hoanTat(.failure(NSError.dmx("Tên đăng nhập gồm 3–40 ký tự: chữ thường, số, dấu chấm, gạch ngang hoặc gạch dưới.")))
            return
        }
        guard matKhau.count >= 6 else {
            hoanTat(.failure(NSError.dmx("Mật khẩu cần có ít nhất 6 ký tự.")))
            return
        }

        let email = taoEmailDmx(tenChuan)
        let quyenAdmin = (tenChuan == Self.taiKhoanAdminGoc) ? true : laAdmin

        struct GoiAdminTaoUser: Encodable {
            let email: String
            let password: String
            let email_confirm: Bool
            let user_metadata: [String: String]
        }

        var meta: [String: String] = [
            "ung_dung": "dmx",
            "ten_dang_nhap": tenChuan,
            "la_admin": quyenAdmin ? "true" : "false",
            "vai_tro": quyenAdmin ? "admin" : "user"
        ]
        if tenChuan == Self.taiKhoanAdminGoc {
            meta["da_don_dep_tai_khoan_v1"] = "true"
        }

        let payload = GoiAdminTaoUser(
            email: email,
            password: matKhau,
            email_confirm: true,
            user_metadata: meta
        )

        var req = URLRequest(url: diaChiSupabase.appendingPathComponent("/auth/v1/admin/users"))
        req.httpMethod = "POST"
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONEncoder().encode(payload)

        phienMang.dataTask(with: req) { [weak self] data, response, error in
            guard let self else { return }
            if let error {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            let duLieu = data ?? Data()
            guard (200..<300).contains(status) else {
                let errObj = try? JSONDecoder().decode(SupabaseAuthError.self, from: duLieu)
                let msg = errObj?.msg ?? errObj?.message ?? errObj?.errorDescription ?? ""
                let laTrung = status == 422 || status == 409 || msg.localizedCaseInsensitiveContains("already") || msg.localizedCaseInsensitiveContains("registered")
                let thongBao = laTrung ? "Tên đăng nhập \"\(tenChuan)\" đã tồn tại." : (msg.isEmpty ? "Chưa tạo được tài khoản mới." : msg)
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx(thongBao))) }
                return
            }

            let u = try? JSONDecoder().decode(SupabaseAuthUser.self, from: duLieu)
            let tk = ThongTinTaiKhoanDMX(
                id: u?.id ?? UUID().uuidString.lowercased(),
                tenDangNhap: tenChuan,
                email: email,
                laAdmin: quyenAdmin,
                ngayTao: self.dinhDangNgayISO(u?.createdAt),
                dangNhapCuoi: "--"
            )
            DispatchQueue.main.async { hoanTat(.success(tk)) }
        }.resume()
    }

    func adminDoiMatKhau(
        userId: String,
        tenDangNhap: String,
        matKhauMoi: String,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        guard matKhauMoi.count >= 6 else {
            hoanTat(.failure(NSError.dmx("Mật khẩu mới cần có ít nhất 6 ký tự.")))
            return
        }
        capNhatUserSupabaseAdmin(userId: userId, matKhauMoi: matKhauMoi, userMetadata: nil, hoanTat: hoanTat)
    }

    func doiMatKhauCaNhan(matKhauMoi: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        guard matKhauMoi.count >= 6 else {
            hoanTat(.failure(NSError.dmx("Mật khẩu mới cần có ít nhất 6 ký tự.")))
            return
        }
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async {
                    hoanTat(.failure(NSError.dmx("Không xác định được phiên tài khoản hiện tại.")))
                }
                return
            }
            self.capNhatUserSupabaseAdmin(userId: uid, matKhauMoi: matKhauMoi, userMetadata: nil, hoanTat: hoanTat)
        }
    }

    func adminDatQuyenAdmin(
        taiKhoan: ThongTinTaiKhoanDMX,
        laAdmin: Bool,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        if taiKhoan.laAdminGoc && !laAdmin {
            hoanTat(.failure(NSError.dmx("Tài khoản \"\(Self.taiKhoanAdminGoc)\" là Admin gốc của dự án, không thể gỡ quyền Admin.")))
            return
        }
        let quyenMoi = taiKhoan.laAdminGoc ? true : laAdmin
        var meta: [String: String] = [
            "ung_dung": "dmx",
            "ten_dang_nhap": taiKhoan.tenDangNhap.lowercased(),
            "la_admin": quyenMoi ? "true" : "false",
            "vai_tro": quyenMoi ? "admin" : "user"
        ]
        if taiKhoan.laAdminGoc {
            meta["da_don_dep_tai_khoan_v1"] = "true"
        }
        capNhatUserSupabaseAdmin(userId: taiKhoan.id, matKhauMoi: nil, userMetadata: meta) { [weak self] kq in
            guard let self else { return }
            if case .success = kq,
               var p = self.phien,
               p.tenDangNhap.lowercased() == taiKhoan.tenDangNhap.lowercased() {
                p.laAdmin = quyenMoi
                self.phien = p
                self.luuKeychain(p)
            }
            hoanTat(kq)
        }
    }

    func adminXoaTaiKhoan(
        taiKhoan: ThongTinTaiKhoanDMX,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        if taiKhoan.laAdminGoc {
            hoanTat(.failure(NSError.dmx("Không thể xoá tài khoản Admin gốc \"\(Self.taiKhoanAdminGoc)\".")))
            return
        }
        xoaUserVaDuLieuTrenSupabase(userId: taiKhoan.id) { kq in
            DispatchQueue.main.async { hoanTat(kq) }
        }
    }

    func adminXoaTatCaTaiKhoanKhacGiuDuongnt(hoanTat: @escaping (Result<Int, Error>) -> Void) {
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let tatCaUsers):
                let dmxUsers = tatCaUsers.filter { self.laUserThuocDMX($0) }
                if let duongnt = dmxUsers.first(where: { self.trichTenDangNhap(tu: $0).lowercased() == Self.taiKhoanAdminGoc }) {
                    self.damBaoMetadataAdminChoDuongnt(userId: duongnt.id, metadataHienTai: duongnt.userMetadata)
                }

                let cacUserCanXoa = dmxUsers.filter {
                    self.trichTenDangNhap(tu: $0).lowercased() != Self.taiKhoanAdminGoc
                }

                self.xoaHoSoSQLKhacDuongnt()

                guard !cacUserCanXoa.isEmpty else {
                    DispatchQueue.main.async { hoanTat(.success(0)) }
                    return
                }

                let nhom = DispatchGroup()
                let khoaDem = NSLock()
                var soDaXoa = 0

                for u in cacUserCanXoa {
                    nhom.enter()
                    self.xoaUserVaDuLieuTrenSupabase(userId: u.id) { kqXoa in
                        if case .success = kqXoa {
                            khoaDem.lock()
                            soDaXoa += 1
                            khoaDem.unlock()
                        }
                        nhom.leave()
                    }
                }

                nhom.notify(queue: .main) {
                    if self.daDangNhap && self.tenDangNhap.lowercased() != Self.taiKhoanAdminGoc {
                        self.dangXuat()
                        NotificationCenter.default.post(name: .taiKhoanDMXBiDangXuat, object: nil)
                    }
                    hoanTat(.success(soDaXoa))
                }

            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            }
        }
    }

    private func layDanhSachUsersSupabaseAdmin(hoanTat: @escaping (Result<[SupabaseAuthUser], Error>) -> Void) {
        var comps = URLComponents(url: diaChiSupabase.appendingPathComponent("/auth/v1/admin/users"), resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "1000")
        ]
        var req = URLRequest(url: comps.url!)
        req.httpMethod = "GET"
        req.timeoutInterval = 20
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")

        phienMang.dataTask(with: req) { data, response, error in
            if let error {
                hoanTat(.failure(error))
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status), let data else {
                hoanTat(.failure(NSError.dmx("Không tải được danh sách tài khoản từ máy chủ.")))
                return
            }
            if let wrapped = try? JSONDecoder().decode(DanhSachAdminUsersResponse.self, from: data),
               let users = wrapped.users {
                hoanTat(.success(users))
            } else if let arr = try? JSONDecoder().decode([SupabaseAuthUser].self, from: data) {
                hoanTat(.success(arr))
            } else {
                hoanTat(.success([]))
            }
        }.resume()
    }

    private func capNhatUserSupabaseAdmin(
        userId: String,
        matKhauMoi: String?,
        userMetadata: [String: String]?,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        var bodyDict: [String: Any] = ["email_confirm": true]
        if let mk = matKhauMoi, !mk.isEmpty {
            bodyDict["password"] = mk
        }
        if let meta = userMetadata {
            bodyDict["user_metadata"] = meta
        }

        let url = diaChiSupabase.appendingPathComponent("/auth/v1/admin/users/\(userId)")
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict)

        phienMang.dataTask(with: req) { data, response, error in
            if let error {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status) else {
                let duLieu = data ?? Data()
                let errObj = try? JSONDecoder().decode(SupabaseAuthError.self, from: duLieu)
                let msg = errObj?.msg ?? errObj?.message ?? errObj?.errorDescription ?? "Không cập nhật được tài khoản."
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx(msg))) }
                return
            }
            DispatchQueue.main.async { hoanTat(.success(())) }
        }.resume()
    }

    private func xoaUserVaDuLieuTrenSupabase(userId: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        let nhom = DispatchGroup()

        nhom.enter()
        var compNgay = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_du_lieu_ngay"), resolvingAgainstBaseURL: false)!
        compNgay.queryItems = [URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)")]
        var reqNgay = URLRequest(url: compNgay.url!)
        reqNgay.httpMethod = "DELETE"
        reqNgay.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        reqNgay.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: reqNgay) { _, _, _ in nhom.leave() }.resume()

        nhom.enter()
        var compHoSo = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
        compHoSo.queryItems = [URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)")]
        var reqHoSo = URLRequest(url: compHoSo.url!)
        reqHoSo.httpMethod = "DELETE"
        reqHoSo.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        reqHoSo.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: reqHoSo) { _, _, _ in nhom.leave() }.resume()

        nhom.enter()
        let urlStorage = diaChiSupabase.appendingPathComponent("/storage/v1/object/\(tenBucket)/\(userId).json")
        var reqStorage = URLRequest(url: urlStorage)
        reqStorage.httpMethod = "DELETE"
        reqStorage.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        reqStorage.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: reqStorage) { _, _, _ in nhom.leave() }.resume()

        var xoaAuthThanhCong = false
        nhom.enter()
        let urlAuth = diaChiSupabase.appendingPathComponent("/auth/v1/admin/users/\(userId)")
        var reqAuth = URLRequest(url: urlAuth)
        reqAuth.httpMethod = "DELETE"
        reqAuth.timeoutInterval = 20
        reqAuth.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        reqAuth.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: reqAuth) { _, response, _ in
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            xoaAuthThanhCong = (200..<300).contains(status) || status == 404
            nhom.leave()
        }.resume()

        nhom.notify(queue: hangDoi) {
            if xoaAuthThanhCong {
                hoanTat(.success(()))
            } else {
                hoanTat(.failure(NSError.dmx("Chưa xoá được tài khoản trên máy chủ.")))
            }
        }
    }

    private func xoaHoSoSQLKhacDuongnt() {
        var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
        comp.queryItems = [URLQueryItem(name: "ten_dang_nhap", value: "neq.\(Self.taiKhoanAdminGoc)")]
        var req = URLRequest(url: comp.url!)
        req.httpMethod = "DELETE"
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: req) { _, _, _ in }.resume()
    }

    private func dinhDangNgayISO(_ raw: String?) -> String {
        guard let raw, !raw.isEmpty else { return "--" }
        let prefix = String(raw.prefix(10))
        let parts = prefix.split(separator: "-")
        if parts.count == 3 {
            return "\(parts[2])/\(parts[1])/\(parts[0])"
        }
        return prefix
    }

    // MARK: - 4. Tải dữ liệu đồng bộ (Xử lý gộp & chuẩn hoá hoàn toàn trên luồng nền, tránh đơ máy người dùng)

    func taiDuLieu(hoanTat: ((Result<Void, Error>) -> Void)? = nil) {
        let sieuThiLucBatDau = BoNhoSieuThiDMX.idDangChon
        khoaTrangThai.lock()
        if dangTaiDuLieu && sieuThiDangTai == sieuThiLucBatDau {
            khoaTrangThai.unlock()
            hoanTat?(.success(()))
            return
        }
        let maLanTai = UUID()
        maLanTaiDuLieu = maLanTai
        sieuThiDangTai = sieuThiLucBatDau
        dangTaiDuLieu = true
        khoaTrangThai.unlock()

        let ketThucTai: (Result<Void, Error>) -> Void = { [weak self] kq in
            guard let self else { return }
            self.khoaTrangThai.lock()
            let laLanMoiNhat = self.maLanTaiDuLieu == maLanTai
            if laLanMoiNhat {
                self.dangTaiDuLieu = false
                self.sieuThiDangTai = ""
            }
            self.khoaTrangThai.unlock()
            guard laLanMoiNhat else { return }
            DispatchQueue.main.async {
                hoanTat?(kq)
            }
        }

        thucHienKhoiTaoAdminVaXoaTaiKhoanCuNeuCan { [weak self] in
            guard let self else { return }
            guard self.daDangNhap else { ketThucTai(.success(())); return }
                let nhom = DispatchGroup()
                let khoaGop = NSLock()
                var caiDatGop: CaiDatDMX?
                var cacNgayGop: [String: DuLieuNgayDMX] = [:]

                func gopAnToan(caiDat: CaiDatDMX?, cacNgay: [String: DuLieuNgayDMX]?) {
                    khoaGop.lock()
                    defer { khoaGop.unlock() }
                    if let cd = caiDat { caiDatGop = cd }
                    if let ngay = cacNgay {
                        for (k, v) in ngay {
                            if var cu = cacNgayGop[k] {
                                if cu.danhSachThiDua.isEmpty && !v.danhSachThiDua.isEmpty {
                                    cu.danhSachThiDua = v.danhSachThiDua
                                }
                                if cu.danhSachThiDuaRealtime.isEmpty && !v.danhSachThiDuaRealtime.isEmpty {
                                    cu.danhSachThiDuaRealtime = v.danhSachThiDuaRealtime
                                }
                                if !v.danhSachThiDua.isEmpty && !v.danhSachThiDuaRealtime.isEmpty {
                                    cu = v
                                } else {
                                    var moi = v
                                    if moi.danhSachThiDua.isEmpty { moi.danhSachThiDua = cu.danhSachThiDua }
                                    if moi.danhSachThiDuaRealtime.isEmpty { moi.danhSachThiDuaRealtime = cu.danhSachThiDuaRealtime }
                                    cu = moi
                                }
                                cacNgayGop[k] = cu
                            } else {
                                cacNgayGop[k] = v
                            }
                        }
                    }
                }

                // Đọc đúng siêu thị qua RLS của Supabase, không phụ thuộc Render.
                if let userId = self.phien?.userId, !sieuThiLucBatDau.isEmpty {
                    nhom.enter()
                    self.docBangSQLSupabase(userId: userId, sieuThiId: sieuThiLucBatDau) { caiDat, cacNgay in
                        gopAnToan(caiDat: caiDat, cacNgay: cacNgay)
                        nhom.leave()
                    }
                }

                // Xử lý gộp và chuẩn hoá chuỗi trên luồng nền (hangDoi) thay vì luồng chính
                nhom.notify(queue: self.hangDoi) { [weak self] in
                    guard let self else { return }
                    self.khoaTrangThai.lock()
                    let conHieuLuc = self.maLanTaiDuLieu == maLanTai && BoNhoSieuThiDMX.idDangChon == sieuThiLucBatDau
                    self.khoaTrangThai.unlock()
                    guard conHieuLuc else { ketThucTai(.success(())); return }
                    khoaGop.lock()
                    var cdCuoi = caiDatGop
                    var ngayCuoi = cacNgayGop
                    khoaGop.unlock()

                    // Giữ nguyên các dữ liệu mới vừa quét/điền ở local đang chờ đẩy lên Supabase (không để dữ liệu cũ trên mây đè lên)
                    self.khoaTrangThai.lock()
                    if let cdMoiLocal = self.caiDatChoDay {
                        cdCuoi = cdMoiLocal
                    }
                    for (kLocal, vLocal) in self.cacNgayChoDay {
                        ngayCuoi[kLocal] = vLocal
                    }
                    self.khoaTrangThai.unlock()

                    if cdCuoi != nil || !ngayCuoi.isEmpty {
                        KhoDuLieu.dungChung.nhapDuLieuDamMay(caiDat: cdCuoi, cacNgay: ngayCuoi)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .duLieuDMXDaDongBo, object: nil)
                        }
                    }
                    ketThucTai(.success(()))
                }
        }
    }

    // MARK: - 5. Đẩy dữ liệu ngày & cài đặt lên đám mây (Gom nhóm & chống dội trên luồng nền, không gây đơ máy)

    func dayDuLieuNgay(_ duLieu: DuLieuNgayDMX) {
        guard daDangNhap else { return }
        khoaTrangThai.lock()
        cacNgayChoDay[duLieu.khoaNgay] = duLieu
        khoaTrangThai.unlock()
        lenLichDayDuLieuNen()
    }

    func dayCaiDat(_ caiDat: CaiDatDMX) {
        guard daDangNhap else { return }
        khoaTrangThai.lock()
        caiDatChoDay = caiDat
        khoaTrangThai.unlock()
        lenLichDayDuLieuNen()
    }

    /// Gom các thay đổi rất gần nhau trong 0.25 giây; dữ liệu mới sẵn sàng cho bot gần như tức thời.
    private func lenLichDayDuLieuNen() {
        hangDoi.async { [weak self] in
            guard let self else { return }
            self.congViecDayNen?.cancel()
            let cv = DispatchWorkItem { [weak self] in
                self?.thucThiDayDuLieuGomNhom()
            }
            self.congViecDayNen = cv
            self.hangDoi.asyncAfter(deadline: .now() + 0.25, execute: cv)
        }
    }

    private func thucThiDayDuLieuGomNhom() {
        guard daDangNhap else { return }
        guard let userId = phien?.userId else { return }
        let sieuThiId = BoNhoSieuThiDMX.idDangChon
        guard !sieuThiId.isEmpty else { return }
        khoaTrangThai.lock()
        let dsNgayCanDay = cacNgayChoDay
        let cdCanDay = caiDatChoDay
        cacNgayChoDay.removeAll()
        caiDatChoDay = nil
        khoaTrangThai.unlock()

        guard cdCanDay != nil || !dsNgayCanDay.isEmpty else { return }

        // Chỉ ghi những ngày thay đổi, không tải/ghi lại cả file 62 ngày.
        ghiBangSQLSupabase(userId: userId, sieuThiId: sieuThiId, caiDat: cdCanDay, cacNgay: dsNgayCanDay)

        // SQL là nguồn đồng bộ của ứng dụng iPhone.
    }

    // MARK: - Các hàm làm việc trực tiếp với Supabase Auth, Storage & PostgREST

    private func guiSupabaseAuth(
        query: String,
        body: [String: String],
        hoanTat: @escaping (Result<SupabaseAuthResponse, Error>) -> Void
    ) {
        var comps = URLComponents(url: diaChiSupabase.appendingPathComponent("/auth/v1/token"), resolvingAgainstBaseURL: false)!
        comps.query = query
        var req = URLRequest(url: comps.url!)
        req.httpMethod = "POST"
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        req.httpBody = try? JSONEncoder().encode(body)

        phienMang.dataTask(with: req) { data, response, error in
            if let error {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            let duLieu = data ?? Data()
            guard (200..<300).contains(status) else {
                let errObj = try? JSONDecoder().decode(SupabaseAuthError.self, from: duLieu)
                let rawMsg = errObj?.msg ?? errObj?.message ?? errObj?.errorDescription ?? ""
                let thongBao: String
                if rawMsg.localizedCaseInsensitiveContains("invalid login credentials") || status == 400 {
                    thongBao = "Tên đăng nhập hoặc mật khẩu chưa đúng."
                } else {
                    thongBao = rawMsg.isEmpty ? "Không thể xác thực tài khoản." : rawMsg
                }
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx(thongBao))) }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(SupabaseAuthResponse.self, from: duLieu)
                DispatchQueue.main.async { hoanTat(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
            }
        }.resume()
    }

    private func damBaoUserId(hoanTat: @escaping (String?) -> Void) {
        let bayGio = Int(Date().timeIntervalSince1970)
        if let exp = phien?.expiresAt, exp > 0, exp <= bayGio + 60 {
            lamMoiPhien { [weak self] _ in
                guard let self else { hoanTat(nil); return }
                if let uid = self.phien?.userId, !uid.isEmpty {
                    hoanTat(uid)
                } else {
                    self.truyVanUserIdTuSupabase(hoanTat: hoanTat)
                }
            }
            return
        }
        if let uid = phien?.userId, !uid.isEmpty {
            hoanTat(uid)
            return
        }
        truyVanUserIdTuSupabase(hoanTat: hoanTat)
    }

    private func truyVanUserIdTuSupabase(hoanTat: @escaping (String?) -> Void) {
        guard let token = phien?.accessToken else {
            hoanTat(nil)
            return
        }
        var req = URLRequest(url: diaChiSupabase.appendingPathComponent("/auth/v1/user"))
        req.httpMethod = "GET"
        req.timeoutInterval = 15
        req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        phienMang.dataTask(with: req) { [weak self] data, response, _ in
            guard let self else { hoanTat(nil); return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status == 401 || status == 403 || status == 404 {
                self.lamMoiPhien { ok in
                    if !ok {
                        DispatchQueue.main.async {
                            self.dangXuat()
                            NotificationCenter.default.post(name: .taiKhoanDMXBiDangXuat, object: nil)
                        }
                    }
                    hoanTat(ok ? self.phien?.userId : nil)
                }
                return
            }
            if let data, let u = try? JSONDecoder().decode(SupabaseAuthUser.self, from: data), !u.id.isEmpty {
                if var p = self.phien {
                    p.userId = u.id
                    p.laAdmin = self.xacDinhLaAdmin(user: u, tenDangNhap: p.tenDangNhap)
                    self.phien = p
                    self.luuKeychain(p)
                }
                hoanTat(u.id)
            } else {
                hoanTat(nil)
            }
        }.resume()
    }

    private func docFileStorageSupabase(userId: String, hoanTat: @escaping (DuLieuDamMay?) -> Void) {
        let url = diaChiSupabase.appendingPathComponent("/storage/v1/object/\(tenBucket)/\(userId).json")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.timeoutInterval = 18
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")

        phienMang.dataTask(with: req) { data, response, _ in
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status), let data else {
                hoanTat(nil)
                return
            }
            let cloud = try? JSONDecoder().decode(DuLieuDamMay.self, from: data)
            hoanTat(cloud)
        }.resume()
    }

    private func ghiStorageSupabase(userId: String, caiDat: CaiDatDMX, cacNgay: [String: DuLieuNgayDMX]) {
        let payload = DuLieuDamMay(caiDat: caiDat, cacNgay: cacNgay)
        guard let body = try? JSONEncoder().encode(payload) else { return }

        let guiFileLenBucket: () -> Void = { [weak self] in
            guard let self else { return }
            let url = self.diaChiSupabase.appendingPathComponent("/storage/v1/object/\(self.tenBucket)/\(userId).json")
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.timeoutInterval = 20
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("true", forHTTPHeaderField: "x-upsert")
            req.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
            req.httpBody = body
            self.phienMang.dataTask(with: req) { _, _, _ in }.resume()
        }

        // Chỉ kiểm tra tạo bucket 1 lần duy nhất trong phiên để giảm một nửa số request mạng
        khoaTrangThai.lock()
        let canTaoBucket = !daKiemTraBucket
        daKiemTraBucket = true
        khoaTrangThai.unlock()

        guard canTaoBucket else {
            guiFileLenBucket()
            return
        }

        var reqBucket = URLRequest(url: diaChiSupabase.appendingPathComponent("/storage/v1/bucket"))
        reqBucket.httpMethod = "POST"
        reqBucket.timeoutInterval = 12
        reqBucket.setValue("application/json", forHTTPHeaderField: "Content-Type")
        reqBucket.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        reqBucket.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        reqBucket.httpBody = try? JSONSerialization.data(withJSONObject: ["id": tenBucket, "name": tenBucket, "public": false])
        phienMang.dataTask(with: reqBucket) { _, _, _ in
            guiFileLenBucket()
        }.resume()
    }

    private func docBangSQLSupabase(
        userId: String,
        sieuThiId: String,
        hoanTat: @escaping (CaiDatDMX?, [String: DuLieuNgayDMX]) -> Void
    ) {
        guard let token = phien?.accessToken else {
            hoanTat(nil, [:])
            return
        }
        let nhom = DispatchGroup()
        let khoaKQ = NSLock()
        var cdKetQua: CaiDatDMX?
        var ngayKetQua: [String: DuLieuNgayDMX] = [:]

        nhom.enter()
        var compHoSo = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_sieu_thi"), resolvingAgainstBaseURL: false)!
        compHoSo.queryItems = [
            URLQueryItem(name: "select", value: "cai_dat"),
            URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)"),
            URLQueryItem(name: "id", value: "eq.\(sieuThiId)"),
            URLQueryItem(name: "limit", value: "1")
        ]
        var reqHoSo = URLRequest(url: compHoSo.url!)
        reqHoSo.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        reqHoSo.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: reqHoSo) { data, response, _ in
            if let status = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(status),
               let data, let rows = try? JSONDecoder().decode([DongHoSoSupabase].self, from: data),
               let cd = rows.first?.cai_dat {
                khoaKQ.lock()
                cdKetQua = cd
                khoaKQ.unlock()
            }
            nhom.leave()
        }.resume()

        nhom.enter()
        var compNgay = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_du_lieu_ngay"), resolvingAgainstBaseURL: false)!
        compNgay.queryItems = [
            URLQueryItem(name: "select", value: "ngay,du_lieu"),
            URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)"),
            URLQueryItem(name: "sieu_thi_id", value: "eq.\(sieuThiId)"),
            URLQueryItem(name: "order", value: "ngay.desc"),
            URLQueryItem(name: "limit", value: "62")
        ]
        var reqNgay = URLRequest(url: compNgay.url!)
        reqNgay.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        reqNgay.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        phienMang.dataTask(with: reqNgay) { data, response, _ in
            if let status = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(status),
               let data, let rows = try? JSONDecoder().decode([DongDuLieuNgaySupabase].self, from: data) {
                khoaKQ.lock()
                for r in rows {
                    ngayKetQua[r.ngay] = r.du_lieu
                }
                khoaKQ.unlock()
            }
            nhom.leave()
        }.resume()

        nhom.notify(queue: hangDoi) {
            khoaKQ.lock()
            let cd = cdKetQua
            let ngay = ngayKetQua
            khoaKQ.unlock()
            hoanTat(cd, ngay)
        }
    }

    /// Ghi dữ liệu lên bảng SQL Supabase theo lô (batch upsert) giúp nhanh và nhẹ máy
    private func ghiBangSQLSupabase(userId: String, sieuThiId: String, caiDat: CaiDatDMX?, cacNgay: [String: DuLieuNgayDMX]) {
        guard let token = phien?.accessToken else { return }
        let isoNow = ISO8601DateFormatter().string(from: Date())

        if let cd = caiDat {
            var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_sieu_thi"), resolvingAgainstBaseURL: false)!
            comp.queryItems = [
                URLQueryItem(name: "id", value: "eq.\(sieuThiId)"),
                URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)")
            ]
            var req = URLRequest(url: comp.url!)
            req.httpMethod = "PATCH"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let body = DongHoSoSupabase(nguoi_dung_id: nil, ten_dang_nhap: nil, cai_dat: cd, ngay_cap_nhat: isoNow)
            req.httpBody = try? JSONEncoder().encode(body)
            phienMang.dataTask(with: req) { _, _, _ in }.resume()
        }

        if !cacNgay.isEmpty {
            var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_du_lieu_ngay"), resolvingAgainstBaseURL: false)!
            comp.queryItems = [URLQueryItem(name: "on_conflict", value: "nguoi_dung_id,sieu_thi_id,ngay")]
            var req = URLRequest(url: comp.url!)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
            req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let danhSachDong = cacNgay.map { (khoa, dl) in
                DongDuLieuNgaySupabase(
                    nguoi_dung_id: userId,
                    sieu_thi_id: sieuThiId,
                    ngay: khoa,
                    du_lieu: dl,
                    ngay_cap_nhat: isoNow
                )
            }
            req.httpBody = try? JSONEncoder().encode(danhSachDong)
            phienMang.dataTask(with: req) { _, _, _ in }.resume()
        }
    }

    func lienKetLine(ma: String, hoanTat: @escaping (Result<String, Error>) -> Void) {
        let maSach = ma.filter(\.isNumber)
        guard maSach.count == 6 else {
            hoanTat(.failure(NSError.dmx("Mã liên kết LINE phải gồm đúng 6 chữ số.")))
            return
        }
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async {
                    hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX trước khi liên kết LINE.")))
                }
                return
            }
            let maHash = self.bamSHA256(maSach)
            let isoNow = ISO8601DateFormatter().string(from: Date())
            var compTim = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_ma_lien_ket"), resolvingAgainstBaseURL: false)!
            compTim.queryItems = [
                URLQueryItem(name: "select", value: "line_user_id,het_han"),
                URLQueryItem(name: "ma_hash", value: "eq.\(maHash)"),
                URLQueryItem(name: "het_han", value: "gt.\(isoNow)"),
                URLQueryItem(name: "limit", value: "1")
            ]
            struct MaLienKetRow: Decodable {
                var line_user_id: String?
            }
            self.guiSupabaseAdminREST(url: compTim.url!, method: "GET") { [weak self] (kqTim: Result<[MaLienKetRow], Error>) in
                guard let self else { return }
                switch kqTim {
                case .failure(let loi):
                    DispatchQueue.main.async { hoanTat(.failure(loi)) }
                case .success(let rows):
                    guard let lineUserId = rows.first?.line_user_id, !lineUserId.isEmpty else {
                        DispatchQueue.main.async {
                            hoanTat(.failure(NSError.dmx("Mã liên kết không đúng hoặc đã hết hạn. Hãy gõ /lienket để lấy mã mới.")))
                        }
                        return
                    }
                    var compXoaCu = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_lien_ket"), resolvingAgainstBaseURL: false)!
                    compXoaCu.queryItems = [URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)")]
                    self.guiSupabaseAdminRESTKhongCanDuLieu(url: compXoaCu.url!, method: "DELETE") { [weak self] _ in
                        guard let self else { return }
                        var compUpsert = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_lien_ket"), resolvingAgainstBaseURL: false)!
                        compUpsert.queryItems = [URLQueryItem(name: "on_conflict", value: "line_user_id")]
                        let payload: [String: String] = [
                            "line_user_id": lineUserId,
                            "nguoi_dung_id": uid,
                            "ngay_cap_nhat": isoNow
                        ]
                        self.guiSupabaseAdminRESTKhongCanDuLieu(
                            url: compUpsert.url!,
                            method: "POST",
                            bodyDict: payload,
                            prefer: "resolution=merge-duplicates"
                        ) { [weak self] kqLuu in
                            guard let self else { return }
                            switch kqLuu {
                            case .failure(let loi):
                                DispatchQueue.main.async { hoanTat(.failure(loi)) }
                            case .success:
                                var compXoaMa = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_ma_lien_ket"), resolvingAgainstBaseURL: false)!
                                compXoaMa.queryItems = [URLQueryItem(name: "line_user_id", value: "eq.\(lineUserId)")]
                                self.guiSupabaseAdminRESTKhongCanDuLieu(url: compXoaMa.url!, method: "DELETE") { _ in }
                                let ten = self.tenDangNhap.isEmpty ? "Tài khoản DMX" : self.tenDangNhap
                                DispatchQueue.main.async {
                                    hoanTat(.success("Đã liên kết LINE với tài khoản \(ten)."))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func taoMaGanNhomLine(hoanTat: @escaping (Result<(String, Int), Error>) -> Void) {
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async {
                    hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX.")))
                }
                return
            }
            let soPhut = 10
            let ma = String(format: "%06d", Int.random(in: 0..<1_000_000))
            let maHash = self.bamSHA256(ma)
            let hetHan = ISO8601DateFormatter().string(from: Date().addingTimeInterval(TimeInterval(soPhut * 60)))

            var compXoa = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_ma_gan_nhom"), resolvingAgainstBaseURL: false)!
            compXoa.queryItems = [URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)")]
            self.guiSupabaseAdminRESTKhongCanDuLieu(url: compXoa.url!, method: "DELETE") { [weak self] _ in
                guard let self else { return }
                let urlInsert = self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_ma_gan_nhom")
                let payload: [String: String] = [
                    "ma_hash": maHash,
                    "nguoi_dung_id": uid,
                    "het_han": hetHan
                ]
                self.guiSupabaseAdminRESTKhongCanDuLieu(url: urlInsert, method: "POST", bodyDict: payload) { kq in
                    DispatchQueue.main.async {
                        switch kq {
                        case .success: hoanTat(.success((ma, soPhut)))
                        case .failure(let loi): hoanTat(.failure(loi))
                        }
                    }
                }
            }
        }
    }

    func taiCauHinhGuiBaoCao(hoanTat: @escaping (Result<([NhomLineDMX], [LichGuiBaoCaoDMX]), Error>) -> Void) {
        damBaoUserIdVaSieuThi { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            case .success(let (uid, sieuThiId)):
                let group = DispatchGroup()
                let lock = NSLock()
                var dsNhomRaw: [NhomLineDMX] = []
                var dsLich: [LichGuiBaoCaoDMX] = []
                var mapCauHinh: [String: (Bool, Int)] = [:]
                var loiNhom: Error?

                group.enter()
                var compNhom = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_nhom"), resolvingAgainstBaseURL: false)!
                compNhom.queryItems = [
                    URLQueryItem(name: "select", value: "line_group_id,ten_nhom,dang_hoat_dong"),
                    URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)"),
                    URLQueryItem(name: "order", value: "ngay_tao.asc")
                ]
                self.guiSupabaseAdminREST(url: compNhom.url!, method: "GET") { (kq: Result<[NhomLineDMX], Error>) in
                    lock.lock()
                    switch kq {
                    case .success(let rows): dsNhomRaw = rows
                    case .failure(let err): loiNhom = err
                    }
                    lock.unlock()
                    group.leave()
                }

                group.enter()
                var compLich = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_lich_gui"), resolvingAgainstBaseURL: false)!
                compLich.queryItems = [
                    URLQueryItem(name: "select", value: "id,line_group_id,sieu_thi_id,gio,cac_thu,cac_noi_dung,kieu_gui,dang_hoat_dong"),
                    URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)"),
                    URLQueryItem(name: "sieu_thi_id", value: "eq.\(sieuThiId)"),
                    URLQueryItem(name: "order", value: "gio.asc")
                ]
                self.guiSupabaseAdminREST(url: compLich.url!, method: "GET") { (kq: Result<[LichGuiBaoCaoDMX], Error>) in
                    lock.lock()
                    if case .success(let rows) = kq { dsLich = rows }
                    lock.unlock()
                    group.leave()
                }

                struct CauHinhNhacRow: Decodable {
                    var line_group_id: String
                    var bat_nhac_phan_hoi: Bool?
                    var so_phut_cho: Int?
                }
                group.enter()
                var compNhac = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_cau_hinh_nhac"), resolvingAgainstBaseURL: false)!
                compNhac.queryItems = [URLQueryItem(name: "select", value: "line_group_id,bat_nhac_phan_hoi,so_phut_cho")]
                self.guiSupabaseAdminREST(url: compNhac.url!, method: "GET") { (kq: Result<[CauHinhNhacRow], Error>) in
                    lock.lock()
                    if case .success(let rows) = kq {
                        for r in rows {
                            mapCauHinh[r.line_group_id] = (r.bat_nhac_phan_hoi ?? false, r.so_phut_cho ?? 30)
                        }
                    }
                    lock.unlock()
                    group.leave()
                }

                group.notify(queue: .main) {
                    if let loiNhom {
                        hoanTat(.failure(loiNhom))
                        return
                    }
                    let nhomDayDu = dsNhomRaw.map { item -> NhomLineDMX in
                        var m = item
                        if let ch = mapCauHinh[item.lineGroupId] {
                            m.batNhacPhanHoi = ch.0
                            m.soPhutCho = ch.1
                        } else {
                            m.batNhacPhanHoi = false
                            m.soPhutCho = 30
                        }
                        return m
                    }
                    hoanTat(.success((nhomDayDu, dsLich)))
                }
            }
        }
    }

    func taiDanhSachSieuThi(hoanTat: @escaping (Result<[SieuThiDMX], Error>) -> Void) {
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX."))) }
                return
            }
            self.truyVanDanhSachSieuThiSupabase(userId: uid) { [weak self] ketQua in
                guard let self else { return }
                switch ketQua {
                case .success(let kq):
                    self.danhSachSieuThi = kq.sieuThi
                    let id = kq.sieuThiDangChon ?? kq.sieuThi.first?.id ?? ""
                    guard !id.isEmpty else {
                        DispatchQueue.main.async { hoanTat(.success(kq.sieuThi)) }
                        return
                    }
                    let idCu = BoNhoSieuThiDMX.idDangChon
                    self.chuyenDuLieuSieuThiTrenMay(tu: idCu, sang: id, danhSach: kq.sieuThi) {
                        DispatchQueue.main.async { hoanTat(.success(kq.sieuThi)) }
                    }
                case .failure(let loi):
                    DispatchQueue.main.async { hoanTat(.failure(loi)) }
                }
            }
        }
    }

    private func truyVanDanhSachSieuThiSupabase(
        userId: String,
        hoanTat: @escaping (Result<PhanHoiDanhSachSieuThi, Error>) -> Void
    ) {
        let group = DispatchGroup()
        let lock = NSLock()
        var dsStores: [SieuThiDMX] = []
        var idDangChon: String?
        var loiTruyVan: Error?

        group.enter()
        var compStores = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_sieu_thi"), resolvingAgainstBaseURL: false)!
        compStores.queryItems = [
            URLQueryItem(name: "select", value: "id,ma_sieu_thi,ten_sieu_thi"),
            URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)"),
            URLQueryItem(name: "order", value: "ngay_tao.asc")
        ]
        guiSupabaseAdminREST(url: compStores.url!, method: "GET") { (kq: Result<[SieuThiDMX], Error>) in
            lock.lock()
            switch kq {
            case .success(let rows): dsStores = rows
            case .failure(let err): loiTruyVan = err
            }
            lock.unlock()
            group.leave()
        }

        struct HoSoSieuThiRow: Decodable {
            var sieu_thi_dang_chon: String?
        }
        group.enter()
        var compProfile = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
        compProfile.queryItems = [
            URLQueryItem(name: "select", value: "sieu_thi_dang_chon"),
            URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)"),
            URLQueryItem(name: "limit", value: "1")
        ]
        guiSupabaseAdminREST(url: compProfile.url!, method: "GET") { (kq: Result<[HoSoSieuThiRow], Error>) in
            lock.lock()
            if case .success(let rows) = kq {
                idDangChon = rows.first?.sieu_thi_dang_chon
            }
            lock.unlock()
            group.leave()
        }

        group.notify(queue: hangDoi) { [weak self] in
            guard let self else { return }
            if let loiTruyVan {
                hoanTat(.failure(loiTruyVan))
                return
            }
            if dsStores.isEmpty {
                // Tự động khởi tạo siêu thị mặc định nếu tài khoản mới chưa có
                let urlInsert = self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_sieu_thi?select=id,ma_sieu_thi,ten_sieu_thi")
                let payload: [String: String] = [
                    "nguoi_dung_id": userId,
                    "ma_sieu_thi": "MAC_DINH",
                    "ten_sieu_thi": "Siêu thị mặc định"
                ]
                self.guiSupabaseAdminREST(url: urlInsert, method: "POST", bodyDict: payload, prefer: "return=representation") { (kqTao: Result<[SieuThiDMX], Error>) in
                    switch kqTao {
                    case .success(let moi):
                        let chon = moi.first?.id
                        if let chon {
                            self.capNhatSieuThiDangChonHoSo(userId: userId, sieuThiId: chon) { _ in
                                hoanTat(.success(PhanHoiDanhSachSieuThi(sieuThi: moi, sieuThiDangChon: chon)))
                            }
                        } else {
                            hoanTat(.success(PhanHoiDanhSachSieuThi(sieuThi: moi, sieuThiDangChon: nil)))
                        }
                    case .failure(let err):
                        hoanTat(.failure(err))
                    }
                }
                return
            }
            let chonHopLe = (idDangChon != nil && dsStores.contains(where: { $0.id == idDangChon }))
                ? idDangChon
                : dsStores.first?.id
            hoanTat(.success(PhanHoiDanhSachSieuThi(sieuThi: dsStores, sieuThiDangChon: chonHopLe)))
        }
    }

    private func capNhatSieuThiDangChonHoSo(userId: String, sieuThiId: String?, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
        comp.queryItems = [URLQueryItem(name: "on_conflict", value: "nguoi_dung_id")]
        var payload: [String: Any] = [
            "nguoi_dung_id": userId,
            "ten_dang_nhap": tenDangNhap.isEmpty ? "user-\(userId.prefix(6))" : tenDangNhap,
            "ngay_cap_nhat": ISO8601DateFormatter().string(from: Date())
        ]
        payload["sieu_thi_dang_chon"] = sieuThiId ?? NSNull()
        guiSupabaseAdminRESTKhongCanDuLieu(
            url: comp.url!,
            method: "POST",
            bodyDict: payload,
            prefer: "resolution=merge-duplicates",
            hoanTat: hoanTat
        )
    }

    private func damBaoUserIdVaSieuThi(hoanTat: @escaping (Result<(String, String), Error>) -> Void) {
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX.")))
                return
            }
            let hienTai = BoNhoSieuThiDMX.idDangChon
            if !hienTai.isEmpty {
                hoanTat(.success((uid, hienTai)))
                return
            }
            self.truyVanDanhSachSieuThiSupabase(userId: uid) { kq in
                switch kq {
                case .success(let ds):
                    self.danhSachSieuThi = ds.sieuThi
                    if let chon = ds.sieuThiDangChon ?? ds.sieuThi.first?.id, !chon.isEmpty {
                        BoNhoSieuThiDMX.idDangChon = chon
                        hoanTat(.success((uid, chon)))
                    } else {
                        hoanTat(.failure(NSError.dmx("Tài khoản chưa chọn siêu thị.")))
                    }
                case .failure(let loi):
                    hoanTat(.failure(loi))
                }
            }
        }
    }

    private func chuyenDuLieuSieuThiTrenMay(
        tu idCu: String,
        sang idMoi: String,
        danhSach: [SieuThiDMX],
        hoanTat: (() -> Void)? = nil
    ) {
        guard !idMoi.isEmpty else { hoanTat?(); return }
        let laMacDinh = danhSach.first { $0.id == idMoi }?.maSieuThi.uppercased() == "MAC_DINH"
        hangDoiDocSieuThi.async { [weak self] in
            KhoDuLieu.dungChung.chuyenSieuThiNhanh(tu: idCu, sang: idMoi, laMacDinh: laMacDinh)
            DispatchQueue.main.async {
                BoNhoSieuThiDMX.idDangChon = idMoi
                NotificationCenter.default.post(name: .sieuThiDMXDaThayDoi, object: idMoi)
                hoanTat?()
                self?.taiDuLieu()
            }
            // Sau khi đã hiện dữ liệu, tiếp tục đọc trước các file còn lại.
            for item in danhSach where item.id != idMoi {
                KhoDuLieu.dungChung.napTruocSieuThi(
                    id: item.id,
                    laMacDinh: item.maSieuThi.uppercased() == "MAC_DINH"
                )
            }
        }
    }

    func themSieuThi(ma: String, ten: String, hoanTat: @escaping (Result<[SieuThiDMX], Error>) -> Void) {
        let idCu = BoNhoSieuThiDMX.idDangChon
        thaoTacSieuThi(.init(hanhDong: "them", sieuThiId: nil, maSieuThi: ma, tenSieuThi: ten)) { [weak self] ketQua in
            if case .success(let ds) = ketQua, idCu != BoNhoSieuThiDMX.idDangChon {
                let idMoi = BoNhoSieuThiDMX.idDangChon
                self?.chuyenDuLieuSieuThiTrenMay(tu: idCu, sang: idMoi, danhSach: ds)
            }
            hoanTat(ketQua)
        }
    }

    func chonSieuThi(id: String, hoanTat: @escaping (Result<[SieuThiDMX], Error>) -> Void) {
        guard id != BoNhoSieuThiDMX.idDangChon else {
            hoanTat(.success(danhSachSieuThi))
            return
        }
        congViecDayNen?.cancel()
        thucThiDayDuLieuGomNhom()
        let idCu = BoNhoSieuThiDMX.idDangChon
        let dsHienTai = danhSachSieuThi
        // Mở dữ liệu trong máy ngay; việc ghi lựa chọn lên máy chủ chạy song song.
        chuyenDuLieuSieuThiTrenMay(tu: idCu, sang: id, danhSach: dsHienTai) {
            hoanTat(.success(dsHienTai))
        }
        thaoTacSieuThi(.init(hanhDong: "chon", sieuThiId: id, maSieuThi: nil, tenSieuThi: nil)) { [weak self] ketQua in
            if case .success(let ds) = ketQua { self?.danhSachSieuThi = ds }
        }
    }

    func xoaSieuThi(id: String, hoanTat: @escaping (Result<[SieuThiDMX], Error>) -> Void) {
        let idCu = BoNhoSieuThiDMX.idDangChon
        thaoTacSieuThi(.init(hanhDong: "xoa", sieuThiId: id, maSieuThi: nil, tenSieuThi: nil)) { [weak self] ketQua in
            if case .success(let ds) = ketQua, idCu != BoNhoSieuThiDMX.idDangChon {
                let idMoi = BoNhoSieuThiDMX.idDangChon
                self?.chuyenDuLieuSieuThiTrenMay(tu: idCu, sang: idMoi, danhSach: ds)
            }
            hoanTat(ketQua)
        }
    }

    private func thaoTacSieuThi(_ body: YeuCauSieuThi, hoanTat: @escaping (Result<[SieuThiDMX], Error>) -> Void) {
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX."))) }
                return
            }
            let hanhDong = body.hanhDong.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

            let taiLaiSauThaoTac: () -> Void = { [weak self] in
                guard let self else { return }
                self.truyVanDanhSachSieuThiSupabase(userId: uid) { kq in
                    DispatchQueue.main.async {
                        switch kq {
                        case .success(let ds):
                            self.danhSachSieuThi = ds.sieuThi
                            if let id = ds.sieuThiDangChon { BoNhoSieuThiDMX.idDangChon = id }
                            hoanTat(.success(ds.sieuThi))
                        case .failure(let loi):
                            hoanTat(.failure(loi))
                        }
                    }
                }
            }

            if hanhDong == "them" {
                let ma = (body.maSieuThi ?? "").trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                let ten = (body.tenSieuThi ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                guard ma.range(of: "^[A-Z0-9._-]{1,30}$", options: .regularExpression) != nil,
                      !ten.isEmpty, ten.count <= 120 else {
                    DispatchQueue.main.async {
                        hoanTat(.failure(NSError.dmx("Mã siêu thị chỉ gồm chữ, số, dấu chấm, gạch ngang; tên tối đa 120 ký tự.")))
                    }
                    return
                }
                let urlInsert = self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_sieu_thi?select=id,ma_sieu_thi,ten_sieu_thi")
                let payload: [String: String] = [
                    "nguoi_dung_id": uid,
                    "ma_sieu_thi": ma,
                    "ten_sieu_thi": ten
                ]
                self.guiSupabaseAdminREST(url: urlInsert, method: "POST", bodyDict: payload, prefer: "return=representation") { [weak self] (kq: Result<[SieuThiDMX], Error>) in
                    guard let self else { return }
                    switch kq {
                    case .failure(let loi):
                        DispatchQueue.main.async { hoanTat(.failure(loi)) }
                    case .success(let moi):
                        guard let idMoi = moi.first?.id, !idMoi.isEmpty else {
                            taiLaiSauThaoTac()
                            return
                        }
                        self.capNhatSieuThiDangChonHoSo(userId: uid, sieuThiId: idMoi) { _ in
                            taiLaiSauThaoTac()
                        }
                    }
                }
            } else if hanhDong == "chon" {
                let id = (body.sieuThiId ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                guard !id.isEmpty else {
                    DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Siêu thị không hợp lệ."))) }
                    return
                }
                self.capNhatSieuThiDangChonHoSo(userId: uid, sieuThiId: id) { _ in
                    taiLaiSauThaoTac()
                }
            } else if hanhDong == "xoa" {
                let id = (body.sieuThiId ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                guard self.danhSachSieuThi.count > 1 else {
                    DispatchQueue.main.async {
                        hoanTat(.failure(NSError.dmx("Tài khoản phải còn ít nhất một siêu thị.")))
                    }
                    return
                }
                var compDel = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_sieu_thi"), resolvingAgainstBaseURL: false)!
                compDel.queryItems = [
                    URLQueryItem(name: "id", value: "eq.\(id)"),
                    URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)")
                ]
                self.guiSupabaseAdminRESTKhongCanDuLieu(url: compDel.url!, method: "DELETE") { [weak self] kqXoa in
                    guard let self else { return }
                    switch kqXoa {
                    case .failure(let loi):
                        DispatchQueue.main.async { hoanTat(.failure(loi)) }
                    case .success:
                        let conLai = self.danhSachSieuThi.first(where: { $0.id != id })?.id
                        self.capNhatSieuThiDangChonHoSo(userId: uid, sieuThiId: conLai) { _ in
                            taiLaiSauThaoTac()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Hành động không hợp lệ."))) }
            }
        }
    }

    func luuLichGuiBaoCao(id: String? = nil, groupId: String, gio: String, cacThu: [Int], cacNoiDung: [String], kieuGui: String, dangHoatDong: Bool = true, hoanTat: @escaping (Result<LichGuiBaoCaoDMX, Error>) -> Void) {
        let gioSach = gio.trimmingCharacters(in: .whitespacesAndNewlines)
        let thuHopLe = cacThu.filter { (1...7).contains($0) }
        let noiDungHopLe = cacNoiDung.filter { !$0.isEmpty }
        guard gioSach.range(of: "^([01]\\d|2[0-3]):[0-5]\\d$", options: .regularExpression) != nil,
              !thuHopLe.isEmpty, !noiDungHopLe.isEmpty, !groupId.isEmpty else {
            hoanTat(.failure(NSError.dmx("Hãy chọn nhóm, giờ, ngày gửi và ít nhất một nội dung.")))
            return
        }
        damBaoUserIdVaSieuThi { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            case .success(let (uid, sieuThiId)):
                let isoNow = ISO8601DateFormatter().string(from: Date())
                var payload: [String: Any] = [
                    "line_group_id": groupId,
                    "nguoi_dung_id": uid,
                    "sieu_thi_id": sieuThiId,
                    "gio": "\(gioSach):00",
                    "cac_thu": thuHopLe,
                    "cac_noi_dung": noiDungHopLe,
                    "kieu_gui": kieuGui == "text" ? "text" : "anh",
                    "dang_hoat_dong": dangHoatDong,
                    "lan_gui_cuoi": NSNull(),
                    "ngay_cap_nhat": isoNow
                ]
                var comp = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_lich_gui"), resolvingAgainstBaseURL: false)!
                let method: String
                if let id, !id.isEmpty {
                    method = "PATCH"
                    comp.queryItems = [
                        URLQueryItem(name: "select", value: "id,line_group_id,sieu_thi_id,gio,cac_thu,cac_noi_dung,kieu_gui,dang_hoat_dong"),
                        URLQueryItem(name: "id", value: "eq.\(id)"),
                        URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)")
                    ]
                } else {
                    method = "POST"
                    comp.queryItems = [
                        URLQueryItem(name: "select", value: "id,line_group_id,sieu_thi_id,gio,cac_thu,cac_noi_dung,kieu_gui,dang_hoat_dong")
                    ]
                }
                self.guiSupabaseAdminREST(
                    url: comp.url!,
                    method: method,
                    bodyDict: payload,
                    prefer: "return=representation"
                ) { (kq: Result<[LichGuiBaoCaoDMX], Error>) in
                    DispatchQueue.main.async {
                        switch kq {
                        case .success(let rows):
                            if let lich = rows.first {
                                hoanTat(.success(lich))
                            } else {
                                hoanTat(.failure(NSError.dmx("Máy chủ đã lưu nhưng chưa trả lại lịch.")))
                            }
                        case .failure(let loi):
                            hoanTat(.failure(loi))
                        }
                    }
                }
            }
        }
    }

    func xoaLichGuiBaoCao(id: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX."))) }
                return
            }
            var compTat = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_lich_gui"), resolvingAgainstBaseURL: false)!
            compTat.queryItems = [
                URLQueryItem(name: "id", value: "eq.\(id)"),
                URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)")
            ]
            let bodyTat: [String: Any] = [
                "dang_hoat_dong": false,
                "ngay_cap_nhat": ISO8601DateFormatter().string(from: Date())
            ]
            self.guiSupabaseAdminRESTKhongCanDuLieu(url: compTat.url!, method: "PATCH", bodyDict: bodyTat) { [weak self] _ in
                guard let self else { return }
                self.guiSupabaseAdminRESTKhongCanDuLieu(url: compTat.url!, method: "DELETE") { kq in
                    DispatchQueue.main.async { hoanTat(kq) }
                }
            }
        }
    }

    func luuNhacPhanHoiNhom(
        groupId: String,
        bat: Bool,
        soPhutCho: Int,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Hãy đăng nhập tài khoản DMX."))) }
                return
            }
            var comp = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_cau_hinh_nhac"), resolvingAgainstBaseURL: false)!
            comp.queryItems = [URLQueryItem(name: "on_conflict", value: "line_group_id")]
            let payload: [String: Any] = [
                "line_group_id": groupId,
                "bat_nhac_phan_hoi": bat,
                "so_phut_cho": max(1, min(1440, soPhutCho)),
                "ngay_cap_nhat": ISO8601DateFormatter().string(from: Date())
            ]
            self.guiSupabaseAdminRESTKhongCanDuLieu(
                url: comp.url!,
                method: "POST",
                bodyDict: payload,
                prefer: "resolution=merge-duplicates"
            ) { kq in
                DispatchQueue.main.async { hoanTat(kq) }
            }
        }
    }

    func luuAnhBaoCaoBot(
        loai: String,
        ngay: String,
        duLieuJPEG: Data? = nil,
        urlDrive: String? = nil,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        let laDrive = !(urlDrive?.isEmpty ?? true)
        if laDrive, let urlBenNgoai = urlDrive {
            ghiBanGhiAnhBaoCaoSupabase(
                loai: loai,
                ngay: ngay,
                nhaCungCap: "google_drive",
                duongDanLuuTru: nil,
                urlBenNgoai: urlBenNgoai,
                hoanTat: hoanTat
            )
            return
        }
        guard let jpeg = duLieuJPEG, !jpeg.isEmpty else {
            hoanTat(.failure(NSError.dmx("Thiếu dữ liệu ảnh.")))
            return
        }
        taiAnhTrucTiepLenStorageSupabase(jpeg: jpeg, loai: loai, ngay: ngay, hoanTat: hoanTat)
    }

    /// Tải ảnh JPEG trực tiếp lên Cloudflare R2 thông qua Worker `dmx-line-bot` (miễn phí 10GB + 0đ băng thông tải ra).
    /// Tự động làm mới JWT nếu hết hạn (HTTP 401).
    func taiAnhLenCloudflareR2(
        jpeg: Data,
        loai: String,
        ngay: String,
        thuLai: Bool = true,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        damBaoUserIdVaSieuThi { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            case .success(let (_, sieuThiId)):
                guard let token = self.phien?.accessToken, !token.isEmpty else {
                    DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Chưa có phiên đăng nhập DMX."))) }
                    return
                }
                var comp = URLComponents(url: self.diaChiWorkerR2.appendingPathComponent("/r2/upload"), resolvingAgainstBaseURL: false)!
                comp.queryItems = [
                    URLQueryItem(name: "loai", value: loai),
                    URLQueryItem(name: "ngay", value: ngay),
                    URLQueryItem(name: "sid", value: sieuThiId)
                ]
                guard let url = comp.url else {
                    DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("URL Cloudflare R2 không hợp lệ."))) }
                    return
                }
                var req = URLRequest(url: url)
                req.httpMethod = "POST"
                req.httpBody = jpeg
                req.timeoutInterval = 60
                req.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                req.setValue("application/json", forHTTPHeaderField: "Accept")
                req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                req.setValue(sieuThiId, forHTTPHeaderField: "X-DMX-Store-ID")
                req.setValue(String(jpeg.count), forHTTPHeaderField: "Content-Length")

                struct PhanHoiR2: Decodable {
                    var ok: Bool?
                    var url: String?
                    var loi: String?
                }

                self.phienMang.dataTask(with: req) { [weak self] data, response, error in
                    guard let self else { return }
                    if let error {
                        DispatchQueue.main.async { hoanTat(.failure(error)) }
                        return
                    }
                    let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                    if status == 401, thuLai {
                        self.lamMoiPhien { thanhCong in
                            if thanhCong {
                                self.taiAnhLenCloudflareR2(jpeg: jpeg, loai: loai, ngay: ngay, thuLai: false, hoanTat: hoanTat)
                            } else {
                                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Phiên đăng nhập hết hạn khi tải ảnh lên R2."))) }
                            }
                        }
                        return
                    }
                    let duLieu = data ?? Data()
                    let phanHoi = try? JSONDecoder().decode(PhanHoiR2.self, from: duLieu)
                    guard (200..<300).contains(status), phanHoi?.ok == true, let urlAnh = phanHoi?.url else {
                        let msg = phanHoi?.loi ?? "Cloudflare R2 từ chối tải ảnh (HTTP \(status))."
                        DispatchQueue.main.async { hoanTat(.failure(NSError.dmx(msg))) }
                        return
                    }
                    DispatchQueue.main.async { hoanTat(.success(urlAnh)) }
                }.resume()
            }
        }
    }

    func taiAnhTrucTiepLenStorageSupabase(
        jpeg: Data,
        loai: String,
        ngay: String,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        damBaoUserIdVaSieuThi { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            case .success(let (uid, sieuThiId)):
                let phienBan = "\(Int(Date().timeIntervalSince1970 * 1000))-\(UUID().uuidString.prefix(8).lowercased())"
                let duongDanMoi = "bot-anh/\(uid)/\(sieuThiId)/\(loai)-\(phienBan).jpg"
                let urlUpload = self.diaChiSupabase.appendingPathComponent("/storage/v1/object/\(self.tenBucket)/\(duongDanMoi)")
                var req = URLRequest(url: urlUpload)
                req.httpMethod = "POST"
                req.httpBody = jpeg
                req.timeoutInterval = 60
                req.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                req.setValue("31536000", forHTTPHeaderField: "cache-control")
                req.setValue("true", forHTTPHeaderField: "x-upsert")
                req.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
                req.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")

                self.phienMang.dataTask(with: req) { [weak self] _, response, error in
                    guard let self else { return }
                    if let error {
                        DispatchQueue.main.async { hoanTat(.failure(error)) }
                        return
                    }
                    let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                    guard (200..<300).contains(status) else {
                        DispatchQueue.main.async {
                            hoanTat(.failure(NSError.dmx("Supabase Storage từ chối tải ảnh (HTTP \(status)).")))
                        }
                        return
                    }
                    self.ghiBanGhiAnhBaoCaoSupabase(
                        userId: uid,
                        sieuThiId: sieuThiId,
                        loai: loai,
                        ngay: ngay,
                        nhaCungCap: "supabase",
                        duongDanLuuTru: duongDanMoi,
                        urlBenNgoai: nil,
                        hoanTat: hoanTat
                    )
                }.resume()
            }
        }
    }

    func taoPhienTaiAnhBaoCaoTrucTiep(
        loai: String,
        ngay: String,
        hoanTat: @escaping (Result<PhienTaiAnhBaoCaoDMX, Error>) -> Void
    ) {
        damBaoUserIdVaSieuThi { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            case .success(let (uid, sieuThiId)):
                let phienBan = "\(Int(Date().timeIntervalSince1970 * 1000))-\(UUID().uuidString.prefix(8).lowercased())"
                let duongDanMoi = "bot-anh/\(uid)/\(sieuThiId)/\(loai)-\(phienBan).jpg"
                let urlSign = self.diaChiSupabase.appendingPathComponent("/storage/v1/object/upload/sign/\(self.tenBucket)/\(duongDanMoi)")
                var req = URLRequest(url: urlSign)
                req.httpMethod = "POST"
                req.timeoutInterval = 20
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                req.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
                req.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
                req.httpBody = Data("{}".utf8)

                struct SignedUploadRes: Decodable {
                    var url: String?
                    var signedURL: String?
                    var signedUrl: String?
                }
                self.phienMang.dataTask(with: req) { [weak self] data, response, error in
                    guard let self else { return }
                    if let error {
                        DispatchQueue.main.async { hoanTat(.failure(error)) }
                        return
                    }
                    let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                    if (200..<300).contains(status),
                       let data,
                       let res = try? JSONDecoder().decode(SignedUploadRes.self, from: data),
                       let rawPath = res.url ?? res.signedURL ?? res.signedUrl {
                        let fullStr: String
                        if rawPath.hasPrefix("http") {
                            fullStr = rawPath
                        } else if rawPath.hasPrefix("/storage/v1") {
                            fullStr = self.diaChiSupabase.absoluteString + rawPath
                        } else if rawPath.hasPrefix("/") {
                            fullStr = self.diaChiSupabase.absoluteString + "/storage/v1" + rawPath
                        } else {
                            fullStr = self.diaChiSupabase.absoluteString + "/storage/v1/" + rawPath
                        }
                        if let signedURL = URL(string: fullStr) {
                            DispatchQueue.main.async {
                                hoanTat(.success(PhienTaiAnhBaoCaoDMX(signedURL: signedURL, duongDanLuuTru: duongDanMoi)))
                            }
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        hoanTat(.failure(NSError.dmx("Không tạo được phiên tải ảnh lên Supabase (HTTP \(status)).")))
                    }
                }.resume()
            }
        }
    }

    func xacNhanTaiAnhBaoCaoTrucTiep(
        loai: String,
        ngay: String,
        duongDanLuuTru: String,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        ghiBanGhiAnhBaoCaoSupabase(
            loai: loai,
            ngay: ngay,
            nhaCungCap: "supabase",
            duongDanLuuTru: duongDanLuuTru,
            urlBenNgoai: nil,
            hoanTat: hoanTat
        )
    }

    private func ghiBanGhiAnhBaoCaoSupabase(
        userId: String? = nil,
        sieuThiId: String? = nil,
        loai: String,
        ngay: String,
        nhaCungCap: String,
        duongDanLuuTru: String?,
        urlBenNgoai: String?,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        let thucThi: (String, String) -> Void = { [weak self] uid, sid in
            guard let self else { return }
            let loaiChuan = loai.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let isoNow = ISO8601DateFormatter().string(from: Date())

            struct BanGhiAnhCu: Decodable {
                var duong_dan_luu_tru: String?
            }
            var compCu = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_anh_bao_cao"), resolvingAgainstBaseURL: false)!
            compCu.queryItems = [
                URLQueryItem(name: "select", value: "duong_dan_luu_tru"),
                URLQueryItem(name: "nguoi_dung_id", value: "eq.\(uid)"),
                URLQueryItem(name: "sieu_thi_id", value: "eq.\(sid)"),
                URLQueryItem(name: "loai", value: "eq.\(loaiChuan)"),
                URLQueryItem(name: "limit", value: "1")
            ]
            self.guiSupabaseAdminREST(url: compCu.url!, method: "GET") { [weak self] (kqCu: Result<[BanGhiAnhCu], Error>) in
                guard let self else { return }
                let duongDanCu = (try? kqCu.get())?.first?.duong_dan_luu_tru

                if loaiChuan.hasPrefix("sk_") {
                    let metaDict: [String: Any] = [
                        "loai": loaiChuan,
                        "ngay": ngay,
                        "nhaCungCap": nhaCungCap,
                        "duongDanLuuTru": duongDanLuuTru ?? NSNull(),
                        "urlBenNgoai": urlBenNgoai ?? NSNull(),
                        "ngayCapNhat": isoNow
                    ]
                    if let metaData = try? JSONSerialization.data(withJSONObject: metaDict) {
                        let metaPath = "bot-anh/\(uid)/\(sid)/meta-\(loaiChuan).json"
                        let urlMeta = self.diaChiSupabase.appendingPathComponent("/storage/v1/object/\(self.tenBucket)/\(metaPath)")
                        var reqMeta = URLRequest(url: urlMeta)
                        reqMeta.httpMethod = "POST"
                        reqMeta.httpBody = metaData
                        reqMeta.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        reqMeta.setValue("true", forHTTPHeaderField: "x-upsert")
                        reqMeta.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
                        reqMeta.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
                        self.phienMang.dataTask(with: reqMeta) { _, _, _ in }.resume()
                    }
                }

                var compUpsert = URLComponents(url: self.diaChiSupabase.appendingPathComponent("/rest/v1/dmx_line_anh_bao_cao"), resolvingAgainstBaseURL: false)!
                compUpsert.queryItems = [URLQueryItem(name: "on_conflict", value: "nguoi_dung_id,sieu_thi_id,loai")]
                var payload: [String: Any] = [
                    "nguoi_dung_id": uid,
                    "sieu_thi_id": sid,
                    "loai": loaiChuan,
                    "ngay": ngay,
                    "nha_cung_cap": nhaCungCap,
                    "ngay_cap_nhat": isoNow,
                    "xoa_sau": NSNull()
                ]
                payload["duong_dan_luu_tru"] = duongDanLuuTru ?? NSNull()
                payload["url_ben_ngoai"] = urlBenNgoai ?? NSNull()

                self.guiSupabaseAdminRESTKhongCanDuLieu(
                    url: compUpsert.url!,
                    method: "POST",
                    bodyDict: payload,
                    prefer: "resolution=merge-duplicates"
                ) { [weak self] kqUpsert in
                    guard let self else { return }
                    if let duongDanCu, !duongDanCu.isEmpty, duongDanCu != duongDanLuuTru {
                        let urlDel = self.diaChiSupabase.appendingPathComponent("/storage/v1/object/\(self.tenBucket)/\(duongDanCu)")
                        var reqDel = URLRequest(url: urlDel)
                        reqDel.httpMethod = "DELETE"
                        reqDel.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
                        reqDel.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
                        self.phienMang.dataTask(with: reqDel) { _, _, _ in }.resume()
                    }
                    if loaiChuan.hasPrefix("sk_") {
                        DispatchQueue.main.async { hoanTat(.success(())) }
                    } else {
                        DispatchQueue.main.async { hoanTat(kqUpsert) }
                    }
                }
            }
        }

        if let uid = userId, let sid = sieuThiId, !uid.isEmpty, !sid.isEmpty {
            thucThi(uid, sid)
        } else {
            damBaoUserIdVaSieuThi { ketQua in
                switch ketQua {
                case .failure(let loi):
                    DispatchQueue.main.async { hoanTat(.failure(loi)) }
                case .success(let (uid, sid)):
                    thucThi(uid, sid)
                }
            }
        }
    }

    private func bamSHA256(_ chuoi: String) -> String {
        let data = Data(chuoi.trimmingCharacters(in: .whitespacesAndNewlines).utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func guiSupabaseAdminREST<T: Decodable>(
        url: URL,
        method: String,
        bodyDict: Any? = nil,
        prefer: String? = nil,
        hoanTat: @escaping (Result<T, Error>) -> Void
    ) {
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        if let prefer {
            req.setValue(prefer, forHTTPHeaderField: "Prefer")
        }
        if let bodyDict {
            req.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict)
        }
        phienMang.dataTask(with: req) { data, response, error in
            if let error {
                hoanTat(.failure(error))
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            let duLieu = data ?? Data()
            guard (200..<300).contains(status) else {
                let errObj = try? JSONDecoder().decode(SupabaseAuthError.self, from: duLieu)
                let msg = errObj?.message ?? errObj?.msg ?? errObj?.errorDescription ?? "Supabase từ chối yêu cầu (HTTP \(status))."
                hoanTat(.failure(NSError.dmx(msg)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: duLieu)
                hoanTat(.success(decoded))
            } catch {
                hoanTat(.failure(error))
            }
        }.resume()
    }

    private func guiSupabaseAdminRESTKhongCanDuLieu(
        url: URL,
        method: String,
        bodyDict: Any? = nil,
        prefer: String? = nil,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.timeoutInterval = 20
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        if let prefer {
            req.setValue(prefer, forHTTPHeaderField: "Prefer")
        }
        if let bodyDict {
            req.httpBody = try? JSONSerialization.data(withJSONObject: bodyDict)
        }
        phienMang.dataTask(with: req) { data, response, error in
            if let error {
                hoanTat(.failure(error))
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status) else {
                let duLieu = data ?? Data()
                let errObj = try? JSONDecoder().decode(SupabaseAuthError.self, from: duLieu)
                let msg = errObj?.message ?? errObj?.msg ?? errObj?.errorDescription ?? "Supabase từ chối yêu cầu (HTTP \(status))."
                hoanTat(.failure(NSError.dmx(msg)))
                return
            }
            hoanTat(.success(()))
        }.resume()
    }

    private func lamMoiPhien(hoanTat: @escaping (Bool) -> Void) {
        guard let refresh = phien?.refreshToken else { hoanTat(false); return }
        guiSupabaseAuth(query: "grant_type=refresh_token", body: ["refresh_token": refresh]) { [weak self] kq in
            guard let self else { hoanTat(false); return }
            if case .success(let authRes) = kq,
               let token = authRes.accessToken,
               let refreshMoi = authRes.refreshToken {
                let exp = authRes.expiresAt ?? (Int(Date().timeIntervalSince1970) + (authRes.expiresIn ?? 3600))
                let ten = authRes.user?.userMetadata?["ten_dang_nhap"] ?? self.tenDangNhap
                let quyen = authRes.user.map { self.xacDinhLaAdmin(user: $0, tenDangNhap: ten) } ?? self.laAdmin
                let moi = PhienDangNhapDMX(
                    accessToken: token,
                    refreshToken: refreshMoi,
                    expiresAt: exp,
                    userId: authRes.user?.id ?? self.phien?.userId,
                    tenDangNhap: ten,
                    laAdmin: quyen
                )
                self.phien = moi
                self.luuKeychain(moi)
                hoanTat(true)
            } else {
                hoanTat(false)
            }
        }
    }

    private func guiWeb<T: Decodable, B: Encodable>(path: String, method: String, body: B, canDangNhap: Bool, hoanTat: @escaping (Result<T, Error>) -> Void) {
        let data = try? JSONEncoder().encode(body)
        guiWeb(path: path, method: method, bodyData: data, canDangNhap: canDangNhap, hoanTat: hoanTat)
    }

    private func guiWeb<T: Decodable>(path: String, method: String, bodyData: Data?, canDangNhap: Bool, sieuThiId: String? = nil, thuLai: Bool = true, hoanTat: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: diaChiWeb.appendingPathComponent(path))
        request.httpMethod = method
        request.httpBody = bodyData
        request.timeoutInterval = 18
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if canDangNhap, let token = phien?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let idSieuThiGuiDi = sieuThiId ?? BoNhoSieuThiDMX.idDangChon
        if !idSieuThiGuiDi.isEmpty {
            request.setValue(idSieuThiGuiDi, forHTTPHeaderField: "X-DMX-Store-ID")
        }

        phienMang.dataTask(with: request) { [weak self] data, response, error in
            if let error { DispatchQueue.main.async { hoanTat(.failure(error)) }; return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status == 401, canDangNhap, thuLai {
                self?.lamMoiPhien { thanhCong in
                    guard thanhCong else {
                        DispatchQueue.main.async {
                            self?.dangXuat()
                            NotificationCenter.default.post(name: .taiKhoanDMXBiDangXuat, object: nil)
                            hoanTat(.failure(NSError.dmx("Phiên đăng nhập cũ đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.")))
                        }
                        return
                    }
                    self?.guiWeb(path: path, method: method, bodyData: bodyData, canDangNhap: true, sieuThiId: sieuThiId, thuLai: false, hoanTat: hoanTat)
                }
                return
            }
            let duLieu = data ?? Data()
            guard (200..<300).contains(status) else {
                let loi = (try? JSONDecoder().decode(LoiMayChu.self, from: duLieu).loi) ?? "Máy chủ chưa phản hồi."
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx(loi))) }
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: duLieu)
                DispatchQueue.main.async { hoanTat(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
            }
        }.resume()
    }

    private func docKeychain() -> PhienDangNhapDMX? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: khoaKeychain,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return try? JSONDecoder().decode(PhienDangNhapDMX.self, from: data)
    }

    private func luuKeychain(_ phien: PhienDangNhapDMX) {
        guard let data = try? JSONEncoder().encode(phien) else { return }
        xoaKeychain()
        SecItemAdd([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: khoaKeychain,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ] as CFDictionary, nil)
    }

    private func xoaKeychain() {
        SecItemDelete([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: khoaKeychain
        ] as CFDictionary)
    }
}

extension Notification.Name {
    static let duLieuDMXDaDongBo = Notification.Name("duLieuDMXDaDongBo")
    static let duLieuDMXDaThayDoiTaiMay = Notification.Name("duLieuDMXDaThayDoiTaiMay")
    static let yeuCauTaoLaiAnhBaoCaoBot = Notification.Name("yeuCauTaoLaiAnhBaoCaoBot")
    static let taiKhoanDMXBiDangXuat = Notification.Name("taiKhoanDMXBiDangXuat")
    static let sieuThiDMXDaThayDoi = Notification.Name("sieuThiDMXDaThayDoi")
}

extension NSError {
    static func dmx(_ message: String) -> NSError {
        NSError(domain: "TongHopDMX", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
