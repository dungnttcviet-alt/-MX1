import UIKit

struct DongThiDuaNhanVienQuet: Hashable {
    var maNV: String
    var hoTen: String
    var thucHien: Double
    var target: Double
    var laPhanTram: Bool = false
    var laPhanTramTargetCaNhan: Bool = false
}

struct KetQuaThiDuaNhanVienKhoi: Hashable {
    var tenNganhHang: String
    var danhSach: [DongThiDuaNhanVienQuet]
    var thucHienNganhGoiY: Double = 0
    var targetNganhGoiY: Double = 0
}

struct KetQuaQuetThiDua {
    var danhSach: [DongThiDua]
    var thiDuaNhanVien: [KetQuaThiDuaNhanVienKhoi]
    var doanhThuQuetDuoc: ThongTinDoanhThu?
    var sucKhoeNhanVien: [String: DuLieuSucKhoeBoSungNV] = [:]
    var capNhatLuc: String
    var thongTinDonVi: String
}

struct KetQuaQuetTatCaAnh {
    var doanhThu: ThongTinDoanhThu?
    var soAnhDoanhThu: Int = 0

    var danhSachThiDua: [DongThiDua] = []
    var soAnhThiDua: Int = 0

    var doanhThuNhanVien: [DoanhThuNhanVienItem] = []
    var soAnhDoanhThuNV: Int = 0

    var gioCongNhanVien: [DoanhThuNhanVienItem] = []
    var soAnhGioCongNV: Int = 0

    var thiDuaNhanVien: [KetQuaThiDuaNhanVienKhoi] = []
    var soAnhThiDuaNV: Int = 0

    var sucKhoeNhanVien: [String: DuLieuSucKhoeBoSungNV] = [:]
    var soAnhSucKhoeNV: Int = 0

    var capNhatLuc: String = ""
    var thongTinDonVi: String = ""

    var coDuLieu: Bool {
        (doanhThu?.coDuLieu ?? false) ||
        !danhSachThiDua.isEmpty ||
        !doanhThuNhanVien.isEmpty ||
        !gioCongNhanVien.isEmpty ||
        !thiDuaNhanVien.isEmpty ||
        !sucKhoeNhanVien.isEmpty
    }
}

/// Bộ điều phối quét ảnh chỉ dùng Gemini Vision + tiền xử lý gỡ watermark (đã bỏ hoàn toàn Apple Vision OCR offline để tránh treo/crash app).
final class DichVuDocAnh {
    static let dungChung = DichVuDocAnh()
    private init() {}

    /// Thông điệp lỗi rõ ràng gần nhất từ Gemini (nil nếu lần quét gần nhất thành công).
    private(set) var loiGeminiGanNhat: String?

    // MARK: - Tiền xử lý gỡ watermark chữ chìm trên ảnh đã thu gọn

    /// Xóa sạch chữ chìm watermark màu xám trung tính (độ sáng >= 205, ví dụ "54453 / Dũng Nguyễn Thanh") trên ảnh đã thu gọn.
    /// Bọc autoreleasepool và giới hạn <= 4.5MP để giải phóng RAM ngay lập tức, tuyệt đối không gây tràn RAM/crash trên ảnh dài hoặc siêu rộng.
    static func xoaWatermarkChuChim(_ anh: UIImage) -> UIImage {
        return autoreleasepool {
            guard let cgGoc = anh.cgImage else { return anh }
            let rong = cgGoc.width
            let cao = cgGoc.height
            guard rong > 20, cao > 20, rong * cao <= 4_500_000 else { return anh }

            let bytesPerRow = rong * 4
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let ctx = CGContext(
                data: nil,
                width: rong,
                height: cao,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else {
                return anh
            }

            ctx.draw(cgGoc, in: CGRect(x: 0, y: 0, width: rong, height: cao))
            guard let data = ctx.data else { return anh }
            let ptr = data.bindMemory(to: UInt8.self, capacity: rong * cao * 4)
            let tongPixel = rong * cao

            for i in 0..<tongPixel {
                let offset = i * 4
                let r = Int(ptr[offset])
                let g = Int(ptr[offset + 1])
                let b = Int(ptr[offset + 2])

                let mx = max(r, max(g, b))
                let mn = min(r, min(g, b))
                // Chỉ làm sạch pixel xám trung tính (giữ nguyên toàn bộ thẻ màu, badge % và thanh tiến độ)
                if (mx - mn) <= 22 {
                    let gray = (r * 299 + g * 587 + b * 114) / 1000
                    let outV: UInt8
                    if gray >= 205 {
                        outV = 255
                    } else if gray <= 35 {
                        outV = 0
                    } else {
                        outV = UInt8(((gray - 35) * 255) / 170)
                    }
                    ptr[offset] = outV
                    ptr[offset + 1] = outV
                    ptr[offset + 2] = outV
                }
            }

            guard let cgSach = ctx.makeImage() else { return anh }
            return UIImage(cgImage: cgSach, scale: anh.scale, orientation: anh.imageOrientation)
        }
    }

    private func ghiNhanLoi(_ error: Error, tienTrinh: ((String) -> Void)?) {
        let thongDiep = error.localizedDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let loi = thongDiep.isEmpty ? "Gemini không phản hồi. Vui lòng kiểm tra mạng hoặc API Key trong Cài đặt." : thongDiep
        loiGeminiGanNhat = loi
        tienTrinh?("⚠️ Lỗi Gemini: \(loi)")
    }

    // MARK: - 1. Quét & phân loại tổng hợp tất cả loại ảnh bằng Gemini

    func quetVaPhanLoaiTatCaAnh(
        danhSachAnh: [UIImage],
        ngay: Date,
        cheDoDangChon: LoaiCheDoDoanhThu,
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetTatCaAnh) -> Void
    ) {
        loiGeminiGanNhat = nil
        DichVuQuetAnhGemini.dungChung.quet(
            danhSachAnh: danhSachAnh,
            cheDo: cheDoDangChon,
            tienTrinh: tienTrinh
        ) { [weak self] ketQuaGemini in
            switch ketQuaGemini {
            case .success(var kq):
                if !kq.thiDuaNhanVien.isEmpty {
                    kq.thiDuaNhanVien = DichVuQuetAnhGemini.dungChung.gopVaLamSachKhoiThiDuaNhanVien(kq.thiDuaNhanVien)
                }
                if kq.capNhatLuc.isEmpty {
                    kq.capNhatLuc = TienIchNgay.hienThiGioPhut.string(from: Date())
                }
                hoanTat(kq)
            case .failure(let err):
                self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                hoanTat(KetQuaQuetTatCaAnh())
            }
        }
    }

    // MARK: - 2. Quét ảnh bảng Thi đua các môn bằng Gemini

    func quetAnhThiDua(
        danhSachAnh: [UIImage],
        danhSachHienCo: [DongThiDua] = [],
        laRealtime: Bool = false,
        tenNganhGoiY: String? = nil,
        tienTrinh: @escaping (String) -> Void,
        hoanTat: @escaping (KetQuaQuetThiDua) -> Void
    ) {
        loiGeminiGanNhat = nil
        let cheDo: LoaiCheDoDoanhThu = laRealtime ? .realtime : .luyKe
        DichVuQuetAnhGemini.dungChung.quet(
            danhSachAnh: danhSachAnh,
            cheDo: cheDo,
            tienTrinh: tienTrinh
        ) { [weak self] ketQuaGemini in
            switch ketQuaGemini {
            case .success(let kqG):
                let dsGop = !danhSachHienCo.isEmpty
                    ? KhoDuLieu.gopDanhSachThiDua(cu: danhSachHienCo, moi: kqG.danhSachThiDua)
                    : KhoDuLieu.gopDanhSachThiDua(cu: [], moi: kqG.danhSachThiDua)
                let ketQua = KetQuaQuetThiDua(
                    danhSach: dsGop,
                    thiDuaNhanVien: kqG.thiDuaNhanVien,
                    doanhThuQuetDuoc: (kqG.doanhThu?.coDuLieu ?? false) ? kqG.doanhThu : nil,
                    sucKhoeNhanVien: kqG.sucKhoeNhanVien,
                    capNhatLuc: kqG.capNhatLuc.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : kqG.capNhatLuc,
                    thongTinDonVi: kqG.thongTinDonVi
                )
                hoanTat(ketQua)
            case .failure(let err):
                self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                hoanTat(KetQuaQuetThiDua(
                    danhSach: [],
                    thiDuaNhanVien: [],
                    doanhThuQuetDuoc: nil,
                    sucKhoeNhanVien: [:],
                    capNhatLuc: "",
                    thongTinDonVi: ""
                ))
            }
        }
    }

    // MARK: - 3. Quét ảnh Ma trận Thi đua Nhân viên bằng Gemini

    func quetAnhThiDuaNhanVien(
        danhSachAnh: [UIImage],
        tenNganhGoiY: String? = nil,
        maNVGoiY: String? = nil,
        tienTrinh: ((String) -> Void)? = nil,
        hoanTatSucKhoe: (([String: DuLieuSucKhoeBoSungNV]) -> Void)? = nil,
        hoanTat: @escaping ([KetQuaThiDuaNhanVienKhoi]) -> Void
    ) {
        loiGeminiGanNhat = nil
        DichVuQuetAnhGemini.dungChung.quetThiDuaNhanVien(
            danhSachAnh: danhSachAnh,
            cheDo: .luyKe,
            tienTrinh: tienTrinh
        ) { [weak self] ketQuaGemini in
            switch ketQuaGemini {
            case .success(let cacKhoiGemini) where !cacKhoiGemini.isEmpty:
                let ketQuaSach = DichVuQuetAnhGemini.dungChung.gopVaLamSachKhoiThiDuaNhanVien(cacKhoiGemini)
                hoanTat(ketQuaSach)
            case .success:
                self?.loiGeminiGanNhat = "Gemini không tìm thấy bảng Thi đua Nhân viên hợp lệ trong ảnh."
                tienTrinh?("⚠️ Gemini không tìm thấy bảng Thi đua Nhân viên hợp lệ trong ảnh.")
                hoanTat([])
            case .failure(let err):
                self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                hoanTat([])
            }
        }
    }

    // MARK: - 4. Quét ảnh Doanh thu Siêu thị bằng Gemini

    func quetAnhDoanhThu(
        danhSachAnh: [UIImage],
        laRealtime: Bool = false,
        tienTrinh: ((String) -> Void)? = nil,
        hoanTat: @escaping (ThongTinDoanhThu) -> Void
    ) {
        loiGeminiGanNhat = nil
        let cheDo: LoaiCheDoDoanhThu = laRealtime ? .realtime : .luyKe
        DichVuQuetAnhGemini.dungChung.quet(
            danhSachAnh: danhSachAnh,
            cheDo: cheDo,
            tienTrinh: { tienTrinh?($0) }
        ) { [weak self] ketQuaGemini in
            switch ketQuaGemini {
            case .success(let kq):
                hoanTat(kq.doanhThu ?? ThongTinDoanhThu())
            case .failure(let err):
                self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                hoanTat(ThongTinDoanhThu())
            }
        }
    }

    // MARK: - 5. Quét ảnh Doanh thu Nhân viên / Phiếu Sức khỏe bằng Gemini

    func quetAnhDoanhThuNhanVien(
        danhSachAnh: [UIImage],
        maNVGoiY: String? = nil,
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        uuTienPhieuSucKhoe: Bool = false,
        tienTrinh: ((String) -> Void)? = nil,
        hoanTatSucKhoe: (([String: DuLieuSucKhoeBoSungNV]) -> Void)? = nil,
        hoanTat: @escaping ([DoanhThuNhanVienItem]) -> Void
    ) {
        loiGeminiGanNhat = nil
        if uuTienPhieuSucKhoe {
            tienTrinh?("⚡ Gemini đang quét phiếu Sức khỏe nhân viên...")
            DichVuQuetAnhGemini.dungChung.quet(
                danhSachAnh: danhSachAnh,
                cheDo: cheDo,
                tienTrinh: { tienTrinh?($0) }
            ) { [weak self] ketQuaGemini in
                switch ketQuaGemini {
                case .success(let kq):
                    if !kq.sucKhoeNhanVien.isEmpty {
                        hoanTatSucKhoe?(kq.sucKhoeNhanVien)
                    }
                    hoanTat(kq.doanhThuNhanVien)
                case .failure(let err):
                    self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                    hoanTat([])
                }
            }
            return
        }

        tienTrinh?("⚡ Gemini đang quét \(danhSachAnh.count) ảnh Doanh thu NV...")
        DichVuQuetAnhGemini.dungChung.quetDoanhThuNhanVien(
            danhSachAnh: danhSachAnh,
            cheDo: cheDo,
            tienTrinh: tienTrinh
        ) { [weak self] ketQuaGemini in
            switch ketQuaGemini {
            case .success(let dsGemini):
                hoanTat(dsGemini)
            case .failure(let err):
                self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                hoanTat([])
            }
        }
    }

    // MARK: - 6. Quét ảnh Giờ công Nhân viên bằng Gemini

    func quetAnhGioCongNhanVien(
        danhSachAnh: [UIImage],
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        tienTrinh: ((String) -> Void)? = nil,
        hoanTat: @escaping ([DoanhThuNhanVienItem]) -> Void
    ) {
        loiGeminiGanNhat = nil
        tienTrinh?("⚡ Gemini đang quét \(danhSachAnh.count) ảnh Giờ công NV...")
        DichVuQuetAnhGemini.dungChung.quetGioCongNhanVien(
            danhSachAnh: danhSachAnh,
            cheDo: cheDo,
            tienTrinh: tienTrinh
        ) { [weak self] ketQuaGemini in
            switch ketQuaGemini {
            case .success(let dsGemini):
                hoanTat(DichVuQuetAnhGemini.dungChung.lamSachDanhSachGioCongNhanVien(dsGemini))
            case .failure(let err):
                self?.ghiNhanLoi(err, tienTrinh: tienTrinh)
                hoanTat([])
            }
        }
    }
}
