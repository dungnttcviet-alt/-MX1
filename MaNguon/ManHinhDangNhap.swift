import UIKit

final class ManHinhDangNhap: UIViewController, UITextFieldDelegate {
    private let cuon = UIScrollView()
    private let chonCheDo = UISegmentedControl(items: ["Đăng nhập", "Tạo tài khoản mới"])
    private let oTen = UITextField()
    private let oMatKhau = UITextField()
    private let oNhapLaiMatKhau = UITextField()
    private let nutThucHien = UIButton(type: .system)
    private let nhanThongBao = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        taoGiaoDien()
        dangKySuKienBanPhim()
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

        chonCheDo.selectedSegmentIndex = 0
        chonCheDo.addTarget(self, action: #selector(doiCheDo), for: .valueChanged)

        cauHinhO(oTen, placeholder: "Tên đăng nhập (VD: sieuthi275)", secure: false, returnKey: .next)
        cauHinhO(oMatKhau, placeholder: "Mật khẩu (tối thiểu 6 ký tự)", secure: true, returnKey: .go)
        cauHinhO(oNhapLaiMatKhau, placeholder: "Nhập lại mật khẩu", secure: true, returnKey: .go)
        oNhapLaiMatKhau.isHidden = true

        oTen.textContentType = .username
        oTen.autocapitalizationType = .none
        oTen.autocorrectionType = .no
        oMatKhau.textContentType = .password
        oNhapLaiMatKhau.textContentType = .newPassword

        nutThucHien.setTitle("Đăng nhập vào hệ thống", for: .normal)
        nutThucHien.titleLabel?.font = .systemFont(ofSize: 16.5, weight: .bold)
        nutThucHien.backgroundColor = .systemBlue
        nutThucHien.tintColor = .white
        nutThucHien.layer.cornerRadius = 12
        nutThucHien.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nutThucHien.addTarget(self, action: #selector(thucHien), for: .touchUpInside)

        nhanThongBao.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanThongBao.textColor = .systemRed
        nhanThongBao.numberOfLines = 0
        nhanThongBao.textAlignment = .center

        let hangNut = UIStackView(arrangedSubviews: [nutThucHien, vongQuay])
        hangNut.axis = .vertical
        hangNut.spacing = 10

        let khung = UIStackView(arrangedSubviews: [icon, chonCheDo, oTen, oMatKhau, oNhapLaiMatKhau, hangNut, nhanThongBao])
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

            chonCheDo.heightAnchor.constraint(equalToConstant: 36),
            oTen.heightAnchor.constraint(equalToConstant: 46),
            oMatKhau.heightAnchor.constraint(equalToConstant: 46),
            oNhapLaiMatKhau.heightAnchor.constraint(equalToConstant: 46)
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
        } else if textField === oMatKhau {
            if chonCheDo.selectedSegmentIndex == 1 {
                oNhapLaiMatKhau.becomeFirstResponder()
            } else {
                thucHien()
            }
        } else {
            thucHien()
        }
        return true
    }

    @objc private func doiCheDo() {
        let laDangKy = (chonCheDo.selectedSegmentIndex == 1)
        oNhapLaiMatKhau.isHidden = !laDangKy
        oMatKhau.returnKeyType = laDangKy ? .next : .go
        nutThucHien.setTitle(laDangKy ? "Tạo tài khoản & Bắt đầu" : "Đăng nhập vào hệ thống", for: .normal)
        nhanThongBao.text = ""
    }

    @objc private func thucHien() {
        view.endEditing(true)
        let ten = (oTen.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let matKhau = oMatKhau.text ?? ""
        let nhapLai = oNhapLaiMatKhau.text ?? ""
        let laDangKy = (chonCheDo.selectedSegmentIndex == 1)

        if ten.range(of: "^[a-z0-9][a-z0-9._-]{2,39}$", options: .regularExpression) == nil {
            nhanThongBao.text = "Tên đăng nhập gồm 3–40 ký tự: chữ thường, số, dấu chấm, gạch ngang hoặc gạch dưới."
            return
        }
        if matKhau.count < 6 {
            nhanThongBao.text = "Mật khẩu cần có ít nhất 6 ký tự."
            return
        }
        if laDangKy && matKhau != nhapLai {
            nhanThongBao.text = "Mật khẩu nhập lại chưa khớp."
            return
        }

        datDangTai(true)
        let xong: (Result<Void, Error>) -> Void = { [weak self] ketQua in
            self?.datDangTai(false)
            switch ketQua {
            case .success:
                (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiManHinhChinh()
            case .failure(let loi):
                self?.nhanThongBao.text = loi.localizedDescription
            }
        }
        if !laDangKy {
            DichVuDongBo.dungChung.dangNhap(tenDangNhap: ten, matKhau: matKhau, hoanTat: xong)
        } else {
            DichVuDongBo.dungChung.dangKy(tenDangNhap: ten, matKhau: matKhau, hoanTat: xong)
        }
    }

    private func datDangTai(_ dangTai: Bool) {
        nutThucHien.isEnabled = !dangTai
        chonCheDo.isEnabled = !dangTai
        dangTai ? vongQuay.startAnimating() : vongQuay.stopAnimating()
        if dangTai {
            nhanThongBao.text = "Đang kết nối tài khoản ĐMX..."
            nhanThongBao.textColor = .secondaryLabel
        } else {
            nhanThongBao.textColor = .systemRed
        }
    }
}
