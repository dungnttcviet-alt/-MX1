import UIKit

final class ManHinhCaiDat: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var khiThayDoiCaiDat: (() -> Void)?
    private var ngay: Date
    private let nhanHopThuThongBao = UILabel()
    private let nutDongBoNgay = UIButton(type: .system)

    private let chonPhuongPhapQuetThiDua = UISegmentedControl(items: [
        "Bảng ngang",
        "Bảng dọc",
        "Lưới",
        "Gemini"
    ])
    private let chonKieuHienThi = UISegmentedControl(items: ["Bảng 8 cột (Chi tiết)", "Thẻ tiến độ (Gọn)"])
    private let chonSoCotXuat = UISegmentedControl(items: ["1 cột", "2 cột", "3 cột", "4 cột"])

    // Cấu hình 3 ô nhập Gemini Flash API Key (nhập 1 dùng 1, nhập 2 dùng 2, nhập 3 dùng 3)
    private let nhanTrangThaiGeminiKey = UILabel()
    private let oNhapGeminiKey = UITextField()
    private let oNhapGeminiKey2 = UITextField()
    private let oNhapGeminiKey3 = UITextField()
    private let nutLuuGeminiKey = UIButton(type: .system)
    private let nutDungKeyCoSan = UIButton(type: .system)
    private let nutKiemTraGeminiKey = UIButton(type: .system)

    private let oNhapCumTu = UITextField()
    private let bangCumTu = UITableView(frame: .zero, style: .plain)
    private var danhSachCumTu: [String] = []

    init(ngay: Date = Date()) {
        self.ngay = ngay
        super.init(nibName: nil, bundle: nil)
    }

    func capNhatNgay(_ ngayMoi: Date) {
        self.ngay = ngayMoi
        guard isViewLoaded else { return }
        let cd = KhoDuLieu.dungChung.caiDat
        chonPhuongPhapQuetThiDua.selectedSegmentIndex = cd.phuongPhapQuetThiDua.rawValue
        chonKieuHienThi.selectedSegmentIndex = cd.kieuHienThi.rawValue
        danhSachCumTu = cd.danhSachCumTuLocBo
        chonSoCotXuat.selectedSegmentIndex = max(0, min(3, cd.soCotXuatAnh - 1))
        capNhatHienThiGeminiKey(tu: cd)
        bangCumTu.reloadData()
        capNhatThongBaoHeThong()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cài đặt"
        view.backgroundColor = BangMauBCTD.nenTrang
        chonPhuongPhapQuetThiDua.addTarget(self, action: #selector(thayDoiTuyChonHienThi), for: .valueChanged)
        chonKieuHienThi.addTarget(self, action: #selector(thayDoiTuyChonHienThi), for: .valueChanged)
        chonSoCotXuat.addTarget(self, action: #selector(thayDoiTuyChonHienThi), for: .valueChanged)
        [oNhapGeminiKey, oNhapGeminiKey2, oNhapGeminiKey3].forEach { tf in
            tf.addTarget(self, action: #selector(dangGoGeminiKey), for: .editingChanged)
            tf.addTarget(self, action: #selector(thayDoiGeminiKey), for: .editingDidEnd)
        }

        let nutLuu = UIBarButtonItem(
            title: "Lưu",
            style: .done,
            target: self,
            action: #selector(luuCaiDat)
        )
        navigationItem.rightBarButtonItem = nutLuu

        let cd = KhoDuLieu.dungChung.caiDat
        chonPhuongPhapQuetThiDua.selectedSegmentIndex = cd.phuongPhapQuetThiDua.rawValue
        chonKieuHienThi.selectedSegmentIndex = cd.kieuHienThi.rawValue
        danhSachCumTu = cd.danhSachCumTuLocBo
        let chiSoCot = max(0, min(3, cd.soCotXuatAnh - 1))
        chonSoCotXuat.selectedSegmentIndex = chiSoCot

        taoGiaoDien()
        capNhatHienThiGeminiKey(tu: cd)
        capNhatThongBaoHeThong()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dongBoTamCaiDat()
        khiThayDoiCaiDat?()
    }

    private func capNhatHienThiGeminiKey(tu cd: CaiDatDMX, giuNguyenONhap: Bool = false) {
        let key1 = cd.geminiApiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let key2 = cd.geminiApiKey2.trimmingCharacters(in: .whitespacesAndNewlines)
        let key3 = cd.geminiApiKey3.trimmingCharacters(in: .whitespacesAndNewlines)

        if !giuNguyenONhap {
            if !oNhapGeminiKey.isFirstResponder {
                oNhapGeminiKey.text = (key1.isEmpty || key1 == CaiDatDMX.geminiKeyMacDinh) ? "" : key1
            }
            if !oNhapGeminiKey2.isFirstResponder {
                oNhapGeminiKey2.text = key2
            }
            if !oNhapGeminiKey3.isFirstResponder {
                oNhapGeminiKey3.text = key3
            }
        }

        let dsKeyNhap = cd.danhSachKeyNguoiDungNhap
        if dsKeyNhap.isEmpty {
            let duoi = String(CaiDatDMX.geminiKeyMacDinh.suffix(6))
            nhanTrangThaiGeminiKey.text = "🔑 Đang dùng: 1 Key Gemini Flash tích hợp sẵn trong app (...\(duoi))"
            nhanTrangThaiGeminiKey.textColor = BangMauBCTD.xanhLaDam
        } else {
            let tomTat = dsKeyNhap.enumerated().map { "Key \($0.offset + 1) (...\(String($0.element.suffix(4))))" }.joined(separator: " · ")
            nhanTrangThaiGeminiKey.text = "🔑 Đang dùng đúng \(dsKeyNhap.count) Key Gemini Flash: \(tomTat)"
            nhanTrangThaiGeminiKey.textColor = BangMauBCTD.xanhChuDaoDam
        }
    }

    private func capNhatThongBaoHeThong() {
        let ten = DichVuDongBo.dungChung.tenDangNhap.isEmpty ? "Chưa đăng nhập" : DichVuDongBo.dungChung.tenDangNhap
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        nhanHopThuThongBao.text = "📩 Hệ thống ĐMX (\(ngayStr)): Dữ liệu và cài đặt của tài khoản \(ten) được đồng bộ đám mây tự động."
    }

    @objc private func thayDoiTuyChonHienThi() {
        dongBoTamCaiDat()
        khiThayDoiCaiDat?()
    }

    @objc private func dangGoGeminiKey() {
        dongBoTamCaiDat()
        capNhatHienThiGeminiKey(tu: KhoDuLieu.dungChung.caiDat, giuNguyenONhap: true)
    }

    @objc private func thayDoiGeminiKey() {
        dongBoTamCaiDat()
        capNhatHienThiGeminiKey(tu: KhoDuLieu.dungChung.caiDat)
        khiThayDoiCaiDat?()
    }

    @objc private func bamLuuGeminiKey() {
        [oNhapGeminiKey, oNhapGeminiKey2, oNhapGeminiKey3].forEach { $0.resignFirstResponder() }
        dongBoTamCaiDat()
        let cd = KhoDuLieu.dungChung.caiDat
        capNhatHienThiGeminiKey(tu: cd)
        khiThayDoiCaiDat?()
        let dsKeyNhap = cd.danhSachKeyNguoiDungNhap
        if dsKeyNhap.isEmpty {
            let duoi = String(CaiDatDMX.geminiKeyMacDinh.suffix(6))
            hienThongBao(
                tieuDe: "✅ Đã lưu cài đặt Key",
                noiDung: "Đang sử dụng 1 API Key Gemini Flash tích hợp sẵn trong ứng dụng (...\(duoi))."
            )
        } else {
            let chiTiet = dsKeyNhap.enumerated().map { "• Key \($0.offset + 1): ...\(String($0.element.suffix(6)))" }.joined(separator: "\n")
            hienThongBao(
                tieuDe: "✅ Đã lưu \(dsKeyNhap.count) API Key Gemini Flash",
                noiDung: "Hệ thống sẽ chạy đúng \(dsKeyNhap.count) Key đã nhập:\n\(chiTiet)"
            )
        }
    }

    @objc private func bamDungKeyCoSan() {
        [oNhapGeminiKey, oNhapGeminiKey2, oNhapGeminiKey3].forEach {
            $0.text = ""
            $0.resignFirstResponder()
        }
        dongBoTamCaiDat()
        capNhatHienThiGeminiKey(tu: KhoDuLieu.dungChung.caiDat)
        khiThayDoiCaiDat?()
        hienThongBao(
            tieuDe: "✅ Đã chuyển về Key có sẵn",
            noiDung: "Đã xóa các ô nhập tay và sử dụng 1 API Key Gemini Flash tích hợp sẵn trong ứng dụng."
        )
    }

    @objc private func bamKiemTraGeminiKey() {
        [oNhapGeminiKey, oNhapGeminiKey2, oNhapGeminiKey3].forEach { $0.resignFirstResponder() }
        dongBoTamCaiDat()
        let cd = KhoDuLieu.dungChung.caiDat
        capNhatHienThiGeminiKey(tu: cd)
        let dsKey = cd.danhSachGeminiApiKeyHieuLuc
        let keyKiemTra = dsKey.first ?? cd.geminiApiKeyHieuLuc
        nutKiemTraGeminiKey.isEnabled = false
        nutKiemTraGeminiKey.setTitle("⏳ Đang kiểm tra...", for: .normal)
        DichVuGeminiAI.dungChung.kiemTraVaDungThuKey(apiKey: keyKiemTra, model: "gemini-3.5-flash-lite") { [weak self] kq in
            guard let self else { return }
            self.nutKiemTraGeminiKey.isEnabled = true
            self.nutKiemTraGeminiKey.setTitle("⚡ Kiểm tra Key", for: .normal)
            switch kq {
            case .success(let info):
                self.hienThongBao(
                    tieuDe: "✅ Kết nối Gemini Flash thành công",
                    noiDung: "Số Key đang kích hoạt: \(dsKey.count) Key\nModel: \(info.modelThanhCong)\nPhản hồi: \(info.phanHoiMau)"
                )
            case .failure(let loi):
                self.hienThongBao(
                    tieuDe: "⚠️ Không kết nối được Key",
                    noiDung: loi.localizedDescription
                )
            }
        }
    }

    @objc private func bamDongBoDamMayNgay() {
        DichVuDongBo.dungChung.taiDuLieu()
        hienThongBao(tieuDe: "🔄 Đang đồng bộ", noiDung: "Đã gửi yêu cầu đồng bộ dữ liệu mới nhất từ đám mây.")
    }

    private func hienThongBao(tieuDe: String, noiDung: String) {
        let tb = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(tb, animated: true)
    }

    private func dongBoTamCaiDat() {
        if let dangGo = oNhapCumTu.text?.trimmingCharacters(in: .whitespacesAndNewlines), !dangGo.isEmpty {
            if !danhSachCumTu.contains(where: { $0.caseInsensitiveCompare(dangGo) == .orderedSame }) {
                danhSachCumTu.insert(dangGo, at: 0)
            }
            oNhapCumTu.text = ""
        }

        let phuongPhap = PhuongPhapQuetThiDua(rawValue: chonPhuongPhapQuetThiDua.selectedSegmentIndex) ?? .bangDoc
        let kieu = KieuHienThiBaoCao(rawValue: chonKieuHienThi.selectedSegmentIndex) ?? .bangChiTiet
        let soCot = chonSoCotXuat.selectedSegmentIndex + 1
        let keyNhap1 = (oNhapGeminiKey.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let keyNhap2 = (oNhapGeminiKey2.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let keyNhap3 = (oNhapGeminiKey3.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        var moi = KhoDuLieu.dungChung.caiDat
        moi.phuongPhapQuetThiDua = phuongPhap
        moi.kieuHienThi = kieu
        moi.danhSachCumTuLocBo = danhSachCumTu
        moi.soCotXuatAnh = soCot
        moi.geminiApiKey = keyNhap1.isEmpty ? CaiDatDMX.geminiKeyMacDinh : keyNhap1
        moi.geminiApiKey2 = keyNhap2
        moi.geminiApiKey3 = keyNhap3
        moi.geminiModel = CaiDatDMX.geminiModelMacDinh
        moi.dungGeminiQuetAnh = (phuongPhap == .gemini)
        KhoDuLieu.dungChung.luuCaiDat(moi)
    }

    private func taoGiaoDien() {
        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.keyboardDismissMode = .interactive
        cuon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuon)

        let nganTong = UIStackView()
        nganTong.axis = .vertical
        nganTong.spacing = 10
        nganTong.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(nganTong)

        // 1. HỘP THƯ & ĐỒNG BỘ
        let tieuDeHopThu = taoTieuDeNhom("📬 HỘP THƯ & THÔNG BÁO HỆ THỐNG")
        let khungHopThu = UIView()
        khungHopThu.backgroundColor = BangMauBCTD.nenThe
        khungHopThu.layer.cornerRadius = 12
        khungHopThu.layer.borderWidth = 1
        khungHopThu.layer.borderColor = BangMauBCTD.vienThe.cgColor

        nhanHopThuThongBao.font = .systemFont(ofSize: 13, weight: .medium)
        nhanHopThuThongBao.textColor = BangMauBCTD.chuChinh
        nhanHopThuThongBao.numberOfLines = 0
        nhanHopThuThongBao.lineBreakMode = .byWordWrapping
        nhanHopThuThongBao.adjustsFontSizeToFitWidth = false

        nutDongBoNgay.setTitle("🔄 Đồng bộ dữ liệu đám mây ngay", for: .normal)
        nutDongBoNgay.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutDongBoNgay.titleLabel?.numberOfLines = 0
        nutDongBoNgay.titleLabel?.lineBreakMode = .byWordWrapping
        nutDongBoNgay.titleLabel?.adjustsFontSizeToFitWidth = false
        nutDongBoNgay.backgroundColor = BangMauBCTD.nenHeaderBang
        nutDongBoNgay.tintColor = BangMauBCTD.xanhChuDao
        nutDongBoNgay.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutDongBoNgay.layer.cornerRadius = 9
        nutDongBoNgay.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutDongBoNgay.addTarget(self, action: #selector(bamDongBoDamMayNgay), for: .touchUpInside)

        let nganHopThu = UIStackView(arrangedSubviews: [nhanHopThuThongBao, nutDongBoNgay])
        nganHopThu.axis = .vertical
        nganHopThu.spacing = 8
        nganHopThu.translatesAutoresizingMaskIntoConstraints = false
        khungHopThu.addSubview(nganHopThu)

        let tieuDeKieu = taoTieuDeNhom("PHƯƠNG PHÁP QUÉT ẢNH & KIỂU HIỂN THỊ")
        let khungKieu = UIView()
        khungKieu.backgroundColor = BangMauBCTD.nenThe
        khungKieu.layer.cornerRadius = 12
        khungKieu.layer.borderWidth = 1
        khungKieu.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let nhanMoTaKieu = UILabel()
        nhanMoTaKieu.text = "Chọn 1 trong 2 mẫu hiển thị trên màn hình và khi xuất ảnh:"
        nhanMoTaKieu.font = .systemFont(ofSize: 13)
        nhanMoTaKieu.textColor = BangMauBCTD.chuPhu
        nhanMoTaKieu.numberOfLines = 0
        nhanMoTaKieu.lineBreakMode = .byWordWrapping
        nhanMoTaKieu.adjustsFontSizeToFitWidth = false

        let nhanMoTaPhuongPhapQuet = UILabel()
        nhanMoTaPhuongPhapQuet.text = "4 Phương pháp quét ảnh Thi đua Lũy kế (Bảng ngang · Bảng dọc · Lưới · Gemini):"
        nhanMoTaPhuongPhapQuet.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanMoTaPhuongPhapQuet.textColor = BangMauBCTD.chuChinh
        nhanMoTaPhuongPhapQuet.numberOfLines = 0
        nhanMoTaPhuongPhapQuet.lineBreakMode = .byWordWrapping
        nhanMoTaPhuongPhapQuet.adjustsFontSizeToFitWidth = false

        let nhanGhiChuPhuongPhapQuet = UILabel()
        nhanGhiChuPhuongPhapQuet.text = "• 1. Bảng ngang: Ảnh BC Thi đua Lũy kế dạng bảng ngang (ĐƠN VỊ | SỐ CT ĐẠT + 39 cột chương trình ngang có THỰC HIỆN | TARGET).\n• 2. Bảng dọc: Ảnh BC Thi đua Lũy kế dạng bảng dọc (CHƯƠNG TRÌNH | THỰC HIỆN | TARGET | % DỰ KIẾN HOÀN THÀNH | HẠNG VÙNG).\n• 3. Lưới: Ảnh BC Thi đua Lũy kế dạng lưới thẻ (Lưới 6 cột × 7 hàng = 39 thẻ hoặc lưới 2 cột thẻ có % Dự kiến, Thực hiện, Target, % HT tháng, DT/SL Dự kiến).\n• 4. Gemini: Quét ảnh (Bảng ngang, Bảng dọc, Lưới) bằng AI Gemini Flash với API Key có sẵn hoặc nhập bên dưới."
        nhanGhiChuPhuongPhapQuet.font = .systemFont(ofSize: 11.5)
        nhanGhiChuPhuongPhapQuet.textColor = BangMauBCTD.chuPhu
        nhanGhiChuPhuongPhapQuet.numberOfLines = 0
        nhanGhiChuPhuongPhapQuet.lineBreakMode = .byWordWrapping
        nhanGhiChuPhuongPhapQuet.adjustsFontSizeToFitWidth = false

        // Khối cấu hình API Key Gemini Flash (Phương pháp 3)
        let khungGemini = UIView()
        khungGemini.backgroundColor = BangMauBCTD.nenThePhu
        khungGemini.layer.cornerRadius = 10
        khungGemini.layer.borderWidth = 1
        khungGemini.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let nhanTieuDeGemini = UILabel()
        nhanTieuDeGemini.text = "🤖 3 API Key Gemini (nên thuộc 3 project khác nhau):"
        nhanTieuDeGemini.font = .systemFont(ofSize: 12.5, weight: .bold)
        nhanTieuDeGemini.textColor = BangMauBCTD.chuChinh
        nhanTieuDeGemini.numberOfLines = 0

        nhanTrangThaiGeminiKey.font = .systemFont(ofSize: 12, weight: .semibold)
        nhanTrangThaiGeminiKey.numberOfLines = 0

        let cacONhap: [(UITextField, String)] = [
            (oNhapGeminiKey, "🔑 Key 1: Nhập Gemini API Key 1 (trống cả 3 ô = dùng Key có sẵn)"),
            (oNhapGeminiKey2, "🔑 Key 2: Nhập Gemini API Key 2 (tùy chọn)"),
            (oNhapGeminiKey3, "🔑 Key 3: Nhập Gemini API Key 3 (tùy chọn)")
        ]
        for (tf, ph) in cacONhap {
            tf.placeholder = ph
            tf.borderStyle = .roundedRect
            tf.font = .systemFont(ofSize: 12.5)
            tf.isSecureTextEntry = true
            tf.textContentType = .password
            tf.clearButtonMode = .whileEditing
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
            tf.returnKeyType = .done
            tf.delegate = self
        }

        nutLuuGeminiKey.setTitle("💾 Lưu Key", for: .normal)
        nutLuuGeminiKey.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nutLuuGeminiKey.backgroundColor = BangMauBCTD.xanhLaDam
        nutLuuGeminiKey.setTitleColor(.white, for: .normal)
        nutLuuGeminiKey.layer.cornerRadius = 8
        nutLuuGeminiKey.contentEdgeInsets = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        nutLuuGeminiKey.addTarget(self, action: #selector(bamLuuGeminiKey), for: .touchUpInside)

        nutDungKeyCoSan.setTitle("🔄 Key có sẵn", for: .normal)
        nutDungKeyCoSan.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nutDungKeyCoSan.backgroundColor = BangMauBCTD.nenHeaderPhu
        nutDungKeyCoSan.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutDungKeyCoSan.layer.cornerRadius = 8
        nutDungKeyCoSan.contentEdgeInsets = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        nutDungKeyCoSan.addTarget(self, action: #selector(bamDungKeyCoSan), for: .touchUpInside)

        nutKiemTraGeminiKey.setTitle("⚡ Kiểm tra Key", for: .normal)
        nutKiemTraGeminiKey.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nutKiemTraGeminiKey.backgroundColor = BangMauBCTD.xanhChuDao
        nutKiemTraGeminiKey.setTitleColor(.white, for: .normal)
        nutKiemTraGeminiKey.layer.cornerRadius = 8
        nutKiemTraGeminiKey.contentEdgeInsets = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        nutKiemTraGeminiKey.addTarget(self, action: #selector(bamKiemTraGeminiKey), for: .touchUpInside)

        let hangNutGemini = UIStackView(arrangedSubviews: [nutLuuGeminiKey, nutDungKeyCoSan, nutKiemTraGeminiKey])
        hangNutGemini.axis = .horizontal
        hangNutGemini.spacing = 6
        hangNutGemini.distribution = .fillProportionally

        let nganGemini = UIStackView(arrangedSubviews: [
            nhanTieuDeGemini,
            nhanTrangThaiGeminiKey,
            oNhapGeminiKey,
            oNhapGeminiKey2,
            oNhapGeminiKey3,
            hangNutGemini
        ])
        nganGemini.axis = .vertical
        nganGemini.spacing = 6
        nganGemini.translatesAutoresizingMaskIntoConstraints = false
        khungGemini.addSubview(nganGemini)

        let nhanMoTaCot = UILabel()
        nhanMoTaCot.text = "Số cột khi xuất ảnh (áp dụng cho mẫu Thẻ tiến độ):"
        nhanMoTaCot.font = .systemFont(ofSize: 13)
        nhanMoTaCot.textColor = BangMauBCTD.chuPhu
        nhanMoTaCot.numberOfLines = 0
        nhanMoTaCot.lineBreakMode = .byWordWrapping
        nhanMoTaCot.adjustsFontSizeToFitWidth = false

        [chonPhuongPhapQuetThiDua, chonKieuHienThi, chonSoCotXuat].forEach { seg in
            seg.backgroundColor = BangMauBCTD.nenThePhu
            seg.selectedSegmentTintColor = BangMauBCTD.vangSang
            seg.setTitleTextAttributes([
                .font: UIFont.systemFont(ofSize: 11.5, weight: .semibold),
                .foregroundColor: BangMauBCTD.chuPhu
            ], for: .normal)
            seg.setTitleTextAttributes([
                .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
                .foregroundColor: BangMauBCTD.chuChinh
            ], for: .selected)
            seg.damBaoHienThiDayDuText()
        }

        let nganKieu = UIStackView(arrangedSubviews: [
            nhanMoTaPhuongPhapQuet,
            chonPhuongPhapQuetThiDua,
            nhanGhiChuPhuongPhapQuet,
            khungGemini,
            nhanMoTaKieu,
            chonKieuHienThi,
            nhanMoTaCot,
            chonSoCotXuat
        ])
        nganKieu.axis = .vertical
        nganKieu.spacing = 8
        nganKieu.translatesAutoresizingMaskIntoConstraints = false
        khungKieu.addSubview(nganKieu)

        let tieuDeLoc = taoTieuDeNhom("CỤM TỪ LỌC BỎ TRONG TẤT CẢ NGÀNH HÀNG")
        let khungLoc = UIView()
        khungLoc.backgroundColor = BangMauBCTD.nenThe
        khungLoc.layer.cornerRadius = 12
        khungLoc.layer.borderWidth = 1
        khungLoc.layer.borderColor = BangMauBCTD.vienThe.cgColor
        khungLoc.clipsToBounds = true

        oNhapCumTu.placeholder = "Nhập cụm từ muốn lọc bỏ (VD: 275 Quang Trung)"
        oNhapCumTu.borderStyle = .roundedRect
        oNhapCumTu.font = .systemFont(ofSize: 14)
        oNhapCumTu.clearButtonMode = .whileEditing
        oNhapCumTu.returnKeyType = .done
        oNhapCumTu.delegate = self

        let nutThem = UIButton(type: .system)
        nutThem.setTitle(" + Thêm ", for: .normal)
        nutThem.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutThem.titleLabel?.numberOfLines = 0
        nutThem.titleLabel?.lineBreakMode = .byWordWrapping
        nutThem.titleLabel?.adjustsFontSizeToFitWidth = false
        nutThem.backgroundColor = BangMauBCTD.xanhChuDao
        nutThem.tintColor = .white
        nutThem.layer.cornerRadius = 8
        nutThem.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        nutThem.addTarget(self, action: #selector(bamThemCumTu), for: .touchUpInside)
        nutThem.setContentHuggingPriority(.required, for: .horizontal)

        let hangNhap = UIStackView(arrangedSubviews: [oNhapCumTu, nutThem])
        hangNhap.axis = .horizontal
        hangNhap.spacing = 8

        let vachNgan = UIView()
        vachNgan.backgroundColor = BangMauBCTD.vienThe

        bangCumTu.dataSource = self
        bangCumTu.delegate = self
        bangCumTu.rowHeight = UITableView.automaticDimension
        bangCumTu.estimatedRowHeight = 44
        bangCumTu.backgroundColor = .clear
        bangCumTu.separatorInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        [hangNhap, vachNgan, bangCumTu].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungLoc.addSubview($0)
        }

        [
            tieuDeKieu, khungKieu,
            tieuDeLoc, khungLoc,
            tieuDeHopThu, khungHopThu
        ].forEach {
            nganTong.addArrangedSubview($0)
        }

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nganTong.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 10),
            nganTong.leadingAnchor.constraint(equalTo: cuon.contentLayoutGuide.leadingAnchor, constant: 14),
            nganTong.trailingAnchor.constraint(equalTo: cuon.contentLayoutGuide.trailingAnchor, constant: -14),
            nganTong.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -16),
            nganTong.widthAnchor.constraint(equalTo: cuon.frameLayoutGuide.widthAnchor, constant: -28),

            nganHopThu.topAnchor.constraint(equalTo: khungHopThu.topAnchor, constant: 10),
            nganHopThu.leadingAnchor.constraint(equalTo: khungHopThu.leadingAnchor, constant: 12),
            nganHopThu.trailingAnchor.constraint(equalTo: khungHopThu.trailingAnchor, constant: -12),
            nganHopThu.bottomAnchor.constraint(equalTo: khungHopThu.bottomAnchor, constant: -10),

            nganGemini.topAnchor.constraint(equalTo: khungGemini.topAnchor, constant: 10),
            nganGemini.leadingAnchor.constraint(equalTo: khungGemini.leadingAnchor, constant: 10),
            nganGemini.trailingAnchor.constraint(equalTo: khungGemini.trailingAnchor, constant: -10),
            nganGemini.bottomAnchor.constraint(equalTo: khungGemini.bottomAnchor, constant: -10),

            nganKieu.topAnchor.constraint(equalTo: khungKieu.topAnchor, constant: 10),
            nganKieu.leadingAnchor.constraint(equalTo: khungKieu.leadingAnchor, constant: 12),
            nganKieu.trailingAnchor.constraint(equalTo: khungKieu.trailingAnchor, constant: -12),
            nganKieu.bottomAnchor.constraint(equalTo: khungKieu.bottomAnchor, constant: -10),

            hangNhap.topAnchor.constraint(equalTo: khungLoc.topAnchor, constant: 10),
            hangNhap.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor, constant: 12),
            hangNhap.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor, constant: -12),

            vachNgan.topAnchor.constraint(equalTo: hangNhap.bottomAnchor, constant: 10),
            vachNgan.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor),
            vachNgan.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor),
            vachNgan.heightAnchor.constraint(equalToConstant: 0.5),

            bangCumTu.topAnchor.constraint(equalTo: vachNgan.bottomAnchor),
            bangCumTu.leadingAnchor.constraint(equalTo: khungLoc.leadingAnchor),
            bangCumTu.trailingAnchor.constraint(equalTo: khungLoc.trailingAnchor),
            bangCumTu.bottomAnchor.constraint(equalTo: khungLoc.bottomAnchor),
            bangCumTu.heightAnchor.constraint(equalToConstant: 210)
        ])
    }

    @objc private func bamThemCumTu() {
        let chu = oNhapCumTu.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !chu.isEmpty else { return }
        if !danhSachCumTu.contains(where: { $0.caseInsensitiveCompare(chu) == .orderedSame }) {
            danhSachCumTu.insert(chu, at: 0)
            bangCumTu.reloadData()
        }
        oNhapCumTu.text = ""
        dongBoTamCaiDat()
        khiThayDoiCaiDat?()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oNhapGeminiKey || textField === oNhapGeminiKey2 || textField === oNhapGeminiKey3 {
            textField.resignFirstResponder()
            thayDoiGeminiKey()
            return true
        }
        bamThemCumTu()
        textField.resignFirstResponder()
        return true
    }

    @objc private func luuCaiDat() {
        dongBoTamCaiDat()
        capNhatHienThiGeminiKey(tu: KhoDuLieu.dungChung.caiDat)
        khiThayDoiCaiDat?()
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(1, danhSachCumTu.count)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "CumTuLocCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .value1, reuseIdentifier: ma)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.adjustsFontSizeToFitWidth = false

        if danhSachCumTu.isEmpty {
            cell.textLabel?.text = "Chưa có cụm từ lọc bỏ nào"
            cell.textLabel?.textColor = BangMauBCTD.chuMo
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.detailTextLabel?.text = nil
            cell.accessoryView = nil
        } else {
            let cumTu = danhSachCumTu[indexPath.row]
            cell.textLabel?.text = "\"\(cumTu)\""
            cell.textLabel?.textColor = BangMauBCTD.chuChinh
            cell.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)

            let nutXoa = UIButton(type: .system)
            nutXoa.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            nutXoa.tintColor = BangMauBCTD.doYeuChu
            nutXoa.tag = indexPath.row
            nutXoa.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            nutXoa.addTarget(self, action: #selector(xoaCumTuTai(_:)), for: .touchUpInside)
            cell.accessoryView = nutXoa
        }
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard !danhSachCumTu.isEmpty else { return nil }
        let xoa = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, hoanTat in
            self?.danhSachCumTu.remove(at: indexPath.row)
            self?.bangCumTu.reloadData()
            hoanTat(true)
        }
        return UISwipeActionsConfiguration(actions: [xoa])
    }

    @objc private func xoaCumTuTai(_ sender: UIButton) {
        let idx = sender.tag
        guard idx >= 0 && idx < danhSachCumTu.count else { return }
        danhSachCumTu.remove(at: idx)
        bangCumTu.reloadData()
        dongBoTamCaiDat()
        khiThayDoiCaiDat?()
    }

    private func taoTieuDeNhom(_ chu: String) -> UILabel {
        let nhan = UILabel()
        nhan.text = chu
        nhan.font = .systemFont(ofSize: 12.0, weight: .heavy)
        nhan.textColor = BangMauBCTD.xanhChuDaoDam
        nhan.numberOfLines = 0
        nhan.lineBreakMode = .byWordWrapping
        nhan.adjustsFontSizeToFitWidth = false
        return nhan
    }
}

// MARK: - Màn hình Quản trị Tài khoản (Dành cho Admin)

final class ManHinhQuanLyTaiKhoan: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var danhSach: [ThongTinTaiKhoanDMX] = []
    private let nhanTomTat = UILabel()
    private let nutThemTaiKhoan = UIButton(type: .system)
    private let bang = UITableView(frame: .zero, style: .insetGrouped)
    private let vongQuay = UIActivityIndicatorView(style: .medium)
    private let nutDoiMatKhauCaNhan = UIButton(type: .system)
    private let nutDangXuat = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quản lý Tài khoản"
        view.backgroundColor = BangMauBCTD.nenTrang

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(bamThemTaiKhoanMoi)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(taiDanhSach))
        ]

        taoGiaoDien()
        if DichVuDongBo.dungChung.laAdmin {
            taiDanhSach()
        } else {
            navigationItem.rightBarButtonItems = nil
            nutThemTaiKhoan.isHidden = true
            bang.isHidden = true
        }
    }

    private func taoGiaoDien() {
        let khungDau = UIView()
        khungDau.backgroundColor = BangMauBCTD.nenThe
        khungDau.layer.cornerRadius = 12
        khungDau.layer.borderWidth = 1
        khungDau.layer.borderColor = BangMauBCTD.vienThe.cgColor

        nhanTomTat.font = .systemFont(ofSize: 13, weight: .semibold)
        nhanTomTat.textColor = BangMauBCTD.chuChinh
        nhanTomTat.numberOfLines = 0
        nhanTomTat.lineBreakMode = .byWordWrapping
        nhanTomTat.adjustsFontSizeToFitWidth = false
        let tenHienTai = DichVuDongBo.dungChung.tenDangNhap
        nhanTomTat.text = "Tài khoản hiện tại: \(tenHienTai.isEmpty ? "Chưa đăng nhập" : tenHienTai)."

        nutDoiMatKhauCaNhan.setTitle("🔑 Đổi mật khẩu của tôi", for: .normal)
        nutDangXuat.setTitle("🚪 Đăng xuất", for: .normal)
        [nutDoiMatKhauCaNhan, nutDangXuat].forEach { nut in
            nut.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.layer.cornerRadius = 9
            nut.backgroundColor = BangMauBCTD.nenThePhu
            nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
            nut.contentEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 10)
        }
        nutDoiMatKhauCaNhan.addTarget(self, action: #selector(bamDoiMatKhauCaNhan), for: .touchUpInside)
        nutDangXuat.addTarget(self, action: #selector(bamDangXuat), for: .touchUpInside)
        let hangTaiKhoan = UIStackView(arrangedSubviews: [nutDoiMatKhauCaNhan, nutDangXuat])
        hangTaiKhoan.axis = .horizontal
        hangTaiKhoan.spacing = 8
        hangTaiKhoan.distribution = .fillEqually

        nutThemTaiKhoan.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        nutThemTaiKhoan.setTitle(" Thêm tài khoản mới", for: .normal)
        nutThemTaiKhoan.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        nutThemTaiKhoan.titleLabel?.numberOfLines = 0
        nutThemTaiKhoan.titleLabel?.lineBreakMode = .byWordWrapping
        nutThemTaiKhoan.titleLabel?.adjustsFontSizeToFitWidth = false
        nutThemTaiKhoan.backgroundColor = BangMauBCTD.xanhChuDao
        nutThemTaiKhoan.tintColor = .white
        nutThemTaiKhoan.layer.cornerRadius = 9
        nutThemTaiKhoan.contentEdgeInsets = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 10)
        nutThemTaiKhoan.addTarget(self, action: #selector(bamThemTaiKhoanMoi), for: .touchUpInside)

        let nganDau = UIStackView(arrangedSubviews: [nhanTomTat, hangTaiKhoan, nutThemTaiKhoan, vongQuay])
        nganDau.axis = .vertical
        nganDau.spacing = 8
        nganDau.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(nganDau)

        bang.dataSource = self
        bang.delegate = self
        bang.rowHeight = UITableView.automaticDimension
        bang.estimatedRowHeight = 64

        [khungDau, bang].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungDau.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            khungDau.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            khungDau.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            nganDau.topAnchor.constraint(equalTo: khungDau.topAnchor, constant: 12),
            nganDau.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor, constant: 12),
            nganDau.trailingAnchor.constraint(equalTo: khungDau.trailingAnchor, constant: -12),
            nganDau.bottomAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: -12),

            bang.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 6),
            bang.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bang.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func bamDoiMatKhauCaNhan() {
        let hop = UIAlertController(title: "Đổi mật khẩu", message: "Nhập mật khẩu mới tối thiểu 6 ký tự.", preferredStyle: .alert)
        hop.addTextField { tf in tf.placeholder = "Mật khẩu mới"; tf.isSecureTextEntry = true }
        hop.addTextField { tf in tf.placeholder = "Nhập lại mật khẩu"; tf.isSecureTextEntry = true }
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            let mk1 = hop.textFields?[0].text ?? ""
            let mk2 = hop.textFields?[1].text ?? ""
            guard mk1.count >= 6, mk1 == mk2 else {
                self?.hienThongBao(tieuDe: "Chưa hợp lệ", noiDung: "Mật khẩu phải có ít nhất 6 ký tự và hai lần nhập phải giống nhau.")
                return
            }
            DichVuDongBo.dungChung.doiMatKhauCaNhan(matKhauMoi: mk1) { [weak self] kq in
                switch kq {
                case .success: self?.hienThongBao(tieuDe: "Thành công", noiDung: "Đã đổi mật khẩu.")
                case .failure(let loi): self?.hienThongBao(tieuDe: "Không đổi được mật khẩu", noiDung: loi.localizedDescription)
                }
            }
        })
        present(hop, animated: true)
    }

    @objc private func bamDangXuat() {
        DichVuDongBo.dungChung.dangXuat()
        (UIApplication.shared.delegate as? UyQuyenUngDung)?.hienThiDangNhap()
    }

    @objc private func taiDanhSach() {
        vongQuay.startAnimating()
        DichVuDongBo.dungChung.layDanhSachTaiKhoan { [weak self] kq in
            guard let self else { return }
            self.vongQuay.stopAnimating()
            switch kq {
            case .success(let ds):
                self.danhSach = ds
                let soAdmin = ds.filter(\.laAdmin).count
                let soThuong = ds.count - soAdmin
                self.nhanTomTat.text = "Tổng: \(ds.count) tài khoản (\(soAdmin) Admin, \(soThuong) tài khoản thường).\nChạm vào tài khoản bên dưới để Đổi mật khẩu, Set quyền Admin hoặc Xoá."
                self.bang.reloadData()
            case .failure(let loi):
                self.hienThongBao(tieuDe: "Lỗi tải danh sách", noiDung: loi.localizedDescription)
            }
        }
    }

    @objc private func bamThemTaiKhoanMoi() {
        let hop = UIAlertController(
            title: "➕ Thêm tài khoản mới",
            message: "Nhập tên đăng nhập (3–40 ký tự) và mật khẩu (tối thiểu 6 ký tự):",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Tên đăng nhập"
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
        }
        hop.addTextField { tf in
            tf.placeholder = "Mật khẩu (tối thiểu 6 ký tự)"
            tf.isSecureTextEntry = true
        }
        hop.addAction(UIAlertAction(title: "👤 Tạo Tài khoản thường", style: .default) { [weak self] _ in
            self?.thucHienTaoTaiKhoan(hop: hop, laAdmin: false)
        })
        hop.addAction(UIAlertAction(title: "🛡️ Tạo & Set quyền Admin", style: .default) { [weak self] _ in
            self?.thucHienTaoTaiKhoan(hop: hop, laAdmin: true)
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func thucHienTaoTaiKhoan(hop: UIAlertController, laAdmin: Bool) {
        guard let tfs = hop.textFields, tfs.count >= 2 else { return }
        let ten = (tfs[0].text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let mk = tfs[1].text ?? ""
        vongQuay.startAnimating()
        DichVuDongBo.dungChung.adminTaoTaiKhoanMoi(tenDangNhap: ten, matKhau: mk, laAdmin: laAdmin) { [weak self] kq in
            guard let self else { return }
            self.vongQuay.stopAnimating()
            switch kq {
            case .success(let tkMoi):
                self.taiDanhSach()
                self.hienThongBao(
                    tieuDe: "✅ Đã tạo tài khoản",
                    noiDung: "Tài khoản \"\(tkMoi.tenDangNhap)\" (\(tkMoi.laAdmin ? "Admin" : "Tài khoản thường")) đã sẵn sàng đăng nhập."
                )
            case .failure(let loi):
                self.hienThongBao(tieuDe: "Chưa tạo được tài khoản", noiDung: loi.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        max(1, danhSach.count)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "DANH SÁCH TÀI KHOẢN (\(danhSach.count))"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "TaiKhoanAdminCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .subtitle, reuseIdentifier: ma)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.adjustsFontSizeToFitWidth = false
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = false

        guard !danhSach.isEmpty else {
            cell.textLabel?.text = "Đang tải danh sách tài khoản"
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .none
            return cell
        }

        let tk = danhSach[indexPath.row]
        let nhanVaiTro = tk.laAdmin ? "🛡️ ADMIN" : "👤 Tài khoản thường"

        cell.textLabel?.text = "\(tk.tenDangNhap)   •   \(nhanVaiTro)"
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        cell.textLabel?.textColor = tk.laAdmin ? BangMauBCTD.xanhChuDao : BangMauBCTD.chuChinh

        cell.detailTextLabel?.text = "Tạo: \(tk.ngayTao)   •   Đăng nhập cuối: \(tk.dangNhapCuoi)"
        cell.detailTextLabel?.font = .systemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = BangMauBCTD.chuMo
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < danhSach.count else { return }
        let tk = danhSach[indexPath.row]
        moMenuTacVuChoTaiKhoan(tk)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < danhSach.count else { return nil }
        let tk = danhSach[indexPath.row]
        guard !tk.laAdminGoc else { return nil }

        let xoa = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, hoanTat in
            self?.xacNhanXoaTaiKhoan(tk)
            hoanTat(true)
        }
        let doiMK = UIContextualAction(style: .normal, title: "Đổi MK") { [weak self] _, _, hoanTat in
            self?.moHopThoaiDoiMatKhau(cho: tk)
            hoanTat(true)
        }
        doiMK.backgroundColor = BangMauBCTD.xanhChuDao
        return UISwipeActionsConfiguration(actions: [xoa, doiMK])
    }

    private func moMenuTacVuChoTaiKhoan(_ tk: ThongTinTaiKhoanDMX) {
        let vaiTro = tk.laAdmin ? "Admin" : "Tài khoản thường"
        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "🔑 Đổi mật khẩu cho \"\(tk.tenDangNhap)\"") { [weak self] in
                self?.moHopThoaiDoiMatKhau(cho: tk)
            }
        ]

        if !tk.laAdminGoc {
            if tk.laAdmin {
                cacMuc.append(MucChonDMX(tieuDe: "👤 Gỡ quyền Admin (Chuyển về Tài khoản thường)") { [weak self] in
                    self?.thucHienDoiQuyenAdmin(cho: tk, laAdmin: false)
                })
            } else {
                cacMuc.append(MucChonDMX(tieuDe: "🛡️ Set quyền Admin cho \"\(tk.tenDangNhap)\"") { [weak self] in
                    self?.thucHienDoiQuyenAdmin(cho: tk, laAdmin: true)
                })
            }

            cacMuc.append(MucChonDMX(tieuDe: "🗑️ Xoá tài khoản \"\(tk.tenDangNhap)\"", kieu: .nguyHiem) { [weak self] in
                self?.xacNhanXoaTaiKhoan(tk)
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(
            tieuDe: "Tài khoản: \(tk.tenDangNhap)",
            thongDiep: "Quyền hiện tại: \(vaiTro)",
            cacMuc: cacMuc
        )
    }

    private func moHopThoaiDoiMatKhau(cho tk: ThongTinTaiKhoanDMX) {
        let hop = UIAlertController(
            title: "🔑 Đổi mật khẩu: \(tk.tenDangNhap)",
            message: "Nhập mật khẩu mới cho tài khoản \"\(tk.tenDangNhap)\" (tối thiểu 6 ký tự):",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Mật khẩu mới (tối thiểu 6 ký tự)"
            tf.isSecureTextEntry = true
        }
        hop.addAction(UIAlertAction(title: "Lưu mật khẩu mới", style: .default) { [weak self] _ in
            guard let self else { return }
            let mk = hop.textFields?.first?.text ?? ""
            self.vongQuay.startAnimating()
            DichVuDongBo.dungChung.adminDoiMatKhau(userId: tk.id, tenDangNhap: tk.tenDangNhap, matKhauMoi: mk) { [weak self] kq in
                guard let self else { return }
                self.vongQuay.stopAnimating()
                switch kq {
                case .success:
                    self.hienThongBao(tieuDe: "✅ Đã đổi mật khẩu", noiDung: "Đã cập nhật mật khẩu mới cho tài khoản \"\(tk.tenDangNhap)\".")
                case .failure(let loi):
                    self.hienThongBao(tieuDe: "Lỗi đổi mật khẩu", noiDung: loi.localizedDescription)
                }
            }
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    private func thucHienDoiQuyenAdmin(cho tk: ThongTinTaiKhoanDMX, laAdmin: Bool) {
        vongQuay.startAnimating()
        DichVuDongBo.dungChung.adminDatQuyenAdmin(taiKhoan: tk, laAdmin: laAdmin) { [weak self] kq in
            guard let self else { return }
            self.vongQuay.stopAnimating()
            switch kq {
            case .success:
                self.taiDanhSach()
                self.hienThongBao(
                    tieuDe: "✅ Đã cập nhật quyền",
                    noiDung: laAdmin
                        ? "Đã cấp quyền Admin cho tài khoản \"\(tk.tenDangNhap)\"."
                        : "Đã chuyển \"\(tk.tenDangNhap)\" về Tài khoản thường."
                )
            case .failure(let loi):
                self.hienThongBao(tieuDe: "Không thể đổi quyền", noiDung: loi.localizedDescription)
            }
        }
    }

    private func xacNhanXoaTaiKhoan(_ tk: ThongTinTaiKhoanDMX) {
        guard !tk.laAdminGoc else { return }
        let hoi = UIAlertController(
            title: "Xoá tài khoản \"\(tk.tenDangNhap)\"?",
            message: "Tài khoản này và phiên đăng nhập của nó sẽ bị xoá khỏi hệ thống.",
            preferredStyle: .alert
        )
        hoi.addAction(UIAlertAction(title: "Xoá tài khoản", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.vongQuay.startAnimating()
            DichVuDongBo.dungChung.adminXoaTaiKhoan(taiKhoan: tk) { [weak self] kq in
                guard let self else { return }
                self.vongQuay.stopAnimating()
                switch kq {
                case .success:
                    self.taiDanhSach()
                case .failure(let loi):
                    self.hienThongBao(tieuDe: "Lỗi xoá tài khoản", noiDung: loi.localizedDescription)
                }
            }
        })
        hoi.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hoi, animated: true)
    }

    private func hienThongBao(tieuDe: String, noiDung: String) {
        let tb = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
        present(tb, animated: true)
    }
}
