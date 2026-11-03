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

// MARK: - Thẻ Chỉ Số Gradient & Cụm 8 Thẻ "Chỉ Số Chính"

final class TheDoanhThuView: UIControl {
    private let lopGradient = CAGradientLayer()
    private let nhanTieuDe = UILabel()
    private let nhanGiaTriChinh = UILabel()
    private let vachKe = UIView()
    private let nhanTarget = UILabel()
    private let chamTron = UIView()

    init(tieuDe: String, mauBatDau: UIColor, mauKetThuc: UIColor, hienChamTron: Bool = false) {
        super.init(frame: .zero)
        layer.cornerRadius = 11
        clipsToBounds = true

        lopGradient.colors = [mauBatDau.cgColor, mauKetThuc.cgColor]
        lopGradient.startPoint = CGPoint(x: 0, y: 0)
        lopGradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(lopGradient, at: 0)

        nhanTieuDe.text = tieuDe
        nhanTieuDe.font = .systemFont(ofSize: 9.5, weight: .bold)
        nhanTieuDe.textColor = UIColor.white.withAlphaComponent(0.95)
        nhanTieuDe.textAlignment = .center
        nhanTieuDe.adjustsFontSizeToFitWidth = true
        nhanTieuDe.minimumScaleFactor = 0.55

        nhanGiaTriChinh.text = "0,00"
        nhanGiaTriChinh.font = .systemFont(ofSize: 18, weight: .heavy)
        nhanGiaTriChinh.textColor = .white
        nhanGiaTriChinh.textAlignment = .center
        nhanGiaTriChinh.adjustsFontSizeToFitWidth = true
        nhanGiaTriChinh.minimumScaleFactor = 0.5

        vachKe.backgroundColor = UIColor.white.withAlphaComponent(0.26)

        nhanTarget.text = "TARGET: 0,00"
        nhanTarget.font = .systemFont(ofSize: 9, weight: .bold)
        nhanTarget.textColor = UIColor.white.withAlphaComponent(0.92)
        nhanTarget.textAlignment = .center
        nhanTarget.adjustsFontSizeToFitWidth = true
        nhanTarget.minimumScaleFactor = 0.5

        chamTron.backgroundColor = .white
        chamTron.layer.cornerRadius = 3.5
        chamTron.isHidden = !hienChamTron

        [nhanTieuDe, nhanGiaTriChinh, vachKe, nhanTarget, chamTron].forEach {
            $0.isUserInteractionEnabled = false
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        let trailingTieuDe: CGFloat = hienChamTron ? -13 : -4
        NSLayoutConstraint.activate([
            nhanTieuDe.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            nhanTieuDe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            nhanTieuDe.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingTieuDe),

            chamTron.centerYAnchor.constraint(equalTo: nhanTieuDe.centerYAnchor),
            chamTron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            chamTron.widthAnchor.constraint(equalToConstant: 6),
            chamTron.heightAnchor.constraint(equalToConstant: 6),

            nhanGiaTriChinh.topAnchor.constraint(equalTo: nhanTieuDe.bottomAnchor, constant: 3),
            nhanGiaTriChinh.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            nhanGiaTriChinh.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),

            vachKe.topAnchor.constraint(equalTo: nhanGiaTriChinh.bottomAnchor, constant: 4),
            vachKe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            vachKe.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            vachKe.heightAnchor.constraint(equalToConstant: 1),

            nhanTarget.topAnchor.constraint(equalTo: vachKe.bottomAnchor, constant: 3),
            nhanTarget.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            nhanTarget.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            nhanTarget.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        lopGradient.frame = bounds
    }

    func capNhatNoiDung(chinh: String, phu: String, coLon: Bool = false) {
        nhanGiaTriChinh.text = chinh
        nhanTarget.text = phu
        nhanTieuDe.font = .systemFont(ofSize: coLon ? 10.5 : 8.5, weight: .bold)
        nhanGiaTriChinh.font = .systemFont(ofSize: coLon ? 21 : 15, weight: .heavy)
        nhanTarget.font = .systemFont(ofSize: coLon ? 10 : 8, weight: .bold)
    }

    func capNhat(doanhThu: Double, target: Double) {
        if doanhThu == 0 && target == 0 {
            nhanGiaTriChinh.text = "Chạm nhập/quét"
            nhanTarget.text = "TARGET: --"
        } else {
            nhanGiaTriChinh.text = doanhThu.chuoiSoVN
            if target > 0 {
                let pt = (doanhThu / target) * 100.0
                nhanTarget.text = "TARGET: \(target.chuoiSoVN) (\(pt.chuoiPhanTramVN))"
            } else {
                nhanTarget.text = "TARGET: 0,00"
            }
        }
    }
}

final class CumChiSoChinhView: UIControl {
    var khiDoiCheDoDoanhThu: ((LoaiCheDoDoanhThu) -> Void)?
    var khiBamBieuDo: (() -> Void)?
    var khiBamVungThe: (() -> Void)?

    private var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private var dangXemBieuDo: Bool = false
    private let nutLuyKe = UIButton(type: .custom)
    private let nutRealtime = UIButton(type: .custom)
    private let nutBieuDo = UIButton(type: .custom)

    private let theDTThuc = TheDoanhThuView(
        tieuDe: "💵 DOANH THU THỰC",
        mauBatDau: UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1),
        mauKetThuc: UIColor(red: 0.23, green: 0.25, blue: 0.89, alpha: 1)
    )
    private let theDTQD = TheDoanhThuView(
        tieuDe: "🎯 DOANH THU QĐ",
        mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1),
        mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1),
        hienChamTron: true
    )
    private let theTraGop = TheDoanhThuView(
        tieuDe: "💳 % TRẢ GÓP",
        mauBatDau: UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1),
        mauKetThuc: UIColor(red: 0.85, green: 0.47, blue: 0.02, alpha: 1)
    )
    private let theLuotKhach = TheDoanhThuView(
        tieuDe: "👥 LƯỢT KHÁCH",
        mauBatDau: UIColor(red: 0.01, green: 0.52, blue: 0.78, alpha: 1),
        mauKetThuc: UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1)
    )
    private let theHTQDDuKien = TheDoanhThuView(
        tieuDe: "📈 % HT QĐ DỰ KIẾN",
        mauBatDau: UIColor(red: 0.39, green: 0.40, blue: 0.95, alpha: 1),
        mauKetThuc: UIColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1)
    )
    private let thePhanTramQD = TheDoanhThuView(
        tieuDe: "🔄 % QUY ĐỔI",
        mauBatDau: UIColor(red: 0.94, green: 0.27, blue: 0.27, alpha: 1),
        mauKetThuc: UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1),
        hienChamTron: true
    )
    private let theThiDuaHT = TheDoanhThuView(
        tieuDe: "🏆 THI ĐUA HOÀN THÀNH",
        mauBatDau: UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1),
        mauKetThuc: UIColor(red: 0.66, green: 0.33, blue: 0.97, alpha: 1)
    )
    private let theTangGiam = TheDoanhThuView(
        tieuDe: "📈 TĂNG/GIẢM CÙNG KỲ",
        mauBatDau: UIColor(red: 0.98, green: 0.45, blue: 0.09, alpha: 1),
        mauKetThuc: UIColor(red: 0.92, green: 0.35, blue: 0.05, alpha: 1)
    )

    private let coLon: Bool

    init(coLon: Bool = false) {
        self.coLon = coLon
        super.init(frame: .zero)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        nutLuyKe.tag = LoaiCheDoDoanhThu.luyKe.rawValue
        nutLuyKe.setTitle("📊 Doanh thu Lũy kế", for: .normal)
        nutLuyKe.titleLabel?.font = .systemFont(ofSize: coLon ? 13.5 : 12, weight: .bold)
        nutLuyKe.titleLabel?.adjustsFontSizeToFitWidth = true
        nutLuyKe.titleLabel?.minimumScaleFactor = 0.8
        nutLuyKe.layer.cornerRadius = 10
        nutLuyKe.layer.borderWidth = 1
        nutLuyKe.addTarget(self, action: #selector(bamChonCheDo(_:)), for: .touchUpInside)

        nutRealtime.tag = LoaiCheDoDoanhThu.realtime.rawValue
        nutRealtime.setTitle("⚡ Doanh thu Realtime", for: .normal)
        nutRealtime.titleLabel?.font = .systemFont(ofSize: coLon ? 13.5 : 12, weight: .bold)
        nutRealtime.titleLabel?.adjustsFontSizeToFitWidth = true
        nutRealtime.titleLabel?.minimumScaleFactor = 0.8
        nutRealtime.layer.cornerRadius = 10
        nutRealtime.layer.borderWidth = 1
        nutRealtime.addTarget(self, action: #selector(bamChonCheDo(_:)), for: .touchUpInside)

        nutBieuDo.setTitle("📈 Biểu đồ", for: .normal)
        nutBieuDo.titleLabel?.font = .systemFont(ofSize: coLon ? 13.5 : 12, weight: .bold)
        nutBieuDo.titleLabel?.adjustsFontSizeToFitWidth = true
        nutBieuDo.titleLabel?.minimumScaleFactor = 0.8
        nutBieuDo.layer.cornerRadius = 10
        nutBieuDo.layer.borderWidth = 1
        nutBieuDo.addTarget(self, action: #selector(bamNutBieuDo), for: .touchUpInside)

        let hangBaNut = UIStackView(arrangedSubviews: [nutLuyKe, nutRealtime, nutBieuDo])
        hangBaNut.axis = .horizontal
        hangBaNut.spacing = 6
        hangBaNut.distribution = .fillProportionally

        let tatCaThe = [theDTThuc, theDTQD, theTraGop, theLuotKhach, theHTQDDuKien, thePhanTramQD, theThiDuaHT, theTangGiam]
        tatCaThe.forEach { $0.isUserInteractionEnabled = false }

        let khoangCach: CGFloat = coLon ? 10 : 5
        let hang1 = UIStackView(arrangedSubviews: [theDTThuc, theDTQD, theTraGop, theLuotKhach])
        hang1.axis = .horizontal
        hang1.spacing = khoangCach
        hang1.distribution = .fillEqually
        hang1.isUserInteractionEnabled = false

        let hang2 = UIStackView(arrangedSubviews: [theHTQDDuKien, thePhanTramQD, theThiDuaHT, theTangGiam])
        hang2.axis = .horizontal
        hang2.spacing = khoangCach
        hang2.distribution = .fillEqually
        hang2.isUserInteractionEnabled = false

        let luoiThe = UIStackView(arrangedSubviews: [hang1, hang2])
        luoiThe.axis = .vertical
        luoiThe.spacing = khoangCach
        luoiThe.distribution = .fillEqually
        luoiThe.isUserInteractionEnabled = true

        let tapLuoiThe = UITapGestureRecognizer(target: self, action: #selector(bamVaoLuoiThe))
        luoiThe.addGestureRecognizer(tapLuoiThe)

        let nganChinh = UIStackView(arrangedSubviews: [hangBaNut, luoiThe])
        nganChinh.axis = .vertical
        nganChinh.spacing = coLon ? 8 : 6
        nganChinh.isUserInteractionEnabled = true
        nganChinh.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nganChinh)

        NSLayoutConstraint.activate([
            hangBaNut.heightAnchor.constraint(equalToConstant: coLon ? 38 : 34),
            nutLuyKe.widthAnchor.constraint(equalTo: nutRealtime.widthAnchor),
            nutBieuDo.widthAnchor.constraint(equalTo: nutLuyKe.widthAnchor, multiplier: 0.72),
            nganChinh.topAnchor.constraint(equalTo: topAnchor),
            nganChinh.leadingAnchor.constraint(equalTo: leadingAnchor),
            nganChinh.trailingAnchor.constraint(equalTo: trailingAnchor),
            nganChinh.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        capNhatMauNutCheDo()
    }

    @objc private func bamChonCheDo(_ sender: UIButton) {
        guard let moi = LoaiCheDoDoanhThu(rawValue: sender.tag) else { return }
        dangXemBieuDo = false
        cheDoDoanhThu = moi
        capNhatMauNutCheDo()
        khiDoiCheDoDoanhThu?(moi)
    }

    @objc private func bamNutBieuDo() {
        dangXemBieuDo = true
        capNhatMauNutCheDo()
        khiBamBieuDo?()
    }

    @objc private func bamVaoLuoiThe() {
        if let khiBamVungThe {
            khiBamVungThe()
        } else {
            sendActions(for: .touchUpInside)
        }
    }

    private func capNhatMauNutCheDo() {
        for (nut, loai) in [(nutLuyKe, LoaiCheDoDoanhThu.luyKe), (nutRealtime, LoaiCheDoDoanhThu.realtime)] {
            if !dangXemBieuDo && cheDoDoanhThu == loai {
                nut.backgroundColor = .systemBlue
                nut.setTitleColor(.white, for: .normal)
                nut.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                nut.backgroundColor = .secondarySystemGroupedBackground
                nut.setTitleColor(.label, for: .normal)
                nut.layer.borderColor = UIColor.separator.cgColor
            }
        }
        if dangXemBieuDo {
            nutBieuDo.backgroundColor = .systemBlue
            nutBieuDo.setTitleColor(.white, for: .normal)
            nutBieuDo.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            nutBieuDo.backgroundColor = .secondarySystemGroupedBackground
            nutBieuDo.setTitleColor(.label, for: .normal)
            nutBieuDo.layer.borderColor = UIColor.separator.cgColor
        }
    }

    func capNhat(doanhThu dt: ThongTinDoanhThu, soNganhDat: Int, tongSoNganh: Int, ngay: Date = Date(), cheDo: LoaiCheDoDoanhThu = .luyKe, dangXemBieuDo: Bool = false) {
        self.cheDoDoanhThu = cheDo
        self.dangXemBieuDo = dangXemBieuDo
        capNhatMauNutCheDo()

        if !dt.coDuLieu {
            theDTThuc.capNhatNoiDung(chinh: coLon ? "0,00" : "Chạm quét", phu: "TARGET: --", coLon: coLon)
            theDTQD.capNhatNoiDung(chinh: coLon ? "0,00" : "Chạm quét", phu: "TARGET: --", coLon: coLon)
        } else {
            theDTThuc.capNhatNoiDung(
                chinh: dt.doanhThuThuc.chuoiSoVN,
                phu: "TARGET: \(dt.targetThuc.chuoiSoVN)",
                coLon: coLon
            )
            theDTQD.capNhatNoiDung(
                chinh: dt.doanhThuQuyDoi.chuoiSoVN,
                phu: "TARGET: \(dt.targetQuyDoi.chuoiSoVN)",
                coLon: coLon
            )
        }

        theTraGop.capNhatNoiDung(
            chinh: dt.phanTramTraGop.chuoiPhanTramVN,
            phu: "DT: \(dt.doanhThuTraGop.chuoiSoVN)",
            coLon: coLon
        )

        theLuotKhach.capNhatNoiDung(
            chinh: dt.luotKhach.chuoiSoNguyenVN,
            phu: "BILL: \(dt.soBill.chuoiSoNguyenVN) | PVTC: \(dt.phanTramPVTC.chuoiPhanTram)",
            coLon: coLon
        )

        let dkHienThi = dt.duKienQuyDoi > 0 ? dt.duKienQuyDoi : dt.duKienThuc
        theHTQDDuKien.capNhatNoiDung(
            chinh: dt.phanTramHTQDDuKienHienThi.chuoiPhanTramVN,
            phu: "DTQĐ DK: \(dkHienThi.chuoiSoVN)",
            coLon: coLon
        )

        thePhanTramQD.capNhatNoiDung(
            chinh: dt.phanTramQuyDoi.chuoiPhanTramVN,
            phu: "MỤC TIÊU: 50%",
            coLon: coLon
        )

        let tyLeTD = tongSoNganh > 0 ? Int(round(Double(soNganhDat) / Double(tongSoNganh) * 100.0)) : 0
        theThiDuaHT.capNhatNoiDung(
            chinh: "\(soNganhDat)/\(tongSoNganh)",
            phu: "TỶ LỆ: \(tyLeTD)%",
            coLon: coLon
        )

        let dauTG = dt.tangGiamCungKy > 0 ? "+" : ""
        let phuTG: String
        if dt.tb3Thang > 0 {
            let goc = dt.doanhThuThuc > 0 ? dt.doanhThuThuc : dt.doanhThuQuyDoi
            if goc > 0 {
                let chenh = goc - dt.tb3Thang
                phuTG = chenh >= 0 ? "TĂNG \(abs(chenh).chuoiSoVN)" : "GIẢM \(abs(chenh).chuoiSoVN)"
            } else {
                phuTG = "TB3T: \(dt.tb3Thang.chuoiSoVN)"
            }
        } else {
            phuTG = "TB3T: 0,00"
        }
        theTangGiam.capNhatNoiDung(
            chinh: "\(dauTG)\(dt.tangGiamCungKy.chuoiPhanTram)",
            phu: phuTG,
            coLon: coLon
        )

        setNeedsLayout()
        layoutIfNeeded()
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
    var khiSuaDong: ((DongThiDua) -> Void)?
    var khiXoaDong: ((UUID) -> Void)?
    var khiBamQuetAnh: (() -> Void)?

    private var danhSachGoc: [DongThiDua] = []
    private var danhSachHienThi: [DongThiDua] = []
    private(set) var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private var boLoc: BoLocThiDua = .tatCa
    private var kieuSapXep: KieuSapXepThiDua = .phanTramCaoThap
    private var soCotTrenDienThoai: Int = 1
    private let tieuDeTrong = UILabel()
    private let phuDeTrong = UILabel()

    // Chiều rộng 8 cột cho Mẫu 1 (Bảng 8 cột chi tiết)
    private let chieuRongCot: [CGFloat] = [38, 210, 48, 88, 88, 92, 84, 84]
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
        chonBoLoc.apportionsSegmentWidthsByContent = true
        chonBoLoc.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10.5, weight: .semibold)], for: .normal)
        chonBoLoc.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 10.5, weight: .bold)], for: .selected)
        chonBoLoc.addTarget(self, action: #selector(doiBoLoc), for: .valueChanged)

        nutSapXep.setTitle("⇅ \(kieuSapXep.nhanNgan)", for: .normal)
        nutSapXep.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        nutSapXep.backgroundColor = .secondarySystemGroupedBackground
        nutSapXep.tintColor = .systemBlue
        nutSapXep.layer.cornerRadius = 8
        nutSapXep.layer.borderWidth = 1
        nutSapXep.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.25).cgColor
        nutSapXep.contentEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
        cauHinhMenuSapXep()

        nutSoCot.setTitle(" 1c", for: .normal)
        nutSoCot.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .normal)
        nutSoCot.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        nutSoCot.backgroundColor = .secondarySystemGroupedBackground
        nutSoCot.tintColor = .systemBlue
        nutSoCot.layer.cornerRadius = 8
        nutSoCot.contentEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
        nutSoCot.addTarget(self, action: #selector(doiSoCot), for: .touchUpInside)

        let thanhDieuKhien = UIStackView(arrangedSubviews: [chonBoLoc, nutSapXep, nutSoCot])
        thanhDieuKhien.axis = .horizontal
        thanhDieuKhien.spacing = 4
        chonBoLoc.setContentHuggingPriority(.defaultLow, for: .horizontal)
        chonBoLoc.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutSapXep.setContentHuggingPriority(.required, for: .horizontal)
        nutSapXep.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nutSoCot.setContentHuggingPriority(.required, for: .horizontal)
        nutSoCot.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        // Khởi tạo Mẫu 1 (Bảng 8 cột)
        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.showsVerticalScrollIndicator = false
        cuonNgang.bounces = false
        cuonNgang.layer.cornerRadius = 12
        cuonNgang.clipsToBounds = true
        cuonNgang.backgroundColor = .systemBackground

        bang8Cot.dataSource = self
        bang8Cot.delegate = self
        bang8Cot.rowHeight = 56
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

        tieuDeTrong.text = "Chạm để chọn ảnh Thi đua (Lũy kế)"
        tieuDeTrong.font = .systemFont(ofSize: 15, weight: .bold)
        tieuDeTrong.textAlignment = .center

        phuDeTrong.text = "Bảng Thi đua Lũy kế và Thi đua Realtime được lưu riêng biệt.\nChạm vào đây hoặc nút Thêm ảnh để tải ảnh Thi đua."
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
                self.nutSapXep.setTitle("⇅ \(kieu.nhanNgan)", for: .normal)
                self.cauHinhMenuSapXep()
                self.capNhatDanhSach()
            }
        }
        nutSapXep.menu = UIMenu(title: "Sắp xếp ngành hàng", children: hanhDong)
        nutSapXep.showsMenuAsPrimaryAction = true
    }

    func ganDanhSach(_ ds: [DongThiDua], cheDo: LoaiCheDoDoanhThu = .luyKe) {
        cheDoDoanhThu = cheDo
        danhSachGoc = ds
        capNhatDanhSach()
    }

    private func locVaSapXep(_ dsGoc: [DongThiDua]) -> [DongThiDua] {
        var tam = dsGoc
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
        return tam
    }

    private func capNhatDanhSach() {
        let tong = danhSachGoc.count
        let soDat = danhSachGoc.filter { $0.daDat }.count
        let soChuaDat = tong - soDat

        chonBoLoc.setTitle("Tất cả (\(tong))", forSegmentAt: 0)
        chonBoLoc.setTitle("Đạt (\(soDat))", forSegmentAt: 1)
        chonBoLoc.setTitle("Chưa đạt (\(soChuaDat))", forSegmentAt: 2)

        let nhanCheDo = (cheDoDoanhThu == .luyKe) ? "Lũy kế" : "Realtime"
        tieuDeTrong.text = "Chạm để chọn ảnh Thi đua (\(nhanCheDo))"
        phuDeTrong.text = "Bảng Thi đua Lũy kế và Thi đua Realtime được lưu riêng biệt.\nChạm vào đây hoặc nút Thêm ảnh để tải ảnh Thi đua \(nhanCheDo)."

        danhSachHienThi = locVaSapXep(danhSachGoc)
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
        nutSoCot.setTitle(" \(soCotTrenDienThoai)c", for: .normal)
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

    // MARK: - Mẫu 1: UITableView (Bảng 8 cột chi tiết)

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
        let viewDong = taoViewDongDuLieu8Cot(stt: indexPath.row + 1, dong: dong, chieuCao: 56, hienNhanNV: true)
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
        let sua = UIContextualAction(style: .normal, title: "Sửa") { [weak self] _, _, hoanTat in
            self?.khiSuaDong?(dong)
            hoanTat(true)
        }
        sua.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [xoa, sua])
    }

    private func taoDongTieuDeCot(cheDo: LoaiCheDoDoanhThu? = nil) -> UIView {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 40))
        khung.backgroundColor = UIColor.systemGray5

        let cheDoHienThi = cheDo ?? cheDoDoanhThu
        let cotHT = (cheDoHienThi == .luyKe) ? "% HT THÁNG" : "% HT NGÀY"
        let tieuDe = ["STT", "NGÀNH HÀNG (BẤM XEM NV)", "ĐVT", "THỰC HIỆN", "TARGET", "THIẾU/VƯỢT", cotHT, "% DỰ BÁO"]
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

    private func taoViewDongDuLieu8Cot(stt: Int, dong: DongThiDua, chieuCao: CGFloat = 52, hienNhanNV: Bool = false) -> UIView {
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

        let soNVGiao = KhoDuLieu.dungChung.danhSachMaNVChiaTarget(cho: dong).count
        let moiNV = soNVGiao > 0 ? (dong.target / Double(soNVGiao)) : 0

        var xHienTai: CGFloat = 0
        for i in 0..<giaTriCot.count {
            let rong = chieuRongCot[i]
            let khungO = CGRect(x: xHienTai, y: 0, width: rong, height: chieuCao)

            if i == 6 || i == 7 {
                let badge = UILabel(frame: khungO.insetBy(dx: 6, dy: (chieuCao - 30) / 2))
                badge.text = giaTriCot[i]
                badge.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                badge.textAlignment = .center
                badge.textColor = (i == 6) ? mauTrangThai : mauChuDuBao
                badge.backgroundColor = (i == 6) ? mauNenBadge : mauNenDuBao
                badge.layer.cornerRadius = 8
                badge.clipsToBounds = true
                khung.addSubview(badge)
            } else if i == 1 && hienNhanNV {
                let lbTen = UILabel(frame: CGRect(x: xHienTai + 6, y: 4, width: rong - 12, height: 32))
                lbTen.text = dong.tenNganhHang
                lbTen.font = .systemFont(ofSize: 12.5, weight: .bold)
                lbTen.textColor = mauChuChinh
                lbTen.numberOfLines = 2
                let lbNV = UILabel(frame: CGRect(x: xHienTai + 6, y: 36, width: rong - 12, height: 15))
                lbNV.text = "👥 \(soNVGiao) NV (\(String(format: "%.1f", moiNV))/NV)"
                lbNV.font = .systemFont(ofSize: 10.5, weight: .semibold)
                lbNV.textColor = .systemBlue
                khung.addSubview(lbTen)
                khung.addSubview(lbNV)
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

    // MARK: - Xuất Ảnh Báo Cáo Thi Đua (Theo Doanh thu Lũy kế hoặc Realtime & theo mẫu trong Cài đặt)

    func taoAnhBaoCao(
        ngay: Date,
        doanhThu: ThongTinDoanhThu,
        danhSach: [DongThiDua]? = nil,
        cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let dsXuat = danhSach.map { locVaSapXep($0) } ?? danhSachHienThi
        switch KhoDuLieu.dungChung.caiDat.kieuHienThi {
        case .bangChiTiet:
            return taoAnhMauBang8Cot(
                ngay: ngay,
                doanhThu: doanhThu,
                danhSach: dsXuat,
                cheDoDoanhThu: cheDoDoanhThu,
                thongTinDonVi: thongTinDonVi,
                capNhatLuc: capNhatLuc
            )
        case .theGon:
            return taoAnhMauTheGon(
                ngay: ngay,
                doanhThu: doanhThu,
                danhSach: dsXuat,
                cheDoDoanhThu: cheDoDoanhThu,
                thongTinDonVi: thongTinDonVi,
                capNhatLuc: capNhatLuc
            )
        }
    }

    private func taoAnhMauBang8Cot(
        ngay: Date,
        doanhThu: ThongTinDoanhThu,
        danhSach: [DongThiDua],
        cheDoDoanhThu: LoaiCheDoDoanhThu,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let ds = danhSach
        let soDat = ds.filter { $0.daDat }.count
        let soKhongDat = ds.count - soDat

        let donVi = thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : thongTinDonVi
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let nhanCheDo = (cheDoDoanhThu == .luyKe) ? "DOANH THU LŨY KẾ" : "DOANH THU REALTIME"

        let chieuCaoTieuDe: CGFloat = 52
        let chieuCaoDoanhThu: CGFloat = 242
        let chieuCaoDongThongKe: CGFloat = 28
        let chieuCaoHeaderCot: CGFloat = 40
        let chieuCaoDong: CGFloat = 50
        let le: CGFloat = 16
        let chieuRongAnh = tongChieuRongBang + le * 2
        let soDongBang = max(1, ds.count)
        let chieuCaoAnh = chieuCaoTieuDe + chieuCaoDoanhThu + chieuCaoDongThongKe + chieuCaoHeaderCot + CGFloat(soDongBang) * chieuCaoDong + le * 2

        let khungBaoCao = UIView(frame: CGRect(x: 0, y: 0, width: chieuRongAnh, height: chieuCaoAnh))
        khungBaoCao.backgroundColor = .white
        khungBaoCao.overrideUserInterfaceStyle = .light

        let lbPhu = UILabel(frame: CGRect(x: le, y: le, width: chieuRongAnh - le * 2, height: 18))
        lbPhu.text = "\(donVi)  •  Ngày \(ngayStr)\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        lbPhu.font = .systemFont(ofSize: 12, weight: .bold)
        lbPhu.textColor = .darkGray
        khungBaoCao.addSubview(lbPhu)

        let tieuDe = UILabel(frame: CGRect(x: le, y: le + 20, width: chieuRongAnh - le * 2, height: 26))
        tieuDe.text = "BẢNG TỔNG HỢP THI ĐUA — \(nhanCheDo)"
        tieuDe.font = .systemFont(ofSize: 19, weight: .heavy)
        tieuDe.textColor = .black
        khungBaoCao.addSubview(tieuDe)

        var yHienTai = le + chieuCaoTieuDe

        let cumChiSo = CumChiSoChinhView(coLon: true)
        cumChiSo.overrideUserInterfaceStyle = .light
        cumChiSo.frame = CGRect(x: le, y: yHienTai, width: chieuRongAnh - le * 2, height: 228)
        cumChiSo.capNhat(doanhThu: doanhThu, soNganhDat: soDat, tongSoNganh: ds.count, ngay: ngay, cheDo: cheDoDoanhThu)
        cumChiSo.layoutIfNeeded()
        khungBaoCao.addSubview(cumChiSo)
        yHienTai += chieuCaoDoanhThu

        let dongThongKe = UILabel(frame: CGRect(x: le, y: yHienTai, width: chieuRongAnh - le * 2, height: 22))
        dongThongKe.text = "Tổng: \(ds.count) ngành hàng   •   Đạt: \(soDat)   •   Không đạt: \(soKhongDat)"
        dongThongKe.font = .systemFont(ofSize: 13.5, weight: .semibold)
        dongThongKe.textColor = .darkGray
        khungBaoCao.addSubview(dongThongKe)

        yHienTai += chieuCaoDongThongKe

        let khungBang = UIView(frame: CGRect(
            x: le,
            y: yHienTai,
            width: tongChieuRongBang,
            height: chieuCaoHeaderCot + CGFloat(soDongBang) * chieuCaoDong
        ))
        khungBang.layer.borderWidth = 1
        khungBang.layer.borderColor = UIColor.systemGray4.cgColor
        khungBang.layer.cornerRadius = 8
        khungBang.clipsToBounds = true
        khungBaoCao.addSubview(khungBang)

        let header = taoDongTieuDeCot(cheDo: cheDoDoanhThu)
        header.frame = CGRect(x: 0, y: 0, width: tongChieuRongBang, height: chieuCaoHeaderCot)
        khungBang.addSubview(header)

        if ds.isEmpty {
            let lbTrong = UILabel(frame: CGRect(x: 0, y: chieuCaoHeaderCot, width: tongChieuRongBang, height: chieuCaoDong))
            lbTrong.text = "Chưa có ngành hàng thi đua nào trong danh sách."
            lbTrong.font = .systemFont(ofSize: 13, weight: .medium)
            lbTrong.textColor = .gray
            lbTrong.textAlignment = .center
            khungBang.addSubview(lbTrong)
        } else {
            for (i, dong) in ds.enumerated() {
                let y = chieuCaoHeaderCot + CGFloat(i) * chieuCaoDong
                let vDong = taoViewDongDuLieu8Cot(stt: i + 1, dong: dong, chieuCao: chieuCaoDong, hienNhanNV: false)
                vDong.frame = CGRect(x: 0, y: y, width: tongChieuRongBang, height: chieuCaoDong)
                let vach = UIView(frame: CGRect(x: 0, y: chieuCaoDong - 0.5, width: tongChieuRongBang, height: 0.5))
                vach.backgroundColor = .systemGray4
                vDong.addSubview(vach)
                khungBang.addSubview(vDong)
            }
        }

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 2.0
        return UIGraphicsImageRenderer(size: khungBaoCao.bounds.size, format: fmt).image { ctx in
            khungBaoCao.layer.render(in: ctx.cgContext)
        }
    }

    private func taoAnhMauTheGon(
        ngay: Date,
        doanhThu: ThongTinDoanhThu,
        danhSach: [DongThiDua],
        cheDoDoanhThu: LoaiCheDoDoanhThu,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let ds = danhSach
        let soDat = ds.filter { $0.daDat }.count
        let soKhongDat = ds.count - soDat

        let donVi = thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : thongTinDonVi
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let nhanCheDo = (cheDoDoanhThu == .luyKe) ? "DOANH THU LŨY KẾ" : "DOANH THU REALTIME"

        let soCot = max(1, min(4, KhoDuLieu.dungChung.caiDat.soCotXuatAnh))
        let le: CGFloat = 16
        let khoangCachO: CGFloat = 12
        let rongO: CGFloat = 320
        let caoO: CGFloat = 86
        let rongAnh = max(760, le * 2 + CGFloat(soCot) * rongO + CGFloat(soCot - 1) * khoangCachO)

        let soHang = Int(ceil(Double(ds.count) / Double(soCot)))
        let caoTieuDe: CGFloat = 52
        let caoPhanDoanhThu: CGFloat = 242
        let caoDongThongKe: CGFloat = 28
        let caoLuoi = soHang > 0 ? (CGFloat(soHang) * caoO + CGFloat(max(0, soHang - 1)) * khoangCachO) : 48
        let caoAnh = le * 2 + caoTieuDe + caoPhanDoanhThu + caoDongThongKe + caoLuoi

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khung.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        khung.overrideUserInterfaceStyle = .light

        let lbPhu = UILabel(frame: CGRect(x: le, y: le, width: rongAnh - le * 2, height: 18))
        lbPhu.text = "\(donVi)  •  Ngày \(ngayStr)\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        lbPhu.font = .systemFont(ofSize: 12, weight: .bold)
        lbPhu.textColor = .darkGray
        khung.addSubview(lbPhu)

        let nhanDau = UILabel(frame: CGRect(x: le, y: le + 20, width: rongAnh - le * 2, height: 26))
        nhanDau.text = "BẢNG TỔNG HỢP THI ĐUA — \(nhanCheDo)"
        nhanDau.font = .systemFont(ofSize: 19, weight: .heavy)
        nhanDau.textColor = .black
        khung.addSubview(nhanDau)

        var yHienTai: CGFloat = le + caoTieuDe

        let cumChiSo = CumChiSoChinhView(coLon: true)
        cumChiSo.overrideUserInterfaceStyle = .light
        cumChiSo.frame = CGRect(x: le, y: yHienTai, width: rongAnh - le * 2, height: 228)
        cumChiSo.capNhat(doanhThu: doanhThu, soNganhDat: soDat, tongSoNganh: ds.count, ngay: ngay, cheDo: cheDoDoanhThu)
        cumChiSo.layoutIfNeeded()
        khung.addSubview(cumChiSo)
        yHienTai += caoPhanDoanhThu

        let dongThongKe = UILabel(frame: CGRect(x: le, y: yHienTai, width: rongAnh - le * 2, height: 22))
        dongThongKe.text = "Tổng: \(ds.count) ngành hàng   •   Đạt: \(soDat)   •   Không đạt: \(soKhongDat)"
        dongThongKe.font = .systemFont(ofSize: 13.5, weight: .semibold)
        dongThongKe.textColor = .darkGray
        khung.addSubview(dongThongKe)

        yHienTai += caoDongThongKe

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

    func taoChuoiExcelCSV(doanhThu: ThongTinDoanhThu, danhSach: [DongThiDua]? = nil, cheDo: LoaiCheDoDoanhThu? = nil) -> String {
        var cacDong: [String] = []
        let ds = danhSach.map { locVaSapXep($0) } ?? danhSachHienThi
        let cheDoCSV = cheDo ?? cheDoDoanhThu
        let soDat = ds.filter { $0.daDat }.count
        if doanhThu.coDuLieu {
            cacDong.append("CHỈ SỐ CHÍNH,GIÁ TRỊ CHÍNH,CHI TIẾT / MỤC TIÊU")
            cacDong.append("Doanh thu thực,\(doanhThu.doanhThuThuc),Target: \(doanhThu.targetThuc)")
            cacDong.append("Doanh thu quy đổi,\(doanhThu.doanhThuQuyDoi),Target: \(doanhThu.targetQuyDoi)")
            cacDong.append("% Trả góp,\(String(format: "%.2f%%", doanhThu.phanTramTraGop)),DT trả góp: \(doanhThu.doanhThuTraGop)")
            cacDong.append("Lượt khách,\(Int(doanhThu.luotKhach)),Bill: \(Int(doanhThu.soBill)) | PVTC: \(String(format: "%.1f%%", doanhThu.phanTramPVTC))")
            let dk = doanhThu.duKienQuyDoi > 0 ? doanhThu.duKienQuyDoi : doanhThu.duKienThuc
            cacDong.append("% HT QĐ dự kiến,\(String(format: "%.2f%%", doanhThu.phanTramHTQDDuKienHienThi)),DTQĐ DK: \(dk)")
            cacDong.append("% Quy đổi,\(String(format: "%.2f%%", doanhThu.phanTramQuyDoi)),Mục tiêu: 50%")
            cacDong.append("Thi đua hoàn thành,\(soDat)/\(ds.count),Tỷ lệ: \(ds.count > 0 ? Int(round(Double(soDat) / Double(ds.count) * 100)) : 0)%")
            cacDong.append("Tăng/giảm cùng kỳ,\(String(format: "%.1f%%", doanhThu.tangGiamCungKy)),TB3T: \(doanhThu.tb3Thang)")
            cacDong.append("")
        }

        let cotHT = (cheDoCSV == .luyKe) ? "% HT Tháng" : "% HT Ngày"
        cacDong.append("STT,Ngành hàng (Chương trình),ĐVT,Thực hiện,Target,Thiếu / Vượt,\(cotHT),% Dự báo,Trạng thái")
        for (i, d) in ds.enumerated() {
            let tenSach = "\"\(d.tenNganhHang.replacingOccurrences(of: "\"", with: "\"\""))\""
            let trangThai = d.daDat ? "Đạt" : "Chưa đạt"
            let dong = "\(i + 1),\(tenSach),\(d.loaiChiTieu.maBang),\(d.thucHien),\(d.target),\(d.chenhLech),\(String(format: "%.2f", d.phanTramHT))%,\(String(format: "%.2f", d.phanTramDuBao))%,\(trangThai)"
            cacDong.append(dong)
        }
        return "\u{FEFF}" + cacDong.joined(separator: "\n")
    }
}


// MARK: - 4. Màn hình / Khung Biểu Đồ & Tổng Hợp Realtime Theo Tháng
// Bao gồm:
// 1. Hai thẻ Doanh thu Lũy kế Thực & Quy đổi (cố định trong tháng)
// 2. Đồ thị cột Doanh thu Thực & Doanh thu Quy đổi theo từng ngày trong tháng của Siêu thị
// 3. MỤC MỚI: Theo dõi sức bán nhân viên theo ngày (lấy từ Doanh thu Realtime Nhân viên), chọn Mã NV - Họ tên qua danh sách đổ ra, biểu đồ & bảng tỷ lệ đóng góp theo ngày, kèm Cảnh báo nhân viên nhiều ngày yếu liên tục cho quản lý
// 4. Bảng chi tiết số liệu Realtime siêu thị theo từng ngày trong tháng

private final class VeBieuDoCotRealtimeView: UIView {
    var danhSachNgay: [DuLieuRealtimeNgayTrongThang] = [] {
        didSet { setNeedsDisplay() }
    }
    var ngayDangChon: Int = 1 {
        didSet { setNeedsDisplay() }
    }
    var khiChonNgay: ((DuLieuRealtimeNgayTrongThang) -> Void)?

    private let leTrai: CGFloat = 46
    private let lePhai: CGFloat = 14
    private let leTren: CGFloat = 26
    private let leDuoi: CGFloat = 34
    let chieuRongMoiNgay: CGFloat = 58

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(xuLyCham(_:)))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    @objc private func xuLyCham(_ g: UITapGestureRecognizer) {
        guard !danhSachNgay.isEmpty else { return }
        let diem = g.location(in: self)
        guard diem.x >= leTrai else { return }
        let idx = Int((diem.x - leTrai) / chieuRongMoiNgay)
        if idx >= 0 && idx < danhSachNgay.count {
            khiChonNgay?(danhSachNgay[idx])
        }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let caoVe = max(40, rect.height - leTren - leDuoi)
        let rongVe = max(60, rect.width - leTrai - lePhai)

        let maxValRaw = danhSachNgay.reduce(0.0) { acc, item in
            max(acc, max(item.doanhThuThuc, item.doanhThuQuyDoi))
        }
        let maxVal = maxValRaw > 0 ? maxValRaw * 1.15 : 100.0

        let fontTruc = UIFont.monospacedDigitSystemFont(ofSize: 9.5, weight: .semibold)
        let mauChuPhu = UIColor.secondaryLabel
        let mauLuoi = UIColor.separator.withAlphaComponent(0.45)

        let soMucLuoi = 4
        for i in 0...soMucLuoi {
            let tyLe = CGFloat(i) / CGFloat(soMucLuoi)
            let y = leTren + caoVe * (1.0 - tyLe)
            let giaTri = maxVal * Double(tyLe)

            ctx.setStrokeColor(mauLuoi.cgColor)
            ctx.setLineWidth(i == 0 ? 1.0 : 0.6)
            if i > 0 {
                ctx.setLineDash(phase: 0, lengths: [3, 3])
            } else {
                ctx.setLineDash(phase: 0, lengths: [])
            }
            ctx.move(to: CGPoint(x: leTrai, y: y))
            ctx.addLine(to: CGPoint(x: leTrai + rongVe, y: y))
            ctx.strokePath()

            let chuY = giaTri >= 1000 ? String(format: "%.0f", giaTri) : giaTri.chuoiSoGonVN
            let attrY: [NSAttributedString.Key: Any] = [
                .font: fontTruc,
                .foregroundColor: mauChuPhu
            ]
            let sizeY = (chuY as NSString).size(withAttributes: attrY)
            (chuY as NSString).draw(
                at: CGPoint(x: max(2, leTrai - sizeY.width - 5), y: y - sizeY.height / 2),
                withAttributes: attrY
            )
        }
        ctx.setLineDash(phase: 0, lengths: [])

        guard !danhSachNgay.isEmpty else {
            let thongBao = "Chưa có dữ liệu Realtime ngày nào trong tháng — chạm nút Thêm ảnh hoặc Nhập/Mẫu để thêm."
            let attr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: mauChuPhu
            ]
            let sz = (thongBao as NSString).size(withAttributes: attr)
            (thongBao as NSString).draw(
                at: CGPoint(x: max(leTrai + 8, (rect.width - sz.width) / 2), y: leTren + caoVe / 2 - sz.height / 2),
                withAttributes: attr
            )
            return
        }

        let mauThuc = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
        let mauQuyDoi = UIColor(red: 0.08, green: 0.60, blue: 0.28, alpha: 1.0)
        let fontSo = UIFont.monospacedDigitSystemFont(ofSize: 8.5, weight: .bold)
        let fontNgay = UIFont.systemFont(ofSize: 10, weight: .bold)

        let rongCot: CGFloat = 18
        let khoangCach2Cot: CGFloat = 3

        for (i, item) in danhSachNgay.enumerated() {
            let xTam = leTrai + CGFloat(i) * chieuRongMoiNgay + chieuRongMoiNgay / 2
            let yDay = leTren + caoVe

            if item.ngayTrongThang == ngayDangChon {
                let khungChon = CGRect(
                    x: xTam - chieuRongMoiNgay / 2 + 2,
                    y: leTren - 4,
                    width: chieuRongMoiNgay - 4,
                    height: caoVe + leDuoi
                )
                let pathNen = UIBezierPath(roundedRect: khungChon, cornerRadius: 8)
                UIColor.systemBlue.withAlphaComponent(0.08).setFill()
                pathNen.fill()
            }

            let caoThuc = item.doanhThuThuc > 0 ? max(4, CGFloat(item.doanhThuThuc / maxVal) * caoVe) : 0
            let xThuc = xTam - khoangCach2Cot / 2 - rongCot
            if caoThuc > 0 {
                let rectThuc = CGRect(x: xThuc, y: yDay - caoThuc, width: rongCot, height: caoThuc)
                let pathThuc = UIBezierPath(
                    roundedRect: rectThuc,
                    byRoundingCorners: [.topLeft, .topRight],
                    cornerRadii: CGSize(width: 4, height: 4)
                )
                mauThuc.setFill()
                pathThuc.fill()

                let chuSo = item.doanhThuThuc.chuoiSoGonVN
                let attrSo: [NSAttributedString.Key: Any] = [.font: fontSo, .foregroundColor: mauThuc]
                let szSo = (chuSo as NSString).size(withAttributes: attrSo)
                (chuSo as NSString).draw(
                    at: CGPoint(x: xThuc + (rongCot - szSo.width) / 2, y: max(2, yDay - caoThuc - szSo.height - 2)),
                    withAttributes: attrSo
                )
            }

            let caoQD = item.doanhThuQuyDoi > 0 ? max(4, CGFloat(item.doanhThuQuyDoi / maxVal) * caoVe) : 0
            let xQD = xTam + khoangCach2Cot / 2
            if caoQD > 0 {
                let rectQD = CGRect(x: xQD, y: yDay - caoQD, width: rongCot, height: caoQD)
                let pathQD = UIBezierPath(
                    roundedRect: rectQD,
                    byRoundingCorners: [.topLeft, .topRight],
                    cornerRadii: CGSize(width: 4, height: 4)
                )
                mauQuyDoi.setFill()
                pathQD.fill()

                let chuQD = item.doanhThuQuyDoi.chuoiSoGonVN
                let attrQD: [NSAttributedString.Key: Any] = [.font: fontSo, .foregroundColor: mauQuyDoi]
                let szQD = (chuQD as NSString).size(withAttributes: attrQD)
                let yNhanQD = max(2, yDay - caoQD - szQD.height - (abs(caoQD - caoThuc) < 10 && caoThuc > 0 ? 11 : 2))
                (chuQD as NSString).draw(
                    at: CGPoint(x: xQD + (rongCot - szQD.width) / 2, y: yNhanQD),
                    withAttributes: attrQD
                )
            }

            let chuNgay = String(format: "%02d/%02d", item.ngayTrongThang, TienIchNgay.lich.component(.month, from: item.ngay))
            let laChon = (item.ngayTrongThang == ngayDangChon)
            let attrNgay: [NSAttributedString.Key: Any] = [
                .font: fontNgay,
                .foregroundColor: laChon ? UIColor.systemBlue : UIColor.label
            ]
            let szNgay = (chuNgay as NSString).size(withAttributes: attrNgay)
            (chuNgay as NSString).draw(
                at: CGPoint(x: xTam - szNgay.width / 2, y: yDay + 8),
                withAttributes: attrNgay
            )
        }
    }
}

// MARK: - Đồ thị cột Theo dõi Tỷ lệ Đóng góp (%) & Sức bán Nhân viên theo Ngày

private final class VeBieuDoSucBanNhanVienView: UIView {
    var danhSachNgay: [DuLieuSucBanNgayNhanVien] = [] {
        didSet { setNeedsDisplay() }
    }
    var ngayDangChon: Int = 1 {
        didSet { setNeedsDisplay() }
    }
    var tyLeChuanBinhQuan: Double = 6.25 {
        didSet { setNeedsDisplay() }
    }
    var khiChonNgay: ((DuLieuSucBanNgayNhanVien) -> Void)?

    private let leTrai: CGFloat = 46
    private let lePhai: CGFloat = 14
    private let leTren: CGFloat = 30
    private let leDuoi: CGFloat = 36
    let chieuRongMoiNgay: CGFloat = 56

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(xuLyCham(_:)))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    @objc private func xuLyCham(_ g: UITapGestureRecognizer) {
        guard !danhSachNgay.isEmpty else { return }
        let diem = g.location(in: self)
        guard diem.x >= leTrai else { return }
        let idx = Int((diem.x - leTrai) / chieuRongMoiNgay)
        if idx >= 0 && idx < danhSachNgay.count {
            khiChonNgay?(danhSachNgay[idx])
        }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let caoVe = max(40, rect.height - leTren - leDuoi)
        let rongVe = max(60, rect.width - leTrai - lePhai)

        let maxPctRaw = danhSachNgay.reduce(tyLeChuanBinhQuan * 1.4) { acc, item in
            max(acc, item.tyLeDongGopNgay)
        }
        let maxPct = max(12.0, maxPctRaw * 1.2)

        let fontTruc = UIFont.monospacedDigitSystemFont(ofSize: 9.5, weight: .semibold)
        let mauChuPhu = UIColor.secondaryLabel
        let mauLuoi = UIColor.separator.withAlphaComponent(0.45)

        // 1. Vẽ 4 đường lưới ngang theo % đóng góp
        let soMucLuoi = 4
        for i in 0...soMucLuoi {
            let tyLe = CGFloat(i) / CGFloat(soMucLuoi)
            let y = leTren + caoVe * (1.0 - tyLe)
            let giaTri = maxPct * Double(tyLe)

            ctx.setStrokeColor(mauLuoi.cgColor)
            ctx.setLineWidth(i == 0 ? 1.0 : 0.6)
            if i > 0 {
                ctx.setLineDash(phase: 0, lengths: [3, 3])
            } else {
                ctx.setLineDash(phase: 0, lengths: [])
            }
            ctx.move(to: CGPoint(x: leTrai, y: y))
            ctx.addLine(to: CGPoint(x: leTrai + rongVe, y: y))
            ctx.strokePath()

            let chuY = String(format: "%.0f%%", giaTri)
            let attrY: [NSAttributedString.Key: Any] = [
                .font: fontTruc,
                .foregroundColor: mauChuPhu
            ]
            let sizeY = (chuY as NSString).size(withAttributes: attrY)
            (chuY as NSString).draw(
                at: CGPoint(x: max(2, leTrai - sizeY.width - 5), y: y - sizeY.height / 2),
                withAttributes: attrY
            )
        }

        // 2. Đường chuẩn bình quân (100% / số NV)
        if tyLeChuanBinhQuan > 0 && tyLeChuanBinhQuan <= maxPct {
            let yChuan = leTren + caoVe * (1.0 - CGFloat(tyLeChuanBinhQuan / maxPct))
            let mauChuan = UIColor(red: 0.90, green: 0.45, blue: 0.02, alpha: 0.85)
            ctx.setStrokeColor(mauChuan.cgColor)
            ctx.setLineWidth(1.2)
            ctx.setLineDash(phase: 0, lengths: [5, 3])
            ctx.move(to: CGPoint(x: leTrai, y: yChuan))
            ctx.addLine(to: CGPoint(x: leTrai + rongVe, y: yChuan))
            ctx.strokePath()

            let nhanChuan = "Chuẩn \(tyLeChuanBinhQuan.chuoiPhanTram)"
            let attrChuan: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8.5, weight: .bold),
                .foregroundColor: mauChuan,
                .backgroundColor: UIColor.systemBackground.withAlphaComponent(0.85)
            ]
            (nhanChuan as NSString).draw(at: CGPoint(x: leTrai + 4, y: max(2, yChuan - 12)), withAttributes: attrChuan)
        }
        ctx.setLineDash(phase: 0, lengths: [])

        let mauTot = UIColor(red: 0.08, green: 0.60, blue: 0.28, alpha: 1.0)
        let mauDat = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
        let mauYeu = UIColor(red: 0.86, green: 0.18, blue: 0.18, alpha: 1.0)
        let fontPct = UIFont.monospacedDigitSystemFont(ofSize: 8.5, weight: .heavy)
        let fontDT = UIFont.monospacedDigitSystemFont(ofSize: 8.0, weight: .semibold)
        let fontNgay = UIFont.systemFont(ofSize: 9.5, weight: .bold)

        let rongCot: CGFloat = 24

        for (i, item) in danhSachNgay.enumerated() {
            let xTam = leTrai + CGFloat(i) * chieuRongMoiNgay + chieuRongMoiNgay / 2
            let yDay = leTren + caoVe

            // Tô nền nếu ngày đang chọn hoặc ngày bị chuỗi yếu liên tục >= 2 ngày
            if item.laNgayYeu && item.chuoiYeuLienTucTaiNgay >= 2 {
                let khungYeu = CGRect(
                    x: xTam - chieuRongMoiNgay / 2 + 2,
                    y: leTren - 4,
                    width: chieuRongMoiNgay - 4,
                    height: caoVe + leDuoi
                )
                UIColor.systemRed.withAlphaComponent(0.09).setFill()
                UIBezierPath(roundedRect: khungYeu, cornerRadius: 7).fill()
            } else if item.ngayTrongThang == ngayDangChon {
                let khungChon = CGRect(
                    x: xTam - chieuRongMoiNgay / 2 + 2,
                    y: leTren - 4,
                    width: chieuRongMoiNgay - 4,
                    height: caoVe + leDuoi
                )
                UIColor.systemBlue.withAlphaComponent(0.08).setFill()
                UIBezierPath(roundedRect: khungChon, cornerRadius: 7).fill()
            }

            if item.coDuLieuNgayCuaDoi {
                let mauCot: UIColor = item.laNgayYeu
                    ? mauYeu
                    : (item.tyLeDongGopNgay >= item.tyLeChuanBinhQuan ? mauTot : mauDat)

                // Nếu ngày đội có số mà NV 0 doanh thu, vẽ vạch đỏ thấp (6pt) để dễ thấy ngày 0 số
                let caoCot: CGFloat
                if item.tyLeDongGopNgay > 0.01 {
                    caoCot = max(8, min(caoVe, CGFloat(item.tyLeDongGopNgay / maxPct) * caoVe))
                } else {
                    caoCot = 6
                }

                let xCot = xTam - rongCot / 2
                let rectCot = CGRect(x: xCot, y: yDay - caoCot, width: rongCot, height: caoCot)
                let pathCot = UIBezierPath(
                    roundedRect: rectCot,
                    byRoundingCorners: [.topLeft, .topRight],
                    cornerRadii: CGSize(width: 4, height: 4)
                )
                mauCot.setFill()
                pathCot.fill()

                // Nhãn % đóng góp phía trên cột
                let chuPct = item.tyLeDongGopNgay.chuoiPhanTram
                let attrPct: [NSAttributedString.Key: Any] = [.font: fontPct, .foregroundColor: mauCot]
                let szPct = (chuPct as NSString).size(withAttributes: attrPct)
                let yPct = max(2, yDay - caoCot - szPct.height - 2)
                (chuPct as NSString).draw(
                    at: CGPoint(x: xTam - szPct.width / 2, y: yPct),
                    withAttributes: attrPct
                )

                // Nhãn DT QĐ (hoặc cảnh báo chuỗi ngày yếu liên tục) ngay trên nhãn %
                let chuPhu: String
                if item.laNgayYeu && item.chuoiYeuLienTucTaiNgay >= 2 {
                    chuPhu = "⚠️\(item.chuoiYeuLienTucTaiNgay)N"
                } else if item.doanhThuQDNV > 0 {
                    chuPhu = item.doanhThuQDNV.chuoiSoGonVN
                } else {
                    chuPhu = "0"
                }
                let attrDT: [NSAttributedString.Key: Any] = [
                    .font: fontDT,
                    .foregroundColor: item.laNgayYeu ? mauYeu : UIColor.secondaryLabel
                ]
                let szDT = (chuPhu as NSString).size(withAttributes: attrDT)
                if yPct - szDT.height >= 1 {
                    (chuPhu as NSString).draw(
                        at: CGPoint(x: xTam - szDT.width / 2, y: yPct - szDT.height),
                        withAttributes: attrDT
                    )
                }
            }

            let chuNgay = String(format: "%02d/%02d", item.ngayTrongThang, TienIchNgay.lich.component(.month, from: item.ngay))
            let laChon = (item.ngayTrongThang == ngayDangChon)
            let attrNgay: [NSAttributedString.Key: Any] = [
                .font: fontNgay,
                .foregroundColor: item.laNgayYeu ? mauYeu : (laChon ? UIColor.systemBlue : UIColor.label)
            ]
            let szNgay = (chuNgay as NSString).size(withAttributes: attrNgay)
            (chuNgay as NSString).draw(
                at: CGPoint(x: xTam - szNgay.width / 2, y: yDay + 8),
                withAttributes: attrNgay
            )
        }
    }
}

final class BangTongHopRealtimeThangView: UIView, UITableViewDataSource, UITableViewDelegate {
    var khiBamSuaDoanhThuLuyKe: (() -> Void)?
    var khiChonNgayRealtime: ((DuLieuRealtimeNgayTrongThang) -> Void)?
    var khiBamQuetDoanhThuNVRealtime: (() -> Void)?

    private var ngayHienTai: Date = Date()
    private var doanhThuLuyKe = ThongTinDoanhThu()
    private var tatCaNgayTrongThang: [DuLieuRealtimeNgayTrongThang] = []
    private var danhSachBieuDo: [DuLieuRealtimeNgayTrongThang] = []
    private var chiHienNgayCoSo: Bool = false

    // Dữ liệu Theo dõi Sức bán Nhân viên theo Ngày (Từ Doanh thu Realtime Nhân viên)
    private var maNVDangChon: String?
    private var baoCaoSucBan: BaoCaoSucBanNhanVienThang?
    private var danhSachNgaySucBanHienThi: [DuLieuSucBanNgayNhanVien] = []

    private let cuonDoc = UIScrollView()
    private let nganNoiDung = UIStackView()

    // Khối 1: Doanh thu Lũy kế Thực & Quy đổi (Cố định của tháng)
    private let nhanTieuDeLuyKe = UILabel()
    private let theLuyKeThuc = TheDoanhThuView(
        tieuDe: "💵 DT LŨY KẾ THỰC (THÁNG)",
        mauBatDau: UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1),
        mauKetThuc: UIColor(red: 0.23, green: 0.25, blue: 0.89, alpha: 1)
    )
    private let theLuyKeQD = TheDoanhThuView(
        tieuDe: "🎯 DT LŨY KẾ QUY ĐỔI (THÁNG)",
        mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1),
        mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1),
        hienChamTron: true
    )

    // Khối 2: Đồ thị cột Doanh thu Thực & Quy đổi theo ngày của Siêu thị
    private let chonCheDoNgay = UISegmentedControl(items: ["Cả tháng", "Ngày có số"])
    private let nhanTomTatRT = UILabel()
    private let cuonBieuDo = UIScrollView()
    private let veBieuDo = VeBieuDoCotRealtimeView()
    private var rangBuocRongBieuDo: NSLayoutConstraint?

    // Khối 3 (MỚI): Theo dõi Sức bán Nhân viên theo Ngày & Cảnh báo nhân viên nhiều ngày yếu liên tục
    private let khungCanhBaoYeu = UIView()
    private let nhanTieuDeCanhBaoYeu = UILabel()
    private let nganDanhSachCanhBaoYeu = UIStackView()
    private let nutChonNhanVienSucBan = UIButton(type: .system)
    private let nhanTomTatSucBanNV = UILabel()
    private let theSucBanDTQD = TheDoanhThuView(
        tieuDe: "💵 DT QĐ NV (RT THÁNG)",
        mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1),
        mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
    )
    private let theSucBanTyLe = TheDoanhThuView(
        tieuDe: "📊 % ĐÓNG GÓP TB THÁNG",
        mauBatDau: UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1),
        mauKetThuc: UIColor(red: 0.23, green: 0.25, blue: 0.89, alpha: 1),
        hienChamTron: true
    )
    private let theSucBanSoNgay = TheDoanhThuView(
        tieuDe: "📅 NGÀY BÁN / NGÀY YẾU",
        mauBatDau: UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1),
        mauKetThuc: UIColor(red: 0.66, green: 0.33, blue: 0.97, alpha: 1)
    )
    private let theSucBanChuoiYeu = TheDoanhThuView(
        tieuDe: "🚨 CHUỖI YẾU LIÊN TỤC",
        mauBatDau: UIColor(red: 0.94, green: 0.27, blue: 0.27, alpha: 1),
        mauKetThuc: UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1)
    )
    private let cuonBieuDoNV = UIScrollView()
    private let veBieuDoNV = VeBieuDoSucBanNhanVienView()
    private var rangBuocRongBieuDoNV: NSLayoutConstraint?
    private let bangSucBanNV = UITableView(frame: .zero, style: .plain)
    private var rangBuocCaoBangSucBanNV: NSLayoutConstraint?

    // Khối 4: Bảng tổng hợp Realtime siêu thị theo ngày
    private let bangNgay = UITableView(frame: .zero, style: .plain)
    private var rangBuocCaoBang: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        backgroundColor = .clear

        cuonDoc.showsVerticalScrollIndicator = true
        cuonDoc.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cuonDoc)

        nganNoiDung.axis = .vertical
        nganNoiDung.spacing = 10
        nganNoiDung.translatesAutoresizingMaskIntoConstraints = false
        cuonDoc.addSubview(nganNoiDung)

        // --- KHỐI 1: DOANH THU LŨY KẾ THÁNG (THỰC & QUY ĐỔI) ---
        let khungLuyKe = UIView()
        khungLuyKe.backgroundColor = .secondarySystemGroupedBackground
        khungLuyKe.layer.cornerRadius = 12

        nhanTieuDeLuyKe.text = "📌 DOANH THU LŨY KẾ THÁNG (CỐ ĐỊNH — MỖI NGÀY NHẬP THAY THẾ NGÀY TRƯỚC)"
        nhanTieuDeLuyKe.font = .systemFont(ofSize: 11, weight: .bold)
        nhanTieuDeLuyKe.textColor = .secondaryLabel
        nhanTieuDeLuyKe.numberOfLines = 2

        let nutSuaLK = UIButton(type: .system)
        nutSuaLK.setTitle("✏️ Nhập / Quét Lũy kế", for: .normal)
        nutSuaLK.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutSuaLK.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        nutSuaLK.tintColor = .systemBlue
        nutSuaLK.layer.cornerRadius = 7
        nutSuaLK.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        nutSuaLK.addTarget(self, action: #selector(bamSuaLuyKe), for: .touchUpInside)
        nutSuaLK.setContentHuggingPriority(.required, for: .horizontal)

        let hangDauLK = UIStackView(arrangedSubviews: [nhanTieuDeLuyKe, nutSuaLK])
        hangDauLK.axis = .horizontal
        hangDauLK.spacing = 6
        hangDauLK.alignment = .center

        let hangTheLK = UIStackView(arrangedSubviews: [theLuyKeThuc, theLuyKeQD])
        hangTheLK.axis = .horizontal
        hangTheLK.spacing = 8
        hangTheLK.distribution = .fillEqually
        hangTheLK.heightAnchor.constraint(equalToConstant: 64).isActive = true

        let tapLK = UITapGestureRecognizer(target: self, action: #selector(bamSuaLuyKe))
        hangTheLK.addGestureRecognizer(tapLK)

        let nganLK = UIStackView(arrangedSubviews: [hangDauLK, hangTheLK])
        nganLK.axis = .vertical
        nganLK.spacing = 8
        nganLK.translatesAutoresizingMaskIntoConstraints = false
        khungLuyKe.addSubview(nganLK)

        NSLayoutConstraint.activate([
            nganLK.topAnchor.constraint(equalTo: khungLuyKe.topAnchor, constant: 10),
            nganLK.leadingAnchor.constraint(equalTo: khungLuyKe.leadingAnchor, constant: 10),
            nganLK.trailingAnchor.constraint(equalTo: khungLuyKe.trailingAnchor, constant: -10),
            nganLK.bottomAnchor.constraint(equalTo: khungLuyKe.bottomAnchor, constant: -10)
        ])

        // --- KHỐI 2: ĐỒ THỊ CỘT DOANH THU THỰC & QUY ĐỔI THEO NGÀY (SIÊU THỊ) ---
        let khungBieuDo = UIView()
        khungBieuDo.backgroundColor = .secondarySystemGroupedBackground
        khungBieuDo.layer.cornerRadius = 12

        let lbTieuDeBD = UILabel()
        lbTieuDeBD.text = "📊 ĐỒ THỊ CỘT DOANH THU THỰC & QUY ĐỔI THEO NGÀY"
        lbTieuDeBD.font = .systemFont(ofSize: 12, weight: .bold)
        lbTieuDeBD.textColor = .label
        lbTieuDeBD.numberOfLines = 2

        chonCheDoNgay.selectedSegmentIndex = 0
        chonCheDoNgay.addTarget(self, action: #selector(doiCheDoLocNgay), for: .valueChanged)
        chonCheDoNgay.setContentHuggingPriority(.required, for: .horizontal)

        let hangTieuDeBD = UIStackView(arrangedSubviews: [lbTieuDeBD, chonCheDoNgay])
        hangTieuDeBD.axis = .horizontal
        hangTieuDeBD.spacing = 8
        hangTieuDeBD.alignment = .center

        nhanTomTatRT.font = .systemFont(ofSize: 11.5, weight: .semibold)
        nhanTomTatRT.textColor = .secondaryLabel
        nhanTomTatRT.numberOfLines = 2

        cuonBieuDo.showsHorizontalScrollIndicator = true
        cuonBieuDo.bounces = true
        cuonBieuDo.heightAnchor.constraint(equalToConstant: 210).isActive = true

        veBieuDo.translatesAutoresizingMaskIntoConstraints = false
        veBieuDo.khiChonNgay = { [weak self] item in
            self?.khiChonNgayRealtime?(item)
        }
        cuonBieuDo.addSubview(veBieuDo)

        let rBieuDo = veBieuDo.widthAnchor.constraint(equalToConstant: 800)
        rBieuDo.isActive = true
        rangBuocRongBieuDo = rBieuDo

        NSLayoutConstraint.activate([
            veBieuDo.topAnchor.constraint(equalTo: cuonBieuDo.contentLayoutGuide.topAnchor),
            veBieuDo.leadingAnchor.constraint(equalTo: cuonBieuDo.contentLayoutGuide.leadingAnchor),
            veBieuDo.trailingAnchor.constraint(equalTo: cuonBieuDo.contentLayoutGuide.trailingAnchor),
            veBieuDo.bottomAnchor.constraint(equalTo: cuonBieuDo.contentLayoutGuide.bottomAnchor),
            veBieuDo.heightAnchor.constraint(equalTo: cuonBieuDo.frameLayoutGuide.heightAnchor)
        ])

        let nganBD = UIStackView(arrangedSubviews: [hangTieuDeBD, nhanTomTatRT, cuonBieuDo])
        nganBD.axis = .vertical
        nganBD.spacing = 6
        nganBD.translatesAutoresizingMaskIntoConstraints = false
        khungBieuDo.addSubview(nganBD)

        NSLayoutConstraint.activate([
            nganBD.topAnchor.constraint(equalTo: khungBieuDo.topAnchor, constant: 10),
            nganBD.leadingAnchor.constraint(equalTo: khungBieuDo.leadingAnchor, constant: 10),
            nganBD.trailingAnchor.constraint(equalTo: khungBieuDo.trailingAnchor, constant: -10),
            nganBD.bottomAnchor.constraint(equalTo: khungBieuDo.bottomAnchor, constant: -10)
        ])

        // --- KHỐI 3 (MỚI): THEO DÕI SỨC BÁN NHÂN VIÊN THEO NGÀY (TỪ DOANH THU REALTIME NHÂN VIÊN) & CẢNH BÁO YẾU LIÊN TỤC ---
        let khungSucBanNV = taoGiaoDienKhungSucBanNhanVien()

        // --- KHỐI 4: BẢNG TỔNG HỢP REALTIME SIÊU THỊ THEO NGÀY TRONG THÁNG ---
        let khungBang = UIView()
        khungBang.backgroundColor = .secondarySystemGroupedBackground
        khungBang.layer.cornerRadius = 12
        khungBang.clipsToBounds = true

        let lbTieuDeBang = UILabel()
        lbTieuDeBang.text = "📋 BẢNG CHI TIẾT REALTIME SIÊU THỊ THEO NGÀY (CHẠM VÀO NGÀY ĐỂ SỬA / QUÉT ẢNH)"
        lbTieuDeBang.font = .systemFont(ofSize: 11.5, weight: .bold)
        lbTieuDeBang.textColor = .secondaryLabel
        lbTieuDeBang.translatesAutoresizingMaskIntoConstraints = false
        khungBang.addSubview(lbTieuDeBang)

        bangNgay.dataSource = self
        bangNgay.delegate = self
        bangNgay.isScrollEnabled = false
        bangNgay.rowHeight = 42
        bangNgay.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        bangNgay.translatesAutoresizingMaskIntoConstraints = false
        khungBang.addSubview(bangNgay)

        let cBang = bangNgay.heightAnchor.constraint(equalToConstant: 360)
        cBang.isActive = true
        rangBuocCaoBang = cBang

        NSLayoutConstraint.activate([
            lbTieuDeBang.topAnchor.constraint(equalTo: khungBang.topAnchor, constant: 10),
            lbTieuDeBang.leadingAnchor.constraint(equalTo: khungBang.leadingAnchor, constant: 12),
            lbTieuDeBang.trailingAnchor.constraint(equalTo: khungBang.trailingAnchor, constant: -12),

            bangNgay.topAnchor.constraint(equalTo: lbTieuDeBang.bottomAnchor, constant: 6),
            bangNgay.leadingAnchor.constraint(equalTo: khungBang.leadingAnchor),
            bangNgay.trailingAnchor.constraint(equalTo: khungBang.trailingAnchor),
            bangNgay.bottomAnchor.constraint(equalTo: khungBang.bottomAnchor)
        ])

        [khungLuyKe, khungBieuDo, khungSucBanNV, khungBang].forEach {
            nganNoiDung.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            cuonDoc.topAnchor.constraint(equalTo: topAnchor),
            cuonDoc.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuonDoc.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuonDoc.bottomAnchor.constraint(equalTo: bottomAnchor),

            nganNoiDung.topAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.topAnchor),
            nganNoiDung.leadingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.leadingAnchor),
            nganNoiDung.trailingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.trailingAnchor),
            nganNoiDung.bottomAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.bottomAnchor, constant: -12),
            nganNoiDung.widthAnchor.constraint(equalTo: cuonDoc.frameLayoutGuide.widthAnchor)
        ])
    }

    private func taoGiaoDienKhungSucBanNhanVien() -> UIView {
        let khung = UIView()
        khung.backgroundColor = .secondarySystemGroupedBackground
        khung.layer.cornerRadius = 12
        khung.clipsToBounds = true

        // 1. Hàng tiêu đề + nút Quét DT NV Realtime cho ngày đang chọn
        let lbTieuDe = UILabel()
        lbTieuDe.text = "👤 THEO DÕI SỨC BÁN NHÂN VIÊN THEO NGÀY (DOANH THU REALTIME NV)"
        lbTieuDe.font = .systemFont(ofSize: 12, weight: .bold)
        lbTieuDe.textColor = .label
        lbTieuDe.numberOfLines = 2

        let nutQuetDTNV = UIButton(type: .system)
        nutQuetDTNV.setTitle("📷 Quét DT NV ngày", for: .normal)
        nutQuetDTNV.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutQuetDTNV.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        nutQuetDTNV.tintColor = .systemBlue
        nutQuetDTNV.layer.cornerRadius = 7
        nutQuetDTNV.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        nutQuetDTNV.addTarget(self, action: #selector(bamQuetDoanhThuNVNgay), for: .touchUpInside)
        nutQuetDTNV.setContentHuggingPriority(.required, for: .horizontal)

        let hangTieuDe = UIStackView(arrangedSubviews: [lbTieuDe, nutQuetDTNV])
        hangTieuDe.axis = .horizontal
        hangTieuDe.spacing = 6
        hangTieuDe.alignment = .center

        // 2. Hộp Cảnh báo nhân viên nhiều ngày yếu liên tục cho quản lý nắm
        khungCanhBaoYeu.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
        khungCanhBaoYeu.layer.cornerRadius = 10
        khungCanhBaoYeu.layer.borderWidth = 1
        khungCanhBaoYeu.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.25).cgColor

        nhanTieuDeCanhBaoYeu.text = "🚨 CẢNH BÁO NHÂN VIÊN NHIỀU NGÀY YẾU LIÊN TỤC"
        nhanTieuDeCanhBaoYeu.font = .systemFont(ofSize: 11.5, weight: .heavy)
        nhanTieuDeCanhBaoYeu.textColor = UIColor(red: 0.78, green: 0.12, blue: 0.12, alpha: 1)
        nhanTieuDeCanhBaoYeu.numberOfLines = 2

        nganDanhSachCanhBaoYeu.axis = .vertical
        nganDanhSachCanhBaoYeu.spacing = 5

        let nganCanhBao = UIStackView(arrangedSubviews: [nhanTieuDeCanhBaoYeu, nganDanhSachCanhBaoYeu])
        nganCanhBao.axis = .vertical
        nganCanhBao.spacing = 6
        nganCanhBao.translatesAutoresizingMaskIntoConstraints = false
        khungCanhBaoYeu.addSubview(nganCanhBao)

        NSLayoutConstraint.activate([
            nganCanhBao.topAnchor.constraint(equalTo: khungCanhBaoYeu.topAnchor, constant: 8),
            nganCanhBao.leadingAnchor.constraint(equalTo: khungCanhBaoYeu.leadingAnchor, constant: 10),
            nganCanhBao.trailingAnchor.constraint(equalTo: khungCanhBaoYeu.trailingAnchor, constant: -10),
            nganCanhBao.bottomAnchor.constraint(equalTo: khungCanhBaoYeu.bottomAnchor, constant: -8)
        ])

        // 3. Hàng chọn Nhân viên từ danh sách đổ ra (chỉ hiển thị Mã số nhân viên - Tên)
        let lbChonNV = UILabel()
        lbChonNV.text = "Nhân viên:"
        lbChonNV.font = .systemFont(ofSize: 12, weight: .bold)
        lbChonNV.textColor = .secondaryLabel
        lbChonNV.setContentHuggingPriority(.required, for: .horizontal)

        nutChonNhanVienSucBan.setTitle("24939 - Phan Hoàng Sơn ▾", for: .normal)
        nutChonNhanVienSucBan.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutChonNhanVienSucBan.contentHorizontalAlignment = .left
        nutChonNhanVienSucBan.backgroundColor = .systemBackground
        nutChonNhanVienSucBan.tintColor = .systemBlue
        nutChonNhanVienSucBan.layer.cornerRadius = 9
        nutChonNhanVienSucBan.layer.borderWidth = 1
        nutChonNhanVienSucBan.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.35).cgColor
        nutChonNhanVienSucBan.contentEdgeInsets = UIEdgeInsets(top: 9, left: 12, bottom: 9, right: 12)
        nutChonNhanVienSucBan.showsMenuAsPrimaryAction = true

        let hangChonNV = UIStackView(arrangedSubviews: [lbChonNV, nutChonNhanVienSucBan])
        hangChonNV.axis = .horizontal
        hangChonNV.spacing = 8
        hangChonNV.alignment = .center

        // 4. 4 Thẻ KPI tóm tắt sức bán tháng của nhân viên đang chọn
        [theSucBanDTQD, theSucBanTyLe, theSucBanSoNgay, theSucBanChuoiYeu].forEach {
            $0.isUserInteractionEnabled = false
        }
        let hangTheSucBan = UIStackView(arrangedSubviews: [theSucBanDTQD, theSucBanTyLe, theSucBanSoNgay, theSucBanChuoiYeu])
        hangTheSucBan.axis = .horizontal
        hangTheSucBan.spacing = 5
        hangTheSucBan.distribution = .fillEqually
        hangTheSucBan.heightAnchor.constraint(equalToConstant: 60).isActive = true

        // 5. Chú thích & Biểu đồ cột tỷ lệ đóng góp theo ngày của nhân viên
        nhanTomTatSucBanNV.font = .systemFont(ofSize: 11, weight: .semibold)
        nhanTomTatSucBanNV.textColor = .secondaryLabel
        nhanTomTatSucBanNV.numberOfLines = 2

        cuonBieuDoNV.showsHorizontalScrollIndicator = true
        cuonBieuDoNV.bounces = true
        cuonBieuDoNV.heightAnchor.constraint(equalToConstant: 195).isActive = true

        veBieuDoNV.translatesAutoresizingMaskIntoConstraints = false
        veBieuDoNV.khiChonNgay = { [weak self] item in
            guard let self = self else { return }
            if let ngayRT = self.tatCaNgayTrongThang.first(where: { $0.khoaNgay == item.khoaNgay }) {
                self.khiChonNgayRealtime?(ngayRT)
            }
        }
        cuonBieuDoNV.addSubview(veBieuDoNV)

        let rBieuDoNV = veBieuDoNV.widthAnchor.constraint(equalToConstant: 800)
        rBieuDoNV.isActive = true
        rangBuocRongBieuDoNV = rBieuDoNV

        NSLayoutConstraint.activate([
            veBieuDoNV.topAnchor.constraint(equalTo: cuonBieuDoNV.contentLayoutGuide.topAnchor),
            veBieuDoNV.leadingAnchor.constraint(equalTo: cuonBieuDoNV.contentLayoutGuide.leadingAnchor),
            veBieuDoNV.trailingAnchor.constraint(equalTo: cuonBieuDoNV.contentLayoutGuide.trailingAnchor),
            veBieuDoNV.bottomAnchor.constraint(equalTo: cuonBieuDoNV.contentLayoutGuide.bottomAnchor),
            veBieuDoNV.heightAnchor.constraint(equalTo: cuonBieuDoNV.frameLayoutGuide.heightAnchor)
        ])

        // 6. Bảng chi tiết tỷ lệ đóng góp từng ngày của nhân viên đang chọn
        bangSucBanNV.dataSource = self
        bangSucBanNV.delegate = self
        bangSucBanNV.isScrollEnabled = false
        bangSucBanNV.rowHeight = 38
        bangSucBanNV.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        bangSucBanNV.layer.cornerRadius = 8
        bangSucBanNV.clipsToBounds = true

        let cBangNV = bangSucBanNV.heightAnchor.constraint(equalToConstant: 260)
        cBangNV.isActive = true
        rangBuocCaoBangSucBanNV = cBangNV

        let nganSucBan = UIStackView(arrangedSubviews: [
            hangTieuDe,
            khungCanhBaoYeu,
            hangChonNV,
            hangTheSucBan,
            nhanTomTatSucBanNV,
            cuonBieuDoNV,
            bangSucBanNV
        ])
        nganSucBan.axis = .vertical
        nganSucBan.spacing = 8
        nganSucBan.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(nganSucBan)

        NSLayoutConstraint.activate([
            nganSucBan.topAnchor.constraint(equalTo: khung.topAnchor, constant: 10),
            nganSucBan.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 10),
            nganSucBan.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -10),
            nganSucBan.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -10)
        ])

        return khung
    }

    @objc private func bamSuaLuyKe() {
        khiBamSuaDoanhThuLuyKe?()
    }

    @objc private func bamQuetDoanhThuNVNgay() {
        khiBamQuetDoanhThuNVRealtime?()
    }

    @objc private func doiCheDoLocNgay() {
        chiHienNgayCoSo = (chonCheDoNgay.selectedSegmentIndex == 1)
        capNhatDuLieuHienThi()
    }

    @objc private func bamChonNhanVienTuCanhBao(_ sender: UIButton) {
        guard let bc = baoCaoSucBan, sender.tag >= 0 && sender.tag < bc.danhSachCanhBaoYeuLienTuc.count else { return }
        let nv = bc.danhSachCanhBaoYeuLienTuc[sender.tag].nhanVien
        maNVDangChon = nv.maNV
        capNhat(cho: ngayHienTai)
    }

    func capNhat(cho ngay: Date) {
        self.ngayHienTai = ngay
        self.doanhThuLuyKe = KhoDuLieu.dungChung.doanhThuLuyKeThang(cho: ngay)
        self.tatCaNgayTrongThang = KhoDuLieu.dungChung.danhSachRealtimeTheoNgayTrongThang(cho: ngay)
        let bc = KhoDuLieu.dungChung.baoCaoSucBanNhanVienTheoNgayTrongThang(cho: ngay, maNVChon: maNVDangChon)
        self.baoCaoSucBan = bc
        self.maNVDangChon = bc.nhanVienDangChon.maNV
        capNhatDuLieuHienThi()
    }

    private func cauHinhMenuChonNhanVien(_ bc: BaoCaoSucBanNhanVienThang) {
        let nvChon = bc.nhanVienDangChon
        nutChonNhanVienSucBan.setTitle("\(nvChon.maNV) - \(nvChon.hoTen)  ▾", for: .normal)

        // Danh sách đổ ra chỉ hiển thị gọn "Mã số nhân viên - Họ và tên" đúng theo yêu cầu
        let cacHanhDong = bc.danhSachNhanVien.map { nv in
            UIAction(
                title: "\(nv.maNV) - \(nv.hoTen)",
                state: (nv.maNV == nvChon.maNV) ? .on : .off
            ) { [weak self] _ in
                guard let self = self else { return }
                self.maNVDangChon = nv.maNV
                self.capNhat(cho: self.ngayHienTai)
            }
        }
        nutChonNhanVienSucBan.menu = UIMenu(title: "Chọn nhân viên", children: cacHanhDong)
    }

    private func capNhatKhungCanhBaoYeuLienTuc(_ bc: BaoCaoSucBanNhanVienThang) {
        nganDanhSachCanhBaoYeu.arrangedSubviews.forEach {
            nganDanhSachCanhBaoYeu.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        if bc.soNgayCoDuLieuNV == 0 {
            khungCanhBaoYeu.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.07)
            khungCanhBaoYeu.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.22).cgColor
            nhanTieuDeCanhBaoYeu.text = "ℹ️ CHƯA CÓ DỮ LIỆU DOANH THU REALTIME NHÂN VIÊN TRONG THÁNG"
            nhanTieuDeCanhBaoYeu.textColor = .systemBlue

            let lb = UILabel()
            lb.text = "Hãy bấm \"📷 Quét DT NV ngày\" ở góc phải (hoặc chọn Nhập/Mẫu → Nạp dữ liệu mẫu) để theo dõi tỷ lệ đóng góp theo ngày và nhận cảnh báo nhân viên yếu liên tục."
            lb.font = .systemFont(ofSize: 11.5, weight: .medium)
            lb.textColor = .secondaryLabel
            lb.numberOfLines = 0
            nganDanhSachCanhBaoYeu.addArrangedSubview(lb)
            return
        }

        let dsCanhBao = bc.danhSachCanhBaoYeuLienTuc
        if dsCanhBao.isEmpty {
            khungCanhBaoYeu.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.08)
            khungCanhBaoYeu.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.28).cgColor
            nhanTieuDeCanhBaoYeu.text = "✅ SỨC BÁN ĐỘI NGŨ ỔN ĐỊNH (\(bc.soNgayCoDuLieuNV) NGÀY CÓ SỐ)"
            nhanTieuDeCanhBaoYeu.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)

            let lb = UILabel()
            lb.text = "Không có nhân viên nào bị yếu liên tục từ 2 ngày trở lên trong các ngày đã có dữ liệu Realtime."
            lb.font = .systemFont(ofSize: 11.5, weight: .medium)
            lb.textColor = .secondaryLabel
            lb.numberOfLines = 0
            nganDanhSachCanhBaoYeu.addArrangedSubview(lb)
            return
        }

        khungCanhBaoYeu.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
        khungCanhBaoYeu.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.28).cgColor
        nhanTieuDeCanhBaoYeu.text = "🚨 CẢNH BÁO \(dsCanhBao.count) NHÂN VIÊN NHIỀU NGÀY YẾU LIÊN TỤC (CHẠM ĐỂ XEM CHI TIẾT)"
        nhanTieuDeCanhBaoYeu.textColor = UIColor(red: 0.78, green: 0.12, blue: 0.12, alpha: 1)

        for (idx, cb) in dsCanhBao.enumerated() {
            let nut = UIButton(type: .system)
            nut.tag = idx
            let icon = cb.mucDoCanhBao >= 2 ? "🚨" : "⚠️"
            let dangChon = (cb.nhanVien.maNV == bc.nhanVienDangChon.maNV)
            let chuoi = "\(icon) \(cb.nhanVien.maNV) - \(cb.nhanVien.hoTen): \(cb.moTaChiTietCanhBao)"
            nut.setTitle(chuoi, for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 11.5, weight: dangChon ? .heavy : .semibold)
            nut.titleLabel?.numberOfLines = 2
            nut.contentHorizontalAlignment = .left
            nut.tintColor = cb.mucDoCanhBao >= 2
                ? UIColor(red: 0.78, green: 0.11, blue: 0.11, alpha: 1)
                : UIColor(red: 0.75, green: 0.35, blue: 0.04, alpha: 1)
            nut.backgroundColor = dangChon
                ? UIColor.systemRed.withAlphaComponent(0.16)
                : UIColor.systemBackground.withAlphaComponent(0.85)
            nut.layer.cornerRadius = 7
            nut.layer.borderWidth = dangChon ? 1.2 : 0.6
            nut.layer.borderColor = (dangChon ? UIColor.systemRed : UIColor.systemRed.withAlphaComponent(0.25)).cgColor
            nut.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            nut.addTarget(self, action: #selector(bamChonNhanVienTuCanhBao(_:)), for: .touchUpInside)
            nganDanhSachCanhBaoYeu.addArrangedSubview(nut)
        }
    }

    private func capNhatDuLieuHienThi() {
        let thang = TienIchNgay.lich.component(.month, from: ngayHienTai)
        let nam = TienIchNgay.lich.component(.year, from: ngayHienTai)
        let ngayChon = TienIchNgay.lich.component(.day, from: ngayHienTai)
        nhanTieuDeLuyKe.text = "📌 DOANH THU LŨY KẾ THÁNG \(String(format: "%02d/%04d", thang, nam)) (CỐ ĐỊNH — NHẬP MỚI THAY THẾ NGÀY TRƯỚC)"

        if doanhThuLuyKe.coDuLieu {
            theLuyKeThuc.capNhatNoiDung(
                chinh: doanhThuLuyKe.doanhThuThuc.chuoiSoVN,
                phu: "TARGET: \(doanhThuLuyKe.targetThuc.chuoiSoVN) | HT: \(doanhThuLuyKe.phanTramHTThucHienThi.chuoiPhanTram)"
            )
            theLuyKeQD.capNhatNoiDung(
                chinh: doanhThuLuyKe.doanhThuQuyDoi.chuoiSoVN,
                phu: "TARGET: \(doanhThuLuyKe.targetQuyDoi.chuoiSoVN) | % QĐ: \(doanhThuLuyKe.phanTramQuyDoi.chuoiPhanTram)"
            )
        } else {
            theLuyKeThuc.capNhatNoiDung(chinh: "Chạm nhập", phu: "TARGET: --")
            theLuyKeQD.capNhatNoiDung(chinh: "Chạm nhập", phu: "TARGET: --")
        }

        let dsCoSo = tatCaNgayTrongThang.filter { $0.coDuLieu }
        if chiHienNgayCoSo && !dsCoSo.isEmpty {
            danhSachBieuDo = dsCoSo
        } else {
            danhSachBieuDo = tatCaNgayTrongThang
        }

        let tongRTThuc = dsCoSo.reduce(0.0) { $0 + $1.doanhThuThuc }
        let tongRTQD = dsCoSo.reduce(0.0) { $0 + $1.doanhThuQuyDoi }
        nhanTomTatRT.text = "🟦 Cột xanh dương: DT Thực (Tổng \(dsCoSo.count) ngày: \(tongRTThuc.chuoiSoVN))   •   🟩 Cột xanh lá: DT Quy đổi (Tổng: \(tongRTQD.chuoiSoVN))"

        veBieuDo.ngayDangChon = ngayChon
        veBieuDo.danhSachNgay = danhSachBieuDo
        let rongCan = max(bounds.width - 20, 62 + CGFloat(max(1, danhSachBieuDo.count)) * veBieuDo.chieuRongMoiNgay)
        rangBuocRongBieuDo?.constant = rongCan

        let soDong = danhSachBieuDo.count
        rangBuocCaoBang?.constant = 36 + CGFloat(soDong) * 42
        bangNgay.reloadData()

        // Cập nhật khối Theo dõi sức bán nhân viên theo ngày
        if let bc = baoCaoSucBan {
            cauHinhMenuChonNhanVien(bc)
            capNhatKhungCanhBaoYeuLienTuc(bc)

            let tk = bc.tongKetNhanVienDangChon
            theSucBanDTQD.capNhatNoiDung(
                chinh: tk.tongDoanhThuQDThang.chuoiSoVN,
                phu: "THỰC: \(tk.tongDoanhThuThucThang.chuoiSoVN) | ĐƠN: \(tk.tongSoDonThang.chuoiSoNguyenVN)"
            )
            theSucBanTyLe.capNhatNoiDung(
                chinh: tk.tyLeDongGopTBThang.chuoiPhanTramVN,
                phu: "CHUẨN ĐỘI: \(tk.tyLeChuanBinhQuan.chuoiPhanTram)"
            )
            theSucBanSoNgay.capNhatNoiDung(
                chinh: "\(tk.soNgayCoBan)/\(max(1, tk.soNgayCoSoDoi)) ngày",
                phu: "NGÀY YẾU: \(tk.soNgayYeu) NGÀY"
            )
            theSucBanChuoiYeu.capNhatNoiDung(
                chinh: tk.soNgayChuoiCanhBao >= 2 ? "\(tk.soNgayChuoiCanhBao) ngày LT" : "Ổn định",
                phu: tk.khoangNgayYeuLienTuc.isEmpty ? "HIỆN TẠI: \(tk.soNgayYeuLienTucHienTai) NGÀY" : tk.khoangNgayYeuLienTuc
            )

            let dsNgayNVCoSo = bc.chiTietTheoNgay.filter { $0.coDuLieuNgayCuaDoi }
            if chiHienNgayCoSo && !dsNgayNVCoSo.isEmpty {
                danhSachNgaySucBanHienThi = dsNgayNVCoSo
            } else {
                danhSachNgaySucBanHienThi = bc.chiTietTheoNgay
            }

            nhanTomTatSucBanNV.text = "👤 \(bc.nhanVienDangChon.maNV) - \(bc.nhanVienDangChon.hoTen)  •  🟩 Tốt (≥ \(tk.tyLeChuanBinhQuan.chuoiPhanTram))  🟦 Đạt  🟥 Ngày yếu (< \(max(2.5, tk.tyLeChuanBinhQuan * 0.65).chuoiPhanTram) hoặc 0 số)"

            veBieuDoNV.ngayDangChon = ngayChon
            veBieuDoNV.tyLeChuanBinhQuan = tk.tyLeChuanBinhQuan
            veBieuDoNV.danhSachNgay = danhSachNgaySucBanHienThi
            let rongCanNV = max(bounds.width - 20, 62 + CGFloat(max(1, danhSachNgaySucBanHienThi.count)) * veBieuDoNV.chieuRongMoiNgay)
            rangBuocRongBieuDoNV?.constant = rongCanNV

            let soDongNV = danhSachNgaySucBanHienThi.count + 2 // +2 dòng Tổng cộng & Trung bình cuối bảng
            rangBuocCaoBangSucBanNV?.constant = 34 + CGFloat(soDongNV) * 38
            bangSucBanNV.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === bangSucBanNV {
            return danhSachNgaySucBanHienThi.count + 2
        }
        return danhSachBieuDo.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView === bangSucBanNV {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 34))
            header.backgroundColor = .systemGray5
            let tieuDe = ["NGÀY", "DT THỰC NV", "DT QĐ NV", "TỔNG ĐỘI", "% ĐÓNG GÓP", "ĐÁNH GIÁ"]
            let tyLe: [CGFloat] = [0.13, 0.17, 0.18, 0.17, 0.17, 0.18]
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: header.topAnchor),
                stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 6),
                stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -6),
                stack.bottomAnchor.constraint(equalTo: header.bottomAnchor)
            ])
            for (i, chu) in tieuDe.enumerated() {
                let lb = UILabel()
                lb.text = chu
                lb.font = .systemFont(ofSize: 9.5, weight: .bold)
                lb.textColor = .label
                lb.textAlignment = (i == 0) ? .left : (i >= 4 ? .center : .right)
                stack.addArrangedSubview(lb)
                lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
            }
            return header
        }

        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 34))
        header.backgroundColor = .systemGray5
        let tieuDe = ["NGÀY", "DT THỰC (RT)", "DT QUY ĐỔI (RT)", "% QUY ĐỔI", "KHÁCH / BILL"]
        let tyLe: [CGFloat] = [0.16, 0.23, 0.23, 0.16, 0.22]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: header.topAnchor),
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        for (i, chu) in tieuDe.enumerated() {
            let lb = UILabel()
            lb.text = chu
            lb.font = .systemFont(ofSize: 10, weight: .bold)
            lb.textColor = .label
            lb.textAlignment = (i == 0) ? .left : .right
            stack.addArrangedSubview(lb)
            lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === bangSucBanNV {
            return taoCellBangSucBanNV(tableView: tableView, indexPath: indexPath)
        }

        let ma = "DongRTThangCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let item = danhSachBieuDo[indexPath.row]
        let ngayChon = TienIchNgay.lich.component(.day, from: ngayHienTai)
        let laChon = (item.ngayTrongThang == ngayChon)
        cell.backgroundColor = laChon
            ? UIColor.systemBlue.withAlphaComponent(0.08)
            : (item.coDuLieu ? .systemBackground : UIColor.secondarySystemGroupedBackground.withAlphaComponent(0.5))

        let thang = TienIchNgay.lich.component(.month, from: item.ngay)
        let giaTri: [String] = [
            String(format: "%02d/%02d", item.ngayTrongThang, thang),
            item.coDuLieu ? item.doanhThuThuc.chuoiSoVN : "--",
            item.coDuLieu ? item.doanhThuQuyDoi.chuoiSoVN : "--",
            item.coDuLieu ? item.phanTramQuyDoi.chuoiPhanTram : "--",
            item.luotKhach > 0 || item.soBill > 0 ? "\(item.luotKhach.chuoiSoNguyenVN)/\(item.soBill.chuoiSoNguyenVN)" : "--"
        ]
        let tyLe: [CGFloat] = [0.16, 0.23, 0.23, 0.16, 0.22]

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])

        for (i, chu) in giaTri.enumerated() {
            let lb = UILabel()
            lb.text = chu
            lb.textAlignment = (i == 0) ? .left : .right
            if i == 0 {
                lb.font = .systemFont(ofSize: 12.5, weight: laChon ? .heavy : .bold)
                lb.textColor = laChon ? .systemBlue : .label
            } else if i == 1 {
                lb.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                lb.textColor = item.coDuLieu ? UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1) : .secondaryLabel
            } else if i == 2 {
                lb.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                lb.textColor = item.coDuLieu ? UIColor(red: 0.08, green: 0.60, blue: 0.28, alpha: 1) : .secondaryLabel
            } else {
                lb.font = .monospacedDigitSystemFont(ofSize: 11.5, weight: .medium)
                lb.textColor = .secondaryLabel
            }
            stack.addArrangedSubview(lb)
            lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
        }
        return cell
    }

    private func taoCellBangSucBanNV(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongSucBanNVCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let tyLe: [CGFloat] = [0.13, 0.17, 0.18, 0.17, 0.17, 0.18]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 6),
            stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -6),
            stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])

        // 2 dòng tổng kết cuối bảng (TỔNG CỘNG & TRUNG BÌNH / NGÀY)
        if indexPath.row >= danhSachNgaySucBanHienThi.count {
            let laDongTong = (indexPath.row == danhSachNgaySucBanHienThi.count)
            cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(laDongTong ? 0.10 : 0.05)
            let tk = baoCaoSucBan?.tongKetNhanVienDangChon
            let soNgayCoSo = max(1, tk?.soNgayCoSoDoi ?? 1)
            let tongQDToanDoi = baoCaoSucBan?.tongDTQDToanDoiThang ?? 0

            let giaTri: [String]
            if laDongTong {
                giaTri = [
                    "TỔNG",
                    (tk?.tongDoanhThuThucThang ?? 0).chuoiSoVN,
                    (tk?.tongDoanhThuQDThang ?? 0).chuoiSoVN,
                    tongQDToanDoi.chuoiSoVN,
                    (tk?.tyLeDongGopTBThang ?? 0).chuoiPhanTram,
                    tk?.nhanTrangThaiNgan ?? "--"
                ]
            } else {
                giaTri = [
                    "TB/NGÀY",
                    ((tk?.tongDoanhThuThucThang ?? 0) / Double(soNgayCoSo)).chuoiSoVN,
                    ((tk?.tongDoanhThuQDThang ?? 0) / Double(soNgayCoSo)).chuoiSoVN,
                    (tongQDToanDoi / Double(soNgayCoSo)).chuoiSoVN,
                    "Chuẩn \((tk?.tyLeChuanBinhQuan ?? 0).chuoiPhanTram)",
                    "Yếu \(tk?.soNgayYeu ?? 0) ngày"
                ]
            }

            for (i, chu) in giaTri.enumerated() {
                let lb = UILabel()
                lb.text = chu
                lb.font = .monospacedDigitSystemFont(ofSize: 10.5, weight: .bold)
                lb.textColor = (i == 5 && (tk?.biCanhBaoNhieuNgayYeu == true)) ? .systemRed : .label
                lb.textAlignment = (i == 0) ? .left : (i >= 4 ? .center : .right)
                lb.adjustsFontSizeToFitWidth = true
                lb.minimumScaleFactor = 0.7
                stack.addArrangedSubview(lb)
                lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
            }
            return cell
        }

        let item = danhSachNgaySucBanHienThi[indexPath.row]
        let ngayChon = TienIchNgay.lich.component(.day, from: ngayHienTai)
        let laChon = (item.ngayTrongThang == ngayChon)

        if item.laNgayYeu && item.chuoiYeuLienTucTaiNgay >= 2 {
            cell.backgroundColor = UIColor.systemRed.withAlphaComponent(0.10)
        } else if item.laNgayYeu {
            cell.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.08)
        } else if laChon {
            cell.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        } else {
            cell.backgroundColor = item.coDuLieuNgayCuaDoi ? .systemBackground : UIColor.secondarySystemGroupedBackground.withAlphaComponent(0.5)
        }

        let thang = TienIchNgay.lich.component(.month, from: item.ngay)
        let giaTri: [String] = [
            String(format: "%02d/%02d", item.ngayTrongThang, thang),
            item.coDuLieuNgayCuaDoi ? item.doanhThuThucNV.chuoiSoVN : "--",
            item.coDuLieuNgayCuaDoi ? item.doanhThuQDNV.chuoiSoVN : "--",
            item.coDuLieuNgayCuaDoi ? item.tongDoanhThuQDNgay.chuoiSoVN : "--",
            item.coDuLieuNgayCuaDoi ? item.tyLeDongGopNgay.chuoiPhanTram : "--",
            item.trangThaiNgay
        ]

        let mauTot = UIColor(red: 0.08, green: 0.55, blue: 0.25, alpha: 1)
        let mauDat = UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1)
        let mauYeu = UIColor(red: 0.80, green: 0.14, blue: 0.14, alpha: 1)

        for (i, chu) in giaTri.enumerated() {
            let lb = UILabel()
            lb.text = chu
            lb.adjustsFontSizeToFitWidth = true
            lb.minimumScaleFactor = 0.72
            lb.textAlignment = (i == 0) ? .left : (i >= 4 ? .center : .right)

            if i == 0 {
                lb.font = .systemFont(ofSize: 11.5, weight: laChon ? .heavy : .bold)
                lb.textColor = item.laNgayYeu ? mauYeu : (laChon ? .systemBlue : .label)
            } else if i == 1 {
                lb.font = .monospacedDigitSystemFont(ofSize: 11, weight: .semibold)
                lb.textColor = item.coDuLieuNgayCuaDoi ? .label : .secondaryLabel
            } else if i == 2 {
                lb.font = .monospacedDigitSystemFont(ofSize: 11.5, weight: .bold)
                lb.textColor = item.coDuLieuNgayCuaDoi ? (item.laNgayYeu ? mauYeu : mauTot) : .secondaryLabel
            } else if i == 3 {
                lb.font = .monospacedDigitSystemFont(ofSize: 11, weight: .medium)
                lb.textColor = .secondaryLabel
            } else if i == 4 {
                lb.font = .monospacedDigitSystemFont(ofSize: 11, weight: .heavy)
                if item.coDuLieuNgayCuaDoi {
                    lb.textColor = item.laNgayYeu ? mauYeu : (item.tyLeDongGopNgay >= item.tyLeChuanBinhQuan ? mauTot : mauDat)
                } else {
                    lb.textColor = .secondaryLabel
                }
            } else {
                lb.font = .systemFont(ofSize: 10.5, weight: .bold)
                lb.textColor = item.laNgayYeu ? mauYeu : (item.tyLeDongGopNgay >= item.tyLeChuanBinhQuan ? mauTot : .secondaryLabel)
            }

            stack.addArrangedSubview(lb)
            lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView === bangSucBanNV {
            guard indexPath.row < danhSachNgaySucBanHienThi.count else { return }
            let item = danhSachNgaySucBanHienThi[indexPath.row]
            if let ngayRT = tatCaNgayTrongThang.first(where: { $0.khoaNgay == item.khoaNgay }) {
                khiChonNgayRealtime?(ngayRT)
            }
            return
        }
        guard indexPath.row < danhSachBieuDo.count else { return }
        khiChonNgayRealtime?(danhSachBieuDo[indexPath.row])
    }

    // MARK: - Xuất Ảnh & CSV Bảng Tổng Hợp Realtime Tháng + Theo Dõi Sức Bán Nhân Viên Theo Ngày

    func taoAnhBaoCaoRealtimeThang(ngay: Date, thongTinDonVi: String = "", capNhatLuc: String = "") -> UIImage? {
        capNhat(cho: ngay)
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let donVi = !thongTinDonVi.isEmpty ? thongTinDonVi : (dl.thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : dl.thongTinDonVi)
        let thang = TienIchNgay.lich.component(.month, from: ngay)
        let nam = TienIchNgay.lich.component(.year, from: ngay)
        let dsCoSo = tatCaNgayTrongThang.filter { $0.coDuLieu }
        let dsVe = dsCoSo.isEmpty ? Array(tatCaNgayTrongThang.prefix(15)) : dsCoSo

        let bc = baoCaoSucBan ?? KhoDuLieu.dungChung.baoCaoSucBanNhanVienTheoNgayTrongThang(cho: ngay, maNVChon: maNVDangChon)
        let dsNVCoSo = bc.chiTietTheoNgay.filter { $0.coDuLieuNgayCuaDoi }
        let dsVeNV = dsNVCoSo.isEmpty ? Array(bc.chiTietTheoNgay.prefix(15)) : dsNVCoSo
        let soCanhBao = bc.danhSachCanhBaoYeuLienTuc.count

        let le: CGFloat = 18
        let rongBieuDo = max(740, 62 + CGFloat(max(dsVe.count, dsVeNV.count)) * 58)
        let rongAnh = rongBieuDo + le * 2
        let caoHeader: CGFloat = 54
        let caoLuyKe: CGFloat = 78
        let caoBieuDo: CGFloat = 230
        let caoCanhBao: CGFloat = 34 + CGFloat(max(1, soCanhBao)) * 24
        let caoBieuDoNV: CGFloat = 230
        let caoHeaderBang: CGFloat = 36
        let caoDong: CGFloat = 38
        let caoBang = caoHeaderBang + CGFloat(max(1, dsVe.count)) * caoDong
        let caoAnh = le * 2 + caoHeader + 10 + caoLuyKe + 12 + caoBieuDo + 12 + caoCanhBao + 10 + caoBieuDoNV + 12 + caoBang

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khung.backgroundColor = .white
        khung.overrideUserInterfaceStyle = .light

        let lbPhu = UILabel(frame: CGRect(x: le, y: le, width: rongBieuDo, height: 18))
        lbPhu.text = "\(donVi)  •  Tháng \(String(format: "%02d/%04d", thang, nam))\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        lbPhu.font = .systemFont(ofSize: 12, weight: .bold)
        lbPhu.textColor = .darkGray
        khung.addSubview(lbPhu)

        let lbChinh = UILabel(frame: CGRect(x: le, y: le + 20, width: rongBieuDo, height: 28))
        lbChinh.text = "📊 BIỂU ĐỒ REALTIME & SỨC BÁN NHÂN VIÊN THEO NGÀY — THÁNG \(String(format: "%02d/%04d", thang, nam))"
        lbChinh.font = .systemFont(ofSize: 18.5, weight: .heavy)
        lbChinh.textColor = .black
        khung.addSubview(lbChinh)

        var y = le + caoHeader + 10

        // 1. Hai thẻ Doanh thu Lũy kế Thực & Quy đổi
        let the1 = TheDoanhThuView(
            tieuDe: "💵 DOANH THU LŨY KẾ THỰC (THÁNG)",
            mauBatDau: UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1),
            mauKetThuc: UIColor(red: 0.23, green: 0.25, blue: 0.89, alpha: 1)
        )
        the1.capNhatNoiDung(
            chinh: doanhThuLuyKe.doanhThuThuc.chuoiSoVN,
            phu: "TARGET: \(doanhThuLuyKe.targetThuc.chuoiSoVN) | HT: \(doanhThuLuyKe.phanTramHTThucHienThi.chuoiPhanTram)",
            coLon: true
        )
        the1.frame = CGRect(x: le, y: y, width: (rongBieuDo - 12) / 2, height: caoLuyKe)
        the1.layoutIfNeeded()
        khung.addSubview(the1)

        let the2 = TheDoanhThuView(
            tieuDe: "🎯 DOANH THU LŨY KẾ QUY ĐỔI (THÁNG)",
            mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1),
            mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1),
            hienChamTron: true
        )
        the2.capNhatNoiDung(
            chinh: doanhThuLuyKe.doanhThuQuyDoi.chuoiSoVN,
            phu: "TARGET: \(doanhThuLuyKe.targetQuyDoi.chuoiSoVN) | % QĐ: \(doanhThuLuyKe.phanTramQuyDoi.chuoiPhanTram)",
            coLon: true
        )
        the2.frame = CGRect(x: le + (rongBieuDo - 12) / 2 + 12, y: y, width: (rongBieuDo - 12) / 2, height: caoLuyKe)
        the2.layoutIfNeeded()
        khung.addSubview(the2)

        y += caoLuyKe + 12

        // 2. Đồ thị cột Doanh thu Thực & Quy đổi theo ngày
        let hopBD = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoBieuDo))
        hopBD.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        hopBD.layer.cornerRadius = 10
        hopBD.layer.borderWidth = 1
        hopBD.layer.borderColor = UIColor.systemGray4.cgColor

        let lbLegend = UILabel(frame: CGRect(x: 12, y: 8, width: rongBieuDo - 24, height: 18))
        lbLegend.text = "ĐỒ THỊ CỘT REALTIME SIÊU THỊ THEO NGÀY:   🟦 Doanh thu Thực     🟩 Doanh thu Quy đổi"
        lbLegend.font = .systemFont(ofSize: 12, weight: .bold)
        lbLegend.textColor = .black
        hopBD.addSubview(lbLegend)

        let chart = VeBieuDoCotRealtimeView(frame: CGRect(x: 4, y: 28, width: rongBieuDo - 8, height: caoBieuDo - 32))
        chart.overrideUserInterfaceStyle = .light
        chart.ngayDangChon = TienIchNgay.lich.component(.day, from: ngay)
        chart.danhSachNgay = dsVe
        hopBD.addSubview(chart)
        khung.addSubview(hopBD)

        y += caoBieuDo + 12

        // 3. Khung Cảnh báo nhân viên nhiều ngày yếu liên tục + Biểu đồ sức bán NV theo ngày
        let hopCB = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoCanhBao))
        hopCB.backgroundColor = soCanhBao > 0
            ? UIColor(red: 1.0, green: 0.95, blue: 0.95, alpha: 1)
            : UIColor(red: 0.94, green: 0.99, blue: 0.95, alpha: 1)
        hopCB.layer.cornerRadius = 10
        hopCB.layer.borderWidth = 1
        hopCB.layer.borderColor = (soCanhBao > 0 ? UIColor.systemRed : UIColor.systemGreen).withAlphaComponent(0.35).cgColor

        let lbTieuDeCB = UILabel(frame: CGRect(x: 12, y: 6, width: rongBieuDo - 24, height: 20))
        lbTieuDeCB.text = soCanhBao > 0
            ? "🚨 CẢNH BÁO NHÂN VIÊN NHIỀU NGÀY YẾU LIÊN TỤC (\(soCanhBao) NV)"
            : "✅ CẢNH BÁO SỨC BÁN NHÂN VIÊN: Không có nhân viên yếu nhiều ngày liên tục"
        lbTieuDeCB.font = .systemFont(ofSize: 12, weight: .heavy)
        lbTieuDeCB.textColor = soCanhBao > 0 ? UIColor(red: 0.78, green: 0.12, blue: 0.12, alpha: 1) : UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
        hopCB.addSubview(lbTieuDeCB)

        if soCanhBao > 0 {
            for (idx, cb) in bc.danhSachCanhBaoYeuLienTuc.enumerated() {
                let lbDong = UILabel(frame: CGRect(x: 14, y: 28 + CGFloat(idx) * 24, width: rongBieuDo - 28, height: 22))
                lbDong.text = "• \(cb.nhanVien.maNV) - \(cb.nhanVien.hoTen): \(cb.moTaChiTietCanhBao)"
                lbDong.font = .systemFont(ofSize: 11.5, weight: .bold)
                lbDong.textColor = .black
                hopCB.addSubview(lbDong)
            }
        } else {
            let lbDong = UILabel(frame: CGRect(x: 14, y: 28, width: rongBieuDo - 28, height: 22))
            lbDong.text = "• Toàn bộ nhân viên duy trì tỷ lệ đóng góp ổn định trong tháng."
            lbDong.font = .systemFont(ofSize: 11.5, weight: .medium)
            lbDong.textColor = .darkGray
            hopCB.addSubview(lbDong)
        }
        khung.addSubview(hopCB)
        y += caoCanhBao + 10

        let hopBDNV = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoBieuDoNV))
        hopBDNV.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        hopBDNV.layer.cornerRadius = 10
        hopBDNV.layer.borderWidth = 1
        hopBDNV.layer.borderColor = UIColor.systemGray4.cgColor

        let tkChon = bc.tongKetNhanVienDangChon
        let lbLegendNV = UILabel(frame: CGRect(x: 12, y: 8, width: rongBieuDo - 24, height: 18))
        lbLegendNV.text = "👤 SỨC BÁN THEO NGÀY: \(bc.nhanVienDangChon.maNV) - \(bc.nhanVienDangChon.hoTen)  •  Tổng QĐ: \(tkChon.tongDoanhThuQDThang.chuoiSoVN)  •  Đóng góp TB: \(tkChon.tyLeDongGopTBThang.chuoiPhanTram)  •  \(tkChon.nhanTrangThaiNgan)"
        lbLegendNV.font = .systemFont(ofSize: 12, weight: .bold)
        lbLegendNV.textColor = .black
        hopBDNV.addSubview(lbLegendNV)

        let chartNV = VeBieuDoSucBanNhanVienView(frame: CGRect(x: 4, y: 28, width: rongBieuDo - 8, height: caoBieuDoNV - 32))
        chartNV.overrideUserInterfaceStyle = .light
        chartNV.ngayDangChon = TienIchNgay.lich.component(.day, from: ngay)
        chartNV.tyLeChuanBinhQuan = tkChon.tyLeChuanBinhQuan
        chartNV.danhSachNgay = dsVeNV
        hopBDNV.addSubview(chartNV)
        khung.addSubview(hopBDNV)

        y += caoBieuDoNV + 12

        // 4. Bảng chi tiết các ngày
        let khungBang = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoBang))
        khungBang.layer.borderWidth = 1
        khungBang.layer.borderColor = UIColor.systemGray4.cgColor
        khungBang.layer.cornerRadius = 8
        khungBang.clipsToBounds = true
        khung.addSubview(khungBang)

        let cu = self.danhSachBieuDo
        self.danhSachBieuDo = dsVe
        if let hView = self.tableView(bangNgay, viewForHeaderInSection: 0) {
            hView.frame = CGRect(x: 0, y: 0, width: rongBieuDo, height: caoHeaderBang)
            khungBang.addSubview(hView)
        }
        for i in 0..<dsVe.count {
            let cell = self.tableView(bangNgay, cellForRowAt: IndexPath(row: i, section: 0))
            let vDong = cell.contentView
            vDong.frame = CGRect(x: 0, y: caoHeaderBang + CGFloat(i) * caoDong, width: rongBieuDo, height: caoDong)
            let vach = UIView(frame: CGRect(x: 0, y: caoDong - 0.5, width: rongBieuDo, height: 0.5))
            vach.backgroundColor = .systemGray4
            vDong.addSubview(vach)
            khungBang.addSubview(vDong)
        }
        self.danhSachBieuDo = cu

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 2.0
        let anh = UIGraphicsImageRenderer(size: khung.bounds.size, format: fmt).image { ctx in
            khung.layer.render(in: ctx.cgContext)
        }
        bangNgay.reloadData()
        return anh
    }

    func taoChuoiExcelCSVBieuDoThang(ngay: Date, thongTinDonVi: String = "", capNhatLuc: String = "") -> String {
        capNhat(cho: ngay)
        let thang = TienIchNgay.lich.component(.month, from: ngay)
        let nam = TienIchNgay.lich.component(.year, from: ngay)
        let bc = baoCaoSucBan ?? KhoDuLieu.dungChung.baoCaoSucBanNhanVienTheoNgayTrongThang(cho: ngay, maNVChon: maNVDangChon)

        var dong: [String] = []
        dong.append("\"BIỂU ĐỒ REALTIME & SỨC BÁN NHÂN VIÊN THEO NGÀY - THÁNG \(String(format: "%02d/%04d", thang, nam))\",\"Cập nhật: \(capNhatLuc)\"")
        dong.append("")
        dong.append("PHẦN 1: CẢNH BÁO NHÂN VIÊN NHIỀU NGÀY YẾU LIÊN TỤC")
        dong.append("Mã NV,Họ và tên,Chuỗi ngày yếu liên tục,Khoảng ngày,Tổng ngày yếu,DT QĐ Tháng (RT),% Đóng góp TB,% Chuẩn bình quân,Trạng thái")
        if bc.danhSachCanhBaoYeuLienTuc.isEmpty {
            dong.append("\"Không có nhân viên yếu nhiều ngày liên tục\",\"--\",0,\"--\",0,0,0%,0%,\"Ổn định\"")
        } else {
            for cb in bc.danhSachCanhBaoYeuLienTuc {
                dong.append("\"\(cb.nhanVien.maNV)\",\"\(cb.nhanVien.hoTen)\",\(cb.soNgayChuoiCanhBao),\"\(cb.khoangNgayYeuLienTuc)\",\(cb.soNgayYeu),\(cb.tongDoanhThuQDThang),\(String(format: "%.2f%%", cb.tyLeDongGopTBThang)),\(String(format: "%.2f%%", cb.tyLeChuanBinhQuan)),\"\(cb.nhanTrangThaiNgan)\"")
            }
        }
        dong.append("")
        dong.append("PHẦN 2: CHI TIẾT SỨC BÁN THEO NGÀY CỦA NHÂN VIÊN: \(bc.nhanVienDangChon.maNV) - \(bc.nhanVienDangChon.hoTen)")
        dong.append("Ngày,DT Thực NV (RT),DT Quy đổi NV (RT),Tổng DT QĐ Đội (RT),% Đóng góp ngày,% Chuẩn bình quân,Đánh giá")
        for item in bc.chiTietTheoNgay where item.coDuLieuNgayCuaDoi {
            let ngayStr = String(format: "%02d/%02d/%04d", item.ngayTrongThang, thang, nam)
            dong.append("\(ngayStr),\(item.doanhThuThucNV),\(item.doanhThuQDNV),\(item.tongDoanhThuQDNgay),\(String(format: "%.2f%%", item.tyLeDongGopNgay)),\(String(format: "%.2f%%", item.tyLeChuanBinhQuan)),\"\(item.trangThaiNgay)\"")
        }
        dong.append("")
        dong.append("PHẦN 3: BẢNG REALTIME SIÊU THỊ THEO NGÀY")
        dong.append("Ngày,DT Thực (RT),DT Quy đổi (RT),% Quy đổi,Lượt khách,Số Bill")
        for item in tatCaNgayTrongThang where item.coDuLieu {
            let ngayStr = String(format: "%02d/%02d/%04d", item.ngayTrongThang, thang, nam)
            dong.append("\(ngayStr),\(item.doanhThuThuc),\(item.doanhThuQuyDoi),\(String(format: "%.2f%%", item.phanTramQuyDoi)),\(Int(item.luotKhach)),\(Int(item.soBill))")
        }
        return "\u{FEFF}" + dong.joined(separator: "\n")
    }
}
