import UIKit
import WebKit

/// Trình duyệt tích hợp dành cho Microsoft 365 Copilot. Cookie đăng nhập được
/// WebKit lưu trong kho dữ liệu mặc định của ứng dụng để người dùng không phải
/// đăng nhập lại mỗi lần mở màn hình.
final class ManHinhTrinhDuyet: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    private var ngay: Date
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    private let oDiaChi = UITextField()
    private let nutLui = UIButton(type: .system)
    private let nutTien = UIButton(type: .system)
    private let nutTaiLai = UIButton(type: .system)
    private let nutCopilot = UIButton(type: .system)
    private let nutCopySoLieu = UIButton(type: .system)
    private let thanhTienTrinh = UIProgressView(progressViewStyle: .bar)

    init(ngay: Date = Date()) {
        self.ngay = ngay
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BangMauBCTD.nenTrang
        taoGiaoDien()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        moCopilot()
    }

    deinit { webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress)) }

    func capNhatNgay(_ ngayMoi: Date) { ngay = ngayMoi }

    private func taoGiaoDien() {
        for (nut, icon, action) in [
            (nutLui, "chevron.left", #selector(bamLui)),
            (nutTien, "chevron.right", #selector(bamTien)),
            (nutTaiLai, "arrow.clockwise", #selector(bamTaiLai))
        ] {
            nut.setImage(UIImage(systemName: icon), for: .normal)
            nut.addTarget(self, action: action, for: .touchUpInside)
        }

        oDiaChi.borderStyle = .roundedRect
        oDiaChi.keyboardType = .URL
        oDiaChi.autocapitalizationType = .none
        oDiaChi.autocorrectionType = .no
        oDiaChi.returnKeyType = .go
        oDiaChi.delegate = self

        nutCopilot.setTitle("Copilot 365", for: .normal)
        nutCopilot.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nutCopilot.addTarget(self, action: #selector(moCopilot), for: .touchUpInside)

        nutCopySoLieu.setTitle("📋 Chỉ copy số liệu", for: .normal)
        nutCopySoLieu.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutCopySoLieu.backgroundColor = BangMauBCTD.vangSang
        nutCopySoLieu.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutCopySoLieu.layer.cornerRadius = 8
        nutCopySoLieu.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutCopySoLieu.addTarget(self, action: #selector(copySoLieu), for: .touchUpInside)

        let hangDiaChi = UIStackView(arrangedSubviews: [nutLui, nutTien, nutTaiLai, oDiaChi, nutCopilot])
        hangDiaChi.axis = .horizontal
        hangDiaChi.spacing = 6
        hangDiaChi.alignment = .center

        let huongDan = UILabel()
        huongDan.text = "Đăng nhập Microsoft 365 trong trang bên dưới. Bấm “Chỉ copy số liệu”, sau đó dán vào Copilot và yêu cầu tạo Excel hoặc PowerPoint."
        huongDan.font = .systemFont(ofSize: 12.5, weight: .medium)
        huongDan.textColor = BangMauBCTD.chuPhu
        huongDan.numberOfLines = 0

        let dau = UIStackView(arrangedSubviews: [hangDiaChi, nutCopySoLieu, huongDan, thanhTienTrinh])
        dau.axis = .vertical
        dau.spacing = 7
        dau.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dau)
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            dau.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            dau.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dau.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            webView.topAnchor.constraint(equalTo: dau.bottomAnchor, constant: 6),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func moCopilot() { moURL("https://m365.cloud.microsoft/chat/") }
    @objc private func bamLui() { if webView.canGoBack { webView.goBack() } }
    @objc private func bamTien() { if webView.canGoForward { webView.goForward() } }
    @objc private func bamTaiLai() { webView.reload() }

    private func moURL(_ chuoi: String) {
        var diaChi = chuoi.trimmingCharacters(in: .whitespacesAndNewlines)
        if !diaChi.lowercased().hasPrefix("http://") && !diaChi.lowercased().hasPrefix("https://") { diaChi = "https://" + diaChi }
        guard let url = URL(string: diaChi) else { return }
        webView.load(URLRequest(url: url))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moURL(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }

    @objc private func copySoLieu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        var dong: [String] = [
            "DU LIEU BAO CAO DMX - \(ngayStr)",
            "Don vi\t\(dl.thongTinDonVi)",
            "Chi so\tThuc hien\tTarget\tTy le",
            "Doanh thu thuc\t\(dl.doanhThu.doanhThuThuc)\t\(dl.doanhThu.targetThuc)\t\(dl.doanhThu.phanTramHTThuc)",
            "Doanh thu quy doi\t\(dl.doanhThu.doanhThuQuyDoi)\t\(dl.doanhThu.targetQuyDoi)\t\(dl.doanhThu.phanTramHTQuyDoi)",
            "",
            "NGANH HANG\tDON VI\tTHUC HIEN\tTARGET\tPHAN TRAM HT\tPHAN TRAM DU KIEN"
        ]
        dong.append(contentsOf: dl.danhSachThiDua.map {
            "\($0.tenNganhHang)\t\($0.loaiChiTieu.maBang)\t\($0.thucHien)\t\($0.target)\t\($0.phanTramHT)\t\($0.phanTramDuBao)"
        })
        UIPasteboard.general.string = dong.joined(separator: "\n")
        let cu = nutCopySoLieu.title(for: .normal)
        nutCopySoLieu.setTitle("✅ Đã copy số liệu — dán vào Copilot", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in self?.nutCopySoLieu.setTitle(cu, for: .normal) }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            thanhTienTrinh.progress = Float(webView.estimatedProgress)
            thanhTienTrinh.isHidden = webView.estimatedProgress >= 1
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        oDiaChi.text = webView.url?.absoluteString
        nutLui.isEnabled = webView.canGoBack
        nutTien.isEnabled = webView.canGoForward
    }
}
