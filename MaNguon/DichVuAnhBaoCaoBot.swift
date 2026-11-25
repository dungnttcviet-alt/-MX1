import UIKit
import Security

enum KhoAnhBaoCaoBot: String, Codable, CaseIterable {
    case supabase
    case apiKey
    case googleDrive

    var tieuDe: String {
        switch self {
        case .supabase: return "Cloudflare R2"
        case .apiKey: return "API Key (ImgBB)"
        case .googleDrive: return "Google Drive"
        }
    }
}

struct CauHinhKhoAnhBaoCaoBot: Codable, Equatable {
    var kho: KhoAnhBaoCaoBot = .supabase
    var apiKeyImgBB: String = ""
    var driveClientId: String = ""
    var driveClientSecret: String = ""
    var driveRefreshToken: String = ""
    var urlAppsScript: String = ""
    var khoaBiMat: String = ""
    var folderId: String = ""

    init(
        kho: KhoAnhBaoCaoBot = .supabase,
        apiKeyImgBB: String = "",
        driveClientId: String = "",
        driveClientSecret: String = "",
        driveRefreshToken: String = "",
        urlAppsScript: String = "",
        khoaBiMat: String = "",
        folderId: String = ""
    ) {
        self.kho = kho
        self.apiKeyImgBB = apiKeyImgBB
        self.driveClientId = driveClientId
        self.driveClientSecret = driveClientSecret
        self.driveRefreshToken = driveRefreshToken
        self.urlAppsScript = urlAppsScript
        self.khoaBiMat = khoaBiMat
        self.folderId = folderId
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        kho = (try? c.decode(KhoAnhBaoCaoBot.self, forKey: .kho)) ?? .supabase
        apiKeyImgBB = (try? c.decode(String.self, forKey: .apiKeyImgBB)) ?? ""
        driveClientId = (try? c.decode(String.self, forKey: .driveClientId)) ?? ""
        driveClientSecret = (try? c.decode(String.self, forKey: .driveClientSecret)) ?? ""
        driveRefreshToken = (try? c.decode(String.self, forKey: .driveRefreshToken)) ?? ""
        urlAppsScript = (try? c.decode(String.self, forKey: .urlAppsScript)) ?? ""
        khoaBiMat = (try? c.decode(String.self, forKey: .khoaBiMat)) ?? ""
        folderId = (try? c.decode(String.self, forKey: .folderId)) ?? ""
    }

    var apiKeyDaSanSang: Bool {
        kho == .apiKey &&
        !apiKeyImgBB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var driveTrucTiepDaSanSang: Bool {
        let token = driveRefreshToken.trimmingCharacters(in: .whitespacesAndNewlines)
        let cid = driveClientId.trimmingCharacters(in: .whitespacesAndNewlines)
        let secret = driveClientSecret.trimmingCharacters(in: .whitespacesAndNewlines)
        return kho == .googleDrive &&
            !token.isEmpty &&
            ((!cid.isEmpty && !secret.isEmpty) || token.hasPrefix("ya29."))
    }

    var driveAppsScriptDaSanSang: Bool {
        kho == .googleDrive &&
        urlAppsScript.lowercased().hasPrefix("https://script.google.com/") &&
        !khoaBiMat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !folderId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var driveDaSanSang: Bool {
        driveTrucTiepDaSanSang || driveAppsScriptDaSanSang
    }

    var tenKhoHieuLuc: String {
        switch kho {
        case .supabase:
            return "Cloudflare R2"
        case .apiKey:
            return apiKeyDaSanSang ? "API Key (ImgBB)" : "Cloudflare R2"
        case .googleDrive:
            if driveTrucTiepDaSanSang { return "Google Drive (API trực tiếp)" }
            if driveAppsScriptDaSanSang { return "Google Drive" }
            return "Cloudflare R2"
        }
    }
}

private struct PhanHoiGoogleDrive: Decodable {
    var ok: Bool?
    var url: String?
    var fileId: String?
    var error: String?
}

private struct PhanHoiImgBB: Decodable {
    struct DuLieuImgBB: Decodable {
        var url: String?
        var display_url: String?
    }
    struct LoiImgBB: Decodable {
        var message: String?
        var code: Int?
    }
    var success: Bool?
    var status: Int?
    var status_code: Int?
    var status_txt: String?
    var error: LoiImgBB?
    var data: DuLieuImgBB?
}

private struct PhanHoiTokenGoogle: Decodable {
    var access_token: String?
    var expires_in: Double?
}

private struct PhanHoiDriveFileAPI: Decodable {
    var id: String?
}

final class DichVuAnhBaoCaoBot {
    static let dungChung = DichVuAnhBaoCaoBot()
    private let khoaKeychain = "com.thanhduong.tonghopdmx.kho-anh-bao-cao-bot-v1"
    private let hangDoi = DispatchQueue(label: "com.thanhduong.tonghopdmx.anh-bot", qos: .utility)
    /// Chỉ được đọc/ghi trên `hangDoi`. Mỗi yêu cầu ImgBB bắt đầu cách nhau ít nhất 2 giây
    /// để tránh lỗi API code 100 "Rate limit reached" khi xuất hàng loạt.
    private var thoiDiemTaiImgBBTiepTheo = Date.distantPast
    private let khoangCachTaiImgBB: TimeInterval = 2
    private let phienMang: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 45
        cfg.timeoutIntervalForResource = 60
        return URLSession(configuration: cfg)
    }()
    private var accessTokenDriveTam: String = ""
    private var hanAccessTokenDrive: Date = .distantPast

    private init() {}

    var cauHinh: CauHinhKhoAnhBaoCaoBot {
        get { docCauHinh() ?? CauHinhKhoAnhBaoCaoBot() }
        set { luuCauHinh(newValue) }
    }

    func taiAnh(
        _ anh: UIImage,
        loai: String,
        ngay: String,
        buocDungSupabase: Bool = false,
        hoanTat: ((Result<String, Error>) -> Void)? = nil
    ) {
        let cauHinh = self.cauHinh
        hangDoi.async { [weak self] in
            guard let self,
                  let jpeg = self.duLieuJPEGToiUu(anh) else {
                DispatchQueue.main.async { hoanTat?(.failure(NSError.dmx("Không nén được ảnh báo cáo."))) }
                return
            }
            if buocDungSupabase || cauHinh.kho == .supabase {
                self.taiLenSupabase(jpeg, loai: loai, ngay: ngay, hoanTat: hoanTat)
            } else if cauHinh.kho == .apiKey && cauHinh.apiKeyDaSanSang {
                let bayGio = Date()
                let thoiDiemBatDau = max(bayGio, self.thoiDiemTaiImgBBTiepTheo)
                self.thoiDiemTaiImgBBTiepTheo = thoiDiemBatDau.addingTimeInterval(self.khoangCachTaiImgBB)
                let doTre = max(0, thoiDiemBatDau.timeIntervalSince(bayGio))

                self.hangDoi.asyncAfter(deadline: .now() + doTre) { [weak self] in
                    guard let self else { return }
                    self.taiLenImgBB(jpeg, loai: loai, ngay: ngay, apiKey: cauHinh.apiKeyImgBB) { ketQua in
                        switch ketQua {
                        case .success(let url):
                            DichVuDongBo.dungChung.luuAnhBaoCaoBot(loai: loai, ngay: ngay, urlDrive: url) { kq in
                                hoanTat?(kq.map { "API Key (ImgBB)" })
                            }
                        case .failure(let loiImgBB):
                            // Vẫn giữ bản dự phòng để bot không mất ảnh, nhưng không được
                            // che lỗi ImgBB như trước đây.
                            self.taiLenSupabase(jpeg, loai: loai, ngay: ngay) { ketQuaDuPhong in
                                switch ketQuaDuPhong {
                                case .success(let khoDuPhong):
                                    hoanTat?(.success("\(khoDuPhong) dự phòng — ImgBB lỗi: \(loiImgBB.localizedDescription)"))
                                case .failure(let loiSupabase):
                                    hoanTat?(.failure(NSError.dmx(
                                        "ImgBB lỗi: \(loiImgBB.localizedDescription). Supabase dự phòng cũng lỗi: \(loiSupabase.localizedDescription)"
                                    )))
                                }
                            }
                        }
                    }
                }
            } else if cauHinh.kho == .googleDrive && cauHinh.driveTrucTiepDaSanSang {
                self.taiLenDriveTrucTiep(jpeg, loai: loai, ngay: ngay, cauHinh: cauHinh) { ketQua in
                    switch ketQua {
                    case .success(let url):
                        DichVuDongBo.dungChung.luuAnhBaoCaoBot(loai: loai, ngay: ngay, urlDrive: url) { kq in
                            hoanTat?(kq.map { "Google Drive (API trực tiếp)" })
                        }
                    case .failure:
                        if cauHinh.driveAppsScriptDaSanSang {
                            self.taiLenDrive(jpeg, loai: loai, ngay: ngay, cauHinh: cauHinh) { kqScript in
                                switch kqScript {
                                case .success(let url):
                                    DichVuDongBo.dungChung.luuAnhBaoCaoBot(loai: loai, ngay: ngay, urlDrive: url) { kq in
                                        hoanTat?(kq.map { "Google Drive" })
                                    }
                                case .failure:
                                    self.taiLenSupabase(jpeg, loai: loai, ngay: ngay, hoanTat: hoanTat)
                                }
                            }
                        } else {
                            self.taiLenSupabase(jpeg, loai: loai, ngay: ngay, hoanTat: hoanTat)
                        }
                    }
                }
            } else if cauHinh.kho == .googleDrive && cauHinh.driveAppsScriptDaSanSang {
                self.taiLenDrive(jpeg, loai: loai, ngay: ngay, cauHinh: cauHinh) { ketQua in
                    switch ketQua {
                    case .success(let url):
                        DichVuDongBo.dungChung.luuAnhBaoCaoBot(loai: loai, ngay: ngay, urlDrive: url) { kq in
                            hoanTat?(kq.map { "Google Drive" })
                        }
                    case .failure:
                        // Drive lỗi không làm mất lịch gửi: tự lưu bản mới nhất sang Supabase.
                        self.taiLenSupabase(jpeg, loai: loai, ngay: ngay, hoanTat: hoanTat)
                    }
                }
            } else {
                self.taiLenSupabase(jpeg, loai: loai, ngay: ngay, hoanTat: hoanTat)
            }
        }
    }

    private func taiLenSupabase(
        _ jpeg: Data,
        loai: String,
        ngay: String,
        hoanTat: ((Result<String, Error>) -> Void)?
    ) {
        // Ưu tiên tải lên Cloudflare R2 (miễn phí 10GB + 0đ băng thông tải ra),
        // tự động dự phòng sang Supabase Storage nếu R2 chưa sẵn sàng.
        DichVuDongBo.dungChung.taiAnhLenCloudflareR2(jpeg: jpeg, loai: loai, ngay: ngay) { kqR2 in
            switch kqR2 {
            case .success:
                hoanTat?(.success("Cloudflare R2"))
            case .failure:
                DichVuDongBo.dungChung.taiAnhTrucTiepLenStorageSupabase(jpeg: jpeg, loai: loai, ngay: ngay) { kq in
                    hoanTat?(kq.map { "Supabase" })
                }
            }
        }
    }

    /// Tải ảnh nhị phân trực tiếp lên ImgBB qua API Key (không cần qua Apps Script, tốc độ 0.3-0.6s/ảnh)
    private func taiLenImgBB(
        _ jpeg: Data,
        loai: String,
        ngay: String,
        apiKey: String,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        let keySach = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard var comp = URLComponents(string: "https://api.imgbb.com/1/upload") else {
            hoanTat(.failure(NSError.dmx("URL ImgBB không hợp lệ.")))
            return
        }
        comp.queryItems = [
            URLQueryItem(name: "key", value: keySach),
            URLQueryItem(name: "name", value: "dmx-\(loai)-\(ngay)")
        ]
        guard let url = comp.url else {
            hoanTat(.failure(NSError.dmx("API Key ImgBB không hợp lệ.")))
            return
        }

        let ranhGioi = "Boundary-\(UUID().uuidString)"
        var body = Data()
        body.append("--\(ranhGioi)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"dmx-\(loai)-\(ngay).jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(jpeg)
        body.append("\r\n--\(ranhGioi)--\r\n".data(using: .utf8)!)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("multipart/form-data; boundary=\(ranhGioi)", forHTTPHeaderField: "Content-Type")
        request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")

        phienMang.dataTask(with: request) { data, response, error in
            if let error {
                hoanTat(.failure(NSError.dmx("Không kết nối được ImgBB: \(error.localizedDescription)")))
                return
            }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard let data, !data.isEmpty else {
                hoanTat(.failure(NSError.dmx("ImgBB không trả về dữ liệu (HTTP \(status)).")))
                return
            }

            let kq: PhanHoiImgBB
            do {
                kq = try JSONDecoder().decode(PhanHoiImgBB.self, from: data)
            } catch {
                let noiDung = String(data: data, encoding: .utf8)?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .prefix(300) ?? ""
                let chiTiet = noiDung.isEmpty ? error.localizedDescription : String(noiDung)
                hoanTat(.failure(NSError.dmx("ImgBB trả về phản hồi không hợp lệ (HTTP \(status)): \(chiTiet)")))
                return
            }

            guard (200..<300).contains(status), kq.success == true else {
                var cacChiTiet: [String] = []
                if let ma = kq.error?.code { cacChiTiet.append("mã \(ma)") }
                if let message = kq.error?.message?.trimmingCharacters(in: .whitespacesAndNewlines), !message.isEmpty {
                    cacChiTiet.append(message)
                }
                if let statusText = kq.status_txt?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !statusText.isEmpty,
                   !cacChiTiet.contains(statusText) {
                    cacChiTiet.append(statusText)
                }
                let maHTTP = status > 0 ? status : (kq.status_code ?? kq.status ?? 0)
                let noiDung = cacChiTiet.isEmpty ? "ImgBB từ chối yêu cầu nhưng không cung cấp chi tiết" : cacChiTiet.joined(separator: " — ")
                hoanTat(.failure(NSError.dmx("\(noiDung) (HTTP \(maHTTP)).")))
                return
            }

            guard let urlAnh = kq.data?.url ?? kq.data?.display_url,
                  URL(string: urlAnh)?.scheme == "https" else {
                hoanTat(.failure(NSError.dmx("ImgBB báo thành công nhưng không trả về URL ảnh HTTPS (HTTP \(status)).")))
                return
            }
            hoanTat(.success(urlAnh))
        }.resume()
    }

    /// Tải ảnh nhị phân trực tiếp lên Google Drive REST API v3 (bỏ qua trung gian Google Apps Script)
    private func taiLenDriveTrucTiep(
        _ jpeg: Data,
        loai: String,
        ngay: String,
        cauHinh: CauHinhKhoAnhBaoCaoBot,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        layAccessTokenGoogleDrive(cauHinh: cauHinh) { [weak self] ketQuaToken in
            guard let self else { return }
            switch ketQuaToken {
            case .failure(let loi):
                hoanTat(.failure(loi))
            case .success(let accessToken):
                guard let urlUpload = URL(string: "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&fields=id") else {
                    hoanTat(.failure(NSError.dmx("URL Google Drive API không hợp lệ.")))
                    return
                }
                let ranhGioi = "Boundary-\(UUID().uuidString)"
                var meta: [String: Any] = [
                    "name": "dmx-\(loai)-\(ngay).jpg",
                    "mimeType": "image/jpeg"
                ]
                let folder = cauHinh.folderId.trimmingCharacters(in: .whitespacesAndNewlines)
                if !folder.isEmpty {
                    meta["parents"] = [folder]
                }
                let metaData = (try? JSONSerialization.data(withJSONObject: meta)) ?? Data("{}".utf8)

                var body = Data()
                body.append("--\(ranhGioi)\r\n".data(using: .utf8)!)
                body.append("Content-Type: application/json; charset=UTF-8\r\n\r\n".data(using: .utf8)!)
                body.append(metaData)
                body.append("\r\n--\(ranhGioi)\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(jpeg)
                body.append("\r\n--\(ranhGioi)--\r\n".data(using: .utf8)!)

                var request = URLRequest(url: urlUpload)
                request.httpMethod = "POST"
                request.httpBody = body
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                request.setValue("multipart/related; boundary=\(ranhGioi)", forHTTPHeaderField: "Content-Type")
                request.setValue(String(body.count), forHTTPHeaderField: "Content-Length")

                self.phienMang.dataTask(with: request) { data, response, error in
                    if let error { hoanTat(.failure(error)); return }
                    let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                    guard (200..<300).contains(status), let data,
                          let file = try? JSONDecoder().decode(PhanHoiDriveFileAPI.self, from: data),
                          let fileId = file.id, !fileId.isEmpty else {
                        hoanTat(.failure(NSError.dmx("Google Drive API từ chối tải ảnh (HTTP \(status)).")))
                        return
                    }
                    // Mở quyền xem công khai để LINE Bot tải được ảnh
                    if let urlPerm = URL(string: "https://www.googleapis.com/drive/v3/files/\(fileId)/permissions") {
                        var reqPerm = URLRequest(url: urlPerm)
                        reqPerm.httpMethod = "POST"
                        reqPerm.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                        reqPerm.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        reqPerm.httpBody = Data("{\"role\":\"reader\",\"type\":\"anyone\"}".utf8)
                        self.phienMang.dataTask(with: reqPerm) { _, _, _ in
                            let urlCongKhai = "https://lh3.googleusercontent.com/d/\(fileId)=w2000"
                            hoanTat(.success(urlCongKhai))
                        }.resume()
                    } else {
                        let urlCongKhai = "https://lh3.googleusercontent.com/d/\(fileId)=w2000"
                        hoanTat(.success(urlCongKhai))
                    }
                }.resume()
            }
        }
    }

    private func layAccessTokenGoogleDrive(
        cauHinh: CauHinhKhoAnhBaoCaoBot,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        let tokenNhap = cauHinh.driveRefreshToken.trimmingCharacters(in: .whitespacesAndNewlines)
        if tokenNhap.hasPrefix("ya29.") {
            hoanTat(.success(tokenNhap))
            return
        }
        if !accessTokenDriveTam.isEmpty && Date() < hanAccessTokenDrive {
            hoanTat(.success(accessTokenDriveTam))
            return
        }
        let clientId = cauHinh.driveClientId.trimmingCharacters(in: .whitespacesAndNewlines)
        let clientSecret = cauHinh.driveClientSecret.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clientId.isEmpty, !clientSecret.isEmpty, !tokenNhap.isEmpty,
              let url = URL(string: "https://oauth2.googleapis.com/token") else {
            hoanTat(.failure(NSError.dmx("Thiếu Client ID, Client Secret hoặc Refresh Token của Google Drive API.")))
            return
        }

        var comp = URLComponents()
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "refresh_token", value: tokenNhap),
            URLQueryItem(name: "grant_type", value: "refresh_token")
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = comp.percentEncodedQuery?.data(using: .utf8)

        phienMang.dataTask(with: request) { [weak self] data, response, error in
            if let error { hoanTat(.failure(error)); return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status), let data,
                  let kq = try? JSONDecoder().decode(PhanHoiTokenGoogle.self, from: data),
                  let tokenMoi = kq.access_token, !tokenMoi.isEmpty else {
                hoanTat(.failure(NSError.dmx("Không lấy được Access Token từ Google OAuth2 (HTTP \(status)).")))
                return
            }
            self?.accessTokenDriveTam = tokenMoi
            self?.hanAccessTokenDrive = Date().addingTimeInterval(max(60, (kq.expires_in ?? 3500) - 120))
            hoanTat(.success(tokenMoi))
        }.resume()
    }

    private func taiLenDrive(
        _ jpeg: Data,
        loai: String,
        ngay: String,
        cauHinh: CauHinhKhoAnhBaoCaoBot,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: cauHinh.urlAppsScript) else {
            hoanTat(.failure(NSError.dmx("URL Apps Script không hợp lệ.")))
            return
        }
        let payload: [String: Any] = [
            "key": cauHinh.khoaBiMat,
            "folderId": cauHinh.folderId,
            "fileName": "dmx-\(loai)-\(ngay).jpg",
            "mimeType": "image/jpeg",
            "base64": jpeg.base64EncodedString()
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: payload) else {
            hoanTat(.failure(NSError.dmx("Không đóng gói được ảnh Drive.")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        phienMang.dataTask(with: request) { data, response, error in
            if let error { hoanTat(.failure(error)); return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200..<300).contains(status), let data,
                  let kq = try? JSONDecoder().decode(PhanHoiGoogleDrive.self, from: data),
                  kq.ok == true, let urlAnh = kq.url,
                  URL(string: urlAnh)?.scheme == "https" else {
                hoanTat(.failure(NSError.dmx("Google Drive từ chối ảnh hoặc chưa chia sẻ ảnh công khai.")))
                return
            }
            hoanTat(.success(urlAnh))
        }.resume()
    }

    private func duLieuJPEGToiUu(_ anh: UIImage) -> Data? {
        let gioiHan = 2_900_000
        let rong = max(1, anh.size.width)
        let cao = max(1, anh.size.height)
        let gioiHanDiemAnh: CGFloat = 6_000_000
        let tiLeTheoRong = min(1, 1_400 / rong)
        let tiLeTheoDiemAnh = min(1, sqrt(gioiHanDiemAnh / (rong * cao)))
        var anhDangNen = thuNho(anh, tiLe: min(tiLeTheoRong, tiLeTheoDiemAnh))

        // Chỉ mã hóa vài lần có tính toán. Cách cũ có thể mã hóa hơn 100 lần
        // đối với ảnh thứ 8 rất dài, khiến người dùng tưởng mạng tải chậm.
        let cacChatLuong: [CGFloat] = [0.82, 0.66, 0.50, 0.36]
        var nhoNhat: Data?
        for _ in 0..<4 {
            for chatLuong in cacChatLuong {
                guard let data = anhDangNen.jpegData(compressionQuality: chatLuong) else { continue }
                if nhoNhat == nil || data.count < nhoNhat!.count { nhoNhat = data }
                if data.count <= gioiHan { return data }
            }

            guard let nhoNhat else { return nil }
            let tiLeDuKien = sqrt(CGFloat(gioiHan) / CGFloat(max(1, nhoNhat.count))) * 0.90
            let tiLeThuNho = min(0.82, max(0.45, tiLeDuKien))
            anhDangNen = thuNho(anhDangNen, tiLe: tiLeThuNho)
        }

        return nhoNhat.flatMap { $0.count <= gioiHan ? $0 : nil }
    }

    private func thuNho(_ anh: UIImage, rongToiDa: CGFloat) -> UIImage {
        guard anh.size.width > rongToiDa else { return anh }
        return thuNho(anh, tiLe: rongToiDa / anh.size.width)
    }

    private func thuNho(_ anh: UIImage, tiLe: CGFloat) -> UIImage {
        guard tiLe < 0.999 else { return anh }
        let kichThuoc = CGSize(
            width: max(1, anh.size.width * tiLe),
            height: max(1, anh.size.height * tiLe)
        )
        return UIGraphicsImageRenderer(size: kichThuoc).image { _ in
            anh.draw(in: CGRect(origin: .zero, size: kichThuoc))
        }
    }

    private func luuCauHinh(_ value: CauHinhKhoAnhBaoCaoBot) {
        accessTokenDriveTam = ""
        hanAccessTokenDrive = .distantPast
        guard let data = try? JSONEncoder().encode(value) else { return }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: khoaKeychain]
        SecItemDelete(query as CFDictionary)
        var them = query
        them[kSecValueData as String] = data
        SecItemAdd(them as CFDictionary, nil)
    }

    private func docCauHinh() -> CauHinhKhoAnhBaoCaoBot? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: khoaKeychain,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else { return nil }
        return try? JSONDecoder().decode(CauHinhKhoAnhBaoCaoBot.self, from: data)
    }
}
