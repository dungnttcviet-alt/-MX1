import UIKit
import Vision
import ImageIO

struct KetQuaQuetThiDua {
    var danhSach: [DongThiDua]
    var capNhatLuc: String
    var thongTinDonVi: String
}

final class DichVuDocAnh {
    static let dungChung = DichVuDocAnh()
    private init() {}

    private struct PhanTuVanBan {
        let chu: String
        let x: CGFloat      // 0 (trái) -> 1 (phải)
        let y: CGFloat      // 0 (đỉnh) -> 1 (đáy)
        let rong: CGFloat
        let cao: CGFloat
    }

    // MARK: - 1. Quét danh sách ảnh chụp màn hình Thi Đua (Giữ nguyên thuật toán bản đầu tiên)

    func quetAnhThiDua(
        danhSachAnh: [UIImage],
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetThiDua) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var dsTongHop: [DongThiDua] = []
            var capNhatOffline = ""
            var donViOffline = ""

            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh("Đang quét chữ (Apple Vision) ảnh \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                let (dsAnh, cn, dv) = self.phanTichThiDuaOffline(phanTu: phanTu)
                dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: dsAnh)
                if capNhatOffline.isEmpty, let cn = cn, !cn.isEmpty {
                    capNhatOffline = cn
                }
                if donViOffline.isEmpty, let dv = dv, !dv.isEmpty {
                    donViOffline = dv
                }
            }

            let ketQua = KetQuaQuetThiDua(
                danhSach: dsTongHop,
                capNhatLuc: capNhatOffline.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : capNhatOffline,
                thongTinDonVi: donViOffline
            )
            DispatchQueue.main.async {
                hoanTat(ketQua)
            }
        }
    }

    // MARK: - 2. Quét danh sách ảnh chụp màn hình Doanh thu (Lũy kế DT thực & DT quy đổi)

    func quetAnhDoanhThu(
        danhSachAnh: [UIImage],
        tienTrinh: ((String) -> Void)? = nil,
        hoanTat: @escaping (ThongTinDoanhThu) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var ketQuaGop = ThongTinDoanhThu()
            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh?("Đang đọc ảnh Doanh thu \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                let kqAnh = self.phanTichDoanhThu(phanTu: phanTu)
                ketQuaGop = ketQuaGop.gop(voi: kqAnh)
            }
            DispatchQueue.main.async {
                hoanTat(ketQuaGop)
            }
        }
    }

    // MARK: - Bước 1: Apple Vision OCR trên iPhone (Nguyên bản phiên bản đầu tiên)

    private func thucHienOCR(anh: UIImage) -> [PhanTuVanBan] {
        guard let cgImage = anh.cgImage else { return [] }

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
        return phanTu
    }

    // MARK: - Bước 2: Bộ phân tích bố cục Thi Đua ĐMX (Nguyên bản phiên bản đầu tiên)

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
            if pt.y < 0.16, let range = pt.chu.range(of: "\\b\\d{4,7}(?=\\s*-)", options: .regularExpression) {
                maNhanVienWatermark = String(pt.chu[range])
            }
            if pt.chu.hasPrefix("ĐML_") || pt.chu.hasPrefix("ĐMX_") || pt.chu.hasPrefix("TGDĐ_") {
                if thongTinDonVi == nil {
                    thongTinDonVi = pt.chu
                }
            }
        }

        // Tìm tất cả các mốc tiêu đề khối chương trình dựa trên chữ "SỐ LƯỢNG" hoặc "DOANH THU" ở cột thứ 2 (0.22 <= x <= 0.55)
        let mocChiTieu = phanTu.filter { pt in
            let khongDau = pt.chu
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
                .replacingOccurrences(of: "đ", with: "d")
                .replacingOccurrences(of: "Đ", with: "D")
                .uppercased()
            let laChiTieu = khongDau.contains("SO LUONG") || khongDau.contains("DOANH THU")
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
                tenNganhHangGoc: tenNganhHang,
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
            if let wm = watermark, chu.contains(wm) { continue }
            if let so = chuyenChuoiThanhSo(chu, watermark: watermark) {
                return so
            }
        }
        return nil
    }

    private func chuyenChuoiThanhSo(_ chuoi: String, watermark: String? = nil) -> Double? {
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
        // Nếu cả chuỗi là số hợp lệ
        if sach.range(of: "^-?\\d+(\\.\\d+)?$", options: .regularExpression) != nil {
            if let wm = watermark, sach == wm { return nil }
            return Double(sach)
        }
        // Trường hợp chữ in chìm (ví dụ "Nguyễn Thanh 39") dính liền phía trước con số thực hiện
        if let range = sach.range(of: "-?\\d+(\\.\\d+)?$", options: .regularExpression) {
            let token = String(sach[range])
            if let wm = watermark, token == wm { return nil }
            return Double(token)
        }
        return nil
    }

    // MARK: - Phân tích ảnh chụp màn hình "Doanh thu hợp nhất" (Lũy kế DT thực & DT quy đổi)

    private func boDau(_ chuoi: String) -> String {
        chuoi
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .uppercased()
    }

    private func chuyenChuoiThanhSoDoanhThu(_ chuoi: String) -> Double? {
        var s = chuoi
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "…", with: "")
            .replacingOccurrences(of: "...", with: "")
            .replacingOccurrences(of: "+", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !s.isEmpty else { return nil }

        if s.contains(",") && s.contains(".") {
            let viTriPhay = s.lastIndex(of: ",")!
            let viTriCham = s.lastIndex(of: ".")!
            if viTriPhay > viTriCham {
                // Định dạng kiểu VN: 8.541,00 -> 8541.00
                s = s.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
            } else {
                // Định dạng kiểu US: 10,957.00 -> 10957.00
                s = s.replacingOccurrences(of: ",", with: "")
            }
        } else if s.contains(",") {
            // Nếu dấu phẩy ngăn cách hàng nghìn (ví dụ 10,957 hoặc 19,149)
            if s.range(of: "^-?\\d{1,3}(,\\d{3})+$", options: .regularExpression) != nil {
                s = s.replacingOccurrences(of: ",", with: "")
            } else {
                s = s.replacingOccurrences(of: ",", with: ".")
            }
        } else if s.contains(".") {
            // Nếu dấu chấm ngăn cách hàng nghìn (ví dụ 14.416)
            if s.range(of: "^-?\\d{1,3}(\\.\\d{3})+$", options: .regularExpression) != nil {
                s = s.replacingOccurrences(of: ".", with: "")
            }
        }

        if let range = s.range(of: "-?\\d+(\\.\\d+)?", options: .regularExpression) {
            return Double(String(s[range]))
        }
        return nil
    }

    private func trichCacSo(trong chuoi: String) -> [Double] {
        guard let regex = try? NSRegularExpression(pattern: "-?\\d+[\\d.,]*") else { return [] }
        let ns = chuoi as NSString
        let matches = regex.matches(in: chuoi, range: NSRange(location: 0, length: ns.length))
        return matches.compactMap { m in
            let sub = ns.substring(with: m.range)
            return chuyenChuoiThanhSoDoanhThu(sub)
        }
    }

    private func phanTichDoanhThu(phanTu: [PhanTuVanBan]) -> ThongTinDoanhThu {
        var kq = ThongTinDoanhThu()

        // 1. Tìm thanh "Quỹ thời gian: 29/31 ngày" & phần trăm tiến độ tháng
        var yBatDauVungThe: CGFloat = 0.44
        if let mocQTG = phanTu.first(where: {
            let u = boDau($0.chu)
            return u.contains("QUY THOI GIAN") || u.contains("TIEN DO THANG")
        }) {
            yBatDauVungThe = mocQTG.y + 0.02
            let cungHang = phanTu
                .filter { abs($0.y - mocQTG.y) < 0.035 }
                .sorted { $0.x < $1.x }
            let chuoiHang = cungHang.map { $0.chu }.joined(separator: " ")

            if let regex = try? NSRegularExpression(pattern: "(\\d{1,2})\\s*/\\s*(\\d{1,2})"),
               let m = regex.firstMatch(in: chuoiHang, range: NSRange(location: 0, length: (chuoiHang as NSString).length)) {
                let ns = chuoiHang as NSString
                let d1 = Int(ns.substring(with: m.range(at: 1))) ?? 0
                let d2 = Int(ns.substring(with: m.range(at: 2))) ?? 0
                if d1 > 0 && d2 > 0 {
                    kq.soNgayDaQua = d1
                    kq.tongSoNgay = d2
                }
            }
            if let ptPhanTram = cungHang.last(where: { $0.chu.contains("%") }),
               let val = chuyenChuoiThanhSoDoanhThu(ptPhanTram.chu) {
                kq.phanTramTienDoThang = val
            } else if kq.soNgayDaQua > 0 && kq.tongSoNgay > 0 {
                kq.phanTramTienDoThang = (Double(kq.soNgayDaQua) / Double(kq.tongSoNgay)) * 100.0
            }
        } else if let mocNut = phanTu.filter({
            let u = boDau($0.chu)
            return u.contains("XUAT EXCEL") || u.contains("XUAT THEO MAU") || u.contains("TOAN CONG TY")
        }).max(by: { $0.y < $1.y }) {
            yBatDauVungThe = mocNut.y + 0.03
        }

        // 2. Lọc vùng các thẻ chỉ số bên dưới thanh Quỹ thời gian (và trên thanh tab đáy)
        let vungThe = phanTu.filter { $0.y > yBatDauVungThe && $0.y < 0.94 }

        // Kiểm tra xem đây là ảnh "DT quy đổi" hay ảnh "DT thực"
        let laAnhQuyDoi = vungThe.contains { pt in
            let u = boDau(pt.chu)
            return u.contains("DT QUY DOI") || u.contains("KHOAN VAY") || u.contains("TRA GOP QD")
        }

        // Hàm lấy số chính và dòng phụ của 1 ô thẻ trong lưới 2 cột
        func layDuLieuThe(thoaMan: (String) -> Bool) -> (soChinh: Double?, vanBanPhu: String)? {
            guard let moc = vungThe.sorted(by: { $0.y < $1.y }).first(where: { thoaMan(boDau($0.chu)) }) else {
                return nil
            }
            let laCotTrai = moc.x < 0.47
            let trongThe = vungThe.filter { pt in
                let cungCot = laCotTrai ? (pt.x < 0.47) : (pt.x >= 0.47)
                return cungCot && pt.y > moc.y + 0.01 && pt.y < moc.y + 0.115
            }.sorted {
                if abs($0.y - $1.y) < 0.012 { return $0.x < $1.x }
                return $0.y < $1.y
            }

            var soChinh: Double?
            for pt in trongThe where pt.y < moc.y + 0.068 {
                let u = boDau(pt.chu)
                if u.contains("TRIEU DONG") || u.contains("TARGET") || u.contains("BILL") || u.contains("TRA GOP") {
                    continue
                }
                if let val = chuyenChuoiThanhSoDoanhThu(pt.chu) {
                    soChinh = val
                    break
                }
            }
            let vanBanPhu = trongThe.map { $0.chu }.joined(separator: " ")
            return (soChinh, vanBanPhu)
        }

        // 3A. Ô "DT thực"
        if !laAnhQuyDoi, let theDTThuc = layDuLieuThe(thoaMan: { $0 == "DT THUC" || ($0.contains("DT THUC") && !$0.contains("LUY KE")) }) {
            if let so = theDTThuc.soChinh { kq.doanhThuThuc = so }
        }

        // 3B. Ô "DT quy đổi"
        if laAnhQuyDoi, let theDTQD = layDuLieuThe(thoaMan: { $0 == "DT QUY DOI" || ($0.contains("DT QUY DOI") && !$0.contains("KHOAN VAY")) }) {
            if let so = theDTQD.soChinh { kq.doanhThuQuyDoi = so }
        }

        // 3C. Ô "DT dự kiến"
        if let theDuKien = layDuLieuThe(thoaMan: { $0.contains("DT DU KIEN") || $0 == "DU KIEN" }) {
            if let so = theDuKien.soChinh {
                if laAnhQuyDoi {
                    kq.duKienQuyDoi = so
                } else {
                    kq.duKienThuc = so
                }
            }
        }

        // 3D. Ô "% HT target" -> Lấy % HT và "Target trọn kỳ 11,128"
        if let theHT = layDuLieuThe(thoaMan: { $0.contains("HT TARGET") || ($0.contains("TARGET") && $0.contains("%")) }) {
            if let so = theHT.soChinh {
                if laAnhQuyDoi {
                    kq.phanTramHTQuyDoi = so
                } else {
                    kq.phanTramHTThuc = so
                }
            }
            let phuKhongDau = boDau(theHT.vanBanPhu)
            if let range = phuKhongDau.range(of: "KY\\s*([0-9][0-9.,]*)", options: .regularExpression) ??
                phuKhongDau.range(of: "TARGET[^0-9]*([0-9][0-9.,]*)", options: .regularExpression) {
                let chuoiCon = String(phuKhongDau[range])
                if let targetVal = trichCacSo(trong: chuoiCon).first, targetVal > 0 {
                    if laAnhQuyDoi {
                        kq.targetQuyDoi = targetVal
                    } else {
                        kq.targetThuc = targetVal
                    }
                }
            }
        }

        // 3E. Ô "TT vs TB 3 tháng" -> Lấy % tăng/giảm và TB3T cùng cửa sổ
        if let theTB3T = layDuLieuThe(thoaMan: { $0.contains("TB 3 THANG") || $0.contains("TT VS") }) {
            if let so = theTB3T.soChinh {
                kq.tangGiamCungKy = so
                kq.coTangGiam = true
            }
            let phuKhongDau = boDau(theTB3T.vanBanPhu)
            if let range = phuKhongDau.range(of: "SO:?\\s*([0-9][0-9.,]*)", options: .regularExpression) {
                let chuoiCon = String(phuKhongDau[range])
                if let tbVal = trichCacSo(trong: chuoiCon).last, tbVal > 0 {
                    kq.tb3Thang = tbVal
                }
            }
        }

        // 3F. Ô "TLPVTC lũy kế" -> Lấy % PVTC, số bill, số khách
        if let thePVTC = layDuLieuThe(thoaMan: { $0.contains("TLPVTC") || $0.contains("PVTC") }) {
            if let so = thePVTC.soChinh {
                kq.phanTramPVTC = so
            }
            let phuKhongDau = boDau(thePVTC.vanBanPhu)
            if let rBill = phuKhongDau.range(of: "([0-9][0-9.,]*)\\s*BILL", options: .regularExpression) {
                if let bVal = trichCacSo(trong: String(phuKhongDau[rBill])).first {
                    kq.soBill = bVal
                }
            }
            if let rKhach = phuKhongDau.range(of: "([0-9][0-9.,]*)\\s*KHACH", options: .regularExpression) {
                if let kVal = trichCacSo(trong: String(phuKhongDau[rKhach])).first {
                    kq.luotKhach = kVal
                }
            }
        }

        // 3G. Ô "Tỷ trọng trả chậm" -> Lấy % trả góp và DT trả góp
        if let theTraCham = layDuLieuThe(thoaMan: { $0.contains("TRA CHAM") || $0.contains("TY TRONG") }) {
            if let so = theTraCham.soChinh {
                kq.phanTramTraGop = so
            }
            let phuKhongDau = boDau(theTraCham.vanBanPhu)
            if let rTG = phuKhongDau.range(of: "TRA GOP(?:\\s*QD)?\\s*([0-9][0-9.,]*)", options: .regularExpression) {
                if let tgVal = trichCacSo(trong: String(phuKhongDau[rTG])).first {
                    kq.doanhThuTraGop = tgVal
                }
            }
        }

        // 4. Dự phòng nếu người dùng quét ảnh đã tổng hợp sẵn kiểu Ảnh 3 (DOANH THU THỰC / DOANH THU QĐ)
        if !kq.coDuLieu {
            if let mocThuc = phanTu.first(where: { boDau($0.chu).contains("DOANH THU THUC") }),
               let mocQD = phanTu.first(where: { boDau($0.chu).contains("DOANH THU QD") }) {
                let ranhX = (mocThuc.x + mocQD.x) / 2.0
                let vung = phanTu.filter { $0.y > min(mocThuc.y, mocQD.y) && $0.y < min(mocThuc.y, mocQD.y) + 0.18 }
                let trai = vung.filter { $0.x < ranhX }.sorted { $0.y < $1.y }
                let phai = vung.filter { $0.x >= ranhX }.sorted { $0.y < $1.y }
                for pt in trai {
                    if boDau(pt.chu).contains("TARGET"), let v = trichCacSo(trong: pt.chu).first { kq.targetThuc = v }
                    else if kq.doanhThuThuc == 0, let v = chuyenChuoiThanhSoDoanhThu(pt.chu), v > 0 { kq.doanhThuThuc = v }
                }
                for pt in phai {
                    if boDau(pt.chu).contains("TARGET"), let v = trichCacSo(trong: pt.chu).first { kq.targetQuyDoi = v }
                    else if kq.doanhThuQuyDoi == 0, let v = chuyenChuoiThanhSoDoanhThu(pt.chu), v > 0 { kq.doanhThuQuyDoi = v }
                }
            }
        }

        return kq
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
