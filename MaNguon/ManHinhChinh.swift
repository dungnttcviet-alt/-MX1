import UIKit
import PhotosUI

final class ManHinhChinh: UIViewController, PHPickerViewControllerDelegate {
    private enum CheDoQuetAnh {
        case thiDua
        case doanhThu
    }

    private var ngayHienTai = TienIchNgay.lich.startOfDay(for: Date())
    private var cheDoQuet: CheDoQuetAnh = .thiDua

    private let nutNgay = UIButton(type: .system)

    // 2 thẻ Chỉ số chính (Doanh thu thực & Doanh thu QĐ giống ảnh 2)
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

    // Danh sách thẻ Thi đua (giống ảnh 1)
    private let bangThiDua = BangThiDuaView()

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

    // MARK: - Thanh điều hướng gọn nhẹ

    private func cauHinhThanhDieuHuong() {
        nutNgay.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        nutNgay.addTarget(self, action: #selector(moLichSuNgay), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: nutNgay)

        let nutQuet = UIBarButtonItem(
            image: UIImage(systemName: "camera.viewfinder"),
            style: .plain,
            target: self,
            action: #selector(moMenuQuetAnh)
        )

        let nutXuat = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(moMenuXuatBaoCao)
        )

        let nutThemMenu = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: taoMenuTienIch()
        )

        navigationItem.rightBarButtonItems = [nutThemMenu, nutXuat, nutQuet]
    }

    private func taoMenuTienIch() -> UIMenu {
        let quetThiDua = UIAction(title: "Quét ảnh Thi đua (nhiều ảnh)", image: UIImage(systemName: "doc.viewfinder")) { [weak self] _ in
            self?.moChonAnh(cheDo: .thiDua, gioiHan: 0)
        }
        let quetDoanhThu = UIAction(title: "Quét ảnh Doanh thu (1 ảnh)", image: UIImage(systemName: "photo.badge.plus")) { [weak self] _ in
            self?.moChonAnh(cheDo: .doanhThu, gioiHan: 1)
        }
        let nhapDoanhThu = UIAction(title: "Nhập / Sửa số Doanh thu", image: UIImage(systemName: "pencil.line")) { [weak self] _ in
            self?.moHopThoaiNhapDoanhThu()
        }
        let themDong = UIAction(title: "Thêm ngành hàng Thi đua", image: UIImage(systemName: "plus.circle")) { [weak self] _ in
            self?.bamThemDongThuCong()
        }
        let napMau = UIAction(title: "Nạp dữ liệu mẫu (như ảnh)", image: UIImage(systemName: "sparkles")) { [weak self] _ in
            self?.napDuLieuMau()
        }
        let xoaTatCa = UIAction(title: "Xoá dữ liệu ngày này", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.xacNhanXoaDuLieuNgay()
        }
        return UIMenu(title: "Tác vụ nhanh", children: [quetThiDua, quetDoanhThu, nhapDoanhThu, themDong, napMau, xoaTatCa])
    }

    // MARK: - Giao diện chính gọn trên 1 màn hình

    private func taoGiaoDien() {
        theDTThuc.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)
        theDTQD.addTarget(self, action: #selector(bamTheDoanhThu), for: .touchUpInside)

        let hangDoanhThu = UIStackView(arrangedSubviews: [theDTThuc, theDTQD])
        hangDoanhThu.axis = .horizontal
        hangDoanhThu.spacing = 10
        hangDoanhThu.distribution = .fillEqually

        bangThiDua.khiBamQuetAnh = { [weak self] in
            self?.moChonAnh(cheDo: .thiDua, gioiHan: 0)
        }
        bangThiDua.khiChonDong = { [weak self] dong in
            self?.moHopThoaiSuaDong(dong)
        }

        [hangDoanhThu, bangThiDua].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            hangDoanhThu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            hangDoanhThu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hangDoanhThu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hangDoanhThu.heightAnchor.constraint(equalToConstant: 88),

            bangThiDua.topAnchor.constraint(equalTo: hangDoanhThu.bottomAnchor, constant: 10),
            bangThiDua.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bangThiDua.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bangThiDua.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])

        taoLopPhuTienTrinh()
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

    // MARK: - Nạp dữ liệu

    private func napDuLieu() {
        nutNgay.setTitle("📅 \(TienIchNgay.hienThiNgay.string(from: ngayHienTai)) ▾", for: .normal)
        nutNgay.sizeToFit()

        let dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        theDTThuc.capNhat(doanhThu: dl.doanhThu.doanhThuThuc, target: dl.doanhThu.targetThuc)
        theDTQD.capNhat(doanhThu: dl.doanhThu.doanhThuQuyDoi, target: dl.doanhThu.targetQuyDoi)
        bangThiDua.ganDanhSach(dl.danhSachThiDua)
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

    @objc private func moMenuQuetAnh() {
        let menu = UIAlertController(title: "Quét ảnh chụp màn hình", message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "🏆 Quét ảnh Thi đua (chọn nhiều ảnh)", style: .default) { [weak self] _ in
            self?.moChonAnh(cheDo: .thiDua, gioiHan: 0)
        })
        menu.addAction(UIAlertAction(title: "💵 Quét ảnh Doanh thu (1 ảnh)", style: .default) { [weak self] _ in
            self?.moChonAnh(cheDo: .doanhThu, gioiHan: 1)
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(menu, animated: true)
    }

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
            case .thiDua:
                self.xuLyQuetThiDua(cacAnh)
            case .doanhThu:
                if let anh = cacAnh.first {
                    self.xuLyQuetDoanhThu(anh)
                }
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
            tf.placeholder = "ĐVT: DTLK hoặc SLLK"
            tf.text = dong.loaiChiTieu.maNgan
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
            let ten = KhoDuLieu.lamSachTenNganhHang(tfs[0].text ?? "")
            guard !ten.isEmpty else { return }
            let dvt = (tfs[1].text ?? "DTLK").uppercased()
            let loai: LoaiChiTieuThiDua = dvt.contains("SL") ? .soLuong : .doanhThu
            let th = self.docSoTuO(tfs[2].text)
            let tg = self.docSoTuO(tfs[3].text)

            var capNhat = dong
            capNhat.tenNganhHang = ten
            capNhat.loaiChiTieu = loai
            capNhat.thucHien = th
            capNhat.target = tg

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

    private func xacNhanXoaDuLieuNgay() {
        let hoi = UIAlertController(
            title: "Xoá dữ liệu ngày này?",
            message: "Toàn bộ số liệu Doanh thu và Thi đua của ngày đang chọn sẽ bị xoá.",
            preferredStyle: .alert
        )
        hoi.addAction(UIAlertAction(title: "Xoá", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngayHienTai)
            dl.doanhThu = ThongTinDoanhThu()
            dl.danhSachThiDua = []
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
        })
        hoi.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hoi, animated: true)
    }

    // MARK: - Nạp dữ liệu mẫu giống hệt ảnh đính kèm để xem thử ngay

    private func napDuLieuMau() {
        var dl = KhoDuLieu.dungChung.duLieu(cho: ngayHienTai)
        dl.doanhThu = ThongTinDoanhThu(
            doanhThuThuc: 8541.00,
            targetThuc: 14466.40,
            doanhThuQuyDoi: 11438.00,
            targetQuyDoi: 19444.10
        )
        let mau: [DongThiDua] = [
            DongThiDua(tenNganhHang: "T10 - IPHONE 18 series, iPhone Duo", loaiChiTieu: .doanhThu, thucHien: 4476.28, target: 3493.60),
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

        let menu = UIAlertController(title: "Xuất báo cáo tổng hợp", message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "🖼️ Xuất Ảnh báo cáo (Lưới 3 cột + Doanh thu)", style: .default) { [weak self] _ in
            guard let self = self,
                  let anh = self.bangThiDua.taoAnhBaoCao(ngay: self.ngayHienTai, doanhThu: dl.doanhThu) else { return }
            self.chiaSe([anh])
        })
        menu.addAction(UIAlertAction(title: "📋 Sao chép văn bản báo cáo", style: .default) { [weak self] _ in
            guard let self = self else { return }
            UIPasteboard.general.string = self.bangThiDua.taoVanBanBaoCao(ngay: self.ngayHienTai, doanhThu: dl.doanhThu)
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?[1]
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
