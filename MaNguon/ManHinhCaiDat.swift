import UIKit

final class ManHinhCaiDat: UIViewController {
    private let oNhapKey = UITextField()
    private let chonModel = UISegmentedControl(items: ["gemini-2.5-flash", "gemini-2.0-flash", "gemini-1.5-flash"])
    private let congTacGuiAnh = UISwitch()
    private let congTacGopCongDon = UISwitch()
    private let nutKiemTra = UIButton(type: .system)
    private let nhanKetQuaKiemTra = UILabel()

    private let danhSachModel = ["gemini-2.5-flash", "gemini-2.0-flash", "gemini-1.5-flash"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cài đặt AI & Hệ thống"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(luuCaiDat)
        )

        taoGiaoDien()
        napDuLieu()
    }

    private func taoGiaoDien() {
        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.keyboardDismissMode = .interactive
        cuon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuon)

        let nganXep = UIStackView()
        nganXep.axis = .vertical
        nganXep.spacing = 16
        nganXep.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(nganXep)

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            nganXep.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 16),
            nganXep.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 16),
            nganXep.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -16),
            nganXep.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        // Khối 1: Nhập Gemini API Key
        let tieuDeKey = taoTieuDeNhom("1. GOOGLE AI STUDIO API KEY (MIỄN PHÍ)")
        oNhapKey.placeholder = "Dán mã API Key (bắt đầu bằng AIza...)"
        oNhapKey.borderStyle = .roundedRect
        oNhapKey.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        oNhapKey.clearButtonMode = .whileEditing
        oNhapKey.autocapitalizationType = .none
        oNhapKey.autocorrectionType = .no

        let nutDan = UIButton(type: .system)
        nutDan.setTitle(" Dán Key ", for: .normal)
        nutDan.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
        nutDan.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        nutDan.backgroundColor = .tertiarySystemFill
        nutDan.layer.cornerRadius = 8
        nutDan.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutDan.addTarget(self, action: #selector(danKeyTuClipboard), for: .touchUpInside)

        let nutLayKey = UIButton(type: .system)
        nutLayKey.setTitle(" Mở trang lấy Key miễn phí (aistudio.google.com)", for: .normal)
        nutLayKey.setImage(UIImage(systemName: "safari"), for: .normal)
        nutLayKey.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        nutLayKey.contentHorizontalAlignment = .left
        nutLayKey.addTarget(self, action: #selector(moTrangGoogleAIStudio), for: .touchUpInside)

        let hangNhapKey = UIStackView(arrangedSubviews: [oNhapKey, nutDan])
        hangNhapKey.axis = .horizontal
        hangNhapKey.spacing = 8
        nutDan.setContentHuggingPriority(.required, for: .horizontal)

        nutKiemTra.setTitle(" Kiểm tra kết nối API Key", for: .normal)
        nutKiemTra.setImage(UIImage(systemName: "checkmark.shield.fill"), for: .normal)
        nutKiemTra.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutKiemTra.backgroundColor = .systemBlue
        nutKiemTra.tintColor = .white
        nutKiemTra.layer.cornerRadius = 10
        nutKiemTra.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        nutKiemTra.addTarget(self, action: #selector(bamKiemTraKey), for: .touchUpInside)

        nhanKetQuaKiemTra.font = .systemFont(ofSize: 13, weight: .medium)
        nhanKetQuaKiemTra.numberOfLines = 0
        nhanKetQuaKiemTra.isHidden = true

        let theKey = taoKhungNhom(cacView: [hangNhapKey, nutLayKey, nutKiemTra, nhanKetQuaKiemTra])

        // Khối 2: Chọn dòng mô hình Gemini
        let tieuDeModel = taoTieuDeNhom("2. MÔ HÌNH GEMINI & CHẾ ĐỘ ĐỌC")
        let nhanMoTaModel = UILabel()
        nhanMoTaModel.text = "Chọn phiên bản Gemini Flash (tất cả đều miễn phí trên Google AI Studio và đọc được hình ảnh + văn bản):"
        nhanMoTaModel.font = .systemFont(ofSize: 13)
        nhanMoTaModel.textColor = .secondaryLabel
        nhanMoTaModel.numberOfLines = 0

        let dongGuiAnh = taoHangCongTac(
            tieuDe: "Gửi kèm ảnh + OCR lên Gemini",
            moTa: "Kết hợp chữ quét từ Apple Vision trên iPhone và hình ảnh để Gemini đối chiếu chính xác 100%.",
            congTac: congTacGuiAnh
        )

        let dongCongDon = taoHangCongTac(
            tieuDe: "Gộp cộng dồn khi quét nhiều lần",
            moTa: "Khi chọn quét thêm ảnh mới trong ngày, tự động nối tiếp và khử trùng lặp với bảng hiện có.",
            congTac: congTacGopCongDon
        )

        let theModel = taoKhungNhom(cacView: [nhanMoTaModel, chonModel, dongGuiAnh, dongCongDon])

        // Khối 3: Giải thích về Key miễn phí Google AI Studio
        let tieuDeHuongDan = taoTieuDeNhom("3. THÔNG TIN VỀ GOOGLE AI STUDIO FREE KEY")
        let nhanHuongDan = UILabel()
        nhanHuongDan.font = .systemFont(ofSize: 13)
        nhanHuongDan.textColor = .secondaryLabel
        nhanHuongDan.numberOfLines = 0
        nhanHuongDan.text = """
        • Key miễn phí lấy tại aistudio.google.com/apikey HOÀN TOÀN ĐỌC ĐƯỢC HÌNH ẢNH (Multimodal Vision).
        • Hạn mức miễn phí (Free Tier): ~15 lần gọi/phút và 500 - 1.500 lần/ngày, hoàn toàn thoải mái để quét 40+ chương trình thi đua mỗi ngày.
        • Ứng dụng còn tích hợp sẵn Bộ đọc Apple Vision OCR ngay trên iPhone: ngay cả khi bạn chưa nhập API Key hoặc không có mạng, app vẫn tự động nhận diện được bố cục bảng Thi Đua ĐMX!
        """
        let theHuongDan = taoKhungNhom(cacView: [nhanHuongDan])

        [tieuDeKey, theKey, tieuDeModel, theModel, tieuDeHuongDan, theHuongDan].forEach {
            nganXep.addArrangedSubview($0)
        }
    }

    private func napDuLieu() {
        let cd = KhoDuLieu.dungChung.caiDat
        oNhapKey.text = cd.geminiApiKey
        if let idx = danhSachModel.firstIndex(of: cd.geminiModel) {
            chonModel.selectedSegmentIndex = idx
        } else {
            chonModel.selectedSegmentIndex = 0
        }
        congTacGuiAnh.isOn = cd.guiKemAnhChoGemini
        congTacGopCongDon.isOn = cd.gopCongDonKhiQuetThem
    }

    @objc private func danKeyTuClipboard() {
        if let chuoi = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines), !chuoi.isEmpty {
            oNhapKey.text = chuoi
        }
    }

    @objc private func moTrangGoogleAIStudio() {
        if let url = URL(string: "https://aistudio.google.com/apikey") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func bamKiemTraKey() {
        view.endEditing(true)
        let key = oNhapKey.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let model = danhSachModel[max(0, chonModel.selectedSegmentIndex)]

        nutKiemTra.isEnabled = false
        nutKiemTra.setTitle(" Đang kiểm tra kết nối...", for: .normal)
        nhanKetQuaKiemTra.isHidden = false
        nhanKetQuaKiemTra.textColor = .secondaryLabel
        nhanKetQuaKiemTra.text = "Đang gửi yêu cầu thử nghiệm tới Google AI Studio..."

        DichVuDocAnh.dungChung.kiemTraKetNoiKey(apiKey: key, model: model) { [weak self] ketQua in
            guard let self = self else { return }
            self.nutKiemTra.isEnabled = true
            self.nutKiemTra.setTitle(" Kiểm tra kết nối API Key", for: .normal)

            switch ketQua {
            case .success(let thongDiep):
                self.nhanKetQuaKiemTra.textColor = .systemGreen
                self.nhanKetQuaKiemTra.text = "✅ \(thongDiep)"
            case .failure(let loi):
                self.nhanKetQuaKiemTra.textColor = .systemRed
                self.nhanKetQuaKiemTra.text = "❌ \(loi.localizedDescription)"
            }
        }
    }

    @objc private func luuCaiDat() {
        let model = danhSachModel[max(0, chonModel.selectedSegmentIndex)]
        let moi = CaiDatDMX(
            geminiApiKey: oNhapKey.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            geminiModel: model,
            guiKemAnhChoGemini: congTacGuiAnh.isOn,
            gopCongDonKhiQuetThem: congTacGopCongDon.isOn
        )
        KhoDuLieu.dungChung.luuCaiDat(moi)
        navigationController?.popViewController(animated: true)
    }

    private func taoTieuDeNhom(_ chu: String) -> UILabel {
        let nhan = UILabel()
        nhan.text = chu
        nhan.font = .systemFont(ofSize: 12, weight: .bold)
        nhan.textColor = .secondaryLabel
        return nhan
    }

    private func taoKhungNhom(cacView: [UIView]) -> UIView {
        let khung = UIView()
        khung.backgroundColor = .secondarySystemGroupedBackground
        khung.layer.cornerRadius = 14
        let nganXep = UIStackView(arrangedSubviews: cacView)
        nganXep.axis = .vertical
        nganXep.spacing = 12
        nganXep.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(nganXep)
        NSLayoutConstraint.activate([
            nganXep.topAnchor.constraint(equalTo: khung.topAnchor, constant: 14),
            nganXep.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 14),
            nganXep.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -14),
            nganXep.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -14)
        ])
        return khung
    }

    private func taoHangCongTac(tieuDe: String, moTa: String, congTac: UISwitch) -> UIView {
        let nhanChinh = UILabel()
        nhanChinh.text = tieuDe
        nhanChinh.font = .systemFont(ofSize: 15, weight: .semibold)

        let nhanPhu = UILabel()
        nhanPhu.text = moTa
        nhanPhu.font = .systemFont(ofSize: 12)
        nhanPhu.textColor = .secondaryLabel
        nhanPhu.numberOfLines = 0

        let cotChu = UIStackView(arrangedSubviews: [nhanChinh, nhanPhu])
        cotChu.axis = .vertical
        cotChu.spacing = 3

        let hang = UIStackView(arrangedSubviews: [cotChu, congTac])
        hang.axis = .horizontal
        hang.spacing = 12
        hang.alignment = .center
        congTac.setContentHuggingPriority(.required, for: .horizontal)
        return hang
    }
}
