import Foundation
import Security

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
}

private struct LoiMayChu: Codable { var loi: String? }
private struct DuLieuDamMay: Codable {
    var caiDat: CaiDatDMX?
    var cacNgay: [String: DuLieuNgayDMX]?
}
private struct GoiDongBo: Codable {
    var caiDat: CaiDatDMX?
    var ngay: String?
    var duLieuNgay: DuLieuNgayDMX?
}

// MARK: - Phản hồi từ Supabase Auth & REST API trực tiếp

private struct AnyCodableValue: Codable {
    var stringValue: String

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
        if let dict = try? c.decode([String: String].self, forKey: .userMetadata) {
            userMetadata = dict
        } else if let rawDict = try? c.decode([String: AnyCodableValue].self, forKey: .userMetadata) {
            userMetadata = rawDict.mapValues { $0.stringValue }
        } else {
            userMetadata = nil
        }
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
    var ngay: String
    var du_lieu: DuLieuNgayDMX
    var ngay_cap_nhat: String?
}

final class DichVuDongBo {
    static let dungChung = DichVuDongBo()

    private let diaChiWeb = URL(string: "https://www.duongnt.io.vn")!
    private let diaChiSupabase = URL(string: "https://isxrxeaxytyiydxiwvuc.supabase.co")!
    private let khoaCongKhaiSupabase = "sb_publishable_mafynf1XYupP9W_WeLYSRg_M7cjJXPS"
    private let khoaBiMatSupabase = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzeHJ4ZWF4eXR5aXlkeGl3dnVjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NDQ1OTY1OCwiZXhwIjoyMTAwMDM1NjU4fQ.V7zW8iMiwuKCHGY-1tG1ociK-aeUXwX0BnhqDf1rTo4"
    private let tenBucket = "dmx-du-lieu"
    private let hauToEmailDmx = "@dmx.internal.duongnt.io.vn"

    private let khoaKeychain = "com.thanhduong.tonghopdmx.phien-dang-nhap"
    private let khoaDaDonDepLocal = "com.thanhduong.tonghopdmx.da-don-dep-tai-khoan-cu-v1"
    private let hangDoi = DispatchQueue(label: "com.thanhduong.tonghopdmx.dongbo")
    private(set) var phien: PhienDangNhapDMX?

    var daDangNhap: Bool { phien != nil }
    var tenDangNhap: String { phien?.tenDangNhap ?? "" }
    var laAdmin: Bool {
        if tenDangNhap.lowercased() == "duongnt" { return true }
        return phien?.laAdmin ?? false
    }

    private init() { phien = docKeychain() }

    func chuanHoaTenDangNhap(_ raw: String) -> String {
        raw.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "[^a-z0-9._-]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

    private func taoEmailDmx(_ tenDangNhap: String) -> String {
        "\(chuanHoaTenDangNhap(tenDangNhap))\(hauToEmailDmx)"
    }

    private func xacDinhLaAdmin(user: SupabaseAuthUser, tenDangNhap: String) -> Bool {
        if tenDangNhap.lowercased() == "duongnt" { return true }
        let v = (user.userMetadata?["la_admin"] ?? "").lowercased()
        return v == "true" || v == "1"
    }

    // MARK: - 1. Đăng nhập & Khởi tạo Admin gốc

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
                let tenHienThi = authRes.user?.userMetadata?["ten_dang_nhap"] ?? tenChuan
                let laAdminQuyen = authRes.user.map { self.xacDinhLaAdmin(user: $0, tenDangNhap: tenHienThi) } ?? (tenHienThi.lowercased() == "duongnt")
                let phienMoi = PhienDangNhapDMX(
                    accessToken: token,
                    refreshToken: refresh,
                    expiresAt: exp,
                    userId: authRes.user?.id,
                    tenDangNhap: tenHienThi,
                    laAdmin: laAdminQuyen
                )
                self.phien = phienMoi
                self.luuKeychain(phienMoi)
                if tenHienThi.lowercased() == "duongnt", let uid = authRes.user?.id {
                    self.damBaoMetadataAdminChoDuongnt(userId: uid, metadataHienTai: authRes.user?.userMetadata)
                }
                hoanTat(.success(()))
            case .failure(let loi):
                if tenChuan == "duongnt" {
                    self.kiemTraVaKhoiTaoDuongntNeuChuaCo(matKhau: matKhau, loiGoc: loi, hoanTat: hoanTat)
                    return
                }
                hoanTat(.failure(loi))
            }
        }
    }

    private func damBaoMetadataAdminChoDuongnt(userId: String, metadataHienTai: [String: String]?) {
        guard (metadataHienTai?["la_admin"] ?? "") != "true" else { return }
        var meta = metadataHienTai ?? [:]
        meta["ung_dung"] = "dmx"
        meta["ten_dang_nhap"] = "duongnt"
        meta["la_admin"] = "true"
        capNhatUserSupabaseAdmin(userId: userId, matKhauMoi: nil, userMetadata: meta) { _ in }
    }

    private func kiemTraVaKhoiTaoDuongntNeuChuaCo(matKhau: String, loiGoc: Error, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { return }
            if case .success(let users) = kq {
                let emailDuongnt = self.taoEmailDmx("duongnt")
                if users.contains(where: { ($0.email ?? "").lowercased() == emailDuongnt }) {
                    hoanTat(.failure(loiGoc))
                    return
                }
                self.adminTaoTaiKhoanMoi(tenDangNhap: "duongnt", matKhau: matKhau, laAdmin: true) { kqTao in
                    switch kqTao {
                    case .success:
                        self.dangNhap(tenDangNhap: "duongnt", matKhau: matKhau, hoanTat: hoanTat)
                    case .failure:
                        hoanTat(.failure(loiGoc))
                    }
                }
            } else {
                hoanTat(.failure(loiGoc))
            }
        }
    }

    func thucHienKhoiTaoAdminVaXoaTaiKhoanCuNeuCan(hoanTat: (() -> Void)? = nil) {
        if UserDefaults.standard.bool(forKey: khoaDaDonDepLocal) {
            hoanTat?()
            return
        }
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { hoanTat?(); return }
            guard case .success(let users) = kq else { hoanTat?(); return }
            let emailDuongnt = self.taoEmailDmx("duongnt")
            let userDuongnt = users.first(where: { ($0.email ?? "").lowercased() == emailDuongnt })
            if let u = userDuongnt, (u.userMetadata?["da_don_dep_tai_khoan_v1"] ?? "") == "true" {
                UserDefaults.standard.set(true, forKey: self.khoaDaDonDepLocal)
                hoanTat?()
                return
            }
            if let u = userDuongnt {
                var meta = u.userMetadata ?? [:]
                meta["ung_dung"] = "dmx"
                meta["ten_dang_nhap"] = "duongnt"
                meta["la_admin"] = "true"
                meta["da_don_dep_tai_khoan_v1"] = "true"
                self.capNhatUserSupabaseAdmin(userId: u.id, matKhauMoi: nil, userMetadata: meta) { _ in }
            }
            UserDefaults.standard.set(true, forKey: self.khoaDaDonDepLocal)
            hoanTat?()
        }
    }

    func dangXuat() {
        phien = nil
        xoaKeychain()
        KhoDuLieu.dungChung.datLaiSauDangXuat()
    }

    // MARK: - 2. Quản trị Tài khoản (Supabase Admin API)

    func layDanhSachTaiKhoan(hoanTat: @escaping (Result<[ThongTinTaiKhoanDMX], Error>) -> Void) {
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let users):
                let ds: [ThongTinTaiKhoanDMX] = users.compactMap { u in
                    let email = (u.email ?? "").lowercased()
                    let ungDung = u.userMetadata?["ung_dung"] ?? ""
                    guard email.hasSuffix(self.hauToEmailDmx) || ungDung == "dmx" else { return nil }
                    let tenTuEmail = email.replacingOccurrences(of: self.hauToEmailDmx, with: "")
                    let ten = u.userMetadata?["ten_dang_nhap"] ?? tenTuEmail
                    let laAdminUser = self.xacDinhLaAdmin(user: u, tenDangNhap: ten)
                    return ThongTinTaiKhoanDMX(
                        id: u.id,
                        tenDangNhap: ten,
                        email: email,
                        laAdmin: laAdminUser,
                        ngayTao: self.dinhDangNgayISO(u.createdAt),
                        dangNhapCuoi: self.dinhDangNgayISO(u.lastSignInAt)
                    )
                }.sorted { a, b in
                    if a.tenDangNhap.lowercased() == "duongnt" { return true }
                    if b.tenDangNhap.lowercased() == "duongnt" { return false }
                    if a.laAdmin != b.laAdmin { return a.laAdmin && !b.laAdmin }
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

        struct GoiTaoUser: Encodable {
            let email: String
            let password: String
            let email_confirm: Bool
            let user_metadata: [String: String]
        }

        let goi = GoiTaoUser(
            email: email,
            password: matKhau,
            email_confirm: true,
            user_metadata: [
                "ung_dung": "dmx",
                "ten_dang_nhap": tenChuan,
                "la_admin": (laAdmin || tenChuan == "duongnt") ? "true" : "false"
            ]
        )

        var req = URLRequest(url: diaChiSupabase.appendingPathComponent("/auth/v1/admin/users"))
        req.httpMethod = "POST"
        req.timeoutInterval = 25
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONEncoder().encode(goi)

        URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
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
                let laTrung = status == 422 || status == 409 || msg.localizedCaseInsensitiveContains("already")
                let thongBao = laTrung ? "Tên đăng nhập \"\(tenChuan)\" đã tồn tại." : (msg.isEmpty ? "Chưa tạo được tài khoản mới." : msg)
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx(thongBao))) }
                return
            }
            if let u = try? JSONDecoder().decode(SupabaseAuthUser.self, from: duLieu), !u.id.isEmpty {
                let tk = ThongTinTaiKhoanDMX(
                    id: u.id,
                    tenDangNhap: tenChuan,
                    email: email,
                    laAdmin: laAdmin || tenChuan == "duongnt",
                    ngayTao: self.dinhDangNgayISO(u.createdAt),
                    dangNhapCuoi: self.dinhDangNgayISO(u.lastSignInAt)
                )
                DispatchQueue.main.async { hoanTat(.success(tk)) }
            } else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Chưa tạo được tài khoản mới."))) }
            }
        }.resume()
    }

    func doiMatKhauCaNhan(matKhauMoi: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        guard matKhauMoi.count >= 6 else {
            hoanTat(.failure(NSError.dmx("Mật khẩu cần có ít nhất 6 ký tự.")))
            return
        }
        damBaoUserId { [weak self] uid in
            guard let self, let uid, !uid.isEmpty else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Không xác định được phiên tài khoản hiện tại."))) }
                return
            }
            self.capNhatUserSupabaseAdmin(userId: uid, matKhauMoi: matKhauMoi, userMetadata: nil, hoanTat: hoanTat)
        }
    }

    func adminDoiMatKhau(userId: String, matKhauMoi: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        guard matKhauMoi.count >= 6 else {
            hoanTat(.failure(NSError.dmx("Mật khẩu cần có ít nhất 6 ký tự.")))
            return
        }
        capNhatUserSupabaseAdmin(userId: userId, matKhauMoi: matKhauMoi, userMetadata: nil, hoanTat: hoanTat)
    }

    func adminDatQuyenAdmin(taiKhoan: ThongTinTaiKhoanDMX, laAdmin: Bool, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        if taiKhoan.tenDangNhap.lowercased() == "duongnt" && !laAdmin {
            hoanTat(.failure(NSError.dmx("\"duongnt\" là Admin gốc của dự án, không thể gỡ quyền Admin.")))
            return
        }
        let meta: [String: String] = [
            "ung_dung": "dmx",
            "ten_dang_nhap": taiKhoan.tenDangNhap,
            "la_admin": laAdmin ? "true" : "false"
        ]
        capNhatUserSupabaseAdmin(userId: taiKhoan.id, matKhauMoi: nil, userMetadata: meta) { [weak self] kq in
            if case .success = kq, let self, self.phien?.userId == taiKhoan.id {
                var p = self.phien
                p?.laAdmin = laAdmin
                if let p {
                    self.phien = p
                    self.luuKeychain(p)
                }
            }
            hoanTat(kq)
        }
    }

    func adminXoaTaiKhoan(taiKhoan: ThongTinTaiKhoanDMX, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        if taiKhoan.tenDangNhap.lowercased() == "duongnt" {
            hoanTat(.failure(NSError.dmx("Không thể xoá tài khoản Admin gốc \"duongnt\".")))
            return
        }
        xoaUserVaDuLieuTrenSupabase(userId: taiKhoan.id) { [weak self] kq in
            if case .success = kq, let self, self.phien?.userId == taiKhoan.id {
                self.dangXuat()
                NotificationCenter.default.post(name: .taiKhoanDMXBiDangXuat, object: nil)
            }
            hoanTat(kq)
        }
    }

    func adminXoaTatCaTaiKhoanKhacGiuDuongnt(hoanTat: @escaping (Result<Int, Error>) -> Void) {
        layDanhSachUsersSupabaseAdmin { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let users):
                let emailDuongnt = self.taoEmailDmx("duongnt")
                let canXoa = users.filter { ($0.email ?? "").lowercased() != emailDuongnt }
                let nhom = DispatchGroup()
                var daXoa = 0
                for u in canXoa {
                    nhom.enter()
                    self.xoaUserVaDuLieuTrenSupabase(userId: u.id) { r in
                        if case .success = r { daXoa += 1 }
                        nhom.leave()
                    }
                }
                self.xoaHoSoSQLKhacDuongnt()
                nhom.notify(queue: .main) {
                    hoanTat(.success(daXoa))
                }
            case .failure(let loi):
                DispatchQueue.main.async { hoanTat(.failure(loi)) }
            }
        }
    }

    private func xoaHoSoSQLKhacDuongnt() {
        var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
        comp.queryItems = [URLQueryItem(name: "ten_dang_nhap", value: "neq.duongnt")]
        var req = URLRequest(url: comp.url!)
        req.httpMethod = "DELETE"
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) { _, _, _ in }.resume()
    }

    private func layDanhSachUsersSupabaseAdmin(hoanTat: @escaping (Result<[SupabaseAuthUser], Error>) -> Void) {
        var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/auth/v1/admin/users"), resolvingAgainstBaseURL: false)!
        comp.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "200")
        ]
        var req = URLRequest(url: comp.url!)
        req.httpMethod = "GET"
        req.timeoutInterval = 25
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status), let data else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Không tải được danh sách tài khoản từ máy chủ."))) }
                return
            }
            if let res = try? JSONDecoder().decode(DanhSachAdminUsersResponse.self, from: data), let users = res.users {
                DispatchQueue.main.async { hoanTat(.success(users)) }
            } else if let users = try? JSONDecoder().decode([SupabaseAuthUser].self, from: data) {
                DispatchQueue.main.async { hoanTat(.success(users)) }
            } else {
                DispatchQueue.main.async { hoanTat(.success([])) }
            }
        }.resume()
    }

    private func capNhatUserSupabaseAdmin(
        userId: String,
        matKhauMoi: String?,
        userMetadata: [String: String]?,
        hoanTat: @escaping (Result<Void, Error>) -> Void
    ) {
        var payload: [String: Any] = [:]
        if let mk = matKhauMoi, !mk.isEmpty { payload["password"] = mk }
        if let meta = userMetadata { payload["user_metadata"] = meta }

        var req = URLRequest(url: diaChiSupabase.appendingPathComponent("/auth/v1/admin/users/\(userId)"))
        req.httpMethod = "PUT"
        req.timeoutInterval = 25
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: req) { data, response, error in
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
        var req = URLRequest(url: diaChiSupabase.appendingPathComponent("/auth/v1/admin/users/\(userId)"))
        req.httpMethod = "DELETE"
        req.timeoutInterval = 25
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: req) { [weak self] _, response, error in
            guard let self else { return }
            if let error {
                DispatchQueue.main.async { hoanTat(.failure(error)) }
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status) else {
                DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Chưa xoá được tài khoản trên máy chủ."))) }
                return
            }
            // Xoá file storage & dữ liệu SQL của user vừa xoá
            var reqStorage = URLRequest(url: self.diaChiSupabase.appendingPathComponent("/storage/v1/object/\(self.tenBucket)/\(userId).json"))
            reqStorage.httpMethod = "DELETE"
            reqStorage.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
            reqStorage.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: reqStorage) { _, _, _ in }.resume()

            for bang in ["/rest/v1/dmx_ho_so", "/rest/v1/dmx_du_lieu_ngay"] {
                var comp = URLComponents(url: self.diaChiSupabase.appendingPathComponent(bang), resolvingAgainstBaseURL: false)!
                comp.queryItems = [URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)")]
                var reqSQL = URLRequest(url: comp.url!)
                reqSQL.httpMethod = "DELETE"
                reqSQL.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
                reqSQL.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
                URLSession.shared.dataTask(with: reqSQL) { _, _, _ in }.resume()
            }

            DispatchQueue.main.async { hoanTat(.success(())) }
        }.resume()
    }

    private func dinhDangNgayISO(_ raw: String?) -> String {
        guard let raw, !raw.isEmpty else { return "Chưa ghi nhận" }
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = iso.date(from: raw) ?? ISO8601DateFormatter().date(from: raw)
        guard let date else { return String(raw.prefix(10)) }
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "vi_VN")
        fmt.dateFormat = "HH:mm dd/MM/yyyy"
        return fmt.string(from: date)
    }

    // MARK: - 3. Tải dữ liệu đồng bộ (Kết hợp Supabase Storage + Bảng SQL + Web API)

    func taiDuLieu(hoanTat: ((Result<Void, Error>) -> Void)? = nil) {
        guard daDangNhap else { hoanTat?(.success(())); return }

        damBaoUserId { [weak self] userId in
            guard let self else { return }
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

            if let uid = userId, !uid.isEmpty {
                nhom.enter()
                self.docFileStorageSupabase(userId: uid) { cloud in
                    gopAnToan(caiDat: cloud?.caiDat, cacNgay: cloud?.cacNgay)
                    nhom.leave()
                }

                nhom.enter()
                self.docBangSQLSupabase(userId: uid) { cdSQL, ngaySQL in
                    gopAnToan(caiDat: cdSQL, cacNgay: ngaySQL)
                    nhom.leave()
                }
            }

            nhom.enter()
            self.guiWeb(path: "/api/dmx/dong-bo", method: "GET", bodyData: nil, canDangNhap: true) { (kq: Result<DuLieuDamMay, Error>) in
                if case .success(let cloud) = kq {
                    gopAnToan(caiDat: cloud.caiDat, cacNgay: cloud.cacNgay)
                }
                nhom.leave()
            }

            nhom.notify(queue: .main) {
                khoaGop.lock()
                let cdCuoi = caiDatGop
                let ngayCuoi = cacNgayGop
                khoaGop.unlock()
                if cdCuoi != nil || !ngayCuoi.isEmpty {
                    KhoDuLieu.dungChung.nhapDuLieuDamMay(caiDat: cdCuoi, cacNgay: ngayCuoi)
                    NotificationCenter.default.post(name: .duLieuDMXDaDongBo, object: nil)
                }
                hoanTat?(.success(()))
            }
        }
    }

    // MARK: - 4. Đẩy dữ liệu ngày & cài đặt lên đám mây

    func dayDuLieuNgay(_ duLieu: DuLieuNgayDMX) {
        day(GoiDongBo(caiDat: nil, ngay: duLieu.khoaNgay, duLieuNgay: duLieu))
    }

    func dayCaiDat(_ caiDat: CaiDatDMX) {
        day(GoiDongBo(caiDat: caiDat, ngay: nil, duLieuNgay: nil))
    }

    private func day(_ goi: GoiDongBo) {
        guard daDangNhap else { return }
        hangDoi.async { [weak self] in
            guard let self else { return }
            self.guiWeb(path: "/api/dmx/dong-bo", method: "POST", body: goi, canDangNhap: true) { (_: Result<LoiMayChu, Error>) in }

            self.damBaoUserId { [weak self] userId in
                guard let self, let uid = userId, !uid.isEmpty else { return }
                self.ghiStorageSupabase(userId: uid, goi: goi)
                self.ghiBangSQLSupabase(userId: uid, goi: goi)
            }
        }
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
        req.timeoutInterval = 25
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        req.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: req) { data, response, error in
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

        URLSession.shared.dataTask(with: req) { [weak self] data, response, _ in
            guard let self else { hoanTat(nil); return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status == 401 {
                self.lamMoiPhien { ok in
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
        req.timeoutInterval = 20
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: req) { data, response, _ in
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status), let data else {
                hoanTat(nil)
                return
            }
            let cloud = try? JSONDecoder().decode(DuLieuDamMay.self, from: data)
            hoanTat(cloud)
        }.resume()
    }

    private func ghiStorageSupabase(userId: String, goi: GoiDongBo) {
        let payload = DuLieuDamMay(
            caiDat: goi.caiDat ?? KhoDuLieu.dungChung.caiDat,
            cacNgay: KhoDuLieu.dungChung.cacNgay
        )
        guard let body = try? JSONEncoder().encode(payload) else { return }

        var reqBucket = URLRequest(url: diaChiSupabase.appendingPathComponent("/storage/v1/bucket"))
        reqBucket.httpMethod = "POST"
        reqBucket.setValue("application/json", forHTTPHeaderField: "Content-Type")
        reqBucket.setValue(khoaBiMatSupabase, forHTTPHeaderField: "apikey")
        reqBucket.setValue("Bearer \(khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
        reqBucket.httpBody = try? JSONSerialization.data(withJSONObject: ["id": tenBucket, "name": tenBucket, "public": false])
        URLSession.shared.dataTask(with: reqBucket) { _, _, _ in
            let url = self.diaChiSupabase.appendingPathComponent("/storage/v1/object/\(self.tenBucket)/\(userId).json")
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.timeoutInterval = 25
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("true", forHTTPHeaderField: "x-upsert")
            req.setValue(self.khoaBiMatSupabase, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(self.khoaBiMatSupabase)", forHTTPHeaderField: "Authorization")
            req.httpBody = body
            URLSession.shared.dataTask(with: req) { _, _, _ in }.resume()
        }.resume()
    }

    private func docBangSQLSupabase(
        userId: String,
        hoanTat: @escaping (CaiDatDMX?, [String: DuLieuNgayDMX]) -> Void
    ) {
        guard let token = phien?.accessToken else {
            hoanTat(nil, [:])
            return
        }
        let nhom = DispatchGroup()
        var cdKetQua: CaiDatDMX?
        var ngayKetQua: [String: DuLieuNgayDMX] = [:]

        nhom.enter()
        var compHoSo = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
        compHoSo.queryItems = [
            URLQueryItem(name: "select", value: "cai_dat"),
            URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)"),
            URLQueryItem(name: "limit", value: "1")
        ]
        var reqHoSo = URLRequest(url: compHoSo.url!)
        reqHoSo.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        reqHoSo.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: reqHoSo) { data, response, _ in
            if let status = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(status),
               let data, let rows = try? JSONDecoder().decode([DongHoSoSupabase].self, from: data),
               let cd = rows.first?.cai_dat {
                cdKetQua = cd
            }
            nhom.leave()
        }.resume()

        nhom.enter()
        var compNgay = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_du_lieu_ngay"), resolvingAgainstBaseURL: false)!
        compNgay.queryItems = [
            URLQueryItem(name: "select", value: "ngay,du_lieu"),
            URLQueryItem(name: "nguoi_dung_id", value: "eq.\(userId)"),
            URLQueryItem(name: "order", value: "ngay.desc"),
            URLQueryItem(name: "limit", value: "62")
        ]
        var reqNgay = URLRequest(url: compNgay.url!)
        reqNgay.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
        reqNgay.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: reqNgay) { data, response, _ in
            if let status = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(status),
               let data, let rows = try? JSONDecoder().decode([DongDuLieuNgaySupabase].self, from: data) {
                for r in rows {
                    ngayKetQua[r.ngay] = r.du_lieu
                }
            }
            nhom.leave()
        }.resume()

        nhom.notify(queue: .global()) {
            hoanTat(cdKetQua, ngayKetQua)
        }
    }

    private func ghiBangSQLSupabase(userId: String, goi: GoiDongBo) {
        guard let token = phien?.accessToken else { return }
        let isoNow = ISO8601DateFormatter().string(from: Date())

        if let cd = goi.caiDat {
            var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_ho_so"), resolvingAgainstBaseURL: false)!
            comp.queryItems = [URLQueryItem(name: "on_conflict", value: "nguoi_dung_id")]
            var req = URLRequest(url: comp.url!)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
            req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let body = DongHoSoSupabase(
                nguoi_dung_id: userId,
                ten_dang_nhap: tenDangNhap.isEmpty ? "user" : tenDangNhap,
                cai_dat: cd,
                ngay_cap_nhat: isoNow
            )
            req.httpBody = try? JSONEncoder().encode(body)
            URLSession.shared.dataTask(with: req) { _, _, _ in }.resume()
        }

        if let ngay = goi.ngay, let dl = goi.duLieuNgay {
            var comp = URLComponents(url: diaChiSupabase.appendingPathComponent("/rest/v1/dmx_du_lieu_ngay"), resolvingAgainstBaseURL: false)!
            comp.queryItems = [URLQueryItem(name: "on_conflict", value: "nguoi_dung_id,ngay")]
            var req = URLRequest(url: comp.url!)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("resolution=merge-duplicates", forHTTPHeaderField: "Prefer")
            req.setValue(khoaCongKhaiSupabase, forHTTPHeaderField: "apikey")
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let body = DongDuLieuNgaySupabase(
                nguoi_dung_id: userId,
                ngay: ngay,
                du_lieu: dl,
                ngay_cap_nhat: isoNow
            )
            req.httpBody = try? JSONEncoder().encode(body)
            URLSession.shared.dataTask(with: req) { _, _, _ in }.resume()
        }
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
                let laAdminQuyen = authRes.user.map { self.xacDinhLaAdmin(user: $0, tenDangNhap: ten) } ?? self.laAdmin
                let moi = PhienDangNhapDMX(
                    accessToken: token,
                    refreshToken: refreshMoi,
                    expiresAt: exp,
                    userId: authRes.user?.id ?? self.phien?.userId,
                    tenDangNhap: ten,
                    laAdmin: laAdminQuyen
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

    private func guiWeb<T: Decodable>(path: String, method: String, bodyData: Data?, canDangNhap: Bool, thuLai: Bool = true, hoanTat: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: diaChiWeb.appendingPathComponent(path))
        request.httpMethod = method
        request.httpBody = bodyData
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if canDangNhap, let token = phien?.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error { DispatchQueue.main.async { hoanTat(.failure(error)) }; return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            if status == 401, canDangNhap, thuLai {
                self?.lamMoiPhien { thanhCong in
                    guard thanhCong else {
                        DispatchQueue.main.async { hoanTat(.failure(NSError.dmx("Phiên đăng nhập đã hết hạn."))) }
                        return
                    }
                    self?.guiWeb(path: path, method: method, bodyData: bodyData, canDangNhap: true, thuLai: false, hoanTat: hoanTat)
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
    static let taiKhoanDMXBiDangXuat = Notification.Name("taiKhoanDMXBiDangXuat")
}

private extension NSError {
    static func dmx(_ message: String) -> NSError {
        NSError(domain: "TongHopDMX", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
