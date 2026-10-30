import UIKit
import PhotosUI

final class ManHinhChinh: UIViewController, PHPickerViewControllerDelegate {
    private var ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
    private var tabHienTai: LoaiTabChinh = .thiDua
    private var mucChonAnh: LoaiTabChinh = .thiDua

    private let nutNgay = UIButton(type: .system)
    private var cacNutTab: [UIButton] = []

    // Khu vực 1 & 2: Hiển thị ảnh Doanh thu thực quy đổi & Doanh thu lũy kế quy đổi
    private let khungAnhDTThuc = KhungXemAnhZoom(tieuDeMuc: "Doanh thu thực quy đổi")
    private let khungAnhDTLuyKe = KhungXemAnhZoom(tieuDeMuc: "Doanh thu lũy kế quy đổi")

    // Khu vực 3: Bảng tổng hợp Thi đua
    private let khungThiDua = UIView()
    private let nhanTrangThaiThiDua = UILabel()
    private let bangThiDua = BangThiDuaView()

    // Hộp thoại tiến trình khi đang quét ảnh
    private let lopPhuTai = UIView()
    private let nhanTienTrinh = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tổng Hợp Số Liệu ĐMX"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "clock.arrow.circlepath"),
            style: .plain,
            target: self,
            action: #selector(moLichSuNgay)
        )

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

        taoGiaoDien()
        napDuLieu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        napDuLieu()
    }

    // MARK: - Dựng giao diện chính

    private func taoGiaoDien() {
        // 1. Thanh chọn ngày
        let nutNgayTruoc = UIButton(type: .system)
        nutNgayTruoc.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        nutNgayTruoc.addTarget(self, action: #selector(ngayTruoc), for: .touchUpInside)

        let nutNgaySau = UIButton(type: .system)
        nutNgaySau.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        nutNgaySau.addTarget(self, action: #selector(ngaySau), for: .touchUpInside)

        nutNgay.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        nutNgay.addTarget(self, action: #selector(moLichSuNgay), for: .touchUpInside)

        let nutHomNay = UIButton(type: .system)
        nutHomNay.setTitle("Hôm nay", for: .normal)
        nutHomNay.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        nutHomNay.backgroundColor = .tertiarySystemFill
        nutHomNay.layer.cornerRadius = 8
        nutHomNay.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        nutHomNay.addTarget(self, action: #selector(veHomNay), for: .touchUpInside)

        let thanhNgay = UIStackView(arrangedSubviews: [nutNgayTruoc, nutNgay, nutNgaySau, nutHomNay])
        thanhNgay.axis = .horizontal
        thanhNgay.spacing = 10
        thanhNgay.alignment = .center
        thanhNgay.distribution = .equalCentering

        // 2. Ba nút chính trên màn hình: Doanh thu thực quy đổi | Doanh thu lũy kế quy đổi | Thi đua
        let danhSachNut: [(LoaiTabChinh, String, String)] = [
            (.doanhThuThuc, "Doanh thu thực\nquy đổi", "banknote.fill"),
            (.doanhThuLuyKe, "Doanh thu lũy kế\nquy đổi", "chart.line.uptrend.xyaxis"),
            (.thiDua, "Thi đua\n(Tổng hợp)", "trophy.fill")
        ]

        cacNutTab = danhSachNut.map { loai, nhan, icon in
            let nut = UIButton(type: .custom)
            nut.tag = loai.rawValue
            nut.layer.cornerRadius = 12
            nut.layer.borderWidth = 1.5
            nut.titleLabel?.numberOfLines = 2
            nut.titleLabel?.textAlignment = .center
            nut.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            nut.setTitle(nhan, for: .normal)
            nut.setImage(UIImage(systemName: icon), for: .normal)
            nut.semanticContentAttribute = .forceLeftToRight
            nut.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
            nut.contentEdgeInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
            nut.addTarget(self, action: #selector(bamChonTab(_:)), for: .touchUpInside)
            return nut
        }

        let hangBaNut = UIStackView(arrangedSubviews: cacNutTab)
        hangBaNut.axis = .horizontal
        hangBaNut.spacing = 8
        hangBaNut.distribution = .fillEqually

        // 3. Cấu hình sự kiện cho 2 khung xem ảnh Doanh thu
        cauHinhKhungAnhDoanhThu()

        // 4. Cấu hình khu vực Thi đua
        taoGiaoDienKhuVucThiDua()

        [thanhNgay, hangBaNut, khungAnhDTThuc, khungAnhDTLuyKe, khungThiDua].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            thanhNgay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            thanhNgay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            thanhNgay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            thanhNgay.heightAnchor.constraint(equalToConstant: 32),

            hangBaNut.topAnchor.constraint(equalTo: thanhNgay.bottomAnchor, constant: 8),
            hangBaNut.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hangBaNut.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hangBaNut.heightAnchor.constraint(equalToConstant: 52),

            khungAnhDTThuc.topAnchor.constraint(equalTo: hangBaNut.bottomAnchor, constant: 8),
            khungAnhDTThuc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            khungAnhDTThuc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            khungAnhDTThuc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6),

            khungAnhDTLuyKe.topAnchor.constraint(equalTo: hangBaNut.bottomAnchor, constant: 8),
            khungAnhDTLuyKe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            khungAnhDTLuyKe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            khungAnhDTLuyKe.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6),

            khungThiDua.topAnchor.constraint(equalTo: hangBaNut.bottomAnchor, constant: 8),
            khungThiDua.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            khungThiDua.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            khungThiDua.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6)
        ])

        taoLopPhuTienTrinh()
        capNhatTrangThaiBaNut()
    }

    private func cauHinhKhungAnhDoanhThu() {
        khungAnhDTThuc.khiBamChonAnh = { [weak self] in
            self?.moChonAnh(cho: .doanhThuThuc, gioiHan: 1)
        }
        khungAnhDTThuc.khiBamDanAnh = { [weak self] in
            self?.danAnhTuClipboard(cho: .doanhThuThuc)
        }
        khungAnhDTThuc.khiBamChiaSeAnh = { [weak self] anh in
            self?.chiaSe(cacMuc: [anh])
        }
        khungAnhDTThuc.khiBamXoaAnh = { [weak self] in
            self?.xoaAnhDoanhThu(loai: .doanhThuThuc)
        }

        khungAnhDTLuyKe.khiBamChonAnh = { [weak self] in
            self?.moChonAnh(cho: .doanhThuLuyKe, gioiHan: 1)
        }
        khungAnhDTLuyKe.khiBamDanAnh = { [weak self] in
            self?.danAnhTuClipboard(cho: .doanhThuLuyKe)
        }
        khungAnhDTLuyKe.khiBamChiaSeAnh = { [weak self] anh in
            self?.chiaSe(cacMuc: [anh])
        }
        khungAnhDTLuyKe.khiBamXoaAnh = { [weak self] in
            self?.xoaAnhDoanhThu(loai: .doanhThuLuyKe)
        }
    }

    private func taoGiaoDienKhuVucThiDua() {
        let nutQuetAnh = UIButton(type: .system)
        nutQuetAnh.setTitle(" Quét ảnh Thi đua", for: .normal)
        nutQuetAnh.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        nutQuetAnh.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutQuetAnh.backgroundColor = .systemBlue
        nutQuetAnh.tintColor = .white
        nutQuetAnh.layer.cornerRadius = 10
        nutQuetAnh.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        nutQuetAnh.addTarget(self, action: #selector(bamQuetAnhThiDua), for: .touchUpInside)

        let nutThemDong = UIButton(type: .system)
        nutThemDong.setTitle(" + Thêm", for: .normal)
        nutThemDong.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        nutThemDong.backgroundColor = .secondarySystemGroupedBackground
        nutThemDong.layer.cornerRadius = 10
        nutThemDong.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutThemDong.addTarget(self, action: #selector(bamThemDongThuCong), for: .touchUpInside)

        let nutMau = UIButton(type: .system)
        nutMau.setTitle(" Mẫu thử", for: .normal)
        nutMau.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        nutMau.backgroundColor = .secondarySystemGroupedBackground
        nutMau.layer.cornerRadius = 10
        nutMau.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutMau.addTarget(self, action: #selector(napDuLieuMauTuAnh), for: .touchUpInside)

        let nutXoaBang = UIButton(type: .system)
        nutXoaBang.setImage(UIImage(systemName: "trash"), for: .normal)
        nutXoaBang.tintColor = .systemRed
        nutXoaBang.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        nutXoaBang.layer.cornerRadius = 10
        nutXoaBang.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutXoaBang.addTarget(self, action: #selector(xacNhanXoaBangThiDua), for: .touchUpInside)

        let thanhTacVu = UIStackView(arrangedSubviews: [nutQuetAnh, nutThemDong, nutMau, UIView(), nutXoaBang])
        thanhTacVu.axis = .horizontal
        thanhTacVu.spacing = 6
        thanhTacVu.alignment = .center

        nhanTrangThaiThiDua.font = .systemFont(ofSize: 11, weight: .medium)
        nhanTrangThaiThiDua.textColor = .secondaryLabel
        nhanTrangThaiThiDua.text = "Chạm vào dòng bất kỳ trên bảng để chỉnh sửa số liệu"

        bangThiDua.khiBamQuetAnh = { [weak self] in
            self?.bamQuetAnhThiDua()
        }
        bangThiDua.khiChonDong = { [weak self] dong in
            self?.moHopThoaiSuaDong(dong)
        }
        bangThiDua.khiXoaDong = { [weak self] id in
            self?.xoaDongThiDua(id: id)
        }

        [thanhTacVu, nhanTrangThaiThiDua, bangThiDua].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungThiDua.addSubview($0)
        }

        NSLayoutConstraint.activate([
            thanhTacVu.topAnchor.constraint(equalTo: khungThiDua.topAnchor),
            thanhTacVu.leadingAnchor.constraint(equalTo: khungThiDua.leadingAnchor),
            thanhTacVu.trailingAnchor.constraint(equalTo: khungThiDua.trailingAnchor),
            thanhTacVu.heightAnchor.constraint(equalToConstant: 36),

            nhanTrangThaiThiDua.topAnchor.constraint(equalTo: thanhTacVu.bottomAnchor, constant: 3),
            nhanTrangThaiThiDua.leadingAnchor.constraint(equalTo: khungThiDua.leadingAnchor, constant: 4),
            nhanTrangThaiThiDua.trailingAnchor.constraint(equalTo: khungThiDua.trailingAnchor, constant: -4),

            bangThiDua.topAnchor.constraint(equalTo: nhanTrangThaiThiDua.bottomAnchor, constant: 4),
            bangThiDua.leadingAnchor.constraint(equalTo: khungThiDua.leadingAnchor),
            bangThiDua.trailingAnchor.constraint(equalTo: khungThiDua.trailingAnchor),
            bangThiDua.bottomAnchor.constraint(equalTo: khungThiDua.bottomAnchor)
        ])
    }

    private func taoLopPhuTienTrinh() {
        lopPhuTai.backgroundColor = UIColor.black.withAlphaComponent(0.45)
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
        nhanTienTrinh.textColor = .label
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
            hop.widthAnchor.constraint(equalToConstant: 260),

            vongQuay.topAnchor.constraint(equalTo: hop.topAnchor, constant: 20),
            vongQuay.centerXAnchor.constraint(equalTo: hop.centerXAnchor),

            nhanTienTrinh.topAnchor.constraint(equalTo: vongQuay.bottomAnchor, constant: 14),
            nhanTienTrinh.leadingAnchor.constraint(equalTo: hop.leadingAnchor, constant: 16),
            nhanTienTrinh.trailingAnchor.constraint(equalTo: hop.trailingAnchor, constant: -16),
            nhanTienTrinh.bottomAnchor.constraint(equalTo: hop.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Nạp & Cập nhật giao diện

    private func napDuLieu() {
        let chuoiNgay = TienIchNgay.hienThiNgay.string(from: ngayHienTai)
        nutNgay.setTitle("📅 Ngày \(chuoiNgay)", for: .normal)

        let duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)

        // Nạp 2 ảnh Doanh thu
        khungAnhDTThuc.ganAnh(ThuMucDuLieu.dungChung.taiAnh(tenTep: duLieu.tenTepAnhDTThuc))
        khungAnhDTLuyKe.ganAnh(ThuMucDuLieu.dungChung.taiAnh(tenTep: duLieu.tenTepAnhDTLuyKe))

        // Nạp bảng Thi đua
        bangThiDua.ganDanhSach(duLieu.danhSachThiDua)

        if !duLieu.capNhatLuc.isEmpty || !duLieu.thongTinDonVi.isEmpty {
            let donVi = duLieu.thongTinDonVi.isEmpty ? "" : "\(duLieu.thongTinDonVi) • "
            let capNhat = duLieu.capNhatLuc.isEmpty ? "" : "Cập nhật: \(duLieu.capNhatLuc)"
            nhanTrangThaiThiDua.text = "\(donVi)\(capNhat) (Chạm vào dòng để sửa)"
        } else {
            nhanTrangThaiThiDua.text = "Chạm vào dòng bất kỳ trên bảng để chỉnh sửa số liệu"
        }

        capNhatTrangThaiBaNut()
    }

    private func capNhatTrangThaiBaNut() {
        let duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let coDTThuc = (duLieu.tenTepAnhDTThuc != nil)
        let coDTLuyKe = (duLieu.tenTepAnhDTLuyKe != nil)
        let soCT = duLieu.danhSachThiDua.count

        for nut in cacNutTab {
            let loai = LoaiTabChinh(rawValue: nut.tag) ?? .thiDua
            let dangChon = (loai == tabHienTai)

            switch loai {
            case .doanhThuThuc:
                nut.setTitle(coDTThuc ? "DT Thực QĐ\n(Đã có ảnh)" : "Doanh thu thực\nquy đổi", for: .normal)
            case .doanhThuLuyKe:
                nut.setTitle(coDTLuyKe ? "DT Lũy kế QĐ\n(Đã có ảnh)" : "Doanh thu lũy kế\nquy đổi", for: .normal)
            case .thiDua:
                nut.setTitle(soCT > 0 ? "Thi đua\n(\(soCT) CT)" : "Thi đua\n(Tổng hợp)", for: .normal)
            }

            if dangChon {
                nut.backgroundColor = .systemBlue
                nut.setTitleColor(.white, for: .normal)
                nut.tintColor = .white
                nut.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                nut.backgroundColor = .secondarySystemGroupedBackground
                nut.setTitleColor(.label, for: .normal)
                nut.tintColor = .systemBlue
                nut.layer.borderColor = UIColor.separator.cgColor
            }
        }

        khungAnhDTThuc.isHidden = (tabHienTai != .doanhThuThuc)
        khungAnhDTLuyKe.isHidden = (tabHienTai != .doanhThuLuyKe)
        khungThiDua.isHidden = (tabHienTai != .thiDua)
    }

    @objc private func bamChonTab(_ sender: UIButton) {
        guard let loai = LoaiTabChinh(rawValue: sender.tag) else { return }
        tabHienTai = loai
        capNhatTrangThaiBaNut()
    }

    // MARK: - Điều hướng Ngày & Lịch sử

    @objc private func ngayTruoc() {
        ngayHienTai = TienIchNgay.lich.date(byAdding: .day, value: -1, to: ngayHienTai) ?? ngayHienTai
        napDuLieu()
    }

    @objc private func ngaySau() {
        ngayHienTai = TienIchNgay.lich.date(byAdding: .day, value: 1, to: ngayHienTai) ?? ngayHienTai
        napDuLieu()
    }

    @objc private func veHomNay() {
        ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
        napDuLieu()
    }

    @objc private func moLichSuNgay() {
        let bangChon = UIAlertController(
            title: "Lịch sử các ngày đã lưu",
            message: "Chọn ngày để xem lại bảng tổng hợp Thi đua và ảnh Doanh thu",
            preferredStyle: .actionSheet
        )

        let cacKhoa = KhoDuLieu.dungChung.cacNgay.keys.sorted(by: >)
        for khoa in cacKhoa.prefix(15) {
            guard let dl = KhoDuLieu.dungChung.cacNgay[khoa] else { continue }
            let ct = dl.danhSachThiDua.count
            let anh1 = dl.tenTepAnhDTThuc != nil ? "Có ảnh DT Thực" : ""
            let anh2 = dl.tenTepAnhDTLuyKe != nil ? "Có ảnh Lũy kế" : ""
            let moTa = ["\(ct) CT Thi đua", anh1, anh2].filter { !$0.isEmpty }.joined(separator: " • ")

            bangChon.addAction(UIAlertAction(title: "\(khoa) (\(moTa))", style: .default) { [weak self] _ in
                if let ngay = TienIchNgay.khoa.date(from: khoa) {
                    self?.ngayHienTai = ngay
                    self?.napDuLieu()
                }
            })
        }

        bangChon.addAction(UIAlertAction(title: "Hôm nay", style: .default) { [weak self] _ in
            self?.veHomNay()
        })
        bangChon.addAction(UIAlertAction(title: "Đóng", style: .cancel))

        if let pop = bangChon.popoverPresentationController {
            pop.sourceView = nutNgay
            pop.sourceRect = nutNgay.bounds
        }
        present(bangChon, animated: true)
    }

    @objc private func moCaiDat() {
        navigationController?.pushViewController(ManHinhCaiDat(), animated: true)
    }

    // MARK: - Chọn ảnh chụp màn hình & Quét dữ liệu

    @objc private func bamQuetAnhThiDua() {
        moChonAnh(cho: .thiDua, gioiHan: 0) // 0 = Cho phép chọn nhiều ảnh chụp màn hình cùng lúc
    }

    private func moChonAnh(cho muc: LoaiTabChinh, gioiHan: Int) {
        mucChonAnh = muc
        var cauHinh = PHPickerConfiguration()
        cauHinh.filter = .images
        cauHinh.selectionLimit = gioiHan
        if #available(iOS 15.0, *) {
            cauHinh.selection = .ordered
        }
        let boChon = PHPickerViewController(configuration: cauHinh)
        boChon.delegate = self
        present(boChon, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let muc = mucChonAnh
        let nhom = DispatchGroup()
        var anhTheoThuTu = Array<UIImage?>(repeating: nil, count: results.count)

        for (chiSo, ketQua) in results.enumerated() {
            guard ketQua.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            nhom.enter()
            ketQua.itemProvider.loadObject(ofClass: UIImage.self) { doiTuong, _ in
                if let anh = doiTuong as? UIImage {
                    anhTheoThuTu[chiSo] = anh
                }
                nhom.leave()
            }
        }

        nhom.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let danhSachAnh = anhTheoThuTu.compactMap { $0 }
            guard !danhSachAnh.isEmpty else { return }

            switch muc {
            case .doanhThuThuc, .doanhThuLuyKe:
                if let anhDau = danhSachAnh.first {
                    self.luuAnhDoanhThu(anhDau, loai: muc)
                }
            case .thiDua:
                self.thucHienQuetDanhSachAnhThiDua(danhSachAnh)
            }
        }
    }

    private func luuAnhDoanhThu(_ anh: UIImage, loai: LoaiTabChinh) {
        var duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let khoa = duLieu.khoaNgay
        let tenTep = (loai == .doanhThuThuc) ? "dt-thuc-\(khoa).jpg" : "dt-luyke-\(khoa).jpg"

        if ThuMucDuLieu.dungChung.luuAnh(anh, tenTep: tenTep) {
            if loai == .doanhThuThuc {
                duLieu.tenTepAnhDTThuc = tenTep
            } else {
                duLieu.tenTepAnhDTLuyKe = tenTep
            }
            KhoDuLieu.dungChung.luu(duLieu)
            napDuLieu()
        }
    }

    private func danAnhTuClipboard(cho loai: LoaiTabChinh) {
        guard let anh = UIPasteboard.general.image else {
            hienThongBao(tieuDe: "Clipboard trống", noiDung: "Chưa có hình ảnh nào được sao chép trong bộ nhớ tạm. Hãy sao chép ảnh trước hoặc bấm \"Chọn ảnh\".")
            return
        }
        luuAnhDoanhThu(anh, loai: loai)
    }

    private func xoaAnhDoanhThu(loai: LoaiTabChinh) {
        var duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        if loai == .doanhThuThuc {
            ThuMucDuLieu.dungChung.xoaAnh(tenTep: duLieu.tenTepAnhDTThuc)
            duLieu.tenTepAnhDTThuc = nil
        } else {
            ThuMucDuLieu.dungChung.xoaAnh(tenTep: duLieu.tenTepAnhDTLuyKe)
            duLieu.tenTepAnhDTLuyKe = nil
        }
        KhoDuLieu.dungChung.luu(duLieu)
        napDuLieu()
    }

    // MARK: - Xử lý quét ảnh Thi đua bằng Apple Vision + Gemini

    private func thucHienQuetDanhSachAnhThiDua(_ danhSachAnh: [UIImage]) {
        hienTienTrinh("Đang chuẩn bị đọc \(danhSachAnh.count) ảnh chụp màn hình...")

        DichVuDocAnh.dungChung.quetAnhThiDua(
            danhSachAnh: danhSachAnh,
            tienTrinh: { [weak self] trangThai in
                self?.nhanTienTrinh.text = trangThai
            },
            hoanTat: { [weak self] ketQua in
                guard let self = self else { return }
                self.anTienTrinh()

                switch ketQua {
                case .success(let kq):
                    var duLieu = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                    if KhoDuLieu.dungChung.caiDat.gopCongDonKhiQuetThem && !duLieu.danhSachThiDua.isEmpty {
                        duLieu.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: duLieu.danhSachThiDua, moi: kq.danhSach)
                    } else {
                        duLieu.danhSachThiDua = kq.danhSach
                    }
                    if !kq.capNhatLuc.isEmpty {
                        duLieu.capNhatLuc = kq.capNhatLuc
                    }
                    if !kq.thongTinDonVi.isEmpty {
                        duLieu.thongTinDonVi = kq.thongTinDonVi
                    }
                    KhoDuLieu.dungChung.luu(duLieu)
                    self.napDuLieu()

                    if let canhBao = kq.canhBao {
                        self.hienThongBao(
                            tieuDe: "Đã đọc \(kq.danhSach.count) chương trình",
                            noiDung: "\(canhBao)\n\nNguồn: \(kq.nguonPhanTich)"
                        )
                    }
                case .failure(let loi):
                    self.hienThongBao(tieuDe: "Không thể đọc ảnh", noiDung: loi.localizedDescription)
                }
            }
        )
    }

    private func hienTienTrinh(_ thongDiep: String) {
        nhanTienTrinh.text = thongDiep
        lopPhuTai.isHidden = false
        vongQuay.startAnimating()
    }

    private func anTienTrinh() {
        vongQuay.stopAnimating()
        lopPhuTai.isHidden = true
    }

    // MARK: - Thêm / Sửa / Xoá dòng Thi đua & Dữ liệu mẫu

    @objc private func bamThemDongThuCong() {
        let dongMoi = DongThiDua(
            tenNganhHang: "",
            loaiChiTieu: .doanhThu,
            thucHien: 0,
            target: 0,
            phanTramHTGoc: nil,
            phanTramDuBaoGoc: nil
        )
        moHopThoaiSuaDong(dongMoi, laThemMoi: true)
    }

    private func moHopThoaiSuaDong(_ dong: DongThiDua, laThemMoi: Bool = false) {
        let hop = UIAlertController(
            title: laThemMoi ? "Thêm chương trình Thi đua" : "Chỉnh sửa số liệu",
            message: "Nhập Tên ngành hàng, ĐVT (SL hoặc DT), Thực hiện, Target và % Dự báo",
            preferredStyle: .alert
        )

        hop.addTextField { tf in
            tf.placeholder = "Tên ngành hàng (VD: T10 - Máy Lạnh)"
            tf.text = dong.tenNganhHang
        }
        hop.addTextField { tf in
            tf.placeholder = "Đơn vị tính: nhập SL hoặc DT"
            tf.text = dong.loaiChiTieu.rawValue
            tf.autocapitalizationType = .allCharacters
        }
        hop.addTextField { tf in
            tf.placeholder = "Thực hiện (VD: 39 hoặc 4476.28)"
            tf.keyboardType = .decimalPad
            tf.text = laThemMoi ? "" : String(dong.thucHien)
        }
        hop.addTextField { tf in
            tf.placeholder = "Target (VD: 147 hoặc 3493.60)"
            tf.keyboardType = .decimalPad
            tf.text = laThemMoi ? "" : String(dong.target)
        }
        hop.addTextField { tf in
            tf.placeholder = "% Dự báo (Để trống sẽ tự tính)"
            tf.keyboardType = .decimalPad
            if let db = dong.phanTramDuBaoGoc {
                tf.text = String(format: "%.1f", db)
            }
        }

        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self,
                  let tfs = hop.textFields, tfs.count >= 5 else { return }

            let ten = tfs[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !ten.isEmpty else { return }

            let chuoiDVT = (tfs[1].text ?? "DT").uppercased()
            let loai: LoaiChiTieuThiDua = chuoiDVT.contains("SL") ? .soLuong : .doanhThu
            let thucHien = Double((tfs[2].text ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0
            let target = Double((tfs[3].text ?? "").replacingOccurrences(of: ",", with: ".")) ?? 0
            let duBao = Double((tfs[4].text ?? "").replacingOccurrences(of: ",", with: "."))

            var capNhat = dong
            capNhat.tenNganhHang = ten
            capNhat.loaiChiTieu = loai
            capNhat.thucHien = thucHien
            capNhat.target = target
            capNhat.phanTramDuBaoGoc = duBao

            var duLieu = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            if laThemMoi {
                duLieu.danhSachThiDua.append(capNhat)
            } else if let idx = duLieu.danhSachThiDua.firstIndex(where: { $0.id == dong.id }) {
                duLieu.danhSachThiDua[idx] = capNhat
            }
            KhoDuLieu.dungChung.luu(duLieu)
            self.napDuLieu()
        })

        if !laThemMoi {
            hop.addAction(UIAlertAction(title: "Xoá dòng này", style: .destructive) { [weak self] _ in
                self?.xoaDongThiDua(id: dong.id)
            })
        }

        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func xoaDongThiDua(id: UUID) {
        var duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        duLieu.danhSachThiDua.removeAll { $0.id == id }
        KhoDuLieu.dungChung.luu(duLieu)
        napDuLieu()
    }

    @objc private func xacNhanXoaBangThiDua() {
        let duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        guard !duLieu.danhSachThiDua.isEmpty else { return }

        let hoi = UIAlertController(
            title: "Xoá bảng Thi đua?",
            message: "Bạn có chắc muốn xoá toàn bộ \(duLieu.danhSachThiDua.count) dòng thi đua của ngày này không?",
            preferredStyle: .alert
        )
        hoi.addAction(UIAlertAction(title: "Xoá tất cả", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            dl.danhSachThiDua = []
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        })
        hoi.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hoi, animated: true)
    }

    @objc private func napDuLieuMauTuAnh() {
        let mau: [DongThiDua] = [
            DongThiDua(tenNganhHang: "T10 - Máy Lạnh", loaiChiTieu: .soLuong, thucHien: 39, target: 147, phanTramHTGoc: 26.53, phanTramDuBaoGoc: 28.4),
            DongThiDua(tenNganhHang: "T09 - T10 IPHONE 18 series, iPhone Duo", loaiChiTieu: .doanhThu, thucHien: 4476.28, target: 3493.60, phanTramHTGoc: 128.13, phanTramDuBaoGoc: 134.2),
            DongThiDua(tenNganhHang: "T10 - NẠP - RÚT TIỀN TÀI KHOẢN NGÂN HÀNG", loaiChiTieu: .soLuong, thucHien: 407, target: 363, phanTramHTGoc: 112.12, phanTramDuBaoGoc: 119.8),
            DongThiDua(tenNganhHang: "T10 - Bảo Hiểm Tổng", loaiChiTieu: .doanhThu, thucHien: 306.69, target: 283.58, phanTramHTGoc: 108.15, phanTramDuBaoGoc: 115.5),
            DongThiDua(tenNganhHang: "T10 - BẢO HIỂM THỢ ĐMX_ICT", loaiChiTieu: .doanhThu, thucHien: 103.82, target: 73.99, phanTramHTGoc: 140.32, phanTramDuBaoGoc: 149.8),
            DongThiDua(tenNganhHang: "T10 - BẢO HIỂM THỢ ĐMX_CE", loaiChiTieu: .doanhThu, thucHien: 551.87, target: 745.76, phanTramHTGoc: 74.0, phanTramDuBaoGoc: 79.0)
        ]

        var duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        duLieu.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: duLieu.danhSachThiDua, moi: mau)
        duLieu.thongTinDonVi = "ĐML_QNG_QNG - 275 Quang Trung"
        duLieu.capNhatLuc = "23:45:21 30/10/2026"
        KhoDuLieu.dungChung.luu(duLieu)
        napDuLieu()
    }

    // MARK: - Xuất báo cáo (Ảnh bảng tổng hợp / Văn bản Zalo / CSV Excel)

    @objc private func moMenuXuatBaoCao() {
        let duLieu = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)

        // Nếu đang ở tab Doanh thu và có ảnh -> chia sẻ ảnh đó
        if tabHienTai == .doanhThuThuc, let anh = ThuMucDuLieu.dungChung.taiAnh(tenTep: duLieu.tenTepAnhDTThuc) {
            chiaSe(cacMuc: [anh])
            return
        }
        if tabHienTai == .doanhThuLuyKe, let anh = ThuMucDuLieu.dungChung.taiAnh(tenTep: duLieu.tenTepAnhDTLuyKe) {
            chiaSe(cacMuc: [anh])
            return
        }

        guard !duLieu.danhSachThiDua.isEmpty else {
            hienThongBao(tieuDe: "Chưa có dữ liệu", noiDung: "Hãy quét ảnh chụp màn hình hoặc bấm \"Mẫu thử\" trước khi xuất bảng tổng hợp.")
            return
        }

        let menu = UIAlertController(
            title: "Xuất & Chia sẻ Bảng Tổng Hợp",
            message: "Chọn định dạng bạn muốn chia sẻ hoặc lưu:",
            preferredStyle: .actionSheet
        )

        menu.addAction(UIAlertAction(title: "🖼️ Xuất Ảnh bảng tổng hợp (Gửi Zalo/Nhóm)", style: .default) { [weak self] _ in
            guard let self = self,
                  let anhBaoCao = self.bangThiDua.taoAnhBaoCao(
                      ngay: self.ngayHienTai,
                      thongTinDonVi: duLieu.thongTinDonVi,
                      capNhatLuc: duLieu.capNhatLuc
                  ) else { return }
            self.chiaSe(cacMuc: [anhBaoCao])
        })

        menu.addAction(UIAlertAction(title: "📋 Sao chép văn bản báo cáo nhanh", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let vanBan = self.bangThiDua.taoVanBanBaoCao(ngay: self.ngayHienTai, thongTinDonVi: duLieu.thongTinDonVi)
            UIPasteboard.general.string = vanBan
            self.hienThongBao(tieuDe: "Đã sao chép!", noiDung: "Báo cáo tổng hợp đã được lưu vào bộ nhớ tạm. Bạn có thể dán thẳng vào Zalo hoặc tin nhắn.")
        })

        menu.addAction(UIAlertAction(title: "📊 Xuất file CSV (Mở bằng Excel / Numbers)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let csv = self.bangThiDua.taoChuoiCSV()
            let tenTep = "TongHopThiDua-\(duLieu.khoaNgay).csv"
            let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
            try? csv.write(to: duongDan, atomically: true, encoding: .utf8)
            self.chiaSe(cacMuc: [duongDan])
        })

        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))

        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(menu, animated: true)
    }

    private func chiaSe(cacMuc: [Any]) {
        let vc = UIActivityViewController(activityItems: cacMuc, applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = view
            pop.sourceRect = CGRect(x: view.bounds.midX, y: 80, width: 1, height: 1)
        }
        present(vc, animated: true)
    }

    private func hienThongBao(tieuDe: String, noiDung: String) {
        let tb = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đã hiểu", style: .default))
        present(tb, animated: true)
    }
}
