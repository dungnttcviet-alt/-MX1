import UIKit

final class ManHinhDangNhap: UIViewController {
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
    }

    private func taoGiaoDien() {
        let icon = UIImageView(image: UIImage(systemName: "chart.bar.xaxis"))
        icon.tintColor = .systemBlue
        icon.preferredSymbolConfiguration = .init(pointSize: 54, weight: .bold)

        let tieuDe = UILabel()
        tieuDe.text = "Báo Cáo Thi Đua ĐMX"
        tieuDe.font = .systemFont(ofSize: 27, weight: .bold)
        tieuDe.textAlignment = .center

        let moTa = UILabel()
        moTa.text = "Mỗi tài khoản lưu trữ bảng dữ liệu & danh sách nhân viên riêng trên Supabase (duongnt.io.vn/dmx). Ảnh được Apple Vision đọc trực tiếp trên iPhone."
        moTa.font = .systemFont(ofSize: 13.5)
        moTa.textColor = .secondaryLabel
        moTa.numberOfLines = 0
        moTa.textAlignment = .center

        chonCheDo.selectedSegmentIndex = 0
        chonCheDo.addTarget(self, action: #selector(doiCheDo), for: .valueChanged)
        cauHinhO(oTen, placeholder: "Tên đăng nhập (VD: sieuthi275 hoặc duongnt)", secure: false)
        cauHinhO(oMatKhau, placeholder: "Mật khẩu (tối thiểu 6 ký tự)", secure: true)
        cauHinhO(oNhapLaiMatKhau, placeholder: "Nhập lại mật khẩu", secure: true)
        oNhapLaiMatKhau.isHidden = true

        oTen.textContentType = .username
        oTen.autocapitalizationType = .none
        oTen.autocorrectionType = .no
        oMatKhau.textContentType = .password
        oNhapLaiMatKhau.textContentType = .newPassword

        nutThucHien.setTitle("Đăng nhập vào hệ thống", for: .normal)
        nutThucHien.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        nutThucHien.backgroundColor = .systemBlue
        nutThucHien.tintColor = .white
        nutThucHien.layer.cornerRadius = 13
        nutThucHien.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nutThucHien.addTarget(self, action: #selector(thucHien), for: .touchUpInside)

        nhanThongBao.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanThongBao.textColor = .systemRed
        nhanThongBao.numberOfLines = 0
        nhanThongBao.textAlignment = .center

        let hangNut = UIStackView(arrangedSubviews: [nutThucHien, vongQuay])
        hangNut.axis = .vertical
        hangNut.spacing = 10

        let khung = UIStackView(arrangedSubviews: [icon, tieuDe, moTa, chonCheDo, oTen, oMatKhau, oNhapLaiMatKhau, hangNut, nhanThongBao])
        khung.axis = .vertical
        khung.spacing = 13
        khung.alignment = .fill
        khung.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khung)

        NSLayoutConstraint.activate([
            khung.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            khung.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            khung.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            oTen.heightAnchor.constraint(equalToConstant: 48),
            oMatKhau.heightAnchor.constraint(equalToConstant: 48),
            oNhapLaiMatKhau.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func cauHinhO(_ o: UITextField, placeholder: String, secure: Bool) {
        o.placeholder = placeholder
        o.isSecureTextEntry = secure
        o.borderStyle = .roundedRect
        o.backgroundColor = .secondarySystemGroupedBackground
        o.font = .systemFont(ofSize: 16)
        o.clearButtonMode = .whileEditing
    }

    @objc private func doiCheDo() {
        let laDangKy = (chonCheDo.selectedSegmentIndex == 1)
        oNhapLaiMatKhau.isHidden = !laDangKy
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
