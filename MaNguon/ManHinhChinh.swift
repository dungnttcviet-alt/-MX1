import UIKit
import PhotosUI

final class ManHinhChinh: UIViewController, PHPickerViewControllerDelegate {
    private enum CheDoQuetAnh {
        case doanhThu(LoaiCheDoDoanhThu)
        case thiDua
        case doanhThuNhanVien
    }

    private var ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
    private var tabHienTai: LoaiTabMuc = .thiDua
    private var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private var cheDoQuet: CheDoQuetAnh = .thiDua
    private var thayTheBangThiDuaKhiQuet: Bool = false

    private let nutNgay = UIButton(type: .system)

    // 1. Cụm Tiến độ tháng & 8 thẻ Chỉ số chính (Doanh thu)
    private let cumChiSoChinh = CumChiSoChinhView(coLon: false)

    // 2. Cụm 4 nút phía dưới cụm Doanh thu: Thi đua | Nhân viên | Dự phòng 2 | Dự phòng 3
    private var cacNutMuc: [UIButton] = []

    // 3. Cụm nút Quét / Thêm ảnh mới & Xoá quét lại nằm ngay dưới cụm 4 nút
    private let nutThemAnhMoi = UIButton(type: .system)
    private let nutXoaQuetLai = UIButton(type: .system)
    private let nutThemThuCong = UIButton(type: .system)

    // 4. Nội dung của từng mục
    private let bangThiDua = BangThiDuaView()
    private let bangNhanVien = BangNhanVienView()
    private let bangRealtimeThang = BangTongHopRealtimeThangView()
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
        NotificationCenter.default.addObserver(self, selector: #selector(duLieuDaDongBo), name: .duLieuDMXDaDongBo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ungDungTroLai), name: UIApplication.willEnterForegroundNotification, object: nil)
        DichVuDongBo.dungChung.taiDuLieu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        napDuLieu()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    @objc private func duLieuDaDongBo() { napDuLieu() }
    @objc private func ungDungTroLai() { DichVuDongBo.dungChung.taiDuLieu() }

    // MARK: - Thanh điều hướng trên cùng (Chọn ngày | Tài khoản | Xuất báo cáo | Cài đặt)

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

        let nutDangXuat = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle"),
            style: .plain,
            target: self,
            action: #selector(moMenuTaiKhoan)
        )

        navigationItem.rightBarButtonItems = [nutCaiDat, nutXuat, nutDangXuat]
    }

    @objc private func moCaiDat() {
        navigationController?.pushViewController(ManHinhCaiDat(ngay: ngayHienTai), animated: true)
    }

    @objc private func moMenuTaiKhoan() {
        let tk = DichVuDongBo.dungChung.tenDangNhap.isEmpty ? "Tài khoản ĐMX" : DichVuDongBo.dungChung.tenDangNhap
        let menu = UIAlertController(
            title: "Tài khoản: \(tk)",
            message: "Đồng bộ hai chiều với duongnt.io.vn/dmx",
            preferredStyle: .actionSheet
        )
        menu.addAction(UIAlertAction(title: "🔄 Đồng bộ từ đám mây ngay", style: .default) { _ in
            DichVuDongBo.dungChung.taiDuLieu()
        })
        menu.addAction(UIAlertAction(title: "⚙️ Cài đặt & Quản lý Nhân viên", style: .default) { [weak self] _ in
            self?.moCaiDat()
        })
        menu.addAction(UIAlertAction(title: "Đăng xuất tài khoản", style: .destructive) { _ in
            DichVuDongBo.dungChung.dangXuat()
            (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiDangNhap()
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(menu, animated: true)
    }

    // MARK: - Dựng giao diện chính

    private func taoGiaoDien() {
        // 1. Cụm Tiến độ tháng & 8 thẻ Chỉ số chính (Doanh thu: Lũy kế & Realtime)
        cumChiSoChinh.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)
        cumChiSoChinh.khiBamVungThe = { [weak self] in
            self?.bamTheDoanhThu()
        }
        cumChiSoChinh.khiDoiCheDoDoanhThu = { [weak self] cheDoMoi in
            guard let self = self else { return }
            self.cheDoDoanhThu = cheDoMoi
            self.napDuLieu()
        }

        // 2. Cụm 4 nút phía dưới cụm Doanh thu (Thi đua | Nhân viên | Dự phòng 2 | Dự phòng 3)
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
        nutThemAnhMoi.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
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

        // 4. Nội dung mục Thi đua, Nhân viên & 2 mục dự phòng
        bangThiDua.khiBamQuetAnh = { [weak self] in
            self?.bamThemAnhMoi()
        }
        bangThiDua.khiChonDong = { [weak self] dong in
            guard let self = self else { return }
            let vc = ManHinhChiTietNganhHang(dong: dong, ngay: self.ngayHienTai)
            vc.khiCapNhatDuLieu = { [weak self] in
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
            dl.danhSachThiDua.removeAll { $0.id == id }
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        }

        bangNhanVien.khiChonNhanVien = { [weak self] row in
            guard let self = self else { return }
            self.navigationController?.pushViewController(ManHinhChiTietNhanVien(row, ngay: self.ngayHienTai), animated: true)
        }
        bangNhanVien.khiBamQuetDoanhThuNV = { [weak self] in
            self?.moChonAnh(cheDo: .doanhThuNhanVien, gioiHan: 0)
        }
        bangNhanVien.khiBamMoCaiDatNV = { [weak self] in
            self?.moCaiDat()
        }

        bangRealtimeThang.khiBamSuaDoanhThuLuyKe = { [weak self] in
            guard let self = self else { return }
            self.cheDoDoanhThu = .luyKe
            self.napDuLieu()
            self.bamTheDoanhThu()
        }
        bangRealtimeThang.khiChonNgayRealtime = { [weak self] item in
            self?.moMenuRealtimeChoNgay(item)
        }

        taoGiaoDienKhungDuPhong()

        [cumChiSoChinh, hangBonNut, hangNutQuet, bangThiDua, bangNhanVien, bangRealtimeThang, khungDuPhong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cumChiSoChinh.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            cumChiSoChinh.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cumChiSoChinh.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cumChiSoChinh.heightAnchor.constraint(equalToConstant: 156),

            hangBonNut.topAnchor.constraint(equalTo: cumChiSoChinh.bottomAnchor, constant: 8),
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

            bangNhanVien.topAnchor.constraint(equalTo: hangNutQuet.bottomAnchor, constant: 8),
            bangNhanVien.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bangNhanVien.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bangNhanVien.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),

            bangRealtimeThang.topAnchor.constraint(equalTo: hangNutQuet.bottomAnchor, constant: 8),
            bangRealtimeThang.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bangRealtimeThang.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bangRealtimeThang.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4),

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
        let soDat = dl.danhSachThiDua.filter { $0.daDat }.count
        let dtDangChon = (cheDoDoanhThu == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        cumChiSoChinh.capNhat(
            doanhThu: dtDangChon,
            soNganhDat: soDat,
            tongSoNganh: dl.danhSachThiDua.count,
            ngay: ngayHienTai,
            cheDo: cheDoDoanhThu
        )
        bangThiDua.ganDanhSach(dl.danhSachThiDua)
        bangNhanVien.capNhat(cho: ngayHienTai)
        bangRealtimeThang.capNhat(cho: ngayHienTai)
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

        let laThiDua = (tabHienTai == .thiDua)
        let laNhanVien = (tabHienTai == .nhanVien)
        let laRTThang = (tabHienTai == .duPhong2)

        if laNhanVien {
            nutThemAnhMoi.setTitle(" Thêm ảnh DT hợp nhất NV", for: .normal)
        } else if laRTThang {
            nutThemAnhMoi.setTitle(" Quét 2 ảnh Realtime ngày", for: .normal)
        } else {
            nutThemAnhMoi.setTitle(" Thêm ảnh", for: .normal)
        }

        bangThiDua.isHidden = !laThiDua
        bangNhanVien.isHidden = !laNhanVien
        bangRealtimeThang.isHidden = !laRTThang
        khungDuPhong.isHidden = laThiDua || laNhanVien || laRTThang
        nutThemThuCong.isHidden = !(laThiDua || laNhanVien || laRTThang)
        nutThemThuCong.setTitle(" Nhập/Mẫu", for: .normal)

        if !laThiDua && !laNhanVien && !laRTThang {
            nhanTieuDeDuPhong.text = tabHienTai.tieuDe
        }
    }

    // MARK: - Nút Thêm ảnh mới (Quét) & Nút Xoá quét lại từ đầu

    @objc private func bamThemAnhMoi() {
        switch tabHienTai {
        case .thiDua:
            moHuongDanQuetAnhThiDua()
        case .nhanVien:
            moChonAnh(cheDo: .doanhThuNhanVien, gioiHan: 0)
        case .duPhong2:
            moHuongDanQuet2AnhDoanhThu(cheDo: .realtime)
        case .duPhong3:
            let tb = UIAlertController(
                title: tabHienTai.tieuDe,
                message: "Mục \(tabHienTai.tieuDe) hiện đang là nút dự phòng chưa gắn chức năng.",
                preferredStyle: .alert
            )
            tb.addAction(UIAlertAction(title: "Đã hiểu", style: .default))
            present(tb, animated: true)
        }
    }

    private func moHuongDanQuetAnhThiDua() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let thongDiep = "Hãy chọn 1 hoặc nhiều ảnh chụp màn hình các thẻ Thi đua (màn hình Doanh thu hợp nhất 2 cột thẻ):\n\n• Tự động đọc từng thẻ ở cả 2 cột trái & phải từ trên xuống\n• Trích xuất đủ: Tên ngành hàng, đơn vị tính (DT / SL), Thực hiện, Target, % HT tháng và % Dự kiến hoàn thành."

        let hd = UIAlertController(
            title: "Nhập ảnh Thi đua",
            message: thongDiep,
            preferredStyle: .alert
        )
        if dl.danhSachThiDua.isEmpty {
            hd.addAction(UIAlertAction(title: "📷 Chọn ảnh Thi đua ngay", style: .default) { [weak self] _ in
                self?.thayTheBangThiDuaKhiQuet = false
                self?.moChonAnh(cheDo: .thiDua, gioiHan: 0)
            })
        } else {
            hd.addAction(UIAlertAction(title: "➕ Quét thêm ảnh (Gộp nối tiếp các thẻ)", style: .default) { [weak self] _ in
                self?.thayTheBangThiDuaKhiQuet = false
                self?.moChonAnh(cheDo: .thiDua, gioiHan: 0)
            })
            hd.addAction(UIAlertAction(title: "🔄 Quét mới từ đầu (Thay thế bảng hiện tại)", style: .destructive) { [weak self] _ in
                self?.thayTheBangThiDuaKhiQuet = true
                self?.moChonAnh(cheDo: .thiDua, gioiHan: 0)
            })
        }
        hd.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hd, animated: true)
    }

    @objc private func bamXoaQuetLai() {
        if tabHienTai == .duPhong2 {
            let ngayStr = TienIchNgay.hienThiNgay.string(from: ngayHienTai)
            let hoiRT = UIAlertController(
                title: "Xoá dữ liệu Realtime / Lũy kế?",
                message: "Chọn phần dữ liệu doanh thu bạn muốn xoá:",
                preferredStyle: .actionSheet
            )
            hoiRT.addAction(UIAlertAction(title: "🗑️ Xoá Realtime của ngày \(ngayStr)", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                dl.doanhThuRealtime = ThongTinDoanhThu()
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            })
            hoiRT.addAction(UIAlertAction(title: "🗑️ Xoá Doanh thu Lũy kế cố định của tháng", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                KhoDuLieu.dungChung.xoaDoanhThuLuyKeThang(cho: self.ngayHienTai)
                self.napDuLieu()
            })
            hoiRT.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
            if let pop = hoiRT.popoverPresentationController {
                pop.sourceView = nutXoaQuetLai
                pop.sourceRect = nutXoaQuetLai.bounds
            }
            present(hoiRT, animated: true)
            return
        }

        if tabHienTai == .nhanVien {
            let hoiNV = UIAlertController(
                title: "Xoá bảng Doanh thu Nhân viên?",
                message: "Xoá bảng Doanh thu hợp nhất Nhân viên của ngày đang chọn?",
                preferredStyle: .alert
            )
            hoiNV.addAction(UIAlertAction(title: "Xoá", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                var moi = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                moi.doanhThuNhanVien = []
                KhoDuLieu.dungChung.luu(moi)
                self.napDuLieu()
            })
            hoiNV.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
            present(hoiNV, animated: true)
            return
        }

        guard tabHienTai == .thiDua else { return }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)

        if dl.danhSachThiDua.isEmpty {
            moHuongDanQuetAnhThiDua()
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
            self.moHuongDanQuetAnhThiDua()
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
        let menu = UIAlertController(title: "Dữ liệu & Chia Target", message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "⚙️ Quản lý Nhân viên & Chia Target mặt hàng", style: .default) { [weak self] _ in
            self?.moCaiDat()
        })
        menu.addAction(UIAlertAction(title: "➕ Thêm 1 ngành hàng thủ công", style: .default) { [weak self] _ in
            self?.bamThemDongThuCong()
        })
        menu.addAction(UIAlertAction(title: "✨ Nạp dữ liệu mẫu thử (Thi đua + NV)", style: .default) { [weak self] _ in
            self?.napDuLieuMau()
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.sourceView = nutThemThuCong
            pop.sourceRect = nutThemThuCong.bounds
        }
        present(menu, animated: true)
    }

    // MARK: - Tương tác cụm Doanh thu (Lũy kế & Realtime — bắt buộc chọn đủ 2 ảnh DT thực & DT quy đổi kèm hướng dẫn)

    @objc private func bamTheDoanhThu() {
        let tenCheDo = cheDoDoanhThu.tieuDe
        let menu = UIAlertController(
            title: "Doanh thu \(tenCheDo) — Thực & Quy đổi",
            message: "Đang xem mục: \(tenCheDo.uppercased()).\nKhi quét ảnh, vui lòng chọn cùng lúc đủ 2 ảnh chụp màn hình (1 ảnh DT thực + 1 ảnh DT quy đổi) của phần \(tenCheDo).",
            preferredStyle: .actionSheet
        )
        menu.addAction(UIAlertAction(title: "📷 Nhập 2 ảnh Doanh thu \(tenCheDo) (Thực + QĐ)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.moHuongDanQuet2AnhDoanhThu(cheDo: self.cheDoDoanhThu)
        })
        menu.addAction(UIAlertAction(title: "✏️ Nhập / Sửa tay Doanh thu \(tenCheDo)", style: .default) { [weak self] _ in
            self?.moHopThoaiNhapDoanhThu()
        })
        menu.addAction(UIAlertAction(title: "🗑️ Xoá số liệu Doanh thu \(tenCheDo)", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if self.cheDoDoanhThu == .luyKe {
                KhoDuLieu.dungChung.xoaDoanhThuLuyKeThang(cho: self.ngayHienTai)
            } else {
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                dl.doanhThuRealtime = ThongTinDoanhThu()
                KhoDuLieu.dungChung.luu(dl)
            }
            self.napDuLieu()
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))

        if let pop = menu.popoverPresentationController {
            pop.sourceView = cumChiSoChinh
            pop.sourceRect = cumChiSoChinh.bounds
        }
        present(menu, animated: true)
    }

    private func moHuongDanQuet2AnhDoanhThu(cheDo: LoaiCheDoDoanhThu) {
        let tenCheDo = cheDo.tieuDe
        let hd = UIAlertController(
            title: "Hướng dẫn nhập ảnh Doanh thu (\(tenCheDo))",
            message: "Bắt buộc chọn đủ 2 ảnh trong 1 lần:\n\n1️⃣ Ảnh 1: Chụp màn hình Doanh thu THỰC (\(tenCheDo))\n2️⃣ Ảnh 2: Chụp màn hình Doanh thu QUY ĐỔI (\(tenCheDo))\n\nHệ thống sẽ tự động phân tích và gộp đủ Doanh thu thực, Doanh thu quy đổi cùng toàn bộ chỉ số phụ.",
            preferredStyle: .alert
        )
        hd.addAction(UIAlertAction(title: "Chọn đủ 2 ảnh ngay", style: .default) { [weak self] _ in
            self?.moChonAnh(cheDo: .doanhThu(cheDo), gioiHan: 2)
        })
        hd.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hd, animated: true)
    }

    private func moHopThoaiNhapDoanhThu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dt = (cheDoDoanhThu == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        let tenCheDo = cheDoDoanhThu.tieuDe

        let hop = UIAlertController(
            title: "Số liệu Doanh thu (\(tenCheDo))",
            message: "Nhập Doanh thu thực, Target thực, Doanh thu QĐ và Target QĐ cho phần \(tenCheDo):",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Doanh thu thực (VD: 10957)"
            tf.keyboardType = .decimalPad
            if dt.doanhThuThuc > 0 { tf.text = String(dt.doanhThuThuc) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target thực (VD: 11128)"
            tf.keyboardType = .decimalPad
            if dt.targetThuc > 0 { tf.text = String(dt.targetThuc) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Doanh thu quy đổi (VD: 14922)"
            tf.keyboardType = .decimalPad
            if dt.doanhThuQuyDoi > 0 { tf.text = String(dt.doanhThuQuyDoi) }
        }
        hop.addTextField { tf in
            tf.placeholder = "Target quy đổi (VD: 14957)"
            tf.keyboardType = .decimalPad
            if dt.targetQuyDoi > 0 { tf.text = String(dt.targetQuyDoi) }
        }

        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self, let tfs = hop.textFields, tfs.count >= 4 else { return }
            var moi = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            let nhap = ThongTinDoanhThu(
                doanhThuThuc: self.docSoTuO(tfs[0].text),
                targetThuc: self.docSoTuO(tfs[1].text),
                doanhThuQuyDoi: self.docSoTuO(tfs[2].text),
                targetQuyDoi: self.docSoTuO(tfs[3].text)
            )
            if self.cheDoDoanhThu == .luyKe {
                moi.doanhThu = moi.doanhThu.gop(voi: nhap)
            } else {
                moi.doanhThuRealtime = moi.doanhThuRealtime.gop(voi: nhap)
            }
            KhoDuLieu.dungChung.luu(moi)
            self.napDuLieu()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func moMenuRealtimeChoNgay(_ item: DuLieuRealtimeNgayTrongThang) {
        let ngayStr = TienIchNgay.hienThiNgay.string(from: item.ngay)
        let menu = UIAlertController(
            title: "Realtime ngày \(ngayStr)",
            message: item.coDuLieu
                ? "DT Thực: \(item.doanhThuThuc.chuoiSoVN)  •  DT Quy đổi: \(item.doanhThuQuyDoi.chuoiSoVN)"
                : "Ngày \(ngayStr) chưa có số liệu Doanh thu Realtime.",
            preferredStyle: .actionSheet
        )
        menu.addAction(UIAlertAction(title: "📷 Quét 2 ảnh Realtime cho ngày \(ngayStr)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.ngayHienTai = item.ngay
            self.cheDoDoanhThu = .realtime
            self.napDuLieu()
            self.moHuongDanQuet2AnhDoanhThu(cheDo: .realtime)
        })
        menu.addAction(UIAlertAction(title: "✏️ Nhập / Sửa tay Realtime ngày \(ngayStr)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.ngayHienTai = item.ngay
            self.cheDoDoanhThu = .realtime
            self.napDuLieu()
            self.moHopThoaiNhapDoanhThu()
        })
        if item.coDuLieu {
            menu.addAction(UIAlertAction(title: "🗑️ Xoá Realtime ngày \(ngayStr)", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                var dl = KhoDuLieu.dungChung.duLieu(cho: item.ngay)
                dl.doanhThuRealtime = ThongTinDoanhThu()
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            })
        }
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.sourceView = bangRealtimeThang
            pop.sourceRect = CGRect(x: bangRealtimeThang.bounds.midX, y: 120, width: 1, height: 1)
        }
        present(menu, animated: true)
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
            case .doanhThu(let loaiDT):
                self.xuLyQuetDoanhThu(cacAnh, loai: loaiDT)
            case .thiDua:
                self.xuLyQuetThiDua(cacAnh)
            case .doanhThuNhanVien:
                self.xuLyQuetDoanhThuNhanVien(cacAnh)
            }
        }
    }

    private func xuLyQuetThiDua(_ cacAnh: [UIImage]) {
        let dlHienTai = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        let dsHienCo = thayTheBangThiDuaKhiQuet ? [] : dlHienTai.danhSachThiDua
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Thi đua...")
        DichVuDocAnh.dungChung.quetAnhThiDua(
            danhSachAnh: cacAnh,
            danhSachHienCo: dsHienCo,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] kq in
                guard let self = self else { return }
                self.anTienTrinh()
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                if !kq.danhSach.isEmpty {
                    if self.thayTheBangThiDuaKhiQuet {
                        dl.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: [], moi: kq.danhSach)
                    } else {
                        dl.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: dl.danhSachThiDua, moi: kq.danhSach)
                    }
                }
                self.thayTheBangThiDuaKhiQuet = false
                if !kq.thiDuaNhanVien.isEmpty {
                    dl.thiDuaNhanVien = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                        hienTai: dl.thiDuaNhanVien,
                        mangKhoiNV: kq.thiDuaNhanVien,
                        ngay: self.ngayHienTai
                    )
                }
                dl.capNhatLuc = kq.capNhatLuc
                if !kq.thongTinDonVi.isEmpty { dl.thongTinDonVi = kq.thongTinDonVi }
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            }
        )
    }

    private func xuLyQuetDoanhThuNhanVien(_ cacAnh: [UIImage]) {
        hienTienTrinh("Đang đọc \(cacAnh.count) ảnh Doanh thu Nhân viên...")
        DichVuDocAnh.dungChung.quetAnhDoanhThuNhanVien(
            danhSachAnh: cacAnh,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] dsQuet in
                guard let self = self else { return }
                self.anTienTrinh()
                guard !dsQuet.isEmpty else {
                    let tb = UIAlertController(
                        title: "Chưa đọc được dòng nhân viên",
                        message: "Hãy chụp rõ bảng Doanh thu hợp nhất theo Nhân viên rồi thử lại.",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                let dsQuanLy = KhoDuLieu.dungChung.caiDat.danhSachNhanVien
                var mapDTNV: [String: DoanhThuNhanVienItem] = [:]
                for item in dl.doanhThuNhanVien {
                    let ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                    if !ma.isEmpty { mapDTNV[ma] = item }
                }
                for item in dsQuet {
                    let nvKhop = KhoDuLieu.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: dsQuanLy)
                    let ma = nvKhop?.maNV ?? KhoDuLieu.chuanHoaMaNV(item.maNV)
                    let ten = nvKhop?.hoTen ?? item.hoTen
                    guard !ma.isEmpty else { continue }
                    var capNhat = item
                    capNhat.maNV = ma
                    capNhat.hoTen = ten
                    mapDTNV[ma] = capNhat
                }
                dl.doanhThuNhanVien = Array(mapDTNV.values)
                KhoDuLieu.dungChung.luu(dl)
                self.napDuLieu()
            }
        )
    }

    private func xuLyQuetDoanhThu(_ cacAnh: [UIImage], loai: LoaiCheDoDoanhThu) {
        let tenCheDo = loai.tieuDe
        guard cacAnh.count == 2 else {
            let tb = UIAlertController(
                title: "Cần chọn đủ 2 ảnh Doanh thu (\(tenCheDo))",
                message: "Bạn vừa chọn \(cacAnh.count) ảnh. Bắt buộc chọn đủ 2 ảnh trong 1 lần:\n• 1 ảnh chứa Doanh thu THỰC\n• 1 ảnh chứa Doanh thu QUY ĐỔI",
                preferredStyle: .alert
            )
            tb.addAction(UIAlertAction(title: "Chọn lại 2 ảnh", style: .default) { [weak self] _ in
                self?.moChonAnh(cheDo: .doanhThu(loai), gioiHan: 2)
            })
            tb.addAction(UIAlertAction(title: "Đóng", style: .cancel))
            present(tb, animated: true)
            return
        }

        hienTienTrinh("Đang đọc 2 ảnh Doanh thu (\(tenCheDo))...")
        DichVuDocAnh.dungChung.quetAnhDoanhThu(
            danhSachAnh: cacAnh,
            tienTrinh: { [weak self] tt in
                self?.nhanTienTrinh.text = tt
            },
            hoanTat: { [weak self] dtMoi in
                guard let self = self else { return }
                self.anTienTrinh()

                if dtMoi.doanhThuThuc <= 0 || dtMoi.doanhThuQuyDoi <= 0 {
                    let thieu = (dtMoi.doanhThuThuc <= 0 && dtMoi.doanhThuQuyDoi <= 0)
                        ? "cả Doanh thu thực và Doanh thu quy đổi"
                        : (dtMoi.doanhThuThuc <= 0 ? "ảnh Doanh thu THỰC" : "ảnh Doanh thu QUY ĐỔI")
                    let tb = UIAlertController(
                        title: "Chưa đủ cả 2 loại ảnh Doanh thu",
                        message: "Hệ thống phát hiện thiếu \(thieu). Vui lòng chọn đúng 1 ảnh Doanh thu thực và 1 ảnh Doanh thu quy đổi của phần \(tenCheDo).",
                        preferredStyle: .alert
                    )
                    tb.addAction(UIAlertAction(title: "Chọn lại 2 ảnh", style: .default) { [weak self] _ in
                        self?.moChonAnh(cheDo: .doanhThu(loai), gioiHan: 2)
                    })
                    tb.addAction(UIAlertAction(title: "Vẫn lưu kết quả vừa đọc", style: .default) { [weak self] _ in
                        guard let self = self else { return }
                        var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                        if loai == .luyKe {
                            dl.doanhThu = dl.doanhThu.gop(voi: dtMoi)
                        } else {
                            dl.doanhThuRealtime = dl.doanhThuRealtime.gop(voi: dtMoi)
                        }
                        KhoDuLieu.dungChung.luu(dl)
                        self.napDuLieu()
                    })
                    tb.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
                    self.present(tb, animated: true)
                    return
                }

                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
                if loai == .luyKe {
                    dl.doanhThu = dl.doanhThu.gop(voi: dtMoi)
                } else {
                    dl.doanhThuRealtime = dl.doanhThuRealtime.gop(voi: dtMoi)
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
        dl.doanhThuRealtime = ThongTinDoanhThu(
            doanhThuThuc: 385.50,
            targetThuc: 420.00,
            duKienThuc: 410.00,
            phanTramHTThuc: 91.8,
            doanhThuQuyDoi: 542.80,
            targetQuyDoi: 560.00,
            duKienQuyDoi: 575.00,
            phanTramHTQuyDoi: 96.9,
            phanTramTraGop: 44.2,
            doanhThuTraGop: 239.90,
            luotKhach: 645,
            soBill: 78,
            phanTramPVTC: 12.1,
            tangGiamCungKy: 8.4,
            coTangGiam: true,
            tb3Thang: 355.6,
            soNgayDaQua: 29,
            tongSoNgay: 31,
            phanTramTienDoThang: 94.0
        )
        dl.doanhThu = ThongTinDoanhThu(
            doanhThuThuc: 10957.00,
            targetThuc: 11128.00,
            duKienThuc: 11698.00,
            phanTramHTThuc: 98.5,
            doanhThuQuyDoi: 14922.00,
            targetQuyDoi: 14957.00,
            duKienQuyDoi: 15936.00,
            phanTramHTQuyDoi: 99.8,
            phanTramTraGop: 42.7,
            doanhThuTraGop: 6379.00,
            luotKhach: 19149,
            soBill: 2238,
            phanTramPVTC: 11.7,
            tangGiamCungKy: -5.6,
            coTangGiam: true,
            tb3Thang: 11609,
            soNgayDaQua: 29,
            tongSoNgay: 31,
            phanTramTienDoThang: 94.0
        )
        let mau: [DongThiDua] = [
            DongThiDua(tenNganhHang: "T09 - T10 IPHONE 18 series, iPhone Duo", loaiChiTieu: .doanhThu, thucHien: 4476.28, target: 3493.60),
            DongThiDua(tenNganhHang: "T10 - NẠP - RÚT TIỀN TÀI KHOẢN NGÂN HÀNG", loaiChiTieu: .soLuong, thucHien: 407, target: 363),
            DongThiDua(tenNganhHang: "T10 - SIM TỔNG", loaiChiTieu: .soLuong, thucHien: 52.00, target: 55.12),
            DongThiDua(tenNganhHang: "T10 - Bảo Hiểm Tổng", loaiChiTieu: .doanhThu, thucHien: 306.69, target: 283.58),
            DongThiDua(tenNganhHang: "T10 - BẢO HIỂM THỢ ĐMX_CE", loaiChiTieu: .doanhThu, thucHien: 551.87, target: 745.76),
            DongThiDua(tenNganhHang: "T10 - BẢO HIỂM THỢ ĐMX_ICT", loaiChiTieu: .doanhThu, thucHien: 103.82, target: 73.99),
            DongThiDua(tenNganhHang: "T10 - GIA DỤNG SUNHOUSE", loaiChiTieu: .doanhThu, thucHien: 647.39, target: 703.00),
            DongThiDua(tenNganhHang: "T10 - ĐIỆN TỬ TCL", loaiChiTieu: .doanhThu, thucHien: 205.22, target: 240.37),
            DongThiDua(tenNganhHang: "T10 - PANASONIC", loaiChiTieu: .doanhThu, thucHien: 599.03, target: 614.15),
            DongThiDua(tenNganhHang: "T10 - TIVI", loaiChiTieu: .doanhThu, thucHien: 800.25, target: 1079.00),
            DongThiDua(tenNganhHang: "T10 - HÚT BỤI", loaiChiTieu: .doanhThu, thucHien: 158.97, target: 288.00),
            DongThiDua(tenNganhHang: "T10 - AUDIO", loaiChiTieu: .doanhThu, thucHien: 19.00, target: 63.00),
            DongThiDua(tenNganhHang: "T10 - Máy Lạnh", loaiChiTieu: .soLuong, thucHien: 39.00, target: 147.00)
        ]
        dl.danhSachThiDua = KhoDuLieu.gopDanhSachThiDua(cu: dl.danhSachThiDua, moi: mau)
        dl.doanhThuNhanVien = [
            DoanhThuNhanVienItem(maNV: "24939", hoTen: "Phan Hoàng Sơn", soLuong: 220, doanhThuThuc: 717, doanhThuQD: 1412, target: 1361.09, dtQDKhoanVay: 0, dtTraThangQD: 924, dtTraGop: 296, phanTramHT: 70.75, phanTramQuyDoi: 34.31, phanTramTraGop: 41.28, gioCong: 170, soNgayNghi: 1, nangSuat: 4.22),
            DoanhThuNhanVienItem(maNV: "65255", hoTen: "Nguyễn Thị Thu Thảo", soLuong: 229, doanhThuThuc: 632, doanhThuQD: 1278, target: 1361.09, dtQDKhoanVay: 0, dtTraThangQD: 847, dtTraGop: 213, phanTramHT: 60.17, phanTramQuyDoi: 29.59, phanTramTraGop: 33.7, gioCong: 168, soNgayNghi: 1, nangSuat: 3.74),
            DoanhThuNhanVienItem(maNV: "261423", hoTen: "Trần Nam Tùng", soLuong: 162, doanhThuThuc: 689, doanhThuQD: 1206, target: 1361.09, dtQDKhoanVay: 0, dtTraThangQD: 716, dtTraGop: 217, phanTramHT: 64.14, phanTramQuyDoi: 26.71, phanTramTraGop: 31.49, gioCong: 188, soNgayNghi: 0, nangSuat: 3.65),
            DoanhThuNhanVienItem(maNV: "201962", hoTen: "Nguyễn Thị Kim Loan", soLuong: 169, doanhThuThuc: 722, doanhThuQD: 1190, target: 1166.65, dtQDKhoanVay: 0, dtTraThangQD: 493, dtTraGop: 470, phanTramHT: 81.94, phanTramQuyDoi: 32.41, phanTramTraGop: 65.1, gioCong: 188, soNgayNghi: 0, nangSuat: 3.83),
            DoanhThuNhanVienItem(maNV: "116719", hoTen: "Đinh Thị Quỳnh Nga", soLuong: 209, doanhThuThuc: 573, doanhThuQD: 1171, target: 1361.09, dtQDKhoanVay: 2, dtTraThangQD: 716, dtTraGop: 205, phanTramHT: 55.25, phanTramQuyDoi: 31.24, phanTramTraGop: 35.78, gioCong: 184, soNgayNghi: 1, nangSuat: 3.11),
            DoanhThuNhanVienItem(maNV: "23986", hoTen: "Nguyễn Ngọc Đẩu", soLuong: 203, doanhThuThuc: 650, doanhThuQD: 1164, target: 1361.09, dtQDKhoanVay: 2, dtTraThangQD: 761, dtTraGop: 259, phanTramHT: 63.99, phanTramQuyDoi: 34.0, phanTramTraGop: 39.85, gioCong: 170, soNgayNghi: 2, nangSuat: 3.82)
        ]
        dl.capNhatLuc = "23:45:21"
        dl.thongTinDonVi = "ĐML_QNG_QNG - 275 Quang Trung"
        KhoDuLieu.dungChung.luu(dl)
        napDuLieu()
    }

    // MARK: - Lịch sử ngày & Xuất báo cáo

    @objc private func moLichSuNgay() {
        let sheet = UIAlertController(title: "Chọn ngày báo cáo", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Hôm nay (\(TienIchNgay.hienThiNgay.string(from: Date())))", style: .default) { [weak self] _ in
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
        let kieu = KhoDuLieu.dungChung.caiDat.kieuHienThi
        let moTaKieu = (kieu == .bangChiTiet) ? "Bảng 8 cột" : "Thẻ \(KhoDuLieu.dungChung.caiDat.soCotXuatAnh) cột"

        let menu = UIAlertController(
            title: "Chia sẻ ảnh & Xuất báo cáo",
            message: "Chọn loại ảnh báo cáo bạn muốn chia sẻ hoặc lưu về máy:",
            preferredStyle: .actionSheet
        )

        // 1. Chia sẻ ảnh Thi đua theo Lũy kế
        menu.addAction(UIAlertAction(title: "📊 Ảnh Thi đua — Doanh thu Lũy kế (\(moTaKieu))", style: .default) { [weak self] _ in
            guard let self = self,
                  let anh = self.bangThiDua.taoAnhBaoCao(
                      ngay: self.ngayHienTai,
                      doanhThu: dl.doanhThu,
                      cheDoDoanhThu: .luyKe,
                      thongTinDonVi: dl.thongTinDonVi,
                      capNhatLuc: dl.capNhatLuc
                  ) else { return }
            self.chiaSe([anh])
        })

        // 2. Chia sẻ ảnh Thi đua theo Realtime
        menu.addAction(UIAlertAction(title: "⚡ Ảnh Thi đua — Doanh thu Realtime (\(moTaKieu))", style: .default) { [weak self] _ in
            guard let self = self,
                  let anh = self.bangThiDua.taoAnhBaoCao(
                      ngay: self.ngayHienTai,
                      doanhThu: dl.doanhThuRealtime,
                      cheDoDoanhThu: .realtime,
                      thongTinDonVi: dl.thongTinDonVi,
                      capNhatLuc: dl.capNhatLuc
                  ) else { return }
            self.chiaSe([anh])
        })

        // 3. Chia sẻ ảnh Bảng Xếp Hạng Nhân Viên
        menu.addAction(UIAlertAction(title: "👥 Ảnh Bảng Xếp Hạng Nhân Viên", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.bangNhanVien.capNhat(cho: self.ngayHienTai)
            guard let anh = self.bangNhanVien.taoAnhBaoCaoNhanVien(
                ngay: self.ngayHienTai,
                thongTinDonVi: dl.thongTinDonVi,
                capNhatLuc: dl.capNhatLuc
            ) else { return }
            self.chiaSe([anh])
        })

        // 4. Chia sẻ ảnh Sức Khoẻ Nhân Viên (Tuỳ chọn 1 hoặc Tất cả nhân viên đang quản lý)
        menu.addAction(UIAlertAction(title: "👤 Ảnh Sức Khoẻ Nhân Viên (1 hoặc Tất cả)...", style: .default) { [weak self] _ in
            self?.moChonNhanVienChiaSeAnh()
        })

        // 5. Chia sẻ ảnh Bảng Tổng Hợp & Đồ Thị Cột Realtime Tháng
        menu.addAction(UIAlertAction(title: "📈 Ảnh Bảng Tổng Hợp & Đồ Thị Realtime Tháng", style: .default) { [weak self] _ in
            guard let self = self,
                  let anh = self.bangRealtimeThang.taoAnhBaoCaoRealtimeThang(
                      ngay: self.ngayHienTai,
                      thongTinDonVi: dl.thongTinDonVi,
                      capNhatLuc: dl.capNhatLuc
                  ) else { return }
            self.chiaSe([anh])
        })

        // 5. Xuất file Excel (.csv)
        let dtDangChon = (cheDoDoanhThu == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        menu.addAction(UIAlertAction(title: "📄 Xuất file Excel (.csv) (\(cheDoDoanhThu.tieuDe))", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let csv = self.bangThiDua.taoChuoiExcelCSV(doanhThu: dtDangChon)
            let tenTep = "TongHopDMX-\(dl.khoaNgay).csv"
            let duongDan = FileManager.default.temporaryDirectory.appendingPathComponent(tenTep)
            try? csv.write(to: duongDan, atomically: true, encoding: .utf8)
            self.chiaSe([duongDan])
        })

        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?[1]
        }
        present(menu, animated: true)
    }

    private func moChonNhanVienChiaSeAnh() {
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngayHienTai, sapXep: .soMonHoanThanh)
        guard !dsNV.isEmpty else { return }
        let chon = UIAlertController(
            title: "Xuất ảnh Sức khoẻ Nhân viên",
            message: "Chọn xuất tất cả \(dsNV.count) nhân viên đang quản lý hoặc chọn 1 nhân viên cụ thể:",
            preferredStyle: .actionSheet
        )

        // Tuỳ chọn xuất TẤT CẢ nhân viên đang quản lý
        chon.addAction(UIAlertAction(title: "📚 Xuất TẤT CẢ \(dsNV.count) NV đang quản lý (Bộ \(dsNV.count) ảnh rời)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let cacAnh = ManHinhChiTietNhanVien.taoTatCaAnhSucKhoe(cho: self.ngayHienTai)
            guard !cacAnh.isEmpty else { return }
            self.chiaSe(cacAnh)
        })

        chon.addAction(UIAlertAction(title: "🖼️ Xuất TẤT CẢ \(dsNV.count) NV đang quản lý (Gộp 1 ảnh tổng hợp)", style: .default) { [weak self] _ in
            guard let self = self,
                  let anhGop = ManHinhChiTietNhanVien.taoAnhGopTatCaSucKhoe(cho: self.ngayHienTai) else { return }
            self.chiaSe([anhGop])
        })

        // Tuỳ chọn xuất 1 nhân viên cụ thể
        for (i, item) in dsNV.enumerated() {
            let tieuDe = "👤 \(i + 1). \(item.nhanVien.hoTen) (\(item.soMonDat)/\(item.tongMonGiao) môn • \(String(format: "%.1f%%", item.phanTramHTTB)))"
            chon.addAction(UIAlertAction(title: tieuDe, style: .default) { [weak self] _ in
                guard let self = self,
                      let anh = ManHinhChiTietNhanVien.taoAnhSucKhoe(cho: item, ngay: self.ngayHienTai) else { return }
                self.chiaSe([anh])
            })
        }
        chon.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = chon.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?[1]
        }
        present(chon, animated: true)
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
