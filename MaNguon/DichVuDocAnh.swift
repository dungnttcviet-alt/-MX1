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

struct KetQuaQuetTatCaAnh {
    var doanhThu: ThongTinDoanhThu?
    var soAnhDoanhThu: Int = 0
    var danhSachThiDua: [DongThiDua] = []
    var soAnhThiDua: Int = 0
    var doanhThuNhanVien: [DoanhThuNhanVienItem] = []
    var soAnhDoanhThuNV: Int = 0
    var thiDuaNhanVien: [KetQuaThiDuaNhanVienKhoi] = []
    var soAnhThiDuaNV: Int = 0
    var capNhatLuc: String = ""
    var thongTinDonVi: String = ""

    var coDuLieu: Bool {
        doanhThu != nil || !danhSachThiDua.isEmpty || !doanhThuNhanVien.isEmpty || !thiDuaNhanVien.isEmpty
    }
}

struct KetQuaQuetThiDua {
    var danhSach: [DongThiDua]
    var thiDuaNhanVien: [KetQuaThiDuaNhanVienKhoi]
    var doanhThuQuetDuoc: ThongTinDoanhThu? = nil
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

    func quetVaPhanLoaiTatCaAnh(
        danhSachAnh: [UIImage],
        ngay: Date,
        cheDoDangChon: LoaiCheDoDoanhThu,
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetTatCaAnh) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var ketQua = KetQuaQuetTatCaAnh()
            var dtGop = ThongTinDoanhThu()
            var coDT = false
            var cacPhanTuThiDua: [([PhanTuVanBan], String?)] = []

            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh("Đang đọc & phân loại ảnh \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                let (cn, dv, wm) = self.trichThongTinChungThiDua(phanTu: phanTu)
                if ketQua.capNhatLuc.isEmpty, let cn, !cn.isEmpty { ketQua.capNhatLuc = cn }
                if ketQua.thongTinDonVi.isEmpty, let dv, !dv.isEmpty { ketQua.thongTinDonVi = dv }

                // 1. Kiểm tra bảng Doanh thu Nhân viên
                let dtnv = self.phanTichDoanhThuNhanVienOffline(phanTu: phanTu)
                if dtnv.count >= 2 {
                    ketQua.doanhThuNhanVien.append(contentsOf: dtnv)
                    ketQua.soAnhDoanhThuNV += 1
                    continue
                }

                // 2. Kiểm tra bảng Thực hiện Nhân viên theo ngành
                let coCotHangTrongST = phanTu.contains { pt in
                    let u = self.boDau(pt.chu)
                    return pt.y < 0.22 && (
                        u.contains("HANG TRONG") ||
                        u.contains("TOP/BOTT") ||
                        u.contains("CON / VUOT") ||
                        u.contains("NHAN VIEN")
                    )
                }
                if coCotHangTrongST,
                   let khoiNV = self.phanTichThiDuaNhanVienOffline(phanTu: phanTu, tenNganhGoiY: nil, watermark: wm),
                   !khoiNV.danhSach.isEmpty {
                    ketQua.thiDuaNhanVien.append(khoiNV)
                    ketQua.soAnhThiDuaNV += 1
                    continue
                }

                // 3. Kiểm tra thẻ Thi đua 2 cột
                let dsLuoiThe = self.phanTichThiDuaLuoiThe2Cot(phanTu: phanTu, watermark: wm)
                if !dsLuoiThe.isEmpty {
                    ketQua.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: ketQua.danhSachThiDua, moi: dsLuoiThe)
                    ketQua.soAnhThiDua += 1
                    continue
                }

                // 4. Kiểm tra ảnh Doanh thu siêu thị (DT Thực / DT Quy đổi)
                let kqDT = self.phanTichDoanhThu(phanTu: phanTu)
                if kqDT.doanhThuThuc > 0 || kqDT.doanhThuQuyDoi > 0 {
                    dtGop = dtGop.gop(voi: kqDT, laRealtime: cheDoDangChon == .realtime)
                    coDT = true
                    ketQua.soAnhDoanhThu += 1
                    continue
                }

                cacPhanTuThiDua.append((phanTu, wm))
            }

            if !cacPhanTuThiDua.isEmpty {
                var idx = 0
                while idx < cacPhanTuThiDua.count {
                    let (pt1, wm1) = cacPhanTuThiDua[idx]
                    if idx + 1 < cacPhanTuThiDua.count {
                        let (pt2, wm2) = cacPhanTuThiDua[idx + 1]
                        let dsCap = self.ghepCapAnhThiDua(phanTu1: pt1, watermark1: wm1, phanTu2: pt2, watermark2: wm2)
                        if !dsCap.isEmpty {
                            ketQua.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: ketQua.danhSachThiDua, moi: dsCap)
                            ketQua.soAnhThiDua += 2
                        }
                        idx += 2
                    } else {
                        let (ds1, _, _, _) = self.phanTichThiDuaOffline(phanTu: pt1, tenNganhGoiY: nil)
                        if !ds1.isEmpty {
                            ketQua.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: ketQua.danhSachThiDua, moi: ds1)
                            ketQua.soAnhThiDua += 1
                        }
                        idx += 1
                    }
                }
            }

            if coDT {
                ketQua.doanhThu = dtGop
            }
            if ketQua.capNhatLuc.isEmpty {
                ketQua.capNhatLuc = TienIchNgay.hienThiGioPhut.string(from: Date())
            }

            DispatchQueue.main.async {
                hoanTat(ketQua)
            }
        }
    }

    func quetAnhThiDua(
        danhSachAnh: [UIImage],
        danhSachHienCo: [DongThiDua] = [],
        laRealtime: Bool = false,
        tenNganhGoiY: String? = nil,
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetThiDua) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var dsTongHop: [DongThiDua] = []
            var cacKhoiNV: [KetQuaThiDuaNhanVienKhoi] = []
            var capNhatOffline = ""
            var donViOffline = ""

            var cacPhanTuThiDua: [([PhanTuVanBan], String?)] = []

            for (chiSo, anh) in danhSachAnh.enumerated() {
                DispatchQueue.main.async {
                    tienTrinh("Đang quét chữ (Apple Vision) ảnh \(chiSo + 1)/\(danhSachAnh.count)...")
                }
                let phanTu = self.thucHienOCR(anh: anh)
                let (cn, dv, wm) = self.trichThongTinChungThiDua(phanTu: phanTu)
                if capNhatOffline.isEmpty, let cn = cn, !cn.isEmpty {
                    capNhatOffline = cn
                }
                if donViOffline.isEmpty, let dv = dv, !dv.isEmpty {
                    donViOffline = dv
                }

                // Kiểm tra xem có phải ảnh bảng Thực hiện nhân viên không
                let coCotHangTrongST = phanTu.contains { pt in
                    let u = self.boDau(pt.chu)
                    return pt.y < 0.22 && (
                        u.contains("HANG TRONG") ||
                        u.contains("TOP/BOTT") ||
                        u.contains("CON / VUOT") ||
                        u.contains("NHAN VIEN")
                    )
                }
                if coCotHangTrongST {
                    if let khoiNV = self.phanTichThiDuaNhanVienOffline(phanTu: phanTu, tenNganhGoiY: tenNganhGoiY, watermark: wm),
                       !khoiNV.danhSach.isEmpty {
                        cacKhoiNV.append(khoiNV)
                    }
                } else {
                    cacPhanTuThiDua.append((phanTu, wm))
                }
            }

            // Ưu tiên 1: Mẫu Lưới Thẻ 2 Cột mới ("Doanh thu hợp nhất" — mỗi thẻ có đủ Tên ngành hàng, DT/SL, Thực hiện, Target, % HT tháng, % Dự kiến hoàn thành)
            var cacPhanTuBang2Cot: [([PhanTuVanBan], String?)] = []
            for (pt, wm) in cacPhanTuThiDua {
                let dsLuoiThe = self.phanTichThiDuaLuoiThe2Cot(phanTu: pt, watermark: wm)
                if !dsLuoiThe.isEmpty {
                    dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: dsLuoiThe)
                } else {
                    cacPhanTuBang2Cot.append((pt, wm))
                }
            }

            // Ưu tiên 2 (Dự phòng): Nếu có ảnh thuộc mẫu bảng 2 cột rời (CHƯƠNG TRÌNH | TARGET và CHƯƠNG TRÌNH | THỰC HIỆN) hoặc mẫu 5 cột cũ
            if !cacPhanTuBang2Cot.isEmpty {
                if cacPhanTuBang2Cot.count == 1,
                   !danhSachHienCo.isEmpty,
                   (danhSachHienCo.allSatisfy({ $0.target <= 0 }) || danhSachHienCo.allSatisfy({ $0.thucHien <= 0 })) {
                    let (pt2, wm2) = cacPhanTuBang2Cot[0]
                    let (_, cacSo2) = self.trichXuatSoCotPhaiTuTrenXuong(phanTu: pt2, watermark: wm2)
                    let dangThieuTarget = danhSachHienCo.allSatisfy({ $0.target <= 0 })
                    var capNhat = danhSachHienCo
                    for i in 0..<min(capNhat.count, cacSo2.count) {
                        if dangThieuTarget {
                            capNhat[i].target = cacSo2[i].giaTri
                        } else {
                            capNhat[i].thucHien = cacSo2[i].giaTri
                        }
                    }
                    dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: capNhat)
                } else {
                    var idx = 0
                    while idx < cacPhanTuBang2Cot.count {
                        let (pt1, wm1) = cacPhanTuBang2Cot[idx]
                        if idx + 1 < cacPhanTuBang2Cot.count {
                            let (pt2, wm2) = cacPhanTuBang2Cot[idx + 1]
                            let dsCap = self.ghepCapAnhThiDua(phanTu1: pt1, watermark1: wm1, phanTu2: pt2, watermark2: wm2)
                            if !dsCap.isEmpty {
                                dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: dsCap)
                            }
                            idx += 2
                        } else {
                            let (ds1, _, _, _) = self.phanTichThiDuaOffline(phanTu: pt1, tenNganhGoiY: tenNganhGoiY)
                            if !ds1.isEmpty {
                                dsTongHop = KhoDuLieu.gopDanhSachThiDua(cu: dsTongHop, moi: ds1)
                            }
                            idx += 1
                        }
                    }
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
        laRealtime: Bool = false,
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
                ketQuaGop = ketQuaGop.gop(voi: kqAnh, laRealtime: laRealtime)
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

        // Lượt 2 tắt languageCorrection để bắt chính xác các chữ số đơn lẻ ("0", "1", "2", "5", "6", "8", "13") trên thẻ SL
        var phanTuSoBoSung: [PhanTuVanBan] = []
        let yeuCauSo = VNRecognizeTextRequest { request, _ in
            guard let ketQua = request.results as? [VNRecognizedTextObservation] else { return }
            for obs in ketQua {
                guard let ungVien = obs.topCandidates(1).first else { continue }
                let chu = ungVien.string.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !chu.isEmpty else { continue }
                guard chu.range(of: "^[0-9]+([.,][0-9]+)?%?$", options: .regularExpression) != nil else { continue }
                let box = obs.boundingBox
                let yTrenXuong = 1.0 - box.origin.y - box.size.height
                phanTuSoBoSung.append(
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
        yeuCauSo.recognitionLevel = .accurate
        yeuCauSo.usesLanguageCorrection = false
        yeuCauSo.minimumTextHeight = 0.006

        let xuLy = VNImageRequestHandler(cgImage: cgImage, orientation: anh.cgImageOrientation, options: [:])
        try? xuLy.perform([yeuCau, yeuCauSo])

        for ptSo in phanTuSoBoSung {
            let daCo = phanTu.contains { pt in
                abs(pt.y - ptSo.y) < 0.016 && abs(pt.x - ptSo.x) < 0.045 &&
                pt.chu.range(of: "\\d", options: .regularExpression) != nil
            }
            if !daCo {
                phanTu.append(ptSo)
            }
        }
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

        // KIỂU LƯỚI THẺ 2 CỘT ("Doanh thu hợp nhất": mỗi thẻ gồm Tên ngành hàng, DT/SL, Thực hiện, Target, % HT tháng, % Dự kiến hoàn thành)
        let dsLuoiThe = phanTichThiDuaLuoiThe2Cot(phanTu: phanTu, watermark: maNhanVienWatermark)
        if !dsLuoiThe.isEmpty {
            return (dsLuoiThe, [], capNhatLuc, thongTinDonVi)
        }

        // KIỂU BẢNG 2 CỘT (CHƯƠNG TRÌNH | TARGET hoặc CHƯƠNG TRÌNH | THỰC HIỆN)
        let dsHaiCot = phanTichThiDuaHaiCot(phanTu: phanTu, watermark: maNhanVienWatermark)
        if !dsHaiCot.isEmpty {
            return (dsHaiCot, [], capNhatLuc, thongTinDonVi)
        }

        // KIỂU CŨ: Tìm tất cả các mốc tiêu đề khối chương trình dựa trên chữ "SỐ LƯỢNG" hoặc "DOANH THU" ở cột thứ 2 (0.22 <= x <= 0.55)
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

    // MARK: - Bước 2A.1: Bộ phân tích Lưới Thẻ Thi Đua 2 Cột ("Doanh thu hợp nhất" — mỗi thẻ có đủ Tên, DT/SL, Thực hiện, Target, % HT ngày/tháng, % Dự kiến)

    private func phanTichThiDuaLuoiThe2Cot(phanTu: [PhanTuVanBan], watermark: String?) -> [DongThiDua] {
        let coDauHieuLuoiThe = phanTu.contains { pt in
            let u = boDau(pt.chu)
            return u.contains("DU KIEN HOAN") || u.contains("HT THANG") || u.contains("HT NGAY") ||
                   u.contains("TARGET NGAY") || u.contains("DT DU KIEN") || u.contains("SL DU KIEN")
        }
        let coTargetTrai = phanTu.contains { $0.x < 0.48 && boDau($0.chu).contains("TARGET") }
        let coTargetPhai = phanTu.contains { $0.x >= 0.48 && boDau($0.chu).contains("TARGET") }

        guard coDauHieuLuoiThe || (coTargetTrai && coTargetPhai) else {
            return []
        }

        // Xác định toạ độ Y bắt đầu vùng thẻ:
        // - Nếu ảnh có thanh tiêu đề trên cùng ("Doanh thu hợp nhất", "Cập nhật lúc", "54453 - Dũng Nguyễn Thanh"): bắt đầu ngay dưới thanh tiêu đề
        // - Nếu ảnh đã cắt bỏ thanh tiêu đề (như ảnh chụp phần cuối danh sách): bắt đầu ngay từ đỉnh ảnh (y = 0.002)
        let cacYHeader = phanTu.compactMap { pt -> CGFloat? in
            guard pt.y < 0.15 else { return nil }
            let u = boDau(pt.chu)
            if u.contains("DOANH THU HOP") || u.contains("HOP NHAT") || u.contains("CAP NHAT") ||
               u.contains("DUNG NGUYEN") || (watermark != nil && u.contains(watermark!)) {
                return pt.y + pt.cao
            }
            return nil
        }
        let yBatDauTrang: CGFloat = (cacYHeader.max() ?? -0.01) + 0.010

        let theCotTrai = phanTichCotTheThiDua(phanTu: phanTu, xMin: 0.0, xMax: 0.495, yBatDauTrang: max(0.002, yBatDauTrang), watermark: watermark)
        let theCotPhai = phanTichCotTheThiDua(phanTu: phanTu, xMin: 0.495, xMax: 1.0, yBatDauTrang: max(0.002, yBatDauTrang), watermark: watermark)

        var ketQua: [DongThiDua] = []
        let soHang = max(theCotTrai.count, theCotPhai.count)
        for i in 0..<soHang {
            if i < theCotTrai.count {
                ketQua = KhoDuLieu.gopDanhSachThiDua(cu: ketQua, moi: [theCotTrai[i]])
            }
            if i < theCotPhai.count {
                ketQua = KhoDuLieu.gopDanhSachThiDua(cu: ketQua, moi: [theCotPhai[i]])
            }
        }
        return ketQua
    }

    private func phanTichCotTheThiDua(
        phanTu: [PhanTuVanBan],
        xMin: CGFloat,
        xMax: CGFloat,
        yBatDauTrang: CGFloat,
        watermark: String?
    ) -> [DongThiDua] {
        let xGiua = (xMin + xMax) / 2.0
        let phanTuCot = phanTu.filter { pt in
            let xTam = pt.x + min(pt.rong, 0.15) / 2.0
            return xTam >= xMin && xTam < xMax && pt.y >= yBatDauTrang && pt.y < 0.996
        }
        guard !phanTuCot.isEmpty else { return [] }

        // 1. Tìm toạ độ đỉnh (yDauThe) của từng thẻ trong cột dựa trên:
        //    - Badge "DT" / "SL" ở góc phải trên của thẻ (x >= xMax - 0.13)
        //    - Dòng tiêu đề bắt đầu bằng "T10 -", "T11 -", "T12 -"... ở góc trái trên của thẻ
        var ungVienDauThe: [CGFloat] = []
        for pt in phanTuCot {
            let u = boDau(pt.chu).trimmingCharacters(in: .whitespacesAndNewlines)
            let uGon = u.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
            if pt.x >= xMax - 0.13 && (uGon == "DT" || uGon == "SL" || uGon == "OT" || uGon == "0T" || uGon == "5L" || uGon == "SI") {
                ungVienDauThe.append(pt.y)
            } else if pt.x < xGiua && u.range(of: "^T\\d{1,2}\\b", options: .regularExpression) != nil {
                ungVienDauThe.append(pt.y)
            }
        }
        ungVienDauThe.sort()

        var cacDauThe: [CGFloat] = []
        for y in ungVienDauThe {
            if let cuoi = cacDauThe.last, y - cuoi < 0.12 {
                cacDauThe[cacDauThe.count - 1] = min(cuoi, y)
            } else {
                cacDauThe.append(y)
            }
        }

        // Bổ sung dự phòng nếu có thẻ không bắt đầu bằng T10/T11 và badge DT/SL bị mờ, dựa trên dòng nhãn "THỰC HIỆN" / "TARGET"
        let cacYMocTHTG = phanTuCot.compactMap { pt -> CGFloat? in
            let u = boDau(pt.chu).trimmingCharacters(in: .whitespacesAndNewlines)
            if u.contains("THUC HIEN") || u.hasPrefix("TARGET") {
                return pt.y
            }
            return nil
        }.sorted()

        for yMoc in cacYMocTHTG {
            let daCoDauThe = cacDauThe.contains { yDau in
                yMoc > yDau && (yMoc - yDau) < 0.24
            }
            if !daCoDauThe {
                let yUocLuong = max(yBatDauTrang, yMoc - 0.115)
                if !cacDauThe.contains(where: { abs($0 - yUocLuong) < 0.10 }) {
                    cacDauThe.append(yUocLuong)
                    cacDauThe.sort()
                }
            }
        }

        guard !cacDauThe.isEmpty else { return [] }

        var danhSachThe: [DongThiDua] = []

        for (k, yDau) in cacDauThe.enumerated() {
            let yTrenThe: CGFloat = max(yBatDauTrang, yDau - 0.016)
            let yDuoiThe: CGFloat = (k + 1 < cacDauThe.count)
                ? (cacDauThe[k + 1] - 0.014)
                : 0.996

            let trongThe = phanTuCot.filter { $0.y >= yTrenThe && $0.y <= yDuoiThe }
            guard !trongThe.isEmpty else { continue }

            // 2. Tìm các phần tử % ở nửa trái thẻ (dòng % lớn phía trên thanh tiến độ và dòng % HT NGÀY/THÁNG ở đáy thẻ)
            let cacPhanTuPhanTramTrai = trongThe.filter { pt in
                pt.x < xGiua && pt.chu.contains("%") && chuyenChuoiThanhSoDoanhThu(pt.chu) != nil
            }.sorted { $0.y < $1.y }

            let yBigPct: CGFloat = cacPhanTuPhanTramTrai.first?.y ?? (yDau + 0.055)
            let yBotPct: CGFloat = (cacPhanTuPhanTramTrai.count >= 2)
                ? cacPhanTuPhanTramTrai.last!.y
                : (yDuoiThe - 0.012)

            let phanTramDuBao = cacPhanTuPhanTramTrai.first.flatMap { chuyenChuoiThanhSoDoanhThu($0.chu) }
            let phanTramHT = cacPhanTuPhanTramTrai.last.flatMap { chuyenChuoiThanhSoDoanhThu($0.chu) } ?? phanTramDuBao

            // 3. Xác định ĐVT (DT hay SL) từ nhãn "DT DỰ KIẾN" / "SL DỰ KIẾN" và badge góc phải trên của thẻ
            var loai: LoaiChiTieuThiDua = .doanhThu
            for pt in trongThe {
                let u = boDau(pt.chu).trimmingCharacters(in: .whitespacesAndNewlines)
                let uGon = u.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
                if u.contains("SL DU") || uGon == "SL" || uGon == "5L" {
                    loai = .soLuong
                    break
                } else if u.contains("DT DU") || uGon == "DT" || uGon == "0T" || uGon == "OT" {
                    loai = .doanhThu
                }
            }

            // 4. Lấy Tên ngành hàng / chương trình ở phần đỉnh thẻ (phía trên dòng % lớn, "% HT NGÀY", "DỰ KIẾN HOÀN THÀNH", và dòng ghi chú phụ)
            var yGioiHanTieuDe = yBigPct - 0.004
            for pt in trongThe where pt.y < yBigPct + 0.025 {
                let u = boDau(pt.chu)
                if pt.chu.contains("%") ||
                   u.contains("DU KIEN") ||
                   u.contains("HOAN THANH") ||
                   u.contains("HT NGAY") ||
                   u.contains("HT THANG") ||
                   ((u == "HOAN" || u == "THANH" || u == "HT" || u == "NGAY") && pt.x > xGiua) ||
                   u.contains("KHONG TINH") ||
                   u.contains("TINH HANG") ||
                   u.contains("CHAY THEO") ||
                   u.contains("THUONG HIEU") {
                    yGioiHanTieuDe = min(yGioiHanTieuDe, pt.y - 0.004)
                }
            }

            let phanTuTen = trongThe.filter { pt in
                guard pt.y <= yGioiHanTieuDe else { return false }
                let u = boDau(pt.chu).trimmingCharacters(in: .whitespacesAndNewlines)
                let uGon = u.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
                if uGon == "DT" || uGon == "SL" || uGon == "OT" || uGon == "0T" || uGon == "5L" || uGon == "SI" {
                    return false
                }
                if pt.x >= xMax - 0.125 && uGon.count <= 3 {
                    return false
                }
                if u.contains("KHONG TINH") || u.contains("TINH HANG") || u.contains("CHAY THEO") || u.contains("THUONG HIEU") {
                    return false
                }
                if let wm = watermark, u.contains(wm) || u.contains("DUNG NGUYEN") {
                    return false
                }
                return true
            }

            let sapXepY = phanTuTen.sorted { $0.y < $1.y }
            var cacDongTen: [(y: CGFloat, tu: [PhanTuVanBan])] = []
            for pt in sapXepY {
                if let idx = cacDongTen.indices.last, abs(pt.y - cacDongTen[idx].y) < 0.014 {
                    cacDongTen[idx].tu.append(pt)
                } else {
                    cacDongTen.append((y: pt.y, tu: [pt]))
                }
            }

            let chuoiTen = cacDongTen
                .flatMap { dong in dong.tu.sorted { $0.x < $1.x }.map(\.chu) }
                .joined(separator: " ")

            let tenSach = lamSachTenChuongTrinh(chuoiTen)
            guard tenSach.count >= 2 else { continue }

            // 5. Lấy số THỰC HIỆN (bên trái thẻ) và TARGET / TARGET NGÀY (bên phải thẻ)
            // Lưu ý: Thẻ Realtime chỉ có 1 dòng % (% HT NGÀY ở trên), dòng số Thực hiện & Target ngày nằm sát đáy thẻ
            let yGioiHanDuoiSo: CGFloat = (cacPhanTuPhanTramTrai.count >= 2) ? (yBotPct - 0.010) : yDuoiThe
            let cacYMocTrongThe = trongThe.compactMap { pt -> CGFloat? in
                guard pt.y > yBigPct + 0.015 && pt.y < yGioiHanDuoiSo else { return nil }
                let u = boDau(pt.chu)
                if u.contains("THUC HIEN") || u.hasPrefix("TARGET") || u == "THUC" || u == "HIEN" {
                    return pt.y
                }
                return nil
            }
            let yBatDauSo: CGFloat = (cacYMocTrongThe.min() ?? (yBigPct + (yBotPct - yBigPct) * 0.40)) + 0.003

            let vungSoTHTG = trongThe.filter { pt in
                guard pt.y > yBatDauSo && pt.y < yGioiHanDuoiSo else { return false }
                guard !pt.chu.contains("%") else { return false }
                let u = boDau(pt.chu)
                if u.contains("THUC") || u.contains("HIEN") || u.contains("TARGET") ||
                   u.contains("NGAY") || u.contains("THANG") || u.contains("DU KIEN") || u.contains("HT") {
                    return false
                }
                return true
            }.sorted {
                if abs($0.y - $1.y) < 0.014 { return $0.x < $1.x }
                return $0.y < $1.y
            }

            var thucHien: Double?
            var target: Double?

            for pt in vungSoTHTG {
                let cacSo = trichCacSoTheThiDua(trong: pt.chu)
                if cacSo.count >= 2 && pt.rong > 0.18 {
                    if thucHien == nil { thucHien = cacSo[0] }
                    if target == nil { target = cacSo[1] }
                } else if let so = cacSo.first {
                    if pt.x < xGiua {
                        if thucHien == nil { thucHien = so }
                    } else {
                        if target == nil { target = so }
                    }
                }
            }

            let soTH = thucHien ?? 0.0
            let soTG: Double
            if let tg = target {
                soTG = tg
            } else if soTH > 0, let pt = phanTramHT ?? phanTramDuBao, pt > 0.1 {
                let uocLuong = soTH / (pt / 100.0)
                soTG = (loai == .soLuong) ? uocLuong.rounded() : ((uocLuong * 100).rounded() / 100)
            } else {
                soTG = 0.0
            }

            let dong = DongThiDua(
                tenNganhHangGoc: tenSach,
                tenNganhHang: tenSach,
                loaiChiTieu: loai,
                thucHien: soTH,
                target: soTG,
                phanTramHTGoc: phanTramHT,
                phanTramDuBaoGoc: phanTramDuBao ?? phanTramHT
            )
            danhSachThe.append(dong)
        }

        return danhSachThe
    }

    /// Trích xuất số trong ô THỰC HIỆN / TARGET của thẻ Thi đua (hỗ trợ cả chữ số đơn 0, 1, 5, 8 bị nhận nhầm thành O, I, S, B)
    private func trichCacSoTheThiDua(trong chuoi: String) -> [Double] {
        let sach = chuoi.trimmingCharacters(in: .whitespacesAndNewlines)
        if sach.count == 1 {
            let mapKyTuDon: [String: Double] = [
                "O": 0, "o": 0, "Q": 0, "D": 0,
                "I": 1, "l": 1,
                "Z": 2, "S": 5, "B": 8
            ]
            if let v = mapKyTuDon[sach] {
                return [v]
            }
        }
        return trichCacSo(trong: sach)
    }

    // MARK: - Bước 2A.2: Bộ phân tích bố cục Thi Đua 2 cột theo quy cách Ảnh 1 (Tên + DT/SL + Số) & Ảnh 2 (Chỉ lấy cột Số từ trên xuống)

    private struct DongAnh1Tam {
        var ten: String
        var loai: LoaiChiTieuThiDua
        var giaTriCot1: Double
    }

    private func trichThongTinChungThiDua(phanTu: [PhanTuVanBan]) -> (capNhatLuc: String?, thongTinDonVi: String?, watermark: String?) {
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
        return (capNhatLuc, thongTinDonVi, maNhanVienWatermark)
    }

    /// Ghép cặp Ảnh 1 (lấy Tên ngành hàng + ĐVT DT/SL + Số cột 1 từ trên xuống) và Ảnh 2 (chỉ lấy cột Số từ trên xuống, không quét lại tên ngành hàng)
    private func ghepCapAnhThiDua(
        phanTu1: [PhanTuVanBan],
        watermark1: String?,
        phanTu2: [PhanTuVanBan],
        watermark2: String?
    ) -> [DongThiDua] {
        let (laTarget1, dsAnh1) = trichXuatDongTuAnh1(phanTu: phanTu1, watermark: watermark1)
        let (laTarget2, cacSoAnh2) = trichXuatSoCotPhaiTuTrenXuong(phanTu: phanTu2, watermark: watermark2)

        guard !dsAnh1.isEmpty else {
            // Dự phòng nếu Ảnh 1 là mẫu 5 cột cũ
            let (dsCu1, _, _, _) = phanTichThiDuaOffline(phanTu: phanTu1, tenNganhGoiY: nil)
            let (dsCu2, _, _, _) = phanTichThiDuaOffline(phanTu: phanTu2, tenNganhGoiY: nil)
            return KhoDuLieu.gopDanhSachThiDua(cu: dsCu1, moi: dsCu2)
        }

        // Xác định Ảnh 1 là cột TARGET hay cột THỰC HIỆN (Doanh thu/Số lượng đạt được)
        let anh1LaTarget: Bool
        if let t1 = laTarget1, let t2 = laTarget2, t1 != t2 {
            anh1LaTarget = t1
        } else if let t1 = laTarget1 {
            anh1LaTarget = t1
        } else if let t2 = laTarget2 {
            anh1LaTarget = !t2
        } else {
            anh1LaTarget = true
        }

        var ketQua: [DongThiDua] = []
        for (i, d1) in dsAnh1.enumerated() {
            let soAnh1 = d1.giaTriCot1
            let soAnh2: Double = (i < cacSoAnh2.count) ? cacSoAnh2[i].giaTri : 0
            let dong = DongThiDua(
                tenNganhHangGoc: d1.ten,
                tenNganhHang: d1.ten,
                loaiChiTieu: d1.loai,
                thucHien: anh1LaTarget ? soAnh2 : soAnh1,
                target: anh1LaTarget ? soAnh1 : soAnh2
            )
            ketQua.append(dong)
        }
        return ketQua
    }

    private func phanTichThiDuaHaiCot(phanTu: [PhanTuVanBan], watermark: String?) -> [DongThiDua] {
        let (laTarget, dsAnh1) = trichXuatDongTuAnh1(phanTu: phanTu, watermark: watermark)
        guard !dsAnh1.isEmpty else { return [] }
        let laCotTarget = laTarget ?? true
        return dsAnh1.map { d in
            DongThiDua(
                tenNganhHangGoc: d.ten,
                tenNganhHang: d.ten,
                loaiChiTieu: d.loai,
                thucHien: laCotTarget ? 0 : d.giaTriCot1,
                target: laCotTarget ? d.giaTriCot1 : 0
            )
        }
    }

    /// Xác định vùng tiêu đề ("CHƯƠNG TRÌNH", "TARGET" / "ARGET", "THỰC HIỆN") và trích xuất danh sách con số ở cột phải từ trên xuống
    private func trichXuatSoCotPhaiTuTrenXuong(
        phanTu: [PhanTuVanBan],
        watermark: String?
    ) -> (laCotTarget: Bool?, cacSo: [(y: CGFloat, giaTri: Double)]) {
        let vungHeader = phanTu.filter { $0.y > 0.08 && $0.y < 0.33 }
        let mocChuongTrinh = vungHeader.first { boDau($0.chu).contains("CHUONG TRINH") }
        let mocTarget = vungHeader.first { pt in
            let u = boDau(pt.chu)
            return pt.x > 0.50 && (u.contains("TARGET") || u.contains("ARGET"))
        }
        let mocThucHien = vungHeader.first { pt in
            let u = boDau(pt.chu)
            return pt.x > 0.50 && u.contains("THUC HIEN")
        }

        var laCotTarget: Bool?
        if let mt = mocTarget, let mth = mocThucHien {
            laCotTarget = mt.x >= mth.x
        } else if mocTarget != nil {
            laCotTarget = true
        } else if mocThucHien != nil {
            laCotTarget = false
        } else if phanTu.contains(where: { $0.y < 0.32 && $0.x > 0.55 && boDau($0.chu).contains("ARGET") }) {
            laCotTarget = true
        } else if phanTu.contains(where: { $0.y < 0.32 && $0.x > 0.55 && boDau($0.chu).contains("THUC HIEN") }) {
            laCotTarget = false
        }

        let yHeader = max(
            mocChuongTrinh?.y ?? 0,
            max(mocTarget?.y ?? 0, mocThucHien?.y ?? 0)
        )
        let yBatDau: CGFloat = (yHeader > 0.08) ? (yHeader + 0.015) : 0.21

        // Chỉ lấy các phần tử là con số thuần túy ở cột bên phải (x >= 0.64) từ trên xuống dưới
        let ungVien = phanTu.compactMap { pt -> (y: CGFloat, x: CGFloat, giaTri: Double)? in
            guard (pt.x >= 0.64 || (pt.x >= 0.58 && pt.x + pt.rong >= 0.78)),
                  pt.y > yBatDau,
                  pt.y < 0.98 else {
                return nil
            }
            if let wm = watermark, pt.chu.contains(wm) { return nil }
            guard let so = chuyenTokenSoCotPhai(pt.chu) else { return nil }
            return (y: pt.y, x: pt.x, giaTri: so)
        }.sorted {
            if abs($0.y - $1.y) < 0.014 { return $0.x > $1.x }
            return $0.y < $1.y
        }

        // Gom các số cùng 1 hàng ngang (nếu có) để mỗi dòng từ trên xuống chỉ có đúng 1 con số
        var cacSoTheoHang: [(y: CGFloat, giaTri: Double)] = []
        for item in ungVien {
            if let last = cacSoTheoHang.last, abs(item.y - last.y) < 0.018 {
                continue
            }
            cacSoTheoHang.append((y: item.y, giaTri: item.giaTri))
        }

        return (laCotTarget, cacSoTheoHang)
    }

    /// Trích xuất từ Ảnh 1 theo thứ tự từ trên xuống: Tên ngành hàng + Đơn vị tính (DT/SL) + Con số cột phải của Ảnh 1
    private func trichXuatDongTuAnh1(
        phanTu: [PhanTuVanBan],
        watermark: String?
    ) -> (laCotTarget: Bool?, danhSach: [DongAnh1Tam]) {
        let (laCotTarget, cacSoPhai) = trichXuatSoCotPhaiTuTrenXuong(phanTu: phanTu, watermark: watermark)
        guard !cacSoPhai.isEmpty else { return (laCotTarget, []) }

        let vungHeader = phanTu.filter { $0.y > 0.08 && $0.y < 0.33 }
        let mocChuongTrinh = vungHeader.first { boDau($0.chu).contains("CHUONG TRINH") }
        let mocTarget = vungHeader.first { pt in
            let u = boDau(pt.chu)
            return pt.x > 0.50 && (u.contains("TARGET") || u.contains("ARGET"))
        }
        let mocThucHien = vungHeader.first { pt in
            let u = boDau(pt.chu)
            return pt.x > 0.50 && u.contains("THUC HIEN")
        }
        let yHeader = max(
            mocChuongTrinh?.y ?? 0,
            max(mocTarget?.y ?? 0, mocThucHien?.y ?? 0)
        )
        let yBatDau: CGFloat = (yHeader > 0.08) ? (yHeader + 0.015) : 0.21

        // Mỗi dòng k kết thúc tại toạ độ Y của con số thứ k (cùng dòng với ĐML_QNG_QNG - 275 Quang Trung)
        // và bắt đầu ngay bên dưới con số của dòng k-1
        var ketQua: [DongAnh1Tam] = []
        for (k, soHang) in cacSoPhai.enumerated() {
            let yTren: CGFloat = (k == 0) ? yBatDau : (cacSoPhai[k - 1].y + 0.008)
            let yDuoi: CGFloat = soHang.y + 0.012

            let phanTuTrongHang = phanTu.filter { pt in
                guard pt.x < 0.68 && pt.y > yTren && pt.y <= yDuoi else { return false }
                let u = boDau(pt.chu)
                if u.contains("CHUONG TRINH") || u.contains("CAN DICH") || u.contains("CHUA DAT") ||
                   u.contains("NGANH HANG") || u.contains("NHOM HANG") || u.contains("TAT CA (") {
                    return false
                }
                if let wm = watermark, u.contains(wm) || u.contains("DUNG NGUYEN") {
                    return false
                }
                return true
            }

            // 1. Xác định đơn vị tính DT / SL của dòng k (từ cả badge DT/SL bên phải và chữ "doanh thu" / "số lượng" trong tên)
            var coBadgeSL = false
            var coBadgeDT = false
            for pt in phanTuTrongHang {
                let u = boDau(pt.chu).trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
                if u == "SL" || u == "5L" {
                    coBadgeSL = true
                } else if u == "DT" || u == "0T" {
                    coBadgeDT = true
                }
            }

            // 2. Gom các phần tử chữ tạo nên Tên ngành hàng (bỏ dòng siêu thị ĐML_/ĐMX_/TGDĐ_ và bỏ badge DT/SL rời)
            let phanTuTen = phanTuTrongHang.filter { pt in
                let chuSach = pt.chu.trimmingCharacters(in: .whitespacesAndNewlines)
                let u = boDau(chuSach)
                let uGon = u.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

                // Bỏ badge DT / SL đứng riêng
                if uGon == "DT" || uGon == "SL" || uGon == "5L" || uGon == "0T" {
                    return false
                }
                // Bỏ dòng tên siêu thị (VD: "ĐML_QNG_QNG - 275 Quang Trung")
                if chuSach.hasPrefix("ĐML_") || chuSach.hasPrefix("ĐMX_") || chuSach.hasPrefix("TGDĐ_") ||
                   u.hasPrefix("DML_") || u.hasPrefix("DMX_") || u.hasPrefix("TGDD_") ||
                   u.contains("QUANG TRUNG") ||
                   u.range(of: "^[A-Z0-9]{2,5}_[A-Z0-9]{2,5}", options: .regularExpression) != nil {
                    return false
                }
                if laChuoiRac(chuSach, watermark: watermark) {
                    return false
                }
                // Không lấy nhầm phần tử quá sát cột số bên phải
                if pt.x >= 0.58 && chuyenTokenSoCotPhai(chuSach) != nil {
                    return false
                }
                return true
            }.sorted {
                if abs($0.y - $1.y) < 0.012 { return $0.x < $1.x }
                return $0.y < $1.y
            }

            let chuoiGop = phanTuTen.map(\.chu).joined(separator: " ")
            let uGop = boDau(chuoiGop)

            // Xác định chính xác DT (.doanhThu) hay SL (.soLuong)
            let loai: LoaiChiTieuThiDua
            if uGop.contains("SO LUONG") || uGop.range(of: "\\bSL\\s*$", options: .regularExpression) != nil {
                loai = .soLuong
            } else if uGop.contains("DOANH THU") || uGop.range(of: "\\bDT\\s*$", options: .regularExpression) != nil {
                loai = .doanhThu
            } else if coBadgeSL && !coBadgeDT {
                loai = .soLuong
            } else {
                loai = .doanhThu
            }

            // Làm sạch tên ngành hàng (loại bỏ dấu trừ đầu dòng, nhãn DT/SL cuối dòng và dấu | thừa ở rìa)
            let tenSach = lamSachTenChuongTrinh(chuoiGop)
            guard tenSach.count >= 2 else { continue }

            ketQua.append(DongAnh1Tam(ten: tenSach, loai: loai, giaTriCot1: soHang.giaTri))
        }

        return (laCotTarget, ketQua)
    }

    /// Chỉ nhận token thuần số ở cột bên phải (VD: "237,51", "30", "111", "9", "44,44")
    private func chuyenTokenSoCotPhai(_ chuoi: String) -> Double? {
        let s = chuoi
            .replacingOccurrences(of: "…", with: "")
            .replacingOccurrences(of: "...", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty else { return nil }
        // Không nhận chuỗi có chứa chữ cái (tránh nhầm với T10, 275 Quang Trung, DT, SL...)
        if s.range(of: "[A-Za-zÀ-ỹĐđ_]", options: .regularExpression) != nil {
            return nil
        }
        guard s.range(of: "^[+\\-]?\\d+([.,]\\d+)*$", options: .regularExpression) != nil else {
            return nil
        }
        return chuyenChuoiThanhSoDoanhThu(s)
    }

    /// Làm sạch tên chương trình: bỏ dấu trừ đầu dòng, bỏ chữ DT/SL hoặc dấu | thừa ở cuối dòng
    private func lamSachTenChuongTrinh(_ chuoi: String) -> String {
        let s = chuoi
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "^[\\s\\-–—−•◦○●⊕⊖|¦/\\\\,:;]+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "(?:\\s+|\\s*[\\|¦]\\s*)\\b(DT|SL|5L|0T)\\b\\s*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\.\\.\\.|…", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\|\\s*\\|+", with: "|", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return s
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
