import UIKit
import PhotosUI

final class ManHinhChinh: UIViewController, PHPickerViewControllerDelegate {
    private enum CheDoQuetAnh {
        case doanhThu
        case theoMuc(LoaiTabMuc)
    }

    private var ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
    private var tabHienTai: LoaiTabMuc = .thiDua
    private var cheDoQuet: CheDoQuetAnh = .theoMuc(.thiDua)

    private let nutNgay = UIButton(type: .system)

    // 1. Cụm 2 thẻ Doanh thu (Doanh thu thực & Doanh thu QĐ)
    private let theDTThuc = TheDoanhThuView(
        tieuDe: "💵 DOANH THU THỰC",
        mauBatDau: UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1),
        mauKetThuc: UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1),
        hienChamTron: false
    )
    private let theDTQD = TheDoanhThuView(
        tieuDe: "🎯 DOANH THU QĐ",
        mauBatDau: UIColor(red: 0.09, green: 0.64, blue: 0.29, alpha: 1),
        mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1),
        hienChamTron: true
    )

    // 2. Cụm 4 nút phía dưới cụm Doanh thu: Thi đua + 3 nút dự phòng
    private var cacNutMuc: [UIButton] = []

    // 3. Cụm nút Quét / Thêm ảnh mới & Xoá quét lại nằm ngay dưới cụm 4 nút
    private let nutThemAnhMoi = UIButton(type: .system)
    private let nutXoaQuetLai = UIButton(type: .system)
    private let nutThemThuCong = UIButton(type: .system)

    // 4. Nội dung của từng mục
    private let bangThiDua = BangThiDuaView()
    private let khungDuPhong = UIView()
    private let nhanTieuDeDuPhong = UILabel()
    private let nhanMoTaDuPhong = UILabel()

    // Hộp thoại tiến trình quét
    private let lopPhuTai = UIView()
    private let nhanTienTrinh = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        cauHinhThanhDieuHuong()
        taoGiaoDien()
        napDuLieu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        napDuLieu()
    }

    // MARK: - Thanh điều hướng trên cùng (Chọn ngày | Xuất báo cáo | Cài đặt)

    private func cauHinhThanhDieuHuong() {
        nutNgay.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        nutNgay.addTarget(self, action: #selector(moLichSuNgay), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: nutNgay)

        let nutCaiDat = UIBarButtonItem(
            image: UIImage(systemName: "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(moCaiDat)
        )

        let nutXuat = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(moMenuXuatBaoCao)
        )

        navigationItem.rightBarButtonItems = [nutCaiDat, nutXuat]
    }

    @objc private func moCaiDat() {
        navigationController?.pushViewController(ManHinhCaiDat(), animated: true)
    }

    // MARK: - Dựng giao diện chính

    private func taoGiaoDien() {
        // 1. Cụm Doanh thu
        theDTThuc.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)
        theDTQD.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)

        let hangDoanhThu = UIStackView(arrangedSubviews: [theDTThuc, theDTQD])
        hangDoanhThu.axis = .horizontal
        hangDoanhThu.spacing = 10
        hangDoanhThu.distribution = .fillEqually

        // 2. Cụm 4 nút phía dưới cụm Doanh thu (Thi đua + 3 nút dự phòng)
        cacNutMuc = LoaiTabMuc.allCases.map { loai in
            let nut = UIButton(type: .custom)
            nut.tag = loai.rawValue
            nut.setTitle(loai.tieuDe, for: .normal)
            nut.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
            nut.titleLabel?.adjustsFontSizeToFitWidth = true
            nut.titleLabel?.minimumScaleFactor = 0.8
            nut.layer.cornerRadius = 10
            nut.layer.borderWidth = 1
            nut.addTarget(self, action: #selector(bamChonMuc(_:)), for: .touchUpInside)
            return nut
        }

        let hangBonNut = UIStackView(arrangedSubviews: cacNutMuc)
        hangBonNut.axis = .horizontal
        hangBonNut.spacing = 6
        hangBonNut.distribution = .fillEqually

        // 3. Thanh nút Quét (Thêm ảnh) & Xoá (Quét lại từ đầu) nằm dưới cụm 4 nút
        nutThemAnhMoi.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        nutThemAnhMoi.setTitle(" Thêm ảnh", for: .normal)
        nutThemAnhMoi.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutThemAnhMoi.backgroundColor = .systemBlue
        nutThemAnhMoi.tintColor = .white
        nutThemAnhMoi.layer.cornerRadius = 10
        nutThemAnhMoi.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutThemAnhMoi.addTarget(self, action: #selector(bamThemAnhMoi), for: .touchUpInside)

        nutXoaQuetLai.setTitle(" Xoá", for: .normal)
        nutXoaQuetLai.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        nutXoaQuetLai.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutXoaQuetLai.backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
        nutXoaQuetLai.tintColor = .systemRed
        nutXoaQuetLai.layer.cornerRadius = 10
        nutXoaQuetLai.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        nutXoaQuetLai.addTarget(self, action: #selector(bamXoaQuetLai), for: .touchUpInside)

        nutThemThuCong.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        nutThemThuCong.setTitle(" Nhập/Mẫu", for: .normal)
        nutThemThuCong.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .semibold)
        nutThemThuCong.backgroundColor = .secondarySystemGroupedBackground
        nutThemThuCong.tintColor = .label
        nutThemThuCong.layer.cornerRadius = 10
        nutThemThuCong.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutThemThuCong.addTarget(self, action: #selector(moMenuNhapThuCong), for: .touchUpInside)

        let hangNutQuet = UIStackView(arrangedSubviews: [nutThemAnhMoi, nutXoaQuetLai, nutThemThuCong])
        hangNutQuet.axis = .horizontal
        hangNutQuet.spacing = 6
        nutThemAnhMoi.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nutThemAnhMoi.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nutXoaQuetLai.setContentHuggingPriority(.required, for: .horizontal)
        nutXoaQuetLai.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutThemThuCong.setContentHuggingPriority(.required, for: .horizontal)
        nutThemThuCong.setContentCompressionResistancePriority(.required, for: .horizontal)

        // 4. Nội dung mục Thi đua & 3 mục dự phòng
        bangThiDua.khiBamQuetAnh = { [weak self] in
            self?.bamThemAnhMoi()
        }
        bangThiDua.khiChonDong = { [weak self] dong in
            self?.moHopThoaiSuaDong(dong)
        }
        bangThiDua.khiXoaDong = { [weak self] id in
            guard let self = self else { return }
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            dl.danhSachThiDua.removeAll { $0.id == id }
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        }

        taoGiaoDienKhungDuPhong()

        [hangDoanhThu, hangBonNut, hangNutQuet, bangThiDua, khungDuPhong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            hangDoanhThu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            hangDoanhThu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hangDoanhThu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hangDoanhThu.heightAnchor.constraint(equalToConstant: 86),

            hangBonNut.topAnchor.constraint(equalTo: hangDoanhThu.bottomAnchor, constant: 8),
            hangBonNut.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hangBonNut.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hangBonNut.heightAnchor.constraint(equalToConstant: 36),

            hangNutQuet.topAnchor.constraint(equalTo: hangBonNut.bottomAnchor, constant: 6),
            hangNutQuet.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hangNutQuet.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hangNutQuet.heightAnchor.constraint(equalToConstant: 36),

            bangThiDua.topAnchor.constraint(equalTo: hangNutQuet.bottomAnchor, constant: 8),
            bangThiDua.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bangThiDua.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bangThiDua.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),

            khungDuPhong.topAnchor.constraint(equalTo: hangNutQuet.bottomAnchor, constant: 8),
            khungDuPhong.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            khungDuPhong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            khungDuPhong.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])

        taoLopPhuTienTrinh()
        capNhatTrangThaiMuc()
    }

    private func taoGiaoDienKhungDuPhong() {
        khungDuPhong.backgroundColor = .secondarySystemGroupedBackground
        khungDuPhong.layer.cornerRadius = 14

        let icon = UIImageView(image: UIImage(systemName: "hammer.fill"))
        icon.tintColor = .secondaryLabel
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 38, weight: .regular)

        nhanTieuDeDuPhong.font = .systemFont(ofSize: 16, weight: .bold)
        nhanTieuDeDuPhong.textAlignment = .center

        nhanMoTaDuPhong.text = "Mục dự phòng đang để trống cho các tính năng tiếp theo."
        nhanMoTaDuPhong.font = .systemFont(ofSize: 13)
        nhanMoTaDuPhong.textColor = .secondaryLabel
        nhanMoTaDuPhong.textAlignment = .center
        nhanMoTaDuPhong.numberOfLines = 0

        let ngan = UIStackView(arrangedSubviews: [icon, nhanTieuDeDuPhong, nhanMoTaDuPhong])
        ngan.axis = .vertical
        ngan.spacing = 8
        ngan.alignment = .center
        ngan.translatesAutoresizingMaskIntoConstraints = false
        khungDuPhong.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.centerXAnchor.constraint(equalTo: khungDuPhong.centerXAnchor),
            ngan.centerYAnchor.constraint(equalTo: khungDuPhong.centerYAnchor),
            ngan.leadingAnchor.constraint(greaterThanOrEqualTo: khungDuPhong.leadingAnchor, constant: 24),
            ngan.trailingAnchor.constraint(lessThanOrEqualTo: khungDuPhong.trailingAnchor, constant: -24)
        ])
    }

    private func taoLopPhuTienTrinh() {
        lopPhuTai.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        lopPhuTai.isHidden = true
        lopPhuTai.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lopPhuTai)

        let hop = UIView()
        hop.backgroundColor = .systemBackground
        hop.layer.cornerRadius = 16
        hop.translatesAutoresizingMaskIntoConstraints = false
        lopPhuTai.addSubview(hop)

        vongQuay.color = .systemBlue
        vongQuay.translatesAutoresizingMaskIntoConstraints = false

        nhanTienTrinh.font = .systemFont(ofSize: 14, weight: .semibold)
        nhanTienTrinh.textAlignment = .center
        nhanTienTrinh.numberOfLines = 0
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
            hop.widthAnchor.constraint(equalToConstant: 240),

            vongQuay.topAnchor.constraint(equalTo: hop.topAnchor, constant: 18),
            vongQuay.centerXAnchor.constraint(equalTo: hop.centerXAnchor),

            nhanTienTrinh.topAnchor.constraint(equalTo: vongQuay.bottomAnchor, constant: 12),
            nhanTienTrinh.leadingAnchor.constraint(equalTo: hop.leadingAnchor, constant: 14),
            nhanTienTrinh.trailingAnchor.constraint(equalTo: hop.trailingAnchor, constant: -14),
            nhanTienTrinh.bottomAnchor.constraint(equalTo: hop.bottomAnchor, constant: -18)
        ])
    }

    // MARK: - Nạp dữ liệu & Chuyển đổi giữa 4 nút

    private func napDuLieu() {
        nutNgay.setTitle("📅 \(TienIchNgay.hienThiNgay.string(from: ngayHienTai)) ▾", for: .normal)
        nutNgay.sizeToFit()

        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        theDTThuc.capNhat(doanhThu: dl.doanhThu.doanhThuThuc, target: dl.doanhThu.targetThuc)
        theDTQD.capNhat(doanhThu: dl.doanhThu.doanhThuQuyDoi, target: dl.doanhThu.targetQuyDoi)
        bangThiDua.ganDanhSach(dl.danhSachThiDua)
        capNhatTrangThaiMuc()
    }

    @objc private func bamChonMuc(_ sender: UIButton) {
        guard let loai = LoaiTabMuc(rawValue: sender.tag) else { return }
        tabHienTai = loai
        capNhatTrangThaiMuc()
    }

    private func capNhatTrangThaiMuc() {
        for nut in cacNutMuc {
            let loai = LoaiTabMuc(rawValue: nut.tag) ?? .thiDua
            let dangChon = (loai == tabHienTai)
            if dangChon {
                nut.backgroundColor = .systemBlue
                nut.setTitleColor(.white, for: .normal)
                nut.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                nut.backgroundColor = .secondarySystemGroupedBackground
                nut.setTitleColor(.label, for: .normal)
                nut.layer.borderColor = UIColor.separator.cgColor
            }
        }

        // Nhãn nút Quét giữ gọn thành "Thêm ảnh"
        nutThemAnhMoi.setTitle(" Thêm ảnh", for: .normal)

        let laThiDua = (tabHienTai == .thiDua)
        bangThiDua.isHidden = !laThiDua
        khungDuPhong.isHidden = laThiDua
        nutThemThuCong.isHidden = !laThiDua

        if !laThiDua {
            nhanTieuDeDuPhong.text = tabHienTai.tieuDe
        }
    }

    // MARK: - Nút Thêm ảnh mới (Quét) & Nút Xoá quét lại từ đầu

    @objc private func bamThemAnhMoi() {
        switch tabHienTai {
        case .thiDua:
            moChonAnh(cheDo: .theoMuc(.thiDua), gioiHan: 0)
        case .duPhong1, .duPhong2, .duPhong3:
            let tb = UIAlertController(
                title: tabHienTai.tieuDe,
                message: "Mục \(tabHienTai.tieuDe) hiện đang là nút dự phòng chưa gắn chức năng.",
                preferredStyle: .alert
            )
            tb.addAction(UIAlertAction(title: "Đã hiểu", style: .default))
            present(tb, animated: true)
        }
    }

    @objc private func bamXoaQuetLai() {
        guard tabHienTai == .thiDua else { return }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)

        if dl.danhSachThiDua.isEmpty {
            // Nếu bảng đang trống sẵn -> mở chọn ảnh quét luôn
            moChonAnh(cheDo: .theoMuc(.thiDua), gioiHan: 0)
            return
        }

        let hoi = UIAlertController(
            title: "Xoá để quét lại từ đầu?",
            message: "Toàn bộ \(dl.danhSachThiDua.count) ngành hàng Thi đua hiện tại sẽ được xoá sạch để bạn quét lại từ đầu.",
            preferredStyle: .actionSheet
        )
        hoi.addAction(UIAlertAction(title: "🗑️ Xoá sạch & Chọn ảnh quét lại ngay", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            var moi = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            moi.danhSachThiDua = []
            KhoDuLieu.dungChung.luu(moi)
            self.napDuLieu()
            self.moChonAnh(cheDo: .theoMuc(.thiDua), gioiHan: 0)
        })
        hoi.addAction(UIAlertAction(title: "Chỉ xoá sạch danh sách", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            var moi = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            moi.danhSachThiDua = []
            KhoDuLieu.dungChung.luu(moi)
            self.napDuLieu()
        })
        hoi.addAction(UIAlertAction(title: "Huỷ", style: .cancel))

        if let pop = hoi.popoverPresentationController {
            pop.sourceView = nutXoaQuetLai
            pop.sourceRect = nutXoaQuetLai.bounds
        }
        present(hoi, animated: true)
    }

    @objc private func moMenuNhapThuCong() {
        let menu = UIAlertController(title: "Thêm dữ liệu", message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "➕ Thêm 1 ngành hàng thủ công", style: .default) { [weak self] _ in
            self?.bamThemDongThuCong()
        })
        menu.addAction(UIAlertAction(title: "✨ Nạp dữ liệu mẫu thử", style: .default) { [weak self] _ in
            self?.napDuLieuMau()
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.sourceView = nutThemThuCong
            pop.sourceRect = nutThemThuCong.bounds
        }
        present(menu, animated: true)
    }

    // MARK: - Tương tác 2 thẻ Doanh thu (Quét 1 ảnh hoặc nhập trực tiếp)

    @objc private func bamTheDoanhThu() {
        let menu = UIAlertController(
            title: "Doanh thu Thực & Quy đổi",
            message: "Chọn ảnh chụp màn hình để đọc tự động hoặc nhập trực tiếp:",
            preferredStyle: .actionSheet
        )
        menu.addAction(UIAlertAction(title: "📷 Chọn 1 ảnh chụp màn hình Doanh thu", style: .default) { [weak self] _ in
            self?.moChonAnh(cheDo: .doanhThu, gioiHan: 1)
        })
        menu.addAction(UIAlertAction(title: "✏️ Nhập / Sửa tay số liệu Doanh thu", style: .default) { [weak self] _ in
            self?.moHopThoaiNhapDoanhThu()
        })
        menu.addAction(UIAlertAction(title: "🗑️ Xoá số liệu Doanh thu", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            dl.doanhThu = ThongTinDoanhThu()
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))

        if let pop = menu.popoverPresentationController {
            pop.sourceView = theDTThuc
            pop.sourceRect = theDTThuc.bounds
        }
        present(menu, animated: true)
    }

    private func moHopThoaiNhapDoanhThu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dt = dl.doanhThu

        let hop = UIAlertController(
            title: "Số liệu Doanh thu",
            message: "Nhập Doanh thu thực, Target thực, Doanh thu QĐ và Target QĐ:",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Doanh thu thực (VD: 8541)"
            tf.keyboardType = .decimalPad
            if dt.doanhThuThuc > 0 { tf.text = String(dt.doanhThuThuc) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target thực (VD: 14466.40)"
            tf.keyboardType = .decimalPad
            if dt.targetThuc > 0 { tf.text = String(dt.targetThuc) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Doanh thu quy đổi (VD: 11438)"
            tf.keyboardType = .decimalPad
            if dt.doanhThuQuyDoi > 0 { tf.text = String(dt.doanhThuQuyDoi) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target quy đổi (VD: 19444.10)"
            tf.keyboardType = .decimalPad
            if dt.targetQuyDoi > 0 { tf.text = String(dt.targetQuyDoi) }
        }

        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self, let tfs = hop.textFields, tfs.count >= 4 else { return }
            var moi = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            moi.doanhThu = ThongTinDoanhThu(
                doanhThuThuc: self.docSoTuO(tfs[0].text),
                targetThuc: self.docSoTuO(tfs[1].text),
                doanhThuQuyDoi: self.docSoTuO(tfs[2].text),
                targetQuyDoi: self.docSoTuO(tfs[3].text)
            )
            KhoDuLieu.dungChung.luu(moi)
            self.napDuLieu()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func docSoTuO(_ text: String?) -> Double {
        let s = (text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        return Double(s) ?? 0
    }

    // MARK: - Chọn ảnh & Quét Apple Vision

    private func moChonAnh(cheDo: CheDoQuetAnh, gioiHan: Int) {
        cheDoQuet = cheDo
        var cauHinh = PHPickerConfiguration()
        cauHinh.filter = .images
        cauHinh.selectionLimit = gioiHan
        if #available(iOS 15.0, *) {
            cauHinh.selection = .ordered
        }
        let picker = PHPickerViewController(configuration: cauHinh)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let cheDo = cheDoQuet
        let nhom = DispatchGroup()
        var danhSach = Array<UIImage?>(repeating: nil, count: results.count)

        for (i, r) in results.enumerated() {
            guard r.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            nhom.enter()
            r.itemProvider.loadObject(ofClass: UIImage.self) { obj, _ in
                if let img = obj as? UIImage { danhSach[i] = img }
                nhom.leave()
            }
        }

        nhom.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let cacAnh = danhSach.compactMap { $0 }
            guard !cacAnh.isEmpty else { return }

            switch cheDo {
            case .doanhThu:
                if let anh = cacAnh.first {
                    self.xuLyQuetDoanhThu(anh)
                }
            case .theoMuc(.thiDua):
                self.xuLyQuetThiDua(cacAnh)
            case .theoMuc:
                break
            }
        }
    }

    private func xuLyQuetThiDua(_ cacAnh: [UIImage]) {
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Thi đua...")
        DichVuDocAnh.dungChung.quetAnhThiDua(
            danhSachAnh: cacAnh,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] kq in
                guard let self = self else { return }
                self.anTienTrinh()
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                dl.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: dl.danhSachThiDua, moi: kq.danhSach)
                dl.capNhatLuc = kq.capNhatLuc
                if !kq.thongTinDonVi.isEmpty { dl.thongTinDonVi = kq.thongTinDonVi }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            }
        )
    }

    private func xuLyQuetDoanhThu(_ anh: UIImage) {
        hienTienTrinh("Đang đọc ảnh Doanh thu...")
        DichVuDocAnh.dungChung.quetAnhDoanhThu(anh: anh) { [weak self] dt in
            guard let self = self else { return }
            self.anTienTrinh()
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            dl.doanhThu = dt
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
            if !dt.coDuLieu {
                self.moHopThoaiNhapDoanhThu()
            }
        }
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

    private func bamThemDongThuCong() {
        let moi = DongThiDua(tenNganhHang: "T10 - ", loaiChiTieu: .doanhThu, thucHien: 0, target: 0)
        moHopThoaiSuaDong(moi, laThemMoi: true)
    }

    private func moHopThoaiSuaDong(_ dong: DongThiDua, laThemMoi: Bool = false) {
        let hop = UIAlertController(
            title: laThemMoi ? "Thêm ngành hàng" : "Sửa ngành hàng",
            message: nil,
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Tên ngành hàng (VD: T10 - AUDIO)"
            tf.text = dong.tenNganhHang
        }
        hop.addTextField { tf in
            tf.placeholder = "ĐVT: DT hoặc SL"
            tf.text = dong.loaiChiTieu.maBang
            tf.autocapitalizationType = .allCharacters
        }
        hop.addTextField { tf in
            tf.placeholder = "Thực hiện (VD: 52.00)"
            tf.keyboardType = .decimalPad
            if !laThemMoi { tf.text = String(dong.thucHien) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target (VD: 55.12)"
            tf.keyboardType = .decimalPad
            if !laThemMoi { tf.text = String(dong.target) }
        }

        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self, let tfs = hop.textFields, tfs.count >= 4 else { return }
            let tenNhap = (tfs[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !tenNhap.isEmpty else { return }
            let dvt = (tfs[1].text ?? "DTLK").uppercased()
            let loai: LoaiChiTieuThiDua = dvt.contains("SL") ? .soLuong : .doanhThu
            let th = self.docSoTuO(tfs[2].text)
            let tg = self.docSoTuO(tfs[3].text)

            let capNhat = DongThiDua(
                id: dong.id,
                tenNganhHangGoc: tenNhap,
                tenNganhHang: tenNhap,
                loaiChiTieu: loai,
                thucHien: th,
                target: tg
            )

            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            if laThemMoi {
                dl.danhSachThiDua.append(capNhat)
            } else if let idx = dl.danhSachThiDua.firstIndex(where: { $0.id == dong.id }) {
                dl.danhSachThiDua[idx] = capNhat
            }
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        })

        if !laThemMoi {
            hop.addAction(UIAlertAction(title: "Xoá ngành hàng này", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                dl.danhSachThiDua.removeAll { $0.id == dong.id }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            })
        }

        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func napDuLieuMau() {
        var dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        dl.doanhThu = ThongTinDoanhThu(
            doanhThuThuc: 8541.00,
            targetThuc: 14466.40,
            doanhThuQuyDoi: 11438.00,
            targetQuyDoi: 19444.10
        )
        let mau: [DongThiDua] = [
            DongThiDua(tenNganhHang: "T09 - T10 IPHONE 18 series, iPhone Duo", loaiChiTieu: .doanhThu, thucHien: 4476.28, target: 3493.60),
            DongThiDua(tenNganhHang: "T10 - NẠP - RÚT TIỀN TÀI KHOẢN NGÂN HÀNG", loaiChiTieu: .soLuong, thucHien: 407, target: 363),
            DongThiDua(tenNganhHang: "T10 - SIM TỔNG", loaiChiTieu: .soLuong, thucHien: 52.00, target: 55.12),
            DongThiDua(tenNganhHang: "T10 - Bảo Hiểm Tổng", loaiChiTieu: .doanhThu, thucHien: 267.51, target: 294.92),
            DongThiDua(tenNganhHang: "T10 - TAI NGHE", loaiChiTieu: .doanhThu, thucHien: 19.43, target: 22.39),
            DongThiDua(tenNganhHang: "T10 - PHỤ KIỆN CÔNG NGHỆ", loaiChiTieu: .doanhThu, thucHien: 12.28, target: 14.34),
            DongThiDua(tenNganhHang: "T10 - TỦ LẠNH, TỦ ĐÔNG, TỦ MÁT", loaiChiTieu: .doanhThu, thucHien: 787.43, target: 1055.10),
            DongThiDua(tenNganhHang: "T10 - GIA DỤNG SUNHOUSE", loaiChiTieu: .doanhThu, thucHien: 533.02, target: 731.12),
            DongThiDua(tenNganhHang: "T10 - ĐIỆN TỬ TCL", loaiChiTieu: .doanhThu, thucHien: 175.26, target: 249.98),
            DongThiDua(tenNganhHang: "T10 - MÁY GIẶT", loaiChiTieu: .doanhThu, thucHien: 550.68, target: 810.24),
            DongThiDua(tenNganhHang: "T10 - CAMERA", loaiChiTieu: .doanhThu, thucHien: 38.68, target: 57.05),
            DongThiDua(tenNganhHang: "T10 - TIVI", loaiChiTieu: .doanhThu, thucHien: 594.02, target: 1122.16),
            DongThiDua(tenNganhHang: "T10 - AUDIO", loaiChiTieu: .doanhThu, thucHien: 19.00, target: 65.52),
            DongThiDua(tenNganhHang: "T10 - Máy Lạnh", loaiChiTieu: .soLuong, thucHien: 32.00, target: 152.88)
        ]
        dl.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: dl.danhSachThiDua, moi: mau)
        KhoDuLieu.dungChung.luu(dl)
        napDuLieu()
    }

    // MARK: - Lịch sử ngày & Xuất báo cáo

    @objc private func moLichSuNgay() {
        let sheet = UIAlertController(title: "Chọn ngày báo cáo", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Hôm nay", style: .default) { [weak self] _ in
            self?.ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
            self?.napDuLieu()
        })
        sheet.addAction(UIAlertAction(title: "Hôm qua", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.ngayHienTai = TienIchNgay.lich.date(byAdding: .day, value: -1, to: self.ngayHienTai) ?? self.ngayHienTai
            self.napDuLieu()
        })

        for khoa in KhoDuLieu.dungChung.cacNgay.keys.sorted(by: >).prefix(12) {
            guard let dl = KhoDuLieu.dungChung.cacNgay[khoa],
                  (!dl.danhSachThiDua.isEmpty || dl.doanhThu.coDuLieu) else { continue }
            sheet.addAction(UIAlertAction(title: "Ngày \(khoa) (\(dl.danhSachThiDua.count) ngành hàng)", style: .default) { [weak self] _ in
                if let d = TienIchNgay.khoa.date(from: khoa) {
                    self?.ngayHienTai = d
                    self?.napDuLieu()
                }
            })
        }

        sheet.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = sheet.popoverPresentationController {
            pop.sourceView = nutNgay
            pop.sourceRect = nutNgay.bounds
        }
        present(sheet, animated: true)
    }

    @objc private func moMenuXuatBaoCao() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        guard !dl.danhSachThiDua.isEmpty || dl.doanhThu.coDuLieu else { return }

        let kieu = KhoDuLieu.dungChung.caiDat.kieuHienThi
        let moTaKieu = (kieu == .bangChiTiet) ? "Mẫu Bảng 8 cột" : "Mẫu Thẻ \(KhoDuLieu.dungChung.caiDat.soCotXuatAnh) cột"

        let menu = UIAlertController(title: "Xuất báo cáo tổng hợp", message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "🖼️ Xuất Ảnh báo cáo (\(moTaKieu))", style: .default) { [weak self] _ in
            guard let self = self,
                  let anh = self.bangThiDua.taoAnhBaoCao(
                      ngay: self.ngayHienTai,
                      doanhThu: dl.doanhThu,
                      thongTinDonVi: dl.thongTinDonVi,
                      capNhatLuc: dl.capNhatLuc
                  ) else { return }
            self.chiaSe([anh])
        })
        menu.addAction(UIAlertAction(title: "📊 Xuất file Excel (.csv)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let csv = self.bangThiDua.taoChuoiExcelCSV(doanhThu: dl.doanhThu)
            let tenTep = "TongHopDMX-\(dl.khoaNgay).csv"
            let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
            try? csv.write(to: duongDan, atomically: true, encoding: .utf8)
            self.chiaSe([duongDan])
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(menu, animated: true)
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
