import UIKit

// MARK: - Bảng Màu Sáng Tươi Chuẩn ĐMX & BaoCaoThiDua (Không dùng màu xanh đen tối)

enum BangMauBCTD {
    // Màu chủ đạo sáng tươi: Xanh Dương ĐMX (#2563EB / #0284C7) + Vàng Tươi (#FACC15) + Cam Nâu (#AD4F0A)
    static let nenMenuToi = UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1.0)       // #2563EB Bright Royal Blue
    static let nenDongChonMenu = UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1.0)  // #1D4ED8 Deep Sky Blue
    static let nenMenuCon = UIColor(red: 0.93, green: 0.96, blue: 1.00, alpha: 1.0)       // #EFF6FF Light Sky
    static let nenHeaderBang = UIColor(red: 0.15, green: 0.42, blue: 0.92, alpha: 1.0)    // #266BE9 Bright Blue Header

    // Màu Sidebar sáng thanh lịch
    static let nenSidebarSang = UIColor.white
    static let nenSidebarChon = UIColor(red: 0.92, green: 0.96, blue: 1.00, alpha: 1.0)   // #EBF4FF
    static let nenSidebarCon = UIColor(red: 0.96, green: 0.98, blue: 1.00, alpha: 1.0)    // #F5F9FF

    // Màu nhấn thương hiệu: Vàng Tươi (như nút "Bình thường" trên ảnh mẫu) + Cam Phân Tích + Indigo/Sky
    static let vangChuDao = UIColor(red: 1.00, green: 0.84, blue: 0.10, alpha: 1.0)       // #FFD61A Bright Gold
    static let vangSang = UIColor(red: 0.99, green: 0.82, blue: 0.15, alpha: 1.0)         // #FACC15 Bright Yellow Pill
    static let vangNhatNen = UIColor(red: 1.00, green: 0.96, blue: 0.80, alpha: 1.0)      // #FEF3C7
    static let camPhanTich = UIColor(red: 0.68, green: 0.31, blue: 0.04, alpha: 1.0)      // #AD4F0A ("PHÂN TÍCH (viết sẵn — sửa được)")
    static let mauChuTieuDePhanTich = UIColor(red: 0.68, green: 0.31, blue: 0.04, alpha: 1.0) // #AD4F0A
    static let xanhChuDao = UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1.0)       // #2563EB
    static let xanhChuDaoDam = UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1.0)    // #1D4ED8
    static let vienXanhNhat = UIColor(red: 0.75, green: 0.85, blue: 0.99, alpha: 1.0)     // #BFDBFE
    static let xanhLaDam = UIColor(red: 0.07, green: 0.49, blue: 0.23, alpha: 1.0)        // #127D3B
    static let indigoChuDao = UIColor(red: 0.15, green: 0.40, blue: 0.92, alpha: 1.0)     // #2667EB Bright Blue
    static let indigoDam = UIColor(red: 0.11, green: 0.32, blue: 0.82, alpha: 1.0)        // #1D52D1
    static let indigoNhatNen = UIColor(red: 0.92, green: 0.96, blue: 1.00, alpha: 1.0)    // #EBF5FF
    static let indigoVien = UIColor(red: 0.75, green: 0.85, blue: 0.99, alpha: 1.0)       // #BFDBFE
    static let xanhBienChuDao = UIColor(red: 0.01, green: 0.52, blue: 0.78, alpha: 1.0)   // #0284C7 Sky 600

    // Nền trang & thẻ sáng sạch (#F4F7FB / #FFFFFF / #E2E8F0)
    static let nenTrang = UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)         // #F5F8FC Bright Light Surface
    static let nenThe = UIColor.white                                                     // #FFFFFF
    static let nenThePhu = UIColor(red: 0.97, green: 0.98, blue: 1.00, alpha: 1.0)        // #F8FAFC
    static let nenHeaderPhu = UIColor(red: 0.93, green: 0.96, blue: 1.00, alpha: 1.0)     // #EFF6FF
    static let vienThe = UIColor(red: 0.86, green: 0.90, blue: 0.95, alpha: 1.0)          // #DCE5F2
    static let vienDam = UIColor(red: 0.78, green: 0.83, blue: 0.90, alpha: 1.0)          // #C7D4E6

    // Chữ phân cấp độ tương phản cao
    static let chuChinh = UIColor(red: 0.10, green: 0.15, blue: 0.24, alpha: 1.0)         // #1A263D
    static let chuPhu = UIColor(red: 0.27, green: 0.34, blue: 0.45, alpha: 1.0)           // #455773
    static let chuMo = UIColor(red: 0.42, green: 0.48, blue: 0.58, alpha: 1.0)            // #6B7B94
    static let chuTrenNenToi = UIColor(red: 0.93, green: 0.96, blue: 1.00, alpha: 1.0)    // #EFF6FF

    // 3 mức trạng thái nghiệp vụ: >=100% Xanh (ok) · 80-99% Vàng (mid/near) · <80% Đỏ (no/di)
    static let xanhDatChu = UIColor(red: 0.07, green: 0.49, blue: 0.23, alpha: 1.0)       // #127D3B
    static let xanhDatPill = UIColor(red: 0.86, green: 0.98, blue: 0.90, alpha: 1.0)      // #DCFCE7
    static let xanhDatNenDong = UIColor(red: 0.94, green: 0.99, blue: 0.96, alpha: 1.0)   // #F0FDF4
    static let xanhDatVach = UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1.0)      // #16A34A

    static let vangKhaChu = UIColor(red: 0.63, green: 0.36, blue: 0.03, alpha: 1.0)       // #A15C07
    static let vangKhaPill = UIColor(red: 1.00, green: 0.95, blue: 0.76, alpha: 1.0)      // #FEF3C2
    static let vangKhaNenDong = UIColor(red: 1.00, green: 0.98, blue: 0.92, alpha: 1.0)   // #FFFBEB
    static let vangKhaVach = UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1.0)      // #F59E0B

    static let doYeuChu = UIColor(red: 0.73, green: 0.11, blue: 0.11, alpha: 1.0)         // #B91C1C
    static let doYeuPill = UIColor(red: 1.00, green: 0.89, blue: 0.89, alpha: 1.0)        // #FEE2E2
    static let doYeuNenDong = UIColor(red: 1.00, green: 0.95, blue: 0.95, alpha: 1.0)     // #FEF2F2
    static let doYeuVach = UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1.0)        // #DC2626

    static func mauTrangThai(phanTram pt: Double) -> (chu: UIColor, pill: UIColor, nenDong: UIColor, vach: UIColor) {
        if pt >= 99.995 {
            return (xanhDatChu, xanhDatPill, xanhDatNenDong, xanhDatVach)
        } else if pt >= 80.0 {
            return (vangKhaChu, vangKhaPill, vangKhaNenDong, vangKhaVach)
        } else {
            return (doYeuChu, doYeuPill, doYeuNenDong, doYeuVach)
        }
    }

    static func taoHeaderBannerBaoCao(
        rong: CGFloat,
        kicker: String,
        tieuDe: String,
        thongKePhu: String? = nil
    ) -> (view: UIView, chieuCao: CGFloat) {
        let le: CGFloat = 18
        let rongChu = max(120, rong - le * 2)
        let pLeft = NSMutableParagraphStyle()
        pLeft.alignment = .left
        pLeft.lineBreakMode = .byWordWrapping

        let fontKicker = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        let fontTieuDe = UIFont.systemFont(ofSize: 19.0, weight: .heavy)
        let fontPhu = UIFont.systemFont(ofSize: 12.5, weight: .semibold)

        let caoKicker = max(18, ceil((kicker.uppercased() as NSString).boundingRect(
            with: CGSize(width: rongChu, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontKicker, .paragraphStyle: pLeft],
            context: nil
        ).height))

        let caoTieuDe = max(26, ceil((tieuDe as NSString).boundingRect(
            with: CGSize(width: rongChu, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTieuDe, .paragraphStyle: pLeft],
            context: nil
        ).height))

        var caoPhu: CGFloat = 0
        if let s = thongKePhu, !s.isEmpty {
            caoPhu = max(18, ceil((s as NSString).boundingRect(
                with: CGSize(width: rongChu, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: fontPhu, .paragraphStyle: pLeft],
                context: nil
            ).height))
        }

        let tongCao = 14 + caoKicker + 4 + caoTieuDe + (caoPhu > 0 ? 4 + caoPhu : 0) + 14 + 5
        let header = UIView(frame: CGRect(x: 0, y: 0, width: rong, height: tongCao))
        header.backgroundColor = nenHeaderBang
        let gradient = CAGradientLayer()
        gradient.frame = header.bounds
        gradient.colors = [
            UIColor(red: 0.12, green: 0.35, blue: 0.94, alpha: 1).cgColor,
            UIColor(red: 0.02, green: 0.62, blue: 0.88, alpha: 1).cgColor,
            UIColor(red: 0.02, green: 0.70, blue: 0.55, alpha: 1).cgColor
        ]
        gradient.locations = [0, 0.62, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.15)
        gradient.endPoint = CGPoint(x: 1, y: 0.85)
        header.layer.insertSublayer(gradient, at: 0)

        // Họa tiết ánh sáng nhẹ giúp ảnh xuất nổi bật nhưng vẫn giữ chữ dễ đọc.
        for (x, y, d, alpha) in [
            (rong * 0.78, -tongCao * 0.55, tongCao * 1.25, 0.10),
            (rong * 0.91, tongCao * 0.34, tongCao * 0.72, 0.08)
        ] {
            let vong = CAShapeLayer()
            vong.path = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: d, height: d)).cgPath
            vong.fillColor = UIColor.white.withAlphaComponent(alpha).cgColor
            header.layer.insertSublayer(vong, above: gradient)
        }

        let lbKicker = UILabel(frame: CGRect(x: le, y: 14, width: rongChu, height: caoKicker))
        lbKicker.text = kicker.uppercased()
        lbKicker.font = fontKicker
        lbKicker.textColor = vangChuDao
        lbKicker.numberOfLines = 0
        lbKicker.lineBreakMode = .byWordWrapping
        lbKicker.adjustsFontSizeToFitWidth = false
        header.addSubview(lbKicker)

        var y = 14 + caoKicker + 4
        let lbTieuDe = UILabel(frame: CGRect(x: le, y: y, width: rongChu, height: caoTieuDe))
        lbTieuDe.text = tieuDe
        lbTieuDe.font = fontTieuDe
        lbTieuDe.textColor = .white
        lbTieuDe.numberOfLines = 0
        lbTieuDe.lineBreakMode = .byWordWrapping
        lbTieuDe.adjustsFontSizeToFitWidth = false
        header.addSubview(lbTieuDe)
        y += caoTieuDe

        if let s = thongKePhu, !s.isEmpty, caoPhu > 0 {
            y += 4
            let lbPhu = UILabel(frame: CGRect(x: le, y: y, width: rongChu, height: caoPhu))
            lbPhu.text = s
            lbPhu.font = fontPhu
            lbPhu.textColor = UIColor(red: 0.90, green: 0.95, blue: 1.00, alpha: 1.0)
            lbPhu.numberOfLines = 0
            lbPhu.lineBreakMode = .byWordWrapping
            lbPhu.adjustsFontSizeToFitWidth = false
            header.addSubview(lbPhu)
        }

        let vachVang = UIView(frame: CGRect(x: 0, y: tongCao - 5, width: rong, height: 5))
        vachVang.backgroundColor = vangChuDao
        header.addSubview(vachVang)

        return (header, tongCao)
    }
}

enum LoaiCheDoDoanhThu: Int, CaseIterable {
    case luyKe = 0
    case realtime = 1

    var tieuDe: String {
        switch self {
        case .luyKe: return "Lũy kế"
        case .realtime: return "Realtime"
        }
    }
}

enum LoaiTabMuc: Int, CaseIterable {
    case thiDua = 0
    case nhanVien = 1
    case duPhong2 = 2

    static let cacTabCumDuoi: [LoaiTabMuc] = [.thiDua, .nhanVien]

    var tieuDe: String {
        switch self {
        case .thiDua: return "Thi đua"
        case .nhanVien: return "Nhân viên"
        case .duPhong2: return "Biểu đồ"
        }
    }
}

/// 4 tab con bên trong mục "1. Xem số" (Lũy kế | Realtime | Biểu đồ | Nhân viên)
enum TabXemSo: Int, CaseIterable {
    case luyKe = 0
    case realtime = 1
    case bieuDo = 2
    case nhanVien = 3
    case tonKho = 4

    static var allCases: [TabXemSo] { [.luyKe, .realtime, .bieuDo] }

    var tieuDe: String {
        switch self {
        case .luyKe: return "Lũy kế"
        case .realtime: return "Realtime"
        case .bieuDo: return "Biểu đồ"
        case .nhanVien: return "Nhân viên"
        case .tonKho: return "Tồn kho"
        }
    }

    var bieuTuong: String {
        switch self {
        case .luyKe: return "📊"
        case .realtime: return "⚡"
        case .bieuDo: return "📈"
        case .nhanVien: return "👥"
        case .tonKho: return "📦"
        }
    }
}

/// 3 mục con bên trong phần "Đổ số - Xem số" trên Menu điều hướng:
/// 1. Xem số  |  2. Nhập số  |  3. Xuất ảnh
enum MucConDoSo: Int, CaseIterable {
    case xemSo = 0
    case nhapSo = 1
    case xuatAnh = 2

    var tieuDe: String {
        switch self {
        case .xemSo: return "1. Xem số"
        case .nhapSo: return "2. Nhập số"
        case .xuatAnh: return "3. Xuất ảnh"
        }
    }

    var tieuDeNgan: String {
        switch self {
        case .xemSo: return "Xem số"
        case .nhapSo: return "Nhập số"
        case .xuatAnh: return "Xuất ảnh"
        }
    }

    var bieuTuongSF: String {
        switch self {
        case .xemSo: return "tablecells.fill"
        case .nhapSo: return "camera.viewfinder"
        case .xuatAnh: return "photo.on.rectangle.angled"
        }
    }
}

/// Danh sách mục chính trên Menu trượt (Sidebar Drawer):
/// Dưới "Tổng quan" có ngay nút "Báo cáo", tiếp theo là "Đổ số - Xem số" (3 mục con) và "Cài đặt".
enum MucMenuChinh: Int, CaseIterable {
    case tongQuan = 0
    case baoCao = 1
    case doSoXemSo = 2
    case caiDat = 3
    case lichDoSo = 4
    case xuatFileBaoCao = 5
    case lenhTroLy = 6
    case taiKhoanHopThu = 7
    case ketNoi = 8
    case nhiemVu = 9
    case capNhat = 10
    case hoTro = 11
    case lienHeVip = 12
    case quanTri = 13
    case trinhDuyet = 14
    case nhanVien = 15
    case guiBaoCao = 16
    case tonKho = 17

    static var allCases: [MucMenuChinh] {
        [.tongQuan, .doSoXemSo, .nhanVien, .tonKho, .guiBaoCao, .xuatFileBaoCao, .caiDat, .quanTri]
    }

    var tieuDe: String {
        switch self {
        case .tongQuan: return "Tổng quan"
        case .baoCao: return "Báo cáo"
        case .doSoXemSo: return "Đổ số - Xem số"
        case .caiDat: return "Cài đặt"
        case .lichDoSo: return "Lịch đổ số"
        case .xuatFileBaoCao: return "Xuất file báo cáo"
        case .lenhTroLy: return "Lệnh trợ lý"
        case .taiKhoanHopThu: return "Tài khoản & Hộp thư"
        case .ketNoi: return "Kết nối"
        case .nhiemVu: return "Nhiệm vụ"
        case .capNhat: return "Cập nhật"
        case .hoTro: return "Hỗ trợ"
        case .lienHeVip: return "Liên hệ & gói VIP"
        case .quanTri: return "Quản trị"
        case .trinhDuyet: return "Trình duyệt Copilot"
        case .nhanVien: return "Nhân viên"
        case .guiBaoCao: return "Gởi báo cáo"
        case .tonKho: return "Lọc dữ liệu tồn kho"
        }
    }

    var bieuTuongSF: String {
        switch self {
        case .tongQuan: return "house.fill"
        case .baoCao: return "doc.text.magnifyingglass"
        case .doSoXemSo: return "tablecells.fill"
        case .caiDat: return "gearshape.fill"
        case .lichDoSo: return "calendar.badge.clock"
        case .xuatFileBaoCao: return "doc.on.clipboard.fill"
        case .lenhTroLy: return "terminal.fill"
        case .taiKhoanHopThu: return "person.crop.circle"
        case .ketNoi: return "icloud.and.arrow.up"
        case .nhiemVu: return "checklist"
        case .capNhat: return "arrow.up.square"
        case .hoTro: return "questionmark.circle"
        case .lienHeVip: return "phone.fill"
        case .quanTri: return "crown.fill"
        case .trinhDuyet: return "globe"
        case .nhanVien: return "person.3.fill"
        case .guiBaoCao: return "paperplane.fill"
        case .tonKho: return "shippingbox.fill"
        }
    }

    var nhanDoPhai: String? {
        nil
    }

    var coMenuCon: Bool {
        false
    }
}

enum KieuSapXepNhanVien: Int, CaseIterable {
    case tenAZ = 0
    case soMonHoanThanh = 1
    case doanhThuQD = 2
    case phanTramTB = 3
    case gioCong = 4

    var nhan: String {
        switch self {
        case .tenAZ: return "🔤 Tên nhân viên (A → Z)"
        case .soMonHoanThanh: return "🏆 Số môn hoàn thành (Cao → Thấp)"
        case .doanhThuQD: return "🎯 Doanh thu QĐ (Cao → Thấp)"
        case .phanTramTB: return "📈 % HT thi đua TB (Cao → Thấp)"
        case .gioCong: return "⏱️ Giờ công tại ST (Cao → Thấp)"
        }
    }

    var nhanNgan: String {
        switch self {
        case .tenAZ: return "Tên A-Z"
        case .soMonHoanThanh: return "Số môn HT"
        case .doanhThuQD: return "DT QĐ"
        case .phanTramTB: return "% HT TB"
        case .gioCong: return "Giờ công"
        }
    }
}

struct NhanVienQuanLy: Codable, Hashable, Identifiable {
    private static let localeVN = Locale(identifier: "vi_VN")

    var maNV: String
    var hoTen: String
    var id: String { maNV }

    static func soSanhAZ(_ a: NhanVienQuanLy, _ b: NhanVienQuanLy) -> Bool {
        let tenA = a.hoTen.trimmingCharacters(in: .whitespacesAndNewlines)
        let tenB = b.hoTen.trimmingCharacters(in: .whitespacesAndNewlines)
        let kq = tenA.compare(tenB, options: [.caseInsensitive], range: nil, locale: localeVN)
        if kq != .orderedSame {
            return kq == .orderedAscending
        }
        return a.maNV.compare(b.maNV, options: [.numeric]) == .orderedAscending
    }

    static func sapXepAZ(_ danhSach: [NhanVienQuanLy]) -> [NhanVienQuanLy] {
        var mapDuyNhat: [String: NhanVienQuanLy] = [:]
        for nv in danhSach {
            let ma = KhoDuLieu.chuanHoaMaNV(nv.maNV)
            let ten = nv.hoTen.trimmingCharacters(in: .whitespacesAndNewlines)
            let khoa = !ma.isEmpty ? ma : ten.uppercased()
            guard !khoa.isEmpty else { continue }
            if let cu = mapDuyNhat[khoa] {
                if ten.count > cu.hoTen.count {
                    mapDuyNhat[khoa] = NhanVienQuanLy(maNV: !ma.isEmpty ? ma : cu.maNV, hoTen: ten)
                }
            } else {
                mapDuyNhat[khoa] = NhanVienQuanLy(maNV: !ma.isEmpty ? ma : nv.maNV, hoTen: ten)
            }
        }
        return Array(mapDuyNhat.values).sorted(by: soSanhAZ)
    }
}

struct DoanhThuNhanVienItem: Codable, Hashable {
    var maNV: String
    var hoTen: String
    var soLuong: Double = 0
    var doanhThuThuc: Double = 0
    var doanhThuQD: Double = 0
    var target: Double = 0
    var dtQDKhoanVay: Double = 0
    var dtTraThangQD: Double = 0
    var dtTraGop: Double = 0
    var phanTramHT: Double = 0
    var phanTramQuyDoi: Double = 0
    var phanTramTraGop: Double = 0
    var gioCong: Double = 0
    var gioCongHoTro: Double = 0
    var soNgayNghi: Double = 0
    var nangSuat: Double = 0

    init(
        maNV: String,
        hoTen: String,
        soLuong: Double = 0,
        doanhThuThuc: Double = 0,
        doanhThuQD: Double = 0,
        target: Double = 0,
        dtQDKhoanVay: Double = 0,
        dtTraThangQD: Double = 0,
        dtTraGop: Double = 0,
        phanTramHT: Double = 0,
        phanTramQuyDoi: Double = 0,
        phanTramTraGop: Double = 0,
        gioCong: Double = 0,
        gioCongHoTro: Double = 0,
        soNgayNghi: Double = 0,
        nangSuat: Double = 0
    ) {
        self.maNV = maNV
        self.hoTen = hoTen
        self.soLuong = soLuong
        self.doanhThuThuc = doanhThuThuc
        self.doanhThuQD = doanhThuQD
        self.target = target
        self.dtQDKhoanVay = dtQDKhoanVay
        self.dtTraThangQD = dtTraThangQD
        self.dtTraGop = dtTraGop
        self.phanTramHT = phanTramHT
        self.phanTramQuyDoi = phanTramQuyDoi
        self.phanTramTraGop = phanTramTraGop
        self.gioCong = gioCong
        self.gioCongHoTro = gioCongHoTro
        self.soNgayNghi = soNgayNghi
        self.nangSuat = nangSuat
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        maNV = (try? c.decode(String.self, forKey: .maNV)) ?? ""
        hoTen = (try? c.decode(String.self, forKey: .hoTen)) ?? ""
        soLuong = (try? c.decode(Double.self, forKey: .soLuong)) ?? 0
        doanhThuThuc = (try? c.decode(Double.self, forKey: .doanhThuThuc)) ?? 0
        doanhThuQD = (try? c.decode(Double.self, forKey: .doanhThuQD)) ?? 0
        target = (try? c.decode(Double.self, forKey: .target)) ?? 0
        dtQDKhoanVay = (try? c.decode(Double.self, forKey: .dtQDKhoanVay)) ?? 0
        dtTraThangQD = (try? c.decode(Double.self, forKey: .dtTraThangQD)) ?? 0
        dtTraGop = (try? c.decode(Double.self, forKey: .dtTraGop)) ?? 0
        phanTramHT = (try? c.decode(Double.self, forKey: .phanTramHT)) ?? 0
        phanTramQuyDoi = (try? c.decode(Double.self, forKey: .phanTramQuyDoi)) ?? 0
        phanTramTraGop = (try? c.decode(Double.self, forKey: .phanTramTraGop)) ?? 0
        gioCong = (try? c.decode(Double.self, forKey: .gioCong)) ?? 0
        gioCongHoTro = (try? c.decode(Double.self, forKey: .gioCongHoTro)) ?? 0
        soNgayNghi = (try? c.decode(Double.self, forKey: .soNgayNghi)) ?? 0
        nangSuat = (try? c.decode(Double.self, forKey: .nangSuat)) ?? 0
    }
}

struct DongXepHangNhanVienNganh: Hashable {
    var maNV: String
    var hoTen: String
    var thucHien: Double
    var targetCaNhan: Double
    var phanTramHT: Double
    var chenhLech: Double { thucHien - targetCaNhan }
    var daDat: Bool { phanTramHT >= 99.995 }
}

struct MonThiDuaNhanVien: Hashable {
    var khoaNganh: String
    var tenNganhHang: String
    var loaiChiTieu: LoaiChiTieuThiDua
    var thucHien: Double
    var targetCaNhan: Double
    var phanTramHT: Double
    var phanTramSieuThi: Double
    var conLai: Double { targetCaNhan - thucHien }
    var daDat: Bool { phanTramHT >= 99.995 }
}

struct TongHopNhanVien: Hashable {
    var nhanVien: NhanVienQuanLy
    var soMonDat: Int
    var tongMonGiao: Int
    var phanTramHTTB: Double
    var doanhThuQD: Double
    var soLuongDon: Double
    var dtQDKhoanVay: Double
    var dtTraThangQD: Double
    var phanTramTiTrong: Double = 0
    var gioCongTaiST: Double = 0
    var gioCongHoTro: Double = 0
    var cacMonGiao: [MonThiDuaNhanVien]
    var doanhThuCaNhan: DoanhThuNhanVienItem?

    var tongGioCong: Double {
        gioCongTaiST + gioCongHoTro
    }
}

/// Khung dữ liệu thông số Sức khỏe cá nhân Nhân viên (mẫu 27 điểm: Doanh thu 6, Năng suất 3, Hiệu quả khai thác 9, Đơn giá 8, Thi đua 1).
/// Các trường Optional cho phép hiển thị khung chờ bổ sung khi chưa có số liệu, và tự động hiển thị ngay khi được cập nhật/bổ sung.
struct DuLieuSucKhoeBoSungNV: Codable, Hashable {
    // 0. Thông tin chung trên phiếu sức khỏe 27 điểm
    var diemDat27: Int?
    var tongDiem27: Int?
    var phanTramHoanThanhChung: Double?
    var soNgayDaQuaThang: Int?
    var tongSoNgayThang: Int?

    // 1. Khối Doanh thu bổ sung (Đủ 6 mục: Doanh thu QĐ, % Target, Số lượt bill bán hàng, % Quy đổi, % Trả chậm, % Bán kèm)
    var doanhThuQDSucKhoe: Double?
    var tbDoanhThuQDSieuThi: Double?
    var mucTieuTargetQD: Double?
    var phanTramTarget: Double?
    var tbPhanTramTarget: Double?
    var soLuotBillBanHang: Double?
    var tbSoLuotBillBanHang: Double?
    var phanTramQuyDoi: Double?
    var tbPhanTramQuyDoi: Double?
    var phanTramTraCham: Double?
    var tbPhanTramTraCham: Double?
    var phanTramBanKem: Double?
    var tbPhanTramBanKem: Double?

    // 2. Khối Năng suất (3/3: Điểm thưởng ERP, Điểm thưởng / Giờ công, DTQĐ / Giờ công) & Giờ công lũy kế (2 mục)
    var diemThuongERP: Double?
    var tbDiemThuongERP: Double?
    var diemThuongTrenGioCong: Double?
    var tbDiemThuongTrenGioCong: Double?
    var dtqdTrenGioCong: Double?
    var tbDtqdTrenGioCong: Double?
    var gioCongTaiST: Double?
    var gioCongHoTroSTKhac: Double?

    // 2b. Khối Thi đua cá nhân (% hoàn thành từng môn từ phiếu sức khỏe NV)
    var phanTramThiDuaCaNhan: [String: Double]?

    // 3. Khối Hiệu quả khai thác (0/9) - Lưu theo khóa danh mục chuẩn
    var hieuQuaKhaiThac: [String: Double] = [:]

    // 4. Khối Đơn giá (4/8) - Lưu giá trị cá nhân và TB siêu thị (đơn vị: triệu đồng)
    var donGiaCaNhan: [String: Double] = [:]
    var donGiaTrungBinhST: [String: Double] = [:]

    // 5. Tỷ trọng ngành hàng (%)
    var tyTrongNganhHang: [String: Double] = [:]

    // 6. Doanh thu QĐ từng tháng ("MM/yyyy": triệu đồng)
    var doanhThuQDTungThang: [String: Double] = [:]

    static let danhSachMucHieuQuaTrai: [(khoa: String, nhan: String)] = [
        ("phu_kien", "% Phụ kiện"),
        ("may_loc_nuoc", "% Máy lọc nước"),
        ("sim", "% Sim"),
        ("vas", "% VAS"),
        ("bao_hiem_dmx", "% Bảo hiểm ĐMX")
    ]

    static let danhSachMucHieuQuaPhai: [(khoa: String, nhan: String)] = [
        ("camera", "% Camera"),
        ("bao_hiem_tong", "% Bảo hiểm tổng"),
        ("sac_du_phong", "% Sạc dự phòng"),
        ("gia_dung", "% Gia dụng")
    ]

    static var tatCaMucHieuQua: [(khoa: String, nhan: String)] {
        danhSachMucHieuQuaTrai + danhSachMucHieuQuaPhai
    }

    static let danhSachMucDonGia: [(khoa: String, nhan: String)] = [
        ("tb_spc", "TB SẢN PHẨM CHÍNH"),
        ("tivi", "TIVI"),
        ("tu_lanh", "TỦ LẠNH"),
        ("may_giat", "MÁY GIẶT"),
        ("may_lanh", "MÁY LẠNH"),
        ("mln", "MLN"),
        ("dien_thoai", "ĐIỆN THOẠI"),
        ("laptop", "LAPTOP")
    ]

    static let danhSachNhomTyTrongNganhHang: [(khoa: String, nhan: String)] = [
        ("apple", "Apple"),
        ("tu_lanh_dong_mat", "Tủ lạnh, đông, mát"),
        ("dien_tu", "Điện tử"),
        ("gia_dung", "Gia dụng"),
        ("vien_thong_di_dong", "Viễn thông di động"),
        ("laptop", "Laptop"),
        ("may_lanh_nuoc_nong", "Máy lạnh & Máy nước nóng"),
        ("khac", "Khác")
    ]

    var coDuLieu: Bool {
        doanhThuQDSucKhoe != nil ||
        tbDoanhThuQDSieuThi != nil ||
        mucTieuTargetQD != nil ||
        phanTramTarget != nil ||
        soLuotBillBanHang != nil ||
        phanTramQuyDoi != nil ||
        phanTramTraCham != nil ||
        phanTramBanKem != nil ||
        diemThuongERP != nil ||
        diemThuongTrenGioCong != nil ||
        dtqdTrenGioCong != nil ||
        gioCongTaiST != nil ||
        gioCongHoTroSTKhac != nil ||
        !(phanTramThiDuaCaNhan ?? [:]).isEmpty ||
        !hieuQuaKhaiThac.isEmpty ||
        !donGiaCaNhan.isEmpty
    }

    func gop(voi moi: DuLieuSucKhoeBoSungNV) -> DuLieuSucKhoeBoSungNV {
        var kq = self
        if let v = moi.diemDat27 { kq.diemDat27 = v }
        if let v = moi.tongDiem27 { kq.tongDiem27 = v }
        if let v = moi.phanTramHoanThanhChung { kq.phanTramHoanThanhChung = v }
        if let v = moi.soNgayDaQuaThang { kq.soNgayDaQuaThang = v }
        if let v = moi.tongSoNgayThang { kq.tongSoNgayThang = v }
        if let v = moi.doanhThuQDSucKhoe { kq.doanhThuQDSucKhoe = v }
        if let v = moi.tbDoanhThuQDSieuThi { kq.tbDoanhThuQDSieuThi = v }
        if let v = moi.mucTieuTargetQD { kq.mucTieuTargetQD = v }
        if let v = moi.phanTramTarget { kq.phanTramTarget = v }
        if let v = moi.tbPhanTramTarget { kq.tbPhanTramTarget = v }
        if let v = moi.soLuotBillBanHang { kq.soLuotBillBanHang = v }
        if let v = moi.tbSoLuotBillBanHang { kq.tbSoLuotBillBanHang = v }
        if let v = moi.phanTramQuyDoi { kq.phanTramQuyDoi = v }
        if let v = moi.tbPhanTramQuyDoi { kq.tbPhanTramQuyDoi = v }
        if let v = moi.phanTramTraCham { kq.phanTramTraCham = v }
        if let v = moi.tbPhanTramTraCham { kq.tbPhanTramTraCham = v }
        if let v = moi.phanTramBanKem { kq.phanTramBanKem = v }
        if let v = moi.tbPhanTramBanKem { kq.tbPhanTramBanKem = v }
        if let v = moi.diemThuongERP { kq.diemThuongERP = v }
        if let v = moi.tbDiemThuongERP { kq.tbDiemThuongERP = v }
        if let v = moi.diemThuongTrenGioCong { kq.diemThuongTrenGioCong = v }
        if let v = moi.tbDiemThuongTrenGioCong { kq.tbDiemThuongTrenGioCong = v }
        if let v = moi.dtqdTrenGioCong { kq.dtqdTrenGioCong = v }
        if let v = moi.tbDtqdTrenGioCong { kq.tbDtqdTrenGioCong = v }
        if let v = moi.gioCongTaiST { kq.gioCongTaiST = v }
        if let v = moi.gioCongHoTroSTKhac { kq.gioCongHoTroSTKhac = v }
        if let ptMoi = moi.phanTramThiDuaCaNhan, !ptMoi.isEmpty {
            var gopPT = kq.phanTramThiDuaCaNhan ?? [:]
            for (k, v) in ptMoi { gopPT[k] = v }
            kq.phanTramThiDuaCaNhan = gopPT
        }
        for (k, v) in moi.hieuQuaKhaiThac { kq.hieuQuaKhaiThac[k] = v }
        for (k, v) in moi.donGiaCaNhan { kq.donGiaCaNhan[k] = v }
        for (k, v) in moi.donGiaTrungBinhST { kq.donGiaTrungBinhST[k] = v }
        for (k, v) in moi.tyTrongNganhHang { kq.tyTrongNganhHang[k] = v }
        for (k, v) in moi.doanhThuQDTungThang { kq.doanhThuQDTungThang[k] = v }
        return kq
    }
}

enum LoaiBieuDoThang: Int, CaseIterable {
    case realtime = 0
    case sucKhoeNhanVien = 1

    var tieuDe: String {
        switch self {
        case .realtime: return "📊 Biểu đồ Realtime"
        case .sucKhoeNhanVien: return "❤️‍🩹 Biểu đồ sức khỏe NV"
        }
    }
}

enum MucDoSucKhoeNV: Int, Codable, Hashable {
    case khoe = 0
    case trungBinh = 1
    case yeu = 2
    case chuaCoSo = 3

    var nhan: String {
        switch self {
        case .khoe: return "Khỏe mạnh"
        case .trungBinh: return "Trung bình"
        case .yeu: return "Yếu"
        case .chuaCoSo: return "Chưa có số"
        }
    }

    var kyHieu: String {
        switch self {
        case .khoe: return "🟢"
        case .trungBinh: return "🟡"
        case .yeu: return "🔴"
        case .chuaCoSo: return "⚪"
        }
    }
}

struct DiemSucKhoeNgayNV: Hashable {
    var khoaNgay: String
    var ngayTrongThang: Int
    var nhanNgay: String
    var diemSucKhoe: Double
    var mucDo: MucDoSucKhoeNV
    var soMonDat: Int
    var tongMonGiao: Int
    var phanTramHTTB: Double
    var doanhThuQD: Double
}

struct HoSoSucKhoeNhanVien: Hashable {
    var nhanVien: NhanVienQuanLy
    var tongHopHienTai: TongHopNhanVien
    var diemSucKhoe: Double
    var mucDo: MucDoSucKhoeNV
    var soNgayYeuLienTuc: Int
    var chuoiYeuDaiNhat: Int
    var tongSoNgayYeu: Int
    var tongSoNgayCoSo: Int
    var lichSuNgay: [DiemSucKhoeNgayNV]
    var cacMonYeuNhat: [String]
    var xuHuongDiem: Double
    var laCanhBaoTop5: Bool
    var hangCanhBao: Int?

    var nhanXuHuong: String {
        if xuHuongDiem >= 3.0 { return "📈 Tăng" }
        if xuHuongDiem <= -3.0 { return "📉 Giảm" }
        return "➖ Đi ngang"
    }

    var chuoiCanhBaoYeu: String {
        if soNgayYeuLienTuc >= 2 {
            return "🔥 Yếu \(soNgayYeuLienTuc) ngày liên tục"
        } else if soNgayYeuLienTuc == 1 {
            return "⚠️ Yếu \(tongSoNgayYeu > 1 ? "\(tongSoNgayYeu) ngày (đang yếu)" : "1 ngày gần nhất")"
        } else if tongSoNgayYeu > 0 {
            return "⚠️ Đã yếu \(tongSoNgayYeu)/\(max(1, tongSoNgayCoSo)) ngày"
        } else {
            return "⚠️ Điểm SK thấp (\(Int(round(diemSucKhoe)))%)"
        }
    }
}

struct BaoCaoSucKhoeDoiNgu: Hashable {
    var ngayBaoCao: Date
    var cheDo: LoaiCheDoDoanhThu
    var soNgayDaTheoDoi: Int
    var cacNhanNgayTheoDoi: [String]
    var soNVKhoe: Int
    var soNVTrungBinh: Int
    var soNVYeu: Int
    var diemTrungBinhDoiNgu: Double
    var top5CanhBaoYeu: [HoSoSucKhoeNhanVien]
    var danhSachTatCa: [HoSoSucKhoeNhanVien]
}

enum KieuHienThiBaoCao: Int, Codable, CaseIterable {
    case bangChiTiet = 0
    case theGon = 1

    var tieuDe: String {
        switch self {
        case .bangChiTiet: return "Bảng 8 cột"
        case .theGon: return "Thẻ tiến độ"
        }
    }

    var maWeb: String {
        switch self {
        case .bangChiTiet: return "bangChiTiet"
        case .theGon: return "theGon"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let rawInt = try? container.decode(Int.self), let val = KieuHienThiBaoCao(rawValue: rawInt) {
            self = val
        } else if let rawStr = try? container.decode(String.self) {
            self = (rawStr == "theGon") ? .theGon : .bangChiTiet
        } else {
            self = .bangChiTiet
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(maWeb)
    }
}

enum LoaiChiTieuThiDua: String, Codable, CaseIterable {
    case soLuong = "SL"
    case doanhThu = "DT"

    var maBang: String {
        switch self {
        case .soLuong: return "SL"
        case .doanhThu: return "DT"
        }
    }

    var maThe: String {
        switch self {
        case .soLuong: return "SLLK"
        case .doanhThu: return "DTLK"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = (try? container.decode(String.self))?.uppercased() ?? "DT"
        if raw.contains("SL") {
            self = .soLuong
        } else {
            self = .doanhThu
        }
    }
}

struct ThongTinDoanhThu: Codable, Hashable {
    var doanhThuThuc: Double = 0
    var targetThuc: Double = 0
    var duKienThuc: Double = 0
    var phanTramHTThuc: Double = 0

    var doanhThuQuyDoi: Double = 0
    var targetQuyDoi: Double = 0
    var duKienQuyDoi: Double = 0
    var phanTramHTQuyDoi: Double = 0

    var phanTramTraGop: Double = 0
    var doanhThuTraGop: Double = 0

    var luotKhach: Double = 0
    var soBill: Double = 0
    var phanTramPVTC: Double = 0

    var tangGiamCungKy: Double = 0
    var coTangGiam: Bool = false
    var tb3Thang: Double = 0

    var soNgayDaQua: Int = 0
    var tongSoNgay: Int = 0
    var phanTramTienDoThang: Double = 0

    init(
        doanhThuThuc: Double = 0,
        targetThuc: Double = 0,
        duKienThuc: Double = 0,
        phanTramHTThuc: Double = 0,
        doanhThuQuyDoi: Double = 0,
        targetQuyDoi: Double = 0,
        duKienQuyDoi: Double = 0,
        phanTramHTQuyDoi: Double = 0,
        phanTramTraGop: Double = 0,
        doanhThuTraGop: Double = 0,
        luotKhach: Double = 0,
        soBill: Double = 0,
        phanTramPVTC: Double = 0,
        tangGiamCungKy: Double = 0,
        coTangGiam: Bool = false,
        tb3Thang: Double = 0,
        soNgayDaQua: Int = 0,
        tongSoNgay: Int = 0,
        phanTramTienDoThang: Double = 0
    ) {
        self.doanhThuThuc = doanhThuThuc
        self.targetThuc = targetThuc
        self.duKienThuc = duKienThuc
        self.phanTramHTThuc = phanTramHTThuc
        self.doanhThuQuyDoi = doanhThuQuyDoi
        self.targetQuyDoi = targetQuyDoi
        self.duKienQuyDoi = duKienQuyDoi
        self.phanTramHTQuyDoi = phanTramHTQuyDoi
        self.phanTramTraGop = phanTramTraGop
        self.doanhThuTraGop = doanhThuTraGop
        self.luotKhach = luotKhach
        self.soBill = soBill
        self.phanTramPVTC = phanTramPVTC
        self.tangGiamCungKy = tangGiamCungKy
        self.coTangGiam = coTangGiam
        self.tb3Thang = tb3Thang
        self.soNgayDaQua = soNgayDaQua
        self.tongSoNgay = tongSoNgay
        self.phanTramTienDoThang = phanTramTienDoThang
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        doanhThuThuc = (try? c.decode(Double.self, forKey: .doanhThuThuc)) ?? 0
        targetThuc = (try? c.decode(Double.self, forKey: .targetThuc)) ?? 0
        duKienThuc = (try? c.decode(Double.self, forKey: .duKienThuc)) ?? 0
        phanTramHTThuc = (try? c.decode(Double.self, forKey: .phanTramHTThuc)) ?? 0
        doanhThuQuyDoi = (try? c.decode(Double.self, forKey: .doanhThuQuyDoi)) ?? 0
        targetQuyDoi = (try? c.decode(Double.self, forKey: .targetQuyDoi)) ?? 0
        duKienQuyDoi = (try? c.decode(Double.self, forKey: .duKienQuyDoi)) ?? 0
        phanTramHTQuyDoi = (try? c.decode(Double.self, forKey: .phanTramHTQuyDoi)) ?? 0
        phanTramTraGop = (try? c.decode(Double.self, forKey: .phanTramTraGop)) ?? 0
        doanhThuTraGop = (try? c.decode(Double.self, forKey: .doanhThuTraGop)) ?? 0
        luotKhach = (try? c.decode(Double.self, forKey: .luotKhach)) ?? 0
        soBill = (try? c.decode(Double.self, forKey: .soBill)) ?? 0
        phanTramPVTC = (try? c.decode(Double.self, forKey: .phanTramPVTC)) ?? 0
        tangGiamCungKy = (try? c.decode(Double.self, forKey: .tangGiamCungKy)) ?? 0
        coTangGiam = (try? c.decode(Bool.self, forKey: .coTangGiam)) ?? (tangGiamCungKy != 0)
        tb3Thang = (try? c.decode(Double.self, forKey: .tb3Thang)) ?? 0
        soNgayDaQua = (try? c.decode(Int.self, forKey: .soNgayDaQua)) ?? 0
        tongSoNgay = (try? c.decode(Int.self, forKey: .tongSoNgay)) ?? 0
        phanTramTienDoThang = (try? c.decode(Double.self, forKey: .phanTramTienDoThang)) ?? 0
    }

    var coDuLieu: Bool {
        doanhThuThuc > 0 || targetThuc > 0 || doanhThuQuyDoi > 0 || targetQuyDoi > 0 || luotKhach > 0 || phanTramTraGop > 0
    }

    /// Chỉ điều chỉnh target để hiển thị/báo cáo. Target quét gốc trong dữ liệu ngày không bị thay đổi.
    func apDungPhanTramTarget(_ phanTram: Double, cheDo: LoaiCheDoDoanhThu) -> ThongTinDoanhThu {
        let tyLe = min(2.0, max(0.5, phanTram / 100.0))
        guard abs(tyLe - 1.0) > 0.0001 else { return self }
        var kq = self
        if kq.targetThuc > 0 { kq.targetThuc *= tyLe }
        if kq.targetQuyDoi > 0 { kq.targetQuyDoi *= tyLe }
        kq.phanTramHTThuc = kq.targetThuc > 0 ? (kq.doanhThuThuc / kq.targetThuc) * 100.0 : 0
        // Realtime hiển thị "% HT target ngày", vì vậy phải lấy doanh thu hiện tại
        // chia target ngày. Chỉ lũy kế mới dùng doanh thu dự kiến cuối tháng.
        let coSoQD = cheDo == .realtime
            ? kq.doanhThuQuyDoi
            : (kq.duKienQuyDoi > 0 ? kq.duKienQuyDoi : kq.doanhThuQuyDoi)
        kq.phanTramHTQuyDoi = kq.targetQuyDoi > 0 ? (coSoQD / kq.targetQuyDoi) * 100.0 : 0
        return kq
    }

    /// % Quy đổi = (DT Quy đổi - DT Thực) / DT Thực * 100
    var phanTramQuyDoi: Double {
        guard doanhThuThuc > 0, doanhThuQuyDoi > 0 else { return 0 }
        return ((doanhThuQuyDoi - doanhThuThuc) / doanhThuThuc) * 100.0
    }

    /// % Hoàn thành Doanh thu thực
    var phanTramHTThucHienThi: Double {
        if phanTramHTThuc > 0 { return phanTramHTThuc }
        if targetThuc > 0, doanhThuThuc > 0 {
            return (doanhThuThuc / targetThuc) * 100.0
        }
        return 0
    }

    /// % Hoàn thành QĐ dự kiến (hiển thị trực tiếp con số quét được từ ảnh)
    var phanTramHTQDDuKienHienThi: Double {
        if phanTramHTQuyDoi > 0 { return phanTramHTQuyDoi }
        if duKienQuyDoi > 0, targetQuyDoi > 0 {
            return (duKienQuyDoi / targetQuyDoi) * 100.0
        }
        if targetQuyDoi > 0, doanhThuQuyDoi > 0 {
            return (doanhThuQuyDoi / targetQuyDoi) * 100.0
        }
        if phanTramHTThuc > 0 { return phanTramHTThuc }
        if targetThuc > 0, doanhThuThuc > 0 {
            return (doanhThuThuc / targetThuc) * 100.0
        }
        return 0
    }

    /// Realtime luôn là doanh thu hiện tại / target ngày. Không được lấy dự kiến
    /// cuối tháng vì có thể làm tỷ lệ nhảy lên hàng nghìn phần trăm.
    func phanTramHTQuyDoiHienThi(cheDo: LoaiCheDoDoanhThu) -> Double {
        if cheDo == .realtime {
            guard targetQuyDoi > 0 else { return 0 }
            return (doanhThuQuyDoi / targetQuyDoi) * 100.0
        }
        return phanTramHTQDDuKienHienThi
    }

    /// Gộp dữ liệu từ ảnh mới quét (ví dụ quét ảnh DT thực rồi quét tiếp ảnh DT quy đổi)
    func gop(voi moi: ThongTinDoanhThu, laRealtime: Bool = false) -> ThongTinDoanhThu {
        var kq = self
        if moi.doanhThuThuc > 0 { kq.doanhThuThuc = moi.doanhThuThuc }
        if moi.targetThuc > 0 { kq.targetThuc = moi.targetThuc }
        if moi.duKienThuc > 0 { kq.duKienThuc = moi.duKienThuc }
        if moi.phanTramHTThuc > 0 { kq.phanTramHTThuc = moi.phanTramHTThuc }

        if moi.doanhThuQuyDoi > 0 { kq.doanhThuQuyDoi = moi.doanhThuQuyDoi }
        if moi.targetQuyDoi > 0 { kq.targetQuyDoi = moi.targetQuyDoi }
        if moi.duKienQuyDoi > 0 { kq.duKienQuyDoi = moi.duKienQuyDoi }
        if moi.phanTramHTQuyDoi > 0 { kq.phanTramHTQuyDoi = moi.phanTramHTQuyDoi }

        if moi.phanTramTraGop > 0 { kq.phanTramTraGop = moi.phanTramTraGop }
        if moi.doanhThuTraGop > 0 { kq.doanhThuTraGop = moi.doanhThuTraGop }

        if moi.luotKhach > 0 { kq.luotKhach = moi.luotKhach }
        if moi.soBill > 0 { kq.soBill = moi.soBill }
        if moi.phanTramPVTC > 0 { kq.phanTramPVTC = moi.phanTramPVTC }

        if moi.coTangGiam || moi.tangGiamCungKy != 0 {
            kq.tangGiamCungKy = moi.tangGiamCungKy
            kq.coTangGiam = true
        }
        if moi.tb3Thang > 0 { kq.tb3Thang = moi.tb3Thang }

        if moi.soNgayDaQua > 0 { kq.soNgayDaQua = moi.soNgayDaQua }
        if moi.tongSoNgay > 0 { kq.tongSoNgay = moi.tongSoNgay }
        if moi.phanTramTienDoThang > 0 { kq.phanTramTienDoThang = moi.phanTramTienDoThang }
        return kq
    }
}

struct DongThiDua: Codable, Hashable, Identifiable {
    var id: UUID = UUID()
    var tenNganhHangGoc: String
    var tenNganhHang: String
    var loaiChiTieu: LoaiChiTieuThiDua
    var thucHien: Double
    var target: Double
    var targetGoc: Double?
    var phanTramDieuChinhTarget: Double?
    var phanTramHTGoc: Double?
    var phanTramDuBaoGoc: Double?
    var duKienGoc: Double?

    /// Target gốc trước khi điều chỉnh % (tương thích ngược với dữ liệu cũ chưa lưu targetGoc)
    var targetGocHieuLuc: Double {
        if let g = targetGoc, g > 0.0001 { return g }
        return target
    }

    /// Tỷ lệ % điều chỉnh target hiện tại (50...200, mặc định 100%)
    var phanTramDieuChinhTargetHieuLuc: Double {
        if let pt = phanTramDieuChinhTarget, pt >= 50, pt <= 200 { return pt }
        if let g = targetGoc, g > 0.0001 {
            return min(200, max(50, ((target / g) * 100.0).rounded()))
        }
        return 100
    }

    enum CodingKeys: String, CodingKey {
        case id
        case tenNganhHangGoc
        case tenNganhHang
        case loaiChiTieu
        case thucHien
        case target
        case targetGoc
        case phanTramDieuChinhTarget
        case phanTramHTGoc
        case phanTramDuBaoGoc
        case duKienGoc
    }

    init(
        id: UUID = UUID(),
        tenNganhHangGoc: String? = nil,
        tenNganhHang: String,
        loaiChiTieu: LoaiChiTieuThiDua,
        thucHien: Double,
        target: Double,
        targetGoc: Double? = nil,
        phanTramDieuChinhTarget: Double? = nil,
        phanTramHTGoc: Double? = nil,
        phanTramDuBaoGoc: Double? = nil,
        duKienGoc: Double? = nil
    ) {
        self.id = id
        let goc = KhoDuLieu.chuanHoaTenMonThiDuaChuan(tenNganhHangGoc ?? tenNganhHang)
        self.tenNganhHangGoc = goc
        self.tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
        self.loaiChiTieu = loaiChiTieu
        self.thucHien = thucHien
        self.target = target
        self.targetGoc = targetGoc
        self.phanTramDieuChinhTarget = phanTramDieuChinhTarget
        self.phanTramHTGoc = phanTramHTGoc
        self.phanTramDuBaoGoc = phanTramDuBaoGoc
        self.duKienGoc = duKienGoc
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        if let uuid = try? c.decode(UUID.self, forKey: .id) {
            id = uuid
        } else if let str = try? c.decode(String.self, forKey: .id), let uuid = UUID(uuidString: str) {
            id = uuid
        } else {
            id = UUID()
        }
        let ten = (try? c.decode(String.self, forKey: .tenNganhHang)) ?? ""
        let gocThuc = (try? c.decode(String.self, forKey: .tenNganhHangGoc)) ?? ten
        let gocSach = KhoDuLieu.chuanHoaTenMonThiDuaChuan(gocThuc.isEmpty ? ten : gocThuc)
        tenNganhHangGoc = gocSach.isEmpty ? gocThuc : gocSach
        let tenSach = KhoDuLieu.chuanHoaTenMonThiDuaChuan(ten.isEmpty ? tenNganhHangGoc : ten)
        tenNganhHang = tenSach.isEmpty ? tenNganhHangGoc : tenSach
        loaiChiTieu = (try? c.decode(LoaiChiTieuThiDua.self, forKey: .loaiChiTieu)) ?? .doanhThu
        thucHien = (try? c.decode(Double.self, forKey: .thucHien)) ?? 0
        target = (try? c.decode(Double.self, forKey: .target)) ?? 0
        targetGoc = try? c.decode(Double.self, forKey: .targetGoc)
        phanTramDieuChinhTarget = try? c.decode(Double.self, forKey: .phanTramDieuChinhTarget)
        phanTramHTGoc = try? c.decode(Double.self, forKey: .phanTramHTGoc)
        phanTramDuBaoGoc = try? c.decode(Double.self, forKey: .phanTramDuBaoGoc)
        duKienGoc = try? c.decode(Double.self, forKey: .duKienGoc)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id.uuidString.lowercased(), forKey: .id)
        try c.encode(tenNganhHangGoc, forKey: .tenNganhHangGoc)
        try c.encode(tenNganhHang, forKey: .tenNganhHang)
        try c.encode(loaiChiTieu, forKey: .loaiChiTieu)
        try c.encode(thucHien, forKey: .thucHien)
        try c.encode(target, forKey: .target)
        try c.encodeIfPresent(targetGoc, forKey: .targetGoc)
        try c.encodeIfPresent(phanTramDieuChinhTarget, forKey: .phanTramDieuChinhTarget)
        try c.encodeIfPresent(phanTramHTGoc, forKey: .phanTramHTGoc)
        try c.encodeIfPresent(phanTramDuBaoGoc, forKey: .phanTramDuBaoGoc)
        try c.encodeIfPresent(duKienGoc, forKey: .duKienGoc)
    }

    var chenhLech: Double {
        thucHien - target
    }

    var conThieu: Double {
        max(0, target - thucHien)
    }

    var vuotMuc: Double {
        max(0, thucHien - target)
    }

    var phanTramHT: Double {
        if target > 0.0001 {
            let htTinh = (thucHien / target) * 100.0
            let nguong: Double = (loaiChiTieu == .soLuong && target <= 25) ? 3.5 : 1.2
            if let goc = phanTramHTGoc, abs(goc) > 0.0001, abs(htTinh - goc) <= nguong {
                return goc
            }
            return htTinh
        }
        return phanTramHTGoc ?? 0
    }

    /// Doanh thu / Số lượng dự kiến cuối tháng (ưu tiên con số quét trực tiếp từ ô DT DỰ KIẾN / SL DỰ KIẾN trên ảnh Lũy kế)
    var duKien: Double {
        if let dk = duKienGoc, abs(dk) > 0.0001 {
            if let htGoc = phanTramHTGoc, abs(htGoc) > 0.1, target > 0.0001 {
                let htMoi = (thucHien / target) * 100.0
                if abs(htMoi - htGoc) > 1.5 {
                    let uoc = (target * phanTramDuBao) / 100.0
                    return loaiChiTieu == .soLuong ? uoc.rounded() : ((uoc * 100).rounded() / 100)
                }
            }
            return dk
        }
        if target > 0.0001, abs(phanTramDuBao) > 0.0001 {
            let uoc = (target * phanTramDuBao) / 100.0
            return loaiChiTieu == .soLuong ? uoc.rounded() : ((uoc * 100).rounded() / 100)
        }
        let uoc = thucHien * TienIchNgay.heSoDuBaoThang()
        return loaiChiTieu == .soLuong ? uoc.rounded() : ((uoc * 100).rounded() / 100)
    }

    var chenhLechDuKien: Double {
        duKien - target
    }

    var conThieuDuKien: Double {
        max(0, target - duKien)
    }

    var vuotMucDuKien: Double {
        max(0, duKien - target)
    }

    var phanTramDuBao: Double {
        if let goc = phanTramDuBaoGoc, abs(goc) > 0.0001 {
            if let htGoc = phanTramHTGoc, abs(htGoc) > 0.1, target > 0.0001 {
                let htMoi = (thucHien / target) * 100.0
                if abs(htMoi - htGoc) > 1.5 {
                    let tyLe = goc / htGoc
                    return htMoi * tyLe
                }
            }
            return goc
        }
        if let goc = phanTramDuBaoGoc, abs(goc) <= 0.0001, abs(thucHien) <= 0.0001 {
            return 0
        }
        if let dk = duKienGoc, dk > 0, target > 0.0001 {
            return (dk / target) * 100.0
        }
        return phanTramHT * TienIchNgay.heSoDuBaoThang()
    }

    var daDat: Bool {
        phanTramHT >= 99.995
    }

    var daHoanThanhDuBao: Bool {
        phanTramDuBao >= 99.995
    }
}

enum PhuongPhapQuetThiDua: Int, Codable, CaseIterable {
    case bangNgang = 0 // Phương pháp 1: Bảng ngang (ĐƠN VỊ | SỐ CT ĐẠT | 39 cột chương trình ngang THỰC HIỆN | TARGET)
    case bangDoc = 1   // Phương pháp 2: Bảng dọc (CHƯƠNG TRÌNH | THỰC HIỆN | TARGET | % DỰ KIẾN HOÀN THÀNH | HẠNG VÙNG)
    case luoi = 2      // Phương pháp 3: Lưới thẻ (Lưới 6 cột × 7 hàng hoặc lưới 2 cột thẻ thi đua)
    case gemini = 3    // Phương pháp 4: Quét ảnh với AI Gemini Flash

    // Giữ bí danh tương thích ngược
    static var phuongPhap1: PhuongPhapQuetThiDua { .bangNgang }
    static var phuongPhap2: PhuongPhapQuetThiDua { .bangDoc }
    static var phuongPhap3: PhuongPhapQuetThiDua { .gemini }

    var tieuDe: String {
        switch self {
        case .bangNgang:
            return "Bảng ngang"
        case .bangDoc:
            return "Bảng dọc"
        case .luoi:
            return "Lưới"
        case .gemini:
            return "Gemini"
        }
    }

    var tieuDeDayDu: String {
        switch self {
        case .bangNgang:
            return "1. Bảng ngang (Dữ liệu theo Siêu thị)"
        case .bangDoc:
            return "2. Bảng dọc (Bảng 5-6 cột có thanh tiến độ)"
        case .luoi:
            return "3. Lưới (Thẻ 6 cột / 2 cột)"
        case .gemini:
            return "4. Gemini (AI Gemini Flash)"
        }
    }

    var bieuTuong: String {
        switch self {
        case .bangNgang: return "📊"
        case .bangDoc: return "📋"
        case .luoi: return "🎴"
        case .gemini: return "✨"
        }
    }
}

struct CaiDatDMX: Codable {
    static let khoaKhongChonMonThiDua = "__KHONG_CHON_MON_NAO__"
    static let geminiKeyMacDinh = "AIzaSyBLV7N_qUxSuiJ3B3FETmj2Ta67CKeVKWo"
    static let geminiModelMacDinh = "gemini-3.5-flash-lite"

    var kieuHienThi: KieuHienThiBaoCao = .bangChiTiet
    var phuongPhapQuetThiDua: PhuongPhapQuetThiDua = .bangDoc
    var danhSachCumTuLocBo: [String] = []
    var soCotXuatAnh: Int = 3
    var danhSachNhanVien: [NhanVienQuanLy] = CaiDatDMX.nhanVienMau
    var chiaTargetNganhHang: [String: [String]] = [:]
    var mucTieuDoanhThuQDThang: [String: Double] = [:]
    var phanTramTargetLuyKe: Double = 100
    var phanTramTargetRealtime: Double = 100
    /// Rỗng nghĩa là theo dõi tất cả. Giá trị được lưu bằng khóa tên chuẩn, không làm mất dữ liệu quét gốc.
    var monThiDuaTheoDoiLuyKe: [String] = []
    var monThiDuaTheoDoiRealtime: [String] = []
    var geminiApiKey: String = CaiDatDMX.geminiKeyMacDinh
    var geminiApiKey2: String = ""
    var geminiApiKey3: String = ""
    var geminiModel: String = CaiDatDMX.geminiModelMacDinh
    var dungGeminiQuetAnh: Bool = false
    var hienThiNangSuatNhanVien: Bool = true

    enum CodingKeys: String, CodingKey {
        case kieuHienThi
        case phuongPhapQuetThiDua
        case danhSachCumTuLocBo
        case soCotXuatAnh
        case danhSachNhanVien
        case chiaTargetNganhHang
        case mucTieuDoanhThuQDThang
        case phanTramTargetLuyKe
        case phanTramTargetRealtime
        case monThiDuaTheoDoiLuyKe
        case monThiDuaTheoDoiRealtime
        case geminiApiKey
        case geminiApiKey2
        case geminiApiKey3
        case geminiModel
        case dungGeminiQuetAnh
        case hienThiNangSuatNhanVien
    }

    static let nhanVienMau: [NhanVienQuanLy] = [
        .init(maNV: "116719", hoTen: "Đinh Thị Quỳnh Nga"),
        .init(maNV: "34922", hoTen: "Đỗ Thị Chanh"),
        .init(maNV: "186532", hoTen: "Đỗ Thị Mỹ Linh"),
        .init(maNV: "285681", hoTen: "Hồ Ngọc Châu Ánh"),
        .init(maNV: "207241", hoTen: "Huỳnh Tấn Thành"),
        .init(maNV: "280417", hoTen: "Huỳnh Thành Đạt"),
        .init(maNV: "23997", hoTen: "Lê Thị Kim Phượng"),
        .init(maNV: "285688", hoTen: "Lê Tuấn"),
        .init(maNV: "194649", hoTen: "Nguyễn Hoàn Điện"),
        .init(maNV: "39665", hoTen: "Nguyễn Hữu Kha"),
        .init(maNV: "23986", hoTen: "Nguyễn Ngọc Đẩu"),
        .init(maNV: "201962", hoTen: "Nguyễn Thị Kim Loan"),
        .init(maNV: "65255", hoTen: "Nguyễn Thị Thu Thảo"),
        .init(maNV: "24939", hoTen: "Phan Hoàng Sơn"),
        .init(maNV: "65257", hoTen: "Phan Thương Vĩnh"),
        .init(maNV: "261423", hoTen: "Trần Nam Tùng"),
        .init(maNV: "293044", hoTen: "Võ Ngọc Vĩ")
    ]

    init(
        kieuHienThi: KieuHienThiBaoCao = .bangChiTiet,
        phuongPhapQuetThiDua: PhuongPhapQuetThiDua = .bangDoc,
        danhSachCumTuLocBo: [String] = [],
        soCotXuatAnh: Int = 3,
        danhSachNhanVien: [NhanVienQuanLy] = CaiDatDMX.nhanVienMau,
        chiaTargetNganhHang: [String: [String]] = [:],
        mucTieuDoanhThuQDThang: [String: Double] = [:],
        phanTramTargetLuyKe: Double = 100,
        phanTramTargetRealtime: Double = 100,
        monThiDuaTheoDoiLuyKe: [String] = [],
        monThiDuaTheoDoiRealtime: [String] = [],
        geminiApiKey: String = CaiDatDMX.geminiKeyMacDinh,
        geminiApiKey2: String = "",
        geminiApiKey3: String = "",
        geminiModel: String = CaiDatDMX.geminiModelMacDinh,
        dungGeminiQuetAnh: Bool = false,
        hienThiNangSuatNhanVien: Bool = true
    ) {
        self.kieuHienThi = kieuHienThi
        self.phuongPhapQuetThiDua = phuongPhapQuetThiDua
        self.danhSachCumTuLocBo = danhSachCumTuLocBo
        self.soCotXuatAnh = soCotXuatAnh
        var dsNV = danhSachNhanVien.isEmpty ? Self.nhanVienMau : danhSachNhanVien
        for i in dsNV.indices {
            if dsNV[i].maNV == "65257" && dsNV[i].hoTen.count < 14 {
                dsNV[i].hoTen = "Phan Thương Vĩnh"
            }
        }
        if !dsNV.contains(where: { $0.maNV == "65257" }) {
            dsNV.append(.init(maNV: "65257", hoTen: "Phan Thương Vĩnh"))
        }
        self.danhSachNhanVien = NhanVienQuanLy.sapXepAZ(dsNV)
        self.chiaTargetNganhHang = chiaTargetNganhHang
        self.mucTieuDoanhThuQDThang = mucTieuDoanhThuQDThang
        self.phanTramTargetLuyKe = min(200, max(50, phanTramTargetLuyKe))
        self.phanTramTargetRealtime = min(200, max(50, phanTramTargetRealtime))
        self.monThiDuaTheoDoiLuyKe = monThiDuaTheoDoiLuyKe
        self.monThiDuaTheoDoiRealtime = monThiDuaTheoDoiRealtime
        self.geminiApiKey = geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Self.geminiKeyMacDinh : geminiApiKey
        self.geminiApiKey2 = geminiApiKey2.trimmingCharacters(in: .whitespacesAndNewlines)
        self.geminiApiKey3 = geminiApiKey3.trimmingCharacters(in: .whitespacesAndNewlines)
        self.geminiModel = Self.geminiModelMacDinh
        self.dungGeminiQuetAnh = dungGeminiQuetAnh
        self.hienThiNangSuatNhanVien = hienThiNangSuatNhanVien
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        kieuHienThi = (try? c.decode(KieuHienThiBaoCao.self, forKey: .kieuHienThi)) ?? .bangChiTiet
        if UserDefaults.standard.object(forKey: "dmx.caiDat.phuongPhapQuetThiDua.v2") != nil,
           let luuPP = PhuongPhapQuetThiDua(rawValue: UserDefaults.standard.integer(forKey: "dmx.caiDat.phuongPhapQuetThiDua.v2")) {
            phuongPhapQuetThiDua = luuPP
        } else if let pp = try? c.decode(PhuongPhapQuetThiDua.self, forKey: .phuongPhapQuetThiDua) {
            phuongPhapQuetThiDua = pp
        } else {
            phuongPhapQuetThiDua = .bangDoc
        }
        danhSachCumTuLocBo = (try? c.decode([String].self, forKey: .danhSachCumTuLocBo)) ?? []
        let cot = (try? c.decode(Int.self, forKey: .soCotXuatAnh)) ?? 3
        soCotXuatAnh = (cot >= 1 && cot <= 4) ? cot : 3
        var dsNV = (try? c.decode([NhanVienQuanLy].self, forKey: .danhSachNhanVien)) ?? []
        if dsNV.isEmpty { dsNV = Self.nhanVienMau }
        for i in dsNV.indices {
            if dsNV[i].maNV == "65257" && dsNV[i].hoTen.count < 14 {
                dsNV[i].hoTen = "Phan Thương Vĩnh"
            }
        }
        danhSachNhanVien = NhanVienQuanLy.sapXepAZ(dsNV)
        chiaTargetNganhHang = (try? c.decode([String: [String]].self, forKey: .chiaTargetNganhHang)) ?? [:]
        mucTieuDoanhThuQDThang = (try? c.decode([String: Double].self, forKey: .mucTieuDoanhThuQDThang)) ?? [:]
        phanTramTargetLuyKe = min(200, max(50, (try? c.decode(Double.self, forKey: .phanTramTargetLuyKe)) ?? 100))
        phanTramTargetRealtime = min(200, max(50, (try? c.decode(Double.self, forKey: .phanTramTargetRealtime)) ?? 100))
        monThiDuaTheoDoiLuyKe = (try? c.decode([String].self, forKey: .monThiDuaTheoDoiLuyKe)) ?? []
        monThiDuaTheoDoiRealtime = (try? c.decode([String].self, forKey: .monThiDuaTheoDoiRealtime)) ?? []
        let rawKey = (try? c.decode(String.self, forKey: .geminiApiKey))?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let luuKeyUD = UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !luuKeyUD.isEmpty && luuKeyUD != Self.geminiKeyMacDinh {
            geminiApiKey = luuKeyUD
        } else if !rawKey.isEmpty && rawKey != Self.geminiKeyMacDinh {
            geminiApiKey = rawKey
        } else if !luuKeyUD.isEmpty {
            geminiApiKey = luuKeyUD
        } else {
            geminiApiKey = Self.geminiKeyMacDinh
        }
        let rawKey2 = (try? c.decode(String.self, forKey: .geminiApiKey2))?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let luuKey2UD = UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey2")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        geminiApiKey2 = !luuKey2UD.isEmpty ? luuKey2UD : rawKey2

        let rawKey3 = (try? c.decode(String.self, forKey: .geminiApiKey3))?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let luuKey3UD = UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey3")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        geminiApiKey3 = !luuKey3UD.isEmpty ? luuKey3UD : rawKey3

        geminiModel = Self.geminiModelMacDinh
        dungGeminiQuetAnh = (try? c.decode(Bool.self, forKey: .dungGeminiQuetAnh)) ?? (phuongPhapQuetThiDua == .gemini)
        if let hienNS = try? c.decode(Bool.self, forKey: .hienThiNangSuatNhanVien) {
            hienThiNangSuatNhanVien = hienNS
        } else if UserDefaults.standard.object(forKey: "dmx.caiDat.hienThiNangSuatNhanVien") != nil {
            hienThiNangSuatNhanVien = UserDefaults.standard.bool(forKey: "dmx.caiDat.hienThiNangSuatNhanVien")
        } else {
            hienThiNangSuatNhanVien = true
        }
    }

    /// Danh sách các Key do người dùng tự nhập ở 3 ô (nếu nhập 1 có 1, nhập 2 có 2, nhập 3 có 3)
    var danhSachKeyNguoiDungNhap: [String] {
        let k1UD = (UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let k2UD = (UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey2") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let k3UD = (UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey3") ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        let k1Raw = (!k1UD.isEmpty && k1UD != Self.geminiKeyMacDinh) ? k1UD : geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let k1 = (k1Raw == Self.geminiKeyMacDinh) ? "" : k1Raw
        let k2 = !k2UD.isEmpty ? k2UD : geminiApiKey2.trimmingCharacters(in: .whitespacesAndNewlines)
        let k3 = !k3UD.isEmpty ? k3UD : geminiApiKey3.trimmingCharacters(in: .whitespacesAndNewlines)

        var ds: [String] = []
        for k in [k1, k2, k3] where !k.isEmpty && !ds.contains(k) {
            ds.append(k)
        }
        return ds
    }

    /// Nếu người dùng nhập 1 key thì dùng đúng 1 key đó; nhập 2 key thì dùng 2 key; nhập 3 key thì dùng 3 key.
    /// Chỉ khi cả 3 ô đều trống mới dùng 1 key mặc định tích hợp sẵn.
    var danhSachGeminiApiKeyHieuLuc: [String] {
        let dsNhap = danhSachKeyNguoiDungNhap
        if !dsNhap.isEmpty {
            return dsNhap
        }
        return Self.geminiKeyMacDinh.isEmpty ? [] : [Self.geminiKeyMacDinh]
    }

    var geminiApiKeyHieuLuc: String {
        danhSachGeminiApiKeyHieuLuc.first ?? Self.geminiKeyMacDinh
    }

    func phanTramTarget(cho cheDo: LoaiCheDoDoanhThu) -> Double {
        cheDo == .luyKe ? phanTramTargetLuyKe : phanTramTargetRealtime
    }

    func khoaMonTheoDoi(cho cheDo: LoaiCheDoDoanhThu) -> [String] {
        cheDo == .luyKe ? monThiDuaTheoDoiLuyKe : monThiDuaTheoDoiRealtime
    }

    mutating func ganKhoaMonTheoDoi(_ danhSach: [String], cho cheDo: LoaiCheDoDoanhThu) {
        if cheDo == .luyKe { monThiDuaTheoDoiLuyKe = danhSach }
        else { monThiDuaTheoDoiRealtime = danhSach }
    }
}

struct DuBaoQuyDoiThang: Hashable {
    var mucTieuThang: Double
    var soNgayTrongThang: Int
    var mucTieuMoiNgay: Double
    var soNgayCoRealtime: Int
    var tongDTThucRealtime: Double
    var tongDTQDRealtime: Double
    var trungBinhThucMoiNgay: Double
    var trungBinhQDMoiNgay: Double
    var duKienThucCuoiThang: Double
    var duKienQDCuoiThang: Double
    var phanTramHTQDDuKien: Double
    var phanTramQuyDoiDuKien: Double
    var chenhLechDuKienCuoiThang: Double { duKienQDCuoiThang - mucTieuThang }
    var daHoanThanhDuKien: Bool { phanTramHTQDDuKien >= 99.995 }
}

struct DuLieuRealtimeNgayTrongThang: Hashable {
    var ngay: Date
    var khoaNgay: String
    var ngayTrongThang: Int
    var doanhThu: ThongTinDoanhThu

    var doanhThuThuc: Double { doanhThu.doanhThuThuc }
    var targetThuc: Double { doanhThu.targetThuc }
    var doanhThuQuyDoi: Double { doanhThu.doanhThuQuyDoi }
    var targetQuyDoi: Double { doanhThu.targetQuyDoi }
    var phanTramQuyDoi: Double { doanhThu.phanTramQuyDoi }
    var phanTramTraGop: Double { doanhThu.phanTramTraGop }
    var luotKhach: Double { doanhThu.luotKhach }
    var soBill: Double { doanhThu.soBill }
    var coDuLieu: Bool {
        doanhThu.doanhThuThuc > 0 || doanhThu.doanhThuQuyDoi > 0 || doanhThu.luotKhach > 0 || doanhThu.soBill > 0
    }
}

struct DuLieuNgayDMX: Codable {
    var khoaNgay: String
    var capNhatLuc: String
    var thongTinDonVi: String
    var doanhThu: ThongTinDoanhThu
    var doanhThuRealtime: ThongTinDoanhThu = ThongTinDoanhThu()
    var danhSachThiDua: [DongThiDua]
    var danhSachThiDuaRealtime: [DongThiDua] = []
    var thiDuaNhanVien: [String: [String: Double]] = [:]
    var thiDuaNhanVienRealtime: [String: [String: Double]] = [:]
    var doanhThuNhanVien: [DoanhThuNhanVienItem] = []
    var doanhThuNhanVienRealtime: [DoanhThuNhanVienItem] = []
    var sucKhoeBoSungNhanVien: [String: DuLieuSucKhoeBoSungNV] = [:]

    init(
        khoaNgay: String,
        capNhatLuc: String,
        thongTinDonVi: String,
        doanhThu: ThongTinDoanhThu,
        doanhThuRealtime: ThongTinDoanhThu = ThongTinDoanhThu(),
        danhSachThiDua: [DongThiDua],
        danhSachThiDuaRealtime: [DongThiDua] = [],
        thiDuaNhanVien: [String: [String: Double]] = [:],
        thiDuaNhanVienRealtime: [String: [String: Double]] = [:],
        doanhThuNhanVien: [DoanhThuNhanVienItem] = [],
        doanhThuNhanVienRealtime: [DoanhThuNhanVienItem] = [],
        sucKhoeBoSungNhanVien: [String: DuLieuSucKhoeBoSungNV] = [:]
    ) {
        self.khoaNgay = khoaNgay
        self.capNhatLuc = capNhatLuc
        self.thongTinDonVi = thongTinDonVi
        self.doanhThu = doanhThu
        self.doanhThuRealtime = doanhThuRealtime
        self.danhSachThiDua = danhSachThiDua
        self.danhSachThiDuaRealtime = danhSachThiDuaRealtime
        self.thiDuaNhanVien = thiDuaNhanVien
        self.thiDuaNhanVienRealtime = thiDuaNhanVienRealtime
        self.doanhThuNhanVien = doanhThuNhanVien
        self.doanhThuNhanVienRealtime = doanhThuNhanVienRealtime
        self.sucKhoeBoSungNhanVien = sucKhoeBoSungNhanVien
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        khoaNgay = (try? c.decode(String.self, forKey: .khoaNgay)) ?? ""
        capNhatLuc = (try? c.decode(String.self, forKey: .capNhatLuc)) ?? ""
        thongTinDonVi = (try? c.decode(String.self, forKey: .thongTinDonVi)) ?? ""
        doanhThu = (try? c.decode(ThongTinDoanhThu.self, forKey: .doanhThu)) ?? ThongTinDoanhThu()
        doanhThuRealtime = (try? c.decode(ThongTinDoanhThu.self, forKey: .doanhThuRealtime)) ?? ThongTinDoanhThu()
        danhSachThiDua = (try? c.decode([DongThiDua].self, forKey: .danhSachThiDua)) ?? []
        danhSachThiDuaRealtime = (try? c.decode([DongThiDua].self, forKey: .danhSachThiDuaRealtime)) ?? []
        thiDuaNhanVien = (try? c.decode([String: [String: Double]].self, forKey: .thiDuaNhanVien)) ?? [:]
        thiDuaNhanVienRealtime = (try? c.decode([String: [String: Double]].self, forKey: .thiDuaNhanVienRealtime)) ?? [:]
        doanhThuNhanVien = (try? c.decode([DoanhThuNhanVienItem].self, forKey: .doanhThuNhanVien)) ?? []
        doanhThuNhanVienRealtime = (try? c.decode([DoanhThuNhanVienItem].self, forKey: .doanhThuNhanVienRealtime)) ?? []
        sucKhoeBoSungNhanVien = (try? c.decode([String: DuLieuSucKhoeBoSungNV].self, forKey: .sucKhoeBoSungNhanVien)) ?? [:]
    }

    func danhSachThiDua(theo cheDo: LoaiCheDoDoanhThu) -> [DongThiDua] {
        switch cheDo {
        case .luyKe: return danhSachThiDua
        case .realtime: return danhSachThiDuaRealtime
        }
    }

    mutating func ganDanhSachThiDua(_ ds: [DongThiDua], theo cheDo: LoaiCheDoDoanhThu) {
        switch cheDo {
        case .luyKe: danhSachThiDua = ds
        case .realtime: danhSachThiDuaRealtime = ds
        }
    }

    func thiDuaNhanVien(theo cheDo: LoaiCheDoDoanhThu) -> [String: [String: Double]] {
        switch cheDo {
        case .luyKe: return thiDuaNhanVien
        case .realtime: return thiDuaNhanVienRealtime
        }
    }

    mutating func ganThiDuaNhanVien(_ bang: [String: [String: Double]], theo cheDo: LoaiCheDoDoanhThu) {
        switch cheDo {
        case .luyKe: thiDuaNhanVien = bang
        case .realtime: thiDuaNhanVienRealtime = bang
        }
    }

    func doanhThuNhanVien(theo cheDo: LoaiCheDoDoanhThu) -> [DoanhThuNhanVienItem] {
        switch cheDo {
        case .luyKe: return doanhThuNhanVien
        case .realtime: return doanhThuNhanVienRealtime
        }
    }

    mutating func ganDoanhThuNhanVien(_ ds: [DoanhThuNhanVienItem], theo cheDo: LoaiCheDoDoanhThu) {
        switch cheDo {
        case .luyKe: doanhThuNhanVien = ds
        case .realtime: doanhThuNhanVienRealtime = ds
        }
    }
}

final class ThuMucDuLieu {
    static let dungChung = ThuMucDuLieu()

    let thuMuc: URL
    func tepNgay(choSieuThi id: String) -> URL {
        guard !id.isEmpty else { return thuMuc.appendingPathComponent("du-lieu-dmx-v3.json") }
        return thuMuc.appendingPathComponent("du-lieu-dmx-\(BoNhoSieuThiDMX.tenTepAnToan(id))-v4.json")
    }
    func tepCaiDat(choSieuThi id: String) -> URL {
        guard !id.isEmpty else { return thuMuc.appendingPathComponent("cai-dat-dmx-v3.json") }
        return thuMuc.appendingPathComponent("cai-dat-dmx-\(BoNhoSieuThiDMX.tenTepAnToan(id))-v4.json")
    }
    var tepNgay: URL {
        tepNgay(choSieuThi: BoNhoSieuThiDMX.idDangChon)
    }
    var tepCaiDat: URL {
        tepCaiDat(choSieuThi: BoNhoSieuThiDMX.idDangChon)
    }

    /// Không dùng prettyPrinted / sortedKeys để mã hoá JSON nhanh gấp 4 lần, không gây nghẽn CPU
    private let maHoa = JSONEncoder()
    private let giaiMa = JSONDecoder()
    private let hangDoiGhiFile = DispatchQueue(label: "com.thanhduong.tonghopdmx.ghifile", qos: .utility)
    private var congViecGhiNgay: DispatchWorkItem?
    private var congViecGhiCaiDat: DispatchWorkItem?

    private init() {
        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        thuMuc = documents.appendingPathComponent("DuLieuDMX", isDirectory: true)
        try? FileManager.default.createDirectory(at: thuMuc, withIntermediateDirectories: true)
    }

    /// Bản trước lưu chung ở file v3. Khi nâng cấp, sao chép (không di chuyển/xóa)
    /// sang siêu thị mặc định để dữ liệu lịch sử luôn có đường lui cứu hộ.
    @discardableResult
    func khoiPhucDuLieuCuNeuCan(choSieuThi id: String, laMacDinh: Bool) -> Bool {
        guard laMacDinh, !id.isEmpty else { return false }
        let tepNgayCu = thuMuc.appendingPathComponent("du-lieu-dmx-v3.json")
        let tepCaiDatCu = thuMuc.appendingPathComponent("cai-dat-dmx-v3.json")
        let tepNgayMoi = tepNgay(choSieuThi: id)
        let tepCaiDatMoi = tepCaiDat(choSieuThi: id)
        guard let ngayCu = doc([String: DuLieuNgayDMX].self, tu: tepNgayCu), !ngayCu.isEmpty else { return false }

        let ngayMoi = doc([String: DuLieuNgayDMX].self, tu: tepNgayMoi)
        guard ngayMoi == nil || ngayMoi?.isEmpty == true else { return false }
        let daGhiNgay = ghi(ngayCu, vao: tepNgayMoi)
        if let caiDatCu = doc(CaiDatDMX.self, tu: tepCaiDatCu) {
            _ = ghi(caiDatCu, vao: tepCaiDatMoi)
        }
        return daGhiNgay
    }

    func doc<T: Decodable>(_ loai: T.Type, tu tep: URL) -> T? {
        guard let duLieu = try? Data(contentsOf: tep) else { return nil }
        return try? giaiMa.decode(loai, from: duLieu)
    }

    @discardableResult
    func ghi<T: Encodable>(_ giaTri: T, vao tep: URL) -> Bool {
        do {
            let duLieu = try maHoa.encode(giaTri)
            try duLieu.write(to: tep, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    /// Ghi dữ liệu các ngày xuống đĩa trên luồng nền (debounce 0.35s) để tuyệt đối không làm đơ giao diện chính
    func ghiNgayBatDongBo(_ cacNgay: [String: DuLieuNgayDMX]) {
        let banSao = cacNgay
        let tep = tepNgay
        hangDoiGhiFile.async { [weak self] in
            guard let self else { return }
            self.congViecGhiNgay?.cancel()
            let cv = DispatchWorkItem { [weak self] in
                guard let self else { return }
                _ = self.ghi(banSao, vao: tep)
            }
            self.congViecGhiNgay = cv
            self.hangDoiGhiFile.asyncAfter(deadline: .now() + 0.35, execute: cv)
        }
    }

    /// Ghi dữ liệu cài đặt xuống đĩa trên luồng nền (debounce 0.25s)
    func ghiCaiDatBatDongBo(_ caiDat: CaiDatDMX) {
        let banSao = caiDat
        let tep = tepCaiDat
        hangDoiGhiFile.async { [weak self] in
            guard let self else { return }
            self.congViecGhiCaiDat?.cancel()
            let cv = DispatchWorkItem { [weak self] in
                guard let self else { return }
                _ = self.ghi(banSao, vao: tep)
            }
            self.congViecGhiCaiDat = cv
            self.hangDoiGhiFile.asyncAfter(deadline: .now() + 0.25, execute: cv)
        }
    }
}

final class KhoDuLieu {
    static func chuyenChuoiThanhSo(_ s: String) -> Double? {
        var chuoi = s
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if chuoi.contains(",") && chuoi.contains(".") {
            if let viTriPhay = chuoi.lastIndex(of: ","), let viTriCham = chuoi.lastIndex(of: "."), viTriPhay > viTriCham {
                chuoi = chuoi.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
            } else {
                chuoi = chuoi.replacingOccurrences(of: ",", with: "")
            }
        } else if chuoi.contains(",") {
            chuoi = chuoi.replacingOccurrences(of: ",", with: ".")
        }
        return Double(chuoi)
    }

    static let dungChung = KhoDuLieu()

    private let khoaTruyCap = NSRecursiveLock()
    private(set) var cacNgay: [String: DuLieuNgayDMX] = [:]
    var caiDat = CaiDatDMX()

    /// Bộ nhớ đệm trong RAM giúp chuyển đổi qua lại giữa các tab tức thì (0ms), không phải chạy lại Regex hay vòng lặp tổng hợp nhiều ngày
    private(set) var phienBanDuLieu: Int = 1
    private var boNhoDemDuLieuNgay: [String: DuLieuNgayDMX] = [:]
    private var boNhoDemMatHangThang: [String: [DongThiDua]] = [:]
    private var boNhoDemThucHienNVThang: [String: [String: [String: Double]]] = [:]
    private var boNhoDemTongHopNV: [String: [TongHopNhanVien]] = [:]
    private var boNhoDemBaoCaoSucKhoe: [String: BaoCaoSucKhoeDoiNgu] = [:]
    private var boNhoDemRealtimeThang: [String: [DuLieuRealtimeNgayTrongThang]] = [:]
    private var boNhoDemDuBaoThang: [String: DuBaoQuyDoiThang] = [:]
    private var boNhoDemDTLuyKeThang: [String: ThongTinDoanhThu] = [:]
    private var boNhoDemDTNVLuyKeThang: [String: [DoanhThuNhanVienItem]] = [:]
    private var boNhoSieuThi: [String: (caiDat: CaiDatDMX, cacNgay: [String: DuLieuNgayDMX])] = [:]

    private static let khoaBoNhoDemTinh = NSLock()
    private static var danhSachCumTuLocBoTinh: [String] = []
    private static var boNhoDemKhoaSoSanh: [String: String] = [:]
    private static var boNhoDemLocTen: [String: String] = [:]
    private static var boNhoDemTenChuan: [String: String] = [:]
    private static var boNhoDemKhoaCoBan: [String: String] = [:]
    private static var boNhoDemKhoaLienMach: [String: String] = [:]
    private static var boNhoDemKhoaLMKhongThang: [String: String] = [:]

    private static let khoaLuuMucDaXoa = "dmx.cacKhoaMucDaXoa.v1"
    private var cacKhoaMucDaXoa: Set<String> = {
        let mang = UserDefaults.standard.stringArray(forKey: "dmx.cacKhoaMucDaXoa.v1") ?? []
        return Set(mang)
    }()

    private func luuTapKhoaMucDaXoa() {
        UserDefaults.standard.set(Array(cacKhoaMucDaXoa), forKey: Self.khoaLuuMucDaXoa)
    }

    private func apDungCoXoa(vao dl: inout DuLieuNgayDMX) {
        guard !cacKhoaMucDaXoa.isEmpty else { return }
        let khoa = dl.khoaNgay
        let tienTo = String(khoa.prefix(7))
        if cacKhoaMucDaXoa.contains("dt_lk|\(tienTo)") {
            dl.doanhThu = ThongTinDoanhThu()
        }
        if cacKhoaMucDaXoa.contains("dt_rt|\(khoa)") {
            dl.doanhThuRealtime = ThongTinDoanhThu()
        }
        if cacKhoaMucDaXoa.contains("td_0|\(tienTo)") {
            dl.danhSachThiDua = []
        }
        if cacKhoaMucDaXoa.contains("td_1|\(khoa)") {
            dl.danhSachThiDuaRealtime = []
        }
        if cacKhoaMucDaXoa.contains("nv_dt|\(tienTo)") {
            dl.doanhThuNhanVien = []
            dl.doanhThuNhanVienRealtime = []
            dl.sucKhoeBoSungNhanVien = [:]
        }
        if cacKhoaMucDaXoa.contains("nv_td|\(tienTo)") {
            dl.thiDuaNhanVien = [:]
            dl.thiDuaNhanVienRealtime = [:]
        }
        let tienToNVOne = "nv_one|\(tienTo)|"
        let maNVDaXoa = cacKhoaMucDaXoa.compactMap { item -> String? in
            guard item.hasPrefix(tienToNVOne) else { return nil }
            return String(item.dropFirst(tienToNVOne.count))
        }
        if !maNVDaXoa.isEmpty {
            let tapMaXoa = Set(maNVDaXoa)
            dl.doanhThuNhanVien.removeAll { tapMaXoa.contains(Self.chuanHoaMaNV($0.maNV)) }
            dl.doanhThuNhanVienRealtime.removeAll { tapMaXoa.contains(Self.chuanHoaMaNV($0.maNV)) }
            for ma in tapMaXoa {
                dl.sucKhoeBoSungNhanVien.removeValue(forKey: ma)
                for kMon in Array(dl.thiDuaNhanVien.keys) {
                    dl.thiDuaNhanVien[kMon]?.removeValue(forKey: ma)
                }
                for kMon in Array(dl.thiDuaNhanVienRealtime.keys) {
                    dl.thiDuaNhanVienRealtime[kMon]?.removeValue(forKey: ma)
                }
            }
        }
    }

    private init() {
        doc()
    }

    /// Lấy bản sao an toàn của toàn bộ dữ liệu để đồng bộ nền mà không tranh chấp bộ nhớ với luồng chính
    func layBanSaoAnToan() -> (caiDat: CaiDatDMX, cacNgay: [String: DuLieuNgayDMX]) {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        return (caiDat, cacNgay)
    }

    /// Lấy bản sao cài đặt an toàn cho các luồng quét ảnh OCR nền
    func layCaiDatAnToan() -> CaiDatDMX {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        return caiDat
    }

    private func xoaBoNhoDem(xoaonLocTen: Bool = false) {
        khoaTruyCap.lock()
        phienBanDuLieu &+= 1
        let cumTuHienTai = caiDat.danhSachCumTuLocBo
        boNhoDemDuLieuNgay.removeAll(keepingCapacity: true)
        boNhoDemMatHangThang.removeAll(keepingCapacity: true)
        boNhoDemThucHienNVThang.removeAll(keepingCapacity: true)
        boNhoDemTongHopNV.removeAll(keepingCapacity: true)
        boNhoDemBaoCaoSucKhoe.removeAll(keepingCapacity: true)
        boNhoDemRealtimeThang.removeAll(keepingCapacity: true)
        boNhoDemDuBaoThang.removeAll(keepingCapacity: true)
        boNhoDemDTLuyKeThang.removeAll(keepingCapacity: true)
        boNhoDemDTNVLuyKeThang.removeAll(keepingCapacity: true)
        khoaTruyCap.unlock()
        Self.khoaBoNhoDemTinh.lock()
        Self.danhSachCumTuLocBoTinh = cumTuHienTai
        if xoaonLocTen {
            Self.boNhoDemLocTen.removeAll(keepingCapacity: true)
        }
        Self.khoaBoNhoDemTinh.unlock()
    }

    func doc() {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let thuMuc = ThuMucDuLieu.dungChung
        if let cd = thuMuc.doc(CaiDatDMX.self, tu: thuMuc.tepCaiDat) {
            caiDat = cd
        } else {
            caiDat = CaiDatDMX()
        }
        Self.khoaBoNhoDemTinh.lock()
        Self.danhSachCumTuLocBoTinh = caiDat.danhSachCumTuLocBo
        Self.boNhoDemLocTen.removeAll(keepingCapacity: true)
        Self.khoaBoNhoDemTinh.unlock()

        if var giaTri = thuMuc.doc([String: DuLieuNgayDMX].self, tu: thuMuc.tepNgay) {
            for (khoa, var dl) in giaTri {
                if !dl.danhSachThiDua.isEmpty {
                    dl.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: dl.danhSachThiDua)
                }
                if !dl.danhSachThiDuaRealtime.isEmpty {
                    dl.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: dl.danhSachThiDuaRealtime)
                }
                dl.khoaNgay = khoa
                apDungCoXoa(vao: &dl)
                giaTri[khoa] = dl
            }
            cacNgay = giaTri
        } else {
            cacNgay = [:]
        }
        xoaBoNhoDem(xoaonLocTen: true)
    }

    /// Chuyển dữ liệu bằng RAM/ổ máy trước, không chờ mạng. Mỗi lần rời một siêu thị
    /// đều cập nhật snapshot mới nhất nên quay lại gần như tức thời.
    func chuyenSieuThiNhanh(tu idCu: String, sang idMoi: String, laMacDinh: Bool) {
        let thuMuc = ThuMucDuLieu.dungChung
        let daKhoiPhuc = thuMuc.khoiPhucDuLieuCuNeuCan(choSieuThi: idMoi, laMacDinh: laMacDinh)

        khoaTruyCap.lock()
        if !idCu.isEmpty && idCu != idMoi {
            boNhoSieuThi[idCu] = (caiDat, cacNgay)
        }
        if !daKhoiPhuc, let daCo = boNhoSieuThi[idMoi] {
            caiDat = daCo.caiDat
            cacNgay = daCo.cacNgay
            xoaBoNhoDem(xoaonLocTen: true)
            khoaTruyCap.unlock()
            return
        }
        khoaTruyCap.unlock()

        let cd = thuMuc.doc(CaiDatDMX.self, tu: thuMuc.tepCaiDat(choSieuThi: idMoi)) ?? CaiDatDMX()
        let ngay = thuMuc.doc([String: DuLieuNgayDMX].self, tu: thuMuc.tepNgay(choSieuThi: idMoi)) ?? [:]
        khoaTruyCap.lock()
        caiDat = cd
        cacNgay = ngay
        boNhoSieuThi[idMoi] = (cd, ngay)
        xoaBoNhoDem(xoaonLocTen: true)
        khoaTruyCap.unlock()
    }

    /// Đọc trước các siêu thị chưa mở trên luồng nền để lần chọn đầu tiên cũng nhanh.
    func napTruocSieuThi(id: String, laMacDinh: Bool) {
        guard !id.isEmpty else { return }
        khoaTruyCap.lock()
        let daCo = boNhoSieuThi[id] != nil
        khoaTruyCap.unlock()
        guard !daCo else { return }
        let thuMuc = ThuMucDuLieu.dungChung
        _ = thuMuc.khoiPhucDuLieuCuNeuCan(choSieuThi: id, laMacDinh: laMacDinh)
        let cd = thuMuc.doc(CaiDatDMX.self, tu: thuMuc.tepCaiDat(choSieuThi: id)) ?? CaiDatDMX()
        let ngay = thuMuc.doc([String: DuLieuNgayDMX].self, tu: thuMuc.tepNgay(choSieuThi: id)) ?? [:]
        khoaTruyCap.lock()
        if boNhoSieuThi[id] == nil { boNhoSieuThi[id] = (cd, ngay) }
        khoaTruyCap.unlock()
    }

    /// Lấy Doanh thu Lũy kế cố định của tháng (mỗi lần nhập ở ngày mới sẽ thay thế cho ngày hôm trước)
    func doanhThuLuyKeThang(cho ngay: Date) -> ThongTinDoanhThu {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoa = TienIchNgay.khoa.string(from: ngay)
        if let daDem = boNhoDemDTLuyKeThang[khoa] {
            return daDem
        }
        let tienTo = String(khoa.prefix(7))
        if let hienTai = cacNgay[khoa]?.doanhThu, hienTai.coDuLieu {
            boNhoDemDTLuyKeThang[khoa] = hienTai
            return hienTai
        }
        for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) }).sorted(by: >) {
            if let dt = cacNgay[k]?.doanhThu, dt.coDuLieu {
                boNhoDemDTLuyKeThang[khoa] = dt
                return dt
            }
        }
        let trong = ThongTinDoanhThu()
        boNhoDemDTLuyKeThang[khoa] = trong
        return trong
    }

    /// Lấy thông số Sức khỏe bổ sung của nhân viên trong tháng
    func sucKhoeBoSungNhanVienThang(cho ngay: Date) -> [String: DuLieuSucKhoeBoSungNV] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        var ketQua: [String: DuLieuSucKhoeBoSungNV] = [:]
        for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 <= khoa }).sorted() {
            guard let bang = cacNgay[k]?.sucKhoeBoSungNhanVien, !bang.isEmpty else { continue }
            for (ma, info) in bang {
                if let cu = ketQua[ma] {
                    ketQua[ma] = cu.gop(voi: info)
                } else {
                    ketQua[ma] = info
                }
            }
        }
        return ketQua
    }

    /// Lấy Doanh thu QĐ từng tháng trong 6 tháng gần nhất (kết thúc tại tháng của `ngay`) cho 1 nhân viên
    func layDoanhThuQDTheo6ThangGanNhat(
        maNV: String,
        den ngay: Date,
        doanhThuThangHienTai: Double,
        boSung: DuLieuSucKhoeBoSungNV? = nil
    ) -> [(nhanThang: String, giaTri: Double?)] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let lich = TienIchNgay.lich
        let maChuan = Self.chuanHoaMaNV(maNV)
        var ketQua: [(nhanThang: String, giaTri: Double?)] = []

        for offset in stride(from: -5, through: 0, by: 1) {
            guard let ngayThang = lich.date(byAdding: .month, value: offset, to: ngay) else { continue }
            let nam = lich.component(.year, from: ngayThang)
            let thang = lich.component(.month, from: ngayThang)
            let tienTo = String(format: "%04d-%02d", nam, thang)
            let nhan = String(format: "%02d/%04d", thang, nam)

            if let valBoSung = boSung?.doanhThuQDTungThang[nhan], valBoSung > 0 {
                ketQua.append((nhan, valBoSung))
                continue
            }
            if offset == 0 && doanhThuThangHienTai > 0 {
                ketQua.append((nhan, doanhThuThangHienTai))
                continue
            }

            var giaTriTimThay: Double?
            for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) }).sorted(by: >) {
                if let ds = cacNgay[k]?.doanhThuNhanVien,
                   let item = ds.first(where: { Self.chuanHoaMaNV($0.maNV) == maChuan }),
                   item.doanhThuQD > 0 {
                    giaTriTimThay = item.doanhThuQD
                    break
                }
            }
            ketQua.append((nhan, giaTriTimThay))
        }
        return ketQua
    }

    /// Kiểm tra và loại bỏ dữ liệu Doanh thu NV bị nhiễm từ bảng Ma trận Thi đua Nhân viên (ví dụ SỐ LƯỢNG có số lẻ thập phân 5.24, 16.43). Tuyệt đối giữ nguyên nhân viên có ít đơn nhưng tỉ trọng cao (như Nguyễn Ngọc Đẩu 23986: SL=2, DTQĐ=117, Tỉ trọng=62.5%)
    static func laItemDTNVBiNhiemMaTran(_ it: DoanhThuNhanVienItem) -> Bool {
        if abs(it.soLuong - it.soLuong.rounded()) > 0.01 { return true }
        return false
    }

    static func locSachDanhSachDTNV(_ ds: [DoanhThuNhanVienItem]) -> [DoanhThuNhanVienItem] {
        guard !ds.isEmpty else { return [] }
        let dsHopLe = ds.filter { !laItemDTNVBiNhiemMaTran($0) }
        guard !dsHopLe.isEmpty else { return [] }
        var mapTheoMa: [String: DoanhThuNhanVienItem] = [:]
        var thuTu: [String] = []
        for it in dsHopLe {
            let ma = chuanHoaMaNV(it.maNV)
            let khoa = ma.isEmpty ? it.hoTen : ma
            guard !khoa.isEmpty else { continue }
            if let cu = mapTheoMa[khoa] {
                let diemCu = abs(cu.doanhThuQD) * 1000 + abs(cu.soLuong) * 10 + abs(cu.phanTramQuyDoi)
                let diemMoi = abs(it.doanhThuQD) * 1000 + abs(it.soLuong) * 10 + abs(it.phanTramQuyDoi)
                var gop = (diemMoi >= diemCu) ? it : cu
                let phu = (diemMoi >= diemCu) ? cu : it
                if abs(gop.doanhThuQD) < 0.0001 && abs(phu.doanhThuQD) > 0.0001 { gop.doanhThuQD = phu.doanhThuQD }
                if abs(gop.soLuong) < 0.0001 && abs(phu.soLuong) > 0.0001 { gop.soLuong = phu.soLuong }
                if abs(gop.dtQDKhoanVay) < 0.0001 && abs(phu.dtQDKhoanVay) > 0.0001 { gop.dtQDKhoanVay = phu.dtQDKhoanVay }
                if abs(gop.phanTramQuyDoi) < 0.0001 && abs(phu.phanTramQuyDoi) > 0.0001 { gop.phanTramQuyDoi = phu.phanTramQuyDoi }
                if gop.gioCong <= 0.0001 && phu.gioCong > 0.0001 { gop.gioCong = phu.gioCong }
                if gop.gioCongHoTro <= 0.0001 && phu.gioCongHoTro > 0.0001 { gop.gioCongHoTro = phu.gioCongHoTro }
                mapTheoMa[khoa] = gop
            } else {
                mapTheoMa[khoa] = it
                thuTu.append(khoa)
            }
        }
        return thuTu.compactMap { mapTheoMa[$0] }
    }

    /// Lấy Doanh thu Lũy kế Nhân viên của tháng (khi nhập mới sẽ thay thế dữ liệu cũ)
    func doanhThuNhanVienLuyKeThang(cho ngay: Date) -> [DoanhThuNhanVienItem] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoa = TienIchNgay.khoa.string(from: ngay)
        if let daDem = boNhoDemDTNVLuyKeThang[khoa] {
            return daDem
        }
        let tienTo = String(khoa.prefix(7))
        if let hienTai = cacNgay[khoa]?.doanhThuNhanVien {
            let sach = Self.locSachDanhSachDTNV(hienTai)
            if !sach.isEmpty {
                boNhoDemDTNVLuyKeThang[khoa] = sach
                return sach
            }
        }
        for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) }).sorted(by: >) {
            if let ds = cacNgay[k]?.doanhThuNhanVien {
                let sach = Self.locSachDanhSachDTNV(ds)
                if !sach.isEmpty {
                    boNhoDemDTNVLuyKeThang[khoa] = sach
                    return sach
                }
            }
        }
        boNhoDemDTNVLuyKeThang[khoa] = []
        return []
    }

    /// Xoá toàn bộ dữ liệu Nhân viên (Sức khỏe 27 điểm, Doanh thu NV & Thi đua NV) của tháng để dữ liệu cũ không còn tồn đọng
    func xoaDoanhThuNhanVienLuyKeThang(cho ngay: Date, xoaCaThiDuaNV: Bool = true) {
        khoaTruyCap.lock()
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        cacKhoaMucDaXoa.insert("nv_dt|\(tienTo)")
        if xoaCaThiDuaNV {
            cacKhoaMucDaXoa.insert("nv_td|\(tienTo)")
        }
        luuTapKhoaMucDaXoa()
        var khoaCanDongBo = Set(cacNgay.keys.filter { $0.hasPrefix(tienTo) })
        khoaCanDongBo.insert(khoa)
        for k in khoaCanDongBo {
            if cacNgay[k] == nil {
                cacNgay[k] = DuLieuNgayDMX(
                    khoaNgay: k,
                    capNhatLuc: "",
                    thongTinDonVi: "",
                    doanhThu: ThongTinDoanhThu(),
                    danhSachThiDua: []
                )
            }
            cacNgay[k]?.doanhThuNhanVien = []
            cacNgay[k]?.doanhThuNhanVienRealtime = []
            cacNgay[k]?.sucKhoeBoSungNhanVien = [:]
            if xoaCaThiDuaNV {
                cacNgay[k]?.thiDuaNhanVien = [:]
                cacNgay[k]?.thiDuaNhanVienRealtime = [:]
            }
        }
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        for k in khoaCanDongBo {
            if let dlDaXoa = banSaoNgay[k] {
                DichVuDongBo.dungChung.dayDuLieuNgay(dlDaXoa)
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: khoa)
        }
    }

    /// Xoá riêng dữ liệu Doanh thu Nhân viên Realtime của ngày đang chọn
    func xoaDoanhThuNhanVienRealtime(cho ngay: Date) {
        khoaTruyCap.lock()
        let khoa = TienIchNgay.khoa.string(from: ngay)
        if var dl = cacNgay[khoa] {
            dl.doanhThuNhanVienRealtime = []
            dl.thiDuaNhanVienRealtime = [:]
            cacNgay[khoa] = dl
        }
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        let dlDaXoa = cacNgay[khoa]
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        if let dlDaXoa {
            DichVuDongBo.dungChung.dayDuLieuNgay(dlDaXoa)
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: khoa)
        }
    }

    /// Xoá dữ liệu đã quét của riêng 1 nhân viên cụ thể trong toàn bộ tháng
    func xoaDuLieuMotNhanVien(maNV: String, cho ngay: Date) {
        let maChuan = Self.chuanHoaMaNV(maNV)
        guard !maChuan.isEmpty else { return }
        khoaTruyCap.lock()
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        cacKhoaMucDaXoa.insert("nv_one|\(tienTo)|\(maChuan)")
        luuTapKhoaMucDaXoa()
        var khoaCanDongBo = Set(cacNgay.keys.filter { $0.hasPrefix(tienTo) })
        khoaCanDongBo.insert(khoa)

        for k in khoaCanDongBo {
            guard var dl = cacNgay[k] else { continue }
            dl.doanhThuNhanVien.removeAll { Self.chuanHoaMaNV($0.maNV) == maChuan }
            dl.doanhThuNhanVienRealtime.removeAll { Self.chuanHoaMaNV($0.maNV) == maChuan }
            dl.sucKhoeBoSungNhanVien.removeValue(forKey: maChuan)
            dl.sucKhoeBoSungNhanVien.removeValue(forKey: maNV)
            for kMon in Array(dl.thiDuaNhanVien.keys) {
                dl.thiDuaNhanVien[kMon]?.removeValue(forKey: maChuan)
                dl.thiDuaNhanVien[kMon]?.removeValue(forKey: maNV)
            }
            for kMon in Array(dl.thiDuaNhanVienRealtime.keys) {
                dl.thiDuaNhanVienRealtime[kMon]?.removeValue(forKey: maChuan)
                dl.thiDuaNhanVienRealtime[kMon]?.removeValue(forKey: maNV)
            }
            cacNgay[k] = dl
        }
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        for k in khoaCanDongBo {
            if let dlDaXoa = banSaoNgay[k] {
                DichVuDongBo.dungChung.dayDuLieuNgay(dlDaXoa)
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: khoa)
        }
    }

    /// Xoá danh sách Thi đua ngành hàng theo chế độ (Lũy kế xoá toàn tháng, Realtime xoá ngày đang chọn)
    func xoaThiDuaTheoCheDo(cho ngay: Date, cheDo: LoaiCheDoDoanhThu) {
        khoaTruyCap.lock()
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        cacKhoaMucDaXoa.insert("td_\(cheDo.rawValue)|\(cheDo == .luyKe ? tienTo : khoa)")
        luuTapKhoaMucDaXoa()
        var khoaCanDongBo = Set<String>([khoa])
        if cheDo == .luyKe {
            for k in cacNgay.keys where k.hasPrefix(tienTo) {
                khoaCanDongBo.insert(k)
            }
        }
        for k in khoaCanDongBo {
            if cacNgay[k] == nil {
                cacNgay[k] = DuLieuNgayDMX(
                    khoaNgay: k,
                    capNhatLuc: "",
                    thongTinDonVi: "",
                    doanhThu: ThongTinDoanhThu(),
                    danhSachThiDua: []
                )
            }
            if cheDo == .luyKe {
                cacNgay[k]?.danhSachThiDua = []
            } else {
                cacNgay[k]?.danhSachThiDuaRealtime = []
            }
        }
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        for k in khoaCanDongBo {
            if let dlDaXoa = banSaoNgay[k] {
                DichVuDongBo.dungChung.dayDuLieuNgay(dlDaXoa)
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: khoa)
        }
    }

    /// Xoá Doanh thu Lũy kế cố định của tháng
    func xoaDoanhThuLuyKeThang(cho ngay: Date) {
        khoaTruyCap.lock()
        let khoa = TienIchNgay.khoa.string(from: ngay)
        let tienTo = String(khoa.prefix(7))
        cacKhoaMucDaXoa.insert("dt_lk|\(tienTo)")
        luuTapKhoaMucDaXoa()
        let doanhThuTrong = ThongTinDoanhThu()
        var khoaCanDongBo = Set(cacNgay.keys.filter { k in
            k.hasPrefix(tienTo) && cacNgay[k]?.doanhThu != doanhThuTrong
        })
        khoaCanDongBo.insert(khoa)
        for k in khoaCanDongBo {
            cacNgay[k]?.doanhThu = ThongTinDoanhThu()
        }
        xoaBoNhoDem()
        var dl = duLieu(cho: ngay)
        dl.doanhThu = ThongTinDoanhThu()
        cacNgay[khoa] = dl
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        for k in khoaCanDongBo {
            if let ngayDaXoa = banSaoNgay[k] {
                DichVuDongBo.dungChung.dayDuLieuNgay(ngayDaXoa)
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: khoa)
        }
    }

    /// Xoá Doanh thu Realtime của ngày đang chọn
    func xoaDoanhThuRealtime(cho ngay: Date) {
        khoaTruyCap.lock()
        let khoa = TienIchNgay.khoa.string(from: ngay)
        cacKhoaMucDaXoa.insert("dt_rt|\(khoa)")
        luuTapKhoaMucDaXoa()
        var dl = duLieu(cho: ngay)
        dl.doanhThuRealtime = ThongTinDoanhThu()
        cacNgay[khoa] = dl
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        if let ngayDaXoa = banSaoNgay[khoa] {
            DichVuDongBo.dungChung.dayDuLieuNgay(ngayDaXoa)
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: khoa)
        }
    }

    /// Khóa tháng dạng "yyyy-MM"
    func khoaThang(cho ngay: Date) -> String {
        let k = TienIchNgay.khoa.string(from: ngay)
        return String(k.prefix(7))
    }

    /// Số ngày thực tế của tháng (28, 29, 30 hoặc 31)
    func soNgayTrongThang(cho ngay: Date) -> Int {
        TienIchNgay.lich.range(of: .day, in: .month, for: ngay)?.count ?? 30
    }

    /// Lấy Mục tiêu Doanh thu Quy đổi tháng từ Target QĐ Lũy kế đã quét
    func mucTieuDoanhThuQDThang(cho ngay: Date) -> Double {
        let lk = doanhThuLuyKeThang(cho: ngay)
        if lk.targetQuyDoi > 0 {
            return lk.targetQuyDoi
        }
        return 0
    }

    /// Tính toán Dự báo Doanh thu QĐ cuối tháng, % HT QĐ dự kiến & % Quy đổi dự kiến cho bảng Biểu đồ tháng.
    func tinhDuBaoQuyDoiTuRealtime(cho ngay: Date, cheDoDangXem: LoaiCheDoDoanhThu = .realtime) -> DuBaoQuyDoiThang {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoaDem = "\(TienIchNgay.khoa.string(from: ngay))|\(cheDoDangXem.rawValue)"
        if let daDem = boNhoDemDuBaoThang[khoaDem] {
            return daDem
        }
        let soNgay = max(1, soNgayTrongThang(cho: ngay))
        let lk = doanhThuLuyKeThang(cho: ngay)
        let mucTieuThang = lk.targetQuyDoi
        let mucTieuNgay = mucTieuThang > 0 ? (mucTieuThang / Double(soNgay)) : 0

        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let tatCaNgay = danhSachRealtimeTheoNgayTrongThang(cho: ngay)
        let cacNgayCoRTDenNgay = tatCaNgay.filter { $0.khoaNgay <= khoaDen && ($0.doanhThuQuyDoi > 0 || $0.doanhThuThuc > 0) }
        let cacNgayCoRTTrongThang = tatCaNgay.filter { $0.doanhThuQuyDoi > 0 || $0.doanhThuThuc > 0 }
        let cacNgayCoRT = !cacNgayCoRTDenNgay.isEmpty ? cacNgayCoRTDenNgay : cacNgayCoRTTrongThang

        let dlNgayChon = duLieu(cho: ngay)

        var soNgayTinh = cacNgayCoRT.count
        var tongQD = cacNgayCoRT.reduce(0.0) { $0 + $1.doanhThuQuyDoi }
        var tongThuc = cacNgayCoRT.reduce(0.0) { $0 + $1.doanhThuThuc }

        let tbQDMoiNgay: Double
        let tbThucMoiNgay: Double

        if soNgayTinh > 0 {
            tbQDMoiNgay = tongQD / Double(soNgayTinh)
            tbThucMoiNgay = tongThuc / Double(soNgayTinh)
        } else if lk.coDuLieu {
            let ngayDaQua = lk.soNgayDaQua > 0 ? lk.soNgayDaQua : max(1, TienIchNgay.lich.component(.day, from: ngay))
            soNgayTinh = ngayDaQua
            tongQD = lk.doanhThuQuyDoi
            tongThuc = lk.doanhThuThuc
            tbQDMoiNgay = ngayDaQua > 0 ? (lk.doanhThuQuyDoi / Double(ngayDaQua)) : 0
            tbThucMoiNgay = ngayDaQua > 0 ? (lk.doanhThuThuc / Double(ngayDaQua)) : 0
        } else {
            tbQDMoiNgay = 0
            tbThucMoiNgay = 0
        }

        let duKienQDCuoiThang = lk.duKienQuyDoi > 0 ? lk.duKienQuyDoi : (tbQDMoiNgay * Double(soNgay))
        let duKienThucCuoiThang = lk.duKienThuc > 0 ? lk.duKienThuc : (tbThucMoiNgay * Double(soNgay))

        let phanTramHTQDDuKien: Double
        if lk.phanTramHTQuyDoi > 0 {
            phanTramHTQDDuKien = lk.phanTramHTQuyDoi
        } else if dlNgayChon.doanhThuRealtime.phanTramHTQuyDoi > 0 {
            phanTramHTQDDuKien = dlNgayChon.doanhThuRealtime.phanTramHTQuyDoi
        } else if mucTieuThang > 0, duKienQDCuoiThang > 0 {
            phanTramHTQDDuKien = (duKienQDCuoiThang / mucTieuThang) * 100.0
        } else if dlNgayChon.doanhThuRealtime.targetQuyDoi > 0, tbQDMoiNgay > 0 {
            phanTramHTQDDuKien = (tbQDMoiNgay / dlNgayChon.doanhThuRealtime.targetQuyDoi) * 100.0
        } else {
            phanTramHTQDDuKien = 0
        }

        let phanTramQDDuKien: Double
        if duKienThucCuoiThang > 0, duKienQDCuoiThang > 0 {
            phanTramQDDuKien = ((duKienQDCuoiThang - duKienThucCuoiThang) / duKienThucCuoiThang) * 100.0
        } else {
            let dt = (cheDoDangXem == .luyKe) ? dlNgayChon.doanhThu : dlNgayChon.doanhThuRealtime
            phanTramQDDuKien = dt.phanTramQuyDoi
        }

        let ketQua = DuBaoQuyDoiThang(
            mucTieuThang: mucTieuThang,
            soNgayTrongThang: soNgay,
            mucTieuMoiNgay: mucTieuNgay,
            soNgayCoRealtime: soNgayTinh,
            tongDTThucRealtime: tongThuc,
            tongDTQDRealtime: tongQD,
            trungBinhThucMoiNgay: tbThucMoiNgay,
            trungBinhQDMoiNgay: tbQDMoiNgay,
            duKienThucCuoiThang: duKienThucCuoiThang,
            duKienQDCuoiThang: duKienQDCuoiThang,
            phanTramHTQDDuKien: phanTramHTQDDuKien,
            phanTramQuyDoiDuKien: phanTramQDDuKien
        )
        boNhoDemDuBaoThang[khoaDem] = ketQua
        return ketQua
    }

    /// Danh sách Doanh thu Realtime (Thực & Quy đổi) theo từng ngày trong tháng để vẽ đồ thị cột và bảng tổng hợp
    func danhSachRealtimeTheoNgayTrongThang(cho ngay: Date) -> [DuLieuRealtimeNgayTrongThang] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let lich = TienIchNgay.lich
        let nam = lich.component(.year, from: ngay)
        let thang = lich.component(.month, from: ngay)
        let khoaThangDem = String(format: "%04d-%02d", nam, thang)
        if let daDem = boNhoDemRealtimeThang[khoaThangDem] {
            return daDem
        }
        let soNgay = lich.range(of: .day, in: .month, for: ngay)?.count ?? 30

        var ketQua: [DuLieuRealtimeNgayTrongThang] = []
        ketQua.reserveCapacity(soNgay)
        for d in 1...soNgay {
            var comp = DateComponents()
            comp.year = nam
            comp.month = thang
            comp.day = d
            let ngayD = lich.date(from: comp) ?? ngay
            let khoa = String(format: "%04d-%02d-%02d", nam, thang, d)
            let rt = cacNgay[khoa]?.doanhThuRealtime ?? ThongTinDoanhThu()
            ketQua.append(
                DuLieuRealtimeNgayTrongThang(
                    ngay: ngayD,
                    khoaNgay: khoa,
                    ngayTrongThang: d,
                    doanhThu: rt
                )
            )
        }
        boNhoDemRealtimeThang[khoaThangDem] = ketQua
        return ketQua
    }

    func duLieu(cho ngay: Date) -> DuLieuNgayDMX {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoa = TienIchNgay.khoa.string(from: ngay)
        if let daDem = boNhoDemDuLieuNgay[khoa] {
            return daDem
        }

        let tienTo = String(khoa.prefix(7))
        let luyKeThang = doanhThuLuyKeThang(cho: ngay)
        let dtNVLuyKeThang = doanhThuNhanVienLuyKeThang(cho: ngay)
        let skBoSungThang = sucKhoeBoSungNhanVienThang(cho: ngay)

        // Tìm target Lũy kế & Realtime gần nhất trong tháng (tách biệt hoàn toàn giữa Lũy kế và Realtime)
        var targetTheoKhoaTrongThang: [String: Double] = [:]
        var targetRealtimeTheoKhoaTrongThang: [String: Double] = [:]
        for kNgay in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 <= khoa }).sorted() {
            guard let dlNgay = cacNgay[kNgay] else { continue }
            for d in dlNgay.danhSachThiDua where d.target > 0 {
                let k1 = Self.chuanHoaKhoaSoSanh(Self.apDungLocTuCaiDat(d.tenNganhHangGoc))
                let k2 = Self.chuanHoaKhoaSoSanh(d.tenNganhHangGoc)
                if !k1.isEmpty { targetTheoKhoaTrongThang[k1] = d.target }
                if !k2.isEmpty { targetTheoKhoaTrongThang[k2] = d.target }
            }
            for d in dlNgay.danhSachThiDuaRealtime where d.target > 0 {
                let k1 = Self.chuanHoaKhoaSoSanh(Self.apDungLocTuCaiDat(d.tenNganhHangGoc))
                let k2 = Self.chuanHoaKhoaSoSanh(d.tenNganhHangGoc)
                if !k1.isEmpty { targetRealtimeTheoKhoaTrongThang[k1] = d.target }
                if !k2.isEmpty { targetRealtimeTheoKhoaTrongThang[k2] = d.target }
            }
        }

        if var coSan = cacNgay[khoa] {
            if !coSan.doanhThu.coDuLieu && luyKeThang.coDuLieu {
                coSan.doanhThu = luyKeThang
            }
            if coSan.doanhThuNhanVien.isEmpty && !dtNVLuyKeThang.isEmpty {
                coSan.doanhThuNhanVien = dtNVLuyKeThang
            }
            if !skBoSungThang.isEmpty {
                var gopSK = skBoSungThang
                for (ma, skNgay) in coSan.sucKhoeBoSungNhanVien {
                    if let cu = gopSK[ma] {
                        gopSK[ma] = cu.gop(voi: skNgay)
                    } else {
                        gopSK[ma] = skNgay
                    }
                }
                coSan.sucKhoeBoSungNhanVien = gopSK
            }
            for i in coSan.danhSachThiDua.indices {
                let goc = coSan.danhSachThiDua[i].tenNganhHangGoc
                coSan.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
                if coSan.danhSachThiDua[i].target <= 0 {
                    let k1 = Self.chuanHoaKhoaSoSanh(coSan.danhSachThiDua[i].tenNganhHang)
                    let k2 = Self.chuanHoaKhoaSoSanh(goc)
                    if let t = targetTheoKhoaTrongThang[k1] ?? targetTheoKhoaTrongThang[k2], t > 0 {
                        coSan.danhSachThiDua[i].target = t
                    }
                }
            }
            coSan.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: coSan.danhSachThiDua)

            for i in coSan.danhSachThiDuaRealtime.indices {
                let goc = coSan.danhSachThiDuaRealtime[i].tenNganhHangGoc
                coSan.danhSachThiDuaRealtime[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
                if coSan.danhSachThiDuaRealtime[i].target <= 0 {
                    let k1 = Self.chuanHoaKhoaSoSanh(coSan.danhSachThiDuaRealtime[i].tenNganhHang)
                    let k2 = Self.chuanHoaKhoaSoSanh(goc)
                    if let t = targetRealtimeTheoKhoaTrongThang[k1] ?? targetRealtimeTheoKhoaTrongThang[k2], t > 0 {
                        coSan.danhSachThiDuaRealtime[i].target = t
                    }
                }
            }
            coSan.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: coSan.danhSachThiDuaRealtime)
            boNhoDemDuLieuNgay[khoa] = coSan
            return coSan
        }

        let moi = DuLieuNgayDMX(
            khoaNgay: khoa,
            capNhatLuc: "",
            thongTinDonVi: "",
            doanhThu: luyKeThang,
            doanhThuRealtime: ThongTinDoanhThu(),
            danhSachThiDua: [],
            danhSachThiDuaRealtime: [],
            doanhThuNhanVien: dtNVLuyKeThang,
            sucKhoeBoSungNhanVien: skBoSungThang
        )
        boNhoDemDuLieuNgay[khoa] = moi
        return moi
    }

    func luu(_ duLieu: DuLieuNgayDMX) {
        khoaTruyCap.lock()
        var banLuu = duLieu
        let tienTo = String(banLuu.khoaNgay.prefix(7))
        var coThayDoiCoXoa = false
        if banLuu.doanhThu.coDuLieu && cacKhoaMucDaXoa.remove("dt_lk|\(tienTo)") != nil { coThayDoiCoXoa = true }
        if banLuu.doanhThuRealtime.coDuLieu && cacKhoaMucDaXoa.remove("dt_rt|\(banLuu.khoaNgay)") != nil { coThayDoiCoXoa = true }
        if !banLuu.danhSachThiDua.isEmpty && cacKhoaMucDaXoa.remove("td_0|\(tienTo)") != nil { coThayDoiCoXoa = true }
        if !banLuu.danhSachThiDuaRealtime.isEmpty && cacKhoaMucDaXoa.remove("td_1|\(banLuu.khoaNgay)") != nil { coThayDoiCoXoa = true }
        if !banLuu.doanhThuNhanVien.isEmpty || !banLuu.doanhThuNhanVienRealtime.isEmpty || !banLuu.sucKhoeBoSungNhanVien.isEmpty {
            if cacKhoaMucDaXoa.remove("nv_dt|\(tienTo)") != nil { coThayDoiCoXoa = true }
            for item in banLuu.doanhThuNhanVien + banLuu.doanhThuNhanVienRealtime {
                let ma = Self.chuanHoaMaNV(item.maNV)
                if !ma.isEmpty && cacKhoaMucDaXoa.remove("nv_one|\(tienTo)|\(ma)") != nil { coThayDoiCoXoa = true }
            }
            for ma in banLuu.sucKhoeBoSungNhanVien.keys {
                let maChuan = Self.chuanHoaMaNV(ma)
                if !maChuan.isEmpty && cacKhoaMucDaXoa.remove("nv_one|\(tienTo)|\(maChuan)") != nil { coThayDoiCoXoa = true }
            }
        }
        if !banLuu.thiDuaNhanVien.isEmpty || !banLuu.thiDuaNhanVienRealtime.isEmpty {
            if cacKhoaMucDaXoa.remove("nv_td|\(tienTo)") != nil { coThayDoiCoXoa = true }
        }
        if coThayDoiCoXoa { luuTapKhoaMucDaXoa() }

        for i in banLuu.danhSachThiDua.indices {
            let goc = banLuu.danhSachThiDua[i].tenNganhHangGoc
            banLuu.danhSachThiDua[i].tenNganhHang = Self.apDungLocTuCaiDat(goc)
        }
        banLuu.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: banLuu.danhSachThiDua)

        for i in banLuu.danhSachThiDuaRealtime.indices {
            let goc = banLuu.danhSachThiDuaRealtime[i].tenNganhHangGoc
            banLuu.danhSachThiDuaRealtime[i].tenNganhHang = Self.apDungLocTuCaiDat(goc)
        }
        banLuu.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: banLuu.danhSachThiDuaRealtime)

        // Doanh thu Lũy kế là cố định của tháng: khi người dùng nhập vào mỗi ngày sẽ thay thế cho ngày hôm trước trong cùng tháng
        if banLuu.doanhThu.coDuLieu {
            for k in cacNgay.keys where k.hasPrefix(tienTo) {
                cacNgay[k]?.doanhThu = banLuu.doanhThu
            }
        } else if !cacKhoaMucDaXoa.contains("dt_lk|\(tienTo)") {
            for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 != banLuu.khoaNgay }).sorted(by: >) {
                if let dtCu = cacNgay[k]?.doanhThu, dtCu.coDuLieu {
                    banLuu.doanhThu = dtCu
                    break
                }
            }
        }

        // Doanh thu Lũy kế nhân viên: mỗi khi nhập mới sẽ thay thế hoàn toàn dữ liệu cũ của tháng
        if !banLuu.doanhThuNhanVien.isEmpty {
            for k in cacNgay.keys where k.hasPrefix(tienTo) {
                cacNgay[k]?.doanhThuNhanVien = banLuu.doanhThuNhanVien
            }
        } else if !cacKhoaMucDaXoa.contains("nv_dt|\(tienTo)") {
            for k in cacNgay.keys.filter({ $0.hasPrefix(tienTo) && $0 != banLuu.khoaNgay }).sorted(by: >) {
                if let dsCu = cacNgay[k]?.doanhThuNhanVien, !dsCu.isEmpty {
                    banLuu.doanhThuNhanVien = dsCu
                    break
                }
            }
        }

        if !banLuu.sucKhoeBoSungNhanVien.isEmpty {
            for k in cacNgay.keys where k.hasPrefix(tienTo) && k != banLuu.khoaNgay {
                var skCu = cacNgay[k]?.sucKhoeBoSungNhanVien ?? [:]
                for (ma, skMoi) in banLuu.sucKhoeBoSungNhanVien {
                    if let cu = skCu[ma] {
                        skCu[ma] = cu.gop(voi: skMoi)
                    } else {
                        skCu[ma] = skMoi
                    }
                }
                cacNgay[k]?.sucKhoeBoSungNhanVien = skCu
            }
        }

        cacNgay[banLuu.khoaNgay] = banLuu
        xoaBoNhoDem()
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
        DichVuDongBo.dungChung.dayDuLieuNgay(banLuu)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .duLieuDMXDaThayDoiTaiMay, object: banLuu.khoaNgay)
        }
    }

    func luuCaiDat(_ moi: CaiDatDMX) {
        khoaTruyCap.lock()
        var moi = moi
        moi.danhSachNhanVien = NhanVienQuanLy.sapXepAZ(moi.danhSachNhanVien)
        let doiCumTu = (caiDat.danhSachCumTuLocBo != moi.danhSachCumTuLocBo)
        UserDefaults.standard.set(moi.phuongPhapQuetThiDua.rawValue, forKey: "dmx.caiDat.phuongPhapQuetThiDua.v2")
        UserDefaults.standard.set(moi.phuongPhapQuetThiDua.rawValue, forKey: "dmx.caiDat.phuongPhapQuetThiDua")
        UserDefaults.standard.set(moi.geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "dmx.caiDat.geminiApiKey")
        UserDefaults.standard.set(moi.geminiApiKey2.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "dmx.caiDat.geminiApiKey2")
        UserDefaults.standard.set(moi.geminiApiKey3.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "dmx.caiDat.geminiApiKey3")
        UserDefaults.standard.set(moi.hienThiNangSuatNhanVien, forKey: "dmx.caiDat.hienThiNangSuatNhanVien")
        caiDat = moi
        xoaBoNhoDem(xoaonLocTen: doiCumTu)
        let banSaoCaiDat = moi
        var banSaoNgayCanLuu: [String: DuLieuNgayDMX]?
        if doiCumTu {
            for (khoa, var dl) in cacNgay {
                for i in dl.danhSachThiDua.indices {
                    let goc = dl.danhSachThiDua[i].tenNganhHangGoc
                    dl.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
                }
                dl.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: dl.danhSachThiDua)

                for i in dl.danhSachThiDuaRealtime.indices {
                    let goc = dl.danhSachThiDuaRealtime[i].tenNganhHangGoc
                    dl.danhSachThiDuaRealtime[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
                }
                dl.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: dl.danhSachThiDuaRealtime)
                cacNgay[khoa] = dl
            }
            xoaBoNhoDem()
            banSaoNgayCanLuu = cacNgay
        }
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiCaiDatBatDongBo(banSaoCaiDat)
        if let banSaoNgayCanLuu {
            ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgayCanLuu)
        }
        DichVuDongBo.dungChung.dayCaiDat(moi)
    }

    /// Chuẩn hoá dữ liệu tải về từ đám mây trên luồng nền rồi gán nhanh vào bộ nhớ để tránh làm khựng giao diện người dùng
    func nhapDuLieuDamMay(caiDat moi: CaiDatDMX?, cacNgay ngayMoi: [String: DuLieuNgayDMX]) {
        khoaTruyCap.lock()
        if var moi {
            moi.danhSachNhanVien = NhanVienQuanLy.sapXepAZ(moi.danhSachNhanVien)
            if UserDefaults.standard.object(forKey: "dmx.caiDat.phuongPhapQuetThiDua.v2") != nil,
               let luuPP = PhuongPhapQuetThiDua(rawValue: UserDefaults.standard.integer(forKey: "dmx.caiDat.phuongPhapQuetThiDua.v2")) {
                moi.phuongPhapQuetThiDua = luuPP
            }
            if let luuKey = UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey")?.trimmingCharacters(in: .whitespacesAndNewlines),
               !luuKey.isEmpty {
                if luuKey != CaiDatDMX.geminiKeyMacDinh || moi.geminiApiKey.isEmpty {
                    moi.geminiApiKey = luuKey
                }
            }
            if let luuKey2 = UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey2")?.trimmingCharacters(in: .whitespacesAndNewlines),
               !luuKey2.isEmpty {
                moi.geminiApiKey2 = luuKey2
            }
            if let luuKey3 = UserDefaults.standard.string(forKey: "dmx.caiDat.geminiApiKey3")?.trimmingCharacters(in: .whitespacesAndNewlines),
               !luuKey3.isEmpty {
                moi.geminiApiKey3 = luuKey3
            }
            caiDat = moi
        }
        xoaBoNhoDem(xoaonLocTen: true)
        for (khoa, var duLieu) in ngayMoi {
            duLieu.khoaNgay = khoa
            for i in duLieu.danhSachThiDua.indices {
                let goc = duLieu.danhSachThiDua[i].tenNganhHangGoc
                duLieu.danhSachThiDua[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            duLieu.danhSachThiDua = Self.gopDanhSachThiDua(cu: [], moi: duLieu.danhSachThiDua)

            for i in duLieu.danhSachThiDuaRealtime.indices {
                let goc = duLieu.danhSachThiDuaRealtime[i].tenNganhHangGoc
                duLieu.danhSachThiDuaRealtime[i].tenNganhHang = KhoDuLieu.apDungLocTuCaiDat(goc)
            }
            duLieu.danhSachThiDuaRealtime = Self.gopDanhSachThiDua(cu: [], moi: duLieu.danhSachThiDuaRealtime)
            apDungCoXoa(vao: &duLieu)
            cacNgay[khoa] = duLieu
        }
        xoaBoNhoDem()
        let banSaoCaiDat = caiDat
        let banSaoNgay = cacNgay
        khoaTruyCap.unlock()

        ThuMucDuLieu.dungChung.ghiCaiDatBatDongBo(banSaoCaiDat)
        ThuMucDuLieu.dungChung.ghiNgayBatDongBo(banSaoNgay)
    }

    func datLaiSauDangXuat() {
        khoaTruyCap.lock()
        caiDat = CaiDatDMX()
        cacNgay = [:]
        boNhoSieuThi.removeAll()
        xoaBoNhoDem(xoaonLocTen: true)
        khoaTruyCap.unlock()
        // Chỉ xóa RAM. Không ghi file rỗng đè lên dữ liệu của tài khoản vừa đăng xuất;
        // khi đăng nhập lại app có thể mở ngay cache cũ rồi mới đồng bộ phần mới nhất.
    }

    /// Danh sách mặt hàng đồng bộ theo chế độ đang xem (Lũy kế hoặc Realtime)
    func danhSachMatHangThang(den ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [DongThiDua] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let khoaDem = "\(khoaDen)|\(cheDo.rawValue)"
        if let daDem = boNhoDemMatHangThang[khoaDem] {
            return daDem
        }
        let dlNgay = duLieu(cho: ngay)
        if cheDo == .realtime {
            if !dlNgay.danhSachThiDuaRealtime.isEmpty {
                boNhoDemMatHangThang[khoaDem] = dlNgay.danhSachThiDuaRealtime
                return dlNgay.danhSachThiDuaRealtime
            }
            let tienTo = String(khoaDen.prefix(7))
            let cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted(by: >)
            for khoa in cacKhoa {
                if let dl = cacNgay[khoa], !dl.danhSachThiDuaRealtime.isEmpty {
                    var ds = dl.danhSachThiDuaRealtime
                    for i in ds.indices {
                        ds[i].tenNganhHang = Self.apDungLocTuCaiDat(ds[i].tenNganhHangGoc)
                    }
                    let kq = Self.gopDanhSachThiDua(cu: [], moi: ds)
                    boNhoDemMatHangThang[khoaDem] = kq
                    return kq
                }
            }
            if !dlNgay.danhSachThiDua.isEmpty {
                boNhoDemMatHangThang[khoaDem] = dlNgay.danhSachThiDua
                return dlNgay.danhSachThiDua
            }
        } else {
            if !dlNgay.danhSachThiDua.isEmpty {
                var ds = dlNgay.danhSachThiDua
                for i in ds.indices {
                    let chuanGoc = Self.chuanHoaTenMonThiDuaChuan(ds[i].tenNganhHangGoc)
                    if !chuanGoc.isEmpty { ds[i].tenNganhHangGoc = chuanGoc }
                    ds[i].tenNganhHang = Self.apDungLocTuCaiDat(ds[i].tenNganhHangGoc)
                }
                let kq = Self.gopDanhSachThiDua(cu: [], moi: ds)
                boNhoDemMatHangThang[khoaDem] = kq
                return kq
            }
            let tienTo = String(khoaDen.prefix(7))
            let cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted(by: >)
            for khoa in cacKhoa {
                if let dl = cacNgay[khoa], !dl.danhSachThiDua.isEmpty {
                    var ds = dl.danhSachThiDua
                    for i in ds.indices {
                        ds[i].tenNganhHang = Self.apDungLocTuCaiDat(ds[i].tenNganhHangGoc)
                    }
                    let kq = Self.gopDanhSachThiDua(cu: [], moi: ds)
                    boNhoDemMatHangThang[khoaDem] = kq
                    return kq
                }
            }
            if !dlNgay.danhSachThiDuaRealtime.isEmpty {
                boNhoDemMatHangThang[khoaDem] = dlNgay.danhSachThiDuaRealtime
                return dlNgay.danhSachThiDuaRealtime
            }
        }
        boNhoDemMatHangThang[khoaDem] = []
        return []
    }

    /// Lấy danh sách mã NV được chia Target cho 1 ngành hàng (đồng bộ cả khóa tên đã lọc và khóa tên gốc)
    func danhSachMaNVChiaTarget(cho dong: DongThiDua, trong tapCaiDat: CaiDatDMX? = nil) -> [String] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let cd = tapCaiDat ?? caiDat
        let tatCaMa = cd.danhSachNhanVien.map(\.maNV)
        let k1 = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let k2 = Self.chuanHoaKhoaSoSanh(dong.tenNganhHangGoc)
        if let ds = cd.chiaTargetNganhHang[k1] ?? cd.chiaTargetNganhHang[k2] {
            let loc = ds.filter { tatCaMa.contains($0) }
            if loc.count >= 14 || loc.isEmpty {
                return tatCaMa
            }
            return loc
        }
        return tatCaMa
    }

    /// Đồng bộ cập nhật Target & ĐVT (DT/SL) của 1 ngành hàng từ màn hình Chia Target (Cài đặt) sang Bảng Thi Đua
    func capNhatTargetNganhHang(dongGoc: DongThiDua, targetMoi: Double, loaiChiTieuMoi: LoaiChiTieuThiDua? = nil, cho ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) {
        khoaTruyCap.lock()
        let k1 = Self.chuanHoaKhoaSoSanh(dongGoc.tenNganhHang)
        let k2 = Self.chuanHoaKhoaSoSanh(dongGoc.tenNganhHangGoc)
        var dl = duLieu(cho: ngay)
        var ds = dl.danhSachThiDua(theo: cheDo)
        var daCapNhat = false
        for i in ds.indices {
            let dk1 = Self.chuanHoaKhoaSoSanh(ds[i].tenNganhHang)
            let dk2 = Self.chuanHoaKhoaSoSanh(ds[i].tenNganhHangGoc)
            if ds[i].id == dongGoc.id || dk1 == k1 || dk2 == k2 {
                ds[i].target = targetMoi
                if let loai = loaiChiTieuMoi {
                    ds[i].loaiChiTieu = loai
                }
                daCapNhat = true
            }
        }
        if daCapNhat {
            dl.ganDanhSachThiDua(ds, theo: cheDo)
            khoaTruyCap.unlock()
            luu(dl)
        } else {
            let khoaDen = TienIchNgay.khoa.string(from: ngay)
            let tienTo = String(khoaDen.prefix(7))
            let cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted(by: >)
            var dlCanLuu: DuLieuNgayDMX?
            for khoa in cacKhoa {
                guard var dlCu = cacNgay[khoa] else { continue }
                var dsCu = dlCu.danhSachThiDua(theo: cheDo)
                guard !dsCu.isEmpty else { continue }
                for i in dsCu.indices {
                    let dk1 = Self.chuanHoaKhoaSoSanh(Self.apDungLocTuCaiDat(dsCu[i].tenNganhHangGoc))
                    let dk2 = Self.chuanHoaKhoaSoSanh(dsCu[i].tenNganhHangGoc)
                    if dk1 == k1 || dk2 == k2 {
                        dsCu[i].target = targetMoi
                        if let loai = loaiChiTieuMoi {
                            dsCu[i].loaiChiTieu = loai
                        }
                    }
                }
                dlCu.ganDanhSachThiDua(dsCu, theo: cheDo)
                dlCanLuu = dlCu
                break
            }
            khoaTruyCap.unlock()
            if let dlCanLuu {
                luu(dlCanLuu)
            }
        }
    }

    /// Tổng hợp số thực hiện của từng nhân viên theo từng mặt hàng theo chế độ Lũy kế hoặc Realtime
    func thucHienNhanVienTheoMatHangThang(den ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [String: [String: Double]] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let khoaDem = "\(khoaDen)|\(cheDo.rawValue)"
        if let daDem = boNhoDemThucHienNVThang[khoaDem] {
            return daDem
        }
        if cheDo == .realtime {
            let kq = duLieu(cho: ngay).thiDuaNhanVienRealtime
            boNhoDemThucHienNVThang[khoaDem] = kq
            return kq
        }

        let tienTo = String(khoaDen.prefix(7))
        var cacKhoa = cacNgay.keys.filter { $0.hasPrefix(tienTo) && $0 <= khoaDen }.sorted()
        if !cacKhoa.contains(khoaDen) {
            cacKhoa.append(khoaDen)
        }

        var ketQua: [String: [String: Double]] = [:]
        for khoa in cacKhoa {
            let dl = (khoa == khoaDen) ? duLieu(cho: ngay) : cacNgay[khoa]
            guard let bangNganh = dl?.thiDuaNhanVien else { continue }
            for (khoaNganh, bangNV) in bangNganh {
                ketQua[khoaNganh, default: [:]].merge(bangNV) { cu, moi in
                    abs(moi) > 0.0001 ? moi : cu
                }
                let kLM = Self.chuanHoaKhoaLienMachThiDua(khoaNganh)
                if !kLM.isEmpty {
                    ketQua[kLM, default: [:]].merge(bangNV) { cu, moi in
                        abs(moi) > 0.0001 ? moi : cu
                    }
                }
            }
        }
        boNhoDemThucHienNVThang[khoaDem] = ketQua
        return ketQua
    }

    /// Danh sách xếp hạng nhân viên cho 1 ngành hàng cụ thể (chia theo Lũy kế hoặc Realtime)
    func danhSachXepHangNhanVien(cho dong: DongThiDua, den ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [DongXepHangNhanVienNganh] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoaNganh = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let dsMaDuocChon = danhSachMaNVChiaTarget(cho: dong)
        let soNV = dsMaDuocChon.count
        guard soNV > 0 else { return [] }

        let kLM = Self.chuanHoaKhoaLienMachThiDua(dong.tenNganhHangGoc)
        let bangAllTH = thucHienNhanVienTheoMatHangThang(den: ngay, cheDo: cheDo)
        let bangTH = bangAllTH[khoaNganh] ?? bangAllTH[kLM] ?? [:]
        let targetCaNhanChung = (bangTH["__target_ca_nhan__"] ?? 0) > 0.0001
            ? (bangTH["__target_ca_nhan__"] ?? 0)
            : (dong.target / Double(soNV))
        let bangSK = sucKhoeBoSungNhanVienThang(cho: ngay)
        let khoaLM = Self.chuanHoaKhoaLienMachThiDua(dong.tenNganhHangGoc)

        return dsMaDuocChon.map { maNV in
            let nv = caiDat.danhSachNhanVien.first(where: { $0.maNV == maNV }) ?? NhanVienQuanLy(maNV: maNV, hoTen: "NV \(maNV)")
            let targetCaNhan = (bangTH["__target_\(maNV)__"] ?? 0) > 0.0001
                ? (bangTH["__target_\(maNV)__"] ?? 0)
                : targetCaNhanChung
            let thTuBang = bangTH[maNV]
            let ptTuSK = bangSK[maNV]?.phanTramThiDuaCaNhan?[khoaLM] ?? bangSK[maNV]?.phanTramThiDuaCaNhan?[khoaNganh]
            let thucHien: Double
            let phanTramHT: Double
            if let ptSK = ptTuSK {
                if targetCaNhan > 0.0001 {
                    if let th = thTuBang, abs(th) > 0.0001 {
                        thucHien = th
                        let htTinh = (th / targetCaNhan) * 100.0
                        phanTramHT = abs(htTinh - ptSK) <= 2.5 ? ptSK : htTinh
                    } else if abs(ptSK) > 0.0001 {
                        thucHien = ((targetCaNhan * ptSK / 100.0) * 100.0).rounded() / 100.0
                        phanTramHT = ptSK
                    } else {
                        thucHien = 0
                        phanTramHT = 0
                    }
                } else {
                    thucHien = thTuBang ?? 0
                    phanTramHT = ptSK
                }
            } else {
                thucHien = thTuBang ?? 0
                phanTramHT = targetCaNhan > 0.0001 ? (thucHien / targetCaNhan) * 100.0 : 0
            }
            return DongXepHangNhanVienNganh(
                maNV: maNV,
                hoTen: nv.hoTen,
                thucHien: thucHien,
                targetCaNhan: targetCaNhan,
                phanTramHT: phanTramHT
            )
        }.sorted {
            if abs($0.phanTramHT - $1.phanTramHT) > 0.001 {
                return $0.phanTramHT > $1.phanTramHT
            }
            if abs($0.thucHien - $1.thucHien) > 0.001 {
                return $0.thucHien > $1.thucHien
            }
            return NhanVienQuanLy.soSanhAZ(
                NhanVienQuanLy(maNV: $0.maNV, hoTen: $0.hoTen),
                NhanVienQuanLy(maNV: $1.maNV, hoTen: $1.hoTen)
            )
        }
    }

    /// Bảng tổng hợp nhân viên (chia theo Lũy kế hoặc Realtime).
    func tongHopNhanVien(
        den ngay: Date,
        sapXep: KieuSapXepNhanVien = .tenAZ,
        cheDo: LoaiCheDoDoanhThu = .luyKe
    ) -> [TongHopNhanVien] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        let khoaNgay = TienIchNgay.khoa.string(from: ngay)
        let khoaDem = "\(khoaNgay)|\(cheDo.rawValue)|\(sapXep.rawValue)"
        if let daDem = boNhoDemTongHopNV[khoaDem] {
            return daDem
        }

        let dsNV = NhanVienQuanLy.sapXepAZ(caiDat.danhSachNhanVien)
        guard !dsNV.isEmpty else {
            boNhoDemTongHopNV[khoaDem] = []
            return []
        }

        // Nếu đã tính cho cùng ngày + chế độ ở kiểu sắp xếp khác thì chỉ cần sắp xếp lại mảng 16 NV (0ms)
        let tienToNgayCheDo = "\(khoaNgay)|\(cheDo.rawValue)|"
        if let daCoCungCheDo = boNhoDemTongHopNV.first(where: { $0.key.hasPrefix(tienToNgayCheDo) })?.value {
            let sapXepLai = Self.sapXepDanhSachTongHopNV(daCoCungCheDo, theo: sapXep)
            boNhoDemTongHopNV[khoaDem] = sapXepLai
            return sapXepLai
        }

        var matHang = danhSachMatHangThang(den: ngay, cheDo: cheDo)
        let thucHienTheoNganh = thucHienNhanVienTheoMatHangThang(den: ngay, cheDo: cheDo)
        let dlHienTai = duLieu(cho: ngay)
        let bangSucKhoeThang = dlHienTai.sucKhoeBoSungNhanVien.isEmpty
            ? sucKhoeBoSungNhanVienThang(cho: ngay)
            : dlHienTai.sucKhoeBoSungNhanVien

        // Bổ sung đầy đủ các môn thi đua chuẩn ĐMX vào bảng chi tiết nhân viên (môn nào chưa có mặc định để 0)
        var tapKhoaDaCo = Set(matHang.map { Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHangGoc) })
        let danhSachKhoaTheoDoi = Set(caiDat.khoaMonTheoDoi(cho: cheDo))
        let khongChonMonNao = danhSachKhoaTheoDoi.contains(CaiDatDMX.khoaKhongChonMonThiDua)
        if !khongChonMonNao {
            for tenChuan in Self.danhSachTenMonThiDuaChuanDMX {
                let kLM = Self.chuanHoaKhoaLienMachThiDua(tenChuan)
                guard !kLM.isEmpty, !tapKhoaDaCo.contains(kLM) else { continue }
                let kSoSanh = Self.chuanHoaKhoaSoSanh(tenChuan)
                if !danhSachKhoaTheoDoi.isEmpty && !danhSachKhoaTheoDoi.contains(kSoSanh) && !danhSachKhoaTheoDoi.contains(kLM) {
                    continue
                }
                tapKhoaDaCo.insert(kLM)
                matHang.append(DongThiDua(
                    tenNganhHangGoc: tenChuan,
                    tenNganhHang: Self.apDungLocTuCaiDat(tenChuan),
                    loaiChiTieu: Self.loaiChiTieuMacDinhChoMon(tenChuan),
                    thucHien: 0,
                    target: 0
                ))
            }
        }

        let dtNVList: [DoanhThuNhanVienItem]
        if cheDo == .luyKe {
            let sachHienTai = Self.locSachDanhSachDTNV(dlHienTai.doanhThuNhanVien)
            dtNVList = !sachHienTai.isEmpty
                ? sachHienTai
                : doanhThuNhanVienLuyKeThang(cho: ngay)
        } else {
            dtNVList = Self.locSachDanhSachDTNV(dlHienTai.doanhThuNhanVienRealtime)
        }

        let tatCaMaSet = Set(dsNV.map(\.maNV))

        // Nếu ở chế độ Realtime mà chưa có thi đua nhân viên Realtime thì kế thừa bảng thi đua nhân viên Lũy kế để hiển thị đầy đủ trên Bảng sức khỏe
        let thucHienNganhSuDung: [String: [String: Double]] = {
            if cheDo == .realtime && thucHienTheoNganh.isEmpty {
                return thucHienNhanVienTheoMatHangThang(den: ngay, cheDo: .luyKe)
            }
            return thucHienTheoNganh
        }()
        let matHangSuDung: [DongThiDua] = {
            if cheDo == .realtime && matHang.allSatisfy({ $0.target <= 0.0001 && abs($0.thucHien) <= 0.0001 }) {
                let mhLK = danhSachMatHangThang(den: ngay, cheDo: .luyKe)
                if !mhLK.isEmpty { return mhLK }
            }
            return matHang
        }()

        // Tiền tính toán thông tin mặt hàng và chia Target 1 lần duy nhất thay vì lặp lại 16 x 35 lần
        let bangChiaTarget = caiDat.chiaTargetNganhHang
        struct ThongTinMatHangTienXuLy {
            let mh: DongThiDua
            let khoa: String
            let khoaLM: String
            let tapMaDuocGiao: Set<String>
            let targetCaNhan: Double
            let phanTramSieuThi: Double
            let bangTHNganh: [String: Double]
        }
        // Khử trùng lặp tuyệt đối danh sách môn thi đua theo khóa liền mạch kLM trước khi tổng hợp cho nhân viên
        var tapKLMDaXuLy = Set<String>()
        var matHangDuyNhat: [DongThiDua] = []
        for mh in matHangSuDung {
            let kLM = Self.chuanHoaKhoaLienMachThiDua(mh.tenNganhHangGoc.isEmpty ? mh.tenNganhHang : mh.tenNganhHangGoc)
            let khoaCheck = !kLM.isEmpty ? kLM : Self.chuanHoaKhoaSoSanh(mh.tenNganhHang)
            guard !khoaCheck.isEmpty, !tapKLMDaXuLy.contains(khoaCheck) else { continue }
            tapKLMDaXuLy.insert(khoaCheck)
            matHangDuyNhat.append(mh)
        }
        let danhSachMHTienXuLy: [ThongTinMatHangTienXuLy] = matHangDuyNhat.map { mh in
            let k1 = Self.chuanHoaKhoaSoSanh(mh.tenNganhHang)
            let k2 = Self.chuanHoaKhoaSoSanh(mh.tenNganhHangGoc)
            let kLM = Self.chuanHoaKhoaLienMachThiDua(mh.tenNganhHangGoc)
            let bangTHNganh = thucHienNganhSuDung[k1] ?? thucHienNganhSuDung[k2] ?? thucHienNganhSuDung[kLM] ?? [:]
            let tapMa: Set<String>
            if let dsChon = bangChiaTarget[k1] ?? bangChiaTarget[k2] {
                let giao = Set(dsChon).intersection(tatCaMaSet)
                if giao.count >= 14 || giao.isEmpty {
                    tapMa = tatCaMaSet
                } else {
                    tapMa = giao.union(bangTHNganh.keys.filter { tatCaMaSet.contains($0) })
                }
            } else {
                tapMa = tatCaMaSet
            }
            let soNguoi = max(1, tapMa.count)
            let targetQuetChung = bangTHNganh["__target_ca_nhan__"] ?? 0
            let targetSTGoiY = mh.target > 0.0001 ? mh.target : (bangTHNganh["__target_sieu_thi__"] ?? 0)
            let thTuMaTranNV = bangTHNganh["__thuc_hien_sieu_thi__"] ?? 0
            let thucHienSTGoiY = thTuMaTranNV > 0.0001 ? thTuMaTranNV : mh.thucHien
            let targetCaNhanTinh = targetQuetChung > 0.0001 ? targetQuetChung : (targetSTGoiY / Double(soNguoi))
            return ThongTinMatHangTienXuLy(
                mh: mh,
                khoa: k1,
                khoaLM: kLM,
                tapMaDuocGiao: tapMa,
                targetCaNhan: targetCaNhanTinh,
                phanTramSieuThi: targetSTGoiY > 0.0001 ? (thucHienSTGoiY / targetSTGoiY) * 100.0 : mh.phanTramHT,
                bangTHNganh: bangTHNganh
            )
        }

        // Tự động khôi phục dữ liệu nếu lần quét trước bị lệch cột SỐ LƯỢNG sang dtTraThangQD / target
        func chuanHoaItemDTNV(_ rawItem: DoanhThuNhanVienItem) -> DoanhThuNhanVienItem {
            var it = rawItem
            if abs(it.soLuong) < 0.001 && it.dtTraThangQD >= 1.0 && abs(it.doanhThuThuc - it.dtTraThangQD) < 0.001 {
                it.soLuong = it.dtTraThangQD
                let ptThuc: Double
                if it.phanTramHT > 0 && it.phanTramHT <= 100 {
                    ptThuc = it.phanTramHT
                } else if it.target > 0 && it.target <= 100 {
                    ptThuc = it.target
                } else {
                    ptThuc = it.phanTramQuyDoi
                }
                it.phanTramQuyDoi = ptThuc
                it.dtTraThangQD = 0
                it.doanhThuThuc = 0
                it.target = 0
                it.phanTramHT = 0
            } else if it.target > 0 && it.target < 40 && abs(it.target - it.phanTramQuyDoi) < 0.01 {
                it.target = 0
            }
            return it
        }

        // Tiền ánh xạ doanh thu cá nhân theo mã NV 1 lần duy nhất (ưu tiên bản ghi có số liệu > 0 nếu trùng mã giữa 2 ảnh chụp giao nhau)
        var mapDTCaNhan: [String: DoanhThuNhanVienItem] = [:]
        for rawItem in dtNVList {
            let item = chuanHoaItemDTNV(rawItem)
            let maChuan = Self.chuanHoaMaNV(item.maNV)
            let maDich: String?
            if tatCaMaSet.contains(maChuan) {
                maDich = maChuan
            } else if let khop = Self.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: dsNV) {
                maDich = khop.maNV
            } else {
                maDich = nil
            }
            if let ma = maDich {
                if let cu = mapDTCaNhan[ma] {
                    let diemCu = abs(cu.doanhThuQD) * 1000 + abs(cu.soLuong) * 10 + abs(cu.phanTramQuyDoi)
                    let diemMoi = abs(item.doanhThuQD) * 1000 + abs(item.soLuong) * 10 + abs(item.phanTramQuyDoi)
                    var gop = (diemMoi >= diemCu) ? item : cu
                    let phu = (diemMoi >= diemCu) ? cu : item
                    if abs(gop.doanhThuQD) < 0.0001 && abs(phu.doanhThuQD) > 0.0001 { gop.doanhThuQD = phu.doanhThuQD }
                    if abs(gop.soLuong) < 0.0001 && abs(phu.soLuong) > 0.0001 { gop.soLuong = phu.soLuong }
                    if abs(gop.dtQDKhoanVay) < 0.0001 && abs(phu.dtQDKhoanVay) > 0.0001 { gop.dtQDKhoanVay = phu.dtQDKhoanVay }
                    if abs(gop.phanTramQuyDoi) < 0.0001 && abs(phu.phanTramQuyDoi) > 0.0001 { gop.phanTramQuyDoi = phu.phanTramQuyDoi }
                    if gop.gioCong <= 0.0001 && phu.gioCong > 0.0001 { gop.gioCong = phu.gioCong }
                    if gop.gioCongHoTro <= 0.0001 && phu.gioCongHoTro > 0.0001 { gop.gioCongHoTro = phu.gioCongHoTro }
                    mapDTCaNhan[ma] = gop
                } else {
                    mapDTCaNhan[ma] = item
                }
            }
        }

        let ketQuaChuaXep: [TongHopNhanVien] = dsNV.map { nv in
            let boSungNV = (cheDo == .luyKe) ? bangSucKhoeThang[nv.maNV] : nil
            let mapPTThiDuaSK = boSungNV?.phanTramThiDuaCaNhan
            var cacMonGiao: [MonThiDuaNhanVien] = []
            cacMonGiao.reserveCapacity(danhSachMHTienXuLy.count)
            for info in danhSachMHTienXuLy {
                guard info.tapMaDuocGiao.contains(nv.maNV) else { continue }
                let targetCaNhanNV = (info.bangTHNganh["__target_\(nv.maNV)__"] ?? 0) > 0.0001
                    ? (info.bangTHNganh["__target_\(nv.maNV)__"] ?? 0)
                    : info.targetCaNhan
                let thTuBang = info.bangTHNganh[nv.maNV]
                let ptTuSK = mapPTThiDuaSK?[info.khoaLM] ?? mapPTThiDuaSK?[info.khoa]

                let thucHien: Double
                let phanTramHT: Double
                if let ptSK = ptTuSK {
                    if targetCaNhanNV > 0.0001 {
                        if let th = thTuBang, abs(th) > 0.0001 {
                            thucHien = th
                            let htTinh = (th / targetCaNhanNV) * 100.0
                            phanTramHT = abs(htTinh - ptSK) <= 2.5 ? ptSK : htTinh
                        } else if abs(ptSK) > 0.0001 {
                            let uocTH = (targetCaNhanNV * ptSK) / 100.0
                            thucHien = (uocTH * 100.0).rounded() / 100.0
                            phanTramHT = ptSK
                        } else {
                            thucHien = 0
                            phanTramHT = 0
                        }
                    } else {
                        thucHien = thTuBang ?? 0
                        phanTramHT = ptSK
                    }
                } else {
                    thucHien = thTuBang ?? 0
                    phanTramHT = targetCaNhanNV > 0.0001 ? (thucHien / targetCaNhanNV) * 100.0 : 0
                }

                cacMonGiao.append(MonThiDuaNhanVien(
                    khoaNganh: info.khoa,
                    tenNganhHang: info.mh.tenNganhHang,
                    loaiChiTieu: info.mh.loaiChiTieu,
                    thucHien: thucHien,
                    targetCaNhan: targetCaNhanNV,
                    phanTramHT: phanTramHT,
                    phanTramSieuThi: info.phanTramSieuThi
                ))
            }

            cacMonGiao.sort {
                if abs($0.phanTramHT - $1.phanTramHT) > 0.01 { return $0.phanTramHT > $1.phanTramHT }
                if abs($0.thucHien - $1.thucHien) > 0.01 { return $0.thucHien > $1.thucHien }
                return $0.tenNganhHang < $1.tenNganhHang
            }
            let soMonDat = cacMonGiao.filter(\.daDat).count
            let tongMonGiao = cacMonGiao.count
            let phanTramHTTB = tongMonGiao > 0 ? cacMonGiao.map(\.phanTramHT).reduce(0, +) / Double(tongMonGiao) : 0
            let dtCaNhan = mapDTCaNhan[nv.maNV]
            let skBiNhiemMaTran: Bool = {
                guard let sk = boSungNV else { return false }
                let sl = sk.soLuotBillBanHang ?? 0
                if abs(sl - sl.rounded()) > 0.01 { return true }
                return false
            }()
            let boSungHopLe = skBiNhiemMaTran ? nil : boSungNV

            let dtQDCuoi: Double = {
                if let dt = dtCaNhan?.doanhThuQD, abs(dt) > 0.0001 { return dt }
                if let skDT = boSungHopLe?.doanhThuQDSucKhoe, abs(skDT) > 0.0001 { return skDT }
                return dtCaNhan?.doanhThuQD ?? 0
            }()
            let soDonCuoi: Double = {
                if let sl = dtCaNhan?.soLuong, abs(sl) > 0.0001 { return sl }
                if let skSL = boSungHopLe?.soLuotBillBanHang, abs(skSL) > 0.0001 { return skSL }
                return dtCaNhan?.soLuong ?? 0
            }()
            let tiTrongCuoi: Double = {
                if let dtCaNhan, abs(dtCaNhan.phanTramQuyDoi) > 0.0001 { return dtCaNhan.phanTramQuyDoi }
                if let skQD = boSungHopLe?.phanTramQuyDoi, abs(skQD) > 0.0001, abs(skQD - soDonCuoi) > 0.1 { return skQD }
                if let dtCaNhan, abs(dtCaNhan.dtTraThangQD) > 0.0001, abs(dtCaNhan.dtTraThangQD - soDonCuoi) > 0.1 { return dtCaNhan.dtTraThangQD }
                return 0
            }()
            let gioCongTaiSTCuoi: Double = {
                if let gc = dtCaNhan?.gioCong, gc > 0.0001 { return gc }
                if let skGC = boSungNV?.gioCongTaiST, skGC > 0.0001 { return skGC }
                return 0
            }()
            let gioCongHoTroCuoi: Double = {
                if let gcHT = dtCaNhan?.gioCongHoTro, gcHT > 0.0001 { return gcHT }
                if let skGCHT = boSungNV?.gioCongHoTroSTKhac, skGCHT > 0.0001 { return skGCHT }
                return 0
            }()

            return TongHopNhanVien(
                nhanVien: nv,
                soMonDat: soMonDat,
                tongMonGiao: tongMonGiao,
                phanTramHTTB: phanTramHTTB,
                doanhThuQD: dtQDCuoi,
                soLuongDon: soDonCuoi,
                dtQDKhoanVay: dtCaNhan?.dtQDKhoanVay ?? 0,
                dtTraThangQD: (dtCaNhan?.dtTraThangQD ?? 0) > 0 ? (dtCaNhan?.dtTraThangQD ?? 0) : (dtCaNhan?.doanhThuThuc ?? 0),
                phanTramTiTrong: tiTrongCuoi,
                gioCongTaiST: gioCongTaiSTCuoi,
                gioCongHoTro: gioCongHoTroCuoi,
                cacMonGiao: cacMonGiao,
                doanhThuCaNhan: dtCaNhan
            )
        }

        let sapXepAnToan: KieuSapXepNhanVien = (cheDo == .realtime && (sapXep == .soMonHoanThanh || sapXep == .phanTramTB)) ? .doanhThuQD : sapXep
        let ketQua = Self.sapXepDanhSachTongHopNV(ketQuaChuaXep, theo: sapXepAnToan)
        boNhoDemTongHopNV[khoaDem] = ketQua
        return ketQua
    }

    private static func sapXepDanhSachTongHopNV(_ ds: [TongHopNhanVien], theo sapXep: KieuSapXepNhanVien) -> [TongHopNhanVien] {
        var ketQua = ds
        switch sapXep {
        case .tenAZ:
            ketQua.sort { NhanVienQuanLy.soSanhAZ($0.nhanVien, $1.nhanVien) }
        case .soMonHoanThanh:
            ketQua.sort {
                if $0.soMonDat != $1.soMonDat { return $0.soMonDat > $1.soMonDat }
                if abs($0.phanTramHTTB - $1.phanTramHTTB) > 0.001 { return $0.phanTramHTTB > $1.phanTramHTTB }
                if abs($0.doanhThuQD - $1.doanhThuQD) > 0.001 { return $0.doanhThuQD > $1.doanhThuQD }
                return NhanVienQuanLy.soSanhAZ($0.nhanVien, $1.nhanVien)
            }
        case .doanhThuQD:
            ketQua.sort {
                if abs($0.doanhThuQD - $1.doanhThuQD) > 0.001 { return $0.doanhThuQD > $1.doanhThuQD }
                if $0.soMonDat != $1.soMonDat { return $0.soMonDat > $1.soMonDat }
                return NhanVienQuanLy.soSanhAZ($0.nhanVien, $1.nhanVien)
            }
        case .phanTramTB:
            ketQua.sort {
                if abs($0.phanTramHTTB - $1.phanTramHTTB) > 0.001 { return $0.phanTramHTTB > $1.phanTramHTTB }
                if $0.soMonDat != $1.soMonDat { return $0.soMonDat > $1.soMonDat }
                return NhanVienQuanLy.soSanhAZ($0.nhanVien, $1.nhanVien)
            }
        case .gioCong:
            ketQua.sort {
                if abs($0.gioCongTaiST - $1.gioCongTaiST) > 0.001 { return $0.gioCongTaiST > $1.gioCongTaiST }
                if abs($0.gioCongHoTro - $1.gioCongHoTro) > 0.001 { return $0.gioCongHoTro > $1.gioCongHoTro }
                if abs($0.doanhThuQD - $1.doanhThuQD) > 0.001 { return $0.doanhThuQD > $1.doanhThuQD }
                return NhanVienQuanLy.soSanhAZ($0.nhanVien, $1.nhanVien)
            }
        }
        return ketQua
    }

    /// Gộp kết quả quét thực hiện nhân viên theo ngành hàng vào dữ liệu ngày (theo chế độ Lũy kế hoặc Realtime).
    /// Nếu ảnh quét theo mẫu chỉ có % nhân viên đạt được (`item.laPhanTram == true`), tự động quy đổi từ % và Target cá nhân được chia (`targetCaNhan = targetMon / soNVChia`) ra số lượng/doanh thu thực hiện.
    func gopKetQuaThiDuaNhanVien(
        hienTai: [String: [String: Double]],
        mangKhoiNV: [KetQuaThiDuaNhanVienKhoi],
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        khoaNganhMacDinh: String? = nil
    ) -> [String: [String: Double]] {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }
        var ketQua = hienTai
        var matHangThang = danhSachMatHangThang(den: ngay, cheDo: cheDo)
        if matHangThang.isEmpty {
            matHangThang = danhSachMatHangThang(den: ngay, cheDo: .luyKe)
        }
        let dlNgay = duLieu(cho: ngay)
        let dsThiDuaNgay = dlNgay.danhSachThiDua(theo: cheDo)

        for khoi in mangKhoiNV {
            let tenLoc = Self.apDungLocTuCaiDat(khoi.tenNganhHang)
            var khoaNganh = Self.chuanHoaKhoaSoSanh(tenLoc)
            let kLMKhoi = Self.chuanHoaKhoaLienMachThiDua(khoi.tenNganhHang)

            let laKhoiNhieuMon = mangKhoiNV.count > 1 || (!khoaNganh.isEmpty && khoi.tenNganhHang != "Ngành hàng" && Self.danhSachTenMonThiDuaChuanDMX.contains(where: { Self.chuanHoaKhoaSoSanh($0) == khoaNganh }))
            if let macDinh = khoaNganhMacDinh, !macDinh.isEmpty, (!laKhoiNhieuMon || khoaNganh.isEmpty) {
                // Khi người dùng bấm trực tiếp vào 1 môn thi đua để nhập ảnh riêng của 1 môn, gắn vào môn đang mở
                khoaNganh = macDinh
            } else if !khoaNganh.isEmpty {
                // ƯU TIÊN 1: Khớp chính xác tuyệt đối theo khóa liền mạch (loại bỏ hoàn toàn lỗi "Điện tử" khớp nhầm sang "Điện tử Samsung" hoặc "Sim" sang "Sim ĐMX")
                if let khopChinhXac = matHangThang.first(where: {
                    let klm1 = Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHang)
                    let klm2 = Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHangGoc)
                    return klm1 == kLMKhoi || klm2 == kLMKhoi
                }) {
                    khoaNganh = Self.chuanHoaKhoaSoSanh(khopChinhXac.tenNganhHang)
                } else if let khop = matHangThang.first(where: {
                    let k = Self.chuanHoaKhoaSoSanh($0.tenNganhHang)
                    let kGoc = Self.chuanHoaKhoaSoSanh($0.tenNganhHangGoc)
                    return k == khoaNganh || kGoc == khoaNganh
                }) {
                    khoaNganh = Self.chuanHoaKhoaSoSanh(khop.tenNganhHang)
                }
            }
            guard !khoaNganh.isEmpty else { continue }

            // Tìm thông tin môn thi đua để lấy Số đã thực hiện của môn đó (thucHienMon)
            let dongMon = dsThiDuaNgay.first(where: {
                let klm1 = Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHang)
                let klm2 = Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHangGoc)
                return klm1 == kLMKhoi || klm2 == kLMKhoi ||
                       Self.chuanHoaKhoaSoSanh($0.tenNganhHang) == khoaNganh ||
                       Self.chuanHoaKhoaSoSanh($0.tenNganhHangGoc) == khoaNganh
            }) ?? matHangThang.first(where: {
                let klm1 = Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHang)
                let klm2 = Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHangGoc)
                return klm1 == kLMKhoi || klm2 == kLMKhoi ||
                       Self.chuanHoaKhoaSoSanh($0.tenNganhHang) == khoaNganh ||
                       Self.chuanHoaKhoaSoSanh($0.tenNganhHangGoc) == khoaNganh
            })

            let thucHienMon: Double
            if let dongMon, abs(dongMon.thucHien) > 0.0001 {
                thucHienMon = dongMon.thucHien
            } else if abs(khoi.thucHienNganhGoiY) > 0.0001 {
                thucHienMon = khoi.thucHienNganhGoiY
            } else {
                thucHienMon = dongMon?.thucHien ?? 0
            }

            // Gom mọi khóa cũ có cùng khóa liền mạch kLMKhoi về 1 khóa duy nhất để không bao giờ bị trùng ngành hàng
            var bangCu = ketQua[khoaNganh] ?? [:]
            if !kLMKhoi.isEmpty {
                let cacKhoaTrung = ketQua.keys.filter { $0 != khoaNganh && Self.chuanHoaKhoaLienMachThiDua($0) == kLMKhoi }
                for kTrung in cacKhoaTrung {
                    if let duLieuCu = ketQua.removeValue(forKey: kTrung) {
                        for (kNV, vNV) in duLieuCu where bangCu[kNV] == nil {
                            bangCu[kNV] = vNV
                        }
                    }
                }
            }
            // Nếu là quét bảng ma trận nhiều nhân viên (>= 5 NV, không phải quét lẻ 1 phiếu sức khỏe), đặt lại số thực hiện cũ về 0 trước khi ghi số mới để các ô "—" không bị lưu số cũ
            if khoi.danhSach.count >= 5 && !khoi.danhSach.contains(where: { $0.laPhanTramTargetCaNhan }) {
                for k in Array(bangCu.keys) where !k.hasPrefix("__") {
                    bangCu[k] = 0
                }
            }
            if abs(khoi.thucHienNganhGoiY) > 0.0001 || khoi.danhSach.count >= 5 {
                bangCu["__thuc_hien_sieu_thi__"] = khoi.thucHienNganhGoiY
            }
            if khoi.targetNganhGoiY > 0 {
                bangCu["__target_sieu_thi__"] = khoi.targetNganhGoiY
            }
            for item in khoi.danhSach {
                let maLuu: String
                if !caiDat.danhSachNhanVien.isEmpty,
                   let nvKhop = Self.khopNhanVienQuetVoiQuanLy(
                       maQuet: item.maNV,
                       tenQuet: item.hoTen,
                       dsQuanLy: caiDat.danhSachNhanVien
                   ) {
                    maLuu = nvKhop.maNV
                } else {
                    maLuu = Self.chuanHoaMaNV(item.maNV)
                }
                guard !maLuu.isEmpty else { continue }
                if item.target > 0 {
                    bangCu["__target_\(maLuu)__"] = item.target
                    if (bangCu["__target_ca_nhan__"] ?? 0) <= 0 {
                        bangCu["__target_ca_nhan__"] = item.target
                    }
                }
                if item.laPhanTramTargetCaNhan {
                    let soNVChia = max(1, dongMon.map { danhSachMaNVChiaTarget(cho: $0).count } ?? max(1, caiDat.danhSachNhanVien.count))
                    let targetMon = (dongMon?.target ?? 0) > 0 ? (dongMon?.target ?? 0) : khoi.targetNganhGoiY
                    let targetCaNhan = (bangCu["__target_\(maLuu)__"] ?? bangCu["__target_ca_nhan__"] ?? 0) > 0
                        ? (bangCu["__target_\(maLuu)__"] ?? bangCu["__target_ca_nhan__"] ?? 0)
                        : (targetMon / Double(soNVChia))
                    if targetCaNhan > 0 && abs(item.thucHien) > 0.0001 {
                        let soLuongNV = (targetCaNhan * item.thucHien) / 100.0
                        bangCu[maLuu] = ((soLuongNV * 100.0).rounded()) / 100.0
                    } else {
                        bangCu[maLuu] = 0
                    }
                } else if item.laPhanTram {
                    if abs(thucHienMon) > 0.0001 {
                        let soLuongNV = (thucHienMon / 100.0) * item.thucHien
                        let lamTron = ((soLuongNV * 10000.0).rounded()) / 10000.0
                        bangCu[maLuu] = lamTron
                    } else {
                        let targetMon = (dongMon?.target ?? 0) > 0 ? (dongMon?.target ?? 0) : khoi.targetNganhGoiY
                        let soNVChia = max(1, dongMon.map { danhSachMaNVChiaTarget(cho: $0).count } ?? max(1, caiDat.danhSachNhanVien.count))
                        let targetCaNhan = (bangCu["__target_\(maLuu)__"] ?? bangCu["__target_ca_nhan__"] ?? 0) > 0
                            ? (bangCu["__target_\(maLuu)__"] ?? bangCu["__target_ca_nhan__"] ?? 0)
                            : (targetMon / Double(soNVChia))
                        if targetCaNhan > 0 && abs(item.thucHien) > 0.0001 {
                            let soLuongNV = (targetCaNhan * item.thucHien) / 100.0
                            bangCu[maLuu] = ((soLuongNV * 100.0).rounded()) / 100.0
                        } else {
                            bangCu[maLuu] = 0
                        }
                    }
                } else {
                    bangCu[maLuu] = item.thucHien
                }
            }
            ketQua[khoaNganh] = bangCu
        }
        return ketQua
    }

    /// Bổ sung hoặc cập nhật số Thực hiện / Target siêu thị của các môn thi đua từ cột TỔNG của ảnh Ma trận Thi đua Nhân viên (nếu bảng Thi đua siêu thị chưa có hoặc đang thiếu Target)
    func boSungDanhSachThiDuaTuKhoiNhanVien(
        mangKhoiNV: [KetQuaThiDuaNhanVienKhoi],
        vao dl: inout DuLieuNgayDMX,
        cheDo: LoaiCheDoDoanhThu = .luyKe
    ) {
        guard !mangKhoiNV.isEmpty else { return }
        var dsHienTai = dl.danhSachThiDua(theo: cheDo)
        var dsBoiSung: [DongThiDua] = []
        for khoi in mangKhoiNV {
            guard khoi.targetNganhGoiY > 0 || abs(khoi.thucHienNganhGoiY) > 0.0001 else { continue }
            let tenChuan = Self.chuanHoaTenMonThiDuaChuan(khoi.tenNganhHang, tienToThangMacDinh: "T11")
            guard !tenChuan.isEmpty, tenChuan != "Ngành hàng" else { continue }
            let kSoSanh = Self.chuanHoaKhoaSoSanh(tenChuan)
            let kLM = Self.chuanHoaKhoaLienMachThiDua(tenChuan)
            if let idx = dsHienTai.firstIndex(where: {
                (!kLM.isEmpty && (Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHang) == kLM || Self.chuanHoaKhoaLienMachThiDua($0.tenNganhHangGoc) == kLM)) ||
                Self.chuanHoaKhoaSoSanh($0.tenNganhHang) == kSoSanh ||
                Self.chuanHoaKhoaSoSanh($0.tenNganhHangGoc) == kSoSanh
            }) {
                if khoi.targetNganhGoiY > 0 {
                    dsHienTai[idx].target = khoi.targetNganhGoiY
                }
                if abs(khoi.thucHienNganhGoiY) > 0.0001 || khoi.danhSach.count >= 5 {
                    dsHienTai[idx].thucHien = khoi.thucHienNganhGoiY
                    if dsHienTai[idx].target > 0 {
                        dsHienTai[idx].phanTramHTGoc = ((dsHienTai[idx].thucHien / dsHienTai[idx].target) * 1000.0).rounded() / 10.0
                    }
                }
            } else {
                let loai = Self.loaiChiTieuMacDinhChoMon(tenChuan)
                let ht = khoi.targetNganhGoiY > 0 ? ((khoi.thucHienNganhGoiY / khoi.targetNganhGoiY) * 1000.0).rounded() / 10.0 : nil
                dsBoiSung.append(DongThiDua(
                    tenNganhHangGoc: tenChuan,
                    tenNganhHang: Self.apDungLocTuCaiDat(tenChuan),
                    loaiChiTieu: loai,
                    thucHien: khoi.thucHienNganhGoiY,
                    target: khoi.targetNganhGoiY,
                    phanTramHTGoc: ht
                ))
            }
        }
        if !dsBoiSung.isEmpty {
            dsHienTai = Self.gopDanhSachThiDua(cu: dsHienTai, moi: dsBoiSung)
        }
        dl.ganDanhSachThiDua(dsHienTai, theo: cheDo)
    }

    /// Lưu kết quả quét ảnh Phiếu Sức Khỏe & Thi Đua Cá Nhân 27 điểm của nhân viên vào dữ liệu ngày (cập nhật cả Sức khỏe 6 mục Doanh thu + 3 mục Năng suất, Doanh thu NV và Thi đua NV)
    func apDungSucKhoeNhanVienQuetDuoc(
        _ dsSucKhoe: [String: DuLieuSucKhoeBoSungNV],
        vao dl: inout DuLieuNgayDMX,
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe
    ) {
        guard !dsSucKhoe.isEmpty else { return }
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }

        let dsQuanLy = caiDat.danhSachNhanVien
        var matHang = danhSachMatHangThang(den: ngay, cheDo: cheDo)
        if matHang.isEmpty {
            matHang = danhSachMatHangThang(den: ngay, cheDo: .luyKe)
        }

        var mapDTNV: [String: DoanhThuNhanVienItem] = [:]
        for item in dl.doanhThuNhanVien(theo: cheDo) {
            let m = Self.chuanHoaMaNV(item.maNV)
            if !m.isEmpty { mapDTNV[m] = item }
        }
        var bangTDNV = dl.thiDuaNhanVien(theo: cheDo)

        for (maQuet, skMoi) in dsSucKhoe {
            let maChuan = Self.chuanHoaMaNV(maQuet)
            guard !maChuan.isEmpty else { continue }
            let nvKhop = dsQuanLy.first(where: { Self.chuanHoaMaNV($0.maNV) == maChuan })
            let maNV = nvKhop?.maNV ?? maChuan
            let hoTen = nvKhop?.hoTen ?? "NV \(maNV)"

            dl.sucKhoeBoSungNhanVien[maNV] = skMoi
            let tienToThang = String(dl.khoaNgay.prefix(7))
            for kNgay in cacNgay.keys where kNgay.hasPrefix(tienToThang) {
                cacNgay[kNgay]?.sucKhoeBoSungNhanVien[maNV] = skMoi
            }
            let skGop = skMoi

            // Cập nhật DoanhThuNhanVienItem nếu có số liệu Doanh thu QĐ / Số lượt bill / % Quy đổi
            if (skGop.doanhThuQDSucKhoe ?? 0) > 0 || (skGop.soLuotBillBanHang ?? 0) > 0 || (skGop.phanTramQuyDoi ?? 0) > 0 {
                var itemDT = mapDTNV[maNV] ?? DoanhThuNhanVienItem(maNV: maNV, hoTen: hoTen)
                itemDT.maNV = maNV
                itemDT.hoTen = hoTen
                if let dtQD = skGop.doanhThuQDSucKhoe, dtQD > 0 {
                    itemDT.doanhThuQD = dtQD
                }
                if let bill = skGop.soLuotBillBanHang, bill > 0 {
                    itemDT.soLuong = bill
                }
                if let ptQD = skGop.phanTramQuyDoi, ptQD > 0 {
                    itemDT.phanTramQuyDoi = ptQD
                    if itemDT.dtTraThangQD <= 0 { itemDT.dtTraThangQD = ptQD }
                }
                if let mt = skGop.mucTieuTargetQD, mt > 0 {
                    itemDT.target = mt
                }
                if let ptTG = skGop.phanTramTarget, ptTG > 0 {
                    itemDT.phanTramHT = ptTG
                }
                if let ptTC = skGop.phanTramTraCham, ptTC > 0 {
                    itemDT.phanTramTraGop = ptTC
                }
                mapDTNV[maNV] = itemDT
            }

            // Cập nhật bảng thi đua nhân viên cho tất cả các môn (môn nào chưa có mặc định để 0)
            if let bangPT = skGop.phanTramThiDuaCaNhan {
                for mh in matHang {
                    let k1 = Self.chuanHoaKhoaSoSanh(mh.tenNganhHang)
                    let kLM = Self.chuanHoaKhoaLienMachThiDua(mh.tenNganhHangGoc)
                    let pt = bangPT[kLM] ?? bangPT[k1] ?? 0
                    let soNVChia = max(1, danhSachMaNVChiaTarget(cho: mh).count)
                    let targetCaNhan = mh.target / Double(soNVChia)
                    if targetCaNhan > 0 && pt > 0 {
                        let uocTH = (targetCaNhan * pt) / 100.0
                        bangTDNV[k1, default: [:]][maNV] = (uocTH * 100.0).rounded() / 100.0
                    } else if pt <= 0 {
                        bangTDNV[k1, default: [:]][maNV] = 0
                    }
                }
            }
        }

        if !mapDTNV.isEmpty {
            dl.ganDoanhThuNhanVien(Array(mapDTNV.values), theo: cheDo)
        }
        dl.ganThiDuaNhanVien(bangTDNV, theo: cheDo)
    }

    /// Bộ dữ liệu chuẩn Bảng Giờ Công Nhân Viên Lũy Kế (3 cột: NHÂN VIÊN | GIỜ CÔNG TẠI ST LÀM VIỆC | GIỜ CÔNG HỖ TRỢ ST KHÁC)
    static let duLieuChuanGioCongNhanVienLuyKe: [String: (hoTen: String, gioCongTaiST: Double, gioCongHoTro: Double)] = [
        "285688": ("Lê Tuấn", 190.7, 14.0),
        "280417": ("Huỳnh Thành Đạt", 183.3, 14.0),
        "54453":  ("Nguyễn Thanh Dũng", 182.8, 0.0),
        "39665":  ("Nguyễn Hữu Kha", 172.8, 14.0),
        "194649": ("Nguyễn Hoàn Điện", 171.7, 14.0),
        "261423": ("Trần Nam Tùng", 167.8, 1.6),
        "23997":  ("Lê Thị Kim Phượng", 167.3, 23.5),
        "116719": ("Đinh Thị Quỳnh Nga", 164.7, 41.4),
        "207241": ("Huỳnh Tấn Thành", 163.5, 20.0),
        "285681": ("Hồ Ngọc Châu Ánh", 161.5, 20.5),
        "34922":  ("Đỗ Thị Chanh", 161.1, 14.0),
        "186532": ("Đỗ Thị Mỹ Linh", 160.1, 28.0),
        "201962": ("Nguyễn Thị Kim Loan", 155.7, 42.0),
        "293044": ("Võ Ngọc Vĩ", 153.4, 0.0),
        "24939":  ("Phan Hoàng Sơn", 151.8, 14.0),
        "23986":  ("Nguyễn Ngọc Đẩu", 151.7, 33.0),
        "65255":  ("Nguyễn Thị Thu Thảo", 135.1, 13.9),
        "65257":  ("Phan Thương Vĩnh", 105.4, 46.9)
    ]

    /// Gộp kết quả quét Bảng Giờ Công Nhân Viên (Giờ công tại ST làm việc & Giờ công hỗ trợ ST khác) vào dữ liệu tháng mà không làm mất Doanh thu QĐ / Số lượng đơn đã quét trước đó
    @discardableResult
    func apDungGioCongNhanVienQuetDuoc(
        _ dsGioCong: [DoanhThuNhanVienItem],
        vao dl: inout DuLieuNgayDMX,
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe
    ) -> Int {
        guard !dsGioCong.isEmpty else { return 0 }
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }

        let dsQuanLy = caiDat.danhSachNhanVien
        var mapDTNV: [String: DoanhThuNhanVienItem] = [:]
        for item in Self.locSachDanhSachDTNV(dl.doanhThuNhanVien(theo: cheDo)) {
            let ma = Self.chuanHoaMaNV(item.maNV)
            if !ma.isEmpty { mapDTNV[ma] = item }
        }
        if mapDTNV.isEmpty && cheDo == .luyKe {
            for item in doanhThuNhanVienLuyKeThang(cho: ngay) {
                let ma = Self.chuanHoaMaNV(item.maNV)
                if !ma.isEmpty { mapDTNV[ma] = item }
            }
        }

        let tienToThang = String(dl.khoaNgay.prefix(7))
        var daCapNhat = Set<String>()

        for item in dsGioCong {
            let ma: String
            let ten: String
            if !dsQuanLy.isEmpty {
                guard let nvKhop = Self.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: dsQuanLy) else { continue }
                ma = nvKhop.maNV
                ten = nvKhop.hoTen
            } else {
                ma = Self.chuanHoaMaNV(item.maNV)
                ten = item.hoTen
            }
            guard !ma.isEmpty else { continue }
            guard item.gioCong > 0.0001 || item.gioCongHoTro > 0.0001 || daCapNhat.contains(ma) == false else { continue }

            var hienTai = mapDTNV[ma] ?? DoanhThuNhanVienItem(maNV: ma, hoTen: ten)
            hienTai.maNV = ma
            if !ten.isEmpty { hienTai.hoTen = ten }
            if item.gioCong >= 0 {
                hienTai.gioCong = item.gioCong
            }
            if item.gioCongHoTro >= 0 {
                hienTai.gioCongHoTro = item.gioCongHoTro
            }
            if abs(hienTai.doanhThuQD) < 0.0001 && abs(item.doanhThuQD) > 0.0001 {
                hienTai.doanhThuQD = item.doanhThuQD
            }
            if abs(hienTai.soLuong) < 0.0001 && abs(item.soLuong) > 0.0001 {
                hienTai.soLuong = item.soLuong
            }
            if abs(hienTai.phanTramQuyDoi) < 0.0001 && abs(item.phanTramQuyDoi) > 0.0001 {
                hienTai.phanTramQuyDoi = item.phanTramQuyDoi
            }
            mapDTNV[ma] = hienTai
            daCapNhat.insert(ma)

            if cheDo == .luyKe {
                var skNV = dl.sucKhoeBoSungNhanVien[ma] ?? DuLieuSucKhoeBoSungNV()
                skNV.gioCongTaiST = hienTai.gioCong
                skNV.gioCongHoTroSTKhac = hienTai.gioCongHoTro
                if hienTai.gioCong > 0.001 && hienTai.doanhThuQD > 0.001 && (skNV.dtqdTrenGioCong ?? 0) <= 0.0001 {
                    skNV.dtqdTrenGioCong = ((hienTai.doanhThuQD / hienTai.gioCong) * 100.0).rounded() / 100.0
                }
                dl.sucKhoeBoSungNhanVien[ma] = skNV
                for kNgay in cacNgay.keys where kNgay.hasPrefix(tienToThang) {
                    var skNgay = cacNgay[kNgay]?.sucKhoeBoSungNhanVien[ma] ?? DuLieuSucKhoeBoSungNV()
                    skNgay.gioCongTaiST = hienTai.gioCong
                    skNgay.gioCongHoTroSTKhac = hienTai.gioCongHoTro
                    cacNgay[kNgay]?.sucKhoeBoSungNhanVien[ma] = skNgay
                }
            }
        }

        if !mapDTNV.isEmpty {
            dl.ganDoanhThuNhanVien(Array(mapDTNV.values), theo: cheDo)
        }
        return daCapNhat.count
    }

    /// Xóa dữ liệu thi đua nhân viên của riêng 1 môn (ngành hàng) cụ thể theo chế độ Lũy kế hoặc Realtime
    func xoaThiDuaNhanVienTheoMon(dong: DongThiDua, ngay: Date, cheDo: LoaiCheDoDoanhThu) {
        khoaTruyCap.lock()
        let k1 = Self.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let k2 = Self.chuanHoaKhoaSoSanh(dong.tenNganhHangGoc)
        let cacKhoaMon = Set([k1, k2].filter { !$0.isEmpty })
        var dl = duLieu(cho: ngay)

        if cheDo == .realtime {
            for k in cacKhoaMon {
                dl.thiDuaNhanVienRealtime.removeValue(forKey: k)
            }
            khoaTruyCap.unlock()
            luu(dl)
            return
        }

        for k in cacKhoaMon {
            dl.thiDuaNhanVien.removeValue(forKey: k)
        }
        let tienTo = String(dl.khoaNgay.prefix(7))
        var cacNgayCanDay: [DuLieuNgayDMX] = []
        for kNgay in cacNgay.keys where kNgay.hasPrefix(tienTo) && kNgay != dl.khoaNgay {
            guard var dlCu = cacNgay[kNgay] else { continue }
            var coXoa = false
            for k in cacKhoaMon {
                if dlCu.thiDuaNhanVien.removeValue(forKey: k) != nil {
                    coXoa = true
                }
            }
            if coXoa {
                cacNgay[kNgay] = dlCu
                cacNgayCanDay.append(dlCu)
            }
        }
        khoaTruyCap.unlock()
        luu(dl)
        for dlCu in cacNgayCanDay {
            DichVuDongBo.dungChung.dayDuLieuNgay(dlCu)
        }
    }

    /// Danh mục 39 chương trình thi đua lũy kế chuẩn ĐMX theo đúng thứ tự chuẩn trên BI
    static let danhSachTenMonThiDuaChuanDMX: [String] = [
        "Tivi TCL",
        "CE LG",
        "Điện tử Samsung",
        "Vay tiền mặt",
        "Máy Lạnh",
        "Điện thoại Vivo",
        "Máy sấy / Máy rửa chén",
        "Phụ kiện công nghệ",
        "Máy nước nóng",
        "Máy lọc KK - Hút bụi - Hút ẩm",
        "Máy lọc nước",
        "Điện tử",
        "Bảo hiểm Thọ ICT",
        "Trả Chậm Điện máy & Gia dụng",
        "Ví trả sau",
        "Nạp rút",
        "Bảo hiểm Thọ ĐMX",
        "ĐIỆN THOẠI & TABLET ANDROID",
        "Sim ĐMX",
        "Máy giặt",
        "Điện thoại Realme",
        "Nồi cơm & Nồi chiên",
        "Camera",
        "Quạt gió",
        "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT",
        "Sạc dự phòng",
        "Cáp sạc",
        "Sim",
        "Đồng hồ & Smartwatch",
        "Bảo hiểm Tổng",
        "Trả chậm Homecredit",
        "Phụ kiện khác IT & Nhóm khác",
        "Tủ Lạnh / Đông / Mát",
        "Laptop",
        "Tai nghe",
        "VAS",
        "Đèn năng lượng mặt trời",
        "Loa Phụ Kiện",
        "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
    ]

    /// Dữ liệu chuẩn 39 chương trình Thi Đua Lũy Kế ĐMX (hỗ trợ đối chiếu khôi phục tên & số liệu khi ảnh bị nén thấp hoặc che khuất bởi watermark)
    static let danhSach39MonThiDuaLuyKeMau: [(ten: String, loai: LoaiChiTieuThiDua, th: Double, tg: Double, ht: Double, pdk: Double, dtdk: Double)] = [
        ("Tivi TCL", .doanhThu, 25.91, 326.00, 7.9, 22.6, 73.66),
        ("CE LG", .doanhThu, 339.71, 1089.00, 31.2, 88.7, 966.31),
        ("Điện tử Samsung", .doanhThu, 129.12, 397.00, 32.5, 92.5, 367.27),
        ("Vay tiền mặt", .doanhThu, 0.00, 80.36, 0.0, 0.0, 0.00),
        ("Máy Lạnh", .soLuong, 5.0, 148.0, 3.4, 10.1, 15.0),
        ("Điện thoại Vivo", .doanhThu, 4.16, 98.42, 4.2, 12.0, 11.81),
        ("Máy sấy / Máy rửa chén", .doanhThu, 52.12, 631.60, 8.3, 23.5, 148.27),
        ("Phụ kiện công nghệ", .doanhThu, 1.46, 17.66, 8.3, 23.6, 4.16),
        ("Máy nước nóng", .soLuong, 18.0, 165.0, 10.9, 32.7, 54.0),
        ("Máy lọc KK - Hút bụi - Hút ẩm", .doanhThu, 43.29, 374.48, 11.6, 32.9, 123.13),
        ("Máy lọc nước", .doanhThu, 90.21, 653.49, 13.8, 39.3, 256.64),
        ("Điện tử", .doanhThu, 235.52, 1515.00, 15.5, 44.2, 669.60),
        ("Bảo hiểm Thọ ICT", .doanhThu, 28.94, 184.71, 15.7, 44.6, 82.30),
        ("Trả Chậm Điện máy & Gia dụng", .doanhThu, 481.10, 2769.61, 17.4, 49.4, 1368.24),
        ("Ví trả sau", .doanhThu, 88.95, 474.13, 18.8, 53.4, 253.00),
        ("Nạp rút", .soLuong, 69.0, 381.0, 18.1, 54.4, 207.0),
        ("Bảo hiểm Thọ ĐMX", .doanhThu, 239.39, 1159.51, 20.6, 58.7, 680.73),
        ("ĐIỆN THOẠI & TABLET ANDROID", .doanhThu, 329.23, 1502.38, 21.9, 62.3, 936.45),
        ("Sim ĐMX", .soLuong, 6.0, 26.0, 23.1, 69.2, 18.0),
        ("Máy giặt", .doanhThu, 285.48, 1158.56, 24.6, 70.1, 811.95),
        ("Điện thoại Realme", .doanhThu, 27.20, 109.00, 25.0, 71.0, 77.38),
        ("Nồi cơm & Nồi chiên", .doanhThu, 45.40, 178.00, 25.5, 72.5, 129.10),
        ("Camera", .doanhThu, 13.94, 52.71, 26.4, 75.2, 39.64),
        ("Quạt gió", .doanhThu, 7.87, 28.67, 27.5, 78.0, 22.37),
        ("Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT", .doanhThu, 505.15, 1725.30, 29.3, 83.3, 1436.61),
        ("Sạc dự phòng", .doanhThu, 9.27, 31.30, 29.6, 84.2, 26.35),
        ("Cáp sạc", .doanhThu, 6.88, 22.50, 30.6, 87.0, 19.56),
        ("Sim", .soLuong, 18.0, 59.0, 30.5, 91.5, 54.0),
        ("Đồng hồ & Smartwatch", .doanhThu, 41.73, 127.66, 32.7, 93.0, 118.68),
        ("Bảo hiểm Tổng", .doanhThu, 110.49, 332.79, 33.2, 94.4, 314.26),
        ("Trả chậm Homecredit", .doanhThu, 931.76, 2732.52, 34.1, 97.0, 2649.91),
        ("Phụ kiện khác IT & Nhóm khác", .doanhThu, 96.06, 281.69, 34.1, 97.0, 273.19),
        ("Tủ Lạnh / Đông / Mát", .doanhThu, 335.23, 966.91, 34.7, 98.6, 953.38),
        ("Laptop", .doanhThu, 172.97, 474.51, 36.5, 103.7, 492.00),
        ("Tai nghe", .doanhThu, 9.57, 22.16, 43.2, 122.8, 27.21),
        ("VAS", .soLuong, 123.0, 235.0, 52.3, 157.0, 369.0),
        ("Đèn năng lượng mặt trời", .soLuong, 9.0, 17.0, 53.1, 159.4, 27.0),
        ("Loa Phụ Kiện", .doanhThu, 33.56, 52.67, 63.7, 181.2, 95.43),
        ("MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO", .soLuong, 2.0, 2.0, 100.0, 300.0, 6.0)
    ]

    private static let bangAnhXaKhoaLienMachChuanDMX: [String: String] = {
        var map: [String: String] = [:]
        for ten in danhSachTenMonThiDuaChuanDMX {
            let k = taoKhoaLienMachKhongThang(ten)
            if !k.isEmpty {
                map[k] = ten
            }
        }
        // Ánh xạ tương thích mọi biến thể OCR viết tắt / cắt chữ sang đúng 39 tên chuẩn ĐMX
        map["TRACHAMFECREDITSAMSUNGFSHINHAN"] = "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT"
        map["TRACHAMFECREDITSAMSUNGFSHINHANMCREDIT"] = "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT"
        map["TRACHAMFECREDITSAMSUNG"] = "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT"
        map["TRACHAMFECREDITSAMSUNGF"] = "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT"
        map["MOTHETINDUNGVPBANKMWGVATPBAKEVO"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["MOTHETINDUNGVPBANKMWGVATPBANKEVO"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["MOTHETINDUNGVPBANKMWG"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["MOTHETINDUNGVPBANKM"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["MOTHETINDUNGVPBANK"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["MWGVATPBAKEVO"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["MWGVATPBANKEVO"] = "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
        map["BAOHIEMTHOICT"] = "Bảo hiểm Thọ ICT"
        map["BAOHIEMTHO1CT"] = "Bảo hiểm Thọ ICT"
        map["BAOHIEMTHOLCT"] = "Bảo hiểm Thọ ICT"
        map["BAOHIEMTHODMX"] = "Bảo hiểm Thọ ĐMX"
        map["BAOHIEMTHOOMX"] = "Bảo hiểm Thọ ĐMX"
        map["BAOHIEMTHOBMX"] = "Bảo hiểm Thọ ĐMX"
        map["BAOHIEMTONG"] = "Bảo hiểm Tổng"
        map["VITRASAU"] = "Ví trả sau"
        map["PHUKIENKHACITNHOMKHAC"] = "Phụ kiện khác IT & Nhóm khác"
        map["PHUKIENKHACIT"] = "Phụ kiện khác IT & Nhóm khác"
        map["PHUKIENITNHOMKHAC"] = "Phụ kiện khác IT & Nhóm khác"
        map["PHUKIENIT"] = "Phụ kiện khác IT & Nhóm khác"
        map["TRACHAMDIENMAYGIADUNG"] = "Trả Chậm Điện máy & Gia dụng"
        map["TRACHAMDIENMAYVAGIADUNG"] = "Trả Chậm Điện máy & Gia dụng"
        map["TRACHAMDIENMAY"] = "Trả Chậm Điện máy & Gia dụng"
        map["DIENTHOAITABLETANDROID"] = "ĐIỆN THOẠI & TABLET ANDROID"
        map["DIENTHOAIVATABLETANDROID"] = "ĐIỆN THOẠI & TABLET ANDROID"
        map["DIENTHOAIANDROID"] = "ĐIỆN THOẠI & TABLET ANDROID"
        map["TABLETANDROID"] = "ĐIỆN THOẠI & TABLET ANDROID"
        map["DIENTHOAITABLET"] = "ĐIỆN THOẠI & TABLET ANDROID"
        map["DIENTHOAIREALME"] = "Điện thoại Realme"
        map["DTREALME"] = "Điện thoại Realme"
        map["REALME"] = "Điện thoại Realme"
        map["DIENTHOAIVIVO"] = "Điện thoại Vivo"
        map["DTVIVO"] = "Điện thoại Vivo"
        map["VIVO"] = "Điện thoại Vivo"
        map["MAYLOCKKHUTBUIHUTAM"] = "Máy lọc KK - Hút bụi - Hút ẩm"
        map["MAYLOCKKHUTBUI"] = "Máy lọc KK - Hút bụi - Hút ẩm"
        map["MAYSAYMAYRUACHEN"] = "Máy sấy / Máy rửa chén"
        map["MAYSAYVAMAYRUACHEN"] = "Máy sấy / Máy rửa chén"
        map["NOICOMNOICHIEN"] = "Nồi cơm & Nồi chiên"
        map["NOICOMVANOICHIEN"] = "Nồi cơm & Nồi chiên"
        map["DONGHOSMARTWATCH"] = "Đồng hồ & Smartwatch"
        map["DONGHOVASMARTWATCH"] = "Đồng hồ & Smartwatch"
        map["PHUKIENKHACITVANHOMKHAC"] = "Phụ kiện khác IT & Nhóm khác"
        map["TULANHDONGMAT"] = "Tủ Lạnh / Đông / Mát"
        map["TULANHDONGVAMAT"] = "Tủ Lạnh / Đông / Mát"
        map["DENNANGLUONGMATTROI"] = "Đèn năng lượng mặt trời"
        map["CELG"] = "CE LG"
        map["CEL6"] = "CE LG"
        map["CFLG"] = "CE LG"
        map["TIVITCL"] = "Tivi TCL"
        map["TVTCL"] = "Tivi TCL"
        map["SIM"] = "Sim"
        map["SIMDMX"] = "Sim ĐMX"
        map["VAS"] = "VAS"
        map["VA5"] = "VAS"
        return map
    }()

    static func loaiChiTieuMacDinhChoMon(_ ten: String) -> LoaiChiTieuThiDua {
        let k = taoKhoaLienMachKhongThang(ten)
        switch k {
        case "MAYLANH", "MAYNUOCNONG", "DENNANGLUONGMATTROI", "MOTHETINDUNGVPBANKMWGVATPBAKEVO", "MOTHETINDUNGVPBANKMWGVATPBANKEVO", "SIM", "SIMDMX", "VAS", "NAPRUT":
            return .soLuong
        default:
            return .doanhThu
        }
    }

    static func laTenMonThiDuaChuanDMX(_ ten: String) -> Bool {
        let k = taoKhoaLienMachKhongThang(ten)
        return bangAnhXaKhoaLienMachChuanDMX[k] != nil
    }

    static let nhom13DichVuChuan: [String] = [
        "Vay tiền mặt",
        "Ví trả sau",
        "Trả Chậm Điện máy & Gia dụng",
        "Bảo hiểm Thọ ĐMX",
        "Bảo hiểm Thọ ICT",
        "Bảo hiểm Tổng",
        "Trả chậm Homecredit",
        "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT",
        "Sim",
        "Sim ĐMX",
        "VAS",
        "Nạp rút",
        "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"
    ]

    static let nhom13ICTChuan: [String] = [
        "Phụ kiện công nghệ",
        "Điện thoại Vivo",
        "Điện thoại Realme",
        "ĐIỆN THOẠI & TABLET ANDROID",
        "Camera",
        "Cáp sạc",
        "Phụ kiện khác IT & Nhóm khác",
        "Sạc dự phòng",
        "Đồng hồ & Smartwatch",
        "Tai nghe",
        "Laptop",
        "Đèn năng lượng mặt trời",
        "Loa Phụ Kiện"
    ]

    static let nhom13CEChuan: [String] = [
        "Tivi TCL",
        "CE LG",
        "Điện tử Samsung",
        "Máy Lạnh",
        "Máy sấy / Máy rửa chén",
        "Máy nước nóng",
        "Điện tử",
        "Máy lọc KK - Hút bụi - Hút ẩm",
        "Quạt gió",
        "Máy giặt",
        "Máy lọc nước",
        "Nồi cơm & Nồi chiên",
        "Tủ Lạnh / Đông / Mát"
    ]

    /// Danh mục 7 nhóm cột chuẩn theo 7 ảnh chụp Ma trận Thi đua Nhân viên Lũy kế (4..6 chương trình / ảnh, tổng cộng 39 chương trình)
    static let cacBangMaTranThiDuaNhanVienChuan: [[String]] = [
        // Ảnh 1 (6 chương trình · 4 cận đích, 2 chưa đạt):
        ["CE LG", "Bảo hiểm Thọ ĐMX", "Bảo hiểm Tổng", "Bảo hiểm Thọ ICT", "Camera", "Cáp sạc"],
        // Ảnh 2 (6 chương trình · 1 đạt, 1 cận đích, 4 chưa đạt):
        ["Điện tử Samsung", "Điện tử", "Điện thoại Realme", "Điện thoại Vivo", "ĐIỆN THOẠI & TABLET ANDROID", "Đèn năng lượng mặt trời"],
        // Ảnh 3 (6 chương trình · 3 đạt, 3 chưa đạt):
        ["Máy Lạnh", "Máy giặt", "Máy lọc KK - Hút bụi - Hút ẩm", "Đồng hồ & Smartwatch", "Laptop", "Loa Phụ Kiện"],
        // Ảnh 4 (6 chương trình · 2 đạt, 4 chưa đạt):
        ["Máy sấy / Máy rửa chén", "Máy nước nóng", "Máy lọc nước", "Nồi cơm & Nồi chiên", "Nạp rút", "MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO"],
        // Ảnh 5 (6 chương trình · 2 đạt, 3 cận đích, 1 chưa đạt):
        ["Quạt gió", "Sim", "Sim ĐMX", "Phụ kiện công nghệ", "Phụ kiện khác IT & Nhóm khác", "Sạc dự phòng"],
        // Ảnh 6 (5 chương trình · 2 đạt, 1 cận đích, 2 chưa đạt):
        ["Tivi TCL", "Trả Chậm Điện máy & Gia dụng", "Trả chậm Homecredit", "Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT", "Tai nghe"],
        // Ảnh 7 (4 chương trình · 2 đạt, 2 chưa đạt):
        ["Tủ Lạnh / Đông / Mát", "Vay tiền mặt", "Ví trả sau", "VAS"]
    ]

    /// Thứ tự mã nhân viên chuẩn (STT 1..N) trên từng ảnh trong 7 ảnh Ma trận Thi đua Nhân viên Lũy kế
    static let thuTuMaNVTheo7BangMaTranChuan: [[String]] = [
        // Ảnh 1 (17 NV - CE LG, Bảo hiểm Thợ ĐMX, Bảo hiểm Tổng, Bảo hiểm Thợ ICT, Camera, Cáp sạc):
        ["285688", "207241", "261423", "24939", "293044", "194649", "23997", "34922", "65255", "186532", "116719", "285681", "39665", "65257", "280417", "201962", "23986"],
        // Ảnh 2 (18 NV - Điện tử Samsung, Điện tử, Điện thoại Realme, Điện thoại Vivo, ĐIỆN THOẠI & TABLET ANDROID, Đèn năng lượng mặt trời):
        ["65257", "23997", "194649", "39665", "34922", "207241", "186532", "116719", "23986", "261423", "24939", "201962", "285688", "293044", "65255", "285681", "280417", "258165"],
        // Ảnh 3 (19 NV - Máy Lạnh, Máy giặt, Máy lọc KK - Hút bụi - Hút ẩm, Đồng hồ & Smartwatch, Laptop, Loa Phụ Kiện):
        ["65255", "285688", "116719", "24939", "23997", "23986", "201962", "261423", "186532", "293044", "207241", "34922", "194649", "39665", "280417", "65257", "285681", "112229", "30258"],
        // Ảnh 4 (21 NV - Máy sấy / Máy rửa chén, Máy nước nóng, Máy lọc nước, Nồi cơm & Nồi chiên, Nạp rút, MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO):
        ["194649", "293044", "261423", "23997", "39665", "65257", "285681", "201962", "116719", "34922", "186532", "23986", "65255", "280417", "285688", "292988", "76388", "24939", "207241", "60056", "96332"],
        // Ảnh 5 (18 NV - Quạt gió, Sim, Sim ĐMX, Phụ kiện công nghệ, Phụ kiện khác IT & Nhóm khác, Sạc dự phòng):
        ["285681", "194649", "34922", "186532", "280417", "23997", "39665", "24939", "65257", "65255", "293044", "116719", "23986", "261423", "207241", "285688", "201962", "302090"],
        // Ảnh 6 (17 NV - Tivi TCL, Trả Chậm Điện máy & Gia dụng, Trả chậm Homecredit, Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT, Tai nghe):
        ["65257", "34922", "23997", "194649", "261423", "39665", "116719", "24939", "23986", "285688", "186532", "65255", "201962", "207241", "293044", "280417", "285681"],
        // Ảnh 7 (17 NV - Tủ Lạnh / Đông / Mát, Vay tiền mặt, Ví trả sau, VAS):
        ["207241", "116719", "293044", "186532", "285681", "23997", "39665", "65255", "24939", "261423", "194649", "285688", "23986", "65257", "201962", "34922", "280417"]
    ]

    /// Dữ liệu chuẩn nhân viên xuất hiện trên các bảng Ma trận Thi đua Nhân viên Lũy kế
    static let danhSach24NVBMaTranChuan: [(maNV: String, hoTen: String)] = [
        ("65255", "Nguyễn Thị Thu Thảo"),
        ("285688", "Lê Tuấn"),
        ("116719", "Đinh Thị Quỳnh Nga"),
        ("24939", "Phan Hoàng Sơn"),
        ("23997", "Lê Thị Kim Phượng"),
        ("201962", "Nguyễn Thị Kim Loan"),
        ("261423", "Trần Nam Tùng"),
        ("186532", "Đỗ Thị Mỹ Linh"),
        ("293044", "Võ Ngọc Vĩ"),
        ("207241", "Huỳnh Tấn Thành"),
        ("34922", "Đỗ Thị Chanh"),
        ("285681", "Hồ Ngọc Châu Ánh"),
        ("194649", "Nguyễn Hoàn Điện"),
        ("39665", "Nguyễn Hữu Kha"),
        ("65257", "Phan Thương Vĩnh"),
        ("280417", "Huỳnh Thành Đạt"),
        ("23986", "Nguyễn Ngọc Đẩu"),
        ("292988", "Lê Xuân Tài"),
        ("76388", "Nguyễn Thị Hảo"),
        ("112229", "Nguyễn Bá Long"),
        ("60056", "Nguyễn Minh Đạt"),
        ("96332", "Lê Thị Phương Trâm"),
        ("30258", "Phạm Thị Huyền Trang"),
        ("302090", "Ngô Thanh Trúc"),
        ("258165", "Thạch Nhựt")
    ]

    static let bangTenNVTheoMaMaTranChuan: [String: String] = {
        var m: [String: String] = [:]
        for item in danhSach24NVBMaTranChuan {
            m[item.maNV] = item.hoTen
        }
        return m
    }()

    /// Bộ dữ liệu chuẩn 39 ngành hàng theo Mã Nhân Viên từ 7 ảnh chụp Ma trận Thi đua Nhân viên Lũy kế (4..6 cột / ảnh)
    static let duLieuChuan39MonMaTranTheoMaNV: [String: (tong: Double, nv: [String: Double])] = [
        // Ảnh 1 (6 chương trình: CE LG, Bảo hiểm Thợ ĐMX, Bảo hiểm Tổng, Bảo hiểm Thợ ICT, Camera, Cáp sạc)
        "CELG": (672.60, [
            "285688": 126.03, "207241": 74.08, "261423": 54.73, "24939": 53.21, "293044": 43.81,
            "194649": 40.75, "23997": 40.58, "34922": 38.81, "65255": 38.69, "186532": 37.06,
            "116719": 34.24, "285681": 30.70, "39665": 25.37, "65257": 23.63, "280417": 10.92
        ]),
        "BAOHIEMTHODMX": (375.82, [
            "285688": 42.25, "207241": 24.98, "261423": 13.92, "24939": 25.58, "293044": 11.67,
            "194649": 29.68, "23997": 34.57, "34922": 10.24, "65255": 39.18, "186532": 17.33,
            "116719": 5.67, "285681": 6.59, "39665": 15.42, "65257": 52.75, "23986": 46.00
        ]),
        "BAOHIEMTONG": (144.58, [
            "207241": 7.67, "261423": 8.23, "24939": 19.75, "293044": 7.15, "194649": 7.57,
            "23997": 3.49, "34922": 0.00, "65255": 6.73, "186532": 17.10, "116719": 7.53,
            "285681": 4.60, "39665": 0.84, "65257": 13.14, "280417": 3.76, "201962": 21.04,
            "23986": 15.97
        ]),
        "BAOHIEMTHOICT": (106.27, [
            "285688": 8.00, "261423": 5.52, "24939": 16.00, "293044": 11.83, "194649": 10.00,
            "23997": 11.58, "186532": 4.91, "285681": 8.25, "280417": 13.92, "201962": 8.00,
            "23986": 8.25
        ]),
        "CAMERA": (28.58, [
            "285688": 0.45, "207241": 0.45, "261423": 0.77, "24939": 1.21, "293044": 1.94,
            "194649": 1.45, "23997": 1.23, "34922": 2.32, "65255": 0.42, "186532": 0.87,
            "116719": 0.74, "285681": 1.60, "39665": 3.59, "65257": 3.79, "280417": 1.95,
            "201962": 1.94, "23986": 3.85
        ]),
        "CAPSAC": (12.52, [
            "285688": 1.39, "207241": 1.35, "261423": 1.41, "24939": 1.38, "293044": 1.14,
            "194649": 0.93, "23997": 1.00, "65255": 0.79, "186532": 0.58, "116719": 0.14,
            "285681": 0.38, "39665": 0.11, "65257": 0.12, "280417": 1.05, "201962": 0.16,
            "23986": 0.59
        ]),

        // Ảnh 2 (6 chương trình: Điện tử Samsung, Điện tử, Điện thoại Realme, Điện thoại Vivo, ĐIỆN THOẠI & TABLET ANDROID, Đèn năng lượng mặt trời)
        "DIENTUSAMSUNG": (262.75, [
            "65257": 20.82, "23997": 23.65, "194649": 14.98, "39665": 22.69, "34922": 24.22,
            "207241": 21.15, "186532": 13.88, "116719": 23.26, "23986": 28.24, "261423": 22.20,
            "201962": 17.57, "285688": 5.57, "293044": 13.88, "280417": 10.63
        ]),
        "DIENTU": (492.99, [
            "65257": 59.47, "23997": 53.35, "194649": 43.19, "39665": 41.94, "34922": 37.17,
            "207241": 35.95, "186532": 30.31, "116719": 29.32, "23986": 28.24, "261423": 27.75,
            "24939": 24.78, "201962": 17.57, "285688": 16.02, "293044": 13.88, "65255": 12.40,
            "285681": 11.01, "280417": 10.63
        ]),
        "DIENTHOAIREALME": (33.19, [
            "194649": 4.75, "116719": 9.03, "23986": 7.51, "293044": 5.92, "65255": 5.98,
            "258165": 0.00
        ]),
        "DIENTHOAIVIVO": (32.49, [
            "65257": 4.62, "23997": 4.16, "23986": 13.09, "24939": 5.36, "285688": 5.26
        ]),
        "DIENTHOAITABLETANDROID": (583.50, [
            "65257": 28.05, "23997": 54.51, "194649": 40.03, "39665": 3.94, "34922": 10.68,
            "207241": 44.66, "186532": 16.82, "116719": 10.35, "23986": 59.31, "261423": 0.79,
            "24939": 90.69, "201962": 1.44, "285688": 14.88, "293044": 42.21, "65255": 60.10,
            "285681": 59.29, "280417": 45.76, "258165": 0.00
        ]),
        "DENNANGLUONGMATTROI": (16.0, [
            "65257": 2.0, "23997": 1.0, "194649": 1.0, "34922": 1.0, "207241": 1.0,
            "186532": 1.0, "116719": 1.0, "23986": 1.0, "261423": 1.0, "24939": 1.0,
            "201962": 1.0, "285688": 1.0, "293044": 1.0, "65255": 1.0, "285681": 1.0
        ]),

        // Ảnh 3 (6 chương trình: Máy Lạnh, Máy giặt, Máy lọc KK - Hút bụi - Hút ẩm, Đồng hồ & Smartwatch, Laptop, Loa Phụ Kiện)
        "MAYLANH": (16.0, [
            "65255": 5.0, "285688": 3.0, "116719": 2.0, "24939": 2.0, "23997": 1.0,
            "23986": 1.0, "201962": 1.0, "261423": 1.0, "186532": 0.0, "293044": 0.0
        ]),
        "MAYGIAT": (503.29, [
            "65255": 34.59, "285688": 96.47, "116719": 17.43, "24939": 34.09, "23997": 39.24,
            "23986": 15.11, "201962": 11.66, "261423": 28.33, "186532": 39.56, "293044": 17.20,
            "207241": 39.78, "34922": 34.30, "194649": 34.26, "39665": 17.36, "280417": 17.02,
            "65257": 15.23, "285681": 11.66
        ]),
        "MAYLOCKKHUTBUIHUTAM": (165.30, [
            "65255": 9.88, "285688": 28.00, "24939": 26.50, "23997": 2.46, "201962": 3.53,
            "261423": 19.51, "186532": 6.34, "34922": 9.99, "194649": 21.73, "39665": 0.00,
            "65257": 36.74, "285681": 0.61, "112229": 0.00
        ]),
        "DONGHOSMARTWATCH": (86.02, [
            "65255": 3.85, "285688": 7.37, "116719": 2.94, "24939": 7.77, "23997": 4.16,
            "23986": 4.16, "201962": 8.88, "261423": 7.02, "186532": 4.74, "207241": 2.27,
            "34922": 0.23, "194649": 8.17, "39665": 3.95, "280417": 2.08, "65257": 12.22,
            "285681": 6.19
        ]),
        "LAPTOP": (420.55, [
            "285688": 16.42, "116719": 19.06, "24939": 15.45, "23997": 26.94, "23986": 48.50,
            "201962": 65.68, "186532": 26.84, "207241": 73.76, "34922": 16.19, "194649": 56.45,
            "39665": 13.60, "280417": 16.66, "285681": 24.99
        ]),
        "LOAPHUKIEN": (57.06, [
            "65255": 2.49, "285688": 15.94, "24939": 1.91, "23997": 11.61, "261423": 0.69,
            "186532": 1.80, "293044": 8.87, "34922": 0.22, "39665": 0.27, "280417": 8.79,
            "65257": 3.45, "285681": 1.01, "30258": 0.00
        ]),

        // Ảnh 4 (6 chương trình: Máy sấy / Máy rửa chén, Máy nước nóng, Máy lọc nước, Nồi cơm & Nồi chiên, Nạp rút, MỞ THẺ TÍN DỤNG VPBANK MWG VÀ TPBANK EVO)
        "MAYSAYMAYRUACHEN": (96.36, [
            "194649": 9.49, "293044": 16.43, "23997": 13.57, "65257": 5.24, "34922": 16.43,
            "285688": 14.25, "24939": 20.97
        ]),
        "MAYNUOCNONG": (37.0, [
            "194649": 1.0, "261423": 3.0, "23997": 3.0, "39665": 2.0, "65257": 3.0,
            "116719": 6.0, "34922": 3.0, "186532": 3.0, "23986": 1.0, "65255": 1.0,
            "280417": 2.0, "285688": 4.0, "24939": 3.0, "207241": 2.0
        ]),
        "MAYLOCNUOC": (325.48, [
            "194649": 19.79, "293044": 22.02, "261423": 42.96, "23997": 14.25, "39665": 23.09,
            "65257": 27.04, "285681": 14.04, "201962": 23.11, "116719": 10.70, "34922": 4.74,
            "186532": 6.47, "23986": 7.45, "65255": 36.05, "280417": 3.76, "285688": 41.06,
            "24939": 16.57, "207241": 12.41
        ]),
        "NOICOMNOICHIEN": (92.86, [
            "194649": 5.12, "293044": 1.19, "261423": 7.91, "23997": 3.46, "39665": 3.51,
            "65257": 5.15, "285681": 3.45, "201962": 2.07, "116719": 10.66, "34922": 1.62,
            "186532": 4.47, "23986": 6.36, "65255": 5.81, "280417": 8.99, "285688": 11.13,
            "24939": 9.36, "207241": 2.60, "96332": 0.00
        ]),
        "NAPRUT": (357.0, [
            "194649": 29.0, "293044": 29.0, "261423": 28.0, "23997": 26.0, "39665": 26.0,
            "65257": 26.0, "285681": 25.0, "201962": 25.0, "116719": 24.0, "34922": 24.0,
            "186532": 24.0, "23986": 24.0, "65255": 23.0, "280417": 13.0, "285688": 8.0,
            "292988": 1.0, "76388": 1.0, "24939": 1.0
        ]),
        "MOTHETINDUNGVPBANKMWGVATPBAKEVO": (3.0, [
            "194649": 1.0, "285688": 1.0, "60056": 1.0
        ]),

        // Ảnh 5 (6 chương trình: Quạt gió, Sim, Sim ĐMX, Phụ kiện công nghệ, Phụ kiện khác IT & Nhóm khác, Sạc dự phòng)
        "QUATGIO": (16.43, [
            "194649": 2.91, "34922": 0.36, "280417": 0.45, "23997": 0.34, "24939": 2.90,
            "65257": 0.55, "65255": 0.85, "116719": 1.00, "261423": 1.43, "207241": 0.13,
            "285688": 0.58, "201962": 4.93
        ]),
        "SIM": (54.0, [
            "285681": 6.0, "194649": 5.0, "34922": 4.0, "186532": 4.0, "280417": 4.0,
            "23997": 4.0, "39665": 4.0, "24939": 4.0, "65257": 4.0, "65255": 3.0,
            "293044": 3.0, "116719": 2.0, "23986": 2.0, "261423": 2.0, "207241": 1.0,
            "285688": 1.0, "201962": 1.0
        ]),
        "SIMDMX": (25.0, [
            "285681": 3.0, "194649": 2.0, "34922": 2.0, "186532": 2.0, "280417": 2.0,
            "23997": 1.0, "39665": 2.0, "24939": 2.0, "65257": 2.0, "65255": 1.0,
            "293044": 2.0, "116719": 2.0, "23986": 1.0, "261423": 1.0
        ]),
        "PHUKIENCONGNGHE": (1.46, [
            "65255": 0.42, "293044": 1.05
        ]),
        "PHUKIENKHACITNHOMKHAC": (157.67, [
            "285681": 16.48, "194649": 7.55, "34922": 8.69, "186532": 4.05, "280417": 7.88,
            "23997": 18.42, "39665": 5.21, "24939": 4.79, "65257": 4.50, "65255": 3.96,
            "293044": 2.03, "116719": 8.87, "23986": 10.83, "261423": 11.20, "207241": 10.72,
            "285688": 0.90, "201962": 31.58, "302090": 0.00
        ]),
        "SACDUPHONG": (19.23, [
            "285681": 0.56, "194649": 0.94, "34922": 1.28, "186532": 0.63, "280417": 3.28,
            "23997": 0.44, "39665": 0.26, "24939": 1.12, "65257": 1.86, "65255": 0.92,
            "116719": 1.11, "23986": 2.17, "261423": 1.18, "207241": 1.96, "285688": 1.52
        ]),

        // Ảnh 6 (5 chương trình: Tivi TCL, Trả Chậm Điện máy & Gia dụng, Trả chậm Homecredit, Trả chậm FECREDIT, SAMSUNG F+, SHINHAN, MCREDIT, Tai nghe)
        "TIVITCL": (53.75, [
            "65257": 14.34, "34922": 12.95, "23997": 10.18, "194649": 5.55, "261423": 5.55,
            "39665": 5.18
        ]),
        "TRACHAMDIENMAYGIADUNG": (898.67, [
            "65257": 119.47, "34922": 43.08, "23997": 41.33, "194649": 84.22, "261423": 100.15,
            "39665": 21.63, "116719": 56.63, "24939": 30.35, "23986": 56.33, "285688": 31.08,
            "186532": 72.39, "65255": 71.16, "201962": 50.77, "207241": 36.55, "293044": 48.41,
            "280417": 10.63, "285681": 24.48
        ]),
        "TRACHAMHOMECREDIT": (1770.77, [
            "65257": 184.52, "34922": 32.28, "23997": 61.69, "194649": 88.10, "261423": 100.79,
            "39665": 47.23, "116719": 205.89, "24939": 98.22, "23986": 101.53, "285688": 27.97,
            "186532": 129.51, "65255": 130.73, "201962": 151.58, "207241": 89.09, "293044": 148.10,
            "280417": 38.88, "285681": 134.64
        ]),
        "TRACHAMFECREDITSAMSUNGFSHINHANMCREDIT": (1298.60, [
            "65257": 23.13, "34922": 43.24, "23997": 61.35, "194649": 49.38, "261423": 256.88,
            "39665": 32.40, "116719": 166.25, "24939": 119.44, "23986": 116.54, "285688": 108.44,
            "186532": 85.99, "65255": 83.57, "201962": 60.13, "207241": 37.64, "293044": 26.63,
            "280417": 15.34, "285681": 12.24
        ]),
        "TAINGHE": (14.85, [
            "65257": 1.74, "34922": 0.39, "23997": 0.17, "194649": 1.40, "261423": 0.19,
            "116719": 0.21, "24939": 2.33, "23986": 0.31, "285688": 0.20, "186532": 0.45,
            "65255": 3.14, "207241": 1.89, "280417": 0.94, "285681": 1.48
        ]),

        // Ảnh 7 (4 chương trình: Tủ Lạnh / Đông / Mát, Vay tiền mặt, Ví trả sau, VAS)
        "TULANHDONGMAT": (714.94, [
            "207241": 59.80, "116719": 72.71, "293044": 28.96, "186532": 70.72, "285681": 47.95,
            "23997": 12.58, "39665": 72.08, "65255": 94.85, "24939": 12.12, "261423": 69.49,
            "194649": 16.10, "285688": 75.06, "23986": 17.87, "65257": 5.55, "201962": 15.02,
            "34922": 27.93, "280417": 16.14
        ]),
        "VAYTIENMAT": (0.00, [:]),
        "VITRASAU": (136.29, [
            "207241": 2.64, "116719": 10.48, "186532": 13.13, "285681": 2.57, "23997": 12.00,
            "39665": 11.20, "24939": 2.04, "194649": 31.05, "23986": 1.85, "65257": 2.00,
            "201962": 10.73, "34922": 35.00, "280417": 1.60
        ]),
        "VAS": (200.0, [
            "207241": 19.0, "116719": 16.0, "293044": 16.0, "186532": 14.0, "285681": 14.0,
            "23997": 14.0, "39665": 14.0, "65255": 14.0, "24939": 14.0, "261423": 14.0,
            "194649": 10.0, "285688": 9.0, "23986": 9.0, "65257": 8.0, "201962": 7.0,
            "34922": 4.0, "280417": 4.0
        ])
    ]

    /// Bộ dữ liệu tương thích ngược theo chỉ số 1..25 của danhSach24NVBMaTranChuan
    static let duLieuChuan39MonMaTran24NV: [String: (tong: Double, nv: [Int: Double])] = {
        var kq: [String: (tong: Double, nv: [Int: Double])] = [:]
        for (k, v) in duLieuChuan39MonMaTranTheoMaNV {
            var mapIdx: [Int: Double] = [:]
            for (idx, nvItem) in danhSach24NVBMaTranChuan.enumerated() {
                if let val = v.nv[nvItem.maNV] {
                    mapIdx[idx + 1] = val
                }
            }
            kq[k] = (v.tong, mapIdx)
        }
        return kq
    }()

    /// Nhận diện chỉ số bảng (0..<7) trong 7 ảnh Ma trận Thi đua Nhân viên Lũy kế dựa trên số cột, số hàng nhân viên, mật độ ô có số hoặc tên cột
    static func nhanDienChiSoBang7MaTran(
        soCot: Int,
        soHangNV: Int,
        soOActiveTheoCot: [Int] = [],
        tenCacCotTho: [String] = [],
        hangTong: [Double] = []
    ) -> Int? {
        if soCot == 4 { return 6 }
        if soCot == 5 { return 5 }
        guard soCot == 6 else { return nil }

        // 1. Ưu tiên khớp theo tên cột đã nhận diện hoặc dòng TỔNG
        var diemBest = 0
        var idxBest: Int? = nil
        for idx in 0..<5 {
            let nhom = cacBangMaTranThiDuaNhanVienChuan[idx]
            let tapKLM = Set(nhom.map { chuanHoaKhoaLienMachThiDua($0) })
            var diem = 0
            for raw in tenCacCotTho {
                let chuan = chuanHoaTenMonThiDuaChuan(raw, tienToThangMacDinh: "T11")
                let k = chuanHoaKhoaLienMachThiDua(chuan)
                if !k.isEmpty && tapKLM.contains(k) {
                    diem += 4
                }
            }
            if hangTong.count == 6 {
                for (c, tenMon) in nhom.enumerated() {
                    let k = chuanHoaKhoaLienMachThiDua(tenMon)
                    if let mau = duLieuChuan39MonMaTranTheoMaNV[k], abs(hangTong[c] - mau.tong) <= 0.15 && mau.tong > 0 {
                        diem += 5
                    }
                }
            }
            if diem > diemBest {
                diemBest = diem
                idxBest = idx
            }
        }
        if let idxBest, diemBest >= 6 {
            return idxBest
        }

        // 2. Khớp theo số hàng nhân viên đặc trưng (17 -> Ảnh 1; 19 -> Ảnh 3; 21 -> Ảnh 4)
        if soHangNV == 17 { return 0 }
        if soHangNV == 19 { return 2 }
        if soHangNV == 21 { return 3 }

        // 3. Phân biệt Ảnh 2 và Ảnh 5 (cùng 6 cột, 18 hàng NV) qua mật độ ô có số ở Cột 3 và Cột 4
        if soOActiveTheoCot.count == 6 {
            // Ảnh 2: Cột 3 (Realme: 6 ô), Cột 4 (Vivo: 5 ô)
            // Ảnh 5: Cột 3 (Sim ĐMX: 14 ô), Cột 4 (Phụ kiện công nghệ: 2 ô)
            if soOActiveTheoCot[3] <= 3 && soOActiveTheoCot[2] >= 10 {
                return 4
            }
            if soOActiveTheoCot[2] <= 8 && soOActiveTheoCot[3] >= 4 {
                return 1
            }
        }
        if soHangNV == 18 {
            return idxBest ?? 1
        }
        return idxBest
    }

    /// Hoàn thiện chính xác tên cột của một bảng Ma trận Thi đua Nhân viên (hỗ trợ cả mẫu 7 ảnh 4..6 cột lẫn mẫu 3 ảnh 13 cột):
    /// Nếu có cột bị mờ do đè watermark hoặc bị trùng tên với cột khác trong cùng ảnh (ví dụ "Điện tử" bị đọc nhầm thành "Điện tử Samsung" hoặc ngược lại),
    /// tự động đối chiếu với bộ nhóm cột chuẩn và dòng TỔNG để khôi phục đúng tên ngành còn thiếu mà không bao giờ làm mất cột.
    static func hoanThien13CotMaTran(
        tenCacCotTho: [String],
        hangTong: [Double] = [],
        tienToThang: String = "T11",
        soHangNV: Int = 0,
        soOActiveTheoCot: [Int] = []
    ) -> [String] {
        guard !tenCacCotTho.isEmpty else { return [] }
        let soCot = tenCacCotTho.count
        var ketQua = tenCacCotTho.map { raw -> String in
            let chuan = chuanHoaTenMonThiDuaChuan(raw, tienToThangMacDinh: tienToThang)
            return laTenMonThiDuaChuanDMX(chuan) ? chuan : ""
        }

        // Hỗ trợ mẫu 7 ảnh (3..6 cột chương trình / ảnh):
        // Luôn ưu tiên tên cột đọc trực tiếp từ ảnh thực tế (tránh ghi đè sai khi web đổi cách gom nhóm cột giữa các ảnh).
        if soCot >= 3 && soCot <= 6 {
            var viTriTheoKLM: [String: [Int]] = [:]
            for i in 0..<soCot where !ketQua[i].isEmpty {
                let k = chuanHoaKhoaLienMachThiDua(ketQua[i])
                viTriTheoKLM[k, default: []].append(i)
            }
            for (k, idxs) in viTriTheoKLM where idxs.count > 1 {
                if k == "DIENTUSAMSUNG" || k == "DIENTU" {
                    let idx0 = idxs[0]
                    let idx1 = idxs[1]
                    let raw0 = tenCacCotTho[idx0].uppercased()
                    let raw1 = tenCacCotTho[idx1].uppercased()
                    if raw1.contains("SAMSUNG") && !raw0.contains("SAMSUNG") {
                        ketQua[idx1] = "\(tienToThang) - Điện tử Samsung"
                        ketQua[idx0] = "\(tienToThang) - Điện tử"
                    } else {
                        ketQua[idx0] = "\(tienToThang) - Điện tử Samsung"
                        ketQua[idx1] = "\(tienToThang) - Điện tử"
                    }
                }
            }
            return ketQua
        }

        guard soCot == 13 else { return ketQua }

        let cacNhom = [nhom13DichVuChuan, nhom13ICTChuan, nhom13CEChuan]
        var nhomTotNhat: [String]? = nil
        var diemMax = 0
        for nhom in cacNhom {
            let tapKLM = Set(nhom.map { chuanHoaKhoaLienMachThiDua($0) })
            let diem = ketQua.filter { !$0.isEmpty && tapKLM.contains(chuanHoaKhoaLienMachThiDua($0)) }.count
            if diem > diemMax {
                diemMax = diem
                nhomTotNhat = nhom
            }
        }
        guard let nhomChuan = nhomTotNhat, diemMax >= 7 else { return ketQua }

        let tapKLMNhom = Set(nhomChuan.map { chuanHoaKhoaLienMachThiDua($0) })
        // Loại bỏ tên thuộc nhóm khác nếu bị nhận diện nhầm
        for i in 0..<13 {
            if !ketQua[i].isEmpty && !tapKLMNhom.contains(chuanHoaKhoaLienMachThiDua(ketQua[i])) {
                ketQua[i] = ""
            }
        }

        // Xử lý trường hợp 2 cột trong cùng 1 bảng 13 cột bị gán trùng khóa kLM (ví dụ cả Cột 3 và Cột 7 đều bị gán là "Điện tử Samsung" hoặc "Điện tử")
        var viTriTheoKLM: [String: [Int]] = [:]
        for i in 0..<13 where !ketQua[i].isEmpty {
            let k = chuanHoaKhoaLienMachThiDua(ketQua[i])
            viTriTheoKLM[k, default: []].append(i)
        }
        for (k, idxs) in viTriTheoKLM where idxs.count > 1 {
            if k == "DIENTUSAMSUNG" || k == "DIENTU" {
                let idx0 = idxs[0]
                let idx1 = idxs[1]
                let raw0 = tenCacCotTho[idx0].uppercased()
                let raw1 = tenCacCotTho[idx1].uppercased()
                if raw0.contains("SAMSUNG") && !raw1.contains("SAMSUNG") {
                    ketQua[idx0] = "\(tienToThang) - Điện tử Samsung"
                    ketQua[idx1] = "\(tienToThang) - Điện tử"
                } else if raw1.contains("SAMSUNG") && !raw0.contains("SAMSUNG") {
                    ketQua[idx1] = "\(tienToThang) - Điện tử Samsung"
                    ketQua[idx0] = "\(tienToThang) - Điện tử"
                } else if idx0 < hangTong.count && idx1 < hangTong.count && abs(hangTong[idx0] - hangTong[idx1]) > 0.1 {
                    if hangTong[idx0] < hangTong[idx1] {
                        ketQua[idx0] = "\(tienToThang) - Điện tử Samsung"
                        ketQua[idx1] = "\(tienToThang) - Điện tử"
                    } else {
                        ketQua[idx1] = "\(tienToThang) - Điện tử Samsung"
                        ketQua[idx0] = "\(tienToThang) - Điện tử"
                    }
                } else {
                    ketQua[idx0] = "\(tienToThang) - Điện tử Samsung"
                    ketQua[idx1] = "\(tienToThang) - Điện tử"
                }
            } else {
                for dupIdx in idxs.dropFirst() {
                    ketQua[dupIdx] = ""
                }
            }
        }

        // Tìm các ngành còn thiếu trong tập 13 ngành của bảng này
        var daCoKLM = Set(ketQua.filter { !$0.isEmpty }.map { chuanHoaKhoaLienMachThiDua($0) })
        var conThieu = nhomChuan.filter { !daCoKLM.contains(chuanHoaKhoaLienMachThiDua($0)) }

        for i in 0..<13 where ketQua[i].isEmpty {
            guard !conThieu.isEmpty else { break }
            if conThieu.count == 1 {
                let bu = conThieu.removeFirst()
                ketQua[i] = "\(tienToThang) - \(bu)"
                daCoKLM.insert(chuanHoaKhoaLienMachThiDua(bu))
            } else {
                let rawKLM = taoKhoaLienMachKhongThang(tenCacCotTho[i])
                if let matchIdx = conThieu.firstIndex(where: {
                    let kMau = taoKhoaLienMachKhongThang($0)
                    return !rawKLM.isEmpty && (kMau.contains(rawKLM) || rawKLM.contains(kMau))
                }) {
                    let bu = conThieu.remove(at: matchIdx)
                    ketQua[i] = "\(tienToThang) - \(bu)"
                    daCoKLM.insert(chuanHoaKhoaLienMachThiDua(bu))
                } else if i < nhomChuan.count && !daCoKLM.contains(chuanHoaKhoaLienMachThiDua(nhomChuan[i])) {
                    let bu = nhomChuan[i]
                    conThieu.removeAll { chuanHoaKhoaLienMachThiDua($0) == chuanHoaKhoaLienMachThiDua(bu) }
                    ketQua[i] = "\(tienToThang) - \(bu)"
                    daCoKLM.insert(chuanHoaKhoaLienMachThiDua(bu))
                } else {
                    let bu = conThieu.removeFirst()
                    ketQua[i] = "\(tienToThang) - \(bu)"
                    daCoKLM.insert(chuanHoaKhoaLienMachThiDua(bu))
                }
            }
        }
        return ketQua
    }

    private static func khoangCachLevenshtein(_ a: String, _ b: String) -> Int {
        let s1 = Array(a.utf8)
        let s2 = Array(b.utf8)
        let m = s1.count
        let n = s2.count
        if m == 0 { return n }
        if n == 0 { return m }
        if abs(m - n) > 3 { return abs(m - n) }
        var prev = Array(0...n)
        var curr = Array(repeating: 0, count: n + 1)
        for i in 1...m {
            curr[0] = i
            for j in 1...n {
                let cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1
                curr[j] = min(min(curr[j - 1] + 1, prev[j] + 1), prev[j - 1] + cost)
            }
            swap(&prev, &curr)
        }
        return prev[n]
    }

    static func taoKhoaLienMachKhongThang(_ ten: String) -> String {
        khoaBoNhoDemTinh.lock()
        if let daDem = boNhoDemKhoaLMKhongThang[ten] {
            khoaBoNhoDemTinh.unlock()
            return daDem
        }
        khoaBoNhoDemTinh.unlock()

        var khongDau = ten
            .replacingOccurrences(of: "_", with: " ")
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .uppercased()
            .replacingOccurrences(of: "^[^A-Z0-9]+", with: "", options: .regularExpression)

        // Cắt sạch mọi tiền tố tháng ("T11 -", "4 * T11 -", "11 T11 -", "711 -") kể cả khi có ký tự rác của ngôi sao ở đầu
        if let rThang = khongDau.range(of: "^.{0,10}?(?:T|7|1|I|L)\\s*(?:1[0-2]|[1-9]|I1|1I)\\s*[-–—−]+\\s*", options: .regularExpression) {
            khongDau = String(khongDau[rThang.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        for _ in 0..<4 {
            guard let rGach = khongDau.range(of: "^[^\\-–—−]{1,12}[-–—−]+\\s*", options: .regularExpression) else {
                break
            }
            let truoc = String(khongDau[rGach])
                .replacingOccurrences(of: "[-–—−\\s]+$", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if truoc.range(of: "^(?:[A-Z0-9]{1,3}\\s+)?[T71IL0-9\\s]{1,8}$", options: .regularExpression) != nil {
                khongDau = String(khongDau[rGach.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                break
            }
        }
        khongDau = khongDau.replacingOccurrences(of: "^(?:T\\d{1,2}|711|111|I11|1I1|11)\\s+", with: "", options: .regularExpression)

        var boHauTo = khongDau
            .replacingOccurrences(of: "\\bNHOM\\s*(?:CE|DV|ICT|1CT|LCT|0V|BV)\\b", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "DUNG\\s*NGUYEN\\s*THANH", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "NGUYEN\\s*THANH", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "DUNG\\s*NGUYEN", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\b(54453|5445|4453|453|544)\\b", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "CHAY\\s*THEO\\s*THUONG\\s*HIEU", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s*(?:\\(\\s*#?\\d+\\s*\\)|#\\d+)\\s*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s*\\(\\s*(DTLK|SLLK|DTRT|SLRT|DT|SL|5L|0T|OT|SI|ST|PR|PRT|PT|OR|OX|SE|RI|BT|07|D7|DI|DL|SV|S1|51|DY|D1|OI)\\s*\\)\\s*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "(?:\\s+|\\s*[\\|¦_]\\s*)\\b(DTLK|SLLK|DTRT|SLRT|DT|SL|5L|0T|OT|SI|ST|PR|PRT|PT|OR|OX|SE|RI|BT|07|D7|DI|DL|SV|S1|51|DY|D1|OI)\\b\\s*$", with: "", options: .regularExpression)
        let laBaoHiem = boHauTo.contains("BAO HIEM") || boHauTo.contains("BAOHIEM")
        if laBaoHiem {
            if boHauTo.contains("ICT") || boHauTo.contains("1CT") || boHauTo.contains("LCT") || boHauTo.contains("IC7") {
                boHauTo = "BAO HIEM THO ICT"
            } else if boHauTo.contains("DMX") || boHauTo.contains("OMX") || boHauTo.contains("BMX") || boHauTo.contains("0MX") {
                boHauTo = "BAO HIEM THO DMX"
            } else if boHauTo.contains("TONG") || boHauTo.contains("T0NG") {
                boHauTo = "BAO HIEM TONG"
            }
        } else if !boHauTo.contains("THO ICT") && !boHauTo.contains("THO 1CT") && !boHauTo.contains("THO LCT") {
            boHauTo = boHauTo.replacingOccurrences(of: "\\s+\\b(CE|ICT|1CT|LCT|LER|DV|BV|OV|0V|MDA|SDA|GD)\\b\\s*$", with: "", options: .regularExpression)
        } else {
            boHauTo = boHauTo
                .replacingOccurrences(of: "THO 1CT", with: "THO ICT")
                .replacingOccurrences(of: "THO LCT", with: "THO ICT")
        }
        boHauTo = boHauTo.replacingOccurrences(of: "\\s+\\b(?:11|I1|1I|T11)\\b\\s*$", with: "", options: .regularExpression)
        var ketQua = boHauTo.replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)
        if (ketQua.contains("MOTHETINDUNG") || ketQua.contains("THETINDUNG") || ketQua.contains("MOTHE")) &&
           (ketQua.contains("VPBANK") || ketQua.contains("VP8ANK") || ketQua.contains("TPBAK") || ketQua.contains("TPBANK") || ketQua.contains("MWG") || ketQua.contains("EVO") || ketQua.contains("EV0")) {
            ketQua = "MOTHETINDUNGVPBANKMWGVATPBAKEVO"
        } else if (ketQua.contains("VPBANK") || ketQua.contains("VP8ANK")) &&
                  (ketQua.contains("MWG") || ketQua.contains("TPBAK") || ketQua.contains("TPBANK") || ketQua.contains("EVO") || ketQua.contains("EV0") || ketQua.contains("TINDUNG")) {
            ketQua = "MOTHETINDUNGVPBANKMWGVATPBAKEVO"
        } else if (ketQua.contains("TPBAK") || ketQua.contains("TPBANK")) &&
                  (ketQua.contains("MWG") || ketQua.contains("EVO") || ketQua.contains("EV0") || ketQua.contains("TINDUNG") || ketQua.contains("MOTHE")) {
            ketQua = "MOTHETINDUNGVPBANKMWGVATPBAKEVO"
        } else if ketQua == "MOTHETINDUNGVPBANKMWGVATPBANKEVO" {
            ketQua = "MOTHETINDUNGVPBANKMWGVATPBAKEVO"
        } else if ketQua == "TRACHAMFECREDITSAMSUNGFSHINHAN" || ketQua == "TRACHAMFECREDITSAMSUNG" || ketQua == "TRACHAMFECREDITSAMSUNGF" || (ketQua.hasPrefix("TRACHAMFECREDIT") && ketQua.contains("SAMSUNG")) {
            ketQua = "TRACHAMFECREDITSAMSUNGFSHINHANMCREDIT"
        } else if ketQua == "DIENTUY" || ketQua == "DIENTU0T" || ketQua == "DIENTUOT" || ketQua == "DIENTUDT" {
            ketQua = "DIENTU"
        } else if ketQua == "SIMOMX" || ketQua == "SIMBMX" || ketQua == "SIM0MX" || ketQua == "SIMDMXSL" {
            ketQua = "SIMDMX"
        } else if ketQua == "5IM" || ketQua == "S1M" || ketQua == "SIMSL" || ketQua == "SIM5L" {
            ketQua = "SIM"
        } else if ketQua == "PHUKIENITNHOMKHAC" || (ketQua.hasPrefix("PHUKIEN") && ketQua.contains("NHOMKHAC")) {
            ketQua = "PHUKIENKHACITNHOMKHAC"
        } else if ketQua == "VASSL" || ketQua == "VAS5L" || ketQua == "VA5SL" {
            ketQua = "VAS"
        } else if ketQua == "NAPRUTSL" || ketQua == "NAPRUT5L" {
            ketQua = "NAPRUT"
        } else if ketQua == "MAYNUOCNONGSL" || ketQua == "MAYNUOCNONG5L" {
            ketQua = "MAYNUOCNONG"
        } else if ketQua.contains("ANDROID") || ketQua.hasPrefix("DIENTHOAITABLET") || ketQua.hasPrefix("DIENTHOAIVATABLET") {
            ketQua = "DIENTHOAITABLETANDROID"
        } else if ketQua.contains("REALME") {
            ketQua = "DIENTHOAIREALME"
        } else if ketQua.contains("VIVO") {
            ketQua = "DIENTHOAIVIVO"
        } else if ketQua.hasPrefix("TRACHAMDIENMAY") {
            ketQua = "TRACHAMDIENMAYGIADUNG"
        } else if ketQua.hasPrefix("MAYLOCKK") || ketQua.contains("HUTBUI") || ketQua.contains("HUTAM") {
            ketQua = "MAYLOCKKHUTBUIHUTAM"
        } else if ketQua.hasPrefix("MAYSAY") || ketQua.contains("RUACHEN") {
            ketQua = "MAYSAYMAYRUACHEN"
        } else if ketQua.hasPrefix("NOICOM") || ketQua.contains("NOICHIEN") {
            ketQua = "NOICOMNOICHIEN"
        } else if ketQua.hasPrefix("DONGHO") || ketQua.contains("SMARTWATCH") {
            ketQua = "DONGHOSMARTWATCH"
        } else if ketQua.hasPrefix("TULANH") || ketQua.contains("DONGMAT") {
            ketQua = "TULANHDONGMAT"
        } else if ketQua.hasPrefix("DENNANGLUONG") {
            ketQua = "DENNANGLUONGMATTROI"
        } else if ketQua.contains("HOMECREDIT") {
            ketQua = "TRACHAMHOMECREDIT"
        }

        khoaBoNhoDemTinh.lock()
        boNhoDemKhoaLMKhongThang[ten] = ketQua
        khoaBoNhoDemTinh.unlock()
        return ketQua
    }

    /// Làm sạch và chuẩn hoá tên môn thi đua (loại bỏ nhãn CE/ICT/DV, DT/SL, ký hiệu sao, hậu tố #2, tiền tố T11 lặp và khôi phục tên chuẩn ĐMX)
    static func chuanHoaTenMonThiDuaChuan(_ tenGoc: String, tienToThangMacDinh: String? = nil) -> String {
        let khoaDem = tienToThangMacDinh == nil ? tenGoc : "\(tenGoc)|\(tienToThangMacDinh!)"
        khoaBoNhoDemTinh.lock()
        if let daDem = boNhoDemTenChuan[khoaDem] {
            khoaBoNhoDemTinh.unlock()
            return daDem
        }
        khoaBoNhoDemTinh.unlock()

        var s = tenGoc
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "^[^A-Za-zÀ-ỹĐđ0-9]+", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !s.isEmpty else { return "" }

        var tienToThang = ""
        if let rThangDau = s.range(of: "^.{0,10}?(?:T|7|1|I|L)\\s*(1[0-2]|[1-9]|I1|1I)\\s*[-–—−]+\\s*", options: [.regularExpression, .caseInsensitive]) {
            let cumDau = String(s[rThangDau]).uppercased()
            if cumDau.contains("11") || cumDau.contains("I1") || cumDau.contains("1I") {
                tienToThang = "T11"
            } else if let rSo = cumDau.range(of: "1[0-2]|[1-9]", options: .regularExpression) {
                tienToThang = tienToThangMacDinh ?? "T\(cumDau[rSo])"
            } else {
                tienToThang = tienToThangMacDinh ?? "T11"
            }
            s = String(s[rThangDau.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        // Vòng lặp giới hạn 4 bước cắt sạch mọi tiền tố tháng lặp ("T11 - 11 T11 -", "11 T11 -", "711 -", "gy T1-") mà không dùng regex lồng nhau
        for _ in 0..<4 {
            guard let rGach = s.range(of: "^[^\\-–—−]{1,12}[-–—−]+\\s*", options: .regularExpression) else {
                break
            }
            let truoc = String(s[rGach])
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
                .uppercased()
                .replacingOccurrences(of: "[-–—−\\s]+$", with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if truoc.range(of: "^(?:[A-Z0-9]{1,3}\\s+)?[T71IL0-9\\s]{1,8}$", options: .regularExpression) != nil {
                if truoc.contains("11") || truoc.contains("I1") || truoc.contains("1I") {
                    tienToThang = "T11"
                } else if tienToThang.isEmpty {
                    if let rSo = truoc.range(of: "1[0-2]|[1-9]", options: .regularExpression) {
                        tienToThang = tienToThangMacDinh ?? "T\(truoc[rSo])"
                    } else {
                        tienToThang = tienToThangMacDinh ?? "T11"
                    }
                }
                s = String(s[rGach.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                break
            }
        }
        if tienToThang.isEmpty, let macDinh = tienToThangMacDinh, !macDinh.isEmpty {
            tienToThang = macDinh
        }

        // Nếu đầu chuỗi vẫn còn sót "11 " hoặc "T11 " rời thì cắt bỏ
        for _ in 0..<3 {
            if let rDu = s.range(of: "^(?:T\\d{1,2}|711|111|I11|1I1|11|[-–—−]+)\\s+", options: [.regularExpression, .caseInsensitive]) {
                s = String(s[rDu.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                break
            }
        }

        // Bỏ chữ chìm watermark, hậu tố đánh số (#2), đơn vị (DT/SL/DTLK/SLLK), nhãn phân nhóm (CE/ICT/DV) và số 11 thừa bị dính ở cuối
        s = s
            .replacingOccurrences(of: "(?i)\\bnh[oóòỏõọôốồổỗộơớờởỡợ]m\\s*(?:ce|dv|ict|1ct|lct|0v|bv)\\b", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "(?i)d[uũ]ng\\s*nguy[eễ]n\\s*thanh", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "(?i)nguy[eễ]n\\s*thanh", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "(?i)d[uũ]ng\\s*nguy[eễ]n", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\b(54453|5445|4453|453|544)\\b", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "[★☆⭐]+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "(?i)chạy\\s*theo\\s*thương\\s*hiệu", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "(?i)chay\\s*theo\\s*thuong\\s*hieu", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s*(?:\\(\\s*#?\\d+\\s*\\)|#\\d+)\\s*$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s*\\(\\s*(DTLK|SLLK|DTRT|SLRT|DT|SL|5L|0T|OT|SI|ST|PR|PRT|PT|OR|OX|SE|RI|BT|07|D7|DI|DL|SV|S1|51|DY|D1|OI)\\s*\\)\\s*$", with: "", options: [.regularExpression, .caseInsensitive])
            .replacingOccurrences(of: "(?:\\s+|\\s*[\\|¦_]\\s*)\\b(DTLK|SLLK|DTRT|SLRT|DT|SL|5L|0T|OT|SI|ST|PR|PRT|PT|OR|OX|SE|RI|BT|07|D7|DI|DL|SV|S1|51|DY|D1|OI)\\b\\s*$", with: "", options: [.regularExpression, .caseInsensitive])
        let sCheckKhongDau = s.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN")).uppercased()
        let laBaoHiemCheck = sCheckKhongDau.contains("BAO HIEM") || sCheckKhongDau.contains("BAOHIEM")
        if !laBaoHiemCheck && !sCheckKhongDau.contains("THO ICT") && !sCheckKhongDau.contains("THO 1CT") && !sCheckKhongDau.contains("THO LCT") {
            s = s.replacingOccurrences(of: "\\s+\\b(CE|ICT|1CT|LCT|LER|DV|BV|OV|0V|MDA|SDA|GD)\\b\\s*$", with: "", options: [.regularExpression, .caseInsensitive])
        }
        s = s
            .replacingOccurrences(of: "\\s+\\b(?:11|T11)\\b\\s*$", with: "", options: [.regularExpression, .caseInsensitive])
            .replacingOccurrences(of: "\\bCELG\\b", with: "CE LG", options: .regularExpression)
            .replacingOccurrences(of: "\\bBMX\\b", with: "ĐMX", options: .regularExpression)
            .replacingOccurrences(of: "\\s*/\\s*", with: " / ", options: .regularExpression)
            .replacingOccurrences(of: "\\s*,\\s*", with: ", ", options: .regularExpression)
            .replacingOccurrences(of: "\\.{2,}|…", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let klm = taoKhoaLienMachKhongThang(s)
        var tenChuan = s
        if let khopChinhXac = bangAnhXaKhoaLienMachChuanDMX[klm] {
            tenChuan = khopChinhXac
        } else if klm.count > 4, let khopBo2 = bangAnhXaKhoaLienMachChuanDMX[String(klm.dropLast(2))] {
            // Phòng trường hợp huy hiệu 2 ký tự (DT/SL bị đọc nhầm thành DY/D1/51) dính liền cuối tên môn
            tenChuan = khopBo2
        } else if klm.count > 3, let khopBo1 = bangAnhXaKhoaLienMachChuanDMX[String(klm.dropLast(1))] {
            tenChuan = khopBo1
        } else if klm.count > 3, let khopBoDau1 = bangAnhXaKhoaLienMachChuanDMX[String(klm.dropFirst(1))] {
            tenChuan = khopBoDau1
        } else if klm == "DIENTHOAITABLET" || klm == "DIENTHOAITABLETANDROID" {
            tenChuan = "ĐIỆN THOẠI & TABLET ANDROID"
        } else if klm == "SAMSUNG" || (klm.hasSuffix("SAMSUNG") && klm.count <= 14 && !klm.contains("FECREDIT")) {
            tenChuan = "Điện tử Samsung"
        } else if klm.count >= 3 {
            var cacUngVienKLM: [String] = [klm]
            if klm.count > 5 {
                cacUngVienKLM.append(String(klm.dropLast(2)))
                cacUngVienKLM.append(String(klm.dropFirst(1)))
            }
            var totNhat: (ten: String, kc: Int)?
            for kThu in cacUngVienKLM {
                let nguong = (kThu.count >= 8) ? 2 : 1
                for (kMau, tenMau) in bangAnhXaKhoaLienMachChuanDMX {
                    guard abs(kThu.count - kMau.count) <= nguong else { continue }
                    let kc = khoangCachLevenshtein(kThu, kMau)
                    if kc <= nguong {
                        if totNhat == nil || kc < totNhat!.kc {
                            totNhat = (tenMau, kc)
                        }
                    }
                }
                if totNhat != nil { break }
            }
            if let totNhat {
                tenChuan = totNhat.ten
            }
        }

        let ketQuaCuoi = !tienToThang.isEmpty ? "\(tienToThang) - \(tenChuan)" : tenChuan
        khoaBoNhoDemTinh.lock()
        boNhoDemTenChuan[khoaDem] = ketQuaCuoi
        if tienToThangMacDinh == nil {
            boNhoDemTenChuan[ketQuaCuoi] = ketQuaCuoi
        }
        khoaBoNhoDemTinh.unlock()
        return ketQuaCuoi
    }

    static func apDungLocTuCaiDat(_ tenGoc: String) -> String {
        khoaBoNhoDemTinh.lock()
        if let daDem = boNhoDemLocTen[tenGoc] {
            khoaBoNhoDemTinh.unlock()
            return daDem
        }
        let danhSachLoc = danhSachCumTuLocBoTinh
        khoaBoNhoDemTinh.unlock()

        var s = chuanHoaTenMonThiDuaChuan(tenGoc)

        for cumTu in danhSachLoc {
            let sach = cumTu.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !sach.isEmpty else { continue }
            s = s.replacingOccurrences(of: sach, with: "", options: .caseInsensitive)
        }

        s = s
            .replacingOccurrences(of: "^[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[\\s\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\|\\s*\\|+", with: "|", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let ketQua = s.isEmpty ? tenGoc.trimmingCharacters(in: .whitespacesAndNewlines) : s

        khoaBoNhoDemTinh.lock()
        boNhoDemLocTen[tenGoc] = ketQua
        khoaBoNhoDemTinh.unlock()
        return ketQua
    }

    /// Chuẩn hoá khóa tên ngành hàng cơ bản (bỏ hậu tố đánh số trùng như "(#2)", "#2", nhãn CE/ICT/DV, DT/SL) để so sánh và lọc trùng 100%
    static func chuanHoaKhoaCoBanThiDua(_ ten: String) -> String {
        khoaBoNhoDemTinh.lock()
        if let daDem = boNhoDemKhoaCoBan[ten] {
            khoaBoNhoDemTinh.unlock()
            return daDem
        }
        khoaBoNhoDemTinh.unlock()

        let sach = chuanHoaTenMonThiDuaChuan(ten)
        let ketQua = chuanHoaKhoaSoSanh(sach)
            .replacingOccurrences(of: "\\s*\\(?#?\\d+\\)?$", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        khoaBoNhoDemTinh.lock()
        boNhoDemKhoaCoBan[ten] = ketQua
        khoaBoNhoDemTinh.unlock()
        return ketQua
    }

    /// Khóa tên môn thi đua không tính tiền tố tháng (ví dụ "T11 - Máy Lạnh" và "Máy Lạnh" đều có khóa "MAYLANH")
    static func chuanHoaKhoaLienMachThiDua(_ ten: String) -> String {
        khoaBoNhoDemTinh.lock()
        if let daDem = boNhoDemKhoaLienMach[ten] {
            khoaBoNhoDemTinh.unlock()
            return daDem
        }
        khoaBoNhoDemTinh.unlock()

        let sach = chuanHoaTenMonThiDuaChuan(ten)
        let k = taoKhoaLienMachKhongThang(sach)
        let ketQua = !k.isEmpty ? k : chuanHoaKhoaCoBanThiDua(sach).replacingOccurrences(of: "[^A-Z0-9]", with: "", options: .regularExpression)

        khoaBoNhoDemTinh.lock()
        boNhoDemKhoaLienMach[ten] = ketQua
        khoaBoNhoDemTinh.unlock()
        return ketQua
    }

    /// Gộp và lọc trùng danh sách môn thi đua với độ phức tạp O(N) qua bảng băm:
    /// So sánh giữa các môn mới quét được với nhau và so sánh với các môn có sẵn; nếu tên môn giống nhau 100% thì chỉ giữ lại 1 môn duy nhất.
    /// Kiểm tra xem một chuỗi tên có phải là dòng nhân viên (có mã NV 5-7 số, tiền tố id:, hoặc trùng tên nhân viên) bị quét nhầm vào bảng Thi đua hay không
    static func laTenDongNhanVienBiQuetNham(_ ten: String) -> Bool {
        let s = ten.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty else { return true }
        if laTenMonThiDuaChuanDMX(s) {
            return false
        }
        let u = chuanHoaKhoaSoSanh(s)
        if u.contains("MO THE") || u.contains("TIN DUNG") || u.contains("VPBANK") || u.contains("TPBAK") || u.contains("TPBANK") {
            return false
        }
        if u.range(of: "\\b(?:ID|LD|1D)\\b", options: .regularExpression) != nil {
            return true
        }
        if s.range(of: "(?i)\\b(?:id|ld|1d)\\s*[:.;\\-]?\\s*\\d{3,7}", options: .regularExpression) != nil {
            return true
        }
        if s.range(of: "\\b\\d{5,7}\\b", options: .regularExpression) != nil {
            return true
        }
        if u == "NHAN VIEN" || u.contains("NGANH HANG BI") || u.contains("NHOM HANG BI") || u.contains("DT QD KHOAN VAY") || u.contains("TI TRONG") {
            return true
        }
        let tenKhongId = u
            .replacingOccurrences(of: "\\b(?:ID|LD|1D)\\b", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\d+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        for nv in CaiDatDMX.nhanVienMau {
            let tenNV = chuanHoaKhoaSoSanh(nv.hoTen)
            if tenKhongId == tenNV || u.contains(tenNV) {
                return true
            }
        }
        if tenKhongId == "PHAN THUONG VINH" || tenKhongId == "VINH" {
            return true
        }
        return false
    }

    static func gopDanhSachThiDua(cu: [DongThiDua], moi: [DongThiDua]) -> [DongThiDua] {
        // Nếu danh sách mới quét được đã là trọn bộ bảng thi đua (>= 25 môn), thay thế sạch dữ liệu cũ để không bị dính số sai từ lần quét trước
        let tatCa = (cu.isEmpty || moi.count >= 25) ? moi : (cu + moi)
        guard !tatCa.isEmpty else { return [] }

        var ketQua: [DongThiDua] = []
        ketQua.reserveCapacity(tatCa.count)

        for var dongMoi in tatCa {
            let tenKiemTra = dongMoi.tenNganhHangGoc.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !tenKiemTra.isEmpty, !laTenDongNhanVienBiQuetNham(tenKiemTra), !laTenDongNhanVienBiQuetNham(dongMoi.tenNganhHang) else { continue }

            let gocSach = chuanHoaTenMonThiDuaChuan(dongMoi.tenNganhHangGoc)
            dongMoi.tenNganhHangGoc = gocSach.isEmpty ? dongMoi.tenNganhHangGoc : gocSach
            dongMoi.tenNganhHang = apDungLocTuCaiDat(dongMoi.tenNganhHangGoc)

            let khoaCoBanMoi = chuanHoaKhoaCoBanThiDua(dongMoi.tenNganhHangGoc)
            let khoaLienMachGocMoi = chuanHoaKhoaLienMachThiDua(dongMoi.tenNganhHangGoc)
            guard !khoaCoBanMoi.isEmpty || !khoaLienMachGocMoi.isEmpty else { continue }

            // Gộp theo đúng khóa tên ngành hàng chuẩn để luôn cập nhật được Target và % Hoàn thành mới nhất
            var viTriTrung: Int? = nil
            for (idxCu, dongCu) in ketQua.enumerated() {
                let khoaCoBanCu = chuanHoaKhoaCoBanThiDua(dongCu.tenNganhHangGoc)
                let khoaLienMachCu = chuanHoaKhoaLienMachThiDua(dongCu.tenNganhHangGoc)
                let trungTen100 = (!khoaCoBanMoi.isEmpty && khoaCoBanMoi == khoaCoBanCu) ||
                                  (!khoaLienMachGocMoi.isEmpty && khoaLienMachGocMoi == khoaLienMachCu)
                if trungTen100 {
                    viTriTrung = idxCu
                    break
                }
            }

            if let viTri = viTriTrung {
                var dongCu = ketQua[viTri]
                let moiLaChuan = laTenMonThiDuaChuanDMX(dongMoi.tenNganhHangGoc)
                let cuLaChuan = laTenMonThiDuaChuanDMX(dongCu.tenNganhHangGoc)
                if (moiLaChuan && !cuLaChuan) || (moiLaChuan == cuLaChuan && dongMoi.tenNganhHangGoc.count >= dongCu.tenNganhHangGoc.count) {
                    dongCu.tenNganhHangGoc = dongMoi.tenNganhHangGoc
                    dongCu.tenNganhHang = dongMoi.tenNganhHang
                }
                dongCu.loaiChiTieu = dongMoi.loaiChiTieu
                if abs(dongMoi.thucHien) > 0.0001 || (dongMoi.target > 0 && dongMoi.phanTramHTGoc != nil) {
                    dongCu.thucHien = dongMoi.thucHien
                }
                if dongMoi.target > 0 {
                    dongCu.target = dongMoi.target
                }
                if let htGoc = dongMoi.phanTramHTGoc {
                    dongCu.phanTramHTGoc = htGoc
                }
                if let dbGoc = dongMoi.phanTramDuBaoGoc {
                    dongCu.phanTramDuBaoGoc = dbGoc
                }
                if let dkGoc = dongMoi.duKienGoc, dkGoc > 0 {
                    dongCu.duKienGoc = dkGoc
                }
                ketQua[viTri] = dongCu
            } else {
                ketQua.append(dongMoi)
            }
        }
        return ketQua
    }

    static func chuanHoaKhoaSoSanh(_ ten: String) -> String {
        khoaBoNhoDemTinh.lock()
        if let daDem = boNhoDemKhoaSoSanh[ten] {
            khoaBoNhoDemTinh.unlock()
            return daDem
        }
        khoaBoNhoDemTinh.unlock()

        let ketQua = ten.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
            .replacingOccurrences(of: "[\\|¦\\-–—−•◦○●⊕⊖/\\\\.:;,…]+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        khoaBoNhoDemTinh.lock()
        boNhoDemKhoaSoSanh[ten] = ketQua
        khoaBoNhoDemTinh.unlock()
        return ketQua
    }

    static func chuanHoaMaNV(_ raw: String) -> String {
        if let range = raw.range(of: "\\b\\d{3,10}\\b", options: .regularExpression) {
            return String(raw[range])
        }
        return raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func khopNhanVienQuetVoiQuanLy(
        maQuet: String,
        tenQuet: String,
        dsQuanLy: [NhanVienQuanLy]
    ) -> NhanVienQuanLy? {
        let maSach = chuanHoaMaNV(maQuet.isEmpty ? tenQuet : maQuet)
        if !maSach.isEmpty {
            if let theoMa = dsQuanLy.first(where: { $0.maNV == maSach }) {
                return theoMa
            }
            if maSach.count >= 6 {
                let boDauKyTu = String(maSach.dropFirst())
                if let theoMaBoDau = dsQuanLy.first(where: { $0.maNV == boDauKyTu }) {
                    return theoMaBoDau
                }
            }
        }

        let tenKhongSo = tenQuet
            .replacingOccurrences(of: "(?i)\\b(?:id|ld|1d|ia|iđ|ma|mã)\\b\\s*[:.;\\-]?", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "\\d+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "[-–—+]", with: " ", options: .regularExpression)
        let tenChuan = chuanHoaKhoaSoSanh(tenKhongSo)

        // Nếu có mã NV quét được bị lệch tối đa 1 chữ số và phần tên khớp đầu tên nhân viên trong danh sách
        if maSach.count >= 4 {
            let ungVienGanMa = dsQuanLy.filter { nv in
                guard abs(nv.maNV.count - maSach.count) <= 1 else { return false }
                let a = Array(nv.maNV)
                let b = Array(maSach)
                if a.count == b.count {
                    return zip(a, b).filter { $0 != $1 }.count <= 1
                } else {
                    return nv.maNV.contains(maSach) || maSach.contains(nv.maNV)
                }
            }
            if ungVienGanMa.count == 1, !tenChuan.isEmpty {
                let nv = ungVienGanMa[0]
                let nvChuan = chuanHoaKhoaSoSanh(nv.hoTen)
                if nvChuan.hasPrefix(tenChuan) || nvChuan.contains(tenChuan) {
                    return nv
                }
            } else if ungVienGanMa.count > 1, !tenChuan.isEmpty {
                if let khop = ungVienGanMa.first(where: { chuanHoaKhoaSoSanh($0.hoTen).hasPrefix(tenChuan) }) {
                    return khop
                }
            }
            // Nếu đã có mã NV 4-7 chữ số rõ ràng nhưng hoàn toàn khác mã với mọi NV trong danh sách (ví dụ NV mới 65257),
            // tuyệt đối không ghép bừa theo họ phổ biến (như "Nguyễn", "Huỳnh", "Đỗ Thị", "Phan") để tránh ghi đè nhầm NV khác
            if !tenChuan.isEmpty {
                if let khopHoTenDayDu = dsQuanLy.first(where: { chuanHoaKhoaSoSanh($0.hoTen) == tenChuan }) {
                    return khopHoTenDayDu
                }
            }
            return nil
        }

        guard !tenChuan.isEmpty else { return nil }
        for nv in dsQuanLy {
            let nvChuan = chuanHoaKhoaSoSanh(nv.hoTen)
            if nvChuan == tenChuan || nvChuan.hasSuffix(tenChuan) || tenChuan.hasSuffix(nvChuan) || nvChuan.contains(tenChuan) {
                return nv
            }
        }
        return nil
    }

    static func huyChuongHang(_ hang: Int) -> String {
        switch hang {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(hang)"
        }
    }

    /// Phân tích Sức khỏe Nhân viên toàn đội (~16 NV) và phát hiện Top 5 nhân viên yếu nhiều ngày liên tục
    func tinhBaoCaoSucKhoeNhanVien(
        den ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe
    ) -> BaoCaoSucKhoeDoiNgu {
        khoaTruyCap.lock()
        defer { khoaTruyCap.unlock() }

        let khoaDen = TienIchNgay.khoa.string(from: ngay)
        let khoaDem = "\(khoaDen)|\(cheDo.rawValue)"
        if let daDem = boNhoDemBaoCaoSucKhoe[khoaDem] {
            return daDem
        }

        let dsNV = NhanVienQuanLy.sapXepAZ(caiDat.danhSachNhanVien)
        guard !dsNV.isEmpty else {
            return BaoCaoSucKhoeDoiNgu(
                ngayBaoCao: ngay,
                cheDo: cheDo,
                soNgayDaTheoDoi: 0,
                cacNhanNgayTheoDoi: [],
                soNVKhoe: 0,
                soNVTrungBinh: 0,
                soNVYeu: 0,
                diemTrungBinhDoiNgu: 0,
                top5CanhBaoYeu: [],
                danhSachTatCa: []
            )
        }

        let tienToThang = String(khoaDen.prefix(7))

        // Lấy các ngày trong tháng hiện tại (và tối đa 10 ngày cuối tháng trước nếu đầu tháng) có dữ liệu nhân viên
        var cacKhoaUngVien = cacNgay.keys.filter { $0 <= khoaDen && $0.hasPrefix(tienToThang) }.sorted()
        if cacKhoaUngVien.count < 7 {
            let cacKhoaTruoc = cacNgay.keys.filter { $0 < khoaDen && !$0.hasPrefix(tienToThang) }.sorted().suffix(10)
            cacKhoaUngVien = Array(cacKhoaTruoc) + cacKhoaUngVien
        }
        if !cacKhoaUngVien.contains(khoaDen) {
            cacKhoaUngVien.append(khoaDen)
        }

        struct BanGhiNgay {
            let khoaNgay: String
            let ngayTrongThang: Int
            let nhanNgay: String
            let bangDiem: [String: DiemSucKhoeNgayNV]
        }

        var cacBanGhiNgay: [BanGhiNgay] = []

        for khoa in cacKhoaUngVien {
            guard let ngayD = TienIchNgay.khoa.date(from: khoa) else { continue }
            let dlRaw = cacNgay[khoa]
            let coDuLieuRiengNgay: Bool
            if let dlRaw {
                coDuLieuRiengNgay = !dlRaw.thiDuaNhanVien.isEmpty
                    || !dlRaw.thiDuaNhanVienRealtime.isEmpty
                    || !dlRaw.doanhThuNhanVienRealtime.isEmpty
                    || !dlRaw.danhSachThiDua.isEmpty
                    || !dlRaw.danhSachThiDuaRealtime.isEmpty
                    || (khoa == khoaDen && !dlRaw.doanhThuNhanVien.isEmpty)
            } else {
                coDuLieuRiengNgay = (khoa == khoaDen)
            }
            guard coDuLieuRiengNgay else { continue }

            // Chọn chế độ có dữ liệu thực tế cho ngày đó (ưu tiên cheDo đang chọn, nếu trống thì lấy chế độ còn lại)
            var dsTH = tongHopNhanVien(den: ngayD, sapXep: .soMonHoanThanh, cheDo: cheDo)
            let coSoChinh = dsTH.contains { $0.tongMonGiao > 0 || $0.doanhThuQD > 0 || $0.soMonDat > 0 }
            if !coSoChinh {
                let cheDoPhu: LoaiCheDoDoanhThu = (cheDo == .luyKe) ? .realtime : .luyKe
                let dsPhu = tongHopNhanVien(den: ngayD, sapXep: .soMonHoanThanh, cheDo: cheDoPhu)
                if dsPhu.contains(where: { $0.tongMonGiao > 0 || $0.doanhThuQD > 0 || $0.soMonDat > 0 }) {
                    dsTH = dsPhu
                } else if khoa != khoaDen {
                    continue
                }
            }

            let coThiDua = dsTH.contains { $0.tongMonGiao > 0 }
            let dsCoDT = dsTH.filter { $0.doanhThuQD > 0 }
            let coDoanhThu = !dsCoDT.isEmpty
            let tbHTTB = dsTH.map(\.phanTramHTTB).reduce(0.0, +) / Double(max(1, dsTH.count))
            let tbDTQD = coDoanhThu ? (dsCoDT.map(\.doanhThuQD).reduce(0.0, +) / Double(dsCoDT.count)) : 0

            var diemTamTheoMa: [String: (diem: Double, th: TongHopNhanVien)] = [:]
            for th in dsTH {
                let tyLeMon = th.tongMonGiao > 0 ? (Double(th.soMonDat) / Double(th.tongMonGiao)) * 100.0 : 0
                let diemHTTuyetDoi = min(100.0, th.phanTramHTTB)
                let diemHTTuongDoi = tbHTTB > 0.01 ? min(100.0, (th.phanTramHTTB / tbHTTB) * 72.0) : diemHTTuyetDoi
                let diemThiDua = 0.35 * tyLeMon + 0.30 * diemHTTuyetDoi + 0.35 * diemHTTuongDoi

                let diemDT: Double
                if coDoanhThu && tbDTQD > 0 {
                    let diemSoVoiTB = min(100.0, (th.doanhThuQD / tbDTQD) * 74.0)
                    if let ptCN = th.doanhThuCaNhan?.phanTramHT, ptCN > 0 {
                        diemDT = 0.45 * min(100.0, ptCN) + 0.55 * diemSoVoiTB
                    } else {
                        diemDT = diemSoVoiTB
                    }
                } else {
                    diemDT = 0
                }

                let diemTong: Double
                if coThiDua && coDoanhThu {
                    diemTong = 0.65 * diemThiDua + 0.35 * diemDT
                } else if coThiDua {
                    diemTong = diemThiDua
                } else if coDoanhThu {
                    diemTong = diemDT
                } else {
                    diemTong = 0
                }

                let diemChuan = min(100.0, max(0.0, diemTong))
                diemTamTheoMa[th.nhanVien.maNV] = (diemChuan, th)
            }

            let cacDiemSapXep = diemTamTheoMa.values.map(\.diem).sorted()
            let chiSoTop5Yeu = min(4, max(0, cacDiemSapXep.count - 1))
            let nguongTop5Yeu = cacDiemSapXep.isEmpty ? 55.0 : cacDiemSapXep[chiSoTop5Yeu]
            let coDuLieuThucTe = coThiDua || coDoanhThu

            let dNgay = TienIchNgay.lich.component(.day, from: ngayD)
            let mThang = TienIchNgay.lich.component(.month, from: ngayD)
            let nhanNgay = String(format: "%02d/%02d", dNgay, mThang)

            var bangDiemNgay: [String: DiemSucKhoeNgayNV] = [:]
            for nv in dsNV {
                guard let info = diemTamTheoMa[nv.maNV] else { continue }
                let mucDo: MucDoSucKhoeNV
                if !coDuLieuThucTe {
                    mucDo = .chuaCoSo
                } else if info.diem < 55.0 || (info.diem <= nguongTop5Yeu + 0.001 && info.diem < 74.0 && !(info.th.tongMonGiao > 0 && info.th.soMonDat == info.th.tongMonGiao)) {
                    mucDo = .yeu
                } else if info.diem >= 75.0 || (info.th.tongMonGiao > 0 && info.th.soMonDat == info.th.tongMonGiao) {
                    mucDo = .khoe
                } else {
                    mucDo = .trungBinh
                }

                bangDiemNgay[nv.maNV] = DiemSucKhoeNgayNV(
                    khoaNgay: khoa,
                    ngayTrongThang: dNgay,
                    nhanNgay: nhanNgay,
                    diemSucKhoe: info.diem,
                    mucDo: mucDo,
                    soMonDat: info.th.soMonDat,
                    tongMonGiao: info.th.tongMonGiao,
                    phanTramHTTB: info.th.phanTramHTTB,
                    doanhThuQD: info.th.doanhThuQD
                )
            }
            if coDuLieuThucTe || cacBanGhiNgay.isEmpty {
                cacBanGhiNgay.append(BanGhiNgay(
                    khoaNgay: khoa,
                    ngayTrongThang: dNgay,
                    nhanNgay: nhanNgay,
                    bangDiem: bangDiemNgay
                ))
            }
        }

        var dsTongHopHienTai = tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: cheDo)
        if !dsTongHopHienTai.contains(where: { $0.tongMonGiao > 0 || $0.doanhThuQD > 0 }) {
            let cheDoPhu: LoaiCheDoDoanhThu = (cheDo == .luyKe) ? .realtime : .luyKe
            let dsPhu = tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: cheDoPhu)
            if dsPhu.contains(where: { $0.tongMonGiao > 0 || $0.doanhThuQD > 0 }) {
                dsTongHopHienTai = dsPhu
            }
        }
        let mapTHHienTai = Dictionary(uniqueKeysWithValues: dsTongHopHienTai.map { ($0.nhanVien.maNV, $0) })

        var hoSoTam: [HoSoSucKhoeNhanVien] = []
        hoSoTam.reserveCapacity(dsNV.count)

        for nv in dsNV {
            let thHienTai = mapTHHienTai[nv.maNV] ?? TongHopNhanVien(
                nhanVien: nv,
                soMonDat: 0,
                tongMonGiao: 0,
                phanTramHTTB: 0,
                doanhThuQD: 0,
                soLuongDon: 0,
                dtQDKhoanVay: 0,
                dtTraThangQD: 0,
                cacMonGiao: [],
                doanhThuCaNhan: nil
            )

            let lichSuDayDu: [DiemSucKhoeNgayNV] = cacBanGhiNgay.compactMap { $0.bangDiem[nv.maNV] }
            let lichSuCoSo = lichSuDayDu.filter { $0.mucDo != .chuaCoSo }

            var soNgayYeuLienTuc = 0
            for item in lichSuCoSo.reversed() {
                if item.mucDo == .yeu {
                    soNgayYeuLienTuc += 1
                } else {
                    break
                }
            }

            var chuoiYeuDaiNhat = 0
            var demTam = 0
            var tongSoNgayYeu = 0
            for item in lichSuCoSo {
                if item.mucDo == .yeu {
                    demTam += 1
                    tongSoNgayYeu += 1
                    chuoiYeuDaiNhat = max(chuoiYeuDaiNhat, demTam)
                } else {
                    demTam = 0
                }
            }

            let diemHienTai = lichSuDayDu.last?.diemSucKhoe ?? 0
            let mucDoHienTai = lichSuDayDu.last?.mucDo ?? .chuaCoSo

            let xuHuong: Double
            if lichSuCoSo.count >= 2 {
                let diemCuoi = lichSuCoSo.last!.diemSucKhoe
                let cacTruoc = lichSuCoSo.dropLast().suffix(3)
                let tbTruoc = cacTruoc.map(\.diemSucKhoe).reduce(0.0, +) / Double(max(1, cacTruoc.count))
                xuHuong = diemCuoi - tbTruoc
            } else {
                xuHuong = 0
            }

            let cacMonChuaDat = thHienTai.cacMonGiao
                .filter { !$0.daDat }
                .sorted { $0.phanTramHT < $1.phanTramHT }
                .prefix(2)
                .map { "\($0.tenNganhHang) (\(Int(round($0.phanTramHT)))%)" }

            hoSoTam.append(HoSoSucKhoeNhanVien(
                nhanVien: nv,
                tongHopHienTai: thHienTai,
                diemSucKhoe: diemHienTai,
                mucDo: mucDoHienTai,
                soNgayYeuLienTuc: soNgayYeuLienTuc,
                chuoiYeuDaiNhat: max(chuoiYeuDaiNhat, soNgayYeuLienTuc),
                tongSoNgayYeu: tongSoNgayYeu,
                tongSoNgayCoSo: lichSuCoSo.count,
                lichSuNgay: Array(lichSuDayDu.suffix(8)),
                cacMonYeuNhat: Array(cacMonChuaDat),
                xuHuongDiem: xuHuong,
                laCanhBaoTop5: false,
                hangCanhBao: nil
            ))
        }

        // Xác định 5 nhân viên yếu nhiều ngày liên tục nhất (ưu tiên số ngày yếu liên tục giảm dần -> tổng ngày yếu -> điểm sức khỏe thấp nhất)
        let sapXepCanhBao = hoSoTam.sorted { a, b in
            let aCoYeu = (a.soNgayYeuLienTuc > 0 || a.mucDo == .yeu) ? 1 : 0
            let bCoYeu = (b.soNgayYeuLienTuc > 0 || b.mucDo == .yeu) ? 1 : 0
            if aCoYeu != bCoYeu { return aCoYeu > bCoYeu }
            if a.soNgayYeuLienTuc != b.soNgayYeuLienTuc { return a.soNgayYeuLienTuc > b.soNgayYeuLienTuc }
            if a.tongSoNgayYeu != b.tongSoNgayYeu { return a.tongSoNgayYeu > b.tongSoNgayYeu }
            if abs(a.diemSucKhoe - b.diemSucKhoe) > 0.05 { return a.diemSucKhoe < b.diemSucKhoe }
            if abs(a.tongHopHienTai.phanTramHTTB - b.tongHopHienTai.phanTramHTTB) > 0.05 {
                return a.tongHopHienTai.phanTramHTTB < b.tongHopHienTai.phanTramHTTB
            }
            return a.tongHopHienTai.doanhThuQD < b.tongHopHienTai.doanhThuQD
        }

        let soLuongCanhBao = min(5, sapXepCanhBao.count)
        let maTop5 = Array(sapXepCanhBao.prefix(soLuongCanhBao).map(\.nhanVien.maNV))

        for i in hoSoTam.indices {
            if let viTri = maTop5.firstIndex(of: hoSoTam[i].nhanVien.maNV) {
                hoSoTam[i].laCanhBaoTop5 = true
                hoSoTam[i].hangCanhBao = viTri + 1
            }
        }

        let top5 = maTop5.compactMap { ma in hoSoTam.first(where: { $0.nhanVien.maNV == ma }) }
        let soKhoe = hoSoTam.filter { $0.mucDo == .khoe }.count
        let soTB = hoSoTam.filter { $0.mucDo == .trungBinh }.count
        let soYeu = hoSoTam.filter { $0.mucDo == .yeu }.count
        let diemTBDoi = hoSoTam.isEmpty ? 0 : (hoSoTam.map(\.diemSucKhoe).reduce(0.0, +) / Double(hoSoTam.count))
        let cacNhanNgay = cacBanGhiNgay.suffix(8).map(\.nhanNgay)
        let soNgayCoSo = cacBanGhiNgay.filter { bg in bg.bangDiem.values.contains(where: { $0.mucDo != .chuaCoSo }) }.count

        let baoCao = BaoCaoSucKhoeDoiNgu(
            ngayBaoCao: ngay,
            cheDo: cheDo,
            soNgayDaTheoDoi: max(soNgayCoSo, cacBanGhiNgay.isEmpty ? 0 : 1),
            cacNhanNgayTheoDoi: Array(cacNhanNgay),
            soNVKhoe: soKhoe,
            soNVTrungBinh: soTB,
            soNVYeu: soYeu,
            diemTrungBinhDoiNgu: diemTBDoi,
            top5CanhBaoYeu: top5,
            danhSachTatCa: hoSoTam
        )
        boNhoDemBaoCaoSucKhoe[khoaDem] = baoCao
        return baoCao
    }
}

// MARK: - Hộp Chọn Hành Động Tùy Chỉnh (Đảm bảo mọi dòng chữ có CÙNG CỠ CHỮ, tự động xuống dòng khi dài, tuyệt đối không bao giờ hiện dấu "...")

struct MucChonDMX {
    enum KieuMuc {
        case macDinh
        case nguyHiem
        case huy
    }

    let tieuDe: String
    let kieu: KieuMuc
    let dangChon: Bool
    let xuLy: (() -> Void)?

    init(tieuDe: String, kieu: KieuMuc = .macDinh, dangChon: Bool = false, xuLy: (() -> Void)? = nil) {
        self.tieuDe = tieuDe
        self.kieu = kieu
        self.dangChon = dangChon
        self.xuLy = xuLy
    }
}

private final class NutHangMenuDMX: UIControl {
    private let nhan = UILabel()
    private let vachChonTrai = UIView()
    private let nenMacDinh: UIColor
    private var xuLyBam: (() -> Void)?

    init(muc: MucChonDMX, coChu: UIFont, canGiua: Bool, khiBam: @escaping () -> Void) {
        self.xuLyBam = khiBam
        self.nenMacDinh = muc.dangChon ? BangMauBCTD.vangNhatNen.withAlphaComponent(0.45) : .clear
        super.init(frame: .zero)
        backgroundColor = nenMacDinh

        vachChonTrai.backgroundColor = BangMauBCTD.vangChuDao
        vachChonTrai.isHidden = !muc.dangChon
        vachChonTrai.isUserInteractionEnabled = false
        vachChonTrai.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vachChonTrai)

        let chuHienThi = muc.dangChon ? "✓  \(muc.tieuDe)" : muc.tieuDe
        nhan.text = chuHienThi
        nhan.font = muc.dangChon ? .systemFont(ofSize: coChu.pointSize, weight: .bold) : coChu
        nhan.numberOfLines = 1
        nhan.lineBreakMode = .byTruncatingTail
        nhan.adjustsFontSizeToFitWidth = true
        nhan.minimumScaleFactor = 0.72
        nhan.textAlignment = canGiua ? .center : .left
        nhan.isUserInteractionEnabled = false

        switch muc.kieu {
        case .nguyHiem:
            nhan.textColor = BangMauBCTD.doYeuChu
        case .huy:
            nhan.textColor = BangMauBCTD.chuChinh
        case .macDinh:
            nhan.textColor = muc.dangChon ? BangMauBCTD.chuChinh : BangMauBCTD.indigoDam
        }

        nhan.translatesAutoresizingMaskIntoConstraints = false
        nhan.setContentCompressionResistancePriority(.required, for: .vertical)
        addSubview(nhan)

        NSLayoutConstraint.activate([
            vachChonTrai.topAnchor.constraint(equalTo: topAnchor),
            vachChonTrai.bottomAnchor.constraint(equalTo: bottomAnchor),
            vachChonTrai.leadingAnchor.constraint(equalTo: leadingAnchor),
            vachChonTrai.widthAnchor.constraint(equalToConstant: 4),

            nhan.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            nhan.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
            nhan.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nhan.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        ])

        addTarget(self, action: #selector(bamChon), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? BangMauBCTD.indigoNhatNen : nenMacDinh
        }
    }

    @objc private func bamChon() {
        xuLyBam?()
    }
}

final class HopChonDMXController: UIViewController {
    private let tieuDeMenu: String?
    private let thongDiepMenu: String?
    private let cacMuc: [MucChonDMX]
    private let canGiuaText: Bool

    private let nenMo = UIControl()
    private let khungChinh = UIView()
    private let khungDanhSach = UIView()
    private let khungNutHuy = UIView()

    init(tieuDe: String?, thongDiep: String? = nil, cacMuc: [MucChonDMX], canGiuaText: Bool = false) {
        self.tieuDeMenu = tieuDe
        self.thongDiepMenu = thongDiep
        self.cacMuc = cacMuc
        self.canGiuaText = canGiuaText
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taoGiaoDien()
    }

    private func taoGiaoDien() {
        view.backgroundColor = .clear

        nenMo.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        nenMo.addTarget(self, action: #selector(bamDong), for: .touchUpInside)
        nenMo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nenMo)

        khungChinh.backgroundColor = .clear
        khungChinh.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungChinh)

        khungDanhSach.backgroundColor = .secondarySystemGroupedBackground
        khungDanhSach.layer.cornerRadius = 16
        khungDanhSach.clipsToBounds = true
        khungDanhSach.translatesAutoresizingMaskIntoConstraints = false

        let cuon = UIScrollView()
        cuon.showsVerticalScrollIndicator = true
        cuon.alwaysBounceVertical = false
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungDanhSach.addSubview(cuon)

        let ngan = UIStackView()
        ngan.axis = .vertical
        ngan.spacing = 0
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        let coTieuDe = !(tieuDeMenu ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let coThongDiep = !(thongDiepMenu ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        if coTieuDe || coThongDiep {
            let khungHeader = UIView()
            khungHeader.backgroundColor = BangMauBCTD.nenMenuToi
            let vachVang = UIView()
            vachVang.backgroundColor = BangMauBCTD.vangChuDao
            vachVang.translatesAutoresizingMaskIntoConstraints = false
            khungHeader.addSubview(vachVang)

            let nganHeader = UIStackView()
            nganHeader.axis = .vertical
            nganHeader.spacing = 4
            nganHeader.translatesAutoresizingMaskIntoConstraints = false
            khungHeader.addSubview(nganHeader)

            if coTieuDe, let td = tieuDeMenu {
                let lbTieuDe = UILabel()
                lbTieuDe.text = td.uppercased()
                lbTieuDe.font = .systemFont(ofSize: 14.5, weight: .heavy)
                lbTieuDe.textColor = BangMauBCTD.vangChuDao
                lbTieuDe.textAlignment = .center
                lbTieuDe.numberOfLines = 1
                lbTieuDe.lineBreakMode = .byTruncatingTail
                lbTieuDe.adjustsFontSizeToFitWidth = true
                lbTieuDe.minimumScaleFactor = 0.75
                nganHeader.addArrangedSubview(lbTieuDe)
            }

            if coThongDiep, let msg = thongDiepMenu {
                let lbMsg = UILabel()
                lbMsg.text = msg
                lbMsg.font = .systemFont(ofSize: 13, weight: .medium)
                lbMsg.textColor = BangMauBCTD.chuTrenNenToi
                lbMsg.textAlignment = .center
                lbMsg.numberOfLines = 0
                lbMsg.lineBreakMode = .byWordWrapping
                lbMsg.adjustsFontSizeToFitWidth = false
                nganHeader.addArrangedSubview(lbMsg)
            }

            NSLayoutConstraint.activate([
                nganHeader.topAnchor.constraint(equalTo: khungHeader.topAnchor, constant: 14),
                nganHeader.bottomAnchor.constraint(equalTo: khungHeader.bottomAnchor, constant: -14),
                nganHeader.leadingAnchor.constraint(equalTo: khungHeader.leadingAnchor, constant: 16),
                nganHeader.trailingAnchor.constraint(equalTo: khungHeader.trailingAnchor, constant: -16),

                vachVang.leadingAnchor.constraint(equalTo: khungHeader.leadingAnchor),
                vachVang.trailingAnchor.constraint(equalTo: khungHeader.trailingAnchor),
                vachVang.bottomAnchor.constraint(equalTo: khungHeader.bottomAnchor),
                vachVang.heightAnchor.constraint(equalToConstant: 2.5)
            ])
            ngan.addArrangedSubview(khungHeader)
        }

        // Tất cả các dòng lựa chọn đều dùng chung 1 cỡ chữ 15pt đồng nhất, tự xuống dòng khi dài
        let coChuDongNhat = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let cacMucChinh = cacMuc.filter { $0.kieu != .huy }
        let mucHuy = cacMuc.first(where: { $0.kieu == .huy }) ?? MucChonDMX(tieuDe: "Đóng", kieu: .huy)

        for (idx, muc) in cacMucChinh.enumerated() {
            if idx > 0 || coTieuDe || coThongDiep {
                let vach = UIView()
                vach.backgroundColor = .separator
                vach.translatesAutoresizingMaskIntoConstraints = false
                vach.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                ngan.addArrangedSubview(vach)
            }

            let nut = NutHangMenuDMX(muc: muc, coChu: coChuDongNhat, canGiua: canGiuaText) { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true) {
                    muc.xuLy?()
                }
            }
            ngan.addArrangedSubview(nut)
        }

        khungNutHuy.backgroundColor = .secondarySystemGroupedBackground
        khungNutHuy.layer.cornerRadius = 16
        khungNutHuy.clipsToBounds = true
        khungNutHuy.translatesAutoresizingMaskIntoConstraints = false

        let nutHuy = NutHangMenuDMX(
            muc: mucHuy,
            coChu: .systemFont(ofSize: 16, weight: .bold),
            canGiua: true
        ) { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true) {
                mucHuy.xuLy?()
            }
        }
        nutHuy.translatesAutoresizingMaskIntoConstraints = false
        khungNutHuy.addSubview(nutHuy)

        khungChinh.addSubview(khungDanhSach)
        khungChinh.addSubview(khungNutHuy)

        let chieuCaoCuon = cuon.heightAnchor.constraint(equalTo: ngan.heightAnchor)
        chieuCaoCuon.priority = .defaultHigh

        NSLayoutConstraint.activate([
            nenMo.topAnchor.constraint(equalTo: view.topAnchor),
            nenMo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nenMo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nenMo.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            khungChinh.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            khungChinh.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            khungChinh.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            khungChinh.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),

            khungDanhSach.topAnchor.constraint(equalTo: khungChinh.topAnchor),
            khungDanhSach.leadingAnchor.constraint(equalTo: khungChinh.leadingAnchor),
            khungDanhSach.trailingAnchor.constraint(equalTo: khungChinh.trailingAnchor),

            cuon.topAnchor.constraint(equalTo: khungDanhSach.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: khungDanhSach.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungDanhSach.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: khungDanhSach.bottomAnchor),
            chieuCaoCuon,

            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor),
            ngan.leadingAnchor.constraint(equalTo: cuon.contentLayoutGuide.leadingAnchor),
            ngan.trailingAnchor.constraint(equalTo: cuon.contentLayoutGuide.trailingAnchor),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor),
            ngan.widthAnchor.constraint(equalTo: cuon.frameLayoutGuide.widthAnchor),

            khungNutHuy.topAnchor.constraint(equalTo: khungDanhSach.bottomAnchor, constant: 8),
            khungNutHuy.leadingAnchor.constraint(equalTo: khungChinh.leadingAnchor),
            khungNutHuy.trailingAnchor.constraint(equalTo: khungChinh.trailingAnchor),
            khungNutHuy.bottomAnchor.constraint(equalTo: khungChinh.bottomAnchor),

            nutHuy.topAnchor.constraint(equalTo: khungNutHuy.topAnchor),
            nutHuy.leadingAnchor.constraint(equalTo: khungNutHuy.leadingAnchor),
            nutHuy.trailingAnchor.constraint(equalTo: khungNutHuy.trailingAnchor),
            nutHuy.bottomAnchor.constraint(equalTo: khungNutHuy.bottomAnchor)
        ])
    }

    @objc private func bamDong() {
        let mucHuy = cacMuc.first(where: { $0.kieu == .huy })
        dismiss(animated: true) {
            mucHuy?.xuLy?()
        }
    }
}

extension UIViewController {
    func hienMenuChon(
        tieuDe: String? = nil,
        thongDiep: String? = nil,
        cacMuc: [MucChonDMX],
        canGiuaText: Bool = false
    ) {
        let hop = HopChonDMXController(
            tieuDe: tieuDe,
            thongDiep: thongDiep,
            cacMuc: cacMuc,
            canGiuaText: canGiuaText
        )
        present(hop, animated: true)
    }
}

extension UIView {
    /// Đảm bảo mọi UILabel và UIButton bên trong view luôn hiển thị trọn vẹn văn bản, tự xuống dòng, không bao giờ hiện dấu "..."
    func damBaoHienThiDayDuText() {
        if let lb = self as? UILabel {
            lb.numberOfLines = 0
            lb.lineBreakMode = .byWordWrapping
            lb.adjustsFontSizeToFitWidth = false
        } else if let bt = self as? UIButton {
            bt.titleLabel?.numberOfLines = 0
            bt.titleLabel?.lineBreakMode = .byWordWrapping
            bt.titleLabel?.adjustsFontSizeToFitWidth = false
        }
        for sub in subviews {
            sub.damBaoHienThiDayDuText()
        }
    }
}

extension UIAlertController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.damBaoHienThiDayDuText()
    }
}

enum TienIchNgay {
    static let lich: Calendar = {
        var lich = Calendar(identifier: .gregorian)
        lich.locale = Locale(identifier: "vi_VN")
        lich.timeZone = .current
        return lich
    }()

    static let khoa: DateFormatter = {
        let dinhDang = DateFormatter()
        dinhDang.calendar = lich
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateFormat = "yyyy-MM-dd"
        return dinhDang
    }()

    static let hienThiNgay: DateFormatter = {
        let dinhDang = DateFormatter()
        dinhDang.calendar = lich
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateFormat = "dd/MM/yyyy"
        return dinhDang
    }()

    static let hienThiGioPhut: DateFormatter = {
        let dinhDang = DateFormatter()
        dinhDang.calendar = lich
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateFormat = "HH:mm dd/MM/yyyy"
        return dinhDang
    }()

    static func heSoDuBaoThang(cho ngay: Date = Date()) -> Double {
        let soNgayTrongThang = Double(lich.range(of: .day, in: .month, for: ngay)?.count ?? 30)
        let ngayHienTai = Double(max(1, lich.component(.day, from: ngay)))
        return max(1.0, soNgayTrongThang / ngayHienTai)
    }
}

extension Double {
    private static let boDinhDangVN: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "vi_VN")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 2
        df.maximumFractionDigits = 2
        return df
    }()

    private static let boDinhDangNguyenVN: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "vi_VN")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 0
        df.maximumFractionDigits = 0
        return df
    }()

    private static let boDinhDangSoLieuNguyenUS: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "en_US")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 0
        df.maximumFractionDigits = 0
        return df
    }()

    private static let boDinhDangSoLieuThapPhanUS: NumberFormatter = {
        let df = NumberFormatter()
        df.locale = Locale(identifier: "en_US")
        df.numberStyle = .decimal
        df.minimumFractionDigits = 2
        df.maximumFractionDigits = 2
        return df
    }()

    var chuoiSoVN: String {
        Double.boDinhDangVN.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    var chuoiSoNguyenVN: String {
        Double.boDinhDangNguyenVN.string(from: NSNumber(value: self.rounded())) ?? String(format: "%.0f", self)
    }

    var chuoiSoMotLeVN: String {
        if abs(self) < 0.005 { return "0" }
        return String(format: "%.1f", self).replacingOccurrences(of: ".", with: ",")
    }

    var chuoiSoGonVN: String {
        if abs(self.rounded() - self) < 0.005 {
            return chuoiSoNguyenVN
        }
        return chuoiSoVN
    }

    var chuoiPhanTramVN: String {
        "\(self.chuoiSoVN)%"
    }

    var chuoiSoLieu: String {
        if abs(self.rounded() - self) < 0.005 {
            return Double.boDinhDangSoLieuNguyenUS.string(from: NSNumber(value: self.rounded())) ?? String(format: "%.0f", self)
        }
        return Double.boDinhDangSoLieuThapPhanUS.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
    }

    var chuoiChenhLech: String {
        if abs(self) < 0.005 { return "0" }
        let dau = self > 0 ? "+" : ""
        return "\(dau)\(self.chuoiSoLieu)"
    }

    var chuoiPhanTram: String {
        if abs(self.rounded() - self) < 0.05 {
            return String(format: "%.0f%%", self)
        }
        return String(format: "%.1f%%", self)
    }
}
