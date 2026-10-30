import UIKit

enum BoLocThiDua: Int {
    case tatCa = 0
    case daDat = 1
    case chuaDat = 2
}

enum KieuSapXepThiDua: Int, CaseIterable {
    case phanTramCaoThap = 0
    case phanTramThapCao = 1
    case tenAZ = 2
    case tenZA = 3
    case thuTuGoc = 4

    var nhan: String {
        switch self {
        case .phanTramCaoThap: return "% HT: Cao → Thấp"
        case .phanTramThapCao: return "% HT: Thấp → Cao"
        case .tenAZ: return "Ngành hàng: A → Z"
        case .tenZA: return "Ngành hàng: Z → A"
        case .thuTuGoc: return "Thứ tự quét gốc"
        }
    }

    var nhanNgan: String {
        switch self {
        case .phanTramCaoThap: return "HT Cao↓"
        case .phanTramThapCao: return "HT Thấp↑"
        case .tenAZ: return "Tên A-Z"
        case .tenZA: return "Tên Z-A"
        case .thuTuGoc: return "Mặc định"
        }
    }
}

// MARK: - Thẻ Doanh Thu (Xanh dương / Xanh lá)

final class TheDoanhThuView: UIControl {
    private let lopGradient = CAGradientLayer()
    private let nhanTieuDe = UILabel()
    private let nhanGiaTriChinh = UILabel()
    private let vachKe = UIView()
    private let nhanTarget = UILabel()
    private let chamTron = UIView()

    init(tieuDe: String, mauBatDau: UIColor, mauKetThuc: UIColor, hienChamTron: Bool) {
        super.init(frame: .zero)
        layer.cornerRadius = 14
        clipsToBounds = true

        lopGradient.colors = [mauBatDau.cgColor, mauKetThuc.cgColor]
        lopGradient.startPoint = CGPoint(x: 0, y: 0)
        lopGradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(lopGradient, at: 0)

        nhanTieuDe.text = tieuDe
        nhanTieuDe.font = .systemFont(ofSize: 11, weight: .bold)
        nhanTieuDe.textColor = UIColor.white.withAlphaComponent(0.92)
        nhanTieuDe.textAlignment = .center

        nhanGiaTriChinh.text = "0,00"
        nhanGiaTriChinh.font = .systemFont(ofSize: 22, weight: .heavy)
        nhanGiaTriChinh.textColor = .white
        nhanGiaTriChinh.textAlignment = .center
        nhanGiaTriChinh.adjustsFontSizeToFitWidth = true
        nhanGiaTriChinh.minimumScaleFactor = 0.65

        vachKe.backgroundColor = UIColor.white.withAlphaComponent(0.28)

        nhanTarget.text = "TARGET: 0,00"
        nhanTarget.font = .systemFont(ofSize: 10.5, weight: .bold)
        nhanTarget.textColor = UIColor.white.withAlphaComponent(0.9)
        nhanTarget.textAlignment = .center

        chamTron.backgroundColor = .white
        chamTron.layer.cornerRadius = 5
        chamTron.isHidden = !hienChamTron

        [nhanTieuDe, nhanGiaTriChinh, vachKe, nhanTarget, chamTron].forEach {
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            nhanTieuDe.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nhanTieuDe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nhanTieuDe.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            chamTron.centerYAnchor.constraint(equalTo: nhanTieuDe.centerYAnchor),
            chamTron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            chamTron.widthAnchor.constraint(equalToConstant: 10),
            chamTron.heightAnchor.constraint(equalToConstant: 10),

            nhanGiaTriChinh.topAnchor.constraint(equalTo: nhanTieuDe.bottomAnchor, constant: 6),
            nhanGiaTriChinh.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nhanGiaTriChinh.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            vachKe.topAnchor.constraint(equalTo: nhanGiaTriChinh.bottomAnchor, constant: 8),
            vachKe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            vachKe.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            vachKe.heightAnchor.constraint(equalToConstant: 1),

            nhanTarget.topAnchor.constraint(equalTo: vachKe.bottomAnchor, constant: 6),
            nhanTarget.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nhanTarget.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nhanTarget.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lopGradient.frame = bounds
    }

    func capNhat(doanhThu: Double, target: Double) {
        if doanhThu == 0 && target == 0 {
            nhanGiaTriChinh.text = "Chạm nhập/quét"
            nhanGiaTriChinh.font = .systemFont(ofSize: 15, weight: .bold)
            nhanTarget.text = "TARGET: --"
        } else {
            nhanGiaTriChinh.text = doanhThu.chuoiSoVN
            nhanGiaTriChinh.font = .systemFont(ofSize: 22, weight: .heavy)
            if target > 0 {
                let pt = (doanhThu / target) * 100.0
                nhanTarget.text = "TARGET: \(target.chuoiSoVN) (\(pt.chuoiPhanTramVN))"
            } else {
                nhanTarget.text = "TARGET: 0,00"
            }
        }
    }
}

// MARK: - Ô Thẻ Tiến Độ Gọn (Mẫu hiển thị 2)

final class OTheThiDuaCell: UICollectionViewCell {
    static let ma = "OTheThiDuaCell"

    private let khungThe = UIView()
    private let nhanTen = UILabel()
    private let nhanPhanTram = UILabel()
    private let nhanThucHienTarget = UILabel()
    private let nhanConThieu = UILabel()
    private let thanhNenTienDo = UIView()
    private let thanhMauTienDo = UIView()
    private var rangBuocRongTienDo: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        khungThe.backgroundColor = .systemBackground
        khungThe.layer.cornerRadius = 12
        khungThe.layer.borderWidth = 1
        khungThe.layer.borderColor = UIColor.systemGray5.cgColor
        khungThe.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(khungThe)

        nhanTen.font = .systemFont(ofSize: 13, weight: .bold)
        nhanTen.textColor = .label
        nhanTen.numberOfLines = 2

        nhanPhanTram.font = .systemFont(ofSize: 12.5, weight: .bold)
        nhanPhanTram.textAlignment = .center
        nhanPhanTram.layer.cornerRadius = 11
        nhanPhanTram.clipsToBounds = true
        nhanPhanTram.setContentHuggingPriority(.required, for: .horizontal)
        nhanPhanTram.setContentCompressionResistancePriority(.required, for: .horizontal)

        nhanThucHienTarget.font = .systemFont(ofSize: 12, weight: .regular)
        nhanThucHienTarget.adjustsFontSizeToFitWidth = true
        nhanThucHienTarget.minimumScaleFactor = 0.75

        nhanConThieu.font = .systemFont(ofSize: 11.5, weight: .medium)
        nhanConThieu.textColor = .secondaryLabel
        nhanConThieu.textAlignment = .right
        nhanConThieu.setContentCompressionResistancePriority(.required, for: .horizontal)

        thanhNenTienDo.backgroundColor = UIColor.systemGray5
        thanhNenTienDo.layer.cornerRadius = 2.5
        thanhNenTienDo.clipsToBounds = true

        thanhMauTienDo.layer.cornerRadius = 2.5
        thanhMauTienDo.translatesAutoresizingMaskIntoConstraints = false
        thanhNenTienDo.addSubview(thanhMauTienDo)

        [nhanTen, nhanPhanTram, nhanThucHienTarget, nhanConThieu, thanhNenTienDo].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungThe.addSubview($0)
        }

        let rgRong = thanhMauTienDo.widthAnchor.constraint(equalToConstant: 0)
        rangBuocRongTienDo = rgRong

        NSLayoutConstraint.activate([
            khungThe.topAnchor.constraint(equalTo: contentView.topAnchor),
            khungThe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            khungThe.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            khungThe.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nhanTen.topAnchor.constraint(equalTo: khungThe.topAnchor, constant: 10),
            nhanTen.leadingAnchor.constraint(equalTo: khungThe.leadingAnchor, constant: 10),
            nhanTen.trailingAnchor.constraint(lessThanOrEqualTo: nhanPhanTram.leadingAnchor, constant: -6),

            nhanPhanTram.topAnchor.constraint(equalTo: khungThe.topAnchor, constant: 8),
            nhanPhanTram.trailingAnchor.constraint(equalTo: khungThe.trailingAnchor, constant: -10),
            nhanPhanTram.widthAnchor.constraint(greaterThanOrEqualToConstant: 64),
            nhanPhanTram.heightAnchor.constraint(equalToConstant: 22),

            thanhNenTienDo.leadingAnchor.constraint(equalTo: khungThe.leadingAnchor, constant: 10),
            thanhNenTienDo.trailingAnchor.constraint(equalTo: khungThe.trailingAnchor, constant: -10),
            thanhNenTienDo.bottomAnchor.constraint(equalTo: khungThe.bottomAnchor, constant: -9),
            thanhNenTienDo.heightAnchor.constraint(equalToConstant: 5),

            thanhMauTienDo.leadingAnchor.constraint(equalTo: thanhNenTienDo.leadingAnchor),
            thanhMauTienDo.topAnchor.constraint(equalTo: thanhNenTienDo.topAnchor),
            thanhMauTienDo.bottomAnchor.constraint(equalTo: thanhNenTienDo.bottomAnchor),
            rgRong,

            nhanThucHienTarget.bottomAnchor.constraint(equalTo: thanhNenTienDo.topAnchor, constant: -6),
            nhanThucHienTarget.leadingAnchor.constraint(equalTo: khungThe.leadingAnchor, constant: 10),
            nhanThucHienTarget.trailingAnchor.constraint(lessThanOrEqualTo: nhanConThieu.leadingAnchor, constant: -4),

            nhanConThieu.centerYAnchor.constraint(equalTo: nhanThucHienTarget.centerYAnchor),
            nhanConThieu.trailingAnchor.constraint(equalTo: khungThe.trailingAnchor, constant: -10)
        ])
    }

    private var tyLeTienDoHienTai: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        let rongToiDa = thanhNenTienDo.bounds.width
        rangBuocRongTienDo?.constant = rongToiDa * min(1.0, max(0.0, tyLeTienDoHienTai))
    }

    func gan(_ dong: DongThiDua) {
        nhanTen.text = dong.tenNganhHang
        let pt = dong.phanTramHT
        nhanPhanTram.text = "  \(pt.chuoiPhanTramVN)  "

        if pt >= 99.995 {
            nhanPhanTram.backgroundColor = UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1)
            nhanPhanTram.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
            thanhMauTienDo.backgroundColor = UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1)
        } else if pt >= 80.0 {
            nhanPhanTram.backgroundColor = UIColor(red: 0.99, green: 0.95, blue: 0.78, alpha: 1)
            nhanPhanTram.textColor = UIColor(red: 0.71, green: 0.33, blue: 0.04, alpha: 1)
            thanhMauTienDo.backgroundColor = UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1)
        } else {
            nhanPhanTram.backgroundColor = UIColor(red: 0.99, green: 0.89, blue: 0.89, alpha: 1)
            nhanPhanTram.textColor = UIColor(red: 0.73, green: 0.11, blue: 0.11, alpha: 1)
            thanhMauTienDo.backgroundColor = (pt >= 70.0)
                ? UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1)
                : UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1)
        }

        let chuoiDam = dong.thucHien.chuoiSoVN
        let chuoiMo = " / \(dong.target.chuoiSoVN) \(dong.loaiChiTieu.maThe)"
        let attr = NSMutableAttributedString(
            string: chuoiDam,
            attributes: [
                .font: UIFont.systemFont(ofSize: 12.5, weight: .bold),
                .foregroundColor: UIColor.label
            ]
        )
        attr.append(NSAttributedString(
            string: chuoiMo,
            attributes: [
                .font: UIFont.systemFont(ofSize: 11.5, weight: .regular),
                .foregroundColor: UIColor.secondaryLabel
            ]
        ))
        nhanThucHienTarget.attributedText = attr

        if dong.conThieu > 0.005 {
            nhanConThieu.text = "Còn: \(dong.conThieu.chuoiSoVN)"
            nhanConThieu.textColor = .secondaryLabel
        } else {
            nhanConThieu.text = "Vượt: \(dong.vuotMuc.chuoiSoVN)"
            nhanConThieu.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
        }

        tyLeTienDoHienTai = CGFloat(min(1.0, max(0.03, pt / 100.0)))
        setNeedsLayout()
    }
}

// MARK: - BangThiDuaView (Hỗ trợ cả 2 mẫu: Bảng 8 cột & Thẻ tiến độ gọn)

final class BangThiDuaView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    var khiChonDong: ((DongThiDua) -> Void)?
    var khiXoaDong: ((UUID) -> Void)?
    var khiBamQuetAnh: (() -> Void)?

    private var danhSachGoc: [DongThiDua] = []
    private var danhSachHienThi: [DongThiDua] = []
    private var boLoc: BoLocThiDua = .tatCa
    private var kieuSapXep: KieuSapXepThiDua = .phanTramCaoThap
    private var soCotTrenDienThoai: Int = 1

    // Chiều rộng 8 cột cho Mẫu 1 (Bảng 8 cột chi tiết)
    private let chieuRongCot: [CGFloat] = [38, 205, 48, 88, 88, 92, 84, 84]
    private var tongChieuRongBang: CGFloat { chieuRongCot.reduce(0, +) }

    private let chonBoLoc = UISegmentedControl(items: ["Tất cả", "Đạt", "Chưa đạt"])
    private let nutSapXep = UIButton(type: .system)
    private let nutSoCot = UIButton(type: .system)

    // Mẫu 1: Bảng 8 cột
    private let cuonNgang = UIScrollView()
    private let bang8Cot = UITableView(frame: .zero, style: .plain)

    // Mẫu 2: Lưới thẻ tiến độ
    private lazy var luoi: UICollectionView = {
        let boCuc = UICollectionViewFlowLayout()
        boCuc.minimumLineSpacing = 8
        boCuc.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: boCuc)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        cv.register(OTheThiDuaCell.self, forCellWithReuseIdentifier: OTheThiDuaCell.ma)
        return cv
    }()

    private let khungTrong = UIControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        backgroundColor = .clear

        chonBoLoc.selectedSegmentIndex = 0
        chonBoLoc.addTarget(self, action: #selector(doiBoLoc), for: .valueChanged)

        nutSapXep.setTitle(" ⇅ \(kieuSapXep.nhanNgan)", for: .normal)
        nutSapXep.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        nutSapXep.backgroundColor = .secondarySystemGroupedBackground
        nutSapXep.tintColor = .label
        nutSapXep.layer.cornerRadius = 8
        nutSapXep.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        cauHinhMenuSapXep()

        nutSoCot.setTitle(" 1 cột", for: .normal)
        nutSoCot.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
        nutSoCot.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        nutSoCot.backgroundColor = .secondarySystemGroupedBackground
        nutSoCot.tintColor = .systemBlue
        nutSoCot.layer.cornerRadius = 8
        nutSoCot.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        nutSoCot.addTarget(self, action: #selector(doiSoCot), for: .touchUpInside)

        let thanhDieuKhien = UIStackView(arrangedSubviews: [chonBoLoc, nutSapXep, nutSoCot])
        thanhDieuKhien.axis = .horizontal
        thanhDieuKhien.spacing = 6
        nutSapXep.setContentHuggingPriority(.required, for: .horizontal)
        nutSoCot.setContentHuggingPriority(.required, for: .horizontal)

        // Khởi tạo Mẫu 1 (Bảng 8 cột)
        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.showsVerticalScrollIndicator = false
        cuonNgang.bounces = false
        cuonNgang.layer.cornerRadius = 12
        cuonNgang.clipsToBounds = true
        cuonNgang.backgroundColor = .systemBackground

        bang8Cot.dataSource = self
        bang8Cot.delegate = self
        bang8Cot.rowHeight = 52
        bang8Cot.sectionHeaderHeight = 40
        bang8Cot.separatorStyle = .singleLine
        bang8Cot.separatorInset = .zero
        bang8Cot.backgroundColor = .systemBackground
        if #available(iOS 15.0, *) {
            bang8Cot.sectionHeaderTopPadding = 0
        }
        bang8Cot.translatesAutoresizingMaskIntoConstraints = false
        cuonNgang.addSubview(bang8Cot)

        // Khung trống khi chưa có dữ liệu
        khungTrong.backgroundColor = .secondarySystemGroupedBackground
        khungTrong.layer.cornerRadius = 14
        khungTrong.addTarget(self, action: #selector(bamQuet), for: .touchUpInside)

        let iconTrong = UIImageView(image: UIImage(systemName: "camera.viewfinder"))
        iconTrong.tintColor = .systemBlue
        iconTrong.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 42, weight: .regular)

        let tieuDeTrong = UILabel()
        tieuDeTrong.text = "Chạm để chọn ảnh chụp màn hình Thi đua"
        tieuDeTrong.font = .systemFont(ofSize: 15, weight: .bold)
        tieuDeTrong.textAlignment = .center

        let phuDeTrong = UILabel()
        phuDeTrong.text = "Chọn nhiều ảnh chụp cuộn trang cùng lúc.\nĐổi kiểu hiển thị (Bảng 8 cột / Thẻ gọn) trong Cài đặt (⚙️)."
        phuDeTrong.font = .systemFont(ofSize: 12.5, weight: .regular)
        phuDeTrong.textColor = .secondaryLabel
        phuDeTrong.textAlignment = .center
        phuDeTrong.numberOfLines = 0

        let nganTrong = UIStackView(arrangedSubviews: [iconTrong, tieuDeTrong, phuDeTrong])
        nganTrong.axis = .vertical
        nganTrong.spacing = 8
        nganTrong.alignment = .center
        nganTrong.isUserInteractionEnabled = false
        nganTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nganTrong)

        [thanhDieuKhien, cuonNgang, luoi, khungTrong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            thanhDieuKhien.topAnchor.constraint(equalTo: topAnchor),
            thanhDieuKhien.leadingAnchor.constraint(equalTo: leadingAnchor),
            thanhDieuKhien.trailingAnchor.constraint(equalTo: trailingAnchor),
            thanhDieuKhien.heightAnchor.constraint(equalToConstant: 32),

            cuonNgang.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 8),
            cuonNgang.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuonNgang.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuonNgang.bottomAnchor.constraint(equalTo: bottomAnchor),

            bang8Cot.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            bang8Cot.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            bang8Cot.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            bang8Cot.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            bang8Cot.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),
            bang8Cot.widthAnchor.constraint(equalToConstant: tongChieuRongBang),

            luoi.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 8),
            luoi.leadingAnchor.constraint(equalTo: leadingAnchor),
            luoi.trailingAnchor.constraint(equalTo: trailingAnchor),
            luoi.bottomAnchor.constraint(equalTo: bottomAnchor),

            khungTrong.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 8),
            khungTrong.leadingAnchor.constraint(equalTo: leadingAnchor),
            khungTrong.trailingAnchor.constraint(equalTo: trailingAnchor),
            khungTrong.bottomAnchor.constraint(equalTo: bottomAnchor),

            nganTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nganTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nganTrong.leadingAnchor.constraint(greaterThanOrEqualTo: khungTrong.leadingAnchor, constant: 20),
            nganTrong.trailingAnchor.constraint(lessThanOrEqualTo: khungTrong.trailingAnchor, constant: -20)
        ])

        capNhatDanhSach()
    }

    private func cauHinhMenuSapXep() {
        let hanhDong = KieuSapXepThiDua.allCases.map { kieu in
            UIAction(
                title: kieu.nhan,
                state: (kieu == kieuSapXep) ? .on : .off
            ) { [weak self] _ in
                guard let self = self else { return }
                self.kieuSapXep = kieu
                self.nutSapXep.setTitle(" ⇅ \(kieu.nhanNgan)", for: .normal)
                self.cauHinhMenuSapXep()
                self.capNhatDanhSach()
            }
        }
        nutSapXep.menu = UIMenu(title: "Sắp xếp ngành hàng", children: hanhDong)
        nutSapXep.showsMenuAsPrimaryAction = true
    }

    func ganDanhSach(_ ds: [DongThiDua]) {
        danhSachGoc = ds
        capNhatDanhSach()
    }

    private func capNhatDanhSach() {
        let tong = danhSachGoc.count
        let soDat = danhSachGoc.filter { $0.daDat }.count
        let soChuaDat = tong - soDat

        chonBoLoc.setTitle("Tất cả (\(tong))", forSegmentAt: 0)
        chonBoLoc.setTitle("Đạt (\(soDat))", forSegmentAt: 1)
        chonBoLoc.setTitle("Chưa (\(soChuaDat))", forSegmentAt: 2)

        var tam = danhSachGoc
        switch boLoc {
        case .tatCa: break
        case .daDat: tam = tam.filter { $0.daDat }
        case .chuaDat: tam = tam.filter { !$0.daDat }
        }

        switch kieuSapXep {
        case .phanTramCaoThap:
            tam.sort { $0.phanTramHT > $1.phanTramHT }
        case .phanTramThapCao:
            tam.sort { $0.phanTramHT < $1.phanTramHT }
        case .tenAZ:
            tam.sort { tenDeSapXep($0.tenNganhHang).localizedCaseInsensitiveCompare(tenDeSapXep($1.tenNganhHang)) == .orderedAscending }
        case .tenZA:
            tam.sort { tenDeSapXep($0.tenNganhHang).localizedCaseInsensitiveCompare(tenDeSapXep($1.tenNganhHang)) == .orderedDescending }
        case .thuTuGoc:
            break
        }

        danhSachHienThi = tam
        let kieu = KhoDuLieu.dungChung.caiDat.kieuHienThi
        let trong = danhSachGoc.isEmpty

        khungTrong.isHidden = !trong
        cuonNgang.isHidden = trong || (kieu != .bangChiTiet)
        luoi.isHidden = trong || (kieu != .theGon)
        nutSoCot.isHidden = (kieu != .theGon)

        bang8Cot.reloadData()
        luoi.collectionViewLayout.invalidateLayout()
        luoi.reloadData()
    }

    private func tenDeSapXep(_ ten: String) -> String {
        ten.replacingOccurrences(of: "^T\\d{1,2}\\s*[-–]\\s*", with: "", options: .regularExpression)
    }

    @objc private func doiBoLoc() {
        boLoc = BoLocThiDua(rawValue: chonBoLoc.selectedSegmentIndex) ?? .tatCa
        capNhatDanhSach()
    }

    @objc private func doiSoCot() {
        soCotTrenDienThoai = (soCotTrenDienThoai == 1) ? 2 : 1
        let icon = (soCotTrenDienThoai == 1) ? "rectangle.grid.1x2" : "square.grid.2x2"
        nutSoCot.setTitle(" \(soCotTrenDienThoai) cột", for: .normal)
        nutSoCot.setImage(UIImage(systemName: icon), for: .normal)
        luoi.collectionViewLayout.invalidateLayout()
        luoi.reloadData()
    }

    @objc private func bamQuet() {
        khiBamQuetAnh?()
    }

    // MARK: - Mẫu 2: UICollectionView (Thẻ tiến độ)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        danhSachHienThi.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OTheThiDuaCell.ma, for: indexPath) as! OTheThiDuaCell
        cell.gan(danhSachHienThi[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        khiChonDong?(danhSachHienThi[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rong = collectionView.bounds.width
        if soCotTrenDienThoai == 2 {
            let rongCot = floor((rong - 8) / 2.0)
            return CGSize(width: rongCot, height: 84)
        }
        return CGSize(width: rong, height: 76)
    }

    // MARK: - Mẫu 1: UITableView (Bảng 8 cột chi tiết giống ảnh 1)

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachHienThi.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        taoDongTieuDeCot()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongBang8CotCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .default
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let dong = danhSachHienThi[indexPath.row]
        let viewDong = taoViewDongDuLieu8Cot(stt: indexPath.row + 1, dong: dong)
        viewDong.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(viewDong)

        NSLayoutConstraint.activate([
            viewDong.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            viewDong.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            viewDong.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            viewDong.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        khiChonDong?(danhSachHienThi[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dong = danhSachHienThi[indexPath.row]
        let xoa = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, hoanTat in
            self?.khiXoaDong?(dong.id)
            hoanTat(true)
        }
        return UISwipeActionsConfiguration(actions: [xoa])
    }

    private func taoDongTieuDeCot() -> UIView {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 40))
        khung.backgroundColor = UIColor.systemGray5

        let tieuDe = ["STT", "NGÀNH HÀNG (CHƯƠNG TRÌNH)", "ĐVT", "THỰC HIỆN", "TARGET", "THIẾU/VƯỢT", "% HT THÁNG", "% DỰ BÁO"]
        var xHienTai: CGFloat = 0

        for (i, chu) in tieuDe.enumerated() {
            let rong = chieuRongCot[i]
            let nhan = UILabel(frame: CGRect(x: xHienTai + 4, y: 0, width: rong - 8, height: 40))
            nhan.text = chu
            nhan.font = .systemFont(ofSize: 11, weight: .bold)
            nhan.textColor = .label
            nhan.numberOfLines = 2
            nhan.textAlignment = (i == 1) ? .left : .center
            khung.addSubview(nhan)

            xHienTai += rong
            if i < tieuDe.count - 1 {
                let vach = UIView(frame: CGRect(x: xHienTai, y: 0, width: 0.5, height: 40))
                vach.backgroundColor = .separator
                khung.addSubview(vach)
            }
        }

        let vachDuoi = UIView(frame: CGRect(x: 0, y: 39.5, width: tongChieuRongBang, height: 0.5))
        vachDuoi.backgroundColor = .separator
        khung.addSubview(vachDuoi)
        return khung
    }

    private func taoViewDongDuLieu8Cot(stt: Int, dong: DongThiDua, chieuCao: CGFloat = 52) -> UIView {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: chieuCao))
        let dat = dong.daDat
        khung.backgroundColor = dat
            ? UIColor.systemGreen.withAlphaComponent(0.05)
            : UIColor.systemRed.withAlphaComponent(0.04)

        let mauChuChinh: UIColor = .label
        let mauTrangThai: UIColor = dat ? UIColor(red: 0.06, green: 0.52, blue: 0.24, alpha: 1) : UIColor(red: 0.80, green: 0.14, blue: 0.14, alpha: 1)
        let mauNenBadge: UIColor = dat ? UIColor.systemGreen.withAlphaComponent(0.18) : UIColor.systemRed.withAlphaComponent(0.16)

        let duBaoDat = dong.daHoanThanhDuBao
        let mauChuDuBao: UIColor = duBaoDat ? UIColor(red: 0.06, green: 0.52, blue: 0.24, alpha: 1) : UIColor(red: 0.80, green: 0.14, blue: 0.14, alpha: 1)
        let mauNenDuBao: UIColor = duBaoDat ? UIColor.systemGreen.withAlphaComponent(0.18) : UIColor.systemRed.withAlphaComponent(0.16)

        let giaTriCot: [String] = [
            "\(stt)",
            dong.tenNganhHang,
            dong.loaiChiTieu.maBang,
            dong.thucHien.chuoiSoLieu,
            dong.target.chuoiSoLieu,
            dong.chenhLech.chuoiChenhLech,
            dong.phanTramHT.chuoiPhanTram,
            dong.phanTramDuBao.chuoiPhanTram
        ]

        var xHienTai: CGFloat = 0
        for i in 0..<giaTriCot.count {
            let rong = chieuRongCot[i]
            let khungO = CGRect(x: xHienTai, y: 0, width: rong, height: chieuCao)

            if i == 6 || i == 7 {
                let badge = UILabel(frame: khungO.insetBy(dx: 6, dy: 10))
                badge.text = giaTriCot[i]
                badge.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                badge.textAlignment = .center
                badge.textColor = (i == 6) ? mauTrangThai : mauChuDuBao
                badge.backgroundColor = (i == 6) ? mauNenBadge : mauNenDuBao
                badge.layer.cornerRadius = 8
                badge.clipsToBounds = true
                khung.addSubview(badge)
            } else {
                let nhan = UILabel(frame: khungO.insetBy(dx: 6, dy: 4))
                nhan.text = giaTriCot[i]
                if i == 1 {
                    nhan.font = .systemFont(ofSize: 13, weight: .bold)
                    nhan.textAlignment = .left
                    nhan.numberOfLines = 2
                    nhan.textColor = mauChuChinh
                } else if i == 0 || i == 2 {
                    nhan.font = .systemFont(ofSize: 12, weight: .semibold)
                    nhan.textAlignment = .center
                    nhan.textColor = .secondaryLabel
                } else if i == 5 {
                    nhan.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                    nhan.textAlignment = .right
                    nhan.textColor = mauTrangThai
                } else {
                    nhan.font = .monospacedDigitSystemFont(ofSize: 13, weight: .bold)
                    nhan.textAlignment = .right
                    nhan.textColor = mauChuChinh
                }
                khung.addSubview(nhan)
            }

            xHienTai += rong
            if i < giaTriCot.count - 1 {
                let vach = UIView(frame: CGRect(x: xHienTai, y: 0, width: 0.5, height: chieuCao))
                vach.backgroundColor = .separator
                khung.addSubview(vach)
            }
        }
        return khung
    }

    // MARK: - Xuất Ảnh Báo Cáo (Tự động theo 1 trong 2 mẫu đã chọn trong Cài đặt)

    func taoAnhBaoCao(ngay: Date, doanhThu: ThongTinDoanhThu, thongTinDonVi: String, capNhatLuc: String) -> UIImage? {
        switch KhoDuLieu.dungChung.caiDat.kieuHienThi {
        case .bangChiTiet:
            return taoAnhMẫuBang8Cot(ngay: ngay, doanhThu: doanhThu, thongTinDonVi: thongTinDonVi, capNhatLuc: capNhatLuc)
        case .theGon:
            return taoAnhMauTheGon(ngay: ngay, doanhThu: doanhThu)
        }
    }

    private func taoAnhMẫuBang8Cot(ngay: Date, doanhThu: ThongTinDoanhThu, thongTinDonVi: String, capNhatLuc: String) -> UIImage? {
        let ds = danhSachHienThi
        guard !ds.isEmpty || doanhThu.coDuLieu else { return nil }

        let chieuCaoDauTrang: CGFloat = 86
        let chieuCaoDoanhThu: CGFloat = doanhThu.coDuLieu ? 110 : 0
        let chieuCaoHeaderCot: CGFloat = 40
        let chieuCaoDong: CGFloat = 50
        let le: CGFloat = 16
        let chieuRongAnh = tongChieuRongBang + le * 2
        let chieuCaoAnh = chieuCaoDauTrang + chieuCaoDoanhThu + chieuCaoHeaderCot + CGFloat(ds.count) * chieuCaoDong + le * 2

        let khungBaoCao = UIView(frame: CGRect(x: 0, y: 0, width: chieuRongAnh, height: chieuCaoAnh))
        khungBaoCao.backgroundColor = .white
        khungBaoCao.overrideUserInterfaceStyle = .light

        let tieuDe = UILabel(frame: CGRect(x: le, y: le, width: chieuRongAnh - le * 2, height: 26))
        tieuDe.text = "BẢNG TỔNG HỢP THI ĐUA ĐMX - NGÀY \(TienIchNgay.hienThiNgay.string(from: ngay))"
        tieuDe.font = .systemFont(ofSize: 18, weight: .bold)
        tieuDe.textColor = .black
        khungBaoCao.addSubview(tieuDe)

        let soDat = ds.filter { $0.daDat }.count
        let soChuaDat = ds.count - soDat
        let phuDe = UILabel(frame: CGRect(x: le, y: le + 28, width: chieuRongAnh - le * 2, height: 20))
        let chuoiDonVi = thongTinDonVi.isEmpty ? "" : "\(thongTinDonVi)  |  "
        phuDe.text = "\(chuoiDonVi)Tổng: \(ds.count) chương trình  •  Đạt (>=100%): \(soDat)  •  Chưa đạt (<100%): \(soChuaDat)"
        phuDe.font = .systemFont(ofSize: 13, weight: .semibold)
        phuDe.textColor = .darkGray
        khungBaoCao.addSubview(phuDe)

        let nhanCapNhat = UILabel(frame: CGRect(x: le, y: le + 50, width: chieuRongAnh - le * 2, height: 18))
        nhanCapNhat.text = "Cập nhật: \(capNhatLuc.isEmpty ? TienIchNgay.hienThiGioPhut.string(from: Date()) : capNhatLuc)"
        nhanCapNhat.font = .systemFont(ofSize: 12, weight: .regular)
        nhanCapNhat.textColor = .gray
        khungBaoCao.addSubview(nhanCapNhat)

        var yHienTai = le + chieuCaoDauTrang

        if doanhThu.coDuLieu {
            let rongTheDT = (chieuRongAnh - le * 2 - 14) / 2.0
            let theThuc = TheDoanhThuView(
                tieuDe: "💵 DOANH THU THỰC",
                mauBatDau: UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1),
                mauKetThuc: UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1),
                hienChamTron: false
            )
            theThuc.frame = CGRect(x: le, y: yHienTai, width: rongTheDT, height: 94)
            theThuc.capNhat(doanhThu: doanhThu.doanhThuThuc, target: doanhThu.targetThuc)
            theThuc.layoutIfNeeded()
            khungBaoCao.addSubview(theThuc)

            let theQD = TheDoanhThuView(
                tieuDe: "🎯 DOANH THU QĐ",
                mauBatDau: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1),
                mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1),
                hienChamTron: true
            )
            theQD.frame = CGRect(x: le + rongTheDT + 14, y: yHienTai, width: rongTheDT, height: 94)
            theQD.capNhat(doanhThu: doanhThu.doanhThuQuyDoi, target: doanhThu.targetQuyDoi)
            theQD.layoutIfNeeded()
            khungBaoCao.addSubview(theQD)

            yHienTai += chieuCaoDoanhThu
        }

        let khungBang = UIView(frame: CGRect(
            x: le,
            y: yHienTai,
            width: tongChieuRongBang,
            height: chieuCaoHeaderCot + CGFloat(ds.count) * chieuCaoDong
        ))
        khungBang.layer.borderWidth = 1
        khungBang.layer.borderColor = UIColor.systemGray4.cgColor
        khungBang.layer.cornerRadius = 8
        khungBang.clipsToBounds = true
        khungBaoCao.addSubview(khungBang)

        let header = taoDongTieuDeCot()
        header.frame = CGRect(x: 0, y: 0, width: tongChieuRongBang, height: chieuCaoHeaderCot)
        khungBang.addSubview(header)

        for (i, dong) in ds.enumerated() {
            let y = chieuCaoHeaderCot + CGFloat(i) * chieuCaoDong
            let vDong = taoViewDongDuLieu8Cot(stt: i + 1, dong: dong, chieuCao: chieuCaoDong)
            vDong.frame = CGRect(x: 0, y: y, width: tongChieuRongBang, height: chieuCaoDong)
            let vach = UIView(frame: CGRect(x: 0, y: chieuCaoDong - 0.5, width: tongChieuRongBang, height: 0.5))
            vach.backgroundColor = .systemGray4
            vDong.addSubview(vach)
            khungBang.addSubview(vDong)
        }

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 2.0
        return UIGraphicsImageRenderer(size: khungBaoCao.bounds.size, format: fmt).image { ctx in
            khungBaoCao.layer.render(in: ctx.cgContext)
        }
    }

    private func taoAnhMauTheGon(ngay: Date, doanhThu: ThongTinDoanhThu) -> UIImage? {
        let ds = danhSachHienThi
        guard !ds.isEmpty || doanhThu.coDuLieu else { return nil }

        let soCot = max(1, min(4, KhoDuLieu.dungChung.caiDat.soCotXuatAnh))
        let le: CGFloat = 16
        let khoangCachO: CGFloat = 12
        let rongO: CGFloat = 320
        let caoO: CGFloat = 86
        let rongAnh = max(520, le * 2 + CGFloat(soCot) * rongO + CGFloat(soCot - 1) * khoangCachO)

        let soHang = Int(ceil(Double(ds.count) / Double(soCot)))
        let caoPhanDoanhThu: CGFloat = doanhThu.coDuLieu ? 116 : 0
        let caoTieuDe: CGFloat = 44
        let caoLuoi = soHang > 0 ? (CGFloat(soHang) * caoO + CGFloat(max(0, soHang - 1)) * khoangCachO) : 0
        let caoAnh = le * 2 + caoTieuDe + caoPhanDoanhThu + caoLuoi

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khung.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        khung.overrideUserInterfaceStyle = .light

        let soDat = ds.filter { $0.daDat }.count
        let nhanDau = UILabel(frame: CGRect(x: le, y: le, width: rongAnh - le * 2, height: 28))
        nhanDau.text = "TỔNG HỢP SỐ LIỆU ĐMX - NGÀY \(TienIchNgay.hienThiNgay.string(from: ngay))   •   Tổng: \(ds.count) ngành hàng (Đạt: \(soDat) | Chưa đạt: \(ds.count - soDat))"
        nhanDau.font = .systemFont(ofSize: 16, weight: .bold)
        nhanDau.textColor = .black
        khung.addSubview(nhanDau)

        var yHienTai: CGFloat = le + caoTieuDe

        if doanhThu.coDuLieu {
            let rongTheDT = (rongAnh - le * 2 - 16) / 2.0
            let theThuc = TheDoanhThuView(
                tieuDe: "💵 DOANH THU THỰC",
                mauBatDau: UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1),
                mauKetThuc: UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1),
                hienChamTron: false
            )
            theThuc.frame = CGRect(x: le, y: yHienTai, width: rongTheDT, height: 98)
            theThuc.capNhat(doanhThu: doanhThu.doanhThuThuc, target: doanhThu.targetThuc)
            theThuc.layoutIfNeeded()
            khung.addSubview(theThuc)

            let theQD = TheDoanhThuView(
                tieuDe: "🎯 DOANH THU QĐ",
                mauBatDau: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1),
                mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1),
                hienChamTron: true
            )
            theQD.frame = CGRect(x: le + rongTheDT + 16, y: yHienTai, width: rongTheDT, height: 98)
            theQD.capNhat(doanhThu: doanhThu.doanhThuQuyDoi, target: doanhThu.targetQuyDoi)
            theQD.layoutIfNeeded()
            khung.addSubview(theQD)

            yHienTai += caoPhanDoanhThu
        }

        for (i, dong) in ds.enumerated() {
            let hang = i / soCot
            let cot = i % soCot
            let x = le + CGFloat(cot) * (rongO + khoangCachO)
            let y = yHienTai + CGFloat(hang) * (caoO + khoangCachO)

            let oThe = OTheThiDuaCell(frame: CGRect(x: x, y: y, width: rongO, height: caoO))
            oThe.overrideUserInterfaceStyle = .light
            oThe.gan(dong)
            oThe.layoutIfNeeded()
            khung.addSubview(oThe)
        }

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 2.0
        return UIGraphicsImageRenderer(size: khung.bounds.size, format: fmt).image { ctx in
            khung.layer.render(in: ctx.cgContext)
        }
    }

    // MARK: - Xuất File Excel (.csv chuẩn UTF-8 BOM mở trực tiếp trên Excel / Numbers)

    func taoChuoiExcelCSV(doanhThu: ThongTinDoanhThu) -> String {
        var cacDong: [String] = []
        if doanhThu.coDuLieu {
            cacDong.append("CHỈ SỐ CHÍNH,THỰC HIỆN,TARGET,% HOÀN THÀNH")
            let ptThuc = doanhThu.targetThuc > 0 ? String(format: "%.2f%%", (doanhThu.doanhThuThuc / doanhThu.targetThuc) * 100) : ""
            let ptQD = doanhThu.targetQuyDoi > 0 ? String(format: "%.2f%%", (doanhThu.doanhThuQuyDoi / doanhThu.targetQuyDoi) * 100) : ""
            cacDong.append("Doanh thu thực,\(doanhThu.doanhThuThuc),\(doanhThu.targetThuc),\(ptThuc)")
            cacDong.append("Doanh thu quy đổi,\(doanhThu.doanhThuQuyDoi),\(doanhThu.targetQuyDoi),\(ptQD)")
            cacDong.append("")
        }

        cacDong.append("STT,Ngành hàng (Chương trình),ĐVT,Thực hiện,Target,Thiếu / Vượt,% HT Tháng,% Dự báo,Trạng thái")
        for (i, d) in danhSachHienThi.enumerated() {
            let tenSach = "\"\(d.tenNganhHang.replacingOccurrences(of: "\"", with: "\"\""))\""
            let trangThai = d.daDat ? "Đạt" : "Chưa đạt"
            let dong = "\(i + 1),\(tenSach),\(d.loaiChiTieu.maBang),\(d.thucHien),\(d.target),\(d.chenhLech),\(String(format: "%.2f", d.phanTramHT))%,\(String(format: "%.2f", d.phanTramDuBao))%,\(trangThai)"
            cacDong.append(dong)
        }
        return "\u{FEFF}" + cacDong.joined(separator: "\n")
    }
}
