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
        let x: CGFloat
        let y: CGFloat
        let rong: CGFloat
        let cao: CGFloat
    }

    // MARK: - 1. Quét danh sách ảnh chụp màn hình Thi Đua bằng Apple Vision

    func quetAnhThiDua(
        danhSachAnh: [UIImage],
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetThiDua) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var dsTongHop: [DongThiDua] = []
            var capNhat = ""
            var donVi = ""

            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh("Đang đọc ảnh \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.nhanDienVanBan(anh: anh)
                let (dsAnh, cn, dv) = self.phanTichBangThiDua(phanTu: phanTu)
                dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: dsAnh)
                if capNhat.isEmpty, let cn = cn, !cn.isEmpty { capNhat = cn }
                if donVi.isEmpty, let dv = dv, !dv.isEmpty { donVi = dv }
            }

            if capNhat.isEmpty {
                capNhat = TienIchNgay.hienThiGioPhut.string(from: Date())
            }

            let ketQua = KetQuaQuetThiDua(
                danhSach: dsTongHop,
                capNhatLuc: capNhat,
                thongTinDonVi: donVi
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
            let phanTu = self.nhanDienVanBan(anh: anh)
            let ketQua = self.phanTichDoanhThu(phanTu: phanTu)
            DispatchQueue.main.async {
                hoanTat(ketQua)
            }
        }
    }

    // MARK: - Apple Vision OCR Core

    private func nhanDienVanBan(anh: UIImage) -> [PhanTuVanBan] {
        guard let cgImage = anh.cgImage else { return [] }
        var phanTu: [PhanTuVanBan] = []

        let yeuCau = VNRecognizeTextRequest { request, _ in
            guard let ketQua = request.results as? [VNRecognizedTextObservation] else { return }
            for obs in ketQua {
                guard let ungVien = obs.topCandidates(1).first else { continue }
                let chu = ungVien.string.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !chu.isEmpty else { continue }
                let box = obs.boundingBox
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

    // MARK: - Phân tích bố cục ảnh Thi Đua ĐMX (Giữ nguyên tên gốc, chỉ lọc theo Cài đặt)

    private func phanTichBangThiDua(phanTu: [PhanTuVanBan]) -> ([DongThiDua], String?, String?) {
        var capNhatLuc: String?
        var thongTinDonVi: String?
        var maNhanVienWatermark: String?

        for pt in phanTu {
            if pt.chu.localizedCaseInsensitiveContains("Cập nhật lúc") || pt.chu.range(of: "\\d{2}:\\d{2}:\\d{2}", options: .regularExpression) != nil {
                let sach = pt.chu.replacingOccurrences(of: "Cập nhật lúc:", with: "").trimmingCharacters(in: .whitespaces)
                if capNhatLuc == nil {
                    capNhatLuc = sach
                } else if !capNhatLuc!.contains(sach) {
                    capNhatLuc = "\(capNhatLuc!) \(sach)"
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

        // Tìm tất cả các mốc tiêu đề khối chương trình dựa trên chữ "SỐ LƯỢNG" hoặc "DOANH THU" ở cột 2
        let mocChiTieu = phanTu.filter { pt in
            let inHoa = pt.chu.uppercased()
            let laChiTieu = inHoa.contains("SỐ LƯỢNG") || inHoa.contains("SO LUONG") || inHoa.contains("DOANH THU")
            return laChiTieu && pt.x >= 0.20 && pt.x <= 0.56 && pt.y > 0.08
        }.sorted { $0.y < $1.y }

        var ketQua: [DongThiDua] = []

        for (chiSo, moc) in mocChiTieu.enumerated() {
            let yTieuDe = moc.y
            let yGioiHanDuoi: CGFloat = (chiSo + 1 < mocChiTieu.count) ? mocChiTieu[chiSo + 1].y - 0.012 : 0.98

            let loai: LoaiChiTieuThiDua = moc.chu.uppercased().contains("DOANH") ? .doanhThu : .soLuong

            // Tìm vị trí dòng "TỔNG" ngay bên dưới tiêu đề khối này để làm mốc chặn dưới cho ô Tên ngành hàng
            let mocTong = phanTu.first { pt in
                let u = pt.chu.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
                return (u == "TỔNG" || u == "TONG") && pt.x < 0.25 && pt.y > yTieuDe && pt.y < yTieuDe + 0.065
            }
            let yChanDuoiTen = (mocTong?.y ?? (yTieuDe + 0.032)) - 0.006

            // Lấy các dòng chữ nằm đúng trong ô tiêu đề bên trái của khối (không lấy tràn lên khối trên)
            let phanTuTen = phanTu.filter { pt in
                pt.x < 0.30
                    && pt.y >= yTieuDe - 0.028
                    && pt.y <= yChanDuoiTen
                    && !laNhanHeThong(pt.chu, watermark: maNhanVienWatermark)
            }.sorted { $0.y < $1.y }

            let tenGop = phanTuTen
                .map { $0.chu }
                .joined(separator: " ")
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !tenGop.isEmpty else { continue }

            // Tìm dòng số liệu bên dưới tiêu đề khối
            let vungDuLieu = phanTu.filter { pt in
                pt.y > yTieuDe + 0.012 && pt.y < min(yGioiHanDuoi, yTieuDe + 0.14) && pt.x >= 0.28
            }

            let soThucHien = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.28 && $0.x < 0.50 }, watermark: maNhanVienWatermark)
            let soTarget = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.50 && $0.x < 0.69 }, watermark: maNhanVienWatermark)
            let soHT = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.69 && $0.x < 0.84 }, watermark: maNhanVienWatermark)
            let soDuBao = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.84 }, watermark: maNhanVienWatermark)

            guard let thucHien = soThucHien, let target = soTarget else { continue }

            let dong = DongThiDua(
                tenNganhHangGoc: tenGop,
                tenNganhHang: tenGop,
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
                    if let val = chuyenChuoiThanhSoLinhHoat(chuoiSo), val > 0 {
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

    private func laNhanHeThong(_ chu: String, watermark: String?) -> Bool {
        let inHoa = chu.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if inHoa == "TỔNG" || inHoa == "TONG" || inHoa == "TARGET" || inHoa.contains("% HT") || inHoa.contains("DỰ BÁO") {
            return true
        }
        if let wm = watermark, inHoa == wm {
            return true
        }
        return false
    }

    private func timGiaTriSo(trong danhSach: [PhanTuVanBan], watermark: String?) -> Double? {
        let sapXep = danhSach.sorted { $0.y < $1.y }
        for pt in sapXep {
            let chu = pt.chu.trimmingCharacters(in: .whitespacesAndNewlines)
            if let wm = watermark, chu == wm { continue }
            if let so = chuyenChuoiThanhSoLinhHoat(chu) {
                return so
            }
        }
        return nil
    }

    private func chuyenChuoiThanhSoLinhHoat(_ chuoi: String) -> Double? {
        var sach = chuoi
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "…", with: "")
            .replacingOccurrences(of: "...", with: "")
            .replacingOccurrences(of: "..", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !sach.isEmpty else { return nil }

        let viTriCham = sach.lastIndex(of: ".")
        let viTriPhay = sach.lastIndex(of: ",")

        if let cham = viTriCham, let phay = viTriPhay {
            if phay > cham {
                sach = sach.replacingOccurrences(of: ".", with: "")
                sach = sach.replacingOccurrences(of: ",", with: ".")
            } else {
                sach = sach.replacingOccurrences(of: ",", with: "")
            }
        } else if viTriPhay != nil {
            let phan = sach.components(separatedBy: ",")
            if phan.count == 2 && phan[1].count == 2 {
                sach = sach.replacingOccurrences(of: ",", with: ".")
            } else {
                sach = sach.replacingOccurrences(of: ",", with: "")
            }
        }

        if sach.range(of: "^-?\\d+(\\.\\d+)?$", options: .regularExpression) != nil {
            return Double(sach)
        }
        return nil
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
