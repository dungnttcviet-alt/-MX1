import Foundation
import Security

struct PhienDangNhapDMX: Codable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Int
    var tenDangNhap: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
        case tenDangNhap = "ten_dang_nhap"
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

final class DichVuDongBo {
    static let dungChung = DichVuDongBo()
    private let diaChi = URL(string: "https://www.duongnt.io.vn")!
    private let khoaKeychain = "com.thanhduong.tonghopdmx.phien-dang-nhap"
    private let hangDoi = DispatchQueue(label: "com.thanhduong.tonghopdmx.dongbo")
    private(set) var phien: PhienDangNhapDMX?

    var daDangNhap: Bool { phien != nil }
    var tenDangNhap: String { phien?.tenDangNhap ?? "" }

    private init() { phien = docKeychain() }

    func dangNhap(tenDangNhap: String, matKhau: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        let body = ["ten_dang_nhap": tenDangNhap.lowercased(), "mat_khau": matKhau]
        gui(path: "/api/dmx/ung-dung/dang-nhap", method: "POST", body: body, canDangNhap: false) { [weak self] (kq: Result<PhienDangNhapDMX, Error>) in
            switch kq {
            case .success(let phien):
                self?.phien = phien
                self?.luuKeychain(phien)
                hoanTat(.success(()))
            case .failure(let loi): hoanTat(.failure(loi))
            }
        }
    }

    func dangKy(tenDangNhap: String, matKhau: String, hoanTat: @escaping (Result<Void, Error>) -> Void) {
        let body = ["ten_dang_nhap": tenDangNhap.lowercased(), "mat_khau": matKhau]
        gui(path: "/api/dmx/dang-ky", method: "POST", body: body, canDangNhap: false) { [weak self] (kq: Result<DangKyThanhCong, Error>) in
            switch kq {
            case .success: self?.dangNhap(tenDangNhap: tenDangNhap, matKhau: matKhau, hoanTat: hoanTat)
            case .failure(let loi): hoanTat(.failure(loi))
            }
        }
    }

    func dangXuat() {
        phien = nil
        xoaKeychain()
        KhoDuLieu.dungChung.datLaiSauDangXuat()
    }

    func taiDuLieu(hoanTat: ((Result<Void, Error>) -> Void)? = nil) {
        guard daDangNhap else { hoanTat?(.success(())); return }
        gui(path: "/api/dmx/dong-bo", method: "GET", bodyData: nil, canDangNhap: true) { (kq: Result<DuLieuDamMay, Error>) in
            DispatchQueue.main.async {
                switch kq {
                case .success(let cloud):
                    KhoDuLieu.dungChung.nhapDuLieuDamMay(caiDat: cloud.caiDat, cacNgay: cloud.cacNgay ?? [:])
                    NotificationCenter.default.post(name: .duLieuDMXDaDongBo, object: nil)
                    hoanTat?(.success(()))
                case .failure(let loi): hoanTat?(.failure(loi))
                }
            }
        }
    }

    func dayDuLieuNgay(_ duLieu: DuLieuNgayDMX) {
        day(GoiDongBo(caiDat: nil, ngay: duLieu.khoaNgay, duLieuNgay: duLieu))
    }

    func dayCaiDat(_ caiDat: CaiDatDMX) {
        day(GoiDongBo(caiDat: caiDat, ngay: nil, duLieuNgay: nil))
    }

    private func day(_ goi: GoiDongBo) {
        guard daDangNhap else { return }
        hangDoi.async { [weak self] in
            self?.gui(path: "/api/dmx/dong-bo", method: "POST", body: goi, canDangNhap: true) { (_: Result<LoiMayChu, Error>) in }
        }
    }

    private func lamMoiPhien(hoanTat: @escaping (Bool) -> Void) {
        guard let refresh = phien?.refreshToken else { hoanTat(false); return }
        gui(path: "/api/dmx/ung-dung/dang-nhap", method: "POST", body: ["refresh_token": refresh], canDangNhap: false) { [weak self] (kq: Result<PhienDangNhapDMX, Error>) in
            if case .success(let moi) = kq {
                self?.phien = moi
                self?.luuKeychain(moi)
                hoanTat(true)
            } else {
                hoanTat(false)
            }
        }
    }

    private func gui<T: Decodable, B: Encodable>(path: String, method: String, body: B, canDangNhap: Bool, hoanTat: @escaping (Result<T, Error>) -> Void) {
        let data = try? JSONEncoder().encode(body)
        gui(path: path, method: method, bodyData: data, canDangNhap: canDangNhap, hoanTat: hoanTat)
    }

    private func gui<T: Decodable>(path: String, method: String, bodyData: Data?, canDangNhap: Bool, thuLai: Bool = true, hoanTat: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: diaChi.appendingPathComponent(path))
        request.httpMethod = method
        request.httpBody = bodyData
        request.timeoutInterval = 35
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
                    self?.gui(path: path, method: method, bodyData: bodyData, canDangNhap: true, thuLai: false, hoanTat: hoanTat)
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
}

private extension NSError {
    static func dmx(_ message: String) -> NSError {
        NSError(domain: "TongHopDMX", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
