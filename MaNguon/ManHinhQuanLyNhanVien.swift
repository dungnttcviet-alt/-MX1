import UIKit

// MARK: - 1. Màn hình Quản lý Nhân viên (Thêm / Sửa / Xoá / Dán nhanh nhiều NV / Nạp 16 NV mẫu)

final class ManHinhQuanLyNhanVien: UITableViewController {
    private var danhSach = KhoDuLieu.dungChung.caiDat.danhSachNhanVien
    var khiLuuXong: (([NhanVienQuanLy]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nhân viên (\(danhSach.count))"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(luu)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(them)),
            UIBarButtonItem(image: UIImage(systemName: "doc.on.clipboard"), style: .plain, target: self, action: #selector(moMenuTienIch))
        ]
    }

    @objc private func moMenuTienIch() {
        let sheet = UIAlertController(title: "Quản lý danh sách nhân viên", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "📋 Dán nhanh nhiều nhân viên", style: .default) { [weak self] _ in
            self?.hienDanNhanhNhanVien()
        })
        sheet.addAction(UIAlertAction(title: "👥 Nạp 16 NV mẫu siêu thị", style: .default) { [weak self] _ in
            self?.napMau()
        })
        sheet.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = sheet.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(sheet, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(1, danhSach.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NV") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "NV")
        guard !danhSach.isEmpty else {
            cell.textLabel?.text = "Chưa có nhân viên nào. Hãy thêm hoặc nạp mẫu."
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .none
            return cell
        }
        let nv = danhSach[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(nv.hoTen)"
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        cell.detailTextLabel?.text = "Mã số: \(nv.maNV)"
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < danhSach.count else { return }
        sua(indexPath.row)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, indexPath.row < danhSach.count {
            danhSach.remove(at: indexPath.row)
            title = "Nhân viên (\(danhSach.count))"
            tableView.reloadData()
        }
    }

    @objc private func them() { hienForm(index: nil) }
    private func sua(_ index: Int) { hienForm(index: index) }

    private func hienForm(index: Int?) {
        let cu = index.map { danhSach[$0] }
        let hop = UIAlertController(title: cu == nil ? "Thêm nhân viên" : "Sửa nhân viên", message: nil, preferredStyle: .alert)
        hop.addTextField {
            $0.placeholder = "Mã số (VD: 24939)"
            $0.text = cu?.maNV
            $0.keyboardType = .numberPad
        }
        hop.addTextField {
            $0.placeholder = "Họ và tên (VD: Phan Hoàng Sơn)"
            $0.text = cu?.hoTen
            $0.autocapitalizationType = .words
        }
        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self, let fields = hop.textFields else { return }
            let ma = (fields[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let ten = (fields[1].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard !ma.isEmpty, !ten.isEmpty else { return }
            let moi = NhanVienQuanLy(maNV: ma, hoTen: ten)
            if let index {
                self.danhSach[index] = moi
            } else if let viTri = self.danhSach.firstIndex(where: { $0.maNV == ma }) {
                self.danhSach[viTri] = moi
            } else {
                self.danhSach.append(moi)
            }
            self.title = "Nhân viên (\(self.danhSach.count))"
            self.tableView.reloadData()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func hienDanNhanhNhanVien() {
        let hop = UIAlertController(
            title: "Dán nhanh nhiều nhân viên",
            message: "Dán từ bộ nhớ tạm hoặc nhập (ví dụ: 24939 - Phan Hoàng Sơn):",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "24939 - Phan Hoàng Sơn..."
            if let clip = UIPasteboard.general.string, !clip.isEmpty {
                tf.text = clip
            }
        }
        hop.addAction(UIAlertAction(title: "Nhập từ ô / Clipboard", style: .default) { [weak self] _ in
            guard let self else { return }
            let raw = (hop.textFields?.first?.text ?? UIPasteboard.general.string ?? "")
            self.xuLyChuoiDanNhanh(raw)
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func xuLyChuoiDanNhanh(_ chuoi: String) {
        let cacDong = chuoi
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        guard !cacDong.isEmpty else { return }

        var nvMoi: [NhanVienQuanLy] = []
        let regDau = try? NSRegularExpression(pattern: "^(\\d{3,10})\\s*[-–:\\t|,]\\s*(.+)$")
        let regCuoi = try? NSRegularExpression(pattern: "^(.+?)\\s*[-–:\\t|,]\\s*(\\d{3,10})$")

        for dong in cacDong {
            let ns = dong as NSString
            let range = NSRange(location: 0, length: ns.length)
            if let m = regDau?.firstMatch(in: dong, range: range) {
                let ma = ns.substring(with: m.range(at: 1)).trimmingCharacters(in: .whitespaces)
                let ten = ns.substring(with: m.range(at: 2)).trimmingCharacters(in: .whitespaces)
                nvMoi.append(NhanVienQuanLy(maNV: ma, hoTen: ten))
            } else if let m = regCuoi?.firstMatch(in: dong, range: range) {
                let ten = ns.substring(with: m.range(at: 1)).trimmingCharacters(in: .whitespaces)
                let ma = ns.substring(with: m.range(at: 2)).trimmingCharacters(in: .whitespaces)
                nvMoi.append(NhanVienQuanLy(maNV: ma, hoTen: ten))
            }
        }
        guard !nvMoi.isEmpty else { return }

        for nv in nvMoi {
            if let i = danhSach.firstIndex(where: { $0.maNV == nv.maNV }) {
                danhSach[i] = nv
            } else {
                danhSach.append(nv)
            }
        }
        title = "Nhân viên (\(danhSach.count))"
        tableView.reloadData()
    }

    @objc private func napMau() {
        danhSach = CaiDatDMX.nhanVienMau
        title = "Nhân viên (\(danhSach.count))"
        tableView.reloadData()
    }

    @objc private func luu() {
        var cd = KhoDuLieu.dungChung.caiDat
        cd.danhSachNhanVien = danhSach
        cd.chiaTargetNganhHang = cd.chiaTargetNganhHang.mapValues { ds in
            ds.filter { ma in danhSach.contains { $0.maNV == ma } }
        }
        KhoDuLieu.dungChung.luuCaiDat(cd)
        khiLuuXong?(danhSach)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - 2. Màn hình Chia Target Mặt Hàng Cho Nhân Viên (Từ ngày 1 đến hiện tại)
// (Tương đương phần 1 của ModalCaiDatDMX trong dmx-settings-modal.tsx)

final class ManHinhChiaTarget: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let ngay: Date
    private var caiDat = KhoDuLieu.dungChung.caiDat
    private var danhSachMatHang: [DongThiDua] = []
    private var chiSoMatHangDangChon: Int = 0

    private let nutChonMatHang = UIButton(type: .system)
    private let nhanTomTat = UILabel()
    private let bang = UITableView(frame: .zero, style: .insetGrouped)

    init(ngay: Date = Date(), khoaNganhChonMacDinh: String? = nil) {
        self.ngay = ngay
        super.init(nibName: nil, bundle: nil)
        self.danhSachMatHang = KhoDuLieu.dungChung.danhSachMatHangThang(den: ngay)
        if let khoa = khoaNganhChonMacDinh,
           let idx = danhSachMatHang.firstIndex(where: { KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) == khoa }) {
            self.chiSoMatHangDangChon = idx
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chia Target Mặt Hàng"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(luu))
        taoGiaoDien()
        capNhatGiaoDien()
    }

    private func taoGiaoDien() {
        let khungTren = UIView()
        khungTren.backgroundColor = .secondarySystemGroupedBackground
        khungTren.layer.cornerRadius = 12

        nutChonMatHang.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutChonMatHang.titleLabel?.numberOfLines = 2
        nutChonMatHang.contentHorizontalAlignment = .left
        nutChonMatHang.backgroundColor = .systemBackground
        nutChonMatHang.tintColor = .systemBlue
        nutChonMatHang.layer.cornerRadius = 10
        nutChonMatHang.layer.borderWidth = 1
        nutChonMatHang.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        nutChonMatHang.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        nutChonMatHang.addTarget(self, action: #selector(bamChonMatHang), for: .touchUpInside)

        nhanTomTat.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanTomTat.textColor = .secondaryLabel
        nhanTomTat.numberOfLines = 2

        let nutChonHet = UIButton(type: .system)
        nutChonHet.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        nutChonHet.setTitle(" Chọn tất cả", for: .normal)
        nutChonHet.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutChonHet.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        nutChonHet.tintColor = .systemBlue
        nutChonHet.layer.cornerRadius = 8
        nutChonHet.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutChonHet.addTarget(self, action: #selector(chonTatCa), for: .touchUpInside)

        let nutBoHet = UIButton(type: .system)
        nutBoHet.setImage(UIImage(systemName: "square"), for: .normal)
        nutBoHet.setTitle(" Bỏ chọn tất cả", for: .normal)
        nutBoHet.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .bold)
        nutBoHet.backgroundColor = UIColor.systemGray5
        nutBoHet.tintColor = .label
        nutBoHet.layer.cornerRadius = 8
        nutBoHet.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutBoHet.addTarget(self, action: #selector(boChonTatCa), for: .touchUpInside)

        let hangNutNhanh = UIStackView(arrangedSubviews: [nutChonHet, nutBoHet])
        hangNutNhanh.axis = .horizontal
        hangNutNhanh.spacing = 8
        hangNutNhanh.distribution = .fillEqually

        let nganTren = UIStackView(arrangedSubviews: [nutChonMatHang, nhanTomTat, hangNutNhanh])
        nganTren.axis = .vertical
        nganTren.spacing = 8
        nganTren.translatesAutoresizingMaskIntoConstraints = false
        khungTren.addSubview(nganTren)

        bang.dataSource = self
        bang.delegate = self

        [khungTren, bang].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungTren.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            khungTren.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungTren.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganTren.topAnchor.constraint(equalTo: khungTren.topAnchor, constant: 12),
            nganTren.leadingAnchor.constraint(equalTo: khungTren.leadingAnchor, constant: 12),
            nganTren.trailingAnchor.constraint(equalTo: khungTren.trailingAnchor, constant: -12),
            nganTren.bottomAnchor.constraint(equalTo: khungTren.bottomAnchor, constant: -12),

            bang.topAnchor.constraint(equalTo: khungTren.bottomAnchor, constant: 4),
            bang.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bang.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private var matHangHienTai: DongThiDua? {
        guard chiSoMatHangDangChon >= 0 && chiSoMatHangDangChon < danhSachMatHang.count else { return nil }
        return danhSachMatHang[chiSoMatHangDangChon]
    }

    private func capNhatGiaoDien() {
        guard let mh = matHangHienTai else {
            nutChonMatHang.setTitle("Chưa có mặt hàng nào được quét trong tháng", for: .normal)
            nhanTomTat.text = "Hãy quét ảnh Thi đua trước để chia Target cho nhân viên."
            bang.reloadData()
            return
        }
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(mh.tenNganhHang)
        let dsChon = caiDat.chiaTargetNganhHang[khoa] ?? caiDat.danhSachNhanVien.map(\.maNV)
        let soNV = dsChon.count
        let moiNV = soNV > 0 ? mh.target / Double(soNV) : 0

        nutChonMatHang.setTitle("📦 \(mh.tenNganhHang) ▾", for: .normal)
        nhanTomTat.text = "Target tổng: \(mh.target.chuoiSoGonVN) (\(mh.loaiChiTieu.maBang))  •  Đã chọn: \(soNV)/\(caiDat.danhSachNhanVien.count) NV  →  Mỗi NV: \(moiNV.chuoiSoVN)"
        bang.reloadData()
    }

    @objc private func bamChonMatHang() {
        guard !danhSachMatHang.isEmpty else { return }
        let sheet = UIAlertController(title: "Chọn mặt hàng (\(danhSachMatHang.count) mặt hàng)", message: nil, preferredStyle: .actionSheet)
        for (i, mh) in danhSachMatHang.enumerated() {
            let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(mh.tenNganhHang)
            let dsChon = caiDat.chiaTargetNganhHang[khoa] ?? caiDat.danhSachNhanVien.map(\.maNV)
            let moiNV = dsChon.isEmpty ? 0 : mh.target / Double(dsChon.count)
            let tieuDe = "\(mh.tenNganhHang) — Target: \(mh.target.chuoiSoGonVN) (\(dsChon.count) NV → \(moiNV.chuoiSoGonVN)/NV)"
            sheet.addAction(UIAlertAction(title: tieuDe, style: .default) { [weak self] _ in
                self?.chiSoMatHangDangChon = i
                self?.capNhatGiaoDien()
            })
        }
        sheet.addAction(UIAlertAction(title: "Đóng", style: .cancel))
        if let pop = sheet.popoverPresentationController {
            pop.sourceView = nutChonMatHang
            pop.sourceRect = nutChonMatHang.bounds
        }
        present(sheet, animated: true)
    }

    @objc private func chonTatCa() {
        guard let mh = matHangHienTai else { return }
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(mh.tenNganhHang)
        caiDat.chiaTargetNganhHang[khoa] = caiDat.danhSachNhanVien.map(\.maNV)
        capNhatGiaoDien()
    }

    @objc private func boChonTatCa() {
        guard let mh = matHangHienTai else { return }
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(mh.tenNganhHang)
        caiDat.chiaTargetNganhHang[khoa] = []
        capNhatGiaoDien()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matHangHienTai == nil ? 0 : caiDat.danhSachNhanVien.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chia") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Chia")
        guard let mh = matHangHienTai else { return cell }
        let nv = caiDat.danhSachNhanVien[indexPath.row]
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(mh.tenNganhHang)
        let ds = caiDat.chiaTargetNganhHang[khoa] ?? caiDat.danhSachNhanVien.map(\.maNV)
        let checked = ds.contains(nv.maNV)
        let moiNV = ds.isEmpty ? 0 : mh.target / Double(ds.count)

        cell.textLabel?.text = "\(nv.maNV) - \(nv.hoTen)"
        cell.textLabel?.font = .systemFont(ofSize: 14.5, weight: .bold)
        cell.detailTextLabel?.text = "Target: \(checked ? moiNV.chuoiSoVN : "0")"
        cell.detailTextLabel?.textColor = checked ? .systemBlue : .secondaryLabel
        cell.accessoryType = checked ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let mh = matHangHienTai, indexPath.row < caiDat.danhSachNhanVien.count else { return }
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(mh.tenNganhHang)
        let ma = caiDat.danhSachNhanVien[indexPath.row].maNV
        var ds = caiDat.chiaTargetNganhHang[khoa] ?? caiDat.danhSachNhanVien.map(\.maNV)
        if let i = ds.firstIndex(of: ma) {
            ds.remove(at: i)
        } else {
            ds.append(ma)
        }
        caiDat.chiaTargetNganhHang[khoa] = ds
        capNhatGiaoDien()
    }

    @objc private func luu() {
        KhoDuLieu.dungChung.luuCaiDat(caiDat)
        navigationController?.popViewController(animated: true)
    }
}
