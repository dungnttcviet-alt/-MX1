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

    // MARK: - 2. Quét ảnh chụp màn hình Doanh thu (Doanh thu thực & Doanh thu QĐ)

    func quetAnhDoanhThu(
        anh: UIImage,
        hoanTat: @escaping (ThongTinDoanhThu) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let phanTu = self.thucHienOCR(anh: anh)
            let ketQua = self.phanTichDoanhThu(phanTu: phanTu)
            DispatchQueue.main.async {
                hoanTat(ketQua)
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

        // Tìm tất cả các mốc tiêu đề khối chương trình dựa trên chữ "SỐ LƯỢNG" hoặc "DOANH THU" ở cột thứ 2 (0.22 <= x <= 0.55)
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

    // MARK: - Phân tích ảnh chụp màn hình Doanh thu (Thực & Quy đổi)

    private func phanTichDoanhThu(phanTu: [PhanTuVanBan]) -> ThongTinDoanhThu {
        var kq = ThongTinDoanhThu()

        let mocDTThuc = phanTu.first {
            let u = $0.chu.uppercased()
            return u.contains("DOANH THU THỰC") || u.contains("DT THỰC") || u.contains("THỰC")
        }
        let mocDTQD = phanTu.first {
            let u = $0.chu.uppercased()
            return u.contains("DOANH THU QĐ") || u.contains("QUY ĐỔI") || u.contains("DT QĐ")
        }

        struct SoToaDo {
            let giaTri: Double
            let x: CGFloat
            let y: CGFloat
            let laTarget: Bool
        }

        var danhSachSo: [SoToaDo] = []
        for pt in phanTu {
            let inHoa = pt.chu.uppercased()
            if inHoa.contains("%") { continue }
            let laTarget = inHoa.contains("TARGET") || inHoa.contains("MỤC TIÊU")

            let mauSo = "\\d+[\\d.,]*"
            if let regex = try? NSRegularExpression(pattern: mauSo) {
                let ns = pt.chu as NSString
                let matches = regex.matches(in: pt.chu, range: NSRange(location: 0, length: ns.length))
                for m in matches {
                    let chuoiSo = ns.substring(with: m.range)
                    if let val = chuyenChuoiThanhSo(chuoiSo), val > 0 {
                        danhSachSo.append(SoToaDo(giaTri: val, x: pt.x, y: pt.y, laTarget: laTarget))
                    }
                }
            }
        }

        if let thuc = mocDTThuc, let qd = mocDTQD, abs(thuc.x - qd.x) > 0.2 {
            let ranhGioiX = (thuc.x + qd.x) / 2.0
            let soBenTrai = danhSachSo.filter { $0.x < ranhGioiX && $0.y > thuc.y }.sorted { $0.y < $1.y }
            let soBenPhai = danhSachSo.filter { $0.x >= ranhGioiX && $0.y > qd.y }.sorted { $0.y < $1.y }

            if let chinhTrai = soBenTrai.first(where: { !$0.laTarget }) ?? soBenTrai.first {
                kq.doanhThuThuc = chinhTrai.giaTri
            }
            if let targetTrai = soBenTrai.first(where: { $0.laTarget }) ?? (soBenTrai.count > 1 ? soBenTrai[1] : nil) {
                kq.targetThuc = targetTrai.giaTri
            }

            if let chinhPhai = soBenPhai.first(where: { !$0.laTarget }) ?? soBenPhai.first {
                kq.doanhThuQuyDoi = chinhPhai.giaTri
            }
            if let targetPhai = soBenPhai.first(where: { $0.laTarget }) ?? (soBenPhai.count > 1 ? soBenPhai[1] : nil) {
                kq.targetQuyDoi = targetPhai.giaTri
            }
        } else {
            let sapXep = danhSachSo.sorted {
                if abs($0.y - $1.y) < 0.03 { return $0.x < $1.x }
                return $0.y < $1.y
            }
            let khongTarget = sapXep.filter { !$0.laTarget }
            let coTarget = sapXep.filter { $0.laTarget }

            if khongTarget.count >= 2 {
                kq.doanhThuThuc = khongTarget[0].giaTri
                kq.doanhThuQuyDoi = khongTarget[1].giaTri
            } else if khongTarget.count == 1 {
                kq.doanhThuThuc = khongTarget[0].giaTri
            }

            if coTarget.count >= 2 {
                kq.targetThuc = coTarget[0].giaTri
                kq.targetQuyDoi = coTarget[1].giaTri
            } else if khongTarget.count >= 4 {
                kq.targetThuc = khongTarget[2].giaTri
                kq.targetQuyDoi = khongTarget[3].giaTri
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
