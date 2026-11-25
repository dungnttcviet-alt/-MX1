import UIKit
import PhotosUI
import UniformTypeIdentifiers

// MARK: - Menu Điều Hướng Trượt Bên Trái (Giao diện Sáng Tươi Chuẩn ĐMX & BaoCaoThiDua)
// Dưới "Tổng quan" có nút "Báo cáo"; trong "Đổ số - Xem số" có 3 mục: 1. Xem số | 2. Nhập số | 3. Xuất ảnh; có nút "Cài đặt"

final class MenuDieuHuongBenTraiView: UIView {
    var khiChonMucChinh: ((MucMenuChinh) -> Void)?
    var khiChonMucConDoSo: ((MucConDoSo) -> Void)?
    var khiDongMenu: (() -> Void)?

    private let nhanTenTaiKhoan = UILabel()
    private let khungHuyHieu = UIView()
    private let nhanHuyHieu = UILabel()
    private let cuonMenu = UIScrollView()
    private let nganDanhSach = UIStackView()

    private var dangMoMenuConDoSo: Bool = true
    private var mucChinhDangChon: MucMenuChinh = .doSoXemSo
    private var mucConDangChon: MucConDoSo = .xemSo

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        backgroundColor = BangMauBCTD.nenSidebarSang
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.18
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 4, height: 0)

        let khungDau = UIView()
        khungDau.backgroundColor = BangMauBCTD.xanhChuDao
        khungDau.translatesAutoresizingMaskIntoConstraints = false
        addSubview(khungDau)

        nhanTenTaiKhoan.font = .systemFont(ofSize: 18, weight: .heavy)
        nhanTenTaiKhoan.textColor = .white
        nhanTenTaiKhoan.numberOfLines = 0
        nhanTenTaiKhoan.lineBreakMode = .byWordWrapping
        nhanTenTaiKhoan.adjustsFontSizeToFitWidth = false
        nhanTenTaiKhoan.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(nhanTenTaiKhoan)

        khungHuyHieu.backgroundColor = BangMauBCTD.vangSang
        khungHuyHieu.layer.cornerRadius = 5
        khungHuyHieu.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(khungHuyHieu)

        nhanHuyHieu.text = ""
        khungHuyHieu.isHidden = true
        nhanHuyHieu.font = .systemFont(ofSize: 11.5, weight: .heavy)
        nhanHuyHieu.textColor = BangMauBCTD.chuChinh
        nhanHuyHieu.numberOfLines = 0
        nhanHuyHieu.lineBreakMode = .byWordWrapping
        nhanHuyHieu.adjustsFontSizeToFitWidth = false
        nhanHuyHieu.translatesAutoresizingMaskIntoConstraints = false
        khungHuyHieu.addSubview(nhanHuyHieu)

        let vachVangDau = UIView()
        vachVangDau.backgroundColor = BangMauBCTD.vangSang
        vachVangDau.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(vachVangDau)

        cuonMenu.showsVerticalScrollIndicator = false
        cuonMenu.alwaysBounceVertical = true
        cuonMenu.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cuonMenu)

        nganDanhSach.axis = .vertical
        nganDanhSach.spacing = 2
        nganDanhSach.translatesAutoresizingMaskIntoConstraints = false
        cuonMenu.addSubview(nganDanhSach)

        NSLayoutConstraint.activate([
            khungDau.topAnchor.constraint(equalTo: topAnchor),
            khungDau.leadingAnchor.constraint(equalTo: leadingAnchor),
            khungDau.trailingAnchor.constraint(equalTo: trailingAnchor),

            nhanTenTaiKhoan.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            nhanTenTaiKhoan.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor, constant: 20),
            nhanTenTaiKhoan.trailingAnchor.constraint(equalTo: khungDau.trailingAnchor, constant: -16),

            khungHuyHieu.topAnchor.constraint(equalTo: nhanTenTaiKhoan.bottomAnchor, constant: 8),
            khungHuyHieu.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor, constant: 20),
            khungHuyHieu.trailingAnchor.constraint(lessThanOrEqualTo: khungDau.trailingAnchor, constant: -16),
            khungHuyHieu.bottomAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: -14),

            nhanHuyHieu.topAnchor.constraint(equalTo: khungHuyHieu.topAnchor, constant: 4),
            nhanHuyHieu.bottomAnchor.constraint(equalTo: khungHuyHieu.bottomAnchor, constant: -4),
            nhanHuyHieu.leadingAnchor.constraint(equalTo: khungHuyHieu.leadingAnchor, constant: 10),
            nhanHuyHieu.trailingAnchor.constraint(equalTo: khungHuyHieu.trailingAnchor, constant: -10),

            vachVangDau.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor),
            vachVangDau.trailingAnchor.constraint(equalTo: khungDau.trailingAnchor),
            vachVangDau.bottomAnchor.constraint(equalTo: khungDau.bottomAnchor),
            vachVangDau.heightAnchor.constraint(equalToConstant: 4),

            cuonMenu.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 6),
            cuonMenu.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuonMenu.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuonMenu.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),

            nganDanhSach.topAnchor.constraint(equalTo: cuonMenu.contentLayoutGuide.topAnchor),
            nganDanhSach.leadingAnchor.constraint(equalTo: cuonMenu.contentLayoutGuide.leadingAnchor),
            nganDanhSach.trailingAnchor.constraint(equalTo: cuonMenu.contentLayoutGuide.trailingAnchor),
            nganDanhSach.bottomAnchor.constraint(equalTo: cuonMenu.contentLayoutGuide.bottomAnchor, constant: -12),
            nganDanhSach.widthAnchor.constraint(equalTo: cuonMenu.frameLayoutGuide.widthAnchor)
        ])

        capNhatThongTinTaiKhoan()
        dungLaiDanhSachMenu()
    }

    func capNhatThongTinTaiKhoan() {
        let tenTK = DichVuDongBo.dungChung.tenDangNhap.trimmingCharacters(in: .whitespacesAndNewlines)
        if tenTK.isEmpty || tenTK.lowercased() == "duongnt" {
            nhanTenTaiKhoan.text = tenTK.isEmpty ? "VĂN ĐẠT" : tenTK.uppercased()
        } else {
            nhanTenTaiKhoan.text = tenTK.uppercased()
        }
        nhanHuyHieu.text = ""
    }

    func capNhatTrangThai(mucChinh: MucMenuChinh, mucCon: MucConDoSo) {
        self.mucChinhDangChon = mucChinh
        self.mucConDangChon = mucCon
        capNhatThongTinTaiKhoan()
        dungLaiDanhSachMenu()
    }

    private func dungLaiDanhSachMenu() {
        nganDanhSach.arrangedSubviews.forEach {
            nganDanhSach.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for muc in MucMenuChinh.allCases {
            let laMucDangChon = (muc == mucChinhDangChon)
            let dongChinh = taoDongMenuChinh(muc: muc, dangChon: laMucDangChon)
            nganDanhSach.addArrangedSubview(dongChinh)

            if muc.coMenuCon && dangMoMenuConDoSo {
                let khungMenuCon = UIStackView()
                khungMenuCon.axis = .vertical
                khungMenuCon.spacing = 4
                khungMenuCon.backgroundColor = BangMauBCTD.nenSidebarCon
                khungMenuCon.isLayoutMarginsRelativeArrangement = true
                khungMenuCon.layoutMargins = UIEdgeInsets(top: 4, left: 10, bottom: 6, right: 10)

                for mucCon in MucConDoSo.allCases {
                    let dangChonCon = (mucChinhDangChon == .doSoXemSo && mucConDangChon == mucCon)
                    let dongCon = taoDongMenuCon(mucCon: mucCon, dangChon: dangChonCon)
                    khungMenuCon.addArrangedSubview(dongCon)
                }
                nganDanhSach.addArrangedSubview(khungMenuCon)
            }
        }
    }

    private func taoDongMenuChinh(muc: MucMenuChinh, dangChon: Bool) -> UIView {
        let nut = UIControl()
        nut.tag = muc.rawValue
        nut.backgroundColor = dangChon ? BangMauBCTD.nenSidebarChon : .clear
        nut.translatesAutoresizingMaskIntoConstraints = false
        nut.addTarget(self, action: #selector(bamMucChinh(_:)), for: .touchUpInside)

        let vachTrai = UIView()
        vachTrai.backgroundColor = BangMauBCTD.xanhChuDao
        vachTrai.isHidden = !dangChon
        vachTrai.isUserInteractionEnabled = false
        vachTrai.translatesAutoresizingMaskIntoConstraints = false
        nut.addSubview(vachTrai)

        let cauHinhIcon = UIImage.SymbolConfiguration(pointSize: 16, weight: dangChon ? .bold : .semibold)
        let oIcon = UIImageView(image: UIImage(systemName: muc.bieuTuongSF, withConfiguration: cauHinhIcon))
        oIcon.tintColor = dangChon ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuPhu
        oIcon.contentMode = .scaleAspectFit
        oIcon.isUserInteractionEnabled = false
        oIcon.translatesAutoresizingMaskIntoConstraints = false
        nut.addSubview(oIcon)

        let nhanTieuDe = UILabel()
        nhanTieuDe.text = muc.tieuDe
        nhanTieuDe.font = .systemFont(ofSize: 15, weight: dangChon ? .bold : .semibold)
        nhanTieuDe.textColor = dangChon ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuChinh
        nhanTieuDe.numberOfLines = 0
        nhanTieuDe.lineBreakMode = .byWordWrapping
        nhanTieuDe.adjustsFontSizeToFitWidth = false
        nhanTieuDe.isUserInteractionEnabled = false
        nhanTieuDe.translatesAutoresizingMaskIntoConstraints = false
        nut.addSubview(nhanTieuDe)

        let nganPhai = UIStackView()
        nganPhai.axis = .horizontal
        nganPhai.spacing = 6
        nganPhai.alignment = .center
        nganPhai.isUserInteractionEnabled = false
        nganPhai.translatesAutoresizingMaskIntoConstraints = false
        nut.addSubview(nganPhai)

        if muc.coMenuCon {
            let tenMuiTen = dangMoMenuConDoSo ? "chevron.down" : "chevron.right"
            let cfgMuiTen = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            let iconMuiTen = UIImageView(image: UIImage(systemName: tenMuiTen, withConfiguration: cfgMuiTen))
            iconMuiTen.tintColor = dangChon ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuPhu
            nganPhai.addArrangedSubview(iconMuiTen)
        }

        nganPhai.setContentHuggingPriority(.required, for: .horizontal)
        nganPhai.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            nut.heightAnchor.constraint(greaterThanOrEqualToConstant: 46),

            vachTrai.topAnchor.constraint(equalTo: nut.topAnchor),
            vachTrai.bottomAnchor.constraint(equalTo: nut.bottomAnchor),
            vachTrai.leadingAnchor.constraint(equalTo: nut.leadingAnchor),
            vachTrai.widthAnchor.constraint(equalToConstant: 4.5),

            oIcon.leadingAnchor.constraint(equalTo: nut.leadingAnchor, constant: 18),
            oIcon.centerYAnchor.constraint(equalTo: nut.centerYAnchor),
            oIcon.widthAnchor.constraint(equalToConstant: 22),
            oIcon.heightAnchor.constraint(equalToConstant: 22),

            nhanTieuDe.topAnchor.constraint(equalTo: nut.topAnchor, constant: 12),
            nhanTieuDe.bottomAnchor.constraint(equalTo: nut.bottomAnchor, constant: -12),
            nhanTieuDe.leadingAnchor.constraint(equalTo: oIcon.trailingAnchor, constant: 12),
            nhanTieuDe.trailingAnchor.constraint(lessThanOrEqualTo: nganPhai.leadingAnchor, constant: -8),

            nganPhai.trailingAnchor.constraint(equalTo: nut.trailingAnchor, constant: -14),
            nganPhai.centerYAnchor.constraint(equalTo: nut.centerYAnchor)
        ])

        return nut
    }

    private func taoDongMenuCon(mucCon: MucConDoSo, dangChon: Bool) -> UIView {
        let nut = UIControl()
        nut.tag = mucCon.rawValue
        nut.backgroundColor = dangChon ? BangMauBCTD.vangSang : BangMauBCTD.nenThe
        nut.layer.cornerRadius = 9
        nut.layer.borderWidth = 1
        nut.layer.borderColor = dangChon ? BangMauBCTD.vangChuDao.cgColor : BangMauBCTD.vienThe.cgColor
        nut.translatesAutoresizingMaskIntoConstraints = false
        nut.addTarget(self, action: #selector(bamMucCon(_:)), for: .touchUpInside)

        let cfgIcon = UIImage.SymbolConfiguration(pointSize: 13.5, weight: dangChon ? .bold : .semibold)
        let oIcon = UIImageView(image: UIImage(systemName: mucCon.bieuTuongSF, withConfiguration: cfgIcon))
        oIcon.tintColor = dangChon ? BangMauBCTD.chuChinh : BangMauBCTD.xanhChuDao
        oIcon.contentMode = .scaleAspectFit
        oIcon.isUserInteractionEnabled = false
        oIcon.translatesAutoresizingMaskIntoConstraints = false
        nut.addSubview(oIcon)

        let nhan = UILabel()
        nhan.text = mucCon.tieuDe
        nhan.font = .systemFont(ofSize: 14, weight: dangChon ? .bold : .semibold)
        nhan.textColor = BangMauBCTD.chuChinh
        nhan.numberOfLines = 0
        nhan.lineBreakMode = .byWordWrapping
        nhan.adjustsFontSizeToFitWidth = false
        nhan.isUserInteractionEnabled = false
        nhan.translatesAutoresizingMaskIntoConstraints = false
        nut.addSubview(nhan)

        NSLayoutConstraint.activate([
            nut.heightAnchor.constraint(greaterThanOrEqualToConstant: 38),

            oIcon.leadingAnchor.constraint(equalTo: nut.leadingAnchor, constant: 14),
            oIcon.centerYAnchor.constraint(equalTo: nut.centerYAnchor),
            oIcon.widthAnchor.constraint(equalToConstant: 18),
            oIcon.heightAnchor.constraint(equalToConstant: 18),

            nhan.topAnchor.constraint(equalTo: nut.topAnchor, constant: 9),
            nhan.bottomAnchor.constraint(equalTo: nut.bottomAnchor, constant: -9),
            nhan.leadingAnchor.constraint(equalTo: oIcon.trailingAnchor, constant: 10),
            nhan.trailingAnchor.constraint(equalTo: nut.trailingAnchor, constant: -10)
        ])

        return nut
    }

    @objc private func bamMucChinh(_ sender: UIControl) {
        guard let muc = MucMenuChinh(rawValue: sender.tag) else { return }
        if muc.coMenuCon {
            dangMoMenuConDoSo.toggle()
            dungLaiDanhSachMenu()
            return
        }
        mucChinhDangChon = muc
        dungLaiDanhSachMenu()
        khiChonMucChinh?(muc)
    }

    @objc private func bamMucCon(_ sender: UIControl) {
        guard let mucCon = MucConDoSo(rawValue: sender.tag) else { return }
        mucChinhDangChon = .doSoXemSo
        mucConDangChon = mucCon
        dungLaiDanhSachMenu()
        khiChonMucConDoSo?(mucCon)
    }
}

// MARK: - Màn Hình Chính Điều Phối Toàn Bộ Ứng Dụng

final class ManHinhChinh: UIViewController, PHPickerViewControllerDelegate, UIDocumentPickerDelegate, UITextViewDelegate {
    private enum NguonChonAnh {
        case thuVienAnh
        case tepTin
    }
    private enum DinhDangFileBaoCao: String, CaseIterable {
        case excel = "Excel"
        case powerPoint = "PowerPoint"
    }
    private enum CaBaoCaoTongQuan: Int, CaseIterable {
        case dauCa = 0
        case giuaCa = 1
        case cuoiCa = 2

        var tieuDe: String {
            switch self {
            case .dauCa: return "Đầu ca"
            case .giuaCa: return "Giữa ca"
            case .cuoiCa: return "Cuối ca"
            }
        }
    }
    private enum CheDoQuetAnh {
        case doanhThu(LoaiCheDoDoanhThu)
        case thiDua(LoaiCheDoDoanhThu)
        case thiDuaNhanVien(LoaiCheDoDoanhThu)
        case doanhThuNhanVien(LoaiCheDoDoanhThu)
        case gioCongNhanVien(LoaiCheDoDoanhThu)
        case tatCaAnhTheoTab(LoaiCheDoDoanhThu)
    }

    private var ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
    private var mucMenuChinh: MucMenuChinh = .doSoXemSo
    private var mucConDoSo: MucConDoSo = .xemSo
    private var tabXemSo: TabXemSo = .luyKe
    private var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private var cheDoQuet: CheDoQuetAnh = .thiDua(.luyKe)
    private var thayTheBangThiDuaKhiQuet: Bool = false

    // Bộ nhớ đệm trạng thái bảng để bấm chuyển qua lại giữa các mục mượt tức thì (0ms)
    private var dsThiDuaDaNapUI: [DongThiDua]?
    private var cheDoThiDuaDaNapUI: LoaiCheDoDoanhThu?
    private var kieuHienThiDaNapUI: KieuHienThiBaoCao?
    private var phienBanThiDuaDaNapUI: Int = -1
    private var khoaNgayThiDuaDaNapUI: String = ""
    private var khoaCumChiSoDaNapUI: String = "" 
    private var congViecTaoAnhBot: DispatchWorkItem?
    private var khoaAnhBotDaTai: String = ""
    private var maLanTaoAnhBot = UUID()
    private var dangNapDuLieu = false
    private var canNapDuLieuLai = false

    // Thanh điều hướng trên cùng (nằm trong nền của tab, bên dưới Menu trượt)
    private let khungThanhDieuHuong = UIView()
    private let nutMoMenu = UIButton(type: .system)
    private let nutNgay = UIButton(type: .system)
    private let nutNhapTatCa = UIButton(type: .system)
    private let nutXuatNav = UIButton(type: .system)
    private let nutXoaNav = UIButton(type: .system)
    private let nutCopyTongQuanNav = UIButton(type: .system)
    private let nutQuanLyNhanVienNav = UIButton(type: .system)
    private let nutXuatAnhTonKhoNav = UIButton(type: .system)
    private let nutCaiDatNav = UIButton(type: .system)

    // Khung nội dung phần "Đổ số - Xem số" (3 mục con: 1. Xem số | 2. Nhập số | 3. Xuất ảnh)
    private let khungDoSoXemSo = UIView()
    private let khungThanhMucConDoSo = UIView()
    private let nganNutMucConDoSo = UIStackView()
    private var cacNutMucConDoSo: [UIButton] = []

    // Mục con 1: XEM SỐ (Chứa 4 tab Lũy kế | Realtime | Biểu đồ | Nhân viên + 8 thẻ chỉ số + bảng/biểu đồ)
    private let khungXemSo = UIView()
    private let khungThanhTabXemSo = UIView()
    private let nganNutTabXemSo = UIStackView()
    private var cacNutTabXemSo: [UIButton] = []

    private let khungCumDoanhThu = UIView()
    private let thanhTieuDeDoanhThu = UIControl()
    private let nhanTieuDeCumDoanhThu = UILabel()
    private let nhanPhuCumDoanhThu = UILabel()
    private let vachNganHaiCum = UIView()
    private let khungCumDuoi = UIView()
    private var rangBuocTopKhungDuoiTheoVach: NSLayoutConstraint?
    private var rangBuocTopKhungDuoiTheoDinh: NSLayoutConstraint?
    private var rangBuocTopKhungDuoiTheoDinhXemSo: NSLayoutConstraint?
    private var rangBuocTopNutQuetTheoNV: NSLayoutConstraint?
    private var rangBuocTopNutQuetTheoDinh: NSLayoutConstraint?
    private var rangBuocTopBangThiDua: NSLayoutConstraint?
    private var rangBuocTopBangNhanVien: NSLayoutConstraint?
    private var rangBuocBangRongHaiNutNV: NSLayoutConstraint?

    // Mục con 2: NHẬP SỐ (Nhập tất cả Lũy kế & Nhập tất cả Realtime + Nhập từng phần)
    private let khungNhapSo = UIView()
    private let nhanTrangThaiNhapSo = UILabel()

    // Mục con 3: XUẤT ẢNH (Chọn loại ảnh -> Hiện ô Text báo cáo -> Nút Xuất ảnh thật & Copy gửi LINE + Xuất Excel/PPTX)
    private let khungXuatAnh = UIView()
    private var loaiXuatAnhDangChon: LoaiBaoCaoXuatAnh = .doanhThuThiDuaLuyKe
    private var giongXuatAnhDangChon: GiongVanBanTin = .binhThuong
    private var cacNutLoaiXuatAnh: [UIButton] = []
    private var cacNutGiongXuatAnh: [UIButton] = []
    private let oVanBanXuatAnh = UITextView()
    private let oYeuCauRiengXuatAnh = UITextView()
    private let nhanGoiYYeuCauXuatAnh = UILabel()
    private let nhanTrangThaiXuatAnh = UILabel()
    private let nutAIGeminiXuatAnh = UIButton(type: .system)
    private let nutCopyJSONXuatAnh = UIButton(type: .system)

    // 1. Cụm 8 thẻ Chỉ số chính
    private let cumChiSoChinh = CumChiSoChinhView(coLon: false, anHangNutCheDo: true)

    // 2. Thanh chọn nhanh chế độ Lũy kế / Realtime khi đang ở tab "Nhân viên" trong Xem số
    private let hangChonCheDoNV = UIStackView()
    private let nutNVLuyKe = UIButton(type: .custom)
    private let nutNVRealtime = UIButton(type: .custom)

    // 3. Cụm nút Quét / Thêm ảnh mới & Xoá
    private var hangNutQuet: UIStackView!
    private let nutThemAnhMoi = UIButton(type: .system)
    private let nutNhapDoanhThuNV = UIButton(type: .system)
    private let nutNhapGioCongNV = UIButton(type: .system)
    private let nutXoaQuetLai = UIButton(type: .system)
    private let nutThemThuCong = UIButton(type: .system)
    private let nutXuatAnhTrongXemSo = UIButton(type: .system)

    // 4. Các bảng dữ liệu trong phần "1. Xem số"
    private let bangThiDua = BangThiDuaView()
    private let bangNhanVien = BangNhanVienView()
    private let bangRealtimeThang = BangTongHopRealtimeThangView()
    private let khungTonKho = KhungLocTonKhoView()

    // 5. Khung nội dung cho các mục khác trong Menu (Tổng quan, Báo cáo AI, Cài đặt, Quản trị, Mở rộng)
    private let khungTongQuan = UIView()
    private var caTongQuanDangChon: CaBaoCaoTongQuan = .dauCa
    private let nutChonCaTongQuan = UIButton(type: .system)
    private let nutChonNVTongQuan = UIButton(type: .system)
    private var maNVChonTongQuan: Set<String>? = {
        guard let mang = UserDefaults.standard.stringArray(forKey: "dmx_ma_nv_chon_tong_quan_v1") else { return nil }
        return Set(mang)
    }()
    private let nhanTomTatTongQuan = UITextView()
    private let khungBaoCao = UIView()
    private lazy var manHinhBanTinNhung = ManHinhBanTin(ngay: ngayHienTai) { [weak self] khung, soLieu in
        self?.taoAnhBangChoBanTin(khung: khung, soLieu: soLieu) ?? []
    }
    private let khungTaiKhoanHopThu = UIView()
    private lazy var manHinhCaiDatNhung = ManHinhCaiDat(ngay: ngayHienTai)
    private let khungQuanTri = UIView()
    private lazy var manHinhQuanTriNhung = ManHinhQuanLyTaiKhoan()
    private let khungTrinhDuyet = UIView()
    private lazy var manHinhTrinhDuyetNhung = ManHinhTrinhDuyet(ngay: ngayHienTai)
    private let khungMucMoRong = UIView()
    private let bangGuiBaoCao = BangGuiBaoCaoView()
    private let bieuTuongMucMoRong = UIImageView()
    private let nhanTieuDeMucMoRong = UILabel()
    private let nhanMoTaMucMoRong = UILabel()
    private let nganHanhDongMucMoRong = UIStackView()
    private var noiDungXuatFileDangChon: LoaiBaoCaoXuatAnh = .doanhThuThiDuaLuyKe
    private var dinhDangFileDangChon: DinhDangFileBaoCao = .excel
    private let nutChonNoiDungXuatFile = UIButton(type: .system)
    private let nutChonDinhDangFile = UIButton(type: .system)
    private let oCauLenhXuatFile = UITextView()
    private let cuonMucMoRong = UIScrollView()
    private var rangBuocCaoOCauLenhXuatFile: NSLayoutConstraint?

    // 6. Menu trượt bên trái (Sidebar Drawer) & lớp nền mờ
    private let lopNenMoMenu = UIControl()
    private let menuBenTrai = MenuDieuHuongBenTraiView()
    private var rangBuocTraiMenu: NSLayoutConstraint?
    private let chieuRongMenu: CGFloat = 286
    private var dangMoMenu: Bool = false

    // Hộp thoại tiến trình quét
    private let lopPhuTai = UIView()
    private let nhanTienTrinh = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BangMauBCTD.nenTrang
        navigationController?.setNavigationBarHidden(true, animated: false)
        cauHinhThanhDieuHuong()
        taoGiaoDien()
        napDuLieu()
        NotificationCenter.default.addObserver(self, selector: #selector(duLieuDaDongBo), name: .duLieuDMXDaDongBo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(duLieuDaThayDoiTaiMay(_:)), name: .duLieuDMXDaThayDoiTaiMay, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taoLaiAnhBaoCaoBot), name: .yeuCauTaoLaiAnhBaoCaoBot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(taiKhoanBiDangXuat), name: .taiKhoanDMXBiDangXuat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(duLieuDaDongBo), name: .sieuThiDMXDaThayDoi, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ungDungTroLai), name: UIApplication.willEnterForegroundNotification, object: nil)
        DichVuDongBo.dungChung.taiDanhSachSieuThi { _ in
            DichVuDongBo.dungChung.taiDuLieu()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        napDuLieu()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }

    deinit {
        congViecTaoAnhBot?.cancel()
        maLanTaoAnhBot = UUID()
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func duLieuDaDongBo() {
        dsThiDuaDaNapUI = nil
        napDuLieu()
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        lenLichCapNhatAnhBaoCaoBot(dl: dl, ngay: ngayHienTai)
    }

    @objc private func duLieuDaThayDoiTaiMay(_ thongBao: Notification) {
        guard let khoaNgay = thongBao.object as? String,
              let ngay = TienIchNgay.khoa.date(from: khoaNgay) else { return }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        lenLichCapNhatAnhBaoCaoBot(dl: dl, ngay: ngay)
    }

    @objc private func taoLaiAnhBaoCaoBot() {
        khoaAnhBotDaTai = ""
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        lenLichCapNhatAnhBaoCaoBot(dl: dl, ngay: ngayHienTai)
    }

    @objc private func taiKhoanBiDangXuat() {
        (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiDangNhap()
    }

    @objc private func ungDungTroLai() { DichVuDongBo.dungChung.taiDuLieu() }

    // MARK: - Thanh điều hướng trên cùng (Nút mở Menu + Chọn ngày + Nhập số / Xuất ảnh / Cài đặt)

    private func cauHinhThanhDieuHuong() {
        let cfgMenu = UIImage.SymbolConfiguration(pointSize: 14.5, weight: .bold)
        nutMoMenu.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: cfgMenu), for: .normal)
        nutMoMenu.setTitle(" Menu", for: .normal)
        nutMoMenu.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutMoMenu.titleLabel?.numberOfLines = 0
        nutMoMenu.titleLabel?.lineBreakMode = .byWordWrapping
        nutMoMenu.titleLabel?.adjustsFontSizeToFitWidth = false
        nutMoMenu.tintColor = BangMauBCTD.vangSang
        nutMoMenu.setTitleColor(.white, for: .normal)
        nutMoMenu.backgroundColor = BangMauBCTD.xanhChuDao
        nutMoMenu.layer.cornerRadius = 9
        nutMoMenu.contentEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 10)
        nutMoMenu.addTarget(self, action: #selector(bamNutMenu), for: .touchUpInside)

        nutNgay.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutNgay.titleLabel?.numberOfLines = 0
        nutNgay.titleLabel?.lineBreakMode = .byWordWrapping
        nutNgay.titleLabel?.adjustsFontSizeToFitWidth = false
        nutNgay.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutNgay.backgroundColor = BangMauBCTD.nenThe
        nutNgay.layer.cornerRadius = 8
        nutNgay.layer.borderWidth = 1
        nutNgay.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutNgay.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        nutNgay.addTarget(self, action: #selector(moLichSuNgay), for: .touchUpInside)

        let cumTrai = UIStackView(arrangedSubviews: [nutMoMenu, nutNgay, nutCopyTongQuanNav, nutXuatNav, nutXoaNav, nutQuanLyNhanVienNav, nutXuatAnhTonKhoNav])
        cumTrai.axis = .horizontal
        cumTrai.spacing = 6
        cumTrai.alignment = .center
        cumTrai.translatesAutoresizingMaskIntoConstraints = false

        khungThanhDieuHuong.backgroundColor = BangMauBCTD.nenTrang
        khungThanhDieuHuong.translatesAutoresizingMaskIntoConstraints = false
        khungThanhDieuHuong.addSubview(cumTrai)
        NSLayoutConstraint.activate([
            cumTrai.topAnchor.constraint(equalTo: khungThanhDieuHuong.topAnchor, constant: 4),
            cumTrai.bottomAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor, constant: -4),
            cumTrai.leadingAnchor.constraint(equalTo: khungThanhDieuHuong.leadingAnchor, constant: 8),
            cumTrai.trailingAnchor.constraint(lessThanOrEqualTo: khungThanhDieuHuong.trailingAnchor, constant: -8)
        ])
        navigationItem.leftBarButtonItem = nil

        let cfgPhoto = UIImage.SymbolConfiguration(pointSize: 12.0, weight: .bold)
        nutNhapTatCa.setImage(UIImage(systemName: "photo.stack.fill", withConfiguration: cfgPhoto), for: .normal)
        nutNhapTatCa.setTitle(" Nhập tất cả", for: .normal)
        nutNhapTatCa.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutNhapTatCa.titleLabel?.numberOfLines = 1
        nutNhapTatCa.titleLabel?.lineBreakMode = .byTruncatingTail
        nutNhapTatCa.titleLabel?.textAlignment = .center
        nutNhapTatCa.titleLabel?.adjustsFontSizeToFitWidth = true
        nutNhapTatCa.titleLabel?.minimumScaleFactor = 0.75
        nutNhapTatCa.backgroundColor = BangMauBCTD.xanhChuDao
        nutNhapTatCa.tintColor = .white
        nutNhapTatCa.setTitleColor(.white, for: .normal)
        nutNhapTatCa.layer.cornerRadius = 9
        nutNhapTatCa.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        nutNhapTatCa.setContentHuggingPriority(.required, for: .horizontal)
        nutNhapTatCa.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutNhapTatCa.addTarget(self, action: #selector(bamNhapTatCaAnh), for: .touchUpInside)

        let cauHinhIcon = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        nutXuatNav.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: cauHinhIcon), for: .normal)
        nutXuatNav.tintColor = BangMauBCTD.chuChinh
        nutXuatNav.backgroundColor = BangMauBCTD.vangSang
        nutXuatNav.layer.cornerRadius = 8
        nutXuatNav.layer.borderWidth = 1
        nutXuatNav.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutXuatNav.translatesAutoresizingMaskIntoConstraints = false
        let rongNutXuat = nutXuatNav.widthAnchor.constraint(equalToConstant: 32)
        rongNutXuat.priority = .defaultHigh
        rongNutXuat.isActive = true
        nutXuatNav.heightAnchor.constraint(equalToConstant: 31).isActive = true
        nutXuatNav.addTarget(self, action: #selector(moMenuXuatBaoCao), for: .touchUpInside)
        nutXuatNav.accessibilityLabel = "Xuất ảnh"
        cauHinhNutIconNav(nutXoaNav, icon: "trash", nhan: "Xóa dữ liệu", mau: BangMauBCTD.doYeuChu)
        nutXoaNav.addTarget(self, action: #selector(moMenuXoaDuLieu), for: .touchUpInside)
        cauHinhNutIconNav(nutCopyTongQuanNav, icon: "doc.on.doc", nhan: "Sao chép tổng quan", mau: BangMauBCTD.xanhChuDaoDam)
        nutCopyTongQuanNav.addTarget(self, action: #selector(saoChepTongQuan), for: .touchUpInside)

        let cfgQuanTriNV = UIImage.SymbolConfiguration(pointSize: 12.5, weight: .bold)
        let iconQuanTriNV = UIImage(systemName: "gearshape.fill", withConfiguration: cfgQuanTriNV)?
            .withTintColor(BangMauBCTD.vangSang, renderingMode: .alwaysOriginal)
        nutQuanLyNhanVienNav.setImage(iconQuanTriNV, for: .normal)
        nutQuanLyNhanVienNav.setTitle(" Quản trị", for: .normal)
        nutQuanLyNhanVienNav.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutQuanLyNhanVienNav.titleLabel?.numberOfLines = 0
        nutQuanLyNhanVienNav.titleLabel?.lineBreakMode = .byWordWrapping
        nutQuanLyNhanVienNav.titleLabel?.adjustsFontSizeToFitWidth = false
        nutQuanLyNhanVienNav.tintColor = .white
        nutQuanLyNhanVienNav.setTitleColor(.white, for: .normal)
        nutQuanLyNhanVienNav.setTitleColor(.white, for: .highlighted)
        nutQuanLyNhanVienNav.setTitleColor(.white, for: .selected)
        nutQuanLyNhanVienNav.backgroundColor = BangMauBCTD.xanhChuDao
        nutQuanLyNhanVienNav.layer.cornerRadius = 9
        nutQuanLyNhanVienNav.layer.borderWidth = 1
        nutQuanLyNhanVienNav.layer.borderColor = BangMauBCTD.xanhChuDaoDam.cgColor
        nutQuanLyNhanVienNav.contentEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 10)
        nutQuanLyNhanVienNav.translatesAutoresizingMaskIntoConstraints = false
        nutQuanLyNhanVienNav.heightAnchor.constraint(equalToConstant: 31).isActive = true
        nutQuanLyNhanVienNav.setContentHuggingPriority(.required, for: .horizontal)
        nutQuanLyNhanVienNav.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutQuanLyNhanVienNav.accessibilityLabel = "Quản trị nhân viên"
        nutQuanLyNhanVienNav.menu = UIMenu(title: "Quản trị nhân viên", children: [
            UIAction(title: "Chia target mặt hàng", image: UIImage(systemName: "target")) { [weak self] _ in
                self?.moNhanhChiaTarget()
            },
            UIAction(title: "Danh sách nhân viên quản lý", image: UIImage(systemName: "person.2")) { [weak self] _ in
                self?.moNhanhQuanLyNV()
            }
        ])
        nutQuanLyNhanVienNav.showsMenuAsPrimaryAction = true

        nutXuatAnhTonKhoNav.setTitle("🖼️ Xuất ảnh", for: .normal)
        nutXuatAnhTonKhoNav.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .heavy)
        nutXuatAnhTonKhoNav.titleLabel?.numberOfLines = 1
        nutXuatAnhTonKhoNav.setTitleColor(.white, for: .normal)
        nutXuatAnhTonKhoNav.backgroundColor = BangMauBCTD.xanhDatVach
        nutXuatAnhTonKhoNav.layer.cornerRadius = 9
        nutXuatAnhTonKhoNav.layer.borderWidth = 1.2
        nutXuatAnhTonKhoNav.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutXuatAnhTonKhoNav.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutXuatAnhTonKhoNav.translatesAutoresizingMaskIntoConstraints = false
        nutXuatAnhTonKhoNav.heightAnchor.constraint(equalToConstant: 31).isActive = true
        nutXuatAnhTonKhoNav.setContentHuggingPriority(.required, for: .horizontal)
        nutXuatAnhTonKhoNav.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutXuatAnhTonKhoNav.isHidden = true
        nutXuatAnhTonKhoNav.addTarget(self, action: #selector(bamXuatAnhTonKhoTrenNav), for: .touchUpInside)

        nutCaiDatNav.setImage(UIImage(systemName: "gearshape.fill", withConfiguration: cauHinhIcon), for: .normal)
        nutCaiDatNav.tintColor = BangMauBCTD.xanhChuDaoDam
        nutCaiDatNav.backgroundColor = BangMauBCTD.nenHeaderPhu
        nutCaiDatNav.layer.cornerRadius = 8
        nutCaiDatNav.layer.borderWidth = 1
        nutCaiDatNav.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor
        nutCaiDatNav.translatesAutoresizingMaskIntoConstraints = false
        nutCaiDatNav.widthAnchor.constraint(equalToConstant: 32).isActive = true
        nutCaiDatNav.heightAnchor.constraint(equalToConstant: 31).isActive = true
        nutCaiDatNav.addTarget(self, action: #selector(bamMoCaiDatNhanh), for: .touchUpInside)

        navigationItem.rightBarButtonItem = nil
    }

    @objc private func bamMoCaiDatNhanh() {
        mucMenuChinh = .caiDat
        anMenu(animated: true)
        napDuLieu()
    }

    @objc private func bamXuatAnhTonKhoTrenNav() {
        khungTonKho.bamXuatAnhBang()
    }

    private func cauHinhNutIconNav(_ nut: UIButton, icon: String, nhan: String, mau: UIColor) {
        nut.setImage(UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)), for: .normal)
        nut.accessibilityLabel = nhan
        nut.tintColor = mau
        nut.backgroundColor = BangMauBCTD.nenThe
        nut.layer.cornerRadius = 8
        nut.layer.borderWidth = 1
        nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
        let rong = nut.widthAnchor.constraint(equalToConstant: 32)
        rong.priority = .defaultHigh
        rong.isActive = true
        nut.heightAnchor.constraint(equalToConstant: 31).isActive = true
    }

    @objc private func bamNutMenu() {
        if dangMoMenu {
            anMenu(animated: true)
        } else {
            hienMenu(animated: true)
        }
    }

    private func hienMenu(animated: Bool) {
        dangMoMenu = true
        menuBenTrai.isUserInteractionEnabled = true
        khungThanhDieuHuong.isUserInteractionEnabled = false
        menuBenTrai.capNhatTrangThai(mucChinh: mucMenuChinh, mucCon: mucConDoSo)
        lopNenMoMenu.isHidden = false
        menuBenTrai.isHidden = false
        view.bringSubviewToFront(lopNenMoMenu)
        view.bringSubviewToFront(menuBenTrai)
        view.bringSubviewToFront(lopPhuTai)

        rangBuocTraiMenu?.constant = 0
        if animated {
            UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseOut]) {
                self.lopNenMoMenu.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            lopNenMoMenu.alpha = 1
            view.layoutIfNeeded()
        }
    }

    @objc private func anMenu(animated: Bool = true) {
        guard dangMoMenu else { return }
        dangMoMenu = false
        // Không nhận thêm lựa chọn trong lúc menu đang trượt ra. Nếu bấm liên tục,
        // các lần nạp bảng nặng sẽ không còn chạy chồng lên cùng một khung hình.
        menuBenTrai.isUserInteractionEnabled = false
        khungThanhDieuHuong.isUserInteractionEnabled = true
        view.endEditing(true)
        rangBuocTraiMenu?.constant = -chieuRongMenu
        if animated {
            UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseIn]) {
                self.lopNenMoMenu.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                if !self.dangMoMenu {
                    self.lopNenMoMenu.isHidden = true
                    self.menuBenTrai.isHidden = true
                }
                self.menuBenTrai.isUserInteractionEnabled = true
            }
        } else {
            lopNenMoMenu.alpha = 0
            lopNenMoMenu.isHidden = true
            menuBenTrai.isHidden = true
            menuBenTrai.isUserInteractionEnabled = true
            view.layoutIfNeeded()
        }
    }

    private func chuyenSangTaiKhoanHopThu() {
        mucMenuChinh = .caiDat
        anMenu(animated: true)
        napDuLieu()
    }

    @objc private func bamNhapTatCaAnh() {
        moChonAnh(cheDo: .tatCaAnhTheoTab(cheDoDoanhThu), gioiHan: 0)
    }

    // MARK: - Dựng giao diện chính

    private func taoGiaoDien() {
        view.addSubview(khungThanhDieuHuong)

        khungDoSoXemSo.backgroundColor = .clear
        khungDoSoXemSo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungDoSoXemSo)

        // 0. Thanh chuyển nhanh 3 mục con của "Đổ số - Xem số": 1. Xem số | 2. Nhập số | 3. Xuất ảnh
        khungThanhMucConDoSo.backgroundColor = BangMauBCTD.nenThe
        khungThanhMucConDoSo.isHidden = true
        khungThanhMucConDoSo.layer.cornerRadius = 11
        khungThanhMucConDoSo.layer.borderWidth = 1
        khungThanhMucConDoSo.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor

        nganNutMucConDoSo.axis = .horizontal
        nganNutMucConDoSo.isHidden = true
        nganNutMucConDoSo.spacing = 6
        nganNutMucConDoSo.distribution = .fillEqually
        nganNutMucConDoSo.translatesAutoresizingMaskIntoConstraints = false
        khungThanhMucConDoSo.addSubview(nganNutMucConDoSo)

        cacNutMucConDoSo.removeAll()
        for mucCon in MucConDoSo.allCases {
            let nut = UIButton(type: .custom)
            nut.tag = mucCon.rawValue
            let bieuTuong: String
            switch mucCon {
            case .xemSo: bieuTuong = "👁️ "
            case .nhapSo: bieuTuong = "📥 "
            case .xuatAnh: bieuTuong = "🖼️ "
            }
            nut.setTitle(bieuTuong + mucCon.tieuDe, for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.titleLabel?.lineBreakMode = .byWordWrapping
            nut.titleLabel?.textAlignment = .center
            nut.titleLabel?.adjustsFontSizeToFitWidth = false
            nut.contentEdgeInsets = UIEdgeInsets(top: 7, left: 6, bottom: 7, right: 6)
            nut.layer.cornerRadius = 8
            nut.addTarget(self, action: #selector(bamChonMucConTrenThanh(_:)), for: .touchUpInside)
            cacNutMucConDoSo.append(nut)
            nganNutMucConDoSo.addArrangedSubview(nut)
        }

        // Khung Mục con 1: XEM SỐ (Chứa thanh 4 tab Lũy kế | Realtime | Biểu đồ | Nhân viên)
        khungXemSo.backgroundColor = .clear
        khungXemSo.translatesAutoresizingMaskIntoConstraints = false

        khungThanhTabXemSo.backgroundColor = BangMauBCTD.nenHeaderPhu
        khungThanhTabXemSo.layer.cornerRadius = 10
        khungThanhTabXemSo.layer.borderWidth = 1
        khungThanhTabXemSo.layer.borderColor = BangMauBCTD.vienThe.cgColor

        nganNutTabXemSo.axis = .horizontal
        nganNutTabXemSo.spacing = 4
        nganNutTabXemSo.distribution = .fillEqually
        nganNutTabXemSo.translatesAutoresizingMaskIntoConstraints = false
        khungThanhTabXemSo.addSubview(nganNutTabXemSo)

        cacNutTabXemSo.removeAll()
        for tab in TabXemSo.allCases {
            let nut = UIButton(type: .custom)
            nut.tag = tab.rawValue
            nut.setTitle("\(tab.bieuTuong) \(tab.tieuDe)", for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.titleLabel?.lineBreakMode = .byWordWrapping
            nut.titleLabel?.textAlignment = .center
            nut.titleLabel?.adjustsFontSizeToFitWidth = false
            nut.contentEdgeInsets = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 4)
            nut.layer.cornerRadius = 7
            nut.addTarget(self, action: #selector(bamChonTabXemSo(_:)), for: .touchUpInside)
            cacNutTabXemSo.append(nut)
            nganNutTabXemSo.addArrangedSubview(nut)
        }

        // Khung cụm Doanh thu sáng sủa + thanh tiêu đề xanh tươi
        khungCumDoanhThu.backgroundColor = BangMauBCTD.nenThe
        khungCumDoanhThu.layer.cornerRadius = 12
        khungCumDoanhThu.layer.borderWidth = 1
        khungCumDoanhThu.layer.borderColor = BangMauBCTD.vienThe.cgColor
        khungCumDoanhThu.clipsToBounds = true

        thanhTieuDeDoanhThu.backgroundColor = BangMauBCTD.xanhChuDao
        thanhTieuDeDoanhThu.isHidden = true
        thanhTieuDeDoanhThu.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)
        thanhTieuDeDoanhThu.translatesAutoresizingMaskIntoConstraints = false
        khungCumDoanhThu.addSubview(thanhTieuDeDoanhThu)

        let vachVangDauDT = UIView()
        vachVangDauDT.backgroundColor = BangMauBCTD.vangSang
        vachVangDauDT.isUserInteractionEnabled = false
        vachVangDauDT.translatesAutoresizingMaskIntoConstraints = false
        thanhTieuDeDoanhThu.addSubview(vachVangDauDT)

        nhanTieuDeCumDoanhThu.text = "CHỈ SỐ KINH DOANH · LŨY KẾ"
        nhanTieuDeCumDoanhThu.font = .systemFont(ofSize: 11.5, weight: .heavy)
        nhanTieuDeCumDoanhThu.textColor = BangMauBCTD.vangSang
        nhanTieuDeCumDoanhThu.numberOfLines = 0
        nhanTieuDeCumDoanhThu.lineBreakMode = .byWordWrapping
        nhanTieuDeCumDoanhThu.adjustsFontSizeToFitWidth = false
        nhanTieuDeCumDoanhThu.isUserInteractionEnabled = false
        nhanTieuDeCumDoanhThu.translatesAutoresizingMaskIntoConstraints = false
        thanhTieuDeDoanhThu.addSubview(nhanTieuDeCumDoanhThu)

        nhanPhuCumDoanhThu.text = "Chạm 8 thẻ để quét/sửa ▸"
        nhanPhuCumDoanhThu.font = .systemFont(ofSize: 10.5, weight: .semibold)
        nhanPhuCumDoanhThu.textColor = .white
        nhanPhuCumDoanhThu.textAlignment = .right
        nhanPhuCumDoanhThu.numberOfLines = 0
        nhanPhuCumDoanhThu.lineBreakMode = .byWordWrapping
        nhanPhuCumDoanhThu.adjustsFontSizeToFitWidth = false
        nhanPhuCumDoanhThu.isUserInteractionEnabled = false
        nhanPhuCumDoanhThu.setContentCompressionResistancePriority(.required, for: .horizontal)
        nhanPhuCumDoanhThu.translatesAutoresizingMaskIntoConstraints = false
        thanhTieuDeDoanhThu.addSubview(nhanPhuCumDoanhThu)

        vachNganHaiCum.backgroundColor = .clear
        vachNganHaiCum.isHidden = true

        khungCumDuoi.backgroundColor = BangMauBCTD.nenThe
        khungCumDuoi.layer.cornerRadius = 12
        khungCumDuoi.layer.borderWidth = 1
        khungCumDuoi.layer.borderColor = BangMauBCTD.vienThe.cgColor

        // 1. Cụm 8 thẻ Chỉ số chính
        cumChiSoChinh.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)
        cumChiSoChinh.khiBamVungThe = { [weak self] in
            self?.bamTheDoanhThu()
        }

        // 2. Thanh chọn nhanh chế độ dữ liệu Lũy kế / Realtime khi đang xem tab "Nhân viên"
        cauHinhNutCheDoNV(nutNVLuyKe, tieuDe: "📊 Nhân viên Lũy kế", tag: LoaiCheDoDoanhThu.luyKe.rawValue)
        cauHinhNutCheDoNV(nutNVRealtime, tieuDe: "⚡ Nhân viên Realtime", tag: LoaiCheDoDoanhThu.realtime.rawValue)
        hangChonCheDoNV.addArrangedSubview(nutNVLuyKe)
        hangChonCheDoNV.addArrangedSubview(nutNVRealtime)
        hangChonCheDoNV.axis = .horizontal
        hangChonCheDoNV.spacing = 6
        hangChonCheDoNV.distribution = .fillEqually

        // 3. Thanh nút Quét & Xoá
        nutThemAnhMoi.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        nutThemAnhMoi.setTitle(" Thêm ảnh", for: .normal)
        nutThemAnhMoi.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutThemAnhMoi.titleLabel?.numberOfLines = 1
        nutThemAnhMoi.titleLabel?.lineBreakMode = .byTruncatingTail
        nutThemAnhMoi.titleLabel?.textAlignment = .center
        nutThemAnhMoi.titleLabel?.adjustsFontSizeToFitWidth = true
        nutThemAnhMoi.titleLabel?.minimumScaleFactor = 0.75
        nutThemAnhMoi.backgroundColor = BangMauBCTD.xanhChuDao
        nutThemAnhMoi.tintColor = .white
        nutThemAnhMoi.setTitleColor(.white, for: .normal)
        nutThemAnhMoi.layer.cornerRadius = 9
        nutThemAnhMoi.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        nutThemAnhMoi.addTarget(self, action: #selector(bamThemAnhMoi), for: .touchUpInside)

        nutNhapDoanhThuNV.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        nutNhapDoanhThuNV.setTitle(" Nhập ảnh Doanh thu", for: .normal)
        nutNhapDoanhThuNV.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutNhapDoanhThuNV.titleLabel?.numberOfLines = 1
        nutNhapDoanhThuNV.titleLabel?.lineBreakMode = .byTruncatingTail
        nutNhapDoanhThuNV.titleLabel?.textAlignment = .center
        nutNhapDoanhThuNV.titleLabel?.adjustsFontSizeToFitWidth = true
        nutNhapDoanhThuNV.titleLabel?.minimumScaleFactor = 0.72
        nutNhapDoanhThuNV.backgroundColor = BangMauBCTD.indigoNhatNen
        nutNhapDoanhThuNV.tintColor = BangMauBCTD.indigoDam
        nutNhapDoanhThuNV.setTitleColor(BangMauBCTD.indigoDam, for: .normal)
        nutNhapDoanhThuNV.layer.cornerRadius = 9
        nutNhapDoanhThuNV.layer.borderWidth = 1
        nutNhapDoanhThuNV.layer.borderColor = BangMauBCTD.indigoVien.cgColor
        nutNhapDoanhThuNV.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        nutNhapDoanhThuNV.addTarget(self, action: #selector(bamNhapAnhDoanhThuNV), for: .touchUpInside)

        nutNhapGioCongNV.setImage(UIImage(systemName: "clock.fill"), for: .normal)
        nutNhapGioCongNV.setTitle(" Quét Giờ công", for: .normal)
        nutNhapGioCongNV.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutNhapGioCongNV.titleLabel?.numberOfLines = 1
        nutNhapGioCongNV.titleLabel?.lineBreakMode = .byTruncatingTail
        nutNhapGioCongNV.titleLabel?.textAlignment = .center
        nutNhapGioCongNV.titleLabel?.adjustsFontSizeToFitWidth = true
        nutNhapGioCongNV.titleLabel?.minimumScaleFactor = 0.72
        nutNhapGioCongNV.backgroundColor = UIColor(red: 0.90, green: 0.97, blue: 0.94, alpha: 1)
        nutNhapGioCongNV.tintColor = UIColor(red: 0.05, green: 0.48, blue: 0.30, alpha: 1)
        nutNhapGioCongNV.setTitleColor(UIColor(red: 0.05, green: 0.48, blue: 0.30, alpha: 1), for: .normal)
        nutNhapGioCongNV.layer.cornerRadius = 9
        nutNhapGioCongNV.layer.borderWidth = 1
        nutNhapGioCongNV.layer.borderColor = UIColor(red: 0.65, green: 0.88, blue: 0.76, alpha: 1).cgColor
        nutNhapGioCongNV.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        nutNhapGioCongNV.addTarget(self, action: #selector(bamNhapAnhGioCongNV), for: .touchUpInside)

        nutXoaQuetLai.setTitle(" Xoá", for: .normal)
        nutXoaQuetLai.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        nutXoaQuetLai.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutXoaQuetLai.titleLabel?.numberOfLines = 1
        nutXoaQuetLai.titleLabel?.lineBreakMode = .byTruncatingTail
        nutXoaQuetLai.titleLabel?.textAlignment = .center
        nutXoaQuetLai.titleLabel?.adjustsFontSizeToFitWidth = true
        nutXoaQuetLai.titleLabel?.minimumScaleFactor = 0.75
        nutXoaQuetLai.backgroundColor = BangMauBCTD.doYeuPill
        nutXoaQuetLai.tintColor = BangMauBCTD.doYeuChu
        nutXoaQuetLai.setTitleColor(BangMauBCTD.doYeuChu, for: .normal)
        nutXoaQuetLai.layer.cornerRadius = 9
        nutXoaQuetLai.layer.borderWidth = 1
        nutXoaQuetLai.layer.borderColor = BangMauBCTD.doYeuVach.withAlphaComponent(0.3).cgColor
        nutXoaQuetLai.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutXoaQuetLai.addTarget(self, action: #selector(bamXoaQuetLai), for: .touchUpInside)

        nutThemThuCong.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        nutThemThuCong.setTitle(" Nhập/Mẫu", for: .normal)
        nutThemThuCong.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutThemThuCong.titleLabel?.numberOfLines = 1
        nutThemThuCong.titleLabel?.lineBreakMode = .byTruncatingTail
        nutThemThuCong.titleLabel?.textAlignment = .center
        nutThemThuCong.titleLabel?.adjustsFontSizeToFitWidth = true
        nutThemThuCong.titleLabel?.minimumScaleFactor = 0.75
        nutThemThuCong.backgroundColor = BangMauBCTD.nenThePhu
        nutThemThuCong.tintColor = BangMauBCTD.chuChinh
        nutThemThuCong.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutThemThuCong.layer.cornerRadius = 9
        nutThemThuCong.layer.borderWidth = 1
        nutThemThuCong.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutThemThuCong.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        nutThemThuCong.addTarget(self, action: #selector(bamThemDongThuCong), for: .touchUpInside)

        nutXuatAnhTrongXemSo.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        nutXuatAnhTrongXemSo.setTitle(" Xuất ảnh", for: .normal)
        nutXuatAnhTrongXemSo.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutXuatAnhTrongXemSo.titleLabel?.numberOfLines = 1
        nutXuatAnhTrongXemSo.titleLabel?.lineBreakMode = .byTruncatingTail
        nutXuatAnhTrongXemSo.titleLabel?.adjustsFontSizeToFitWidth = true
        nutXuatAnhTrongXemSo.titleLabel?.minimumScaleFactor = 0.75
        nutXuatAnhTrongXemSo.backgroundColor = BangMauBCTD.xanhDatVach
        nutXuatAnhTrongXemSo.tintColor = .white
        nutXuatAnhTrongXemSo.setTitleColor(.white, for: .normal)
        nutXuatAnhTrongXemSo.layer.cornerRadius = 9
        nutXuatAnhTrongXemSo.addTarget(self, action: #selector(moMenuXuatBaoCao), for: .touchUpInside)

        hangNutQuet = UIStackView(arrangedSubviews: [nutThemAnhMoi, nutNhapDoanhThuNV, nutNhapGioCongNV, nutXoaQuetLai])
        hangNutQuet.axis = .horizontal
        hangNutQuet.spacing = 5
        nutThemAnhMoi.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nutThemAnhMoi.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nutNhapDoanhThuNV.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nutNhapDoanhThuNV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nutNhapGioCongNV.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nutNhapGioCongNV.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nutXoaQuetLai.setContentHuggingPriority(.required, for: .horizontal)
        nutXoaQuetLai.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutThemThuCong.setContentHuggingPriority(.required, for: .horizontal)
        nutThemThuCong.setContentCompressionResistancePriority(.required, for: .horizontal)

        let rgBangRongNV = nutNhapDoanhThuNV.widthAnchor.constraint(equalTo: nutThemAnhMoi.widthAnchor)
        rgBangRongNV.priority = .defaultHigh
        rangBuocBangRongHaiNutNV = rgBangRongNV

        // 4. Sự kiện các bảng dữ liệu trong phần "1. Xem số"
        bangThiDua.khiBamQuetAnh = { [weak self] in
            self?.bamTheDoanhThu()
        }
        bangThiDua.khiDoiCheDoDuKien = { [weak self] _ in
            self?.napDuLieu()
        }
        bangThiDua.khiChonDong = { [weak self] dong in
            guard let self = self else { return }
            let vc = ManHinhChiTietNganhHang(dong: dong, ngay: self.ngayHienTai, cheDo: self.cheDoDoanhThu)
            vc.khiCapNhatDuLieu = { [weak self] in
                self?.dsThiDuaDaNapUI = nil
                self?.napDuLieu()
            }
            vc.khiYeuCauSuaDong = { [weak self] dongCanSua in
                self?.moHopThoaiSuaDong(dongCanSua)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        bangThiDua.khiSuaDong = { [weak self] dong in
            self?.moHopThoaiSuaDong(dong)
        }
        bangThiDua.khiXoaDong = { [weak self] id in
            guard let self = self else { return }
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            var ds = dl.danhSachThiDua(theo: self.cheDoDoanhThu)
            ds.removeAll { $0.id == id }
            if ds.isEmpty {
                KhoDuLieu.dungChung.xoaThiDuaTheoCheDo(cho: self.ngayHienTai, cheDo: self.cheDoDoanhThu)
            } else {
                dl.ganDanhSachThiDua(ds, theo: self.cheDoDoanhThu)
                KhoDuLieu.dungChung.luu(dl)
            }
            self.dsThiDuaDaNapUI = nil
            self.khoaCumChiSoDaNapUI = ""
            self.napDuLieu()
        }

        bangNhanVien.khiChonNhanVien = { [weak self] row in
            guard let self = self else { return }
            let vc = ManHinhChiTietNhanVien(row, ngay: self.ngayHienTai, cheDo: self.cheDoDoanhThu)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        bangNhanVien.khiBamQuetDoanhThuNV = { [weak self] in
            guard let self = self else { return }
            self.moChonAnh(cheDo: .doanhThuNhanVien(self.cheDoDoanhThu), gioiHan: 0)
        }
        bangNhanVien.khiBamMoCaiDatNV = { [weak self] in
            self?.moNhanhQuanLyNV()
        }
        bangNhanVien.khiBamChiaSeAnhNV = { [weak self] in
            self?.moMenuChiaSeAnhNhanVien()
        }

        bangRealtimeThang.khiBamSuaDoanhThuLuyKe = { [weak self] in
            guard let self = self else { return }
            self.mucMenuChinh = .doSoXemSo
            self.mucConDoSo = .xemSo
            self.tabXemSo = .luyKe
            self.cheDoDoanhThu = .luyKe
            self.napDuLieu()
            self.bamTheDoanhThu()
        }
        bangRealtimeThang.khiChonNgayRealtime = { [weak self] item in
            self?.moMenuRealtimeChoNgay(item)
        }
        bangRealtimeThang.khiChonNhanVienSucKhoe = { [weak self] row, cheDo in
            guard let self = self else { return }
            let vc = ManHinhChiTietNhanVien(row, ngay: self.ngayHienTai, cheDo: cheDo)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        bangRealtimeThang.khiChiaSeAnhSucKhoe = { [weak self] anh in
            self?.chiaSe([anh])
        }
        bangRealtimeThang.khiXuatTatCaAnhSucKhoeNV = { [weak self] in
            self?.moChonNhanVienChiaSeAnh(cheDo: .luyKe)
        }
        khungTonKho.khiXuatAnh = { [weak self] anh in
            self?.chiaSe([anh])
        }

        cumChiSoChinh.translatesAutoresizingMaskIntoConstraints = false
        khungCumDoanhThu.addSubview(cumChiSoChinh)

        [hangChonCheDoNV, hangNutQuet, bangThiDua, bangNhanVien, bangRealtimeThang, khungTonKho].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungCumDuoi.addSubview($0)
        }

        [khungThanhTabXemSo, khungCumDoanhThu, vachNganHaiCum, khungCumDuoi].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungXemSo.addSubview($0)
        }

        taoKhungNhapSo()
        taoKhungXuatAnh()

        [khungThanhMucConDoSo, khungXemSo, khungNhapSo, khungXuatAnh].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungDoSoXemSo.addSubview($0)
        }

        let rgTopDuoiTheoVach = khungCumDuoi.topAnchor.constraint(equalTo: khungCumDoanhThu.bottomAnchor, constant: 6)
        let rgTopDuoiTheoDinh = khungCumDuoi.topAnchor.constraint(equalTo: khungThanhTabXemSo.bottomAnchor, constant: 3)
        let rgTopDuoiTheoDinhXemSo = khungCumDuoi.topAnchor.constraint(equalTo: khungXemSo.topAnchor, constant: 2)
        rangBuocTopKhungDuoiTheoVach = rgTopDuoiTheoVach
        rangBuocTopKhungDuoiTheoDinh = rgTopDuoiTheoDinh
        rangBuocTopKhungDuoiTheoDinhXemSo = rgTopDuoiTheoDinhXemSo

        let rgTopNutQuetNV = hangNutQuet.topAnchor.constraint(equalTo: hangChonCheDoNV.bottomAnchor, constant: 6)
        let rgTopNutQuetDinh = hangNutQuet.topAnchor.constraint(equalTo: khungCumDuoi.topAnchor, constant: 8)
        rangBuocTopNutQuetTheoNV = rgTopNutQuetNV
        rangBuocTopNutQuetTheoDinh = rgTopNutQuetDinh

        let rgTopBangTD = bangThiDua.topAnchor.constraint(equalTo: khungCumDuoi.topAnchor, constant: 6)
        let rgTopBangNV = bangNhanVien.topAnchor.constraint(equalTo: hangNutQuet.bottomAnchor, constant: 8)
        rangBuocTopBangThiDua = rgTopBangTD
        rangBuocTopBangNhanVien = rgTopBangNV

        NSLayoutConstraint.activate([
            khungThanhDieuHuong.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            khungThanhDieuHuong.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungThanhDieuHuong.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            khungDoSoXemSo.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungDoSoXemSo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungDoSoXemSo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungDoSoXemSo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            khungThanhMucConDoSo.topAnchor.constraint(equalTo: khungDoSoXemSo.topAnchor, constant: 4),
            khungThanhMucConDoSo.leadingAnchor.constraint(equalTo: khungDoSoXemSo.leadingAnchor, constant: 8),
            khungThanhMucConDoSo.trailingAnchor.constraint(equalTo: khungDoSoXemSo.trailingAnchor, constant: -8),
            khungThanhMucConDoSo.heightAnchor.constraint(equalToConstant: 0),

            nganNutMucConDoSo.topAnchor.constraint(equalTo: khungThanhMucConDoSo.topAnchor, constant: 4),
            nganNutMucConDoSo.leadingAnchor.constraint(equalTo: khungThanhMucConDoSo.leadingAnchor, constant: 4),
            nganNutMucConDoSo.trailingAnchor.constraint(equalTo: khungThanhMucConDoSo.trailingAnchor, constant: -4),
            nganNutMucConDoSo.bottomAnchor.constraint(equalTo: khungThanhMucConDoSo.bottomAnchor, constant: -4),

            khungXemSo.topAnchor.constraint(equalTo: khungDoSoXemSo.topAnchor),
            khungXemSo.leadingAnchor.constraint(equalTo: khungDoSoXemSo.leadingAnchor),
            khungXemSo.trailingAnchor.constraint(equalTo: khungDoSoXemSo.trailingAnchor),
            khungXemSo.bottomAnchor.constraint(equalTo: khungDoSoXemSo.bottomAnchor),

            khungNhapSo.topAnchor.constraint(equalTo: khungThanhMucConDoSo.bottomAnchor, constant: 4),
            khungNhapSo.leadingAnchor.constraint(equalTo: khungDoSoXemSo.leadingAnchor),
            khungNhapSo.trailingAnchor.constraint(equalTo: khungDoSoXemSo.trailingAnchor),
            khungNhapSo.bottomAnchor.constraint(equalTo: khungDoSoXemSo.bottomAnchor),

            khungXuatAnh.topAnchor.constraint(equalTo: khungThanhMucConDoSo.bottomAnchor, constant: 4),
            khungXuatAnh.leadingAnchor.constraint(equalTo: khungDoSoXemSo.leadingAnchor),
            khungXuatAnh.trailingAnchor.constraint(equalTo: khungDoSoXemSo.trailingAnchor),
            khungXuatAnh.bottomAnchor.constraint(equalTo: khungDoSoXemSo.bottomAnchor),

            khungThanhTabXemSo.topAnchor.constraint(equalTo: khungXemSo.topAnchor, constant: 2),
            khungThanhTabXemSo.leadingAnchor.constraint(equalTo: khungXemSo.leadingAnchor, constant: 8),
            khungThanhTabXemSo.trailingAnchor.constraint(equalTo: khungXemSo.trailingAnchor, constant: -8),
            khungThanhTabXemSo.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),

            nganNutTabXemSo.topAnchor.constraint(equalTo: khungThanhTabXemSo.topAnchor, constant: 3),
            nganNutTabXemSo.leadingAnchor.constraint(equalTo: khungThanhTabXemSo.leadingAnchor, constant: 3),
            nganNutTabXemSo.trailingAnchor.constraint(equalTo: khungThanhTabXemSo.trailingAnchor, constant: -3),
            nganNutTabXemSo.bottomAnchor.constraint(equalTo: khungThanhTabXemSo.bottomAnchor, constant: -3),

            khungCumDoanhThu.topAnchor.constraint(equalTo: khungThanhTabXemSo.bottomAnchor, constant: 6),
            khungCumDoanhThu.leadingAnchor.constraint(equalTo: khungXemSo.leadingAnchor, constant: 8),
            khungCumDoanhThu.trailingAnchor.constraint(equalTo: khungXemSo.trailingAnchor, constant: -8),

            thanhTieuDeDoanhThu.topAnchor.constraint(equalTo: khungCumDoanhThu.topAnchor),
            thanhTieuDeDoanhThu.leadingAnchor.constraint(equalTo: khungCumDoanhThu.leadingAnchor),
            thanhTieuDeDoanhThu.trailingAnchor.constraint(equalTo: khungCumDoanhThu.trailingAnchor),
            thanhTieuDeDoanhThu.heightAnchor.constraint(equalToConstant: 0),

            vachVangDauDT.topAnchor.constraint(equalTo: thanhTieuDeDoanhThu.topAnchor),
            vachVangDauDT.bottomAnchor.constraint(equalTo: thanhTieuDeDoanhThu.bottomAnchor),
            vachVangDauDT.leadingAnchor.constraint(equalTo: thanhTieuDeDoanhThu.leadingAnchor),
            vachVangDauDT.widthAnchor.constraint(equalToConstant: 4),

            nhanTieuDeCumDoanhThu.topAnchor.constraint(equalTo: thanhTieuDeDoanhThu.topAnchor, constant: 5),
            nhanTieuDeCumDoanhThu.bottomAnchor.constraint(equalTo: thanhTieuDeDoanhThu.bottomAnchor, constant: -5),
            nhanTieuDeCumDoanhThu.leadingAnchor.constraint(equalTo: vachVangDauDT.trailingAnchor, constant: 8),
            nhanTieuDeCumDoanhThu.trailingAnchor.constraint(lessThanOrEqualTo: nhanPhuCumDoanhThu.leadingAnchor, constant: -6),

            nhanPhuCumDoanhThu.centerYAnchor.constraint(equalTo: thanhTieuDeDoanhThu.centerYAnchor),
            nhanPhuCumDoanhThu.trailingAnchor.constraint(equalTo: thanhTieuDeDoanhThu.trailingAnchor, constant: -10),

            cumChiSoChinh.topAnchor.constraint(equalTo: thanhTieuDeDoanhThu.bottomAnchor, constant: 7),
            cumChiSoChinh.leadingAnchor.constraint(equalTo: khungCumDoanhThu.leadingAnchor, constant: 7),
            cumChiSoChinh.trailingAnchor.constraint(equalTo: khungCumDoanhThu.trailingAnchor, constant: -7),
            cumChiSoChinh.bottomAnchor.constraint(equalTo: khungCumDoanhThu.bottomAnchor, constant: -7),
            cumChiSoChinh.heightAnchor.constraint(equalToConstant: 108),

            rgTopDuoiTheoVach,
            khungCumDuoi.leadingAnchor.constraint(equalTo: khungXemSo.leadingAnchor, constant: 8),
            khungCumDuoi.trailingAnchor.constraint(equalTo: khungXemSo.trailingAnchor, constant: -8),
            khungCumDuoi.bottomAnchor.constraint(equalTo: khungXemSo.bottomAnchor, constant: -4),

            hangChonCheDoNV.topAnchor.constraint(equalTo: khungCumDuoi.topAnchor, constant: 8),
            hangChonCheDoNV.leadingAnchor.constraint(equalTo: khungCumDuoi.leadingAnchor, constant: 8),
            hangChonCheDoNV.trailingAnchor.constraint(equalTo: khungCumDuoi.trailingAnchor, constant: -8),
            hangChonCheDoNV.heightAnchor.constraint(greaterThanOrEqualToConstant: 34),

            rgTopNutQuetDinh,
            hangNutQuet.leadingAnchor.constraint(equalTo: khungCumDuoi.leadingAnchor, constant: 8),
            hangNutQuet.trailingAnchor.constraint(equalTo: khungCumDuoi.trailingAnchor, constant: -8),
            hangNutQuet.heightAnchor.constraint(greaterThanOrEqualToConstant: 38),

            rgTopBangTD,
            bangThiDua.leadingAnchor.constraint(equalTo: khungCumDuoi.leadingAnchor, constant: 6),
            bangThiDua.trailingAnchor.constraint(equalTo: khungCumDuoi.trailingAnchor, constant: -6),
            bangThiDua.bottomAnchor.constraint(equalTo: khungCumDuoi.bottomAnchor, constant: -6),

            rgTopBangNV,
            bangNhanVien.leadingAnchor.constraint(equalTo: khungCumDuoi.leadingAnchor, constant: 2),
            bangNhanVien.trailingAnchor.constraint(equalTo: khungCumDuoi.trailingAnchor, constant: -2),
            bangNhanVien.bottomAnchor.constraint(equalTo: khungCumDuoi.bottomAnchor, constant: -6),

            bangRealtimeThang.topAnchor.constraint(equalTo: khungCumDuoi.topAnchor, constant: 3),
            bangRealtimeThang.leadingAnchor.constraint(equalTo: khungCumDuoi.leadingAnchor, constant: 6),
            bangRealtimeThang.trailingAnchor.constraint(equalTo: khungCumDuoi.trailingAnchor, constant: -6),
            bangRealtimeThang.bottomAnchor.constraint(equalTo: khungCumDuoi.bottomAnchor, constant: -6),

            khungTonKho.topAnchor.constraint(equalTo: khungCumDuoi.topAnchor, constant: 2),
            khungTonKho.leadingAnchor.constraint(equalTo: khungCumDuoi.leadingAnchor, constant: 2),
            khungTonKho.trailingAnchor.constraint(equalTo: khungCumDuoi.trailingAnchor, constant: -2),
            khungTonKho.bottomAnchor.constraint(equalTo: khungCumDuoi.bottomAnchor, constant: -4)
        ])

        taoKhungTongQuan()
        taoKhungBaoCao()
        taoKhungTaiKhoanHopThu()
        taoKhungQuanTri()
        taoKhungTrinhDuyet()
        taoKhungMucMoRong()
        taoMenuTruotBenTrai()
        taoLopPhuTienTrinh()
        capNhatTrangThaiMuc()
    }

    // MARK: - Mục con 2: Giao diện "2. Nhập số" (Nhập tất cả Lũy kế & Nhập tất cả Realtime + Nhập từng phần)

    private func taoKhungNhapSo() {
        khungNhapSo.backgroundColor = BangMauBCTD.nenTrang
        khungNhapSo.isHidden = true

        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungNhapSo.addSubview(cuon)

        let ngan = UIStackView()
        ngan.axis = .vertical
        ngan.spacing = 12
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: khungNhapSo.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: khungNhapSo.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungNhapSo.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: khungNhapSo.bottomAnchor),

            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 8),
            ngan.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -10),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        // Thẻ trạng thái dữ liệu đã nhập
        let theTrangThai = UIView()
        theTrangThai.backgroundColor = BangMauBCTD.nenThe
        theTrangThai.layer.cornerRadius = 12
        theTrangThai.layer.borderWidth = 1
        theTrangThai.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor

        nhanTrangThaiNhapSo.font = .systemFont(ofSize: 13.0, weight: .semibold)
        nhanTrangThaiNhapSo.textColor = BangMauBCTD.chuChinh
        nhanTrangThaiNhapSo.numberOfLines = 0
        nhanTrangThaiNhapSo.lineBreakMode = .byWordWrapping
        nhanTrangThaiNhapSo.adjustsFontSizeToFitWidth = false
        nhanTrangThaiNhapSo.translatesAutoresizingMaskIntoConstraints = false
        theTrangThai.addSubview(nhanTrangThaiNhapSo)

        NSLayoutConstraint.activate([
            nhanTrangThaiNhapSo.topAnchor.constraint(equalTo: theTrangThai.topAnchor, constant: 12),
            nhanTrangThaiNhapSo.leadingAnchor.constraint(equalTo: theTrangThai.leadingAnchor, constant: 12),
            nhanTrangThaiNhapSo.trailingAnchor.constraint(equalTo: theTrangThai.trailingAnchor, constant: -12),
            nhanTrangThaiNhapSo.bottomAnchor.constraint(equalTo: theTrangThai.bottomAnchor, constant: -12)
        ])
        ngan.addArrangedSubview(theTrangThai)

        // 2 Nút lớn: NHẬP TẤT CẢ LŨY KẾ & NHẬP TẤT CẢ REALTIME
        let nutNhapAllLK = taoNutLonNhapSo(
            tieuDe: "📥 NHẬP TẤT CẢ LŨY KẾ (Chọn nhiều ảnh 1 lần)",
            moTa: "Tự động đọc & phân loại: Doanh thu Lũy kế + Thi đua ngành hàng Lũy kế + 3 ảnh Ma trận Thi đua Nhân viên Lũy kế (+ Sức khỏe NV)",
            mauNen: BangMauBCTD.xanhChuDao,
            mauChu: .white,
            action: #selector(bamNhapTatCaLuyKe)
        )
        let nutNhapAllRT = taoNutLonNhapSo(
            tieuDe: "⚡ NHẬP TẤT CẢ REALTIME (Chọn nhiều ảnh 1 lần)",
            moTa: "Tự động đọc & phân loại: Doanh thu Realtime + Thi đua ngành hàng Realtime + Bảng Doanh thu NV Realtime",
            mauNen: BangMauBCTD.xanhDatVach,
            mauChu: .white,
            action: #selector(bamNhapTatCaRealtime)
        )
        ngan.addArrangedSubview(nutNhapAllLK)
        ngan.addArrangedSubview(nutNhapAllRT)

        // Khung nhập từng phần Lũy kế
        let theLK = taoKhungNhapTungPhan(
            tieuDe: "📊 NHẬP / SỬA TỪNG PHẦN — LŨY KẾ THÁNG",
            cacNut: [
                ("📷 Quét 2 ảnh Doanh thu Lũy kế (Thực + QĐ)", #selector(bamQuetDoanhThuLK)),
                ("✏️ Nhập / Sửa tay số liệu Doanh thu Lũy kế", #selector(bamSuaTayDoanhThuLK)),
                ("📋 Quét ảnh Bảng Thi đua Ngành hàng Lũy kế", #selector(bamQuetThiDuaLK)),
                ("📁 Nhập ảnh Thi đua Lũy kế từ Tệp (Files)", #selector(bamNhapTepThiDuaLK)),
                ("💰 Quét ảnh Bảng Doanh thu Nhân viên Lũy kế", #selector(bamQuetDoanhThuNVLK)),
                ("⏱️ Quét ảnh Bảng Giờ công Nhân viên Lũy kế", #selector(bamQuetGioCongNVLK)),
                ("👥 Quét ảnh Bảng Thi đua Nhân viên Lũy kế", #selector(bamQuetThiDuaNVLK)),
                ("📁 Nhập ảnh Thi đua Nhân viên Lũy kế từ Tệp (Files)", #selector(bamNhapTepThiDuaNVLK))
            ]
        )
        ngan.addArrangedSubview(theLK)

        // Khung nhập từng phần Realtime (Realtime nhân viên chỉ có Doanh thu, không có Thi đua)
        let theRT = taoKhungNhapTungPhan(
            tieuDe: "⚡ NHẬP / SỬA TỪNG PHẦN — REALTIME HÔM NAY",
            cacNut: [
                ("📷 Quét 2 ảnh Doanh thu Realtime (Thực + QĐ)", #selector(bamQuetDoanhThuRT)),
                ("✏️ Nhập / Sửa tay số liệu Doanh thu Realtime", #selector(bamSuaTayDoanhThuRT)),
                ("📋 Quét ảnh Bảng Thi đua Ngành hàng Realtime", #selector(bamQuetThiDuaRT)),
                ("👥 Quét ảnh Bảng Doanh thu Nhân viên Realtime", #selector(bamQuetDoanhThuNVRT))
            ]
        )
        ngan.addArrangedSubview(theRT)
    }

    private func taoNutLonNhapSo(
        tieuDe: String,
        moTa: String,
        mauNen: UIColor,
        mauChu: UIColor,
        action: Selector
    ) -> UIControl {
        let the = UIControl()
        the.backgroundColor = mauNen
        the.layer.cornerRadius = 14
        the.addTarget(self, action: action, for: .touchUpInside)

        let lbTieuDe = UILabel()
        lbTieuDe.text = tieuDe
        lbTieuDe.font = .systemFont(ofSize: 15.5, weight: .heavy)
        lbTieuDe.textColor = mauChu
        lbTieuDe.numberOfLines = 0
        lbTieuDe.lineBreakMode = .byWordWrapping
        lbTieuDe.adjustsFontSizeToFitWidth = false
        lbTieuDe.isUserInteractionEnabled = false

        let lbMoTa = UILabel()
        lbMoTa.text = moTa
        lbMoTa.font = .systemFont(ofSize: 12.5, weight: .medium)
        lbMoTa.textColor = mauChu.withAlphaComponent(0.92)
        lbMoTa.numberOfLines = 0
        lbMoTa.lineBreakMode = .byWordWrapping
        lbMoTa.adjustsFontSizeToFitWidth = false
        lbMoTa.isUserInteractionEnabled = false

        let ngan = UIStackView(arrangedSubviews: [lbTieuDe, lbMoTa])
        ngan.axis = .vertical
        ngan.spacing = 4
        ngan.isUserInteractionEnabled = false
        ngan.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: the.topAnchor, constant: 14),
            ngan.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 14),
            ngan.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -14),
            ngan.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -14)
        ])
        return the
    }

    private func taoKhungNhapTungPhan(tieuDe: String, cacNut: [(String, Selector)]) -> UIView {
        let khung = UIView()
        khung.backgroundColor = BangMauBCTD.nenThe
        khung.layer.cornerRadius = 12
        khung.layer.borderWidth = 1
        khung.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let lb = UILabel()
        lb.text = tieuDe
        lb.font = .systemFont(ofSize: 12.5, weight: .heavy)
        lb.textColor = BangMauBCTD.xanhChuDaoDam
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.adjustsFontSizeToFitWidth = false

        let ngan = UIStackView(arrangedSubviews: [lb])
        ngan.axis = .vertical
        ngan.spacing = 8
        ngan.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(ngan)

        for (ten, sel) in cacNut {
            let nut = UIButton(type: .system)
            nut.setTitle(ten + " ▸", for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .bold)
            nut.titleLabel?.numberOfLines = 1
            nut.titleLabel?.lineBreakMode = .byTruncatingTail
            nut.titleLabel?.textAlignment = .left
            nut.titleLabel?.adjustsFontSizeToFitWidth = true
            nut.titleLabel?.minimumScaleFactor = 0.75
            nut.contentHorizontalAlignment = .left
            nut.backgroundColor = BangMauBCTD.nenHeaderPhu
            nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
            nut.layer.cornerRadius = 9
            nut.layer.borderWidth = 1
            nut.layer.borderColor = BangMauBCTD.vienThe.cgColor
            nut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
            nut.addTarget(self, action: sel, for: .touchUpInside)
            ngan.addArrangedSubview(nut)
        }

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: khung.topAnchor, constant: 12),
            ngan.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 12),
            ngan.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),
            ngan.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -12)
        ])
        return khung
    }

    @objc private func bamNhapTatCaLuyKe() {
        cheDoDoanhThu = .luyKe
        moChonAnh(cheDo: .tatCaAnhTheoTab(.luyKe), gioiHan: 0)
    }

    @objc private func bamNhapTatCaRealtime() {
        cheDoDoanhThu = .realtime
        moChonAnh(cheDo: .tatCaAnhTheoTab(.realtime), gioiHan: 0)
    }

    @objc private func bamQuetDoanhThuLK() {
        cheDoDoanhThu = .luyKe
        moChonAnh(cheDo: .doanhThu(.luyKe), gioiHan: 2)
    }

    @objc private func bamSuaTayDoanhThuLK() {
        cheDoDoanhThu = .luyKe
        moHopThoaiNhapDoanhThu()
    }

    @objc private func bamQuetThiDuaLK() {
        cheDoDoanhThu = .luyKe
        moHuongDanQuetAnhThiDua(cheDo: .luyKe)
    }

    @objc private func bamNhapTepThiDuaLK() {
        cheDoDoanhThu = .luyKe
        thayTheBangThiDuaKhiQuet = false
        moChonTepAnh(cheDo: .thiDua(.luyKe), gioiHan: 0)
    }

    @objc private func bamQuetDoanhThuNVLK() {
        cheDoDoanhThu = .luyKe
        moChonAnh(cheDo: .doanhThuNhanVien(.luyKe), gioiHan: 0)
    }

    @objc private func bamQuetGioCongNVLK() {
        cheDoDoanhThu = .luyKe
        moChonAnh(cheDo: .gioCongNhanVien(.luyKe), gioiHan: 0)
    }

    @objc private func bamQuetThiDuaNVLK() {
        cheDoDoanhThu = .luyKe
        moChonAnh(cheDo: .thiDuaNhanVien(.luyKe), gioiHan: 0)
    }

    @objc private func bamNhapTepThiDuaNVLK() {
        cheDoDoanhThu = .luyKe
        moChonTepAnh(cheDo: .thiDuaNhanVien(.luyKe), gioiHan: 0)
    }

    @objc private func bamQuetDoanhThuRT() {
        cheDoDoanhThu = .realtime
        moChonAnh(cheDo: .doanhThu(.realtime), gioiHan: 2)
    }

    @objc private func bamSuaTayDoanhThuRT() {
        cheDoDoanhThu = .realtime
        moHopThoaiNhapDoanhThu()
    }

    @objc private func bamQuetThiDuaRT() {
        cheDoDoanhThu = .realtime
        moHuongDanQuetAnhThiDua(cheDo: .realtime)
    }

    @objc private func bamQuetDoanhThuNVRT() {
        cheDoDoanhThu = .realtime
        moChonAnh(cheDo: .doanhThuNhanVien(.realtime), gioiHan: 0)
    }

    @objc private func bamQuetThiDuaNVRT() {
        cheDoDoanhThu = .realtime
        moChonAnh(cheDo: .thiDuaNhanVien(.realtime), gioiHan: 0)
    }

    // MARK: - Mục con 3: Giao diện "3. Xuất ảnh" (Chọn loại ảnh -> Ô Text báo cáo -> Nút Xuất ảnh thật & Copy gửi LINE + Excel/PowerPoint)

    private func taoKhungXuatAnh() {
        khungXuatAnh.backgroundColor = BangMauBCTD.nenTrang
        khungXuatAnh.isHidden = true

        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.keyboardDismissMode = .interactive
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungXuatAnh.addSubview(cuon)

        let ngan = UIStackView()
        ngan.axis = .vertical
        ngan.spacing = 12
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: khungXuatAnh.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: khungXuatAnh.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungXuatAnh.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: khungXuatAnh.bottomAnchor),

            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 8),
            ngan.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -10),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -28)
        ])

        // BƯỚC 1: Chọn tùy chọn xuất ảnh gì
        let theChonLoai = UIView()
        theChonLoai.backgroundColor = BangMauBCTD.nenThe
        theChonLoai.layer.cornerRadius = 14
        theChonLoai.layer.borderWidth = 1
        theChonLoai.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let lbBuoc1 = UILabel()
        lbBuoc1.text = "BƯỚC 1 · CHỌN LOẠI BÁO CÁO MUỐN XUẤT ẢNH (Ấn chọn để tạo nội dung chữ bên dưới)"
        lbBuoc1.font = .systemFont(ofSize: 12.5, weight: .heavy)
        lbBuoc1.textColor = BangMauBCTD.mauChuTieuDePhanTich
        lbBuoc1.numberOfLines = 0
        lbBuoc1.lineBreakMode = .byWordWrapping
        lbBuoc1.adjustsFontSizeToFitWidth = false

        let nganLuoiLoai = UIStackView()
        nganLuoiLoai.axis = .vertical
        nganLuoiLoai.spacing = 8
        nganLuoiLoai.translatesAutoresizingMaskIntoConstraints = false
        theChonLoai.addSubview(nganLuoiLoai)

        cacNutLoaiXuatAnh.removeAll()
        let tatCaLoai = LoaiBaoCaoXuatAnh.allCases
        for loai in tatCaLoai {
            let nut = UIButton(type: .custom)
            nut.tag = loai.rawValue
            nut.setTitle(loai.tieuDeNgan, for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .bold)
            nut.titleLabel?.numberOfLines = 1
            nut.titleLabel?.lineBreakMode = .byTruncatingTail
            nut.titleLabel?.textAlignment = .left
            nut.titleLabel?.adjustsFontSizeToFitWidth = true
            nut.titleLabel?.minimumScaleFactor = 0.75
            nut.contentHorizontalAlignment = .left
            nut.layer.cornerRadius = 10
            nut.layer.borderWidth = 1.2
            nut.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
            nut.addTarget(self, action: #selector(bamChonLoaiBaoCaoXuatAnh(_:)), for: .touchUpInside)
            cacNutLoaiXuatAnh.append(nut)
            nganLuoiLoai.addArrangedSubview(nut)
        }

        NSLayoutConstraint.activate([
            nganLuoiLoai.topAnchor.constraint(equalTo: theChonLoai.topAnchor, constant: 12),
            nganLuoiLoai.leadingAnchor.constraint(equalTo: theChonLoai.leadingAnchor, constant: 12),
            nganLuoiLoai.trailingAnchor.constraint(equalTo: theChonLoai.trailingAnchor, constant: -12),
            nganLuoiLoai.bottomAnchor.constraint(equalTo: theChonLoai.bottomAnchor, constant: -12)
        ])
        ngan.addArrangedSubview(theChonLoai)

        // BƯỚC 2: Ô Text chứa nội dung báo cáo về phần đó (sửa được + có AI Gemini)
        let theVanBan = UIView()
        theVanBan.backgroundColor = BangMauBCTD.nenThe
        theVanBan.layer.cornerRadius = 14
        theVanBan.layer.borderWidth = 1
        theVanBan.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let lbBuoc2 = UILabel()
        lbBuoc2.text = "BƯỚC 2 · NỘI DUNG BÁO CÁO (Tự động Copy khi bấm Xuất ảnh thật)"
        lbBuoc2.font = .systemFont(ofSize: 12.5, weight: .heavy)
        lbBuoc2.textColor = BangMauBCTD.mauChuTieuDePhanTich
        lbBuoc2.numberOfLines = 0
        lbBuoc2.lineBreakMode = .byWordWrapping
        lbBuoc2.adjustsFontSizeToFitWidth = false

        nutAIGeminiXuatAnh.setTitle("✨ AI Gemini viết", for: .normal)
        nutAIGeminiXuatAnh.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutAIGeminiXuatAnh.titleLabel?.numberOfLines = 0
        nutAIGeminiXuatAnh.titleLabel?.lineBreakMode = .byWordWrapping
        nutAIGeminiXuatAnh.titleLabel?.adjustsFontSizeToFitWidth = false
        nutAIGeminiXuatAnh.backgroundColor = BangMauBCTD.nenHeaderBang
        nutAIGeminiXuatAnh.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutAIGeminiXuatAnh.layer.cornerRadius = 8
        nutAIGeminiXuatAnh.layer.borderWidth = 1
        nutAIGeminiXuatAnh.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor
        nutAIGeminiXuatAnh.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutAIGeminiXuatAnh.setContentHuggingPriority(.required, for: .horizontal)
        nutAIGeminiXuatAnh.addTarget(self, action: #selector(bamAIGeminiTrongXuatAnh), for: .touchUpInside)

        let nutTaoLaiMau = UIButton(type: .system)
        nutTaoLaiMau.setTitle("🔄 Tạo lại", for: .normal)
        nutTaoLaiMau.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .semibold)
        nutTaoLaiMau.titleLabel?.numberOfLines = 0
        nutTaoLaiMau.titleLabel?.lineBreakMode = .byWordWrapping
        nutTaoLaiMau.titleLabel?.adjustsFontSizeToFitWidth = false
        nutTaoLaiMau.backgroundColor = BangMauBCTD.nenThePhu
        nutTaoLaiMau.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutTaoLaiMau.layer.cornerRadius = 8
        nutTaoLaiMau.layer.borderWidth = 1
        nutTaoLaiMau.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutTaoLaiMau.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutTaoLaiMau.setContentHuggingPriority(.required, for: .horizontal)
        nutTaoLaiMau.addTarget(self, action: #selector(bamTaoLaiMauXuatAnh), for: .touchUpInside)

        let hangTrenVB = UIStackView(arrangedSubviews: [lbBuoc2, nutAIGeminiXuatAnh, nutTaoLaiMau])
        hangTrenVB.axis = .horizontal
        hangTrenVB.spacing = 6
        hangTrenVB.alignment = .center

        // Hàng chọn giọng văn trong Xuất ảnh
        let hangGiongXA = UIStackView()
        hangGiongXA.axis = .horizontal
        hangGiongXA.spacing = 6
        hangGiongXA.distribution = .fillEqually
        cacNutGiongXuatAnh.removeAll()
        for giong in GiongVanBanTin.allCases {
            let nut = UIButton(type: .custom)
            nut.tag = giong.rawValue
            nut.setTitle("Giọng: \(giong.tieuDe)", for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.titleLabel?.lineBreakMode = .byWordWrapping
            nut.titleLabel?.textAlignment = .center
            nut.titleLabel?.adjustsFontSizeToFitWidth = false
            nut.layer.cornerRadius = 8
            nut.layer.borderWidth = 1
            nut.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            nut.addTarget(self, action: #selector(bamDoiGiongTrongXuatAnh(_:)), for: .touchUpInside)
            cacNutGiongXuatAnh.append(nut)
            hangGiongXA.addArrangedSubview(nut)
        }

        oVanBanXuatAnh.font = .systemFont(ofSize: 14.5, weight: .regular)
        oVanBanXuatAnh.textColor = BangMauBCTD.chuChinh
        oVanBanXuatAnh.backgroundColor = BangMauBCTD.nenThePhu
        oVanBanXuatAnh.layer.cornerRadius = 10
        oVanBanXuatAnh.layer.borderWidth = 1
        oVanBanXuatAnh.layer.borderColor = BangMauBCTD.vienDam.cgColor
        oVanBanXuatAnh.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        oVanBanXuatAnh.isScrollEnabled = false
        oVanBanXuatAnh.delegate = self
        oVanBanXuatAnh.translatesAutoresizingMaskIntoConstraints = false
        oVanBanXuatAnh.heightAnchor.constraint(greaterThanOrEqualToConstant: 210).isActive = true

        nhanTrangThaiXuatAnh.text = "💡 Khi ấn nút \"XUẤT ẢNH THẬT & COPY NỘI DUNG GỬI LINE\" bên dưới, ứng dụng sẽ tự động Copy nội dung ô chữ này và mở hộp thoại chia sẻ ảnh qua LINE."
        nhanTrangThaiXuatAnh.font = .systemFont(ofSize: 12.5, weight: .medium)
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.chuPhu
        nhanTrangThaiXuatAnh.numberOfLines = 0
        nhanTrangThaiXuatAnh.lineBreakMode = .byWordWrapping
        nhanTrangThaiXuatAnh.adjustsFontSizeToFitWidth = false

        // BƯỚC 3: Nút Xuất ảnh thật + Copy gửi LINE & Nút xuất Excel (.xlsx) / PowerPoint (.pptx)
        let nutXuatAnhThat = UIButton(type: .system)
        nutXuatAnhThat.setTitle("📤 XUẤT ẢNH THẬT & COPY NỘI DUNG GỬI LINE", for: .normal)
        nutXuatAnhThat.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .heavy)
        nutXuatAnhThat.titleLabel?.numberOfLines = 0
        nutXuatAnhThat.titleLabel?.lineBreakMode = .byWordWrapping
        nutXuatAnhThat.titleLabel?.textAlignment = .center
        nutXuatAnhThat.titleLabel?.adjustsFontSizeToFitWidth = false
        nutXuatAnhThat.backgroundColor = BangMauBCTD.xanhDatVach
        nutXuatAnhThat.setTitleColor(.white, for: .normal)
        nutXuatAnhThat.layer.cornerRadius = 12
        nutXuatAnhThat.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        nutXuatAnhThat.addTarget(self, action: #selector(bamXuatAnhThatVaCopyLine), for: .touchUpInside)

        let nutCopyRieng = UIButton(type: .system)
        nutCopyRieng.setTitle("📋 Chỉ Copy nội dung trong ô Text", for: .normal)
        nutCopyRieng.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .bold)
        nutCopyRieng.titleLabel?.numberOfLines = 0
        nutCopyRieng.titleLabel?.lineBreakMode = .byWordWrapping
        nutCopyRieng.titleLabel?.textAlignment = .center
        nutCopyRieng.titleLabel?.adjustsFontSizeToFitWidth = false
        nutCopyRieng.backgroundColor = BangMauBCTD.nenHeaderPhu
        nutCopyRieng.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutCopyRieng.layer.cornerRadius = 10
        nutCopyRieng.layer.borderWidth = 1
        nutCopyRieng.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor
        nutCopyRieng.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        nutCopyRieng.addTarget(self, action: #selector(bamChiCopyNoiDungXuatAnh), for: .touchUpInside)

        nutCopyJSONXuatAnh.setTitle("📋 Copy JSON + câu lệnh tạo Excel / PowerPoint bằng AI khác", for: .normal)
        nutCopyJSONXuatAnh.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .bold)
        nutCopyJSONXuatAnh.titleLabel?.numberOfLines = 0
        nutCopyJSONXuatAnh.titleLabel?.lineBreakMode = .byWordWrapping
        nutCopyJSONXuatAnh.titleLabel?.textAlignment = .center
        nutCopyJSONXuatAnh.backgroundColor = BangMauBCTD.xanhLaDam
        nutCopyJSONXuatAnh.setTitleColor(.white, for: .normal)
        nutCopyJSONXuatAnh.layer.cornerRadius = 10
        nutCopyJSONXuatAnh.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        nutCopyJSONXuatAnh.addTarget(self, action: #selector(bamCopyJSONTuMucXuatAnh), for: .touchUpInside)

        let nutXuatTatCaLenServer = UIButton(type: .system)
        nutXuatTatCaLenServer.setTitle("☁️ TẢI ẢNH BÁO CÁO CHUNG LÊN KHO ĐÃ CHỌN", for: .normal)
        nutXuatTatCaLenServer.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .heavy)
        nutXuatTatCaLenServer.titleLabel?.numberOfLines = 0
        nutXuatTatCaLenServer.titleLabel?.lineBreakMode = .byWordWrapping
        nutXuatTatCaLenServer.titleLabel?.textAlignment = .center
        nutXuatTatCaLenServer.titleLabel?.adjustsFontSizeToFitWidth = false
        nutXuatTatCaLenServer.backgroundColor = BangMauBCTD.xanhChuDao
        nutXuatTatCaLenServer.setTitleColor(.white, for: .normal)
        nutXuatTatCaLenServer.layer.cornerRadius = 12
        nutXuatTatCaLenServer.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        nutXuatTatCaLenServer.addTarget(self, action: #selector(bamXuatTatCaAnhLenServerSupabase), for: .touchUpInside)

        let nutXuatTatCaSucKhoeNV = UIButton(type: .system)
        nutXuatTatCaSucKhoeNV.setTitle("❤️‍🩹 TẢI RIÊNG ẢNH TỪNG NHÂN VIÊN LÊN KHO", for: .normal)
        nutXuatTatCaSucKhoeNV.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .heavy)
        nutXuatTatCaSucKhoeNV.titleLabel?.numberOfLines = 0
        nutXuatTatCaSucKhoeNV.titleLabel?.lineBreakMode = .byWordWrapping
        nutXuatTatCaSucKhoeNV.titleLabel?.textAlignment = .center
        nutXuatTatCaSucKhoeNV.backgroundColor = UIColor(red: 0.05, green: 0.52, blue: 0.36, alpha: 1)
        nutXuatTatCaSucKhoeNV.setTitleColor(.white, for: .normal)
        nutXuatTatCaSucKhoeNV.layer.cornerRadius = 12
        nutXuatTatCaSucKhoeNV.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        nutXuatTatCaSucKhoeNV.addTarget(self, action: #selector(bamTaiRiengAnhNhanVienLenServer), for: .touchUpInside)

        let nganVB = UIStackView(arrangedSubviews: [nutXuatAnhThat, nutXuatTatCaLenServer, nutXuatTatCaSucKhoeNV])
        nganVB.axis = .vertical
        nganVB.spacing = 10
        nganVB.translatesAutoresizingMaskIntoConstraints = false
        theVanBan.addSubview(nganVB)

        NSLayoutConstraint.activate([
            nganVB.topAnchor.constraint(equalTo: theVanBan.topAnchor, constant: 12),
            nganVB.leadingAnchor.constraint(equalTo: theVanBan.leadingAnchor, constant: 12),
            nganVB.trailingAnchor.constraint(equalTo: theVanBan.trailingAnchor, constant: -12),
            nganVB.bottomAnchor.constraint(equalTo: theVanBan.bottomAnchor, constant: -12)
        ])
        ngan.addArrangedSubview(theVanBan)
    }

    private func capNhatGiaoDienKhungXuatAnh(taoMoiVanBan: Bool) {
        for nut in cacNutLoaiXuatAnh {
            let dangChon = (nut.tag == loaiXuatAnhDangChon.rawValue)
            if dangChon {
                nut.backgroundColor = BangMauBCTD.vangSang
                nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
            } else {
                nut.backgroundColor = BangMauBCTD.nenHeaderPhu
                nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vienThe.cgColor
            }
        }

        for nut in cacNutGiongXuatAnh {
            let dangChon = (nut.tag == giongXuatAnhDangChon.rawValue)
            if dangChon {
                nut.backgroundColor = BangMauBCTD.vangSang
                nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
            } else {
                nut.backgroundColor = BangMauBCTD.nenThePhu
                nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            }
        }

        let ycLuu = DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai
        if (oYeuCauRiengXuatAnh.text ?? "") != ycLuu {
            oYeuCauRiengXuatAnh.text = ycLuu
            capNhatPlaceholderYeuCauXuatAnh()
        }

        if taoMoiVanBan || (oVanBanXuatAnh.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let noiDung = BoVietBanTin.taoNoiDungBaoCao(
                loai: loaiXuatAnhDangChon,
                ngay: ngayHienTai,
                giong: giongXuatAnhDangChon
            )
            oVanBanXuatAnh.attributedText = ManHinhBanTin.dinhDangVanBanCoInDam(noiDung)
            oVanBanXuatAnh.invalidateIntrinsicContentSize()
        }
    }

    private func taoKhungYeuCauTrongXuatAnh() -> UIView {
        let hop = UIView()
        hop.backgroundColor = BangMauBCTD.nenHeaderBang
        hop.layer.cornerRadius = 12
        hop.layer.borderWidth = 1.2
        hop.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor

        let lbTieuDe = UILabel()
        lbTieuDe.text = "💬 YÊU CẦU RIÊNG CỦA NGƯỜI DÙNG KHI XUẤT BÁO CÁO / EXCEL / POWERPOINT"
        lbTieuDe.font = .systemFont(ofSize: 12.0, weight: .heavy)
        lbTieuDe.textColor = BangMauBCTD.xanhChuDaoDam
        lbTieuDe.numberOfLines = 0
        lbTieuDe.lineBreakMode = .byWordWrapping
        lbTieuDe.adjustsFontSizeToFitWidth = false

        let nutXoaYC = UIButton(type: .system)
        nutXoaYC.setTitle("Xoá", for: .normal)
        nutXoaYC.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutXoaYC.titleLabel?.numberOfLines = 0
        nutXoaYC.titleLabel?.lineBreakMode = .byWordWrapping
        nutXoaYC.titleLabel?.adjustsFontSizeToFitWidth = false
        nutXoaYC.setTitleColor(BangMauBCTD.doYeuChu, for: .normal)
        nutXoaYC.setContentHuggingPriority(.required, for: .horizontal)
        nutXoaYC.addTarget(self, action: #selector(bamXoaYeuCauTrongXuatAnh), for: .touchUpInside)

        let hangTren = UIStackView(arrangedSubviews: [lbTieuDe, nutXoaYC])
        hangTren.axis = .horizontal
        hangTren.spacing = 6
        hangTren.alignment = .center

        oYeuCauRiengXuatAnh.font = .systemFont(ofSize: 13.5, weight: .medium)
        oYeuCauRiengXuatAnh.textColor = BangMauBCTD.chuChinh
        oYeuCauRiengXuatAnh.backgroundColor = BangMauBCTD.nenThe
        oYeuCauRiengXuatAnh.layer.cornerRadius = 9
        oYeuCauRiengXuatAnh.layer.borderWidth = 1
        oYeuCauRiengXuatAnh.layer.borderColor = BangMauBCTD.vienDam.cgColor
        oYeuCauRiengXuatAnh.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        oYeuCauRiengXuatAnh.isScrollEnabled = false
        oYeuCauRiengXuatAnh.delegate = self
        oYeuCauRiengXuatAnh.text = DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai
        oYeuCauRiengXuatAnh.translatesAutoresizingMaskIntoConstraints = false
        oYeuCauRiengXuatAnh.heightAnchor.constraint(greaterThanOrEqualToConstant: 62).isActive = true

        nhanGoiYYeuCauXuatAnh.text = "Nhập yêu cầu riêng (VD: Soi sâu các ngành dưới 80%, chia chỉ tiêu ngày còn lại và giao từng NV kèm cặp Top 5 yếu...)"
        nhanGoiYYeuCauXuatAnh.font = .italicSystemFont(ofSize: 12.5)
        nhanGoiYYeuCauXuatAnh.textColor = BangMauBCTD.chuPhu
        nhanGoiYYeuCauXuatAnh.numberOfLines = 0
        nhanGoiYYeuCauXuatAnh.lineBreakMode = .byWordWrapping
        nhanGoiYYeuCauXuatAnh.adjustsFontSizeToFitWidth = false
        nhanGoiYYeuCauXuatAnh.translatesAutoresizingMaskIntoConstraints = false
        oYeuCauRiengXuatAnh.addSubview(nhanGoiYYeuCauXuatAnh)

        NSLayoutConstraint.activate([
            nhanGoiYYeuCauXuatAnh.topAnchor.constraint(equalTo: oYeuCauRiengXuatAnh.topAnchor, constant: 8),
            nhanGoiYYeuCauXuatAnh.leadingAnchor.constraint(equalTo: oYeuCauRiengXuatAnh.leadingAnchor, constant: 12),
            nhanGoiYYeuCauXuatAnh.trailingAnchor.constraint(equalTo: oYeuCauRiengXuatAnh.frameLayoutGuide.trailingAnchor, constant: -12)
        ])
        capNhatPlaceholderYeuCauXuatAnh()

        let nganGoiY = UIStackView()
        nganGoiY.axis = .vertical
        nganGoiY.spacing = 6
        let dsGoiY = DichVuGeminiAI.cacGoiYYeuCauNhanh
        var hangGY: UIStackView?
        for (idx, item) in dsGoiY.enumerated() {
            if idx % 2 == 0 {
                let h = UIStackView()
                h.axis = .horizontal
                h.spacing = 6
                h.distribution = .fillEqually
                nganGoiY.addArrangedSubview(h)
                hangGY = h
            }
            let nut = UIButton(type: .system)
            nut.tag = idx
            nut.setTitle(item.nhan, for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .semibold)
            nut.titleLabel?.numberOfLines = 0
            nut.titleLabel?.lineBreakMode = .byWordWrapping
            nut.titleLabel?.textAlignment = .center
            nut.titleLabel?.adjustsFontSizeToFitWidth = false
            nut.backgroundColor = BangMauBCTD.nenThe
            nut.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
            nut.layer.cornerRadius = 8
            nut.layer.borderWidth = 1
            nut.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor
            nut.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            nut.addTarget(self, action: #selector(bamChonGoiYTrongXuatAnh(_:)), for: .touchUpInside)
            hangGY?.addArrangedSubview(nut)
        }

        let nganHop = UIStackView(arrangedSubviews: [hangTren, oYeuCauRiengXuatAnh, nganGoiY])
        nganHop.axis = .vertical
        nganHop.spacing = 6
        nganHop.translatesAutoresizingMaskIntoConstraints = false
        hop.addSubview(nganHop)

        NSLayoutConstraint.activate([
            nganHop.topAnchor.constraint(equalTo: hop.topAnchor, constant: 10),
            nganHop.leadingAnchor.constraint(equalTo: hop.leadingAnchor, constant: 10),
            nganHop.trailingAnchor.constraint(equalTo: hop.trailingAnchor, constant: -10),
            nganHop.bottomAnchor.constraint(equalTo: hop.bottomAnchor, constant: -10)
        ])
        return hop
    }

    private func capNhatPlaceholderYeuCauXuatAnh() {
        let trong = (oYeuCauRiengXuatAnh.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        nhanGoiYYeuCauXuatAnh.isHidden = !trong
    }

    @objc private func bamXoaYeuCauTrongXuatAnh() {
        oYeuCauRiengXuatAnh.text = ""
        DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai = ""
        capNhatPlaceholderYeuCauXuatAnh()
        oYeuCauRiengXuatAnh.invalidateIntrinsicContentSize()
    }

    @objc private func bamChonGoiYTrongXuatAnh(_ sender: UIButton) {
        let ds = DichVuGeminiAI.cacGoiYYeuCauNhanh
        guard sender.tag >= 0 && sender.tag < ds.count else { return }
        let noiDung = ds[sender.tag].noiDung
        oYeuCauRiengXuatAnh.text = noiDung
        DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai = noiDung
        capNhatPlaceholderYeuCauXuatAnh()
        oYeuCauRiengXuatAnh.invalidateIntrinsicContentSize()
        nhanTrangThaiXuatAnh.text = "💬 Đã chọn yêu cầu: \"\(ds[sender.tag].nhan)\" · Có thể dùng Gemini viết báo cáo hoặc copy gói JSON bên dưới!"
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhChuDaoDam
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView === oYeuCauRiengXuatAnh {
            capNhatPlaceholderYeuCauXuatAnh()
            DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai = textView.text ?? ""
            oYeuCauRiengXuatAnh.invalidateIntrinsicContentSize()
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        guard textView === oCauLenhXuatFile, textView.isFirstResponder,
              let viTri = textView.selectedTextRange?.end else { return }
        let khungConTro = textView.caretRect(for: viTri).insetBy(dx: 0, dy: -12)
        cuonMucMoRong.scrollRectToVisible(textView.convert(khungConTro, to: cuonMucMoRong), animated: false)
    }

    @objc private func bamChonLoaiBaoCaoXuatAnh(_ sender: UIButton) {
        guard let loai = LoaiBaoCaoXuatAnh(rawValue: sender.tag) else { return }
        loaiXuatAnhDangChon = loai
        capNhatGiaoDienKhungXuatAnh(taoMoiVanBan: true)
        nhanTrangThaiXuatAnh.text = "✅ Đã nạp nội dung báo cáo cho phần \"\(loai.tieuDeNgan)\". Bạn có thể sửa chữ rồi bấm nút XUẤT ẢNH THẬT bên dưới."
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhChuDaoDam
    }

    @objc private func bamDoiGiongTrongXuatAnh(_ sender: UIButton) {
        guard let giong = GiongVanBanTin(rawValue: sender.tag) else { return }
        giongXuatAnhDangChon = giong
        capNhatGiaoDienKhungXuatAnh(taoMoiVanBan: true)
    }

    @objc private func bamTaoLaiMauXuatAnh() {
        view.endEditing(true)
        capNhatGiaoDienKhungXuatAnh(taoMoiVanBan: true)
    }

    @objc private func bamAIGeminiTrongXuatAnh() {
        view.endEditing(true)
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngayHienTai, khung: KhungBanTin.theoGio())
        let yc = (oYeuCauRiengXuatAnh.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai = yc

        nutAIGeminiXuatAnh.isEnabled = false
        nutAIGeminiXuatAnh.setTitle("⏳ Đang viết...", for: .normal)
        nhanTrangThaiXuatAnh.text = "🤖 Đang kết nối Google Gemini (\(DichVuGeminiAI.dungChung.modelHienTai)) để phân tích phần \"\(loaiXuatAnhDangChon.tieuDeNgan)\"\(yc.isEmpty ? "" : " theo yêu cầu riêng")..."
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhChuDao

        DichVuGeminiAI.dungChung.phanTichBaoCao(
            soLieu: s,
            giong: giongXuatAnhDangChon,
            loaiBaoCao: loaiXuatAnhDangChon,
            yeuCauRieng: yc
        ) { [weak self] kq in
            guard let self = self else { return }
            self.nutAIGeminiXuatAnh.isEnabled = true
            self.nutAIGeminiXuatAnh.setTitle("✨ AI Gemini viết", for: .normal)
            switch kq {
            case .success(let baiAI):
                self.oVanBanXuatAnh.attributedText = ManHinhBanTin.dinhDangVanBanCoInDam(baiAI)
                self.oVanBanXuatAnh.invalidateIntrinsicContentSize()
                self.nhanTrangThaiXuatAnh.text = "✨ Đã tạo nội dung bằng Google Gemini AI (\(DichVuGeminiAI.dungChung.modelHienTai))! Ấn nút XUẤT ẢNH THẬT bên dưới để lưu/chia sẻ."
                self.nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhLaDam
            case .failure(let loi):
                let mau = BoVietBanTin.taoNoiDungBaoCao(loai: self.loaiXuatAnhDangChon, ngay: self.ngayHienTai, giong: self.giongXuatAnhDangChon)
                self.oVanBanXuatAnh.attributedText = ManHinhBanTin.dinhDangVanBanCoInDam(mau)
                self.oVanBanXuatAnh.invalidateIntrinsicContentSize()
                self.nhanTrangThaiXuatAnh.text = "ℹ️ Đã tạo nội dung theo mẫu chuẩn (Gemini phản hồi: \(loi.localizedDescription))"
                self.nhanTrangThaiXuatAnh.textColor = BangMauBCTD.vangKhaChu
            }
        }
    }

    @objc private func bamChiCopyNoiDungXuatAnh() {
        view.endEditing(true)
        let text = oVanBanXuatAnh.text ?? ""
        UIPasteboard.general.string = text
        nhanTrangThaiXuatAnh.text = "✅ Đã sao chép nội dung trong ô văn bản vào bộ nhớ tạm!"
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhLaDam
    }

    @objc private func bamXuatAnhThatVaCopyLine() {
        view.endEditing(true)
        let noiDungText = oVanBanXuatAnh.text ?? ""
        UIPasteboard.general.string = noiDungText

        guard let anh = taoAnhTheoLoaiBaoCao(loaiXuatAnhDangChon) else {
            nhanTrangThaiXuatAnh.text = "⚠️ Chưa có dữ liệu bảng của phần \"\(loaiXuatAnhDangChon.tieuDeNgan)\" để vẽ ảnh (Đã copy sẵn nội dung chữ)."
            nhanTrangThaiXuatAnh.textColor = BangMauBCTD.doYeuChu
            return
        }

        nhanTrangThaiXuatAnh.text = "✅ ĐÃ COPY NỘI DUNG Ô TEXT! Hãy chọn LINE (hoặc Lưu hình ảnh) trên hộp thoại rồi Dán (Paste) nội dung kèm ảnh."
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhLaDam
        chiaSe([anh])
    }

    private func taoAnhTheoLoaiBaoCao(_ loai: LoaiBaoCaoXuatAnh) -> UIImage? {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        switch loai {
        case .doanhThuThiDuaLuyKe:
            return bangThiDua.taoAnhBaoCao(
                ngay: ngayHienTai,
                doanhThu: doanhThuHienThi(dl.doanhThu, cheDo: .luyKe),
                danhSach: dl.danhSachThiDua,
                cheDoDoanhThu: .luyKe,
                xemDuKien: false,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .luyKeDuKien:
            return bangThiDua.taoAnhBaoCao(
                ngay: ngayHienTai,
                doanhThu: doanhThuHienThi(dl.doanhThu, cheDo: .luyKe),
                danhSach: dl.danhSachThiDua,
                cheDoDoanhThu: .luyKe,
                xemDuKien: true,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .doanhThuThiDuaRealtime:
            return bangThiDua.taoAnhBaoCao(
                ngay: ngayHienTai,
                doanhThu: doanhThuHienThi(dl.doanhThuRealtime, cheDo: .realtime),
                danhSach: dl.danhSachThiDuaRealtime,
                cheDoDoanhThu: .realtime,
                xemDuKien: false,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .xepHangNVLuyKe:
            return bangNhanVien.taoAnhBaoCaoNhanVien(
                ngay: ngayHienTai,
                cheDo: .luyKe,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .xepHangNVRealtime:
            return bangNhanVien.taoAnhBaoCaoNhanVien(
                ngay: ngayHienTai,
                cheDo: .realtime,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .bieuDoSucKhoeNV:
            return bangRealtimeThang.taoAnhBaoCaoSucKhoeNhanVien(
                ngay: ngayHienTai,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .bieuDoRealtimeThang:
            return bangRealtimeThang.taoAnhBaoCaoRealtimeThang(
                ngay: ngayHienTai,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            )
        case .chiTiet16NV:
            return ManHinhChiTietNhanVien.taoAnhGopTatCaSucKhoe(cho: ngayHienTai, cheDo: .luyKe)
        }
    }

    @objc private func bamCopyJSONTuMucXuatAnh() {
        view.endEditing(true)
        let noiDung = oVanBanXuatAnh.text ?? ""
        let yc = (oYeuCauRiengXuatAnh.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai = yc
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngayHienTai, khung: KhungBanTin.theoGio())
        UIPasteboard.general.string = GoiDuLieuXuatAI.tao(soLieu: s, noiDungBaoCao: noiDung, yeuCau: yc)
        nhanTrangThaiXuatAnh.text = "✅ Đã copy JSON kèm câu lệnh. Hãy dán vào Copilot hoặc ứng dụng AI khác để tạo Excel/PowerPoint."
        nhanTrangThaiXuatAnh.textColor = BangMauBCTD.xanhLaDam
    }

    @objc private func bamChonMucConTrenThanh(_ sender: UIButton) {
        guard let mucCon = MucConDoSo(rawValue: sender.tag) else { return }
        mucMenuChinh = .doSoXemSo
        mucConDoSo = mucCon
        napDuLieu()
    }

    @objc private func bamChonTabXemSo(_ sender: UIButton) {
        guard let tab = TabXemSo(rawValue: sender.tag) else { return }
        let dangTrongMucNhanVien = (mucMenuChinh == .nhanVien)
        if !dangTrongMucNhanVien { mucMenuChinh = .doSoXemSo }
        mucConDoSo = .xemSo
        if tabXemSo == tab && ((dangTrongMucNhanVien && mucMenuChinh == .nhanVien) || (!dangTrongMucNhanVien && mucMenuChinh == .doSoXemSo)) {
            return
        }
        tabXemSo = tab
        if tab == .luyKe {
            cheDoDoanhThu = .luyKe
        } else if tab == .realtime {
            cheDoDoanhThu = .realtime
        }
        napDuLieu()
    }

    private func capNhatNutTabXemSo(choNhanVien: Bool) {
        guard cacNutTabXemSo.count >= 3 else { return }
        if choNhanVien {
            cacNutTabXemSo[0].tag = TabXemSo.nhanVien.rawValue
            cacNutTabXemSo[0].setTitle("👥 Xếp hạng", for: .normal)
            cacNutTabXemSo[1].tag = TabXemSo.bieuDo.rawValue
            cacNutTabXemSo[1].setTitle("❤️‍🩹 Sức khỏe", for: .normal)
            for idx in 2..<cacNutTabXemSo.count {
                cacNutTabXemSo[idx].isHidden = true
            }
        } else {
            for (nut, tab) in zip(cacNutTabXemSo, TabXemSo.allCases) {
                nut.tag = tab.rawValue
                nut.setTitle("\(tab.bieuTuong) \(tab.tieuDe)", for: .normal)
                nut.isHidden = false
            }
        }
    }

    private func cauHinhNutCheDoNV(_ nut: UIButton, tieuDe: String, tag: Int) {
        nut.tag = tag
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nut.titleLabel?.numberOfLines = 0
        nut.titleLabel?.lineBreakMode = .byWordWrapping
        nut.titleLabel?.textAlignment = .center
        nut.titleLabel?.adjustsFontSizeToFitWidth = false
        nut.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        nut.layer.cornerRadius = 9
        nut.layer.borderWidth = 1
        nut.addTarget(self, action: #selector(bamChonCheDoNV(_:)), for: .touchUpInside)
    }

    @objc private func bamChonCheDoNV(_ sender: UIButton) {
        guard let moi = LoaiCheDoDoanhThu(rawValue: sender.tag), moi != cheDoDoanhThu else { return }
        cheDoDoanhThu = moi
        napDuLieu()
    }

    // MARK: - Khung nội dung Tổng quan, Báo cáo AI, Cài đặt, Quản trị và các mục mở rộng

    private func taoKhungTongQuan() {
        khungTongQuan.backgroundColor = BangMauBCTD.nenTrang
        khungTongQuan.isHidden = true
        khungTongQuan.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungTongQuan)

        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungTongQuan.addSubview(cuon)

        let ngan = UIStackView()
        ngan.axis = .vertical
        ngan.spacing = 10
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        let theChao = UIView()
        theChao.backgroundColor = BangMauBCTD.xanhChuDao
        theChao.layer.cornerRadius = 12
        theChao.clipsToBounds = true

        let vachVangChao = UIView()
        vachVangChao.backgroundColor = BangMauBCTD.vangSang
        vachVangChao.translatesAutoresizingMaskIntoConstraints = false
        theChao.addSubview(vachVangChao)

        let lbKickerChao = UILabel()
        lbKickerChao.text = "BÁO CÁO THI ĐUA · TỔNG QUAN SIÊU THỊ"
        lbKickerChao.font = .systemFont(ofSize: 11.5, weight: .heavy)
        lbKickerChao.textColor = BangMauBCTD.vangSang
        lbKickerChao.numberOfLines = 0
        lbKickerChao.lineBreakMode = .byWordWrapping
        lbKickerChao.adjustsFontSizeToFitWidth = false
        lbKickerChao.translatesAutoresizingMaskIntoConstraints = false
        theChao.addSubview(lbKickerChao)

        nutChonCaTongQuan.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutChonCaTongQuan.titleLabel?.numberOfLines = 0
        nutChonCaTongQuan.titleLabel?.lineBreakMode = .byWordWrapping
        nutChonCaTongQuan.titleLabel?.adjustsFontSizeToFitWidth = false
        nutChonCaTongQuan.backgroundColor = BangMauBCTD.vangSang
        nutChonCaTongQuan.tintColor = BangMauBCTD.chuChinh
        nutChonCaTongQuan.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutChonCaTongQuan.setTitleColor(BangMauBCTD.chuChinh, for: .highlighted)
        nutChonCaTongQuan.layer.cornerRadius = 8
        nutChonCaTongQuan.layer.borderWidth = 1
        nutChonCaTongQuan.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutChonCaTongQuan.contentEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
        nutChonCaTongQuan.setContentHuggingPriority(.required, for: .horizontal)
        nutChonCaTongQuan.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutChonCaTongQuan.showsMenuAsPrimaryAction = true

        nutChonNVTongQuan.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutChonNVTongQuan.titleLabel?.numberOfLines = 0
        nutChonNVTongQuan.titleLabel?.lineBreakMode = .byWordWrapping
        nutChonNVTongQuan.titleLabel?.adjustsFontSizeToFitWidth = false
        nutChonNVTongQuan.backgroundColor = BangMauBCTD.nenThe
        nutChonNVTongQuan.tintColor = BangMauBCTD.xanhChuDaoDam
        nutChonNVTongQuan.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutChonNVTongQuan.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .highlighted)
        nutChonNVTongQuan.layer.cornerRadius = 8
        nutChonNVTongQuan.layer.borderWidth = 1
        nutChonNVTongQuan.layer.borderColor = BangMauBCTD.vangSang.cgColor
        nutChonNVTongQuan.contentEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 9)
        nutChonNVTongQuan.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nutChonNVTongQuan.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nutChonNVTongQuan.addTarget(self, action: #selector(moBangChonNhanVienTrongCaTongQuan), for: .touchUpInside)

        let hangCbbTongQuan = UIStackView(arrangedSubviews: [nutChonCaTongQuan, nutChonNVTongQuan])
        hangCbbTongQuan.axis = .horizontal
        hangCbbTongQuan.spacing = 8
        hangCbbTongQuan.alignment = .center
        hangCbbTongQuan.distribution = .fill
        hangCbbTongQuan.translatesAutoresizingMaskIntoConstraints = false
        theChao.addSubview(hangCbbTongQuan)
        capNhatMenuCaTongQuan()
        capNhatMenuNVTongQuan()

        nhanTomTatTongQuan.font = .systemFont(ofSize: 14, weight: .medium)
        nhanTomTatTongQuan.textColor = BangMauBCTD.chuChinh
        nhanTomTatTongQuan.backgroundColor = .white
        nhanTomTatTongQuan.layer.cornerRadius = 10
        nhanTomTatTongQuan.isEditable = false
        nhanTomTatTongQuan.isScrollEnabled = true
        nhanTomTatTongQuan.showsVerticalScrollIndicator = true
        nhanTomTatTongQuan.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        nhanTomTatTongQuan.translatesAutoresizingMaskIntoConstraints = false
        theChao.addSubview(nhanTomTatTongQuan)

        let nhanHuongDan = UILabel()
        nhanHuongDan.text = "TRUY CẬP NHANH BÁO CÁO AI · XEM SỐ · NHẬP SỐ · XUẤT ẢNH & CÀI ĐẶT"
        nhanHuongDan.font = .systemFont(ofSize: 11.5, weight: .bold)
        nhanHuongDan.textColor = BangMauBCTD.chuPhu
        nhanHuongDan.numberOfLines = 0
        nhanHuongDan.lineBreakMode = .byWordWrapping
        nhanHuongDan.adjustsFontSizeToFitWidth = false

        let nutMoBaoCao = taoNutLoiTatTongQuan(
            tieuDe: "📰 Báo cáo",
            moTa: "Chọn nội dung, nhóm hàng và nhân viên cần nhắc; xuất ảnh và tự động copy nội dung",
            mau: BangMauBCTD.vangChuDao,
            tag: 100
        )
        let nutMoXemSo = taoNutLoiTatTongQuan(
            tieuDe: "👁️ 1. Xem số (Lũy kế · Realtime · Biểu đồ · Nhân viên)",
            moTa: "Xem bảng thi đua Lũy kế, Realtime, Biểu đồ sức khỏe 16 NV & Bảng xếp hạng NV",
            mau: BangMauBCTD.xanhChuDao,
            tag: 101
        )
        let nutMoNhapSo = taoNutLoiTatTongQuan(
            tieuDe: "📥 2. Nhập số (Nhập tất cả Lũy kế & Nhập tất cả Realtime)",
            moTa: "Mở bảng nhập dữ liệu nhanh: quét tất cả ảnh Lũy kế, tất cả ảnh Realtime hoặc nhập tay",
            mau: BangMauBCTD.xanhDatVach,
            tag: 102
        )
        let nutMoXuatAnh = taoNutLoiTatTongQuan(
            tieuDe: "🖼️ 3. Xuất ảnh & Copy JSON tạo file",
            moTa: "Chọn loại ảnh cần xuất, xem/sửa ô Text báo cáo, tự động Copy nội dung kèm ảnh gửi LINE",
            mau: BangMauBCTD.xanhBienChuDao,
            tag: 103
        )
        let nutMoCaiDat = taoNutLoiTatTongQuan(
            tieuDe: "⚙️ Cài đặt",
            moTa: "Chia target mặt hàng, quản lý danh sách nhân viên và chọn kiểu hiển thị",
            mau: BangMauBCTD.indigoDam,
            tag: 105
        )

        ngan.addArrangedSubview(theChao)

        NSLayoutConstraint.activate([
            khungTongQuan.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungTongQuan.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungTongQuan.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungTongQuan.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            cuon.topAnchor.constraint(equalTo: khungTongQuan.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: khungTongQuan.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungTongQuan.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: khungTongQuan.bottomAnchor),

            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 12),
            ngan.leadingAnchor.constraint(equalTo: cuon.contentLayoutGuide.leadingAnchor, constant: 12),
            ngan.trailingAnchor.constraint(equalTo: cuon.contentLayoutGuide.trailingAnchor, constant: -12),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -16),
            ngan.widthAnchor.constraint(equalTo: cuon.frameLayoutGuide.widthAnchor, constant: -24),

            vachVangChao.topAnchor.constraint(equalTo: theChao.topAnchor),
            vachVangChao.bottomAnchor.constraint(equalTo: theChao.bottomAnchor),
            vachVangChao.leadingAnchor.constraint(equalTo: theChao.leadingAnchor),
            vachVangChao.widthAnchor.constraint(equalToConstant: 5),

            lbKickerChao.topAnchor.constraint(equalTo: theChao.topAnchor, constant: 10),
            lbKickerChao.leadingAnchor.constraint(equalTo: vachVangChao.trailingAnchor, constant: 12),
            lbKickerChao.trailingAnchor.constraint(equalTo: theChao.trailingAnchor, constant: -14),

            hangCbbTongQuan.topAnchor.constraint(equalTo: lbKickerChao.bottomAnchor, constant: 8),
            hangCbbTongQuan.leadingAnchor.constraint(equalTo: vachVangChao.trailingAnchor, constant: 12),
            hangCbbTongQuan.trailingAnchor.constraint(lessThanOrEqualTo: theChao.trailingAnchor, constant: -14),

            nhanTomTatTongQuan.topAnchor.constraint(equalTo: hangCbbTongQuan.bottomAnchor, constant: 8),
            nhanTomTatTongQuan.leadingAnchor.constraint(equalTo: vachVangChao.trailingAnchor, constant: 12),
            nhanTomTatTongQuan.trailingAnchor.constraint(equalTo: theChao.trailingAnchor, constant: -14),
            nhanTomTatTongQuan.bottomAnchor.constraint(equalTo: theChao.bottomAnchor, constant: -14),
            nhanTomTatTongQuan.heightAnchor.constraint(equalToConstant: max(420, UIScreen.main.bounds.height * 0.75))
        ])
    }

    private func taoNutLoiTatTongQuan(tieuDe: String, moTa: String, mau: UIColor, tag: Int) -> UIControl {
        let the = UIControl()
        the.tag = tag
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 11
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor
        the.clipsToBounds = true
        the.addTarget(self, action: #selector(bamLoiTatTongQuan(_:)), for: .touchUpInside)

        let vachTrai = UIView()
        vachTrai.backgroundColor = mau
        vachTrai.isUserInteractionEnabled = false
        vachTrai.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(vachTrai)

        let lbChinh = UILabel()
        lbChinh.text = tieuDe
        lbChinh.font = .systemFont(ofSize: 14.5, weight: .bold)
        lbChinh.textColor = BangMauBCTD.chuChinh
        lbChinh.numberOfLines = 0
        lbChinh.lineBreakMode = .byWordWrapping
        lbChinh.adjustsFontSizeToFitWidth = false
        lbChinh.isUserInteractionEnabled = false
        lbChinh.translatesAutoresizingMaskIntoConstraints = false

        let lbPhu = UILabel()
        lbPhu.text = moTa
        lbPhu.font = .systemFont(ofSize: 12.5, weight: .medium)
        lbPhu.textColor = BangMauBCTD.chuMo
        lbPhu.numberOfLines = 0
        lbPhu.lineBreakMode = .byWordWrapping
        lbPhu.adjustsFontSizeToFitWidth = false
        lbPhu.isUserInteractionEnabled = false
        lbPhu.translatesAutoresizingMaskIntoConstraints = false

        the.addSubview(lbChinh)
        the.addSubview(lbPhu)

        NSLayoutConstraint.activate([
            vachTrai.topAnchor.constraint(equalTo: the.topAnchor),
            vachTrai.bottomAnchor.constraint(equalTo: the.bottomAnchor),
            vachTrai.leadingAnchor.constraint(equalTo: the.leadingAnchor),
            vachTrai.widthAnchor.constraint(equalToConstant: 4.5),

            lbChinh.topAnchor.constraint(equalTo: the.topAnchor, constant: 12),
            lbChinh.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            lbChinh.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -14),

            lbPhu.topAnchor.constraint(equalTo: lbChinh.bottomAnchor, constant: 4),
            lbPhu.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            lbPhu.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -14),
            lbPhu.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -12)
        ])
        return the
    }

    @objc private func bamLoiTatTongQuan(_ sender: UIControl) {
        switch sender.tag {
        case 100:
            mucMenuChinh = .baoCao
        case 101:
            mucMenuChinh = .doSoXemSo
            mucConDoSo = .xemSo
        case 102:
            mucMenuChinh = .doSoXemSo
            mucConDoSo = .nhapSo
        case 103:
            mucMenuChinh = .doSoXemSo
            mucConDoSo = .xuatAnh
        case 105:
            mucMenuChinh = .caiDat
        default:
            break
        }
        napDuLieu()
    }

    private func capNhatMenuCaTongQuan() {
        nutChonCaTongQuan.setTitle("Ca: \(caTongQuanDangChon.tieuDe) ▾", for: .normal)
        let cacMuc = CaBaoCaoTongQuan.allCases.map { ca in
            UIAction(title: ca.tieuDe, state: ca == caTongQuanDangChon ? .on : .off) { [weak self] _ in
                guard let self else { return }
                self.caTongQuanDangChon = ca
                self.capNhatMenuCaTongQuan()
                self.napDuLieu()
            }
        }
        nutChonCaTongQuan.menu = UIMenu(title: "Chọn ca báo cáo", children: cacMuc)
    }

    private func layTapMaNVChonTongQuan() -> Set<String> {
        let tatCaMa = Set(KhoDuLieu.dungChung.caiDat.danhSachNhanVien.map(\.maNV))
        guard let daLuu = maNVChonTongQuan else { return tatCaMa }
        return daLuu.intersection(tatCaMa)
    }

    private func luuMaNVChonTongQuan(_ tap: Set<String>?) {
        maNVChonTongQuan = tap
        if let tap = tap {
            UserDefaults.standard.set(Array(tap), forKey: "dmx_ma_nv_chon_tong_quan_v1")
        } else {
            UserDefaults.standard.removeObject(forKey: "dmx_ma_nv_chon_tong_quan_v1")
        }
    }

    private func capNhatMenuNVTongQuan() {
        let dsNV = NhanVienQuanLy.sapXepAZ(KhoDuLieu.dungChung.caiDat.danhSachNhanVien)
        let tapDangChon = layTapMaNVChonTongQuan()
        let tongNV = dsNV.count
        let soChon = tapDangChon.count

        if tongNV == 0 {
            nutChonNVTongQuan.setTitle("👥 NV trong ca: 0 NV ▾", for: .normal)
        } else if soChon >= tongNV {
            nutChonNVTongQuan.setTitle("👥 NV trong ca: Tất cả (\(tongNV)) ▾", for: .normal)
        } else {
            nutChonNVTongQuan.setTitle("👥 NV trong ca: \(soChon)/\(tongNV) NV ▾", for: .normal)
        }
    }

    @objc private func moBangChonNhanVienTrongCaTongQuan() {
        let dsNV = NhanVienQuanLy.sapXepAZ(KhoDuLieu.dungChung.caiDat.danhSachNhanVien)
        guard !dsNV.isEmpty else { return }

        let hop = UIViewController()
        hop.view.backgroundColor = UIColor.black.withAlphaComponent(0.12)

        // Khung thẻ chính mang phong cách thương hiệu Điện Máy Xanh (Nền Xanh chủ đạo + Viền Vàng đậm + Vạch Vàng trái)
        let khungDMX = UIView()
        khungDMX.backgroundColor = BangMauBCTD.xanhChuDao
        khungDMX.layer.cornerRadius = 18
        khungDMX.layer.borderWidth = 2.5
        khungDMX.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        khungDMX.clipsToBounds = true
        khungDMX.translatesAutoresizingMaskIntoConstraints = false
        hop.view.addSubview(khungDMX)

        let vachVangTrai = UIView()
        vachVangTrai.backgroundColor = BangMauBCTD.vangSang
        vachVangTrai.translatesAutoresizingMaskIntoConstraints = false
        khungDMX.addSubview(vachVangTrai)

        let lbTieuDe = UILabel()
        lbTieuDe.text = "👥 CHỌN NHÂN VIÊN TRONG CA"
        lbTieuDe.font = .systemFont(ofSize: 15.0, weight: .heavy)
        lbTieuDe.textColor = BangMauBCTD.vangSang
        lbTieuDe.numberOfLines = 0
        lbTieuDe.lineBreakMode = .byWordWrapping
        lbTieuDe.adjustsFontSizeToFitWidth = false

        let nutXong = UIButton(type: .system, primaryAction: UIAction { [weak hop] _ in
            hop?.dismiss(animated: true)
        })
        nutXong.setTitle("Xong", for: .normal)
        nutXong.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .heavy)
        nutXong.titleLabel?.numberOfLines = 0
        nutXong.titleLabel?.lineBreakMode = .byWordWrapping
        nutXong.titleLabel?.adjustsFontSizeToFitWidth = false
        nutXong.backgroundColor = BangMauBCTD.vangSang
        nutXong.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutXong.layer.cornerRadius = 9
        nutXong.layer.borderWidth = 1.2
        nutXong.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutXong.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        nutXong.setContentHuggingPriority(.required, for: .horizontal)
        nutXong.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hangDau = UIStackView(arrangedSubviews: [lbTieuDe, nutXong])
        hangDau.axis = .horizontal
        hangDau.spacing = 8
        hangDau.alignment = .center

        let nhanMoTa = UILabel()
        nhanMoTa.font = .systemFont(ofSize: 12.5, weight: .semibold)
        nhanMoTa.textColor = .white
        nhanMoTa.numberOfLines = 0
        nhanMoTa.lineBreakMode = .byWordWrapping
        nhanMoTa.adjustsFontSizeToFitWidth = false

        let nutAll = UIButton(type: .system)
        nutAll.setTitle("✅ Chọn tất cả (\(dsNV.count))", for: .normal)
        nutAll.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .heavy)
        nutAll.titleLabel?.numberOfLines = 0
        nutAll.titleLabel?.lineBreakMode = .byWordWrapping
        nutAll.titleLabel?.adjustsFontSizeToFitWidth = false
        nutAll.backgroundColor = BangMauBCTD.vangSang
        nutAll.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutAll.layer.cornerRadius = 9
        nutAll.layer.borderWidth = 1.5
        nutAll.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutAll.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

        let nutNone = UIButton(type: .system)
        nutNone.setTitle("⬜ Bỏ chọn tất cả", for: .normal)
        nutNone.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutNone.titleLabel?.numberOfLines = 0
        nutNone.titleLabel?.lineBreakMode = .byWordWrapping
        nutNone.titleLabel?.adjustsFontSizeToFitWidth = false
        nutNone.backgroundColor = .white
        nutNone.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutNone.layer.cornerRadius = 9
        nutNone.layer.borderWidth = 1.5
        nutNone.layer.borderColor = BangMauBCTD.vangSang.cgColor
        nutNone.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)

        let hangNut = UIStackView(arrangedSubviews: [nutAll, nutNone])
        hangNut.axis = .horizontal
        hangNut.spacing = 8
        hangNut.distribution = .fillEqually

        // Khung trắng bên trong viền vàng chứa danh sách nhân viên
        let khungDanhSach = UIView()
        khungDanhSach.backgroundColor = .white
        khungDanhSach.layer.cornerRadius = 12
        khungDanhSach.layer.borderWidth = 1.8
        khungDanhSach.layer.borderColor = BangMauBCTD.vangSang.cgColor
        khungDanhSach.clipsToBounds = true

        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungDanhSach.addSubview(cuon)

        let nganDS = UIStackView()
        nganDS.axis = .vertical
        nganDS.spacing = 7
        nganDS.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(nganDS)

        var cacNutHang: [(nv: NhanVienQuanLy, nut: UIButton, vachVang: UIView)] = []

        func capNhatTrangThaiBang() {
            let tap = self.layTapMaNVChonTongQuan()
            nhanMoTa.text = "Đang chọn \(tap.count)/\(dsNV.count) nhân viên làm trong ca • Báo cáo Tổng quan chỉ phân tích các nhân viên được tích chọn:"
            for (nv, nut, vachVang) in cacNutHang {
                let chon = tap.contains(nv.maNV)
                let icon = chon ? "☑️" : "⬜"
                nut.setTitle("\(icon)  \(nv.hoTen) — Mã NV: \(nv.maNV)", for: .normal)
                if chon {
                    nut.backgroundColor = BangMauBCTD.vangNhatNen
                    nut.layer.borderWidth = 1.8
                    nut.layer.borderColor = BangMauBCTD.xanhChuDao.cgColor
                    nut.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
                    vachVang.backgroundColor = BangMauBCTD.vangChuDao
                    vachVang.isHidden = false
                } else {
                    nut.backgroundColor = BangMauBCTD.nenThe
                    nut.layer.borderWidth = 1.0
                    nut.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor
                    nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                    vachVang.isHidden = true
                }
            }
        }

        for nv in dsNV {
            let nut = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
                guard let self else { return }
                var tap = self.layTapMaNVChonTongQuan()
                if tap.contains(nv.maNV) {
                    tap.remove(nv.maNV)
                } else {
                    tap.insert(nv.maNV)
                }
                let tatCa = Set(dsNV.map(\.maNV))
                self.luuMaNVChonTongQuan(tap == tatCa ? nil : tap)
                capNhatTrangThaiBang()
                self.capNhatMenuNVTongQuan()
                self.napDuLieu()
            })
            nut.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.titleLabel?.lineBreakMode = .byWordWrapping
            nut.titleLabel?.adjustsFontSizeToFitWidth = false
            nut.contentHorizontalAlignment = .left
            nut.contentEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 12)
            nut.layer.cornerRadius = 10
            nut.clipsToBounds = true

            let vachVang = UIView()
            vachVang.backgroundColor = BangMauBCTD.vangChuDao
            vachVang.isUserInteractionEnabled = false
            vachVang.translatesAutoresizingMaskIntoConstraints = false
            nut.addSubview(vachVang)
            NSLayoutConstraint.activate([
                vachVang.topAnchor.constraint(equalTo: nut.topAnchor),
                vachVang.bottomAnchor.constraint(equalTo: nut.bottomAnchor),
                vachVang.leadingAnchor.constraint(equalTo: nut.leadingAnchor),
                vachVang.widthAnchor.constraint(equalToConstant: 5)
            ])

            cacNutHang.append((nv, nut, vachVang))
            nganDS.addArrangedSubview(nut)
        }

        nutAll.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.luuMaNVChonTongQuan(nil)
            capNhatTrangThaiBang()
            self.capNhatMenuNVTongQuan()
            self.napDuLieu()
        }, for: .touchUpInside)

        nutNone.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.luuMaNVChonTongQuan([])
            capNhatTrangThaiBang()
            self.capNhatMenuNVTongQuan()
            self.napDuLieu()
        }, for: .touchUpInside)

        capNhatTrangThaiBang()

        [hangDau, nhanMoTa, hangNut, khungDanhSach].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungDMX.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungDMX.topAnchor.constraint(equalTo: hop.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            khungDMX.leadingAnchor.constraint(equalTo: hop.view.leadingAnchor, constant: 8),
            khungDMX.trailingAnchor.constraint(equalTo: hop.view.trailingAnchor, constant: -8),
            khungDMX.bottomAnchor.constraint(equalTo: hop.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),

            vachVangTrai.topAnchor.constraint(equalTo: khungDMX.topAnchor),
            vachVangTrai.bottomAnchor.constraint(equalTo: khungDMX.bottomAnchor),
            vachVangTrai.leadingAnchor.constraint(equalTo: khungDMX.leadingAnchor),
            vachVangTrai.widthAnchor.constraint(equalToConstant: 5),

            hangDau.topAnchor.constraint(equalTo: khungDMX.topAnchor, constant: 12),
            hangDau.leadingAnchor.constraint(equalTo: vachVangTrai.trailingAnchor, constant: 12),
            hangDau.trailingAnchor.constraint(equalTo: khungDMX.trailingAnchor, constant: -12),

            nhanMoTa.topAnchor.constraint(equalTo: hangDau.bottomAnchor, constant: 6),
            nhanMoTa.leadingAnchor.constraint(equalTo: vachVangTrai.trailingAnchor, constant: 12),
            nhanMoTa.trailingAnchor.constraint(equalTo: khungDMX.trailingAnchor, constant: -12),

            hangNut.topAnchor.constraint(equalTo: nhanMoTa.bottomAnchor, constant: 10),
            hangNut.leadingAnchor.constraint(equalTo: vachVangTrai.trailingAnchor, constant: 12),
            hangNut.trailingAnchor.constraint(equalTo: khungDMX.trailingAnchor, constant: -12),

            khungDanhSach.topAnchor.constraint(equalTo: hangNut.bottomAnchor, constant: 10),
            khungDanhSach.leadingAnchor.constraint(equalTo: vachVangTrai.trailingAnchor, constant: 10),
            khungDanhSach.trailingAnchor.constraint(equalTo: khungDMX.trailingAnchor, constant: -10),
            khungDanhSach.bottomAnchor.constraint(equalTo: khungDMX.bottomAnchor, constant: -10),

            cuon.topAnchor.constraint(equalTo: khungDanhSach.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: khungDanhSach.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungDanhSach.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: khungDanhSach.bottomAnchor),

            nganDS.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 10),
            nganDS.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 10),
            nganDS.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -10),
            nganDS.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -14)
        ])

        hop.modalPresentationStyle = .pageSheet
        if let sheet = hop.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(hop, animated: true)
    }

    @objc private func saoChepTongQuan() {
        UIPasteboard.general.string = nhanTomTatTongQuan.text
        let tb = UIAlertController(title: "Đã sao chép", message: "Thông tin tổng quan đã được lưu vào clipboard.", preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(tb, animated: true)
    }

    private func dongNhomHangTongQuan(
        _ ds: [DongThiDua],
        rong: String,
        doiChieu: [DongThiDua] = [],
        nhanDoiChieu: String = ""
    ) -> [String] {
        guard !ds.isEmpty else { return ["• \(rong)"] }
        return ds.prefix(5).enumerated().map { viTri, dong in
            let thucHien = dong.thucHien.chuoiSoGonVN
            let target = dong.target.chuoiSoGonVN
            let tyLe = dong.phanTramHT.chuoiPhanTram
            let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(dong.tenNganhHang)
            let cungNganh = doiChieu.first {
                $0.loaiChiTieu == dong.loaiChiTieu && KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) == khoa
            }
            let soSanh = cungNganh.map { " · \(nhanDoiChieu) \($0.phanTramHT.chuoiPhanTram)" } ?? ""
            return "\(viTri + 1). \(dong.tenNganhHang): \(thucHien)/\(target) (\(tyLe))\(soSanh)"
        }
    }

    private func taoKhungBaoCao() {
        khungBaoCao.backgroundColor = BangMauBCTD.nenTrang
        khungBaoCao.isHidden = true
        khungBaoCao.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungBaoCao)

        addChild(manHinhBanTinNhung)
        manHinhBanTinNhung.view.translatesAutoresizingMaskIntoConstraints = false
        khungBaoCao.addSubview(manHinhBanTinNhung.view)
        manHinhBanTinNhung.didMove(toParent: self)

        NSLayoutConstraint.activate([
            khungBaoCao.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungBaoCao.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungBaoCao.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungBaoCao.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            manHinhBanTinNhung.view.topAnchor.constraint(equalTo: khungBaoCao.topAnchor),
            manHinhBanTinNhung.view.leadingAnchor.constraint(equalTo: khungBaoCao.leadingAnchor),
            manHinhBanTinNhung.view.trailingAnchor.constraint(equalTo: khungBaoCao.trailingAnchor),
            manHinhBanTinNhung.view.bottomAnchor.constraint(equalTo: khungBaoCao.bottomAnchor)
        ])
    }

    private func taoKhungTaiKhoanHopThu() {
        khungTaiKhoanHopThu.backgroundColor = BangMauBCTD.nenTrang
        khungTaiKhoanHopThu.isHidden = true
        khungTaiKhoanHopThu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungTaiKhoanHopThu)

        addChild(manHinhCaiDatNhung)
        manHinhCaiDatNhung.view.translatesAutoresizingMaskIntoConstraints = false
        khungTaiKhoanHopThu.addSubview(manHinhCaiDatNhung.view)
        manHinhCaiDatNhung.didMove(toParent: self)
        manHinhCaiDatNhung.khiThayDoiCaiDat = { [weak self] in
            self?.dsThiDuaDaNapUI = nil
            self?.napDuLieu()
        }

        NSLayoutConstraint.activate([
            khungTaiKhoanHopThu.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungTaiKhoanHopThu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungTaiKhoanHopThu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungTaiKhoanHopThu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            manHinhCaiDatNhung.view.topAnchor.constraint(equalTo: khungTaiKhoanHopThu.topAnchor),
            manHinhCaiDatNhung.view.leadingAnchor.constraint(equalTo: khungTaiKhoanHopThu.leadingAnchor),
            manHinhCaiDatNhung.view.trailingAnchor.constraint(equalTo: khungTaiKhoanHopThu.trailingAnchor),
            manHinhCaiDatNhung.view.bottomAnchor.constraint(equalTo: khungTaiKhoanHopThu.bottomAnchor)
        ])
    }

    private func taoKhungQuanTri() {
        khungQuanTri.backgroundColor = BangMauBCTD.nenTrang
        khungQuanTri.isHidden = true
        khungQuanTri.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungQuanTri)

        addChild(manHinhQuanTriNhung)
        manHinhQuanTriNhung.view.translatesAutoresizingMaskIntoConstraints = false
        khungQuanTri.addSubview(manHinhQuanTriNhung.view)
        manHinhQuanTriNhung.didMove(toParent: self)

        NSLayoutConstraint.activate([
            khungQuanTri.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungQuanTri.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungQuanTri.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungQuanTri.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            manHinhQuanTriNhung.view.topAnchor.constraint(equalTo: khungQuanTri.topAnchor),
            manHinhQuanTriNhung.view.leadingAnchor.constraint(equalTo: khungQuanTri.leadingAnchor),
            manHinhQuanTriNhung.view.trailingAnchor.constraint(equalTo: khungQuanTri.trailingAnchor),
            manHinhQuanTriNhung.view.bottomAnchor.constraint(equalTo: khungQuanTri.bottomAnchor)
        ])
    }

    private func taoKhungTrinhDuyet() {
        khungTrinhDuyet.backgroundColor = BangMauBCTD.nenTrang
        khungTrinhDuyet.isHidden = true
        khungTrinhDuyet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungTrinhDuyet)

        addChild(manHinhTrinhDuyetNhung)
        manHinhTrinhDuyetNhung.view.translatesAutoresizingMaskIntoConstraints = false
        khungTrinhDuyet.addSubview(manHinhTrinhDuyetNhung.view)
        manHinhTrinhDuyetNhung.didMove(toParent: self)

        NSLayoutConstraint.activate([
            khungTrinhDuyet.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungTrinhDuyet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungTrinhDuyet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungTrinhDuyet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            manHinhTrinhDuyetNhung.view.topAnchor.constraint(equalTo: khungTrinhDuyet.topAnchor),
            manHinhTrinhDuyetNhung.view.leadingAnchor.constraint(equalTo: khungTrinhDuyet.leadingAnchor),
            manHinhTrinhDuyetNhung.view.trailingAnchor.constraint(equalTo: khungTrinhDuyet.trailingAnchor),
            manHinhTrinhDuyetNhung.view.bottomAnchor.constraint(equalTo: khungTrinhDuyet.bottomAnchor)
        ])
    }

    private func taoKhungMucMoRong() {
        khungMucMoRong.backgroundColor = BangMauBCTD.nenTrang
        khungMucMoRong.isHidden = true
        khungMucMoRong.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khungMucMoRong)

        let cuon = cuonMucMoRong
        cuon.keyboardDismissMode = .interactive
        cuon.alwaysBounceVertical = true
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungMucMoRong.addSubview(cuon)

        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 14
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor
        the.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(the)

        bieuTuongMucMoRong.tintColor = BangMauBCTD.xanhChuDao
        bieuTuongMucMoRong.contentMode = .scaleAspectFit
        bieuTuongMucMoRong.translatesAutoresizingMaskIntoConstraints = false

        nhanTieuDeMucMoRong.font = .systemFont(ofSize: 18, weight: .heavy)
        nhanTieuDeMucMoRong.textColor = BangMauBCTD.chuChinh
        nhanTieuDeMucMoRong.textAlignment = .center
        nhanTieuDeMucMoRong.numberOfLines = 0
        nhanTieuDeMucMoRong.lineBreakMode = .byWordWrapping
        nhanTieuDeMucMoRong.adjustsFontSizeToFitWidth = false

        nhanMoTaMucMoRong.font = .systemFont(ofSize: 14, weight: .medium)
        nhanMoTaMucMoRong.textColor = BangMauBCTD.chuPhu
        nhanMoTaMucMoRong.textAlignment = .center
        nhanMoTaMucMoRong.numberOfLines = 0
        nhanMoTaMucMoRong.lineBreakMode = .byWordWrapping
        nhanMoTaMucMoRong.adjustsFontSizeToFitWidth = false

        nganHanhDongMucMoRong.axis = .vertical
        nganHanhDongMucMoRong.spacing = 10

        let ngan = UIStackView(arrangedSubviews: [bieuTuongMucMoRong, nhanTieuDeMucMoRong, nhanMoTaMucMoRong, nganHanhDongMucMoRong])
        ngan.axis = .vertical
        ngan.spacing = 12
        ngan.alignment = .fill
        ngan.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(ngan)

        NSLayoutConstraint.activate([
            khungMucMoRong.topAnchor.constraint(equalTo: khungThanhDieuHuong.bottomAnchor),
            khungMucMoRong.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            khungMucMoRong.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            khungMucMoRong.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            cuon.topAnchor.constraint(equalTo: khungMucMoRong.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: khungMucMoRong.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungMucMoRong.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            the.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 16),
            the.leadingAnchor.constraint(equalTo: cuon.contentLayoutGuide.leadingAnchor, constant: 14),
            the.trailingAnchor.constraint(equalTo: cuon.contentLayoutGuide.trailingAnchor, constant: -14),
            the.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -24),
            the.widthAnchor.constraint(equalTo: cuon.frameLayoutGuide.widthAnchor, constant: -28),

            ngan.topAnchor.constraint(equalTo: the.topAnchor, constant: 20),
            ngan.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 16),
            ngan.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -16),
            ngan.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -20)
        ])
    }

    @objc private func anBanPhimXuatFile() {
        view.endEditing(true)
    }

    private func taoMenuTruotBenTrai() {
        lopNenMoMenu.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        lopNenMoMenu.alpha = 0
        lopNenMoMenu.isHidden = true
        lopNenMoMenu.translatesAutoresizingMaskIntoConstraints = false
        lopNenMoMenu.addTarget(self, action: #selector(anMenu), for: .touchUpInside)
        view.addSubview(lopNenMoMenu)

        menuBenTrai.isHidden = true
        menuBenTrai.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuBenTrai)

        let rgTrai = menuBenTrai.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -chieuRongMenu)
        rangBuocTraiMenu = rgTrai

        NSLayoutConstraint.activate([
            lopNenMoMenu.topAnchor.constraint(equalTo: view.topAnchor),
            lopNenMoMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lopNenMoMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lopNenMoMenu.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            menuBenTrai.topAnchor.constraint(equalTo: view.topAnchor),
            menuBenTrai.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuBenTrai.widthAnchor.constraint(equalToConstant: chieuRongMenu),
            rgTrai
        ])

        menuBenTrai.khiChonMucChinh = { [weak self] muc in
            guard let self = self else { return }
            self.mucMenuChinh = muc
            if muc == .doSoXemSo {
                self.mucConDoSo = .xemSo
                self.tabXemSo = .luyKe
                self.cheDoDoanhThu = .luyKe
            }
            if muc == .nhanVien { self.mucConDoSo = .xemSo; self.tabXemSo = .nhanVien }
            if muc == .tonKho { self.mucConDoSo = .xemSo; self.tabXemSo = .tonKho }
            self.anMenu(animated: true)
            self.napDuLieu()
        }

        menuBenTrai.khiChonMucConDoSo = { [weak self] mucCon in
            guard let self = self else { return }
            self.mucMenuChinh = .doSoXemSo
            self.mucConDoSo = mucCon
            self.anMenu(animated: true)
            self.napDuLieu()
        }

        let vuotMoMenu = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(xuLyVuotMepTrai(_:)))
        vuotMoMenu.edges = .left
        view.addGestureRecognizer(vuotMoMenu)
    }

    @objc private func xuLyVuotMepTrai(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .began && !dangMoMenu {
            hienMenu(animated: true)
        }
    }

    private func taoLopPhuTienTrinh() {
        lopPhuTai.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        lopPhuTai.isHidden = true
        lopPhuTai.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lopPhuTai)

        let hop = UIView()
        hop.backgroundColor = .white
        hop.layer.cornerRadius = 16
        hop.translatesAutoresizingMaskIntoConstraints = false
        lopPhuTai.addSubview(hop)

        vongQuay.color = BangMauBCTD.xanhChuDao
        vongQuay.translatesAutoresizingMaskIntoConstraints = false

        nhanTienTrinh.font = .systemFont(ofSize: 14, weight: .semibold)
        nhanTienTrinh.textColor = BangMauBCTD.chuChinh
        nhanTienTrinh.textAlignment = .center
        nhanTienTrinh.numberOfLines = 0
        nhanTienTrinh.lineBreakMode = .byWordWrapping
        nhanTienTrinh.adjustsFontSizeToFitWidth = false
        nhanTienTrinh.translatesAutoresizingMaskIntoConstraints = false

        hop.addSubview(vongQuay)
        hop.addSubview(nhanTienTrinh)

        NSLayoutConstraint.activate([
            lopPhuTai.topAnchor.constraint(equalTo: view.topAnchor),
            lopPhuTai.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lopPhuTai.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lopPhuTai.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            hop.centerXAnchor.constraint(equalTo: lopPhuTai.centerXAnchor),
            hop.centerYAnchor.constraint(equalTo: lopPhuTai.centerYAnchor),
            hop.widthAnchor.constraint(equalToConstant: 250),

            vongQuay.topAnchor.constraint(equalTo: hop.topAnchor, constant: 18),
            vongQuay.centerXAnchor.constraint(equalTo: hop.centerXAnchor),

            nhanTienTrinh.topAnchor.constraint(equalTo: vongQuay.bottomAnchor, constant: 12),
            nhanTienTrinh.leadingAnchor.constraint(equalTo: hop.leadingAnchor, constant: 14),
            nhanTienTrinh.trailingAnchor.constraint(equalTo: hop.trailingAnchor, constant: -14),
            nhanTienTrinh.bottomAnchor.constraint(equalTo: hop.bottomAnchor, constant: -18)
        ])
    }

    // MARK: - Nạp dữ liệu & Chuyển đổi mượt mà giữa các mục trong Menu

    private func doanhThuHienThi(_ doanhThu: ThongTinDoanhThu, cheDo: LoaiCheDoDoanhThu) -> ThongTinDoanhThu {
        doanhThu.apDungPhanTramTarget(
            KhoDuLieu.dungChung.caiDat.phanTramTarget(cho: cheDo),
            cheDo: cheDo
        )
    }

    private func napDuLieu() {
        // Notification và callback mạng có thể đến từ luồng nền. Mọi thay đổi UIKit
        // phải được gom về main thread để tránh crash ngẫu nhiên khi đổi mục nhanh.
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in self?.napDuLieu() }
            return
        }
        // Chống nạp lồng nhau (reload bảng có thể kích hoạt callback đồng bộ).
        // Nếu có yêu cầu mới, chỉ chạy thêm đúng một lượt ở nhịp giao diện kế tiếp.
        guard !dangNapDuLieu else {
            canNapDuLieuLai = true
            return
        }
        dangNapDuLieu = true
        defer {
            dangNapDuLieu = false
            if canNapDuLieuLai {
                canNapDuLieuLai = false
                DispatchQueue.main.async { [weak self] in self?.napDuLieu() }
            }
        }

        let chuoiNgay = "📅 \(TienIchNgay.hienThiNgay.string(from: ngayHienTai)) ▾"
        if nutNgay.title(for: .normal) != chuoiNgay {
            nutNgay.setTitle(chuoiNgay, for: .normal)
            nutNgay.sizeToFit()
        }

        let kho = KhoDuLieu.dungChung
        let dl = kho.duLieu(cho: ngayHienTai)
        let dsThiDuaDangChon = dl.danhSachThiDua(theo: cheDoDoanhThu)

        // Chỉ cập nhật cụm 8 thẻ doanh thu khi đang ở tab Lũy kế hoặc Realtime của mục Xem số (tránh tính toán thừa khi ẩn)
        let canHienCumDoanhThu = (mucMenuChinh == .doSoXemSo && mucConDoSo == .xemSo && (tabXemSo == .luyKe || tabXemSo == .realtime))
        if canHienCumDoanhThu {
            let xemDK = (cheDoDoanhThu == .luyKe && bangThiDua.dangXemDuKien)
            let khoaCum = "\(dl.khoaNgay)|\(kho.phienBanDuLieu)|\(cheDoDoanhThu.rawValue)|\(xemDK)"
            if khoaCumChiSoDaNapUI != khoaCum {
                khoaCumChiSoDaNapUI = khoaCum
                let soDat = dsThiDuaDangChon.filter { xemDK ? $0.daHoanThanhDuBao : $0.daDat }.count
                let dtGoc = (cheDoDoanhThu == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
                let dtDangChon = doanhThuHienThi(dtGoc, cheDo: cheDoDoanhThu)
                cumChiSoChinh.capNhat(
                    doanhThu: dtDangChon,
                    soNganhDat: soDat,
                    tongSoNganh: dsThiDuaDangChon.count,
                    ngay: ngayHienTai,
                    cheDo: cheDoDoanhThu,
                    dangXemBieuDo: false
                )
            }
        }

        capNhatTrangThaiMuc()
        capNhatNoiDungTheoMucDangChon(dl: dl, dsThiDuaDangChon: dsThiDuaDangChon)
    }

    /// Sau lần nhập/quét gần nhất, vẽ sẵn đúng ảnh của app và tải lên kho.
    /// Đến giờ gửi, Worker chỉ lấy URL ảnh nên không còn phải chờ máy chủ dựng ảnh.
    private func lenLichCapNhatAnhBaoCaoBot(dl: DuLieuNgayDMX, ngay: Date) {
        guard DichVuDongBo.dungChung.daDangNhap else { return }
        let cd = KhoDuLieu.dungChung.caiDat
        let khoaTaiKhoan = DichVuDongBo.dungChung.phien?.userId ?? ""
        let khoaSieuThi = DichVuDongBo.dungChung.sieuThiDangChonId
        let khoaDoanhThu = [
            String(dl.doanhThu.doanhThuQuyDoi),
            String(dl.doanhThuRealtime.doanhThuQuyDoi)
        ]
        let khoaDanhSach = [
            String(dl.danhSachThiDua.count),
            String(dl.danhSachThiDuaRealtime.count),
            String(dl.doanhThuNhanVien.count),
            String(dl.doanhThuNhanVienRealtime.count)
        ]
        let khoaCaiDat = [
            String(cd.phanTramTargetLuyKe),
            String(cd.phanTramTargetRealtime),
            cd.monThiDuaTheoDoiLuyKe.joined(separator: ","),
            cd.monThiDuaTheoDoiRealtime.joined(separator: ",")
        ]
        var thanhPhanKhoa = [khoaTaiKhoan, khoaSieuThi, dl.khoaNgay, dl.capNhatLuc]
        thanhPhanKhoa.append(contentsOf: khoaDoanhThu)
        thanhPhanKhoa.append(contentsOf: khoaDanhSach)
        thanhPhanKhoa.append(contentsOf: khoaCaiDat)
        let khoa = thanhPhanKhoa.joined(separator: "|")
        guard khoa != khoaAnhBotDaTai else { return }
        congViecTaoAnhBot?.cancel()
        maLanTaoAnhBot = UUID()
        let maLanTao = maLanTaoAnhBot
        let congViec = DispatchWorkItem { [weak self] in
            guard let self, self.maLanTaoAnhBot == maLanTao else { return }
            // Luôn tạo đủ 7 mẫu ảnh tổng hợp/biểu đồ mà app hỗ trợ (đã bỏ ảnh gộp chi tiết nhân viên theo yêu cầu để tăng tốc tải lên server).
            var cacLoai: Set<String> = [
                "luyke_du_kien",
                "doanhthu_thidua_luyke",
                "doanhthu_thidua_realtime",
                "xep_hang_nv_luyke",
                "xep_hang_nv_realtime",
                "bieu_do_realtime_thang",
                "bieu_do_suc_khoe_nv"
            ]
            let dsNVSK = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .tenAZ, cheDo: .luyKe).prefix(43)
            for itemNV in dsNVSK {
                let maSach = itemNV.nhanVien.maNV.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if !maSach.isEmpty { cacLoai.insert("sk_\(maSach)") }
            }
            self.taoVaTaiAnhBaoCaoBot(cacLoai: cacLoai, dl: dl, ngayBaoCao: ngay, maLanTao: maLanTao) { [weak self] thanhCong in
                guard let self, self.maLanTaoAnhBot == maLanTao else { return }
                if thanhCong { self.khoaAnhBotDaTai = khoa }
            }
        }
        congViecTaoAnhBot = congViec
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: congViec)
    }

    private func taoVaTaiAnhBaoCaoBot(
        cacLoai: Set<String>,
        dl: DuLieuNgayDMX,
        ngayBaoCao: Date,
        maLanTao: UUID,
        hoanTat: @escaping (Bool) -> Void
    ) {
        let ngay = dl.khoaNgay
        let doanhThuLuyKeHienThi = doanhThuHienThi(dl.doanhThu, cheDo: .luyKe)
        let doanhThuRealtimeHienThi = doanhThuHienThi(dl.doanhThuRealtime, cheDo: .realtime)
        // Dùng các view riêng để dựng ảnh. Không thay đổi bảng đang hiển thị khi
        // người dùng chuyển mục trong lúc ảnh báo cáo được tạo ngầm.
        let bangThiDuaXuat = BangThiDuaView()
        let bangNhanVienXuat = BangNhanVienView()
        let bangRealtimeXuat = BangTongHopRealtimeThangView()
        let anhLuyKeThuong: () -> UIImage? = {
            return bangThiDuaXuat.taoAnhBaoCao(
                ngay: ngayBaoCao, doanhThu: doanhThuLuyKeHienThi, danhSach: dl.danhSachThiDua,
                cheDoDoanhThu: .luyKe, xemDuKien: false,
                thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
            )
        }
        let anhLuyKeDuKien: () -> UIImage? = {
            return bangThiDuaXuat.taoAnhBaoCao(
                ngay: ngayBaoCao, doanhThu: doanhThuLuyKeHienThi, danhSach: dl.danhSachThiDua,
                cheDoDoanhThu: .luyKe, xemDuKien: true,
                thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
            )
        }

        let danhSachLoai = Array(cacLoai).sorted()
        func taoAnh(_ loai: String) -> UIImage? {
            switch loai {
            case "luyke_du_kien":
                return anhLuyKeDuKien()
            case "doanhthu_thidua_luyke":
                return anhLuyKeThuong()
            case "doanhthu_thidua_realtime":
                return bangThiDuaXuat.taoAnhBaoCao(
                    ngay: ngayBaoCao, doanhThu: doanhThuRealtimeHienThi, danhSach: dl.danhSachThiDuaRealtime,
                    cheDoDoanhThu: .realtime, xemDuKien: false,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "xep_hang_nv_luyke":
                bangNhanVienXuat.capNhat(cho: ngayBaoCao, cheDo: .luyKe)
                return bangNhanVienXuat.taoAnhBaoCaoNhanVien(
                    ngay: ngayBaoCao, cheDo: .luyKe,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "xep_hang_nv_realtime":
                bangNhanVienXuat.capNhat(cho: ngayBaoCao, cheDo: .realtime)
                return bangNhanVienXuat.taoAnhBaoCaoNhanVien(
                    ngay: ngayBaoCao, cheDo: .realtime,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "bieu_do_suc_khoe_nv":
                bangRealtimeXuat.capNhat(cho: ngayBaoCao)
                return bangRealtimeXuat.taoAnhBaoCaoSucKhoeNhanVien(
                    ngay: ngayBaoCao, thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "bieu_do_realtime_thang":
                bangRealtimeXuat.capNhat(cho: ngayBaoCao)
                return bangRealtimeXuat.taoAnhBaoCaoRealtimeThang(
                    ngay: ngayBaoCao, thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "chi_tiet_nhan_vien":
                return ManHinhChiTietNhanVien.taoAnhGopTatCaSucKhoe(cho: ngayBaoCao, cheDo: .luyKe)
            default:
                if loai.hasPrefix("sk_") {
                    let maNV = String(loai.dropFirst(3)).lowercased()
                    let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayBaoCao, sapXep: .tenAZ, cheDo: .luyKe)
                    if let chon = dsNV.first(where: { $0.nhanVien.maNV.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == maNV }) {
                        return BangThongSoSucKhoeNhanVienView.taoAnhBaoCao(cho: chon, ngay: ngayBaoCao, cheDo: .luyKe)
                    }
                }
                return nil
            }
        }

        // Chỉ giữ một ảnh lớn trong RAM: vẽ -> nén/tải -> giải phóng -> ảnh kế tiếp.
        // Cách cũ gom đủ 8 UIImage rồi mới tải, rất dễ bị iOS đóng app do áp lực bộ nhớ
        // đúng lúc người dùng chuyển nhanh giữa các bảng và biểu đồ.
        func taoTiep(_ viTri: Int) {
            guard self.maLanTaoAnhBot == maLanTao else { return }
            guard viTri < danhSachLoai.count else { hoanTat(true); return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) { [weak self] in
                guard let self, self.maLanTaoAnhBot == maLanTao else { return }
                let loai = danhSachLoai[viTri]
                let anh = autoreleasepool { taoAnh(loai) }
                guard let anh else {
                    taoTiep(viTri + 1)
                    return
                }
                DichVuAnhBaoCaoBot.dungChung.taiAnh(anh, loai: loai, ngay: ngay) { [weak self] ketQua in
                    guard let self, self.maLanTaoAnhBot == maLanTao else { return }
                    guard case .success = ketQua else { hoanTat(false); return }
                    taoTiep(viTri + 1)
                }
            }
        }
        taoTiep(0)
    }

    @objc private func bamXuatTatCaAnhLenServerSupabase() {
        xuatTatCaAnhLenServerSupabase()
    }

    @objc private func bamTaiRiengAnhNhanVienLenServer() {
        xuatTatCaAnhLenServerSupabase(chiAnhNhanVien: true)
    }

    /// Tách ảnh báo cáo chung và ảnh từng nhân viên thành hai đợt tải độc lập.
    private func xuatTatCaAnhLenServerSupabase(chiAnhNhanVien: Bool = false) {
        guard DichVuDongBo.dungChung.daDangNhap else {
            let tb = UIAlertController(
                title: "Chưa đăng nhập Server",
                message: "Vui lòng đăng nhập tài khoản đồng bộ trước khi xuất tất cả ảnh lên Server (Supabase).",
                preferredStyle: .alert
            )
            tb.addAction(UIAlertAction(title: "Đóng", style: .default))
            present(tb, animated: true)
            return
        }

        congViecTaoAnhBot?.cancel()
        maLanTaoAnhBot = UUID()
        let maLanXuat = maLanTaoAnhBot

        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let ngayBaoCao = ngayHienTai
        let ngay = dl.khoaNgay
        let doanhThuLuyKeHienThi = doanhThuHienThi(dl.doanhThu, cheDo: .luyKe)
        let doanhThuRealtimeHienThi = doanhThuHienThi(dl.doanhThuRealtime, cheDo: .realtime)

        let bangThiDuaXuat = BangThiDuaView()
        let bangNhanVienXuat = BangNhanVienView()
        let bangRealtimeXuat = BangTongHopRealtimeThangView()

        var danhSachMuc: [(ma: String, ten: String)] = []
        if chiAnhNhanVien {
            let dsNVQuanLy = KhoDuLieu.dungChung
                .tongHopNhanVien(den: ngayBaoCao, sapXep: .tenAZ, cheDo: .luyKe)
                .prefix(50)
            for itemNV in dsNVQuanLy {
                let maSach = itemNV.nhanVien.maNV.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if !maSach.isEmpty {
                    danhSachMuc.append(("sk_\(maSach)", "Sức khỏe NV \(itemNV.nhanVien.hoTen) (\(itemNV.nhanVien.maNV))"))
                }
            }
        } else {
            danhSachMuc = [
                ("doanhthu_thidua_luyke", "Bảng Thi đua Lũy kế"),
                ("luyke_du_kien", "Bảng Thi đua Lũy kế (% Dự kiến)"),
                ("doanhthu_thidua_realtime", "Bảng Thi đua Realtime"),
                ("xep_hang_nv_luyke", "Bảng Xếp hạng NV Lũy kế"),
                ("xep_hang_nv_realtime", "Bảng Xếp hạng NV Realtime"),
                ("bieu_do_suc_khoe_nv", "Biểu đồ Sức khỏe NV"),
                ("bieu_do_realtime_thang", "Biểu đồ Realtime Tháng")
            ]
        }

        guard !danhSachMuc.isEmpty else {
            let tb = UIAlertController(
                title: "Không có ảnh để tải",
                message: chiAnhNhanVien ? "Chưa có nhân viên hợp lệ để tạo ảnh." : "Chưa có dữ liệu báo cáo để tạo ảnh.",
                preferredStyle: .alert
            )
            tb.addAction(UIAlertAction(title: "Đóng", style: .default))
            present(tb, animated: true)
            return
        }

        func taoAnh(_ loai: String) -> UIImage? {
            switch loai {
            case "doanhthu_thidua_luyke":
                return bangThiDuaXuat.taoAnhBaoCao(
                    ngay: ngayBaoCao, doanhThu: doanhThuLuyKeHienThi, danhSach: dl.danhSachThiDua,
                    cheDoDoanhThu: .luyKe, xemDuKien: false,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "luyke_du_kien":
                return bangThiDuaXuat.taoAnhBaoCao(
                    ngay: ngayBaoCao, doanhThu: doanhThuLuyKeHienThi, danhSach: dl.danhSachThiDua,
                    cheDoDoanhThu: .luyKe, xemDuKien: true,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "doanhthu_thidua_realtime":
                return bangThiDuaXuat.taoAnhBaoCao(
                    ngay: ngayBaoCao, doanhThu: doanhThuRealtimeHienThi, danhSach: dl.danhSachThiDuaRealtime,
                    cheDoDoanhThu: .realtime, xemDuKien: false,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "xep_hang_nv_luyke":
                bangNhanVienXuat.capNhat(cho: ngayBaoCao, cheDo: .luyKe)
                return bangNhanVienXuat.taoAnhBaoCaoNhanVien(
                    ngay: ngayBaoCao, cheDo: .luyKe,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "xep_hang_nv_realtime":
                bangNhanVienXuat.capNhat(cho: ngayBaoCao, cheDo: .realtime)
                return bangNhanVienXuat.taoAnhBaoCaoNhanVien(
                    ngay: ngayBaoCao, cheDo: .realtime,
                    thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "bieu_do_suc_khoe_nv":
                bangRealtimeXuat.capNhat(cho: ngayBaoCao)
                return bangRealtimeXuat.taoAnhBaoCaoSucKhoeNhanVien(
                    ngay: ngayBaoCao, thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "bieu_do_realtime_thang":
                bangRealtimeXuat.capNhat(cho: ngayBaoCao)
                return bangRealtimeXuat.taoAnhBaoCaoRealtimeThang(
                    ngay: ngayBaoCao, thongTinDonVi: dl.thongTinDonVi, capNhatLuc: dl.capNhatLuc
                )
            case "chi_tiet_nhan_vien":
                return ManHinhChiTietNhanVien.taoAnhGopTatCaSucKhoe(cho: ngayBaoCao, cheDo: .luyKe)
            default:
                if loai.hasPrefix("sk_") {
                    let maNV = String(loai.dropFirst(3)).lowercased()
                    let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayBaoCao, sapXep: .tenAZ, cheDo: .luyKe)
                    if let chon = dsNV.first(where: { $0.nhanVien.maNV.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == maNV }) {
                        return BangThongSoSucKhoeNhanVienView.taoAnhBaoCao(cho: chon, ngay: ngayBaoCao, cheDo: .luyKe)
                    }
                }
                return nil
            }
        }

        let cauHinhKho = DichVuAnhBaoCaoBot.dungChung.cauHinh
        let tenKhoUuTien = cauHinhKho.tenKhoHieuLuc

        lopPhuTai.isHidden = false
        vongQuay.startAnimating()
        let tenNhomAnh = chiAnhNhanVien ? "ảnh từng nhân viên" : "ảnh báo cáo chung"
        nhanTienTrinh.text = "Đang chuẩn bị tải \(danhSachMuc.count) \(tenNhomAnh) lên \(tenKhoUuTien)..."

        var soThanhCong = 0
        var soLoi = 0
        var soDangTai = 0
        var soDaXuLy = 0
        var viTriTiepTheo = 0
        var thongBaoLoiCuoi: String?
        var soAnhTheoKho: [String: Int] = [:]
        let soLuongTaiDongThoi = 3

        func ketThucNeuDaXong() -> Bool {
            guard soDaXuLy >= danhSachMuc.count else { return false }
            guard self.maLanTaoAnhBot == maLanXuat else { return true }
            self.vongQuay.stopAnimating()
            self.lopPhuTai.isHidden = true
            let tieuDe: String
            let thongDiep: String
            let moTaKho = soAnhTheoKho
                .sorted { $0.key < $1.key }
                .map { "\($0.value) ảnh \($0.key)" }
                .joined(separator: ", ")
            if soThanhCong > 0 && soLoi == 0 {
                tieuDe = "Đã tải ảnh lên Server"
                thongDiep = "Đã tải và cập nhật thành công \(soThanhCong) \(tenNhomAnh) (\(moTaKho)); ảnh mới đã thay thế ảnh cũ."
            } else if soThanhCong > 0 {
                let chiTietLoi = thongBaoLoiCuoi ?? ""
                tieuDe = "Đã tải \(soThanhCong) ảnh lên Server"
                thongDiep = "Đã cập nhật \(soThanhCong) ảnh (\(moTaKho)); \(soLoi) ảnh lỗi: \(chiTietLoi)."
            } else {
                tieuDe = "Chưa tải được ảnh lên Server"
                thongDiep = thongBaoLoiCuoi ?? "Chưa có dữ liệu báo cáo để tạo ảnh hoặc kết nối máy chủ gặp sự cố."
            }
            let tb = UIAlertController(title: tieuDe, message: thongDiep, preferredStyle: .alert)
            tb.addAction(UIAlertAction(title: "Đóng", style: .default))
            self.present(tb, animated: true)
            return true
        }

        func capNhatTienTrinh() {
            self.nhanTienTrinh.text = "Đang tải \(tenNhomAnh) lên \(tenKhoUuTien): \(soDaXuLy)/\(danhSachMuc.count) hoàn tất, \(soDangTai) đang tải..."
        }

        func batDauThemAnhNeuCan() {
            guard self.maLanTaoAnhBot == maLanXuat else { return }
            if ketThucNeuDaXong() { return }

            while soDangTai < soLuongTaiDongThoi && viTriTiepTheo < danhSachMuc.count {
                let viTri = viTriTiepTheo
                let muc = danhSachMuc[viTri]
                viTriTiepTheo += 1
                soDangTai += 1
                capNhatTienTrinh()

                // Tạo ảnh vẫn thực hiện tuần tự trên main thread để UIKit ổn định,
                // nhưng upload mạng chạy đồng thời tối đa 3 ảnh.
                DispatchQueue.main.async { [weak self] in
                    guard let self, self.maLanTaoAnhBot == maLanXuat else { return }
                    let anh = autoreleasepool { taoAnh(muc.ma) }
                    guard let anh else {
                        soDangTai -= 1
                        soDaXuLy += 1
                        soLoi += 1
                        thongBaoLoiCuoi = "Không tạo được ảnh \(muc.ten)."
                        capNhatTienTrinh()
                        batDauThemAnhNeuCan()
                        return
                    }
                    DichVuAnhBaoCaoBot.dungChung.taiAnh(
                        anh, loai: muc.ma, ngay: ngay
                    ) { [weak self] ketQua in
                        guard let self, self.maLanTaoAnhBot == maLanXuat else { return }
                        soDangTai -= 1
                        soDaXuLy += 1
                        switch ketQua {
                        case .success(let khoDaDung):
                            soThanhCong += 1
                            soAnhTheoKho[khoDaDung, default: 0] += 1
                        case .failure(let err):
                            soLoi += 1
                            thongBaoLoiCuoi = "\(muc.ten): \(err.localizedDescription)"
                        }
                        capNhatTienTrinh()
                        batDauThemAnhNeuCan()
                    }
                }
            }
        }

        batDauThemAnhNeuCan()
    }

    private func capNhatNoiDungTheoMucDangChon(dl: DuLieuNgayDMX? = nil, dsThiDuaDangChon: [DongThiDua]? = nil) {
        var duLieu = dl ?? KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        duLieu.doanhThu = doanhThuHienThi(duLieu.doanhThu, cheDo: .luyKe)
        duLieu.doanhThuRealtime = doanhThuHienThi(duLieu.doanhThuRealtime, cheDo: .realtime)

        switch mucMenuChinh {
        case .tongQuan:
            capNhatMenuCaTongQuan()
            capNhatMenuNVTongQuan()
            let tapMaNVChon = layTapMaNVChonTongQuan()
            let ngayStr = TienIchNgay.hienThiNgay.string(from: ngayHienTai)
            let kho = KhoDuLieu.dungChung
            let khoaNgay = duLieu.khoaNgay
            let thang = String(khoaNgay.prefix(7))
            let lichSu = kho.layBanSaoAnToan().cacNgay
            let khoaLuyKe = lichSu.keys.filter { khoa in
                khoa.hasPrefix(thang) && khoa <= khoaNgay && lichSu[khoa]?.danhSachThiDua.isEmpty == false
            }.max()
            let ngayLuyKe = khoaLuyKe.flatMap { TienIchNgay.khoa.date(from: $0) }
            let danhSachLuyKe = ngayLuyKe.map { kho.duLieu(cho: $0).danhSachThiDua } ?? []
            let nganhLuyKe = danhSachLuyKe.filter { $0.target > 0 }
            let nganhRealtime = duLieu.danhSachThiDuaRealtime.filter { $0.target > 0 }
            let nhomTotLuyKe = nganhLuyKe.filter { $0.thucHien > 0 }.sorted { $0.phanTramHT > $1.phanTramHT }
            let nhomTotRealtime = nganhRealtime.filter { $0.thucHien > 0 }.sorted { $0.phanTramHT > $1.phanTramHT }
            let nhomKemLuyKe = nganhLuyKe.filter { $0.phanTramHT < 100 }.sorted { $0.phanTramHT < $1.phanTramHT }
            let khongCoNhomKem = nganhLuyKe.isEmpty ? "Chưa có target lũy kế" : "Tất cả nhóm có target đều đã đạt"

            var cacDongTongQuan: [String] = []
            if caTongQuanDangChon == .dauCa {
                let tatCaNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .doanhThuQD, cheDo: .luyKe)
                    .filter { tapMaNVChon.contains($0.nhanVien.maNV) }
                let huyHieuTop = ["🥇 TOP 1", "🥈 TOP 2", "🥉 TOP 3", "🏅 TOP 4", "🏅 TOP 5"]
                let topNV = tatCaNV.prefix(5).enumerated().map { viTri, item in
                    let nhanTop = viTri < huyHieuTop.count ? huyHieuTop[viTri] : "🏅 TOP \(viTri + 1)"
                    return "\(nhanTop): \(item.nhanVien.hoTen) – \(item.doanhThuQD.chuoiSoGonVN) QĐ · \(item.soLuongDon.chuoiSoGonVN) SL"
                }

                cacDongTongQuan = [
                    "📊 BÁO CÁO KINH DOANH NGÀY \(ngayStr)",
                    "━━━━━━━━━━━━━━━━━━",
                    "1. 💰 TÌNH HÌNH DOANH THU",
                    "",
                    "🔹 A. LŨY KẾ",
                    "• DT thực tế: \(duLieu.doanhThu.doanhThuThuc.chuoiSoGonVN) / Target: \(duLieu.doanhThu.targetThuc.chuoiSoGonVN)",
                    "• DT quy đổi: \(duLieu.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) / Target: \(duLieu.doanhThu.targetQuyDoi.chuoiSoGonVN)",
                    "• Dự kiến cuối tháng: \(duLieu.doanhThu.duKienQuyDoi.chuoiSoGonVN) (\(duLieu.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram) Target)",
                    "",
                    "📌 Chỉ số chung:",
                    "• Trả góp: \(duLieu.doanhThu.phanTramTraGop.chuoiPhanTram)",
                    "• Khách hàng: \(duLieu.doanhThu.luotKhach.chuoiSoGonVN)",
                    "• Tổng Bill: \(duLieu.doanhThu.soBill.chuoiSoGonVN)",
                    "━━━━━━━━━━━━━━━━━━",
                    "2. 🔥 NHÓM HÀNG BÁN TỐT",
                    "(Xếp hạng theo % Target)",
                    "",
                    "📍 LŨY KẾ:",
                    ""
                ]
                cacDongTongQuan.append(contentsOf: dongNhomHangTongQuan(
                    nhomTotLuyKe, rong: "Chưa có nhóm hàng có số bán và target",
                    doiChieu: nganhRealtime, nhanDoiChieu: "Realtime"
                ))
                cacDongTongQuan.append(contentsOf: [
                    "━━━━━━━━━━━━━━━━━━",
                    "3. ⚠️ NHÓM HÀNG BÁN KÉM",
                    "(Lũy kế dưới Target)",
                    ""
                ])
                cacDongTongQuan.append(contentsOf: dongNhomHangTongQuan(nhomKemLuyKe, rong: khongCoNhomKem))
                cacDongTongQuan.append(contentsOf: [
                    "━━━━━━━━━━━━━━━━━━",
                    "4. 🏆 TOP 5 NHÂN VIÊN BÁN TỐT",
                    ""
                ])
                cacDongTongQuan.append(contentsOf: topNV.isEmpty ? ["• Chưa có dữ liệu"] : topNV)
                cacDongTongQuan.append(contentsOf: [
                    "",
                    "━━━━━━━━━━━━━━━━━━",
                    "🔥 MỤC TIÊU: TĂNG TỐC DOANH THU – ĐẨY MẠNH NHÓM HÀNG – HOÀN THÀNH 100% TARGET!"
                ])
            } else {
                let dsNVRT = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .doanhThuQD, cheDo: .realtime)
                    .filter { tapMaNVChon.contains($0.nhanVien.maNV) }
                let coDuLieuNVRT = dsNVRT.contains { $0.doanhThuQD != 0 || $0.soLuongDon != 0 || $0.soMonDat > 0 }
                let nguonNV = coDuLieuNVRT
                    ? dsNVRT
                    : KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .doanhThuQD, cheDo: .luyKe)
                        .filter { tapMaNVChon.contains($0.nhanVien.maNV) }
                let kemNV = nguonNV.suffix(5).reversed().enumerated().map { viTri, item in
                    "✖️ TOP \(viTri + 1): \(item.nhanVien.hoTen) – \(item.doanhThuQD.chuoiSoGonVN) QĐ · \(item.soLuongDon.chuoiSoGonVN) SL"
                }
                let traGopRT = duLieu.doanhThuRealtime.phanTramTraGop > 0
                    ? duLieu.doanhThuRealtime.phanTramTraGop.chuoiPhanTram
                    : "0"

                cacDongTongQuan = [
                    "📊 BÁO CÁO KINH DOANH NGÀY \(ngayStr)",
                    "━━━━━━━━━━━━━━━━━━",
                    "",
                    "1. 💰 TÌNH HÌNH DOANH THU",
                    "",
                    "🔹  REALTIME",
                    "• DT thực tế: \(duLieu.doanhThuRealtime.doanhThuThuc.chuoiSoGonVN)",
                    "• DT quy đổi: \(duLieu.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN)",
                    "• Trả góp: \(traGopRT)",
                    "• Khách hàng: \(duLieu.doanhThuRealtime.luotKhach.chuoiSoGonVN)",
                    "• Tổng Bill: \(duLieu.doanhThuRealtime.soBill.chuoiSoGonVN)",
                    "📌 Chỉ số chung:",
                    "• Trả góp: \(duLieu.doanhThu.phanTramTraGop.chuoiPhanTram)",
                    "• Khách hàng: \(duLieu.doanhThu.luotKhach.chuoiSoGonVN)",
                    "• Tổng Bill: \(duLieu.doanhThu.soBill.chuoiSoGonVN)",
                    "━━━━━━━━━━━━━━━━━━",
                    "2. 🔥 NHÓM HÀNG BÁN TỐT",
                    "(Xếp hạng theo % Target)",
                    "",
                    "📍 REALTIME:"
                ]
                cacDongTongQuan.append(contentsOf: dongNhomHangTongQuan(
                    nhomTotRealtime, rong: "Chưa có nhóm hàng có số bán và target",
                    doiChieu: nganhLuyKe, nhanDoiChieu: "Lũy kế"
                ))
                cacDongTongQuan.append(contentsOf: [
                    "━━━━━━━━━━━━━━━━━━",
                    "3. ⚠️ NHÓM HÀNG BÁN KÉM",
                    "(Lũy kế dưới Target)",
                    ""
                ])
                cacDongTongQuan.append(contentsOf: dongNhomHangTongQuan(nhomKemLuyKe, rong: khongCoNhomKem))
                cacDongTongQuan.append(contentsOf: [
                    "━━━━━━━━━━━━━━━━━━",
                    "4. 🆘 TOP 5 NHÂN VIÊN YẾU",
                    ""
                ])
                cacDongTongQuan.append(contentsOf: kemNV.isEmpty ? ["• Chưa có dữ liệu"] : kemNV)
                cacDongTongQuan.append(contentsOf: [
                    "",
                    "━━━━━━━━━━━━━━━━━━",
                    "🔥 MỤC TIÊU: TĂNG TỐC DOANH THU – ĐẨY MẠNH NHÓM HÀNG – HOÀN THÀNH min 120% TARGET!"
                ])
            }
            nhanTomTatTongQuan.text = cacDongTongQuan.joined(separator: "\n")

        case .baoCao:
            manHinhBanTinNhung.capNhatNgay(ngayHienTai)

        case .doSoXemSo:
            switch mucConDoSo {
            case .xemSo:
                switch tabXemSo {
                case .luyKe, .realtime:
                    let ds = dsThiDuaDangChon ?? duLieu.danhSachThiDua(theo: cheDoDoanhThu)
                    let kho = KhoDuLieu.dungChung
                    let kieuHienTai = kho.caiDat.kieuHienThi
                    if phienBanThiDuaDaNapUI != kho.phienBanDuLieu ||
                       khoaNgayThiDuaDaNapUI != duLieu.khoaNgay ||
                       cheDoThiDuaDaNapUI != cheDoDoanhThu ||
                       kieuHienThiDaNapUI != kieuHienTai {
                        phienBanThiDuaDaNapUI = kho.phienBanDuLieu
                        khoaNgayThiDuaDaNapUI = duLieu.khoaNgay
                        dsThiDuaDaNapUI = ds
                        cheDoThiDuaDaNapUI = cheDoDoanhThu
                        kieuHienThiDaNapUI = kieuHienTai
                        bangThiDua.ganDanhSach(ds, cheDo: cheDoDoanhThu)
                    }
                case .nhanVien:
                    bangNhanVien.capNhat(cho: ngayHienTai, cheDo: cheDoDoanhThu)
                case .bieuDo:
                    bangRealtimeThang.hienThiBieuDoRealtime()
                    bangRealtimeThang.capNhat(cho: ngayHienTai)
                case .tonKho:
                    khungTonKho.kichHoatNeuCan()
                }

            case .nhapSo:
                let ngayStr = TienIchNgay.hienThiNgay.string(from: ngayHienTai)
                let ttLK = duLieu.doanhThu.coDuLieu ? "Đã có (\(duLieu.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) tr QĐ)" : "Chưa nhập"
                let ttRT = duLieu.doanhThuRealtime.coDuLieu ? "Đã có (\(duLieu.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN) tr QĐ)" : "Chưa nhập"
                nhanTrangThaiNhapSo.text = [
                    "📅 TRẠNG THÁI DỮ LIỆU NGÀY \(ngayStr):",
                    "• Lũy kế: Doanh thu [\(ttLK)] · Thi đua [\(duLieu.danhSachThiDua.count) ngành] · Doanh thu NV [\(duLieu.doanhThuNhanVien.count) NV]",
                    "• Realtime: Doanh thu [\(ttRT)] · Thi đua [\(duLieu.danhSachThiDuaRealtime.count) ngành] · Doanh thu NV [\(duLieu.doanhThuNhanVienRealtime.count) NV]"
                ].joined(separator: "\n")

            case .xuatAnh:
                capNhatGiaoDienKhungXuatAnh(taoMoiVanBan: false)
            }

        case .caiDat, .taiKhoanHopThu:
            manHinhCaiDatNhung.capNhatNgay(ngayHienTai)

        case .quanTri:
            break

        case .nhanVien:
            if tabXemSo == .bieuDo {
                bangRealtimeThang.hienThiRieng(.sucKhoeNhanVien)
                bangRealtimeThang.capNhat(cho: ngayHienTai)
            } else {
                tabXemSo = .nhanVien
                bangNhanVien.capNhat(cho: ngayHienTai, cheDo: cheDoDoanhThu)
            }

        case .tonKho:
            tabXemSo = .tonKho
            khungTonKho.kichHoatNeuCan()

        case .trinhDuyet:
            manHinhTrinhDuyetNhung.capNhatNgay(ngayHienTai)

        default:
            capNhatNoiDungMucMoRong(mucMenuChinh)
        }
    }

    private func capNhatTrangThaiMuc() {
        if mucMenuChinh == .doSoXemSo || mucMenuChinh == .nhanVien || mucMenuChinh == .tonKho { mucConDoSo = .xemSo }
        menuBenTrai.capNhatTrangThai(mucChinh: mucMenuChinh, mucCon: mucConDoSo)

        let tieuDeNutMenu: String
        tieuDeNutMenu = " \(mucMenuChinh.tieuDe)"
        nutMoMenu.setTitle(tieuDeNutMenu, for: .normal)

        let hienNutTrenNav = (mucMenuChinh == .doSoXemSo || mucMenuChinh == .tongQuan || mucMenuChinh == .nhanVien || mucMenuChinh == .baoCao || mucMenuChinh == .lichDoSo)
        nutNgay.isHidden = !hienNutTrenNav
        nutNhapTatCa.isHidden = (mucMenuChinh != .doSoXemSo)
        nutXuatNav.isHidden = (mucMenuChinh != .doSoXemSo && mucMenuChinh != .nhanVien)
        // Tab Nhân viên đã có nút xoá riêng theo đúng ngữ cảnh dữ liệu,
        // không hiện thêm nút xoá tổng trên thanh điều hướng.
        nutXoaNav.isHidden = (mucMenuChinh != .doSoXemSo)
        nutCopyTongQuanNav.isHidden = (mucMenuChinh != .tongQuan)
        nutQuanLyNhanVienNav.isHidden = (mucMenuChinh != .nhanVien)
        nutXuatAnhTonKhoNav.isHidden = (mucMenuChinh != .tonKho)

        let laCaiDat = (mucMenuChinh == .caiDat || mucMenuChinh == .taiKhoanHopThu)
        let laManHinhNhanVien = (mucMenuChinh == .nhanVien)
        let laManHinhTonKho = (mucMenuChinh == .tonKho)
        khungDoSoXemSo.isHidden = (mucMenuChinh != .doSoXemSo && !laManHinhNhanVien && !laManHinhTonKho)
        khungTongQuan.isHidden = (mucMenuChinh != .tongQuan)
        khungBaoCao.isHidden = (mucMenuChinh != .baoCao)
        khungTaiKhoanHopThu.isHidden = !laCaiDat
        khungQuanTri.isHidden = (mucMenuChinh != .quanTri)
        khungTrinhDuyet.isHidden = (mucMenuChinh != .trinhDuyet)
        khungMucMoRong.isHidden = (mucMenuChinh == .doSoXemSo || laManHinhNhanVien || laManHinhTonKho || mucMenuChinh == .tongQuan || mucMenuChinh == .baoCao || laCaiDat || mucMenuChinh == .quanTri || mucMenuChinh == .trinhDuyet)

        guard mucMenuChinh == .doSoXemSo || laManHinhNhanVien || laManHinhTonKho else { return }

        capNhatNutTabXemSo(choNhanVien: laManHinhNhanVien)

        // Highlight 3 nút mục con: 1. Xem số | 2. Nhập số | 3. Xuất ảnh
        for nut in cacNutMucConDoSo {
            let dangChon = (nut.tag == mucConDoSo.rawValue)
            if dangChon {
                nut.backgroundColor = BangMauBCTD.vangSang
                nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
                nut.layer.borderWidth = 1.2
                nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
            } else {
                nut.backgroundColor = .clear
                nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                nut.layer.borderWidth = 0
                nut.layer.borderColor = UIColor.clear.cgColor
            }
        }

        khungXemSo.isHidden = (mucConDoSo != .xemSo)
        khungNhapSo.isHidden = (mucConDoSo != .nhapSo)
        khungXuatAnh.isHidden = (mucConDoSo != .xuatAnh)

        guard mucConDoSo == .xemSo else { return }

        // Highlight 4 tab bên trong "1. Xem số": Lũy kế | Realtime | Biểu đồ | Nhân viên
        for nut in cacNutTabXemSo {
            let dangChon = (nut.tag == tabXemSo.rawValue)
            if dangChon {
                nut.backgroundColor = BangMauBCTD.xanhChuDao
                nut.setTitleColor(.white, for: .normal)
                nut.layer.shadowColor = BangMauBCTD.xanhChuDaoDam.cgColor
                nut.layer.shadowOpacity = 0.28
                nut.layer.shadowRadius = 4
                nut.layer.shadowOffset = CGSize(width: 0, height: 2)
            } else {
                nut.backgroundColor = .clear
                nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                nut.layer.shadowOpacity = 0
            }
        }

        nhanTieuDeCumDoanhThu.text = (cheDoDoanhThu == .luyKe)
            ? "CHỈ SỐ KINH DOANH · LŨY KẾ THÁNG"
            : "CHỈ SỐ KINH DOANH · REALTIME HÔM NAY"

        let laThiDua = (tabXemSo == .luyKe || tabXemSo == .realtime)
        let laNhanVien = (tabXemSo == .nhanVien)
        let laBieuDo = (tabXemSo == .bieuDo)
        let laTonKho = (tabXemSo == .tonKho)
        let anCumDoanhThu = laBieuDo || laNhanVien || laTonKho

        khungThanhTabXemSo.isHidden = laTonKho
        khungCumDoanhThu.isHidden = anCumDoanhThu
        vachNganHaiCum.isHidden = true
        rangBuocTopKhungDuoiTheoVach?.isActive = !anCumDoanhThu
        rangBuocTopKhungDuoiTheoDinh?.isActive = (anCumDoanhThu && !laTonKho)
        rangBuocTopKhungDuoiTheoDinhXemSo?.isActive = laTonKho

        hangChonCheDoNV.isHidden = !laNhanVien
        hangNutQuet.isHidden = !laNhanVien

        for (nut, loai) in [(nutNVLuyKe, LoaiCheDoDoanhThu.luyKe), (nutNVRealtime, LoaiCheDoDoanhThu.realtime)] {
            if cheDoDoanhThu == loai {
                nut.backgroundColor = BangMauBCTD.vangSang
                nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
            } else {
                nut.backgroundColor = BangMauBCTD.nenThePhu
                nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            }
        }

        if laNhanVien {
            rangBuocTopNutQuetTheoDinh?.isActive = false
            rangBuocTopNutQuetTheoNV?.isActive = true
        } else {
            rangBuocTopNutQuetTheoNV?.isActive = false
            rangBuocTopNutQuetTheoDinh?.isActive = true
        }

        let nhanCheDo = cheDoDoanhThu.tieuDe
        if laNhanVien {
            nutThemAnhMoi.isHidden = false
            nutThemAnhMoi.setTitle(" Nhập dữ liệu Nhân viên (\(nhanCheDo))", for: .normal)
            nutNhapDoanhThuNV.isHidden = true
            nutNhapGioCongNV.isHidden = true
            rangBuocBangRongHaiNutNV?.isActive = false
        } else {
            nutThemAnhMoi.isHidden = false
            nutThemAnhMoi.setTitle(" Thêm ảnh Thi đua (\(nhanCheDo))", for: .normal)
            nutNhapDoanhThuNV.isHidden = true
            nutNhapGioCongNV.isHidden = true
            rangBuocBangRongHaiNutNV?.isActive = false
        }

        bangThiDua.isHidden = !laThiDua
        bangNhanVien.isHidden = !laNhanVien
        bangRealtimeThang.isHidden = !laBieuDo
        khungTonKho.isHidden = !laTonKho

        nutThemThuCong.isHidden = !laThiDua
        nutThemThuCong.setTitle(" Nhập/Mẫu", for: .normal)
    }

    private func capNhatNoiDungMucMoRong(_ muc: MucMenuChinh) {
        let laXuatFile = muc == .xuatFileBaoCao
        bieuTuongMucMoRong.isHidden = laXuatFile
        nhanTieuDeMucMoRong.isHidden = laXuatFile
        // Giữ nội dung đang sửa và vị trí cuộn khi dữ liệu nền vừa đồng bộ.
        if laXuatFile, oCauLenhXuatFile.superview === nganHanhDongMucMoRong { return }
        let cfg = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold)
        bieuTuongMucMoRong.image = UIImage(systemName: muc.bieuTuongSF, withConfiguration: cfg)
        nhanTieuDeMucMoRong.text = muc.tieuDe.uppercased()

        nganHanhDongMucMoRong.arrangedSubviews.forEach {
            nganHanhDongMucMoRong.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        switch muc {
        case .guiBaoCao:
            nhanMoTaMucMoRong.text = "Chọn nhóm LINE, giờ gửi, ngày gửi và các báo cáo cần gửi tự động. Mỗi nhóm chỉ đọc dữ liệu mới nhất của đúng tài khoản DMX đã gắn."
            nganHanhDongMucMoRong.addArrangedSubview(bangGuiBaoCao)
            bangGuiBaoCao.napDuLieu()

        case .lichDoSo:
            let ngayStr = TienIchNgay.hienThiNgay.string(from: ngayHienTai)
            nhanMoTaMucMoRong.text = "Quản lý lịch sử ngày đổ số và theo dõi tiến độ dữ liệu theo từng ngày trong tháng.\nNgày đang chọn: \(ngayStr)."
            nganHanhDongMucMoRong.addArrangedSubview(taoNutHanhDongMoRong("📅 Chọn ngày xem / đổ số báo cáo", action: #selector(moLichSuNgay)))
            nganHanhDongMucMoRong.addArrangedSubview(taoNutHanhDongMoRong("📈 Mở Biểu đồ & Tổng hợp Realtime tháng", action: #selector(moNhanhBieuDoTuMucMoRong)))

        case .xuatFileBaoCao:
            nhanMoTaMucMoRong.text = "Chọn nội dung và loại file. Ứng dụng sẽ tự sinh câu lệnh, copy vào clipboard và xuất đúng ảnh dữ liệu để gửi sang ứng dụng AI khác."
            cauHinhKhuVucXuatFileBaoCao()
            nganHanhDongMucMoRong.addArrangedSubview(nutChonNoiDungXuatFile)
            nganHanhDongMucMoRong.addArrangedSubview(nutChonDinhDangFile)
            nganHanhDongMucMoRong.addArrangedSubview(oCauLenhXuatFile)
            nganHanhDongMucMoRong.addArrangedSubview(taoNutHanhDongMoRong("📋 Copy câu lệnh & Xuất ảnh dữ liệu", action: #selector(bamCopyVaXuatAnhTaoFile)))

        case .nhanVien:
            break

        case .ketNoi:
            let tk = DichVuDongBo.dungChung.tenDangNhap.isEmpty ? "Chưa đăng nhập" : DichVuDongBo.dungChung.tenDangNhap
            nhanMoTaMucMoRong.text = "Trạng thái kết nối đồng bộ đám mây trực tiếp qua Supabase & Cloudflare Bot.\nTài khoản hiện tại: \(tk)."
            nganHanhDongMucMoRong.addArrangedSubview(taoNutHanhDongMoRong("🔄 Đồng bộ dữ liệu đám mây ngay", action: #selector(dongBoDamMayTuMucMoRong)))

        default:
            nhanMoTaMucMoRong.text = "Mục \"\(muc.tieuDe)\" đã sẵn sàng phục vụ quản lý siêu thị."
            nganHanhDongMucMoRong.addArrangedSubview(taoNutHanhDongMoRong("📊 Quay lại Đổ số - Xem số", action: #selector(quayLaiDoSoXemSo)))
        }
    }

    private func taoNutHanhDongMoRong(_ tieuDe: String, action: Selector) -> UIButton {
        let nut = UIButton(type: .system)
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nut.titleLabel?.numberOfLines = 0
        nut.titleLabel?.lineBreakMode = .byWordWrapping
        nut.titleLabel?.textAlignment = .center
        nut.titleLabel?.adjustsFontSizeToFitWidth = false
        nut.backgroundColor = BangMauBCTD.xanhChuDao
        nut.tintColor = .white
        nut.setTitleColor(.white, for: .normal)
        nut.layer.cornerRadius = 10
        nut.contentEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
        nut.addTarget(self, action: action, for: .touchUpInside)
        return nut
    }

    private func cauHinhKhuVucXuatFileBaoCao() {
        func cauHinhCombo(_ nut: UIButton) {
            nut.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.contentHorizontalAlignment = .left
            nut.backgroundColor = BangMauBCTD.nenThePhu
            nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
            nut.layer.cornerRadius = 10
            nut.layer.borderWidth = 1
            nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            nut.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
            nut.showsMenuAsPrimaryAction = true
        }
        cauHinhCombo(nutChonNoiDungXuatFile)
        cauHinhCombo(nutChonDinhDangFile)

        let cacNoiDung = LoaiBaoCaoXuatAnh.allCases.map { loai in
            UIAction(title: loai.tieuDeNgan, state: loai == noiDungXuatFileDangChon ? .on : .off) { [weak self] _ in
                self?.noiDungXuatFileDangChon = loai
                self?.cauHinhKhuVucXuatFileBaoCao()
            }
        }
        nutChonNoiDungXuatFile.menu = UIMenu(title: "Nội dung xuất báo cáo", children: cacNoiDung)
        nutChonNoiDungXuatFile.setTitle("Nội dung: \(noiDungXuatFileDangChon.tieuDeNgan) ▾", for: .normal)

        let cacDinhDang = DinhDangFileBaoCao.allCases.map { dinhDang in
            UIAction(title: dinhDang.rawValue, state: dinhDang == dinhDangFileDangChon ? .on : .off) { [weak self] _ in
                self?.dinhDangFileDangChon = dinhDang
                self?.cauHinhKhuVucXuatFileBaoCao()
            }
        }
        nutChonDinhDangFile.menu = UIMenu(title: "Loại file cần tạo", children: cacDinhDang)
        nutChonDinhDangFile.setTitle("Loại file: \(dinhDangFileDangChon.rawValue) ▾", for: .normal)

        oCauLenhXuatFile.font = .systemFont(ofSize: 13.5)
        oCauLenhXuatFile.textColor = BangMauBCTD.chuChinh
        oCauLenhXuatFile.backgroundColor = BangMauBCTD.nenThePhu
        oCauLenhXuatFile.layer.cornerRadius = 10
        oCauLenhXuatFile.layer.borderWidth = 1
        oCauLenhXuatFile.layer.borderColor = BangMauBCTD.vienDam.cgColor
        oCauLenhXuatFile.isScrollEnabled = false
        oCauLenhXuatFile.delegate = self
        if oCauLenhXuatFile.inputAccessoryView == nil {
            let thanh = UIToolbar()
            thanh.sizeToFit()
            thanh.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(anBanPhimXuatFile))
            ]
            oCauLenhXuatFile.inputAccessoryView = thanh
        }
        if rangBuocCaoOCauLenhXuatFile == nil {
            let rangBuoc = oCauLenhXuatFile.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
            rangBuoc.isActive = true
            rangBuocCaoOCauLenhXuatFile = rangBuoc
        }
        oCauLenhXuatFile.text = taoCauLenhXuatFile()
    }

    private func taoCauLenhXuatFile() -> String {
        let yeuCauDinhDang: String
        switch dinhDangFileDangChon {
        case .excel:
            yeuCauDinhDang = "Hãy tạo file Excel (.xlsx) có bảng dữ liệu rõ ràng, định dạng số/phần trăm đúng, bộ lọc, tổng hợp và biểu đồ phù hợp."
        case .powerPoint:
            yeuCauDinhDang = "Hãy tạo file PowerPoint (.pptx) trình bày chuyên nghiệp, chữ dễ đọc, có bảng hoặc biểu đồ phù hợp và trang kết luận hành động."
        }
        return """
        Tôi gửi kèm một ảnh báo cáo: \(noiDungXuatFileDangChon.tieuDeNgan).
        \(yeuCauDinhDang)
        Hãy đọc toàn bộ số liệu trực tiếp từ ảnh, giữ nguyên tên ngành hàng/nhân viên, số âm, số 0, số thập phân và phần trăm. Không tự bịa hoặc thay đổi số liệu. Nếu ô nào không đọc rõ, hãy đánh dấu cần kiểm tra thay vì suy đoán. Khi hoàn tất, cung cấp file \(dinhDangFileDangChon.rawValue) để tải xuống.
        """
    }

    @objc private func bamCopyVaXuatAnhTaoFile() {
        anBanPhimXuatFile()
        let cauLenh = oCauLenhXuatFile.text.trimmingCharacters(in: .whitespacesAndNewlines)
        UIPasteboard.general.string = cauLenh.isEmpty ? taoCauLenhXuatFile() : cauLenh
        guard let anh = taoAnhTheoLoaiBaoCao(noiDungXuatFileDangChon) else {
            let tb = UIAlertController(title: "Chưa xuất được ảnh", message: "Không có đủ dữ liệu để tạo ảnh đã chọn. Câu lệnh vẫn được copy vào clipboard.", preferredStyle: .alert)
            tb.addAction(UIAlertAction(title: "Đóng", style: .default))
            present(tb, animated: true)
            return
        }
        chiaSe([anh])
    }

    @objc private func moNhanhBieuDoTuMucMoRong() {
        mucMenuChinh = .doSoXemSo
        mucConDoSo = .xemSo
        tabXemSo = .bieuDo
        napDuLieu()
    }

    @objc private func moNhanVienTuMenu() {
        mucMenuChinh = .doSoXemSo
        mucConDoSo = .xemSo
        tabXemSo = .nhanVien
        napDuLieu()
    }

    @objc private func moSucKhoeNhanVienTuMenu() {
        mucMenuChinh = .doSoXemSo
        mucConDoSo = .xemSo
        tabXemSo = .bieuDo
        napDuLieu()
        bangRealtimeThang.hienThiRieng(.sucKhoeNhanVien)
    }

    /// Mở mục Báo cáo & Phân tích AI Gemini
    @objc private func moBanTin() {
        mucMenuChinh = .baoCao
        napDuLieu()
    }

    private func taoAnhBangChoBanTin(khung: KhungBanTin, soLieu: SoLieuBanTin) -> [UIImage] {
        let anh: UIImage?
        switch khung {
        case .dauCa:
            guard soLieu.coSoLieuLuyKe else { return [] }
            anh = bangThiDua.taoAnhBaoCao(
                ngay: soLieu.ngay,
                doanhThu: doanhThuHienThi(soLieu.luyKe, cheDo: .luyKe),
                danhSach: soLieu.dsLuyKe,
                cheDoDoanhThu: .luyKe,
                xemDuKien: true,
                thongTinDonVi: soLieu.tenDonVi,
                capNhatLuc: soLieu.capNhatLuc
            )
        case .hienTai, .ketCa:
            if soLieu.coSoLieuHomNay {
                anh = bangThiDua.taoAnhBaoCao(
                    ngay: soLieu.ngay,
                    doanhThu: doanhThuHienThi(soLieu.homNay, cheDo: .realtime),
                    danhSach: soLieu.dsHomNay,
                    cheDoDoanhThu: .realtime,
                    xemDuKien: false,
                    thongTinDonVi: soLieu.tenDonVi,
                    capNhatLuc: soLieu.capNhatLuc
                )
            } else if soLieu.coSoLieuLuyKe {
                anh = bangThiDua.taoAnhBaoCao(
                    ngay: soLieu.ngay,
                    doanhThu: doanhThuHienThi(soLieu.luyKe, cheDo: .luyKe),
                    danhSach: soLieu.dsLuyKe,
                    cheDoDoanhThu: .luyKe,
                    xemDuKien: false,
                    thongTinDonVi: soLieu.tenDonVi,
                    capNhatLuc: soLieu.capNhatLuc
                )
            } else {
                anh = nil
            }
        }
        if let anh = anh { return [anh] }
        return []
    }

    @objc private func moNhanhChiaTarget() {
        navigationController?.pushViewController(ManHinhChiaTarget(ngay: ngayHienTai), animated: true)
    }

    @objc private func moNhanhQuanLyNV() {
        navigationController?.pushViewController(ManHinhQuanLyNhanVien(), animated: true)
    }

    @objc private func dongBoDamMayTuMucMoRong() {
        DichVuDongBo.dungChung.taiDuLieu()
    }

    @objc private func quayLaiDoSoXemSo() {
        mucMenuChinh = .doSoXemSo
        mucConDoSo = .xemSo
        napDuLieu()
    }

    // MARK: - Nút Nhập ảnh & Xoá

    @objc private func bamThemAnhMoi() {
        switch tabXemSo {
        case .luyKe, .realtime:
            moHuongDanQuetAnhThiDua()
        case .nhanVien:
            moMenuNhapDuLieuNhanVien()
        case .bieuDo:
            moChonAnh(cheDo: .doanhThu(.realtime), gioiHan: 2)
        case .tonKho:
            khungTonKho.kichHoatNeuCan()
        }
    }

    private func moMenuNhapDuLieuNhanVien() {
        let cheDo = cheDoDoanhThu
        let tenCheDo = cheDo.tieuDe
        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "📥 Nhập tất cả ảnh \(tenCheDo)") { [weak self] in
                self?.moChonAnh(cheDo: .tatCaAnhTheoTab(cheDo), gioiHan: 0)
            }
        ]
        if cheDo == .luyKe {
            cacMuc.append(MucChonDMX(tieuDe: "👥 Ảnh Ma trận Thi đua Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .thiDuaNhanVien(.luyKe), gioiHan: 0)
            })
            cacMuc.append(MucChonDMX(tieuDe: "💰 Ảnh Bảng Doanh thu Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .doanhThuNhanVien(.luyKe), gioiHan: 0)
            })
            cacMuc.append(MucChonDMX(tieuDe: "⏱️ Ảnh Bảng Giờ công Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .gioCongNhanVien(.luyKe), gioiHan: 0)
            })
            cacMuc.append(MucChonDMX(tieuDe: "🎯 Chia target mặt hàng cho nhân viên") { [weak self] in
                self?.moNhanhChiaTarget()
            })
        } else {
            cacMuc.append(MucChonDMX(tieuDe: "💰 Ảnh Bảng Doanh thu Nhân viên Realtime") { [weak self] in
                self?.moChonAnh(cheDo: .doanhThuNhanVien(.realtime), gioiHan: 0)
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "👤 Danh sách nhân viên quản lý") { [weak self] in
            self?.moNhanhQuanLyNV()
        })
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(
            tieuDe: "Nhập dữ liệu Nhân viên \(tenCheDo)",
            cacMuc: cacMuc
        )
    }

    @objc private func bamNhapAnhDoanhThuNV() {
        moChonAnh(cheDo: .doanhThuNhanVien(cheDoDoanhThu), gioiHan: 0)
    }

    @objc private func bamNhapAnhGioCongNV() {
        moChonAnh(cheDo: .gioCongNhanVien(.luyKe), gioiHan: 0)
    }

    private func moHuongDanQuetAnhThiDua(cheDo: LoaiCheDoDoanhThu? = nil) {
        let cheDoMucTieu = cheDo ?? cheDoDoanhThu
        if cheDoDoanhThu != cheDoMucTieu {
            cheDoDoanhThu = cheDoMucTieu
            napDuLieu()
        }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dsHienTai = dl.danhSachThiDua(theo: cheDoMucTieu)
        let tenCheDo = cheDoMucTieu.tieuDe
        let cheDoKhac: LoaiCheDoDoanhThu = (cheDoMucTieu == .luyKe) ? .realtime : .luyKe
        let bieuTuongKhac = (cheDoKhac == .luyKe) ? "📊" : "⚡"

        if dsHienTai.isEmpty {
            thayTheBangThiDuaKhiQuet = false
            moChonAnh(cheDo: .thiDua(cheDoMucTieu), gioiHan: 0)
            return
        }

        hienMenuChon(
            tieuDe: "Nhập ảnh Thi đua (\(tenCheDo))",
            cacMuc: [
                MucChonDMX(tieuDe: "🖼️ Chọn ảnh từ Thư viện Ảnh") { [weak self] in
                    self?.thayTheBangThiDuaKhiQuet = false
                    self?.moThuVienAnh(cheDo: .thiDua(cheDoMucTieu), gioiHan: 0)
                },
                MucChonDMX(tieuDe: "📁 Nhập ảnh từ Tệp (Files)") { [weak self] in
                    self?.thayTheBangThiDuaKhiQuet = false
                    self?.moChonTepAnh(cheDo: .thiDua(cheDoMucTieu), gioiHan: 0)
                },
                MucChonDMX(tieuDe: "🔄 Quét mới & thay thế bảng \(tenCheDo)", kieu: .nguyHiem) { [weak self] in
                    self?.thayTheBangThiDuaKhiQuet = true
                    self?.moChonAnh(cheDo: .thiDua(cheDoMucTieu), gioiHan: 0)
                },
                MucChonDMX(tieuDe: "\(bieuTuongKhac) Chuyển sang nhập Thi đua \(cheDoKhac.tieuDe)") { [weak self] in
                    self?.moHuongDanQuetAnhThiDua(cheDo: cheDoKhac)
                },
                MucChonDMX(tieuDe: "Đóng", kieu: .huy)
            ]
        )
    }

    @objc private func bamXoaQuetLai() {
        let cheDoXoa = cheDoDoanhThu
        let tenCheDo = cheDoXoa.tieuDe

        if tabXemSo == .nhanVien {
            if cheDoXoa == .realtime {
                hienMenuChon(
                    tieuDe: "Xoá Doanh thu Nhân viên Realtime?",
                    thongDiep: "Sẽ xoá sạch bảng Doanh thu Nhân viên Realtime của ngày đang chọn:",
                    cacMuc: [
                        MucChonDMX(tieuDe: "🗑️ Xoá Doanh thu Nhân viên Realtime", kieu: .nguyHiem) { [weak self] in
                            guard let self = self else { return }
                            KhoDuLieu.dungChung.xoaDoanhThuNhanVienRealtime(cho: self.ngayHienTai)
                            self.dsThiDuaDaNapUI = nil
                            self.khoaCumChiSoDaNapUI = ""
                            self.napDuLieu()
                        },
                        MucChonDMX(tieuDe: "Huỷ", kieu: .huy)
                    ]
                )
            } else {
                hienMenuChon(
                    tieuDe: "Xoá dữ liệu Nhân viên Lũy kế?",
                    thongDiep: "Chọn phần dữ liệu Nhân viên Lũy kế muốn xoá:",
                    cacMuc: [
                        MucChonDMX(tieuDe: "🗑️ Xoá Doanh thu & Sức khỏe NV Lũy kế", kieu: .nguyHiem) { [weak self] in
                            guard let self = self else { return }
                            KhoDuLieu.dungChung.xoaDoanhThuNhanVienLuyKeThang(cho: self.ngayHienTai, xoaCaThiDuaNV: false)
                            self.dsThiDuaDaNapUI = nil
                            self.khoaCumChiSoDaNapUI = ""
                            self.napDuLieu()
                        },
                        MucChonDMX(tieuDe: "🗑️ Xoá TẤT CẢ Doanh thu, Sức khỏe & Thi đua NV", kieu: .nguyHiem) { [weak self] in
                            guard let self = self else { return }
                            KhoDuLieu.dungChung.xoaDoanhThuNhanVienLuyKeThang(cho: self.ngayHienTai, xoaCaThiDuaNV: true)
                            self.dsThiDuaDaNapUI = nil
                            self.khoaCumChiSoDaNapUI = ""
                            self.napDuLieu()
                        },
                        MucChonDMX(tieuDe: "Huỷ", kieu: .huy)
                    ]
                )
            }
            return
        }

        guard tabXemSo == .luyKe || tabXemSo == .realtime else { return }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dsHienTai = dl.danhSachThiDua(theo: cheDoXoa)

        if dsHienTai.isEmpty {
            moHuongDanQuetAnhThiDua(cheDo: cheDoXoa)
            return
        }

        hienMenuChon(
            tieuDe: "Xoá bảng Thi đua \(tenCheDo)?",
            thongDiep: "Toàn bộ \(dsHienTai.count) ngành hàng trong bảng Thi đua \(tenCheDo) sẽ được xoá sạch.",
            cacMuc: [
                MucChonDMX(tieuDe: "🗑️ Xoá sạch Thi đua \(tenCheDo) & Quét lại ngay", kieu: .nguyHiem) { [weak self] in
                    guard let self = self else { return }
                    KhoDuLieu.dungChung.xoaThiDuaTheoCheDo(cho: self.ngayHienTai, cheDo: cheDoXoa)
                    self.dsThiDuaDaNapUI = nil
                    self.khoaCumChiSoDaNapUI = ""
                    self.napDuLieu()
                    self.moChonAnh(cheDo: .thiDua(cheDoXoa), gioiHan: 0)
                },
                MucChonDMX(tieuDe: "Chỉ xoá sạch danh sách Thi đua \(tenCheDo)", kieu: .nguyHiem) { [weak self] in
                    guard let self = self else { return }
                    KhoDuLieu.dungChung.xoaThiDuaTheoCheDo(cho: self.ngayHienTai, cheDo: cheDoXoa)
                    self.dsThiDuaDaNapUI = nil
                    self.khoaCumChiSoDaNapUI = ""
                    self.napDuLieu()
                },
                MucChonDMX(tieuDe: "Huỷ", kieu: .huy)
            ]
        )
    }

    // MARK: - Tương tác cụm Doanh thu & Menu Xóa dữ liệu

    @objc private func moMenuXoaDuLieu() {
        let ngay = ngayHienTai
        let ngayChu = TienIchNgay.hienThiNgay.string(from: ngay)
        let luaChon: [(ten: String, doanhThu: Bool, cheDo: LoaiCheDoDoanhThu)] = [
            ("Doanh thu Realtime", true, .realtime),
            ("Doanh thu Lũy kế", true, .luyKe),
            ("Thi đua Realtime", false, .realtime),
            ("Thi đua Lũy kế", false, .luyKe)
        ]
        var cacNut: [(tieuDe: String, hanhDong: () -> Void)] = luaChon.map { muc in
            (tieuDe: "🗑️ Xóa \(muc.ten)", hanhDong: { [weak self] in
                self?.xacNhanXoaDuLieu(muc.ten, doanhThu: muc.doanhThu, cheDo: muc.cheDo, ngay: ngay)
            })
        }
        cacNut.append((
            tieuDe: "🗑️ Xóa Doanh thu & Thi đua Nhân viên",
            hanhDong: { [weak self] in
                self?.xacNhanXoaDuLieuNhanVien(ngay: ngay)
            }
        ))
        cacNut.append((
            tieuDe: "🔥 Xóa TẤT CẢ dữ liệu đã quét",
            hanhDong: { [weak self] in
                self?.xacNhanXoaTatCaDuLieu(ngay: ngay)
            }
        ))
        hienBangNut(tieuDe: "Xóa dữ liệu", huongDan: "Chọn phần dữ liệu đã quét cần xóa (Ngày \(ngayChu)):", cacNut: cacNut, nguyHiem: true)
    }

    private func xacNhanXoaDuLieu(_ ten: String, doanhThu: Bool, cheDo: LoaiCheDoDoanhThu, ngay: Date) {
        let ngayChu = TienIchNgay.hienThiNgay.string(from: ngay)
        let theoThang = (cheDo == .luyKe)
        let phamVi = theoThang ? "toàn bộ tháng chứa ngày \(ngayChu)" : "ngày \(ngayChu)"
        let hop = UIAlertController(title: "Xóa \(ten)?", message: "Sẽ xóa sạch dữ liệu \(ten) của \(phamVi).", preferredStyle: .alert)
        hop.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        hop.addAction(UIAlertAction(title: "Xóa", style: .destructive) { [weak self] _ in
            guard let self else { return }
            let kho = KhoDuLieu.dungChung
            if doanhThu {
                if cheDo == .luyKe {
                    kho.xoaDoanhThuLuyKeThang(cho: ngay)
                } else {
                    kho.xoaDoanhThuRealtime(cho: ngay)
                }
            } else {
                kho.xoaThiDuaTheoCheDo(cho: ngay, cheDo: cheDo)
            }
            self.dsThiDuaDaNapUI = nil
            self.khoaCumChiSoDaNapUI = ""
            self.napDuLieu()
        })
        present(hop, animated: true)
    }

    private func xacNhanXoaDuLieuNhanVien(ngay: Date) {
        let ngayChu = TienIchNgay.hienThiNgay.string(from: ngay)
        let hop = UIAlertController(
            title: "Xóa dữ liệu Nhân viên?",
            message: "Sẽ xóa toàn bộ Doanh thu, Sức khỏe 27 điểm và Thi đua Nhân viên đã quét trong tháng chứa ngày \(ngayChu).",
            preferredStyle: .alert
        )
        hop.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        hop.addAction(UIAlertAction(title: "Xóa sạch", style: .destructive) { [weak self] _ in
            guard let self else { return }
            KhoDuLieu.dungChung.xoaDoanhThuNhanVienLuyKeThang(cho: ngay, xoaCaThiDuaNV: true)
            self.dsThiDuaDaNapUI = nil
            self.khoaCumChiSoDaNapUI = ""
            self.napDuLieu()
        })
        present(hop, animated: true)
    }

    private func xacNhanXoaTatCaDuLieu(ngay: Date) {
        let ngayChu = TienIchNgay.hienThiNgay.string(from: ngay)
        let hop = UIAlertController(
            title: "Xóa TẤT CẢ dữ liệu đã quét?",
            message: "Sẽ xóa sạch Doanh thu (Lũy kế & Realtime), Thi đua ngành hàng (Lũy kế & Realtime) và toàn bộ Doanh thu / Sức khỏe / Thi đua Nhân viên của tháng chứa ngày \(ngayChu).",
            preferredStyle: .alert
        )
        hop.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        hop.addAction(UIAlertAction(title: "Xóa tất cả", style: .destructive) { [weak self] _ in
            guard let self else { return }
            let kho = KhoDuLieu.dungChung
            kho.xoaDoanhThuLuyKeThang(cho: ngay)
            kho.xoaDoanhThuRealtime(cho: ngay)
            kho.xoaThiDuaTheoCheDo(cho: ngay, cheDo: .luyKe)
            kho.xoaThiDuaTheoCheDo(cho: ngay, cheDo: .realtime)
            kho.xoaDoanhThuNhanVienLuyKeThang(cho: ngay, xoaCaThiDuaNV: true)
            self.dsThiDuaDaNapUI = nil
            self.khoaCumChiSoDaNapUI = ""
            self.napDuLieu()
        })
        present(hop, animated: true)
    }

    @objc private func bamTheDoanhThu() {
        let cheDo = cheDoDoanhThu
        let tenCheDo = cheDo.tieuDe
        let ptTarget = KhoDuLieu.dungChung.caiDat.phanTramTarget(cho: cheDo)

        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "🎚️ Target hiển thị: \(Int(ptTarget))%") { [weak self] in
                self?.moDieuChinhPhanTramTarget()
            },
            MucChonDMX(tieuDe: "🎯 Tùy chỉnh target các môn thi đua") { [weak self] in
                self?.moDieuChinhTargetMonThiDua()
            },
            MucChonDMX(tieuDe: "📥 Nhập tất cả ảnh \(tenCheDo)") { [weak self] in
                self?.moChonAnh(cheDo: .tatCaAnhTheoTab(cheDo), gioiHan: 0)
            },
            MucChonDMX(tieuDe: "📷 Ảnh doanh thu (Thực / Quy đổi)") { [weak self] in
                self?.moChonAnh(cheDo: .doanhThu(cheDo), gioiHan: 2)
            },
            MucChonDMX(tieuDe: "📋 Ảnh thi đua ngành hàng") { [weak self] in
                self?.moHuongDanQuetAnhThiDua(cheDo: cheDo)
            }
        ]
        if cheDo == .realtime {
            cacMuc.append(MucChonDMX(tieuDe: "👥 Ảnh Bảng Doanh thu Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .doanhThuNhanVien(.realtime), gioiHan: 0)
            })
        } else {
            cacMuc.append(MucChonDMX(tieuDe: "👥 Ảnh Ma trận Thi đua Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .thiDuaNhanVien(.luyKe), gioiHan: 0)
            })
            cacMuc.append(MucChonDMX(tieuDe: "💰 Ảnh Bảng Doanh thu Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .doanhThuNhanVien(.luyKe), gioiHan: 0)
            })
            cacMuc.append(MucChonDMX(tieuDe: "⏱️ Ảnh Bảng Giờ công Nhân viên") { [weak self] in
                self?.moChonAnh(cheDo: .gioCongNhanVien(.luyKe), gioiHan: 0)
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "✏️ Nhập / Sửa tay Doanh thu & Lượt khách") { [weak self] in
            self?.moHopThoaiNhapDoanhThu()
        })
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(
            tieuDe: "Nhập dữ liệu \(tenCheDo)",
            cacMuc: cacMuc
        )
    }

    private func moDieuChinhPhanTramTarget() {
        let cheDo = cheDoDoanhThu
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let goc = cheDo == .luyKe ? dl.doanhThu : dl.doanhThuRealtime
        let vc = ManHinhDieuChinhTarget(
            cheDo: cheDo,
            phanTram: KhoDuLieu.dungChung.caiDat.phanTramTarget(cho: cheDo),
            targetGoc: goc
        )
        vc.khiLuu = { [weak self] phanTram in
            guard let self else { return }
            var cd = KhoDuLieu.dungChung.caiDat
            if cheDo == .luyKe { cd.phanTramTargetLuyKe = phanTram }
            else { cd.phanTramTargetRealtime = phanTram }
            KhoDuLieu.dungChung.luuCaiDat(cd)
            NotificationCenter.default.post(name: .yeuCauTaoLaiAnhBaoCaoBot, object: nil)
            self.napDuLieu()
        }
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController { sheet.detents = [.medium()] }
        present(nav, animated: true)
    }

    private func moDieuChinhTargetMonThiDua() {
        let cheDo = cheDoDoanhThu
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let danhSach = dl.danhSachThiDua(theo: cheDo)
        guard !danhSach.isEmpty else {
            let hop = UIAlertController(
                title: "Chưa có môn thi đua",
                message: "Hãy quét hoặc nhập bảng thi đua trước khi điều chỉnh target.",
                preferredStyle: .alert
            )
            hop.addAction(UIAlertAction(title: "Đóng", style: .default))
            present(hop, animated: true)
            return
        }

        let vc = ManHinhDieuChinhTargetThiDua(cheDo: cheDo, danhSach: danhSach)
        vc.khiLuu = { [weak self] tyLeTheoId in
            guard let self else { return }
            var duLieu = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            var danhSachMoi = duLieu.danhSachThiDua(theo: cheDo)
            for index in danhSachMoi.indices {
                guard let tyLe = tyLeTheoId[danhSachMoi[index].id] else { continue }
                let tyLeHopLe = min(200, max(50, tyLe))
                let goc = danhSachMoi[index].targetGocHieuLuc
                danhSachMoi[index].targetGoc = goc
                danhSachMoi[index].phanTramDieuChinhTarget = tyLeHopLe
                danhSachMoi[index].target = goc * (tyLeHopLe / 100.0)
                // Target đã đổi nên các tỷ lệ OCR cũ không còn đúng; để model tự tính lại.
                danhSachMoi[index].phanTramHTGoc = nil
                danhSachMoi[index].phanTramDuBaoGoc = nil
            }
            duLieu.ganDanhSachThiDua(danhSachMoi, theo: cheDo)
            KhoDuLieu.dungChung.luu(duLieu)
            self.dsThiDuaDaNapUI = nil
            self.khoaCumChiSoDaNapUI = ""
            NotificationCenter.default.post(name: .yeuCauTaoLaiAnhBaoCaoBot, object: nil)
            self.napDuLieu()
        }
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController { sheet.detents = [.large()] }
        present(nav, animated: true)
    }

    private func moHopThoaiNhapDoanhThu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dt = (cheDoDoanhThu == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        let tenCheDo = cheDoDoanhThu.tieuDe

        let hop = UIAlertController(
            title: "Số liệu Doanh thu (\(tenCheDo))",
            message: "Nhập Doanh thu thực, Target thực, Doanh thu QĐ, Target QĐ và Lượt khách:",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Doanh thu thực (VD: 11143)"
            tf.keyboardType = .decimalPad
            if dt.doanhThuThuc > 0 { tf.text = String(dt.doanhThuThuc) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target thực (VD: 11128)"
            tf.keyboardType = .decimalPad
            if dt.targetThuc > 0 { tf.text = String(dt.targetThuc) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Doanh thu quy đổi (VD: 15199)"
            tf.keyboardType = .decimalPad
            if dt.doanhThuQuyDoi > 0 { tf.text = String(dt.doanhThuQuyDoi) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target quy đổi (VD: 14957)"
            tf.keyboardType = .decimalPad
            if dt.targetQuyDoi > 0 { tf.text = String(dt.targetQuyDoi) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Lượt khách (từ ô TLPVTC, VD: 19149)"
            tf.keyboardType = .numberPad
            if dt.luotKhach > 0 { tf.text = String(Int(dt.luotKhach)) }
        }

        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self, let tfs = hop.textFields, tfs.count >= 5 else { return }
            var moi = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            let nhap = ThongTinDoanhThu(
                doanhThuThuc: self.docSoTuO(tfs[0].text),
                targetThuc: self.docSoTuO(tfs[1].text),
                doanhThuQuyDoi: self.docSoTuO(tfs[2].text),
                targetQuyDoi: self.docSoTuO(tfs[3].text),
                luotKhach: self.docSoTuO(tfs[4].text)
            )
            if self.cheDoDoanhThu == .luyKe {
                moi.doanhThu = moi.doanhThu.gop(voi: nhap, laRealtime: false)
            } else {
                moi.doanhThuRealtime = moi.doanhThuRealtime.gop(voi: nhap, laRealtime: true)
            }
            KhoDuLieu.dungChung.luu(moi)
            self.napDuLieu()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func moMenuRealtimeChoNgay(_ item: DuLieuRealtimeNgayTrongThang) {
        let ngayStr = TienIchNgay.hienThiNgay.string(from: item.ngay)
        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "📷 Chọn 2 ảnh Realtime ngày \(ngayStr)") { [weak self] in
                guard let self = self else { return }
                self.ngayHienTai = item.ngay
                self.napDuLieu()
                self.moChonAnh(cheDo: .doanhThu(.realtime), gioiHan: 2)
            },
            MucChonDMX(tieuDe: "✏️ Nhập / Sửa tay Realtime ngày \(ngayStr)") { [weak self] in
                guard let self = self else { return }
                self.ngayHienTai = item.ngay
                self.cheDoDoanhThu = .realtime
                self.napDuLieu()
                self.moHopThoaiNhapDoanhThu()
            }
        ]
        if item.coDuLieu {
            cacMuc.append(MucChonDMX(tieuDe: "🗑️ Xoá Realtime ngày \(ngayStr)", kieu: .nguyHiem) { [weak self] in
                guard let self = self else { return }
                var dl = KhoDuLieu.dungChung.duLieu(cho: item.ngay)
                dl.doanhThuRealtime = ThongTinDoanhThu()
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(
            tieuDe: ngayStr,
            thongDiep: item.coDuLieu
                ? "DT Thực: \(item.doanhThuThuc.chuoiSoVN)  •  DT Quy đổi: \(item.doanhThuQuyDoi.chuoiSoVN)"
                : nil,
            cacMuc: cacMuc
        )
    }

    private func docSoTuO(_ text: String?) -> Double {
        let s = (text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        return Double(s) ?? 0
    }

    // MARK: - Chọn ảnh từ Thư viện Ảnh hoặc Nhập ảnh từ Tệp (Files) & Quét dữ liệu

    private func moChonAnh(cheDo: CheDoQuetAnh, gioiHan: Int, nguon: NguonChonAnh? = nil) {
        cheDoQuet = cheDo
        if let nguon {
            switch nguon {
            case .thuVienAnh:
                moThuVienAnh(cheDo: cheDo, gioiHan: gioiHan)
            case .tepTin:
                moChonTepAnh(cheDo: cheDo, gioiHan: gioiHan)
            }
            return
        }

        hienMenuChon(
            tieuDe: "Chọn nguồn nhập ảnh",
            cacMuc: [
                MucChonDMX(tieuDe: "🖼️ Chọn ảnh từ Thư viện Ảnh") { [weak self] in
                    self?.moThuVienAnh(cheDo: cheDo, gioiHan: gioiHan)
                },
                MucChonDMX(tieuDe: "📁 Nhập ảnh từ Tệp (Files)") { [weak self] in
                    self?.moChonTepAnh(cheDo: cheDo, gioiHan: gioiHan)
                },
                MucChonDMX(tieuDe: "Đóng", kieu: .huy)
            ]
        )
    }

    private func moThuVienAnh(cheDo: CheDoQuetAnh, gioiHan: Int) {
        cheDoQuet = cheDo
        var cauHinh = PHPickerConfiguration()
        cauHinh.filter = .images
        cauHinh.selectionLimit = (gioiHan <= 0 || gioiHan == 10) ? 50 : max(gioiHan, 50)
        if #available(iOS 15.0, *) {
            cauHinh.selection = .ordered
        }
        let picker = PHPickerViewController(configuration: cauHinh)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func moChonTepAnh(cheDo: CheDoQuetAnh, gioiHan: Int) {
        cheDoQuet = cheDo
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = (gioiHan != 1)
        present(picker, animated: true)
    }

    private func xuLyDanhSachAnhDaChon(_ cacAnh: [UIImage], theo cheDo: CheDoQuetAnh) {
        guard !cacAnh.isEmpty else { return }
        switch cheDo {
        case .doanhThu(let loaiDT):
            self.xuLyQuetDoanhThu(cacAnh, loai: loaiDT)
        case .thiDua(let loaiTD):
            self.xuLyQuetThiDua(cacAnh, loai: loaiTD)
        case .thiDuaNhanVien(let loaiTDNV):
            self.xuLyQuetThiDuaNhanVien(cacAnh, loai: loaiTDNV)
        case .doanhThuNhanVien(let loaiNV):
            self.xuLyQuetDoanhThuNhanVien(cacAnh, loai: loaiNV)
        case .gioCongNhanVien(let loaiGC):
            self.xuLyQuetGioCongNhanVien(cacAnh, loai: loaiGC)
        case .tatCaAnhTheoTab(let cheDoTab):
            self.xuLyQuetTatCaAnhTheoTab(cacAnh, cheDoTab: cheDoTab)
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        guard !urls.isEmpty else { return }
        let cheDo = cheDoQuet

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var cacAnh: [UIImage] = []
            for url in urls {
                let daMoQuyen = url.startAccessingSecurityScopedResource()
                defer {
                    if daMoQuyen { url.stopAccessingSecurityScopedResource() }
                }
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    cacAnh.append(img)
                } else if let img = UIImage(contentsOfFile: url.path) {
                    cacAnh.append(img)
                }
            }
            DispatchQueue.main.async {
                guard let self = self, !cacAnh.isEmpty else { return }
                self.xuLyDanhSachAnhDaChon(cacAnh, theo: cheDo)
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let cheDo = cheDoQuet
        let nhom = DispatchGroup()
        let khoaAnh = NSLock()
        var danhSach = Array<UIImage?>(repeating: nil, count: results.count)

        for (i, r) in results.enumerated() {
            let provider = r.itemProvider
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                nhom.enter()
                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    if let data, let img = UIImage(data: data) {
                        khoaAnh.lock()
                        danhSach[i] = img
                        khoaAnh.unlock()
                        nhom.leave()
                    } else if provider.canLoadObject(ofClass: UIImage.self) {
                        provider.loadObject(ofClass: UIImage.self) { obj, _ in
                            if let img = obj as? UIImage {
                                khoaAnh.lock()
                                danhSach[i] = img
                                khoaAnh.unlock()
                            }
                            nhom.leave()
                        }
                    } else {
                        nhom.leave()
                    }
                }
            } else if provider.canLoadObject(ofClass: UIImage.self) {
                nhom.enter()
                provider.loadObject(ofClass: UIImage.self) { obj, _ in
                    if let img = obj as? UIImage {
                        khoaAnh.lock()
                        danhSach[i] = img
                        khoaAnh.unlock()
                    }
                    nhom.leave()
                }
            }
        }

        nhom.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let cacAnh = danhSach.compactMap { $0 }
            self.xuLyDanhSachAnhDaChon(cacAnh, theo: cheDo)
        }
    }

    private func xuLyQuetTatCaAnhTheoTab(_ cacAnh: [UIImage], cheDoTab: LoaiCheDoDoanhThu) {
        let tenCheDo = cheDoTab.tieuDe
        let laRT = (cheDoTab == .realtime)
        hienTienTrinh("Đang đọc & lọc \(cacAnh.count) ảnh cho \(tenCheDo)...")
        DichVuDocAnh.dungChung.quetVaPhanLoaiTatCaAnh(
            danhSachAnh: cacAnh,
            ngay: ngayHienTai,
            cheDoDangChon: cheDoTab,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] kq in
                guard let self = self else { return }
                self.anTienTrinh()

                guard kq.coDuLieu else {
                    let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                    let tb = UIAlertController(
                        title: loi != nil ? "Quét Gemini thất bại" : "Chưa nhận diện được dữ liệu",
                        message: loi ?? "Không tìm thấy bảng Doanh thu, Thi đua hay Nhân viên hợp lệ trong các ảnh vừa chọn.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                var cacMucDaDien: [String] = []

                if let dt = kq.doanhThu, dt.coDuLieu {
                    if laRT {
                        dl.doanhThuRealtime = dl.doanhThuRealtime.gop(voi: dt, laRealtime: true)
                        cacMucDaDien.append("• Doanh thu Realtime (\(kq.soAnhDoanhThu) ảnh): Thực \(dl.doanhThuRealtime.doanhThuThuc.chuoiSoGonVN) | QĐ \(dl.doanhThuRealtime.doanhThuQuyDoi.chuoiSoGonVN) | HT \(dl.doanhThuRealtime.phanTramHTQDDuKienHienThi.chuoiPhanTram)")
                    } else {
                        dl.doanhThu = dl.doanhThu.gop(voi: dt, laRealtime: false)
                        cacMucDaDien.append("• Doanh thu Lũy kế (\(kq.soAnhDoanhThu) ảnh): Thực \(dl.doanhThu.doanhThuThuc.chuoiSoGonVN) | QĐ \(dl.doanhThu.doanhThuQuyDoi.chuoiSoGonVN) | HT \(dl.doanhThu.phanTramHTQDDuKienHienThi.chuoiPhanTram)")
                    }
                }

                if !kq.danhSachThiDua.isEmpty {
                    let cu = (kq.danhSachThiDua.count >= 25) ? [] : dl.danhSachThiDua(theo: cheDoTab)
                    let gop = KhoDuLieu.gopDanhSachThiDua(cu: cu, moi: kq.danhSachThiDua)
                    dl.ganDanhSachThiDua(gop, theo: cheDoTab)
                    var cd = KhoDuLieu.dungChung.caiDat
                    let dangTheoDoi = cd.khoaMonTheoDoi(cho: cheDoTab)
                    if !dangTheoDoi.isEmpty && dangTheoDoi != [CaiDatDMX.khoaKhongChonMonThiDua] {
                        cd.ganKhoaMonTheoDoi([], cho: cheDoTab)
                        KhoDuLieu.dungChung.luuCaiDat(cd)
                    }
                    cacMucDaDien.append("• Thi đua \(tenCheDo) (\(kq.soAnhThiDua) ảnh): \(gop.count) ngành hàng (đã lọc trùng)")
                }

                if !kq.doanhThuNhanVien.isEmpty {
                    let dsQuanLy = KhoDuLieu.dungChung.caiDat.danhSachNhanVien
                    var mapDTNV: [String: DoanhThuNhanVienItem] = [:]
                    if cheDoTab == .realtime || kq.doanhThuNhanVien.count < max(15, dsQuanLy.count - 1) {
                        for item in KhoDuLieu.locSachDanhSachDTNV(dl.doanhThuNhanVien(theo: cheDoTab)) {
                            let ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                            if !ma.isEmpty { mapDTNV[ma] = item }
                        }
                    }
                    var daQuetTrongDot = Set<String>()
                    for item in kq.doanhThuNhanVien {
                        let ma: String
                        let ten: String
                        if !dsQuanLy.isEmpty {
                            guard let nvKhop = KhoDuLieu.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: dsQuanLy) else { continue }
                            ma = nvKhop.maNV
                            ten = nvKhop.hoTen
                        } else {
                            ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                            ten = item.hoTen
                        }
                        guard !ma.isEmpty else { continue }
                        var capNhat = item
                        capNhat.maNV = ma
                        capNhat.hoTen = ten
                        if daQuetTrongDot.contains(ma), let daCo = mapDTNV[ma] {
                            let daCoSo = abs(daCo.doanhThuQD) > 0.001 || abs(daCo.soLuong) > 0.001 || abs(daCo.phanTramQuyDoi) > 0.01
                            let moiCoSo = abs(capNhat.doanhThuQD) > 0.001 || abs(capNhat.soLuong) > 0.001 || abs(capNhat.phanTramQuyDoi) > 0.01
                            if daCoSo && !moiCoSo { continue }
                            if abs(daCo.doanhThuQD) > abs(capNhat.doanhThuQD) && abs(daCo.phanTramQuyDoi) >= abs(capNhat.phanTramQuyDoi) {
                                continue
                            }
                        }
                        if let cu = mapDTNV[ma] {
                            if capNhat.gioCong <= 0.0001 && cu.gioCong > 0.0001 { capNhat.gioCong = cu.gioCong }
                            if capNhat.gioCongHoTro <= 0.0001 && cu.gioCongHoTro > 0.0001 { capNhat.gioCongHoTro = cu.gioCongHoTro }
                        }
                        daQuetTrongDot.insert(ma)
                        mapDTNV[ma] = capNhat
                        if cheDoTab == .luyKe {
                            var skNV = dl.sucKhoeBoSungNhanVien[ma] ?? DuLieuSucKhoeBoSungNV()
                            skNV.doanhThuQDSucKhoe = capNhat.doanhThuQD
                            skNV.soLuotBillBanHang = capNhat.soLuong
                            skNV.phanTramQuyDoi = capNhat.phanTramQuyDoi
                            if capNhat.gioCong > 0.0001 { skNV.gioCongTaiST = capNhat.gioCong }
                            if capNhat.gioCongHoTro > 0.0001 { skNV.gioCongHoTroSTKhac = capNhat.gioCongHoTro }
                            dl.sucKhoeBoSungNhanVien[ma] = skNV
                        }
                    }
                    dl.ganDoanhThuNhanVien(Array(mapDTNV.values), theo: cheDoTab)
                    cacMucDaDien.append("• Doanh thu Nhân viên \(tenCheDo) (\(kq.soAnhDoanhThuNV) ảnh): \(mapDTNV.count) NV (Đã thay thế dữ liệu cũ)")
                }

                if !kq.gioCongNhanVien.isEmpty {
                    let soNVGC = KhoDuLieu.dungChung.apDungGioCongNhanVienQuetDuoc(
                        kq.gioCongNhanVien,
                        vao: &dl,
                        ngay: self.ngayHienTai,
                        cheDo: cheDoTab
                    )
                    cacMucDaDien.append("• Giờ công Nhân viên \(tenCheDo) (\(max(1, kq.soAnhGioCongNV)) ảnh): \(soNVGC) NV (Giờ công tại ST & Hỗ trợ ST khác)")
                }

                if !kq.thiDuaNhanVien.isEmpty {
                    KhoDuLieu.dungChung.boSungDanhSachThiDuaTuKhoiNhanVien(
                        mangKhoiNV: kq.thiDuaNhanVien,
                        vao: &dl,
                        cheDo: cheDoTab
                    )
                    let bangNVMoi = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                        hienTai: dl.thiDuaNhanVien(theo: cheDoTab),
                        mangKhoiNV: kq.thiDuaNhanVien,
                        ngay: self.ngayHienTai,
                        cheDo: cheDoTab
                    )
                    dl.ganThiDuaNhanVien(bangNVMoi, theo: cheDoTab)
                    let soMonDuyNhat = Set(kq.thiDuaNhanVien.map { KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) }).count
                    cacMucDaDien.append("• Thi đua Nhân viên \(tenCheDo) (\(kq.soAnhThiDuaNV) ảnh): \(soMonDuyNhat) chương trình")
                }

                if !kq.sucKhoeNhanVien.isEmpty {
                    KhoDuLieu.dungChung.apDungSucKhoeNhanVienQuetDuoc(
                        kq.sucKhoeNhanVien,
                        vao: &dl,
                        ngay: self.ngayHienTai,
                        cheDo: cheDoTab
                    )
                    cacMucDaDien.append("• Sức khỏe & Thi đua cá nhân NV (\(kq.soAnhSucKhoeNV) ảnh): \(kq.sucKhoeNhanVien.count) NV (Đủ 6 mục Doanh thu, 3 mục Năng suất & các môn Thi đua)")
                }

                if !kq.capNhatLuc.isEmpty { dl.capNhatLuc = kq.capNhatLuc }
                if !kq.thongTinDonVi.isEmpty { dl.thongTinDonVi = kq.thongTinDonVi }

                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()

                let tb = UIAlertController(
                    title: "✅ Đã nạp vào phần \(tenCheDo)",
                    message: cacMucDaDien.joined(separator: "\n"),
                    preferredStyle: .alert
                )
                tb.addAction(UIAlertAction(title: "Hoàn tất", style: .default))
                self.present(tb, animated: true)
            }
        )
    }

    private func xuLyQuetGioCongNhanVien(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        let tenCheDo = loai.tieuDe
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Bảng Giờ công Nhân viên (\(tenCheDo))...")
        DichVuDocAnh.dungChung.quetAnhGioCongNhanVien(
            danhSachAnh: cacAnh,
            cheDo: loai,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] dsQuet in
                guard let self = self else { return }
                self.anTienTrinh()
                guard !dsQuet.isEmpty else {
                    let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                    let tb = UIAlertController(
                        title: loi != nil ? "Quét Gemini thất bại" : "Chưa đọc được dữ liệu Giờ công NV",
                        message: loi ?? "Hãy chọn ảnh Bảng Giờ công Nhân viên (có 3 cột: NHÂN VIÊN | GIỜ CÔNG TẠI ST LÀM VIỆC | GIỜ CÔNG HỖ TRỢ ST KHÁC) rồi thử lại.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                let soNVCapNhat = KhoDuLieu.dungChung.apDungGioCongNhanVienQuetDuoc(
                    dsQuet,
                    vao: &dl,
                    ngay: self.ngayHienTai,
                    cheDo: loai
                )
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()

                let tongGCTaiST = dsQuet.reduce(0.0) { $0 + $1.gioCong }
                let tongGCHoTro = dsQuet.reduce(0.0) { $0 + $1.gioCongHoTro }
                let tb = UIAlertController(
                    title: "✅ Đã nhập Giờ công Nhân viên (\(tenCheDo))",
                    message: "Đã cập nhật Giờ công tại ST làm việc (Tổng: \(tongGCTaiST.chuoiSoMotLeVN)h) & Giờ công hỗ trợ ST khác (Tổng: \(tongGCHoTro.chuoiSoMotLeVN)h) cho \(soNVCapNhat) nhân viên. Số liệu đã hiển thị trên Bảng xếp hạng và Bảng chi tiết nhân viên.",
                    preferredStyle: .alert
                )
                tb.addAction(UIAlertAction(title: "Hoàn tất", style: .default))
                self.present(tb, animated: true)
            }
        )
    }

    private func xuLyQuetThiDua(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        cheDoDoanhThu = loai
        let tenCheDo = loai.tieuDe
        let laRT = (loai == .realtime)
        let dlHienTai = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dsHienCo = thayTheBangThiDuaKhiQuet ? [] : dlHienTai.danhSachThiDua(theo: loai)
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Thi đua (\(tenCheDo))...")
        DichVuDocAnh.dungChung.quetAnhThiDua(
            danhSachAnh: cacAnh,
            danhSachHienCo: dsHienCo,
            laRealtime: laRT,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] kq in
                guard let self = self else { return }
                self.anTienTrinh()
                let coDuLieuThiDua = !kq.danhSach.isEmpty || !kq.thiDuaNhanVien.isEmpty || (kq.doanhThuQuetDuoc?.coDuLieu ?? false) || !kq.sucKhoeNhanVien.isEmpty
                guard coDuLieuThiDua else {
                    self.thayTheBangThiDuaKhiQuet = false
                    let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                    let tb = UIAlertController(
                        title: loi != nil ? "Quét Gemini thất bại" : "Chưa đọc được bảng Thi đua",
                        message: loi ?? "Gemini không tìm thấy bảng số liệu Thi đua hợp lệ trong ảnh vừa chọn.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                    self.present(tb, animated: true)
                    return
                }
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                if let dtMoi = kq.doanhThuQuetDuoc, dtMoi.coDuLieu {
                    if laRT {
                        dl.doanhThuRealtime = dl.doanhThuRealtime.gop(voi: dtMoi, laRealtime: true)
                    } else {
                        dl.doanhThu = dl.doanhThu.gop(voi: dtMoi, laRealtime: false)
                    }
                }
                if !kq.danhSach.isEmpty {
                    let cu = (self.thayTheBangThiDuaKhiQuet || kq.danhSach.count >= 25) ? [] : dl.danhSachThiDua(theo: loai)
                    let gop = KhoDuLieu.gopDanhSachThiDua(cu: cu, moi: kq.danhSach)
                    dl.ganDanhSachThiDua(gop, theo: loai)
                    var cd = KhoDuLieu.dungChung.caiDat
                    let dangTheoDoi = cd.khoaMonTheoDoi(cho: loai)
                    if !dangTheoDoi.isEmpty && dangTheoDoi != [CaiDatDMX.khoaKhongChonMonThiDua] {
                        cd.ganKhoaMonTheoDoi([], cho: loai)
                        KhoDuLieu.dungChung.luuCaiDat(cd)
                    }
                }
                self.thayTheBangThiDuaKhiQuet = false
                if !kq.thiDuaNhanVien.isEmpty {
                    KhoDuLieu.dungChung.boSungDanhSachThiDuaTuKhoiNhanVien(
                        mangKhoiNV: kq.thiDuaNhanVien,
                        vao: &dl,
                        cheDo: loai
                    )
                    let bangNVMoi = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                        hienTai: dl.thiDuaNhanVien(theo: loai),
                        mangKhoiNV: kq.thiDuaNhanVien,
                        ngay: self.ngayHienTai,
                        cheDo: loai
                    )
                    dl.ganThiDuaNhanVien(bangNVMoi, theo: loai)
                }
                if !kq.sucKhoeNhanVien.isEmpty {
                    KhoDuLieu.dungChung.apDungSucKhoeNhanVienQuetDuoc(
                        kq.sucKhoeNhanVien,
                        vao: &dl,
                        ngay: self.ngayHienTai,
                        cheDo: loai
                    )
                }
                dl.capNhatLuc = kq.capNhatLuc
                if !kq.thongTinDonVi.isEmpty { dl.thongTinDonVi = kq.thongTinDonVi }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            }
        )
    }

    private func xuLyQuetThiDuaNhanVien(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        let tenCheDo = loai.tieuDe
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Thi đua / Sức khỏe Nhân viên (\(tenCheDo))...")
        var skQuetDuoc: [String: DuLieuSucKhoeBoSungNV] = [:]
        DichVuDocAnh.dungChung.quetAnhThiDuaNhanVien(
            danhSachAnh: cacAnh,
            tenNganhGoiY: nil,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTatSucKhoe: { bangSK in
                skQuetDuoc = bangSK
            },
            hoanTat: { [weak self] cacKhoi in
                guard let self = self else { return }
                self.anTienTrinh()
                guard !cacKhoi.isEmpty || !skQuetDuoc.isEmpty else {
                    let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                    let tb = UIAlertController(
                        title: loi != nil ? "Quét Gemini thất bại" : "Chưa đọc được dữ liệu Thi đua NV",
                        message: loi ?? "Hãy chọn ảnh Phiếu Sức Khỏe / Thi Đua Cá Nhân Nhân Viên (27 điểm) hoặc bảng Thực hiện Thi đua Nhân viên rồi thử lại.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                if !cacKhoi.isEmpty {
                    KhoDuLieu.dungChung.boSungDanhSachThiDuaTuKhoiNhanVien(
                        mangKhoiNV: cacKhoi,
                        vao: &dl,
                        cheDo: loai
                    )
                    let bangNVMoi = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                        hienTai: dl.thiDuaNhanVien(theo: loai),
                        mangKhoiNV: cacKhoi,
                        ngay: self.ngayHienTai,
                        cheDo: loai
                    )
                    dl.ganThiDuaNhanVien(bangNVMoi, theo: loai)
                }
                if !skQuetDuoc.isEmpty {
                    KhoDuLieu.dungChung.apDungSucKhoeNhanVienQuetDuoc(
                        skQuetDuoc,
                        vao: &dl,
                        ngay: self.ngayHienTai,
                        cheDo: loai
                    )
                }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
                let soMonDuyNhat = Set(cacKhoi.map { KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) }).count
                let tb = UIAlertController(
                    title: "✅ Đã nạp Thi đua Nhân viên (\(tenCheDo))",
                    message: "Đã cập nhật số Thực hiện & Target cá nhân của \(soMonDuyNhat) chương trình từ \(cacAnh.count) ảnh.",
                    preferredStyle: .alert
                )
                tb.addAction(UIAlertAction(title: "Hoàn tất", style: .default))
                self.present(tb, animated: true)
            }
        )
    }

    private func xuLyQuetDoanhThuNhanVien(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        xuLyQuetDoanhThuNhanVienCu(cacAnh, loai: loai)
    }

    private func xuLyQuetDoanhThuNhanVienCu(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        let tenCheDo = loai.tieuDe
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Doanh thu Nhân viên (\(tenCheDo))...")
        var skQuetDuoc: [String: DuLieuSucKhoeBoSungNV] = [:]
        DichVuDocAnh.dungChung.quetAnhDoanhThuNhanVien(
            danhSachAnh: cacAnh,
            cheDo: loai,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTatSucKhoe: { bangSK in
                skQuetDuoc = bangSK
            },
            hoanTat: { [weak self] dsQuet in
                guard let self = self else { return }
                self.anTienTrinh()
                guard !dsQuet.isEmpty else {
                    let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                    let tb = UIAlertController(
                        title: loi != nil ? "Quét Gemini thất bại" : "Chưa đọc được dòng nhân viên",
                        message: loi ?? "Hãy chụp rõ bảng Doanh thu hợp nhất theo Nhân viên rồi thử lại.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                let chiLaAnhGioCong = dsQuet.allSatisfy {
                    abs($0.doanhThuQD) < 0.0001 && abs($0.soLuong) < 0.0001 && ($0.gioCong > 0.0001 || $0.gioCongHoTro > 0.0001)
                }
                if chiLaAnhGioCong {
                    let soNVGC = KhoDuLieu.dungChung.apDungGioCongNhanVienQuetDuoc(
                        dsQuet,
                        vao: &dl,
                        ngay: self.ngayHienTai,
                        cheDo: loai
                    )
                    KhoDuLieu.dungChung.luu(dl)
                    self.napDuLieu()
                    let tb = UIAlertController(
                        title: "✅ Đã nhập Giờ công Nhân viên (\(tenCheDo))",
                        message: "Đã cập nhật Giờ công tại ST làm việc & Giờ công hỗ trợ ST khác cho \(soNVGC) nhân viên.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Hoàn tất", style: .default))
                    self.present(tb, animated: true)
                    return
                }
                let dsQuanLy = KhoDuLieu.dungChung.caiDat.danhSachNhanVien
                var mapDTNV: [String: DoanhThuNhanVienItem] = [:]
                for item in KhoDuLieu.locSachDanhSachDTNV(dl.doanhThuNhanVien(theo: loai)) {
                    let ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                    if !ma.isEmpty { mapDTNV[ma] = item }
                }
                var daQuetTrongDot = Set<String>()
                for item in dsQuet {
                    let ma: String
                    let ten: String
                    if !dsQuanLy.isEmpty {
                        guard let nvKhop = KhoDuLieu.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: dsQuanLy) else { continue }
                        ma = nvKhop.maNV
                        ten = nvKhop.hoTen
                    } else {
                        ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                        ten = item.hoTen
                    }
                    guard !ma.isEmpty else { continue }
                    var capNhat = item
                    capNhat.maNV = ma
                    capNhat.hoTen = ten
                    if let cu = mapDTNV[ma] {
                        if capNhat.gioCong <= 0.0001 && cu.gioCong > 0.0001 { capNhat.gioCong = cu.gioCong }
                        if capNhat.gioCongHoTro <= 0.0001 && cu.gioCongHoTro > 0.0001 { capNhat.gioCongHoTro = cu.gioCongHoTro }
                    }
                    if daQuetTrongDot.contains(ma), let daCo = mapDTNV[ma] {
                        let daCoSo = abs(daCo.doanhThuQD) > 0.001 || abs(daCo.soLuong) > 0.001 || abs(daCo.phanTramQuyDoi) > 0.01
                        let moiCoSo = abs(capNhat.doanhThuQD) > 0.001 || abs(capNhat.soLuong) > 0.001 || abs(capNhat.phanTramQuyDoi) > 0.01
                        if daCoSo && !moiCoSo { continue }
                        if abs(daCo.doanhThuQD) > abs(capNhat.doanhThuQD) && abs(daCo.phanTramQuyDoi) >= abs(capNhat.phanTramQuyDoi) {
                            continue
                        }
                    }
                    daQuetTrongDot.insert(ma)
                    mapDTNV[ma] = capNhat
                    if loai == .luyKe {
                        var skNV = dl.sucKhoeBoSungNhanVien[ma] ?? DuLieuSucKhoeBoSungNV()
                        skNV.doanhThuQDSucKhoe = capNhat.doanhThuQD
                        skNV.soLuotBillBanHang = capNhat.soLuong
                        if abs(capNhat.phanTramQuyDoi) > 0.0001 {
                            skNV.phanTramQuyDoi = capNhat.phanTramQuyDoi
                        }
                        if capNhat.gioCong > 0.0001 { skNV.gioCongTaiST = capNhat.gioCong }
                        if capNhat.gioCongHoTro > 0.0001 { skNV.gioCongHoTroSTKhac = capNhat.gioCongHoTro }
                        dl.sucKhoeBoSungNhanVien[ma] = skNV
                    }
                }
                dl.ganDoanhThuNhanVien(Array(mapDTNV.values), theo: loai)
                if !skQuetDuoc.isEmpty {
                    KhoDuLieu.dungChung.apDungSucKhoeNhanVienQuetDuoc(
                        skQuetDuoc,
                        vao: &dl,
                        ngay: self.ngayHienTai,
                        cheDo: loai
                    )
                }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
                let tb = UIAlertController(
                    title: "Đã nhập Doanh thu Nhân viên (\(tenCheDo))",
                    message: "Đã cập nhật doanh thu cho \(daQuetTrongDot.count) nhân viên và đồng bộ lên Bảng sức khỏe nhân viên.",
                    preferredStyle: .alert
                )
                tb.addAction(UIAlertAction(title: "Hoàn tất", style: .default))
                self.present(tb, animated: true)
            }
        )
    }

    private func xuLyQuetDoanhThu(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        let tenCheDo = loai.tieuDe
        let laRT = (loai == .realtime)
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Doanh thu (\(tenCheDo))...")
        DichVuDocAnh.dungChung.quetAnhDoanhThu(
            danhSachAnh: cacAnh,
            laRealtime: laRT,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] dtMoi in
                guard let self = self else { return }
                self.anTienTrinh()

                if dtMoi.doanhThuThuc <= 0 && dtMoi.doanhThuQuyDoi <= 0 {
                    let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                    let tb = UIAlertController(
                        title: loi != nil ? "Quét Gemini thất bại" : "Chưa đọc được số liệu Doanh thu",
                        message: loi ?? "Vui lòng chọn ảnh chụp màn hình Doanh thu thực và Doanh thu quy đổi của phần \(tenCheDo).",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Chọn lại ảnh", style: .default) { [weak self] _ in
                        self?.moChonAnh(cheDo: .doanhThu(loai), gioiHan: 2)
                    })
                    tb.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                if loai == .luyKe {
                    dl.doanhThu = dl.doanhThu.gop(voi: dtMoi, laRealtime: false)
                } else {
                    dl.doanhThuRealtime = dl.doanhThuRealtime.gop(voi: dtMoi, laRealtime: true)
                }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            }
        )
    }

    private func hienTienTrinh(_ chu: String) {
        nhanTienTrinh.text = chu
        lopPhuTai.isHidden = false
        vongQuay.startAnimating()
    }

    private func anTienTrinh() {
        vongQuay.stopAnimating()
        lopPhuTai.isHidden = true
    }

    // MARK: - Sửa / Thêm / Xoá Ngành hàng Thi đua

    @objc private func bamThemDongThuCong() {
        let moi = DongThiDua(tenNganhHang: "T11 - ", loaiChiTieu: .doanhThu, thucHien: 0, target: 0)
        moHopThoaiSuaDong(moi, laThemMoi: true)
    }

    private func moHopThoaiSuaDong(_ dong: DongThiDua, laThemMoi: Bool = false) {
        let cheDoSua = cheDoDoanhThu
        let hop = UIAlertController(
            title: laThemMoi ? "Thêm ngành hàng (\(cheDoSua.tieuDe))" : "Sửa ngành hàng (\(cheDoSua.tieuDe))",
            message: nil,
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Tên ngành hàng (VD: T11 - Cáp sạc)"
            tf.text = dong.tenNganhHang
        }
        hop.addTextField { tf in
            tf.placeholder = "ĐVT: DT hoặc SL"
            tf.text = dong.loaiChiTieu.maBang
            tf.autocapitalizationType = .allCharacters
        }
        hop.addTextField { tf in
            tf.placeholder = "Thực hiện (VD: 12.73 hoặc -0.94)"
            tf.keyboardType = .numbersAndPunctuation
            if !laThemMoi { tf.text = String(dong.thucHien) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target (VD: 127.66)"
            tf.keyboardType = .decimalPad
            if !laThemMoi { tf.text = String(dong.target) }
        }
        if cheDoSua == .luyKe {
            hop.addTextField { tf in
                tf.placeholder = "DT/SL Dự kiến cuối tháng (VD: 169.87)"
                tf.keyboardType = .decimalPad
                if !laThemMoi, let dk = dong.duKienGoc, dk > 0 {
                    tf.text = String(dk)
                }
            }
            hop.addTextField { tf in
                tf.placeholder = "% Dự kiến hoàn thành (VD: 133.1)"
                tf.keyboardType = .decimalPad
                if !laThemMoi, let ptDB = dong.phanTramDuBaoGoc, ptDB > 0 {
                    tf.text = String(ptDB)
                }
            }
        }

        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self, let tfs = hop.textFields, tfs.count >= 4 else { return }
            let tenNhap = (tfs[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !tenNhap.isEmpty else { return }
            let dvt = (tfs[1].text ?? "DT").uppercased()
            let loai: LoaiChiTieuThiDua = dvt.contains("SL") ? .soLuong : .doanhThu
            let th = self.docSoTuO(tfs[2].text)
            let tg = self.docSoTuO(tfs[3].text)

            var dkMoi = dong.duKienGoc
            var ptDBMoi = dong.phanTramDuBaoGoc
            if cheDoSua == .luyKe && tfs.count >= 6 {
                let vDK = self.docSoTuO(tfs[4].text)
                let vPTDB = self.docSoTuO(tfs[5].text)
                dkMoi = vDK > 0 ? vDK : nil
                ptDBMoi = vPTDB > 0 ? vPTDB : nil
            }

            let ptHTGocMoi: Double? = {
                if abs(th - dong.thucHien) > 0.0001 || abs(tg - dong.target) > 0.0001 {
                    return tg > 0.0001 ? ((th / tg) * 100.0) : nil
                }
                return dong.phanTramHTGoc
            }()
            let capNhat = DongThiDua(
                id: dong.id,
                tenNganhHangGoc: tenNhap,
                tenNganhHang: tenNhap,
                loaiChiTieu: loai,
                thucHien: th,
                target: tg,
                phanTramHTGoc: ptHTGocMoi,
                phanTramDuBaoGoc: ptDBMoi,
                duKienGoc: dkMoi
            )

            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            var ds = dl.danhSachThiDua(theo: cheDoSua)
            if laThemMoi {
                ds.append(capNhat)
            } else if let idx = ds.firstIndex(where: { $0.id == dong.id }) {
                ds[idx] = capNhat
            }
            dl.ganDanhSachThiDua(ds, theo: cheDoSua)
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        })

        if !laThemMoi {
            hop.addAction(UIAlertAction(title: "Xoá ngành hàng này", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                var ds = dl.danhSachThiDua(theo: cheDoSua)
                ds.removeAll { $0.id == dong.id }
                dl.ganDanhSachThiDua(ds, theo: cheDoSua)
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            })
        }

        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    // MARK: - Chọn ngày & Xuất báo cáo (Yêu cầu 2 & 4: các dòng text có cỡ chữ bằng nhau, dài tự xuống dòng, không có dấu "...")

    @objc private func moLichSuNgay() {
        let lich = TienIchNgay.lich
        let homNay = lich.startOfDay(for: Date())
        let khoaHienTai = TienIchNgay.khoa.string(from: ngayHienTai)

        var tapKhoaNgay = Set<String>()
        for i in 0..<15 {
            if let d = lich.date(byAdding: .day, value: -i, to: homNay) {
                tapKhoaNgay.insert(TienIchNgay.khoa.string(from: d))
            }
        }
        for khoa in KhoDuLieu.dungChung.cacNgay.keys {
            tapKhoaNgay.insert(khoa)
        }

        var cacMuc: [MucChonDMX] = []
        for khoa in tapKhoaNgay.sorted(by: >).prefix(20) {
            guard let d = TienIchNgay.khoa.date(from: khoa) else { continue }
            let tieuDeNgay = TienIchNgay.hienThiNgay.string(from: d)
            cacMuc.append(MucChonDMX(tieuDe: tieuDeNgay, dangChon: khoa == khoaHienTai) { [weak self] in
                self?.ngayHienTai = d
                self?.napDuLieu()
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(tieuDe: "Chọn ngày xem báo cáo", cacMuc: cacMuc, canGiuaText: true)
    }

    @objc private func moMenuXuatBaoCao() {
        if mucMenuChinh == .nhanVien || (mucMenuChinh == .doSoXemSo && mucConDoSo == .xemSo && tabXemSo == .nhanVien) {
            moMenuChiaSeAnhNhanVien()
            return
        }
        hienBangNutXuatAnh()
    }

    private func moMenuChiaSeAnhNhanVien() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let cheDoNV = cheDoDoanhThu
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .tenAZ, cheDo: cheDoNV)

        let cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "☁️ Tải ảnh từng nhân viên lên kho") { [weak self] in
                self?.xuatTatCaAnhLenServerSupabase(chiAnhNhanVien: true)
            },
            MucChonDMX(tieuDe: "📊 Bảng xếp hạng Nhân viên — Lũy kế") { [weak self] in
                guard let self = self,
                      let anh = self.bangNhanVien.taoAnhBaoCaoNhanVien(
                          ngay: self.ngayHienTai,
                          cheDo: .luyKe,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "⚡ Bảng xếp hạng Nhân viên — Realtime") { [weak self] in
                guard let self = self,
                      let anh = self.bangNhanVien.taoAnhBaoCaoNhanVien(
                          ngay: self.ngayHienTai,
                          cheDo: .realtime,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "❤️‍🩹 Biểu đồ sức khỏe \(dsNV.count) NV & Top 5 yếu") { [weak self] in
                guard let self = self,
                      let anh = self.bangRealtimeThang.taoAnhBaoCaoSucKhoeNhanVien(
                          ngay: self.ngayHienTai,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "🖼️ Ảnh gộp chi tiết \(dsNV.count) NV (\(cheDoNV.tieuDe))") { [weak self] in
                guard let self = self,
                      let anhGop = ManHinhChiTietNhanVien.taoAnhGopTatCaSucKhoe(cho: self.ngayHienTai, cheDo: cheDoNV) else { return }
                self.chiaSe([anhGop])
            },
            MucChonDMX(tieuDe: "📚 Xuất bộ \(dsNV.count) ảnh rời từng NV (\(cheDoNV.tieuDe))") { [weak self] in
                guard let self = self else { return }
                let cacAnh = ManHinhChiTietNhanVien.taoTatCaAnhSucKhoe(cho: self.ngayHienTai, cheDo: cheDoNV)
                guard !cacAnh.isEmpty else { return }
                self.chiaSe(cacAnh)
            },
            MucChonDMX(tieuDe: "👤 Chọn 1 nhân viên để xuất ảnh (\(cheDoNV.tieuDe))") { [weak self] in
                self?.moChonNhanVienChiaSeAnh(cheDo: cheDoNV)
            },
            MucChonDMX(tieuDe: "Đóng", kieu: .huy)
        ]

        hienMenuChon(
            tieuDe: "Xuất ảnh Nhân viên",
            cacMuc: cacMuc
        )
    }

    private func moMenuXuatBaoCaoCu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let kieu = KhoDuLieu.dungChung.caiDat.kieuHienThi
        let moTaKieu = (kieu == .bangChiTiet) ? "Bảng 8 cột" : "Thẻ \(KhoDuLieu.dungChung.caiDat.soCotXuatAnh) cột"
        let cheDoNV = cheDoDoanhThu
        let cheDoCSV = cheDoDoanhThu
        let dtDangChon = (cheDoCSV == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        let dsDangChon = dl.danhSachThiDua(theo: cheDoCSV)

        let cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "☁️ Tải ảnh báo cáo chung lên kho đã chọn") { [weak self] in
                self?.xuatTatCaAnhLenServerSupabase()
            },
            MucChonDMX(tieuDe: "🖼️ Mở mục 3. Xuất ảnh (Có ô Text báo cáo + Copy gửi LINE)") { [weak self] in
                self?.mucMenuChinh = .doSoXemSo
                self?.mucConDoSo = .xuatAnh
                self?.napDuLieu()
            },
            MucChonDMX(tieuDe: "📋 Copy JSON + câu lệnh tạo Excel / PowerPoint bằng AI khác") { [weak self] in
                self?.saoChepGoiJSONXuatFile()
            },
            MucChonDMX(tieuDe: "📊 Ảnh Thi đua Lũy kế — Thực hiện & Target (\(moTaKieu))") { [weak self] in
                guard let self = self,
                      let anh = self.bangThiDua.taoAnhBaoCao(
                          ngay: self.ngayHienTai,
                          doanhThu: self.doanhThuHienThi(dl.doanhThu, cheDo: .luyKe),
                          danhSach: dl.danhSachThiDua,
                          cheDoDoanhThu: .luyKe,
                          xemDuKien: false,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "📈 Ảnh Thi đua Lũy kế — % Dự kiến cuối tháng (\(moTaKieu))") { [weak self] in
                guard let self = self,
                      let anh = self.bangThiDua.taoAnhBaoCao(
                          ngay: self.ngayHienTai,
                          doanhThu: self.doanhThuHienThi(dl.doanhThu, cheDo: .luyKe),
                          danhSach: dl.danhSachThiDua,
                          cheDoDoanhThu: .luyKe,
                          xemDuKien: true,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "⚡ Ảnh Thi đua — Realtime (\(moTaKieu))") { [weak self] in
                guard let self = self,
                      let anh = self.bangThiDua.taoAnhBaoCao(
                          ngay: self.ngayHienTai,
                          doanhThu: self.doanhThuHienThi(dl.doanhThuRealtime, cheDo: .realtime),
                          danhSach: dl.danhSachThiDuaRealtime,
                          cheDoDoanhThu: .realtime,
                          xemDuKien: false,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "👥 Ảnh Bảng Xếp Hạng Nhân Viên (\(cheDoNV.tieuDe))") { [weak self] in
                guard let self = self else { return }
                self.bangNhanVien.capNhat(cho: self.ngayHienTai, cheDo: cheDoNV)
                guard let anh = self.bangNhanVien.taoAnhBaoCaoNhanVien(
                    ngay: self.ngayHienTai,
                    cheDo: cheDoNV,
                    thongTinDonVi: dl.thongTinDonVi,
                    capNhatLuc: dl.capNhatLuc
                ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "❤️‍🩹 Ảnh Biểu Đồ Sức Khỏe 16 NV & Cảnh Báo Top 5 Yếu") { [weak self] in
                guard let self = self,
                      let anh = self.bangRealtimeThang.taoAnhBaoCaoSucKhoeNhanVien(
                          ngay: self.ngayHienTai,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "👤 Ảnh Chi Tiết Từng Nhân Viên (\(cheDoNV.tieuDe))") { [weak self] in
                self?.moChonNhanVienChiaSeAnh(cheDo: cheDoNV)
            },
            MucChonDMX(tieuDe: "📈 Ảnh Biểu Đồ & Tổng Hợp Realtime Tháng (Toàn bộ bảng)") { [weak self] in
                guard let self = self,
                      let anh = self.bangRealtimeThang.taoAnhBaoCaoRealtimeThang(
                          ngay: self.ngayHienTai,
                          thongTinDonVi: dl.thongTinDonVi,
                          capNhatLuc: dl.capNhatLuc
                      ) else { return }
                self.chiaSe([anh])
            },
            MucChonDMX(tieuDe: "📑 Xuất file Biểu Đồ & Realtime Tháng (.csv)") { [weak self] in
                guard let self = self else { return }
                let csv = self.bangRealtimeThang.taoChuoiExcelCSVBieuDoThang(
                    ngay: self.ngayHienTai,
                    thongTinDonVi: dl.thongTinDonVi,
                    capNhatLuc: dl.capNhatLuc
                )
                let tenTep = "BieuDo-RealtimeThang-\(dl.khoaNgay.prefix(7)).csv"
                let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
                try? csv.write(to: duongDan, atomically: true, encoding: .utf8)
                self.chiaSe([duongDan])
            },
            MucChonDMX(tieuDe: "📄 Xuất file Excel (.csv) (\(cheDoCSV.tieuDe) + Biểu đồ)") { [weak self] in
                guard let self = self else { return }
                let csvThiDua = self.bangThiDua.taoChuoiExcelCSV(doanhThu: dtDangChon, danhSach: dsDangChon, cheDo: cheDoCSV, ngay: self.ngayHienTai)
                let csvBieuDo = self.bangRealtimeThang.taoChuoiExcelCSVBieuDoThang(
                    ngay: self.ngayHienTai,
                    thongTinDonVi: dl.thongTinDonVi,
                    capNhatLuc: dl.capNhatLuc
                ).replacingOccurrences(of: "\u{FEFF}", with: "")
                let csvGop = csvThiDua + "\n\n" + csvBieuDo
                let hauTo = (cheDoCSV == .luyKe) ? "LuyKe" : "Realtime"
                let tenTep = "TongHopDMX-\(dl.khoaNgay)-\(hauTo).csv"
                let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
                try? csvGop.write(to: duongDan, atomically: true, encoding: .utf8)
                self.chiaSe([duongDan])
            },
            MucChonDMX(tieuDe: "Đóng", kieu: .huy)
        ]

        hienMenuChon(
            tieuDe: "Chia sẻ ảnh & Xuất báo cáo",
            thongDiep: "Chọn loại ảnh hoặc file dữ liệu báo cáo bạn muốn chia sẻ hoặc lưu về máy:",
            cacMuc: cacMuc
        )
    }

    private func hienBangNutXuatAnh() {
        let cheDoNV = cheDoDoanhThu
        var cacNut: [(tieuDe: String, hanhDong: () -> Void)] = [
            (tieuDe: "☁️ Tải ảnh báo cáo chung lên kho", hanhDong: { [weak self] in
                self?.xuatTatCaAnhLenServerSupabase()
            }),
            (tieuDe: "❤️‍🩹 Tải ảnh từng nhân viên lên kho", hanhDong: { [weak self] in
                self?.xuatTatCaAnhLenServerSupabase(chiAnhNhanVien: true)
            })
        ]
        cacNut.append(contentsOf: LoaiBaoCaoXuatAnh.allCases.map { loai in
            (tieuDe: loai.tieuDeNgan, hanhDong: { [weak self] in
                guard let self, let anh = self.taoAnhTheoLoaiBaoCao(loai) else { return }
                self.chiaSe([anh])
            })
        })
        cacNut.append((
            tieuDe: "👤 Chọn 1 nhân viên để xuất ảnh (\(cheDoNV.tieuDe))",
            hanhDong: { [weak self] in
                self?.moChonNhanVienChiaSeAnh(cheDo: cheDoNV)
            }
        ))
        hienBangNut(tieuDe: "Xuất ảnh báo cáo", huongDan: "", cacNut: cacNut)
    }

    private func hienBangNut(tieuDe: String, huongDan: String, cacNut: [(tieuDe: String, hanhDong: () -> Void)], nguyHiem: Bool = false) {
        let kieuMuc: MucChonDMX.KieuMuc = nguyHiem ? .nguyHiem : .macDinh
        var cacMuc: [MucChonDMX] = cacNut.map { muc in
            MucChonDMX(tieuDe: muc.tieuDe, kieu: kieuMuc) {
                muc.hanhDong()
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: tieuDe, cacMuc: cacMuc)
    }

    private func saoChepGoiJSONXuatFile() {
        let s = KhoDuLieu.dungChung.taoSoLieuBanTin(cho: ngayHienTai, khung: KhungBanTin.theoGio())
        let yc = DichVuGeminiAI.dungChung.yeuCauTuyChinhHienTai
        let noiDung = BoVietBanTin(soLieu: s, giong: .binhThuong).vietTheoMauAnhChup()
        UIPasteboard.general.string = GoiDuLieuXuatAI.tao(soLieu: s, noiDungBaoCao: noiDung, yeuCau: yc)
        let thongBao = UIAlertController(title: "Đã copy JSON", message: "Đã sao chép toàn bộ số liệu và câu lệnh. Hãy mở Copilot hoặc ứng dụng AI khác, dán vào rồi yêu cầu tạo Excel/PowerPoint.", preferredStyle: .alert)
        thongBao.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(thongBao, animated: true)
    }

    @objc private func bamCopyJSONXuatFileTuMenu() {
        saoChepGoiJSONXuatFile()
    }

    private func moChonNhanVienChiaSeAnh(cheDo: LoaiCheDoDoanhThu) {
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .tenAZ, cheDo: cheDo)
        guard !dsNV.isEmpty else { return }

        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "📚 Xuất bộ \(dsNV.count) ảnh rời tất cả NV") { [weak self] in
                guard let self = self else { return }
                let cacAnh = ManHinhChiTietNhanVien.taoTatCaAnhSucKhoe(cho: self.ngayHienTai, cheDo: cheDo)
                guard !cacAnh.isEmpty else { return }
                self.chiaSe(cacAnh)
            },
            MucChonDMX(tieuDe: "☁️ Tải ảnh sức khỏe \(dsNV.count) NV lên kho") { [weak self] in
                guard let self = self else { return }
                self.xuatTatCaAnhLenServerSupabase(chiAnhNhanVien: true)
            },
            MucChonDMX(tieuDe: "🖼️ Xuất 1 ảnh gộp tất cả \(dsNV.count) NV") { [weak self] in
                guard let self = self,
                      let anhGop = ManHinhChiTietNhanVien.taoAnhGopTatCaSucKhoe(cho: self.ngayHienTai, cheDo: cheDo) else { return }
                self.chiaSe([anhGop])
            }
        ]

        for (i, item) in dsNV.enumerated() {
            let tieuDe = "👤 \(i + 1). \(item.nhanVien.hoTen) (\(item.soMonDat)/\(item.tongMonGiao) môn • \(String(format: "%.1f%%", item.phanTramHTTB)))"
            cacMuc.append(MucChonDMX(tieuDe: tieuDe) { [weak self] in
                guard let self = self,
                      let anh = ManHinhChiTietNhanVien.taoAnhSucKhoe(cho: item, ngay: self.ngayHienTai, cheDo: cheDo) else { return }
                self.chiaSe([anh])
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(
            tieuDe: "Xuất ảnh Sức khoẻ Nhân viên (\(cheDo.tieuDe))",
            cacMuc: cacMuc
        )
    }

    private func chiaSe(_ muc: [Any]) {
        let vc = UIActivityViewController(activityItems: muc, applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = view
            pop.sourceRect = CGRect(x: view.bounds.midX, y: 80, width: 1, height: 1)
        }
        present(vc, animated: true)
    }
}
