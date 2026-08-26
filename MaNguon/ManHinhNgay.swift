import UIKit

final class ManHinhNgay: UIViewController, UITextFieldDelegate {
    private var duLieu: DuLieuNgay
    private let ngay: Date
    private let khiDong: () -> Void

    private let cuon = UIScrollView()
    private let noiDung = UIStackView()
    private let batDau = UIDatePicker()
    private let ketThuc = UIDatePicker()
    private let nghi = UISwitch()
    private let phutChuan = UITextField()
    private let danhSach = UIStackView()
    private let tongKetQuaCongDoan = UILabel()
    private let ketQua = UILabel()
    private weak var oDangNhap: UITextField?

    init(ngay: Date, duLieu: DuLieuNgay, khiDong: @escaping () -> Void) {
        self.ngay = ngay
        self.duLieu = duLieu
        self.khiDong = khiDong
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        let dinhDang = DateFormatter()
        dinhDang.locale = Locale(identifier: "vi_VN")
        dinhDang.dateStyle = .full
        title = dinhDang.string(from: ngay).capitalized

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Hủy",
            style: .plain,
            target: self,
            action: #selector(huy)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Đóng & lưu",
            style: .done,
            target: self,
            action: #selector(dongLuu)
        )

        cauHinhGiaoDien()
        cauHinhBanPhim()
        capNhatKetQua()
    }

    private func cauHinhGiaoDien() {
        batDau.datePickerMode = .time
        ketThuc.datePickerMode = .time
        batDau.preferredDatePickerStyle = .compact
        ketThuc.preferredDatePickerStyle = .compact
        batDau.date = duLieu.gioBatDau
        ketThuc.date = duLieu.gioKetThuc
        nghi.isOn = duLieu.nghiLam

        cauHinhONhap(phutChuan, goiY: "Phút chuẩn")
        phutChuan.text = String(format: "%.0f", duLieu.phutChuan)

        danhSach.axis = .vertical
        danhSach.spacing = 10
        duLieu.congDoan.forEach { themDong($0, tuDongCuon: false) }

        let tieuDeCot = taoTieuDeCot()

        let nutThem = UIButton(type: .system)
        nutThem.setTitle("＋ Thêm công đoạn", for: .normal)
        nutThem.addTarget(self, action: #selector(themMoi), for: .touchUpInside)

        let nutTon = UIButton(type: .system)
        var cauHinhTon = UIButton.Configuration.tinted()
        cauHinhTon.title = "Công đoạn dư"
        cauHinhTon.image = UIImage(systemName: "tray.full.fill")
        cauHinhTon.imagePadding = 8
        nutTon.configuration = cauHinhTon
        nutTon.addTarget(self, action: #selector(moTonCongDoan), for: .touchUpInside)

        ketQua.font = .monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        ketQua.textAlignment = .center
        ketQua.textColor = .systemBlue

        noiDung.axis = .vertical
        noiDung.spacing = 14
        noiDung.translatesAutoresizingMaskIntoConstraints = false
        [
            taoHangGio(),
            taoHang("Nghỉ làm", nghi),
            taoHang("Phút chuẩn", phutChuan),
            tieuDeCot,
            danhSach,
            tongKetQuaCongDoan,
            nutThem,
            nutTon,
            ketQua
        ].forEach { noiDung.addArrangedSubview($0) }

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
            noiDung.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 18),
            noiDung.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -18)
        ])
    }

    private func cauHinhBanPhim() {
        let chamNen = UITapGestureRecognizer(target: self, action: #selector(tatBanPhim))
        chamNen.cancelsTouchesInView = false
        view.addGestureRecognizer(chamNen)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(banPhimHien(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(banPhimAn(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func cauHinhONhap(_ oNhap: UITextField, goiY: String) {
        oNhap.borderStyle = .roundedRect
        oNhap.keyboardType = .decimalPad
        oNhap.placeholder = goiY
        oNhap.textAlignment = .center
        oNhap.delegate = self
        oNhap.addTarget(self, action: #selector(duLieuThayDoi), for: .editingChanged)

        let thanh = UIToolbar()
        thanh.sizeToFit()
        thanh.items = [
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(tatBanPhim))
        ]
        oNhap.inputAccessoryView = thanh
    }

    private func taoTieuDeCot() -> UIStackView {
        let soTo = taoNhanCot("Số tờ")
        let heSo = taoNhanCot("Hệ số %")
        let ketQuaDong = taoNhanCot("Kết quả")
        let choXoa = UIView()
        choXoa.widthAnchor.constraint(equalToConstant: 42).isActive = true
        let hang = UIStackView(arrangedSubviews: [soTo, heSo, ketQuaDong, choXoa])
        hang.spacing = 6
        soTo.widthAnchor.constraint(equalTo: heSo.widthAnchor).isActive = true
        heSo.widthAnchor.constraint(equalTo: ketQuaDong.widthAnchor).isActive = true
        return hang
    }

    private func taoNhanCot(_ noiDung: String) -> UILabel {
        let nhan = UILabel()
        nhan.text = noiDung
        nhan.font = .systemFont(ofSize: 12, weight: .bold)
        nhan.textAlignment = .center
        nhan.adjustsFontSizeToFitWidth = true
        nhan.minimumScaleFactor = 0.75
        return nhan
    }

    private func taoHangGio() -> UIStackView {
        let nhomVao = UIStackView(arrangedSubviews: [taoNhanGio("Giờ vào"), batDau])
        let nhomVe = UIStackView(arrangedSubviews: [taoNhanGio("Giờ về"), ketThuc])
        [nhomVao, nhomVe].forEach {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 6
        }
        let hang = UIStackView(arrangedSubviews: [nhomVao, nhomVe])
        hang.axis = .horizontal
        hang.distribution = .fillEqually
        hang.alignment = .center
        hang.spacing = 16
        return hang
    }

    private func taoNhanGio(_ noiDung: String) -> UILabel {
        let nhan = UILabel()
        nhan.text = noiDung
        nhan.font = .systemFont(ofSize: 16, weight: .semibold)
        nhan.textAlignment = .center
        return nhan
    }

    private func taoHang(_ ten: String, _ noiDung: UIView) -> UIStackView {
        let nhan = UILabel()
        nhan.text = ten
        nhan.font = .systemFont(ofSize: 16, weight: .semibold)

        let hang = UIStackView(arrangedSubviews: [nhan, noiDung])
        hang.distribution = .equalSpacing
        hang.alignment = .center
        return hang
    }

    private func themDong(_ congDoan: CongDoan, tuDongCuon: Bool) {
        let soLuong = UITextField()
        let heSo = UITextField()
        let ketQuaDong = UILabel()
        cauHinhONhap(soLuong, goiY: "Số lượng tờ")
        cauHinhONhap(heSo, goiY: "Hệ số %")
        soLuong.text = congDoan.soLuong == 0 ? "" : congDoan.soLuong.chuoiGon
        heSo.text = congDoan.heSo == 0 ? "" : congDoan.heSo.chuoiGon

        let nutXoa = UIButton(type: .system)
        nutXoa.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        nutXoa.tintColor = .systemRed

        nutXoa.widthAnchor.constraint(equalToConstant: 42).isActive = true
        let hang = UIStackView(arrangedSubviews: [soLuong, heSo, ketQuaDong, nutXoa])
        hang.spacing = 6
        soLuong.widthAnchor.constraint(equalTo: heSo.widthAnchor).isActive = true
        heSo.widthAnchor.constraint(equalTo: ketQuaDong.widthAnchor).isActive = true

        nutXoa.addAction(UIAction { [weak self, weak hang] _ in
            guard let self, let hang else { return }
            self.danhSach.removeArrangedSubview(hang)
            hang.removeFromSuperview()
            self.capNhatKetQua()
        }, for: .touchUpInside)

        danhSach.addArrangedSubview(hang)

        if tuDongCuon {
            view.layoutIfNeeded()
            DispatchQueue.main.async { [weak self, weak soLuong] in
                guard let self, let soLuong else { return }
                soLuong.becomeFirstResponder()
                self.cuon.scrollRectToVisible(
                    soLuong.convert(soLuong.bounds, to: self.cuon).insetBy(dx: 0, dy: -24),
                    animated: true
                )
            }
        }
    }

    private func docSo(_ chuoi: String?) -> Double {
        Double(chuoi?.replacingOccurrences(of: ",", with: ".") ?? "") ?? 0
    }

    private func docCongDoan() -> [CongDoan] {
        danhSach.arrangedSubviews.compactMap { view in
            guard let hang = view as? UIStackView,
                  hang.arrangedSubviews.count >= 2,
                  let soLuong = hang.arrangedSubviews[0] as? UITextField,
                  let heSo = hang.arrangedSubviews[1] as? UITextField else {
                return nil
            }
            return CongDoan(soLuong: docSo(soLuong.text), heSo: docSo(heSo.text))
        }
    }

    private func tinhPhanTram() -> Double {
        let phut = docSo(phutChuan.text)
        guard phut > 0 else { return 0 }
        return docCongDoan().reduce(0) { $0 + $1.soLuong * $1.heSo } / phut * 100
    }

    private func capNhatKetQua() {
        var tongKetQua = 0.0
        for view in danhSach.arrangedSubviews {
            guard let hang = view as? UIStackView,
                  hang.arrangedSubviews.count >= 3,
                  let soLuong = hang.arrangedSubviews[0] as? UITextField,
                  let heSo = hang.arrangedSubviews[1] as? UITextField,
                  let ketQuaDong = hang.arrangedSubviews[2] as? UILabel else { continue }
            let giaTri = docSo(soLuong.text) * docSo(heSo.text)
            ketQuaDong.text = giaTri.chuoiGon
            tongKetQua += giaTri
        }
        tongKetQuaCongDoan.text = "  Tổng kết quả: \(tongKetQua.chuoiGon)  "
        ketQua.text = String(format: "%.2f%%", tinhPhanTram())
    }

    @objc private func themMoi() {
        themDong(CongDoan(), tuDongCuon: true)
    }

    @objc private func moTonCongDoan() {
        tatBanPhim()
        present(UINavigationController(rootViewController: ManHinhTonCongDoan()), animated: true)
    }

    @objc private func duLieuThayDoi() {
        capNhatKetQua()
    }

    @objc private func tatBanPhim() {
        view.endEditing(true)
    }

    @objc private func banPhimHien(_ thongBao: Notification) {
        guard let khung = thongBao.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let chieuCao = max(0, view.bounds.maxY - view.convert(khung, from: nil).minY)
        cuon.contentInset.bottom = chieuCao + 12
        cuon.verticalScrollIndicatorInsets.bottom = chieuCao + 12

        if let oDangNhap {
            DispatchQueue.main.async { [weak self, weak oDangNhap] in
                guard let self, let oDangNhap else { return }
                self.cuon.scrollRectToVisible(
                    oDangNhap.convert(oDangNhap.bounds, to: self.cuon).insetBy(dx: 0, dy: -24),
                    animated: true
                )
            }
        }
    }

    @objc private func banPhimAn(_ thongBao: Notification) {
        cuon.contentInset.bottom = 0
        cuon.verticalScrollIndicatorInsets.bottom = 0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        oDangNhap = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if oDangNhap === textField {
            oDangNhap = nil
        }
    }

    @objc private func huy() {
        dismiss(animated: true)
    }

    @objc private func dongLuu() {
        tatBanPhim()
        duLieu.gioBatDau = batDau.date
        duLieu.gioKetThuc = ketThuc.date
        duLieu.nghiLam = nghi.isOn
        duLieu.phutChuan = max(0, docSo(phutChuan.text))
        let congDoanMoi = docCongDoan()
        duLieu.congDoan = congDoanMoi
        duLieu.phanTram = tinhPhanTram()
        duLieu.daTinh = congDoanMoi.contains { $0.soLuong != 0 || $0.heSo != 0 }
        KhoDuLieu.dungChung.luu(duLieu)
        dismiss(animated: true, completion: khiDong)
    }
}
