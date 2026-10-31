import UIKit
import PhotosUI

// MARK: - 1. Màn hình Chi tiết Ngành hàng -> Xếp hạng nhân viên, Nhập ảnh thực hiện NV, Chia Target & Xuất ảnh
// (Tương đương ModalChiTietNganhHang trong dmx-modals.tsx)

final class ManHinhChiTietNganhHang: UIViewController, UITableViewDataSource, UITableViewDelegate, PHPickerViewControllerDelegate {
    private var dong: DongThiDua
    private let ngay: Date
    private var danhSachXepHang: [DongXepHangNhanVienNganh] = []

    var khiCapNhatDuLieu: (() -> Void)?
    var khiYeuCauSuaDong: ((DongThiDua) -> Void)?

    private let nhanPhuDe = UILabel()
    private let nhanThongTinTarget = UILabel()
    private let bang = UITableView(frame: .zero, style: .plain)
    private let khungTongCong = UIView()
    private let nhanTongCongTrai = UILabel()
    private let nhanTongCongPhai = UILabel()
    private let khungTrong = UIView()
    private let lopPhuTai = UIView()
    private let nhanTienTrinh = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .large)

    init(dong: DongThiDua, ngay: Date) {
        self.dong = dong
        self.ngay = ngay
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = dong.tenNganhHang
        view.backgroundColor = .systemGroupedBackground

        let nutSua = UIBarButtonItem(
            image: UIImage(systemName: "pencil.circle"),
            style: .plain,
            target: self,
            action: #selector(bamSuaNganhHang)
        )
        let nutXuatAnh = UIBarButtonItem(
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            style: .plain,
            target: self,
            action: #selector(bamXuatAnhBangNganhHang)
        )
        navigationItem.rightBarButtonItems = [nutXuatAnh, nutSua]

        taoGiaoDien()
        napDuLieu()
        NotificationCenter.default.addObserver(self, selector: #selector(napDuLieu), name: .duLieuDMXDaDongBo, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        napDuLieu()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func taoGiaoDien() {
        let khungDau = UIView()
        khungDau.backgroundColor = .secondarySystemGroupedBackground
        khungDau.layer.cornerRadius = 12

        nhanPhuDe.font = .systemFont(ofSize: 12, weight: .semibold)
        nhanPhuDe.textColor = .secondaryLabel

        nhanThongTinTarget.font = .systemFont(ofSize: 13.5, weight: .bold)
        nhanThongTinTarget.textColor = .label
        nhanThongTinTarget.numberOfLines = 2

        let nutQuetAnhNV = UIButton(type: .system)
        nutQuetAnhNV.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        nutQuetAnhNV.setTitle(" Nhập ảnh thực hiện NV", for: .normal)
        nutQuetAnhNV.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutQuetAnhNV.backgroundColor = .systemBlue
        nutQuetAnhNV.tintColor = .white
        nutQuetAnhNV.layer.cornerRadius = 9
        nutQuetAnhNV.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutQuetAnhNV.addTarget(self, action: #selector(bamQuetAnhNV), for: .touchUpInside)

        let nutChiaTarget = UIButton(type: .system)
        nutChiaTarget.setImage(UIImage(systemName: "person.2.badge.gearshape"), for: .normal)
        nutChiaTarget.setTitle(" Chia Target", for: .normal)
        nutChiaTarget.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutChiaTarget.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        nutChiaTarget.tintColor = .systemBlue
        nutChiaTarget.layer.cornerRadius = 9
        nutChiaTarget.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutChiaTarget.addTarget(self, action: #selector(bamMoChiaTarget), for: .touchUpInside)

        let hangNut = UIStackView(arrangedSubviews: [nutQuetAnhNV, nutChiaTarget])
        hangNut.axis = .horizontal
        hangNut.spacing = 8
        hangNut.distribution = .fillProportionally

        let nganDau = UIStackView(arrangedSubviews: [nhanPhuDe, nhanThongTinTarget, hangNut])
        nganDau.axis = .vertical
        nganDau.spacing = 6
        nganDau.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(nganDau)

        // Bảng xếp hạng nhân viên
        bang.dataSource = self
        bang.delegate = self
        bang.rowHeight = 52
        bang.separatorStyle = .none
        bang.backgroundColor = .secondarySystemGroupedBackground
        bang.layer.cornerRadius = 12
        bang.clipsToBounds = true
        if #available(iOS 15.0, *) {
            bang.sectionHeaderTopPadding = 0
        }

        // Khung tổng cộng chân bảng
        khungTongCong.backgroundColor = .secondarySystemGroupedBackground
        khungTongCong.layer.cornerRadius = 10
        nhanTongCongTrai.font = .systemFont(ofSize: 13, weight: .bold)
        nhanTongCongTrai.textColor = .label
        nhanTongCongPhai.font = .systemFont(ofSize: 13, weight: .heavy)
        nhanTongCongPhai.textColor = .systemBlue
        nhanTongCongPhai.textAlignment = .right

        [nhanTongCongTrai, nhanTongCongPhai].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungTongCong.addSubview($0)
        }

        // Khung trống khi chưa chọn NV
        khungTrong.backgroundColor = .secondarySystemGroupedBackground
        khungTrong.layer.cornerRadius = 12
        let nhanTrong = UILabel()
        nhanTrong.text = "Chưa chọn nhân viên nhận Target cho mặt hàng này.\nHãy bấm \"Chia Target\" để tích chọn các nhân viên phụ trách hoặc \"Nhập ảnh thực hiện NV\"."
        nhanTrong.font = .systemFont(ofSize: 13.5)
        nhanTrong.textColor = .secondaryLabel
        nhanTrong.textAlignment = .center
        nhanTrong.numberOfLines = 0
        nhanTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nhanTrong)

        [khungDau, bang, khungTrong, khungTongCong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungDau.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            khungDau.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            khungDau.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            nganDau.topAnchor.constraint(equalTo: khungDau.topAnchor, constant: 10),
            nganDau.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor, constant: 12),
            nganDau.trailingAnchor.constraint(equalTo: khungDau.trailingAnchor, constant: -12),
            nganDau.bottomAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: -10),

            khungTongCong.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            khungTongCong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            khungTongCong.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            khungTongCong.heightAnchor.constraint(equalToConstant: 42),

            nhanTongCongTrai.leadingAnchor.constraint(equalTo: khungTongCong.leadingAnchor, constant: 12),
            nhanTongCongTrai.centerYAnchor.constraint(equalTo: khungTongCong.centerYAnchor),
            nhanTongCongPhai.trailingAnchor.constraint(equalTo: khungTongCong.trailingAnchor, constant: -12),
            nhanTongCongPhai.centerYAnchor.constraint(equalTo: khungTongCong.centerYAnchor),

            bang.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 8),
            bang.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bang.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bang.bottomAnchor.constraint(equalTo: khungTongCong.topAnchor, constant: -8),

            khungTrong.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 8),
            khungTrong.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            khungTrong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            khungTrong.bottomAnchor.constraint(equalTo: khungTongCong.topAnchor, constant: -8),

            nhanTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nhanTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nhanTrong.leadingAnchor.constraint(equalTo: khungTrong.leadingAnchor, constant: 20),
            nhanTrong.trailingAnchor.constraint(equalTo: khungTrong.trailingAnchor, constant: -20)
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

    @objc private func napDuLieu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        if let capNhatDong = dl.danhSachThiDua.first(where: {
            $0.id == dong.id || KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) == KhoDuLieu.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        }) {
            dong = capNhatDong
            title = dong.tenNganhHang
        }

        danhSachXepHang = KhoDuLieu.dungChung.danhSachXepHangNhanVien(cho: dong, den: ngay)
        let soNV = danhSachXepHang.count
        let targetMoiNV = soNV > 0 ? dong.target / Double(soNV) : 0
        let donVi = dl.thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : dl.thongTinDonVi

        nhanPhuDe.text = "\(donVi) • Ngày \(TienIchNgay.hienThiNgay.string(from: ngay))"
        nhanThongTinTarget.text = "Target ST: \(dong.target.chuoiSoGonVN) (\(dong.loaiChiTieu.maBang))  •  Chia đều \(soNV) NV: \(soNV > 0 ? targetMoiNV.chuoiSoGonVN : "--")/NV"

        let tongTH = danhSachXepHang.reduce(0.0) { $0 + $1.thucHien }
        let tyLeChung = dong.target > 0 ? Int(round(tongTH / dong.target * 100.0)) : 0
        nhanTongCongTrai.text = "TỔNG: \(tongTH.chuoiSoGonVN) / \(dong.target.chuoiSoGonVN) • \(soNV) NV"
        nhanTongCongPhai.text = "Tỷ lệ HT: \(tyLeChung)%"

        khungTrong.isHidden = !danhSachXepHang.isEmpty
        bang.isHidden = danhSachXepHang.isEmpty
        bang.reloadData()
    }

    @objc private func bamQuetAnhNV() {
        var cauHinh = PHPickerConfiguration()
        cauHinh.filter = .images
        cauHinh.selectionLimit = 0
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

            self.nhanTienTrinh.text = "Đang đọc \(cacAnh.count) ảnh Thực hiện NV..."
            self.lopPhuTai.isHidden = false
            self.vongQuay.startAnimating()

            let khoaMacDinh = KhoDuLieu.chuanHoaKhoaSoSanh(self.dong.tenNganhHang)
            DichVuDocAnh.dungChung.quetAnhThiDuaNhanVien(
                danhSachAnh: cacAnh,
                tenNganhGoiY: self.dong.tenNganhHang,
                tienTrinh: { [weak self] tt in
                    self?.nhanTienTrinh.text = tt
                },
                hoanTat: { [weak self] cacKhoi in
                    guard let self = self else { return }
                    self.vongQuay.stopAnimating()
                    self.lopPhuTai.isHidden = true

                    if cacKhoi.isEmpty {
                        let tb = UIAlertController(
                            title: "Chưa đọc được dòng nhân viên",
                            message: "Hãy chụp rõ cột mã - tên nhân viên và cột số thực hiện rồi thử lại.",
                            preferredStyle: .alert
                        )
                        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                        self.present(tb, animated: true)
                        return
                    }

                    var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
                    dl.thiDuaNhanVien = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                        hienTai: dl.thiDuaNhanVien,
                        mangKhoiNV: cacKhoi,
                        ngay: self.ngay,
                        khoaNganhMacDinh: khoaMacDinh
                    )
                    KhoDuLieu.dungChung.luu(dl)
                    self.napDuLieu()
                    self.khiCapNhatDuLieu?()
                }
            )
        }
    }

    @objc private func bamMoChiaTarget() {
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let vc = ManHinhChiaTarget(ngay: ngay, khoaNganhChonMacDinh: khoa)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func bamSuaNganhHang() {
        khiYeuCauSuaDong?(dong)
    }

    // MARK: - Bảng xếp hạng nhân viên của ngành hàng

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachXepHang.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 34))
        header.backgroundColor = .tertiarySystemGroupedBackground

        let nhanTrai = UILabel()
        nhanTrai.text = "#   NHÂN VIÊN (Chạm để sửa TH)"
        nhanTrai.font = .systemFont(ofSize: 11, weight: .bold)
        nhanTrai.textColor = .secondaryLabel

        let nhanPhai = UILabel()
        nhanPhai.text = "THỰC HIỆN   •   CÒN/VƯỢT   •   % HT"
        nhanPhai.font = .systemFont(ofSize: 11, weight: .bold)
        nhanPhai.textColor = .secondaryLabel
        nhanPhai.textAlignment = .right

        [nhanTrai, nhanPhai].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview($0)
        }
        NSLayoutConstraint.activate([
            nhanTrai.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10),
            nhanTrai.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            nhanPhai.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10),
            nhanPhai.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "XepHangNVNganhCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let item = danhSachXepHang[indexPath.row]
        let hang = indexPath.row + 1
        let dat = item.daDat
        let kha = item.phanTramHT >= 80.0

        let nenKhung = UIView()
        nenKhung.layer.cornerRadius = 8
        nenKhung.clipsToBounds = true
        nenKhung.backgroundColor = dat
            ? UIColor(red: 0.94, green: 0.99, blue: 0.96, alpha: 1)
            : (kha ? UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1) : UIColor(red: 1.0, green: 0.99, blue: 0.92, alpha: 1))
        nenKhung.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(nenKhung)

        let thanhTienDo = UIView()
        thanhTienDo.backgroundColor = dat
            ? UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1)
            : (kha ? UIColor(red: 0.86, green: 0.92, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.94, blue: 0.54, alpha: 0.65))
        thanhTienDo.translatesAutoresizingMaskIntoConstraints = false
        nenKhung.addSubview(thanhTienDo)

        let nhanHang = UILabel()
        nhanHang.text = KhoDuLieu.huyChuongHang(hang)
        nhanHang.font = .systemFont(ofSize: 13, weight: .bold)
        nhanHang.textAlignment = .center

        let nhanTen = UILabel()
        nhanTen.text = "\(item.hoTen) - \(item.maNV)"
        nhanTen.font = .systemFont(ofSize: 12.5, weight: .bold)
        nhanTen.textColor = .label
        nhanTen.lineBreakMode = .byTruncatingTail

        let nhanThucHien = UILabel()
        nhanThucHien.text = "\(item.thucHien.chuoiSoGonVN) / \(item.targetCaNhan.chuoiSoGonVN)"
        nhanThucHien.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
        nhanThucHien.textAlignment = .right

        let vuot = item.thucHien - item.targetCaNhan
        let nhanChenh = UILabel()
        nhanChenh.text = vuot >= -0.005 ? "+\(max(0, vuot).chuoiSoGonVN)" : "-\(abs(vuot).chuoiSoGonVN)"
        nhanChenh.font = .monospacedDigitSystemFont(ofSize: 11.5, weight: .semibold)
        nhanChenh.textColor = vuot >= -0.005 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : .secondaryLabel
        nhanChenh.textAlignment = .right

        let nhanBadge = UILabel()
        nhanBadge.text = "\(Int(round(item.phanTramHT)))%"
        nhanBadge.font = .monospacedDigitSystemFont(ofSize: 11.5, weight: .bold)
        nhanBadge.textAlignment = .center
        nhanBadge.layer.cornerRadius = 6
        nhanBadge.clipsToBounds = true
        nhanBadge.backgroundColor = dat
            ? UIColor(red: 0.80, green: 0.96, blue: 0.85, alpha: 1)
            : (kha ? UIColor(red: 0.82, green: 0.89, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.92, blue: 0.75, alpha: 1))
        nhanBadge.textColor = dat
            ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
            : (kha ? UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1) : UIColor(red: 0.71, green: 0.33, blue: 0.04, alpha: 1))

        [nhanHang, nhanTen, nhanThucHien, nhanChenh, nhanBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            nenKhung.addSubview($0)
        }

        let tyLe = CGFloat(min(1.0, max(0.03, item.phanTramHT / 100.0)))
        NSLayoutConstraint.activate([
            nenKhung.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 3),
            nenKhung.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -3),
            nenKhung.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 6),
            nenKhung.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -6),

            thanhTienDo.leadingAnchor.constraint(equalTo: nenKhung.leadingAnchor),
            thanhTienDo.topAnchor.constraint(equalTo: nenKhung.topAnchor),
            thanhTienDo.bottomAnchor.constraint(equalTo: nenKhung.bottomAnchor),
            thanhTienDo.widthAnchor.constraint(equalTo: nenKhung.widthAnchor, multiplier: tyLe),

            nhanHang.leadingAnchor.constraint(equalTo: nenKhung.leadingAnchor, constant: 6),
            nhanHang.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanHang.widthAnchor.constraint(equalToConstant: 26),

            nhanBadge.trailingAnchor.constraint(equalTo: nenKhung.trailingAnchor, constant: -6),
            nhanBadge.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanBadge.widthAnchor.constraint(equalToConstant: 48),
            nhanBadge.heightAnchor.constraint(equalToConstant: 24),

            nhanChenh.trailingAnchor.constraint(equalTo: nhanBadge.leadingAnchor, constant: -6),
            nhanChenh.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanChenh.widthAnchor.constraint(equalToConstant: 56),

            nhanThucHien.trailingAnchor.constraint(equalTo: nhanChenh.leadingAnchor, constant: -6),
            nhanThucHien.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanThucHien.widthAnchor.constraint(greaterThanOrEqualToConstant: 68),

            nhanTen.leadingAnchor.constraint(equalTo: nhanHang.trailingAnchor, constant: 4),
            nhanTen.trailingAnchor.constraint(lessThanOrEqualTo: nhanThucHien.leadingAnchor, constant: -6),
            nhanTen.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < danhSachXepHang.count else { return }
        let item = danhSachXepHang[indexPath.row]
        let hop = UIAlertController(
            title: "\(item.hoTen) (\(item.maNV))",
            message: "Nhập số Thực hiện cho mặt hàng \(dong.tenNganhHang):",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Thực hiện..."
            tf.keyboardType = .decimalPad
            if item.thucHien > 0 {
                tf.text = item.thucHien.chuoiSoGonVN.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
            }
        }
        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let chu = (hop.textFields?.first?.text ?? "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ",", with: ".")
            let giaTri = Double(chu) ?? 0
            let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(self.dong.tenNganhHang)
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
            dl.thiDuaNhanVien[khoa, default: [:]][item.maNV] = giaTri
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
            self.khiCapNhatDuLieu?()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    // MARK: - Xuất ảnh Bảng xếp hạng nhân viên của ngành hàng

    @objc private func bamXuatAnhBangNganhHang() {
        guard !danhSachXepHang.isEmpty else { return }
        guard let anh = taoAnhBangNganhHang() else { return }
        let vc = UIActivityViewController(activityItems: [anh], applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.first
        }
        present(vc, animated: true)
    }

    private func taoAnhBangNganhHang() -> UIImage? {
        let soNV = danhSachXepHang.count
        guard soNV > 0 else { return nil }
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let donVi = dl.thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : dl.thongTinDonVi
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let targetMoiNV = dong.target / Double(soNV)
        let tongTH = danhSachXepHang.reduce(0.0) { $0 + $1.thucHien }
        let tyLeChung = dong.target > 0 ? Int(round(tongTH / dong.target * 100.0)) : 0

        let rong: CGFloat = 760
        let le: CGFloat = 22
        let caoHeader: CGFloat = 76
        let caoTieuDeCot: CGFloat = 34
        let caoDong: CGFloat = 42
        let caoChan: CGFloat = 52
        let cao = le * 2 + caoHeader + caoTieuDeCot + CGFloat(soNV) * caoDong + caoChan

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 2.0
        return UIGraphicsImageRenderer(size: CGSize(width: rong, height: cao), format: fmt).image { ctx in
            let cg = ctx.cgContext
            UIColor.white.setFill()
            cg.fill(CGRect(x: 0, y: 0, width: rong, height: cao))

            let pLeft = NSMutableParagraphStyle(); pLeft.alignment = .left
            let pRight = NSMutableParagraphStyle(); pRight.alignment = .right
            let pCenter = NSMutableParagraphStyle(); pCenter.alignment = .center

            (donVi as NSString).draw(at: CGPoint(x: le, y: le + 4), withAttributes: [
                .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
                .foregroundColor: UIColor.darkGray
            ])
            (dong.tenNganhHang as NSString).draw(at: CGPoint(x: le, y: le + 24), withAttributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .heavy),
                .foregroundColor: UIColor.black
            ])
            let subRight = "Ngày \(ngayStr) • Chia đều \(soNV) NV (\(targetMoiNV.chuoiSoGonVN)/NV)"
            (subRight as NSString).draw(in: CGRect(x: rong - le - 340, y: le + 16, width: 340, height: 20), withAttributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: UIColor.darkGray,
                .paragraphStyle: pRight
            ])

            var y = le + caoHeader
            let headerAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11, weight: .bold),
                .foregroundColor: UIColor.gray
            ]
            ("#" as NSString).draw(at: CGPoint(x: le + 10, y: y + 8), withAttributes: headerAttr)
            ("NHÂN VIÊN" as NSString).draw(at: CGPoint(x: le + 46, y: y + 8), withAttributes: headerAttr)
            ("THỰC HIỆN" as NSString).draw(in: CGRect(x: rong - le - 290, y: y + 8, width: 100, height: 18), withAttributes: headerAttr.merging([.paragraphStyle: pRight]) { $1 })
            ("CÒN / VƯỢT" as NSString).draw(in: CGRect(x: rong - le - 180, y: y + 8, width: 94, height: 18), withAttributes: headerAttr.merging([.paragraphStyle: pRight]) { $1 })
            ("% HT" as NSString).draw(in: CGRect(x: rong - le - 64, y: y + 8, width: 58, height: 18), withAttributes: headerAttr.merging([.paragraphStyle: pCenter]) { $1 })

            y += caoTieuDeCot

            for (idx, item) in danhSachXepHang.enumerated() {
                let hang = idx + 1
                let dat = item.daDat
                let kha = item.phanTramHT >= 80.0
                let bgTrack = dat ? UIColor(red: 0.94, green: 0.99, blue: 0.96, alpha: 1) : (kha ? UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1) : UIColor(red: 0.99, green: 0.99, blue: 0.91, alpha: 1))
                let bgFill = dat ? UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1) : (kha ? UIColor(red: 0.86, green: 0.92, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.94, blue: 0.54, alpha: 1))

                let rectRow = CGRect(x: le, y: y + 3, width: rong - le * 2, height: caoDong - 6)
                bgTrack.setFill()
                UIBezierPath(roundedRect: rectRow, cornerRadius: 8).fill()

                let pctW = CGFloat(min(1.0, max(0.03, item.phanTramHT / 100.0))) * rectRow.width
                bgFill.setFill()
                UIBezierPath(roundedRect: CGRect(x: le, y: y + 3, width: pctW, height: caoDong - 6), cornerRadius: 8).fill()

                (KhoDuLieu.huyChuongHang(hang) as NSString).draw(in: CGRect(x: le + 6, y: y + 12, width: 28, height: 20), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .bold),
                    .foregroundColor: UIColor.darkGray,
                    .paragraphStyle: pCenter
                ])
                ("\(item.hoTen) - \(item.maNV)" as NSString).draw(in: CGRect(x: le + 46, y: y + 12, width: 320, height: 20), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .bold),
                    .foregroundColor: UIColor.black
                ])
                ("\(item.thucHien.chuoiSoGonVN) / \(item.targetCaNhan.chuoiSoGonVN)" as NSString).draw(in: CGRect(x: rong - le - 310, y: y + 12, width: 120, height: 20), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .heavy),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: pRight
                ])
                let vuot = item.thucHien - item.targetCaNhan
                let strDiff = vuot >= -0.005 ? "Vượt +\(max(0, vuot).chuoiSoGonVN)" : "Còn \(abs(vuot).chuoiSoGonVN)"
                (strDiff as NSString).draw(in: CGRect(x: rong - le - 184, y: y + 12, width: 98, height: 20), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                    .foregroundColor: vuot >= -0.005 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : UIColor.darkGray,
                    .paragraphStyle: pRight
                ])

                let badgeRect = CGRect(x: rong - le - 64, y: y + 9, width: 58, height: 24)
                let badgeBg = dat ? UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1) : (kha ? UIColor(red: 0.86, green: 0.92, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.95, blue: 0.78, alpha: 1))
                let badgeFg = dat ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : (kha ? UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1) : UIColor(red: 0.71, green: 0.33, blue: 0.04, alpha: 1))
                badgeBg.setFill()
                UIBezierPath(roundedRect: badgeRect, cornerRadius: 6).fill()
                ("\(Int(round(item.phanTramHT)))%" as NSString).draw(in: CGRect(x: badgeRect.minX, y: badgeRect.minY + 4, width: badgeRect.width, height: 18), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 12, weight: .heavy),
                    .foregroundColor: badgeFg,
                    .paragraphStyle: pCenter
                ])

                y += caoDong
            }

            UIColor.lightGray.setFill()
            cg.fill(CGRect(x: le, y: y + 8, width: rong - le * 2, height: 1))
            ("TỔNG CỘNG:  \(tongTH.chuoiSoGonVN) / \(dong.target.chuoiSoGonVN)   •   \(soNV) nhân viên" as NSString).draw(at: CGPoint(x: le, y: y + 20), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .heavy),
                .foregroundColor: UIColor.black
            ])
            ("Tỷ lệ HT: \(tyLeChung)%" as NSString).draw(in: CGRect(x: rong - le - 160, y: y + 20, width: 160, height: 22), withAttributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .heavy),
                .foregroundColor: UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1),
                .paragraphStyle: pRight
            ])
        }
    }
}

// MARK: - 2. BangNhanVienView (Tab Nhân viên trên màn hình chính: Sắp xếp + Nút Nhập ảnh DT hợp nhất + Bảng 8 cột)

final class BangNhanVienView: UIView, UITableViewDataSource, UITableViewDelegate {
    var khiChonNhanVien: ((TongHopNhanVien) -> Void)?
    var khiBamQuetDoanhThuNV: (() -> Void)?
    var khiBamMoCaiDatNV: (() -> Void)?

    private var ngayHienTai = Date()
    private var kieuSapXep: KieuSapXepNhanVien = .soMonHoanThanh
    private var danhSach: [TongHopNhanVien] = []

    private let chieuRongCot: [CGFloat] = [44, 175, 86, 82, 74, 88, 92, 92]
    private var tongChieuRongBang: CGFloat { chieuRongCot.reduce(0, +) }

    private let nhanTieuDe = UILabel()
    private let nutSapXep = UIButton(type: .system)
    private let nutQuetDTNV = UIButton(type: .system)
    private let cuonNgang = UIScrollView()
    private let bang = UITableView(frame: .zero, style: .plain)
    private let khungTrong = UIControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func taoGiaoDien() {
        backgroundColor = .clear

        nhanTieuDe.font = .systemFont(ofSize: 12.5, weight: .bold)
        nhanTieuDe.textColor = .label
        nhanTieuDe.text = "🏆 Bảng Xếp Hạng Nhân Viên"

        nutSapXep.setTitle(" ⇅ \(kieuSapXep.nhanNgan)", for: .normal)
        nutSapXep.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutSapXep.backgroundColor = .secondarySystemGroupedBackground
        nutSapXep.tintColor = .systemBlue
        nutSapXep.layer.cornerRadius = 8
        nutSapXep.layer.borderWidth = 1
        nutSapXep.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.25).cgColor
        nutSapXep.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        cauHinhMenuSapXep()

        nutQuetDTNV.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        nutQuetDTNV.setTitle(" Nhập ảnh DT", for: .normal)
        nutQuetDTNV.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutQuetDTNV.backgroundColor = .secondarySystemGroupedBackground
        nutQuetDTNV.tintColor = .systemBlue
        nutQuetDTNV.layer.cornerRadius = 8
        nutQuetDTNV.layer.borderWidth = 1
        nutQuetDTNV.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.25).cgColor
        nutQuetDTNV.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        nutQuetDTNV.addTarget(self, action: #selector(bamQuetDT), for: .touchUpInside)

        let thanhDieuKhien = UIStackView(arrangedSubviews: [nhanTieuDe, nutSapXep, nutQuetDTNV])
        thanhDieuKhien.axis = .horizontal
        thanhDieuKhien.spacing = 6
        nhanTieuDe.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nhanTieuDe.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nutSapXep.setContentHuggingPriority(.required, for: .horizontal)
        nutQuetDTNV.setContentHuggingPriority(.required, for: .horizontal)

        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.showsVerticalScrollIndicator = false
        cuonNgang.bounces = false
        cuonNgang.layer.cornerRadius = 12
        cuonNgang.clipsToBounds = true
        cuonNgang.backgroundColor = .systemBackground

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

        khungTrong.backgroundColor = .secondarySystemGroupedBackground
        khungTrong.layer.cornerRadius = 14
        khungTrong.addTarget(self, action: #selector(bamMoCaiDat), for: .touchUpInside)

        let nhanTrong = UILabel()
        nhanTrong.text = "Chưa có nhân viên trong danh sách quản lý.\nHãy bấm vào Cài đặt (⚙️) để thêm danh sách nhân viên bạn quản lý."
        nhanTrong.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nhanTrong.textColor = .secondaryLabel
        nhanTrong.textAlignment = .center
        nhanTrong.numberOfLines = 0
        nhanTrong.isUserInteractionEnabled = false
        nhanTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nhanTrong)

        [thanhDieuKhien, cuonNgang, khungTrong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            thanhDieuKhien.topAnchor.constraint(equalTo: topAnchor),
            thanhDieuKhien.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thanhDieuKhien.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thanhDieuKhien.heightAnchor.constraint(equalToConstant: 32),

            cuonNgang.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 8),
            cuonNgang.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cuonNgang.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cuonNgang.bottomAnchor.constraint(equalTo: bottomAnchor),

            bang.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            bang.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            bang.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            bang.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),
            bang.widthAnchor.constraint(equalToConstant: tongChieuRongBang),

            khungTrong.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 8),
            khungTrong.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            khungTrong.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            khungTrong.bottomAnchor.constraint(equalTo: bottomAnchor),

            nhanTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nhanTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nhanTrong.leadingAnchor.constraint(equalTo: khungTrong.leadingAnchor, constant: 20),
            nhanTrong.trailingAnchor.constraint(equalTo: khungTrong.trailingAnchor, constant: -20)
        ])
    }

    private func cauHinhMenuSapXep() {
        let actions = KieuSapXepNhanVien.allCases.map { kieu in
            UIAction(title: kieu.nhan, state: (kieu == kieuSapXep) ? .on : .off) { [weak self] _ in
                guard let self = self else { return }
                self.kieuSapXep = kieu
                self.nutSapXep.setTitle(" ⇅ \(kieu.nhanNgan)", for: .normal)
                self.cauHinhMenuSapXep()
                self.capNhat(cho: self.ngayHienTai)
            }
        }
        nutSapXep.menu = UIMenu(title: "Sắp xếp nhân viên", children: actions)
        nutSapXep.showsMenuAsPrimaryAction = true
    }

    @objc private func bamQuetDT() {
        khiBamQuetDoanhThuNV?()
    }

    @objc private func bamMoCaiDat() {
        khiBamMoCaiDatNV?()
    }

    func capNhat(cho ngay: Date) {
        ngayHienTai = ngay
        danhSach = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: kieuSapXep)
        let soMonThang = KhoDuLieu.dungChung.danhSachMatHangThang(den: ngay).count
        nhanTieuDe.text = "🏆 Xếp Hạng (\(danhSach.count) NV • \(soMonThang) môn)"

        let trong = danhSach.isEmpty
        khungTrong.isHidden = !trong
        cuonNgang.isHidden = trong
        bang.reloadData()
    }

    func gan(_ moi: [TongHopNhanVien]) {
        danhSach = moi
        let trong = danhSach.isEmpty
        khungTrong.isHidden = !trong
        cuonNgang.isHidden = trong
        bang.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSach.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 40))
        khung.backgroundColor = .systemGray5

        let tieuDe = ["HẠNG", "NHÂN VIÊN (CHẠM XEM MÔN)", "SỐ MÔN ĐẠT", "% HT TB", "SỐ LƯỢNG", "DOANH THU QĐ", "DT KHOẢN VAY", "DT TRẢ THẲNG"]
        var xHienTai: CGFloat = 0
        for (i, chu) in tieuDe.enumerated() {
            let w = chieuRongCot[i]
            let nhan = UILabel(frame: CGRect(x: xHienTai + 4, y: 0, width: w - 8, height: 40))
            nhan.text = chu
            nhan.font = .systemFont(ofSize: 10.5, weight: .bold)
            nhan.textColor = .label
            nhan.numberOfLines = 2
            nhan.textAlignment = (i == 1) ? .left : (i >= 4 ? .right : .center)
            khung.addSubview(nhan)

            xHienTai += w
            if i < tieuDe.count - 1 {
                let vach = UIView(frame: CGRect(x: xHienTai, y: 0, width: 0.5, height: 40))
                vach.backgroundColor = .separator
                khung.addSubview(vach)
            }
        }
        return khung
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongTongHopNV8Cot"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .default
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let row = danhSach[indexPath.row]
        let hang = indexPath.row + 1
        let laTop3 = hang <= 3

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 52))
        khung.backgroundColor = laTop3 ? UIColor.systemGreen.withAlphaComponent(0.05) : .systemBackground
        cell.contentView.addSubview(khung)

        var x: CGFloat = 0
        for i in 0..<chieuRongCot.count {
            let w = chieuRongCot[i]
            let rect = CGRect(x: x, y: 0, width: w, height: 52)

            switch i {
            case 0:
                let lb = UILabel(frame: rect)
                lb.text = KhoDuLieu.huyChuongHang(hang)
                lb.font = .systemFont(ofSize: laTop3 ? 16 : 13, weight: .bold)
                lb.textAlignment = .center
                khung.addSubview(lb)
            case 1:
                let lbTen = UILabel(frame: CGRect(x: x + 8, y: 7, width: w - 12, height: 20))
                lbTen.text = row.nhanVien.hoTen
                lbTen.font = .systemFont(ofSize: 13, weight: .bold)
                let lbMa = UILabel(frame: CGRect(x: x + 8, y: 27, width: w - 12, height: 16))
                lbMa.text = "Mã NV: \(row.nhanVien.maNV)"
                lbMa.font = .systemFont(ofSize: 11, weight: .medium)
                lbMa.textColor = .secondaryLabel
                khung.addSubview(lbTen)
                khung.addSubview(lbMa)
            case 2:
                let pill = UILabel(frame: rect.insetBy(dx: 6, dy: 12))
                pill.text = "🏆 \(row.soMonDat)/\(row.tongMonGiao) môn"
                pill.font = .systemFont(ofSize: 11.5, weight: .bold)
                pill.textAlignment = .center
                pill.layer.cornerRadius = 8
                pill.clipsToBounds = true
                pill.backgroundColor = row.soMonDat > 0 ? UIColor.systemGreen.withAlphaComponent(0.16) : UIColor.systemRed.withAlphaComponent(0.14)
                pill.textColor = row.soMonDat > 0 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : UIColor(red: 0.78, green: 0.14, blue: 0.14, alpha: 1)
                khung.addSubview(pill)
            case 3:
                let lb = UILabel(frame: rect)
                lb.text = row.tongMonGiao > 0 ? String(format: "%.1f%%", row.phanTramHTTB) : "--"
                lb.font = .monospacedDigitSystemFont(ofSize: 12.5, weight: .bold)
                lb.textAlignment = .center
                khung.addSubview(lb)
            case 4:
                let lb = UILabel(frame: rect.insetBy(dx: 8, dy: 0))
                lb.text = row.soLuongDon > 0 ? row.soLuongDon.chuoiSoNguyenVN : "--"
                lb.font = .monospacedDigitSystemFont(ofSize: 12.5, weight: .medium)
                lb.textColor = .secondaryLabel
                lb.textAlignment = .right
                khung.addSubview(lb)
            case 5:
                let lb = UILabel(frame: rect.insetBy(dx: 8, dy: 0))
                lb.text = row.doanhThuQD > 0 ? row.doanhThuQD.chuoiSoLieu : "--"
                lb.font = .monospacedDigitSystemFont(ofSize: 13, weight: .bold)
                lb.textColor = UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
                lb.textAlignment = .right
                khung.addSubview(lb)
            case 6:
                let lb = UILabel(frame: rect.insetBy(dx: 8, dy: 0))
                lb.text = row.dtQDKhoanVay > 0 ? row.dtQDKhoanVay.chuoiSoLieu : "0"
                lb.font = .monospacedDigitSystemFont(ofSize: 12.5, weight: .medium)
                lb.textColor = .secondaryLabel
                lb.textAlignment = .right
                khung.addSubview(lb)
            case 7:
                let lb = UILabel(frame: rect.insetBy(dx: 8, dy: 0))
                lb.text = row.dtTraThangQD > 0 ? row.dtTraThangQD.chuoiSoLieu : "--"
                lb.font = .monospacedDigitSystemFont(ofSize: 12.5, weight: .bold)
                lb.textAlignment = .right
                khung.addSubview(lb)
            default:
                break
            }

            x += w
            if i < chieuRongCot.count - 1 {
                let vach = UIView(frame: CGRect(x: x, y: 0, width: 0.5, height: 52))
                vach.backgroundColor = .separator
                khung.addSubview(vach)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < danhSach.count else { return }
        khiChonNhanVien?(danhSach[indexPath.row])
    }
}

// MARK: - 3. Màn hình Chi tiết Sức khoẻ Cá nhân Nhân viên
// (Tương đương ModalChiTietNhanVien trong dmx-modals.tsx: Thanh tiến độ tháng, 4 thẻ KPI, Bộ lọc Đạt/Chưa đạt, Bảng 8 cột môn thi đua)

final class ManHinhChiTietNhanVien: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tongHop: TongHopNhanVien
    private let ngay: Date
    private var boLoc: BoLocThiDua = .tatCa
    private var danhSachMonLoc: [MonThiDuaNhanVien] = []

    private let chonBoLoc = UISegmentedControl(items: ["Tất cả", "Đạt", "Chưa đạt"])
    private let cuonNgang = UIScrollView()
    private let bang = UITableView(frame: .zero, style: .plain)
    private let chieuRongCot: [CGFloat] = [36, 190, 82, 82, 78, 86, 82, 92]
    private var tongChieuRongBang: CGFloat { chieuRongCot.reduce(0, +) }

    init(_ tongHop: TongHopNhanVien, ngay: Date = Date()) {
        self.tongHop = tongHop
        self.ngay = ngay
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sức khoẻ \(tongHop.nhanVien.hoTen)"
        view.backgroundColor = .systemGroupedBackground
        taoGiaoDien()
        locDanhSachMon()
    }

    private func taoGiaoDien() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let dt = dl.doanhThu
        let lich = TienIchNgay.lich
        let soNgayQua = dt.soNgayDaQua > 0 ? dt.soNgayDaQua : max(1, lich.component(.day, from: ngay))
        let tongNgayThang = dt.tongSoNgay > 0 ? dt.tongSoNgay : (lich.range(of: .day, in: .month, for: ngay)?.count ?? 30)
        let ptTienDo = dt.phanTramTienDoThang > 0 ? dt.phanTramTienDoThang : (Double(soNgayQua) / Double(max(1, tongNgayThang)) * 100.0)

        // 1. Thanh tiến độ tháng
        let khungTienDo = UIView()
        khungTienDo.backgroundColor = .systemBackground
        khungTienDo.layer.cornerRadius = 10
        khungTienDo.layer.borderWidth = 1
        khungTienDo.layer.borderColor = UIColor.systemGray5.cgColor

        let lbTDTrai = UILabel()
        lbTDTrai.text = "Tiến độ tháng   Ngày \(soNgayQua) / \(tongNgayThang)"
        lbTDTrai.font = .systemFont(ofSize: 11.5, weight: .bold)
        let lbTDPhai = UILabel()
        lbTDPhai.text = String(format: "%.1f%%", ptTienDo)
        lbTDPhai.font = .systemFont(ofSize: 11.5, weight: .bold)
        lbTDPhai.textAlignment = .right

        let track = UIView()
        track.backgroundColor = .systemGray5
        track.layer.cornerRadius = 3
        track.clipsToBounds = true
        let fill = UIView()
        fill.backgroundColor = .systemBlue
        fill.layer.cornerRadius = 3
        fill.translatesAutoresizingMaskIntoConstraints = false
        track.addSubview(fill)

        [lbTDTrai, lbTDPhai, track].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungTienDo.addSubview($0)
        }

        let tyLeTD = CGFloat(min(1.0, max(0.02, ptTienDo / 100.0)))
        NSLayoutConstraint.activate([
            lbTDTrai.topAnchor.constraint(equalTo: khungTienDo.topAnchor, constant: 6),
            lbTDTrai.leadingAnchor.constraint(equalTo: khungTienDo.leadingAnchor, constant: 10),
            lbTDPhai.centerYAnchor.constraint(equalTo: lbTDTrai.centerYAnchor),
            lbTDPhai.trailingAnchor.constraint(equalTo: khungTienDo.trailingAnchor, constant: -10),
            track.topAnchor.constraint(equalTo: lbTDTrai.bottomAnchor, constant: 5),
            track.leadingAnchor.constraint(equalTo: khungTienDo.leadingAnchor, constant: 10),
            track.trailingAnchor.constraint(equalTo: khungTienDo.trailingAnchor, constant: -10),
            track.heightAnchor.constraint(equalToConstant: 5),
            fill.leadingAnchor.constraint(equalTo: track.leadingAnchor),
            fill.topAnchor.constraint(equalTo: track.topAnchor),
            fill.bottomAnchor.constraint(equalTo: track.bottomAnchor),
            fill.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: tyLeTD)
        ])

        // 2. 4 Thẻ KPI Cá nhân
        let dtQD = tongHop.doanhThuQD
        let dtThang = tongHop.dtTraThangQD
        let soDon = tongHop.soLuongDon
        let dtVay = tongHop.dtQDKhoanVay
        let tongMon = tongHop.tongMonGiao
        let soMonDat = tongHop.soMonDat
        let soMonChua = tongMon - soMonDat
        let tyLeMon = tongMon > 0 ? Int(round(Double(soMonDat) / Double(tongMon) * 100.0)) : 0

        let the1 = TheDoanhThuView(
            tieuDe: "💵 DOANH THU QĐ",
            mauBatDau: UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1),
            mauKetThuc: UIColor(red: 0.23, green: 0.25, blue: 0.89, alpha: 1)
        )
        the1.capNhatNoiDung(
            chinh: dtQD > 0 ? "\(dtQD.chuoiSoGonVN)tr" : "--",
            phu: dtThang > 0 ? "DT THẲNG: \(dtThang.chuoiSoGonVN)" : "SL: \(soDon.chuoiSoNguyenVN) ĐƠN"
        )

        let the2 = TheDoanhThuView(
            tieuDe: "🏆 MÔN THI ĐUA HT",
            mauBatDau: UIColor(red: 0.96, green: 0.62, blue: 0.04, alpha: 1),
            mauKetThuc: UIColor(red: 0.85, green: 0.47, blue: 0.02, alpha: 1)
        )
        the2.capNhatNoiDung(
            chinh: "\(soMonDat)/\(tongMon)",
            phu: "HOÀN THÀNH: \(tyLeMon)% SỐ MÔN"
        )

        let the3 = TheDoanhThuView(
            tieuDe: "📦 SỐ LƯỢNG / KHOẢN VAY",
            mauBatDau: UIColor(red: 0.09, green: 0.61, blue: 0.27, alpha: 1),
            mauKetThuc: UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
        )
        the3.capNhatNoiDung(
            chinh: soDon > 0 ? soDon.chuoiSoNguyenVN : "--",
            phu: "QĐ VAY: \(dtVay.chuoiSoGonVN)"
        )

        let the4 = TheDoanhThuView(
            tieuDe: "📈 % HT THI ĐUA TB",
            mauBatDau: UIColor(red: 0.55, green: 0.36, blue: 0.96, alpha: 1),
            mauKetThuc: UIColor(red: 0.66, green: 0.33, blue: 0.97, alpha: 1)
        )
        the4.capNhatNoiDung(
            chinh: tongHop.phanTramHTTB.chuoiPhanTramVN,
            phu: "ĐẠT \(soMonDat) • CHƯA \(soMonChua)"
        )

        let hangThe = UIStackView(arrangedSubviews: [the1, the2, the3, the4])
        hangThe.axis = .horizontal
        hangThe.spacing = 6
        hangThe.distribution = .fillEqually

        // 3. Bộ lọc Tất cả / Đạt / Chưa đạt
        chonBoLoc.selectedSegmentIndex = 0
        chonBoLoc.setTitle("Tất cả (\(tongMon))", forSegmentAt: 0)
        chonBoLoc.setTitle("Đạt (\(soMonDat))", forSegmentAt: 1)
        chonBoLoc.setTitle("Chưa đạt (\(soMonChua))", forSegmentAt: 2)
        chonBoLoc.addTarget(self, action: #selector(doiBoLoc), for: .valueChanged)

        // 4. Bảng 8 cột môn thi đua của nhân viên
        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.bounces = false
        cuonNgang.layer.cornerRadius = 12
        cuonNgang.clipsToBounds = true
        cuonNgang.backgroundColor = .systemBackground

        bang.dataSource = self
        bang.delegate = self
        bang.rowHeight = 48
        bang.sectionHeaderHeight = 38
        bang.separatorStyle = .singleLine
        bang.separatorInset = .zero
        if #available(iOS 15.0, *) {
            bang.sectionHeaderTopPadding = 0
        }
        bang.translatesAutoresizingMaskIntoConstraints = false
        cuonNgang.addSubview(bang)

        [khungTienDo, hangThe, chonBoLoc, cuonNgang].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungTienDo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            khungTienDo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            khungTienDo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            khungTienDo.heightAnchor.constraint(equalToConstant: 34),

            hangThe.topAnchor.constraint(equalTo: khungTienDo.bottomAnchor, constant: 8),
            hangThe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hangThe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hangThe.heightAnchor.constraint(equalToConstant: 62),

            chonBoLoc.topAnchor.constraint(equalTo: hangThe.bottomAnchor, constant: 8),
            chonBoLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            chonBoLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chonBoLoc.heightAnchor.constraint(equalToConstant: 32),

            cuonNgang.topAnchor.constraint(equalTo: chonBoLoc.bottomAnchor, constant: 8),
            cuonNgang.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cuonNgang.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            cuonNgang.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),

            bang.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            bang.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            bang.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            bang.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),
            bang.widthAnchor.constraint(equalToConstant: tongChieuRongBang)
        ])
    }

    @objc private func doiBoLoc() {
        boLoc = BoLocThiDua(rawValue: chonBoLoc.selectedSegmentIndex) ?? .tatCa
        locDanhSachMon()
    }

    private func locDanhSachMon() {
        switch boLoc {
        case .tatCa:
            danhSachMonLoc = tongHop.cacMonGiao
        case .daDat:
            danhSachMonLoc = tongHop.cacMonGiao.filter(\.daDat)
        case .chuaDat:
            danhSachMonLoc = tongHop.cacMonGiao.filter { !$0.daDat }
        }
        bang.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachMonLoc.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 38))
        khung.backgroundColor = .systemGray5
        let tieuDe = ["#", "MÔN THI ĐUA", "THỰC HIỆN", "TARGET", "% HT", "% HT ST", "CÒN LẠI", "TIẾN ĐỘ"]
        var x: CGFloat = 0
        for (i, chu) in tieuDe.enumerated() {
            let w = chieuRongCot[i]
            let lb = UILabel(frame: CGRect(x: x + 4, y: 0, width: w - 8, height: 38))
            lb.text = chu
            lb.font = .systemFont(ofSize: 10.5, weight: .bold)
            lb.textAlignment = (i == 1) ? .left : (i == 2 || i == 3 || i == 6 ? .right : .center)
            khung.addSubview(lb)
            x += w
        }
        return khung
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "ChiTietMonNVCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .none
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let m = danhSachMonLoc[indexPath.row]
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: tongChieuRongBang, height: 48))
        khung.backgroundColor = m.daDat ? UIColor.systemGreen.withAlphaComponent(0.05) : UIColor.systemRed.withAlphaComponent(0.04)
        cell.contentView.addSubview(khung)

        var x: CGFloat = 0
        for i in 0..<chieuRongCot.count {
            let w = chieuRongCot[i]
            let rect = CGRect(x: x, y: 0, width: w, height: 48)
            switch i {
            case 0:
                let lb = UILabel(frame: rect)
                lb.text = "\(indexPath.row + 1)"
                lb.font = .systemFont(ofSize: 12, weight: .semibold)
                lb.textColor = .secondaryLabel
                lb.textAlignment = .center
                khung.addSubview(lb)
            case 1:
                let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 4))
                lb.text = "\(m.tenNganhHang) (\(m.loaiChiTieu.maThe))"
                lb.font = .systemFont(ofSize: 12.5, weight: .bold)
                lb.numberOfLines = 2
                khung.addSubview(lb)
            case 2:
                let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 0))
                lb.text = m.thucHien.chuoiSoVN
                lb.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                lb.textAlignment = .right
                khung.addSubview(lb)
            case 3:
                let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 0))
                lb.text = m.targetCaNhan.chuoiSoVN
                lb.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
                lb.textColor = .secondaryLabel
                lb.textAlignment = .right
                khung.addSubview(lb)
            case 4:
                let pill = UILabel(frame: rect.insetBy(dx: 5, dy: 10))
                pill.text = m.phanTramHT.chuoiPhanTramVN
                pill.font = .monospacedDigitSystemFont(ofSize: 11, weight: .bold)
                pill.textAlignment = .center
                pill.layer.cornerRadius = 7
                pill.clipsToBounds = true
                pill.backgroundColor = m.daDat ? UIColor.systemGreen.withAlphaComponent(0.18) : UIColor.systemRed.withAlphaComponent(0.16)
                pill.textColor = m.daDat ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : UIColor(red: 0.78, green: 0.14, blue: 0.14, alpha: 1)
                khung.addSubview(pill)
            case 5:
                let lb = UILabel(frame: rect)
                lb.text = m.phanTramSieuThi.chuoiPhanTramVN
                lb.font = .monospacedDigitSystemFont(ofSize: 11.5, weight: .medium)
                lb.textColor = .secondaryLabel
                lb.textAlignment = .center
                khung.addSubview(lb)
            case 6:
                let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 0))
                lb.text = m.conLai.chuoiSoVN
                lb.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
                lb.textColor = m.conLai <= 0 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : UIColor(red: 0.78, green: 0.14, blue: 0.14, alpha: 1)
                lb.textAlignment = .right
                khung.addSubview(lb)
            case 7:
                let track = UIView(frame: CGRect(x: x + 8, y: 21, width: w - 16, height: 6))
                track.backgroundColor = .systemGray5
                track.layer.cornerRadius = 3
                track.clipsToBounds = true
                let pct = CGFloat(min(1.0, max(0.04, m.phanTramHT / 100.0)))
                let fill = UIView(frame: CGRect(x: 0, y: 0, width: (w - 16) * pct, height: 6))
                fill.backgroundColor = m.daDat ? .systemGreen : (m.phanTramHT >= 70 ? .systemOrange : .systemRed)
                track.addSubview(fill)
                khung.addSubview(track)
            default:
                break
            }
            x += w
        }
        return cell
    }
}
