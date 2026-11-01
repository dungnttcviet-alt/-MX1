import UIKit

final class ManHinhCaiDat: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let ngay: Date
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
        title = "Cài đặt & Nhân viên"
        view.backgroundColor = .systemGroupedBackground

        let nutLuu = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(luuCaiDat)
        )
        let nutTaiKhoan = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(moQuanLyTaiKhoan)
        )
        nutTaiKhoan.tintColor = .systemRed
        navigationItem.rightBarButtonItems = [nutLuu, nutTaiKhoan]

        let cd = KhoDuLieu.dungChung.caiDat
        chonKieuHienThi.selectedSegmentIndex = cd.kieuHienThi.rawValue
        danhSachCumTu = cd.danhSachCumTuLocBo
        let chiSoCot = max(0, min(3, cd.soCotXuatAnh - 1))
        chonSoCotXuat.selectedSegmentIndex = chiSoCot

        taoGiaoDien()
        capNhatTieuDeNutNhanVien()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        capNhatTieuDeNutNhanVien()
    }

    private func capNhatTieuDeNutNhanVien() {
        let cd = KhoDuLieu.dungChung.caiDat
        let soMH = KhoDuLieu.dungChung.danhSachMatHangThang(den: ngay).count
        nutChiaTarget.setTitle("🎯 1. Chia Target mặt hàng (\(soMH) mặt hàng) ▸", for: .normal)
        nutQuanLyNV.setTitle("👥 2. Danh sách nhân viên quản lý (\(cd.danhSachNhanVien.count) NV) ▸", for: .normal)
    }

    @objc private func moQuanLyTaiKhoan() {
        let tk = DichVuDongBo.dungChung.tenDangNhap.isEmpty ? "Tài khoản" : DichVuDongBo.dungChung.tenDangNhap
        let menu = UIAlertController(
            title: "Tài khoản ĐMX: \(tk)",
            message: "Dữ liệu được đồng bộ tự động với nhánh duongnt.io.vn/dmx.",
            preferredStyle: .actionSheet
        )
        menu.addAction(UIAlertAction(title: "🔄 Đồng bộ dữ liệu ngay", style: .default) { _ in
            DichVuDongBo.dungChung.taiDuLieu()
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
            nut.contentEdgeInsets = UIEdgeInsets(top: 11, left: 12, bottom: 11, right: 12)
        }
        nutChiaTarget.addTarget(self, action: #selector(moChiaTarget), for: .touchUpInside)
        nutQuanLyNV.addTarget(self, action: #selector(moQuanLyNhanVien), for: .touchUpInside)

        let nganNV = UIStackView(arrangedSubviews: [nutChiaTarget, nutQuanLyNV])
        nganNV.axis = .vertical
        nganNV.spacing = 8
        nganNV.translatesAutoresizingMaskIntoConstraints = false
        khungNV.addSubview(nganNV)

        // Khối 3: Chọn kiểu hiển thị & xuất báo cáo
        let tieuDeKieu = taoTieuDeNhom("3. KIỂU HIỂN THỊ & XUẤT BÁO CÁO")
        let khungKieu = UIView()
        khungKieu.backgroundColor = .secondarySystemGroupedBackground
        khungKieu.layer.cornerRadius = 12

        let nhanMoTaKieu = UILabel()
        nhanMoTaKieu.text = "Chọn 1 trong 2 mẫu hiển thị trên màn hình và khi xuất ảnh:"
        nhanMoTaKieu.font = .systemFont(ofSize: 13)
        nhanMoTaKieu.textColor = .secondaryLabel
        nhanMoTaKieu.numberOfLines = 0

        let nhanMoTaCot = UILabel()
        nhanMoTaCot.text = "Số cột khi xuất ảnh (áp dụng cho mẫu Thẻ tiến độ):"
        nhanMoTaCot.font = .systemFont(ofSize: 13)
        nhanMoTaCot.textColor = .secondaryLabel
        nhanMoTaCot.numberOfLines = 0

        let nganKieu = UIStackView(arrangedSubviews: [nhanMoTaKieu, chonKieuHienThi, nhanMoTaCot, chonSoCotXuat])
        nganKieu.axis = .vertical
        nganKieu.spacing = 8
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
        bangCumTu.rowHeight = 42
        bangCumTu.backgroundColor = .clear
        bangCumTu.separatorInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        [hangNhap, vachNgan, bangCumTu].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungLoc.addSubview($0)
        }

        [tieuDeNV, khungNV, tieuDeKieu, khungKieu, tieuDeLoc, khungLoc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tieuDeNV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tieuDeNV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeNV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungNV.topAnchor.constraint(equalTo: tieuDeNV.bottomAnchor, constant: 6),
            khungNV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungNV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganNV.topAnchor.constraint(equalTo: khungNV.topAnchor, constant: 10),
            nganNV.leadingAnchor.constraint(equalTo: khungNV.leadingAnchor, constant: 10),
            nganNV.trailingAnchor.constraint(equalTo: khungNV.trailingAnchor, constant: -10),
            nganNV.bottomAnchor.constraint(equalTo: khungNV.bottomAnchor, constant: -10),

            tieuDeKieu.topAnchor.constraint(equalTo: khungNV.bottomAnchor, constant: 12),
            tieuDeKieu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeKieu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungKieu.topAnchor.constraint(equalTo: tieuDeKieu.bottomAnchor, constant: 6),
            khungKieu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungKieu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganKieu.topAnchor.constraint(equalTo: khungKieu.topAnchor, constant: 10),
            nganKieu.leadingAnchor.constraint(equalTo: khungKieu.leadingAnchor, constant: 12),
            nganKieu.trailingAnchor.constraint(equalTo: khungKieu.trailingAnchor, constant: -12),
            nganKieu.bottomAnchor.constraint(equalTo: khungKieu.bottomAnchor, constant: -10),

            tieuDeLoc.topAnchor.constraint(equalTo: khungKieu.bottomAnchor, constant: 12),
            tieuDeLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungLoc.topAnchor.constraint(equalTo: tieuDeLoc.bottomAnchor, constant: 6),
            khungLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            khungLoc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            hangNhap.topAnchor.constraint(equalTo: khungLoc.topAnchor, constant: 10),
            hangNhap.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor, constant: 12),
            hangNhap.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor, constant: -12),

            vachNgan.topAnchor.constraint(equalTo: hangNhap.bottomAnchor, constant: 10),
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
