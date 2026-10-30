import UIKit

final class ManHinhCaiDat: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let chonSoCotXuat = UISegmentedControl(items: ["1 cột", "2 cột", "3 cột", "4 cột"])
    private let oNhapCumTu = UITextField()
    private let bangCumTu = UITableView(frame: .zero, style: .plain)
    private var danhSachCumTu: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cài đặt"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(luuCaiDat)
        )

        let cd = KhoDuLieu.dungChung.caiDat
        danhSachCumTu = cd.danhSachCumTuLocBo
        let chiSoCot = max(0, min(3, cd.soCotXuatAnh - 1))
        chonSoCotXuat.selectedSegmentIndex = chiSoCot

        taoGiaoDien()
    }

    private func taoGiaoDien() {
        // 1. Khối chọn số cột khi Xuất ảnh báo cáo
        let tieuDeCot = taoTieuDeNhom("1. SỐ CỘT KHI XUẤT ẢNH BÁO CÁO")
        let khungCot = UIView()
        khungCot.backgroundColor = .secondarySystemGroupedBackground
        khungCot.layer.cornerRadius = 12

        let nhanMoTaCot = UILabel()
        nhanMoTaCot.text = "Chọn số cột thẻ Thi đua khi xuất ra ảnh báo cáo tổng hợp:"
        nhanMoTaCot.font = .systemFont(ofSize: 13)
        nhanMoTaCot.textColor = .secondaryLabel
        nhanMoTaCot.numberOfLines = 0

        let nganCot = UIStackView(arrangedSubviews: [nhanMoTaCot, chonSoCotXuat])
        nganCot.axis = .vertical
        nganCot.spacing = 10
        nganCot.translatesAutoresizingMaskIntoConstraints = false
        khungCot.addSubview(nganCot)

        // 2. Khối thêm cụm từ lọc bỏ trong tên ngành hàng
        let tieuDeLoc = taoTieuDeNhom("2. CỤM TỪ LỌC BỎ TRONG TẤT CẢ NGÀNH HÀNG")
        let khungLoc = UIView()
        khungLoc.backgroundColor = .secondarySystemGroupedBackground
        khungLoc.layer.cornerRadius = 12
        khungLoc.clipsToBounds = true

        oNhapCumTu.placeholder = "Nhập cụm từ muốn lọc bỏ (VD: T09 - , T10 - )..."
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
        bangCumTu.rowHeight = 44
        bangCumTu.backgroundColor = .clear
        bangCumTu.separatorInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        [hangNhap, vachNgan, bangCumTu].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungLoc.addSubview($0)
        }

        [tieuDeCot, khungCot, tieuDeLoc, khungLoc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tieuDeCot.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            tieuDeCot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeCot.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungCot.topAnchor.constraint(equalTo: tieuDeCot.bottomAnchor, constant: 6),
            khungCot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungCot.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganCot.topAnchor.constraint(equalTo: khungCot.topAnchor, constant: 12),
            nganCot.leadingAnchor.constraint(equalTo: khungCot.leadingAnchor, constant: 12),
            nganCot.trailingAnchor.constraint(equalTo: khungCot.trailingAnchor, constant: -12),
            nganCot.bottomAnchor.constraint(equalTo: khungCot.bottomAnchor, constant: -12),

            tieuDeLoc.topAnchor.constraint(equalTo: khungCot.bottomAnchor, constant: 18),
            tieuDeLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tieuDeLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            khungLoc.topAnchor.constraint(equalTo: tieuDeLoc.bottomAnchor, constant: 6),
            khungLoc.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungLoc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            khungLoc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),

            hangNhap.topAnchor.constraint(equalTo: khungLoc.topAnchor, constant: 12),
            hangNhap.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor, constant: 12),
            hangNhap.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor, constant: -12),

            vachNgan.topAnchor.constraint(equalTo: hangNhap.bottomAnchor, constant: 12),
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
        // Nếu người dùng vừa gõ chữ trong ô mà chưa bấm "+ Thêm", tự thêm luôn khi bấm Lưu
        if let dangGo = oNhapCumTu.text?.trimmingCharacters(in: .whitespacesAndNewlines), !dangGo.isEmpty {
            if !danhSachCumTu.contains(where: { $0.caseInsensitiveCompare(dangGo) == .orderedSame }) {
                danhSachCumTu.insert(dangGo, at: 0)
            }
        }

        let soCot = chonSoCotXuat.selectedSegmentIndex + 1
        let moi = CaiDatDMX(
            danhSachCumTuLocBo: danhSachCumTu,
            soCotXuatAnh: soCot
        )
        KhoDuLieu.dungChung.luuCaiDat(moi)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableViewDataSource & Delegate

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
        nhan.font = .systemFont(ofSize: 12, weight: .bold)
        nhan.textColor = .secondaryLabel
        return nhan
    }
}
