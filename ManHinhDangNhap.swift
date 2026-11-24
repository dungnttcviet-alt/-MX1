import UIKit

final class ManHinhDangNhap: UIViewController, UITextFieldDelegate {
    private let cuon = UIScrollView()
    private let nhanTieuDe = UILabel()
    private let nhanPhuDe = UILabel()
    private let oTen = UITextField()
    private let oMatKhau = UITextField()
    private let nutThucHien = UIButton(type: .system)
    private let nhanThongBao = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        taoGiaoDien()
        dangKySuKienBanPhim()
        DichVuDongBo.dungChung.thucHienKhoiTaoAdminVaXoaTaiKhoanCuNeuCan()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func taoGiaoDien() {
        cuon.alwaysBounceVertical = true
        cuon.keyboardDismissMode = .interactive
        cuon.showsVerticalScrollIndicator = false
        cuon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuon)

        let tapAnBanPhim = UITapGestureRecognizer(target: self, action: #selector(anBanPhim))
        tapAnBanPhim.cancelsTouchesInView = false
        cuon.addGestureRecognizer(tapAnBanPhim)

        let icon = UIImageView(image: UIImage(systemName: "chart.bar.xaxis"))
        icon.tintColor = .systemBlue
        icon.contentMode = .scaleAspectFit
        icon.preferredSymbolConfiguration = .init(pointSize: 38, weight: .bold)
        icon.heightAnchor.constraint(equalToConstant: 44).isActive = true

        nhanTieuDe.text = "Tổng Hợp Số Liệu ĐMX"
        nhanTieuDe.font = .systemFont(ofSize: 21, weight: .heavy)
        nhanTieuDe.textColor = .label
        nhanTieuDe.textAlignment = .center
        nhanTieuDe.numberOfLines = 0
        nhanTieuDe.lineBreakMode = .byWordWrapping
        nhanTieuDe.adjustsFontSizeToFitWidth = false

        nhanPhuDe.text = "Đăng nhập tài khoản để đồng bộ dữ liệu báo cáo."
        nhanPhuDe.font = .systemFont(ofSize: 13, weight: .medium)
        nhanPhuDe.textColor = .secondaryLabel
        nhanPhuDe.textAlignment = .center
        nhanPhuDe.numberOfLines = 0
        nhanPhuDe.lineBreakMode = .byWordWrapping
        nhanPhuDe.adjustsFontSizeToFitWidth = false

        cauHinhO(oTen, placeholder: "Tên đăng nhập", secure: false, returnKey: .next)
        cauHinhO(oMatKhau, placeholder: "Mật khẩu", secure: true, returnKey: .go)

        oTen.textContentType = .username
        oTen.autocapitalizationType = .none
        oTen.autocorrectionType = .no
        oMatKhau.textContentType = .password

        nutThucHien.setTitle("Đăng nhập vào hệ thống", for: .normal)
        nutThucHien.titleLabel?.font = .systemFont(ofSize: 16.5, weight: .bold)
        nutThucHien.titleLabel?.numberOfLines = 0
        nutThucHien.titleLabel?.lineBreakMode = .byWordWrapping
        nutThucHien.titleLabel?.textAlignment = .center
        nutThucHien.titleLabel?.adjustsFontSizeToFitWidth = false
        nutThucHien.backgroundColor = .systemBlue
        nutThucHien.tintColor = .white
        nutThucHien.layer.cornerRadius = 12
        nutThucHien.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        nutThucHien.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        nutThucHien.addTarget(self, action: #selector(thucHien), for: .touchUpInside)

        nhanThongBao.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanThongBao.textColor = .systemRed
        nhanThongBao.numberOfLines = 0
        nhanThongBao.lineBreakMode = .byWordWrapping
        nhanThongBao.adjustsFontSizeToFitWidth = false
        nhanThongBao.textAlignment = .center

        let hangNut = UIStackView(arrangedSubviews: [nutThucHien, vongQuay])
        hangNut.axis = .vertical
        hangNut.spacing = 10

        let khung = UIStackView(arrangedSubviews: [icon, nhanTieuDe, nhanPhuDe, oTen, oMatKhau, hangNut, nhanThongBao])
        khung.axis = .vertical
        khung.spacing = 14
        khung.alignment = .fill
        khung.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(khung)

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            khung.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 28),
            khung.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -28),
            khung.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 24),
            khung.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -24),

            oTen.heightAnchor.constraint(equalToConstant: 46),
            oMatKhau.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    private func cauHinhO(_ o: UITextField, placeholder: String, secure: Bool, returnKey: UIReturnKeyType) {
        o.placeholder = placeholder
        o.isSecureTextEntry = secure
        o.borderStyle = .roundedRect
        o.backgroundColor = .secondarySystemGroupedBackground
        o.font = .systemFont(ofSize: 16)
        o.clearButtonMode = .whileEditing
        o.returnKeyType = returnKey
        o.delegate = self
    }

    private func dangKySuKienBanPhim() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(banPhimThayDoi(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(banPhimAn(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func banPhimThayDoi(_ note: Notification) {
        guard let info = note.userInfo,
              let frameVal = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let kbFrame = view.convert(frameVal.cgRectValue, from: view.window)
        let chieuCaoChe = max(0, view.bounds.maxY - kbFrame.minY)
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: chieuCaoChe + 16, right: 0)
        cuon.contentInset = inset
        cuon.scrollIndicatorInsets = inset
    }

    @objc private func banPhimAn(_ note: Notification) {
        cuon.contentInset = .zero
        cuon.scrollIndicatorInsets = .zero
    }

    @objc private func anBanPhim() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oTen {
            oMatKhau.becomeFirstResponder()
        } else {
            thucHien()
        }
        return true
    }

    @objc private func thucHien() {
        view.endEditing(true)
        let ten = (oTen.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let matKhau = oMatKhau.text ?? ""

        if ten.range(of: "^[a-z0-9][a-z0-9._-]{2,39}$", options: .regularExpression) == nil {
            nhanThongBao.text = "Tên đăng nhập gồm 3–40 ký tự: chữ thường, số, dấu chấm, gạch ngang hoặc gạch dưới."
            return
        }
        if matKhau.count < 6 {
            nhanThongBao.text = "Mật khẩu cần có ít nhất 6 ký tự."
            return
        }

        datDangTai(true)
        DichVuDongBo.dungChung.dangNhap(tenDangNhap: ten, matKhau: matKhau) { [weak self] ketQua in
            self?.datDangTai(false)
            switch ketQua {
            case .success:
                (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiManHinhChinh()
            case .failure(let loi):
                self?.nhanThongBao.text = loi.localizedDescription
            }
        }
    }

    private func datDangTai(_ dangTai: Bool) {
        nutThucHien.isEnabled = !dangTai
        dangTai ? vongQuay.startAnimating() : vongQuay.stopAnimating()
        if dangTai {
            nhanThongBao.text = "Đang kết nối tài khoản ĐMX"
            nhanThongBao.textColor = .secondaryLabel
        } else {
            nhanThongBao.textColor = .systemRed
        }
    }
}
