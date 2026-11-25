import UIKit

// MARK: - Khung bản tin & giọng văn

/// 3 khung bản tin trong ngày: Đầu ca (tới 9h) · Hiện tại (9h–19h) · Kết ca (sau 19h)
enum KhungBanTin: Int, CaseIterable {
    case dauCa = 0
    case hienTai = 1
    case ketCa = 2

    var tieuDe: String {
        switch self {
        case .dauCa: return "☀️ Đầu ca"
        case .hienTai: return "⏱ Hiện tại"
        case .ketCa: return "🌙 Kết ca"
        }
    }

    var tenNgan: String {
        switch self {
        case .dauCa: return "ĐẦU CA"
        case .hienTai: return "HIỆN TẠI"
        case .ketCa: return "KẾT CA"
        }
    }

    /// Tự chọn khung theo giờ hiện tại: tới 9h = Đầu ca, 9h–19h = Hiện tại, sau 19h = Kết ca
    static func theoGio(_ luc: Date = Date()) -> KhungBanTin {
        let gio = TienIchNgay.lich.component(.hour, from: luc)
        if gio < 9 { return .dauCa }
        if gio < 19 { return .hienTai }
        return .ketCa
    }
}

enum GiongVanBanTin: Int, CaseIterable {
    case binhThuong = 0
    case cangThang = 1
    case thaoMai = 2

    var tieuDe: String {
        switch self {
        case .binhThuong: return "Bình thường"
        case .cangThang: return "Căng thẳng"
        case .thaoMai: return "Thảo mai"
        }
    }
}

// MARK: - Loại báo cáo trong mục "3. Xuất ảnh"

enum LoaiBaoCaoXuatAnh: Int, CaseIterable {
    case doanhThuThiDuaLuyKe = 0
    case luyKeDuKien = 1
    case doanhThuThiDuaRealtime = 2
    case xepHangNVLuyKe = 3
    case xepHangNVRealtime = 4
    case bieuDoSucKhoeNV = 5
    case bieuDoRealtimeThang = 6
    case chiTiet16NV = 7

    var tieuDeNgan: String {
        switch self {
        case .doanhThuThiDuaLuyKe: return "📊 Doanh thu & Thi đua Lũy kế"
        case .luyKeDuKien: return "📈 Lũy kế — % Dự kiến cuối tháng"
        case .doanhThuThiDuaRealtime: return "⚡ Doanh thu & Thi đua Realtime"
        case .xepHangNVLuyKe: return "👥 Bảng Xếp Hạng NV (Lũy kế)"
        case .xepHangNVRealtime: return "🔥 Bảng Xếp Hạng NV (Realtime)"
        case .bieuDoSucKhoeNV: return "❤️‍🩹 Biểu Đồ Sức Khỏe 16 NV"
        case .bieuDoRealtimeThang: return "📆 Biểu Đồ Realtime Tháng"
        case .chiTiet16NV: return "👤 Gộp Chi Tiết Tất Cả NV"
        }
    }

    var moTaPhu: String {
        switch self {
        case .doanhThuThiDuaLuyKe: return "8 thẻ Doanh thu Lũy kế + Bảng ngành hàng Thực hiện & Target"
        case .luyKeDuKien: return "8 thẻ Doanh thu Lũy kế + Bảng % Dự kiến hoàn thành cuối tháng"
        case .doanhThuThiDuaRealtime: return "8 thẻ Doanh thu Realtime + Bảng ngành hàng trong ngày"
        case .xepHangNVLuyKe: return "Xếp hạng Doanh thu QĐ & số môn hoàn thành Lũy kế của NV"
        case .xepHangNVRealtime: return "Xếp hạng Doanh thu QĐ & số môn Realtime trong ngày của NV"
        case .bieuDoSucKhoeNV: return "Biểu đồ sức khỏe 16 NV & Cảnh báo Top 5 NV cần hỗ trợ"
        case .bieuDoRealtimeThang: return "Biểu đồ cột Doanh thu Realtime các ngày trong tháng"
        case .chiTiet16NV: return "Ảnh tổng hợp chi tiết các môn thi đua của toàn bộ nhân viên"
        }
    }
}

// MARK: - Bộ số liệu dùng để viết bản tin

struct SoLieuBanTin {
    var ngay: Date
    var khung: KhungBanTin
    var tenDonVi: String
    var capNhatLuc: String
    var luyKe: ThongTinDoanhThu
    var dsLuyKe: [DongThiDua]
    var homNay: ThongTinDoanhThu
    var dsHomNay: [DongThiDua]
    var nhanVien: [TongHopNhanVien]
    var homNayNV: [DoanhThuNhanVienItem]
    /// true = số Lũy kế đầu ca hôm nay chưa có, đang tính tạm từ (Lũy kế hôm qua + Realtime kết ca hôm qua)
    var tamTinh: Bool
    var soNgayTrongThang: Int
    var ngayTrongThang: Int

    /// Số ngày còn lại để chạy tới cuối tháng (đầu ca / hiện tại: tính cả hôm nay; kết ca: không tính hôm nay)
    var soNgayConLai: Int {
        let con = (khung == .ketCa) ? (soNgayTrongThang - ngayTrongThang) : (soNgayTrongThang - ngayTrongThang + 1)
        return max(1, con)
    }

    var coSoLieuLuyKe: Bool {
        luyKe.coDuLieu || !dsLuyKe.isEmpty
    }

    var coSoLieuHomNay: Bool {
        homNay.coDuLieu || !dsHomNay.isEmpty
    }
}

// MARK: - Gói JSON để chuyển sang Copilot hoặc ứng dụng AI khác tạo file

enum GoiDuLieuXuatAI {
    static func tao(soLieu s: SoLieuBanTin, noiDungBaoCao: String, yeuCau: String) -> String {
        func doanhThu(_ d: ThongTinDoanhThu) -> [String: Any] {
            [
                "doanh_thu_thuc": d.doanhThuThuc,
                "target_thuc": d.targetThuc,
                "du_kien_thuc": d.duKienThuc,
                "phan_tram_hoan_thanh_thuc": d.phanTramHTThucHienThi,
                "doanh_thu_quy_doi": d.doanhThuQuyDoi,
                "target_quy_doi": d.targetQuyDoi,
                "du_kien_quy_doi": d.duKienQuyDoi,
                "phan_tram_hoan_thanh_quy_doi": d.phanTramHTQDDuKienHienThi,
                "phan_tram_tra_gop": d.phanTramTraGop,
                "luot_khach": d.luotKhach,
                "so_bill": d.soBill
            ]
        }
        func nganhHang(_ ds: [DongThiDua]) -> [[String: Any]] {
            ds.map {
                [
                    "ten": $0.tenNganhHang,
                    "don_vi": $0.loaiChiTieu.maBang,
                    "thuc_hien": $0.thucHien,
                    "target": $0.target,
                    "phan_tram_hien_tai": $0.phanTramHT,
                    "du_kien": $0.duKien,
                    "phan_tram_du_kien": $0.phanTramDuBao
                ]
            }
        }
        let nhanVien: [[String: Any]] = s.nhanVien.map {
            [
                "ma_nhan_vien": $0.nhanVien.maNV,
                "ho_ten": $0.nhanVien.hoTen,
                "so_mon_dat": $0.soMonDat,
                "tong_mon_giao": $0.tongMonGiao,
                "phan_tram_hoan_thanh_trung_binh": $0.phanTramHTTB,
                "so_luong": $0.soLuongDon,
                "doanh_thu_quy_doi": $0.doanhThuQD,
                "doanh_thu_khoan_vay": $0.dtQDKhoanVay,
                "phan_tram_ti_trong": $0.phanTramTiTrong
            ]
        }
        let yeuCauSach = yeuCau.trimmingCharacters(in: .whitespacesAndNewlines)
        let cauLenh = """
        Hãy dùng toàn bộ dữ liệu JSON bên dưới để tạo file Excel hoặc PowerPoint theo yêu cầu của tôi. Giữ nguyên số âm, số 0, phần trăm và tên nhân viên/ngành hàng; không tự bịa số liệu. Excel cần có bảng rõ ràng, tiêu đề, định dạng số, bộ lọc và biểu đồ phù hợp. PowerPoint cần trình bày ngắn gọn, dễ đọc, có bảng/biểu đồ và kết luận hành động. Khi hoàn tất, hãy cung cấp file để tải xuống.
        Yêu cầu riêng: \(yeuCauSach.isEmpty ? "Tự chọn bố cục chuyên nghiệp và phân tích toàn diện." : yeuCauSach)
        """
        let goi: [String: Any] = [
            "cau_lenh": cauLenh,
            "yeu_cau_nguoi_dung": yeuCauSach,
            "noi_dung_bao_cao_hien_tai": noiDungBaoCao,
            "du_lieu": [
                "ngay": TienIchNgay.khoa.string(from: s.ngay),
                "khung_bao_cao": s.khung.tenNgan,
                "don_vi": s.tenDonVi,
                "cap_nhat_luc": s.capNhatLuc,
                "luy_ke": doanhThu(s.luyKe),
                "nganh_hang_luy_ke": nganhHang(s.dsLuyKe),
                "realtime": doanhThu(s.homNay),
                "nganh_hang_realtime": nganhHang(s.dsHomNay),
                "nhan_vien": nhanVien
            ]
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: goi, options: [.prettyPrinted, .sortedKeys]),
              let json = String(data: data, encoding: .utf8) else { return "{}" }
        return json
    }
}

extension KhoDuLieu {
    /// Gom số liệu cho bản tin. Đầu ca chưa có số hôm nay → tự dựng "Đầu ca tạm tính".
    func taoSoLieuBanTin(cho ngay: Date, khung: KhungBanTin) -> SoLieuBanTin {
        let lich = TienIchNgay.lich
        let dl = duLieu(cho: ngay)
        let soNgay = soNgayTrongThang(cho: ngay)
        let ngayTrongThang = lich.component(.day, from: ngay)

        var luyKe = dl.doanhThu
        var dsLuyKe = danhSachMatHangThang(den: ngay, cheDo: .luyKe)
        var tamTinh = false

        if khung == .dauCa, ngayTrongThang > 1, lich.isDateInToday(ngay) {
            let khoaHomNay = TienIchNgay.khoa.string(from: ngay)
            let homNay = cacNgay[khoaHomNay]
            let homNayDaCo = (homNay?.doanhThu.coDuLieu ?? false) || !(homNay?.danhSachThiDua.isEmpty ?? true)
            if !homNayDaCo, let homQua = lich.date(byAdding: .day, value: -1, to: ngay) {
                let khoaQua = TienIchNgay.khoa.string(from: homQua)
                if let q = cacNgay[khoaQua], q.doanhThu.coDuLieu, q.doanhThuRealtime.coDuLieu {
                    let daQua = Double(max(1, ngayTrongThang - 1))
                    let tong = Double(soNgay)

                    var lk = q.doanhThu
                    lk.doanhThuThuc += q.doanhThuRealtime.doanhThuThuc
                    lk.doanhThuQuyDoi += q.doanhThuRealtime.doanhThuQuyDoi
                    if lk.phanTramHTThuc > 0, lk.targetThuc > 0 {
                        lk.phanTramHTThuc = lk.doanhThuThuc / lk.targetThuc * 100.0
                    }
                    lk.duKienThuc = lk.doanhThuThuc / daQua * tong
                    lk.duKienQuyDoi = lk.doanhThuQuyDoi / daQua * tong
                    if lk.targetQuyDoi > 0 {
                        lk.phanTramHTQuyDoi = lk.duKienQuyDoi / lk.targetQuyDoi * 100.0
                    }
                    lk.soNgayDaQua = Int(daQua)
                    lk.tongSoNgay = soNgay
                    lk.phanTramTienDoThang = daQua / tong * 100.0

                    var dsTam: [DongThiDua] = []
                    for d in q.danhSachThiDua {
                        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(d.tenNganhHang)
                        var them: Double = 0
                        for r in q.danhSachThiDuaRealtime where KhoDuLieu.chuanHoaKhoaSoSanh(r.tenNganhHang) == khoa {
                            them = r.thucHien
                            break
                        }
                        let thucHien = d.thucHien + them
                        let duKien = thucHien / daQua * tong
                        let phanTramHT: Double? = d.target > 0 ? (thucHien / d.target * 100.0) : nil
                        let phanTramDuBao: Double? = d.target > 0 ? (duKien / d.target * 100.0) : nil
                        let dong = DongThiDua(
                            tenNganhHangGoc: d.tenNganhHangGoc,
                            tenNganhHang: d.tenNganhHang,
                            loaiChiTieu: d.loaiChiTieu,
                            thucHien: thucHien,
                            target: d.target,
                            phanTramHTGoc: phanTramHT,
                            phanTramDuBaoGoc: phanTramDuBao,
                            duKienGoc: duKien
                        )
                        dsTam.append(dong)
                    }
                    luyKe = lk
                    dsLuyKe = dsTam
                    tamTinh = true
                }
            }
        }

        return SoLieuBanTin(
            ngay: ngay,
            khung: khung,
            tenDonVi: dl.thongTinDonVi,
            capNhatLuc: dl.capNhatLuc,
            luyKe: luyKe,
            dsLuyKe: dsLuyKe,
            homNay: dl.doanhThuRealtime,
            dsHomNay: dl.danhSachThiDuaRealtime,
            nhanVien: tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe),
            homNayNV: dl.doanhThuNhanVienRealtime,
            tamTinh: tamTinh,
            soNgayTrongThang: soNgay,
            ngayTrongThang: ngayTrongThang
        )
    }
}

// MARK: - Bộ sinh số ngẫu nhiên theo hạt giống

struct BoSinhNgauNhien: RandomNumberGenerator {
    private var trangThai: UInt64

    init(hatGiong: String) {
        var h: UInt64 = 1469598103934665603
        for byte in hatGiong.utf8 {
            h ^= UInt64(byte)
            h = h &* 1099511628211
        }
        trangThai = h
    }

    mutating func next() -> UInt64 {
        trangThai = trangThai &+ 0x9E3779B97F4A7C15
        var z = trangThai
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

// MARK: - Bộ viết bài Phân tích (theo đúng mẫu đính kèm & cho từng loại ảnh xuất)

final class BoVietBanTin {
    private var rng: BoSinhNgauNhien
    private let s: SoLieuBanTin
    private let giong: GiongVanBanTin

    private struct LoiDan {
        var mo: String
        var viec: String
        var duoiTapTrung: String
        var ket: String
    }

    /// Việc cụ thể theo nhóm hàng: (từ khóa, việc làm)
    private static let bangViec: [([String], String)] = [
        (["sim"], "mời 100% khách mua máy lấy sim, để sẵn bộ sim + bảng giá gói cước ngay quầy thu ngân"),
        (["bao hiem"], "chào bảo hiểm cho mọi đơn máy từ 3 triệu, nói rõ quyền lợi rơi vỡ – vào nước trong 1 câu"),
        (["phu kien", "cap", "sac", "tai nghe", "op", "dan"], "giao máy là đưa combo phụ kiện ra bàn: ốp + dán + sạc, báo giá combo thay vì từng món"),
        (["tra cham", "tra gop", "vay", "the tin dung", "vi tra sau", "homecredit", "fecredit"], "khách chê giá hoặc phân vân thì mời ngay trả chậm 0%, tính sẵn số tiền mỗi tháng để khách dễ gật"),
        (["laptop", "tablet", "dong ho", "camera", "may doc sach"], "mời khách trải nghiệm máy trưng bày, demo tính năng chính trong 2 phút"),
        (["iphone"], "chủ động gợi ý đổi máy cũ lên iPhone, báo giá thu cũ ngay tại quầy"),
        (["vas", "nap", "rut", "tai khoan"], "mời khách nạp/rút tiền, mở tài khoản ngay lúc chờ thanh toán"),
        (["dien thoai"], "đón khách ở khu điện thoại, so sánh 2 mẫu cùng tầm giá để khách chốt nhanh"),
        (["tivi", "tu lanh", "may giat", "may lanh", "gia dung", "loc nuoc"], "tư vấn gói trả chậm 0% + ưu đãi lắp đặt miễn phí trong ngày để chốt đơn nhanh")
    ]

    init(soLieu: SoLieuBanTin, giong: GiongVanBanTin, bienThe: Int = 0) {
        self.s = soLieu
        self.giong = giong
        let khoa = TienIchNgay.khoa.string(from: soLieu.ngay)
        self.rng = BoSinhNgauNhien(hatGiong: "\(khoa)|\(soLieu.khung.rawValue)|\(giong.rawValue)|\(soLieu.tenDonVi)|\(bienThe)")
    }

    func viet() -> String {
        return vietTheoMauAnhChup(nhomTapTrung: [], nvTapTrung: [])
    }

    /// Viết bản tin đúng chuẩn mẫu ảnh chụp đính kèm (1..5 có đánh số, in đậm đầu mục, lọc theo chip Nhóm hàng & Nhân viên tập trung)
    func vietTheoMauAnhChup(nhomTapTrung: Set<String> = [], nvTapTrung: Set<String> = []) -> String {
        let dfNgay = DateFormatter()
        dfNgay.dateFormat = "dd/MM/yyyy"
        let ngayStr = dfNgay.string(from: s.ngay)

        let dfGio = DateFormatter()
        dfGio.dateFormat = "HH:mm"
        let gioStr = s.capNhatLuc.isEmpty ? dfGio.string(from: Date()) : s.capNhatLuc
        let donViStr = s.tenDonVi.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "ĐMX"
            : s.tenDonVi.trimmingCharacters(in: .whitespacesAndNewlines)

        let lk = s.luyKe
        let rt = s.homNay
        let dungQD = lk.targetQuyDoi > 0 || lk.doanhThuQuyDoi > 0
        let dtLK = dungQD ? lk.doanhThuQuyDoi : lk.doanhThuThuc
        let tgLK = dungQD ? lk.targetQuyDoi : lk.targetThuc
        let ptHTLK: Double = {
            if tgLK > 0 { return dtLK / tgLK * 100.0 }
            return lk.phanTramHTQDDuKienHienThi
        }()
        let dtRT = (rt.doanhThuQuyDoi > 0) ? rt.doanhThuQuyDoi : rt.doanhThuThuc

        let dsLK = dongCoTarget(s.dsLuyKe)
        let dsRT = dongCoTarget(s.dsHomNay)
        let nguonNganh = !dsLK.isEmpty ? dsLK : dsRT

        // 2) Nhóm hàng bán tốt (đạt >= 100% dự kiến hoặc có % hoàn thành cao nhất)
        let nhomTot = nguonNganh
            .sorted { $0.phanTramDuBao > $1.phanTramDuBao }
            .filter { $0.phanTramDuBao >= 95.0 || $0.phanTramHT >= 85.0 }
            .prefix(6)

        // 3) Nhóm hàng tập trung — gần đạt target (còn thiếu ít) hoặc do người dùng chọn chip
        let nhomGanDat: [DongThiDua] = {
            if !nhomTapTrung.isEmpty {
                let daChon = nguonNganh.filter { nhomTapTrung.contains($0.tenNganhHang) }
                if !daChon.isEmpty { return Array(daChon.prefix(6)) }
            }
            let gan = nguonNganh
                .filter { $0.phanTramHT < 100.0 && $0.target > $0.thucHien }
                .sorted { $0.phanTramHT > $1.phanTramHT }
            return Array(gan.prefix(5))
        }()

        // 4) Ghi nhận nhân viên bán tốt
        let dsNVLuyKe = KhoDuLieu.dungChung.duLieu(cho: s.ngay).doanhThuNhanVien
        let dsNVRealtime = s.homNayNV
        var dongNVTot: [String] = []

        let topNVLK = dsNVLuyKe.filter { $0.doanhThuQD > 0 }.sorted { $0.doanhThuQD > $1.doanhThuQD }.prefix(4)
        for nv in topNVLK {
            let tenRutGon = rutGonHoTenNV(nv.hoTen, maNV: nv.maNV)
            let dtThuc = nv.doanhThuThuc > 0 ? " (DT thực \(Int(nv.doanhThuThuc.rounded())) tr)" : ""
            dongNVTot.append("- **\(tenRutGon)**: Doanh thu QĐ lũy kế **\(Int(nv.doanhThuQD.rounded())) triệu**\(dtThuc).")
        }

        if dongNVTot.isEmpty {
            let topNVThiDua = s.nhanVien
                .filter { $0.tongMonGiao > 0 }
                .sorted { ($0.soMonDat, $0.phanTramHTTB) > ($1.soMonDat, $1.phanTramHTTB) }
                .prefix(4)
            for nv in topNVThiDua {
                let tenRutGon = rutGonHoTenNV(nv.nhanVien.hoTen, maNV: nv.nhanVien.maNV)
                dongNVTot.append("- **\(tenRutGon)**: Hoàn thành **\(nv.soMonDat)/\(nv.tongMonGiao) môn** thi đua (TB **\(nv.phanTramHTTB.chuoiPhanTram)**).")
            }
        }

        let topNVRT = dsNVRealtime.filter { $0.doanhThuQD > 0 }.sorted { $0.doanhThuQD > $1.doanhThuQD }.prefix(2)
        for nv in topNVRT {
            let tenRutGon = rutGonHoTenNV(nv.hoTen, maNV: nv.maNV)
            dongNVTot.append("- **\(tenRutGon)** (Realtime hôm nay): **\(nv.doanhThuQD.chuoiSoGonVN) triệu** QĐ.")
        }

        var L: [String] = []
        L.append("THÔNG BÁO TÌNH HÌNH KINH DOANH ĐẾN NGÀY \(ngayStr) — \(donViStr) lúc \(gioStr)")
        L.append("")

        if giong == .cangThang {
            L.append("⚠️ Anh chị em chú ý đọc kỹ số liệu và tập trung đẩy số ngay trong ca:")
            L.append("")
        } else if giong == .thaoMai {
            L.append("🌸 Cả nhà iu ơi, mình cùng điểm qua tình hình kinh doanh của siêu thị để cùng về đích thật rực rỡ nha ♥")
            L.append("")
        }

        // Mục 1
        L.append("1) **Doanh thu hiện tại so với lũy kế / target**:")
        if s.coSoLieuLuyKe {
            L.append("- Doanh thu lũy kế: **\(dtLK.chuoiSoNguyenVN) triệu**")
            L.append("- Target: **\(tgLK.chuoiSoNguyenVN) triệu**")
            L.append("- % hoàn thành: **\(String(format: "%.0f%%", ptHTLK))** (Dự kiến cuối tháng: **\(lk.phanTramHTQDDuKienHienThi.chuoiPhanTram)**)")
        } else {
            L.append("- Doanh thu lũy kế: Chưa nhập ảnh Doanh thu lũy kế hôm nay")
        }
        if dtRT > 0 {
            let tgNgay = rt.targetQuyDoi > 0 ? " / target ngày **\(rt.targetQuyDoi.chuoiSoGonVN) triệu** (**\(rt.phanTramHTQDDuKienHienThi.chuoiPhanTram)**)" : ""
            L.append("- Doanh thu Realtime: **\(dtRT.chuoiSoGonVN) triệu**\(tgNgay)")
        } else {
            L.append("- Doanh thu Realtime: **0 triệu** (cần cập nhật đơn phát sinh trong ca)")
        }
        L.append("")

        // Mục 2
        L.append("2) **Nhóm hàng bán tốt** (lũy kế đến hôm qua):")
        if !nhomTot.isEmpty {
            for d in nhomTot {
                let dvt = d.loaiChiTieu == .soLuong ? "cái" : "triệu"
                L.append("- **\(d.tenNganhHang)**: lũy kế **\(d.thucHien.chuoiSoGonVN)** / target **\(d.target.chuoiSoGonVN) \(dvt)** — đạt **\(String(format: "%.0f%%", d.phanTramHT))** (dự kiến **\(String(format: "%.0f%%", d.phanTramDuBao))**)")
            }
        } else if !nguonNganh.isEmpty {
            for d in nguonNganh.sorted(by: { $0.phanTramHT > $1.phanTramHT }).prefix(4) {
                L.append("- **\(d.tenNganhHang)**: thực hiện **\(d.thucHien.chuoiSoGonVN)** / target **\(d.target.chuoiSoGonVN)** (**\(String(format: "%.0f%%", d.phanTramHT))**)")
            }
        } else {
            L.append("- Chưa có dữ liệu bảng ngành hàng thi đua. Vui lòng vào mục **Nhập số** để quét ảnh.")
        }
        L.append("")

        // Mục 3
        L.append("3) **Nhóm hàng tập trung — gần đạt target** (còn thiếu ít):")
        if !nhomGanDat.isEmpty {
            for d in nhomGanDat {
                let thieu = max(0, d.target - d.thucHien)
                L.append("- **\(d.tenNganhHang)**: đạt **\(String(format: "%.0f%%", d.phanTramHT))** (\(d.thucHien.chuoiSoGonVN)/\(d.target.chuoiSoGonVN)), chỉ còn thiếu **\(thieu.chuoiSoGonVN)** để cán mốc 100%")
            }
        } else {
            L.append("- Các nhóm ngành trọng tâm đang bám sát tiến độ, tiếp tục duy trì tư vấn combo phụ kiện, trả chậm và bảo hiểm.")
        }
        L.append("")

        // Mục 4
        L.append("4) **Ghi nhận nhân viên bán tốt**:")
        if !dongNVTot.isEmpty {
            L.append(contentsOf: dongNVTot)
        } else {
            L.append("- Ghi nhận tinh thần chủ động đón khách và tư vấn nhiệt tình của tập thể nhân viên trong ca.")
        }
        L.append("")

        // Mục 5
        L.append("5) **Trọng tâm tập trung trong ca**:")
        if !nhomTapTrung.isEmpty {
            for tenNhom in nhomTapTrung.sorted() {
                let goiY = vietHoaDau(hanhDong(cho: tenNhom))
                L.append("- Tập trung đẩy **\(tenNhom)**: \(goiY).")
            }
        } else if let dau = nhomGanDat.first {
            L.append("- Ưu tiên chốt dứt điểm các nhóm sát đích (**\(dau.tenNganhHang)**): \(hanhDong(cho: dau.tenNganhHang)).")
        }

        if !nvTapTrung.isEmpty {
            let dsTen = nvTapTrung.sorted().joined(separator: ", ")
            L.append("- Nhân sự trọng tâm cần bứt tốc trong ca: **\(dsTen)** — chủ động bám sát mục tiêu cá nhân và báo đơn ngay khi phát sinh.")
        } else {
            let nvCanHoTro = s.nhanVien
                .filter { $0.tongMonGiao > 0 && $0.phanTramHTTB < 90 }
                .sorted { $0.phanTramHTTB < $1.phanTramHTTB }
                .prefix(3)
            if !nvCanHoTro.isEmpty {
                let dsTen = nvCanHoTro.map { ten($0.nhanVien.hoTen) }.joined(separator: ", ")
                L.append("- Nhắc nhở các bạn **\(dsTen)** tập trung khai thác các môn còn 0 và tận dụng tối đa lượt khách vào quầy.")
            }
        }

        switch giong {
        case .cangThang:
            L.append("- Yêu cầu 100% nhân sự bám sát chỉ tiêu, không để môn thi đua bằng 0, cuối ca Quản lý rà soát trực tiếp từng bạn!")
        case .thaoMai:
            L.append("- Cả nhà mình cùng cố gắng thêm một chút nữa để chiều tối nay bảng số xanh mướt hết nha, yêu cả nhà nhiều ♥")
        case .binhThuong:
            L.append("- Toàn siêu thị chủ động đón khách trong 5 giây, tư vấn kèm Phụ kiện + Sim + Bảo hiểm để hoàn thành vượt mức Target hôm nay!")
        }

        return L.joined(separator: "\n")
    }

    private func rutGonHoTenNV(_ hoTen: String, maNV: String) -> String {
        let sach = hoTen.trimmingCharacters(in: .whitespacesAndNewlines)
        if maNV.isEmpty || sach.contains(maNV) {
            return sach
        }
        return "\(maNV) - \(sach)"
    }

    /// Tạo nội dung phân tích tương ứng cho từng nút trong mục "3. Xuất ảnh"
    static func taoNoiDungBaoCao(loai: LoaiBaoCaoXuatAnh, ngay: Date, giong: GiongVanBanTin = .binhThuong) -> String {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngay, khung: KhungBanTin.theoGio())
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let donVi = dl.thongTinDonVi.isEmpty ? "Siêu thị ĐMX" : dl.thongTinDonVi

        switch loai {
        case .doanhThuThiDuaLuyKe:
            return BoVietBanTin(soLieu: s, giong: giong).vietTheoMauAnhChup()

        case .luyKeDuKien:
            let dt = dl.doanhThu
            let ds = dl.danhSachThiDua.filter { $0.target > 0 }
            let dat = ds.filter { $0.phanTramDuBao >= 100 }.sorted { $0.phanTramDuBao > $1.phanTramDuBao }
            let gan = ds.filter { $0.phanTramDuBao >= 85 && $0.phanTramDuBao < 100 }.sorted { $0.phanTramDuBao > $1.phanTramDuBao }
            let yeu = ds.filter { $0.phanTramDuBao < 85 }.sorted { $0.phanTramDuBao < $1.phanTramDuBao }

            var L: [String] = [
                "📈 BÁO CÁO LŨY KẾ & % DỰ KIẾN CUỐI THÁNG — \(donVi) (\(ngayStr))",
                "",
                "1) Tổng quan Doanh thu Lũy kế:",
                "• Doanh thu Thực: \(dt.doanhThuThuc.chuoiSoGonVN) / Target \(dt.targetThuc.chuoiSoGonVN) triệu",
                "• Doanh thu Quy đổi: \(dt.doanhThuQuyDoi.chuoiSoGonVN) / Target \(dt.targetQuyDoi.chuoiSoGonVN) triệu",
                "• Dự kiến hoàn thành cuối tháng: \(dt.phanTramHTQDDuKienHienThi.chuoiPhanTram) (Số ngành đạt dự kiến: \(dat.count)/\(ds.count) ngành)",
                ""
            ]
            if !dat.isEmpty {
                L.append("2) Nhóm ngành vượt / đạt dự kiến tốt (>= 100%):")
                for d in dat.prefix(5) {
                    L.append("- \(d.tenNganhHang): TH \(d.thucHien.chuoiSoGonVN)/\(d.target.chuoiSoGonVN) → Dự kiến \(d.phanTramDuBao.chuoiPhanTram)")
                }
                L.append("")
            }
            if !gan.isEmpty {
                L.append("3) Nhóm ngành sát đích (85% – 99%):")
                for d in gan.prefix(5) {
                    L.append("- \(d.tenNganhHang): Dự kiến \(d.phanTramDuBao.chuoiPhanTram) (cần đẩy nhẹ mỗi ngày)")
                }
                L.append("")
            }
            if !yeu.isEmpty {
                L.append("4) Nhóm ngành cần tập trung bứt tốc (< 85%):")
                for d in yeu.prefix(5) {
                    L.append("- \(d.tenNganhHang): Dự kiến \(d.phanTramDuBao.chuoiPhanTram) (TH \(d.thucHien.chuoiSoGonVN)/\(d.target.chuoiSoGonVN))")
                }
            }
            return L.joined(separator: "\n")

        case .doanhThuThiDuaRealtime:
            let rt = dl.doanhThuRealtime
            let ds = dl.danhSachThiDuaRealtime.filter { $0.target > 0 }
            let dat = ds.filter { $0.phanTramHT >= 100 }
            let coSo = ds.filter { $0.thucHien > 0 && $0.phanTramHT < 100 }.sorted { $0.phanTramHT > $1.phanTramHT }
            let bangKhong = ds.filter { $0.thucHien <= 0 }

            var L: [String] = [
                "⚡ BÁO CÁO NHANH REALTIME TRONG NGÀY — \(donVi) (\(ngayStr) \(dl.capNhatLuc))",
                "",
                "1) Doanh thu Realtime trong ngày:",
                "• Doanh thu Thực: \(rt.doanhThuThuc.chuoiSoGonVN) triệu",
                "• Doanh thu Quy đổi: \(rt.doanhThuQuyDoi.chuoiSoGonVN) / Target ngày \(rt.targetQuyDoi.chuoiSoGonVN) triệu (\(rt.phanTramHTQDDuKienHienThi.chuoiPhanTram))",
                "• Số ngành đạt target ngày: \(dat.count)/\(ds.count) ngành",
                ""
            ]
            if !dat.isEmpty {
                L.append("2) Ngành hàng đã hoàn thành target ngày:")
                for d in dat.prefix(5) {
                    L.append("- \(d.tenNganhHang): \(d.thucHien.chuoiSoGonVN)/\(d.target.chuoiSoGonVN) (\(d.phanTramHT.chuoiPhanTram))")
                }
                L.append("")
            }
            if !coSo.isEmpty {
                L.append("3) Ngành hàng đang chạy số — cần chốt thêm:")
                for d in coSo.prefix(5) {
                    let thieu = max(0, d.target - d.thucHien)
                    L.append("- \(d.tenNganhHang): \(d.thucHien.chuoiSoGonVN)/\(d.target.chuoiSoGonVN) (\(d.phanTramHT.chuoiPhanTram)) — còn thiếu \(thieu.chuoiSoGonVN)")
                }
                L.append("")
            }
            if !bangKhong.isEmpty {
                L.append("4) Ngành hàng đang bằng 0 (ưu tiên mở điểm ngay trong ca):")
                L.append("- " + bangKhong.prefix(8).map(\.tenNganhHang).joined(separator: ", "))
            }
            return L.joined(separator: "\n")

        case .xepHangNVLuyKe, .xepHangNVRealtime:
            let cheDo: LoaiCheDoDoanhThu = (loai == .xepHangNVLuyKe) ? .luyKe : .realtime
            let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: cheDo)
            let dsDT = dl.doanhThuNhanVien(theo: cheDo).sorted { $0.doanhThuQD > $1.doanhThuQD }

            var L: [String] = [
                "👥 BẢNG XẾP HẠNG NHÂN VIÊN (\(cheDo.tieuDe.uppercased())) — \(donVi) (\(ngayStr))",
                ""
            ]
            if !dsDT.isEmpty {
                L.append("1) Top Doanh thu Quy đổi (\(cheDo.tieuDe)):")
                for (i, nv) in dsDT.prefix(6).enumerated() {
                    L.append("  \(i + 1). \(nv.hoTen): \(nv.doanhThuQD.chuoiSoGonVN) triệu QĐ (Thực: \(nv.doanhThuThuc.chuoiSoGonVN) tr • QĐ: \(nv.phanTramQuyDoi.chuoiPhanTram))")
                }
                L.append("")
            }
            if !dsNV.isEmpty {
                L.append("2) Xếp hạng hoàn thành môn Thi đua (\(cheDo.tieuDe)):")
                for (i, nv) in dsNV.prefix(6).enumerated() {
                    L.append("  \(i + 1). \(nv.nhanVien.hoTen): \(nv.soMonDat)/\(nv.tongMonGiao) môn đạt • TB \(nv.phanTramHTTB.chuoiPhanTram)")
                }
                let yeu = dsNV.suffix(3)
                if !yeu.isEmpty {
                    L.append("")
                    L.append("3) Nhân sự cần tập trung đẩy thêm các môn còn thiếu:")
                    for nv in yeu {
                        L.append("- \(nv.nhanVien.hoTen): đạt \(nv.soMonDat)/\(nv.tongMonGiao) môn (TB \(nv.phanTramHTTB.chuoiPhanTram))")
                    }
                }
            }
            return L.joined(separator: "\n")

        case .bieuDoSucKhoeNV:
            let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe)
            let topManh = dsNV.prefix(3)
            let topYeu = dsNV.sorted { $0.phanTramHTTB < $1.phanTramHTTB }.prefix(5)

            var L: [String] = [
                "❤️‍🩹 BÁO CÁO BIỂU ĐỒ SỨC KHỎE NHÂN VIÊN — \(donVi) (\(ngayStr))",
                "",
                "1) Nhân sự dẫn đầu phong trào thi đua:"
            ]
            for nv in topManh {
                L.append("- \(nv.nhanVien.hoTen): \(nv.soMonDat)/\(nv.tongMonGiao) môn đạt • TB \(nv.phanTramHTTB.chuoiPhanTram)")
            }
            L.append("")
            L.append("2) Top 5 nhân sự cần kèm cặp & hỗ trợ đẩy số ngay trong ca:")
            for nv in topYeu {
                let monKhong = nv.cacMonGiao.filter { $0.thucHien <= 0 }.count
                L.append("- \(nv.nhanVien.hoTen): TB \(nv.phanTramHTTB.chuoiPhanTram) (\(nv.soMonDat)/\(nv.tongMonGiao) môn đạt, còn \(monKhong) môn = 0)")
            }
            L.append("")
            L.append("3) Trọng tâm hành động: Quản lý ca phân công kèm cặp trực tiếp các môn = 0 trong hôm nay.")
            return L.joined(separator: "\n")

        case .bieuDoRealtimeThang:
            let dsNgay = KhoDuLieu.dungChung.danhSachRealtimeTheoNgayTrongThang(cho: ngay).filter(\.coDuLieu)
            let tongQD = dsNgay.map(\.doanhThuQuyDoi).reduce(0, +)
            let tongThuc = dsNgay.map(\.doanhThuThuc).reduce(0, +)
            let tbQD = dsNgay.isEmpty ? 0 : tongQD / Double(dsNgay.count)
            let caoNhat = dsNgay.max(by: { $0.doanhThuQuyDoi < $1.doanhThuQuyDoi })

            var L: [String] = [
                "📆 TỔNG HỢP BIỂU ĐỒ DOANH THU REALTIME THÁNG — \(donVi) (đến \(ngayStr))",
                "",
                "• Số ngày đã cập nhật Realtime: \(dsNgay.count) ngày",
                "• Tổng Doanh thu Thực các ngày: \(tongThuc.chuoiSoGonVN) triệu",
                "• Tổng Doanh thu Quy đổi các ngày: \(tongQD.chuoiSoGonVN) triệu (Trung bình: \(tbQD.chuoiSoGonVN) triệu/ngày)"
            ]
            if let maxD = caoNhat {
                L.append("• Ngày cao điểm nhất: Ngày \(maxD.ngayTrongThang) đạt \(maxD.doanhThuQuyDoi.chuoiSoGonVN) triệu QĐ (\(maxD.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram))")
            }
            L.append("• Cả siêu thị tiếp tục duy trì nhịp độ chốt đơn đều đặn ở tất cả các khung giờ!")
            return L.joined(separator: "\n")

        case .chiTiet16NV:
            let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe)
            var L: [String] = [
                "👤 TỔNG HỢP CHI TIẾT THI ĐUA CÁ NHÂN (\(dsNV.count) NHÂN VIÊN) — \(ngayStr)",
                ""
            ]
            for (i, nv) in dsNV.enumerated() {
                let monYeu = nv.cacMonGiao.filter { $0.phanTramHT < 80 }.prefix(2).map(\.tenNganhHang).joined(separator: ", ")
                let ghiChuYeu = monYeu.isEmpty ? "Đều các môn" : "Cần đẩy: \(monYeu)"
                L.append("\(i + 1). \(nv.nhanVien.hoTen): \(nv.soMonDat)/\(nv.tongMonGiao) môn đạt (TB \(nv.phanTramHTTB.chuoiPhanTram)) — \(ghiChuYeu)")
            }
            return L.joined(separator: "\n")
        }
    }

    // MARK: Tiện ích

    private func chon(_ cacMau: [String]) -> String {
        cacMau.randomElement(using: &rng) ?? ""
    }

    private func ten(_ hoTen: String) -> String {
        hoTen.split(separator: " ").last.map { String($0) } ?? hoTen
    }

    private func vietHoaDau(_ chu: String) -> String {
        guard let dau = chu.first else { return chu }
        return String(dau).uppercased() + chu.dropFirst()
    }

    private func khongDau(_ chu: String) -> String {
        KhoDuLieu.chuanHoaKhoaSoSanh(chu).lowercased()
    }

    private func hanhDong(cho nhom: String) -> String {
        let g = " " + khongDau(nhom) + " "
        for (cacKhoa, viec) in Self.bangViec {
            for khoa in cacKhoa {
                let trung = khoa.count <= 3 ? g.contains(" " + khoa + " ") : g.contains(khoa)
                if trung { return viec }
            }
        }
        return "đưa \(nhom) vào lời chào đầu tiên với mỗi khách, mục tiêu ít nhất 1 đơn trong ca"
    }

    private func dongCoTarget(_ ds: [DongThiDua]) -> [DongThiDua] {
        ds.filter { $0.target > 0.0001 }
    }
}


// MARK: - Hồ sơ Báo cáo Chi tiết AI Gemini (Dùng để tạo file Excel .xlsx & PowerPoint .pptx chuẩn chuyên gia)

struct HangMucHanhDongAI: Codable {
    var hangMuc: String
    var mucTieuSoLieu: String
    var nguoiPhuTrach: String
    var thoiHan: String
    var mucUuTien: String
}

struct BangChuyenDeAI: Codable {
    var tenSheet: String
    var tieuDeBang: String
    var moTaNgan: String
    var cacCot: [String]
    var cacDong: [[String]]
    var ketLuanChuyenDe: String
}

struct HoSoBaoCaoOfficeAI: Codable {
    var tieuDeBaoCao: String
    var phuDeBaoCao: String
    var yeuCauNguoiDung: String
    var tomTatDieuHanh: String
    var phanTichTheoYeuCau: String
    var keHoachHanhDong: [HangMucHanhDongAI]
    var nhanXetNganhHang: [String: String]
    var nhanXetNhanVien: [String: String]
    var bangChuyenDe: BangChuyenDeAI?

    /// Tự động tổng hợp hồ sơ phân tích chuyên sâu (dùng làm nền tảng dữ liệu thật hoặc khi offline / hết hạn mức API)
    static func taoHoSoChuyenSauTuDuLieu(
        ngay: Date,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String
    ) -> HoSoBaoCaoOfficeAI {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let donVi = dl.thongTinDonVi.isEmpty ? "Siêu thị Điện Máy Xanh" : dl.thongTinDonVi
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngay, khung: KhungBanTin.theoGio())
        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngay, cheDoDangXem: .luyKe)
        let bcSucKhoe = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: .luyKe)
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe)

        let yeuCauSach = yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines)
        let tieuDe = yeuCauSach.isEmpty
            ? "BÁO CÁO ĐIỀU HÀNH KINH DOANH & THI ĐUA CHI TIẾT — \(donVi.uppercased())"
            : "BÁO CÁO PHÂN TÍCH CHUYÊN SÂU THEO YÊU CẦU — \(donVi.uppercased())"
        let phuDe = "Ngày số liệu: \(ngayStr) • Cập nhật: \(dl.capNhatLuc.isEmpty ? "Mới nhất" : dl.capNhatLuc) • Còn \(s.soNgayConLai) ngày về đích tháng"

        let dsLK = dl.danhSachThiDua.filter { $0.target > 0 }
        let soNganhDat = dsLK.filter { $0.phanTramDuBao >= 100 || $0.phanTramHT >= 100 }.count
        let nganhHutNang = dsLK.filter { $0.phanTramDuBao < 85 && $0.phanTramHT < 85 }
            .sorted { $0.phanTramDuBao < $1.phanTramDuBao }
        let nganhSatDich = dsLK.filter { ($0.phanTramDuBao >= 85 && $0.phanTramDuBao < 100) || ($0.phanTramHT >= 85 && $0.phanTramHT < 100) }
            .sorted { $0.phanTramDuBao > $1.phanTramDuBao }

        let dtLK = dl.doanhThu
        let dtRT = dl.doanhThuRealtime
        let tomTat = [
            "Lũy kế đến \(ngayStr), \(donVi) đạt Doanh thu Thực \(dtLK.doanhThuThuc.chuoiSoGonVN) tr / Target \(dtLK.targetThuc.chuoiSoGonVN) tr, Doanh thu Quy đổi \(dtLK.doanhThuQuyDoi.chuoiSoGonVN) tr / Target \(dtLK.targetQuyDoi.chuoiSoGonVN) tr (Dự kiến hoàn thành \(dtLK.phanTramHTQDDuKienHienThi.chuoiPhanTram), đạt \(soNganhDat)/\(dsLK.count) ngành hàng).",
            "Trong ngày (Realtime), Doanh thu QĐ đạt \(dtRT.doanhThuQuyDoi.chuoiSoGonVN) tr / Target ngày \(dtRT.targetQuyDoi.chuoiSoGonVN) tr (\(dtRT.phanTramHTQDDuKienHienThi.chuoiPhanTram)). Sức khỏe đội ngũ đạt trung bình \(String(format: "%.1f%%", bcSucKhoe.diemTrungBinhDoiNgu)) (\(bcSucKhoe.soNVKhoe) Khỏe • \(bcSucKhoe.soNVTrungBinh) Trung bình • \(bcSucKhoe.soNVYeu) Yếu)."
        ].joined(separator: " ")

        let phanTichYC: String
        if yeuCauSach.isEmpty {
            let tenHut = nganhHutNang.prefix(5).map { "\($0.tenNganhHang) (\($0.phanTramDuBao.chuoiPhanTram))" }.joined(separator: ", ")
            let tenYeu = bcSucKhoe.top5CanhBaoYeu.prefix(5).map { "\($0.nhanVien.hoTen) (\($0.chuoiCanhBaoYeu))" }.joined(separator: ", ")
            phanTichYC = [
                "1. Trọng tâm Ngành hàng: Khai thác tối đa nhóm sát đích (\(nganhSatDich.count) ngành) để kéo tỷ lệ hoàn thành chung; đồng thời chia nhỏ mục tiêu ngày cho nhóm đang hụt sâu: \(tenHut.isEmpty ? "Các ngành đang bám sát tiến độ" : tenHut).",
                "2. Trọng tâm Nhân sự: Kèm cặp trực tiếp nhóm nhân viên cảnh báo sức khỏe yếu liên tục (\(tenYeu.isEmpty ? "Đội ngũ duy trì ổn định" : tenYeu)), giao chỉ tiêu mở điểm tối thiểu 1–2 đơn/ca ở các mặt hàng đang bằng 0.",
                "3. Nhịp độ Realtime: Để cán đích mục tiêu tháng (\(duBao.mucTieuThang.chuoiSoGonVN) tr QĐ), trong \(s.soNgayConLai) ngày còn lại siêu thị cần duy trì bình quân tối thiểu \(max(0, (duBao.mucTieuThang - dtLK.doanhThuQuyDoi) / Double(max(1, s.soNgayConLai))).chuoiSoGonVN) tr QĐ/ngày."
            ].joined(separator: "\n")
        } else {
            let tenHut = nganhHutNang.prefix(4).map { "\($0.tenNganhHang) (thiếu \(max(0, $0.target - $0.thucHien).chuoiSoGonVN))" }.joined(separator: ", ")
            let tenTopNV = dsNV.prefix(3).map { "\($0.nhanVien.hoTen) (\($0.soMonDat)/\($0.tongMonGiao) môn)" }.joined(separator: ", ")
            let tenYeuNV = bcSucKhoe.top5CanhBaoYeu.prefix(3).map { "\($0.nhanVien.hoTen) (\($0.chuoiCanhBaoYeu))" }.joined(separator: ", ")
            phanTichYC = [
                "📌 PHÂN TÍCH TRỌNG TÂM",
                "• Phân tích dữ liệu thực tế: Lũy kế QĐ đạt \(dtLK.doanhThuQuyDoi.chuoiSoGonVN)/\(dtLK.targetQuyDoi.chuoiSoGonVN) tr (\(dtLK.phanTramHTQDDuKienHienThi.chuoiPhanTram)). Với \(s.soNgayConLai) ngày còn lại, định mức cần chạy mỗi ngày là \(max(0, (dtLK.targetQuyDoi - dtLK.doanhThuQuyDoi) / Double(max(1, s.soNgayConLai))).chuoiSoGonVN) tr QĐ/ngày.",
                "• Nhóm ngành trọng điểm cần xử lý ngay: \(tenHut.isEmpty ? "Tất cả ngành đang trong ngưỡng kiểm soát" : tenHut).",
                "• Phân bổ nhân sự thực thi: Nhân sự dẫn đầu làm nòng cốt (\(tenTopNV.isEmpty ? "Đang cập nhật" : tenTopNV)); Quản lý ca kèm sát nhóm cần hỗ trợ (\(tenYeuNV.isEmpty ? "Không có NV yếu kéo dài" : tenYeuNV))."
            ].joined(separator: "\n")
        }

        var mapNganh: [String: String] = [:]
        let ngayCon = Double(max(1, s.soNgayConLai))
        for d in dl.danhSachThiDua {
            let thieu = max(0, d.target - d.thucHien)
            let moiNgay = thieu / ngayCon
            let pt = d.phanTramDuBao > 0 ? d.phanTramDuBao : d.phanTramHT
            if pt >= 100 {
                mapNganh[d.tenNganhHang] = "✅ Đã đạt/vượt tiến độ (\(pt.chuoiPhanTram)). Tiếp tục giữ nhịp bán kèm để bù chéo cho ngành đang thiếu."
            } else if pt >= 85 {
                mapNganh[d.tenNganhHang] = "⚡ Sát đích (\(pt.chuoiPhanTram)), còn thiếu \(thieu.chuoiSoGonVN) \(d.loaiChiTieu.maBang). Cần chốt bình quân \(moiNgay.chuoiSoGonVN)/ngày trong \(s.soNgayConLai) ngày tới."
            } else {
                mapNganh[d.tenNganhHang] = "🔥 Báo động hụt (\(pt.chuoiPhanTram)), thiếu \(thieu.chuoiSoGonVN) \(d.loaiChiTieu.maBang). Phải giao định mức \(moiNgay.chuoiSoGonVN)/ngày và kiểm tra luỹ kế mỗi 2 giờ."
            }
        }

        var mapNV: [String: String] = [:]
        let mapSK = Dictionary(uniqueKeysWithValues: bcSucKhoe.danhSachTatCa.map { ($0.nhanVien.maNV, $0) })
        for (idx, nv) in dsNV.enumerated() {
            let sk = mapSK[nv.nhanVien.maNV]
            let monYeu = nv.cacMonGiao.filter { $0.phanTramHT < 80 }.prefix(3).map(\.tenNganhHang).joined(separator: ", ")
            let mon0 = nv.cacMonGiao.filter { $0.thucHien <= 0 }.count
            if let sk, sk.laCanhBaoTop5 {
                mapNV[nv.nhanVien.maNV] = "🚨 Top \(sk.hangCanhBao ?? 5) cần kèm cặp (\(sk.chuoiCanhBaoYeu)). Đạt \(nv.soMonDat)/\(nv.tongMonGiao) môn, còn \(mon0) môn = 0. Ưu tiên gỡ ngay: \(monYeu.isEmpty ? "các môn trọng tâm" : monYeu)."
            } else if idx < 3 && nv.soMonDat > 0 {
                mapNV[nv.nhanVien.maNV] = "🏆 Top \(idx + 1) xuất sắc (\(nv.soMonDat)/\(nv.tongMonGiao) môn đạt • TB \(nv.phanTramHTTB.chuoiPhanTram)). Phát huy vai trò đầu tàu hỗ trợ đồng đội chốt đơn."
            } else if nv.phanTramHTTB >= 80 {
                mapNV[nv.nhanVien.maNV] = "🟢 Phong độ tốt (\(nv.soMonDat)/\(nv.tongMonGiao) môn đạt). Cần đẩy dứt điểm: \(monYeu.isEmpty ? "các môn sát đích 85-99%" : monYeu)."
            } else {
                mapNV[nv.nhanVien.maNV] = "🟡 Cần bứt tốc (\(nv.soMonDat)/\(nv.tongMonGiao) môn đạt • còn \(mon0) môn = 0). Tập trung mở điểm: \(monYeu.isEmpty ? "ngành hàng chủ lực" : monYeu)."
            }
        }

        var dsHanhDong: [HangMucHanhDongAI] = []
        let thieuQDThang = max(0, dtLK.targetQuyDoi - dtLK.doanhThuQuyDoi)
        dsHanhDong.append(HangMucHanhDongAI(
            hangMuc: "Đảm bảo tiến độ Doanh thu Quy đổi toàn siêu thị",
            mucTieuSoLieu: thieuQDThang > 0
                ? "Bù \(thieuQDThang.chuoiSoGonVN) tr QĐ (chạy tối thiểu \((thieuQDThang / ngayCon).chuoiSoGonVN) tr QĐ/ngày)"
                : "Duy trì vượt đích \(dtLK.phanTramHTQDDuKienHienThi.chuoiPhanTram), tối ưu tỷ lệ QĐ \(dtLK.phanTramQuyDoi.chuoiPhanTram)",
            nguoiPhuTrach: "Quản lý Siêu thị & Trưởng ca",
            thoiHan: "Theo dõi mỗi 2 giờ / Kết ca",
            mucUuTien: "CAO NHẤT"
        ))
        if !nganhSatDich.isEmpty {
            let ten = nganhSatDich.prefix(3).map(\.tenNganhHang).joined(separator: ", ")
            dsHanhDong.append(HangMucHanhDongAI(
                hangMuc: "Chốt dứt điểm \(nganhSatDich.count) ngành hàng sát đích (85%–99%)",
                mucTieuSoLieu: "Đưa \(ten) cán mốc >= 100% dự kiến ngay trong 2 ngày tới",
                nguoiPhuTrach: "Toàn bộ nhân viên tư vấn",
                thoiHan: "Trong ca hôm nay & ngày mai",
                mucUuTien: "CAO"
            ))
        }
        if !nganhHutNang.isEmpty {
            let ten = nganhHutNang.prefix(3).map { "\($0.tenNganhHang) (\($0.phanTramDuBao.chuoiPhanTram))" }.joined(separator: ", ")
            dsHanhDong.append(HangMucHanhDongAI(
                hangMuc: "Cứu các ngành hàng báo động đỏ (< 85%)",
                mucTieuSoLieu: "Tập trung tư vấn kèm & mở điểm cho: \(ten)",
                nguoiPhuTrach: "Nhóm NV dẫn đầu + Quản lý ca",
                thoiHan: "Kiểm tra lúc 12:00 & 18:00",
                mucUuTien: "KHẨN CẤP"
            ))
        }
        if !bcSucKhoe.top5CanhBaoYeu.isEmpty {
            let tenNV = bcSucKhoe.top5CanhBaoYeu.prefix(5).map(\.nhanVien.hoTen).joined(separator: ", ")
            dsHanhDong.append(HangMucHanhDongAI(
                hangMuc: "Kèm cặp 1-1 nhóm 5 Nhân viên yếu nhiều ngày liên tiếp",
                mucTieuSoLieu: "Xoá trắng các môn = 0 cho: \(tenNV)",
                nguoiPhuTrach: "Quản lý ca & NV Top 1-3",
                thoiHan: "Họp đầu ca 10 phút & rà soát cuối ca",
                mucUuTien: "CAO"
            ))
        }
        var dongChuyenDe: [[String]] = []
        let dsUuTien = dl.danhSachThiDua
            .filter { $0.target > 0 }
            .sorted { ($0.phanTramDuBao > 0 ? $0.phanTramDuBao : $0.phanTramHT) < ($1.phanTramDuBao > 0 ? $1.phanTramDuBao : $1.phanTramHT) }
        for (i, d) in dsUuTien.enumerated() {
            let thieu = max(0, d.target - d.thucHien)
            let dinhMucNgay = thieu / ngayCon
            let dsXH = KhoDuLieu.dungChung.danhSachXepHangNhanVien(cho: d, den: ngay, cheDo: .luyKe)
            let nvCanDay = dsXH.reversed().prefix(3).map { "\($0.hoTen) (\($0.thucHien.chuoiSoGonVN)/\($0.targetCaNhan.chuoiSoGonVN))" }.joined(separator: "; ")
            let nvDanDau = dsXH.first.map { "\($0.hoTen) (\($0.phanTramHT.chuoiPhanTram))" } ?? "Đang cập nhật"
            let trangThai: String
            let pt = d.phanTramDuBao > 0 ? d.phanTramDuBao : d.phanTramHT
            if pt >= 100 { trangThai = "🟢 Đạt mục tiêu" }
            else if pt >= 85 { trangThai = "🟡 Sát đích (Đẩy nhẹ)" }
            else { trangThai = "🔴 Hụt sâu (Cần bứt tốc)" }

            dongChuyenDe.append([
                String(i + 1),
                d.tenNganhHang,
                d.loaiChiTieu.maBang,
                d.thucHien.chuoiSoGonVN,
                d.target.chuoiSoGonVN,
                thieu.chuoiSoGonVN,
                pt.chuoiPhanTram,
                dinhMucNgay.chuoiSoGonVN,
                trangThai,
                nvDanDau,
                nvCanDay.isEmpty ? "Chia đều toàn đội" : nvCanDay,
                mapNganh[d.tenNganhHang] ?? ""
            ])
        }

        let bangCD = BangChuyenDeAI(
            tenSheet: "2_ChuyenDe_TheoYeuCau",
            tieuDeBang: "CHUYÊN ĐỀ: PHÂN BỔ MỤC TIÊU BÙ HỤT MỖI NGÀY & GIAO TRÁCH NHIỆM NHÂN SỰ (\(ngayStr))",
            moTaNgan: "Bảng tính chi tiết lượng còn thiếu, định mức cần chạy mỗi ngày trong \(s.soNgayConLai) ngày còn lại và danh sách nhân sự cần kèm cặp theo từng ngành hàng.",
            cacCot: [
                "STT", "Ngành hàng", "ĐVT", "Thực hiện", "Target tháng", "Còn thiếu",
                "% Dự kiến", "Định mức/Ngày còn lại", "Mức độ ưu tiên",
                "NV Dẫn đầu", "NV Cần đẩy mạnh (Thực hiện/Target)", "Giải pháp & Hành động cụ thể"
            ],
            cacDong: dongChuyenDe,
            ketLuanChuyenDe: phanTichYC
        )

        return HoSoBaoCaoOfficeAI(
            tieuDeBaoCao: tieuDe,
            phuDeBaoCao: phuDe,
            yeuCauNguoiDung: yeuCauSach,
            tomTatDieuHanh: tomTat,
            phanTichTheoYeuCau: phanTichYC,
            keHoachHanhDong: dsHanhDong,
            nhanXetNganhHang: mapNganh,
            nhanXetNhanVien: mapNV,
            bangChuyenDe: bangCD
        )
    }
}

// MARK: - Dịch vụ Google Gemini AI (Free-tier Flash model, tích hợp sẵn key mặc định)

final class DichVuGeminiAI {
    static let dungChung = DichVuGeminiAI()

    /// Key mặc định do người dùng cung cấp để kiểm tra và dùng thử ngay
    static let khoaMacDinh = "AIzaSyBLV7N_qUxSuiJ3B3FETmj2Ta67CKeVKWo"

    /// Ưu tiên Gemini 3.5 Flash-Lite; 3.1 Flash-Lite là model dự phòng.
    static let cacModelMienPhi: [(ma: String, ten: String)] = [
        ("gemini-3.5-flash-lite", "Gemini 3.5 Flash-Lite"),
        ("gemini-3.1-flash-lite", "Gemini 3.1 Flash-Lite")
    ]

    /// Các gợi ý yêu cầu nhanh để người dùng bấm 1 chạm khi xuất báo cáo / Excel / PowerPoint
    static let cacGoiYYeuCauNhanh: [(nhan: String, noiDung: String)] = [
        ("🎯 Soi ngành hụt & chia chỉ tiêu ngày", "Phân tích sâu các ngành hàng đang dưới 85% dự kiến, tính định mức cần bán mỗi ngày còn lại và chỉ rõ nhân viên nào phải chịu trách nhiệm đẩy từng ngành."),
        ("❤️‍🩹 Kèm cặp Top 5 NV yếu liên tiếp", "Tập trung phân tích Top 5 nhân viên có sức khỏe yếu nhiều ngày liên tục, liệt kê các môn đang bằng 0 của từng bạn và lập kế hoạch kèm cặp 1-1 trong ca."),
        ("📈 Kịch bản bứt tốc về đích tháng", "Đánh giá khả năng hoàn thành Target Doanh thu Quy đổi cuối tháng dựa trên xu hướng Realtime các ngày qua, đề xuất kịch bản bứt tốc khung giờ vàng."),
        ("🏆 Vinh danh Top đầu & đẩy Trả góp", "Tuyên dương các nhân viên và ngành hàng dẫn đầu, đồng thời phân tích giải pháp nâng tỷ lệ Trả góp và Doanh thu Quy đổi toàn siêu thị.")
    ]

    private let khoaLuuYeuCauTuyChinh = "dmx.gemini.yeuCauTuyChinhNguoiDung.v2"

    private init() {}

    /// Yêu cầu tùy chỉnh của người dùng (đồng bộ giữa màn hình Báo cáo AI, mục Xuất ảnh và Menu xuất file)
    var yeuCauTuyChinhHienTai: String {
        get {
            UserDefaults.standard.string(forKey: khoaLuuYeuCauTuyChinh) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: khoaLuuYeuCauTuyChinh)
        }
    }

    var apiKeyHienTai: String {
        KhoDuLieu.dungChung.caiDat.geminiApiKeyHieuLuc
    }

    var modelHienTai: String {
        "gemini-3.5-flash-lite"
    }

    /// Kiểm tra API Key trực tiếp với máy chủ Google Gemini (tự động thử model dự phòng miễn phí nếu model đầu bận)
    func kiemTraVaDungThuKey(
        apiKey: String? = nil,
        model: String? = nil,
        hoanTat: @escaping (Result<(modelThanhCong: String, phanHoiMau: String), Error>) -> Void
    ) {
        let key = (apiKey ?? apiKeyHienTai).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else {
            let err = NSError(domain: "GeminiAI", code: 400, userInfo: [NSLocalizedDescriptionKey: "Vui lòng nhập Google Gemini API Key."])
            DispatchQueue.main.async { hoanTat(.failure(err)) }
            return
        }

        let modelUuTien = "gemini-3.5-flash-lite"
        var danhSachThu: [String] = [modelUuTien]
        for m in Self.cacModelMienPhi.map(\.ma) where !danhSachThu.contains(m) {
            danhSachThu.append(m)
        }

        let cauLenhThu = "Bạn là trợ lý phân tích kinh doanh Điện Máy Xanh. Hãy trả lời ngắn gọn 1 câu tiếng Việt xác nhận kết nối API Gemini thành công và sẵn sàng tạo báo cáo."
        goiTiepModel(danhSachModel: danhSachThu, chiSo: 0, apiKey: key, prompt: cauLenhThu) { kq in
            DispatchQueue.main.async {
                switch kq {
                case .success(let ketQua):
                    let modelOK = ketQua.0
                    let text = ketQua.1
                    hoanTat(.success((modelOK, text)))
                case .failure(let loi):
                    hoanTat(.failure(loi))
                }
            }
        }
    }

    /// Gọi Google Gemini AI để phân tích dữ liệu thật của siêu thị và sinh báo cáo theo đúng mẫu ảnh chụp + yêu cầu riêng của người dùng
    func phanTichBaoCao(
        soLieu: SoLieuBanTin,
        giong: GiongVanBanTin,
        nhomTapTrung: Set<String> = [],
        nvTapTrung: Set<String> = [],
        loaiBaoCao: LoaiBaoCaoXuatAnh? = nil,
        yeuCauRieng: String? = nil,
        hoanTat: @escaping (Result<String, Error>) -> Void
    ) {
        let key = apiKeyHienTai
        let modelUuTien = modelHienTai
        var danhSachThu: [String] = [modelUuTien]
        for m in Self.cacModelMienPhi.map(\.ma) where !danhSachThu.contains(m) {
            danhSachThu.append(m)
        }

        let yc = (yeuCauRieng ?? yeuCauTuyChinhHienTai).trimmingCharacters(in: .whitespacesAndNewlines)
        let prompt = taoPromptPhanTich(
            soLieu: soLieu,
            giong: giong,
            nhomTapTrung: nhomTapTrung,
            nvTapTrung: nvTapTrung,
            loaiBaoCao: loaiBaoCao,
            yeuCauRieng: yc
        )

        goiTiepModel(danhSachModel: danhSachThu, chiSo: 0, apiKey: key, prompt: prompt, maxTokens: 8192) { kq in
            DispatchQueue.main.async {
                switch kq {
                case .success(let ketQua):
                    let vanBan = ketQua.1
                    hoanTat(.success(vanBan))
                case .failure(let loi):
                    hoanTat(.failure(loi))
                }
            }
        }
    }

    /// Gọi Google Gemini AI sinh Hồ sơ Báo cáo Office (Excel .xlsx & PowerPoint .pptx) chuyên sâu theo yêu cầu riêng của người dùng
    func taoHoSoBaoCaoOfficeChiTiet(
        ngay: Date,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String,
        hoanTat: @escaping (HoSoBaoCaoOfficeAI, Bool, String) -> Void
    ) {
        let hoSoCoSo = HoSoBaoCaoOfficeAI.taoHoSoChuyenSauTuDuLieu(
            ngay: ngay,
            noiDungPhanTich: noiDungPhanTich,
            yeuCauNguoiDung: yeuCauNguoiDung
        )

        let key = apiKeyHienTai.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else {
            DispatchQueue.main.async {
                hoanTat(hoSoCoSo, false, "Offline")
            }
            return
        }

        let modelUuTien = modelHienTai
        var danhSachThu: [String] = [modelUuTien]
        for m in Self.cacModelMienPhi.map(\.ma) where !danhSachThu.contains(m) {
            danhSachThu.append(m)
        }

        let prompt = taoPromptJSONBaoCaoOffice(
            ngay: ngay,
            hoSoCoSo: hoSoCoSo,
            noiDungPhanTich: noiDungPhanTich,
            yeuCauNguoiDung: yeuCauNguoiDung
        )

        goiTiepModel(
            danhSachModel: danhSachThu,
            chiSo: 0,
            apiKey: key,
            prompt: prompt,
            maxTokens: 8192,
            epKieuJSON: true
        ) { kq in
            DispatchQueue.main.async {
                switch kq {
                case .success(let (modelOK, jsonText)):
                    let hopNhat = Self.gopHoSoTuJSONGemini(jsonText: jsonText, vao: hoSoCoSo)
                    hoanTat(hopNhat, true, modelOK)
                case .failure:
                    hoanTat(hoSoCoSo, false, "Mẫu thông minh")
                }
            }
        }
    }

    private func taoPromptJSONBaoCaoOffice(
        ngay: Date,
        hoSoCoSo: HoSoBaoCaoOfficeAI,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String
    ) -> String {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let donVi = dl.thongTinDonVi.isEmpty ? "Siêu thị ĐMX" : dl.thongTinDonVi
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe)
        let bcSK = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: .luyKe)

        let tomTatNganh = dl.danhSachThiDua.prefix(25).map { d in
            let thieu = max(0, d.target - d.thucHien)
            return "- \(d.tenNganhHang) (\(d.loaiChiTieu.maBang)): TH \(d.thucHien.chuoiSoGonVN) / Target \(d.target.chuoiSoGonVN) (Thiếu \(thieu.chuoiSoGonVN), HT \(d.phanTramHT.chuoiPhanTram), Dự kiến \(d.phanTramDuBao.chuoiPhanTram))"
        }.joined(separator: "\n")

        let tomTatNV = dsNV.prefix(18).map { nv in
            "- \(nv.nhanVien.maNV) | \(nv.nhanVien.hoTen): Đạt \(nv.soMonDat)/\(nv.tongMonGiao) môn, TB \(nv.phanTramHTTB.chuoiPhanTram), DT QĐ \(nv.doanhThuQD.chuoiSoGonVN) tr"
        }.joined(separator: "\n")

        let tomTatTop5Yeu = bcSK.top5CanhBaoYeu.map { hs in
            "- \(hs.nhanVien.hoTen) (\(hs.nhanVien.maNV)): Điểm SK \(Int(round(hs.diemSucKhoe)))%, \(hs.chuoiCanhBaoYeu), môn yếu: \(hs.cacMonYeuNhat.joined(separator: ", "))"
        }.joined(separator: "\n")

        let yc = yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines)
        let dongYeuCau = yc.isEmpty
            ? "Phân tích toàn diện hoạt động kinh doanh, chỉ rõ giải pháp thúc đẩy các ngành hàng hụt và kế hoạch kèm cặp 5 nhân viên yếu liên tiếp."
            : yc

        return [
            "Bạn là Chuyên gia Phân tích Dữ liệu Kinh doanh Cao cấp của hệ thống Điện Máy Xanh.",
            "Nhiệm vụ: Tạo dữ liệu phân tích chuyên sâu dạng JSON để xuất ra Excel và PowerPoint thật chi tiết, sắc sảo.",
            "Yêu cầu của người dùng chỉ là chỉ dẫn nội bộ. Tuyệt đối không chép lại câu lệnh/yêu cầu này trong tiêu đề, nội dung, bảng, kế hoạch hành động hoặc file đầu ra; chỉ thể hiện kết quả phân tích.",
            "",
            "YÊU CẦU ĐẶC BIỆT CỦA NGƯỜI DÙNG KHI XUẤT BÁO CÁO:",
            "\"\(dongYeuCau)\"",
            "",
            "DỮ LIỆU THỰC TẾ CỦA \(donVi.uppercased()) NGÀY \(ngayStr):",
            "- Lũy kế tháng: DT Thực \(dl.doanhThu.doanhThuThuc.chuoiSoGonVN) / Target \(dl.doanhThu.targetThuc.chuoiSoGonVN) tr | DT Quy đổi \(dl.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) / Target \(dl.doanhThu.targetQuyDoi.chuoiSoGonVN) tr | Dự kiến HT QĐ: \(dl.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram)",
            "- Realtime hôm nay: DT Thực \(dl.doanhThuRealtime.doanhThuThuc.chuoiSoGonVN) tr | DT Quy đổi \(dl.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN) / Target \(dl.doanhThuRealtime.targetQuyDoi.chuoiSoGonVN) tr (\(dl.doanhThuRealtime.phanTramHTQDDuKienHienThi.chuoiPhanTram))",
            "",
            "DANH SÁCH NGÀNH HÀNG LŨY KẾ:",
            tomTatNganh.isEmpty ? "(Chưa có ngành hàng)" : tomTatNganh,
            "",
            "DANH SÁCH NHÂN VIÊN:",
            tomTatNV.isEmpty ? "(Chưa có nhân viên)" : tomTatNV,
            "",
            "TOP 5 NHÂN VIÊN YẾU NHIỀU NGÀY LIÊN TỤC:",
            tomTatTop5Yeu.isEmpty ? "(Không có)" : tomTatTop5Yeu,
            "",
            "Hãy trả về ĐÚNG 1 ĐỐI TƯỢNG JSON HỢP LỆ (không bọc trong markdown hay giải thích ngoài JSON) theo cấu trúc sau:",
            "{",
            "  \"tieuDeBaoCao\": \"Tiêu đề báo cáo chuyên nghiệp, không nhắc tới câu lệnh hay yêu cầu người dùng\",",
            "  \"tomTatDieuHanh\": \"Đoạn tóm tắt điều hành sâu sắc (3-4 câu) nêu bật bức tranh doanh thu, điểm sáng và điểm nghẽn lớn nhất\",",
            "  \"phanTichTheoYeuCau\": \"Bài phân tích chi tiết (chia các ý rõ ràng), chỉ chứa kết quả và khuyến nghị\",",
            "  \"keHoachHanhDong\": [",
            "    {\"hangMuc\": \"Tên đầu việc cụ thể\", \"mucTieuSoLieu\": \"Con số mục tiêu rõ ràng\", \"nguoiPhuTrach\": \"Bộ phận/Cá nhân\", \"thoiHan\": \"Mốc thời gian\", \"mucUuTien\": \"KHẨN CẤP / CAO / TRỌNG TÂM\"}",
            "  ],",
            "  \"nhanXetNganhHang\": {",
            "    \"Tên ngành hàng chính xác\": \"Nhận xét ngắn gọn + hành động chốt số cụ thể cho ngành này\"",
            "  },",
            "  \"nhanXetNhanVien\": {",
            "    \"Mã NV\": \"Đánh giá năng lực + chỉ đạo kèm cặp cụ thể cho nhân viên này\"",
            "  },",
            "  \"bangChuyenDe\": {",
            "    \"tenSheet\": \"2_ChuyenDe_TheoYeuCau\",",
            "    \"tieuDeBang\": \"Tiêu đề bảng phân tích chuyên đề theo đúng yêu cầu của người dùng\",",
            "    \"moTaNgan\": \"Mô tả ý nghĩa bảng chuyên đề\",",
            "    \"cacCot\": [\"Cột 1\", \"Cột 2\", \"Cột 3\", \"Cột 4\", \"Cột 5\", \"Cột 6\"],",
            "    \"cacDong\": [[\"Giá trị 1\", \"Giá trị 2\", \"Giá trị 3\", \"Giá trị 4\", \"Giá trị 5\", \"Giá trị 6\"]],",
            "    \"ketLuanChuyenDe\": \"Kết luận & chỉ đạo chốt lại cho bảng chuyên đề này\"",
            "  }",
            "}"
        ].joined(separator: "\n")
    }

    private static func gopHoSoTuJSONGemini(jsonText: String, vao goc: HoSoBaoCaoOfficeAI) -> HoSoBaoCaoOfficeAI {
        var ketQua = goc
        var chuoi = jsonText.trimmingCharacters(in: .whitespacesAndNewlines)
        if let dau = chuoi.firstIndex(of: "{"), let cuoi = chuoi.lastIndex(of: "}") {
            chuoi = String(chuoi[dau...cuoi])
        }
        guard let data = chuoi.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return ketQua
        }

        if let td = dict["tieuDeBaoCao"] as? String, !td.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ketQua.tieuDeBaoCao = td.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let tt = dict["tomTatDieuHanh"] as? String, !tt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ketQua.tomTatDieuHanh = tt.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let pt = dict["phanTichTheoYeuCau"] as? String, !pt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ketQua.phanTichTheoYeuCau = pt.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let arrHD = dict["keHoachHanhDong"] as? [[String: Any]], !arrHD.isEmpty {
            var dsMoi: [HangMucHanhDongAI] = []
            for item in arrHD {
                let hm = (item["hangMuc"] as? String) ?? ""
                let mt = (item["mucTieuSoLieu"] as? String) ?? ""
                let npt = (item["nguoiPhuTrach"] as? String) ?? "Toàn siêu thị"
                let th = (item["thoiHan"] as? String) ?? "Trong ca"
                let ut = (item["mucUuTien"] as? String) ?? "CAO"
                if !hm.isEmpty {
                    dsMoi.append(HangMucHanhDongAI(hangMuc: hm, mucTieuSoLieu: mt, nguoiPhuTrach: npt, thoiHan: th, mucUuTien: ut))
                }
            }
            if !dsMoi.isEmpty {
                ketQua.keHoachHanhDong = dsMoi
            }
        }
        if let mapNH = dict["nhanXetNganhHang"] as? [String: String] {
            for (k, v) in mapNH where !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ketQua.nhanXetNganhHang[k] = v.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        if let mapNV = dict["nhanXetNhanVien"] as? [String: String] {
            for (k, v) in mapNV where !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ketQua.nhanXetNhanVien[k] = v.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        if let cdObj = dict["bangChuyenDe"] as? [String: Any],
           let cacCot = cdObj["cacCot"] as? [String],
           let cacDongAny = cdObj["cacDong"] as? [[Any]],
           !cacCot.isEmpty,
           !cacDongAny.isEmpty {
            let cacDong: [[String]] = cacDongAny.map { dong in
                dong.map { String(describing: $0) }
            }
            let tieuDeBang = (cdObj["tieuDeBang"] as? String) ?? ketQua.bangChuyenDe?.tieuDeBang ?? "BẢNG PHÂN TÍCH CHUYÊN ĐỀ AI GEMINI"
            let moTaNgan = (cdObj["moTaNgan"] as? String) ?? ketQua.bangChuyenDe?.moTaNgan ?? ""
            let ketLuan = (cdObj["ketLuanChuyenDe"] as? String) ?? ketQua.phanTichTheoYeuCau
            ketQua.bangChuyenDe = BangChuyenDeAI(
                tenSheet: "2_ChuyenDe_TheoYeuCau",
                tieuDeBang: tieuDeBang,
                moTaNgan: moTaNgan,
                cacCot: cacCot,
                cacDong: cacDong,
                ketLuanChuyenDe: ketLuan
            )
        }
        // Phòng trường hợp model vẫn lặp nguyên chỉ dẫn: loại câu lệnh trước khi
        // dữ liệu được chuyển thành ô Excel hoặc textbox PowerPoint.
        let chiDan = goc.yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines)
        if !chiDan.isEmpty {
            func sach(_ value: String) -> String {
                value.replacingOccurrences(of: chiDan, with: "", options: [.caseInsensitive])
                    .replacingOccurrences(of: "\"\"", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            ketQua.tieuDeBaoCao = sach(ketQua.tieuDeBaoCao)
            ketQua.tomTatDieuHanh = sach(ketQua.tomTatDieuHanh)
            ketQua.phanTichTheoYeuCau = sach(ketQua.phanTichTheoYeuCau)
            ketQua.keHoachHanhDong = ketQua.keHoachHanhDong.map {
                HangMucHanhDongAI(hangMuc: sach($0.hangMuc), mucTieuSoLieu: sach($0.mucTieuSoLieu), nguoiPhuTrach: $0.nguoiPhuTrach, thoiHan: $0.thoiHan, mucUuTien: $0.mucUuTien)
            }
            ketQua.nhanXetNganhHang = ketQua.nhanXetNganhHang.mapValues(sach)
            ketQua.nhanXetNhanVien = ketQua.nhanXetNhanVien.mapValues(sach)
            if var bang = ketQua.bangChuyenDe {
                bang.tieuDeBang = sach(bang.tieuDeBang)
                bang.moTaNgan = sach(bang.moTaNgan)
                bang.cacDong = bang.cacDong.map { $0.map(sach) }
                bang.ketLuanChuyenDe = sach(bang.ketLuanChuyenDe)
                ketQua.bangChuyenDe = bang
            }
        }
        return ketQua
    }

    private func taoPromptPhanTich(
        soLieu: SoLieuBanTin,
        giong: GiongVanBanTin,
        nhomTapTrung: Set<String>,
        nvTapTrung: Set<String>,
        loaiBaoCao: LoaiBaoCaoXuatAnh?,
        yeuCauRieng: String = ""
    ) -> String {
        let banMau = BoVietBanTin(soLieu: soLieu, giong: giong).vietTheoMauAnhChup(
            nhomTapTrung: nhomTapTrung,
            nvTapTrung: nvTapTrung
        )
        let moTaGiong: String
        switch giong {
        case .binhThuong:
            moTaGiong = "Chuyên nghiệp, rõ ràng, khích lệ tinh thần đội ngũ siêu thị."
        case .cangThang:
            moTaGiong = "Quyết liệt, thẳng thắn, tập trung đốc thúc tiến độ và yêu cầu cam kết hành động."
        case .thaoMai:
            moTaGiong = "Thân thiện, ngọt ngào, truyền cảm hứng tích cực nhưng vẫn bám sát con số mục tiêu."
        }

        let yeuCauLoai: String
        if let loai = loaiBaoCao {
            let tomTatRieng = BoVietBanTin.taoNoiDungBaoCao(loai: loai, ngay: soLieu.ngay, giong: giong)
            yeuCauLoai = "\nBỐI CẢNH XUẤT ẢNH: Người dùng đang chọn xuất ảnh \"\(loai.tieuDeNgan)\".\nDữ liệu chi tiết của phần này:\n\(tomTatRieng)\n"
        } else {
            yeuCauLoai = ""
        }

        let doanYeuCauNguoiDung: String
        let ycSach = yeuCauRieng.trimmingCharacters(in: .whitespacesAndNewlines)
        if !ycSach.isEmpty {
            doanYeuCauNguoiDung = "\n🎯 YÊU CẦU RIÊNG CỦA NGƯỜI DÙNG CẦN ĐƯA VÀO BÁO CÁO:\n\"\(ycSach)\"\nHãy đảm bảo phân tích sâu và làm nổi bật nội dung theo đúng yêu cầu riêng này trong bài báo cáo.\n"
        } else {
            doanYeuCauNguoiDung = ""
        }

        return [
            "Bạn là Quản lý Siêu thị Điện Máy Xanh chuyên phân tích số liệu thi đua kinh doanh để gửi lên nhóm LINE.",
            "Hãy dựa trên số liệu thực tế dưới đây để viết một bản thông báo tình hình kinh doanh súc tích, chính xác tuyệt đối về con số, có đánh số 1) 2) 3) 4) 5) và giữ định dạng **in đậm** cho các chỉ số quan trọng giống hệt cấu trúc mẫu.",
            "Giọng văn yêu cầu: \(moTaGiong)",
            yeuCauLoai,
            doanYeuCauNguoiDung,
            "DỮ LIỆU & BẢN MẪU CHUẨN CỦA SIÊU THỊ:",
            banMau,
            "",
            "Chỉ trả về nội dung bài báo cáo hoàn chỉnh để copy gửi LINE (không thêm lời giải thích mở đầu hay kết thúc ngoài bản tin)."
        ].joined(separator: "\n")
    }

    private func goiTiepModel(
        danhSachModel: [String],
        chiSo: Int,
        apiKey: String,
        prompt: String,
        maxTokens: Int = 2048,
        epKieuJSON: Bool = false,
        hoanTat: @escaping (Result<(String, String), Error>) -> Void
    ) {
        guard chiSo < danhSachModel.count else {
            let err = NSError(
                domain: "GeminiAI",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Không thể kết nối tới các model Gemini miễn phí. Vui lòng kiểm tra lại kết nối mạng hoặc API Key."]
            )
            hoanTat(.failure(err))
            return
        }

        let model = danhSachModel[chiSo]
        let urlStr = "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlStr) else {
            goiTiepModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, maxTokens: maxTokens, epKieuJSON: epKieuJSON, hoanTat: hoanTat)
            return
        }

        var req = URLRequest(url: url, timeoutInterval: 32)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var genConfig: [String: Any] = [
            "temperature": 0.4,
            "maxOutputTokens": maxTokens
        ]
        if model.hasPrefix("gemini-3") {
            genConfig["thinkingConfig"] = ["thinkingBudget": 0]
        }
        if epKieuJSON {
            genConfig["responseMimeType"] = "application/json"
        }

        let payload: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": genConfig
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                if chiSo + 1 < danhSachModel.count {
                    self.goiTiepModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, maxTokens: maxTokens, epKieuJSON: epKieuJSON, hoanTat: hoanTat)
                } else {
                    hoanTat(.failure(error))
                }
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard let data = data else {
                self.goiTiepModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, maxTokens: maxTokens, epKieuJSON: epKieuJSON, hoanTat: hoanTat)
                return
            }

            if statusCode == 200,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let first = candidates.first,
               let content = first["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]] {
                let gopText = parts.compactMap { $0["text"] as? String }.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
                if !gopText.isEmpty {
                    hoanTat(.success((model, gopText)))
                    return
                }
            }

            if (statusCode == 400 || statusCode == 404 || statusCode == 429 || statusCode == 503) && (chiSo + 1 < danhSachModel.count) {
                self.goiTiepModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, maxTokens: maxTokens, epKieuJSON: epKieuJSON, hoanTat: hoanTat)
                return
            }

            var thongDiepLoi = "Mã phản hồi HTTP \(statusCode)"
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errObj = json["error"] as? [String: Any],
               let msg = errObj["message"] as? String {
                thongDiepLoi = msg
            }
            let err = NSError(domain: "GeminiAI", code: statusCode, userInfo: [NSLocalizedDescriptionKey: thongDiepLoi])
            hoanTat(.failure(err))
        }.resume()
    }
}

// MARK: - Bộ tạo gói ZIP & Xuất file Excel (.xlsx) 7 Sheet / PowerPoint (.pptx) 6 Slide Chuẩn Thiết Kế Chuyên Gia Gemini

enum BoXuatOfficeDMX {

    /// Kiểu định dạng ô trong Excel (ánh xạ với bảng cellXfs trong xl/styles.xml)
    enum KieuOExcel: Int {
        case macDinh = 0             // Viền mảnh, chữ thường căn trái, tự xuống dòng
        case vanBanXenKe = 1         // Nền xám xanh nhạt #F8FAFC, căn trái
        case inDam = 2               // Chữ in đậm căn trái
        case bannerChinh = 3         // Nền Xanh ĐMX #1D4ED8, chữ Trắng 14pt Bold
        case bannerPhu = 4           // Nền Vàng nhạt #FEF3C2, chữ Xanh đậm 11pt Bold
        case tieuDeMuc = 5           // Nền Xanh nhạt #DBEAFE, chữ Xanh đậm 11pt Bold
        case headerBang = 6          // Nền Xanh Navy #1E40AF, chữ Trắng 11pt Bold căn giữa
        case canGiua = 7             // Căn giữa, viền mảnh
        case soThuc = 8              // Số thập phân #,##0.00 căn phải
        case soNguyen = 9            // Số nguyên #,##0 căn phải
        case phanTram = 10           // Phần trăm 0.0"%" in đậm căn phải
        case trangThaiTot = 11       // Nền Xanh lá #DCFCE7, chữ Xanh đậm #15803D Bold căn giữa
        case trangThaiKha = 12       // Nền Vàng #FEF9C3, chữ Nâu vàng #B45309 Bold căn giữa
        case trangThaiYeu = 13       // Nền Đỏ nhạt #FEE2E2, chữ Đỏ đậm #B91C1C Bold căn giữa
        case dongTongKetChu = 14     // Dòng Tổng kết: Nền Vàng #FEF3C2, viền đậm, chữ Bold
        case dongTongKetSo = 15      // Dòng Tổng kết: Nền Vàng #FEF3C2, số #,##0.00 Bold
        case dongTongKetPhanTram = 16 // Dòng Tổng kết: Nền Vàng #FEF3C2, 0.0"%" Bold
        case hopPhanTichAI = 17      // Nền tím/xanh AI #EEF2FF, chữ đậm vừa, tự xuống dòng
    }

    enum GiaTriOExcel {
        case chu(String)
        case so(Double)
        case congThuc(String, Double)
    }

    struct OExcel {
        var giaTri: GiaTriOExcel
        var kieu: KieuOExcel

        static func chu(_ s: String, kieu: KieuOExcel = .macDinh) -> OExcel {
            OExcel(giaTri: .chu(s), kieu: kieu)
        }

        static func so(_ v: Double, kieu: KieuOExcel = .soThuc) -> OExcel {
            OExcel(giaTri: .so(v), kieu: kieu)
        }

        static func nguyen(_ v: Int, kieu: KieuOExcel = .soNguyen) -> OExcel {
            OExcel(giaTri: .so(Double(v)), kieu: kieu)
        }

        static func phanTram(_ v: Double, kieu: KieuOExcel? = nil) -> OExcel {
            let k: KieuOExcel
            if let kieu {
                k = kieu
            } else if v >= 100 {
                k = .trangThaiTot
            } else if v >= 85 {
                k = .trangThaiKha
            } else {
                k = .trangThaiYeu
            }
            return OExcel(giaTri: .so(v), kieu: k)
        }

        static func congThuc(_ f: String, giaTriTam: Double = 0, kieu: KieuOExcel = .soThuc) -> OExcel {
            OExcel(giaTri: .congThuc(f, giaTriTam), kieu: kieu)
        }
    }

    struct DongExcel {
        var cacO: [OExcel]
        var chieuCao: Double?

        init(_ cacO: [OExcel], chieuCao: Double? = nil) {
            self.cacO = cacO
            self.chieuCao = chieuCao
        }
    }

    struct CauHinhSheetExcel {
        var tenSheet: String
        var doRongCot: [Double]
        var cacDong: [DongExcel]
        var cacGopO: [String]
        var dongCoDinh: Int
    }

    /// Tạo file Excel (.xlsx) thông qua AI Gemini (tự động phân tích theo yêu cầu người dùng rồi sinh file 7 Sheet chuẩn đẹp)
    static func taoFileExcelBangAIGemini(
        ngay: Date,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String,
        hoanTat: @escaping (URL?, Bool, String) -> Void
    ) {
        DichVuGeminiAI.dungChung.taoHoSoBaoCaoOfficeChiTiet(
            ngay: ngay,
            noiDungPhanTich: noiDungPhanTich,
            yeuCauNguoiDung: yeuCauNguoiDung
        ) { hoSo, dungAIThat, tenModel in
            let url = xuatFileExcelXLSX(
                ngay: ngay,
                noiDungPhanTich: noiDungPhanTich,
                yeuCauNguoiDung: yeuCauNguoiDung,
                hoSoAI: hoSo
            )
            hoanTat(url, dungAIThat, tenModel)
        }
    }

    /// Tạo file PowerPoint (.pptx) thông qua AI Gemini (6 Slide trình chiếu chuyên nghiệp theo yêu cầu người dùng)
    static func taoFilePowerPointBangAIGemini(
        ngay: Date,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String,
        hoanTat: @escaping (URL?, Bool, String) -> Void
    ) {
        DichVuGeminiAI.dungChung.taoHoSoBaoCaoOfficeChiTiet(
            ngay: ngay,
            noiDungPhanTich: noiDungPhanTich,
            yeuCauNguoiDung: yeuCauNguoiDung
        ) { hoSo, dungAIThat, tenModel in
            let url = xuatFilePowerPointPPTX(
                ngay: ngay,
                noiDungPhanTich: noiDungPhanTich,
                yeuCauNguoiDung: yeuCauNguoiDung,
                hoSoAI: hoSo
            )
            hoanTat(url, dungAIThat, tenModel)
        }
    }

    /// Tạo file Excel (.xlsx) chuẩn OpenXML gồm 7 Sheet định dạng đầy đủ màu sắc, viền, độ rộng cột, công thức Excel thật & nhận xét AI Gemini
    static func xuatFileExcelXLSX(
        ngay: Date,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String = "",
        hoSoAI: HoSoBaoCaoOfficeAI? = nil
    ) -> URL? {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let donVi = dl.thongTinDonVi.isEmpty ? "Siêu thị Điện Máy Xanh" : dl.thongTinDonVi
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngay, khung: KhungBanTin.theoGio())
        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngay, cheDoDangXem: .luyKe)
        let bcSucKhoe = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: .luyKe)
        let yc = yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai.trimmingCharacters(in: .whitespacesAndNewlines)
            : yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines)

        let hoSo = hoSoAI ?? HoSoBaoCaoOfficeAI.taoHoSoChuyenSauTuDuLieu(
            ngay: ngay,
            noiDungPhanTich: noiDungPhanTich,
            yeuCauNguoiDung: yc
        )

        // SHEET 1: DASHBOARD ĐIỀU HÀNH & PHÂN TÍCH AI THEO YÊU CẦU NGƯỜI DÙNG
        var d1: [DongExcel] = []
        var merge1: [String] = []

        d1.append(DongExcel(taoHangGop(hoSo.tieuDeBaoCao, soCot: 8, kieu: .bannerChinh), chieuCao: 34))
        merge1.append("A1:H1")

        d1.append(DongExcel(taoHangGop(hoSo.phuDeBaoCao, soCot: 8, kieu: .bannerPhu), chieuCao: 24))
        merge1.append("A2:H2")

        let rTomTat = d1.count + 1
        d1.append(DongExcel(taoHangGop("🤖 TÓM TẮT ĐIỀU HÀNH & NHẬN ĐỊNH TRỌNG TÂM TỪ AI GEMINI", soCot: 8, kieu: .tieuDeMuc), chieuCao: 25))
        merge1.append("A\(rTomTat):H\(rTomTat)")

        let rNDTomTat = d1.count + 1
        d1.append(DongExcel(taoHangGop(hoSo.tomTatDieuHanh, soCot: 8, kieu: .hopPhanTichAI), chieuCao: 46))
        merge1.append("A\(rNDTomTat):H\(rNDTomTat)")

        let tieuDeYC = yc.isEmpty
            ? "🎯 PHÂN TÍCH CHUYÊN SÂU & ĐỊNH HƯỚNG ĐIỀU HÀNH CA TRỰC"
            : "🎯 PHÂN TÍCH TRỌNG TÂM"
        let rTieuDeYC = d1.count + 1
        d1.append(DongExcel(taoHangGop(tieuDeYC, soCot: 8, kieu: .tieuDeMuc), chieuCao: 25))
        merge1.append("A\(rTieuDeYC):H\(rTieuDeYC)")

        for dongYC in hoSo.phanTichTheoYeuCau.components(separatedBy: .newlines) where !dongYC.trimmingCharacters(in: .whitespaces).isEmpty {
            let r = d1.count + 1
            d1.append(DongExcel(taoHangGop(dongYC, soCot: 8, kieu: .hopPhanTichAI), chieuCao: 28))
            merge1.append("A\(r):H\(r)")
        }

        d1.append(DongExcel([], chieuCao: 10))

        let rMucKPI = d1.count + 1
        d1.append(DongExcel(taoHangGop("📊 BẢNG TỔNG HỢP CHỈ SỐ DOANH THU & DỰ BÁO CUỐI THÁNG", soCot: 8, kieu: .tieuDeMuc), chieuCao: 25))
        merge1.append("A\(rMucKPI):H\(rMucKPI)")

        d1.append(DongExcel([
            .chu("Hạng mục Chế độ", kieu: .headerBang),
            .chu("Doanh thu Thực (Tr)", kieu: .headerBang),
            .chu("Target Thực (Tr)", kieu: .headerBang),
            .chu("Doanh thu Quy đổi (Tr)", kieu: .headerBang),
            .chu("Target Quy đổi (Tr)", kieu: .headerBang),
            .chu("Còn thiếu QĐ (Tr)", kieu: .headerBang),
            .chu("% HT QĐ / Dự kiến", kieu: .headerBang),
            .chu("Đánh giá & Nhịp độ yêu cầu", kieu: .headerBang)
        ], chieuCao: 28))

        let rLuyKe = d1.count + 1
        let thieuQDLK = max(0, dl.doanhThu.targetQuyDoi - dl.doanhThu.doanhThuQuyDoi)
        let canMoiNgay = thieuQDLK / Double(max(1, s.soNgayConLai))
        d1.append(DongExcel([
            .chu("1. Lũy kế tháng (tới \(ngayStr))", kieu: .inDam),
            .so(dl.doanhThu.doanhThuThuc),
            .so(dl.doanhThu.targetThuc),
            .so(dl.doanhThu.doanhThuQuyDoi),
            .so(dl.doanhThu.targetQuyDoi),
            .congThuc("MAX(0,E\(rLuyKe)-D\(rLuyKe))", giaTriTam: thieuQDLK),
            .phanTram(dl.doanhThu.phanTramHTQDDuKienHienThi),
            .chu(thieuQDLK > 0 ? "Cần chạy TB \(canMoiNgay.chuoiSoGonVN) tr QĐ/ngày trong \(s.soNgayConLai) ngày còn lại" : "Đã vượt Target Quy đổi tháng", kieu: .macDinh)
        ], chieuCao: 24))

        let rRealtime = d1.count + 1
        let thieuQDRT = max(0, dl.doanhThuRealtime.targetQuyDoi - dl.doanhThuRealtime.doanhThuQuyDoi)
        d1.append(DongExcel([
            .chu("2. Realtime trong ngày (\(ngayStr))", kieu: .inDam),
            .so(dl.doanhThuRealtime.doanhThuThuc),
            .so(dl.doanhThuRealtime.targetThuc),
            .so(dl.doanhThuRealtime.doanhThuQuyDoi),
            .so(dl.doanhThuRealtime.targetQuyDoi),
            .congThuc("MAX(0,E\(rRealtime)-D\(rRealtime))", giaTriTam: thieuQDRT),
            .phanTram(dl.doanhThuRealtime.phanTramHTQDDuKienHienThi),
            .chu("Lượt khách: \(Int(dl.doanhThuRealtime.luotKhach)) • Tỷ lệ trả góp: \(dl.doanhThuRealtime.phanTramTraGop.chuoiPhanTram)", kieu: .macDinh)
        ], chieuCao: 24))

        d1.append(DongExcel([
            .chu("3. Dự báo cuối tháng (Theo nhịp Realtime)", kieu: .dongTongKetChu),
            .so(duBao.duKienThucCuoiThang, kieu: .dongTongKetSo),
            .so(dl.doanhThu.targetThuc, kieu: .dongTongKetSo),
            .so(duBao.duKienQDCuoiThang, kieu: .dongTongKetSo),
            .so(duBao.mucTieuThang, kieu: .dongTongKetSo),
            .so(max(0, duBao.mucTieuThang - duBao.duKienQDCuoiThang), kieu: .dongTongKetSo),
            .phanTram(duBao.phanTramHTQDDuKien, kieu: .dongTongKetPhanTram),
            .chu("TB mỗi ngày đạt \(duBao.trungBinhQDMoiNgay.chuoiSoGonVN) tr QĐ / Mục tiêu ngày \(duBao.mucTieuMoiNgay.chuoiSoGonVN) tr", kieu: .dongTongKetChu)
        ], chieuCao: 26))

        d1.append(DongExcel([], chieuCao: 10))

        let rMucAction = d1.count + 1
        d1.append(DongExcel(taoHangGop("🚀 KẾ HOẠCH HÀNH ĐỘNG TRỌNG TÂM (ACTION PLAN DO AI GEMINI ĐỀ XUẤT)", soCot: 8, kieu: .tieuDeMuc), chieuCao: 25))
        merge1.append("A\(rMucAction):H\(rMucAction)")

        let rHeaderAction = d1.count + 1
        d1.append(DongExcel([
            .chu("STT", kieu: .headerBang),
            .chu("Hạng mục hành động trọng tâm", kieu: .headerBang),
            .chu("Hạng mục hành động trọng tâm", kieu: .headerBang),
            .chu("Mục tiêu số liệu cụ thể", kieu: .headerBang),
            .chu("Mục tiêu số liệu cụ thể", kieu: .headerBang),
            .chu("Người / Bộ phận phụ trách", kieu: .headerBang),
            .chu("Thời hạn kiểm tra", kieu: .headerBang),
            .chu("Mức ưu tiên", kieu: .headerBang)
        ], chieuCao: 26))
        merge1.append("B\(rHeaderAction):C\(rHeaderAction)")
        merge1.append("D\(rHeaderAction):E\(rHeaderAction)")

        for (idx, hd) in hoSo.keHoachHanhDong.enumerated() {
            let r = d1.count + 1
            let kieuUT: KieuOExcel = hd.mucUuTien.uppercased().contains("KHẨN") || hd.mucUuTien.uppercased().contains("NHẤT")
                ? .trangThaiYeu
                : .trangThaiKha
            d1.append(DongExcel([
                .nguyen(idx + 1, kieu: .canGiua),
                .chu(hd.hangMuc, kieu: .inDam),
                .chu("", kieu: .inDam),
                .chu(hd.mucTieuSoLieu, kieu: .macDinh),
                .chu("", kieu: .macDinh),
                .chu(hd.nguoiPhuTrach, kieu: .canGiua),
                .chu(hd.thoiHan, kieu: .canGiua),
                .chu(hd.mucUuTien, kieu: kieuUT)
            ], chieuCao: 28))
            merge1.append("B\(r):C\(r)")
            merge1.append("D\(r):E\(r)")
        }

        d1.append(DongExcel([], chieuCao: 10))

        let rMucBanTin = d1.count + 1
        d1.append(DongExcel(taoHangGop("📰 NỘI DUNG BẢN TIN PHÂN TÍCH GỬI LINE (AI GEMINI / MẪU BÁO CÁO)", soCot: 8, kieu: .tieuDeMuc), chieuCao: 25))
        merge1.append("A\(rMucBanTin):H\(rMucBanTin)")

        let cacDongBanTin = noiDungPhanTich
            .replacingOccurrences(of: "**", with: "")
            .components(separatedBy: .newlines)
        for dong in cacDongBanTin where !dong.trimmingCharacters(in: .whitespaces).isEmpty {
            let r = d1.count + 1
            let laDauMuc = dong.hasPrefix("1)") || dong.hasPrefix("2)") || dong.hasPrefix("3)") || dong.hasPrefix("4)") || dong.hasPrefix("5)") || dong.hasPrefix("📊") || dong.hasPrefix("📈") || dong.hasPrefix("⚡")
            d1.append(DongExcel(taoHangGop(dong, soCot: 8, kieu: laDauMuc ? .inDam : .macDinh), chieuCao: 22))
            merge1.append("A\(r):H\(r)")
        }

        let sheet1 = CauHinhSheetExcel(
            tenSheet: "1_Dashboard_DieuHanh",
            doRongCot: [28, 18, 18, 20, 18, 18, 18, 42],
            cacDong: d1,
            cacGopO: merge1,
            dongCoDinh: 2
        )

        // SHEET 2: CHUYÊN ĐỀ THEO YÊU CẦU NGƯỜI DÙNG (DYNAMIC AI TABLE)
        var d2: [DongExcel] = []
        var merge2: [String] = []
        let cd = hoSo.bangChuyenDe ?? HoSoBaoCaoOfficeAI.taoHoSoChuyenSauTuDuLieu(ngay: ngay, noiDungPhanTich: noiDungPhanTich, yeuCauNguoiDung: yc).bangChuyenDe!
        let soCotCD = max(6, cd.cacCot.count)
        let cotCuoiCD = tenCotExcel(soCotCD - 1)

        d2.append(DongExcel(taoHangGop(cd.tieuDeBang, soCot: soCotCD, kieu: .bannerChinh), chieuCao: 32))
        merge2.append("A1:\(cotCuoiCD)1")

        d2.append(DongExcel(taoHangGop(cd.moTaNgan, soCot: soCotCD, kieu: .bannerPhu), chieuCao: 24))
        merge2.append("A2:\(cotCuoiCD)2")

        d2.append(DongExcel(cd.cacCot.map { .chu($0, kieu: .headerBang) }, chieuCao: 28))

        for (rIdx, dong) in cd.cacDong.enumerated() {
            let kieuNen: KieuOExcel = (rIdx % 2 == 1) ? .vanBanXenKe : .macDinh
            var oDong: [OExcel] = []
            for (cIdx, val) in dong.enumerated() {
                if cIdx == 0, let n = Int(val) {
                    oDong.append(.nguyen(n, kieu: .canGiua))
                } else if val.contains("🟢") {
                    oDong.append(.chu(val, kieu: .trangThaiTot))
                } else if val.contains("🟡") {
                    oDong.append(.chu(val, kieu: .trangThaiKha))
                } else if val.contains("🔴") || val.contains("🔥") || val.contains("🚨") {
                    oDong.append(.chu(val, kieu: .trangThaiYeu))
                } else if cIdx == 1 {
                    oDong.append(.chu(val, kieu: .inDam))
                } else {
                    oDong.append(.chu(val, kieu: kieuNen))
                }
            }
            while oDong.count < soCotCD {
                oDong.append(.chu("", kieu: kieuNen))
            }
            d2.append(DongExcel(oDong, chieuCao: 26))
        }

        d2.append(DongExcel([], chieuCao: 10))
        let rKL = d2.count + 1
        d2.append(DongExcel(taoHangGop("📌 KẾT LUẬN & CHỈ ĐẠO THỰC THI CHUYÊN ĐỀ", soCot: soCotCD, kieu: .tieuDeMuc), chieuCao: 25))
        merge2.append("A\(rKL):\(cotCuoiCD)\(rKL)")

        for dongKL in cd.ketLuanChuyenDe.components(separatedBy: .newlines) where !dongKL.trimmingCharacters(in: .whitespaces).isEmpty {
            let r = d2.count + 1
            d2.append(DongExcel(taoHangGop(dongKL, soCot: soCotCD, kieu: .hopPhanTichAI), chieuCao: 26))
            merge2.append("A\(r):\(cotCuoiCD)\(r)")
        }

        let doRongCD: [Double] = (0..<soCotCD).map { idx in
            if idx == 0 { return 7 }
            if idx == 1 { return 28 }
            if idx == 2 { return 9 }
            if idx >= soCotCD - 2 { return 34 }
            return 16
        }
        let sheet2 = CauHinhSheetExcel(
            tenSheet: "2_ChuyenDe_TheoYeuCau",
            doRongCot: doRongCD,
            cacDong: d2,
            cacGopO: merge2,
            dongCoDinh: 3
        )

        // SHEET 3: BẢNG THI ĐUA NGÀNH HÀNG — LŨY KẾ
        var d3: [DongExcel] = []
        var merge3: [String] = []
        let soCotS3 = 12
        d3.append(DongExcel(taoHangGop("BẢNG THI ĐUA NGÀNH HÀNG — LŨY KẾ THÁNG (\(donVi.uppercased()) • \(ngayStr))", soCot: soCotS3, kieu: .bannerChinh), chieuCao: 32))
        merge3.append("A1:L1")

        d3.append(DongExcel(taoHangGop("Doanh thu Thực: \(dl.doanhThu.doanhThuThuc.chuoiSoGonVN) tr • Doanh thu QĐ: \(dl.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) / Target \(dl.doanhThu.targetQuyDoi.chuoiSoGonVN) tr • Dự kiến HT: \(dl.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram) • Còn \(s.soNgayConLai) ngày", soCot: soCotS3, kieu: .bannerPhu), chieuCao: 24))
        merge3.append("A2:L2")

        d3.append(DongExcel([
            .chu("STT", kieu: .headerBang),
            .chu("Ngành hàng thi đua", kieu: .headerBang),
            .chu("ĐVT", kieu: .headerBang),
            .chu("Thực hiện", kieu: .headerBang),
            .chu("Target tháng", kieu: .headerBang),
            .chu("Còn thiếu", kieu: .headerBang),
            .chu("% Hoàn thành", kieu: .headerBang),
            .chu("Dự kiến cuối tháng", kieu: .headerBang),
            .chu("% Dự kiến", kieu: .headerBang),
            .chu("Cần chạy/Ngày còn lại", kieu: .headerBang),
            .chu("Trạng thái", kieu: .headerBang),
            .chu("Nhận xét & Giải pháp AI Gemini", kieu: .headerBang)
        ], chieuCao: 28))

        let dongBatDauS3 = 4
        let ngayConDouble = Double(max(1, s.soNgayConLai))
        for (i, d) in dl.danhSachThiDua.enumerated() {
            let r = dongBatDauS3 + i
            let thieu = max(0, d.target - d.thucHien)
            let canNgay = thieu / ngayConDouble
            let ptDanhGia = d.phanTramDuBao > 0 ? d.phanTramDuBao : d.phanTramHT
            let nhanTT: String
            let kieuTT: KieuOExcel
            if ptDanhGia >= 100 {
                nhanTT = "🟢 Đạt (\(ptDanhGia.chuoiPhanTram))"
                kieuTT = .trangThaiTot
            } else if ptDanhGia >= 85 {
                nhanTT = "🟡 Sát đích (\(ptDanhGia.chuoiPhanTram))"
                kieuTT = .trangThaiKha
            } else {
                nhanTT = "🔴 Hụt (\(ptDanhGia.chuoiPhanTram))"
                kieuTT = .trangThaiYeu
            }
            let nxAI = hoSo.nhanXetNganhHang[d.tenNganhHang]
                ?? (ptDanhGia >= 100 ? "Duy trì nhịp bán tốt, hỗ trợ kéo doanh thu quy đổi." : "Cần đẩy tối thiểu \(canNgay.chuoiSoGonVN)/ngày trong \(s.soNgayConLai) ngày tới.")

            d3.append(DongExcel([
                .nguyen(i + 1, kieu: .canGiua),
                .chu(d.tenNganhHang, kieu: .inDam),
                .chu(d.loaiChiTieu.maBang, kieu: .canGiua),
                .so(d.thucHien),
                .so(d.target),
                .congThuc("MAX(0,E\(r)-D\(r))", giaTriTam: thieu),
                .congThuc("IF(E\(r)>0,D\(r)/E\(r)*100,0)", giaTriTam: d.phanTramHT, kieu: .phanTram),
                .so(d.duKien),
                .phanTram(d.phanTramDuBao),
                .congThuc("F\(r)/\(max(1, s.soNgayConLai))", giaTriTam: canNgay),
                .chu(nhanTT, kieu: kieuTT),
                .chu(nxAI, kieu: (i % 2 == 1) ? .vanBanXenKe : .macDinh)
            ], chieuCao: 25))
        }

        if !dl.danhSachThiDua.isEmpty {
            let rCuoi = dongBatDauS3 + dl.danhSachThiDua.count - 1
            let tongTH = dl.danhSachThiDua.map(\.thucHien).reduce(0, +)
            let tongTG = dl.danhSachThiDua.map(\.target).reduce(0, +)
            let tongThieu = dl.danhSachThiDua.map { max(0, $0.target - $0.thucHien) }.reduce(0, +)
            let tbHT = dl.danhSachThiDua.map(\.phanTramHT).reduce(0, +) / Double(dl.danhSachThiDua.count)
            let tongDK = dl.danhSachThiDua.map(\.duKien).reduce(0, +)
            let tbDK = dl.danhSachThiDua.map(\.phanTramDuBao).reduce(0, +) / Double(dl.danhSachThiDua.count)
            let soDat = dl.danhSachThiDua.filter { ($0.phanTramDuBao > 0 ? $0.phanTramDuBao : $0.phanTramHT) >= 100 }.count

            d3.append(DongExcel([
                .chu("", kieu: .dongTongKetChu),
                .chu("TỔNG CỘNG / TRUNG BÌNH (\(dl.danhSachThiDua.count) NGÀNH)", kieu: .dongTongKetChu),
                .chu("-", kieu: .dongTongKetChu),
                .congThuc("SUM(D\(dongBatDauS3):D\(rCuoi))", giaTriTam: tongTH, kieu: .dongTongKetSo),
                .congThuc("SUM(E\(dongBatDauS3):E\(rCuoi))", giaTriTam: tongTG, kieu: .dongTongKetSo),
                .congThuc("SUM(F\(dongBatDauS3):F\(rCuoi))", giaTriTam: tongThieu, kieu: .dongTongKetSo),
                .congThuc("AVERAGE(G\(dongBatDauS3):G\(rCuoi))", giaTriTam: tbHT, kieu: .dongTongKetPhanTram),
                .congThuc("SUM(H\(dongBatDauS3):H\(rCuoi))", giaTriTam: tongDK, kieu: .dongTongKetSo),
                .congThuc("AVERAGE(I\(dongBatDauS3):I\(rCuoi))", giaTriTam: tbDK, kieu: .dongTongKetPhanTram),
                .congThuc("SUM(J\(dongBatDauS3):J\(rCuoi))", giaTriTam: tongThieu / ngayConDouble, kieu: .dongTongKetSo),
                .chu("Đạt \(soDat)/\(dl.danhSachThiDua.count) ngành", kieu: .dongTongKetChu),
                .chu("Tập trung dứt điểm nhóm ngành Sát đích (85-99%) và kèm sát nhóm Hụt (<85%)", kieu: .dongTongKetChu)
            ], chieuCao: 27))
        }

        let sheet3 = CauHinhSheetExcel(
            tenSheet: "3_ThiDua_LuyKe",
            doRongCot: [7, 30, 8, 14, 14, 14, 15, 16, 15, 18, 20, 44],
            cacDong: d3,
            cacGopO: merge3,
            dongCoDinh: 3
        )

        // SHEET 4: BẢNG THI ĐUA NGÀNH HÀNG — REALTIME TRONG NGÀY
        var d4: [DongExcel] = []
        var merge4: [String] = []
        let soCotS4 = 9
        d4.append(DongExcel(taoHangGop("BẢNG THI ĐUA NGÀNH HÀNG — REALTIME TRONG NGÀY (\(ngayStr) \(dl.capNhatLuc))", soCot: soCotS4, kieu: .bannerChinh), chieuCao: 32))
        merge4.append("A1:I1")

        d4.append(DongExcel(taoHangGop("DT Thực Realtime: \(dl.doanhThuRealtime.doanhThuThuc.chuoiSoGonVN) tr • DT Quy đổi Realtime: \(dl.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN) / Target ngày \(dl.doanhThuRealtime.targetQuyDoi.chuoiSoGonVN) tr (\(dl.doanhThuRealtime.phanTramHTQDDuKienHienThi.chuoiPhanTram))", soCot: soCotS4, kieu: .bannerPhu), chieuCao: 24))
        merge4.append("A2:I2")

        d4.append(DongExcel([
            .chu("STT", kieu: .headerBang),
            .chu("Ngành hàng thi đua", kieu: .headerBang),
            .chu("ĐVT", kieu: .headerBang),
            .chu("Thực hiện hôm nay", kieu: .headerBang),
            .chu("Target ngày", kieu: .headerBang),
            .chu("Còn thiếu hôm nay", kieu: .headerBang),
            .chu("% Hoàn thành ngày", kieu: .headerBang),
            .chu("Trạng thái ca trực", kieu: .headerBang),
            .chu("Chỉ đạo thúc đẩy trong ca (AI Gemini)", kieu: .headerBang)
        ], chieuCao: 28))

        let dongBatDauS4 = 4
        for (i, d) in dl.danhSachThiDuaRealtime.enumerated() {
            let r = dongBatDauS4 + i
            let thieu = max(0, d.target - d.thucHien)
            let nhanTT: String
            let kieuTT: KieuOExcel
            let goiYCa: String
            if d.phanTramHT >= 100 {
                nhanTT = "🟢 Đã đạt ngày"
                kieuTT = .trangThaiTot
                goiYCa = "✅ Đã vượt mục tiêu ngày. Tiếp tục phát huy bán chéo."
            } else if d.thucHien <= 0 {
                nhanTT = "🔴 Chưa mở điểm (0)"
                kieuTT = .trangThaiYeu
                goiYCa = "🚨 Đang bằng 0! Giao Trưởng ca chỉ định NV mở điểm ngay trong 2 giờ tới (cần \(d.target.chuoiSoGonVN))."
            } else {
                nhanTT = "🟡 Đang chạy (\(d.phanTramHT.chuoiPhanTram))"
                kieuTT = .trangThaiKha
                goiYCa = "⚡ Còn thiếu \(thieu.chuoiSoGonVN) \(d.loaiChiTieu.maBang) để về đích ngày. Tập trung tư vấn khách tại quầy."
            }

            d4.append(DongExcel([
                .nguyen(i + 1, kieu: .canGiua),
                .chu(d.tenNganhHang, kieu: .inDam),
                .chu(d.loaiChiTieu.maBang, kieu: .canGiua),
                .so(d.thucHien),
                .so(d.target),
                .congThuc("MAX(0,E\(r)-D\(r))", giaTriTam: thieu),
                .congThuc("IF(E\(r)>0,D\(r)/E\(r)*100,0)", giaTriTam: d.phanTramHT, kieu: .phanTram),
                .chu(nhanTT, kieu: kieuTT),
                .chu(goiYCa, kieu: (i % 2 == 1) ? .vanBanXenKe : .macDinh)
            ], chieuCao: 25))
        }

        if !dl.danhSachThiDuaRealtime.isEmpty {
            let rCuoi = dongBatDauS4 + dl.danhSachThiDuaRealtime.count - 1
            let tongTH = dl.danhSachThiDuaRealtime.map(\.thucHien).reduce(0, +)
            let tongTG = dl.danhSachThiDuaRealtime.map(\.target).reduce(0, +)
            let tongThieu = dl.danhSachThiDuaRealtime.map { max(0, $0.target - $0.thucHien) }.reduce(0, +)
            let tbHT = dl.danhSachThiDuaRealtime.map(\.phanTramHT).reduce(0, +) / Double(dl.danhSachThiDuaRealtime.count)
            let soBang0 = dl.danhSachThiDuaRealtime.filter { $0.thucHien <= 0 && $0.target > 0 }.count

            d4.append(DongExcel([
                .chu("", kieu: .dongTongKetChu),
                .chu("TỔNG KẾT REALTIME (\(dl.danhSachThiDuaRealtime.count) NGÀNH)", kieu: .dongTongKetChu),
                .chu("-", kieu: .dongTongKetChu),
                .congThuc("SUM(D\(dongBatDauS4):D\(rCuoi))", giaTriTam: tongTH, kieu: .dongTongKetSo),
                .congThuc("SUM(E\(dongBatDauS4):E\(rCuoi))", giaTriTam: tongTG, kieu: .dongTongKetSo),
                .congThuc("SUM(F\(dongBatDauS4):F\(rCuoi))", giaTriTam: tongThieu, kieu: .dongTongKetSo),
                .congThuc("AVERAGE(G\(dongBatDauS4):G\(rCuoi))", giaTriTam: tbHT, kieu: .dongTongKetPhanTram),
                .chu("Còn \(soBang0) ngành = 0", kieu: .dongTongKetChu),
                .chu("Ưu tiên xoá các ngành = 0 trước 15:00 và chốt dứt điểm các ngành > 70%", kieu: .dongTongKetChu)
            ], chieuCao: 27))
        }

        let sheet4 = CauHinhSheetExcel(
            tenSheet: "4_ThiDua_Realtime",
            doRongCot: [7, 30, 8, 16, 15, 16, 16, 20, 44],
            cacDong: d4,
            cacGopO: merge4,
            dongCoDinh: 3
        )

        // SHEET 5: BẢNG XẾP HẠNG & ĐÁNH GIÁ CHI TIẾT 16 NHÂN VIÊN
        var d5: [DongExcel] = []
        var merge5: [String] = []
        let soCotS5 = 13
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe)
        let mapDTLK = Dictionary(uniqueKeysWithValues: dl.doanhThuNhanVien.map { (KhoDuLieu.chuanHoaMaNV($0.maNV), $0) })
        let mapDTRT = Dictionary(uniqueKeysWithValues: dl.doanhThuNhanVienRealtime.map { (KhoDuLieu.chuanHoaMaNV($0.maNV), $0) })

        d5.append(DongExcel(taoHangGop("BẢNG XẾP HẠNG CHI TIẾT NHÂN VIÊN & ĐÁNH GIÁ AI GEMINI (\(ngayStr))", soCot: soCotS5, kieu: .bannerChinh), chieuCao: 32))
        merge5.append("A1:M1")

        d5.append(DongExcel(taoHangGop("Tổng nhân sự: \(dsNV.count) NV • Xếp hạng theo Số môn đạt & % Hoàn thành trung bình • Tích hợp đánh giá kèm cặp cá nhân", soCot: soCotS5, kieu: .bannerPhu), chieuCao: 24))
        merge5.append("A2:M2")

        d5.append(DongExcel([
            .chu("Hạng", kieu: .headerBang),
            .chu("Mã NV", kieu: .headerBang),
            .chu("Họ tên Nhân viên", kieu: .headerBang),
            .chu("Số môn Đạt", kieu: .headerBang),
            .chu("Tổng môn Giao", kieu: .headerBang),
            .chu("Tỷ lệ môn Đạt", kieu: .headerBang),
            .chu("% HT Trung bình", kieu: .headerBang),
            .chu("DT Thực Lũy kế", kieu: .headerBang),
            .chu("DT QĐ Lũy kế", kieu: .headerBang),
            .chu("DT QĐ Realtime", kieu: .headerBang),
            .chu("Số đơn LK", kieu: .headerBang),
            .chu("Xếp loại năng lực", kieu: .headerBang),
            .chu("Đánh giá & Hướng kèm cặp từ AI Gemini", kieu: .headerBang)
        ], chieuCao: 28))

        let dongBatDauS5 = 4
        for (i, nv) in dsNV.enumerated() {
            let r = dongBatDauS5 + i
            let ma = KhoDuLieu.chuanHoaMaNV(nv.nhanVien.maNV)
            let dtLK = mapDTLK[ma]
            let dtRT = mapDTRT[ma]
            let tyLeMon = nv.tongMonGiao > 0 ? (Double(nv.soMonDat) / Double(nv.tongMonGiao) * 100.0) : 0
            let xepLoai: String
            let kieuXL: KieuOExcel
            if nv.phanTramHTTB >= 85 || tyLeMon >= 60 {
                xepLoai = "🟢 Tốt (Hạng \(i + 1))"
                kieuXL = .trangThaiTot
            } else if nv.phanTramHTTB >= 60 || tyLeMon >= 35 {
                xepLoai = "🟡 Khá - TB"
                kieuXL = .trangThaiKha
            } else {
                xepLoai = "🔴 Cần kèm sát"
                kieuXL = .trangThaiYeu
            }
            let nxNV = hoSo.nhanXetNhanVien[nv.nhanVien.maNV]
                ?? hoSo.nhanXetNhanVien[nv.nhanVien.hoTen]
                ?? "Đạt \(nv.soMonDat)/\(nv.tongMonGiao) môn (TB \(nv.phanTramHTTB.chuoiPhanTram))."

            d5.append(DongExcel([
                .nguyen(i + 1, kieu: .canGiua),
                .chu(nv.nhanVien.maNV, kieu: .canGiua),
                .chu(nv.nhanVien.hoTen, kieu: .inDam),
                .nguyen(nv.soMonDat, kieu: .soNguyen),
                .nguyen(nv.tongMonGiao, kieu: .soNguyen),
                .congThuc("IF(E\(r)>0,D\(r)/E\(r)*100,0)", giaTriTam: tyLeMon, kieu: .phanTram),
                .phanTram(nv.phanTramHTTB),
                .so(dtLK?.doanhThuThuc ?? 0),
                .so(dtLK?.doanhThuQD ?? nv.doanhThuQD),
                .so(dtRT?.doanhThuQD ?? 0),
                .so(dtLK?.soLuong ?? nv.soLuongDon, kieu: .soNguyen),
                .chu(xepLoai, kieu: kieuXL),
                .chu(nxNV, kieu: (i % 2 == 1) ? .vanBanXenKe : .macDinh)
            ], chieuCao: 26))
        }

        if !dsNV.isEmpty {
            let rCuoi = dongBatDauS5 + dsNV.count - 1
            let tbMonDat = Double(dsNV.map(\.soMonDat).reduce(0, +)) / Double(dsNV.count)
            let tbTongMon = Double(dsNV.map(\.tongMonGiao).reduce(0, +)) / Double(dsNV.count)
            let tbHT = dsNV.map(\.phanTramHTTB).reduce(0, +) / Double(dsNV.count)
            let tongDTThuc = dsNV.map { mapDTLK[KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV)]?.doanhThuThuc ?? 0 }.reduce(0, +)
            let tongDTQD = dsNV.map { mapDTLK[KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV)]?.doanhThuQD ?? $0.doanhThuQD }.reduce(0, +)
            let tongDTRT = dsNV.map { mapDTRT[KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV)]?.doanhThuQD ?? 0 }.reduce(0, +)
            let tongDon = dsNV.map { mapDTLK[KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV)]?.soLuong ?? $0.soLuongDon }.reduce(0, +)

            d5.append(DongExcel([
                .chu("", kieu: .dongTongKetChu),
                .chu("-", kieu: .dongTongKetChu),
                .chu("TỔNG / TRUNG BÌNH ĐỘI NGŨ (\(dsNV.count) NV)", kieu: .dongTongKetChu),
                .congThuc("AVERAGE(D\(dongBatDauS5):D\(rCuoi))", giaTriTam: tbMonDat, kieu: .dongTongKetSo),
                .congThuc("AVERAGE(E\(dongBatDauS5):E\(rCuoi))", giaTriTam: tbTongMon, kieu: .dongTongKetSo),
                .congThuc("AVERAGE(F\(dongBatDauS5):F\(rCuoi))", giaTriTam: tbTongMon > 0 ? (tbMonDat / tbTongMon * 100) : 0, kieu: .dongTongKetPhanTram),
                .congThuc("AVERAGE(G\(dongBatDauS5):G\(rCuoi))", giaTriTam: tbHT, kieu: .dongTongKetPhanTram),
                .congThuc("SUM(H\(dongBatDauS5):H\(rCuoi))", giaTriTam: tongDTThuc, kieu: .dongTongKetSo),
                .congThuc("SUM(I\(dongBatDauS5):I\(rCuoi))", giaTriTam: tongDTQD, kieu: .dongTongKetSo),
                .congThuc("SUM(J\(dongBatDauS5):J\(rCuoi))", giaTriTam: tongDTRT, kieu: .dongTongKetSo),
                .congThuc("SUM(K\(dongBatDauS5):K\(rCuoi))", giaTriTam: tongDon, kieu: .dongTongKetSo),
                .chu("Đội ngũ ĐMX", kieu: .dongTongKetChu),
                .chu("Phân công nhóm Tốt kèm cặp nhóm Cần kèm sát theo từng ngành hàng", kieu: .dongTongKetChu)
            ], chieuCao: 27))
        }

        let sheet5 = CauHinhSheetExcel(
            tenSheet: "5_XepHang_16NhanVien",
            doRongCot: [7, 12, 24, 12, 13, 14, 15, 16, 16, 16, 12, 18, 46],
            cacDong: d5,
            cacGopO: merge5,
            dongCoDinh: 3
        )

        // SHEET 6: BÁO CÁO SỨC KHỎE ĐỘI NGŨ, TOP 5 YẾU LIÊN TIẾP & MA TRẬN NHIỆT NGÀY
        var d6: [DongExcel] = []
        var merge6: [String] = []
        let cacNhanNgay = bcSucKhoe.cacNhanNgayTheoDoi
        let soCotS6 = max(9, 7 + cacNhanNgay.count)
        let cotCuoiS6 = tenCotExcel(soCotS6 - 1)

        d6.append(DongExcel(taoHangGop("BÁO CÁO SỨC KHỎE ĐỘI NGŨ & CẢNH BÁO TOP 5 NHÂN VIÊN YẾU LIÊN TIẾP (\(ngayStr))", soCot: soCotS6, kieu: .bannerChinh), chieuCao: 32))
        merge6.append("A1:\(cotCuoiS6)1")

        d6.append(DongExcel(taoHangGop("Điểm Sức khỏe TB Đội ngũ: \(String(format: "%.1f%%", bcSucKhoe.diemTrungBinhDoiNgu)) • 🟢 Khỏe (>=75%): \(bcSucKhoe.soNVKhoe) NV • 🟡 Trung bình (55-74%): \(bcSucKhoe.soNVTrungBinh) NV • 🔴 Yếu (<55%): \(bcSucKhoe.soNVYeu) NV", soCot: soCotS6, kieu: .bannerPhu), chieuCao: 24))
        merge6.append("A2:\(cotCuoiS6)2")

        let rMucTop5 = d6.count + 1
        d6.append(DongExcel(taoHangGop("🚨 CẢNH BÁO TOP 5 NHÂN VIÊN YẾU NHIỀU NGÀY LIÊN TỤC (CẦN KÈM CẶP 1-1 NGAY TRONG CA)", soCot: soCotS6, kieu: .tieuDeMuc), chieuCao: 25))
        merge6.append("A\(rMucTop5):\(cotCuoiS6)\(rMucTop5)")

        d6.append(DongExcel([
            .chu("Mức Cảnh Báo", kieu: .headerBang),
            .chu("Mã NV", kieu: .headerBang),
            .chu("Họ tên Nhân viên", kieu: .headerBang),
            .chu("Điểm Sức khỏe", kieu: .headerBang),
            .chu("Chuỗi ngày yếu", kieu: .headerBang),
            .chu("Số môn Đạt / Giao", kieu: .headerBang),
            .chu("Các ngành hàng yếu nhất cần kèm cặp", kieu: .headerBang),
            .chu("Chỉ đạo kèm cặp từ AI Gemini", kieu: .headerBang),
            .chu("Cam kết hoàn thành", kieu: .headerBang)
        ], chieuCao: 28))

        for (idx, hs) in bcSucKhoe.top5CanhBaoYeu.enumerated() {
            let monYeu = hs.cacMonYeuNhat.isEmpty ? "Cần rà soát các môn = 0" : hs.cacMonYeuNhat.joined(separator: ", ")
            let nxAI = hoSo.nhanXetNhanVien[hs.nhanVien.maNV] ?? "Kèm cặp 1-1 đầu ca, yêu cầu mở điểm ít nhất 2 môn đang bằng 0 trong hôm nay."
            d6.append(DongExcel([
                .chu("🚨 Cảnh báo #\(idx + 1)", kieu: .trangThaiYeu),
                .chu(hs.nhanVien.maNV, kieu: .canGiua),
                .chu(hs.nhanVien.hoTen, kieu: .inDam),
                .phanTram(hs.diemSucKhoe, kieu: .trangThaiYeu),
                .chu(hs.chuoiCanhBaoYeu, kieu: .trangThaiYeu),
                .chu("\(hs.tongHopHienTai.soMonDat)/\(hs.tongHopHienTai.tongMonGiao) môn", kieu: .canGiua),
                .chu(monYeu, kieu: .macDinh),
                .chu(nxAI, kieu: .macDinh),
                .chu("Kiểm tra kết ca", kieu: .canGiua)
            ], chieuCao: 26))
        }

        d6.append(DongExcel([], chieuCao: 10))

        let rMucMaTran = d6.count + 1
        d6.append(DongExcel(taoHangGop("🌡️ BẢNG MA TRẬN NHIỆT (HEATMAP) ĐIỂM SỨC KHỎE TOÀN ĐỘI NGŨ THEO NGÀY", soCot: soCotS6, kieu: .tieuDeMuc), chieuCao: 25))
        merge6.append("A\(rMucMaTran):\(cotCuoiS6)\(rMucMaTran)")

        var headerMaTran: [OExcel] = [
            .chu("Hạng", kieu: .headerBang),
            .chu("Mã NV", kieu: .headerBang),
            .chu("Họ tên Nhân viên", kieu: .headerBang),
            .chu("Điểm SK Hiện tại", kieu: .headerBang),
            .chu("Phân tầng", kieu: .headerBang),
            .chu("Xu hướng", kieu: .headerBang),
            .chu("Chuỗi yếu LT", kieu: .headerBang)
        ]
        for nhan in cacNhanNgay {
            headerMaTran.append(.chu("Ngày \(nhan)", kieu: .headerBang))
        }
        d6.append(DongExcel(headerMaTran, chieuCao: 28))

        for (idx, hs) in bcSucKhoe.danhSachTatCa.enumerated() {
            let kieuMuc: KieuOExcel
            switch hs.mucDo {
            case .khoe: kieuMuc = .trangThaiTot
            case .trungBinh: kieuMuc = .trangThaiKha
            case .yeu, .chuaCoSo: kieuMuc = .trangThaiYeu
            }
            var oDong: [OExcel] = [
                .nguyen(idx + 1, kieu: .canGiua),
                .chu(hs.nhanVien.maNV, kieu: .canGiua),
                .chu(hs.nhanVien.hoTen, kieu: .inDam),
                .phanTram(hs.diemSucKhoe, kieu: kieuMuc),
                .chu("\(hs.mucDo.kyHieu) \(hs.mucDo.nhan)", kieu: kieuMuc),
                .chu(hs.nhanXuHuong, kieu: .canGiua),
                .chu(hs.soNgayYeuLienTuc > 0 ? "\(hs.soNgayYeuLienTuc) ngày" : "0", kieu: hs.soNgayYeuLienTuc >= 2 ? .trangThaiYeu : .canGiua)
            ]
            let mapNgay = Dictionary(uniqueKeysWithValues: hs.lichSuNgay.map { ($0.nhanNgay, $0) })
            for nhan in cacNhanNgay {
                if let dNgay = mapNgay[nhan] {
                    let kNgay: KieuOExcel
                    switch dNgay.mucDo {
                    case .khoe: kNgay = .trangThaiTot
                    case .trungBinh: kNgay = .trangThaiKha
                    case .yeu: kNgay = .trangThaiYeu
                    case .chuaCoSo: kNgay = .canGiua
                    }
                    oDong.append(.phanTram(dNgay.diemSucKhoe, kieu: kNgay))
                } else {
                    oDong.append(.chu("-", kieu: .canGiua))
                }
            }
            d6.append(DongExcel(oDong, chieuCao: 24))
        }

        var doRongS6: [Double] = [14, 12, 24, 15, 18, 14, 28, 38, 16]
        while doRongS6.count < soCotS6 {
            doRongS6.append(12)
        }
        let sheet6 = CauHinhSheetExcel(
            tenSheet: "6_SucKhoe_CanhBaoNV",
            doRongCot: doRongS6,
            cacDong: d6,
            cacGopO: merge6,
            dongCoDinh: 2
        )

        // SHEET 7: LỊCH SỬ DOANH THU REALTIME THEO NGÀY TRONG THÁNG & DỰ BÁO
        var d7: [DongExcel] = []
        var merge7: [String] = []
        let soCotS7 = 8
        let dsNgayRT = KhoDuLieu.dungChung.danhSachRealtimeTheoNgayTrongThang(cho: ngay)

        d7.append(DongExcel(taoHangGop("BẢNG THEO DÕI DOANH THU REALTIME THEO NGÀY TRONG THÁNG & DỰ KIẾN CUỐI THÁNG", soCot: soCotS7, kieu: .bannerChinh), chieuCao: 32))
        merge7.append("A1:H1")

        d7.append(DongExcel(taoHangGop("Mục tiêu QĐ Tháng: \(duBao.mucTieuThang.chuoiSoGonVN) tr • Định mức chuẩn: \(duBao.mucTieuMoiNgay.chuoiSoGonVN) tr/ngày • Đã cập nhật: \(duBao.soNgayCoRealtime)/\(duBao.soNgayTrongThang) ngày", soCot: soCotS7, kieu: .bannerPhu), chieuCao: 24))
        merge7.append("A2:H2")

        d7.append(DongExcel([
            .chu("Ngày", kieu: .headerBang),
            .chu("Mã ngày", kieu: .headerBang),
            .chu("Doanh thu Thực (Tr)", kieu: .headerBang),
            .chu("Doanh thu Quy đổi (Tr)", kieu: .headerBang),
            .chu("Mục tiêu QĐ Ngày (Tr)", kieu: .headerBang),
            .chu("Chênh lệch Ngày (Tr)", kieu: .headerBang),
            .chu("% Hoàn thành Ngày", kieu: .headerBang),
            .chu("Đánh giá nhịp độ ngày", kieu: .headerBang)
        ], chieuCao: 28))

        let dongBatDauS7 = 4
        var soDongRT = 0
        for item in dsNgayRT where item.coDuLieu || item.khoaNgay <= dl.khoaNgay {
            let r = dongBatDauS7 + soDongRT
            soDongRT += 1
            let mtNgay = item.doanhThu.targetQuyDoi > 0 ? item.doanhThu.targetQuyDoi : duBao.mucTieuMoiNgay
            let chenh = item.doanhThuQuyDoi - mtNgay
            let ptNgay = mtNgay > 0 ? (item.doanhThuQuyDoi / mtNgay * 100.0) : item.doanhThu.phanTramHTQDDuKienHienThi
            let danhGia: String
            let kieuDG: KieuOExcel
            if !item.coDuLieu {
                danhGia = "⚪ Chưa nhập số Realtime"
                kieuDG = .canGiua
            } else if ptNgay >= 100 {
                danhGia = "🟢 Vượt định mức ngày (+\(max(0, chenh).chuoiSoGonVN) tr)"
                kieuDG = .trangThaiTot
            } else if ptNgay >= 85 {
                danhGia = "🟡 Bám sát định mức (\(ptNgay.chuoiPhanTram))"
                kieuDG = .trangThaiKha
            } else {
                danhGia = "🔴 Hụt định mức ngày (\(chenh.chuoiSoGonVN) tr)"
                kieuDG = .trangThaiYeu
            }

            d7.append(DongExcel([
                .chu("Ngày \(String(format: "%02d", item.ngayTrongThang))", kieu: .canGiua),
                .chu(item.khoaNgay, kieu: .canGiua),
                .so(item.doanhThuThuc),
                .so(item.doanhThuQuyDoi),
                .so(mtNgay),
                .congThuc("D\(r)-E\(r)", giaTriTam: chenh),
                .congThuc("IF(E\(r)>0,D\(r)/E\(r)*100,0)", giaTriTam: ptNgay, kieu: .phanTram),
                .chu(danhGia, kieu: kieuDG)
            ], chieuCao: 24))
        }

        if soDongRT > 0 {
            let rCuoi = dongBatDauS7 + soDongRT - 1
            d7.append(DongExcel([
                .chu("TỔNG", kieu: .dongTongKetChu),
                .chu("\(duBao.soNgayCoRealtime) ngày có số", kieu: .dongTongKetChu),
                .congThuc("SUM(C\(dongBatDauS7):C\(rCuoi))", giaTriTam: duBao.tongDTThucRealtime, kieu: .dongTongKetSo),
                .congThuc("SUM(D\(dongBatDauS7):D\(rCuoi))", giaTriTam: duBao.tongDTQDRealtime, kieu: .dongTongKetSo),
                .congThuc("SUM(E\(dongBatDauS7):E\(rCuoi))", giaTriTam: duBao.mucTieuMoiNgay * Double(soDongRT), kieu: .dongTongKetSo),
                .congThuc("SUM(F\(dongBatDauS7):F\(rCuoi))", giaTriTam: duBao.tongDTQDRealtime - duBao.mucTieuMoiNgay * Double(soDongRT), kieu: .dongTongKetSo),
                .phanTram(duBao.phanTramHTQDDuKien, kieu: .dongTongKetPhanTram),
                .chu("Tổng lũy kế từ các ngày có Realtime", kieu: .dongTongKetChu)
            ], chieuCao: 26))

            d7.append(DongExcel([
                .chu("TB / NGÀY", kieu: .dongTongKetChu),
                .chu("Bình quân ngày", kieu: .dongTongKetChu),
                .so(duBao.trungBinhThucMoiNgay, kieu: .dongTongKetSo),
                .so(duBao.trungBinhQDMoiNgay, kieu: .dongTongKetSo),
                .so(duBao.mucTieuMoiNgay, kieu: .dongTongKetSo),
                .so(duBao.trungBinhQDMoiNgay - duBao.mucTieuMoiNgay, kieu: .dongTongKetSo),
                .phanTram(duBao.phanTramHTQDDuKien, kieu: .dongTongKetPhanTram),
                .chu("Nhịp độ bình quân thực tế mỗi ngày", kieu: .dongTongKetChu)
            ], chieuCao: 26))

            d7.append(DongExcel([
                .chu("DK CUỐI THÁNG", kieu: .dongTongKetChu),
                .chu("\(duBao.soNgayTrongThang) ngày tháng", kieu: .dongTongKetChu),
                .so(duBao.duKienThucCuoiThang, kieu: .dongTongKetSo),
                .so(duBao.duKienQDCuoiThang, kieu: .dongTongKetSo),
                .so(duBao.mucTieuThang, kieu: .dongTongKetSo),
                .so(duBao.duKienQDCuoiThang - duBao.mucTieuThang, kieu: .dongTongKetSo),
                .phanTram(duBao.phanTramHTQDDuKien, kieu: .dongTongKetPhanTram),
                .chu("Dự kiến hoàn thành cuối tháng theo tốc độ hiện tại", kieu: .dongTongKetChu)
            ], chieuCao: 26))
        }

        let sheet7 = CauHinhSheetExcel(
            tenSheet: "7_LichSu_RealtimeThang",
            doRongCot: [12, 14, 18, 20, 18, 18, 18, 36],
            cacDong: d7,
            cacGopO: merge7,
            dongCoDinh: 3
        )

        let tatCaSheet = [sheet1, sheet2, sheet3, sheet4, sheet5, sheet6, sheet7]

        var contentTypesLines = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">",
            "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>",
            "<Default Extension=\"xml\" ContentType=\"application/xml\"/>",
            "<Override PartName=\"/xl/workbook.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml\"/>",
            "<Override PartName=\"/xl/styles.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml\"/>"
        ]
        for idx in 1...tatCaSheet.count {
            contentTypesLines.append("<Override PartName=\"/xl/worksheets/sheet\(idx).xml\" ContentType=\"application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml\"/>")
        }
        contentTypesLines.append("</Types>")
        let contentTypes = contentTypesLines.joined(separator: "\n")

        let relsRoot = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">",
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"xl/workbook.xml\"/>",
            "</Relationships>"
        ].joined(separator: "\n")

        var workbookLines = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<workbook xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\">",
            "<sheets>"
        ]
        for (idx, sh) in tatCaSheet.enumerated() {
            let sId = idx + 1
            workbookLines.append("<sheet name=\"\(thoatXML(sh.tenSheet))\" sheetId=\"\(sId)\" r:id=\"rId\(sId)\"/>")
        }
        workbookLines.append("</sheets>")
        workbookLines.append("</workbook>")
        let workbookXML = workbookLines.joined(separator: "\n")

        var wbRelsLines = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">"
        ]
        for idx in 1...tatCaSheet.count {
            wbRelsLines.append("<Relationship Id=\"rId\(idx)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet\(idx).xml\"/>")
        }
        wbRelsLines.append("<Relationship Id=\"rId\(tatCaSheet.count + 1)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/>")
        wbRelsLines.append("</Relationships>")
        let workbookRels = wbRelsLines.joined(separator: "\n")

        let stylesXML = taoStylesXMLChuyenNghiep()

        var cacTep: [(String, Data)] = [
            ("[Content_Types].xml", Data(contentTypes.utf8)),
            ("_rels/.rels", Data(relsRoot.utf8)),
            ("xl/workbook.xml", Data(workbookXML.utf8)),
            ("xl/_rels/workbook.xml.rels", Data(workbookRels.utf8)),
            ("xl/styles.xml", Data(stylesXML.utf8))
        ]
        for (idx, sh) in tatCaSheet.enumerated() {
            let xml = taoSheetXMLNangCao(sh)
            cacTep.append(("xl/worksheets/sheet\(idx + 1).xml", Data(xml.utf8)))
        }

        let duLieuZip = dongGoiZipStore(cacTep: cacTep)
        let tenTep = "BaoCao-DMX-ChiTiet-\(dl.khoaNgay).xlsx"
        let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
        do {
            try duLieuZip.write(to: duongDan, options: .atomic)
            return duongDan
        } catch {
            return nil
        }
    }

    // MARK: - Xuất File PowerPoint (.pptx) 6 Slide Thiết Kế Đồ Họa Chuyên Nghiệp

    static func xuatFilePowerPointPPTX(
        ngay: Date,
        noiDungPhanTich: String,
        yeuCauNguoiDung: String = "",
        hoSoAI: HoSoBaoCaoOfficeAI? = nil
    ) -> URL? {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let donVi = dl.thongTinDonVi.isEmpty ? "Siêu thị Điện Máy Xanh" : dl.thongTinDonVi
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngay, khung: KhungBanTin.theoGio())
        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngay, cheDoDangXem: .luyKe)
        let bcSK = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: .luyKe)
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: .luyKe)

        let yc = yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai.trimmingCharacters(in: .whitespacesAndNewlines)
            : yeuCauNguoiDung.trimmingCharacters(in: .whitespacesAndNewlines)

        let hoSo = hoSoAI ?? HoSoBaoCaoOfficeAI.taoHoSoChuyenSauTuDuLieu(
            ngay: ngay,
            noiDungPhanTich: noiDungPhanTich,
            yeuCauNguoiDung: yc
        )

        let soNganhLK = dl.danhSachThiDua.filter { $0.target > 0 }.count
        let soDatLK = dl.danhSachThiDua.filter { $0.target > 0 && ($0.phanTramDuBao >= 100 || $0.phanTramHT >= 100) }.count

        let theKPI1: [(tieuDe: String, giaTri: String, phu: String, mauVien: String, mauNen: String)] = [
            ("DOANH THU THỰC LŨY KẾ", "\(dl.doanhThu.doanhThuThuc.chuoiSoGonVN) tr", "Target: \(dl.doanhThu.targetThuc.chuoiSoGonVN) tr", "1D4ED8", "EFF6FF"),
            ("DOANH THU QUY ĐỔI LK", "\(dl.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) tr", "Target: \(dl.doanhThu.targetQuyDoi.chuoiSoGonVN) tr", "1E40AF", "DBEAFE"),
            ("% HT QĐ DỰ KIẾN THÁNG", dl.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram, "Còn \(s.soNgayConLai) ngày về đích", dl.doanhThu.phanTramHTQDDuKienHienThi >= 100 ? "15803D" : "B45309", dl.doanhThu.phanTramHTQDDuKienHienThi >= 100 ? "DCFCE7" : "FEF3C2"),
            ("THI ĐUA & SỨC KHỎE NV", "\(soDatLK)/\(soNganhLK) Ngành", "SK Đội ngũ: \(String(format: "%.0f%%", bcSK.diemTrungBinhDoiNgu))", "0F766E", "CCFBF1")
        ]

        let bangSlide1: [[String]] = [
            ["Hạng mục Báo cáo", "Doanh thu Thực", "Doanh thu Quy đổi", "Target Quy đổi", "% Hoàn thành", "Nhận định điều hành"],
            ["Lũy kế tháng (\(ngayStr))", "\(dl.doanhThu.doanhThuThuc.chuoiSoGonVN) tr", "\(dl.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) tr", "\(dl.doanhThu.targetQuyDoi.chuoiSoGonVN) tr", dl.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram, hoSo.tomTatDieuHanh],
            ["Realtime trong ngày", "\(dl.doanhThuRealtime.doanhThuThuc.chuoiSoGonVN) tr", "\(dl.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN) tr", "\(dl.doanhThuRealtime.targetQuyDoi.chuoiSoGonVN) tr", dl.doanhThuRealtime.phanTramHTQDDuKienHienThi.chuoiPhanTram, "Lượt khách: \(Int(dl.doanhThuRealtime.luotKhach)) • Trả góp: \(dl.doanhThuRealtime.phanTramTraGop.chuoiPhanTram)"],
            ["Dự báo cuối tháng", "\(duBao.duKienThucCuoiThang.chuoiSoGonVN) tr", "\(duBao.duKienQDCuoiThang.chuoiSoGonVN) tr", "\(duBao.mucTieuThang.chuoiSoGonVN) tr", duBao.phanTramHTQDDuKien.chuoiPhanTram, "TB ngày: \(duBao.trungBinhQDMoiNgay.chuoiSoGonVN) tr / Định mức: \(duBao.mucTieuMoiNgay.chuoiSoGonVN) tr"]
        ]
        let slide1XML = taoSlideChuyenNghiepXML(
            tieuDe: hoSo.tieuDeBaoCao,
            phuDe: hoSo.phuDeBaoCao,
            theKPI: theKPI1,
            tieuDeBang: "BẢNG TỔNG HỢP CHỈ SỐ DOANH THU & DỰ BÁO ĐIỀU HÀNH",
            doRongCotBang: [1900000, 1400000, 1500000, 1500000, 1300000, 3677600],
            cacDongBang: bangSlide1,
            tieuDeHopAI: "🤖 NHẬN ĐỊNH TRỌNG TÂM TỪ AI GEMINI",
            noiDungHopAI: hoSo.phanTichTheoYeuCau
        )

        var bangSlide2: [[String]] = [
            ["STT", "Hạng mục hành động trọng tâm", "Mục tiêu số liệu cụ thể", "Người phụ trách", "Thời hạn", "Ưu tiên"]
        ]
        for (idx, hd) in hoSo.keHoachHanhDong.prefix(6).enumerated() {
            bangSlide2.append([
                String(idx + 1),
                hd.hangMuc,
                hd.mucTieuSoLieu,
                hd.nguoiPhuTrach,
                hd.thoiHan,
                hd.mucUuTien
            ])
        }
        let slide2XML = taoSlideChuyenNghiepXML(
            tieuDe: "KẾ HOẠCH HÀNH ĐỘNG & CHUYÊN ĐỀ THEO YÊU CẦU NGƯỜI DÙNG",
            phuDe: "Phân công mục tiêu cụ thể theo ca trực — \(donVi) (\(ngayStr))",
            theKPI: [],
            tieuDeBang: "BẢNG PHÂN CÔNG HÀNH ĐỘNG TRỌNG TÂM (ACTION PLAN)",
            doRongCotBang: [650000, 3100000, 3300000, 1800000, 1327600, 1100000],
            cacDongBang: bangSlide2,
            tieuDeHopAI: "📌 CHI TIẾT BẢN TIN ĐIỀU HÀNH GỬI LINE",
            noiDungHopAI: noiDungPhanTich.replacingOccurrences(of: "**", with: "")
        )

        var bangSlide3: [[String]] = [
            ["STT", "Ngành hàng", "Thực hiện", "Target", "Còn thiếu", "% Dự kiến", "Định mức/Ngày", "Giải pháp AI Gemini"]
        ]
        let ngayCon = Double(max(1, s.soNgayConLai))
        for (idx, d) in dl.danhSachThiDua.prefix(10).enumerated() {
            let thieu = max(0, d.target - d.thucHien)
            let pt = d.phanTramDuBao > 0 ? d.phanTramDuBao : d.phanTramHT
            let nx = hoSo.nhanXetNganhHang[d.tenNganhHang] ?? (pt >= 100 ? "Đạt tiến độ tốt" : "Cần đẩy \((thieu / ngayCon).chuoiSoGonVN)/ngày")
            bangSlide3.append([
                String(idx + 1),
                d.tenNganhHang,
                d.thucHien.chuoiSoGonVN,
                d.target.chuoiSoGonVN,
                thieu.chuoiSoGonVN,
                pt.chuoiPhanTram,
                (thieu / ngayCon).chuoiSoGonVN,
                nx
            ])
        }
        let slide3XML = taoSlideChuyenNghiepXML(
            tieuDe: "THI ĐUA NGÀNH HÀNG — LŨY KẾ & ĐỊNH MỨC \(s.soNgayConLai) NGÀY CUỐI THÁNG",
            phuDe: "Tổng số ngành đạt dự kiến: \(soDatLK)/\(soNganhLK) ngành • Đơn vị: \(donVi) (\(ngayStr))",
            theKPI: [],
            tieuDeBang: "BẢNG CHI TIẾT TIẾN ĐỘ NGÀNH HÀNG LŨY KẾ & GIẢI PHÁP BÙ HỤT",
            doRongCotBang: [600000, 2300000, 1100000, 1100000, 1100000, 1150000, 1250000, 2677600],
            cacDongBang: bangSlide3,
            tieuDeHopAI: "💡 CHỈ ĐẠO BỨT TỐC NGÀNH HÀNG TỪ AI GEMINI",
            noiDungHopAI: hoSo.tomTatDieuHanh
        )

        var bangSlide4: [[String]] = [
            ["STT", "Ngành hàng", "ĐVT", "Thực hiện ngày", "Target ngày", "Còn thiếu", "% HT Ngày", "Trạng thái & Hành động ca"]
        ]
        for (idx, d) in dl.danhSachThiDuaRealtime.prefix(10).enumerated() {
            let thieu = max(0, d.target - d.thucHien)
            let tt = d.phanTramHT >= 100 ? "🟢 Đã đạt ngày" : (d.thucHien <= 0 ? "🔴 Đang = 0 (Mở điểm ngay)" : "🟡 Thiếu \(thieu.chuoiSoGonVN)")
            bangSlide4.append([
                String(idx + 1),
                d.tenNganhHang,
                d.loaiChiTieu.maBang,
                d.thucHien.chuoiSoGonVN,
                d.target.chuoiSoGonVN,
                thieu.chuoiSoGonVN,
                d.phanTramHT.chuoiPhanTram,
                tt
            ])
        }
        let soBang0RT = dl.danhSachThiDuaRealtime.filter { $0.thucHien <= 0 && $0.target > 0 }.count
        let slide4XML = taoSlideChuyenNghiepXML(
            tieuDe: "THI ĐUA NGÀNH HÀNG — REALTIME TRONG NGÀY (\(ngayStr))",
            phuDe: "DT Thực: \(dl.doanhThuRealtime.doanhThuThuc.chuoiSoGonVN) tr • DT QĐ: \(dl.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN)/\(dl.doanhThuRealtime.targetQuyDoi.chuoiSoGonVN) tr (\(dl.doanhThuRealtime.phanTramHTQDDuKienHienThi.chuoiPhanTram)) • Còn \(soBang0RT) ngành = 0",
            theKPI: [],
            tieuDeBang: "BẢNG THEO DÕI TIẾN ĐỘ REALTIME TRONG CA TRỰC",
            doRongCotBang: [600000, 2600000, 750000, 1300000, 1300000, 1250000, 1250000, 2227600],
            cacDongBang: bangSlide4,
            tieuDeHopAI: "⚡ TRỌNG TÂM CA TRỰC HÔM NAY",
            noiDungHopAI: "Ưu tiên mở điểm ngay cho \(soBang0RT) ngành hàng đang bằng 0 và đẩy dứt điểm các ngành đã đạt trên 70% mục tiêu ngày."
        )

        var bangSlide5: [[String]] = [
            ["Hạng", "Mã NV", "Họ tên Nhân viên", "Môn Đạt", "% HT TB", "DT QĐ Lũy kế", "Xếp loại", "Đánh giá & Hướng kèm cặp AI"]
        ]
        for (idx, nv) in dsNV.prefix(10).enumerated() {
            let xl = nv.phanTramHTTB >= 85 ? "🟢 Tốt" : (nv.phanTramHTTB >= 60 ? "🟡 Khá" : "🔴 Cần kèm")
            let nx = hoSo.nhanXetNhanVien[nv.nhanVien.maNV] ?? "Đạt \(nv.soMonDat)/\(nv.tongMonGiao) môn (TB \(nv.phanTramHTTB.chuoiPhanTram))"
            bangSlide5.append([
                String(idx + 1),
                nv.nhanVien.maNV,
                nv.nhanVien.hoTen,
                "\(nv.soMonDat)/\(nv.tongMonGiao)",
                nv.phanTramHTTB.chuoiPhanTram,
                "\(nv.doanhThuQD.chuoiSoGonVN) tr",
                xl,
                nx
            ])
        }
        let slide5XML = taoSlideChuyenNghiepXML(
            tieuDe: "BẢNG XẾP HẠNG NHÂN VIÊN & ĐÁNH GIÁ KÈM CẶP CÁ NHÂN",
            phuDe: "Tổng hợp \(dsNV.count) nhân viên siêu thị \(donVi) đến ngày \(ngayStr)",
            theKPI: [],
            tieuDeBang: "BẢNG XẾP HẠNG HIỆU SUẤT THI ĐUA & DOANH THU QUY ĐỔI NHÂN VIÊN",
            doRongCotBang: [650000, 1050000, 2100000, 1000000, 1100000, 1300000, 1150000, 2927600],
            cacDongBang: bangSlide5,
            tieuDeHopAI: "🏆 GHI NHẬN TOP ĐẦU & PHÂN CÔNG HỖ TRỢ ĐỒNG ĐỘI",
            noiDungHopAI: "Biểu dương Top 3 nhân sự dẫn đầu bảng tổng sắp; giao nhiệm vụ kèm cặp trực tiếp các bạn nhóm cuối bảng mở điểm các mặt hàng đang bằng 0."
        )

        var bangSlide6: [[String]] = [
            ["Cảnh báo", "Mã NV", "Họ tên Nhân viên", "Điểm SK", "Chuỗi ngày yếu", "Môn Đạt", "Các ngành hàng yếu nhất cần gỡ ngay"]
        ]
        for (idx, hs) in bcSK.top5CanhBaoYeu.enumerated() {
            bangSlide6.append([
                "🚨 Top \(idx + 1)",
                hs.nhanVien.maNV,
                hs.nhanVien.hoTen,
                "\(Int(round(hs.diemSucKhoe)))%",
                hs.chuoiCanhBaoYeu,
                "\(hs.tongHopHienTai.soMonDat)/\(hs.tongHopHienTai.tongMonGiao)",
                hs.cacMonYeuNhat.isEmpty ? "Cần xoá các môn = 0" : hs.cacMonYeuNhat.joined(separator: ", ")
            ])
        }
        if bangSlide6.count == 1 {
            for (idx, hs) in bcSK.danhSachTatCa.prefix(6).enumerated() {
                bangSlide6.append([
                    "\(hs.mucDo.kyHieu) #\(idx + 1)",
                    hs.nhanVien.maNV,
                    hs.nhanVien.hoTen,
                    "\(Int(round(hs.diemSucKhoe)))%",
                    hs.nhanXuHuong,
                    "\(hs.tongHopHienTai.soMonDat)/\(hs.tongHopHienTai.tongMonGiao)",
                    hs.cacMonYeuNhat.joined(separator: ", ")
                ])
            }
        }
        let theKPISK: [(tieuDe: String, giaTri: String, phu: String, mauVien: String, mauNen: String)] = [
            ("ĐIỂM SỨC KHỎE TB ĐỘI", String(format: "%.1f%%", bcSK.diemTrungBinhDoiNgu), "Theo dõi \(bcSK.soNgayDaTheoDoi) ngày", "1D4ED8", "EFF6FF"),
            ("NHÂN SỰ KHỎE (>=75%)", "\(bcSK.soNVKhoe) NV", "Duy trì phong độ tốt", "15803D", "DCFCE7"),
            ("TRUNG BÌNH (55–74%)", "\(bcSK.soNVTrungBinh) NV", "Cần bứt tốc thêm", "B45309", "FEF3C2"),
            ("BÁO ĐỘNG YẾU (<55%)", "\(bcSK.soNVYeu) NV", "Kèm cặp 1-1 mỗi ca", "B91C1C", "FEE2E2")
        ]
        let slide6XML = taoSlideChuyenNghiepXML(
            tieuDe: "BÁO CÁO SỨC KHỎE ĐỘI NGŨ & CẢNH BÁO 5 NHÂN VIÊN YẾU LIÊN TIẾP",
            phuDe: "Phân tích chuỗi lịch sử nhiều ngày liên tục để phát hiện nhân sự cần hỗ trợ kịp thời (\(ngayStr))",
            theKPI: theKPISK,
            tieuDeBang: "DANH SÁCH CẢNH BÁO TOP 5 NHÂN VIÊN YẾU LIÊN TIẾP & NGÀNH HÀNG CẦN KÈM CẶP",
            doRongCotBang: [1100000, 1050000, 2100000, 1000000, 1950000, 1000000, 3077600],
            cacDongBang: bangSlide6,
            tieuDeHopAI: "❤️‍🩹 PHƯƠNG ÁN KÈM CẶP NHÂN SỰ YẾU LIÊN TIẾP",
            noiDungHopAI: "Quản lý ca họp nhanh 5 phút đầu ca với nhóm cảnh báo đỏ, giao chỉ tiêu mở điểm từng ngành hàng yếu nhất và kiểm tra tiến độ lúc 12:00 & 17:00."
        )

        let cacSlideXML = [slide1XML, slide2XML, slide3XML, slide4XML, slide5XML, slide6XML]

        var contentTypesLines = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Types xmlns=\"http://schemas.openxmlformats.org/package/2006/content-types\">",
            "<Default Extension=\"rels\" ContentType=\"application/vnd.openxmlformats-package.relationships+xml\"/>",
            "<Default Extension=\"xml\" ContentType=\"application/xml\"/>",
            "<Override PartName=\"/ppt/presentation.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml\"/>",
            "<Override PartName=\"/ppt/slideMasters/slideMaster1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml\"/>",
            "<Override PartName=\"/ppt/slideLayouts/slideLayout1.xml\" ContentType=\"application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml\"/>"
        ]
        for idx in 1...cacSlideXML.count {
            contentTypesLines.append("<Override PartName=\"/ppt/slides/slide\(idx).xml\" ContentType=\"application/vnd.openxmlformats-officedocument.presentationml.slide+xml\"/>")
        }
        contentTypesLines.append("</Types>")
        let contentTypes = contentTypesLines.joined(separator: "\n")

        let relsRoot = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">",
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument\" Target=\"ppt/presentation.xml\"/>",
            "</Relationships>"
        ].joined(separator: "\n")

        var sldIdLines: [String] = []
        var presRelsLines: [String] = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">",
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster\" Target=\"slideMasters/slideMaster1.xml\"/>"
        ]
        for idx in 1...cacSlideXML.count {
            sldIdLines.append("<p:sldId id=\"\(255 + idx)\" r:id=\"rId\(idx + 1)\"/>")
            presRelsLines.append("<Relationship Id=\"rId\(idx + 1)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide\" Target=\"slides/slide\(idx).xml\"/>")
        }
        presRelsLines.append("</Relationships>")

        let presentationXML = ([
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<p:presentation xmlns:a=\"http://schemas.openxmlformats.org/drawingml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" xmlns:p=\"http://schemas.openxmlformats.org/presentationml/2006/main\">",
            "<p:sldMasterIdLst><p:sldMasterId id=\"2147483648\" r:id=\"rId1\"/></p:sldMasterIdLst>",
            "<p:sldIdLst>"
        ] + sldIdLines + [
            "</p:sldIdLst>",
            "<p:sldSz cx=\"12192000\" cy=\"6858000\"/>",
            "<p:notesSz cx=\"6858000\" cy=\"9144000\"/>",
            "</p:presentation>"
        ]).joined(separator: "\n")

        let slideMasterXML = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<p:sldMaster xmlns:a=\"http://schemas.openxmlformats.org/drawingml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" xmlns:p=\"http://schemas.openxmlformats.org/presentationml/2006/main\">",
            "<p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id=\"1\" name=\"\"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr/></p:spTree></p:cSld>",
            "<p:clrMap bg1=\"lt1\" tx1=\"dk1\" bg2=\"lt2\" tx2=\"dk2\" accent1=\"accent1\" accent2=\"accent2\" accent3=\"accent3\" accent4=\"accent4\" accent5=\"accent5\" accent6=\"accent6\" hlink=\"hlink\" folHlink=\"folHlink\"/>",
            "<p:sldLayoutIdLst><p:sldLayoutId id=\"2147483649\" r:id=\"rId1\"/></p:sldLayoutIdLst>",
            "</p:sldMaster>"
        ].joined(separator: "\n")

        let slideMasterRels = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">",
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout\" Target=\"../slideLayouts/slideLayout1.xml\"/>",
            "</Relationships>"
        ].joined(separator: "\n")

        let slideLayoutXML = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<p:sldLayout xmlns:a=\"http://schemas.openxmlformats.org/drawingml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" xmlns:p=\"http://schemas.openxmlformats.org/presentationml/2006/main\" type=\"blank\">",
            "<p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id=\"1\" name=\"\"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr/></p:spTree></p:cSld>",
            "</p:sldLayout>"
        ].joined(separator: "\n")

        let slideLayoutRels = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">",
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster\" Target=\"../slideMasters/slideMaster1.xml\"/>",
            "</Relationships>"
        ].joined(separator: "\n")

        let slideRels = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<Relationships xmlns=\"http://schemas.openxmlformats.org/package/2006/relationships\">",
            "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout\" Target=\"../slideLayouts/slideLayout1.xml\"/>",
            "</Relationships>"
        ].joined(separator: "\n")

        var cacTep: [(String, Data)] = [
            ("[Content_Types].xml", Data(contentTypes.utf8)),
            ("_rels/.rels", Data(relsRoot.utf8)),
            ("ppt/presentation.xml", Data(presentationXML.utf8)),
            ("ppt/_rels/presentation.xml.rels", Data(presRelsLines.joined(separator: "\n").utf8)),
            ("ppt/slideMasters/slideMaster1.xml", Data(slideMasterXML.utf8)),
            ("ppt/slideMasters/_rels/slideMaster1.xml.rels", Data(slideMasterRels.utf8)),
            ("ppt/slideLayouts/slideLayout1.xml", Data(slideLayoutXML.utf8)),
            ("ppt/slideLayouts/_rels/slideLayout1.xml.rels", Data(slideLayoutRels.utf8))
        ]
        for (idx, sXML) in cacSlideXML.enumerated() {
            let sNum = idx + 1
            cacTep.append(("ppt/slides/slide\(sNum).xml", Data(sXML.utf8)))
            cacTep.append(("ppt/slides/_rels/slide\(sNum).xml.rels", Data(slideRels.utf8)))
        }

        let duLieuZip = dongGoiZipStore(cacTep: cacTep)
        let tenTep = "BaoCao-Slide-DMX-ChiTiet-\(dl.khoaNgay).pptx"
        let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
        do {
            try duLieuZip.write(to: duongDan, options: .atomic)
            return duongDan
        } catch {
            return nil
        }
    }

    // MARK: - Helpers sinh XML nâng cao cho Excel (.xlsx) & PowerPoint (.pptx)

    private static func taoHangGop(_ chu: String, soCot: Int, kieu: KieuOExcel) -> [OExcel] {
        var mang: [OExcel] = [.chu(chu, kieu: kieu)]
        if soCot > 1 {
            for _ in 1..<soCot {
                mang.append(.chu("", kieu: kieu))
            }
        }
        return mang
    }

    private static func thoatXML(_ s: String) -> String {
        s.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&apos;")
    }

    private static func tenCotExcel(_ chiSo: Int) -> String {
        var n = chiSo + 1
        var ketQua = ""
        while n > 0 {
            let du = (n - 1) % 26
            ketQua = String(UnicodeScalar(65 + du)!) + ketQua
            n = (n - 1) / 26
        }
        return ketQua
    }

    private static func taoStylesXMLChuyenNghiep() -> String {
        return [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<styleSheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">",
            "<numFmts count=\"3\">",
            "<numFmt numFmtId=\"164\" formatCode=\"#,##0.00\"/>",
            "<numFmt numFmtId=\"165\" formatCode=\"#,##0\"/>",
            "<numFmt numFmtId=\"166\" formatCode=\"0.0&quot;%&quot;\"/>",
            "</numFmts>",
            "<fonts count=\"8\">",
            "<font><sz val=\"10.5\"/><color rgb=\"FF0F172A\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"10.5\"/><color rgb=\"FF0F172A\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"13.5\"/><color rgb=\"FFFFFFFF\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"10.5\"/><color rgb=\"FFFFFFFF\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"11\"/><color rgb=\"FF1E3A8A\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"10.5\"/><color rgb=\"FF15803D\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"10.5\"/><color rgb=\"FFB45309\"/><name val=\"Arial\"/></font>",
            "<font><b/><sz val=\"10.5\"/><color rgb=\"FFB91C1C\"/><name val=\"Arial\"/></font>",
            "</fonts>",
            "<fills count=\"11\">",
            "<fill><patternFill patternType=\"none\"/></fill>",
            "<fill><patternFill patternType=\"gray125\"/></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FF1D4ED8\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FF1E40AF\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFFEF3C2\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFDBEAFE\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFDCFCE7\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFFEF9C3\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFFEE2E2\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFF8FAFC\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "<fill><patternFill patternType=\"solid\"><fgColor rgb=\"FFEEF2FF\"/><bgColor indexed=\"64\"/></patternFill></fill>",
            "</fills>",
            "<borders count=\"3\">",
            "<border><left/><right/><top/><bottom/><diagonal/></border>",
            "<border>",
            "<left style=\"thin\"><color rgb=\"FFCBD5E1\"/></left>",
            "<right style=\"thin\"><color rgb=\"FFCBD5E1\"/></right>",
            "<top style=\"thin\"><color rgb=\"FFCBD5E1\"/></top>",
            "<bottom style=\"thin\"><color rgb=\"FFCBD5E1\"/></bottom>",
            "<diagonal/>",
            "</border>",
            "<border>",
            "<left style=\"thin\"><color rgb=\"FF94A3B8\"/></left>",
            "<right style=\"thin\"><color rgb=\"FF94A3B8\"/></right>",
            "<top style=\"medium\"><color rgb=\"FF1D4ED8\"/></top>",
            "<bottom style=\"medium\"><color rgb=\"FF1D4ED8\"/></bottom>",
            "<diagonal/>",
            "</border>",
            "</borders>",
            "<cellStyleXfs count=\"1\"><xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"0\"/></cellStyleXfs>",
            "<cellXfs count=\"18\">",
            "<xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"0\" fillId=\"9\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"1\" fillId=\"0\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"2\" fillId=\"2\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"4\" fillId=\"4\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"4\" fillId=\"5\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"3\" fillId=\"3\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"center\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"0\" fillId=\"0\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"center\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"164\" fontId=\"0\" fillId=\"0\" borderId=\"1\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"right\" vertical=\"center\"/></xf>",
            "<xf numFmtId=\"165\" fontId=\"0\" fillId=\"0\" borderId=\"1\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"right\" vertical=\"center\"/></xf>",
            "<xf numFmtId=\"166\" fontId=\"1\" fillId=\"0\" borderId=\"1\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"right\" vertical=\"center\"/></xf>",
            "<xf numFmtId=\"166\" fontId=\"5\" fillId=\"6\" borderId=\"1\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"center\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"166\" fontId=\"6\" fillId=\"7\" borderId=\"1\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"center\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"166\" fontId=\"7\" fillId=\"8\" borderId=\"1\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"center\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"1\" fillId=\"4\" borderId=\"2\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "<xf numFmtId=\"164\" fontId=\"1\" fillId=\"4\" borderId=\"2\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"right\" vertical=\"center\"/></xf>",
            "<xf numFmtId=\"166\" fontId=\"1\" fillId=\"4\" borderId=\"2\" xfId=\"0\" applyNumberFormat=\"1\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"right\" vertical=\"center\"/></xf>",
            "<xf numFmtId=\"0\" fontId=\"1\" fillId=\"10\" borderId=\"1\" xfId=\"0\" applyFont=\"1\" applyFill=\"1\" applyBorder=\"1\" applyAlignment=\"1\"><alignment horizontal=\"left\" vertical=\"center\" wrapText=\"1\"/></xf>",
            "</cellXfs>",
            "</styleSheet>"
        ].joined(separator: "\n")
    }

    private static func taoSheetXMLNangCao(_ cauHinh: CauHinhSheetExcel) -> String {
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"
        xml += "<worksheet xmlns=\"http://schemas.openxmlformats.org/spreadsheetml/2006/main\">"

        if cauHinh.dongCoDinh > 0 {
            let cellDau = "A\(cauHinh.dongCoDinh + 1)"
            xml += "<sheetViews><sheetView workbookViewId=\"0\" showGridLines=\"1\"><pane ySplit=\"\(cauHinh.dongCoDinh)\" topLeftCell=\"\(cellDau)\" activePane=\"bottomLeft\" state=\"frozen\"/></sheetView></sheetViews>"
        } else {
            xml += "<sheetViews><sheetView workbookViewId=\"0\" showGridLines=\"1\"/></sheetViews>"
        }

        if !cauHinh.doRongCot.isEmpty {
            xml += "<cols>"
            for (idx, w) in cauHinh.doRongCot.enumerated() {
                let c = idx + 1
                xml += "<col min=\"\(c)\" max=\"\(c)\" width=\"\(String(format: "%.1f", w))\" customWidth=\"1\"/>"
            }
            xml += "</cols>"
        }

        xml += "<sheetData>"
        for (rIdx, dong) in cauHinh.cacDong.enumerated() {
            let soDong = rIdx + 1
            if let h = dong.chieuCao {
                xml += "<row r=\"\(soDong)\" ht=\"\(String(format: "%.1f", h))\" customHeight=\"1\">"
            } else {
                xml += "<row r=\"\(soDong)\">"
            }
            for (cIdx, o) in dong.cacO.enumerated() {
                let ref = "\(tenCotExcel(cIdx))\(soDong)"
                let sAttr = " s=\"\(o.kieu.rawValue)\""
                switch o.giaTri {
                case .chu(let str):
                    xml += "<c r=\"\(ref)\" t=\"inlineStr\"\(sAttr)><is><t>\(thoatXML(str))</t></is></c>"
                case .so(let val):
                    let vSafe = val.isFinite ? val : 0
                    xml += "<c r=\"\(ref)\" t=\"n\"\(sAttr)><v>\(String(format: "%.4f", vSafe))</v></c>"
                case .congThuc(let f, let valTam):
                    let vSafe = valTam.isFinite ? valTam : 0
                    xml += "<c r=\"\(ref)\" t=\"n\"\(sAttr)><f>\(thoatXML(f))</f><v>\(String(format: "%.4f", vSafe))</v></c>"
                }
            }
            xml += "</row>"
        }
        xml += "</sheetData>"

        if !cauHinh.cacGopO.isEmpty {
            xml += "<mergeCells count=\"\(cauHinh.cacGopO.count)\">"
            for m in cauHinh.cacGopO {
                xml += "<mergeCell ref=\"\(m)\"/>"
            }
            xml += "</mergeCells>"
        }

        xml += "</worksheet>"
        return xml
    }

    private static func taoSlideChuyenNghiepXML(
        tieuDe: String,
        phuDe: String,
        theKPI: [(tieuDe: String, giaTri: String, phu: String, mauVien: String, mauNen: String)],
        tieuDeBang: String,
        doRongCotBang: [Int],
        cacDongBang: [[String]],
        tieuDeHopAI: String,
        noiDungHopAI: String
    ) -> String {
        var shapesXML = ""
        var shapeId = 2

        shapesXML += taoHinhChuNhatPPTX(
            id: shapeId, ten: "BgSlide",
            x: 0, y: 0, cx: 12192000, cy: 6858000,
            mauNen: "F8FAFC", mauVien: nil,
            cacDoan: []
        )
        shapeId += 1

        shapesXML += taoHinhChuNhatPPTX(
            id: shapeId, ten: "HeaderBanner",
            x: 0, y: 0, cx: 12192000, cy: 880000,
            mauNen: "1D4ED8", mauVien: nil,
            cacDoan: [
                (tieuDe, 1900, true, "FFFFFF"),
                (phuDe, 1100, false, "FEF3C2")
            ]
        )
        shapeId += 1

        shapesXML += taoHinhChuNhatPPTX(
            id: shapeId, ten: "GoldAccent",
            x: 0, y: 880000, cx: 12192000, cy: 48000,
            mauNen: "FACC15", mauVien: nil,
            cacDoan: []
        )
        shapeId += 1

        var yHienTai = 1020000

        if !theKPI.isEmpty {
            let leX = 457200
            let khoangCach = 160000
            let soThe = min(4, theKPI.count)
            let rongThe = (11277600 - khoangCach * (soThe - 1)) / soThe
            let caoThe = 820000

            for (idx, the) in theKPI.prefix(4).enumerated() {
                let xThe = leX + idx * (rongThe + khoangCach)
                shapesXML += taoHinhChuNhatPPTX(
                    id: shapeId, ten: "KPICard_\(idx + 1)",
                    x: xThe, y: yHienTai, cx: rongThe, cy: caoThe,
                    mauNen: the.mauNen, mauVien: the.mauVien, boGoc: true,
                    cacDoan: [
                        (the.tieuDe, 950, true, "475569"),
                        (the.giaTri, 1750, true, the.mauVien),
                        (the.phu, 950, false, "334155")
                    ]
                )
                shapeId += 1
            }
            yHienTai += caoThe + 120000
        }

        let caoHopAI = 1280000
        let caoBangToiDa = max(1800000, 6858000 - yHienTai - caoHopAI - 260000)

        shapesXML += taoBangDrawingMLPPTX(
            id: shapeId,
            ten: "DataTable",
            x: 457200,
            y: yHienTai,
            cx: 11277600,
            cy: caoBangToiDa,
            doRongCot: doRongCotBang,
            cacDong: cacDongBang
        )
        shapeId += 1

        let yHopAI = 6858000 - caoHopAI - 120000
        let cacDongAI = noiDungHopAI
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .prefix(5)
        var doanAI: [(String, Int, Bool, String)] = [
            (tieuDeHopAI, 1150, true, "1E3A8A")
        ]
        for d in cacDongAI {
            let rutGon = d.count > 195 ? String(d.prefix(192)) + "..." : d
            doanAI.append((rutGon, 1000, false, "0F172A"))
        }

        shapesXML += taoHinhChuNhatPPTX(
            id: shapeId, ten: "AIInsightBox",
            x: 457200, y: yHopAI, cx: 11277600, cy: caoHopAI,
            mauNen: "EFF6FF", mauVien: "93C5FD", boGoc: true,
            cacDoan: doanAI
        )

        return [
            "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>",
            "<p:sld xmlns:a=\"http://schemas.openxmlformats.org/drawingml/2006/main\" xmlns:r=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships\" xmlns:p=\"http://schemas.openxmlformats.org/presentationml/2006/main\">",
            "<p:cSld><p:spTree>",
            "<p:nvGrpSpPr><p:cNvPr id=\"1\" name=\"\"/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>",
            "<p:grpSpPr><a:xfrm><a:off x=\"0\" y=\"0\"/><a:ext cx=\"0\" cy=\"0\"/><a:chOff x=\"0\" y=\"0\"/><a:chExt cx=\"0\" cy=\"0\"/></a:xfrm></p:grpSpPr>",
            shapesXML,
            "</p:spTree></p:cSld>",
            "</p:sld>"
        ].joined(separator: "\n")
    }

    private static func taoHinhChuNhatPPTX(
        id: Int,
        ten: String,
        x: Int,
        y: Int,
        cx: Int,
        cy: Int,
        mauNen: String,
        mauVien: String?,
        boGoc: Bool = false,
        cacDoan: [(chu: String, coChu: Int, inDam: Bool, mauChu: String)]
    ) -> String {
        let prst = boGoc ? "roundRect" : "rect"
        let vienXML: String
        if let v = mauVien {
            vienXML = "<a:ln w=\"15875\"><a:solidFill><a:srgbClr val=\"\(v)\"/></a:solidFill></a:ln>"
        } else {
            vienXML = "<a:ln><a:noFill/></a:ln>"
        }

        var doanXML = ""
        if cacDoan.isEmpty {
            doanXML = "<a:p><a:endParaRPr lang=\"vi-VN\"/></a:p>"
        } else {
            for d in cacDoan {
                let bAttr = d.inDam ? " b=\"1\"" : ""
                doanXML += "<a:p><a:r><a:rPr lang=\"vi-VN\" sz=\"\(d.coChu)\"\(bAttr)><a:solidFill><a:srgbClr val=\"\(d.mauChu)\"/></a:solidFill></a:rPr><a:t>\(thoatXML(d.chu))</a:t></a:r></a:p>"
            }
        }

        return [
            "<p:sp>",
            "<p:nvSpPr><p:cNvPr id=\"\(id)\" name=\"\(thoatXML(ten))\"/><p:cNvSpPr/><p:nvPr/></p:nvSpPr>",
            "<p:spPr>",
            "<a:xfrm><a:off x=\"\(x)\" y=\"\(y)\"/><a:ext cx=\"\(cx)\" cy=\"\(cy)\"/></a:xfrm>",
            "<a:prstGeom prst=\"\(prst)\"><a:avLst/></a:prstGeom>",
            "<a:solidFill><a:srgbClr val=\"\(mauNen)\"/></a:solidFill>",
            vienXML,
            "</p:spPr>",
            "<p:txBody><a:bodyPr wrap=\"square\" lIns=\"110000\" tIns=\"75000\" rIns=\"110000\" bIns=\"75000\" anchor=\"ctr\"/><a:lstStyle/>\(doanXML)</p:txBody>",
            "</p:sp>"
        ].joined(separator: "")
    }

    private static func taoBangDrawingMLPPTX(
        id: Int,
        ten: String,
        x: Int,
        y: Int,
        cx: Int,
        cy: Int,
        doRongCot: [Int],
        cacDong: [[String]]
    ) -> String {
        guard !cacDong.isEmpty, !doRongCot.isEmpty else { return "" }
        let soCot = doRongCot.count
        let caoDong = max(260000, cy / max(1, cacDong.count))

        var gridCols = ""
        for w in doRongCot {
            gridCols += "<a:gridCol w=\"\(w)\"/>"
        }

        var rowsXML = ""
        for (rIdx, dong) in cacDong.enumerated() {
            let laHeader = (rIdx == 0)
            rowsXML += "<a:tr h=\"\(caoDong)\">"
            for cIdx in 0..<soCot {
                let text = (cIdx < dong.count) ? dong[cIdx] : ""
                let mauNenO: String
                let mauChuO: String
                let inDamO: Bool
                if laHeader {
                    mauNenO = "1E40AF"
                    mauChuO = "FFFFFF"
                    inDamO = true
                } else if text.contains("🟢") {
                    mauNenO = "DCFCE7"
                    mauChuO = "15803D"
                    inDamO = true
                } else if text.contains("🟡") {
                    mauNenO = "FEF9C3"
                    mauChuO = "B45309"
                    inDamO = true
                } else if text.contains("🔴") || text.contains("🚨") || text.contains("KHẨN") {
                    mauNenO = "FEE2E2"
                    mauChuO = "B91C1C"
                    inDamO = true
                } else {
                    mauNenO = (rIdx % 2 == 1) ? "FFFFFF" : "F1F5F9"
                    mauChuO = "0F172A"
                    inDamO = (cIdx <= 1)
                }

                let bAttr = inDamO ? " b=\"1\"" : ""
                let coChu = laHeader ? 1050 : 980
                let align = (laHeader || cIdx == 0) ? "ctr" : "l"

                rowsXML += [
                    "<a:tc>",
                    "<a:txBody><a:bodyPr wrap=\"square\" lIns=\"65000\" tIns=\"35000\" rIns=\"65000\" bIns=\"35000\"/><a:lstStyle/>",
                    "<a:p><a:pPr algn=\"\(align)\"/><a:r><a:rPr lang=\"vi-VN\" sz=\"\(coChu)\"\(bAttr)><a:solidFill><a:srgbClr val=\"\(mauChuO)\"/></a:solidFill></a:rPr><a:t>\(thoatXML(text))</a:t></a:r></a:p>",
                    "</a:txBody>",
                    "<a:tcPr anchor=\"ctr\">",
                    "<a:lnL w=\"9525\"><a:solidFill><a:srgbClr val=\"CBD5E1\"/></a:solidFill></a:lnL>",
                    "<a:lnR w=\"9525\"><a:solidFill><a:srgbClr val=\"CBD5E1\"/></a:solidFill></a:lnR>",
                    "<a:lnT w=\"9525\"><a:solidFill><a:srgbClr val=\"CBD5E1\"/></a:solidFill></a:lnT>",
                    "<a:lnB w=\"9525\"><a:solidFill><a:srgbClr val=\"CBD5E1\"/></a:solidFill></a:lnB>",
                    "<a:solidFill><a:srgbClr val=\"\(mauNenO)\"/></a:solidFill>",
                    "</a:tcPr>",
                    "</a:tc>"
                ].joined(separator: "")
            }
            rowsXML += "</a:tr>"
        }

        return [
            "<p:graphicFrame>",
            "<p:nvGraphicFramePr><p:cNvPr id=\"\(id)\" name=\"\(thoatXML(ten))\"/><p:cNvGraphicFramePr><a:graphicFrameLocks noGrp=\"1\"/></p:cNvGraphicFramePr><p:nvPr/></p:nvGraphicFramePr>",
            "<p:xfrm><a:off x=\"\(x)\" y=\"\(y)\"/><a:ext cx=\"\(cx)\" cy=\"\(cy)\"/></p:xfrm>",
            "<a:graphic><a:graphicData uri=\"http://schemas.openxmlformats.org/drawingml/2006/table\">",
            "<a:tbl><a:tblPr firstRow=\"1\" bandRow=\"1\"/><a:tblGrid>\(gridCols)</a:tblGrid>\(rowsXML)</a:tbl>",
            "</a:graphicData></a:graphic>",
            "</p:graphicFrame>"
        ].joined(separator: "")
    }

    // MARK: - Bộ đóng gói ZIP (Store mode + CRC32 IEEE 802.3)

    private static let bangCRC32: [UInt32] = {
        (0..<256).map { i -> UInt32 in
            var c = UInt32(i)
            for _ in 0..<8 {
                c = (c & 1 != 0) ? (0xEDB88320 ^ (c >> 1)) : (c >> 1)
            }
            return c
        }
    }()

    private static func tinhCRC32(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xFFFFFFFF
        for byte in data {
            let idx = Int((crc ^ UInt32(byte)) & 0xFF)
            crc = (crc >> 8) ^ bangCRC32[idx]
        }
        return crc ^ 0xFFFFFFFF
    }

    private static func ghiUInt16LE(_ v: UInt16, vao data: inout Data) {
        var le = v.littleEndian
        withUnsafeBytes(of: &le) { data.append(contentsOf: $0) }
    }

    private static func ghiUInt32LE(_ v: UInt32, vao data: inout Data) {
        var le = v.littleEndian
        withUnsafeBytes(of: &le) { data.append(contentsOf: $0) }
    }

    private static func dongGoiZipStore(cacTep: [(String, Data)]) -> Data {
        var zipData = Data()
        var centralDir = Data()

        for (ten, noiDung) in cacTep {
            let tenBytes = Data(ten.utf8)
            let crc = tinhCRC32(noiDung)
            let kichThuoc = UInt32(noiDung.count)
            let viTriOffset = UInt32(zipData.count)

            ghiUInt32LE(0x04034B50, vao: &zipData)
            ghiUInt16LE(20, vao: &zipData)
            ghiUInt16LE(0, vao: &zipData)
            ghiUInt16LE(0, vao: &zipData)
            ghiUInt16LE(0, vao: &zipData)
            ghiUInt16LE(0x5421, vao: &zipData)
            ghiUInt32LE(crc, vao: &zipData)
            ghiUInt32LE(kichThuoc, vao: &zipData)
            ghiUInt32LE(kichThuoc, vao: &zipData)
            ghiUInt16LE(UInt16(tenBytes.count), vao: &zipData)
            ghiUInt16LE(0, vao: &zipData)
            zipData.append(tenBytes)
            zipData.append(noiDung)

            ghiUInt32LE(0x02014B50, vao: &centralDir)
            ghiUInt16LE(20, vao: &centralDir)
            ghiUInt16LE(20, vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt16LE(0x5421, vao: &centralDir)
            ghiUInt32LE(crc, vao: &centralDir)
            ghiUInt32LE(kichThuoc, vao: &centralDir)
            ghiUInt32LE(kichThuoc, vao: &centralDir)
            ghiUInt16LE(UInt16(tenBytes.count), vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt16LE(0, vao: &centralDir)
            ghiUInt32LE(0, vao: &centralDir)
            ghiUInt32LE(viTriOffset, vao: &centralDir)
            centralDir.append(tenBytes)
        }

        let cdOffset = UInt32(zipData.count)
        let cdSize = UInt32(centralDir.count)
        zipData.append(centralDir)

        ghiUInt32LE(0x06054B50, vao: &zipData)
        ghiUInt16LE(0, vao: &zipData)
        ghiUInt16LE(0, vao: &zipData)
        ghiUInt16LE(UInt16(cacTep.count), vao: &zipData)
        ghiUInt16LE(UInt16(cacTep.count), vao: &zipData)
        ghiUInt32LE(cdSize, vao: &zipData)
        ghiUInt32LE(cdOffset, vao: &zipData)
        ghiUInt16LE(0, vao: &zipData)

        return zipData
    }
}
