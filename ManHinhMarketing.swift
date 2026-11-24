import UIKit
import WebKit

/// Module Marketing BOT được nhúng riêng, không can thiệp các màn hình nghiệp vụ hiện hữu.
/// Địa chỉ Web App được cấu hình sau khi máy chủ Marketing được triển khai.
final class ManHinhMarketing: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    private let khoaDiaChi = "dmx_marketing_web_url_v1"
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let oDiaChi = UITextField()
    private let nutMo = UIButton(type: .system)
    private let nutTaiLai = UIButton(type: .system)
    private let nhanTrangThai = UILabel()
    private let thanhTienTrinh = UIProgressView(progressViewStyle: .bar)
    private var daGanObserver = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BangMauBCTD.nenTrang
        taoGiaoDien()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        daGanObserver = true
        taiCauHinhVaHienThi()
    }

    deinit {
        if daGanObserver {
            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        }
    }

    func taiCauHinhVaHienThi() {
        guard isViewLoaded else { return }
        let diaChi = UserDefaults.standard.string(forKey: khoaDiaChi) ?? ""
        oDiaChi.text = diaChi
        guard let url = URL(string: diaChi),
              url.scheme?.lowercased() == "https",
              url.host != nil else {
            hienTrangThaiChuaCauHinh()
            return
        }
        nhanTrangThai.text = "Đã cấu hình địa chỉ Marketing. Đang tải công cụ…"
        webView.load(URLRequest(url: url))
    }

    private func taoGiaoDien() {
        let tieuDe = UILabel()
        tieuDe.text = "📣 AI MARKETING BOT"
        tieuDe.font = .systemFont(ofSize: 18, weight: .heavy)
        tieuDe.textColor = BangMauBCTD.xanhChuDaoDam
        tieuDe.numberOfLines = 0
        tieuDe.lineBreakMode = .byWordWrapping
        tieuDe.adjustsFontSizeToFitWidth = false

        let moTa = UILabel()
        moTa.text = "Công cụ tạo chiến dịch, soạn nội dung Facebook / Zalo OA / TikTok, duyệt bài và quản lý lịch đăng."
        moTa.font = .systemFont(ofSize: 13, weight: .medium)
        moTa.textColor = BangMauBCTD.chuPhu
        moTa.numberOfLines = 0
        moTa.lineBreakMode = .byWordWrapping
        moTa.adjustsFontSizeToFitWidth = false

        oDiaChi.borderStyle = .roundedRect
        oDiaChi.placeholder = "Địa chỉ HTTPS của Web App Marketing"
        oDiaChi.keyboardType = .URL
        oDiaChi.autocapitalizationType = .none
        oDiaChi.autocorrectionType = .no
        oDiaChi.returnKeyType = .go
        oDiaChi.font = .systemFont(ofSize: 13)
        oDiaChi.delegate = self
        oDiaChi.clearButtonMode = .whileEditing

        nutMo.setTitle("Kết nối", for: .normal)
        nutMo.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutMo.backgroundColor = BangMauBCTD.xanhChuDao
        nutMo.setTitleColor(.white, for: .normal)
        nutMo.layer.cornerRadius = 8
        nutMo.contentEdgeInsets = UIEdgeInsets(top: 9, left: 14, bottom: 9, right: 14)
        nutMo.addTarget(self, action: #selector(bamKetNoi), for: .touchUpInside)

        nutTaiLai.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        nutTaiLai.tintColor = BangMauBCTD.xanhChuDaoDam
        nutTaiLai.addTarget(self, action: #selector(bamTaiLai), for: .touchUpInside)

        nhanTrangThai.text = "Chưa cấu hình máy chủ Marketing."
        nhanTrangThai.font = .systemFont(ofSize: 12, weight: .medium)
        nhanTrangThai.textColor = BangMauBCTD.chuPhu
        nhanTrangThai.numberOfLines = 0
        nhanTrangThai.lineBreakMode = .byWordWrapping
        nhanTrangThai.adjustsFontSizeToFitWidth = false

        let hangDiaChi = UIStackView(arrangedSubviews: [oDiaChi, nutMo, nutTaiLai])
        hangDiaChi.axis = .horizontal
        hangDiaChi.spacing = 7
        hangDiaChi.alignment = .center

        let dau = UIStackView(arrangedSubviews: [tieuDe, moTa, hangDiaChi, nhanTrangThai, thanhTienTrinh])
        dau.axis = .vertical
        dau.spacing = 9
        dau.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dau)
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            dau.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            dau.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dau.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            webView.topAnchor.constraint(equalTo: dau.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func hienTrangThaiChuaCauHinh() {
        nhanTrangThai.text = "Marketing BOT đã được thêm vào V2 ĐMX. Máy chủ Web App chưa được triển khai hoặc chưa có địa chỉ HTTPS. Khi có máy chủ, nhập địa chỉ VPN/HTTPS vào ô phía trên rồi bấm Kết nối. Các chức năng hiện có của V2 ĐMX không bị thay đổi."
        webView.loadHTMLString("""
        <!doctype html><html lang="vi"><meta name="viewport" content="width=device-width, initial-scale=1">
        <body style="font-family:-apple-system; padding:24px; color:#334155; background:#f8fafc">
        <h2>Marketing BOT</h2>
        <p>Module đã được tích hợp vào ứng dụng.</p>
        <p>Đang chờ địa chỉ Web App Marketing an toàn (HTTPS) để kết nối.</p>
        <p>Các chức năng tạo chiến dịch, duyệt bài và đăng Facebook, Zalo OA, TikTok sẽ hoạt động sau khi backend được triển khai và tài khoản nền tảng được cấp quyền.</p>
        </body></html>
        """, baseURL: nil)
    }

    @objc private func bamKetNoi() {
        let diaChi = (oDiaChi.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: diaChi),
              url.scheme?.lowercased() == "https",
              url.host != nil else {
            nhanTrangThai.text = "Địa chỉ không hợp lệ. Vui lòng nhập địa chỉ bắt đầu bằng https://."
            return
        }
        UserDefaults.standard.set(url.absoluteString, forKey: khoaDiaChi)
        oDiaChi.resignFirstResponder()
        nhanTrangThai.text = "Đang kết nối đến máy chủ Marketing…"
        webView.load(URLRequest(url: url))
    }

    @objc private func bamTaiLai() {
        if webView.url != nil {
            webView.reload()
        } else {
            taiCauHinhVaHienThi()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bamKetNoi()
        return true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            thanhTienTrinh.progress = Float(webView.estimatedProgress)
            thanhTienTrinh.isHidden = webView.estimatedProgress >= 1
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        nhanTrangThai.text = "Đã kết nối Marketing Web App."
        oDiaChi.text = webView.url?.absoluteString
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        nhanTrangThai.text = "Không tải được Marketing Web App: \(error.localizedDescription)"
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        nhanTrangThai.text = "Không kết nối được máy chủ Marketing: \(error.localizedDescription)"
    }
}
