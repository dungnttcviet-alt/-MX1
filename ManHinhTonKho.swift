import UIKit

// MARK: - Hộp Thoại Chọn Nhóm Hàng / Trạng Thái Tồn Kho (Chuẩn Nhận Diện Thương Hiệu ĐMX + Ô Tìm Kiếm Nhanh)

final class HopThoaiChonNhomHangDMX: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    struct MucChon {
        let giaTri: String
        let hienThi: String
        let laTatCa: Bool
    }

    private let tieuDeChinh: String
    private let phuDe: String
    private let goiYTimKiem: String
    private let tatCaMuc: [MucChon]
    private var cacMucDaLoc: [MucChon] = []
    private var giaTriDangChon: String?
    private let khiChon: (String) -> Void

    private let oTimKiem = UITextField()
    private let nhanSoLuong = UILabel()
    private let bangDanhSach = UITableView(frame: .zero, style: .plain)
    private let nhanKhongCoKetQua = UILabel()

    init(
        tieuDe: String,
        phuDe: String,
        goiYTimKiem: String,
        tatCaMuc: [MucChon],
        giaTriDangChon: String?,
        khiChon: @escaping (String) -> Void
    ) {
        self.tieuDeChinh = tieuDe
        self.phuDe = phuDe
        self.goiYTimKiem = goiYTimKiem
        self.tatCaMuc = tatCaMuc
        self.cacMucDaLoc = tatCaMuc
        self.giaTriDangChon = giaTriDangChon
        self.khiChon = khiChon
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *), let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .large
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private static func boDauTiengViet(_ s: String) -> String {
        s.folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "d")
            .lowercased()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = UIColor.black.withAlphaComponent(0.15)

        let khung = UIView()
        khung.backgroundColor = BangMauBCTD.xanhChuDao
        khung.layer.cornerRadius = 18
        khung.layer.borderWidth = 2.5
        khung.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        khung.clipsToBounds = true
        khung.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khung)

        let vachTrai = UIView()
        vachTrai.backgroundColor = BangMauBCTD.vangSang
        vachTrai.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(vachTrai)

        // Header: Tiêu đề vàng tươi ĐMX + Nút Đóng
        let lbTieuDe = UILabel()
        lbTieuDe.text = tieuDeChinh
        lbTieuDe.font = .systemFont(ofSize: 15.5, weight: .heavy)
        lbTieuDe.textColor = BangMauBCTD.vangSang
        lbTieuDe.numberOfLines = 0

        let nutDong = UIButton(type: .system)
        nutDong.setTitle("Đóng", for: .normal)
        nutDong.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .heavy)
        nutDong.backgroundColor = BangMauBCTD.vangSang
        nutDong.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutDong.layer.cornerRadius = 9
        nutDong.layer.borderWidth = 1.5
        nutDong.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutDong.contentEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
        nutDong.setContentHuggingPriority(.required, for: .horizontal)
        nutDong.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutDong.addTarget(self, action: #selector(bamDong), for: .touchUpInside)

        let hangDau = UIStackView(arrangedSubviews: [lbTieuDe, nutDong])
        hangDau.axis = .horizontal
        hangDau.spacing = 8
        hangDau.alignment = .center

        let lbPhuDe = UILabel()
        lbPhuDe.text = phuDe
        lbPhuDe.font = .systemFont(ofSize: 12.0, weight: .semibold)
        lbPhuDe.textColor = .white
        lbPhuDe.numberOfLines = 0

        // Ô tìm kiếm nhanh chuẩn ĐMX (Nền vàng nhạt / trắng sáng, viền vàng tươi, icon kính lúp)
        let khungTimKiem = UIView()
        khungTimKiem.backgroundColor = .white
        khungTimKiem.layer.cornerRadius = 11
        khungTimKiem.layer.borderWidth = 2.0
        khungTimKiem.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        khungTimKiem.translatesAutoresizingMaskIntoConstraints = false

        let iconTim = UIImageView(image: UIImage(
            systemName: "magnifyingglass",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        ))
        iconTim.tintColor = BangMauBCTD.xanhChuDaoDam
        iconTim.translatesAutoresizingMaskIntoConstraints = false
        khungTimKiem.addSubview(iconTim)

        oTimKiem.placeholder = goiYTimKiem
        oTimKiem.font = .systemFont(ofSize: 14.0, weight: .bold)
        oTimKiem.textColor = BangMauBCTD.chuChinh
        oTimKiem.clearButtonMode = .whileEditing
        oTimKiem.returnKeyType = .search
        oTimKiem.autocorrectionType = .no
        oTimKiem.autocapitalizationType = .none
        oTimKiem.delegate = self
        oTimKiem.addTarget(self, action: #selector(tuKhoaThayDoi), for: .editingChanged)
        oTimKiem.translatesAutoresizingMaskIntoConstraints = false
        khungTimKiem.addSubview(oTimKiem)

        NSLayoutConstraint.activate([
            khungTimKiem.heightAnchor.constraint(equalToConstant: 42),
            iconTim.leadingAnchor.constraint(equalTo: khungTimKiem.leadingAnchor, constant: 12),
            iconTim.centerYAnchor.constraint(equalTo: khungTimKiem.centerYAnchor),
            iconTim.widthAnchor.constraint(equalToConstant: 18),
            iconTim.heightAnchor.constraint(equalToConstant: 18),

            oTimKiem.leadingAnchor.constraint(equalTo: iconTim.trailingAnchor, constant: 8),
            oTimKiem.trailingAnchor.constraint(equalTo: khungTimKiem.trailingAnchor, constant: -8),
            oTimKiem.topAnchor.constraint(equalTo: khungTimKiem.topAnchor),
            oTimKiem.bottomAnchor.constraint(equalTo: khungTimKiem.bottomAnchor)
        ])

        nhanSoLuong.font = .systemFont(ofSize: 11.5, weight: .bold)
        nhanSoLuong.textColor = BangMauBCTD.vangSang
        nhanSoLuong.numberOfLines = 1

        // Khung bảng danh sách nhóm hàng
        let khungBang = UIView()
        khungBang.backgroundColor = .white
        khungBang.layer.cornerRadius = 12
        khungBang.layer.borderWidth = 1.8
        khungBang.layer.borderColor = BangMauBCTD.vangSang.cgColor
        khungBang.clipsToBounds = true
        khungBang.translatesAutoresizingMaskIntoConstraints = false

        bangDanhSach.backgroundColor = .white
        bangDanhSach.separatorStyle = .none
        bangDanhSach.rowHeight = UITableView.automaticDimension
        bangDanhSach.estimatedRowHeight = 48
        bangDanhSach.keyboardDismissMode = .onDrag
        bangDanhSach.dataSource = self
        bangDanhSach.delegate = self
        bangDanhSach.register(ODongNhomHangDMXCell.self, forCellReuseIdentifier: ODongNhomHangDMXCell.maTaiSuDung)
        bangDanhSach.translatesAutoresizingMaskIntoConstraints = false
        khungBang.addSubview(bangDanhSach)

        nhanKhongCoKetQua.text = "Không tìm thấy mục nào khớp từ khóa."
        nhanKhongCoKetQua.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nhanKhongCoKetQua.textColor = BangMauBCTD.chuPhu
        nhanKhongCoKetQua.textAlignment = .center
        nhanKhongCoKetQua.numberOfLines = 0
        nhanKhongCoKetQua.isHidden = true
        nhanKhongCoKetQua.translatesAutoresizingMaskIntoConstraints = false
        khungBang.addSubview(nhanKhongCoKetQua)

        [hangDau, lbPhuDe, khungTimKiem, nhanSoLuong, khungBang].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khung.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khung.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            khung.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            khung.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            khung.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),

            vachTrai.topAnchor.constraint(equalTo: khung.topAnchor),
            vachTrai.bottomAnchor.constraint(equalTo: khung.bottomAnchor),
            vachTrai.leadingAnchor.constraint(equalTo: khung.leadingAnchor),
            vachTrai.widthAnchor.constraint(equalToConstant: 5),

            hangDau.topAnchor.constraint(equalTo: khung.topAnchor, constant: 12),
            hangDau.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            hangDau.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),

            lbPhuDe.topAnchor.constraint(equalTo: hangDau.bottomAnchor, constant: 4),
            lbPhuDe.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            lbPhuDe.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),

            khungTimKiem.topAnchor.constraint(equalTo: lbPhuDe.bottomAnchor, constant: 8),
            khungTimKiem.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            khungTimKiem.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),

            nhanSoLuong.topAnchor.constraint(equalTo: khungTimKiem.bottomAnchor, constant: 6),
            nhanSoLuong.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            nhanSoLuong.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),

            khungBang.topAnchor.constraint(equalTo: nhanSoLuong.bottomAnchor, constant: 6),
            khungBang.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 10),
            khungBang.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -10),
            khungBang.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -10),

            bangDanhSach.topAnchor.constraint(equalTo: khungBang.topAnchor, constant: 4),
            bangDanhSach.leadingAnchor.constraint(equalTo: khungBang.leadingAnchor),
            bangDanhSach.trailingAnchor.constraint(equalTo: khungBang.trailingAnchor),
            bangDanhSach.bottomAnchor.constraint(equalTo: khungBang.bottomAnchor, constant: -4),

            nhanKhongCoKetQua.centerYAnchor.constraint(equalTo: khungBang.centerYAnchor),
            nhanKhongCoKetQua.leadingAnchor.constraint(equalTo: khungBang.leadingAnchor, constant: 20),
            nhanKhongCoKetQua.trailingAnchor.constraint(equalTo: khungBang.trailingAnchor, constant: -20)
        ])

        capNhatDanhSachTheoTuKhoa()
    }

    @objc private func bamDong() {
        dismiss(animated: true)
    }

    @objc private func tuKhoaThayDoi() {
        capNhatDanhSachTheoTuKhoa()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func capNhatDanhSachTheoTuKhoa() {
        let tuKhoa = (oTimKiem.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if tuKhoa.isEmpty {
            cacMucDaLoc = tatCaMuc
        } else {
            let tkKhongDau = Self.boDauTiengViet(tuKhoa)
            let tkThuong = tuKhoa.lowercased()
            cacMucDaLoc = tatCaMuc.filter { muc in
                let tenThuong = muc.hienThi.lowercased()
                if tenThuong.contains(tkThuong) { return true }
                return Self.boDauTiengViet(muc.hienThi).contains(tkKhongDau)
            }
        }
        nhanSoLuong.text = tuKhoa.isEmpty
            ? "📋 Hiển thị \(cacMucDaLoc.count) lựa chọn • Chạm vào dòng bất kỳ để lọc ngay:"
            : "🔎 Tìm thấy \(cacMucDaLoc.count) kết quả cho “\(tuKhoa)”:"
        nhanKhongCoKetQua.isHidden = !cacMucDaLoc.isEmpty
        bangDanhSach.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cacMucDaLoc.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ODongNhomHangDMXCell.maTaiSuDung, for: indexPath) as? ODongNhomHangDMXCell else {
            return UITableViewCell()
        }
        let muc = cacMucDaLoc[indexPath.row]
        let dangChon = (muc.giaTri == giaTriDangChon)
        cell.cauHinh(muc: muc, dangChon: dangChon)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let muc = cacMucDaLoc[indexPath.row]
        giaTriDangChon = muc.giaTri
        khiChon(muc.giaTri)
        dismiss(animated: true)
    }
}

private final class ODongNhomHangDMXCell: UITableViewCell {
    static let maTaiSuDung = "ODongNhomHangDMXCell"

    private let theNen = UIView()
    private let vachTrai = UIView()
    private let nhanTen = UILabel()
    private let nhanTrangThaiChon = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        theNen.layer.cornerRadius = 10
        theNen.clipsToBounds = true
        theNen.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(theNen)

        vachTrai.translatesAutoresizingMaskIntoConstraints = false
        theNen.addSubview(vachTrai)

        nhanTen.font = .systemFont(ofSize: 14.0, weight: .bold)
        nhanTen.numberOfLines = 0
        nhanTen.lineBreakMode = .byWordWrapping
        nhanTen.translatesAutoresizingMaskIntoConstraints = false
        theNen.addSubview(nhanTen)

        nhanTrangThaiChon.font = .systemFont(ofSize: 12.0, weight: .heavy)
        nhanTrangThaiChon.textAlignment = .center
        nhanTrangThaiChon.layer.cornerRadius = 6
        nhanTrangThaiChon.clipsToBounds = true
        nhanTrangThaiChon.setContentHuggingPriority(.required, for: .horizontal)
        nhanTrangThaiChon.setContentCompressionResistancePriority(.required, for: .horizontal)
        nhanTrangThaiChon.translatesAutoresizingMaskIntoConstraints = false
        theNen.addSubview(nhanTrangThaiChon)

        NSLayoutConstraint.activate([
            theNen.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3.5),
            theNen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.5),
            theNen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            theNen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            vachTrai.topAnchor.constraint(equalTo: theNen.topAnchor),
            vachTrai.bottomAnchor.constraint(equalTo: theNen.bottomAnchor),
            vachTrai.leadingAnchor.constraint(equalTo: theNen.leadingAnchor),
            vachTrai.widthAnchor.constraint(equalToConstant: 5),

            nhanTen.topAnchor.constraint(equalTo: theNen.topAnchor, constant: 10),
            nhanTen.bottomAnchor.constraint(equalTo: theNen.bottomAnchor, constant: -10),
            nhanTen.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 10),
            nhanTen.trailingAnchor.constraint(lessThanOrEqualTo: nhanTrangThaiChon.leadingAnchor, constant: -8),

            nhanTrangThaiChon.centerYAnchor.constraint(equalTo: theNen.centerYAnchor),
            nhanTrangThaiChon.trailingAnchor.constraint(equalTo: theNen.trailingAnchor, constant: -10),
            nhanTrangThaiChon.widthAnchor.constraint(greaterThanOrEqualToConstant: 26),
            nhanTrangThaiChon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    func cauHinh(muc: HopThoaiChonNhomHangDMX.MucChon, dangChon: Bool) {
        let bieuTuong = muc.laTatCa ? "📋 " : "📦 "
        nhanTen.text = bieuTuong + muc.hienThi
        if dangChon {
            theNen.backgroundColor = BangMauBCTD.vangNhatNen
            theNen.layer.borderWidth = 1.8
            theNen.layer.borderColor = BangMauBCTD.xanhChuDao.cgColor
            nhanTen.textColor = BangMauBCTD.xanhChuDaoDam
            vachTrai.backgroundColor = BangMauBCTD.vangChuDao
            nhanTrangThaiChon.text = "✓"
            nhanTrangThaiChon.backgroundColor = BangMauBCTD.xanhChuDao
            nhanTrangThaiChon.textColor = BangMauBCTD.vangSang
        } else {
            theNen.backgroundColor = muc.laTatCa ? BangMauBCTD.nenHeaderPhu : BangMauBCTD.nenThePhu
            theNen.layer.borderWidth = 1.0
            theNen.layer.borderColor = (muc.laTatCa ? BangMauBCTD.vienXanhNhat : BangMauBCTD.vienThe).cgColor
            nhanTen.textColor = muc.laTatCa ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuChinh
            vachTrai.backgroundColor = muc.laTatCa ? BangMauBCTD.xanhChuDao : BangMauBCTD.vienDam
            nhanTrangThaiChon.text = "▸"
            nhanTrangThaiChon.backgroundColor = .clear
            nhanTrangThaiChon.textColor = BangMauBCTD.chuMo
        }
    }
}

// MARK: - Khung Lọc Dữ Liệu Tồn Kho Từ Google Sheet (19 Cột A -> S)

final class KhungLocTonKhoView: UIView, UITextFieldDelegate {
    private static let khoaLuuLinkSheet = "dmx_ton_kho_google_sheet_url_v2"
    private static let khoaLuuMaSieuThi = "dmx_ton_kho_ma_sieu_thi_v2"

    /// Chuẩn hoá chuỗi ô Sheet về Unicode dựng sẵn (NFC) và xoá khoảng trắng thừa / ký tự ẩn
    private static func chuanHoaChuoiO(_ raw: String) -> String {
        raw.replacingOccurrences(of: "\u{00A0}", with: " ")
           .replacingOccurrences(of: "\u{200B}", with: "")
           .replacingOccurrences(of: "\u{FEFF}", with: "")
           .trimmingCharacters(in: .whitespacesAndNewlines)
           .precomposedStringWithCanonicalMapping
    }

    /// Kiểm tra chính xác Cột A bắt đầu bằng cụm ký tự người dùng nhập vào
    private static func khopCotABatDauVoi(_ cotA: String, cumKyTu: String) -> Bool {
        let mau = chuanHoaChuoiO(cumKyTu)
        guard !mau.isEmpty else { return true }
        let giaTriCotA = chuanHoaChuoiO(cotA)
        return giaTriCotA.lowercased().hasPrefix(mau.lowercased())
    }

    /// Kiểm tra khớp Trạng thái sản phẩm ở Cột H (hỗ trợ đầy đủ trạng thái Mới, Trưng bày và mọi trạng thái trong Sheet)
    private static func khopTrangThaiCotH(_ cotH: String, trangThaiChon: String, coChuoiMoiTrongSheet: Bool) -> Bool {
        let h = chuanHoaChuoiO(cotH)
        let chon = chuanHoaChuoiO(trangThaiChon)
        guard !chon.isEmpty && chon != "__ALL__" else { return true }
        if h.caseInsensitiveCompare(chon) == .orderedSame { return true }

        let hLow = h.lowercased()
        let chonLow = chon.lowercased()
        if chonLow == "mới" || chonLow == "trạng thái mới" || chonLow == "hàng mới" {
            if hLow == "mới" || hLow == "trạng thái mới" || hLow == "hàng mới" || hLow.hasPrefix("mới ") || hLow.hasSuffix(" mới") {
                return true
            }
            if !coChuoiMoiTrongSheet && hLow.isEmpty {
                return true
            }
            return false
        }
        if chonLow == "trưng bày" || chonLow == "trạng thái trưng bày" || chonLow == "hàng trưng bày" {
            return hLow.contains("trưng bày")
        }
        return false
    }

    /// 19 cột chuẩn theo thứ tự từ A đến S
    static let tenCacCotChuan: [String] = [
        "Tên siêu thị",                           // A (0)
        "Mã Model",                               // B (1)
        "Mã sản phẩm",                            // C (2)
        "Tên sản phẩm",                           // D (3)
        "Đơn vị",                                 // E (4)
        "Ngành hàng",                             // F (5)
        "Nhóm hàng",                              // G (6)
        "Trạng thái sản phẩm",                    // H (7)
        "Số lượng",                               // I (8)
        "Số lượng không bao gồm hàng đi đường",   // J (9)
        "Số lượng đặt",                           // K (10)
        "Số lượng được chia đến",                 // L (11)
        "Số lượng đang  đi đường",                // M (12)
        "Số lượng đang chia đi",                  // N (13)
        "Số lượng đã đặt",                        // O (14)
        "Số lượng có thể bán",                    // P (15)
        "SL tồn kho tối thiểu",                   // Q (16)
        "Có in QR",                               // R (17)
        "Số lượng tồn lô"                         // S (18)
    ]

    /// Chỉ hiển thị và xuất ảnh 6 cột: A (0), C (2), D (3), G (6), H (7), I (8)
    static let chiSoCotHienThi: [Int] = [
        0, // A: Tên siêu thị
        2, // C: Mã sản phẩm
        3, // D: Tên sản phẩm
        6, // G: Nhóm hàng
        7, // H: Trạng thái sản phẩm
        8  // I: Số lượng
    ]

    static let doRongCacCot: [CGFloat] = [
        180, // A: Tên siêu thị
        125, // C: Mã sản phẩm
        250, // D: Tên sản phẩm
        150, // G: Nhóm hàng
        150, // H: Trạng thái sản phẩm
        90   // I: Số lượng
    ]

    var khiXuatAnh: ((UIImage) -> Void)?

    private let oLinkSheet = UITextField()
    private let nutTaiSheet = UIButton(type: .system)
    private let oMaSieuThi = UITextField()
    private let nutLocSieuThi = UIButton(type: .system)
    private let nutChonNhomHang = UIButton(type: .system)
    private let nutChonTrangThai = UIButton(type: .system)
    private let nhanTrangThai = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .medium)

    private let cuonNgang = UIScrollView()
    private let cuonDoc = UIScrollView()
    private let nganBang = UIStackView()
    private let khungTrong = UIView()
    private let nhanTrong = UILabel()

    private var tatCaDong: [[String]] = []
    private var dsNhomHang: [String] = []
    private var dsTrangThai: [String] = ["Mới", "Trưng bày"]
    private var maSieuThiDangLoc: String = ""
    private var nhomHangDangChon: String? = nil   // nil = chưa chọn; "__ALL__" = tất cả
    private var trangThaiDangChon: String = "__ALL__"
    private var cacDongDaLoc: [[String]] = []
    private var dangTaiSheet = false
    private var daTuDongTaiLanDau = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    func kichHoatNeuCan() {
        let link = (oLinkSheet.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !daTuDongTaiLanDau && !link.isEmpty && tatCaDong.isEmpty && !dangTaiSheet {
            daTuDongTaiLanDau = true
            bamTaiSheet()
        }
    }

    private func taoGiaoDien() {
        backgroundColor = BangMauBCTD.nenTrang

        let theBoLoc = UIView()
        theBoLoc.backgroundColor = BangMauBCTD.nenThe
        theBoLoc.layer.cornerRadius = 12
        theBoLoc.layer.borderWidth = 1
        theBoLoc.layer.borderColor = BangMauBCTD.vienThe.cgColor
        theBoLoc.translatesAutoresizingMaskIntoConstraints = false
        addSubview(theBoLoc)

        let lbLink = UILabel()
        lbLink.text = "🔗 LINK GOOGLE SHEET TỒN KHO:"
        lbLink.font = .systemFont(ofSize: 11.5, weight: .heavy)
        lbLink.textColor = BangMauBCTD.xanhChuDaoDam

        let linkLuu = UserDefaults.standard.string(forKey: Self.khoaLuuLinkSheet) ?? ""
        oLinkSheet.text = linkLuu
        oLinkSheet.placeholder = "Dán link Google Sheet tồn kho..."
        oLinkSheet.font = .systemFont(ofSize: 12.5, weight: .medium)
        oLinkSheet.textColor = BangMauBCTD.chuChinh
        oLinkSheet.backgroundColor = BangMauBCTD.nenThePhu
        oLinkSheet.layer.cornerRadius = 8
        oLinkSheet.layer.borderWidth = 1
        oLinkSheet.layer.borderColor = BangMauBCTD.vienDam.cgColor
        oLinkSheet.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        oLinkSheet.leftViewMode = .always
        oLinkSheet.clearButtonMode = .whileEditing
        oLinkSheet.keyboardType = .URL
        oLinkSheet.autocapitalizationType = .none
        oLinkSheet.autocorrectionType = .no
        oLinkSheet.returnKeyType = .go
        oLinkSheet.delegate = self
        oLinkSheet.heightAnchor.constraint(equalToConstant: 34).isActive = true

        nutTaiSheet.setTitle("🔄 Quét Sheet", for: .normal)
        nutTaiSheet.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .heavy)
        nutTaiSheet.backgroundColor = BangMauBCTD.xanhChuDao
        nutTaiSheet.setTitleColor(.white, for: .normal)
        nutTaiSheet.layer.cornerRadius = 8
        nutTaiSheet.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutTaiSheet.setContentHuggingPriority(.required, for: .horizontal)
        nutTaiSheet.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutTaiSheet.addTarget(self, action: #selector(bamTaiSheet), for: .touchUpInside)

        let hangLink = UIStackView(arrangedSubviews: [oLinkSheet, nutTaiSheet])
        hangLink.axis = .horizontal
        hangLink.spacing = 6
        hangLink.alignment = .fill

        // Hàng 2: Nhập mã siêu thị (Cột A) + Nút Lọc (Ô nhập rộng rãi, không bị ép hẹp)
        let lbSieuThi = UILabel()
        lbSieuThi.text = "🏪 Siêu thị (Cột A):"
        lbSieuThi.font = .systemFont(ofSize: 12.0, weight: .bold)
        lbSieuThi.textColor = BangMauBCTD.chuChinh
        lbSieuThi.setContentHuggingPriority(.required, for: .horizontal)
        lbSieuThi.setContentCompressionResistancePriority(.required, for: .horizontal)

        let maLuu = (UserDefaults.standard.string(forKey: Self.khoaLuuMaSieuThi) ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        maSieuThiDangLoc = maLuu
        oMaSieuThi.text = maLuu
        oMaSieuThi.placeholder = "Nhập mã/tên siêu thị (VD: 2776)..."
        oMaSieuThi.font = .systemFont(ofSize: 13.5, weight: .bold)
        oMaSieuThi.textColor = BangMauBCTD.xanhChuDaoDam
        oMaSieuThi.backgroundColor = BangMauBCTD.vangNhatNen
        oMaSieuThi.layer.cornerRadius = 8
        oMaSieuThi.layer.borderWidth = 1.4
        oMaSieuThi.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        oMaSieuThi.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        oMaSieuThi.leftViewMode = .always
        oMaSieuThi.clearButtonMode = .whileEditing
        oMaSieuThi.returnKeyType = .search
        oMaSieuThi.delegate = self
        oMaSieuThi.setContentHuggingPriority(.defaultLow, for: .horizontal)
        oMaSieuThi.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        oMaSieuThi.heightAnchor.constraint(equalToConstant: 36).isActive = true
        oMaSieuThi.widthAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true

        nutLocSieuThi.setTitle("🔍 Lọc", for: .normal)
        nutLocSieuThi.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .heavy)
        nutLocSieuThi.backgroundColor = BangMauBCTD.xanhChuDao
        nutLocSieuThi.setTitleColor(.white, for: .normal)
        nutLocSieuThi.layer.cornerRadius = 8
        nutLocSieuThi.layer.borderWidth = 1.2
        nutLocSieuThi.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nutLocSieuThi.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        nutLocSieuThi.setContentHuggingPriority(.required, for: .horizontal)
        nutLocSieuThi.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutLocSieuThi.addTarget(self, action: #selector(bamLocSieuThi), for: .touchUpInside)

        let hangSieuThi = UIStackView(arrangedSubviews: [lbSieuThi, oMaSieuThi, nutLocSieuThi])
        hangSieuThi.axis = .horizontal
        hangSieuThi.spacing = 6
        hangSieuThi.alignment = .center
        hangSieuThi.distribution = .fill

        // Hàng 3: Combobox Nhóm hàng (Cột G) thiết kế nhận diện ĐMX có tìm kiếm & Trạng thái (Cột H)
        cauHinhNutComboboxDMX(nutChonNhomHang, tieuDe: "📂 Nhóm hàng (Cột G): Chưa chọn ▾", laChinh: true)
        nutChonNhomHang.addTarget(self, action: #selector(bamMoChonNhomHangDMX), for: .touchUpInside)

        cauHinhNutComboboxDMX(nutChonTrangThai, tieuDe: "🏷️ Trạng thái (Cột H): Tất cả ▾", laChinh: false)
        nutChonTrangThai.showsMenuAsPrimaryAction = true

        let hangCombo = UIStackView(arrangedSubviews: [nutChonNhomHang, nutChonTrangThai])
        hangCombo.axis = .horizontal
        hangCombo.spacing = 6
        hangCombo.distribution = .fillEqually

        vongQuay.hidesWhenStopped = true
        vongQuay.color = BangMauBCTD.xanhChuDao

        nhanTrangThai.text = "Nhập link Google Sheet, mã siêu thị rồi bấm “Lọc” và chọn Nhóm hàng (Cột G) để hiển thị bảng tồn kho."
        nhanTrangThai.font = .systemFont(ofSize: 11.5, weight: .semibold)
        nhanTrangThai.textColor = BangMauBCTD.chuPhu
        nhanTrangThai.numberOfLines = 0

        let hangTrangThai = UIStackView(arrangedSubviews: [vongQuay, nhanTrangThai])
        hangTrangThai.axis = .horizontal
        hangTrangThai.spacing = 6
        hangTrangThai.alignment = .center

        let nganLoc = UIStackView(arrangedSubviews: [lbLink, hangLink, hangSieuThi, hangCombo, hangTrangThai])
        nganLoc.axis = .vertical
        nganLoc.spacing = 6
        nganLoc.translatesAutoresizingMaskIntoConstraints = false
        theBoLoc.addSubview(nganLoc)

        // Khung bảng 19 cột (A -> S) bên dưới
        let theBang = UIView()
        theBang.backgroundColor = BangMauBCTD.nenThe
        theBang.layer.cornerRadius = 12
        theBang.layer.borderWidth = 1
        theBang.layer.borderColor = BangMauBCTD.vienThe.cgColor
        theBang.clipsToBounds = true
        theBang.translatesAutoresizingMaskIntoConstraints = false
        addSubview(theBang)

        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.bounces = true
        cuonNgang.translatesAutoresizingMaskIntoConstraints = false
        theBang.addSubview(cuonNgang)

        cuonDoc.showsVerticalScrollIndicator = true
        cuonDoc.alwaysBounceVertical = true
        cuonDoc.translatesAutoresizingMaskIntoConstraints = false
        cuonNgang.addSubview(cuonDoc)

        nganBang.axis = .vertical
        nganBang.spacing = 0
        nganBang.alignment = .fill
        nganBang.translatesAutoresizingMaskIntoConstraints = false
        cuonDoc.addSubview(nganBang)

        khungTrong.backgroundColor = BangMauBCTD.nenThe
        khungTrong.translatesAutoresizingMaskIntoConstraints = false
        theBang.addSubview(khungTrong)

        nhanTrong.text = "📦 Hãy bấm “Quét Sheet” và chọn Nhóm hàng (Cột G) trên Combobox để hiển thị bảng dữ liệu tồn kho (Cột A, C, D, G, H, I)."
        nhanTrong.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nhanTrong.textColor = BangMauBCTD.chuPhu
        nhanTrong.textAlignment = .center
        nhanTrong.numberOfLines = 0
        nhanTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nhanTrong)

        let tongRongBang = Self.doRongCacCot.reduce(0, +)

        NSLayoutConstraint.activate([
            theBoLoc.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            theBoLoc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            theBoLoc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            nganLoc.topAnchor.constraint(equalTo: theBoLoc.topAnchor, constant: 8),
            nganLoc.leadingAnchor.constraint(equalTo: theBoLoc.leadingAnchor, constant: 10),
            nganLoc.trailingAnchor.constraint(equalTo: theBoLoc.trailingAnchor, constant: -10),
            nganLoc.bottomAnchor.constraint(equalTo: theBoLoc.bottomAnchor, constant: -8),

            theBang.topAnchor.constraint(equalTo: theBoLoc.bottomAnchor, constant: 6),
            theBang.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            theBang.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            theBang.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),

            cuonNgang.topAnchor.constraint(equalTo: theBang.topAnchor),
            cuonNgang.leadingAnchor.constraint(equalTo: theBang.leadingAnchor),
            cuonNgang.trailingAnchor.constraint(equalTo: theBang.trailingAnchor),
            cuonNgang.bottomAnchor.constraint(equalTo: theBang.bottomAnchor),

            cuonDoc.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            cuonDoc.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            cuonDoc.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            cuonDoc.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            cuonDoc.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),
            cuonDoc.widthAnchor.constraint(equalToConstant: tongRongBang),

            nganBang.topAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.topAnchor),
            nganBang.leadingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.leadingAnchor),
            nganBang.trailingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.trailingAnchor),
            nganBang.bottomAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.bottomAnchor),
            nganBang.widthAnchor.constraint(equalToConstant: tongRongBang),

            khungTrong.topAnchor.constraint(equalTo: theBang.topAnchor),
            khungTrong.leadingAnchor.constraint(equalTo: theBang.leadingAnchor),
            khungTrong.trailingAnchor.constraint(equalTo: theBang.trailingAnchor),
            khungTrong.bottomAnchor.constraint(equalTo: theBang.bottomAnchor),

            nhanTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nhanTrong.leadingAnchor.constraint(equalTo: khungTrong.leadingAnchor, constant: 24),
            nhanTrong.trailingAnchor.constraint(equalTo: khungTrong.trailingAnchor, constant: -24)
        ])

        capNhatMenuCombobox()
    }

    private func cauHinhNutComboboxDMX(_ nut: UIButton, tieuDe: String, laChinh: Bool) {
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .heavy)
        nut.titleLabel?.numberOfLines = 2
        nut.titleLabel?.lineBreakMode = .byTruncatingTail
        nut.contentHorizontalAlignment = .left
        if laChinh {
            nut.backgroundColor = BangMauBCTD.xanhChuDao
            nut.setTitleColor(BangMauBCTD.vangSang, for: .normal)
            nut.layer.cornerRadius = 9
            nut.layer.borderWidth = 1.6
            nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        } else {
            nut.backgroundColor = BangMauBCTD.nenHeaderPhu
            nut.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
            nut.layer.cornerRadius = 9
            nut.layer.borderWidth = 1.2
            nut.layer.borderColor = BangMauBCTD.xanhChuDao.cgColor
        }
        nut.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }

    @objc private func bamMoChonNhomHangDMX() {
        endEditing(true)
        guard !tatCaDong.isEmpty else {
            nhanTrangThai.text = "⚠️ Hãy bấm “Quét Sheet” để tải danh sách Nhóm hàng (Cột G) trước!"
            nhanTrangThai.textColor = BangMauBCTD.doYeuChu
            return
        }

        var cacMuc: [HopThoaiChonNhomHangDMX.MucChon] = [
            .init(
                giaTri: "__ALL__",
                hienThi: "Tất cả nhóm hàng (\(dsNhomHang.count) nhóm)",
                laTatCa: true
            )
        ]
        for nhom in dsNhomHang {
            cacMuc.append(.init(giaTri: nhom, hienThi: nhom, laTatCa: false))
        }

        let maSTHienThi = maSieuThiDangLoc.isEmpty ? "Tất cả siêu thị" : "Siêu thị bắt đầu bằng “\(maSieuThiDangLoc)”"
        let vc = HopThoaiChonNhomHangDMX(
            tieuDe: "📂 CHỌN NHÓM HÀNG TỒN KHO (CỘT G)",
            phuDe: "Đang lọc theo: \(maSTHienThi) • Có \(dsNhomHang.count) nhóm hàng",
            goiYTimKiem: "🔍 Nhập mã hoặc tên nhóm hàng (VD: 1094, Tivi, Tủ lạnh...)",
            tatCaMuc: cacMuc,
            giaTriDangChon: nhomHangDangChon
        ) { [weak self] giaTriChon in
            guard let self = self else { return }
            self.nhomHangDangChon = giaTriChon
            self.capNhatMenuCombobox()
            self.apDungBoLocVaVeBang()
        }
        timViewControllerCha()?.present(vc, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField === oLinkSheet {
            bamTaiSheet()
        } else if textField === oMaSieuThi {
            bamLocSieuThi()
        }
        return true
    }

    @objc private func bamLocSieuThi() {
        endEditing(true)
        let ma = (oMaSieuThi.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        oMaSieuThi.text = ma
        maSieuThiDangLoc = ma
        UserDefaults.standard.set(ma, forKey: Self.khoaLuuMaSieuThi)
        capNhatDanhSachComboboxTuDuLieu()
        apDungBoLocVaVeBang()
    }

    @objc private func bamTaiSheet() {
        endEditing(true)
        let link = (oLinkSheet.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        oLinkSheet.text = link
        UserDefaults.standard.set(link, forKey: Self.khoaLuuLinkSheet)

        let ma = (oMaSieuThi.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        oMaSieuThi.text = ma
        maSieuThiDangLoc = ma
        UserDefaults.standard.set(ma, forKey: Self.khoaLuuMaSieuThi)

        guard !link.isEmpty else {
            nhanTrangThai.text = "⚠️ Vui lòng dán link Google Sheet tồn kho vào ô phía trên rồi bấm “Quét Sheet”."
            nhanTrangThai.textColor = BangMauBCTD.doYeuChu
            return
        }

        guard let (sheetId, gid) = Self.tachSheetIdVaGid(tu: link) else {
            nhanTrangThai.text = "⚠️ Link Google Sheet không hợp lệ. Hãy dán link dạng https://docs.google.com/spreadsheets/d/.../edit?gid=..."
            nhanTrangThai.textColor = BangMauBCTD.doYeuChu
            return
        }

        var cacURL: [URL] = []
        if let u1 = URL(string: "https://docs.google.com/spreadsheets/d/\(sheetId)/export?format=csv&gid=\(gid)") {
            cacURL.append(u1)
        }
        if let u2 = URL(string: "https://docs.google.com/spreadsheets/d/\(sheetId)/export?format=tsv&gid=\(gid)") {
            cacURL.append(u2)
        }
        if let u3 = URL(string: "https://docs.google.com/spreadsheets/d/\(sheetId)/gviz/tq?tqx=out:csv&headers=0&gid=\(gid)") {
            cacURL.append(u3)
        }
        if let u4 = URL(string: "https://docs.google.com/spreadsheets/d/\(sheetId)/gviz/tq?tqx=out:csv&headers=1&gid=\(gid)") {
            cacURL.append(u4)
        }

        dangTaiSheet = true
        nutTaiSheet.isEnabled = false
        vongQuay.startAnimating()
        nhanTrangThai.text = "⏳ Đang quét dữ liệu & danh sách Nhóm hàng (Cột G), Trạng thái (Cột H) từ Google Sheet..."
        nhanTrangThai.textColor = BangMauBCTD.xanhChuDaoDam

        taiTuDanhSachURL(cacURL, chiSo: 0)
    }

    private func taiTuDanhSachURL(_ cacURL: [URL], chiSo: Int) {
        guard chiSo < cacURL.count else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dangTaiSheet = false
                self.nutTaiSheet.isEnabled = true
                self.vongQuay.stopAnimating()
                self.nhanTrangThai.text = "⚠️ Không tải được Google Sheet. Hãy kiểm tra kết nối mạng hoặc quyền chia sẻ (Bất kỳ ai có liên kết đều xem được)."
                self.nhanTrangThai.textColor = BangMauBCTD.doYeuChu
            }
            return
        }

        let url = cacURL[chiSo]
        var req = URLRequest(url: url)
        req.timeoutInterval = 25
        req.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            guard let self = self else { return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            guard error == nil, status >= 200 && status < 300,
                  let data = data,
                  let text = String(data: data, encoding: .utf8),
                  !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  !text.lowercased().contains("<!doctype html"),
                  !text.lowercased().contains("<html") else {
                self.taiTuDanhSachURL(cacURL, chiSo: chiSo + 1)
                return
            }

            let laTSV = url.absoluteString.contains("format=tsv")
            let cacDong = Self.phanTichBangSheet(text, laTSV: laTSV)
            guard !cacDong.isEmpty else {
                self.taiTuDanhSachURL(cacURL, chiSo: chiSo + 1)
                return
            }

            DispatchQueue.main.async {
                self.dangTaiSheet = false
                self.nutTaiSheet.isEnabled = true
                self.vongQuay.stopAnimating()
                self.tatCaDong = cacDong
                self.capNhatDanhSachComboboxTuDuLieu()
                self.apDungBoLocVaVeBang()
            }
        }.resume()
    }

    private func capNhatDanhSachComboboxTuDuLieu() {
        let maST = maSieuThiDangLoc
        let dongTheoSieuThi: [[String]]
        if maST.isEmpty {
            dongTheoSieuThi = tatCaDong
        } else {
            let loc = tatCaDong.filter { dong in
                guard !dong.isEmpty else { return false }
                return Self.khopCotABatDauVoi(dong[0], cumKyTu: maST)
            }
            dongTheoSieuThi = loc.isEmpty ? tatCaDong : loc
        }

        var tapNhom = Set<String>()
        var tapTrangThai = Set<String>()
        for dong in dongTheoSieuThi {
            if dong.count > 6 {
                let nhom = Self.chuanHoaChuoiO(dong[6])
                if !nhom.isEmpty && nhom.lowercased() != "nhóm hàng" {
                    tapNhom.insert(nhom)
                }
            }
            if dong.count > 7 {
                let tt = Self.chuanHoaChuoiO(dong[7])
                if !tt.isEmpty && tt.lowercased() != "trạng thái sản phẩm" {
                    tapTrangThai.insert(tt)
                }
            }
        }
        // Quét thêm toàn bộ cột H trên toàn Sheet để không bao giờ bị sót trạng thái (như Mới, Trưng bày...)
        for dong in tatCaDong where dong.count > 7 {
            let tt = Self.chuanHoaChuoiO(dong[7])
            if !tt.isEmpty && tt.lowercased() != "trạng thái sản phẩm" {
                tapTrangThai.insert(tt)
            }
        }
        // Đảm bảo 2 trạng thái chuẩn "Mới" và "Trưng bày" luôn có mặt trong Combobox Trạng thái (Cột H)
        if !tapTrangThai.contains(where: { $0.caseInsensitiveCompare("Mới") == .orderedSame || $0.caseInsensitiveCompare("Trạng thái mới") == .orderedSame }) {
            tapTrangThai.insert("Mới")
        }
        if !tapTrangThai.contains(where: { $0.caseInsensitiveCompare("Trưng bày") == .orderedSame || $0.caseInsensitiveCompare("Trạng thái trưng bày") == .orderedSame }) {
            tapTrangThai.insert("Trưng bày")
        }

        dsNhomHang = tapNhom.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
        let uuTienTrangThai = ["mới": 0, "trạng thái mới": 0, "hàng mới": 0, "trưng bày": 1, "trạng thái trưng bày": 1, "hàng trưng bày": 1]
        dsTrangThai = tapTrangThai.sorted { a, b in
            let pa = uuTienTrangThai[a.lowercased()] ?? 99
            let pb = uuTienTrangThai[b.lowercased()] ?? 99
            if pa != pb { return pa < pb }
            return a.localizedStandardCompare(b) == .orderedAscending
        }

        if let dangChon = nhomHangDangChon, dangChon != "__ALL__", !dsNhomHang.contains(dangChon) {
            nhomHangDangChon = nil
        }
        if trangThaiDangChon != "__ALL__", !dsTrangThai.contains(trangThaiDangChon) {
            trangThaiDangChon = "__ALL__"
        }

        capNhatMenuCombobox()
    }

    private func capNhatMenuCombobox() {
        // 1. Nút Chọn Nhóm hàng (Cột G) mở hộp thoại ĐMX có tìm kiếm
        let nhanNhom: String
        if let chon = nhomHangDangChon {
            nhanNhom = (chon == "__ALL__") ? "Tất cả (\(dsNhomHang.count))" : chon
        } else {
            nhanNhom = dsNhomHang.isEmpty ? "Chưa quét" : "Chọn nhóm (\(dsNhomHang.count))"
        }
        nutChonNhomHang.setTitle("📂 Nhóm hàng (G): \(nhanNhom) ▾", for: .normal)

        // 2. Menu Trạng thái sản phẩm (Cột H)
        let nhanTT = (trangThaiDangChon == "__ALL__") ? "Tất cả (\(dsTrangThai.count))" : trangThaiDangChon
        nutChonTrangThai.setTitle("🏷️ Trạng thái (H): \(nhanTT) ▾", for: .normal)

        var actionsTT: [UIAction] = []
        actionsTT.append(UIAction(
            title: "📋 Tất cả trạng thái (\(dsTrangThai.count))",
            state: trangThaiDangChon == "__ALL__" ? .on : .off
        ) { [weak self] _ in
            guard let self = self else { return }
            self.trangThaiDangChon = "__ALL__"
            self.capNhatMenuCombobox()
            self.apDungBoLocVaVeBang()
        })
        for tt in dsTrangThai {
            actionsTT.append(UIAction(
                title: tt,
                state: trangThaiDangChon == tt ? .on : .off
            ) { [weak self] _ in
                guard let self = self else { return }
                self.trangThaiDangChon = tt
                self.capNhatMenuCombobox()
                self.apDungBoLocVaVeBang()
            })
        }
        nutChonTrangThai.menu = UIMenu(title: "Chọn Trạng thái sản phẩm (Cột H)", children: actionsTT)
    }

    private func apDungBoLocVaVeBang() {
        guard !tatCaDong.isEmpty else {
            khungTrong.isHidden = false
            nhanTrong.text = "📦 Chưa có dữ liệu. Hãy bấm “Quét Sheet” để tải các nhóm hàng và dữ liệu tồn kho từ Google Sheet."
            return
        }

        let maST = maSieuThiDangLoc

        // Chờ người dùng chọn xong Nhóm hàng trong Combobox mới hiển thị bảng bên dưới
        guard let nhomChon = nhomHangDangChon else {
            cacDongDaLoc = []
            khungTrong.isHidden = false
            nhanTrong.text = "✅ Đã quét xong \(tatCaDong.count) dòng (\(dsNhomHang.count) Nhóm hàng ở cột G, \(dsTrangThai.count) Trạng thái ở cột H).\n\n👉 Hãy bấm vào nút “Nhóm hàng (G)” phía trên để tìm và chọn nhóm hàng cần xem bảng tồn kho."
            nhanTrangThai.text = "Đã quét \(tatCaDong.count) dòng · \(dsNhomHang.count) Nhóm hàng (Cột G) · Hãy chọn Nhóm hàng"
            nhanTrangThai.textColor = BangMauBCTD.xanhChuDaoDam
            return
        }

        let coChuoiMoiTrongSheet = tatCaDong.contains { dong in
            guard dong.count > 7 else { return false }
            return Self.chuanHoaChuoiO(dong[7]).lowercased().contains("mới")
        }

        let ketQua = tatCaDong.filter { dong in
            let cotA = dong.count > 0 ? dong[0] : ""
            let cotG = dong.count > 6 ? Self.chuanHoaChuoiO(dong[6]) : ""
            let cotH = dong.count > 7 ? Self.chuanHoaChuoiO(dong[7]) : ""

            if !maST.isEmpty && !Self.khopCotABatDauVoi(cotA, cumKyTu: maST) {
                return false
            }
            if nhomChon != "__ALL__" && cotG.caseInsensitiveCompare(Self.chuanHoaChuoiO(nhomChon)) != .orderedSame {
                return false
            }
            if trangThaiDangChon != "__ALL__" && !Self.khopTrangThaiCotH(cotH, trangThaiChon: trangThaiDangChon, coChuoiMoiTrongSheet: coChuoiMoiTrongSheet) {
                return false
            }
            return true
        }

        cacDongDaLoc = ketQua

        if ketQua.isEmpty {
            khungTrong.isHidden = false
            nhanTrong.text = "Không có sản phẩm nào khớp điều kiện:\n• Siêu thị (Cột A) bắt đầu bằng: \"\(maST.isEmpty ? "Tất cả" : maST)\"\n• Nhóm hàng (Cột G): \"\(nhomChon == "__ALL__" ? "Tất cả" : nhomChon)\"\n• Trạng thái (Cột H): \"\(trangThaiDangChon == "__ALL__" ? "Tất cả" : trangThaiDangChon)\""
            nhanTrangThai.text = "0 dòng khớp bộ lọc (Tổng Sheet: \(tatCaDong.count) dòng)"
            nhanTrangThai.textColor = BangMauBCTD.vangKhaChu
            return
        }

        khungTrong.isHidden = true
        let tenNhomHienThi = (nhomChon == "__ALL__") ? "Tất cả nhóm" : nhomChon
        let tenTTHienThi = (trangThaiDangChon == "__ALL__") ? "Tất cả TT" : trangThaiDangChon
        nhanTrangThai.text = "✅ Hiển thị \(ketQua.count) dòng (Siêu thị: \(maST.isEmpty ? "Tất cả" : maST) · Nhóm: \(tenNhomHienThi) · \(tenTTHienThi))"
        nhanTrangThai.textColor = BangMauBCTD.xanhLaDam

        dungBangHienThi(cacDong: ketQua)
    }

    private func dungBangHienThi(cacDong: [[String]]) {
        nganBang.arrangedSubviews.forEach {
            nganBang.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // Hàng đầu tiên: chỉ hiển thị 6 cột A, C, D, G, H, I
        let hangTieuDe = Self.taoHangBang(cacGiaTri: Self.tenCacCotChuan, laHeader: true, chiSoDong: -1)
        nganBang.addArrangedSubview(hangTieuDe)

        let gioiHanHienThi = min(cacDong.count, 500)
        for i in 0..<gioiHanHienThi {
            let hang = Self.taoHangBang(cacGiaTri: cacDong[i], laHeader: false, chiSoDong: i)
            nganBang.addArrangedSubview(hang)
        }
    }

    private static func taoHangBang(cacGiaTri: [String], laHeader: Bool, chiSoDong: Int) -> UIView {
        let hang = UIStackView()
        hang.axis = .horizontal
        hang.spacing = 0
        hang.alignment = .fill
        hang.distribution = .fill

        let mauNen: UIColor
        if laHeader {
            mauNen = BangMauBCTD.xanhChuDao
        } else {
            mauNen = (chiSoDong % 2 == 0) ? .white : BangMauBCTD.nenHeaderPhu
        }
        hang.backgroundColor = mauNen

        for (viTri, chiSoCot) in chiSoCotHienThi.enumerated() {
            let giaTri = (chiSoCot < cacGiaTri.count) ? cacGiaTri[chiSoCot] : ""
            let rong = doRongCacCot[viTri]

            let o = UIView()
            o.backgroundColor = mauNen
            o.layer.borderWidth = 0.5
            o.layer.borderColor = (laHeader ? UIColor.white.withAlphaComponent(0.3) : BangMauBCTD.vienThe).cgColor
            o.translatesAutoresizingMaskIntoConstraints = false
            o.widthAnchor.constraint(equalToConstant: rong).isActive = true

            let lb = UILabel()
            lb.text = giaTri
            lb.font = laHeader
                ? .systemFont(ofSize: 11.5, weight: .heavy)
                : .systemFont(ofSize: 11.5, weight: (chiSoCot == 0 || chiSoCot == 3 || chiSoCot == 8) ? .bold : .medium)
            lb.textColor = laHeader
                ? BangMauBCTD.vangSang
                : (chiSoCot == 8 ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuChinh)
            lb.numberOfLines = laHeader ? 2 : 0
            lb.lineBreakMode = .byWordWrapping
            lb.textAlignment = (laHeader || chiSoCot == 8) ? .center : .left
            lb.translatesAutoresizingMaskIntoConstraints = false
            o.addSubview(lb)

            NSLayoutConstraint.activate([
                o.heightAnchor.constraint(greaterThanOrEqualToConstant: laHeader ? 40 : 34),
                lb.topAnchor.constraint(equalTo: o.topAnchor, constant: 5),
                lb.bottomAnchor.constraint(equalTo: o.bottomAnchor, constant: -5),
                lb.leadingAnchor.constraint(equalTo: o.leadingAnchor, constant: 6),
                lb.trailingAnchor.constraint(equalTo: o.trailingAnchor, constant: -6)
            ])

            hang.addArrangedSubview(o)
        }
        return hang
    }

    @objc func bamXuatAnhBang() {
        guard !cacDongDaLoc.isEmpty else {
            nhanTrangThai.text = "⚠️ Chưa có dữ liệu bảng đang hiển thị để xuất ảnh. Hãy chọn Nhóm hàng (Cột G) trước!"
            nhanTrangThai.textColor = BangMauBCTD.doYeuChu
            return
        }
        guard let anh = taoAnhBangTonKho() else { return }
        khiXuatAnh?(anh)
    }

    func taoAnhBangTonKho() -> UIImage? {
        guard !cacDongDaLoc.isEmpty else { return nil }
        let dsXuat = Array(cacDongDaLoc.prefix(300))
        let le: CGFloat = 12
        let rongBang = Self.doRongCacCot.reduce(0, +)
        let tongRong = rongBang + le * 2

        let maST = maSieuThiDangLoc
        let tenNhom = (nhomHangDangChon == nil || nhomHangDangChon == "__ALL__") ? "Tất cả nhóm hàng" : (nhomHangDangChon ?? "")
        let tenTT = (trangThaiDangChon == "__ALL__") ? "Tất cả trạng thái" : trangThaiDangChon
        let chuoiTieuDe = "📦 BẢNG DỮ LIỆU TỒN KHO · SIÊU THỊ: \(maST.isEmpty ? "TẤT CẢ" : maST) · NHÓM HÀNG: \(tenNhom.uppercased()) · TRẠNG THÁI: \(tenTT.uppercased()) (\(dsXuat.count) SP)"

        let fontTieuDe = UIFont.systemFont(ofSize: 14.0, weight: .heavy)
        let fontHeaderCot = UIFont.systemFont(ofSize: 11.5, weight: .heavy)
        let fontThuong = UIFont.systemFont(ofSize: 11.5, weight: .medium)
        let fontDam = UIFont.systemFont(ofSize: 11.5, weight: .bold)

        let rectTieuDe = (chuoiTieuDe as NSString).boundingRect(
            with: CGSize(width: rongBang - 24, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTieuDe],
            context: nil
        )
        let caoDau = max(42, ceil(rectTieuDe.height) + 20)
        let caoHeaderCot: CGFloat = 40

        let cacCaoDong: [CGFloat] = dsXuat.map { dong in
            var caoMax: CGFloat = 34
            for (viTri, chiSoCot) in Self.chiSoCotHienThi.enumerated() {
                let giaTri = (chiSoCot < dong.count) ? dong[chiSoCot] : ""
                guard !giaTri.isEmpty else { continue }
                let rongO = Self.doRongCacCot[viTri] - 12
                let fontO = (chiSoCot == 0 || chiSoCot == 3 || chiSoCot == 8) ? fontDam : fontThuong
                let r = (giaTri as NSString).boundingRect(
                    with: CGSize(width: max(20, rongO), height: CGFloat.greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: [.font: fontO],
                    context: nil
                )
                caoMax = max(caoMax, ceil(r.height) + 12)
            }
            return caoMax
        }

        let tongCao = le * 2 + caoDau + caoHeaderCot + cacCaoDong.reduce(0, +)

        let pLeft = NSMutableParagraphStyle()
        pLeft.alignment = .left
        pLeft.lineBreakMode = .byWordWrapping

        let pCenter = NSMutableParagraphStyle()
        pCenter.alignment = .center
        pCenter.lineBreakMode = .byWordWrapping

        let fmt = UIGraphicsImageRendererFormat.default()
        fmt.scale = tongCao > 5000 ? 1.5 : 2.0
        fmt.opaque = true
        if #available(iOS 12.0, *) {
            fmt.preferredRange = .standard
        }

        return UIGraphicsImageRenderer(size: CGSize(width: tongRong, height: tongCao), format: fmt).image { rendererCtx in
            let cg = rendererCtx.cgContext
            UIColor.white.setFill()
            cg.fill(CGRect(x: 0, y: 0, width: tongRong, height: tongCao))

            var y: CGFloat = le

            // 1. Thanh tiêu đề
            let rDau = CGRect(x: le, y: y, width: rongBang, height: caoDau)
            BangMauBCTD.xanhChuDaoDam.setFill()
            cg.fill(rDau)
            (chuoiTieuDe as NSString).draw(
                in: CGRect(x: rDau.minX + 12, y: rDau.minY + (caoDau - ceil(rectTieuDe.height)) / 2.0, width: rongBang - 24, height: ceil(rectTieuDe.height) + 4),
                withAttributes: [
                    .font: fontTieuDe,
                    .foregroundColor: BangMauBCTD.vangSang,
                    .paragraphStyle: pLeft
                ]
            )
            y += caoDau

            // 2. Hàng Header 6 cột: A, C, D, G, H, I
            let rHeader = CGRect(x: le, y: y, width: rongBang, height: caoHeaderCot)
            BangMauBCTD.xanhChuDao.setFill()
            cg.fill(rHeader)

            var xCot: CGFloat = le
            for (viTri, chiSoCot) in Self.chiSoCotHienThi.enumerated() {
                let rong = Self.doRongCacCot[viTri]
                let tenCot = Self.tenCacCotChuan[chiSoCot]
                let rO = CGRect(x: xCot, y: y, width: rong, height: caoHeaderCot)
                UIColor.white.withAlphaComponent(0.3).setStroke()
                cg.setLineWidth(0.5)
                cg.stroke(rO)

                let rText = (tenCot as NSString).boundingRect(
                    with: CGSize(width: rong - 12, height: caoHeaderCot),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: [.font: fontHeaderCot],
                    context: nil
                )
                (tenCot as NSString).draw(
                    in: CGRect(x: xCot + 6, y: y + (caoHeaderCot - ceil(rText.height)) / 2.0, width: rong - 12, height: ceil(rText.height) + 2),
                    withAttributes: [
                        .font: fontHeaderCot,
                        .foregroundColor: BangMauBCTD.vangSang,
                        .paragraphStyle: pCenter
                    ]
                )
                xCot += rong
            }
            y += caoHeaderCot

            // 3. Các dòng dữ liệu (6 cột A, C, D, G, H, I)
            for (idx, dong) in dsXuat.enumerated() {
                let caoDong = cacCaoDong[idx]
                let rDong = CGRect(x: le, y: y, width: rongBang, height: caoDong)
                let mauNen = (idx % 2 == 0) ? UIColor.white : BangMauBCTD.nenHeaderPhu
                mauNen.setFill()
                cg.fill(rDong)

                var x: CGFloat = le
                for (viTri, chiSoCot) in Self.chiSoCotHienThi.enumerated() {
                    let rong = Self.doRongCacCot[viTri]
                    let rO = CGRect(x: x, y: y, width: rong, height: caoDong)
                    BangMauBCTD.vienThe.setStroke()
                    cg.setLineWidth(0.5)
                    cg.stroke(rO)

                    let giaTri = (chiSoCot < dong.count) ? dong[chiSoCot] : ""
                    if !giaTri.isEmpty {
                        let fontO = (chiSoCot == 0 || chiSoCot == 3 || chiSoCot == 8) ? fontDam : fontThuong
                        let mauChu = (chiSoCot == 8) ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuChinh
                        let align = (chiSoCot == 8) ? pCenter : pLeft
                        let rText = (giaTri as NSString).boundingRect(
                            with: CGSize(width: rong - 12, height: caoDong),
                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                            attributes: [.font: fontO],
                            context: nil
                        )
                        (giaTri as NSString).draw(
                            in: CGRect(x: x + 6, y: y + max(4, (caoDong - ceil(rText.height)) / 2.0), width: rong - 12, height: ceil(rText.height) + 2),
                            withAttributes: [
                                .font: fontO,
                                .foregroundColor: mauChu,
                                .paragraphStyle: align
                            ]
                        )
                    }
                    x += rong
                }
                y += caoDong
            }
        }
    }

    // MARK: - Tách ID Google Sheet & Phân tích TSV / CSV

    static func tachSheetIdVaGid(tu link: String) -> (sheetId: String, gid: String)? {
        let s = link.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let r1 = s.range(of: "/spreadsheets/d/") else { return nil }
        let sau = s[r1.upperBound...]
        let sheetId = String(sau.prefix { $0 != "/" && $0 != "?" && $0 != "#" && $0 != "&" })
        guard !sheetId.isEmpty else { return nil }

        var gid = "0"
        if let rgGid = s.range(of: "gid=") {
            let sauGid = s[rgGid.upperBound...]
            let chuoiSo = String(sauGid.prefix { $0.isNumber })
            if !chuoiSo.isEmpty { gid = chuoiSo }
        }
        return (sheetId, gid)
    }

    static func phanTichBangSheet(_ noiDung: String, laTSV: Bool) -> [[String]] {
        let bang = laTSV ? phanTichTSV(noiDung) : phanTichCSV(noiDung)
        var ketQua: [[String]] = []

        for dongGoc in bang {
            var dong = dongGoc.map { chuanHoaChuoiO($0) }
            if dong.allSatisfy({ $0.isEmpty }) { continue }

            // Chỉ bỏ qua dòng tiêu đề gốc của Sheet khi cột A là "Tên siêu thị" và cột B là "Mã Model"
            let cot0 = dong.first?.lowercased() ?? ""
            let cot1 = (dong.count > 1 ? dong[1] : "").lowercased()
            if (cot0 == "tên siêu thị" || cot0 == "ten sieu thi") || (cot1 == "mã model" || cot1 == "ma model") {
                continue
            }
            while dong.count < tenCacCotChuan.count {
                dong.append("")
            }
            if dong.count > tenCacCotChuan.count {
                dong = Array(dong.prefix(tenCacCotChuan.count))
            }
            ketQua.append(dong)
        }
        return ketQua
    }

    private static func phanTichTSV(_ text: String) -> [[String]] {
        let chuan = text.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
        return chuan.components(separatedBy: "\n").map { $0.components(separatedBy: "\t") }
    }

    private static func phanTichCSV(_ text: String) -> [[String]] {
        var ketQua: [[String]] = []
        var dongHienTai: [String] = []
        var oHienTai = ""
        var trongNhay = false
        // Chuẩn hoá \r\n thành \n trước khi chuyển sang Array(Character) vì trong Swift "\r\n" là 1 Character gộp!
        let chuan = text.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
        let chars = Array(chuan)
        var i = 0

        while i < chars.count {
            let c = chars[i]
            if trongNhay {
                if c == "\"" {
                    if i + 1 < chars.count && chars[i + 1] == "\"" {
                        oHienTai.append("\"")
                        i += 2
                        continue
                    } else {
                        trongNhay = false
                    }
                } else {
                    oHienTai.append(c)
                }
            } else {
                if c == "\"" {
                    trongNhay = true
                } else if c == "," {
                    dongHienTai.append(oHienTai)
                    oHienTai = ""
                } else if c == "\r" {
                    dongHienTai.append(oHienTai)
                    oHienTai = ""
                    ketQua.append(dongHienTai)
                    dongHienTai = []
                    if i + 1 < chars.count && chars[i + 1] == "\n" {
                        i += 1
                    }
                } else if c == "\n" {
                    dongHienTai.append(oHienTai)
                    oHienTai = ""
                    ketQua.append(dongHienTai)
                    dongHienTai = []
                } else {
                    oHienTai.append(c)
                }
            }
            i += 1
        }
        if !oHienTai.isEmpty || !dongHienTai.isEmpty {
            dongHienTai.append(oHienTai)
            ketQua.append(dongHienTai)
        }
        return ketQua
    }
}
