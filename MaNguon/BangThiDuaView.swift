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

// MARK: - Thẻ Chỉ Số Gradient & Cụm 8 Thẻ "Chỉ Số Chính" (Giống Ảnh 3)

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
    var khiBamVungThe: (() -> Void)?

    private var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private let nutLuyKe = UIButton(type: .custom)
    private let nutRealtime = UIButton(type: .custom)

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
        nutLuyKe.titleLabel?.font = .systemFont(ofSize: coLon ? 14 : 13, weight: .bold)
        nutLuyKe.layer.cornerRadius = 10
        nutLuyKe.layer.borderWidth = 1
        nutLuyKe.addTarget(self, action: #selector(bamChonCheDo(_:)), for: .touchUpInside)

        nutRealtime.tag = LoaiCheDoDoanhThu.realtime.rawValue
        nutRealtime.setTitle("⚡ Doanh thu Realtime", for: .normal)
        nutRealtime.titleLabel?.font = .systemFont(ofSize: coLon ? 14 : 13, weight: .bold)
        nutRealtime.layer.cornerRadius = 10
        nutRealtime.layer.borderWidth = 1
        nutRealtime.addTarget(self, action: #selector(bamChonCheDo(_:)), for: .touchUpInside)

        let hangHaiNut = UIStackView(arrangedSubviews: [nutLuyKe, nutRealtime])
        hangHaiNut.axis = .horizontal
        hangHaiNut.spacing = 6
        hangHaiNut.distribution = .fillEqually

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

        let nganChinh = UIStackView(arrangedSubviews: [hangHaiNut, luoiThe])
        nganChinh.axis = .vertical
        nganChinh.spacing = coLon ? 8 : 6
        nganChinh.isUserInteractionEnabled = true
        nganChinh.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nganChinh)

        NSLayoutConstraint.activate([
            hangHaiNut.heightAnchor.constraint(equalToConstant: coLon ? 38 : 34),
            nganChinh.topAnchor.constraint(equalTo: topAnchor),
            nganChinh.leadingAnchor.constraint(equalTo: leadingAnchor),
            nganChinh.trailingAnchor.constraint(equalTo: trailingAnchor),
            nganChinh.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        capNhatMauNutCheDo()
    }

    @objc private func bamChonCheDo(_ sender: UIButton) {
        guard let moi = LoaiCheDoDoanhThu(rawValue: sender.tag), moi != cheDoDoanhThu else { return }
        cheDoDoanhThu = moi
        capNhatMauNutCheDo()
        khiDoiCheDoDoanhThu?(moi)
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
            if cheDoDoanhThu == loai {
                nut.backgroundColor = .systemBlue
                nut.setTitleColor(.white, for: .normal)
                nut.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                nut.backgroundColor = .secondarySystemGroupedBackground
                nut.setTitleColor(.label, for: .normal)
                nut.layer.borderColor = UIColor.separator.cgColor
            }
        }
    }

    func capNhat(doanhThu dt: ThongTinDoanhThu, soNganhDat: Int, tongSoNganh: Int, ngay: Date = Date(), cheDo: LoaiCheDoDoanhThu = .luyKe) {
        self.cheDoDoanhThu = cheDo
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
    private var boLoc: BoLocThiDua = .tatCa
    private var kieuSapXep: KieuSapXepThiDua = .phanTramCaoThap
    private var soCotTrenDienThoai: Int = 1

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

        let tieuDeTrong = UILabel()
        tieuDeTrong.text = "Chạm để chọn ảnh chụp màn hình Thi đua"
        tieuDeTrong.font = .systemFont(ofSize: 15, weight: .bold)
        tieuDeTrong.textAlignment = .center

        let phuDeTrong = UILabel()
        phuDeTrong.text = "Chọn cặp ảnh cột TARGET và cột THỰC HIỆN để tự động ghép số liệu.\nBấm vào từng ngành hàng sau khi quét để xem xếp hạng nhân viên."
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
        chonBoLoc.setTitle("Chưa đạt (\(soChuaDat))", forSegmentAt: 2)

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

    private func taoDongTieuDeCot() -> UIView {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 40))
        khung.backgroundColor = UIColor.systemGray5

        let tieuDe = ["STT", "NGÀNH HÀNG (BẤM XEM NV)", "ĐVT", "THỰC HIỆN", "TARGET", "THIẾU/VƯỢT", "% HT THÁNG", "% DỰ BÁO"]
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
        cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        switch KhoDuLieu.dungChung.caiDat.kieuHienThi {
        case .bangChiTiet:
            return taoAnhMẫuBang8Cot(
                ngay: ngay,
                doanhThu: doanhThu,
                cheDoDoanhThu: cheDoDoanhThu,
                thongTinDonVi: thongTinDonVi,
                capNhatLuc: capNhatLuc
            )
        case .theGon:
            return taoAnhMauTheGon(
                ngay: ngay,
                doanhThu: doanhThu,
                cheDoDoanhThu: cheDoDoanhThu,
                thongTinDonVi: thongTinDonVi,
                capNhatLuc: capNhatLuc
            )
        }
    }

    private func taoAnhMẫuBang8Cot(
        ngay: Date,
        doanhThu: ThongTinDoanhThu,
        cheDoDoanhThu: LoaiCheDoDoanhThu,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let ds = danhSachHienThi
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

        let header = taoDongTieuDeCot()
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
        cheDoDoanhThu: LoaiCheDoDoanhThu,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let ds = danhSachHienThi
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

    func taoChuoiExcelCSV(doanhThu: ThongTinDoanhThu) -> String {
        var cacDong: [String] = []
        let ds = danhSachHienThi
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
