import UIKit
import Vision
import ImageIO

struct KetQuaQuetThiDua {
    var danhSach: [DongThiDua]
    var capNhatLuc: String
    var thongTinDonVi: String
    var nguonPhanTich: String
    var canhBao: String?
}

final class DichVuDocAnh {
    static let dungChung = DichVuDocAnh()
    private init() {}

    private struct PhanTuVanBan {
        let chu: String
        let x: CGFloat      // 0 (trái) -> 1 (phải)
        let y: CGFloat      // 0 (đáy) -> 1 (đỉnh) theo Vision, ta đổi sang 0 (đỉnh) -> 1 (đáy)
        let rong: CGFloat
        let cao: CGFloat
    }

    private struct KetQuaOCRAnh {
        let chiSoAnh: Int
        let vanBanThuan: String
        let danhSachPhanTu: [PhanTuVanBan]
        let dongThiDuaOffline: [DongThiDua]
        let capNhatLuc: String?
        let thongTinDonVi: String?
    }

    // MARK: - Quét danh sách ảnh chụp màn hình Thi Đua

    func quetAnhThiDua(
        danhSachAnh: [UIImage],
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (Result<KetQuaQuetThiDua, Error>) -> Void
    ) {
        guard !danhSachAnh.isEmpty else {
            hoanTat(.failure(taoLoi("Chưa có ảnh nào được chọn.")))
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            var ketQuaOCR: [KetQuaOCRAnh] = []

            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh("Đang quét chữ (Apple Vision) ảnh \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let ocr = self.thucHienOCR(anh: anh, chiSo: chiSo)
                ketQuaOCR.append(ocr)
            }

            // Tổng hợp kết quả từ bộ phân tích Offline trước để làm cơ sở / dự phòng
            var dsOffline: [DongThiDua] = []
            var capNhatOffline = ""
            var donViOffline = ""

            for ocr in ketQuaOCR {
                dsOffline = KhoDuLieu.gopDanhSachThiDua(cu: dsOffline, moi: ocr.dongThiDuaOffline)
                if capNhatOffline.isEmpty, let cn = ocr.capNhatLuc, !cn.isEmpty {
                    capNhatOffline = cn
                }
                if donViOffline.isEmpty, let dv = ocr.thongTinDonVi, !dv.isEmpty {
                    donViOffline = dv
                }
            }

            let caiDat = KhoDuLieu.dungChung.caiDat
            let apiKey = caiDat.geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines)

            // Nếu chưa nhập Gemini API Key -> trả về kết quả từ Apple Vision OCR + Bộ phân tích DMX nội bộ
            if apiKey.isEmpty {
                let ketQua = KetQuaQuetThiDua(
                    danhSach: dsOffline,
                    capNhatLuc: capNhatOffline.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : capNhatOffline,
                    thongTinDonVi: donViOffline,
                    nguonPhanTich: "Apple Vision OCR (Offline)",
                    canhBao: dsOffline.isEmpty
                        ? "Chưa trích xuất được bảng. Hãy vào Cài đặt (⚙️) nhập Gemini API Key miễn phí để đọc chính xác mọi định dạng ảnh."
                        : "Đã đọc bằng Apple Vision trên máy. Bạn có thể nhập thêm Gemini API Key trong Cài đặt (⚙️) để AI hỗ trợ chuẩn hóa tối đa."
                )
                DispatchQueue.main.async {
                    hoanTat(.success(ketQua))
                }
                return
            }

            // Có Gemini API Key -> Gọi Gemini kết hợp OCR Text + Ảnh
            DispatchQueue.main.async {
                tienTrinh("Đang phân tích bảng số liệu bằng Gemini AI...")
            }

            self.goiGeminiPhanTich(
                danhSachAnh: danhSachAnh,
                ketQuaOCR: ketQuaOCR,
                apiKey: apiKey,
                model: caiDat.geminiModel,
                guiKemAnh: caiDat.guiKemAnhChoGemini
            ) { ketQuaGemini in
                switch ketQuaGemini {
                case .success(var kq):
                    // Nếu Gemini sót dòng nào mà Offline bắt được đầy đủ, gộp bổ sung an toàn
                    if kq.danhSach.isEmpty && !dsOffline.isEmpty {
                        kq.danhSach = dsOffline
                    }
                    if kq.capNhatLuc.isEmpty {
                        kq.capNhatLuc = capNhatOffline.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : capNhatOffline
                    }
                    if kq.thongTinDonVi.isEmpty {
                        kq.thongTinDonVi = donViOffline
                    }
                    DispatchQueue.main.async {
                        hoanTat(.success(kq))
                    }
                case .failure(let loiGemini):
                    // Nếu Gemini lỗi (hết hạn mức, mất mạng, sai key), tự động dùng kết quả Apple Vision Offline nếu có
                    if !dsOffline.isEmpty {
                        let duPhong = KetQuaQuetThiDua(
                            danhSach: dsOffline,
                            capNhatLuc: capNhatOffline.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : capNhatOffline,
                            thongTinDonVi: donViOffline,
                            nguonPhanTich: "Apple Vision OCR (Dự phòng khi lỗi Gemini)",
                            canhBao: "Lưu ý Gemini: \(loiGemini.localizedDescription). Đã tự động dùng bộ đọc Apple Vision trên máy."
                        )
                        DispatchQueue.main.async {
                            hoanTat(.success(duPhong))
                        }
                    } else {
                        DispatchQueue.main.async {
                            hoanTat(.failure(loiGemini))
                        }
                    }
                }
            }
        }
    }

    // MARK: - Kiểm tra kết nối Gemini API Key

    func kiemTraKetNoiKey(
        apiKey: String,
        model: String,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        let keySach = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keySach.isEmpty else {
            hoanTat(.failure(taoLoi("Vui lòng nhập API Key trước khi kiểm tra.")))
            return
        }

        let tenModel = model.isEmpty ? "gemini-2.5-flash" : model
        let chuoiURL = "https://generativelanguage.googleapis.com/v1beta/models/\(tenModel):generateContent?key=\(keySach)"
        guard let url = URL(string: chuoiURL) else {
            hoanTat(.failure(taoLoi("URL không hợp lệ.")))
            return
        }

        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": "Trả lời ngắn gọn: OK"]
                    ]
                ]
            ],
            "generationConfig": [
                "maxOutputTokens": 20
            ]
        ]

        var yeuCau = URLRequest(url: url)
        yeuCau.httpMethod = "POST"
        yeuCau.setValue("application/json", forHTTPHeaderField: "Content-Type")
        yeuCau.timeoutInterval = 20
        yeuCau.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: yeuCau) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    hoanTat(.failure(self.taoLoi("Lỗi mạng: \(error.localizedDescription)")))
                }
                return
            }

            let maHTTP = (response as? HTTPURLResponse)?.statusCode ?? 0
            if (200...299).contains(maHTTP) {
                DispatchQueue.main.async {
                    hoanTat(.success("Kết nối thành công với model \(tenModel)! Key hoạt động tốt và hỗ trợ đọc ảnh + văn bản."))
                }
            } else {
                var thongBaoLoi = "Mã lỗi HTTP \(maHTTP)"
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errObj = json["error"] as? [String: Any],
                   let msg = errObj["message"] as? String {
                    thongBaoLoi = msg
                }
                DispatchQueue.main.async {
                    hoanTat(.failure(self.taoLoi("Không thể kết nối: \(thongBaoLoi)")))
                }
            }
        }.resume()
    }

    // MARK: - Bước 1: Apple Vision OCR trên iPhone

    private func thucHienOCR(anh: UIImage, chiSo: Int) -> KetQuaOCRAnh {
        guard let cgImage = anh.cgImage else {
            return KetQuaOCRAnh(chiSoAnh: chiSo, vanBanThuan: "", danhSachPhanTu: [], dongThiDuaOffline: [], capNhatLuc: nil, thongTinDonVi: nil)
        }

        var phanTu: [PhanTuVanBan] = []
        let yeuCau = VNRecognizeTextRequest { request, _ in
            guard let ketQua = request.results as? [VNRecognizedTextObservation] else { return }
            for obs in ketQua {
                guard let ungVien = obs.topCandidates(1).first else { continue }
                let chu = ungVien.string.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !chu.isEmpty else { continue }
                let box = obs.boundingBox
                // Đổi trục Y từ gốc dưới-trái của Vision sang gốc trên-trái (0 ở đỉnh ảnh, 1 ở đáy ảnh)
                let yTrenXuong = 1.0 - box.origin.y - box.size.height
                phanTu.append(
                    PhanTuVanBan(
                        chu: chu,
                        x: box.origin.x,
                        y: yTrenXuong,
                        rong: box.size.width,
                        cao: box.size.height
                    )
                )
            }
        }

        yeuCau.recognitionLevel = .accurate
        yeuCau.usesLanguageCorrection = true
        yeuCau.recognitionLanguages = ["vi-VN", "en-US"]

        let xuLy = VNImageRequestHandler(cgImage: cgImage, orientation: anh.cgImageOrientation, options: [:])
        try? xuLy.perform([yeuCau])

        // Gom các phần tử theo từng dòng ngang (cùng độ cao y tương đối)
        let sapXepY = phanTu.sorted {
            if abs($0.y - $1.y) < 0.012 {
                return $0.x < $1.x
            }
            return $0.y < $1.y
        }

        var cacHang: [[PhanTuVanBan]] = []
        for pt in sapXepY {
            if var hangCuoi = cacHang.last,
               let mau = hangCuoi.first,
               abs(pt.y - mau.y) < 0.014 {
                hangCuoi.append(pt)
                cacHang[cacHang.count - 1] = hangCuoi.sorted { $0.x < $1.x }
            } else {
                cacHang.append([pt])
            }
        }

        var cacDongVanBan: [String] = []
        for hang in cacHang {
            let chuoiHang = hang.map { p in
                let cot = Int((p.x * 100).rounded())
                return "[x=\(cot)%]\(p.chu)"
            }.joined(separator: " | ")
            cacDongVanBan.append(chuoiHang)
        }

        let vanBanThuan = cacDongVanBan.joined(separator: "\n")
        let (dsOffline, capNhat, donVi) = phanTichThiDuaOffline(phanTu: phanTu)

        return KetQuaOCRAnh(
            chiSoAnh: chiSo,
            vanBanThuan: vanBanThuan,
            danhSachPhanTu: phanTu,
            dongThiDuaOffline: dsOffline,
            capNhatLuc: capNhat,
            thongTinDonVi: donVi
        )
    }

    // MARK: - Bước 2: Bộ phân tích bố cục Thi Đua ĐMX trực tiếp trên máy (Offline Parser)

    private func phanTichThiDuaOffline(phanTu: [PhanTuVanBan]) -> ([DongThiDua], String?, String?) {
        var capNhatLuc: String?
        var thongTinDonVi: String?
        var maNhanVienWatermark: String?

        // Tìm thông tin chung & mã nhân viên in chìm (watermark) để loại bỏ nhiễu
        for pt in phanTu {
            if pt.chu.localizedCaseInsensitiveContains("Cập nhật lúc") || pt.chu.range(of: "\\d{2}:\\d{2}:\\d{2}", options: .regularExpression) != nil {
                if capNhatLuc == nil {
                    capNhatLuc = pt.chu.replacingOccurrences(of: "Cập nhật lúc:", with: "").trimmingCharacters(in: .whitespaces)
                } else if !capNhatLuc!.contains(pt.chu) {
                    capNhatLuc = "\(capNhatLuc!) \(pt.chu)"
                }
            }
            if pt.chu.contains(" - "), pt.y < 0.16, pt.chu.first?.isNumber == true {
                let tach = pt.chu.components(separatedBy: " - ")
                if let ma = tach.first?.trimmingCharacters(in: .whitespaces), ma.count >= 4 {
                    maNhanVienWatermark = ma
                }
            }
            if pt.chu.hasPrefix("ĐML_") || pt.chu.hasPrefix("ĐMX_") || pt.chu.hasPrefix("TGDĐ_") {
                if thongTinDonVi == nil {
                    thongTinDonVi = pt.chu
                }
            }
        }

        // Tìm tất cả các mốc tiêu đề khối chương trình dựa trên chữ "SỐ LƯỢNG" hoặc "DOANH THU" ở cột thứ 2 (0.22 <= x <= 0.52)
        let mocChiTieu = phanTu.filter { pt in
            let inHoa = pt.chu.uppercased()
            let laChiTieu = inHoa.contains("SỐ LƯỢNG") || inHoa.contains("SO LUONG") || inHoa.contains("DOANH THU")
            return laChiTieu && pt.x >= 0.22 && pt.x <= 0.55 && pt.y > 0.12
        }.sorted { $0.y < $1.y }

        var ketQua: [DongThiDua] = []

        for (chiSo, moc) in mocChiTieu.enumerated() {
            let yTieuDe = moc.y
            let yGioiHanDuoi: CGFloat = (chiSo + 1 < mocChiTieu.count) ? mocChiTieu[chiSo + 1].y - 0.015 : 0.98

            let loai: LoaiChiTieuThiDua = moc.chu.uppercased().contains("DOANH") ? .doanhThu : .soLuong

            // 1. Lấy tên ngành hàng / chương trình ở góc trái (x < 0.31) ngang hàng với tiêu đề khối
            let phanTuTen = phanTu.filter { pt in
                pt.x < 0.31 && abs(pt.y - yTieuDe) < 0.042 && !laChuoiRac(pt.chu, watermark: maNhanVienWatermark)
            }.sorted { $0.y < $1.y }

            let tenNganhHang = phanTuTen
                .map { $0.chu }
                .joined(separator: " ")
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !tenNganhHang.isEmpty else { continue }

            // 2. Tìm các dòng số liệu bên dưới tiêu đề này (ưu tiên dòng TỔNG hoặc dòng siêu thị)
            let vungDuLieu = phanTu.filter { pt in
                pt.y > yTieuDe + 0.015 && pt.y < min(yGioiHanDuoi, yTieuDe + 0.14) && pt.x >= 0.28
            }

            // Lọc các con số theo từng cột X:
            // Cột Thực hiện: x khoảng 0.28 ..< 0.50
            // Cột Target: x khoảng 0.50 ..< 0.69
            // Cột % HT Tháng: x khoảng 0.69 ..< 0.84
            // Cột % Dự báo: x >= 0.84
            let soThucHien = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.28 && $0.x < 0.50 }, watermark: maNhanVienWatermark)
            let soTarget = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.50 && $0.x < 0.69 }, watermark: maNhanVienWatermark)
            let soHT = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.69 && $0.x < 0.84 }, watermark: maNhanVienWatermark)
            let soDuBao = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.84 }, watermark: maNhanVienWatermark)

            // Nếu khối ở sát đáy màn hình bị cắt mất phần số liệu -> bỏ qua để lấy ở ảnh tiếp theo
            guard let thucHien = soThucHien, let target = soTarget else { continue }

            let dong = DongThiDua(
                tenNganhHang: tenNganhHang,
                loaiChiTieu: loai,
                thucHien: thucHien,
                target: target,
                phanTramHTGoc: soHT,
                phanTramDuBaoGoc: soDuBao
            )
            ketQua = KhoDuLieu.gopDanhSachThiDua(cu: ketQua, moi: [dong])
        }

        return (ketQua, capNhatLuc, thongTinDonVi)
    }

    private func laChuoiRac(_ chu: String, watermark: String?) -> Bool {
        let inHoa = chu.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if inHoa == "TỔNG" || inHoa == "TONG" || inHoa == "TARGET" || inHoa.contains("% HT") || inHoa.contains("DỰ BÁO") {
            return true
        }
        if let wm = watermark, inHoa.contains(wm) {
            return true
        }
        return false
    }

    private func timGiaTriSo(trong danhSach: [PhanTuVanBan], watermark: String?) -> Double? {
        let sapXep = danhSach.sorted { $0.y < $1.y }
        for pt in sapXep {
            let chu = pt.chu.trimmingCharacters(in: .whitespacesAndNewlines)
            if let wm = watermark, chu == wm { continue }
            if let so = chuyenChuoiThanhSo(chu) {
                return so
            }
        }
        return nil
    }

    private func chuyenChuoiThanhSo(_ chuoi: String) -> Double? {
        // Loại bỏ ký tự %, dấu ... ở cuối (ví dụ "26.5...", "4,476.28", "74%")
        var sach = chuoi
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "…", with: "")
            .replacingOccurrences(of: "...", with: "")
            .replacingOccurrences(of: "..", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Loại bỏ dấu phẩy ngăn cách hàng nghìn (ví dụ 4,476.28 -> 4476.28)
        sach = sach.replacingOccurrences(of: ",", with: "")

        guard !sach.isEmpty else { return nil }
        // Chỉ nhận chuỗi thực sự là số hợp lệ
        if sach.range(of: "^-?\\d+(\\.\\d+)?$", options: .regularExpression) != nil {
            return Double(sach)
        }
        return nil
    }

    // MARK: - Bước 3: Gọi Gemini API (Google AI Studio Free Key)

    private func goiGeminiPhanTich(
        danhSachAnh: [UIImage],
        ketQuaOCR: [KetQuaOCRAnh],
        apiKey: String,
        model: String,
        guiKemAnh: Bool,
        hoanTat: @escaping (Result<KetQuaQuetThiDua, Error>) -> Void
    ) {
        let tenModel = model.isEmpty ? "gemini-2.5-flash" : model
        let chuoiURL = "https://generativelanguage.googleapis.com/v1beta/models/\(tenModel):generateContent?key=\(apiKey)"
        guard let url = URL(string: chuoiURL) else {
            hoanTat(.failure(taoLoi("URL Gemini API không hợp lệ.")))
            return
        }

        // Xây dựng nội dung OCR từ tất cả các ảnh chụp màn hình
        var vanBanTongHop = ""
        for ocr in ketQuaOCR {
            vanBanTongHop += "\n--- ẢNH CHỤP MÀN HÌNH SỐ \(ocr.chiSoAnh + 1) ---\n"
            vanBanTongHop += ocr.vanBanThuan
        }

        let huongDan = """
        Bạn là trợ lý phân tích dữ liệu báo cáo Thi Đua của Điện Máy Xanh (ĐMX).
        Người dùng đã chụp \(danhSachAnh.count) ảnh màn hình mục "Thi đua" (có thể cuộn trang qua nhiều ảnh).
        Mỗi chương trình thi đua là một bảng nhỏ gồm:
        - Cột 1 (Trái): Tên chương trình / Ngành hàng (ví dụ: "T10 - Máy Lạnh", "T09 - T10 IPHONE 18 series, iPhone Duo", "T10 - Bảo Hiểm Tổng"...).
        - Cột 2: Tiêu đề là "SỐ LƯỢNG" hoặc "DOANH THU", bên dưới là con số Thực hiện (dòng TỔNG hoặc dòng siêu thị).
        - Cột 3: Tiêu đề là "TARGET", bên dưới là con số Mục tiêu (Target).
        - Cột 4: Tiêu đề là "% HT THÁNG", bên dưới là tỷ lệ hoàn thành tháng.
        - Cột 5: Tiêu đề là "% DỰ BÁO", bên dưới là tỷ lệ dự báo.

        Lưu ý quan trọng:
        1. Bỏ qua các chữ in chìm (watermark) chéo trên nền như mã nhân viên (ví dụ "54453") và tên nhân viên.
        2. Nếu một chương trình ở cuối ảnh bị cắt khuất dòng số liệu, chỉ lấy khi có số liệu Thực hiện & Target đầy đủ (hoặc gộp với ảnh tiếp theo).
        3. Khử trùng lặp nếu cùng một chương trình xuất hiện ở nhiều ảnh chụp cuộn trang, giữ đúng thứ tự xuất hiện.
        4. Dấu phẩy trong số (ví dụ 4,476.28) là dấu phân cách hàng nghìn -> trả về số thực 4476.28.

        Dữ liệu OCR đọc từ Apple Vision trên thiết bị (kèm tọa độ ngang x%):
        \(vanBanTongHop)

        Hãy trả về ĐÚNG định dạng JSON sau (không kèm markdown):
        {
          "capNhatLuc": "thời gian cập nhật trên ảnh nếu có",
          "thongTinDonVi": "tên siêu thị hoặc đơn vị nếu có (ví dụ ĐML_QNG_QNG - 275 Quang Trung)",
          "danhSach": [
            {
              "tenNganhHang": "Tên chương trình thi đua",
              "loaiChiTieu": "SL" hoặc "DT" ("SL" nếu cột 2 là SỐ LƯỢNG, "DT" nếu cột 2 là DOANH THU),
              "thucHien": 39.0,
              "target": 147.0,
              "phanTramHT": 26.53,
              "phanTramDuBao": 28.4
            }
          ]
        }
        """

        var parts: [[String: Any]] = [
            ["text": huongDan]
        ]

        // Đính kèm ảnh nén nhẹ (tối đa 6 ảnh đầu tiên để đảm bảo tốc độ và giới hạn dung lượng request)
        if guiKemAnh {
            for anh in danhSachAnh.prefix(6) {
                if let jpegData = nenAnhChoGemini(anh: anh, kichThuocToiDa: 1280) {
                    parts.append([
                        "inline_data": [
                            "mime_type": "image/jpeg",
                            "data": jpegData.base64EncodedString()
                        ]
                    ])
                }
            }
        }

        let body: [String: Any] = [
            "contents": [
                ["parts": parts]
            ],
            "generationConfig": [
                "temperature": 0.1,
                "responseMimeType": "application/json"
            ]
        ]

        var yeuCau = URLRequest(url: url)
        yeuCau.httpMethod = "POST"
        yeuCau.setValue("application/json", forHTTPHeaderField: "Content-Type")
        yeuCau.timeoutInterval = 45
        yeuCau.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: yeuCau) { data, response, error in
            if let error = error {
                hoanTat(.failure(self.taoLoi("Lỗi kết nối Gemini: \(error.localizedDescription)")))
                return
            }

            let maHTTP = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard (200...299).contains(maHTTP), let data = data else {
                var thongBao = "Lỗi HTTP \(maHTTP)"
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let errObj = json["error"] as? [String: Any],
                   let msg = errObj["message"] as? String {
                    thongBao = msg
                }
                hoanTat(.failure(self.taoLoi("Gemini API trả về lỗi: \(thongBao)")))
                return
            }

            do {
                let ketQua = try self.giaiMaPhanHoiGemini(data: data, tenModel: tenModel)
                hoanTat(.success(ketQua))
            } catch {
                hoanTat(.failure(error))
            }
        }.resume()
    }

    private func giaiMaPhanHoiGemini(data: Data, tenModel: String) throws -> KetQuaQuetThiDua {
        guard let goc = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = goc["candidates"] as? [[String: Any]],
              let dauTien = candidates.first,
              let content = dauTien["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            throw taoLoi("Phản hồi từ Gemini không đúng cấu trúc.")
        }

        let chuoiJSON = lamSachChuoiJSON(text)
        guard let jsonData = chuoiJSON.data(using: .utf8),
              let doiTuong = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw taoLoi("Không thể đọc JSON kết quả từ Gemini.")
        }

        let capNhatLuc = (doiTuong["capNhatLuc"] as? String) ?? ""
        let thongTinDonVi = (doiTuong["thongTinDonVi"] as? String) ?? ""
        let mangJSON = (doiTuong["danhSach"] as? [[String: Any]]) ?? []

        var danhSach: [DongThiDua] = []
        for muc in mangJSON {
            let ten = (muc["tenNganhHang"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !ten.isEmpty else { continue }

            let loaiChuoi = ((muc["loaiChiTieu"] as? String) ?? "DT").uppercased()
            let loai: LoaiChiTieuThiDua = (loaiChuoi.contains("SL") || loaiChuoi.contains("LƯỢNG")) ? .soLuong : .doanhThu

            let thucHien = docDouble(muc["thucHien"]) ?? 0
            let target = docDouble(muc["target"]) ?? 0
            let ptHT = docDouble(muc["phanTramHT"])
            let ptDuBao = docDouble(muc["phanTramDuBao"])

            let dong = DongThiDua(
                tenNganhHang: ten,
                loaiChiTieu: loai,
                thucHien: thucHien,
                target: target,
                phanTramHTGoc: ptHT,
                phanTramDuBaoGoc: ptDuBao
            )
            danhSach = KhoDuLieu.gopDanhSachThiDua(cu: danhSach, moi: [dong])
        }

        return KetQuaQuetThiDua(
            danhSach: danhSach,
            capNhatLuc: capNhatLuc,
            thongTinDonVi: thongTinDonVi,
            nguonPhanTich: "Apple Vision + Gemini (\(tenModel))",
            canhBao: nil
        )
    }

    private func docDouble(_ giaTri: Any?) -> Double? {
        if let so = giaTri as? Double { return so }
        if let soInt = giaTri as? Int { return Double(soInt) }
        if let soNS = giaTri as? NSNumber { return soNS.doubleValue }
        if let chuoi = giaTri as? String {
            return chuyenChuoiThanhSo(chuoi)
        }
        return nil
    }

    private func lamSachChuoiJSON(_ raw: String) -> String {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("```json") {
            s = String(s.dropFirst(7))
        } else if s.hasPrefix("```") {
            s = String(s.dropFirst(3))
        }
        if s.hasSuffix("```") {
            s = String(s.dropLast(3))
        }
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func nenAnhChoGemini(anh: UIImage, kichThuocToiDa: CGFloat) -> Data? {
        let kichThuoc = anh.size
        let canhLonNhat = max(kichThuoc.width, kichThuoc.height)
        if canhLonNhat <= kichThuocToiDa {
            return anh.jpegData(compressionQuality: 0.72)
        }
        let tyLe = kichThuocToiDa / canhLonNhat
        let kichThuocMoi = CGSize(width: floor(kichThuoc.width * tyLe), height: floor(kichThuoc.height * tyLe))
        let boVe = UIGraphicsImageRenderer(size: kichThuocMoi)
        let anhThuNho = boVe.image { _ in
            anh.draw(in: CGRect(origin: .zero, size: kichThuocMoi))
        }
        return anhThuNho.jpegData(compressionQuality: 0.72)
    }

    private func taoLoi(_ thongDiep: String) -> NSError {
        NSError(domain: "DichVuDocAnhDMX", code: -1, userInfo: [NSLocalizedDescriptionKey: thongDiep])
    }
}

private extension UIImage {
    var cgImageOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
