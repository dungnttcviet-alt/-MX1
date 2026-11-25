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

extension UIView {
    func timViewControllerCha() -> UIViewController? {
        var phanHoi: UIResponder? = self
        while let tiep = phanHoi?.next {
            if let vc = tiep as? UIViewController {
                return vc
            }
            phanHoi = tiep
        }
        return nil
    }

    private func apDungKieuSangDeQuy(scale: CGFloat) {
        overrideUserInterfaceStyle = .light
        if bounds.width > 0 && bounds.height > 0 {
            layer.contentsScale = scale
            if self is VeBieuDoCotRealtimeView || self is VeBieuDoSucKhoeNhanVienView {
                layer.setNeedsDisplay()
                layer.displayIfNeeded()
            }
        }
        for sub in subviews {
            sub.apDungKieuSangDeQuy(scale: scale)
        }
    }

    func buocBoCucToanBo() {
        overrideUserInterfaceStyle = .light
        setNeedsLayout()
        layoutIfNeeded()
        apDungKieuSangDeQuy(scale: 2.0)
    }

    func ketXuatAnhChuanSang(scale: CGFloat = 2.0) -> UIImage? {
        guard bounds.width > 1, bounds.height > 1 else { return nil }
        let traitSang = UITraitCollection(userInterfaceStyle: .light)
        var ketQua: UIImage?
        let maxCanh = max(bounds.width, bounds.height)
        let scaleAnToan: CGFloat = maxCanh > 2200 ? min(scale, 2.0) : min(scale, 2.5)
        traitSang.performAsCurrent {
            self.overrideUserInterfaceStyle = .light
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.apDungKieuSangDeQuy(scale: scaleAnToan)
            CATransaction.flush()

            let fmt = UIGraphicsImageRendererFormat.default()
            fmt.scale = scaleAnToan
            fmt.opaque = true
            if #available(iOS 12.0, *) {
                fmt.preferredRange = .standard
            }
            ketQua = UIGraphicsImageRenderer(size: self.bounds.size, format: fmt).image { ctx in
                (self.backgroundColor ?? .white).setFill()
                ctx.fill(self.bounds)
                self.layer.render(in: ctx.cgContext)
            }
        }
        return ketQua
    }
}

// MARK: - Thẻ Chỉ Số Gradient & Cụm 8 Thẻ "Chỉ Số Chính" (Chữ đồng nhất kích cỡ, tự xuống dòng, không bao giờ "...")

final class TheDoanhThuView: UIControl {
    private let lopGradient = CAGradientLayer()
    private let nenDauThe = UIView()
    private let vachTrai = UIView()
    private let nhanTieuDe = UILabel()
    private let nhanGiaTriChinh = UILabel()
    private let vachKe = UIView()
    private let nhanTarget = UILabel()
    private let chamTron = UIView()
    private let mauNhan: UIColor
    private let mauSoChinh: UIColor
    private let noiBatSo: Bool
    private let nenNoiBat: Bool

    override var frame: CGRect {
        didSet { capNhatBoCucThe() }
    }

    override var bounds: CGRect {
        didSet { capNhatBoCucThe() }
    }

    init(tieuDe: String, mauBatDau: UIColor, mauKetThuc: UIColor, hienChamTron: Bool = false, nenNoiBat: Bool = false) {
        self.mauNhan = mauBatDau
        self.mauSoChinh = mauKetThuc
        self.noiBatSo = hienChamTron
        self.nenNoiBat = nenNoiBat
        super.init(frame: .zero)
        backgroundColor = nenNoiBat ? .clear : BangMauBCTD.nenThePhu
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = (nenNoiBat ? mauBatDau.withAlphaComponent(0.55) : BangMauBCTD.vienThe).cgColor
        clipsToBounds = true

        if nenNoiBat {
            lopGradient.colors = [mauBatDau.cgColor, mauKetThuc.cgColor]
            lopGradient.startPoint = CGPoint(x: 0, y: 0)
            lopGradient.endPoint = CGPoint(x: 1, y: 1)
            layer.insertSublayer(lopGradient, at: 0)
        }
        nenDauThe.backgroundColor = nenNoiBat ? UIColor.white.withAlphaComponent(0.12) : mauBatDau.withAlphaComponent(0.16)
        vachTrai.backgroundColor = nenNoiBat ? UIColor.white.withAlphaComponent(0.72) : mauBatDau

        nhanTieuDe.text = tieuDe
        nhanTieuDe.font = .systemFont(ofSize: 8.5, weight: .bold)
        nhanTieuDe.textColor = nenNoiBat ? UIColor.white.withAlphaComponent(0.94) : BangMauBCTD.chuPhu
        nhanTieuDe.textAlignment = .center
        nhanTieuDe.numberOfLines = 0
        nhanTieuDe.lineBreakMode = .byWordWrapping
        nhanTieuDe.adjustsFontSizeToFitWidth = false

        nhanGiaTriChinh.text = "0,00"
        nhanGiaTriChinh.font = .systemFont(ofSize: 13.0, weight: .heavy)
        nhanGiaTriChinh.textColor = nenNoiBat ? .white : (hienChamTron ? mauKetThuc : BangMauBCTD.chuChinh)
        nhanGiaTriChinh.textAlignment = .center
        nhanGiaTriChinh.numberOfLines = 0
        nhanGiaTriChinh.lineBreakMode = .byWordWrapping
        nhanGiaTriChinh.adjustsFontSizeToFitWidth = false

        vachKe.backgroundColor = nenNoiBat ? UIColor.white.withAlphaComponent(0.28) : BangMauBCTD.vienThe

        nhanTarget.text = "TARGET: 0,00"
        nhanTarget.font = .systemFont(ofSize: 8.0, weight: .bold)
        nhanTarget.textColor = nenNoiBat ? UIColor.white.withAlphaComponent(0.88) : BangMauBCTD.chuMo
        nhanTarget.textAlignment = .center
        nhanTarget.numberOfLines = 0
        nhanTarget.lineBreakMode = .byWordWrapping
        nhanTarget.adjustsFontSizeToFitWidth = false

        chamTron.backgroundColor = mauBatDau
        chamTron.layer.cornerRadius = 2.5
        chamTron.isHidden = !hienChamTron

        [nenDauThe, vachTrai, nhanTieuDe, nhanGiaTriChinh, vachKe, nhanTarget, chamTron].forEach {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        capNhatBoCucThe()
    }

    private func capNhatBoCucThe() {
        let w = bounds.width
        let h = bounds.height
        guard w > 10, h > 10 else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        lopGradient.frame = bounds
        CATransaction.commit()

        // Cố định toạ độ Y của vùng tiêu đề, số chính và đường gạch ngang theo chiều cao thẻ H
        // để mọi thẻ trên cùng 1 hàng có số chính và đường gạch ngang thẳng hàng ngang tuyệt đối
        let yTieuDe = round(h * 0.03)
        let caoTieuDe = round(h * 0.31)
        let yGiaTri = yTieuDe + caoTieuDe
        let caoGiaTri = round(h * 0.27)
        let yVachKe = yGiaTri + caoGiaTri + 1
        let yTarget = yVachKe + 2
        let caoTarget = max(12, h - yTarget - 2)

        vachTrai.frame = CGRect(x: 0, y: 0, width: 3.5, height: h)
        nenDauThe.frame = CGRect(x: 3.5, y: 0, width: max(4, w - 3.5), height: yGiaTri)
        nhanTieuDe.frame = CGRect(x: 5, y: yTieuDe, width: max(8, w - 8), height: caoTieuDe)
        chamTron.frame = CGRect(x: max(4, w - 8), y: max(3, yTieuDe + 2), width: 5, height: 5)
        nhanGiaTriChinh.frame = CGRect(x: 5, y: yGiaTri, width: max(8, w - 8), height: caoGiaTri)
        vachKe.frame = CGRect(x: 6, y: yVachKe, width: max(8, w - 10), height: 1)
        nhanTarget.frame = CGRect(x: 5, y: yTarget, width: max(8, w - 8), height: caoTarget)
    }

    func capNhatNoiDung(chinh: String, phu: String, coLon: Bool = false) {
        nhanGiaTriChinh.text = chinh
        nhanTarget.text = phu
        nhanTieuDe.font = .systemFont(ofSize: coLon ? 15.0 : 8.5, weight: .bold)
        nhanGiaTriChinh.font = .systemFont(ofSize: coLon ? 24.0 : 13.0, weight: .heavy)
        nhanTarget.font = .systemFont(ofSize: coLon ? 13.5 : 8.0, weight: .bold)

        if nenNoiBat {
            nhanGiaTriChinh.textColor = .white
        } else if chinh.hasPrefix("+") {
            nhanGiaTriChinh.textColor = BangMauBCTD.xanhDatChu
        } else if chinh.hasPrefix("-") && chinh != "--" {
            nhanGiaTriChinh.textColor = BangMauBCTD.doYeuChu
        } else {
            nhanGiaTriChinh.textColor = noiBatSo ? mauSoChinh : BangMauBCTD.chuChinh
        }
        capNhatBoCucThe()
    }

    func capNhatTieuDe(_ tieuDe: String) {
        nhanTieuDe.text = tieuDe
        capNhatBoCucThe()
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
        capNhatBoCucThe()
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
    private var luoiThe: UIStackView!

    private let theDTThuc = TheDoanhThuView(
        tieuDe: "💵 DT THỰC",
        mauBatDau: BangMauBCTD.indigoChuDao,
        mauKetThuc: UIColor(red: 0.03, green: 0.62, blue: 0.92, alpha: 1.0),
        nenNoiBat: true
    )
    private let theDTQD = TheDoanhThuView(
        tieuDe: "🎯 DT QUY ĐỔI",
        mauBatDau: BangMauBCTD.xanhDatVach,
        mauKetThuc: UIColor(red: 0.02, green: 0.43, blue: 0.28, alpha: 1.0),
        nenNoiBat: true
    )
    private let theTraGop = TheDoanhThuView(
        tieuDe: "💳 % TRẢ GÓP",
        mauBatDau: BangMauBCTD.vangKhaVach,
        mauKetThuc: BangMauBCTD.vangKhaChu
    )
    private let theLuotKhach = TheDoanhThuView(
        tieuDe: "👥 LƯỢT KHÁCH",
        mauBatDau: BangMauBCTD.xanhBienChuDao,
        mauKetThuc: BangMauBCTD.chuChinh
    )
    private let theHTQDDuKien = TheDoanhThuView(
        tieuDe: "📈 % HT QĐ DỰ KIẾN",
        mauBatDau: BangMauBCTD.indigoDam,
        mauKetThuc: BangMauBCTD.indigoDam
    )
    private let thePhanTramQD = TheDoanhThuView(
        tieuDe: "🔄 % QUY ĐỔI",
        mauBatDau: BangMauBCTD.vangChuDao,
        mauKetThuc: BangMauBCTD.vangKhaChu
    )
    private let theThiDuaHT = TheDoanhThuView(
        tieuDe: "🏆 THI ĐUA HOÀN THÀNH",
        mauBatDau: BangMauBCTD.xanhDatVach,
        mauKetThuc: BangMauBCTD.xanhDatChu
    )
    private let theTangGiam = TheDoanhThuView(
        tieuDe: "📈 TĂNG/GIẢM CÙNG KỲ",
        mauBatDau: BangMauBCTD.indigoChuDao,
        mauKetThuc: BangMauBCTD.chuChinh
    )

    private let coLon: Bool
    private let anHangNutCheDo: Bool

    init(coLon: Bool = false, anHangNutCheDo: Bool = false) {
        self.coLon = coLon
        self.anHangNutCheDo = anHangNutCheDo
        super.init(frame: .zero)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func cauHinhNutCheDo(_ nut: UIButton, tieuDe: String) {
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: coLon ? 13.5 : 12.0, weight: .bold)
        nut.titleLabel?.numberOfLines = 0
        nut.titleLabel?.lineBreakMode = .byWordWrapping
        nut.titleLabel?.textAlignment = .center
        nut.titleLabel?.adjustsFontSizeToFitWidth = false
        nut.contentEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
        nut.layer.cornerRadius = 10
        nut.layer.borderWidth = 1
    }

    private func taoGiaoDien() {
        // Yêu cầu 1: Bỏ chữ "Doanh thu" ra khỏi 2 nút trên đầu, chỉ còn "Lũy kế" và "Realtime"
        nutLuyKe.tag = LoaiCheDoDoanhThu.luyKe.rawValue
        cauHinhNutCheDo(nutLuyKe, tieuDe: "📊 Lũy kế")
        nutLuyKe.addTarget(self, action: #selector(bamChonCheDo(_:)), for: .touchUpInside)

        nutRealtime.tag = LoaiCheDoDoanhThu.realtime.rawValue
        cauHinhNutCheDo(nutRealtime, tieuDe: "⚡ Realtime")
        nutRealtime.addTarget(self, action: #selector(bamChonCheDo(_:)), for: .touchUpInside)

        cauHinhNutCheDo(nutBieuDo, tieuDe: "📈 Biểu đồ")
        nutBieuDo.isHidden = coLon
        nutBieuDo.addTarget(self, action: #selector(bamNutBieuDo), for: .touchUpInside)

        let cacNutTren: [UIView] = coLon ? [nutLuyKe, nutRealtime] : [nutLuyKe, nutRealtime, nutBieuDo]
        let hangBaNut = UIStackView(arrangedSubviews: cacNutTren)
        hangBaNut.axis = .horizontal
        hangBaNut.spacing = 6
        hangBaNut.distribution = .fillEqually

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

        luoiThe = UIStackView(arrangedSubviews: [hang1, hang2])
        luoiThe.axis = .vertical
        luoiThe.spacing = khoangCach
        luoiThe.distribution = .fillEqually
        luoiThe.isUserInteractionEnabled = true

        let tapLuoiThe = UITapGestureRecognizer(target: self, action: #selector(bamVaoLuoiThe))
        luoiThe.addGestureRecognizer(tapLuoiThe)

        hangBaNut.isHidden = anHangNutCheDo
        let cacPhanTuChinh: [UIView] = anHangNutCheDo ? [luoiThe] : [hangBaNut, luoiThe]
        let nganChinh = UIStackView(arrangedSubviews: cacPhanTuChinh)
        nganChinh.axis = .vertical
        nganChinh.spacing = coLon ? 8 : 6
        nganChinh.isUserInteractionEnabled = true
        nganChinh.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nganChinh)

        if !anHangNutCheDo {
            hangBaNut.heightAnchor.constraint(greaterThanOrEqualToConstant: coLon ? 38 : 34).isActive = true
        }
        NSLayoutConstraint.activate([
            nganChinh.topAnchor.constraint(equalTo: topAnchor),
            nganChinh.leadingAnchor.constraint(equalTo: leadingAnchor),
            nganChinh.trailingAnchor.constraint(equalTo: trailingAnchor),
            nganChinh.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        capNhatMauNutCheDo()
    }

    @objc private func bamChonCheDo(_ sender: UIButton) {
        guard let moi = LoaiCheDoDoanhThu(rawValue: sender.tag) else { return }
        if moi == cheDoDoanhThu && !dangXemBieuDo { return }
        cheDoDoanhThu = moi
        dangXemBieuDo = false
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
                nut.backgroundColor = BangMauBCTD.nenMenuToi
                nut.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
            } else {
                nut.backgroundColor = BangMauBCTD.nenThePhu
                nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            }
        }
        if dangXemBieuDo {
            nutBieuDo.backgroundColor = BangMauBCTD.nenMenuToi
            nutBieuDo.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
            nutBieuDo.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        } else {
            nutBieuDo.backgroundColor = BangMauBCTD.nenThePhu
            nutBieuDo.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
            nutBieuDo.layer.borderColor = BangMauBCTD.vienDam.cgColor
        }
        luoiThe?.isHidden = dangXemBieuDo
    }

    func capNhat(
        doanhThu dt: ThongTinDoanhThu,
        soNganhDat: Int,
        tongSoNganh: Int,
        ngay: Date = Date(),
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        dangXemBieuDo: Bool = false
    ) {
        self.cheDoDoanhThu = cheDo
        self.dangXemBieuDo = dangXemBieuDo
        capNhatMauNutCheDo()

        if !dt.coDuLieu {
            theDTThuc.capNhatNoiDung(chinh: "-", phu: "TARGET: --", coLon: coLon)
            theDTQD.capNhatNoiDung(chinh: coLon ? "0,00" : "Chạm quét", phu: "TARGET: --", coLon: coLon)
        } else {
            let phuThuc: String
            if dt.phanTramHTThuc > 0 && dt.targetThuc > 0 {
                phuThuc = "TARGET: \(dt.targetThuc.chuoiSoGonVN) (\(dt.phanTramHTThuc.chuoiPhanTram))"
            } else {
                phuThuc = "TARGET: \(dt.targetThuc.chuoiSoGonVN)"
            }
            theDTThuc.capNhatNoiDung(
                chinh: "-",
                phu: phuThuc,
                coLon: coLon
            )

            let phuQD: String
            if dt.phanTramHTQuyDoi > 0 && dt.targetQuyDoi > 0 {
                phuQD = "TARGET: \(dt.targetQuyDoi.chuoiSoGonVN) (\(dt.phanTramHTQuyDoi.chuoiPhanTram))"
            } else {
                phuQD = "TARGET: \(dt.targetQuyDoi.chuoiSoGonVN)"
            }
            theDTQD.capNhatNoiDung(
                chinh: dt.doanhThuQuyDoi.chuoiSoGonVN,
                phu: phuQD,
                coLon: coLon
            )
        }

        theTraGop.capNhatNoiDung(
            chinh: dt.phanTramTraGop.chuoiPhanTram,
            phu: "DT: \(dt.doanhThuTraGop.chuoiSoGonVN)",
            coLon: coLon
        )

        theLuotKhach.capNhatNoiDung(
            chinh: dt.luotKhach.chuoiSoNguyenVN,
            phu: "BILL: \(dt.soBill.chuoiSoNguyenVN) | PVTC: \(dt.phanTramPVTC.chuoiPhanTram)",
            coLon: coLon
        )

        let ptGoc = dt.phanTramHTQuyDoiHienThi(cheDo: cheDo)
        let dkGoc = dt.duKienQuyDoi > 0 ? dt.duKienQuyDoi : dt.duKienThuc
        theHTQDDuKien.capNhatTieuDe(
            cheDo == .realtime ? "📈 % HT TARGET NGÀY" : "📈 % HT QĐ DỰ KIẾN"
        )
        theHTQDDuKien.capNhatNoiDung(
            chinh: ptGoc.chuoiPhanTram,
            phu: cheDo == .realtime
                ? "DT QĐ / TARGET: \(dt.doanhThuQuyDoi.chuoiSoGonVN) / \(dt.targetQuyDoi.chuoiSoGonVN)"
                : "DTQĐ DK: \(dkGoc.chuoiSoGonVN)",
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
        let phuTG = dt.tb3Thang > 0 ? "TB3T: \(dt.tb3Thang.chuoiSoGonVN)" : "TB3T: 0"
        theTangGiam.capNhatNoiDung(
            chinh: "\(dauTG)\(dt.tangGiamCungKy.chuoiPhanTram)",
            phu: phuTG,
            coLon: coLon
        )

        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - Ô Thẻ Tiến Độ Gọn (Mẫu hiển thị 2 — bố cục frame chính xác tuyệt đối, 2 ô cùng hàng bằng nhau, hiện đầy đủ 100% tên ngành hàng & số liệu)

final class OTheThiDuaCell: UICollectionViewCell {
    static let ma = "OTheThiDuaCell"
    private static let fontNhanChiSo = UIFont.systemFont(ofSize: 10, weight: .semibold)
    private static let fontSoChiSo = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .bold)
    private static let caoNhanChiSo = ceil(fontNhanChiSo.lineHeight) + 1
    private static let caoSoChiSo = ceil(fontSoChiSo.lineHeight) + 1
    private static let khoangChiSo: CGFloat = 3
    private static let caoNhomChiSo = 2 * (caoNhanChiSo + caoSoChiSo) + khoangChiSo

    private struct BoCucThe {
        let coChu: CGFloat
        let coChuTen: CGFloat
        let khungTen: CGRect
        let khungPhanTram: CGRect
        var khungDonVi: CGRect = .zero
        var khungNhanDuKien: CGRect = .zero
        let khungThucHien: CGRect
        let khungConThieu: CGRect
        let canPhaiConThieu: Bool
        let khungThanhTienDo: CGRect
        let tongChieuCao: CGFloat
    }

    private let khungThe = UIView()
    private let vachTrai = UIView()
    private let nhanTen = UILabel()
    private let nhanPhanTram = UILabel()
    private let nhanDonVi = UILabel()
    private let nhanDuKien = UILabel()
    private let mocThucHien = UILabel()
    private let mocTarget = UIView()
    private let nhanThucHienTarget = UILabel()
    private let nhanConThieu = UILabel()
    private let nhanChiSoDuKien = (0..<4).map { _ in UILabel() }
    private let soChiSoDuKien = (0..<4).map { _ in UILabel() }
    private let thanhNenTienDo = UIView()
    private let thanhMauTienDo = UIView()

    private var dongHienTai: DongThiDua?
    private var xemDuKienHienTai: Bool = false
    private var tyLeTienDoHienTai: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        khungThe.backgroundColor = BangMauBCTD.nenThe
        khungThe.layer.cornerRadius = 11
        khungThe.layer.borderWidth = 1
        khungThe.layer.borderColor = BangMauBCTD.vienThe.cgColor
        khungThe.clipsToBounds = true
        contentView.addSubview(khungThe)

        nhanTen.textColor = BangMauBCTD.chuChinh
        nhanTen.numberOfLines = 0
        nhanTen.lineBreakMode = .byWordWrapping
        nhanTen.adjustsFontSizeToFitWidth = true
        nhanTen.minimumScaleFactor = 0.68

        nhanPhanTram.textAlignment = .center
        nhanPhanTram.numberOfLines = 1
        nhanPhanTram.layer.cornerRadius = 6
        nhanPhanTram.clipsToBounds = true
        nhanPhanTram.adjustsFontSizeToFitWidth = true
        nhanPhanTram.minimumScaleFactor = 0.72

        nhanDonVi.font = .systemFont(ofSize: 10, weight: .bold)
        nhanDonVi.textAlignment = .center
        nhanDonVi.textColor = BangMauBCTD.chuPhu
        nhanDonVi.backgroundColor = BangMauBCTD.nenThePhu
        nhanDonVi.layer.cornerRadius = 5
        nhanDonVi.clipsToBounds = true
        nhanDuKien.text = "DỰ KIẾN\nHOÀN THÀNH"
        nhanDuKien.font = .systemFont(ofSize: 9, weight: .semibold)
        nhanDuKien.textAlignment = .right
        nhanDuKien.textColor = BangMauBCTD.chuMo
        nhanDuKien.numberOfLines = 2
        mocThucHien.text = "▼"
        mocThucHien.font = .systemFont(ofSize: 8, weight: .bold)
        mocThucHien.textAlignment = .center
        mocThucHien.textColor = BangMauBCTD.chuPhu
        mocTarget.backgroundColor = .white

        nhanThucHienTarget.textColor = BangMauBCTD.chuChinh
        nhanThucHienTarget.numberOfLines = 0
        nhanThucHienTarget.lineBreakMode = .byWordWrapping
        nhanThucHienTarget.adjustsFontSizeToFitWidth = false

        nhanConThieu.textColor = BangMauBCTD.chuMo
        nhanConThieu.numberOfLines = 0
        nhanConThieu.lineBreakMode = .byWordWrapping
        nhanConThieu.adjustsFontSizeToFitWidth = false

        thanhNenTienDo.backgroundColor = BangMauBCTD.vienThe
        thanhNenTienDo.layer.cornerRadius = 2.5
        thanhNenTienDo.clipsToBounds = true

        thanhMauTienDo.layer.cornerRadius = 2.5
        thanhNenTienDo.addSubview(thanhMauTienDo)

        [vachTrai, nhanTen, nhanPhanTram, nhanDonVi, nhanDuKien, nhanThucHienTarget, nhanConThieu, thanhNenTienDo, mocTarget, mocThucHien].forEach {
            khungThe.addSubview($0)
        }
        for (nhan, so) in zip(nhanChiSoDuKien, soChiSoDuKien) {
            nhan.font = Self.fontNhanChiSo
            nhan.textColor = BangMauBCTD.chuMo
            so.font = Self.fontSoChiSo
            for label in [nhan, so] {
                label.numberOfLines = 1
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.7
                khungThe.addSubview(label)
            }
        }
    }

    private static func tinhBoCuc(
        cho dong: DongThiDua,
        rongThe: CGFloat,
        chieuCaoKhung: CGFloat? = nil,
        xemDuKien: Bool
    ) -> BoCucThe {
        let laTheHep = (rongThe < 240)
        let coChu: CGFloat = rongThe >= 300 ? 15 : (laTheHep ? 11 : 12)
        let le: CGFloat = laTheHep ? 6 : 8
        let rongTrong = max(1, rongThe - le * 2)

        let fontDam = UIFont.systemFont(ofSize: coChu, weight: .bold)
        let fontVua = UIFont.systemFont(ofSize: coChu, weight: .semibold)
        let pWrap = NSMutableParagraphStyle()
        pWrap.lineBreakMode = .byWordWrapping

        let rongPT = min(72, floor(rongTrong * 0.42))
        let caoPT: CGFloat = 17
        let rongDonVi: CGFloat = 26
        let rongTen = max(1, rongTrong - (xemDuKien ? rongDonVi : rongPT) - 4)
        var coChuTen = coChu
        func doCaoTen() -> CGFloat {
            ceil((dong.tenNganhHang as NSString).boundingRect(
                with: CGSize(width: rongTen, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: UIFont.systemFont(ofSize: coChuTen, weight: .bold), .paragraphStyle: pWrap],
                context: nil
            ).height)
        }
        var caoTen = doCaoTen()
        while coChuTen > 9, caoTen > ceil(UIFont.systemFont(ofSize: coChuTen, weight: .bold).lineHeight * 2) {
            coChuTen -= 1
            caoTen = doCaoTen()
        }
        let caoTenChu = max(xemDuKien ? 29 : caoPT, caoTen + 1)
        let khungTen = CGRect(x: le, y: 5, width: rongTen, height: caoTenChu)

        if xemDuKien {
            let yDuKien = khungTen.maxY + 3
            let rongTyLe = floor(rongTrong * 0.55)
            let khungThanh = CGRect(x: le, y: yDuKien + 34, width: rongTrong, height: 5)
            let rongChiSo = (rongTrong - 4) / 2
            let yChiSo = khungThanh.maxY + 5
            let caoChiSo = caoNhomChiSo
            return BoCucThe(
                coChu: coChu, coChuTen: coChuTen, khungTen: khungTen,
                khungPhanTram: CGRect(x: le, y: yDuKien, width: rongTyLe, height: 25),
                khungDonVi: CGRect(x: rongThe - le - rongDonVi, y: 5, width: rongDonVi, height: caoPT),
                khungNhanDuKien: CGRect(x: le + rongTyLe, y: yDuKien, width: rongTrong - rongTyLe, height: 25),
                khungThucHien: CGRect(x: le, y: yChiSo, width: rongChiSo, height: caoChiSo),
                khungConThieu: CGRect(x: le + rongChiSo + 4, y: yChiSo, width: rongChiSo, height: caoChiSo),
                canPhaiConThieu: false, khungThanhTienDo: khungThanh,
                tongChieuCao: max(chieuCaoKhung ?? 0, yChiSo + caoChiSo + 5)
            )
        }

        let chuoiTrai = "\(dong.thucHien.chuoiSoVN) / \(dong.target.chuoiSoVN) \(dong.loaiChiTieu.maThe)"
        let chuoiPhai = dong.conThieu > 0.005 ? "Còn: \(dong.conThieu.chuoiSoVN)" : "Vượt: \(dong.vuotMuc.chuoiSoVN)"

        let rongTrai1Dong = ceil((chuoiTrai as NSString).size(withAttributes: [.font: fontDam]).width) + 2
        let rongPhai1Dong = ceil((chuoiPhai as NSString).size(withAttributes: [.font: fontVua]).width) + 2

        let xepChong2DongSo = rongTrai1Dong + 6 + rongPhai1Dong > rongTrong
        let caoTrai: CGFloat
        let caoPhai: CGFloat
        let caoKhuVucSo: CGFloat

        if xepChong2DongSo {
            let rectTrai = (chuoiTrai as NSString).boundingRect(
                with: CGSize(width: rongTrong, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: fontDam, .paragraphStyle: pWrap],
                context: nil
            )
            let rectPhai = (chuoiPhai as NSString).boundingRect(
                with: CGSize(width: rongTrong, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: fontVua, .paragraphStyle: pWrap],
                context: nil
            )
            caoTrai = max(17, ceil(rectTrai.height) + 1)
            caoPhai = max(17, ceil(rectPhai.height) + 1)
            caoKhuVucSo = caoTrai + 3 + caoPhai
        } else {
            caoTrai = 17
            caoPhai = 17
            caoKhuVucSo = 17
        }

        let caoToiThieu = 5 + caoTenChu + 4 + caoKhuVucSo + 3 + 4 + 5
        let tongCao = max(caoToiThieu, chieuCaoKhung ?? caoToiThieu)

        let khungPhanTram = CGRect(x: rongThe - le - rongPT, y: 5, width: rongPT, height: caoPT)
        let khungThanh = CGRect(x: le, y: tongCao - 5 - 4, width: rongTrong, height: 4)

        let yDaySo = khungThanh.minY - 3
        let khungThucHien: CGRect
        let khungConThieu: CGRect

        if xepChong2DongSo {
            khungConThieu = CGRect(x: le, y: yDaySo - caoPhai, width: rongTrong, height: caoPhai)
            khungThucHien = CGRect(x: le, y: khungConThieu.minY - 3 - caoTrai, width: rongTrong, height: caoTrai)
        } else {
            let rongTrai = rongTrong - rongPhai1Dong - 6
            let rongPhai = rongPhai1Dong
            khungThucHien = CGRect(x: le, y: yDaySo - caoTrai, width: rongTrai, height: caoTrai)
            khungConThieu = CGRect(x: rongThe - le - rongPhai, y: yDaySo - caoPhai, width: rongPhai, height: caoPhai)
        }

        return BoCucThe(
            coChu: coChu,
            coChuTen: coChuTen,
            khungTen: khungTen,
            khungPhanTram: khungPhanTram,
            khungThucHien: khungThucHien,
            khungConThieu: khungConThieu,
            canPhaiConThieu: !xepChong2DongSo,
            khungThanhTienDo: khungThanh,
            tongChieuCao: tongCao
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        khungThe.frame = contentView.bounds
        guard let dong = dongHienTai, bounds.width > 20 else { return }

        let bc = Self.tinhBoCuc(
            cho: dong,
            rongThe: bounds.width,
            chieuCaoKhung: bounds.height,
            xemDuKien: xemDuKienHienTai
        )
        nhanTen.font = .systemFont(ofSize: bc.coChuTen, weight: .bold)
        nhanPhanTram.font = .monospacedDigitSystemFont(ofSize: xemDuKienHienTai ? 20 : bc.coChu, weight: .bold)
        nhanConThieu.font = .systemFont(ofSize: bc.coChu, weight: .semibold)
        nhanConThieu.textAlignment = bc.canPhaiConThieu ? .right : .left
        if xemDuKienHienTai {
            let buocDong = Self.caoNhanChiSo + Self.caoSoChiSo + Self.khoangChiSo
            for i in nhanChiSoDuKien.indices {
                let cot = i < 2 ? bc.khungThucHien : bc.khungConThieu
                let y = cot.minY + CGFloat(i % 2) * buocDong
                nhanChiSoDuKien[i].frame = CGRect(x: cot.minX, y: y, width: cot.width, height: Self.caoNhanChiSo)
                soChiSoDuKien[i].frame = CGRect(x: cot.minX, y: y + Self.caoNhanChiSo, width: cot.width, height: Self.caoSoChiSo)
            }
        } else {
            capNhatChuoiThucHien(dong: dong, coChu: bc.coChu)
        }

        vachTrai.frame = .zero
        nhanTen.frame = bc.khungTen
        nhanPhanTram.frame = bc.khungPhanTram
        nhanDonVi.frame = bc.khungDonVi
        nhanDuKien.frame = bc.khungNhanDuKien
        nhanThucHienTarget.frame = bc.khungThucHien
        nhanConThieu.frame = bc.khungConThieu
        thanhNenTienDo.frame = bc.khungThanhTienDo

        let thanh = bc.khungThanhTienDo
        let tienDoThuc = CGFloat(min(1.25, max(0, dong.phanTramHT / 100))) / 1.25
        let xMoc = min(thanh.maxX - 5, max(thanh.minX + 5, thanh.minX + thanh.width * tienDoThuc))
        mocThucHien.frame = CGRect(x: xMoc - 5, y: thanh.minY - 9, width: 10, height: 9)
        mocTarget.frame = CGRect(x: thanh.minX + thanh.width / 1.25, y: thanh.minY, width: 1, height: thanh.height)

        let rongTienDo = bc.khungThanhTienDo.width * min(1.0, max(0.0, tyLeTienDoHienTai))
        thanhMauTienDo.frame = CGRect(x: 0, y: 0, width: rongTienDo, height: bc.khungThanhTienDo.height)
    }

    static func tinhChieuCaoThe(cho dong: DongThiDua, rongThe: CGFloat, xemDuKien: Bool) -> CGFloat {
        tinhBoCuc(cho: dong, rongThe: rongThe, chieuCaoKhung: nil, xemDuKien: xemDuKien).tongChieuCao
    }

    private func capNhatChuoiThucHien(dong: DongThiDua, coChu: CGFloat) {
        let pWrap = NSMutableParagraphStyle()
        pWrap.lineBreakMode = .byWordWrapping
        let chuoiDam = dong.thucHien.chuoiSoVN
        let chuoiMo = " / \(dong.target.chuoiSoVN) \(dong.loaiChiTieu.maThe)"
        let mauThucHien: UIColor = dong.thucHien < 0 ? BangMauBCTD.doYeuChu : UIColor.label
        let attr = NSMutableAttributedString(
            string: chuoiDam,
            attributes: [
                .font: UIFont.systemFont(ofSize: coChu, weight: .bold),
                .foregroundColor: mauThucHien,
                .paragraphStyle: pWrap
            ]
        )
        attr.append(NSAttributedString(
            string: chuoiMo,
            attributes: [
                .font: UIFont.systemFont(ofSize: coChu, weight: .semibold),
                .foregroundColor: UIColor.secondaryLabel,
                .paragraphStyle: pWrap
            ]
        ))
        nhanThucHienTarget.attributedText = attr
    }

    func gan(_ dong: DongThiDua, xemDuKien: Bool = false) {
        self.dongHienTai = dong
        self.xemDuKienHienTai = xemDuKien

        nhanTen.text = KhoDuLieu.apDungLocTuCaiDat(dong.tenNganhHang)
        let pt = xemDuKien ? dong.phanTramDuBao : dong.phanTramHT
        nhanPhanTram.text = pt.chuoiPhanTramVN
        nhanPhanTram.textAlignment = xemDuKien ? .left : .center
        nhanDonVi.text = dong.loaiChiTieu.maBang
        nhanDonVi.isHidden = !xemDuKien
        nhanDuKien.isHidden = !xemDuKien
        mocThucHien.isHidden = !xemDuKien
        mocTarget.isHidden = !xemDuKien
        nhanThucHienTarget.isHidden = xemDuKien
        nhanConThieu.isHidden = xemDuKien
        for label in nhanChiSoDuKien + soChiSoDuKien {
            label.isHidden = !xemDuKien
        }

        let mauTT = BangMauBCTD.mauTrangThai(phanTram: pt)
        // Nền trạng thái đậm hơn một nhịp để các môn dễ phân biệt; bỏ vạch trái.
        khungThe.backgroundColor = mauTT.pill.withAlphaComponent(xemDuKien ? 0.34 : 0.58)
        vachTrai.backgroundColor = .clear
        vachTrai.isHidden = true
        nhanPhanTram.backgroundColor = xemDuKien ? .clear : mauTT.pill
        nhanPhanTram.textColor = mauTT.chu
        thanhMauTienDo.backgroundColor = mauTT.vach

        if xemDuKien {
            let nhanDK = dong.loaiChiTieu == .doanhThu ? "DT DỰ KIẾN" : "SL DỰ KIẾN"
            let tieuDe = ["THỰC HIỆN", "% HT THÁNG", "TARGET", nhanDK]
            let giaTri = [dong.thucHien.chuoiSoVN, dong.phanTramHT.chuoiPhanTramVN, dong.target.chuoiSoVN, dong.duKien.chuoiSoVN]
            for i in tieuDe.indices {
                nhanChiSoDuKien[i].text = tieuDe[i]
                soChiSoDuKien[i].text = giaTri[i]
                soChiSoDuKien[i].textColor = i == 3 && dong.phanTramDuBao >= 100 ? BangMauBCTD.xanhDatChu : BangMauBCTD.chuChinh
            }
        } else {
            if dong.conThieu > 0.005 {
                nhanConThieu.text = "Còn: \(dong.conThieu.chuoiSoVN)"
                nhanConThieu.textColor = .secondaryLabel
            } else {
                nhanConThieu.text = "Vượt: \(dong.vuotMuc.chuoiSoVN)"
                nhanConThieu.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
            }
        }

        tyLeTienDoHienTai = CGFloat(min(1.0, max(0, pt / (xemDuKien ? 125 : 100))))
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - BangThiDuaView (Hỗ trợ cả 2 mẫu: Bảng 8 cột & Thẻ tiến độ gọn + Nút "% dự kiến" riêng ở Tab Lũy kế)

final class BangThiDuaView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    var khiChonDong: ((DongThiDua) -> Void)?
    var khiSuaDong: ((DongThiDua) -> Void)?
    var khiXoaDong: ((UUID) -> Void)?
    var khiBamQuetAnh: (() -> Void)?
    var khiDoiCheDoDuKien: ((Bool) -> Void)?

    private var danhSachGoc: [DongThiDua] = []
    private var danhSachHienThi: [DongThiDua] = []
    private(set) var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private(set) var dangXemDuKien: Bool = false
    var hieuLucXemDuKien: Bool {
        cheDoDoanhThu == .luyKe && dangXemDuKien
    }

    private var boLoc: BoLocThiDua = .tatCa
    private static let khoaKieuSapXepThiDua = "dmx.thiDua.kieuSapXep"
    private var kieuSapXep: KieuSapXepThiDua = {
        if UserDefaults.standard.object(forKey: BangThiDuaView.khoaKieuSapXepThiDua) != nil,
           let luu = KieuSapXepThiDua(rawValue: UserDefaults.standard.integer(forKey: BangThiDuaView.khoaKieuSapXepThiDua)) {
            return luu
        }
        return .phanTramCaoThap
    }()
    private static let khoaSoCotTrenDienThoai = "dmx.thiDua.soCotTrenDienThoai"
    private var soCotTrenDienThoai = UserDefaults.standard.integer(forKey: BangThiDuaView.khoaSoCotTrenDienThoai) == 2 ? 2 : 1
    private let tieuDeTrong = UILabel()
    private let phuDeTrong = UILabel()

    private let chieuRongCot: [CGFloat] = [42, 224, 52, 92, 92, 96, 88, 88]
    private var tongChieuRongBang: CGFloat { chieuRongCot.reduce(0, +) }

    private let chonBoLoc = UISegmentedControl(items: ["Tất cả", "Đạt", "Chưa đạt"])
    private let nutChonMonTheoDoi = UIButton(type: .system)
    private let nutPhanTramDuKien = UIButton(type: .system)
    private let nutSapXep = UIButton(type: .system)
    private let nutSoCot = UIButton(type: .system)

    private let cuonNgang = UIScrollView()
    private let bang8Cot = UITableView(frame: .zero, style: .plain)

    private lazy var luoi: UICollectionView = {
        let boCuc = UICollectionViewFlowLayout()
        boCuc.minimumLineSpacing = 5
        boCuc.minimumInteritemSpacing = 6
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

    private func cauHinhNutDieuKhien(_ nut: UIButton) {
        nut.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nut.titleLabel?.numberOfLines = 0
        nut.titleLabel?.lineBreakMode = .byWordWrapping
        nut.titleLabel?.textAlignment = .center
        nut.titleLabel?.adjustsFontSizeToFitWidth = false
        nut.layer.cornerRadius = 8
        nut.layer.borderWidth = 1
        nut.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    }

    private func taoGiaoDien() {
        backgroundColor = .clear

        chonBoLoc.selectedSegmentIndex = 0
        chonBoLoc.apportionsSegmentWidthsByContent = false
        chonBoLoc.backgroundColor = BangMauBCTD.nenThePhu
        chonBoLoc.selectedSegmentTintColor = BangMauBCTD.nenMenuToi
        chonBoLoc.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.5, weight: .semibold),
            .foregroundColor: BangMauBCTD.chuPhu
        ], for: .normal)
        chonBoLoc.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
            .foregroundColor: BangMauBCTD.vangChuDao
        ], for: .selected)
        chonBoLoc.addTarget(self, action: #selector(doiBoLoc), for: .valueChanged)

        cauHinhNutDieuKhien(nutChonMonTheoDoi)
        nutChonMonTheoDoi.backgroundColor = BangMauBCTD.nenThePhu
        nutChonMonTheoDoi.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutChonMonTheoDoi.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutChonMonTheoDoi.showsMenuAsPrimaryAction = false
        nutChonMonTheoDoi.addTarget(self, action: #selector(moBangChonMonTheoDoi), for: .touchUpInside)
        nutChonMonTheoDoi.widthAnchor.constraint(equalToConstant: 112).isActive = true
        capNhatMenuMonTheoDoi()

        nutPhanTramDuKien.setTitle("% dự kiến", for: .normal)
        cauHinhNutDieuKhien(nutPhanTramDuKien)
        nutPhanTramDuKien.addTarget(self, action: #selector(doiCheDoXemDuKien), for: .touchUpInside)
        capNhatGiaoDienNutDuKien()

        nutSapXep.setTitle("⇅ \(kieuSapXep.nhanNgan)", for: .normal)
        cauHinhNutDieuKhien(nutSapXep)
        nutSapXep.backgroundColor = BangMauBCTD.nenThePhu
        nutSapXep.tintColor = BangMauBCTD.chuChinh
        nutSapXep.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutSapXep.addTarget(self, action: #selector(bamMoMenuSapXep), for: .touchUpInside)

        capNhatNutSoCot()
        cauHinhNutDieuKhien(nutSoCot)
        nutSoCot.backgroundColor = BangMauBCTD.nenThePhu
        nutSoCot.tintColor = BangMauBCTD.chuChinh
        nutSoCot.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutSoCot.addTarget(self, action: #selector(doiSoCot), for: .touchUpInside)

        let hangNutPhu = UIStackView(arrangedSubviews: [nutPhanTramDuKien, nutSapXep, nutSoCot])
        hangNutPhu.axis = .horizontal
        hangNutPhu.spacing = 6
        hangNutPhu.distribution = .fillEqually

        let hangLocVaMon = UIStackView(arrangedSubviews: [chonBoLoc, nutChonMonTheoDoi])
        hangLocVaMon.axis = .horizontal
        hangLocVaMon.spacing = 6

        let thanhDieuKhien = UIStackView(arrangedSubviews: [hangLocVaMon, hangNutPhu])
        thanhDieuKhien.axis = .vertical
        thanhDieuKhien.spacing = 6

        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.showsVerticalScrollIndicator = false
        cuonNgang.bounces = false
        cuonNgang.layer.cornerRadius = 12
        cuonNgang.clipsToBounds = true
        cuonNgang.backgroundColor = .systemBackground

        bang8Cot.dataSource = self
        bang8Cot.delegate = self
        bang8Cot.rowHeight = 56
        bang8Cot.sectionHeaderHeight = 42
        bang8Cot.separatorStyle = .singleLine
        bang8Cot.separatorInset = .zero
        bang8Cot.backgroundColor = .systemBackground
        if #available(iOS 15.0, *) {
            bang8Cot.sectionHeaderTopPadding = 0
        }
        bang8Cot.translatesAutoresizingMaskIntoConstraints = false
        cuonNgang.addSubview(bang8Cot)

        khungTrong.backgroundColor = .secondarySystemGroupedBackground
        khungTrong.layer.cornerRadius = 14
        khungTrong.addTarget(self, action: #selector(bamQuet), for: .touchUpInside)

        let iconTrong = UIImageView(image: UIImage(systemName: "camera.viewfinder"))
        iconTrong.tintColor = .systemBlue
        iconTrong.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 42, weight: .regular)

        tieuDeTrong.text = "Chưa có số Thi đua (Lũy kế)"
        tieuDeTrong.font = .systemFont(ofSize: 15, weight: .bold)
        tieuDeTrong.textAlignment = .center
        tieuDeTrong.numberOfLines = 0
        tieuDeTrong.lineBreakMode = .byWordWrapping

        phuDeTrong.text = "Chạm cụm doanh thu để mở tùy chọn nhập ảnh."
        phuDeTrong.font = .systemFont(ofSize: 12.5, weight: .regular)
        phuDeTrong.textColor = .secondaryLabel
        phuDeTrong.textAlignment = .center
        phuDeTrong.numberOfLines = 0
        phuDeTrong.lineBreakMode = .byWordWrapping

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
            chonBoLoc.heightAnchor.constraint(equalToConstant: 30),
            hangNutPhu.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),

            thanhDieuKhien.topAnchor.constraint(equalTo: topAnchor),
            thanhDieuKhien.leadingAnchor.constraint(equalTo: leadingAnchor),
            thanhDieuKhien.trailingAnchor.constraint(equalTo: trailingAnchor),

            cuonNgang.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 6),
            cuonNgang.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuonNgang.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuonNgang.bottomAnchor.constraint(equalTo: bottomAnchor),

            bang8Cot.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            bang8Cot.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            bang8Cot.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            bang8Cot.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            bang8Cot.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),
            bang8Cot.widthAnchor.constraint(equalToConstant: tongChieuRongBang),

            luoi.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 6),
            luoi.leadingAnchor.constraint(equalTo: leadingAnchor),
            luoi.trailingAnchor.constraint(equalTo: trailingAnchor),
            luoi.bottomAnchor.constraint(equalTo: bottomAnchor),

            khungTrong.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 6),
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

    private func capNhatGiaoDienNutDuKien() {
        nutPhanTramDuKien.isHidden = (cheDoDoanhThu != .luyKe)
        if hieuLucXemDuKien {
            nutPhanTramDuKien.backgroundColor = BangMauBCTD.nenMenuToi
            nutPhanTramDuKien.tintColor = BangMauBCTD.vangChuDao
            nutPhanTramDuKien.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        } else {
            nutPhanTramDuKien.backgroundColor = BangMauBCTD.nenThePhu
            nutPhanTramDuKien.tintColor = BangMauBCTD.chuChinh
            nutPhanTramDuKien.layer.borderColor = BangMauBCTD.vienDam.cgColor
        }
    }

    @objc private func doiCheDoXemDuKien() {
        guard cheDoDoanhThu == .luyKe else { return }
        dangXemDuKien.toggle()
        capNhatGiaoDienNutDuKien()
        capNhatDanhSach()
        khiDoiCheDoDuKien?(hieuLucXemDuKien)
    }

    @objc private func bamMoMenuSapXep() {
        guard let vc = timViewControllerCha() else { return }
        var cacMuc: [MucChonDMX] = KieuSapXepThiDua.allCases.map { kieu in
            MucChonDMX(tieuDe: kieu.nhan, dangChon: kieu == kieuSapXep) { [weak self] in
                guard let self else { return }
                self.kieuSapXep = kieu
                UserDefaults.standard.set(kieu.rawValue, forKey: Self.khoaKieuSapXepThiDua)
                self.nutSapXep.setTitle("⇅ \(kieu.nhanNgan)", for: .normal)
                self.capNhatDanhSach()
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        vc.hienMenuChon(tieuDe: "Sắp xếp ngành hàng", cacMuc: cacMuc)
    }

    func ganDanhSach(_ ds: [DongThiDua], cheDo: LoaiCheDoDoanhThu = .luyKe) {
        cheDoDoanhThu = cheDo
        danhSachGoc = KhoDuLieu.gopDanhSachThiDua(cu: [], moi: ds)
        capNhatGiaoDienNutDuKien()
        capNhatMenuMonTheoDoi()
        capNhatDanhSach()
    }

    private func khoaTheoDoi(_ dong: DongThiDua) -> String {
        KhoDuLieu.chuanHoaKhoaLienMachThiDua(dong.tenNganhHangGoc.isEmpty ? dong.tenNganhHang : dong.tenNganhHangGoc)
    }

    private func locTheoMonDaChon(_ danhSach: [DongThiDua], cheDo: LoaiCheDoDoanhThu? = nil) -> [DongThiDua] {
        let tap = Set(KhoDuLieu.dungChung.caiDat.khoaMonTheoDoi(cho: cheDo ?? cheDoDoanhThu))
        guard !tap.isEmpty else { return danhSach }
        return danhSach.filter { tap.contains(khoaTheoDoi($0)) }
    }

    private func capNhatMenuMonTheoDoi() {
        let cacMon = Dictionary(grouping: danhSachGoc) { self.khoaTheoDoi($0) }
            .compactMap { khoa, ds -> (String, String)? in
                guard !khoa.isEmpty, let ten = ds.first?.tenNganhHang else { return nil }
                return (khoa, ten)
            }
            .sorted { tenDeSapXep($0.1).localizedCaseInsensitiveCompare(tenDeSapXep($1.1)) == .orderedAscending }
        let daLuu = Set(KhoDuLieu.dungChung.caiDat.khoaMonTheoDoi(cho: cheDoDoanhThu))
        let soChon = daLuu.isEmpty ? cacMon.count : daLuu.filter { $0 != CaiDatDMX.khoaKhongChonMonThiDua }.count
        let nhan = soChon >= cacMon.count ? "Tất cả môn" : "Đã chọn \(soChon)/\(cacMon.count)"
        nutChonMonTheoDoi.setTitle("\(nhan) ▾", for: .normal)
    }

    @objc private func moBangChonMonTheoDoi() {
        let cacMon = Dictionary(grouping: danhSachGoc) { self.khoaTheoDoi($0) }
            .compactMap { khoa, ds -> ManHinhChonMonThiDua.Muc? in
                guard !khoa.isEmpty, let ten = ds.first?.tenNganhHang else { return nil }
                return .init(khoa: khoa, ten: ten)
            }
            .sorted { tenDeSapXep($0.ten).localizedCaseInsensitiveCompare(tenDeSapXep($1.ten)) == .orderedAscending }
        guard !cacMon.isEmpty, let vcCha = timViewControllerCha() else { return }

        let daLuu = Set(KhoDuLieu.dungChung.caiDat.khoaMonTheoDoi(cho: cheDoDoanhThu))
        let dangChon = daLuu.isEmpty ? Set(cacMon.map(\.khoa)) : Set(daLuu.filter { $0 != CaiDatDMX.khoaKhongChonMonThiDua })
        let hop = ManHinhChonMonThiDua(cacMuc: cacMon, dangChon: dangChon, cheDo: cheDoDoanhThu)
        hop.khiThayDoi = { [weak self] tap in
            guard let self else { return }
            var cd = KhoDuLieu.dungChung.caiDat
            let tatCa = Set(cacMon.map(\.khoa))
            let giaTriLuu: [String]
            if tap == tatCa { giaTriLuu = [] }
            else if tap.isEmpty { giaTriLuu = [CaiDatDMX.khoaKhongChonMonThiDua] }
            else { giaTriLuu = Array(tap).sorted() }
            cd.ganKhoaMonTheoDoi(giaTriLuu, cho: self.cheDoDoanhThu)
            KhoDuLieu.dungChung.luuCaiDat(cd)
            NotificationCenter.default.post(name: .yeuCauTaoLaiAnhBaoCaoBot, object: nil)
            self.capNhatMenuMonTheoDoi()
            self.capNhatDanhSach()
        }
        if let sheet = hop.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        vcCha.present(hop, animated: true)
    }

    private func locVaSapXep(_ dsGoc: [DongThiDua], xemDuKien: Bool? = nil, cheDoLoc: LoaiCheDoDoanhThu? = nil) -> [DongThiDua] {
        let xemDK = xemDuKien ?? hieuLucXemDuKien
        var tam = locTheoMonDaChon(dsGoc, cheDo: cheDoLoc)
        switch boLoc {
        case .tatCa: break
        case .daDat: tam = tam.filter { xemDK ? $0.daHoanThanhDuBao : $0.daDat }
        case .chuaDat: tam = tam.filter { xemDK ? !$0.daHoanThanhDuBao : !$0.daDat }
        }

        switch kieuSapXep {
        case .phanTramCaoThap:
            tam.sort { (xemDK ? $0.phanTramDuBao : $0.phanTramHT) > (xemDK ? $1.phanTramDuBao : $1.phanTramHT) }
        case .phanTramThapCao:
            tam.sort { (xemDK ? $0.phanTramDuBao : $0.phanTramHT) < (xemDK ? $1.phanTramDuBao : $1.phanTramHT) }
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
        capNhatGiaoDienNutDuKien()
        let xemDK = hieuLucXemDuKien
        let danhSachTheoDoi = locTheoMonDaChon(danhSachGoc)
        let tong = danhSachTheoDoi.count
        let soDat = danhSachTheoDoi.filter { xemDK ? $0.daHoanThanhDuBao : $0.daDat }.count
        let soChuaDat = tong - soDat

        chonBoLoc.setTitle("Tất cả (\(tong))", forSegmentAt: 0)
        chonBoLoc.setTitle("Đạt (\(soDat))", forSegmentAt: 1)
        chonBoLoc.setTitle("Chưa đạt (\(soChuaDat))", forSegmentAt: 2)
        chonBoLoc.damBaoHienThiDayDuText()

        let nhanCheDo = (cheDoDoanhThu == .luyKe) ? "Lũy kế" : "Realtime"
        tieuDeTrong.text = "Chưa có số Thi đua (\(nhanCheDo))"

        danhSachHienThi = locVaSapXep(danhSachGoc, xemDuKien: xemDK)
        let kieu: KieuHienThiBaoCao = xemDK ? .theGon : KhoDuLieu.dungChung.caiDat.kieuHienThi
        let trong = danhSachGoc.isEmpty

        khungTrong.isHidden = !trong
        cuonNgang.isHidden = trong || (kieu != .bangChiTiet)
        luoi.isHidden = trong || (kieu != .theGon)
        nutSoCot.isHidden = (kieu != .theGon)

        if !trong {
            if kieu == .bangChiTiet {
                bang8Cot.reloadData()
            } else {
                luoi.collectionViewLayout.invalidateLayout()
                luoi.reloadData()
            }
        }
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
        UserDefaults.standard.set(soCotTrenDienThoai, forKey: Self.khoaSoCotTrenDienThoai)
        capNhatNutSoCot()
        luoi.collectionViewLayout.invalidateLayout()
        luoi.reloadData()
    }

    private func capNhatNutSoCot() {
        let icon = (soCotTrenDienThoai == 1) ? "rectangle.grid.1x2" : "square.grid.2x2"
        nutSoCot.setTitle(" \(soCotTrenDienThoai) cột", for: .normal)
        nutSoCot.setImage(UIImage(systemName: icon), for: .normal)
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
        cell.gan(danhSachHienThi[indexPath.item], xemDuKien: hieuLucXemDuKien)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard danhSachHienThi.indices.contains(indexPath.item) else { return }
        khiChonDong?(danhSachHienThi[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rong = collectionView.bounds.width
        let dong = danhSachHienThi[indexPath.item]
        let xemDK = hieuLucXemDuKien
        if soCotTrenDienThoai == 2 {
            let rongCot = floor((rong - 6) / 2.0)
            // Hai ô cùng 1 hàng luôn có kích thước (chiều rộng & chiều cao) bằng nhau theo ô cao hơn trong hàng
            let chiSoDauHang = (indexPath.item / 2) * 2
            let chiSoCuoiHang = min(danhSachHienThi.count - 1, chiSoDauHang + 1)
            let cao1 = OTheThiDuaCell.tinhChieuCaoThe(cho: danhSachHienThi[chiSoDauHang], rongThe: rongCot, xemDuKien: xemDK)
            let cao2 = OTheThiDuaCell.tinhChieuCaoThe(cho: danhSachHienThi[chiSoCuoiHang], rongThe: rongCot, xemDuKien: xemDK)
            return CGSize(width: rongCot, height: max(cao1, cao2))
        }
        let cao = OTheThiDuaCell.tinhChieuCaoThe(cho: dong, rongThe: rong, xemDuKien: xemDK)
        return CGSize(width: rong, height: cao)
    }

    // MARK: - Mẫu 1: UITableView (Bảng 8 cột chi tiết — tự mở rộng chiều cao dòng khi chữ nhiều, cỡ chữ đồng nhất, không bao giờ "...")

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachHienThi.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        taoDongTieuDeCot(cheDo: cheDoDoanhThu, xemDuKien: hieuLucXemDuKien)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dong = danhSachHienThi[indexPath.row]
        return tinhChieuCaoDong8Cot(dong: dong, hienNhanNV: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongBang8CotCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .default
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let dong = danhSachHienThi[indexPath.row]
        let caoDong = tinhChieuCaoDong8Cot(dong: dong, hienNhanNV: true)
        let viewDong = taoViewDongDuLieu8Cot(
            stt: indexPath.row + 1,
            dong: dong,
            chieuCao: caoDong,
            hienNhanNV: true,
            xemDuKien: hieuLucXemDuKien
        )
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
        guard danhSachHienThi.indices.contains(indexPath.row) else { return }
        khiChonDong?(danhSachHienThi[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard danhSachHienThi.indices.contains(indexPath.row) else { return nil }
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

    private func tinhChieuCaoDong8Cot(dong: DongThiDua, hienNhanNV: Bool) -> CGFloat {
        let rongTen = chieuRongCot[1] - 12
        let fontTen = UIFont.systemFont(ofSize: 14.5, weight: .bold)
        let rectTen = (dong.tenNganhHang as NSString).boundingRect(
            with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTen],
            context: nil
        )
        let caoTen = ceil(rectTen.height)
        if hienNhanNV {
            let soNVGiao = KhoDuLieu.dungChung.danhSachMaNVChiaTarget(cho: dong).count
            let moiNV = soNVGiao > 0 ? (dong.target / Double(soNVGiao)) : 0
            let chuoiNV = "👥 \(soNVGiao) NV (\(String(format: "%.1f", moiNV))/NV)"
            let rectNV = (chuoiNV as NSString).boundingRect(
                with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: fontTen],
                context: nil
            )
            let caoNV = max(18, ceil(rectNV.height))
            return max(58, caoTen + caoNV + 16)
        } else {
            return max(52, caoTen + 18)
        }
    }

    private func taoDongTieuDeCot(cheDo: LoaiCheDoDoanhThu? = nil, xemDuKien: Bool = false) -> UIView {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 42))
        khung.backgroundColor = BangMauBCTD.nenHeaderBang

        let cheDoHienThi = cheDo ?? cheDoDoanhThu
        let tieuDe: [String]
        if cheDoHienThi == .luyKe && xemDuKien {
            tieuDe = ["STT", "NGÀNH HÀNG (BẤM XEM NV)", "ĐVT", "THỰC HIỆN", "TARGET", "% HT THÁNG", "DT/SL DỰ KIẾN", "% DỰ KIẾN"]
        } else {
            let cotHT = (cheDoHienThi == .luyKe) ? "% HT THÁNG" : "% HT NGÀY"
            tieuDe = ["STT", "NGÀNH HÀNG (BẤM XEM NV)", "ĐVT", "THỰC HIỆN", "TARGET", "THIẾU/VƯỢT", cotHT, "% DỰ KIẾN"]
        }
        var xHienTai: CGFloat = 0

        for (i, chu) in tieuDe.enumerated() {
            let rong = chieuRongCot[i]
            let nhan = UILabel(frame: CGRect(x: xHienTai + 4, y: 2, width: rong - 8, height: 37))
            nhan.text = chu
            nhan.font = .systemFont(ofSize: 12.0, weight: .bold)
            nhan.textColor = ((xemDuKien && i == 7) || (!xemDuKien && i == 6)) ? BangMauBCTD.vangChuDao : .white
            nhan.numberOfLines = 0
            nhan.lineBreakMode = .byWordWrapping
            nhan.adjustsFontSizeToFitWidth = false
            nhan.textAlignment = (i == 1) ? .left : .center
            khung.addSubview(nhan)

            xHienTai += rong
            if i < tieuDe.count - 1 {
                let vach = UIView(frame: CGRect(x: xHienTai, y: 0, width: 0.5, height: 42))
                vach.backgroundColor = UIColor.white.withAlphaComponent(0.14)
                khung.addSubview(vach)
            }
        }

        let vachDuoi = UIView(frame: CGRect(x: 0, y: 39.5, width: tongChieuRongBang, height: 2.5))
        vachDuoi.backgroundColor = BangMauBCTD.vangChuDao
        khung.addSubview(vachDuoi)
        return khung
    }

    private func taoViewDongDuLieu8Cot(
        stt: Int,
        dong: DongThiDua,
        chieuCao: CGFloat = 52,
        hienNhanNV: Bool = false,
        xemDuKien: Bool = false
    ) -> UIView {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: chieuCao))
        let ttHT = BangMauBCTD.mauTrangThai(phanTram: dong.phanTramHT)
        let ttDuBao = BangMauBCTD.mauTrangThai(phanTram: dong.phanTramDuBao)
        let ttChinh = xemDuKien ? ttDuBao : ttHT

        khung.backgroundColor = ttChinh.pill.withAlphaComponent(0.58)

        let mauChuChinh: UIColor = BangMauBCTD.chuChinh
        let mauChuHT: UIColor = ttHT.chu
        let mauNenHT: UIColor = ttHT.pill
        let mauChuDuBao: UIColor = ttDuBao.chu
        let mauNenDuBao: UIColor = ttDuBao.pill

        let giaTriCot: [String]
        if xemDuKien {
            giaTriCot = [
                "\(stt)",
                dong.tenNganhHang,
                dong.loaiChiTieu.maBang,
                dong.thucHien.chuoiSoLieu,
                dong.target.chuoiSoLieu,
                dong.phanTramHT.chuoiPhanTram,
                dong.duKien.chuoiSoLieu,
                dong.phanTramDuBao.chuoiPhanTram
            ]
        } else {
            giaTriCot = [
                "\(stt)",
                dong.tenNganhHang,
                dong.loaiChiTieu.maBang,
                dong.thucHien.chuoiSoLieu,
                dong.target.chuoiSoLieu,
                dong.chenhLech.chuoiChenhLech,
                dong.phanTramHT.chuoiPhanTram,
                dong.phanTramDuBao.chuoiPhanTram
            ]
        }

        let soNVGiao = KhoDuLieu.dungChung.danhSachMaNVChiaTarget(cho: dong).count
        let moiNV = soNVGiao > 0 ? (dong.target / Double(soNVGiao)) : 0

        // Các cột dùng cỡ chữ lớn, đồng nhất, tự xuống dòng và không bao giờ "..."
        let fontDongNhat = UIFont.monospacedDigitSystemFont(ofSize: 14.5, weight: .bold)
        let fontChuDongNhat = UIFont.systemFont(ofSize: 14.5, weight: .bold)

        var xHienTai: CGFloat = 0
        for i in 0..<giaTriCot.count {
            let rong = chieuRongCot[i]
            let khungO = CGRect(x: xHienTai, y: 0, width: rong, height: chieuCao)

            let laCotPhanTram = xemDuKien ? (i == 5 || i == 7) : (i == 6 || i == 7)
            if laCotPhanTram {
                let badge = UILabel(frame: khungO.insetBy(dx: 5, dy: max(4, (chieuCao - 30) / 2)))
                badge.text = giaTriCot[i]
                badge.font = fontDongNhat
                badge.textAlignment = .center
                badge.numberOfLines = 0
                badge.lineBreakMode = .byWordWrapping
                badge.adjustsFontSizeToFitWidth = false
                if xemDuKien {
                    badge.textColor = (i == 7) ? mauChuDuBao : mauChuHT
                    badge.backgroundColor = (i == 7) ? mauNenDuBao : mauNenHT
                } else {
                    badge.textColor = (i == 6) ? mauChuHT : mauChuDuBao
                    badge.backgroundColor = (i == 6) ? mauNenHT : mauNenDuBao
                }
                badge.layer.cornerRadius = 6
                badge.clipsToBounds = true
                khung.addSubview(badge)
            } else if i == 1 && hienNhanNV {
                let chuoiNV = "👥 \(soNVGiao) NV (\(String(format: "%.1f", moiNV))/NV)"
                let rectNV = (chuoiNV as NSString).boundingRect(
                    with: CGSize(width: rong - 12, height: CGFloat.greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: [.font: fontChuDongNhat],
                    context: nil
                )
                let caoNV = max(18, ceil(rectNV.height))
                let caoTen = max(20, chieuCao - caoNV - 10)

                let lbTen = UILabel(frame: CGRect(x: xHienTai + 6, y: 4, width: rong - 12, height: caoTen))
                lbTen.text = dong.tenNganhHang
                lbTen.font = fontChuDongNhat
                lbTen.textColor = mauChuChinh
                lbTen.numberOfLines = 0
                lbTen.lineBreakMode = .byWordWrapping
                lbTen.adjustsFontSizeToFitWidth = false

                let lbNV = UILabel(frame: CGRect(x: xHienTai + 6, y: chieuCao - caoNV - 4, width: rong - 12, height: caoNV))
                lbNV.text = chuoiNV
                lbNV.font = fontChuDongNhat
                lbNV.textColor = BangMauBCTD.indigoDam
                lbNV.numberOfLines = 0
                lbNV.lineBreakMode = .byWordWrapping
                lbNV.adjustsFontSizeToFitWidth = false

                khung.addSubview(lbTen)
                khung.addSubview(lbNV)
            } else {
                let nhan = UILabel(frame: khungO.insetBy(dx: 6, dy: 4))
                nhan.text = giaTriCot[i]
                nhan.numberOfLines = 0
                nhan.lineBreakMode = .byWordWrapping
                nhan.adjustsFontSizeToFitWidth = false
                if i == 1 {
                    nhan.font = fontChuDongNhat
                    nhan.textAlignment = .left
                    nhan.textColor = mauChuChinh
                } else if i == 0 {
                    nhan.font = fontDongNhat
                    nhan.textAlignment = .center
                    nhan.textColor = BangMauBCTD.indigoDam
                } else if i == 2 {
                    nhan.font = fontDongNhat
                    nhan.textAlignment = .center
                    nhan.textColor = BangMauBCTD.chuMo
                } else if i == 5 {
                    nhan.font = fontDongNhat
                    nhan.textAlignment = .right
                    nhan.textColor = xemDuKien ? mauChuDuBao : mauChuHT
                } else if i == 3 && dong.thucHien < 0 {
                    nhan.font = fontDongNhat
                    nhan.textAlignment = .right
                    nhan.textColor = BangMauBCTD.doYeuChu
                } else {
                    nhan.font = fontDongNhat
                    nhan.textAlignment = .right
                    nhan.textColor = mauChuChinh
                }
                khung.addSubview(nhan)
            }

            xHienTai += rong
            if i < giaTriCot.count - 1 {
                let vach = UIView(frame: CGRect(x: xHienTai, y: 0, width: 0.5, height: chieuCao))
                vach.backgroundColor = BangMauBCTD.vienThe
                khung.addSubview(vach)
            }
        }
        return khung
    }

    // MARK: - Xuất Ảnh Báo Cáo Thi Đua (Các dòng text có cùng cỡ chữ, tự xuống dòng đầy đủ, không có dấu "...")

    func taoAnhBaoCao(
        ngay: Date,
        doanhThu: ThongTinDoanhThu,
        danhSach: [DongThiDua]? = nil,
        cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe,
        xemDuKien: Bool? = nil,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let xemDK = (cheDoDoanhThu == .luyKe) ? (xemDuKien ?? dangXemDuKien) : false
        let dsXuat = danhSach.map { locVaSapXep($0, xemDuKien: xemDK, cheDoLoc: cheDoDoanhThu) }
            ?? locVaSapXep(danhSachGoc, xemDuKien: xemDK, cheDoLoc: cheDoDoanhThu)
        let kieu: KieuHienThiBaoCao = xemDK ? .theGon : KhoDuLieu.dungChung.caiDat.kieuHienThi
        switch kieu {
        case .bangChiTiet:
            return taoAnhMauBang8Cot(
                ngay: ngay,
                doanhThu: doanhThu,
                danhSach: dsXuat,
                cheDoDoanhThu: cheDoDoanhThu,
                xemDuKien: xemDK,
                thongTinDonVi: thongTinDonVi,
                capNhatLuc: capNhatLuc
            )
        case .theGon:
            return taoAnhMauTheGon(
                ngay: ngay,
                doanhThu: doanhThu,
                danhSach: dsXuat,
                cheDoDoanhThu: cheDoDoanhThu,
                xemDuKien: xemDK,
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
        xemDuKien: Bool = false,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let ds = danhSach
        let soDat = ds.filter { xemDuKien ? $0.daHoanThanhDuBao : $0.daDat }.count
        let soKhongDat = ds.count - soDat

        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let nhanCheDo = (cheDoDoanhThu == .luyKe)
            ? (xemDuKien ? "LŨY KẾ (% DỰ KIẾN CUỐI THÁNG)" : "LŨY KẾ (THỰC HIỆN & TARGET)")
            : "REALTIME"

        let le: CGFloat = 16
        let chieuRongAnh = tongChieuRongBang + le * 2
        let rongNoiDung = chieuRongAnh - le * 2
        let chieuCaoHeaderCot: CGFloat = 42
        let cacChieuCaoDong: [CGFloat] = ds.isEmpty
            ? [52]
            : ds.map { tinhChieuCaoDong8Cot(dong: $0, hienNhanNV: false) }
        let tongCaoCacDong = cacChieuCaoDong.reduce(0, +)

        let chuPhu = "Ngày \(ngayStr)\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        let fontPhu = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        let caoPhu = max(20, ceil((chuPhu as NSString).boundingRect(
            with: CGSize(width: rongNoiDung, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontPhu],
            context: nil
        ).height))

        let chuTieuDe = "BẢNG TỔNG HỢP THI ĐUA — \(nhanCheDo)"
        let fontTieuDe = UIFont.systemFont(ofSize: 18.0, weight: .heavy)
        let caoTieuDeChinh = max(26, ceil((chuTieuDe as NSString).boundingRect(
            with: CGSize(width: rongNoiDung, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTieuDe],
            context: nil
        ).height))

        let nhanDat = xemDuKien ? "Đạt dự kiến" : "Đạt"
        let nhanChuaDat = xemDuKien ? "Chưa đạt dự kiến" : "Không đạt"
        let chuThongKe = "Tổng: \(ds.count) ngành hàng   •   \(nhanDat): \(soDat)   •   \(nhanChuaDat): \(soKhongDat)"
        let fontThongKe = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        let caoThongKe = max(22, ceil((chuThongKe as NSString).boundingRect(
            with: CGSize(width: rongNoiDung, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontThongKe],
            context: nil
        ).height))

        let banner = BangMauBCTD.taoHeaderBannerBaoCao(
            rong: chieuRongAnh,
            kicker: chuPhu,
            tieuDe: chuTieuDe,
            thongKePhu: chuThongKe
        )
        let chieuCaoDoanhThu: CGFloat = 272
        let chieuCaoDongThongKe = caoThongKe + 8
        let chieuCaoAnh = banner.chieuCao + 14 + chieuCaoDoanhThu + chieuCaoDongThongKe + chieuCaoHeaderCot + tongCaoCacDong + le

        let khungBaoCao = UIView(frame: CGRect(x: 0, y: 0, width: chieuRongAnh, height: chieuCaoAnh))
        khungBaoCao.backgroundColor = BangMauBCTD.nenTrang
        khungBaoCao.overrideUserInterfaceStyle = .light
        khungBaoCao.addSubview(banner.view)

        var yHienTai = banner.chieuCao + 14

        let cumChiSo = CumChiSoChinhView(coLon: true, anHangNutCheDo: true)
        cumChiSo.overrideUserInterfaceStyle = .light
        cumChiSo.frame = CGRect(x: le, y: yHienTai, width: rongNoiDung, height: 260)
        cumChiSo.capNhat(doanhThu: doanhThu, soNganhDat: soDat, tongSoNganh: ds.count, ngay: ngay, cheDo: cheDoDoanhThu)
        cumChiSo.layoutIfNeeded()
        khungBaoCao.addSubview(cumChiSo)
        yHienTai += chieuCaoDoanhThu

        let dongThongKe = UILabel(frame: CGRect(x: le, y: yHienTai, width: rongNoiDung, height: caoThongKe))
        dongThongKe.text = chuThongKe
        dongThongKe.font = fontThongKe
        dongThongKe.textColor = .darkGray
        dongThongKe.numberOfLines = 0
        dongThongKe.lineBreakMode = .byWordWrapping
        dongThongKe.adjustsFontSizeToFitWidth = false
        khungBaoCao.addSubview(dongThongKe)

        yHienTai += chieuCaoDongThongKe

        let khungBang = UIView(frame: CGRect(
            x: le,
            y: yHienTai,
            width: tongChieuRongBang,
            height: chieuCaoHeaderCot + tongCaoCacDong
        ))
        khungBang.layer.borderWidth = 1
        khungBang.layer.borderColor = UIColor.systemGray4.cgColor
        khungBang.layer.cornerRadius = 8
        khungBang.clipsToBounds = true
        khungBaoCao.addSubview(khungBang)

        let header = taoDongTieuDeCot(cheDo: cheDoDoanhThu, xemDuKien: xemDuKien)
        header.frame = CGRect(x: 0, y: 0, width: tongChieuRongBang, height: chieuCaoHeaderCot)
        khungBang.addSubview(header)

        if ds.isEmpty {
            let lbTrong = UILabel(frame: CGRect(x: 0, y: chieuCaoHeaderCot, width: tongChieuRongBang, height: 52))
            lbTrong.text = "Chưa có ngành hàng thi đua nào trong danh sách."
            lbTrong.font = .systemFont(ofSize: 12.5, weight: .medium)
            lbTrong.textColor = .gray
            lbTrong.textAlignment = .center
            lbTrong.numberOfLines = 0
            lbTrong.lineBreakMode = .byWordWrapping
            khungBang.addSubview(lbTrong)
        } else {
            var yDong = chieuCaoHeaderCot
            for (i, dong) in ds.enumerated() {
                let caoDong = cacChieuCaoDong[i]
                let vDong = taoViewDongDuLieu8Cot(stt: i + 1, dong: dong, chieuCao: caoDong, hienNhanNV: false, xemDuKien: xemDuKien)
                vDong.frame = CGRect(x: 0, y: yDong, width: tongChieuRongBang, height: caoDong)
                let vach = UIView(frame: CGRect(x: 0, y: caoDong - 0.5, width: tongChieuRongBang, height: 0.5))
                vach.backgroundColor = .systemGray4
                vDong.addSubview(vach)
                khungBang.addSubview(vDong)
                yDong += caoDong
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
        xemDuKien: Bool = false,
        thongTinDonVi: String,
        capNhatLuc: String
    ) -> UIImage? {
        let ds = danhSach
        let soDat = ds.filter { xemDuKien ? $0.daHoanThanhDuBao : $0.daDat }.count
        let soKhongDat = ds.count - soDat

        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let nhanCheDo = (cheDoDoanhThu == .luyKe)
            ? (xemDuKien ? "LŨY KẾ (% DỰ KIẾN CUỐI THÁNG)" : "LŨY KẾ (THỰC HIỆN & TARGET)")
            : "REALTIME"

        let soCot = max(1, min(4, KhoDuLieu.dungChung.caiDat.soCotXuatAnh))
        let le: CGFloat = 16
        let khoangCachO: CGFloat = 12
        let rongO: CGFloat = 330
        let rongAnh = max(780, le * 2 + CGFloat(soCot) * rongO + CGFloat(soCot - 1) * khoangCachO)
        let rongNoiDung = rongAnh - le * 2

        let soHang = Int(ceil(Double(ds.count) / Double(soCot)))
        var chieuCaoTungHang: [CGFloat] = []
        for h in 0..<soHang {
            var maxH: CGFloat = 88
            for c in 0..<soCot {
                let idx = h * soCot + c
                if idx < ds.count {
                    let hThe = OTheThiDuaCell.tinhChieuCaoThe(cho: ds[idx], rongThe: rongO, xemDuKien: xemDuKien)
                    maxH = max(maxH, hThe)
                }
            }
            chieuCaoTungHang.append(maxH)
        }

        let chuPhu = "Ngày \(ngayStr)\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        let fontPhu = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        let caoPhu = max(20, ceil((chuPhu as NSString).boundingRect(
            with: CGSize(width: rongNoiDung, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontPhu],
            context: nil
        ).height))

        let chuDau = "BẢNG TỔNG HỢP THI ĐUA — \(nhanCheDo)"
        let fontDau = UIFont.systemFont(ofSize: 18.0, weight: .heavy)
        let caoDau = max(26, ceil((chuDau as NSString).boundingRect(
            with: CGSize(width: rongNoiDung, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontDau],
            context: nil
        ).height))

        let nhanDat = xemDuKien ? "Đạt dự kiến" : "Đạt"
        let nhanChuaDat = xemDuKien ? "Chưa đạt dự kiến" : "Không đạt"
        let chuThongKe = "Tổng: \(ds.count) ngành hàng   •   \(nhanDat): \(soDat)   •   \(nhanChuaDat): \(soKhongDat)"
        let fontThongKe = UIFont.systemFont(ofSize: 12.5, weight: .semibold)
        let caoThongKe = max(22, ceil((chuThongKe as NSString).boundingRect(
            with: CGSize(width: rongNoiDung, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontThongKe],
            context: nil
        ).height))

        let banner = BangMauBCTD.taoHeaderBannerBaoCao(
            rong: rongAnh,
            kicker: chuPhu,
            tieuDe: chuDau,
            thongKePhu: chuThongKe
        )
        let caoPhanDoanhThu: CGFloat = 272
        let caoDongThongKe = caoThongKe + 8
        let caoLuoi = soHang > 0
            ? (chieuCaoTungHang.reduce(0, +) + CGFloat(max(0, soHang - 1)) * khoangCachO)
            : 48
        let caoAnh = banner.chieuCao + 14 + caoPhanDoanhThu + caoDongThongKe + caoLuoi + le

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khung.backgroundColor = BangMauBCTD.nenTrang
        khung.overrideUserInterfaceStyle = .light
        khung.addSubview(banner.view)

        var yHienTai: CGFloat = banner.chieuCao + 14

        let cumChiSo = CumChiSoChinhView(coLon: true, anHangNutCheDo: true)
        cumChiSo.overrideUserInterfaceStyle = .light
        cumChiSo.frame = CGRect(x: le, y: yHienTai, width: rongNoiDung, height: 260)
        cumChiSo.capNhat(doanhThu: doanhThu, soNganhDat: soDat, tongSoNganh: ds.count, ngay: ngay, cheDo: cheDoDoanhThu)
        cumChiSo.layoutIfNeeded()
        khung.addSubview(cumChiSo)
        yHienTai += caoPhanDoanhThu

        let dongThongKe = UILabel(frame: CGRect(x: le, y: yHienTai, width: rongNoiDung, height: caoThongKe))
        dongThongKe.text = chuThongKe
        dongThongKe.font = fontThongKe
        dongThongKe.textColor = .darkGray
        dongThongKe.numberOfLines = 0
        dongThongKe.lineBreakMode = .byWordWrapping
        dongThongKe.adjustsFontSizeToFitWidth = false
        khung.addSubview(dongThongKe)

        yHienTai += caoDongThongKe

        var yHang = yHienTai
        for h in 0..<soHang {
            let caoO = chieuCaoTungHang[h]
            for c in 0..<soCot {
                let idx = h * soCot + c
                guard idx < ds.count else { break }
                let x = le + CGFloat(c) * (rongO + khoangCachO)
                let oThe = OTheThiDuaCell(frame: CGRect(x: x, y: yHang, width: rongO, height: caoO))
                oThe.overrideUserInterfaceStyle = .light
                oThe.gan(ds[idx], xemDuKien: xemDuKien)
                khung.addSubview(oThe)
                oThe.layoutIfNeeded()
            }
            yHang += caoO + khoangCachO
        }

        return khung.ketXuatAnhChuanSang(scale: 3.0)
    }

    // MARK: - Xuất File Excel (.csv chuẩn UTF-8 BOM)

    func taoChuoiExcelCSV(doanhThu: ThongTinDoanhThu, danhSach: [DongThiDua]? = nil, cheDo: LoaiCheDoDoanhThu? = nil, ngay: Date = Date()) -> String {
        var cacDong: [String] = []
        let cheDoCSV = cheDo ?? cheDoDoanhThu
        let xemDK = (cheDoCSV == .luyKe && dangXemDuKien)
        let ds = danhSach.map { locVaSapXep($0, xemDuKien: xemDK, cheDoLoc: cheDoCSV) } ?? danhSachHienThi
        let soDat = ds.filter { xemDK ? $0.daHoanThanhDuBao : $0.daDat }.count

        if doanhThu.coDuLieu {
            cacDong.append("CHỈ SỐ CHÍNH,GIÁ TRỊ CHÍNH,CHI TIẾT / MỤC TIÊU")
            cacDong.append("Doanh thu thực,\(doanhThu.doanhThuThuc),Target: \(doanhThu.targetThuc)")
            cacDong.append("Doanh thu quy đổi,\(doanhThu.doanhThuQuyDoi),Target: \(doanhThu.targetQuyDoi)")
            cacDong.append("% Trả góp,\(String(format: "%.2f%%", doanhThu.phanTramTraGop)),DT trả góp: \(doanhThu.doanhThuTraGop)")
            cacDong.append("Lượt khách,\(Int(doanhThu.luotKhach)),Bill: \(Int(doanhThu.soBill)) | PVTC: \(String(format: "%.1f%%", doanhThu.phanTramPVTC))")
            let dk = doanhThu.duKienQuyDoi > 0 ? doanhThu.duKienQuyDoi : doanhThu.duKienThuc
            let kqDK = doanhThu.phanTramHTQDDuKienHienThi >= 99.995 ? "ĐẠT MỤC TIÊU" : "CHƯA ĐẠT"
            cacDong.append("\"% HT QĐ dự kiến\",\(String(format: "%.2f%%", doanhThu.phanTramHTQDDuKienHienThi)),\"DTQĐ DK: \(dk) (\(kqDK))\"")
            cacDong.append("% Quy đổi,\(String(format: "%.2f%%", doanhThu.phanTramQuyDoi)),Mục tiêu: 50%")
            cacDong.append("Thi đua hoàn thành,\(soDat)/\(ds.count),Tỷ lệ: \(ds.count > 0 ? Int(round(Double(soDat) / Double(ds.count) * 100)) : 0)%")
            cacDong.append("Tăng/giảm cùng kỳ,\(String(format: "%.1f%%", doanhThu.tangGiamCungKy)),TB3T: \(doanhThu.tb3Thang)")
            cacDong.append("")
        }

        if cheDoCSV == .luyKe {
            cacDong.append("STT,Ngành hàng (Chương trình),ĐVT,Thực hiện,Target,Thiếu / Vượt,% HT Tháng,DT/SL Dự kiến,Thiếu / Vượt DK,% Dự kiến,Trạng thái Thực hiện,Trạng thái Dự kiến")
            for (i, d) in ds.enumerated() {
                let tenSach = "\"\(d.tenNganhHang.replacingOccurrences(of: "\"", with: "\"\""))\""
                let ttTH = d.daDat ? "Đạt" : "Chưa đạt"
                let ttDK = d.daHoanThanhDuBao ? "Đạt DK" : "Chưa đạt DK"
                let dong = "\(i + 1),\(tenSach),\(d.loaiChiTieu.maBang),\(d.thucHien),\(d.target),\(d.chenhLech),\(String(format: "%.2f", d.phanTramHT))%,\(d.duKien),\(d.chenhLechDuKien),\(String(format: "%.2f", d.phanTramDuBao))%,\(ttTH),\(ttDK)"
                cacDong.append(dong)
            }
        } else {
            cacDong.append("STT,Ngành hàng (Chương trình),ĐVT,Thực hiện,Target,Thiếu / Vượt,% HT Ngày,% Dự kiến,Trạng thái")
            for (i, d) in ds.enumerated() {
                let tenSach = "\"\(d.tenNganhHang.replacingOccurrences(of: "\"", with: "\"\""))\""
                let trangThai = d.daDat ? "Đạt" : "Chưa đạt"
                let dong = "\(i + 1),\(tenSach),\(d.loaiChiTieu.maBang),\(d.thucHien),\(d.target),\(d.chenhLech),\(String(format: "%.2f", d.phanTramHT))%,\(String(format: "%.2f", d.phanTramDuBao))%,\(trangThai)"
                cacDong.append(dong)
            }
        }
        return "\u{FEFF}" + cacDong.joined(separator: "\n")
    }
}

// MARK: - 4. Màn hình / Khung Tổng Hợp Biểu Đồ Realtime Theo Tháng (Nút Biểu đồ)

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
            let pCenter = NSMutableParagraphStyle()
            pCenter.alignment = .center
            pCenter.lineBreakMode = .byWordWrapping
            let thongBao = "Chưa có dữ liệu Realtime ngày nào trong tháng — chạm vào ngày bên dưới để thêm."
            let attr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: mauChuPhu,
                .paragraphStyle: pCenter
            ]
            (thongBao as NSString).draw(
                in: CGRect(x: leTrai + 8, y: leTren + caoVe / 2 - 20, width: max(100, rongVe - 16), height: 44),
                withAttributes: attr
            )
            return
        }

        let mauThuc = BangMauBCTD.indigoChuDao
        let mauQuyDoi = BangMauBCTD.xanhDatVach
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

// MARK: - Biểu Đồ Thanh Ngang Trực Quan Sức Khỏe ~16 Nhân Viên + Chuỗi Ngày Yếu Liên Tục

final class VeBieuDoSucKhoeNhanVienView: UIView {
    var danhSachHoSo: [HoSoSucKhoeNhanVien] = [] {
        didSet { setNeedsDisplay() }
    }
    var khiChonNhanVien: ((HoSoSucKhoeNhanVien) -> Void)?

    let chieuCaoMoiDong: CGFloat = 54
    private let leTren: CGFloat = 30
    private let leDuoi: CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
        let tap = UITapGestureRecognizer(target: self, action: #selector(xuLyCham(_:)))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    func chieuCaoCanThiet(cho soLuong: Int) -> CGFloat {
        guard soLuong > 0 else { return 110 }
        return leTren + CGFloat(soLuong) * chieuCaoMoiDong + leDuoi
    }

    @objc private func xuLyCham(_ g: UITapGestureRecognizer) {
        guard !danhSachHoSo.isEmpty else { return }
        let diem = g.location(in: self)
        guard diem.y >= leTren else { return }
        let idx = Int((diem.y - leTren) / chieuCaoMoiDong)
        if idx >= 0 && idx < danhSachHoSo.count {
            khiChonNhanVien?(danhSachHoSo[idx])
        }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let rong = rect.width
        let cao = rect.height

        guard !danhSachHoSo.isEmpty else {
            let pCenter = NSMutableParagraphStyle()
            pCenter.alignment = .center
            pCenter.lineBreakMode = .byWordWrapping
            let thongBao = "Chưa có dữ liệu nhân viên để vẽ biểu đồ sức khỏe.\nHãy thêm nhân viên trong Cài đặt (⚙️) và quét ảnh Thi đua / Doanh thu NV."
            (thongBao as NSString).draw(
                in: CGRect(x: 16, y: max(16, cao / 2 - 26), width: max(100, rong - 32), height: 60),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 12.5, weight: .medium),
                    .foregroundColor: UIColor.secondaryLabel,
                    .paragraphStyle: pCenter
                ]
            )
            return
        }

        let rongCotTen: CGFloat = min(148, max(116, round(rong * 0.36)))
        let rongCotPhai: CGFloat = 82
        let xBatDauThanh: CGFloat = rongCotTen + 6
        let rongVungThanh: CGFloat = max(80, rong - xBatDauThanh - rongCotPhai - 6)

        // Vẽ thước đo phần trăm phía trên (0% - 55% Yếu - 75% Khỏe - 100%)
        let fontTruc = UIFont.monospacedDigitSystemFont(ofSize: 9.5, weight: .bold)
        let cacMoc: [(Double, String, UIColor)] = [
            (0, "0%", .secondaryLabel),
            (55, "55% (Yếu)", UIColor(red: 0.85, green: 0.16, blue: 0.16, alpha: 1)),
            (75, "75% (Khỏe)", UIColor(red: 0.08, green: 0.55, blue: 0.24, alpha: 1)),
            (100, "100%", .secondaryLabel)
        ]

        for (moc, nhan, mau) in cacMoc {
            let xMoc = xBatDauThanh + rongVungThanh * CGFloat(moc / 100.0)
            ctx.setStrokeColor(mau.withAlphaComponent(moc == 55 || moc == 75 ? 0.55 : 0.25).cgColor)
            ctx.setLineWidth(moc == 55 || moc == 75 ? 1.1 : 0.6)
            if moc == 55 || moc == 75 {
                ctx.setLineDash(phase: 0, lengths: [4, 3])
            } else {
                ctx.setLineDash(phase: 0, lengths: [])
            }
            ctx.move(to: CGPoint(x: xMoc, y: leTren - 4))
            ctx.addLine(to: CGPoint(x: xMoc, y: cao - leDuoi))
            ctx.strokePath()

            let attrMoc: [NSAttributedString.Key: Any] = [.font: fontTruc, .foregroundColor: mau]
            let sz = (nhan as NSString).size(withAttributes: attrMoc)
            let xText = min(max(xBatDauThanh, xMoc - sz.width / 2), xBatDauThanh + rongVungThanh - sz.width)
            (nhan as NSString).draw(at: CGPoint(x: xText, y: 8), withAttributes: attrMoc)
        }
        ctx.setLineDash(phase: 0, lengths: [])

        let pLeftWrap = NSMutableParagraphStyle()
        pLeftWrap.alignment = .left
        pLeftWrap.lineBreakMode = .byWordWrapping

        let pCenter = NSMutableParagraphStyle()
        pCenter.alignment = .center
        pCenter.lineBreakMode = .byWordWrapping

        let fontTen = UIFont.systemFont(ofSize: 11.5, weight: .bold)
        let fontPhu = UIFont.systemFont(ofSize: 9.5, weight: .semibold)
        let fontDiem = UIFont.monospacedDigitSystemFont(ofSize: 10.5, weight: .heavy)
        let fontBadge = UIFont.systemFont(ofSize: 9.5, weight: .bold)

        for (idx, hs) in danhSachHoSo.enumerated() {
            let yDong = leTren + CGFloat(idx) * chieuCaoMoiDong
            let khungDong = CGRect(x: 2, y: yDong + 2, width: rong - 4, height: chieuCaoMoiDong - 4)

            // Nền nổi bật cho 5 nhân viên cảnh báo yếu liên tục
            if hs.laCanhBaoTop5 {
                let mauNenCanhBao = UIColor(red: 1.0, green: 0.92, blue: 0.92, alpha: 0.75)
                mauNenCanhBao.setFill()
                let pathNen = UIBezierPath(roundedRect: khungDong, cornerRadius: 8)
                pathNen.fill()
                UIColor(red: 0.90, green: 0.20, blue: 0.20, alpha: 0.35).setStroke()
                pathNen.lineWidth = 1.0
                pathNen.stroke()
            } else if idx % 2 == 1 {
                UIColor.secondarySystemFill.withAlphaComponent(0.28).setFill()
                UIBezierPath(roundedRect: khungDong, cornerRadius: 8).fill()
            }

            // 1. Cột tên nhân viên bên trái (hiển thị đầy đủ tên, tự xuống dòng, không "...")
            let tienToHang = hs.laCanhBaoTop5 ? "🚨#\(hs.hangCanhBao ?? (idx + 1))" : "\(idx + 1)."
            let chuoiTen = "\(tienToHang) \(hs.nhanVien.hoTen)"
            let mauTen: UIColor = hs.laCanhBaoTop5 ? UIColor(red: 0.76, green: 0.10, blue: 0.10, alpha: 1) : .label
            (chuoiTen as NSString).draw(
                in: CGRect(x: 6, y: yDong + 4, width: rongCotTen - 8, height: 28),
                withAttributes: [
                    .font: fontTen,
                    .foregroundColor: mauTen,
                    .paragraphStyle: pLeftWrap
                ]
            )

            let dtText = hs.tongHopHienTai.doanhThuQD > 0 ? " • \(hs.tongHopHienTai.doanhThuQD.chuoiSoGonVN)tr" : ""
            let chuoiChiSoPhu = "\(hs.tongHopHienTai.soMonDat)/\(hs.tongHopHienTai.tongMonGiao) môn\(dtText)"
            (chuoiChiSoPhu as NSString).draw(
                in: CGRect(x: 6, y: yDong + 33, width: rongCotTen - 8, height: 15),
                withAttributes: [
                    .font: fontPhu,
                    .foregroundColor: UIColor.secondaryLabel,
                    .paragraphStyle: pLeftWrap
                ]
            )

            // 2. Vùng thanh ngang điểm sức khỏe ở giữa
            let yThanh = yDong + 7
            let caoThanh: CGFloat = 17
            let khungTrack = CGRect(x: xBatDauThanh, y: yThanh, width: rongVungThanh, height: caoThanh)
            UIColor.systemGray5.setFill()
            UIBezierPath(roundedRect: khungTrack, cornerRadius: 6).fill()

            let mauThanh: UIColor
            switch hs.mucDo {
            case .khoe:
                mauThanh = UIColor(red: 0.09, green: 0.62, blue: 0.28, alpha: 1)
            case .trungBinh:
                mauThanh = UIColor(red: 0.95, green: 0.56, blue: 0.04, alpha: 1)
            case .yeu:
                mauThanh = UIColor(red: 0.88, green: 0.18, blue: 0.18, alpha: 1)
            case .chuaCoSo:
                mauThanh = UIColor.systemGray3
            }

            let tyLe = CGFloat(min(1.0, max(0.04, hs.diemSucKhoe / 100.0)))
            let rongFill = max(8, rongVungThanh * tyLe)
            let khungFill = CGRect(x: xBatDauThanh, y: yThanh, width: rongFill, height: caoThanh)
            mauThanh.setFill()
            UIBezierPath(roundedRect: khungFill, cornerRadius: 6).fill()

            let chuDiem = "\(hs.diemSucKhoe.chuoiPhanTram) (HT TB: \(hs.tongHopHienTai.phanTramHTTB.chuoiPhanTram))"
            let szDiem = (chuDiem as NSString).size(withAttributes: [.font: fontDiem])
            if rongFill > szDiem.width + 12 {
                (chuDiem as NSString).draw(
                    at: CGPoint(x: xBatDauThanh + 6, y: yThanh + (caoThanh - szDiem.height) / 2),
                    withAttributes: [.font: fontDiem, .foregroundColor: UIColor.white]
                )
            } else {
                let xChu = min(xBatDauThanh + rongFill + 5, xBatDauThanh + rongVungThanh - szDiem.width - 2)
                (chuDiem as NSString).draw(
                    at: CGPoint(x: max(xBatDauThanh + 4, xChu), y: yThanh + (caoThanh - szDiem.height) / 2),
                    withAttributes: [.font: fontDiem, .foregroundColor: mauThanh]
                )
            }

            // Dải chấm lịch sử ngày gần nhất ngay dưới thanh ngang
            let lichSu = hs.lichSuNgay.suffix(6)
            var xCham = xBatDauThanh
            let yCham = yDong + 29
            for ng in lichSu {
                let mauCham: UIColor
                switch ng.mucDo {
                case .khoe: mauCham = UIColor(red: 0.09, green: 0.62, blue: 0.28, alpha: 1)
                case .trungBinh: mauCham = UIColor(red: 0.95, green: 0.56, blue: 0.04, alpha: 1)
                case .yeu: mauCham = UIColor(red: 0.88, green: 0.18, blue: 0.18, alpha: 1)
                case .chuaCoSo: mauCham = UIColor.systemGray3
                }
                let chuoiNg = "\(ng.nhanNgay.prefix(2)):"
                let szNg = (chuoiNg as NSString).size(withAttributes: [.font: fontPhu])
                if xCham + szNg.width + 12 <= xBatDauThanh + rongVungThanh {
                    (chuoiNg as NSString).draw(
                        at: CGPoint(x: xCham, y: yCham),
                        withAttributes: [.font: fontPhu, .foregroundColor: UIColor.secondaryLabel]
                    )
                    let rectDot = CGRect(x: xCham + szNg.width + 1, y: yCham + 2.5, width: 7, height: 7)
                    mauCham.setFill()
                    UIBezierPath(ovalIn: rectDot).fill()
                    xCham += szNg.width + 13
                }
            }

            // 3. Cột huy hiệu cảnh báo chuỗi ngày yếu bên phải
            let khungBadge = CGRect(x: rong - rongCotPhai - 4, y: yDong + 7, width: rongCotPhai - 2, height: 22)
            let bgBadge: UIColor
            let fgBadge: UIColor
            let chuBadge: String

            if hs.soNgayYeuLienTuc >= 2 {
                bgBadge = UIColor(red: 0.99, green: 0.86, blue: 0.86, alpha: 1)
                fgBadge = UIColor(red: 0.76, green: 0.10, blue: 0.10, alpha: 1)
                chuBadge = "🔥 Yếu \(hs.soNgayYeuLienTuc)N"
            } else if hs.soNgayYeuLienTuc == 1 || hs.mucDo == .yeu {
                bgBadge = UIColor(red: 1.0, green: 0.91, blue: 0.84, alpha: 1)
                fgBadge = UIColor(red: 0.78, green: 0.24, blue: 0.06, alpha: 1)
                chuBadge = "⚠️ Yếu 1N"
            } else if hs.mucDo == .khoe {
                bgBadge = UIColor(red: 0.86, green: 0.98, blue: 0.90, alpha: 1)
                fgBadge = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
                chuBadge = "✅ Khỏe"
            } else {
                bgBadge = UIColor(red: 0.99, green: 0.95, blue: 0.78, alpha: 1)
                fgBadge = UIColor(red: 0.70, green: 0.35, blue: 0.04, alpha: 1)
                chuBadge = "⚡ TB"
            }

            bgBadge.setFill()
            UIBezierPath(roundedRect: khungBadge, cornerRadius: 6).fill()
            (chuBadge as NSString).draw(
                in: CGRect(x: khungBadge.minX + 2, y: khungBadge.minY + 4, width: khungBadge.width - 4, height: 15),
                withAttributes: [
                    .font: fontBadge,
                    .foregroundColor: fgBadge,
                    .paragraphStyle: pCenter
                ]
            )

            (hs.nhanXuHuong as NSString).draw(
                in: CGRect(x: khungBadge.minX, y: yDong + 31, width: khungBadge.width, height: 15),
                withAttributes: [
                    .font: fontPhu,
                    .foregroundColor: UIColor.secondaryLabel,
                    .paragraphStyle: pCenter
                ]
            )
        }
    }
}

final class BangTongHopRealtimeThangView: UIView, UITableViewDataSource, UITableViewDelegate {
    var khiBamSuaDoanhThuLuyKe: (() -> Void)?
    var khiChonNgayRealtime: ((DuLieuRealtimeNgayTrongThang) -> Void)?
    var khiChonNhanVienSucKhoe: ((TongHopNhanVien, LoaiCheDoDoanhThu) -> Void)?
    var khiChiaSeAnhSucKhoe: ((UIImage) -> Void)?
    var khiXuatTatCaAnhSucKhoeNV: (() -> Void)?

    private var ngayHienTai: Date = Date()
    private(set) var loaiBieuDoDangXem: LoaiBieuDoThang = .realtime
    private var cheDoSucKhoe: LoaiCheDoDoanhThu = .luyKe
    private static let khoaKieuSapXepSucKhoe = "dmx.sucKhoeNV.kieuSapXep"
    private var kieuSapXepSucKhoe: Int = {
        if UserDefaults.standard.object(forKey: BangTongHopRealtimeThangView.khoaKieuSapXepSucKhoe) != nil {
            let v = UserDefaults.standard.integer(forKey: BangTongHopRealtimeThangView.khoaKieuSapXepSucKhoe)
            if (0...2).contains(v) { return v }
        }
        return 0
    }() // 0: Yếu -> Khỏe, 1: Khỏe -> Yếu, 2: DT QĐ Cao -> Thấp
    private var boLocNhomSucKhoe: Int = 0 // 0: Tất cả, 1: Yếu, 2: Trung bình, 3: Khỏe

    // Hai nút chuyển đổi trên đỉnh mục Biểu đồ: 1. Biểu đồ Realtime | 2. Biểu đồ sức khỏe NV
    private let nutBieuDoRealtime = UIButton(type: .custom)
    private let nutBieuDoSucKhoeNV = UIButton(type: .custom)
    private let hangHaiNutBieuDo = UIStackView()
    private var rangBuocCaoHangChonBieuDo: NSLayoutConstraint?

    private var doanhThuLuyKe = ThongTinDoanhThu()
    private var tatCaNgayTrongThang: [DuLieuRealtimeNgayTrongThang] = []
    private var danhSachBieuDo: [DuLieuRealtimeNgayTrongThang] = []
    private var chiHienNgayCoSo: Bool = false

    // Bộ nhớ đệm trạng thái giao diện giúp chuyển qua lại giữa Biểu đồ / Realtime / Sức khỏe NV tức thì (0ms)
    private var khoaNgayDaNapRT: String = ""
    private var phienBanDaNapRT: Int = -1
    private var chiHienCoSoDaNapRT: Bool?
    private var khoaNgayDaNapSK: String = ""
    private var phienBanDaNapSK: Int = -1
    private var cheDoDaNapSK: LoaiCheDoDoanhThu?

    private let cuonDoc = UIScrollView()
    private let nganTong = UIStackView()
    private let nganNoiDung = UIStackView()
    private let nganSucKhoeNV = UIStackView()

    // Thành phần của Bảng Chi tiết Sức khỏe Nhân viên & Biểu đồ Đội ngũ (~16 NV)
    private var baoCaoSucKhoeHienTai: BaoCaoSucKhoeDoiNgu?
    private let chonKieuXemSK = UISegmentedControl(items: ["📋 Chi tiết Sức khỏe NV", "📊 Biểu đồ & Chuỗi ngày"])
    private let khungChonNVSucKhoe = UIView()
    private let nutSKNVTruoc = UIButton(type: .system)
    private let nutSKNVSau = UIButton(type: .system)
    private let nutChonNVSucKhoe = UIButton(type: .system)
    private var maNVSucKhoeDangChon: String = ""
    private var bangThongSoCaNhanSKView: BangThongSoSucKhoeNhanVienView?
    private let nganBieuDoDoiNguSK = UIStackView()
    private let chonCheDoSK = UISegmentedControl(items: ["Theo Lũy kế", "Theo Realtime"])
    private let nutSapXepSK = UIButton(type: .system)
    private let nutXuatAnhSK = UIButton(type: .system)
    private let nutXuatTatCaAnhSK = UIButton(type: .system)

    private let theSKKhoe = TheDoanhThuView(
        tieuDe: "💪 KHỎE MẠNH",
        mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1),
        mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
    )
    private let theSKTrungBinh = TheDoanhThuView(
        tieuDe: "⚡ TRUNG BÌNH",
        mauBatDau: UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1),
        mauKetThuc: UIColor(red: 0.85, green: 0.47, blue: 0.02, alpha: 1)
    )
    private let theSKYeu = TheDoanhThuView(
        tieuDe: "🚨 YẾU / BÁO ĐỘNG",
        mauBatDau: UIColor(red: 0.94, green: 0.24, blue: 0.24, alpha: 1),
        mauKetThuc: UIColor(red: 0.80, green: 0.12, blue: 0.12, alpha: 1),
        hienChamTron: true
    )
    private let theSKDiemDoi = TheDoanhThuView(
        tieuDe: "❤️‍🩹 ĐIỂM ĐỘI NGŨ",
        mauBatDau: UIColor(red: 0.39, green: 0.40, blue: 0.95, alpha: 1),
        mauKetThuc: UIColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1)
    )

    private let nhanTieuDeCanhBaoTop5 = UILabel()
    private let nhanPhuDeCanhBaoTop5 = UILabel()
    private let nganDanhSachTop5 = UIStackView()
    private var dsTop5DangHienThi: [HoSoSucKhoeNhanVien] = []

    private let chonLocNhomSK = UISegmentedControl(items: ["Tất cả", "Yếu", "TB", "Khỏe"])
    private let veBieuDoSucKhoe = VeBieuDoSucKhoeNhanVienView()
    private var rangBuocCaoBieuDoSucKhoe: NSLayoutConstraint?

    private let cuonNgangMaTran = UIScrollView()
    private let nganBangMaTranNgay = UIStackView()
    private var dsMaTranDangHienThi: [HoSoSucKhoeNhanVien] = []

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

    private let chonCheDoNgay = UISegmentedControl(items: ["Tất cả", "Có số"])
    private let nhanTomTatRT = UILabel()
    private let cuonBieuDo = UIScrollView()
    private let veBieuDo = VeBieuDoCotRealtimeView()
    private var rangBuocRongBieuDo: NSLayoutConstraint?

    private let bangNgay = UITableView(frame: .zero, style: .plain)
    private var rangBuocCaoBang: NSLayoutConstraint?

    private let soDongTongKetCuoiBang: Int = 3
    private let chieuCaoMoiDongBang: CGFloat = 52

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func cauHinhNutChuyenBieuDo(_ nut: UIButton, tieuDe: String, tag: Int) {
        nut.tag = tag
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nut.titleLabel?.numberOfLines = 0
        nut.titleLabel?.lineBreakMode = .byWordWrapping
        nut.titleLabel?.textAlignment = .center
        nut.titleLabel?.adjustsFontSizeToFitWidth = false
        nut.contentEdgeInsets = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        nut.layer.cornerRadius = 10
        nut.layer.borderWidth = 1.2
        nut.addTarget(self, action: #selector(bamChonLoaiBieuDo(_:)), for: .touchUpInside)
    }

    private func taoGiaoDien() {
        backgroundColor = .clear

        // Thanh 2 nút nhấn trên cùng: 1. Biểu đồ Realtime | 2. Biểu đồ sức khỏe NV
        cauHinhNutChuyenBieuDo(nutBieuDoRealtime, tieuDe: "📊 Biểu đồ Realtime", tag: LoaiBieuDoThang.realtime.rawValue)
        cauHinhNutChuyenBieuDo(nutBieuDoSucKhoeNV, tieuDe: "❤️‍🩹 Biểu đồ sức khỏe NV", tag: LoaiBieuDoThang.sucKhoeNhanVien.rawValue)

        hangHaiNutBieuDo.addArrangedSubview(nutBieuDoRealtime)
        hangHaiNutBieuDo.addArrangedSubview(nutBieuDoSucKhoeNV)
        hangHaiNutBieuDo.axis = .horizontal
        hangHaiNutBieuDo.spacing = 8
        hangHaiNutBieuDo.distribution = .fillEqually
        hangHaiNutBieuDo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hangHaiNutBieuDo)

        cuonDoc.showsVerticalScrollIndicator = true
        cuonDoc.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cuonDoc)

        nganTong.axis = .vertical
        nganTong.spacing = 10
        nganTong.translatesAutoresizingMaskIntoConstraints = false
        cuonDoc.addSubview(nganTong)

        nganNoiDung.axis = .vertical
        nganNoiDung.spacing = 10

        nganSucKhoeNV.axis = .vertical
        nganSucKhoeNV.spacing = 10

        let khungLuyKe = UIView()
        khungLuyKe.backgroundColor = BangMauBCTD.nenThe
        khungLuyKe.layer.cornerRadius = 11
        khungLuyKe.layer.borderWidth = 1
        khungLuyKe.layer.borderColor = BangMauBCTD.vienThe.cgColor

        nhanTieuDeLuyKe.text = "📌 DOANH THU LŨY KẾ THÁNG (CỐ ĐỊNH — MỖI NGÀY NHẬP THAY THẾ NGÀY TRƯỚC)"
        nhanTieuDeLuyKe.font = .systemFont(ofSize: 11, weight: .bold)
        nhanTieuDeLuyKe.textColor = BangMauBCTD.chuPhu
        nhanTieuDeLuyKe.numberOfLines = 0
        nhanTieuDeLuyKe.lineBreakMode = .byWordWrapping
        nhanTieuDeLuyKe.adjustsFontSizeToFitWidth = false

        let nutSuaLK = UIButton(type: .system)
        nutSuaLK.setTitle("✏️ Lũy kế", for: .normal)
        nutSuaLK.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutSuaLK.titleLabel?.numberOfLines = 0
        nutSuaLK.titleLabel?.lineBreakMode = .byWordWrapping
        nutSuaLK.titleLabel?.textAlignment = .center
        nutSuaLK.titleLabel?.adjustsFontSizeToFitWidth = false
        nutSuaLK.backgroundColor = BangMauBCTD.nenMenuToi
        nutSuaLK.tintColor = BangMauBCTD.vangChuDao
        nutSuaLK.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
        nutSuaLK.layer.cornerRadius = 7
        nutSuaLK.layer.borderWidth = 1
        nutSuaLK.layer.borderColor = BangMauBCTD.vangChuDao.withAlphaComponent(0.45).cgColor
        nutSuaLK.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        nutSuaLK.addTarget(self, action: #selector(bamSuaLuyKe), for: .touchUpInside)
        nutSuaLK.setContentHuggingPriority(.required, for: .horizontal)

        let hangDauLK = UIStackView(arrangedSubviews: [nhanTieuDeLuyKe])
        hangDauLK.axis = .horizontal
        hangDauLK.spacing = 6
        hangDauLK.alignment = .center

        let hangTheLK = UIStackView(arrangedSubviews: [theLuyKeThuc, theLuyKeQD])
        hangTheLK.axis = .horizontal
        hangTheLK.spacing = 8
        hangTheLK.distribution = .fillEqually
        hangTheLK.heightAnchor.constraint(greaterThanOrEqualToConstant: 76).isActive = true

        let tapLK = UITapGestureRecognizer(target: self, action: #selector(bamSuaLuyKe))
        hangTheLK.addGestureRecognizer(tapLK)

        let nganLK = UIStackView(arrangedSubviews: [hangDauLK, hangTheLK])
        nganLK.axis = .vertical
        nganLK.spacing = 8
        nganLK.translatesAutoresizingMaskIntoConstraints = false
        khungLuyKe.addSubview(nganLK)

        let rgCaoHangChon = hangHaiNutBieuDo.heightAnchor.constraint(equalToConstant: 38)
        rangBuocCaoHangChonBieuDo = rgCaoHangChon
        NSLayoutConstraint.activate([
            nganLK.topAnchor.constraint(equalTo: khungLuyKe.topAnchor, constant: 10),
            nganLK.leadingAnchor.constraint(equalTo: khungLuyKe.leadingAnchor, constant: 10),
            nganLK.trailingAnchor.constraint(equalTo: khungLuyKe.trailingAnchor, constant: -10),
            nganLK.bottomAnchor.constraint(equalTo: khungLuyKe.bottomAnchor, constant: -10)
        ])

        let khungBieuDo = UIView()
        khungBieuDo.backgroundColor = BangMauBCTD.nenThe
        khungBieuDo.layer.cornerRadius = 11
        khungBieuDo.layer.borderWidth = 1
        khungBieuDo.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let lbTieuDeBD = UILabel()
        lbTieuDeBD.text = "📊 BIỂU ĐỒ DOANH THU THỰC & QUY ĐỔI THEO NGÀY"
        lbTieuDeBD.font = .systemFont(ofSize: 12, weight: .bold)
        lbTieuDeBD.textColor = BangMauBCTD.chuChinh
        lbTieuDeBD.numberOfLines = 0
        lbTieuDeBD.lineBreakMode = .byWordWrapping
        lbTieuDeBD.adjustsFontSizeToFitWidth = false

        chonCheDoNgay.selectedSegmentIndex = 0
        chonCheDoNgay.backgroundColor = BangMauBCTD.nenThePhu
        chonCheDoNgay.selectedSegmentTintColor = BangMauBCTD.nenMenuToi
        chonCheDoNgay.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.0, weight: .semibold),
            .foregroundColor: BangMauBCTD.chuPhu
        ], for: .normal)
        chonCheDoNgay.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.0, weight: .bold),
            .foregroundColor: BangMauBCTD.vangChuDao
        ], for: .selected)
        chonCheDoNgay.addTarget(self, action: #selector(doiCheDoLocNgay), for: .valueChanged)
        chonCheDoNgay.setContentHuggingPriority(.required, for: .horizontal)

        let hangTieuDeBD = UIStackView(arrangedSubviews: [lbTieuDeBD, chonCheDoNgay])
        hangTieuDeBD.axis = .vertical
        hangTieuDeBD.spacing = 8
        hangTieuDeBD.alignment = .fill

        nhanTomTatRT.font = .systemFont(ofSize: 11.5, weight: .semibold)
        nhanTomTatRT.textColor = .secondaryLabel
        nhanTomTatRT.numberOfLines = 0
        nhanTomTatRT.lineBreakMode = .byWordWrapping
        nhanTomTatRT.adjustsFontSizeToFitWidth = false

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

        let khungBang = UIView()
        khungBang.backgroundColor = .secondarySystemGroupedBackground
        khungBang.layer.cornerRadius = 12
        khungBang.clipsToBounds = true

        let lbTieuDeBang = UILabel()
        lbTieuDeBang.text = "📋 BẢNG CHI TIẾT REALTIME THEO NGÀY (CHẠM VÀO NGÀY ĐỂ SỬA / QUÉT ẢNH)"
        lbTieuDeBang.font = .systemFont(ofSize: 11.5, weight: .bold)
        lbTieuDeBang.textColor = .secondaryLabel
        lbTieuDeBang.numberOfLines = 0
        lbTieuDeBang.lineBreakMode = .byWordWrapping
        lbTieuDeBang.adjustsFontSizeToFitWidth = false
        lbTieuDeBang.translatesAutoresizingMaskIntoConstraints = false
        khungBang.addSubview(lbTieuDeBang)

        bangNgay.dataSource = self
        bangNgay.delegate = self
        bangNgay.isScrollEnabled = false
        bangNgay.rowHeight = chieuCaoMoiDongBang
        bangNgay.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if #available(iOS 15.0, *) {
            bangNgay.sectionHeaderTopPadding = 0
        }
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

        [khungLuyKe, khungBieuDo, khungBang].forEach {
            nganNoiDung.addArrangedSubview($0)
        }

        taoGiaoDienSucKhoeNhanVien()

        nganTong.addArrangedSubview(nganNoiDung)
        nganTong.addArrangedSubview(nganSucKhoeNV)

        NSLayoutConstraint.activate([
            hangHaiNutBieuDo.topAnchor.constraint(equalTo: topAnchor),
            hangHaiNutBieuDo.leadingAnchor.constraint(equalTo: leadingAnchor),
            hangHaiNutBieuDo.trailingAnchor.constraint(equalTo: trailingAnchor),
            rgCaoHangChon,

            cuonDoc.topAnchor.constraint(equalTo: hangHaiNutBieuDo.bottomAnchor),
            cuonDoc.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuonDoc.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuonDoc.bottomAnchor.constraint(equalTo: bottomAnchor),

            nganTong.topAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.topAnchor),
            nganTong.leadingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.leadingAnchor),
            nganTong.trailingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.trailingAnchor),
            nganTong.bottomAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.bottomAnchor, constant: -12),
            nganTong.widthAnchor.constraint(equalTo: cuonDoc.frameLayoutGuide.widthAnchor)
        ])

        capNhatGiaoDienHaiNutBieuDo()
    }

    private func taoGiaoDienSucKhoeNhanVien() {
        // 1. Thanh điều khiển: Chế độ (Lũy kế / Realtime) + Sắp xếp + Xuất ảnh
        chonCheDoSK.selectedSegmentIndex = 0
        chonCheDoSK.backgroundColor = BangMauBCTD.nenThePhu
        chonCheDoSK.selectedSegmentTintColor = BangMauBCTD.nenMenuToi
        chonCheDoSK.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.5, weight: .semibold),
            .foregroundColor: BangMauBCTD.chuPhu
        ], for: .normal)
        chonCheDoSK.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
            .foregroundColor: BangMauBCTD.vangChuDao
        ], for: .selected)
        chonCheDoSK.addTarget(self, action: #selector(doiCheDoSucKhoe), for: .valueChanged)

        switch kieuSapXepSucKhoe {
        case 0: nutSapXepSK.setTitle("⇅ Yếu → Khỏe", for: .normal)
        case 1: nutSapXepSK.setTitle("⇅ Khỏe → Yếu", for: .normal)
        default: nutSapXepSK.setTitle("⇅ Theo DT QĐ", for: .normal)
        }
        nutSapXepSK.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutSapXepSK.titleLabel?.numberOfLines = 0
        nutSapXepSK.titleLabel?.lineBreakMode = .byWordWrapping
        nutSapXepSK.titleLabel?.textAlignment = .center
        nutSapXepSK.titleLabel?.adjustsFontSizeToFitWidth = false
        nutSapXepSK.backgroundColor = BangMauBCTD.nenThePhu
        nutSapXepSK.tintColor = BangMauBCTD.chuChinh
        nutSapXepSK.layer.cornerRadius = 8
        nutSapXepSK.layer.borderWidth = 1
        nutSapXepSK.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutSapXepSK.contentEdgeInsets = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        nutSapXepSK.addTarget(self, action: #selector(bamDoiSapXepSK), for: .touchUpInside)

        nutXuatAnhSK.setTitle("📸 XUẤT ẢNH SỨC KHỎE NHÂN VIÊN", for: .normal)
        nutXuatAnhSK.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .bold)
        nutXuatAnhSK.titleLabel?.numberOfLines = 0
        nutXuatAnhSK.titleLabel?.lineBreakMode = .byWordWrapping
        nutXuatAnhSK.titleLabel?.textAlignment = .center
        nutXuatAnhSK.titleLabel?.adjustsFontSizeToFitWidth = false
        nutXuatAnhSK.backgroundColor = BangMauBCTD.nenMenuToi
        nutXuatAnhSK.tintColor = BangMauBCTD.vangChuDao
        nutXuatAnhSK.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
        nutXuatAnhSK.layer.cornerRadius = 8
        nutXuatAnhSK.layer.borderWidth = 1
        nutXuatAnhSK.layer.borderColor = BangMauBCTD.vangChuDao.withAlphaComponent(0.5).cgColor
        nutXuatAnhSK.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
        nutXuatAnhSK.heightAnchor.constraint(greaterThanOrEqualToConstant: 46).isActive = true
        nutXuatAnhSK.addTarget(self, action: #selector(bamXuatAnhSucKhoe), for: .touchUpInside)

        nutXuatTatCaAnhSK.setTitle("📚 XUẤT ẢNH SỨC KHỎE TẤT CẢ NV ĐANG QUẢN LÝ", for: .normal)
        nutXuatTatCaAnhSK.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .bold)
        nutXuatTatCaAnhSK.titleLabel?.numberOfLines = 0
        nutXuatTatCaAnhSK.titleLabel?.lineBreakMode = .byWordWrapping
        nutXuatTatCaAnhSK.titleLabel?.textAlignment = .center
        nutXuatTatCaAnhSK.backgroundColor = BangMauBCTD.xanhChuDao
        nutXuatTatCaAnhSK.setTitleColor(.white, for: .normal)
        nutXuatTatCaAnhSK.layer.cornerRadius = 8
        nutXuatTatCaAnhSK.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
        nutXuatTatCaAnhSK.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        nutXuatTatCaAnhSK.addTarget(self, action: #selector(bamXuatTatCaAnhSucKhoe), for: .touchUpInside)

        chonCheDoSK.heightAnchor.constraint(equalToConstant: 32).isActive = true

        // 2. Cụm 4 thẻ chỉ số sức khỏe đội ngũ
        let hangTheSK = UIStackView(arrangedSubviews: [theSKKhoe, theSKTrungBinh, theSKYeu, theSKDiemDoi])
        hangTheSK.axis = .horizontal
        hangTheSK.spacing = 5
        hangTheSK.distribution = .fillEqually
        hangTheSK.heightAnchor.constraint(equalToConstant: 72).isActive = true

        // 3. Khung Cảnh Báo Nổi Bật: 5 Nhân Viên Yếu Nhiều Ngày Liên Tục
        let khungCanhBao = UIView()
        khungCanhBao.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.95, alpha: 1)
        khungCanhBao.layer.cornerRadius = 12
        khungCanhBao.layer.borderWidth = 1.4
        khungCanhBao.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.45).cgColor

        nhanTieuDeCanhBaoTop5.text = "🚨 CẢNH BÁO 5 NHÂN VIÊN YẾU NHIỀU NGÀY LIÊN TỤC"
        nhanTieuDeCanhBaoTop5.font = .systemFont(ofSize: 13.0, weight: .heavy)
        nhanTieuDeCanhBaoTop5.textColor = UIColor(red: 0.78, green: 0.10, blue: 0.10, alpha: 1)
        nhanTieuDeCanhBaoTop5.numberOfLines = 0
        nhanTieuDeCanhBaoTop5.lineBreakMode = .byWordWrapping
        nhanTieuDeCanhBaoTop5.adjustsFontSizeToFitWidth = false

        nhanPhuDeCanhBaoTop5.text = "Danh sách 5 nhân viên có chuỗi ngày yếu liên tiếp dài nhất hoặc điểm sức khỏe thấp nhất cần kèm cặp ngay (chạm vào nhân viên để xem chi tiết từng ngành hàng):"
        nhanPhuDeCanhBaoTop5.font = .systemFont(ofSize: 11.5, weight: .semibold)
        nhanPhuDeCanhBaoTop5.textColor = .secondaryLabel
        nhanPhuDeCanhBaoTop5.numberOfLines = 0
        nhanPhuDeCanhBaoTop5.lineBreakMode = .byWordWrapping
        nhanPhuDeCanhBaoTop5.adjustsFontSizeToFitWidth = false

        nganDanhSachTop5.axis = .vertical
        nganDanhSachTop5.spacing = 8

        let nganCanhBao = UIStackView(arrangedSubviews: [nhanTieuDeCanhBaoTop5, nhanPhuDeCanhBaoTop5, nganDanhSachTop5])
        nganCanhBao.axis = .vertical
        nganCanhBao.spacing = 6
        nganCanhBao.translatesAutoresizingMaskIntoConstraints = false
        khungCanhBao.addSubview(nganCanhBao)

        NSLayoutConstraint.activate([
            nganCanhBao.topAnchor.constraint(equalTo: khungCanhBao.topAnchor, constant: 10),
            nganCanhBao.leadingAnchor.constraint(equalTo: khungCanhBao.leadingAnchor, constant: 10),
            nganCanhBao.trailingAnchor.constraint(equalTo: khungCanhBao.trailingAnchor, constant: -10),
            nganCanhBao.bottomAnchor.constraint(equalTo: khungCanhBao.bottomAnchor, constant: -10)
        ])

        // 4. Khung Biểu Đồ Thanh Ngang Trực Quan Toàn Bộ ~16 Nhân Viên
        let khungBieuDoSK = UIView()
        khungBieuDoSK.backgroundColor = .secondarySystemGroupedBackground
        khungBieuDoSK.layer.cornerRadius = 12

        let lbTieuDeBDSK = UILabel()
        lbTieuDeBDSK.text = "📊 BIỂU ĐỒ SỨC KHỎE TRỰC QUAN TOÀN ĐỘI NGŨ (CHẠM VÀO NV ĐỂ XEM CHI TIẾT)"
        lbTieuDeBDSK.font = .systemFont(ofSize: 12.0, weight: .bold)
        lbTieuDeBDSK.textColor = .label
        lbTieuDeBDSK.numberOfLines = 0
        lbTieuDeBDSK.lineBreakMode = .byWordWrapping
        lbTieuDeBDSK.adjustsFontSizeToFitWidth = false

        let lbChuThichSK = UILabel()
        lbChuThichSK.text = "🟢 Khỏe (>=75%)   •   🟡 Trung bình (55-74%)   •   🔴 Yếu (<55% / Top 5 yếu)   •   Chấm tròn dưới thanh: Lịch sử các ngày gần nhất"
        lbChuThichSK.font = .systemFont(ofSize: 11.0, weight: .semibold)
        lbChuThichSK.textColor = .secondaryLabel
        lbChuThichSK.numberOfLines = 0
        lbChuThichSK.lineBreakMode = .byWordWrapping
        lbChuThichSK.adjustsFontSizeToFitWidth = false

        chonLocNhomSK.selectedSegmentIndex = 0
        chonLocNhomSK.backgroundColor = BangMauBCTD.nenThePhu
        chonLocNhomSK.selectedSegmentTintColor = BangMauBCTD.nenMenuToi
        chonLocNhomSK.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.0, weight: .semibold),
            .foregroundColor: BangMauBCTD.chuPhu
        ], for: .normal)
        chonLocNhomSK.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 11.0, weight: .bold),
            .foregroundColor: BangMauBCTD.vangChuDao
        ], for: .selected)
        chonLocNhomSK.addTarget(self, action: #selector(doiBoLocNhomSK), for: .valueChanged)
        chonLocNhomSK.heightAnchor.constraint(equalToConstant: 30).isActive = true

        veBieuDoSucKhoe.translatesAutoresizingMaskIntoConstraints = false
        veBieuDoSucKhoe.khiChonNhanVien = { [weak self] hs in
            guard let self else { return }
            self.khiChonNhanVienSucKhoe?(hs.tongHopHienTai, self.cheDoSucKhoe)
        }
        let rgCaoBDSK = veBieuDoSucKhoe.heightAnchor.constraint(equalToConstant: 420)
        rgCaoBDSK.isActive = true
        rangBuocCaoBieuDoSucKhoe = rgCaoBDSK

        let nganBDSK = UIStackView(arrangedSubviews: [lbTieuDeBDSK, lbChuThichSK, chonLocNhomSK, veBieuDoSucKhoe])
        nganBDSK.axis = .vertical
        nganBDSK.spacing = 8
        nganBDSK.translatesAutoresizingMaskIntoConstraints = false
        khungBieuDoSK.addSubview(nganBDSK)

        NSLayoutConstraint.activate([
            nganBDSK.topAnchor.constraint(equalTo: khungBieuDoSK.topAnchor, constant: 10),
            nganBDSK.leadingAnchor.constraint(equalTo: khungBieuDoSK.leadingAnchor, constant: 10),
            nganBDSK.trailingAnchor.constraint(equalTo: khungBieuDoSK.trailingAnchor, constant: -10),
            nganBDSK.bottomAnchor.constraint(equalTo: khungBieuDoSK.bottomAnchor, constant: -10)
        ])

        // 5. Khung Bảng Ma Trận Lịch Sử Sức Khỏe Theo Ngày
        let khungMaTran = UIView()
        khungMaTran.backgroundColor = .secondarySystemGroupedBackground
        khungMaTran.layer.cornerRadius = 12
        khungMaTran.layer.borderWidth = 1
        khungMaTran.layer.borderColor = UIColor.separator.withAlphaComponent(0.35).cgColor

        let lbTieuDeMaTran = UILabel()
        lbTieuDeMaTran.text = "🗓️ BẢNG THEO DÕI CHUỖI NGÀY SỨC KHỎE NHÂN VIÊN TRONG THÁNG"
        lbTieuDeMaTran.font = .systemFont(ofSize: 12.0, weight: .bold)
        lbTieuDeMaTran.textColor = .label
        lbTieuDeMaTran.numberOfLines = 0
        lbTieuDeMaTran.lineBreakMode = .byWordWrapping
        lbTieuDeMaTran.adjustsFontSizeToFitWidth = false

        let lbPhuDeMaTran = UILabel()
        lbPhuDeMaTran.text = "Chạm vào từng nhân viên để xem Sức khỏe chi tiết • Vuốt ngang bảng nếu màn hình nhỏ"
        lbPhuDeMaTran.font = .systemFont(ofSize: 10.5, weight: .medium)
        lbPhuDeMaTran.textColor = .secondaryLabel
        lbPhuDeMaTran.numberOfLines = 0

        nganBangMaTranNgay.axis = .vertical
        nganBangMaTranNgay.spacing = 5
        nganBangMaTranNgay.translatesAutoresizingMaskIntoConstraints = false

        cuonNgangMaTran.showsHorizontalScrollIndicator = false
        cuonNgangMaTran.showsVerticalScrollIndicator = false
        cuonNgangMaTran.bounces = true
        cuonNgangMaTran.translatesAutoresizingMaskIntoConstraints = false
        cuonNgangMaTran.addSubview(nganBangMaTranNgay)

        NSLayoutConstraint.activate([
            nganBangMaTranNgay.topAnchor.constraint(equalTo: cuonNgangMaTran.contentLayoutGuide.topAnchor),
            nganBangMaTranNgay.bottomAnchor.constraint(equalTo: cuonNgangMaTran.contentLayoutGuide.bottomAnchor),
            nganBangMaTranNgay.leadingAnchor.constraint(equalTo: cuonNgangMaTran.contentLayoutGuide.leadingAnchor),
            nganBangMaTranNgay.trailingAnchor.constraint(equalTo: cuonNgangMaTran.contentLayoutGuide.trailingAnchor),
            cuonNgangMaTran.heightAnchor.constraint(equalTo: nganBangMaTranNgay.heightAnchor),
            nganBangMaTranNgay.widthAnchor.constraint(greaterThanOrEqualTo: cuonNgangMaTran.frameLayoutGuide.widthAnchor)
        ])

        let nganTrongMaTran = UIStackView(arrangedSubviews: [lbTieuDeMaTran, lbPhuDeMaTran, cuonNgangMaTran])
        nganTrongMaTran.axis = .vertical
        nganTrongMaTran.spacing = 6
        nganTrongMaTran.translatesAutoresizingMaskIntoConstraints = false
        khungMaTran.addSubview(nganTrongMaTran)

        NSLayoutConstraint.activate([
            nganTrongMaTran.topAnchor.constraint(equalTo: khungMaTran.topAnchor, constant: 10),
            nganTrongMaTran.leadingAnchor.constraint(equalTo: khungMaTran.leadingAnchor, constant: 10),
            nganTrongMaTran.trailingAnchor.constraint(equalTo: khungMaTran.trailingAnchor, constant: -10),
            nganTrongMaTran.bottomAnchor.constraint(equalTo: khungMaTran.bottomAnchor, constant: -10)
        ])

        chonKieuXemSK.selectedSegmentIndex = 0
        chonKieuXemSK.backgroundColor = BangMauBCTD.nenThePhu
        chonKieuXemSK.selectedSegmentTintColor = BangMauBCTD.xanhChuDao
        chonKieuXemSK.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
            .foregroundColor: BangMauBCTD.chuPhu
        ], for: .normal)
        chonKieuXemSK.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 12.0, weight: .bold),
            .foregroundColor: UIColor.white
        ], for: .selected)
        chonKieuXemSK.heightAnchor.constraint(equalToConstant: 34).isActive = true
        chonKieuXemSK.addTarget(self, action: #selector(doiKieuXemSucKhoe), for: .valueChanged)

        // Thanh chọn nhân viên cho Bảng thông số Sức khỏe NV
        khungChonNVSucKhoe.backgroundColor = .white
        khungChonNVSucKhoe.layer.cornerRadius = 12
        khungChonNVSucKhoe.layer.borderWidth = 1
        khungChonNVSucKhoe.layer.borderColor = BangMauBCTD.vienThe.cgColor

        for (nut, icon, action) in [
            (nutSKNVTruoc, "chevron.left", #selector(bamSKNVTruoc)),
            (nutSKNVSau, "chevron.right", #selector(bamSKNVSau))
        ] {
            nut.setImage(UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
            nut.tintColor = BangMauBCTD.xanhChuDaoDam
            nut.backgroundColor = BangMauBCTD.nenThePhu
            nut.layer.cornerRadius = 8
            nut.layer.borderWidth = 1
            nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            nut.widthAnchor.constraint(equalToConstant: 36).isActive = true
            nut.heightAnchor.constraint(equalToConstant: 36).isActive = true
            nut.addTarget(self, action: action, for: .touchUpInside)
        }

        nutChonNVSucKhoe.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        nutChonNVSucKhoe.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutChonNVSucKhoe.backgroundColor = BangMauBCTD.nenThePhu
        nutChonNVSucKhoe.layer.cornerRadius = 8
        nutChonNVSucKhoe.layer.borderWidth = 1
        nutChonNVSucKhoe.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutChonNVSucKhoe.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutChonNVSucKhoe.addTarget(self, action: #selector(bamMoMenuChonNVSucKhoe), for: .touchUpInside)

        let hangChonNV = UIStackView(arrangedSubviews: [nutSKNVTruoc, nutChonNVSucKhoe, nutSKNVSau])
        hangChonNV.axis = .horizontal
        hangChonNV.spacing = 6
        hangChonNV.alignment = .center
        hangChonNV.translatesAutoresizingMaskIntoConstraints = false
        khungChonNVSucKhoe.addSubview(hangChonNV)
        NSLayoutConstraint.activate([
            hangChonNV.topAnchor.constraint(equalTo: khungChonNVSucKhoe.topAnchor, constant: 6),
            hangChonNV.bottomAnchor.constraint(equalTo: khungChonNVSucKhoe.bottomAnchor, constant: -6),
            hangChonNV.leadingAnchor.constraint(equalTo: khungChonNVSucKhoe.leadingAnchor, constant: 8),
            hangChonNV.trailingAnchor.constraint(equalTo: khungChonNVSucKhoe.trailingAnchor, constant: -8)
        ])

        let nvKhoiTao = TongHopNhanVien(
            nhanVien: KhoDuLieu.dungChung.caiDat.danhSachNhanVien.first ?? NhanVienQuanLy(maNV: "116719", hoTen: "Đinh Thị Quỳnh Nga"),
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
        let bangCaNhan = BangThongSoSucKhoeNhanVienView(tongHop: nvKhoiTao, ngay: ngayHienTai, cheDo: cheDoSucKhoe)
        bangCaNhan.khiYeuCauCapNhat = { [weak self] in
            self?.capNhatDuLieuSucKhoeNV(epCapNhat: true)
        }
        bangThongSoCaNhanSKView = bangCaNhan

        nganBieuDoDoiNguSK.axis = .vertical
        nganBieuDoDoiNguSK.spacing = 10
        [nutSapXepSK, hangTheSK, khungCanhBao, khungBieuDoSK, khungMaTran].forEach {
            nganBieuDoDoiNguSK.addArrangedSubview($0)
        }
        nganBieuDoDoiNguSK.isHidden = true

        [chonKieuXemSK, chonCheDoSK, khungChonNVSucKhoe, nutXuatAnhSK, nutXuatTatCaAnhSK, bangCaNhan, nganBieuDoDoiNguSK].forEach {
            nganSucKhoeNV.addArrangedSubview($0)
        }
    }

    @objc private func bamChonLoaiBieuDo(_ sender: UIButton) {
        guard let loai = LoaiBieuDoThang(rawValue: sender.tag), loai != loaiBieuDoDangXem else { return }
        loaiBieuDoDangXem = loai
        capNhatGiaoDienHaiNutBieuDo()
        capNhatTheoLoaiDangXem()
        cuonDoc.setContentOffset(.zero, animated: true)
    }

    func chonLoaiBieuDo(_ loai: LoaiBieuDoThang) {
        let doiLoai = (loaiBieuDoDangXem != loai)
        loaiBieuDoDangXem = loai
        capNhatGiaoDienHaiNutBieuDo()
        if doiLoai {
            capNhatTheoLoaiDangXem()
        }
    }

    func hienThiRieng(_ loai: LoaiBieuDoThang) {
        let doiLoai = (loaiBieuDoDangXem != loai)
        loaiBieuDoDangXem = loai
        hangHaiNutBieuDo.isHidden = true
        rangBuocCaoHangChonBieuDo?.constant = 0
        capNhatGiaoDienHaiNutBieuDo()
        if doiLoai {
            capNhatTheoLoaiDangXem()
            cuonDoc.setContentOffset(.zero, animated: false)
        }
    }

    func hienThiBieuDoRealtime() {
        hienThiRieng(.realtime)
    }

    private func capNhatGiaoDienHaiNutBieuDo() {
        let laRT = (loaiBieuDoDangXem == .realtime)
        for (nut, dangChon) in [(nutBieuDoRealtime, laRT), (nutBieuDoSucKhoeNV, !laRT)] {
            if dangChon {
                nut.backgroundColor = BangMauBCTD.nenMenuToi
                nut.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
            } else {
                nut.backgroundColor = BangMauBCTD.nenThePhu
                nut.setTitleColor(BangMauBCTD.chuPhu, for: .normal)
                nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            }
        }
        nganNoiDung.isHidden = !laRT
        nganSucKhoeNV.isHidden = laRT
    }

    @objc private func doiCheDoSucKhoe() {
        cheDoSucKhoe = (chonCheDoSK.selectedSegmentIndex == 1) ? .realtime : .luyKe
        capNhatDuLieuSucKhoeNV()
    }

    @objc private func bamDoiSapXepSK() {
        kieuSapXepSucKhoe = (kieuSapXepSucKhoe + 1) % 3
        UserDefaults.standard.set(kieuSapXepSucKhoe, forKey: Self.khoaKieuSapXepSucKhoe)
        switch kieuSapXepSucKhoe {
        case 0: nutSapXepSK.setTitle("⇅ Yếu → Khỏe", for: .normal)
        case 1: nutSapXepSK.setTitle("⇅ Khỏe → Yếu", for: .normal)
        default: nutSapXepSK.setTitle("⇅ Theo DT QĐ", for: .normal)
        }
        capNhatDanhSachVeBieuDoSK()
    }

    @objc private func doiBoLocNhomSK() {
        boLocNhomSucKhoe = chonLocNhomSK.selectedSegmentIndex
        capNhatDanhSachVeBieuDoSK()
    }

    @objc private func doiKieuXemSucKhoe() {
        let xemBangThongSo = (chonKieuXemSK.selectedSegmentIndex == 0)
        khungChonNVSucKhoe.isHidden = !xemBangThongSo
        bangThongSoCaNhanSKView?.isHidden = !xemBangThongSo
        nganBieuDoDoiNguSK.isHidden = xemBangThongSo
        nutXuatAnhSK.setTitle(
            xemBangThongSo ? "📸 XUẤT ẢNH BẢNG THÔNG SỐ SỨC KHỎE NV" : "📸 XUẤT ẢNH BIỂU ĐỒ SỨC KHỎE ĐỘI NGŨ",
            for: .normal
        )
    }

    private func danhSachTongHopNVSucKhoe() -> [TongHopNhanVien] {
        KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .doanhThuQD, cheDo: cheDoSucKhoe)
    }

    private func capNhatBangThongSoCaNhanDangChon() {
        let ds = danhSachTongHopNVSucKhoe()
        guard !ds.isEmpty else { return }
        let chon: TongHopNhanVien
        let idx: Int
        if let viTri = ds.firstIndex(where: { $0.nhanVien.maNV == maNVSucKhoeDangChon }) {
            chon = ds[viTri]
            idx = viTri
        } else {
            chon = ds[0]
            idx = 0
            maNVSucKhoeDangChon = chon.nhanVien.maNV
        }
        let dtStr = chon.doanhThuQD > 0 ? " • \(chon.doanhThuQD.chuoiSoGonVN) tr" : ""
        nutChonNVSucKhoe.setTitle("👤 \(idx + 1)/\(ds.count). \(chon.nhanVien.hoTen) (id: \(chon.nhanVien.maNV))\(dtStr) ▾", for: .normal)
        bangThongSoCaNhanSKView?.capNhat(tongHop: chon, ngay: ngayHienTai, cheDo: cheDoSucKhoe)
    }

    @objc private func bamSKNVTruoc() {
        let ds = danhSachTongHopNVSucKhoe()
        guard !ds.isEmpty else { return }
        let idx = ds.firstIndex(where: { $0.nhanVien.maNV == maNVSucKhoeDangChon }) ?? 0
        let moi = (idx - 1 + ds.count) % ds.count
        maNVSucKhoeDangChon = ds[moi].nhanVien.maNV
        capNhatBangThongSoCaNhanDangChon()
    }

    @objc private func bamSKNVSau() {
        let ds = danhSachTongHopNVSucKhoe()
        guard !ds.isEmpty else { return }
        let idx = ds.firstIndex(where: { $0.nhanVien.maNV == maNVSucKhoeDangChon }) ?? 0
        let moi = (idx + 1) % ds.count
        maNVSucKhoeDangChon = ds[moi].nhanVien.maNV
        capNhatBangThongSoCaNhanDangChon()
    }

    @objc private func bamMoMenuChonNVSucKhoe() {
        guard let vc = timViewControllerCha() else { return }
        let ds = danhSachTongHopNVSucKhoe()
        guard !ds.isEmpty else { return }
        var cacMuc: [MucChonDMX] = ds.enumerated().map { i, item in
            let dtStr = item.doanhThuQD > 0 ? "\(item.doanhThuQD.chuoiSoGonVN) tr" : "--"
            return MucChonDMX(
                tieuDe: "\(i + 1). \(item.nhanVien.hoTen) (id: \(item.nhanVien.maNV)) • DT QĐ: \(dtStr)",
                dangChon: item.nhanVien.maNV == maNVSucKhoeDangChon
            ) { [weak self] in
                guard let self else { return }
                self.maNVSucKhoeDangChon = item.nhanVien.maNV
                self.capNhatBangThongSoCaNhanDangChon()
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        vc.hienMenuChon(tieuDe: "Chọn nhân viên xem Bảng thông số Sức khỏe", cacMuc: cacMuc)
    }

    @objc private func bamXuatTatCaAnhSucKhoe() {
        if let khiXuatTatCaAnhSucKhoeNV {
            khiXuatTatCaAnhSucKhoeNV()
            return
        }
        let cacAnh = ManHinhChiTietNhanVien.taoTatCaAnhSucKhoe(cho: ngayHienTai, cheDo: cheDoSucKhoe)
        guard !cacAnh.isEmpty, let vc = timViewControllerCha() else { return }
        let hd = UIActivityViewController(activityItems: cacAnh, applicationActivities: nil)
        if let pop = hd.popoverPresentationController {
            pop.sourceView = nutXuatTatCaAnhSK
            pop.sourceRect = nutXuatTatCaAnhSK.bounds
        }
        vc.present(hd, animated: true)
    }

    @objc private func bamXuatAnhSucKhoe() {
        if chonKieuXemSK.selectedSegmentIndex == 0 {
            let ds = danhSachTongHopNVSucKhoe()
            if let chon = ds.first(where: { $0.nhanVien.maNV == maNVSucKhoeDangChon }) ?? ds.first,
               let anh = BangThongSoSucKhoeNhanVienView.taoAnhBaoCao(cho: chon, ngay: ngayHienTai, cheDo: cheDoSucKhoe) {
                if let khiChiaSeAnhSucKhoe {
                    khiChiaSeAnhSucKhoe(anh)
                } else if let vc = timViewControllerCha() {
                    let hd = UIActivityViewController(activityItems: [anh], applicationActivities: nil)
                    if let pop = hd.popoverPresentationController {
                        pop.sourceView = nutXuatAnhSK
                        pop.sourceRect = nutXuatAnhSK.bounds
                    }
                    vc.present(hd, animated: true)
                }
                return
            }
        }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        guard let anh = taoAnhBaoCaoSucKhoeNhanVien(
            ngay: ngayHienTai,
            thongTinDonVi: dl.thongTinDonVi,
            capNhatLuc: dl.capNhatLuc
        ) else { return }
        if let khiChiaSeAnhSucKhoe {
            khiChiaSeAnhSucKhoe(anh)
        } else if let vc = timViewControllerCha() {
            let hd = UIActivityViewController(activityItems: [anh], applicationActivities: nil)
            if let pop = hd.popoverPresentationController {
                pop.sourceView = nutXuatAnhSK
                pop.sourceRect = nutXuatAnhSK.bounds
            }
            vc.present(hd, animated: true)
        }
    }

    @objc private func bamTheCanhBaoTop5(_ sender: UIControl) {
        let idx = sender.tag
        guard idx >= 0 && idx < dsTop5DangHienThi.count else { return }
        khiChonNhanVienSucKhoe?(dsTop5DangHienThi[idx].tongHopHienTai, cheDoSucKhoe)
    }

    private func taoTheCanhBaoNhanVienYeu(hoSo: HoSoSucKhoeNhanVien, hang: Int, chiSo: Int) -> UIControl {
        let the = UIControl()
        the.tag = chiSo
        the.backgroundColor = .systemBackground
        the.layer.cornerRadius = 10
        the.layer.borderWidth = 1
        the.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.32).cgColor
        the.addTarget(self, action: #selector(bamTheCanhBaoTop5(_:)), for: .touchUpInside)

        let lbTen = UILabel()
        lbTen.text = "🚨 #\(hang). \(hoSo.nhanVien.hoTen) (\(hoSo.nhanVien.maNV))"
        lbTen.font = .systemFont(ofSize: 13.0, weight: .bold)
        lbTen.textColor = UIColor(red: 0.75, green: 0.10, blue: 0.10, alpha: 1)
        lbTen.numberOfLines = 0
        lbTen.lineBreakMode = .byWordWrapping
        lbTen.adjustsFontSizeToFitWidth = false

        let lbBadge = UILabel()
        lbBadge.text = " \(hoSo.chuoiCanhBaoYeu) • SK: \(hoSo.diemSucKhoe.chuoiPhanTram) "
        lbBadge.font = .systemFont(ofSize: 11.0, weight: .heavy)
        lbBadge.textColor = .white
        lbBadge.backgroundColor = UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1)
        lbBadge.layer.cornerRadius = 6
        lbBadge.clipsToBounds = true
        lbBadge.textAlignment = .center
        lbBadge.numberOfLines = 0
        lbBadge.lineBreakMode = .byWordWrapping
        lbBadge.adjustsFontSizeToFitWidth = false
        lbBadge.setContentHuggingPriority(.required, for: .horizontal)
        lbBadge.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hangTren = UIStackView(arrangedSubviews: [lbTen, lbBadge])
        hangTren.axis = .horizontal
        hangTren.spacing = 6
        hangTren.alignment = .top
        hangTren.isUserInteractionEnabled = false

        let th = hoSo.tongHopHienTai
        let chuoiDT = th.doanhThuQD > 0 ? "  •  DT QĐ: \(th.doanhThuQD.chuoiSoGonVN)tr" : ""
        let lbChiSo = UILabel()
        lbChiSo.text = "📊 Môn đạt: \(th.soMonDat)/\(th.tongMonGiao) môn (HT TB: \(th.phanTramHTTB.chuoiPhanTramVN))\(chuoiDT)  •  \(hoSo.nhanXuHuong)"
        lbChiSo.font = .systemFont(ofSize: 11.5, weight: .semibold)
        lbChiSo.textColor = .label
        lbChiSo.numberOfLines = 0
        lbChiSo.lineBreakMode = .byWordWrapping
        lbChiSo.adjustsFontSizeToFitWidth = false
        lbChiSo.isUserInteractionEnabled = false

        let chuoiLichSu = hoSo.lichSuNgay.map { "\($0.nhanNgay): \($0.mucDo.kyHieu) \(Int(round($0.diemSucKhoe)))%" }.joined(separator: "  ➔  ")
        let lbLichSu = UILabel()
        lbLichSu.text = "🗓️ Chuỗi ngày: \(chuoiLichSu.isEmpty ? "Chưa có lịch sử ngày" : chuoiLichSu)"
        lbLichSu.font = .systemFont(ofSize: 11.0, weight: .medium)
        lbLichSu.textColor = .secondaryLabel
        lbLichSu.numberOfLines = 0
        lbLichSu.lineBreakMode = .byWordWrapping
        lbLichSu.adjustsFontSizeToFitWidth = false
        lbLichSu.isUserInteractionEnabled = false

        let cacView: [UIView]
        if !hoSo.cacMonYeuNhat.isEmpty {
            let lbMonYeu = UILabel()
            lbMonYeu.text = "🎯 Ngành yếu cần kèm: \(hoSo.cacMonYeuNhat.joined(separator: "  |  "))"
            lbMonYeu.font = .systemFont(ofSize: 11.0, weight: .bold)
            lbMonYeu.textColor = UIColor(red: 0.78, green: 0.28, blue: 0.04, alpha: 1)
            lbMonYeu.numberOfLines = 0
            lbMonYeu.lineBreakMode = .byWordWrapping
            lbMonYeu.adjustsFontSizeToFitWidth = false
            lbMonYeu.isUserInteractionEnabled = false
            cacView = [hangTren, lbChiSo, lbLichSu, lbMonYeu]
        } else {
            cacView = [hangTren, lbChiSo, lbLichSu]
        }

        let ngan = UIStackView(arrangedSubviews: cacView)
        ngan.axis = .vertical
        ngan.spacing = 4
        ngan.isUserInteractionEnabled = false
        ngan.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: the.topAnchor, constant: 8),
            ngan.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -10),
            ngan.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -8)
        ])

        return the
    }

    private func capNhatDuLieuSucKhoeNV(epCapNhat: Bool = false) {
        let khoaNgay = TienIchNgay.khoa.string(from: ngayHienTai)
        let phienBan = KhoDuLieu.dungChung.phienBanDuLieu
        if !epCapNhat,
           khoaNgayDaNapSK == khoaNgay,
           phienBanDaNapSK == phienBan,
           cheDoDaNapSK == cheDoSucKhoe,
           baoCaoSucKhoeHienTai != nil {
            return
        }
        khoaNgayDaNapSK = khoaNgay
        phienBanDaNapSK = phienBan
        cheDoDaNapSK = cheDoSucKhoe

        let bc = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngayHienTai, cheDo: cheDoSucKhoe)
        baoCaoSucKhoeHienTai = bc

        let soCanhBao = bc.top5CanhBaoYeu.count
        if soCanhBao > 0 {
            nutBieuDoSucKhoeNV.setTitle("❤️‍🩹 Sức khỏe NV (\(soCanhBao)⚠️)", for: .normal)
        } else {
            nutBieuDoSucKhoeNV.setTitle("❤️‍🩹 Biểu đồ sức khỏe NV", for: .normal)
        }

        theSKKhoe.capNhatNoiDung(
            chinh: "\(bc.soNVKhoe) NV",
            phu: "CHUẨN >= 75%"
        )
        theSKTrungBinh.capNhatNoiDung(
            chinh: "\(bc.soNVTrungBinh) NV",
            phu: "MỨC 55% - 74%"
        )
        theSKYeu.capNhatNoiDung(
            chinh: "\(bc.soNVYeu) NV",
            phu: "CẦN KÈM CẶP"
        )
        theSKDiemDoi.capNhatNoiDung(
            chinh: bc.diemTrungBinhDoiNgu.chuoiPhanTram,
            phu: "THEO DÕI: \(bc.soNgayDaTheoDoi) NGÀY"
        )

        chonLocNhomSK.setTitle("Tất cả (\(bc.danhSachTatCa.count))", forSegmentAt: 0)
        chonLocNhomSK.setTitle("Yếu (\(bc.soNVYeu))", forSegmentAt: 1)
        chonLocNhomSK.setTitle("TB (\(bc.soNVTrungBinh))", forSegmentAt: 2)
        chonLocNhomSK.setTitle("Khỏe (\(bc.soNVKhoe))", forSegmentAt: 3)
        chonLocNhomSK.damBaoHienThiDayDuText()

        // Cập nhật danh sách 5 nhân viên cảnh báo yếu nhiều ngày liên tục
        nganDanhSachTop5.arrangedSubviews.forEach {
            nganDanhSachTop5.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        dsTop5DangHienThi = bc.top5CanhBaoYeu

        if bc.top5CanhBaoYeu.isEmpty {
            let lbTrong = UILabel()
            lbTrong.text = "Chưa có danh sách nhân viên. Hãy thêm nhân viên trong Cài đặt (⚙️) để theo dõi sức khỏe và cảnh báo nhân viên yếu liên tục."
            lbTrong.font = .systemFont(ofSize: 12.0, weight: .medium)
            lbTrong.textColor = .secondaryLabel
            lbTrong.numberOfLines = 0
            lbTrong.lineBreakMode = .byWordWrapping
            nganDanhSachTop5.addArrangedSubview(lbTrong)
        } else {
            for (i, hs) in bc.top5CanhBaoYeu.enumerated() {
                let the = taoTheCanhBaoNhanVienYeu(hoSo: hs, hang: i + 1, chiSo: i)
                nganDanhSachTop5.addArrangedSubview(the)
            }
        }

        capNhatBangThongSoCaNhanDangChon()
        capNhatDanhSachVeBieuDoSK()
        capNhatBangMaTranNgay(bc)
    }

    private func danhSachHoSoSauLocVaSapXep(tu bc: BaoCaoSucKhoeDoiNgu) -> [HoSoSucKhoeNhanVien] {
        var ds = bc.danhSachTatCa
        switch boLocNhomSucKhoe {
        case 1: ds = ds.filter { $0.mucDo == .yeu }
        case 2: ds = ds.filter { $0.mucDo == .trungBinh }
        case 3: ds = ds.filter { $0.mucDo == .khoe }
        default: break
        }

        switch kieuSapXepSucKhoe {
        case 0: // Yếu -> Khỏe (ưu tiên nhân viên yếu liên tục lên đầu để dễ giám sát)
            ds.sort { a, b in
                if a.laCanhBaoTop5 != b.laCanhBaoTop5 { return a.laCanhBaoTop5 && !b.laCanhBaoTop5 }
                if let ha = a.hangCanhBao, let hb = b.hangCanhBao, ha != hb { return ha < hb }
                if a.soNgayYeuLienTuc != b.soNgayYeuLienTuc { return a.soNgayYeuLienTuc > b.soNgayYeuLienTuc }
                if abs(a.diemSucKhoe - b.diemSucKhoe) > 0.05 { return a.diemSucKhoe < b.diemSucKhoe }
                return a.tongHopHienTai.phanTramHTTB < b.tongHopHienTai.phanTramHTTB
            }
        case 1: // Khỏe -> Yếu
            ds.sort { a, b in
                if abs(a.diemSucKhoe - b.diemSucKhoe) > 0.05 { return a.diemSucKhoe > b.diemSucKhoe }
                return a.tongHopHienTai.phanTramHTTB > b.tongHopHienTai.phanTramHTTB
            }
        default: // Theo DT QĐ Cao -> Thấp
            ds.sort { a, b in
                if abs(a.tongHopHienTai.doanhThuQD - b.tongHopHienTai.doanhThuQD) > 0.01 {
                    return a.tongHopHienTai.doanhThuQD > b.tongHopHienTai.doanhThuQD
                }
                return a.diemSucKhoe > b.diemSucKhoe
            }
        }
        return ds
    }

    private func capNhatDanhSachVeBieuDoSK() {
        guard let bc = baoCaoSucKhoeHienTai else { return }
        let ds = danhSachHoSoSauLocVaSapXep(tu: bc)
        veBieuDoSucKhoe.danhSachHoSo = ds
        rangBuocCaoBieuDoSucKhoe?.constant = veBieuDoSucKhoe.chieuCaoCanThiet(cho: ds.count)
        capNhatBangMaTranNgay(bc)
    }

    private func capNhatBangMaTranNgay(_ bc: BaoCaoSucKhoeDoiNgu) {
        nganBangMaTranNgay.arrangedSubviews.forEach {
            nganBangMaTranNgay.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        guard !bc.danhSachTatCa.isEmpty else { return }
        let cacNgay = Array(bc.cacNhanNgayTheoDoi.suffix(6))
        let dsSapXep = danhSachHoSoSauLocVaSapXep(tu: bc)
        dsMaTranDangHienThi = dsSapXep

        let wCotTenToiThieu: CGFloat = 132
        let wCotNgay: CGFloat = 38
        let wCotChuoi: CGFloat = 48

        // Dòng tiêu đề cột
        let header = UIStackView()
        header.axis = .horizontal
        header.spacing = 5
        header.alignment = .center
        header.backgroundColor = BangMauBCTD.nenHeaderBang
        header.layer.cornerRadius = 8
        header.isLayoutMarginsRelativeArrangement = true
        header.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let lbHNV = UILabel()
        lbHNV.text = "NHÂN VIÊN (\(dsSapXep.count))"
        lbHNV.font = .systemFont(ofSize: 11.0, weight: .bold)
        lbHNV.textColor = BangMauBCTD.vangChuDao
        lbHNV.numberOfLines = 1
        lbHNV.lineBreakMode = .byTruncatingTail
        lbHNV.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbHNV.setContentCompressionResistancePriority(.required, for: .horizontal)
        lbHNV.widthAnchor.constraint(greaterThanOrEqualToConstant: wCotTenToiThieu).isActive = true
        header.addArrangedSubview(lbHNV)

        for ng in cacNgay {
            let lb = UILabel()
            lb.text = ng
            lb.font = .monospacedDigitSystemFont(ofSize: 10.0, weight: .bold)
            lb.textColor = .white
            lb.textAlignment = .center
            lb.setContentHuggingPriority(.required, for: .horizontal)
            lb.setContentCompressionResistancePriority(.required, for: .horizontal)
            lb.widthAnchor.constraint(equalToConstant: wCotNgay).isActive = true
            header.addArrangedSubview(lb)
        }

        let lbHChuoi = UILabel()
        lbHChuoi.text = "CHUỖI"
        lbHChuoi.font = .systemFont(ofSize: 10.0, weight: .bold)
        lbHChuoi.textColor = BangMauBCTD.vangChuDao
        lbHChuoi.textAlignment = .center
        lbHChuoi.setContentHuggingPriority(.required, for: .horizontal)
        lbHChuoi.setContentCompressionResistancePriority(.required, for: .horizontal)
        lbHChuoi.widthAnchor.constraint(equalToConstant: wCotChuoi).isActive = true
        header.addArrangedSubview(lbHChuoi)

        nganBangMaTranNgay.addArrangedSubview(header)

        for (idx, hs) in dsSapXep.enumerated() {
            let dong = UIStackView()
            dong.axis = .horizontal
            dong.spacing = 5
            dong.alignment = .center
            dong.layer.cornerRadius = 8
            dong.isLayoutMarginsRelativeArrangement = true
            dong.layoutMargins = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
            dong.tag = idx
            dong.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(bamDongMaTranNgay(_:)))
            dong.addGestureRecognizer(tap)

            if hs.laCanhBaoTop5 {
                dong.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
                dong.layer.borderWidth = 0.8
                dong.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.22).cgColor
            } else if idx % 2 == 1 {
                dong.backgroundColor = UIColor.secondarySystemFill.withAlphaComponent(0.32)
            } else {
                dong.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
            }

            let lbTen = UILabel()
            lbTen.text = "\(idx + 1). \(hs.nhanVien.hoTen)"
            lbTen.font = .systemFont(ofSize: 11.5, weight: hs.laCanhBaoTop5 ? .bold : .semibold)
            lbTen.textColor = hs.laCanhBaoTop5 ? UIColor(red: 0.76, green: 0.10, blue: 0.10, alpha: 1) : .label
            lbTen.numberOfLines = 1
            lbTen.lineBreakMode = .byTruncatingTail
            lbTen.adjustsFontSizeToFitWidth = true
            lbTen.minimumScaleFactor = 0.80
            lbTen.setContentHuggingPriority(.defaultLow, for: .horizontal)
            lbTen.setContentCompressionResistancePriority(.required, for: .horizontal)
            lbTen.widthAnchor.constraint(greaterThanOrEqualToConstant: wCotTenToiThieu).isActive = true
            dong.addArrangedSubview(lbTen)

            let mapNgay = Dictionary(uniqueKeysWithValues: hs.lichSuNgay.map { ($0.nhanNgay, $0) })
            for ng in cacNgay {
                let lbO = UILabel()
                lbO.font = .monospacedDigitSystemFont(ofSize: 10.0, weight: .bold)
                lbO.textAlignment = .center
                lbO.layer.cornerRadius = 6
                lbO.clipsToBounds = true
                lbO.setContentHuggingPriority(.required, for: .horizontal)
                lbO.setContentCompressionResistancePriority(.required, for: .horizontal)
                lbO.widthAnchor.constraint(equalToConstant: wCotNgay).isActive = true
                lbO.heightAnchor.constraint(equalToConstant: 24).isActive = true

                if let diemNg = mapNgay[ng], diemNg.mucDo != .chuaCoSo {
                    lbO.text = "\(Int(round(diemNg.diemSucKhoe)))%"
                    switch diemNg.mucDo {
                    case .khoe:
                        lbO.backgroundColor = UIColor(red: 0.86, green: 0.98, blue: 0.90, alpha: 1)
                        lbO.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
                    case .trungBinh:
                        lbO.backgroundColor = UIColor(red: 0.99, green: 0.95, blue: 0.78, alpha: 1)
                        lbO.textColor = UIColor(red: 0.70, green: 0.35, blue: 0.04, alpha: 1)
                    case .yeu:
                        lbO.backgroundColor = UIColor(red: 0.99, green: 0.86, blue: 0.86, alpha: 1)
                        lbO.textColor = UIColor(red: 0.76, green: 0.10, blue: 0.10, alpha: 1)
                    case .chuaCoSo:
                        lbO.backgroundColor = .systemGray6
                        lbO.textColor = .secondaryLabel
                    }
                } else {
                    lbO.text = "--"
                    lbO.backgroundColor = .systemGray6
                    lbO.textColor = .secondaryLabel
                }
                dong.addArrangedSubview(lbO)
            }

            let lbChuoi = UILabel()
            lbChuoi.font = .systemFont(ofSize: 10.0, weight: .bold)
            lbChuoi.textAlignment = .center
            lbChuoi.layer.cornerRadius = 6
            lbChuoi.clipsToBounds = true
            lbChuoi.setContentHuggingPriority(.required, for: .horizontal)
            lbChuoi.setContentCompressionResistancePriority(.required, for: .horizontal)
            lbChuoi.widthAnchor.constraint(equalToConstant: wCotChuoi).isActive = true
            lbChuoi.heightAnchor.constraint(equalToConstant: 24).isActive = true
            if hs.soNgayYeuLienTuc > 0 {
                lbChuoi.text = "🔥\(hs.soNgayYeuLienTuc)N"
                lbChuoi.textColor = UIColor(red: 0.76, green: 0.10, blue: 0.10, alpha: 1)
                lbChuoi.backgroundColor = UIColor.systemRed.withAlphaComponent(0.14)
            } else {
                lbChuoi.text = "✓ 0N"
                lbChuoi.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
                lbChuoi.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
            }
            dong.addArrangedSubview(lbChuoi)

            nganBangMaTranNgay.addArrangedSubview(dong)
        }
    }

    @objc private func bamDongMaTranNgay(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let idx = view.tag
        guard idx >= 0 && idx < dsMaTranDangHienThi.count else { return }
        khiChonNhanVienSucKhoe?(dsMaTranDangHienThi[idx].tongHopHienTai, cheDoSucKhoe)
    }

    @objc private func bamSuaLuyKe() {
        khiBamSuaDoanhThuLuyKe?()
    }

    @objc private func doiCheDoLocNgay() {
        chiHienNgayCoSo = (chonCheDoNgay.selectedSegmentIndex == 1)
        capNhatDuLieuHienThi(epCapNhat: true)
    }

    func capNhat(cho ngay: Date) {
        self.ngayHienTai = ngay
        capNhatTheoLoaiDangXem()
    }

    private func capNhatTheoLoaiDangXem() {
        if loaiBieuDoDangXem == .realtime {
            capNhatDuLieuHienThi()
        } else {
            capNhatDuLieuSucKhoeNV()
        }
    }

    private func damBaoDuLieuRealtimeThang(cho ngay: Date) {
        self.ngayHienTai = ngay
        capNhatDuLieuHienThi()
    }

    private func taoNoiDungTomTatThang(
        dsCoSo: [DuLieuRealtimeNgayTrongThang],
        duBao: DuBaoQuyDoiThang
    ) -> (dong1: String, dong2: String, trangThaiDK: String) {
        let tongRTThuc = dsCoSo.reduce(0.0) { $0 + $1.doanhThuThuc }
        let tongRTQD = dsCoSo.reduce(0.0) { $0 + $1.doanhThuQuyDoi }
        let d1 = "🟦 DT Thực (\(dsCoSo.count) ngày): \(tongRTThuc.chuoiSoVN) (TB: \(duBao.trungBinhThucMoiNgay.chuoiSoVN)/ngày)  •  🟩 DT QĐ: \(tongRTQD.chuoiSoVN) (TB: \(duBao.trungBinhQDMoiNgay.chuoiSoVN)/ngày)"

        if duBao.phanTramHTQDDuKien > 0 || duBao.mucTieuThang > 0 {
            let kq = duBao.daHoanThanhDuKien ? "✅ ĐẠT MỤC TIÊU" : "⚠️ CHƯA ĐẠT"
            if duBao.mucTieuThang > 0 {
                let chenh = duBao.chenhLechDuKienCuoiThang
                let chuoiChenh = chenh >= 0 ? "Vượt +\(chenh.chuoiSoVN)" : "Thiếu \(abs(chenh).chuoiSoVN)"
                let d2 = "🎯 Target QĐ tháng: \(duBao.mucTieuThang.chuoiSoVN)  •  DK cuối tháng: \(duBao.duKienQDCuoiThang.chuoiSoVN) (\(duBao.phanTramHTQDDuKien.chuoiPhanTramVN) - \(kq) • \(chuoiChenh))"
                return (d1, d2, kq)
            } else {
                let d2 = "📈 DK cuối tháng: DT Thực DK: \(duBao.duKienThucCuoiThang.chuoiSoVN)  •  DT QĐ DK: \(duBao.duKienQDCuoiThang.chuoiSoVN) (\(duBao.phanTramHTQDDuKien.chuoiPhanTramVN) - \(kq))"
                return (d1, d2, kq)
            }
        } else {
            let d2 = "📈 DK cuối tháng (\(duBao.soNgayTrongThang) ngày): DT Thực DK: \(duBao.duKienThucCuoiThang.chuoiSoVN)  •  DT QĐ DK: \(duBao.duKienQDCuoiThang.chuoiSoVN)"
            return (d1, d2, "CHƯA CÓ TARGET")
        }
    }

    private func capNhatDuLieuHienThi(epCapNhat: Bool = false) {
        let khoaNgay = TienIchNgay.khoa.string(from: ngayHienTai)
        let phienBan = KhoDuLieu.dungChung.phienBanDuLieu
        if !epCapNhat,
           khoaNgayDaNapRT == khoaNgay,
           phienBanDaNapRT == phienBan,
           chiHienCoSoDaNapRT == chiHienNgayCoSo,
           !tatCaNgayTrongThang.isEmpty {
            return
        }
        khoaNgayDaNapRT = khoaNgay
        phienBanDaNapRT = phienBan
        chiHienCoSoDaNapRT = chiHienNgayCoSo
        self.doanhThuLuyKe = KhoDuLieu.dungChung.doanhThuLuyKeThang(cho: ngayHienTai)
        self.tatCaNgayTrongThang = KhoDuLieu.dungChung.danhSachRealtimeTheoNgayTrongThang(cho: ngayHienTai)

        let thang = TienIchNgay.lich.component(.month, from: ngayHienTai)
        let nam = TienIchNgay.lich.component(.year, from: ngayHienTai)
        let ngayChon = TienIchNgay.lich.component(.day, from: ngayHienTai)
        nhanTieuDeLuyKe.text = "📌 DOANH THU LŨY KẾ THÁNG \(String(format: "%02d/%04d", thang, nam)) (CỐ ĐỊNH — NHẬP MỚI THAY THẾ NGÀY TRƯỚC)"

        if doanhThuLuyKe.coDuLieu {
            theLuyKeThuc.capNhatNoiDung(
                chinh: doanhThuLuyKe.doanhThuThuc.chuoiSoGonVN,
                phu: "TARGET: \(doanhThuLuyKe.targetThuc.chuoiSoGonVN) | HT: \(doanhThuLuyKe.phanTramHTThucHienThi.chuoiPhanTram)"
            )
            theLuyKeQD.capNhatNoiDung(
                chinh: doanhThuLuyKe.doanhThuQuyDoi.chuoiSoGonVN,
                phu: "TARGET: \(doanhThuLuyKe.targetQuyDoi.chuoiSoGonVN) | HT: \(doanhThuLuyKe.phanTramHTQDDuKienHienThi.chuoiPhanTram)"
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

        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngayHienTai, cheDoDangXem: .realtime)
        let tomTat = taoNoiDungTomTatThang(dsCoSo: dsCoSo, duBao: duBao)
        nhanTomTatRT.numberOfLines = 0
        nhanTomTatRT.text = "\(tomTat.dong1)\n\(tomTat.dong2)"

        veBieuDo.ngayDangChon = ngayChon
        veBieuDo.danhSachNgay = danhSachBieuDo
        let rongCan = max(bounds.width - 20, 62 + CGFloat(max(1, danhSachBieuDo.count)) * veBieuDo.chieuRongMoiNgay)
        rangBuocRongBieuDo?.constant = rongCan

        let soDong = danhSachBieuDo.count + soDongTongKetCuoiBang
        rangBuocCaoBang?.constant = 42 + CGFloat(soDong) * chieuCaoMoiDongBang
        bangNgay.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachBieuDo.count + soDongTongKetCuoiBang
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 42))
        header.backgroundColor = BangMauBCTD.nenHeaderBang
        let tieuDe = ["NGÀY / MỤC", "DT THỰC (RT)", "DT QUY ĐỔI (RT)", "% QUY ĐỔI", "KHÁCH / BILL", "DK / ĐÁNH GIÁ"]
        let tyLe: [CGFloat] = [0.16, 0.17, 0.18, 0.13, 0.16, 0.20]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(stack)
        let vachVang = UIView()
        vachVang.backgroundColor = BangMauBCTD.vangChuDao
        vachVang.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(vachVang)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: header.topAnchor),
            stack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -2.5),
            vachVang.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            vachVang.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            vachVang.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            vachVang.heightAnchor.constraint(equalToConstant: 2.5)
        ])
        for (i, chu) in tieuDe.enumerated() {
            let lb = UILabel()
            lb.text = chu
            lb.font = .systemFont(ofSize: 10.5, weight: .bold)
            lb.textColor = (i == 2 || i == 5) ? BangMauBCTD.vangChuDao : .white
            lb.numberOfLines = 0
            lb.lineBreakMode = .byWordWrapping
            lb.adjustsFontSizeToFitWidth = false
            lb.textAlignment = (i == 0) ? .left : .right
            stack.addArrangedSubview(lb)
            lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
        }
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        42
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongRTThangCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let tyLe: [CGFloat] = [0.16, 0.17, 0.18, 0.13, 0.16, 0.20]
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

        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngayHienTai, cheDoDangXem: .realtime)
        let dsCoSo = tatCaNgayTrongThang.filter { $0.coDuLieu }
        let fontDongNhat = UIFont.monospacedDigitSystemFont(ofSize: 11.5, weight: .bold)

        if indexPath.row >= danhSachBieuDo.count {
            cell.selectionStyle = .none
            let loaiTongKet = indexPath.row - danhSachBieuDo.count
            let tongRTThuc = dsCoSo.reduce(0.0) { $0 + $1.doanhThuThuc }
            let tongRTQD = dsCoSo.reduce(0.0) { $0 + $1.doanhThuQuyDoi }
            let tongKhach = dsCoSo.reduce(0.0) { $0 + $1.luotKhach }
            let tongBill = dsCoSo.reduce(0.0) { $0 + $1.soBill }
            let ptQDTong = tongRTThuc > 0 ? ((tongRTQD - tongRTThuc) / tongRTThuc * 100.0) : 0

            let giaTri: [String]
            let mauChuCuoi: UIColor
            if loaiTongKet == 0 {
                cell.backgroundColor = BangMauBCTD.indigoNhatNen
                let mtDenNay = duBao.mucTieuMoiNgay * Double(max(1, dsCoSo.count))
                let ptDenNay = mtDenNay > 0 ? (tongRTQD / mtDenNay * 100.0) : 0
                let danhGia = mtDenNay > 0
                    ? (ptDenNay >= 99.995 ? "✅ Đạt (\(ptDenNay.chuoiPhanTram))" : "⚠️ \(ptDenNay.chuoiPhanTram)")
                    : "\(dsCoSo.count) ngày RT"
                mauChuCuoi = (mtDenNay > 0) ? BangMauBCTD.mauTrangThai(phanTram: ptDenNay).chu : BangMauBCTD.chuChinh
                giaTri = [
                    "TỔNG (\(dsCoSo.count)N)",
                    tongRTThuc.chuoiSoVN,
                    tongRTQD.chuoiSoVN,
                    ptQDTong.chuoiPhanTram,
                    "\(tongKhach.chuoiSoNguyenVN)/\(tongBill.chuoiSoNguyenVN)",
                    danhGia
                ]
            } else if loaiTongKet == 1 {
                cell.backgroundColor = UIColor.systemGray6
                let soN = Double(max(1, dsCoSo.count))
                let tbKhach = dsCoSo.isEmpty ? 0 : (tongKhach / soN)
                let tbBill = dsCoSo.isEmpty ? 0 : (tongBill / soN)
                let chuoiMTNgay = duBao.mucTieuMoiNgay > 0 ? "Target: \(duBao.mucTieuMoiNgay.chuoiSoGonVN)/ngày" : "TB \(dsCoSo.count) ngày"
                mauChuCuoi = .secondaryLabel
                giaTri = [
                    "TB / NGÀY",
                    duBao.trungBinhThucMoiNgay.chuoiSoVN,
                    duBao.trungBinhQDMoiNgay.chuoiSoVN,
                    ptQDTong.chuoiPhanTram,
                    "\(tbKhach.chuoiSoNguyenVN)/\(tbBill.chuoiSoNguyenVN)",
                    chuoiMTNgay
                ]
            } else {
                let dat = duBao.daHoanThanhDuKien
                let coPT = duBao.phanTramHTQDDuKien > 0 || duBao.mucTieuThang > 0
                cell.backgroundColor = coPT
                    ? (dat ? UIColor.systemGreen.withAlphaComponent(0.14) : UIColor.systemOrange.withAlphaComponent(0.15))
                    : UIColor.systemPurple.withAlphaComponent(0.08)
                let soN = Double(max(1, dsCoSo.count))
                let dkKhach = dsCoSo.isEmpty ? 0 : (tongKhach / soN * Double(duBao.soNgayTrongThang))
                let dkBill = dsCoSo.isEmpty ? 0 : (tongBill / soN * Double(duBao.soNgayTrongThang))
                let chuoiTrangThaiDK: String
                if coPT {
                    let kq = dat ? "✅ ĐẠT" : "⚠️ CHƯA ĐẠT"
                    chuoiTrangThaiDK = "\(kq) (\(duBao.phanTramHTQDDuKien.chuoiPhanTram))"
                } else {
                    chuoiTrangThaiDK = "--"
                }
                mauChuCuoi = coPT
                    ? (dat ? UIColor(red: 0.06, green: 0.52, blue: 0.24, alpha: 1) : UIColor(red: 0.80, green: 0.14, blue: 0.14, alpha: 1))
                    : .secondaryLabel
                giaTri = [
                    "DK CUỐI THÁNG",
                    duBao.duKienThucCuoiThang.chuoiSoVN,
                    duBao.duKienQDCuoiThang.chuoiSoVN,
                    duBao.phanTramQuyDoiDuKien.chuoiPhanTram,
                    "\(dkKhach.chuoiSoNguyenVN)/\(dkBill.chuoiSoNguyenVN)",
                    chuoiTrangThaiDK
                ]
            }

            for (i, chu) in giaTri.enumerated() {
                let lb = UILabel()
                lb.text = chu
                lb.textAlignment = (i == 0) ? .left : .right
                lb.numberOfLines = 0
                lb.lineBreakMode = .byWordWrapping
                lb.adjustsFontSizeToFitWidth = false
                lb.font = fontDongNhat
                if i == 0 {
                    lb.textColor = .label
                } else if i == 1 {
                    lb.textColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1)
                } else if i == 2 {
                    lb.textColor = UIColor(red: 0.08, green: 0.60, blue: 0.28, alpha: 1)
                } else if i == 5 {
                    lb.textColor = mauChuCuoi
                } else {
                    lb.textColor = .label
                }
                stack.addArrangedSubview(lb)
                lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
            }
            return cell
        }

        cell.selectionStyle = .default
        let item = danhSachBieuDo[indexPath.row]
        let ngayChon = TienIchNgay.lich.component(.day, from: ngayHienTai)
        let laChon = (item.ngayTrongThang == ngayChon)
        cell.backgroundColor = laChon
            ? UIColor.systemBlue.withAlphaComponent(0.08)
            : (item.coDuLieu ? .systemBackground : UIColor.secondarySystemGroupedBackground.withAlphaComponent(0.5))

        let thang = TienIchNgay.lich.component(.month, from: item.ngay)
        let mtNgay = item.targetQuyDoi > 0 ? item.targetQuyDoi : duBao.mucTieuMoiNgay
        let ptHTNgay: Double
        if item.doanhThu.phanTramHTQuyDoi > 0 {
            ptHTNgay = item.doanhThu.phanTramHTQuyDoi
        } else if mtNgay > 0 && item.doanhThuQuyDoi > 0 {
            ptHTNgay = (item.doanhThuQuyDoi / mtNgay) * 100.0
        } else {
            ptHTNgay = 0
        }
        let datNgay = ptHTNgay >= 99.995
        let chuoiDanhGiaNgay: String
        if !item.coDuLieu {
            chuoiDanhGiaNgay = "--"
        } else if ptHTNgay > 0 {
            chuoiDanhGiaNgay = datNgay ? "✅ Đạt (\(ptHTNgay.chuoiPhanTram))" : "⚠️ Chưa (\(ptHTNgay.chuoiPhanTram))"
        } else {
            chuoiDanhGiaNgay = "Đã nhập"
        }

        let giaTri: [String] = [
            String(format: "%02d/%02d", item.ngayTrongThang, thang),
            item.coDuLieu ? item.doanhThuThuc.chuoiSoVN : "--",
            item.coDuLieu ? item.doanhThuQuyDoi.chuoiSoVN : "--",
            item.coDuLieu ? item.phanTramQuyDoi.chuoiPhanTram : "--",
            item.luotKhach > 0 || item.soBill > 0 ? "\(item.luotKhach.chuoiSoNguyenVN)/\(item.soBill.chuoiSoNguyenVN)" : "--",
            chuoiDanhGiaNgay
        ]

        for (i, chu) in giaTri.enumerated() {
            let lb = UILabel()
            lb.text = chu
            lb.textAlignment = (i == 0) ? .left : .right
            lb.numberOfLines = 0
            lb.lineBreakMode = .byWordWrapping
            lb.adjustsFontSizeToFitWidth = false
            lb.font = fontDongNhat
            if i == 0 {
                lb.textColor = laChon ? .systemBlue : .label
            } else if i == 1 {
                lb.textColor = item.coDuLieu ? UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1) : .secondaryLabel
            } else if i == 2 {
                lb.textColor = item.coDuLieu ? UIColor(red: 0.08, green: 0.60, blue: 0.28, alpha: 1) : .secondaryLabel
            } else if i == 5 {
                if !item.coDuLieu || ptHTNgay <= 0 {
                    lb.textColor = .secondaryLabel
                } else {
                    lb.textColor = datNgay
                        ? UIColor(red: 0.06, green: 0.52, blue: 0.24, alpha: 1)
                        : UIColor(red: 0.80, green: 0.14, blue: 0.14, alpha: 1)
                }
            } else {
                lb.textColor = .secondaryLabel
            }
            stack.addArrangedSubview(lb)
            lb.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: tyLe[i]).isActive = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < danhSachBieuDo.count else { return }
        khiChonNgayRealtime?(danhSachBieuDo[indexPath.row])
    }

    // MARK: - Xuất Ảnh Bảng Tổng Hợp & Đồ Thị Cột Realtime Tháng

    func taoAnhBaoCaoRealtimeThang(ngay: Date, thongTinDonVi: String = "", capNhatLuc: String = "") -> UIImage? {
        damBaoDuLieuRealtimeThang(cho: ngay)
        let thang = TienIchNgay.lich.component(.month, from: ngay)
        let nam = TienIchNgay.lich.component(.year, from: ngay)
        let dsCoSo = tatCaNgayTrongThang.filter { $0.coDuLieu }
        let dsVe = danhSachBieuDo
        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngay, cheDoDangXem: .realtime)
        let tomTat = taoNoiDungTomTatThang(dsCoSo: dsCoSo, duBao: duBao)

        let le: CGFloat = 18
        let rongBieuDo = max(860, 62 + CGFloat(dsVe.count) * 58)
        let rongAnh = rongBieuDo + le * 2

        let fontTomTat1 = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        let fontTomTat2 = UIFont.systemFont(ofSize: 12.5, weight: .heavy)
        let caoD1 = max(20, ceil((tomTat.dong1 as NSString).boundingRect(
            with: CGSize(width: rongBieuDo - 24, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTomTat1],
            context: nil
        ).height))
        let caoD2 = max(20, ceil((tomTat.dong2 as NSString).boundingRect(
            with: CGSize(width: rongBieuDo - 24, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTomTat2],
            context: nil
        ).height))

        let caoHeader: CGFloat = 56
        let caoTieuDeLuyKe: CGFloat = 24
        let caoLuyKe: CGFloat = 88
        let caoHopTomTat: CGFloat = 16 + caoD1 + 6 + caoD2
        let caoBieuDo: CGFloat = 236
        let caoTieuDeBang: CGFloat = 24
        let caoHeaderBang: CGFloat = 42
        let caoDong: CGFloat = 48
        let tongSoDongBang = dsVe.count + soDongTongKetCuoiBang
        let caoBang = caoHeaderBang + CGFloat(max(1, tongSoDongBang)) * caoDong
        let caoAnh = le * 2 + caoHeader + 10 + caoTieuDeLuyKe + 6 + caoLuyKe + 12 + caoHopTomTat + 10 + caoBieuDo + 12 + caoTieuDeBang + 6 + caoBang

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khung.backgroundColor = .white
        khung.overrideUserInterfaceStyle = .light

        let lbPhu = UILabel(frame: CGRect(x: le, y: le, width: rongBieuDo, height: 20))
        lbPhu.text = "Tháng \(String(format: "%02d/%04d", thang, nam))\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        lbPhu.font = .systemFont(ofSize: 12.5, weight: .bold)
        lbPhu.textColor = .darkGray
        lbPhu.numberOfLines = 0
        lbPhu.lineBreakMode = .byWordWrapping
        lbPhu.adjustsFontSizeToFitWidth = false
        khung.addSubview(lbPhu)

        let lbChinh = UILabel(frame: CGRect(x: le, y: le + 22, width: rongBieuDo, height: 30))
        lbChinh.text = "📊 BIỂU ĐỒ & TỔNG HỢP REALTIME THÁNG \(String(format: "%02d/%04d", thang, nam))"
        lbChinh.font = .systemFont(ofSize: 19, weight: .heavy)
        lbChinh.textColor = .black
        lbChinh.numberOfLines = 0
        lbChinh.lineBreakMode = .byWordWrapping
        lbChinh.adjustsFontSizeToFitWidth = false
        khung.addSubview(lbChinh)

        var y = le + caoHeader + 10

        let lbTieuDeLK = UILabel(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoTieuDeLuyKe))
        lbTieuDeLK.text = "📌 DOANH THU LŨY KẾ THÁNG \(String(format: "%02d/%04d", thang, nam)) (CỐ ĐỊNH — NHẬP MỚI THAY THẾ NGÀY TRƯỚC)"
        lbTieuDeLK.font = .systemFont(ofSize: 12.5, weight: .bold)
        lbTieuDeLK.textColor = .darkGray
        lbTieuDeLK.numberOfLines = 0
        lbTieuDeLK.lineBreakMode = .byWordWrapping
        lbTieuDeLK.adjustsFontSizeToFitWidth = false
        khung.addSubview(lbTieuDeLK)

        y += caoTieuDeLuyKe + 6

        let the1 = TheDoanhThuView(
            tieuDe: "💵 DOANH THU LŨY KẾ THỰC (THÁNG)",
            mauBatDau: UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1),
            mauKetThuc: UIColor(red: 0.23, green: 0.25, blue: 0.89, alpha: 1)
        )
        let kqLKThuc = doanhThuLuyKe.phanTramHTThucHienThi >= 99.995 ? "ĐẠT" : "CHƯA ĐẠT"
        the1.capNhatNoiDung(
            chinh: doanhThuLuyKe.doanhThuThuc.chuoiSoGonVN,
            phu: "TARGET: \(doanhThuLuyKe.targetThuc.chuoiSoGonVN) | HT: \(doanhThuLuyKe.phanTramHTThucHienThi.chuoiPhanTram) (\(kqLKThuc))",
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
        let dkLK = doanhThuLuyKe.duKienQuyDoi > 0 ? doanhThuLuyKe.duKienQuyDoi : doanhThuLuyKe.duKienThuc
        let kqLKQD = doanhThuLuyKe.phanTramHTQDDuKienHienThi >= 99.995 ? "ĐẠT" : "CHƯA ĐẠT"
        the2.capNhatNoiDung(
            chinh: doanhThuLuyKe.doanhThuQuyDoi.chuoiSoGonVN,
            phu: "TARGET: \(doanhThuLuyKe.targetQuyDoi.chuoiSoGonVN) | HT: \(doanhThuLuyKe.phanTramHTQDDuKienHienThi.chuoiPhanTram) (DK: \(dkLK.chuoiSoGonVN) - \(kqLKQD))",
            coLon: true
        )
        the2.frame = CGRect(x: le + (rongBieuDo - 12) / 2 + 12, y: y, width: (rongBieuDo - 12) / 2, height: caoLuyKe)
        the2.layoutIfNeeded()
        khung.addSubview(the2)

        y += caoLuyKe + 12

        let coPT = duBao.phanTramHTQDDuKien > 0 || duBao.mucTieuThang > 0
        let hopTomTat = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoHopTomTat))
        hopTomTat.backgroundColor = coPT
            ? (duBao.daHoanThanhDuKien ? UIColor(red: 0.92, green: 0.98, blue: 0.94, alpha: 1) : UIColor(red: 1.0, green: 0.96, blue: 0.90, alpha: 1))
            : UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1)
        hopTomTat.layer.cornerRadius = 10
        hopTomTat.layer.borderWidth = 1
        hopTomTat.layer.borderColor = (coPT
            ? (duBao.daHoanThanhDuKien ? UIColor.systemGreen : UIColor.systemOrange)
            : UIColor.systemBlue).withAlphaComponent(0.4).cgColor

        let lbDong1 = UILabel(frame: CGRect(x: 12, y: 8, width: rongBieuDo - 24, height: caoD1))
        lbDong1.text = tomTat.dong1
        lbDong1.font = fontTomTat1
        lbDong1.textColor = .black
        lbDong1.numberOfLines = 0
        lbDong1.lineBreakMode = .byWordWrapping
        lbDong1.adjustsFontSizeToFitWidth = false
        hopTomTat.addSubview(lbDong1)

        let lbDong2 = UILabel(frame: CGRect(x: 12, y: 8 + caoD1 + 6, width: rongBieuDo - 24, height: caoD2))
        lbDong2.text = tomTat.dong2
        lbDong2.font = fontTomTat2
        lbDong2.numberOfLines = 0
        lbDong2.lineBreakMode = .byWordWrapping
        lbDong2.adjustsFontSizeToFitWidth = false
        lbDong2.textColor = coPT
            ? (duBao.daHoanThanhDuKien ? UIColor(red: 0.06, green: 0.50, blue: 0.22, alpha: 1) : UIColor(red: 0.78, green: 0.18, blue: 0.08, alpha: 1))
            : UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1)
        hopTomTat.addSubview(lbDong2)
        khung.addSubview(hopTomTat)

        y += caoHopTomTat + 10

        let hopBD = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoBieuDo))
        hopBD.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        hopBD.layer.cornerRadius = 10
        hopBD.layer.borderWidth = 1
        hopBD.layer.borderColor = UIColor.systemGray4.cgColor

        let lbLegend = UILabel(frame: CGRect(x: 12, y: 8, width: rongBieuDo - 24, height: 18))
        lbLegend.text = "BIỂU ĐỒ CỘT REALTIME THEO NGÀY (\(dsCoSo.count)/\(dsVe.count) NGÀY CÓ SỐ):   🟦 Doanh thu Thực     🟩 Doanh thu Quy đổi"
        lbLegend.font = .systemFont(ofSize: 12, weight: .bold)
        lbLegend.textColor = .black
        lbLegend.numberOfLines = 0
        lbLegend.lineBreakMode = .byWordWrapping
        lbLegend.adjustsFontSizeToFitWidth = false
        hopBD.addSubview(lbLegend)

        let chart = VeBieuDoCotRealtimeView(frame: CGRect(x: 4, y: 28, width: rongBieuDo - 8, height: caoBieuDo - 32))
        chart.overrideUserInterfaceStyle = .light
        chart.ngayDangChon = TienIchNgay.lich.component(.day, from: ngay)
        chart.danhSachNgay = dsVe
        hopBD.addSubview(chart)
        khung.addSubview(hopBD)

        y += caoBieuDo + 12

        let lbTieuDeBangXuat = UILabel(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoTieuDeBang))
        lbTieuDeBangXuat.text = "📋 BẢNG CHI TIẾT REALTIME THEO NGÀY & ĐÁNH GIÁ DỰ KIẾN CUỐI THÁNG"
        lbTieuDeBangXuat.font = .systemFont(ofSize: 13, weight: .heavy)
        lbTieuDeBangXuat.textColor = .black
        lbTieuDeBangXuat.numberOfLines = 0
        lbTieuDeBangXuat.lineBreakMode = .byWordWrapping
        lbTieuDeBangXuat.adjustsFontSizeToFitWidth = false
        khung.addSubview(lbTieuDeBangXuat)

        y += caoTieuDeBang + 6

        let khungBang = UIView(frame: CGRect(x: le, y: y, width: rongBieuDo, height: caoBang))
        khungBang.layer.borderWidth = 1
        khungBang.layer.borderColor = UIColor.systemGray4.cgColor
        khungBang.layer.cornerRadius = 8
        khungBang.clipsToBounds = true
        khung.addSubview(khungBang)

        if let hView = self.tableView(bangNgay, viewForHeaderInSection: 0) {
            hView.frame = CGRect(x: 0, y: 0, width: rongBieuDo, height: caoHeaderBang)
            hView.layoutIfNeeded()
            khungBang.addSubview(hView)
        }
        for i in 0..<tongSoDongBang {
            let cell = self.tableView(bangNgay, cellForRowAt: IndexPath(row: i, section: 0))
            let vDong = cell.contentView
            vDong.frame = CGRect(x: 0, y: caoHeaderBang + CGFloat(i) * caoDong, width: rongBieuDo, height: caoDong)
            vDong.backgroundColor = cell.backgroundColor
            vDong.layoutIfNeeded()
            let vach = UIView(frame: CGRect(x: 0, y: caoDong - 0.5, width: rongBieuDo, height: 0.5))
            vach.backgroundColor = .systemGray4
            vDong.addSubview(vach)
            khungBang.addSubview(vDong)
        }
        return khung.ketXuatAnhChuanSang(scale: 3.0)
    }

    // MARK: - Xuất File Excel (.csv) cho Bảng Biểu Đồ & Tổng Hợp Realtime Tháng

    func taoChuoiExcelCSVBieuDoThang(ngay: Date, thongTinDonVi: String = "", capNhatLuc: String = "") -> String {
        damBaoDuLieuRealtimeThang(cho: ngay)
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let donVi = !thongTinDonVi.isEmpty ? thongTinDonVi : (dl.thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : dl.thongTinDonVi)
        let thang = TienIchNgay.lich.component(.month, from: ngay)
        let nam = TienIchNgay.lich.component(.year, from: ngay)
        let dsCoSo = tatCaNgayTrongThang.filter { $0.coDuLieu }
        let duBao = KhoDuLieu.dungChung.tinhDuBaoQuyDoiTuRealtime(cho: ngay, cheDoDangXem: .realtime)
        let tomTat = taoNoiDungTomTatThang(dsCoSo: dsCoSo, duBao: duBao)

        var cacDong: [String] = []
        cacDong.append("\"BIỂU ĐỒ & TỔNG HỢP REALTIME THÁNG \(String(format: "%02d/%04d", thang, nam))\",\"\(donVi)\",\"Cập nhật: \(capNhatLuc)\"")
        cacDong.append("")
        cacDong.append("PHẦN 1: DOANH THU LŨY KẾ THÁNG,GIÁ TRỊ,TARGET,TỶ LỆ HT,ĐÁNH GIÁ")
        let kqLKThuc = doanhThuLuyKe.phanTramHTThucHienThi >= 99.995 ? "ĐẠT" : "CHƯA ĐẠT"
        let kqLKQD = doanhThuLuyKe.phanTramHTQDDuKienHienThi >= 99.995 ? "ĐẠT" : "CHƯA ĐẠT"
        cacDong.append("\"DT Lũy kế Thực (Tháng)\",\(doanhThuLuyKe.doanhThuThuc),\(doanhThuLuyKe.targetThuc),\(String(format: "%.2f%%", doanhThuLuyKe.phanTramHTThucHienThi)),\"\(kqLKThuc)\"")
        cacDong.append("\"DT Lũy kế Quy đổi (Tháng)\",\(doanhThuLuyKe.doanhThuQuyDoi),\(doanhThuLuyKe.targetQuyDoi),\(String(format: "%.2f%%", doanhThuLuyKe.phanTramHTQDDuKienHienThi)),\"\(kqLKQD)\"")
        cacDong.append("")
        cacDong.append("PHẦN 2: TÓM TẮT & DỰ BÁO CUỐI THÁNG TỪ REALTIME")
        cacDong.append("\"\(tomTat.dong1.replacingOccurrences(of: "\"", with: "\"\""))\"")
        cacDong.append("\"\(tomTat.dong2.replacingOccurrences(of: "\"", with: "\"\""))\"")
        cacDong.append("\"Trạng thái DK cuối tháng\",\"\(tomTat.trangThaiDK)\",\"DK QĐ cuối tháng: \(duBao.duKienQDCuoiThang.chuoiSoVN)\",\"Target QĐ tháng: \(duBao.mucTieuThang.chuoiSoVN)\",\"% HT QĐ DK: \(duBao.phanTramHTQDDuKien.chuoiPhanTramVN)\"")
        cacDong.append("")
        cacDong.append("PHẦN 3: BẢNG CHI TIẾT REALTIME THEO NGÀY")
        cacDong.append("Ngày,DT Thực (RT),DT Quy đổi (RT),Target Ngày QĐ,% HT Ngày,% Quy đổi,Lượt khách,Số Bill,Đánh giá ngày")

        for item in tatCaNgayTrongThang {
            let ngayStr = String(format: "%02d/%02d/%04d", item.ngayTrongThang, thang, nam)
            let mtNgay = item.targetQuyDoi > 0 ? item.targetQuyDoi : duBao.mucTieuMoiNgay
            let ptHTNgay: Double
            if item.doanhThu.phanTramHTQuyDoi > 0 {
                ptHTNgay = item.doanhThu.phanTramHTQuyDoi
            } else if mtNgay > 0 && item.doanhThuQuyDoi > 0 {
                ptHTNgay = (item.doanhThuQuyDoi / mtNgay) * 100.0
            } else {
                ptHTNgay = 0
            }
            let danhGia: String
            if !item.coDuLieu {
                danhGia = "Chưa nhập"
            } else if ptHTNgay > 0 {
                danhGia = ptHTNgay >= 99.995 ? "ĐẠT (\(String(format: "%.1f%%", ptHTNgay)))" : "CHƯA ĐẠT (\(String(format: "%.1f%%", ptHTNgay)))"
            } else {
                danhGia = "Đã nhập"
            }
            cacDong.append("\(ngayStr),\(item.doanhThuThuc),\(item.doanhThuQuyDoi),\(String(format: "%.2f", mtNgay)),\(String(format: "%.2f%%", ptHTNgay)),\(String(format: "%.2f%%", item.phanTramQuyDoi)),\(Int(item.luotKhach)),\(Int(item.soBill)),\"\(danhGia)\"")
        }

        let tongRTThuc = dsCoSo.reduce(0.0) { $0 + $1.doanhThuThuc }
        let tongRTQD = dsCoSo.reduce(0.0) { $0 + $1.doanhThuQuyDoi }
        let tongKhach = dsCoSo.reduce(0.0) { $0 + $1.luotKhach }
        let tongBill = dsCoSo.reduce(0.0) { $0 + $1.soBill }
        let ptQDTong = tongRTThuc > 0 ? ((tongRTQD - tongRTThuc) / tongRTThuc * 100.0) : 0
        let mtDenNay = duBao.mucTieuMoiNgay * Double(max(1, dsCoSo.count))
        let ptDenNay = mtDenNay > 0 ? (tongRTQD / mtDenNay * 100.0) : 0
        let danhGiaTong = mtDenNay > 0 ? (ptDenNay >= 99.995 ? "ĐẠT TIẾN ĐỘ" : "CHƯA ĐẠT TIẾN ĐỘ") : "\(dsCoSo.count) ngày"
        let soN = Double(max(1, dsCoSo.count))

        cacDong.append("\"TỔNG CỘNG (\(dsCoSo.count) ngày)\",\(String(format: "%.2f", tongRTThuc)),\(String(format: "%.2f", tongRTQD)),\(String(format: "%.2f", mtDenNay)),\(String(format: "%.2f%%", ptDenNay)),\(String(format: "%.2f%%", ptQDTong)),\(Int(tongKhach)),\(Int(tongBill)),\"\(danhGiaTong)\"")
        cacDong.append("\"TRUNG BÌNH / NGÀY\",\(String(format: "%.2f", duBao.trungBinhThucMoiNgay)),\(String(format: "%.2f", duBao.trungBinhQDMoiNgay)),\(String(format: "%.2f", duBao.mucTieuMoiNgay)),\(String(format: "%.2f%%", ptDenNay)),\(String(format: "%.2f%%", ptQDTong)),\(Int(round(tongKhach / soN))),\(Int(round(tongBill / soN))),\"TB \(dsCoSo.count) ngày\"")
        let coPT = duBao.phanTramHTQDDuKien > 0 || duBao.mucTieuThang > 0
        let kqCuoiThang = coPT ? (duBao.daHoanThanhDuKien ? "ĐẠT MỤC TIÊU (\(duBao.phanTramHTQDDuKien.chuoiPhanTramVN))" : "CHƯA ĐẠT (\(duBao.phanTramHTQDDuKien.chuoiPhanTramVN))") : "--"
        cacDong.append("\"DK CUỐI THÁNG (\(duBao.soNgayTrongThang) ngày)\",\(String(format: "%.2f", duBao.duKienThucCuoiThang)),\(String(format: "%.2f", duBao.duKienQDCuoiThang)),\(String(format: "%.2f", duBao.mucTieuThang)),\(String(format: "%.2f%%", duBao.phanTramHTQDDuKien)),\(String(format: "%.2f%%", duBao.phanTramQuyDoiDuKien)),\(Int(round(tongKhach / soN * Double(duBao.soNgayTrongThang)))),\(Int(round(tongBill / soN * Double(duBao.soNgayTrongThang)))),\"\(kqCuoiThang)\"")

        return "\u{FEFF}" + cacDong.joined(separator: "\n")
    }

    // MARK: - Xuất Ảnh Báo Cáo Biểu Đồ Sức Khỏe ~16 Nhân Viên & Cảnh Báo Top 5 Yếu Liên Tục

    func taoAnhBaoCaoSucKhoeNhanVien(ngay: Date, thongTinDonVi: String = "", capNhatLuc: String = "") -> UIImage? {
        let bc = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: cheDoSucKhoe)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)

        let le: CGFloat = 18
        let rongNoiDung: CGFloat = 820
        let rongAnh = rongNoiDung + le * 2

        let caoHeader: CGFloat = 56
        let caoKPI: CGFloat = 86
        let soTop5 = bc.top5CanhBaoYeu.count
        let caoMoiTheTop5: CGFloat = 84
        let caoKhungTop5: CGFloat = 54 + CGFloat(max(1, soTop5)) * (caoMoiTheTop5 + 8) + 10
        let dsVe = danhSachHoSoSauLocVaSapXep(tu: bc)
        let chartTemp = VeBieuDoSucKhoeNhanVienView()
        let caoBieuDo = chartTemp.chieuCaoCanThiet(cho: dsVe.count)
        let caoKhungBieuDo = 54 + caoBieuDo + 12

        let caoAnh = le * 2 + caoHeader + 10 + caoKPI + 12 + caoKhungTop5 + 12 + caoKhungBieuDo

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khung.backgroundColor = .white
        khung.overrideUserInterfaceStyle = .light

        let lbPhu = UILabel(frame: CGRect(x: le, y: le, width: rongNoiDung, height: 20))
        lbPhu.text = "Ngày \(ngayStr)  •  Chế độ: \(cheDoSucKhoe.tieuDe)\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        lbPhu.font = .systemFont(ofSize: 12.5, weight: .bold)
        lbPhu.textColor = .darkGray
        khung.addSubview(lbPhu)

        let lbChinh = UILabel(frame: CGRect(x: le, y: le + 22, width: rongNoiDung, height: 30))
        lbChinh.text = "❤️‍🩹 BÁO CÁO BIỂU ĐỒ SỨC KHỎE NHÂN VIÊN & CẢNH BÁO TOP 5 YẾU LIÊN TỤC"
        lbChinh.font = .systemFont(ofSize: 18.5, weight: .heavy)
        lbChinh.textColor = .black
        khung.addSubview(lbChinh)

        var y = le + caoHeader + 10

        let k1 = TheDoanhThuView(tieuDe: "💪 KHỎE MẠNH", mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1), mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1))
        k1.capNhatNoiDung(chinh: "\(bc.soNVKhoe) NV", phu: "CHUẨN >= 75%", coLon: true)
        let k2 = TheDoanhThuView(tieuDe: "⚡ TRUNG BÌNH", mauBatDau: UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1), mauKetThuc: UIColor(red: 0.85, green: 0.47, blue: 0.02, alpha: 1))
        k2.capNhatNoiDung(chinh: "\(bc.soNVTrungBinh) NV", phu: "MỨC 55% - 74%", coLon: true)
        let k3 = TheDoanhThuView(tieuDe: "🚨 YẾU / BÁO ĐỘNG", mauBatDau: UIColor(red: 0.94, green: 0.24, blue: 0.24, alpha: 1), mauKetThuc: UIColor(red: 0.80, green: 0.12, blue: 0.12, alpha: 1), hienChamTron: true)
        k3.capNhatNoiDung(chinh: "\(bc.soNVYeu) NV", phu: "CẦN KÈM CẶP", coLon: true)
        let k4 = TheDoanhThuView(tieuDe: "❤️‍🩹 ĐIỂM ĐỘI NGŨ", mauBatDau: UIColor(red: 0.39, green: 0.40, blue: 0.95, alpha: 1), mauKetThuc: UIColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1))
        k4.capNhatNoiDung(chinh: bc.diemTrungBinhDoiNgu.chuoiPhanTram, phu: "THEO DÕI: \(bc.soNgayDaTheoDoi) NGÀY", coLon: true)

        let gap: CGFloat = 10
        let rongThe = (rongNoiDung - gap * 3) / 4.0
        for (i, the) in [k1, k2, k3, k4].enumerated() {
            the.frame = CGRect(x: le + CGFloat(i) * (rongThe + gap), y: y, width: rongThe, height: caoKPI)
            the.layoutIfNeeded()
            khung.addSubview(the)
        }

        y += caoKPI + 12

        let hopTop5 = UIView(frame: CGRect(x: le, y: y, width: rongNoiDung, height: caoKhungTop5))
        hopTop5.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.95, alpha: 1)
        hopTop5.layer.cornerRadius = 12
        hopTop5.layer.borderWidth = 1.5
        hopTop5.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.45).cgColor
        khung.addSubview(hopTop5)

        let lbTop5 = UILabel(frame: CGRect(x: 14, y: 10, width: rongNoiDung - 28, height: 22))
        lbTop5.text = "🚨 CẢNH BÁO 5 NHÂN VIÊN YẾU NHIỀU NGÀY LIÊN TỤC CẦN KÈM CẶP NGAY"
        lbTop5.font = .systemFont(ofSize: 14.0, weight: .heavy)
        lbTop5.textColor = UIColor(red: 0.78, green: 0.10, blue: 0.10, alpha: 1)
        hopTop5.addSubview(lbTop5)

        let lbPhuTop5 = UILabel(frame: CGRect(x: 14, y: 32, width: rongNoiDung - 28, height: 18))
        lbPhuTop5.text = "Xếp hạng theo số ngày yếu liên tục giảm dần và điểm sức khỏe thấp nhất:"
        lbPhuTop5.font = .systemFont(ofSize: 11.5, weight: .semibold)
        lbPhuTop5.textColor = .darkGray
        hopTop5.addSubview(lbPhuTop5)

        var yCard: CGFloat = 54
        for (i, hs) in bc.top5CanhBaoYeu.enumerated() {
            let card = UIView(frame: CGRect(x: 12, y: yCard, width: rongNoiDung - 24, height: caoMoiTheTop5))
            card.backgroundColor = .white
            card.layer.cornerRadius = 9
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.3).cgColor

            let l1 = UILabel(frame: CGRect(x: 10, y: 6, width: rongNoiDung - 260, height: 20))
            l1.text = "🚨 #\(i + 1). \(hs.nhanVien.hoTen) (\(hs.nhanVien.maNV))"
            l1.font = .systemFont(ofSize: 13.0, weight: .bold)
            l1.textColor = UIColor(red: 0.75, green: 0.10, blue: 0.10, alpha: 1)
            card.addSubview(l1)

            let lBadge = UILabel(frame: CGRect(x: rongNoiDung - 244, y: 6, width: 210, height: 20))
            lBadge.text = "\(hs.chuoiCanhBaoYeu) • SK: \(hs.diemSucKhoe.chuoiPhanTram)"
            lBadge.font = .systemFont(ofSize: 11.0, weight: .heavy)
            lBadge.textColor = .white
            lBadge.backgroundColor = UIColor(red: 0.86, green: 0.15, blue: 0.15, alpha: 1)
            lBadge.layer.cornerRadius = 5
            lBadge.clipsToBounds = true
            lBadge.textAlignment = .center
            card.addSubview(lBadge)

            let th = hs.tongHopHienTai
            let dtStr = th.doanhThuQD > 0 ? "  •  DT QĐ: \(th.doanhThuQD.chuoiSoGonVN)tr" : ""
            let l2 = UILabel(frame: CGRect(x: 10, y: 29, width: rongNoiDung - 44, height: 18))
            l2.text = "📊 Môn đạt: \(th.soMonDat)/\(th.tongMonGiao) môn (HT TB: \(th.phanTramHTTB.chuoiPhanTramVN))\(dtStr)  •  \(hs.nhanXuHuong)"
            l2.font = .systemFont(ofSize: 11.5, weight: .semibold)
            l2.textColor = .black
            card.addSubview(l2)

            let lsStr = hs.lichSuNgay.map { "\($0.nhanNgay): \($0.mucDo.kyHieu) \(Int(round($0.diemSucKhoe)))%" }.joined(separator: "  ➔  ")
            let monYeuStr = hs.cacMonYeuNhat.isEmpty ? "" : "   |   🎯 Ngành yếu: \(hs.cacMonYeuNhat.joined(separator: ", "))"
            let l3 = UILabel(frame: CGRect(x: 10, y: 50, width: rongNoiDung - 44, height: 28))
            l3.text = "🗓️ Chuỗi ngày: \(lsStr)\(monYeuStr)"
            l3.font = .systemFont(ofSize: 11.0, weight: .medium)
            l3.textColor = .darkGray
            l3.numberOfLines = 0
            card.addSubview(l3)

            hopTop5.addSubview(card)
            yCard += caoMoiTheTop5 + 8
        }

        y += caoKhungTop5 + 12

        let hopBD = UIView(frame: CGRect(x: le, y: y, width: rongNoiDung, height: caoKhungBieuDo))
        hopBD.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        hopBD.layer.cornerRadius = 12
        hopBD.layer.borderWidth = 1
        hopBD.layer.borderColor = UIColor.systemGray4.cgColor
        khung.addSubview(hopBD)

        let lbTBD = UILabel(frame: CGRect(x: 14, y: 10, width: rongNoiDung - 28, height: 20))
        lbTBD.text = "📊 BIỂU ĐỒ SỨC KHỎE TRỰC QUAN TOÀN BỘ \(dsVe.count) NHÂN VIÊN"
        lbTBD.font = .systemFont(ofSize: 13.5, weight: .heavy)
        lbTBD.textColor = .black
        hopBD.addSubview(lbTBD)

        let lbLegend = UILabel(frame: CGRect(x: 14, y: 31, width: rongNoiDung - 28, height: 18))
        lbLegend.text = "🟢 Khỏe (>=75%)   •   🟡 Trung bình (55-74%)   •   🔴 Yếu (<55% / Top 5 yếu)   •   Chấm tròn dưới thanh: Lịch sử ngày gần nhất"
        lbLegend.font = .systemFont(ofSize: 11.5, weight: .semibold)
        lbLegend.textColor = .darkGray
        hopBD.addSubview(lbLegend)

        let chart = VeBieuDoSucKhoeNhanVienView(frame: CGRect(x: 10, y: 52, width: rongNoiDung - 20, height: caoBieuDo))
        chart.overrideUserInterfaceStyle = .light
        chart.danhSachHoSo = dsVe
        hopBD.addSubview(chart)

        return khung.ketXuatAnhChuanSang(scale: 3.0)
    }
}
