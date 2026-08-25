import UIKit

final class ManHinhTonCongDoan: UIViewController, UITextFieldDelegate {
    private let khiLuu: (() -> Void)?
    private let cuon = UIScrollView()
    private let noiDung = UIStackView()
    private let danhSach = UIStackView()
    private weak var oDangNhap: UITextField?

    init(khiLuu: (() -> Void)? = nil) {
        self.khiLuu = khiLuu
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quản lý công đoạn dư"
        view.backgroundColor = .systemGroupedBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Hủy",
            style: .plain,
            target: self,
            action: #selector(huy)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(luu)
        )
        taoGiaoDien()
        taoBanPhim()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func taoGiaoDien() {
        let moTa = UILabel()
        moTa.text = "Nhập số tờ cần thay đổi rồi chọn − hoặc +. Khi bấm Lưu, ứng dụng mới thực hiện phép toán và cập nhật dữ liệu."
        moTa.font = .systemFont(ofSize: 14)
        moTa.textColor = .secondaryLabel
        moTa.numberOfLines = 0

        danhSach.axis = .vertical
        danhSach.spacing = 10

        let duLieu = KhoCongDoanDu.dungChung.danhSach.sorted { $0.heSo < $1.heSo }
        duLieu.forEach { themDong(heSo: $0.heSo, hienCo: $0.soLuong, laMoi: false, tuDongNhap: false) }
        if duLieu.isEmpty {
            themDong(heSo: 0, hienCo: 0, laMoi: true, tuDongNhap: false)
        }

        let nutThem = UIButton(type: .system)
        var cauHinh = UIButton.Configuration.tinted()
        cauHinh.title = "Thêm loại công đoạn"
        cauHinh.image = UIImage(systemName: "plus.circle.fill")
        cauHinh.imagePadding = 8
        nutThem.configuration = cauHinh
        nutThem.addTarget(self, action: #selector(themMoi), for: .touchUpInside)

        noiDung.axis = .vertical
        noiDung.spacing = 14
        noiDung.translatesAutoresizingMaskIntoConstraints = false
        [moTa, taoTieuDeCot(), danhSach, nutThem].forEach { noiDung.addArrangedSubview($0) }

        cuon.keyboardDismissMode = .interactive
        cuon.alwaysBounceVertical = true
        cuon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuon)
        cuon.addSubview(noiDung)

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cuon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noiDung.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 18),
            noiDung.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -30),
            noiDung.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 12),
            noiDung.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -12)
        ])
    }

    private func taoTieuDeCot() -> UIStackView {
        let heSo = nhan("Hệ số %")
        let hienCo = nhan("Hiện có")
        let thayDoi = nhan("Thay đổi")
        let phepTinh = nhan("− / +")

        let hang = UIStackView(arrangedSubviews: [heSo, hienCo, thayDoi, phepTinh])
        hang.spacing = 6
        hang.distribution = .fillEqually
        return hang
    }

    private func nhan(_ chu: String) -> UILabel {
        let nhan = UILabel()
        nhan.text = chu
        nhan.font = .systemFont(ofSize: 12, weight: .bold)
        nhan.textAlignment = .center
        nhan.adjustsFontSizeToFitWidth = true
        nhan.minimumScaleFactor = 0.7
        return nhan
    }

    private func cauHinhONhap(_ oNhap: UITextField, goiY: String) {
        oNhap.borderStyle = .roundedRect
        oNhap.keyboardType = .decimalPad
        oNhap.placeholder = goiY
        oNhap.textAlignment = .center
        oNhap.delegate = self

        let thanh = UIToolbar()
        thanh.sizeToFit()
        thanh.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(tatBanPhim))
        ]
        oNhap.inputAccessoryView = thanh
    }

    private func themDong(heSo: Double, hienCo: Double, laMoi: Bool, tuDongNhap: Bool) {
        let oHeSo = UITextField()
        cauHinhONhap(oHeSo, goiY: "%")
        oHeSo.text = heSo == 0 ? "" : heSo.chuoiGon
        oHeSo.isEnabled = laMoi
        oHeSo.backgroundColor = laMoi ? .secondarySystemGroupedBackground : .clear

        let nhanHienCo = UILabel()
        nhanHienCo.text = hienCo.chuoiGon
        nhanHienCo.font = .monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
        nhanHienCo.textAlignment = .center
        nhanHienCo.adjustsFontSizeToFitWidth = true
        nhanHienCo.minimumScaleFactor = 0.7

        let oThayDoi = UITextField()
        cauHinhONhap(oThayDoi, goiY: "Số tờ")
        oThayDoi.tag = 1001

        let dau = UISegmentedControl(items: ["−", "+"])
        dau.selectedSegmentIndex = 1
        dau.addAction(UIAction { [weak oThayDoi, weak dau] _ in
            guard let oThayDoi, let dau else { return }
            let giaTri = oThayDoi.text ?? ""
            let boDau = giaTri.replacingOccurrences(of: "−", with: "").replacingOccurrences(of: "-", with: "")
            oThayDoi.text = dau.selectedSegmentIndex == 0 && !boDau.isEmpty ? "-" + boDau : boDau
        }, for: .valueChanged)

        let hang = UIStackView(arrangedSubviews: [oHeSo, nhanHienCo, oThayDoi, dau])
        hang.spacing = 6
        hang.distribution = .fillEqually
        hang.backgroundColor = .secondarySystemGroupedBackground
        hang.layer.cornerRadius = 10
        hang.isLayoutMarginsRelativeArrangement = true
        hang.layoutMargins = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        danhSach.addArrangedSubview(hang)

        if tuDongNhap {
            view.layoutIfNeeded()
            DispatchQueue.main.async { [weak self, weak oHeSo] in
                guard let self, let oHeSo else { return }
                oHeSo.becomeFirstResponder()
                self.cuon.scrollRectToVisible(
                    oHeSo.convert(oHeSo.bounds, to: self.cuon).insetBy(dx: 0, dy: -24),
                    animated: true
                )
            }
        }
    }

    private func docSo(_ chuoi: String?) -> Double {
        let chuanHoa = chuoi?
            .replacingOccurrences(of: ",", with: ".")
            .replacingOccurrences(of: "−", with: "-") ?? ""
        return Double(chuanHoa) ?? 0
    }

    private func docThayDoi() -> [CongDoan] {
        danhSach.arrangedSubviews.compactMap { view in
            guard let hang = view as? UIStackView,
                  hang.arrangedSubviews.count == 4,
                  let oHeSo = hang.arrangedSubviews[0] as? UITextField,
                  let oThayDoi = hang.arrangedSubviews[2] as? UITextField,
                  let dau = hang.arrangedSubviews[3] as? UISegmentedControl else { return nil }

            let heSo = docSo(oHeSo.text)
            let soNhap = abs(docSo(oThayDoi.text))
            guard heSo > 0, soNhap > 0 else { return nil }
            let soLuong = dau.selectedSegmentIndex == 0 ? -soNhap : soNhap
            return CongDoan(soLuong: soLuong, heSo: heSo)
        }
    }

    @objc private func themMoi() {
        themDong(heSo: 0, hienCo: 0, laMoi: true, tuDongNhap: true)
    }

    @objc private func tatBanPhim() {
        view.endEditing(true)
    }

    @objc private func huy() {
        dismiss(animated: true)
    }

    @objc private func luu() {
        tatBanPhim()
        let thayDoi = docThayDoi()
        guard !thayDoi.isEmpty else {
            hienLoi("Hãy nhập ít nhất một thay đổi hợp lệ.")
            return
        }

        if let loi = KhoCongDoanDu.dungChung.thuCongDon(thayDoi) {
            hienLoi(loi)
            return
        }

        khiLuu?()
        dismiss(animated: true)
    }

    private func taoBanPhim() {
        let cham = UITapGestureRecognizer(target: self, action: #selector(tatBanPhim))
        cham.cancelsTouchesInView = false
        view.addGestureRecognizer(cham)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(banPhimHien(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(banPhimAn),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func banPhimHien(_ thongBao: Notification) {
        guard let khung = thongBao.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let cao = max(0, view.bounds.maxY - view.convert(khung, from: nil).minY)
        cuon.contentInset.bottom = cao + 12
        cuon.verticalScrollIndicatorInsets.bottom = cao + 12

        if let oDangNhap {
            cuon.scrollRectToVisible(
                oDangNhap.convert(oDangNhap.bounds, to: cuon).insetBy(dx: 0, dy: -24),
                animated: true
            )
        }
    }

    @objc private func banPhimAn() {
        cuon.contentInset.bottom = 0
        cuon.verticalScrollIndicatorInsets.bottom = 0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        oDangNhap = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if oDangNhap === textField { oDangNhap = nil }
    }

    private func hienLoi(_ noiDung: String) {
        let hopThoai = UIAlertController(
            title: "Không thể lưu",
            message: noiDung,
            preferredStyle: .alert
        )
        hopThoai.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(hopThoai, animated: true)
    }
}
