import UIKit

final class BangCongDoanDuView: UIView, UITableViewDataSource, UITableViewDelegate {
    private let bang = UITableView(frame: .zero, style: .plain)
    private var danhSach: [CongDoanDu] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 14
        clipsToBounds = true

        bang.dataSource = self
        bang.delegate = self
        bang.isScrollEnabled = true
        bang.alwaysBounceVertical = true
        bang.separatorStyle = .singleLine
        bang.rowHeight = 40
        bang.sectionHeaderHeight = 38
        bang.backgroundColor = .clear
        bang.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bang)

        NSLayoutConstraint.activate([
            bang.topAnchor.constraint(equalTo: topAnchor),
            bang.bottomAnchor.constraint(equalTo: bottomAnchor),
            bang.leadingAnchor.constraint(equalTo: leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    func ganDanhSach(_ moi: [CongDoanDu]) {
        danhSach = moi.sorted { $0.heSo < $1.heSo }
        bang.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(1, danhSach.count)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        taoHang(trai: "Loại công đoạn", phai: "Số tờ", dam: true, hienMuiTen: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongCongDoanDu"
        let o = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        o.backgroundColor = .clear
        o.accessoryType = .disclosureIndicator
        o.contentView.subviews.forEach { $0.removeFromSuperview() }

        if danhSach.isEmpty {
            let trong = UILabel()
            trong.text = "Chưa có dữ liệu - chạm để nhập"
            trong.textColor = .secondaryLabel
            trong.textAlignment = .center
            trong.translatesAutoresizingMaskIntoConstraints = false
            o.contentView.addSubview(trong)
            NSLayoutConstraint.activate([
                trong.leadingAnchor.constraint(equalTo: o.contentView.leadingAnchor, constant: 8),
                trong.trailingAnchor.constraint(equalTo: o.contentView.trailingAnchor, constant: -8),
                trong.topAnchor.constraint(equalTo: o.contentView.topAnchor),
                trong.bottomAnchor.constraint(equalTo: o.contentView.bottomAnchor)
            ])
        } else {
            let dong = danhSach[indexPath.row]
            let hang = taoHang(
                trai: "\(dong.heSo.chuoiGon)%",
                phai: dong.soLuong.chuoiGon,
                dam: false,
                hienMuiTen: false
            )
            hang.translatesAutoresizingMaskIntoConstraints = false
            o.contentView.addSubview(hang)
            NSLayoutConstraint.activate([
                hang.leadingAnchor.constraint(equalTo: o.contentView.leadingAnchor),
                hang.trailingAnchor.constraint(equalTo: o.contentView.trailingAnchor),
                hang.topAnchor.constraint(equalTo: o.contentView.topAnchor),
                hang.bottomAnchor.constraint(equalTo: o.contentView.bottomAnchor)
            ])
        }
        return o
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moBangQuanLy()
    }

    private func moBangQuanLy() {
        guard let manHinh = timManHinhCha() else { return }
        let quanLy = ManHinhTonCongDoan { [weak self] in
            self?.ganDanhSach(KhoCongDoanDu.dungChung.danhSach)
        }
        let dieuHuong = UINavigationController(rootViewController: quanLy)
        dieuHuong.modalPresentationStyle = .fullScreen
        manHinh.present(dieuHuong, animated: true)
    }

    private func timManHinhCha() -> UIViewController? {
        var doiTuong: UIResponder? = self
        while let hienTai = doiTuong {
            if let manHinh = hienTai as? UIViewController { return manHinh }
            doiTuong = hienTai.next
        }
        return nil
    }

    private func taoHang(trai: String, phai: String, dam: Bool, hienMuiTen: Bool) -> UIView {
        let khung = UIView()
        khung.backgroundColor = dam ? UIColor.tertiarySystemGroupedBackground : .clear

        let nhanTrai = UILabel()
        let nhanPhai = UILabel()
        nhanTrai.text = trai
        nhanPhai.text = phai
        nhanTrai.font = .systemFont(ofSize: 14, weight: dam ? .bold : .regular)
        nhanPhai.font = .monospacedDigitSystemFont(ofSize: 14, weight: dam ? .bold : .regular)
        nhanTrai.textAlignment = .center
        nhanPhai.textAlignment = .center

        let vach = UIView()
        vach.backgroundColor = .separator
        [nhanTrai, nhanPhai, vach].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khung.addSubview($0)
        }

        let lePhai: CGFloat = hienMuiTen ? -22 : -6
        NSLayoutConstraint.activate([
            vach.centerXAnchor.constraint(equalTo: khung.centerXAnchor),
            vach.topAnchor.constraint(equalTo: khung.topAnchor),
            vach.bottomAnchor.constraint(equalTo: khung.bottomAnchor),
            vach.widthAnchor.constraint(equalToConstant: 0.5),
            nhanTrai.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 6),
            nhanTrai.trailingAnchor.constraint(equalTo: vach.leadingAnchor, constant: -6),
            nhanTrai.topAnchor.constraint(equalTo: khung.topAnchor),
            nhanTrai.bottomAnchor.constraint(equalTo: khung.bottomAnchor),
            nhanPhai.leadingAnchor.constraint(equalTo: vach.trailingAnchor, constant: 6),
            nhanPhai.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: lePhai),
            nhanPhai.topAnchor.constraint(equalTo: khung.topAnchor),
            nhanPhai.bottomAnchor.constraint(equalTo: khung.bottomAnchor)
        ])
        return khung
    }
}
