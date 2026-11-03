import UIKit

final class ManHinhCaiDat: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let ngay: Date
    private let nhanThongTinTaiKhoan = UILabel()
    private let nutMoAdminTaiKhoan = UIButton(type: .system)
    private let nutDoiMatKhauNhanh = UIButton(type: .system)
    private let nutDangXuatNhanh = UIButton(type: .system)
    private let chonKieuHienThi = UISegmentedControl(items: ["Bảng 8 cột (Chi tiết)", "Thẻ tiến độ (Gọn)"])
    private let chonSoCotXuat = UISegmentedControl(items: ["1 cột", "2 cột", "3 cột", "4 cột"])
    private let nutChiaTarget = UIButton(type: .system)
    private let nutQuanLyNV = UIButton(type: .system)
    private let oNhapCumTu = UITextField()
    private let bangCumTu = UITableView(frame: .zero, style: .plain)
    private var danhSachCumTu: [String] = []

    init(ngay: Date = Date()) {
        self.ngay = ngay
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cài đặt & Tài khoản"
        view.backgroundColor = .systemGroupedBackground

        let nutLuu = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(luuCaiDat)
        )
        let nutTaiKhoan = UIBarButtonItem(
            image: UIImage(systemName: "person.crop.circle.badge.checkmark"),
            style: .plain,
            target: self,
            action: #selector(moQuanLyTaiKhoan)
        )
        nutTaiKhoan.tintColor = .systemBlue
        navigationItem.rightBarButtonItems = [nutLuu, nutTaiKhoan]

        let cd = KhoDuLieu.dungChung.caiDat
        chonKieuHienThi.selectedSegmentIndex = cd.kieuHienThi.rawValue
        danhSachCumTu = cd.danhSachCumTuLocBo
        let chiSoCot = max(0, min(3, cd.soCotXuatAnh - 1))
        chonSoCotXuat.selectedSegmentIndex = chiSoCot

        taoGiaoDien()
        capNhatThongTinTaiKhoanUI()
        capNhatTieuDeNutNhanVien()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        capNhatThongTinTaiKhoanUI()
        capNhatTieuDeNutNhanVien()
    }

    private func capNhatThongTinTaiKhoanUI() {
        let dv = DichVuDongBo.dungChung
        let ten = dv.tenDangNhap.isEmpty ? "Chưa đăng nhập" : dv.tenDangNhap
        let vaiTro = dv.laAdmin ? "🛡️ Quản trị viên (Admin)" : "👤 Tài khoản thường"
        nhanThongTinTaiKhoan.text = "Tài khoản ĐMX: \(ten)   •   \(vaiTro)"
        nutMoAdminTaiKhoan.isHidden = !dv.laAdmin
    }

    private func capNhatTieuDeNutNhanVien() {
        let cd = KhoDuLieu.dungChung.caiDat
        let soMH = KhoDuLieu.dungChung.danhSachMatHangThang(den: ngay).count
        nutChiaTarget.setTitle("🎯 1. Chia Target mặt hàng (\(soMH) mặt hàng) ▸", for: .normal)
        nutQuanLyNV.setTitle("👥 2. Danh sách nhân viên quản lý (\(cd.danhSachNhanVien.count) NV) ▸", for: .normal)
    }

    @objc private func bamMoManHinhAdminTaiKhoan() {
        dongBoTamCaiDat()
        navigationController?.pushViewController(ManHinhQuanLyTaiKhoan(), animated: true)
    }

    @objc private func bamDoiMatKhauCaNhan() {
        let tk = DichVuDongBo.dungChung.tenDangNhap
        let hop = UIAlertController(
            title: "🔑 Đổi mật khẩu (\(tk))",
            message: "Nhập mật khẩu mới (tối thiểu 6 ký tự):",
            preferredStyle: .alert
        )
        hop.addTextField { o in
            o.placeholder = "Mật khẩu mới"
            o.isSecureTextEntry = true
        }
        hop.addTextField { o in
            o.placeholder = "Nhập lại mật khẩu mới"
            o.isSecureTextEntry = true
        }
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        hop.addAction(UIAlertAction(title: "Cập nhật mật khẩu", style: .default) { [weak self, weak hop] _ in
            guard let self, let hop else { return }
            let mk1 = hop.textFields?[0].text ?? ""
            let mk2 = hop.textFields?[1].text ?? ""
            guard mk1.count >= 6 else {
                self.hienThongBao(tieuDe: "Mật khẩu quá ngắn", noiDung: "Mật khẩu mới cần có ít nhất 6 ký tự.")
                return
            }
            guard mk1 == mk2 else {
                self.hienThongBao(tieuDe: "Chưa khớp", noiDung: "Mật khẩu nhập lại chưa khớp.")
                return
            }
            DichVuDongBo.dungChung.doiMatKhauCaNhan(matKhauMoi: mk1) { [weak self] kq in
                switch kq {
                case .success:
                    self?.hienThongBao(tieuDe: "✅ Thành công", noiDung: "Đã cập nhật mật khẩu cho tài khoản \(tk).")
                case .failure(let loi):
                    self?.hienThongBao(tieuDe: "Lỗi đổi mật khẩu", noiDung: loi.localizedDescription)
                }
            }
        })
        present(hop, animated: true)
    }

    @objc private func bamDangXuatTaiKhoan() {
        let tk = DichVuDongBo.dungChung.tenDangNhap
        let hop = UIAlertController(
            title: "Đăng xuất tài khoản \(tk)?",
            message: "Bạn có thể đăng nhập lại bất cứ lúc nào.",
            preferredStyle: .alert
        )
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        hop.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive) { _ in
            DichVuDongBo.dungChung.dangXuat()
            (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiDangNhap()
        })
        present(hop, animated: true)
    }

    @objc private func moQuanLyTaiKhoan() {
        let dv = DichVuDongBo.dungChung
        let tk = dv.tenDangNhap.isEmpty ? "Tài khoản" : dv.tenDangNhap
        let menu = UIAlertController(
            title: "Tài khoản ĐMX: \(tk)",
            message: "Dữ liệu được đồng bộ tự động với nhánh duongnt.io.vn/dmx.",
            preferredStyle: .actionSheet
        )
        if dv.laAdmin {
            menu.addAction(UIAlertAction(title: "🛡️ Quản lý tài khoản & Phân quyền Admin", style: .default) { [weak self] _ in
                self?.bamMoManHinhAdminTaiKhoan()
            })
        }
        menu.addAction(UIAlertAction(title: "🔑 Đổi mật khẩu tài khoản \(tk)", style: .default) { [weak self] _ in
            self?.bamDoiMatKhauCaNhan()
        })
        menu.addAction(UIAlertAction(title: "🔄 Đồng bộ dữ liệu ngay", style: .default) { _ in
            DichVuDongBo.dungChung.taiDuLieu()
        })
        menu.addAction(UIAlertAction(title: "🚪 Đăng xuất tài khoản", style: .destructive) { _ in
            DichVuDongBo.dungChung.dangXuat()
            (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiDangNhap()
        })
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(menu, animated: true)
    }

    private func hienThongBao(tieuDe: String, noiDung: String) {
        let tb = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(tb, animated: true)
    }

    private func dongBoTamCaiDat() {
        if let dangGo = oNhapCumTu.text?.trimmingCharacters(in: .whitespacesAndNewlines), !dangGo.isEmpty {
            if !danhSachCumTu.contains(where: { $0.caseInsensitiveCompare(dangGo) == .orderedSame }) {
                danhSachCumTu.insert(dangGo, at: 0)
            }
            oNhapCumTu.text = ""
        }
        let kieu = KieuHienThiBaoCao(rawValue: chonKieuHienThi.selectedSegmentIndex) ?? .bangChiTiet
        let soCot = chonSoCotXuat.selectedSegmentIndex + 1
        var moi = KhoDuLieu.dungChung.caiDat
        moi.kieuHienThi = kieu
        moi.danhSachCumTuLocBo = danhSachCumTu
        moi.soCotXuatAnh = soCot
        KhoDuLieu.dungChung.luuCaiDat(moi)
    }

    @objc private func moChiaTarget() {
        dongBoTamCaiDat()
        navigationController?.pushViewController(ManHinhChiaTarget(ngay: ngay), animated: true)
    }

    @objc private func moQuanLyNhanVien() {
        dongBoTamCaiDat()
        navigationController?.pushViewController(ManHinhQuanLyNhanVien(), animated: true)
    }

    private func taoGiaoDien() {
        // Khối 0: Tài khoản & Quản trị hệ thống
        let tieuDeTK = taoTieuDeNhom("👤 TÀI KHOẢN & QUẢN TRỊ HỆ THỐNG")
        let khungTK = UIView()
        khungTK.backgroundColor = .secondarySystemGroupedBackground
        khungTK.layer.cornerRadius = 12

        nhanThongTinTaiKhoan.font = .systemFont(ofSize: 13.5, weight: .bold)
        nhanThongTinTaiKhoan.textColor = .label
        nhanThongTinTaiKhoan.numberOfLines = 1

        nutMoAdminTaiKhoan.setTitle("🛡️ Quản lý Tài khoản (Thêm mới, Đổi mật khẩu, Set quyền Admin) ▸", for: .normal)
        nutMoAdminTaiKhoan.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutMoAdminTaiKhoan.contentHorizontalAlignment = .left
        nutMoAdminTaiKhoan.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.12)
        nutMoAdminTaiKhoan.tintColor = .systemIndigo
        nutMoAdminTaiKhoan.layer.cornerRadius = 9
        nutMoAdminTaiKhoan.layer.borderWidth = 1
        nutMoAdminTaiKhoan.layer.borderColor = UIColor.systemIndigo.withAlphaComponent(0.28).cgColor
        nutMoAdminTaiKhoan.contentEdgeInsets = UIEdgeInsets(top: 9, left: 11, bottom: 9, right: 11)
        nutMoAdminTaiKhoan.addTarget(self, action: #selector(bamMoManHinhAdminTaiKhoan), for: .touchUpInside)

        nutDoiMatKhauNhanh.setTitle("🔑 Đổi mật khẩu", for: .normal)
        nutDoiMatKhauNhanh.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutDoiMatKhauNhanh.backgroundColor = .systemBackground
        nutDoiMatKhauNhanh.tintColor = .systemBlue
        nutDoiMatKhauNhanh.layer.cornerRadius = 8
        nutDoiMatKhauNhanh.layer.borderWidth = 1
        nutDoiMatKhauNhanh.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.24).cgColor
        nutDoiMatKhauNhanh.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutDoiMatKhauNhanh.addTarget(self, action: #selector(bamDoiMatKhauCaNhan), for: .touchUpInside)

        nutDangXuatNhanh.setTitle("🚪 Đăng xuất", for: .normal)
        nutDangXuatNhanh.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutDangXuatNhanh.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        nutDangXuatNhanh.tintColor = .systemRed
        nutDangXuatNhanh.layer.cornerRadius = 8
        nutDangXuatNhanh.layer.borderWidth = 1
        nutDangXuatNhanh.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.25).cgColor
        nutDangXuatNhanh.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutDangXuatNhanh.addTarget(self, action: #selector(bamDangXuatTaiKhoan), for: .touchUpInside)

        let hangNutTK = UIStackView(arrangedSubviews: [nutDoiMatKhauNhanh, nutDangXuatNhanh])
        hangNutTK.axis = .horizontal
        hangNutTK.spacing = 8
        hangNutTK.distribution = .fillEqually

        let nganTK = UIStackView(arrangedSubviews: [nhanThongTinTaiKhoan, nutMoAdminTaiKhoan, hangNutTK])
        nganTK.axis = .vertical
        nganTK.spacing = 7
        nganTK.translatesAutoresizingMaskIntoConstraints = false
        khungTK.addSubview(nganTK)

        // Khối 1 & 2: Chia Target mặt hàng & Quản lý danh sách nhân viên
        let tieuDeNV = taoTieuDeNhom("1 & 2. CHIA TARGET MẶT HÀNG & QUẢN LÝ NHÂN VIÊN")
        let khungNV = UIView()
        khungNV.backgroundColor = .secondarySystemGroupedBackground
        khungNV.layer.cornerRadius = 12

        [nutChiaTarget, nutQuanLyNV].forEach { nut in
            nut.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            nut.contentHorizontalAlignment = .left
            nut.backgroundColor = .systemBackground
            nut.tintColor = .systemBlue
            nut.layer.cornerRadius = 10
            nut.layer.borderWidth = 1
            nut.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.22).cgColor
            nut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        }
        nutChiaTarget.addTarget(self, action: #selector(moChiaTarget), for: .touchUpInside)
        nutQuanLyNV.addTarget(self, action: #selector(moQuanLyNhanVien), for: .touchUpInside)

        let nganNV = UIStackView(arrangedSubviews: [nutChiaTarget, nutQuanLyNV])
        nganNV.axis = .vertical
        nganNV.spacing = 7
        nganNV.translatesAutoresizingMaskIntoConstraints = false
        khungNV.addSubview(nganNV)

        // Khối 3: Chọn kiểu hiển thị & xuất báo cáo
        let tieuDeKieu = taoTieuDeNhom("3. KIỂU HIỂN THỊ & XUẤT BÁO CÁO")
        let khungKieu = UIView()
        khungKieu.backgroundColor = .secondarySystemGroupedBackground
        khungKieu.layer.cornerRadius = 12

        let nhanMoTaKieu = UILabel()
        nhanMoTaKieu.text = "Chọn 1 trong 2 mẫu hiển thị trên màn hình và khi xuất ảnh:"
        nhanMoTaKieu.font = .systemFont(ofSize: 12.5)
        nhanMoTaKieu.textColor = .secondaryLabel
        nhanMoTaKieu.numberOfLines = 0

        let nhanMoTaCot = UILabel()
        nhanMoTaCot.text = "Số cột khi xuất ảnh (áp dụng cho mẫu Thẻ tiến độ):"
        nhanMoTaCot.font = .systemFont(ofSize: 12.5)
        nhanMoTaCot.textColor = .secondaryLabel
        nhanMoTaCot.numberOfLines = 0

        let nganKieu = UIStackView(arrangedSubviews: [nhanMoTaKieu, chonKieuHienThi, nhanMoTaCot, chonSoCotXuat])
        nganKieu.axis = .vertical
        nganKieu.spacing = 6
        nganKieu.translatesAutoresizingMaskIntoConstraints = false
        khungKieu.addSubview(nganKieu)

        // Khối 4: Cụm từ lọc bỏ trong tất cả ngành hàng
        let tieuDeLoc = taoTieuDeNhom("4. CỤM TỪ LỌC BỎ TRONG TẤT CẢ NGÀNH HÀNG")
        let khungLoc = UIView()
        khungLoc.backgroundColor = .secondarySystemGroupedBackground
        khungLoc.layer.cornerRadius = 12
        khungLoc.clipsToBounds = true

        oNhapCumTu.placeholder = "Nhập cụm từ muốn lọc bỏ (VD: 275 Quang Trung)..."
        oNhapCumTu.borderStyle = .roundedRect
        oNhapCumTu.font = .systemFont(ofSize: 14)
        oNhapCumTu.clearButtonMode = .whileEditing
        oNhapCumTu.returnKeyType = .done
        oNhapCumTu.delegate = self

        let nutThem = UIButton(type: .system)
        nutThem.setTitle(" + Thêm ", for: .normal)
        nutThem.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutThem.backgroundColor = .systemBlue
        nutThem.tintColor = .white
        nutThem.layer.cornerRadius = 8
        nutThem.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        nutThem.addTarget(self, action: #selector(bamThemCumTu), for: .touchUpInside)
        nutThem.setContentHuggingPriority(.required, for: .horizontal)

        let hangNhap = UIStackView(arrangedSubviews: [oNhapCumTu, nutThem])
        hangNhap.axis = .horizontal
        hangNhap.spacing = 8

        let vachNgan = UIView()
        vachNgan.backgroundColor = .separator

        bangCumTu.dataSource = self
        bangCumTu.delegate = self
        bangCumTu.rowHeight = 40
        bangCumTu.backgroundColor = .clear
        bangCumTu.separatorInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        [hangNhap, vachNgan, bangCumTu].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungLoc.addSubview($0)
        }

        [tieuDeTK, khungTK, tieuDeNV, khungNV, tieuDeKieu, khungKieu, tieuDeLoc, khungLoc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tieuDeTK.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tieuDeTK.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeTK.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungTK.topAnchor.constraint(equalTo: tieuDeTK.bottomAnchor, constant: 4),
            khungTK.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungTK.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganTK.topAnchor.constraint(equalTo: khungTK.topAnchor, constant: 9),
            nganTK.leadingAnchor.constraint(equalTo: khungTK.leadingAnchor, constant: 10),
            nganTK.trailingAnchor.constraint(equalTo: khungTK.trailingAnchor, constant: -10),
            nganTK.bottomAnchor.constraint(equalTo: khungTK.bottomAnchor, constant: -9),

            tieuDeNV.topAnchor.constraint(equalTo: khungTK.bottomAnchor, constant: 10),
            tieuDeNV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeNV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungNV.topAnchor.constraint(equalTo: tieuDeNV.bottomAnchor, constant: 4),
            khungNV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungNV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganNV.topAnchor.constraint(equalTo: khungNV.topAnchor, constant: 9),
            nganNV.leadingAnchor.constraint(equalTo: khungNV.leadingAnchor, constant: 10),
            nganNV.trailingAnchor.constraint(equalTo: khungNV.trailingAnchor, constant: -10),
            nganNV.bottomAnchor.constraint(equalTo: khungNV.bottomAnchor, constant: -9),

            tieuDeKieu.topAnchor.constraint(equalTo: khungNV.bottomAnchor, constant: 10),
            tieuDeKieu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeKieu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungKieu.topAnchor.constraint(equalTo: tieuDeKieu.bottomAnchor, constant: 4),
            khungKieu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungKieu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganKieu.topAnchor.constraint(equalTo: khungKieu.topAnchor, constant: 9),
            nganKieu.leadingAnchor.constraint(equalTo: khungKieu.leadingAnchor, constant: 12),
            nganKieu.trailingAnchor.constraint(equalTo: khungKieu.trailingAnchor, constant: -12),
            nganKieu.bottomAnchor.constraint(equalTo: khungKieu.bottomAnchor, constant: -9),

            tieuDeLoc.topAnchor.constraint(equalTo: khungKieu.bottomAnchor, constant: 10),
            tieuDeLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungLoc.topAnchor.constraint(equalTo: tieuDeLoc.bottomAnchor, constant: 4),
            khungLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            khungLoc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),

            hangNhap.topAnchor.constraint(equalTo: khungLoc.topAnchor, constant: 8),
            hangNhap.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor, constant: 12),
            hangNhap.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor, constant: -12),

            vachNgan.topAnchor.constraint(equalTo: hangNhap.bottomAnchor, constant: 8),
            vachNgan.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor),
            vachNgan.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor),
            vachNgan.heightAnchor.constraint(equalToConstant: 0.5),

            bangCumTu.topAnchor.constraint(equalTo: vachNgan.bottomAnchor),
            bangCumTu.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor),
            bangCumTu.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor),
            bangCumTu.bottomAnchor.constraint(equalTo: khungLoc.bottomAnchor)
        ])
    }

    @objc private func bamThemCumTu() {
        let chu = oNhapCumTu.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !chu.isEmpty else { return }
        if !danhSachCumTu.contains(where: { $0.caseInsensitiveCompare(chu) == .orderedSame }) {
            danhSachCumTu.insert(chu, at: 0)
            bangCumTu.reloadData()
        }
        oNhapCumTu.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bamThemCumTu()
        textField.resignFirstResponder()
        return true
    }

    @objc private func luuCaiDat() {
        dongBoTamCaiDat()
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(1, danhSachCumTu.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "CumTuLocCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .value1, reuseIdentifier: ma)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        if danhSachCumTu.isEmpty {
            cell.textLabel?.text = "Chưa có cụm từ lọc bỏ nào"
            cell.textLabel?.textColor = .secondaryLabel
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.detailTextLabel?.text = nil
            cell.accessoryView = nil
        } else {
            let cumTu = danhSachCumTu[indexPath.row]
            cell.textLabel?.text = "\"\(cumTu)\""
            cell.textLabel?.textColor = .label
            cell.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)

            let nutXoa = UIButton(type: .system)
            nutXoa.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            nutXoa.tintColor = .systemRed
            nutXoa.tag = indexPath.row
            nutXoa.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            nutXoa.addTarget(self, action: #selector(xoaCumTuTai(_:)), for: .touchUpInside)
            cell.accessoryView = nutXoa
        }
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !danhSachCumTu.isEmpty else { return nil }
        let xoa = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, hoanTat in
            self?.danhSachCumTu.remove(at: indexPath.row)
            self?.bangCumTu.reloadData()
            hoanTat(true)
        }
        return UISwipeActionsConfiguration(actions: [xoa])
    }

    @objc private func xoaCumTuTai(_ sender: UIButton) {
        let idx = sender.tag
        guard idx >= 0 && idx < danhSachCumTu.count else { return }
        danhSachCumTu.remove(at: idx)
        bangCumTu.reloadData()
    }

    private func taoTieuDeNhom(_ chu: String) -> UILabel {
        let nhan = UILabel()
        nhan.text = chu
        nhan.font = .systemFont(ofSize: 11.5, weight: .bold)
        nhan.textColor = .secondaryLabel
        return nhan
    }
}

// MARK: - Màn hình Quản lý Tài khoản & Phân quyền Admin

final class ManHinhQuanLyTaiKhoan: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var danhSach: [ThongTinTaiKhoanDMX] = []
    private let nhanTomTat = UILabel()
    private let nutThemTaiKhoan = UIButton(type: .system)
    private let bang = UITableView(frame: .zero, style: .insetGrouped)
    private let vongQuay = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quản lý Tài khoản"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(taiDanhSach)
        )

        taoGiaoDien()
        taiDanhSach()
    }

    private func taoGiaoDien() {
        let khungDau = UIView()
        khungDau.backgroundColor = .secondarySystemGroupedBackground
        khungDau.layer.cornerRadius = 12

        nhanTomTat.text = "Chạm vào từng tài khoản bên dưới để Đổi mật khẩu, Set/Gỡ quyền Admin hoặc Xoá."
        nhanTomTat.font = .systemFont(ofSize: 13, weight: .medium)
        nhanTomTat.textColor = .secondaryLabel
        nhanTomTat.numberOfLines = 0

        nutThemTaiKhoan.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        nutThemTaiKhoan.setTitle(" Thêm tài khoản mới", for: .normal)
        nutThemTaiKhoan.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutThemTaiKhoan.backgroundColor = .systemBlue
        nutThemTaiKhoan.tintColor = .white
        nutThemTaiKhoan.layer.cornerRadius = 10
        nutThemTaiKhoan.contentEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
        nutThemTaiKhoan.addTarget(self, action: #selector(bamThemTaiKhoanMoi), for: .touchUpInside)

        let nganDau = UIStackView(arrangedSubviews: [nhanTomTat, nutThemTaiKhoan])
        nganDau.axis = .vertical
        nganDau.spacing = 10
        nganDau.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(nganDau)

        bang.dataSource = self
        bang.delegate = self
        bang.rowHeight = 62

        vongQuay.hidesWhenStopped = true

        [khungDau, bang, vongQuay].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungDau.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            khungDau.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            khungDau.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            nganDau.topAnchor.constraint(equalTo: khungDau.topAnchor, constant: 12),
            nganDau.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor, constant: 12),
            nganDau.trailingAnchor.constraint(equalTo: khungDau.trailingAnchor, constant: -12),
            nganDau.bottomAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: -12),

            bang.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 6),
            bang.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bang.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            vongQuay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vongQuay.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func taiDanhSach() {
        vongQuay.startAnimating()
        nhanTomTat.text = "Đang tải danh sách tài khoản..."
        DichVuDongBo.dungChung.layDanhSachTaiKhoan { [weak self] kq in
            guard let self else { return }
            self.vongQuay.stopAnimating()
            switch kq {
            case .success(let ds):
                self.danhSach = ds
                let soAdmin = ds.filter { $0.laAdmin }.count
                let soThuong = ds.count - soAdmin
                self.nhanTomTat.text = "Tổng \(ds.count) tài khoản (\(soAdmin) Admin, \(soThuong) tài khoản thường).\nChạm vào tài khoản bên dưới để Đổi mật khẩu, Set quyền Admin hoặc Xoá."
                self.bang.reloadData()
            case .failure(let loi):
                self.hienThongBao(tieuDe: "Lỗi tải danh sách", noiDung: loi.localizedDescription)
            }
        }
    }

    @objc private func bamThemTaiKhoanMoi() {
        let hop = UIAlertController(
            title: "➕ Thêm tài khoản mới",
            message: "Nhập tên đăng nhập (3–40 ký tự) và mật khẩu (tối thiểu 6 ký tự):",
            preferredStyle: .alert
        )
        hop.addTextField { o in
            o.placeholder = "Tên đăng nhập"
            o.autocapitalizationType = .none
            o.autocorrectionType = .no
        }
        hop.addTextField { o in
            o.placeholder = "Mật khẩu (tối thiểu 6 ký tự)"
            o.isSecureTextEntry = true
        }
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        hop.addAction(UIAlertAction(title: "👤 Tạo Tài khoản thường", style: .default) { [weak self, weak hop] _ in
            guard let self, let hop else { return }
            self.thucHienTaoTaiKhoan(hop: hop, laAdmin: false)
        })
        hop.addAction(UIAlertAction(title: "🛡️ Tạo & Set quyền Admin", style: .default) { [weak self, weak hop] _ in
            guard let self, let hop else { return }
            self.thucHienTaoTaiKhoan(hop: hop, laAdmin: true)
        })
        present(hop, animated: true)
    }

    private func thucHienTaoTaiKhoan(hop: UIAlertController, laAdmin: Bool) {
        let ten = hop.textFields?[0].text ?? ""
        let mk = hop.textFields?[1].text ?? ""
        vongQuay.startAnimating()
        DichVuDongBo.dungChung.adminTaoTaiKhoanMoi(tenDangNhap: ten, matKhau: mk, laAdmin: laAdmin) { [weak self] kq in
            guard let self else { return }
            self.vongQuay.stopAnimating()
            switch kq {
            case .success(let tk):
                self.taiDanhSach()
                self.hienThongBao(
                    tieuDe: "✅ Đã tạo tài khoản",
                    noiDung: "Tài khoản \"\(tk.tenDangNhap)\" (\(tk.laAdmin ? "Admin" : "Tài khoản thường")) đã sẵn sàng đăng nhập."
                )
            case .failure(let loi):
                self.hienThongBao(tieuDe: "Chưa tạo được tài khoản", noiDung: loi.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSach.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "DANH SÁCH TÀI KHOẢN (\(danhSach.count))"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "TaiKhoanAdminCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .subtitle, reuseIdentifier: ma)
        let tk = danhSach[indexPath.row]
        let nhanQuyen = tk.laAdmin ? "🛡️ Quản trị viên (Admin)" : "👤 Tài khoản thường"
        cell.textLabel?.text = "\(tk.tenDangNhap)   —   \(nhanQuyen)"
        cell.textLabel?.font = .systemFont(ofSize: 14.5, weight: .bold)
        cell.textLabel?.textColor = tk.laAdmin ? .systemIndigo : .label
        cell.detailTextLabel?.text = "Tạo: \(tk.ngayTao)   •   Đăng nhập cuối: \(tk.dangNhapCuoi)"
        cell.detailTextLabel?.font = .systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moMenuTacVuChoTaiKhoan(danhSach[indexPath.row])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tk = danhSach[indexPath.row]
        guard tk.tenDangNhap.lowercased() != "duongnt" else { return nil }
        let xoa = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, hoanTat in
            self?.xacNhanXoaTaiKhoan(tk)
            hoanTat(true)
        }
        return UISwipeActionsConfiguration(actions: [xoa])
    }

    private func moMenuTacVuChoTaiKhoan(_ tk: ThongTinTaiKhoanDMX) {
        let quyenHienTai = tk.laAdmin ? "Quản trị viên (Admin)" : "Tài khoản thường"
        let menu = UIAlertController(
            title: "Tài khoản: \(tk.tenDangNhap)",
            message: "Quyền hiện tại: \(quyenHienTai)",
            preferredStyle: .actionSheet
        )
        menu.addAction(UIAlertAction(title: "🔑 Đổi mật khẩu cho \"\(tk.tenDangNhap)\"", style: .default) { [weak self] _ in
            self?.moHopThoaiDoiMatKhau(cho: tk)
        })
        if tk.laAdmin {
            if tk.tenDangNhap.lowercased() != "duongnt" {
                menu.addAction(UIAlertAction(title: "👤 Gỡ quyền Admin (Chuyển về Tài khoản thường)", style: .default) { [weak self] _ in
                    self?.thucHienDoiQuyenAdmin(cho: tk, laAdmin: false)
                })
            }
        } else {
            menu.addAction(UIAlertAction(title: "🛡️ Set quyền Admin cho \"\(tk.tenDangNhap)\"", style: .default) { [weak self] _ in
                self?.thucHienDoiQuyenAdmin(cho: tk, laAdmin: true)
            })
        }
        if tk.tenDangNhap.lowercased() != "duongnt" {
            menu.addAction(UIAlertAction(title: "🗑️ Xoá tài khoản \"\(tk.tenDangNhap)\"", style: .destructive) { [weak self] _ in
                self?.xacNhanXoaTaiKhoan(tk)
            })
        }
        menu.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = menu.popoverPresentationController {
            pop.sourceView = view
            pop.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
        }
        present(menu, animated: true)
    }

    private func moHopThoaiDoiMatKhau(cho tk: ThongTinTaiKhoanDMX) {
        let hop = UIAlertController(
            title: "🔑 Đổi mật khẩu: \(tk.tenDangNhap)",
            message: "Nhập mật khẩu mới cho tài khoản \"\(tk.tenDangNhap)\" (tối thiểu 6 ký tự):",
            preferredStyle: .alert
        )
        hop.addTextField { o in
            o.placeholder = "Mật khẩu mới (tối thiểu 6 ký tự)"
            o.isSecureTextEntry = true
        }
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        hop.addAction(UIAlertAction(title: "Lưu mật khẩu mới", style: .default) { [weak self, weak hop] _ in
            guard let self, let hop else { return }
            let mk = hop.textFields?.first?.text ?? ""
            guard mk.count >= 6 else {
                self.hienThongBao(tieuDe: "Mật khẩu quá ngắn", noiDung: "Mật khẩu mới cần có ít nhất 6 ký tự.")
                return
            }
            self.vongQuay.startAnimating()
            DichVuDongBo.dungChung.adminDoiMatKhau(userId: tk.id, matKhauMoi: mk) { [weak self] kq in
                guard let self else { return }
                self.vongQuay.stopAnimating()
                switch kq {
                case .success:
                    self.hienThongBao(tieuDe: "✅ Đã đổi mật khẩu", noiDung: "Đã cập nhật mật khẩu mới cho tài khoản \"\(tk.tenDangNhap)\".")
                case .failure(let loi):
                    self.hienThongBao(tieuDe: "Lỗi đổi mật khẩu", noiDung: loi.localizedDescription)
                }
            }
        })
        present(hop, animated: true)
    }

    private func thucHienDoiQuyenAdmin(cho tk: ThongTinTaiKhoanDMX, laAdmin: Bool) {
        vongQuay.startAnimating()
        DichVuDongBo.dungChung.adminDatQuyenAdmin(taiKhoan: tk, laAdmin: laAdmin) { [weak self] kq in
            guard let self else { return }
            self.vongQuay.stopAnimating()
            switch kq {
            case .success:
                self.taiDanhSach()
                let msg = laAdmin
                    ? "Đã cấp quyền Admin cho tài khoản \"\(tk.tenDangNhap)\"."
                    : "Đã chuyển tài khoản \"\(tk.tenDangNhap)\" về Tài khoản thường."
                self.hienThongBao(tieuDe: "✅ Đã cập nhật quyền", noiDung: msg)
            case .failure(let loi):
                self.hienThongBao(tieuDe: "Không thể đổi quyền", noiDung: loi.localizedDescription)
            }
        }
    }

    private func xacNhanXoaTaiKhoan(_ tk: ThongTinTaiKhoanDMX) {
        guard tk.tenDangNhap.lowercased() != "duongnt" else {
            hienThongBao(tieuDe: "Lỗi xoá tài khoản", noiDung: "Không thể xoá tài khoản Admin gốc \"duongnt\".")
            return
        }
        let hop = UIAlertController(
            title: "Xoá tài khoản \"\(tk.tenDangNhap)\"?",
            message: "Tài khoản này và phiên đăng nhập của nó sẽ bị xoá khỏi hệ thống.",
            preferredStyle: .alert
        )
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        hop.addAction(UIAlertAction(title: "Xoá tài khoản", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.vongQuay.startAnimating()
            DichVuDongBo.dungChung.adminXoaTaiKhoan(taiKhoan: tk) { [weak self] kq in
                guard let self else { return }
                self.vongQuay.stopAnimating()
                switch kq {
                case .success:
                    self.taiDanhSach()
                case .failure(let loi):
                    self.hienThongBao(tieuDe: "Lỗi xoá tài khoản", noiDung: loi.localizedDescription)
                }
            }
        })
        present(hop, animated: true)
    }

    private func hienThongBao(tieuDe: String, noiDung: String) {
        let tb = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(tb, animated: true)
    }
}
