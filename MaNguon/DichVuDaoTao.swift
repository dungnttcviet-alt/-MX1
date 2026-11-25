import Foundation

// MARK: - Mô hình Đào tạo & Huấn luyện nhân sự (Coaching 1-1)

enum NguyenNhanKemCap: String, Codable, CaseIterable {
    case kienThucSanPham = "kienThucSanPham"
    case kyNangChotDon = "kyNangChotDon"
    case tuVanTraGop = "tuVanTraGop"
    case banKemPhuKien = "banKemPhuKien"
    case kyLuatCaLamViec = "kyLuatCaLamViec"
    case khac = "khac"

    var tieuDe: String {
        switch self {
        case .kienThucSanPham: return "Kiến thức sản phẩm & tư vấn"
        case .kyNangChotDon: return "Kỹ năng chốt đơn & xử lý từ chối"
        case .tuVanTraGop: return "Tư vấn trả góp & quy đổi"
        case .banKemPhuKien: return "Chào bán kèm & phụ kiện"
        case .kyLuatCaLamViec: return "Tác phong & bám sát chỉ tiêu ca"
        case .khac: return "Nguyên nhân khác"
        }
    }
}

enum TrangThaiKemCap: String, Codable, CaseIterable {
    case dangTheoDoi = "dangTheoDoi"
    case daHoanThanh = "daHoanThanh"
    case canKemLai = "canKemLai"

    var tieuDe: String {
        switch self {
        case .dangTheoDoi: return "Đang theo dõi"
        case .daHoanThanh: return "Đã hoàn thành"
        case .canKemLai: return "Cần kèm lại"
        }
    }
}

struct PhienKemCapNhanVien: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var maNV: String
    var hoTenNV: String
    /// Định dạng yyyy-MM-dd theo TienIchNgay.khoa
    var ngayTao: String
    /// Định dạng yyyy-MM-dd theo TienIchNgay.khoa
    var hanKiemTra: String
    /// Rỗng nghĩa là kèm cặp tổng thể sức khỏe nhân viên
    var nganhHangMucTieu: String
    var khoaNganhMucTieu: String
    var nguyenNhan: NguyenNhanKemCap
    var hanhDongCamKet: String
    var maNVMentor: String
    var hoTenNVMentor: String
    var trangThai: TrangThaiKemCap
    var ketQuaGhiChu: String
    var nguoiTao: String
    var capNhatLuc: TimeInterval

    init(
        id: UUID = UUID(),
        maNV: String,
        hoTenNV: String,
        ngayTao: String,
        hanKiemTra: String,
        nganhHangMucTieu: String = "",
        khoaNganhMucTieu: String = "",
        nguyenNhan: NguyenNhanKemCap = .kienThucSanPham,
        hanhDongCamKet: String = "",
        maNVMentor: String = "",
        hoTenNVMentor: String = "",
        trangThai: TrangThaiKemCap = .dangTheoDoi,
        ketQuaGhiChu: String = "",
        nguoiTao: String = "",
        capNhatLuc: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.id = id
        self.maNV = KhoDuLieu.chuanHoaMaNV(maNV).isEmpty ? maNV.trimmingCharacters(in: .whitespacesAndNewlines) : KhoDuLieu.chuanHoaMaNV(maNV)
        self.hoTenNV = hoTenNV.trimmingCharacters(in: .whitespacesAndNewlines)
        self.ngayTao = ngayTao
        self.hanKiemTra = hanKiemTra
        let tenSach = nganhHangMucTieu.trimmingCharacters(in: .whitespacesAndNewlines)
        self.nganhHangMucTieu = tenSach
        let khoaSach = khoaNganhMucTieu.trimmingCharacters(in: .whitespacesAndNewlines)
        self.khoaNganhMucTieu = !khoaSach.isEmpty
            ? khoaSach
            : (tenSach.isEmpty ? "" : KhoDuLieu.chuanHoaTenMonThiDuaChuan(tenSach))
        self.nguyenNhan = nguyenNhan
        self.hanhDongCamKet = hanhDongCamKet.trimmingCharacters(in: .whitespacesAndNewlines)
        self.maNVMentor = KhoDuLieu.chuanHoaMaNV(maNVMentor)
        self.hoTenNVMentor = hoTenNVMentor.trimmingCharacters(in: .whitespacesAndNewlines)
        self.trangThai = trangThai
        self.ketQuaGhiChu = ketQuaGhiChu.trimmingCharacters(in: .whitespacesAndNewlines)
        self.nguoiTao = nguoiTao.trimmingCharacters(in: .whitespacesAndNewlines)
        self.capNhatLuc = capNhatLuc
    }

    var tenMucTieuHienThi: String {
        nganhHangMucTieu.isEmpty ? "Tổng thể sức khỏe nhân viên" : nganhHangMucTieu
    }

    var coMentor: Bool {
        !hoTenNVMentor.isEmpty
    }
}

// MARK: - Kết quả phân tích thực tế (Gợi ý Mentor & Hiệu quả Trước/Sau)

struct GoiYMentor: Hashable {
    var nhanVien: NhanVienQuanLy
    var tenNganhHang: String
    var phanTramHT: Double
    var thucHien: Double
    var targetCaNhan: Double
    var laTongThe: Bool

    var moTaNgan: String {
        let ptStr = String(format: "%.1f%%", phanTramHT)
        if laTongThe {
            return "\(nhanVien.hoTen) (HT TB \(ptStr))"
        }
        return "\(nhanVien.hoTen) (\(ptStr))"
    }
}

struct HieuQuaKemCap: Hashable {
    var phanTramTruoc: Double?
    var soNgayTruoc: Int
    var phanTramSau: Double?
    var soNgaySau: Int

    var chenhLech: Double? {
        guard let truoc = phanTramTruoc, let sau = phanTramSau else { return nil }
        return sau - truoc
    }

    var moTaHieuQua: String {
        let chuoiTruoc: String
        if let tr = phanTramTruoc, soNgayTruoc > 0 {
            chuoiTruoc = String(format: "Trước (%d ngày): %.1f%%", soNgayTruoc, tr)
        } else {
            chuoiTruoc = "Trước: chưa có số liệu"
        }

        let chuoiSau: String
        if let sa = phanTramSau, soNgaySau > 0 {
            chuoiSau = String(format: "Sau (%d ngày): %.1f%%", soNgaySau, sa)
        } else {
            chuoiSau = "Sau: chờ dữ liệu mới"
        }

        if let delta = chenhLech {
            let dau = delta >= 0 ? "+" : ""
            return "\(chuoiTruoc) → \(chuoiSau) (\(dau)\(String(format: "%.1f%%", delta)))"
        }
        return "\(chuoiTruoc) → \(chuoiSau)"
    }
}

// MARK: - Dịch vụ Đào tạo & Huấn luyện (Tính toán 100% từ dữ liệu thực tế trong KhoDuLieu)

final class DichVuDaoTao {
    static let dungChung = DichVuDaoTao()

    private init() {}

    /// Lưu thêm hoặc cập nhật 1 phiên kèm cặp vào CaiDatDMX (tự động ghi bất đồng bộ & đồng bộ Supabase)
    func luuPhienKemCap(_ phien: PhienKemCapNhanVien) {
        var caiDatMoi = KhoDuLieu.dungChung.caiDat
        var phienCapNhat = phien
        phienCapNhat.capNhatLuc = Date().timeIntervalSince1970

        if let idx = caiDatMoi.nhatKyDaoTao.firstIndex(where: { $0.id == phienCapNhat.id }) {
            caiDatMoi.nhatKyDaoTao[idx] = phienCapNhat
        } else {
            caiDatMoi.nhatKyDaoTao.insert(phienCapNhat, at: 0)
        }
        caiDatMoi.nhatKyDaoTao.sort {
            if $0.ngayTao != $1.ngayTao { return $0.ngayTao > $1.ngayTao }
            return $0.capNhatLuc > $1.capNhatLuc
        }
        KhoDuLieu.dungChung.luuCaiDat(caiDatMoi)
    }

    /// Xóa 1 phiên kèm cặp khỏi nhật ký
    func xoaPhienKemCap(id: UUID) {
        var caiDatMoi = KhoDuLieu.dungChung.caiDat
        caiDatMoi.nhatKyDaoTao.removeAll { $0.id == id }
        KhoDuLieu.dungChung.luuCaiDat(caiDatMoi)
    }

    /// Lấy toàn bộ danh sách phiên kèm cặp, có thể lọc theo mã nhân viên hoặc trạng thái
    func danhSachPhien(locMaNV: String? = nil, trangThai: TrangThaiKemCap? = nil) -> [PhienKemCapNhanVien] {
        let maChuan = locMaNV.map { KhoDuLieu.chuanHoaMaNV($0) } ?? ""
        return KhoDuLieu.dungChung.caiDat.nhatKyDaoTao.filter { phien in
            if !maChuan.isEmpty && KhoDuLieu.chuanHoaMaNV(phien.maNV) != maChuan {
                return false
            }
            if let tt = trangThai, phien.trangThai != tt {
                return false
            }
            return true
        }
    }

    /// Gợi ý Mentor giỏi nhất theo đúng ngành hàng yếu dựa trên số liệu thực tế trong ngày
    func goiYMentor(
        choNganhHang tenNganhHang: String,
        loaiTruMaNV: String,
        den ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        gioiHan: Int = 3
    ) -> [GoiYMentor] {
        let dsTongHop = KhoDuLieu.dungChung.tongHopNhanVien(
            den: ngay,
            sapXep: .phanTramHoanThanhTB,
            cheDo: cheDo
        )
        return Self.tinhGoiYMentor(
            tu: dsTongHop,
            choNganhHang: tenNganhHang,
            loaiTruMaNV: loaiTruMaNV,
            gioiHan: gioiHan
        )
    }

    /// Hàm thuần tính gợi ý Mentor (tách riêng để kiểm thử đơn vị chính xác)
    static func tinhGoiYMentor(
        tu danhSachTongHop: [TongHopNhanVien],
        choNganhHang tenNganhHang: String,
        loaiTruMaNV: String,
        gioiHan: Int = 3
    ) -> [GoiYMentor] {
        let maLoaiTru = KhoDuLieu.chuanHoaMaNV(loaiTruMaNV)
        let tenSach = tenNganhHang.trimmingCharacters(in: .whitespacesAndNewlines)
        let khoaCanTim = KhoDuLieu.chuanHoaTenMonThiDuaChuan(tenSach).lowercased()

        if !tenSach.isEmpty {
            var ungVien: [GoiYMentor] = []
            for nv in danhSachTongHop {
                guard KhoDuLieu.chuanHoaMaNV(nv.nhanVien.maNV) != maLoaiTru else { continue }
                if let mon = nv.cacMonGiao.first(where: { mon in
                    let k1 = KhoDuLieu.chuanHoaTenMonThiDuaChuan(mon.tenNganhHang).lowercased()
                    let k2 = mon.khoaNganh.lowercased()
                    return k1 == khoaCanTim || k2 == khoaCanTim || mon.tenNganhHang.caseInsensitiveCompare(tenSach) == .orderedSame
                }), mon.targetCaNhan > 0, mon.thucHien > 0 {
                    ungVien.append(GoiYMentor(
                        nhanVien: nv.nhanVien,
                        tenNganhHang: mon.tenNganhHang,
                        phanTramHT: mon.phanTramHT,
                        thucHien: mon.thucHien,
                        targetCaNhan: mon.targetCaNhan,
                        laTongThe: false
                    ))
                }
            }
            ungVien.sort {
                if abs($0.phanTramHT - $1.phanTramHT) > 0.01 { return $0.phanTramHT > $1.phanTramHT }
                return $0.thucHien > $1.thucHien
            }
            return Array(ungVien.prefix(max(1, gioiHan)))
        }

        // Kèm cặp tổng thể: chọn nhân viên có % HT trung bình cao nhất và có giao chỉ tiêu
        let ungVienTong = danhSachTongHop
            .filter { KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV) != maLoaiTru && $0.tongMonGiao > 0 && $0.phanTramHTTB > 0 }
            .sorted {
                if abs($0.phanTramHTTB - $1.phanTramHTTB) > 0.01 { return $0.phanTramHTTB > $1.phanTramHTTB }
                return $0.soMonDat > $1.soMonDat
            }
            .prefix(max(1, gioiHan))
            .map {
                GoiYMentor(
                    nhanVien: $0.nhanVien,
                    tenNganhHang: "Tổng thể",
                    phanTramHT: $0.phanTramHTTB,
                    thucHien: Double($0.soMonDat),
                    targetCaNhan: Double($0.tongMonGiao),
                    laTongThe: true
                )
            }
        return Array(ungVienTong)
    }

    /// Tính hiệu quả Trước vs Sau buổi kèm cặp dựa trên tối đa 7 ngày có dữ liệu thực tế mỗi bên (trong cửa sổ ±14 ngày)
    func tinhHieuQuaKemCap(
        cho phien: PhienKemCapNhanVien,
        cheDo: LoaiCheDoDoanhThu = .luyKe
    ) -> HieuQuaKemCap {
        guard let ngayMoc = TienIchNgay.khoa.date(from: phien.ngayTao) else {
            return HieuQuaKemCap(phanTramTruoc: nil, soNgayTruoc: 0, phanTramSau: nil, soNgaySau: 0)
        }
        let lich = TienIchNgay.lich
        let ngayGioiHanTruoc = lich.date(byAdding: .day, value: -14, to: ngayMoc) ?? ngayMoc
        let ngayGioiHanSau = lich.date(byAdding: .day, value: 14, to: ngayMoc) ?? ngayMoc
        let khoaMin = TienIchNgay.khoa.string(from: ngayGioiHanTruoc)
        let khoaMax = TienIchNgay.khoa.string(from: ngayGioiHanSau)

        let tatCaKhoa = KhoDuLieu.dungChung.tatCaKhoaNgayCoDuLieu()
            .filter { $0 >= khoaMin && $0 <= khoaMax }
            .sorted()

        let khoaTruoc = tatCaKhoa.filter { $0 <= phien.ngayTao }.suffix(7)
        let khoaSau = tatCaKhoa.filter { $0 > phien.ngayTao }.prefix(7)

        let maNVChuan = KhoDuLieu.chuanHoaMaNV(phien.maNV)
        let tenNganhSach = phien.nganhHangMucTieu.trimmingCharacters(in: .whitespacesAndNewlines)
        let khoaNganhChuan = KhoDuLieu.chuanHoaTenMonThiDuaChuan(tenNganhSach).lowercased()

        func layGiaTriNgay(_ khoaNgay: String) -> Double? {
            guard let ngayD = TienIchNgay.khoa.date(from: khoaNgay) else { return nil }
            var ds = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayD, sapXep: .soMonHoanThanh, cheDo: cheDo)
            let coSoChinh = ds.contains { $0.tongMonGiao > 0 || $0.doanhThuQD > 0 || $0.soMonDat > 0 }
            if !coSoChinh {
                let cheDoPhu: LoaiCheDoDoanhThu = (cheDo == .luyKe) ? .realtime : .luyKe
                ds = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayD, sapXep: .soMonHoanThanh, cheDo: cheDoPhu)
            }
            guard let nv = ds.first(where: { KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV) == maNVChuan }) else {
                return nil
            }
            if !tenNganhSach.isEmpty {
                guard let mon = nv.cacMonGiao.first(where: { mon in
                    let k1 = KhoDuLieu.chuanHoaTenMonThiDuaChuan(mon.tenNganhHang).lowercased()
                    let k2 = mon.khoaNganh.lowercased()
                    return k1 == khoaNganhChuan || k2 == khoaNganhChuan || mon.tenNganhHang.caseInsensitiveCompare(tenNganhSach) == .orderedSame
                }), mon.targetCaNhan > 0 else {
                    return nil
                }
                return mon.phanTramHT
            }
            guard nv.tongMonGiao > 0 else { return nil }
            return nv.phanTramHTTB
        }

        let diemTruoc = khoaTruoc.compactMap { layGiaTriNgay($0) }
        let diemSau = khoaSau.compactMap { layGiaTriNgay($0) }

        return Self.tongHopHieuQua(diemTruoc: diemTruoc, diemSau: diemSau)
    }

    /// Hàm thuần tính trung bình Trước / Sau (để kiểm thử đơn vị chính xác tuyệt đối)
    static func tongHopHieuQua(diemTruoc: [Double], diemSau: [Double]) -> HieuQuaKemCap {
        let tbTruoc: Double? = diemTruoc.isEmpty ? nil : (diemTruoc.reduce(0, +) / Double(diemTruoc.count))
        let tbSau: Double? = diemSau.isEmpty ? nil : (diemSau.reduce(0, +) / Double(diemSau.count))
        return HieuQuaKemCap(
            phanTramTruoc: tbTruoc,
            soNgayTruoc: diemTruoc.count,
            phanTramSau: tbSau,
            soNgaySau: diemSau.count
        )
    }

    /// Tính ngày hạn kiểm tra mặc định (+soNgay ngày từ ngày gốc)
    static func congNgay(_ ngay: Date, them soNgay: Int) -> String {
        let dich = TienIchNgay.lich.date(byAdding: .day, value: soNgay, to: ngay) ?? ngay
        return TienIchNgay.khoa.string(from: dich)
    }
}
