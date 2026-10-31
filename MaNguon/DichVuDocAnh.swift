import UIKit
import Vision
import ImageIO

struct DongThiDuaNhanVienQuet: Hashable {
    var maNV: String
    var hoTen: String
    var thucHien: Double
    var target: Double
}

struct KetQuaThiDuaNhanVienKhoi: Hashable {
    var tenNganhHang: String
    var danhSach: [DongThiDuaNhanVienQuet]
}

struct KetQuaQuetThiDua {
    var danhSach: [DongThiDua]
    var thiDuaNhanVien: [KetQuaThiDuaNhanVienKhoi]
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

    // MARK: - 1. Quét danh sách ảnh chụp màn hình Thi Đua (hỗ trợ cả ảnh bảng Thực hiện NV nếu chọn lẫn)

    func quetAnhThiDua(
        danhSachAnh: [UIImage],
        tenNganhGoiY: String? = nil,
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetThiDua) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var dsTongHop: [DongThiDua] = []
            var cacKhoiNV: [KetQuaThiDuaNhanVienKhoi] = []
            var capNhatOffline = ""
            var donViOffline = ""

            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh("Đang quét chữ (Apple Vision) ảnh \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                let (dsAnh, khoiNV, cn, dv) = self.phanTichThiDuaOffline(phanTu: phanTu, tenNganhGoiY: tenNganhGoiY)
                if !dsAnh.isEmpty {
                    dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: dsAnh)
                }
                if !khoiNV.isEmpty {
                    cacKhoiNV.append(contentsOf: khoiNV)
                }
                if capNhatOffline.isEmpty, let cn = cn, !cn.isEmpty {
                    capNhatOffline = cn
                }
                if donViOffline.isEmpty, let dv = dv, !dv.isEmpty {
                    donViOffline = dv
                }
            }

            let ketQua = KetQuaQuetThiDua(
                danhSach: dsTongHop,
                thiDuaNhanVien: cacKhoiNV,
                capNhatLuc: capNhatOffline.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : capNhatOffline,
                thongTinDonVi: donViOffline
            )
            DispatchQueue.main.async {
                hoanTat(ketQua)
            }
        }
    }

    // MARK: - 2. Quét danh sách ảnh chụp bảng Thực hiện Nhân viên theo Ngành hàng

    func quetAnhThiDuaNhanVien(
        danhSachAnh: [UIImage],
        tenNganhGoiY: String? = nil,
        tienTrinh: ((String) -> Void)? = nil,
        hoanTat: @escaping ([KetQuaThiDuaNhanVienKhoi]) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var cacKhoi: [KetQuaThiDuaNhanVienKhoi] = []
            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh?("Đang đọc ảnh Thực hiện NV \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                var watermark: String?
                for pt in phanTu where pt.y < 0.16 {
                    if let range = pt.chu.range(of: "\\b\\d{4,7}(?=\\s*-)", options: .regularExpression) {
                        watermark = String(pt.chu[range])
                    }
                }
                if let khoi = self.phanTichThiDuaNhanVienOffline(phanTu: phanTu, tenNganhGoiY: tenNganhGoiY, watermark: watermark),
                   !khoi.danhSach.isEmpty {
                    cacKhoi.append(khoi)
                }
            }
            DispatchQueue.main.async {
                hoanTat(cacKhoi)
            }
        }
    }

    // MARK: - 3. Quét danh sách ảnh chụp màn hình Doanh thu (Lũy kế DT thực & DT quy đổi)

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

    // MARK: - 4. Quét danh sách ảnh chụp bảng Doanh thu hợp nhất theo Nhân viên

    func quetAnhDoanhThuNhanVien(
        danhSachAnh: [UIImage],
        tienTrinh: ((String) -> Void)? = nil,
        hoanTat: @escaping ([DoanhThuNhanVienItem]) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var dsQuet: [DoanhThuNhanVienItem] = []
            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh?("Đang đọc ảnh Doanh thu NV \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                dsQuet.append(contentsOf: self.phanTichDoanhThuNhanVienOffline(phanTu: phanTu))
            }
            DispatchQueue.main.async {
                hoanTat(dsQuet)
            }
        }
    }

    // MARK: - Bước 1: Apple Vision OCR trên iPhone

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

    // MARK: - Bước 2A: Bộ phân tích bố cục Thi Đua ĐMX & Thực hiện NV

    private func phanTichThiDuaOffline(
        phanTu: [PhanTuVanBan],
        tenNganhGoiY: String? = nil
    ) -> ([DongThiDua], [KetQuaThiDuaNhanVienKhoi], String?, String?) {
        var capNhatLuc: String?
        var thongTinDonVi: String?
        var maNhanVienWatermark: String?

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

        // Kiểm tra xem đây có phải ảnh chụp bảng Thực hiện nhân viên của 1 ngành hàng không
        let coCotHangTrongST = phanTu.contains { pt in
            let u = boDau(pt.chu)
            return pt.y < 0.22 && (
                u.contains("HANG TRONG") ||
                u.contains("TOP/BOTT") ||
                u.contains("CON / VUOT") ||
                u.contains("NHAN VIEN")
            )
        }

        if coCotHangTrongST {
            if let khoiNV = phanTichThiDuaNhanVienOffline(phanTu: phanTu, tenNganhGoiY: tenNganhGoiY, watermark: maNhanVienWatermark) {
                return ([], [khoiNV], capNhatLuc, thongTinDonVi)
            }
            return ([], [], capNhatLuc, thongTinDonVi)
        }

        // Tìm tất cả các mốc tiêu đề khối chương trình dựa trên chữ "SỐ LƯỢNG" hoặc "DOANH THU" ở cột thứ 2 (0.22 <= x <= 0.55)
        let mocChiTieu = phanTu.filter { pt in
            let khongDau = boDau(pt.chu)
            let laChiTieu = khongDau.contains("SO LUONG") || khongDau.contains("DOANH THU")
            return laChiTieu && pt.x >= 0.22 && pt.x <= 0.55 && pt.y > 0.12
        }.sorted { $0.y < $1.y }

        var ketQua: [DongThiDua] = []

        for (chiSo, moc) in mocChiTieu.enumerated() {
            let yTieuDe = moc.y
            let yGioiHanDuoi: CGFloat = (chiSo + 1 < mocChiTieu.count) ? mocChiTieu[chiSo + 1].y - 0.015 : 0.98

            let loai: LoaiChiTieuThiDua = boDau(moc.chu).contains("DOANH") ? .doanhThu : .soLuong

            // 1. Lấy tên ngành hàng / chương trình ở góc trái (x < 0.31) ngang hàng với tiêu đề khối
            let phanTuTen = phanTu.filter { pt in
                pt.x < 0.31 && abs(pt.y - yTieuDe) < 0.045 && !laChuoiRac(pt.chu, watermark: maNhanVienWatermark)
            }.sorted {
                if abs($0.y - $1.y) < 0.008 { return $0.x < $1.x }
                return $0.y < $1.y
            }

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

            let soThucHien = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.28 && $0.x < 0.50 }, watermark: maNhanVienWatermark)
            let soTarget = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.50 && $0.x < 0.69 }, watermark: maNhanVienWatermark)
            let soHT = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.69 && $0.x < 0.84 }, watermark: maNhanVienWatermark)
            let soDuBao = timGiaTriSo(trong: vungDuLieu.filter { $0.x >= 0.84 }, watermark: maNhanVienWatermark)

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

        return (ketQua, [], capNhatLuc, thongTinDonVi)
    }

    // MARK: - Bước 2B: Phân tích ảnh Thực hiện Nhân viên theo Ngành hàng

    private func phanTichThiDuaNhanVienOffline(
        phanTu: [PhanTuVanBan],
        tenNganhGoiY: String? = nil,
        watermark: String? = nil
    ) -> KetQuaThiDuaNhanVienKhoi? {
        var tenNganhHang = tenNganhGoiY ?? ""
        if tenNganhHang.isEmpty {
            if let mocTieuDe = phanTu.first(where: { pt in
                let u = boDau(pt.chu)
                return pt.y > 0.05 && pt.y < 0.20 && (
                    u.contains("DOANH THU") || u.contains("SO LUONG") || u.contains("THUC HIEN")
                )
            }) {
                let phanTuTen = phanTu.filter { pt in
                    pt.x < 0.31 && abs(pt.y - mocTieuDe.y) < 0.05 && !laChuoiRac(pt.chu, watermark: watermark)
                }.sorted {
                    if abs($0.y - $1.y) < 0.008 { return $0.x < $1.x }
                    return $0.y < $1.y
                }
                tenNganhHang = phanTuTen
                    .map(\.chu)
                    .joined(separator: " ")
                    .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        let cacDongNV = phanTu.filter { pt in
            guard pt.x < 0.45 && pt.y > 0.13 && pt.y < 0.96 else { return false }
            let u = boDau(pt.chu)
            if u.contains("ONLINE") || u.contains("TONG CONG") || u == "TONG" { return false }
            guard let range = pt.chu.range(of: "\\b\\d{4,7}\\b", options: .regularExpression) else { return false }
            let ma = String(pt.chu[range])
            if let wm = watermark, ma == wm, u.contains("DUNG NGUYEN") { return false }
            return true
        }.sorted { $0.y < $1.y }

        var danhSach: [DongThiDuaNhanVienQuet] = []
        var daXetMa = Set<String>()

        for dong in cacDongNV {
            guard let range = dong.chu.range(of: "\\b\\d{4,7}\\b", options: .regularExpression) else { continue }
            let maNV = String(dong.chu[range])
            if daXetMa.contains(maNV) { continue }

            let hoTen = dong.chu
                .replacingOccurrences(of: maNV, with: "")
                .replacingOccurrences(of: "[-–—]", with: " ", options: .regularExpression)
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let cungHang = phanTu.filter { pt in
                pt.x >= 0.28 && pt.x < 0.72 && abs(pt.y - dong.y) < 0.03
            }.sorted { $0.x < $1.x }

            var thucHien: Double?
            var target: Double = 0

            for pt in cungHang {
                if pt.chu.contains("/") {
                    let parts = pt.chu.components(separatedBy: "/")
                    if let v1 = chuyenChuoiThanhSoDoanhThu(parts[0]) {
                        thucHien = v1
                        if parts.count > 1, let v2 = chuyenChuoiThanhSoDoanhThu(parts[1]) {
                            target = v2
                        }
                        break
                    }
                }
                if let val = chuyenChuoiThanhSo(pt.chu, watermark: watermark) {
                    thucHien = val
                    break
                }
            }

            if let th = thucHien {
                daXetMa.insert(maNV)
                danhSach.append(DongThiDuaNhanVienQuet(maNV: maNV, hoTen: hoTen, thucHien: th, target: target))
            }
        }

        return KetQuaThiDuaNhanVienKhoi(
            tenNganhHang: tenNganhHang.isEmpty ? "Ngành hàng" : tenNganhHang,
            danhSach: danhSach
        )
    }

    // MARK: - Bước 2C: Phân tích ảnh Doanh thu hợp nhất theo Nhân viên (Lưới 5 cột & Bảng rộng 11 cột)

    private func phanTichDoanhThuNhanVienOffline(phanTu: [PhanTuVanBan]) -> [DoanhThuNhanVienItem] {
        var watermark: String?
        for pt in phanTu where pt.y < 0.14 {
            if let range = pt.chu.range(of: "\\b\\d{4,7}(?=\\s*-)", options: .regularExpression) {
                watermark = String(pt.chu[range])
            }
        }

        let laBangRong = phanTu.contains { pt in
            let u = boDau(pt.chu)
            return u.contains("DTLK") || u.contains("GIO CONG") || u.contains("NANG SUAT")
        }

        let cacDongNV = phanTu.filter { pt in
            guard pt.x < 0.36 && pt.y > 0.12 && pt.y < 0.96 else { return false }
            let u = boDau(pt.chu)
            if u.contains("TONG") || u.contains("ONLINE") { return false }
            guard let range = pt.chu.range(of: "\\b\\d{4,7}\\b", options: .regularExpression) else { return false }
            let ma = String(pt.chu[range])
            if let wm = watermark, ma == wm, u.contains("DUNG NGUYEN") { return false }
            return true
        }.sorted { $0.y < $1.y }

        var ketQua: [DoanhThuNhanVienItem] = []
        var daXetMa = Set<String>()

        for dong in cacDongNV {
            guard let range = dong.chu.range(of: "\\b\\d{4,7}\\b", options: .regularExpression) else { continue }
            let maNV = String(dong.chu[range])
            if daXetMa.contains(maNV) { continue }

            let hoTen = dong.chu
                .replacingOccurrences(of: maNV, with: "")
                .replacingOccurrences(of: "^[+\\s-–—]+|[-–—\\s]+$", with: "", options: .regularExpression)
                .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let cacPhanTuSoCungHang = phanTu.filter { pt in
                pt.x >= 0.20 && abs(pt.y - dong.y) < 0.024 && chuyenChuoiThanhSoDoanhThu(pt.chu) != nil
            }.sorted { $0.x < $1.x }

            guard !cacPhanTuSoCungHang.isEmpty else { continue }

            if !laBangRong {
                func laySoTheoKhoangX(_ xMin: CGFloat, _ xMax: CGFloat) -> Double {
                    guard let pt = cacPhanTuSoCungHang.first(where: { $0.x >= xMin && $0.x < xMax }) else { return 0 }
                    return chuyenChuoiThanhSoDoanhThu(pt.chu) ?? 0
                }

                let soLuong = laySoTheoKhoangX(0.32, 0.48)
                let doanhThuQD = laySoTheoKhoangX(0.48, 0.65)
                let dtQDKhoanVay = laySoTheoKhoangX(0.65, 0.80)
                let dtTraThangQD = laySoTheoKhoangX(0.80, 1.00)

                daXetMa.insert(maNV)
                ketQua.append(DoanhThuNhanVienItem(
                    maNV: maNV,
                    hoTen: hoTen,
                    soLuong: soLuong,
                    doanhThuThuc: 0,
                    doanhThuQD: doanhThuQD,
                    target: 0,
                    dtQDKhoanVay: dtQDKhoanVay,
                    dtTraThangQD: dtTraThangQD
                ))
            } else {
                let cacSo = cacPhanTuSoCungHang.map { chuyenChuoiThanhSoDoanhThu($0.chu) ?? 0 }
                func soTai(_ idx: Int) -> Double { idx < cacSo.count ? cacSo[idx] : 0 }

                daXetMa.insert(maNV)
                ketQua.append(DoanhThuNhanVienItem(
                    maNV: maNV,
                    hoTen: hoTen,
                    soLuong: 0,
                    doanhThuThuc: soTai(0),
                    doanhThuQD: soTai(1),
                    target: soTai(2),
                    dtQDKhoanVay: 0,
                    dtTraThangQD: soTai(0),
                    dtTraGop: soTai(6),
                    phanTramHT: soTai(3),
                    phanTramQuyDoi: soTai(4),
                    phanTramTraGop: soTai(5),
                    gioCong: soTai(7),
                    soNgayNghi: soTai(8),
                    nangSuat: soTai(9)
                ))
            }
        }

        return ketQua
    }

    private func laChuoiRac(_ chu: String, watermark: String?) -> Bool {
        let inHoa = boDau(chu).trimmingCharacters(in: .whitespacesAndNewlines)
        if inHoa == "TONG" || inHoa == "TARGET" || inHoa.contains("% HT") || inHoa.contains("DU BAO") || inHoa.contains("HANG TRONG") || inHoa.contains("BO PHAN") {
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
        var sach = chuoi
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "…", with: "")
            .replacingOccurrences(of: "...", with: "")
            .replacingOccurrences(of: "..", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        sach = sach.replacingOccurrences(of: ",", with: "")

        guard !sach.isEmpty else { return nil }
        if sach.range(of: "^-?\\d+(\\.\\d+)?$", options: .regularExpression) != nil {
            if let wm = watermark, sach == wm { return nil }
            return Double(sach)
        }
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
                s = s.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
            } else {
                s = s.replacingOccurrences(of: ",", with: "")
            }
        } else if s.contains(",") {
            if s.range(of: "^-?\\d{1,3}(,\\d{3})+$", options: .regularExpression) != nil {
                s = s.replacingOccurrences(of: ",", with: "")
            } else {
                s = s.replacingOccurrences(of: ",", with: ".")
            }
        } else if s.contains(".") {
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

        let laAnhQuyDoi = vungThe.contains { pt in
            let u = boDau(pt.chu)
            return u.contains("DT QUY DOI") || u.contains("KHOAN VAY") || u.contains("TRA GOP QD")
        }

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

        // 3D. Ô "% HT target"
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

        // 3E. Ô "TT vs TB 3 tháng"
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

        // 3F. Ô "TLPVTC lũy kế"
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

        // 3G. Ô "Tỷ trọng trả chậm"
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

        // 4. Dự phòng nếu người dùng quét ảnh đã tổng hợp sẵn kiểu Ảnh 3
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
