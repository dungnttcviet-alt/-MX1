import UIKit

enum BoLocThiDua: Int {
    case tatCa = 0
    case daDat = 1
    case chuaDat = 2
}

enum KieuSapXepThiDua: Int {
    case macDinh = 0
    case phanTramGiamDan = 1
    case phanTramTangDan = 2

    var nhan: String {
        switch self {
        case .macDinh: return "Thứ tự gốc"
        case .phanTramGiamDan: return "% HT giảm dần"
        case .phanTramTangDan: return "% HT tăng dần"
        }
    }
}

final class BangThiDuaView: UIView, UITableViewDataSource, UITableViewDelegate {
    var khiChonDong: ((DongThiDua) -> Void)?
    var khiXoaDong: ((UUID) -> Void)?
    var khiBamQuetAnh: (() -> Void)?

    private var danhSachGoc: [DongThiDua] = []
    private var danhSachHienThi: [DongThiDua] = []
    private var boLoc: BoLocThiDua = .tatCa
    private var kieuSapXep: KieuSapXepThiDua = .macDinh

    // Chiều rộng cố định của 8 cột để bảng hiển thị đầy đủ, rõ ràng không bị cắt chữ "..."
    private let chieuRongCot: [CGFloat] = [
        38,   // STT
        205,  // Ngành hàng (Tên chương trình)
        48,   // ĐVT (SL/DT)
        88,   // Thực hiện
        88,   // Target
        92,   // Còn thiếu / Vượt
        84,   // % HT Tháng
        84    // % Dự báo
    ]

    private var tongChieuRongBang: CGFloat {
        chieuRongCot.reduce(0, +)
    }

    private let nhanTongCT = UILabel()
    private let nhanSoDat = UILabel()
    private let nhanSoChuaDat = UILabel()
    private let chonBoLoc = UISegmentedControl(items: ["Tất cả", "Đạt >=100%", "Chưa đạt"])
    private let nutSapXep = UIButton(type: .system)

    private let cuonNgang = UIScrollView()
    private let bang = UITableView(frame: .zero, style: .plain)
    private let khungTrong = UIControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        clipsToBounds = true

        // 1. Thẻ thống kê nhanh (Tổng CT | Đạt | Chưa đạt)
        let theTong = taoTheChiSo(nhan: nhanTongCT, mauNen: UIColor.systemBlue.withAlphaComponent(0.1), mauChu: .systemBlue)
        let theDat = taoTheChiSo(nhan: nhanSoDat, mauNen: UIColor.systemGreen.withAlphaComponent(0.12), mauChu: .systemGreen)
        let theChuaDat = taoTheChiSo(nhan: nhanSoChuaDat, mauNen: UIColor.systemRed.withAlphaComponent(0.12), mauChu: .systemRed)

        let hangThongKe = UIStackView(arrangedSubviews: [theTong, theDat, theChuaDat])
        hangThongKe.axis = .horizontal
        hangThongKe.spacing = 8
        hangThongKe.distribution = .fillEqually

        // 2. Thanh lọc & Sắp xếp
        chonBoLoc.selectedSegmentIndex = 0
        chonBoLoc.addTarget(self, action: #selector(doiBoLoc), for: .valueChanged)

        nutSapXep.setTitle(" ⇅ Thứ tự gốc", for: .normal)
        nutSapXep.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        nutSapXep.backgroundColor = .tertiarySystemFill
        nutSapXep.tintColor = .label
        nutSapXep.layer.cornerRadius = 8
        nutSapXep.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutSapXep.addTarget(self, action: #selector(doiSapXep), for: .touchUpInside)

        let hangLoc = UIStackView(arrangedSubviews: [chonBoLoc, nutSapXep])
        hangLoc.axis = .horizontal
        hangLoc.spacing = 8

        let vachNgan = UIView()
        vachNgan.backgroundColor = .separator

        // 3. Khung cuộn ngang chứa bảng 8 cột
        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.showsVerticalScrollIndicator = false
        cuonNgang.bounces = false

        bang.dataSource = self
        bang.delegate = self
        bang.rowHeight = 52
        bang.sectionHeaderHeight = 40
        bang.separatorStyle = .singleLine
        bang.separatorInset = .zero
        bang.backgroundColor = .systemBackground
        if #available(iOS 15.0, *) {
            bang.sectionHeaderTopPadding = 0
        }
        bang.translatesAutoresizingMaskIntoConstraints = false
        cuonNgang.addSubview(bang)

        // 4. Khung trống khi chưa có dữ liệu
        khungTrong.backgroundColor = .systemBackground
        khungTrong.addTarget(self, action: #selector(bamQuetAnh), for: .touchUpInside)

        let iconTrong = UIImageView(image: UIImage(systemName: "doc.viewfinder"))
        iconTrong.tintColor = .systemBlue
        iconTrong.contentMode = .scaleAspectFit
        iconTrong.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 48, weight: .regular)

        let tieuDeTrong = UILabel()
        tieuDeTrong.text = "Chưa có dữ liệu bảng tổng hợp Thi đua"
        tieuDeTrong.font = .systemFont(ofSize: 16, weight: .bold)
        tieuDeTrong.textAlignment = .center
        tieuDeTrong.numberOfLines = 0

        let moTaTrong = UILabel()
        moTaTrong.text = "Bấm \"Quét ảnh chụp màn hình\" để chọn 1 hoặc nhiều ảnh mục Thi đua.\nỨng dụng sẽ tự động đọc và gộp thành bảng tổng hợp đầy đủ 8 cột."
        moTaTrong.font = .systemFont(ofSize: 13, weight: .regular)
        moTaTrong.textColor = .secondaryLabel
        moTaTrong.textAlignment = .center
        moTaTrong.numberOfLines = 0

        let nutQuetNgay = UIButton(type: .system)
        nutQuetNgay.setTitle("  Chọn ảnh chụp màn hình Thi đua  ", for: .normal)
        nutQuetNgay.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        nutQuetNgay.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        nutQuetNgay.backgroundColor = .systemBlue
        nutQuetNgay.tintColor = .white
        nutQuetNgay.layer.cornerRadius = 12
        nutQuetNgay.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        nutQuetNgay.isUserInteractionEnabled = false

        let nganXepTrong = UIStackView(arrangedSubviews: [iconTrong, tieuDeTrong, moTaTrong, nutQuetNgay])
        nganXepTrong.axis = .vertical
        nganXepTrong.spacing = 10
        nganXepTrong.alignment = .center
        nganXepTrong.isUserInteractionEnabled = false
        nganXepTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nganXepTrong)

        [hangThongKe, hangLoc, vachNgan, cuonNgang, khungTrong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            hangThongKe.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hangThongKe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            hangThongKe.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            hangThongKe.heightAnchor.constraint(equalToConstant: 34),

            hangLoc.topAnchor.constraint(equalTo: hangThongKe.bottomAnchor, constant: 6),
            hangLoc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            hangLoc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            hangLoc.heightAnchor.constraint(equalToConstant: 30),

            vachNgan.topAnchor.constraint(equalTo: hangLoc.bottomAnchor, constant: 6),
            vachNgan.leadingAnchor.constraint(equalTo: leadingAnchor),
            vachNgan.trailingAnchor.constraint(equalTo: trailingAnchor),
            vachNgan.heightAnchor.constraint(equalToConstant: 0.5),

            cuonNgang.topAnchor.constraint(equalTo: vachNgan.bottomAnchor),
            cuonNgang.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuonNgang.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuonNgang.bottomAnchor.constraint(equalTo: bottomAnchor),

            bang.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            bang.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            bang.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            bang.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),
            bang.widthAnchor.constraint(equalToConstant: tongChieuRongBang),

            khungTrong.topAnchor.constraint(equalTo: vachNgan.bottomAnchor),
            khungTrong.leadingAnchor.constraint(equalTo: leadingAnchor),
            khungTrong.trailingAnchor.constraint(equalTo: trailingAnchor),
            khungTrong.bottomAnchor.constraint(equalTo: bottomAnchor),

            nganXepTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nganXepTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nganXepTrong.leadingAnchor.constraint(greaterThanOrEqualTo: khungTrong.leadingAnchor, constant: 20),
            nganXepTrong.trailingAnchor.constraint(lessThanOrEqualTo: khungTrong.trailingAnchor, constant: -20)
        ])

        capNhatGiaoDien()
    }

    func ganDanhSach(_ danhSach: [DongThiDua]) {
        danhSachGoc = danhSach
        capNhatGiaoDien()
    }

    private func capNhatGiaoDien() {
        let tong = danhSachGoc.count
        let soDat = danhSachGoc.filter { $0.daDat }.count
        let soChuaDat = tong - soDat
        let tyLeChung = tong > 0 ? Int((Double(soDat) / Double(tong) * 100).rounded()) : 0

        nhanTongCT.text = "Tổng: \(tong) CT (\(tyLeChung)%)"
        nhanSoDat.text = "🟢 Đạt: \(soDat)"
        nhanSoChuaDat.text = "🔴 Chưa đạt: \(soChuaDat)"

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
        case .macDinh: break
        case .phanTramGiamDan: tam.sort { $0.phanTramHT > $1.phanTramHT }
        case .phanTramTangDan: tam.sort { $0.phanTramHT < $1.phanTramHT }
        }

        danhSachHienThi = tam
        khungTrong.isHidden = !danhSachGoc.isEmpty
        cuonNgang.isHidden = danhSachGoc.isEmpty
        bang.reloadData()
    }

    @objc private func doiBoLoc() {
        boLoc = BoLocThiDua(rawValue: chonBoLoc.selectedSegmentIndex) ?? .tatCa
        capNhatGiaoDien()
    }

    @objc private func doiSapXep() {
        let tiepTheo = (kieuSapXep.rawValue + 1) % 3
        kieuSapXep = KieuSapXepThiDua(rawValue: tiepTheo) ?? .macDinh
        nutSapXep.setTitle(" ⇅ \(kieuSapXep.nhan)", for: .normal)
        capNhatGiaoDien()
    }

    @objc private func bamQuetAnh() {
        khiBamQuetAnh?()
    }

    private func taoTheChiSo(nhan: UILabel, mauNen: UIColor, mauChu: UIColor) -> UIView {
        let khung = UIView()
        khung.backgroundColor = mauNen
        khung.layer.cornerRadius = 8
        nhan.font = .systemFont(ofSize: 12, weight: .bold)
        nhan.textColor = mauChu
        nhan.textAlignment = .center
        nhan.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(nhan)
        NSLayoutConstraint.activate([
            nhan.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 4),
            nhan.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -4),
            nhan.topAnchor.constraint(equalTo: khung.topAnchor),
            nhan.bottomAnchor.constraint(equalTo: khung.bottomAnchor)
        ])
        return khung
    }

    // MARK: - UITableViewDataSource & Delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachHienThi.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        taoDongTieuDeCot()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongThiDuaCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .default
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let dong = danhSachHienThi[indexPath.row]
        let viewDong = taoViewDongDuLieu(stt: indexPath.row + 1, dong: dong)
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
        let dong = danhSachHienThi[indexPath.row]
        khiChonDong?(dong)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dong = danhSachHienThi[indexPath.row]
        let xoa = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, hoanTat in
            self?.khiXoaDong?(dong.id)
            hoanTat(true)
        }
        return UISwipeActionsConfiguration(actions: [xoa])
    }

    // MARK: - Dựng giao diện dòng Tiêu đề & Dòng dữ liệu 8 cột

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

    private func taoViewDongDuLieu(stt: Int, dong: DongThiDua, chieuCao: CGFloat = 52) -> UIView {
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
            dong.loaiChiTieu.rawValue,
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
                // Cột % HT Tháng và % Dự báo hiển thị dạng pill badge nổi bật giống app ĐMX
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

    // MARK: - Xuất Bảng Tổng Hợp ra Ảnh sắc nét / Văn bản / CSV

    func taoAnhBaoCao(ngay: Date, thongTinDonVi: String, capNhatLuc: String) -> UIImage? {
        let ds = danhSachHienThi
        guard !ds.isEmpty else { return nil }

        let chieuCaoDauTrang: CGFloat = 86
        let chieuCaoHeaderCot: CGFloat = 40
        let chieuCaoDong: CGFloat = 50
        let le: CGFloat = 16
        let chieuRongAnh = tongChieuRongBang + le * 2
        let chieuCaoAnh = chieuCaoDauTrang + chieuCaoHeaderCot + CGFloat(ds.count) * chieuCaoDong + le * 2

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

        let khungBang = UIView(frame: CGRect(
            x: le,
            y: le + chieuCaoDauTrang,
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
            let vDong = taoViewDongDuLieu(stt: i + 1, dong: dong, chieuCao: chieuCaoDong)
            vDong.frame = CGRect(x: 0, y: y, width: tongChieuRongBang, height: chieuCaoDong)
            let vach = UIView(frame: CGRect(x: 0, y: chieuCaoDong - 0.5, width: tongChieuRongBang, height: 0.5))
            vach.backgroundColor = .systemGray4
            vDong.addSubview(vach)
            khungBang.addSubview(vDong)
        }

        let dinhDangRender = UIGraphicsImageRendererFormat()
        dinhDangRender.scale = 2.0
        let boRender = UIGraphicsImageRenderer(size: khungBaoCao.bounds.size, format: dinhDangRender)
        return boRender.image { ctx in
            khungBaoCao.layer.render(in: ctx.cgContext)
        }
    }

    func taoVanBanBaoCao(ngay: Date, thongTinDonVi: String) -> String {
        let ds = danhSachHienThi
        let soDat = ds.filter { $0.daDat }.count
        let soChuaDat = ds.count - soDat
        var dongVanBan: [String] = []
        dongVanBan.append("📊 TỔNG HỢP THI ĐUA ĐMX (\(TienIchNgay.hienThiNgay.string(from: ngay)))")
        if !thongTinDonVi.isEmpty {
            dongVanBan.append("🏪 Đơn vị: \(thongTinDonVi)")
        }
        dongVanBan.append("📌 Tổng: \(ds.count) CT | 🟢 Đạt: \(soDat) | 🔴 Chưa đạt: \(soChuaDat)")
        dongVanBan.append("----------------------------------------")

        for (i, d) in ds.enumerated() {
            let icon = d.daDat ? "🟢" : "🔴"
            let trangThai = d.chenhLech >= 0 ? "Vượt \(d.chenhLech.chuoiChenhLech)" : "Thiếu \(abs(d.chenhLech).chuoiSoLieu)"
            dongVanBan.append("\(i + 1). \(icon) \(d.tenNganhHang) (\(d.loaiChiTieu.rawValue))")
            dongVanBan.append("   TH: \(d.thucHien.chuoiSoLieu) / Target: \(d.target.chuoiSoLieu) (\(trangThai)) -> HT: \(d.phanTramHT.chuoiPhanTram) | Dự báo: \(d.phanTramDuBao.chuoiPhanTram)")
        }
        return dongVanBan.joined(separator: "\n")
    }

    func taoChuoiCSV() -> String {
        var cacDong: [String] = []
        cacDong.append("STT,Ngành hàng,ĐVT,Thực hiện,Target,Còn thiếu / Vượt,% HT Tháng,% Dự báo,Trạng thái")
        for (i, d) in danhSachHienThi.enumerated() {
            let tenSach = "\"\(d.tenNganhHang.replacingOccurrences(of: "\"", with: "\"\""))\""
            let trangThai = d.daDat ? "Đạt" : "Chưa đạt"
            let dong = "\(i + 1),\(tenSach),\(d.loaiChiTieu.rawValue),\(d.thucHien),\(d.target),\(d.chenhLech),\(String(format: "%.2f", d.phanTramHT))%,\(String(format: "%.2f", d.phanTramDuBao))%,\(trangThai)"
            cacDong.append(dong)
        }
        return "\u{FEFF}" + cacDong.joined(separator: "\n")
    }
}
