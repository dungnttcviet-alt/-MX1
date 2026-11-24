import UIKit
import PhotosUI

// MARK: - 1. Màn Hình Quản Lý Liên Kết Tài Khoản MXH (Facebook Page, Zalo OA, TikTok & Webhook)

final class ManHinhLienKetMXH: UIViewController {
    var khiDaLuu: (() -> Void)?

    private let cuon = UIScrollView()
    private let ngan = UIStackView()

    private let oTenSieuThi = UITextField()
    private let oHotline = UITextField()
    private let oDiaChi = UITextField()

    private let oFBTen = UITextField()
    private let oFBPageId = UITextField()
    private let oFBToken = UITextField()

    private let oZaloTen = UITextField()
    private let oZaloId = UITextField()
    private let oZaloToken = UITextField()

    private let oTikTokTen = UITextField()
    private let oTikTokToken = UITextField()

    private let oWebhookUrl = UITextField()
    private let oWebhookSecret = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Liên kết tài khoản MXH"
        view.backgroundColor = BangMauBCTD.nenTrang

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Đóng",
            style: .plain,
            target: self,
            action: #selector(bamDong)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(bamLuu)
        )

        taoGiaoDien()
        napCauHinh()

        let chamAnBanPhim = UITapGestureRecognizer(target: self, action: #selector(anBanPhim))
        chamAnBanPhim.cancelsTouchesInView = false
        view.addGestureRecognizer(chamAnBanPhim)
    }

    @objc private func anBanPhim() {
        view.endEditing(true)
    }

    @objc private func bamDong() {
        dismiss(animated: true)
    }

    @objc private func bamLuu() {
        var ch = QuanLyDuLieuMXH.dungChung.cauHinh
        ch.tenSieuThiMacDinh = (oTenSieuThi.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.hotlineMacDinh = (oHotline.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.diaChiMacDinh = (oDiaChi.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        ch.fbTenTrang = (oFBTen.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.fbPageId = (oFBPageId.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.fbAccessToken = (oFBToken.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        ch.zaloTenOA = (oZaloTen.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.zaloOAId = (oZaloId.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.zaloAccessToken = (oZaloToken.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        ch.tiktokTenKenh = (oTikTokTen.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.tiktokAccessToken = (oTikTokToken.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        ch.webhookUrl = (oWebhookUrl.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        ch.webhookSecret = (oWebhookSecret.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        QuanLyDuLieuMXH.dungChung.cauHinh = ch
        khiDaLuu?()
        dismiss(animated: true)
    }

    private func napCauHinh() {
        let ch = QuanLyDuLieuMXH.dungChung.cauHinh
        oTenSieuThi.text = ch.tenSieuThiMacDinh
        oHotline.text = ch.hotlineMacDinh
        oDiaChi.text = ch.diaChiMacDinh

        oFBTen.text = ch.fbTenTrang
        oFBPageId.text = ch.fbPageId
        oFBToken.text = ch.fbAccessToken

        oZaloTen.text = ch.zaloTenOA
        oZaloId.text = ch.zaloOAId
        oZaloToken.text = ch.zaloAccessToken

        oTikTokTen.text = ch.tiktokTenKenh
        oTikTokToken.text = ch.tiktokAccessToken

        oWebhookUrl.text = ch.webhookUrl
        oWebhookSecret.text = ch.webhookSecret
    }

    private func taoGiaoDien() {
        cuon.alwaysBounceVertical = true
        cuon.keyboardDismissMode = .interactive
        cuon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuon)

        ngan.axis = .vertical
        ngan.spacing = 14
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 14),
            ngan.leadingAnchor.constraint(equalTo: cuon.contentLayoutGuide.leadingAnchor, constant: 14),
            ngan.trailingAnchor.constraint(equalTo: cuon.contentLayoutGuide.trailingAnchor, constant: -14),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -32),
            ngan.widthAnchor.constraint(equalTo: cuon.frameLayoutGuide.widthAnchor, constant: -28)
        ])

        ngan.addArrangedSubview(taoTheNhom(
            tieuDe: "🏪 Thông tin siêu thị in trên ảnh & bài viết",
            moTa: "Tự động chèn vào thanh thương hiệu, chân poster quảng cáo và cuối bài đăng.",
            cacTruong: [
                ("Tên siêu thị / Fanpage", "VD: Điện Máy Xanh Nghĩa Lộ", oTenSieuThi, false),
                ("Số Hotline tư vấn", "VD: 09xx.xxx.xxx hoặc 1900 232 461", oHotline, false),
                ("Địa chỉ siêu thị", "VD: Số 123 Quang Trung, TP. Quảng Ngãi", oDiaChi, false)
            ]
        ))

        ngan.addArrangedSubview(taoTheNhom(
            tieuDe: "📘 Facebook Page (Graph API)",
            moTa: "Dùng Page ID và Page Access Token có quyền pages_manage_posts để đăng ảnh + bài viết trực tiếp.",
            cacTruong: [
                ("Tên Fanpage hiển thị", "VD: Điện Máy Xanh Quảng Ngãi", oFBTen, false),
                ("Facebook Page ID", "VD: 102938475612345", oFBPageId, false),
                ("Page Access Token", "Dán mã EAA... tại đây", oFBToken, true)
            ]
        ))

        ngan.addArrangedSubview(taoTheNhom(
            tieuDe: "💬 Zalo Official Account (Zalo OA API)",
            moTa: "Dùng OA Access Token để tự tải ảnh poster lên Zalo OA và xuất bản bài viết mới.",
            cacTruong: [
                ("Tên Zalo OA hiển thị", "VD: Điện Máy Xanh Official", oZaloTen, false),
                ("Zalo OA ID (tùy chọn)", "VD: 123456789012345678", oZaloId, false),
                ("Zalo OA Access Token", "Dán mã Access Token Zalo OA", oZaloToken, true)
            ]
        ))

        ngan.addArrangedSubview(taoTheNhom(
            tieuDe: "🎵 TikTok (Content Posting API)",
            moTa: "Dán Access Token TikTok có quyền video.upload / photo post, hoặc dùng Webhook bên dưới để tự đẩy đa kênh.",
            cacTruong: [
                ("Tên kênh TikTok", "VD: @dmx_sieu_thi", oTikTokTen, false),
                ("TikTok Access Token", "Dán mã Access Token TikTok", oTikTokToken, true)
            ]
        ))

        ngan.addArrangedSubview(taoTheNhom(
            tieuDe: "⚡ Webhook tự động hóa (Make / n8n / Cloudflare)",
            moTa: "Tùy chọn nâng cao: nếu điền URL Webhook, ứng dụng sẽ gửi JSON gồm nền tảng, tiêu đề, caption và ảnh base64 sang luồng tự đăng của bạn.",
            cacTruong: [
                ("Webhook URL", "https://hook.make.com/...", oWebhookUrl, false),
                ("Khóa bảo mật Header (tùy chọn)", "X-DMX-Webhook-Secret", oWebhookSecret, true)
            ]
        ))

        let nutLuuLon = UIButton(type: .system)
        nutLuuLon.setTitle("💾 Lưu toàn bộ cấu hình liên kết MXH", for: .normal)
        nutLuuLon.titleLabel?.font = .systemFont(ofSize: 15.5, weight: .bold)
        nutLuuLon.titleLabel?.numberOfLines = 0
        nutLuuLon.titleLabel?.lineBreakMode = .byWordWrapping
        nutLuuLon.titleLabel?.adjustsFontSizeToFitWidth = false
        nutLuuLon.setTitleColor(.white, for: .normal)
        nutLuuLon.backgroundColor = BangMauBCTD.xanhChuDao
        nutLuuLon.layer.cornerRadius = 12
        nutLuuLon.contentEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        nutLuuLon.addTarget(self, action: #selector(bamLuu), for: .touchUpInside)
        ngan.addArrangedSubview(nutLuuLon)
    }

    private func taoTheNhom(
        tieuDe: String,
        moTa: String,
        cacTruong: [(nhan: String, goiY: String, o: UITextField, matKhau: Bool)]
    ) -> UIView {
        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 14
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(stack)

        let lblTieuDe = UILabel()
        lblTieuDe.text = tieuDe
        lblTieuDe.font = .systemFont(ofSize: 15, weight: .bold)
        lblTieuDe.textColor = BangMauBCTD.xanhChuDaoDam
        lblTieuDe.numberOfLines = 0
        lblTieuDe.lineBreakMode = .byWordWrapping
        lblTieuDe.adjustsFontSizeToFitWidth = false
        stack.addArrangedSubview(lblTieuDe)

        let lblMoTa = UILabel()
        lblMoTa.text = moTa
        lblMoTa.font = .systemFont(ofSize: 12.5, weight: .regular)
        lblMoTa.textColor = BangMauBCTD.chuPhu
        lblMoTa.numberOfLines = 0
        lblMoTa.lineBreakMode = .byWordWrapping
        lblMoTa.adjustsFontSizeToFitWidth = false
        stack.addArrangedSubview(lblMoTa)

        for muc in cacTruong {
            let lbl = UILabel()
            lbl.text = muc.nhan
            lbl.font = .systemFont(ofSize: 13, weight: .semibold)
            lbl.textColor = BangMauBCTD.chuChinh
            lbl.numberOfLines = 0
            lbl.lineBreakMode = .byWordWrapping
            lbl.adjustsFontSizeToFitWidth = false
            stack.addArrangedSubview(lbl)

            muc.o.placeholder = muc.goiY
            muc.o.font = .systemFont(ofSize: 14, weight: .regular)
            muc.o.textColor = BangMauBCTD.chuChinh
            muc.o.backgroundColor = BangMauBCTD.nenThePhu
            muc.o.layer.cornerRadius = 10
            muc.o.layer.borderWidth = 1
            muc.o.layer.borderColor = BangMauBCTD.vienDam.cgColor
            muc.o.isSecureTextEntry = muc.matKhau
            muc.o.autocorrectionType = .no
            muc.o.autocapitalizationType = .none
            muc.o.clearButtonMode = .whileEditing
            muc.o.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 10))
            muc.o.leftViewMode = .always
            muc.o.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true
            stack.addArrangedSubview(muc.o)
        }

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: the.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -14)
        ])

        return the
    }
}

// MARK: - 2. Màn Hình Xem Toàn Màn Hình Ảnh Poster AI Thiết Kế

final class ManHinhXemAnhThietKeMXH: UIViewController {
    private let anh: UIImage
    private let tieuDe: String

    init(anh: UIImage, tieuDe: String) {
        self.anh = anh
        self.tieuDe = tieuDe
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = tieuDe
        view.backgroundColor = UIColor(red: 0.07, green: 0.10, blue: 0.16, alpha: 1.0)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Đóng", style: .plain, target: self, action: #selector(bamDong))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chia sẻ / Lưu", style: .done, target: self, action: #selector(bamChiaSe))

        let imgView = UIImageView(image: anh)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgView)

        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            imgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }

    @objc private func bamDong() {
        dismiss(animated: true)
    }

    @objc private func bamChiaSe() {
        let vc = UIActivityViewController(activityItems: [anh], applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(vc, animated: true)
    }
}

// MARK: - 3. Giao Diện Chính Công Cụ AI Truyền Thông & Tự Đăng MXH (Nhúng Trong ManHinhChinh)

final class BangTruyenThongMXHView: UIView, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    weak var vcCha: UIViewController?

    private let nganChinh = UIStackView()

    // Thẻ 1: Trạng thái liên kết tài khoản MXH
    private let nganDanhSachKenh = UIStackView()
    private let nutQuanLyLienKet = UIButton(type: .system)

    // Thẻ 2: Tải ảnh & thông tin nhanh
    private let khungAnhGoc = UIImageView()
    private let nhanHuongDanAnh = UILabel()
    private let nutChonAnh = UIButton(type: .system)
    private let oThongTinSanPham = UITextField()
    private let oGiaUuDai = UITextField()
    private let nutTaoDeXuatAI = UIButton(type: .system)
    private let vongXoayAI = UIActivityIndicatorView(style: .medium)
    private let nhanTrangThaiAI = UILabel()

    // Thẻ 3: Chọn lựa & duyệt các đề xuất AI
    private let theDeXuat = UIView()
    private let nganNutPhuongAn = UIStackView()
    private let nhanGocTiepCan = UILabel()
    private let anhPosterPreview = UIImageView()
    private let nutDoiPhongCach = UIButton(type: .system)
    private let nutDoiTyLe = UIButton(type: .system)
    private let nutSuaChuTrenAnh = UIButton(type: .system)
    private let nganTabNenTang = UIStackView()
    private let oNoiDungBaiViet = UITextView()
    private let nutDuyetVaDang = UIButton(type: .system)
    private let nutChiaSeNhanh = UIButton(type: .system)
    private let nutLuuAnhVaCopy = UIButton(type: .system)
    private let nhanKetQuaDang = UILabel()

    // Thẻ 4: Lịch sử đăng gần đây
    private let nganLichSu = UIStackView()

    // Trạng thái hoạt động
    private var anhGocDaChon: UIImage?
    private var danhSachDeXuat: [DeXuatBaiDangMXH] = []
    private var chiSoDeXuatDangChon: Int = 0
    private var nenTangDangXem: NenTangMXH = .facebook
    private var phongCachDangChon: PhongCachThietKeAnh = .flashSale
    private var tyLeDangChon: TyLeAnhMXH = .vuong1x1
    private var anhPosterHienTai: UIImage?
    private var dangXuLyAI: Bool = false
    private var dangDangBai: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
        napDuLieu()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    func napDuLieu() {
        capNhatDanhSachKenh()
        capNhatLichSu()
        capNhatHienThiDeXuat()
    }

    // MARK: - Xây Dựng Giao Diện Chuẩn ĐMX (Sáng Tươi, 100% Không Cắt Chữ)

    private func taoGiaoDien() {
        backgroundColor = .clear

        nganChinh.axis = .vertical
        nganChinh.spacing = 14
        nganChinh.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nganChinh)

        NSLayoutConstraint.activate([
            nganChinh.topAnchor.constraint(equalTo: topAnchor),
            nganChinh.leadingAnchor.constraint(equalTo: leadingAnchor),
            nganChinh.trailingAnchor.constraint(equalTo: trailingAnchor),
            nganChinh.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        nganChinh.addArrangedSubview(taoTheLienKetKenh())
        nganChinh.addArrangedSubview(taoTheTaiAnhVaAI())
        nganChinh.addArrangedSubview(taoTheDuyetDeXuat())
        nganChinh.addArrangedSubview(taoTheLichSu())
    }

    private func taoKhungThe() -> (the: UIView, stack: UIStackView) {
        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 14
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: the.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -14)
        ])

        return (the, stack)
    }

    private func taoNhan(_ text: String, co: CGFloat, dam: UIFont.Weight, mau: UIColor) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: co, weight: dam)
        lbl.textColor = mau
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.adjustsFontSizeToFitWidth = false
        return lbl
    }

    private func cauHinhNutDaDong(_ nut: UIButton, tieuDe: String, co: CGFloat, dam: UIFont.Weight, nen: UIColor, chu: UIColor, vien: UIColor? = nil) {
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: co, weight: dam)
        nut.titleLabel?.numberOfLines = 0
        nut.titleLabel?.lineBreakMode = .byWordWrapping
        nut.titleLabel?.textAlignment = .center
        nut.titleLabel?.adjustsFontSizeToFitWidth = false
        nut.setTitleColor(chu, for: .normal)
        nut.backgroundColor = nen
        nut.layer.cornerRadius = 10
        if let vien = vien {
            nut.layer.borderWidth = 1
            nut.layer.borderColor = vien.cgColor
        } else {
            nut.layer.borderWidth = 0
        }
        nut.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }

    private func cauHinhONhap(_ o: UITextField, goiY: String) {
        o.placeholder = goiY
        o.font = .systemFont(ofSize: 14, weight: .regular)
        o.textColor = BangMauBCTD.chuChinh
        o.backgroundColor = BangMauBCTD.nenThePhu
        o.layer.cornerRadius = 10
        o.layer.borderWidth = 1
        o.layer.borderColor = BangMauBCTD.vienDam.cgColor
        o.clearButtonMode = .whileEditing
        o.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 10))
        o.leftViewMode = .always
        o.heightAnchor.constraint(greaterThanOrEqualToConstant: 42).isActive = true
    }

    // MARK: - Thẻ 1: Liên kết tài khoản mạng xã hội

    private func taoTheLienKetKenh() -> UIView {
        let (the, stack) = taoKhungThe()
        stack.addArrangedSubview(taoNhan("1️⃣ Tài khoản mạng xã hội nhận bài tự động", co: 15.5, dam: .bold, mau: BangMauBCTD.xanhChuDaoDam))
        stack.addArrangedSubview(taoNhan("Bật/tắt các kênh muốn lên bài sau khi bạn chọn và duyệt đề xuất.", co: 12.5, dam: .regular, mau: BangMauBCTD.chuPhu))

        nganDanhSachKenh.axis = .vertical
        nganDanhSachKenh.spacing = 8
        stack.addArrangedSubview(nganDanhSachKenh)

        cauHinhNutDaDong(
            nutQuanLyLienKet,
            tieuDe: "🔗 Cài đặt liên kết Facebook Page, Zalo OA, TikTok",
            co: 14,
            dam: .bold,
            nen: BangMauBCTD.nenHeaderPhu,
            chu: BangMauBCTD.xanhChuDaoDam,
            vien: BangMauBCTD.vienXanhNhat
        )
        nutQuanLyLienKet.addTarget(self, action: #selector(bamMoQuanLyLienKet), for: .touchUpInside)
        stack.addArrangedSubview(nutQuanLyLienKet)

        return the
    }

    private func capNhatDanhSachKenh() {
        nganDanhSachKenh.arrangedSubviews.forEach {
            nganDanhSachKenh.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let ch = QuanLyDuLieuMXH.dungChung.cauHinh
        for (idx, nenTang) in NenTangMXH.allCases.enumerated() {
            let dong = UIView()
            dong.backgroundColor = BangMauBCTD.nenThePhu
            dong.layer.cornerRadius = 10
            dong.layer.borderWidth = 1
            dong.layer.borderColor = BangMauBCTD.vienThe.cgColor

            let icon = UIImageView(image: UIImage(systemName: nenTang.bieuTuongSF))
            icon.tintColor = nenTang.mauChuDao
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            dong.addSubview(icon)

            let daLK = ch.daLienKet(nenTang)
            let tenKenh = ch.tenHienThi(nenTang)
            let trangThaiText = daLK ? "✅ Đã liên kết: \(tenKenh)" : "⚠️ Chưa liên kết API (vẫn dùng Chia sẻ nhanh được)"
            let mauTT = daLK ? BangMauBCTD.xanhDatChu : BangMauBCTD.vangKhaChu

            let stackChu = UIStackView()
            stackChu.axis = .vertical
            stackChu.spacing = 2
            stackChu.translatesAutoresizingMaskIntoConstraints = false
            stackChu.addArrangedSubview(taoNhan(nenTang.tieuDe, co: 14, dam: .bold, mau: BangMauBCTD.chuChinh))
            stackChu.addArrangedSubview(taoNhan(trangThaiText, co: 12, dam: .semibold, mau: mauTT))
            dong.addSubview(stackChu)

            let congTac = UISwitch()
            congTac.isOn = ch.dangBat(nenTang)
            congTac.onTintColor = BangMauBCTD.xanhChuDao
            congTac.tag = idx
            congTac.addTarget(self, action: #selector(doiCongTacKenh(_:)), for: .valueChanged)
            congTac.translatesAutoresizingMaskIntoConstraints = false
            dong.addSubview(congTac)

            NSLayoutConstraint.activate([
                icon.leadingAnchor.constraint(equalTo: dong.leadingAnchor, constant: 12),
                icon.centerYAnchor.constraint(equalTo: dong.centerYAnchor),
                icon.widthAnchor.constraint(equalToConstant: 24),
                icon.heightAnchor.constraint(equalToConstant: 24),

                stackChu.topAnchor.constraint(equalTo: dong.topAnchor, constant: 10),
                stackChu.bottomAnchor.constraint(equalTo: dong.bottomAnchor, constant: -10),
                stackChu.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
                stackChu.trailingAnchor.constraint(equalTo: congTac.leadingAnchor, constant: -10),

                congTac.trailingAnchor.constraint(equalTo: dong.trailingAnchor, constant: -12),
                congTac.centerYAnchor.constraint(equalTo: dong.centerYAnchor)
            ])

            nganDanhSachKenh.addArrangedSubview(dong)
        }
    }

    @objc private func doiCongTacKenh(_ sender: UISwitch) {
        let tatCa = NenTangMXH.allCases
        guard sender.tag >= 0, sender.tag < tatCa.count else { return }
        var ch = QuanLyDuLieuMXH.dungChung.cauHinh
        ch.datBat(tatCa[sender.tag], bat: sender.isOn)
        QuanLyDuLieuMXH.dungChung.cauHinh = ch
    }

    @objc private func bamMoQuanLyLienKet() {
        guard let cha = timViewController() else { return }
        let manHinh = ManHinhLienKetMXH()
        manHinh.khiDaLuu = { [weak self] in
            self?.capNhatDanhSachKenh()
            self?.veLaiPosterNeuCo()
        }
        let nav = UINavigationController(rootViewController: manHinh)
        nav.modalPresentationStyle = .pageSheet
        cha.present(nav, animated: true)
    }

    // MARK: - Thẻ 2: Gửi hình ảnh & chạy AI thiết kế + tạo đề xuất

    private func taoTheTaiAnhVaAI() -> UIView {
        let (the, stack) = taoKhungThe()
        stack.addArrangedSubview(taoNhan("2️⃣ Gửi ảnh sản phẩm để AI thiết kế & viết bài", co: 15.5, dam: .bold, mau: BangMauBCTD.xanhChuDaoDam))
        stack.addArrangedSubview(taoNhan("Chỉ cần chọn hoặc chụp 1 ảnh sản phẩm. AI sẽ tự nhận diện, thiết kế poster bắt mắt và đề xuất 3 phương án bài viết cho Facebook, Zalo OA, TikTok.", co: 12.5, dam: .regular, mau: BangMauBCTD.chuPhu))

        let khungXemTruoc = UIView()
        khungXemTruoc.backgroundColor = BangMauBCTD.nenThePhu
        khungXemTruoc.layer.cornerRadius = 12
        khungXemTruoc.layer.borderWidth = 1.5
        khungXemTruoc.layer.borderColor = BangMauBCTD.vienXanhNhat.cgColor
        khungXemTruoc.clipsToBounds = true
        khungXemTruoc.isUserInteractionEnabled = true
        khungXemTruoc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bamChonAnh)))

        khungAnhGoc.contentMode = .scaleAspectFit
        khungAnhGoc.translatesAutoresizingMaskIntoConstraints = false
        khungXemTruoc.addSubview(khungAnhGoc)

        nhanHuongDanAnh.text = "📸 Chạm vào đây để chọn ảnh từ Thư viện hoặc Chụp ảnh sản phẩm"
        nhanHuongDanAnh.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nhanHuongDanAnh.textColor = BangMauBCTD.xanhChuDaoDam
        nhanHuongDanAnh.textAlignment = .center
        nhanHuongDanAnh.numberOfLines = 0
        nhanHuongDanAnh.lineBreakMode = .byWordWrapping
        nhanHuongDanAnh.adjustsFontSizeToFitWidth = false
        nhanHuongDanAnh.translatesAutoresizingMaskIntoConstraints = false
        khungXemTruoc.addSubview(nhanHuongDanAnh)

        NSLayoutConstraint.activate([
            khungXemTruoc.heightAnchor.constraint(equalToConstant: 190),
            khungAnhGoc.topAnchor.constraint(equalTo: khungXemTruoc.topAnchor, constant: 6),
            khungAnhGoc.bottomAnchor.constraint(equalTo: khungXemTruoc.bottomAnchor, constant: -6),
            khungAnhGoc.leadingAnchor.constraint(equalTo: khungXemTruoc.leadingAnchor, constant: 6),
            khungAnhGoc.trailingAnchor.constraint(equalTo: khungXemTruoc.trailingAnchor, constant: -6),

            nhanHuongDanAnh.centerYAnchor.constraint(equalTo: khungXemTruoc.centerYAnchor),
            nhanHuongDanAnh.leadingAnchor.constraint(equalTo: khungXemTruoc.leadingAnchor, constant: 18),
            nhanHuongDanAnh.trailingAnchor.constraint(equalTo: khungXemTruoc.trailingAnchor, constant: -18)
        ])
        stack.addArrangedSubview(khungXemTruoc)

        cauHinhNutDaDong(
            nutChonAnh,
            tieuDe: "🖼️ Chọn ảnh sản phẩm / Chụp ảnh mới",
            co: 14,
            dam: .bold,
            nen: BangMauBCTD.nenHeaderPhu,
            chu: BangMauBCTD.xanhChuDaoDam,
            vien: BangMauBCTD.vienXanhNhat
        )
        nutChonAnh.addTarget(self, action: #selector(bamChonAnh), for: .touchUpInside)
        stack.addArrangedSubview(nutChonAnh)

        cauHinhONhap(oThongTinSanPham, goiY: "Ghi chú thêm cho AI (tùy chọn): VD Máy lạnh Daikin Inverter 1HP")
        stack.addArrangedSubview(oThongTinSanPham)

        cauHinhONhap(oGiaUuDai, goiY: "Giá / Ưu đãi nổi bật (tùy chọn): VD Giảm 2 triệu • Trả góp 0%")
        stack.addArrangedSubview(oGiaUuDai)

        cauHinhNutDaDong(
            nutTaoDeXuatAI,
            tieuDe: "✨ AI Thiết Kế Ảnh & Tạo 3 Đề Xuất Bài Viết",
            co: 15,
            dam: .heavy,
            nen: BangMauBCTD.vangSang,
            chu: BangMauBCTD.chuChinh,
            vien: BangMauBCTD.vangKhaVach
        )
        nutTaoDeXuatAI.addTarget(self, action: #selector(bamChayAITaoDeXuat), for: .touchUpInside)
        stack.addArrangedSubview(nutTaoDeXuatAI)

        let hangTrangThai = UIStackView()
        hangTrangThai.axis = .horizontal
        hangTrangThai.spacing = 8
        hangTrangThai.alignment = .center
        vongXoayAI.hidesWhenStopped = true
        vongXoayAI.color = BangMauBCTD.xanhChuDao
        nhanTrangThaiAI.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanTrangThaiAI.textColor = BangMauBCTD.chuPhu
        nhanTrangThaiAI.numberOfLines = 0
        nhanTrangThaiAI.lineBreakMode = .byWordWrapping
        nhanTrangThaiAI.adjustsFontSizeToFitWidth = false
        hangTrangThai.addArrangedSubview(vongXoayAI)
        hangTrangThai.addArrangedSubview(nhanTrangThaiAI)
        stack.addArrangedSubview(hangTrangThai)

        return the
    }

    // MARK: - Thẻ 3: Chọn lựa đề xuất, xem poster AI, chỉnh sửa & duyệt đăng

    private func taoTheDuyetDeXuat() -> UIView {
        let (the, stack) = taoKhungThe()
        theDeXuat.backgroundColor = .clear
        theDeXuat.translatesAutoresizingMaskIntoConstraints = false
        the.translatesAutoresizingMaskIntoConstraints = false
        theDeXuat.addSubview(the)
        NSLayoutConstraint.activate([
            the.topAnchor.constraint(equalTo: theDeXuat.topAnchor),
            the.leadingAnchor.constraint(equalTo: theDeXuat.leadingAnchor),
            the.trailingAnchor.constraint(equalTo: theDeXuat.trailingAnchor),
            the.bottomAnchor.constraint(equalTo: theDeXuat.bottomAnchor)
        ])

        stack.addArrangedSubview(taoNhan("3️⃣ Chọn lựa đề xuất & Duyệt đăng", co: 15.5, dam: .bold, mau: BangMauBCTD.camPhanTich))
        stack.addArrangedSubview(taoNhan("Chạm chọn 1 trong 3 phương án AI đề xuất bên dưới, xem ảnh đã thiết kế, chỉnh sửa chữ nếu cần rồi bấm Duyệt & Đăng.", co: 12.5, dam: .regular, mau: BangMauBCTD.chuPhu))

        nganNutPhuongAn.axis = .vertical
        nganNutPhuongAn.spacing = 8
        stack.addArrangedSubview(nganNutPhuongAn)

        nhanGocTiepCan.font = .systemFont(ofSize: 12.5, weight: .semibold)
        nhanGocTiepCan.textColor = BangMauBCTD.xanhChuDaoDam
        nhanGocTiepCan.numberOfLines = 0
        nhanGocTiepCan.lineBreakMode = .byWordWrapping
        nhanGocTiepCan.adjustsFontSizeToFitWidth = false
        stack.addArrangedSubview(nhanGocTiepCan)

        // Ảnh Poster thiết kế AI (chạm để phóng to)
        anhPosterPreview.contentMode = .scaleAspectFit
        anhPosterPreview.backgroundColor = BangMauBCTD.nenThePhu
        anhPosterPreview.layer.cornerRadius = 12
        anhPosterPreview.layer.borderWidth = 1
        anhPosterPreview.layer.borderColor = BangMauBCTD.vienDam.cgColor
        anhPosterPreview.clipsToBounds = true
        anhPosterPreview.isUserInteractionEnabled = true
        anhPosterPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bamXemToanManHinhPoster)))
        anhPosterPreview.heightAnchor.constraint(equalToConstant: 320).isActive = true
        stack.addArrangedSubview(anhPosterPreview)

        // Hàng nút tinh chỉnh ảnh thiết kế
        let hangChinhAnh = UIStackView()
        hangChinhAnh.axis = .horizontal
        hangChinhAnh.spacing = 8
        hangChinhAnh.distribution = .fillEqually

        cauHinhNutDaDong(nutDoiPhongCach, tieuDe: "🎨 Đổi mẫu thiết kế", co: 12.5, dam: .bold, nen: BangMauBCTD.nenHeaderPhu, chu: BangMauBCTD.xanhChuDaoDam, vien: BangMauBCTD.vienXanhNhat)
        nutDoiPhongCach.addTarget(self, action: #selector(bamDoiPhongCach), for: .touchUpInside)

        cauHinhNutDaDong(nutDoiTyLe, tieuDe: "📐 Tỷ lệ: 1:1", co: 12.5, dam: .bold, nen: BangMauBCTD.nenHeaderPhu, chu: BangMauBCTD.xanhChuDaoDam, vien: BangMauBCTD.vienXanhNhat)
        nutDoiTyLe.addTarget(self, action: #selector(bamDoiTyLe), for: .touchUpInside)

        hangChinhAnh.addArrangedSubview(nutDoiPhongCach)
        hangChinhAnh.addArrangedSubview(nutDoiTyLe)
        stack.addArrangedSubview(hangChinhAnh)

        cauHinhNutDaDong(nutSuaChuTrenAnh, tieuDe: "✏️ Chỉnh tiêu đề / giá / CTA in trên ảnh poster", co: 13, dam: .semibold, nen: BangMauBCTD.nenThePhu, chu: BangMauBCTD.chuChinh, vien: BangMauBCTD.vienDam)
        nutSuaChuTrenAnh.addTarget(self, action: #selector(bamSuaChuTrenAnh), for: .touchUpInside)
        stack.addArrangedSubview(nutSuaChuTrenAnh)

        // Tab xem & sửa nội dung bài viết theo từng nền tảng
        stack.addArrangedSubview(taoNhan("Nội dung bài truyền thông theo từng kênh (chạm để chỉnh sửa trực tiếp):", co: 13, dam: .bold, mau: BangMauBCTD.chuChinh))

        nganTabNenTang.axis = .horizontal
        nganTabNenTang.spacing = 8
        nganTabNenTang.distribution = .fillEqually
        stack.addArrangedSubview(nganTabNenTang)

        oNoiDungBaiViet.font = .systemFont(ofSize: 14, weight: .regular)
        oNoiDungBaiViet.textColor = BangMauBCTD.chuChinh
        oNoiDungBaiViet.backgroundColor = BangMauBCTD.nenThePhu
        oNoiDungBaiViet.layer.cornerRadius = 10
        oNoiDungBaiViet.layer.borderWidth = 1
        oNoiDungBaiViet.layer.borderColor = BangMauBCTD.vienDam.cgColor
        oNoiDungBaiViet.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        oNoiDungBaiViet.delegate = self
        oNoiDungBaiViet.heightAnchor.constraint(equalToConstant: 210).isActive = true
        stack.addArrangedSubview(oNoiDungBaiViet)

        // Nút hành động Duyệt & Đăng
        cauHinhNutDaDong(
            nutDuyetVaDang,
            tieuDe: "✅ Duyệt & Tự Động Đăng Các Kênh Đã Chọn",
            co: 15,
            dam: .heavy,
            nen: BangMauBCTD.xanhLaDam,
            chu: .white
        )
        nutDuyetVaDang.addTarget(self, action: #selector(bamDuyetVaDang), for: .touchUpInside)
        stack.addArrangedSubview(nutDuyetVaDang)

        let hangPhu = UIStackView()
        hangPhu.axis = .horizontal
        hangPhu.spacing = 8
        hangPhu.distribution = .fillEqually

        cauHinhNutDaDong(nutChiaSeNhanh, tieuDe: "📤 Chia sẻ nhanh sang App", co: 13, dam: .bold, nen: BangMauBCTD.xanhChuDao, chu: .white)
        nutChiaSeNhanh.addTarget(self, action: #selector(bamChiaSeNhanh), for: .touchUpInside)

        cauHinhNutDaDong(nutLuuAnhVaCopy, tieuDe: "📋 Copy bài & Lưu ảnh", co: 13, dam: .bold, nen: BangMauBCTD.nenHeaderPhu, chu: BangMauBCTD.xanhChuDaoDam, vien: BangMauBCTD.vienXanhNhat)
        nutLuuAnhVaCopy.addTarget(self, action: #selector(bamLuuAnhVaCopy), for: .touchUpInside)

        hangPhu.addArrangedSubview(nutChiaSeNhanh)
        hangPhu.addArrangedSubview(nutLuuAnhVaCopy)
        stack.addArrangedSubview(hangPhu)

        nhanKetQuaDang.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanKetQuaDang.textColor = BangMauBCTD.chuChinh
        nhanKetQuaDang.numberOfLines = 0
        nhanKetQuaDang.lineBreakMode = .byWordWrapping
        nhanKetQuaDang.adjustsFontSizeToFitWidth = false
        nhanKetQuaDang.isHidden = true
        stack.addArrangedSubview(nhanKetQuaDang)

        theDeXuat.isHidden = true
        return theDeXuat
    }

    // MARK: - Thẻ 4: Lịch sử đăng gần đây

    private func taoTheLichSu() -> UIView {
        let (the, stack) = taoKhungThe()
        stack.addArrangedSubview(taoNhan("🕒 Lịch sử duyệt & đăng bài gần đây", co: 15, dam: .bold, mau: BangMauBCTD.chuChinh))
        nganLichSu.axis = .vertical
        nganLichSu.spacing = 8
        stack.addArrangedSubview(nganLichSu)
        return the
    }

    private func capNhatLichSu() {
        nganLichSu.arrangedSubviews.forEach {
            nganLichSu.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let ds = QuanLyDuLieuMXH.dungChung.lichSuDang
        if ds.isEmpty {
            nganLichSu.addArrangedSubview(taoNhan("Chưa có bài truyền thông nào được duyệt đăng.", co: 13, dam: .regular, mau: BangMauBCTD.chuMo))
            return
        }

        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm dd/MM/yyyy"

        for muc in ds.prefix(6) {
            let theCon = UIView()
            theCon.backgroundColor = muc.thanhCongHet ? BangMauBCTD.xanhDatNenDong : BangMauBCTD.vangKhaNenDong
            theCon.layer.cornerRadius = 10
            theCon.layer.borderWidth = 1
            theCon.layer.borderColor = (muc.thanhCongHet ? BangMauBCTD.xanhDatVach : BangMauBCTD.vangKhaVach).withAlphaComponent(0.35).cgColor

            let st = UIStackView()
            st.axis = .vertical
            st.spacing = 4
            st.translatesAutoresizingMaskIntoConstraints = false
            theCon.addSubview(st)

            let dongDau = "\(muc.thanhCongHet ? "✅" : "⚠️") \(muc.tieuDeAnh) • \(fmt.string(from: muc.thoiGian))"
            st.addArrangedSubview(taoNhan(dongDau, co: 13, dam: .bold, mau: BangMauBCTD.chuChinh))
            st.addArrangedSubview(taoNhan("Kênh: \(muc.cacNenTang.joined(separator: ", "))", co: 12, dam: .semibold, mau: BangMauBCTD.chuPhu))
            st.addArrangedSubview(taoNhan(muc.ketQuaChiTiet.joined(separator: "\n"), co: 12, dam: .regular, mau: BangMauBCTD.chuPhu))

            NSLayoutConstraint.activate([
                st.topAnchor.constraint(equalTo: theCon.topAnchor, constant: 10),
                st.leadingAnchor.constraint(equalTo: theCon.leadingAnchor, constant: 10),
                st.trailingAnchor.constraint(equalTo: theCon.trailingAnchor, constant: -10),
                st.bottomAnchor.constraint(equalTo: theCon.bottomAnchor, constant: -10)
            ])
            nganLichSu.addArrangedSubview(theCon)
        }
    }

    // MARK: - Chọn Ảnh Từ Thư Viện Hoặc Camera (Dùng HopChonDMXController chuẩn ĐMX)

    @objc private func bamChonAnh() {
        guard let cha = timViewController() else { return }
        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "🖼️ Chọn ảnh từ Thư viện ảnh") { [weak self] in
                self?.moThuVienAnh()
            }
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cacMuc.append(MucChonDMX(tieuDe: "📸 Chụp ảnh sản phẩm trực tiếp") { [weak self] in
                self?.moCamera()
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        cha.hienMenuChon(
            tieuDe: "Chọn ảnh sản phẩm",
            thongDiep: "Ảnh sẽ được AI phân tích và tự động thiết kế thành poster quảng cáo bắt mắt.",
            cacMuc: cacMuc
        )
    }

    private func moThuVienAnh() {
        guard let cha = timViewController() else { return }
        var cfg = PHPickerConfiguration(photoLibrary: .shared())
        cfg.filter = .images
        cfg.selectionLimit = 1
        let picker = PHPickerViewController(configuration: cfg)
        picker.delegate = self
        cha.present(picker, animated: true)
    }

    private func moCamera() {
        guard let cha = timViewController(), UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        cha.present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] obj, _ in
            guard let img = obj as? UIImage else { return }
            DispatchQueue.main.async {
                self?.ganAnhGocMoi(img)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let img = info[.originalImage] as? UIImage {
            ganAnhGocMoi(img)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func ganAnhGocMoi(_ anh: UIImage) {
        anhGocDaChon = anh
        khungAnhGoc.image = anh
        nhanHuongDanAnh.isHidden = true
        nhanTrangThaiAI.text = "✅ Đã nhận ảnh sản phẩm. Bấm nút vàng bên trên để AI thiết kế poster & đề xuất 3 bài viết."
        nhanTrangThaiAI.textColor = BangMauBCTD.xanhDatChu
        if !danhSachDeXuat.isEmpty {
            veLaiPosterNeuCo()
        }
    }

    // MARK: - Chạy AI Thiết Kế & Đề Xuất 3 Bài Viết

    @objc private func bamChayAITaoDeXuat() {
        endEditing(true)
        guard let anh = anhGocDaChon else {
            hienThongBao(tieuDe: "Chưa có hình ảnh", noiDung: "Vui lòng chọn hoặc chụp 1 hình ảnh sản phẩm trước khi chạy AI.")
            return
        }
        guard !dangXuLyAI else { return }

        dangXuLyAI = true
        nutTaoDeXuatAI.isEnabled = false
        nutTaoDeXuatAI.alpha = 0.65
        vongXoayAI.startAnimating()
        nhanTrangThaiAI.text = "🤖 AI đang phân tích hình ảnh, thiết kế poster và soạn 3 đề xuất bài viết cho Facebook, Zalo OA, TikTok..."
        nhanTrangThaiAI.textColor = BangMauBCTD.xanhChuDaoDam

        let thongTin = (oThongTinSanPham.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let gia = (oGiaUuDai.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let cauHinh = QuanLyDuLieuMXH.dungChung.cauHinh

        DichVuAITruyenThongMXH.dungChung.taoDeXuatTuAnh(
            anh: anh,
            thongTinBoSung: thongTin,
            giaUuDai: gia,
            cauHinh: cauHinh
        ) { [weak self] ketQua in
            guard let self = self else { return }
            self.dangXuLyAI = false
            self.nutTaoDeXuatAI.isEnabled = true
            self.nutTaoDeXuatAI.alpha = 1.0
            self.vongXoayAI.stopAnimating()

            switch ketQua {
            case .success(let ds):
                self.danhSachDeXuat = ds
                self.chiSoDeXuatDangChon = 0
                if let dau = ds.first {
                    self.phongCachDangChon = dau.phongCach
                }
                self.nhanTrangThaiAI.text = "✅ Đã tạo xong \(ds.count) đề xuất bài viết + ảnh thiết kế! Hãy chọn phương án ưng ý bên dưới để duyệt đăng."
                self.nhanTrangThaiAI.textColor = BangMauBCTD.xanhDatChu
                self.nhanKetQuaDang.isHidden = true
                self.capNhatHienThiDeXuat()
            case .failure(let loi):
                self.nhanTrangThaiAI.text = "⚠️ Không thể tạo đề xuất: \(loi.localizedDescription)"
                self.nhanTrangThaiAI.textColor = BangMauBCTD.doYeuChu
            }
        }
    }

    // MARK: - Hiển Thị & Tương Tác Đề Xuất

    private func capNhatHienThiDeXuat() {
        guard !danhSachDeXuat.isEmpty, chiSoDeXuatDangChon < danhSachDeXuat.count else {
            theDeXuat.isHidden = true
            return
        }
        theDeXuat.isHidden = false

        // 1. Vẽ danh sách nút chọn 3 phương án đề xuất
        nganNutPhuongAn.arrangedSubviews.forEach {
            nganNutPhuongAn.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for (idx, dx) in danhSachDeXuat.enumerated() {
            let dangChon = (idx == chiSoDeXuatDangChon)
            let nut = UIButton(type: .system)
            let tienTo = dangChon ? "✅ " : "⚪️ "
            cauHinhNutDaDong(
                nut,
                tieuDe: "\(tienTo)\(dx.tenPhuongAn)",
                co: 13.5,
                dam: dangChon ? .bold : .semibold,
                nen: dangChon ? BangMauBCTD.vangNhatNen : BangMauBCTD.nenThePhu,
                chu: dangChon ? BangMauBCTD.camPhanTich : BangMauBCTD.chuChinh,
                vien: dangChon ? BangMauBCTD.vangKhaVach : BangMauBCTD.vienThe
            )
            nut.contentHorizontalAlignment = .leading
            nut.titleLabel?.textAlignment = .left
            nut.tag = idx
            nut.addTarget(self, action: #selector(bamChonPhuongAn(_:)), for: .touchUpInside)
            nganNutPhuongAn.addArrangedSubview(nut)
        }

        let hienTai = danhSachDeXuat[chiSoDeXuatDangChon]
        nhanGocTiepCan.text = "💡 Góc tiếp cận: \(hienTai.gocTiepCan)"
        nutDoiPhongCach.setTitle("🎨 Mẫu: \(phongCachDangChon.tieuDeNgan)", for: .normal)
        nutDoiTyLe.setTitle("📐 Tỷ lệ: \(tyLeDangChon.rawValue)", for: .normal)

        // 2. Vẽ các tab nền tảng FB / Zalo OA / TikTok
        nganTabNenTang.arrangedSubviews.forEach {
            nganTabNenTang.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for (idx, nt) in NenTangMXH.allCases.enumerated() {
            let dangChon = (nt == nenTangDangXem)
            let nut = UIButton(type: .system)
            cauHinhNutDaDong(
                nut,
                tieuDe: nt.tieuDeNgan,
                co: 13,
                dam: .bold,
                nen: dangChon ? nt.mauChuDao : BangMauBCTD.nenThePhu,
                chu: dangChon ? .white : BangMauBCTD.chuChinh,
                vien: dangChon ? nil : BangMauBCTD.vienDam
            )
            nut.tag = idx
            nut.addTarget(self, action: #selector(bamChonTabNenTang(_:)), for: .touchUpInside)
            nganTabNenTang.addArrangedSubview(nut)
        }

        // 3. Nạp nội dung bài viết theo nền tảng đang chọn
        oNoiDungBaiViet.text = hienTai.noiDung(cho: nenTangDangXem)

        // 4. Vẽ poster thiết kế AI
        veLaiPosterNeuCo()
    }

    private func veLaiPosterNeuCo() {
        guard let anhGoc = anhGocDaChon,
              !danhSachDeXuat.isEmpty,
              chiSoDeXuatDangChon < danhSachDeXuat.count else { return }

        let dx = danhSachDeXuat[chiSoDeXuatDangChon]
        let ch = QuanLyDuLieuMXH.dungChung.cauHinh
        let pc = phongCachDangChon
        let tl = tyLeDangChon

        DispatchQueue.global(qos: .userInitiated).async {
            let poster = BoThietKeAnhQuangCaoDMX.veAnhQuangCao(
                anhGoc: anhGoc,
                deXuat: dx,
                phongCach: pc,
                tyLe: tl,
                tenSieuThi: ch.tenSieuThiMacDinh,
                hotline: ch.hotlineMacDinh
            )
            DispatchQueue.main.async { [weak self] in
                self?.anhPosterHienTai = poster
                self?.anhPosterPreview.image = poster
            }
        }
    }

    @objc private func bamChonPhuongAn(_ sender: UIButton) {
        guard sender.tag >= 0, sender.tag < danhSachDeXuat.count else { return }
        chiSoDeXuatDangChon = sender.tag
        phongCachDangChon = danhSachDeXuat[chiSoDeXuatDangChon].phongCach
        capNhatHienThiDeXuat()
    }

    @objc private func bamChonTabNenTang(_ sender: UIButton) {
        let tatCa = NenTangMXH.allCases
        guard sender.tag >= 0, sender.tag < tatCa.count else { return }
        nenTangDangXem = tatCa[sender.tag]
        tyLeDangChon = nenTangDangXem.tyLeAnhMacDinh
        capNhatHienThiDeXuat()
    }

    func textViewDidChange(_ textView: UITextView) {
        guard textView === oNoiDungBaiViet, chiSoDeXuatDangChon < danhSachDeXuat.count else { return }
        danhSachDeXuat[chiSoDeXuatDangChon].capNhatNoiDung(textView.text ?? "", cho: nenTangDangXem)
    }

    @objc private func bamDoiPhongCach() {
        guard let cha = timViewController() else { return }
        var cacMuc = PhongCachThietKeAnh.allCases.map { pc in
            MucChonDMX(tieuDe: pc.tieuDe, dangChon: pc == phongCachDangChon) { [weak self] in
                self?.phongCachDangChon = pc
                if let idx = self?.chiSoDeXuatDangChon, idx < (self?.danhSachDeXuat.count ?? 0) {
                    self?.danhSachDeXuat[idx].phongCach = pc
                }
                self?.capNhatHienThiDeXuat()
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        cha.hienMenuChon(tieuDe: "Chọn phong cách thiết kế poster", cacMuc: cacMuc)
    }

    @objc private func bamDoiTyLe() {
        guard let cha = timViewController() else { return }
        var cacMuc = TyLeAnhMXH.allCases.map { tl in
            MucChonDMX(tieuDe: tl.tieuDe, dangChon: tl == tyLeDangChon) { [weak self] in
                self?.tyLeDangChon = tl
                self?.capNhatHienThiDeXuat()
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        cha.hienMenuChon(tieuDe: "Chọn tỷ lệ khung ảnh", cacMuc: cacMuc)
    }

    @objc private func bamSuaChuTrenAnh() {
        guard let cha = timViewController(), chiSoDeXuatDangChon < danhSachDeXuat.count else { return }
        let dx = danhSachDeXuat[chiSoDeXuatDangChon]
        let alert = UIAlertController(
            title: "Chỉnh chữ in trên ảnh poster",
            message: "Chỉnh nhanh tiêu đề, nhãn nổi bật, giá/ưu đãi và câu kêu gọi hành động.",
            preferredStyle: .alert
        )
        alert.addTextField { tf in tf.placeholder = "Tiêu đề chính"; tf.text = dx.tieuDeAnh }
        alert.addTextField { tf in tf.placeholder = "Phụ đề"; tf.text = dx.phuDeAnh }
        alert.addTextField { tf in tf.placeholder = "Nhãn góc trên (VD: FLASH SALE)"; tf.text = dx.nhanNoiBat }
        alert.addTextField { tf in tf.placeholder = "Tem giá / ưu đãi"; tf.text = dx.giaHienThi }
        alert.addTextField { tf in tf.placeholder = "Thanh CTA dưới cùng"; tf.text = dx.ctaAnh }

        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cập nhật poster", style: .default) { [weak self] _ in
            guard let self = self, self.chiSoDeXuatDangChon < self.danhSachDeXuat.count else { return }
            let fields = alert.textFields ?? []
            if fields.count >= 5 {
                self.danhSachDeXuat[self.chiSoDeXuatDangChon].tieuDeAnh = fields[0].text ?? ""
                self.danhSachDeXuat[self.chiSoDeXuatDangChon].phuDeAnh = fields[1].text ?? ""
                self.danhSachDeXuat[self.chiSoDeXuatDangChon].nhanNoiBat = fields[2].text ?? ""
                self.danhSachDeXuat[self.chiSoDeXuatDangChon].giaHienThi = fields[3].text ?? ""
                self.danhSachDeXuat[self.chiSoDeXuatDangChon].ctaAnh = fields[4].text ?? ""
                self.veLaiPosterNeuCo()
            }
        })
        cha.present(alert, animated: true)
    }

    @objc private func bamXemToanManHinhPoster() {
        guard let cha = timViewController(), let anh = anhPosterHienTai else { return }
        let vc = ManHinhXemAnhThietKeMXH(anh: anh, tieuDe: "Ảnh thiết kế AI")
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        cha.present(nav, animated: true)
    }

    // MARK: - Duyệt & Đăng Bài Tự Động Đa Kênh

    @objc private func bamDuyetVaDang() {
        endEditing(true)
        guard let cha = timViewController(),
              let anhGoc = anhGocDaChon,
              chiSoDeXuatDangChon < danhSachDeXuat.count else { return }
        guard !dangDangBai else { return }

        let ch = QuanLyDuLieuMXH.dungChung.cauHinh
        let cacKenhBat = NenTangMXH.allCases.filter { ch.dangBat($0) }
        guard !cacKenhBat.isEmpty else {
            hienThongBao(tieuDe: "Chưa bật kênh đăng", noiDung: "Vui lòng bật ít nhất 1 kênh (Facebook, Zalo OA hoặc TikTok) ở mục 1.")
            return
        }

        let kenhDaLK = cacKenhBat.filter { ch.daLienKet($0) }
        let dx = danhSachDeXuat[chiSoDeXuatDangChon]

        if kenhDaLK.isEmpty {
            cha.hienMenuChon(
                tieuDe: "Chưa cấu hình API tự đăng",
                thongDiep: "Bạn chưa điền Token API hoặc Webhook cho các kênh đang bật. Bạn muốn làm gì tiếp theo?",
                cacMuc: [
                    MucChonDMX(tieuDe: "🔗 Mở Cài đặt liên kết Facebook / Zalo OA / TikTok") { [weak self] in
                        self?.bamMoQuanLyLienKet()
                    },
                    MucChonDMX(tieuDe: "📤 Dùng Chia sẻ nhanh (kèm ảnh thiết kế & tự copy bài)") { [weak self] in
                        self?.bamChiaSeNhanh()
                    },
                    MucChonDMX(tieuDe: "Đóng", kieu: .huy)
                ]
            )
            return
        }

        let tenCacKenh = kenhDaLK.map(\.tieuDeNgan).joined(separator: ", ")
        cha.hienMenuChon(
            tieuDe: "Xác nhận duyệt & đăng bài",
            thongDiep: "Bạn duyệt \"\(dx.tenPhuongAn)\" và cho phép đăng tự động lên: \(tenCacKenh)?",
            cacMuc: [
                MucChonDMX(tieuDe: "✅ Duyệt & Đăng ngay lên \(tenCacKenh)") { [weak self] in
                    self?.thucThiDangDaKenh(cacKenh: kenhDaLK, anhGoc: anhGoc, deXuat: dx, cauHinh: ch)
                },
                MucChonDMX(tieuDe: "Hủy, xem lại", kieu: .huy)
            ]
        )
    }

    private func thucThiDangDaKenh(
        cacKenh: [NenTangMXH],
        anhGoc: UIImage,
        deXuat: DeXuatBaiDangMXH,
        cauHinh: CauHinhLienKetMXH
    ) {
        dangDangBai = true
        nutDuyetVaDang.isEnabled = false
        nutDuyetVaDang.alpha = 0.65
        nhanKetQuaDang.isHidden = false
        nhanKetQuaDang.text = "⏳ Đang dựng ảnh đúng tỷ lệ từng nền tảng và tự động đăng bài..."
        nhanKetQuaDang.textColor = BangMauBCTD.xanhChuDaoDam

        let pc = phongCachDangChon
        DispatchQueue.global(qos: .userInitiated).async {
            var anhTheoKenh: [NenTangMXH: UIImage] = [:]
            for kenh in cacKenh {
                anhTheoKenh[kenh] = BoThietKeAnhQuangCaoDMX.veAnhQuangCao(
                    anhGoc: anhGoc,
                    deXuat: deXuat,
                    phongCach: pc,
                    tyLe: kenh.tyLeAnhMacDinh,
                    tenSieuThi: cauHinh.tenSieuThiMacDinh,
                    hotline: cauHinh.hotlineMacDinh
                )
            }

            DichVuDangBaiMXH.dungChung.dangDaNenTang(
                cacNenTang: cacKenh,
                deXuat: deXuat,
                anhTheoNenTang: anhTheoKenh,
                cauHinh: cauHinh
            ) { [weak self] ketQua in
                guard let self = self else { return }
                self.dangDangBai = false
                self.nutDuyetVaDang.isEnabled = true
                self.nutDuyetVaDang.alpha = 1.0

                let dongKQ = ketQua.map { kq in
                    "\(kq.thanhCong ? "✅" : "❌") \(kq.nenTang.tieuDeNgan): \(kq.thongBao)"
                }
                let thanhCongHet = !ketQua.isEmpty && ketQua.allSatisfy(\.thanhCong)
                self.nhanKetQuaDang.text = dongKQ.joined(separator: "\n")
                self.nhanKetQuaDang.textColor = thanhCongHet ? BangMauBCTD.xanhDatChu : BangMauBCTD.camPhanTich

                let banGhi = BanGhiLichSuDangMXH(
                    tieuDeAnh: deXuat.tieuDeAnh,
                    tenPhuongAn: deXuat.tenPhuongAn,
                    cacNenTang: cacKenh.map(\.tieuDeNgan),
                    ketQuaChiTiet: dongKQ,
                    thanhCongHet: thanhCongHet
                )
                QuanLyDuLieuMXH.dungChung.themLichSu(banGhi)
                self.capNhatLichSu()
            }
        }
    }

    @objc private func bamChiaSeNhanh() {
        guard let cha = timViewController(),
              let anh = anhPosterHienTai,
              chiSoDeXuatDangChon < danhSachDeXuat.count else { return }
        let noiDung = danhSachDeXuat[chiSoDeXuatDangChon].noiDung(cho: nenTangDangXem)
        UIPasteboard.general.string = noiDung

        let vc = UIActivityViewController(activityItems: [anh, noiDung], applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.sourceView = nutChiaSeNhanh
            pop.sourceRect = nutChiaSeNhanh.bounds
        }
        cha.present(vc, animated: true)

        nhanKetQuaDang.isHidden = false
        nhanKetQuaDang.text = "📋 Đã tự động copy bài viết \(nenTangDangXem.tieuDeNgan) vào bộ nhớ tạm và mở bảng Chia sẻ ảnh."
        nhanKetQuaDang.textColor = BangMauBCTD.xanhDatChu
    }

    @objc private func bamLuuAnhVaCopy() {
        guard let anh = anhPosterHienTai, chiSoDeXuatDangChon < danhSachDeXuat.count else { return }
        let noiDung = danhSachDeXuat[chiSoDeXuatDangChon].noiDung(cho: nenTangDangXem)
        UIPasteboard.general.string = noiDung
        UIImageWriteToSavedPhotosAlbum(anh, nil, nil, nil)

        nhanKetQuaDang.isHidden = false
        nhanKetQuaDang.text = "✅ Đã lưu ảnh thiết kế vào Thư viện ảnh và copy sẵn nội dung bài \(nenTangDangXem.tieuDeNgan)."
        nhanKetQuaDang.textColor = BangMauBCTD.xanhDatChu
    }

    private func timViewController() -> UIViewController? {
        if let cha = vcCha { return cha }
        var r: UIResponder? = self
        while let next = r?.next {
            if let vc = next as? UIViewController { return vc }
            r = next
        }
        return nil
    }

    private func hienThongBao(tieuDe: String, noiDung: String) {
        guard let cha = timViewController() else { return }
        let alert = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đã hiểu", style: .default))
        cha.present(alert, animated: true)
    }
}
