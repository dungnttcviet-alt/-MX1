import UIKit

final class BangGuiBaoCaoView: UIView {
    private let ngan = UIStackView()
    private let nutChonSieuThi = UIButton(type: .system)
    private let nhanMa = UILabel()
    private let nutSaoChepLenhGanNhom = UIButton(type: .system)
    private let chonKhoAnh = UISegmentedControl(items: KhoAnhBaoCaoBot.allCases.map(\.tieuDe))
    private let oApiKeyImgBB = UITextField()
    private let nganCauHinhApiKey = UIStackView()
    private let oDriveClientId = UITextField()
    private let oDriveClientSecret = UITextField()
    private let oDriveRefreshToken = UITextField()
    private let oURLAppsScript = UITextField()
    private let oKhoaDrive = UITextField()
    private let oFolderId = UITextField()
    private let nganCauHinhDrive = UIStackView()
    private let nhanTrangThaiKhoAnh = UILabel()
    private let nutChonNhom = UIButton(type: .system)
    private let congTacNhacPhanHoi = UISwitch()
    private let nutChonThoiGianNhac = UIButton(type: .system)
    private let chonGio = UIDatePicker()
    private let chonKieuGui = UISegmentedControl(items: ["🖼️ Gửi ảnh", "📝 Gửi văn bản"])
    private let nganThu = UIStackView()
    private let nganNoiDung = UIStackView()
    private let nhanTrangThai = UILabel()
    private let nganLich = UIStackView()
    private var danhSachNhom: [NhomLineDMX] = []
    private var danhSachLich: [LichGuiBaoCaoDMX] = []
    private var groupIdDangChon = ""
    private var cacThuDangChon = Set([1, 2, 3, 4, 5, 6, 7])
    private var noiDungDangChon = Set(["luyke_du_kien"])
    private var lenhGanNhomHienTai = ""
    private var dangTaiDanhSachSieuThi = false
    private var soPhutChoPhanHoi = 30

    private let cacNoiDung: [(String, String)] = [
        ("luyke_du_kien", "📈 Lũy kế — % dự kiến cuối tháng"),
        ("doanhthu_thidua_luyke", "📊 Doanh thu & thi đua lũy kế"),
        ("doanhthu_thidua_realtime", "⚡ Doanh thu & thi đua realtime"),
        ("xep_hang_nv_realtime", "🔥 Bảng xếp hạng nhân viên realtime"),
        ("xep_hang_nv_luyke", "👥 Bảng xếp hạng nhân viên lũy kế"),
        ("bieu_do_realtime_thang", "📆 Biểu đồ realtime tháng"),
        ("bieu_do_suc_khoe_nv", "❤️‍🩹 Biểu đồ sức khỏe 16 NV")
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) { super.init(coder: coder); taoGiaoDien() }

    private func taoGiaoDien() {
        backgroundColor = .clear
        ngan.axis = .vertical
        ngan.spacing = 10
        ngan.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ngan)
        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: topAnchor), ngan.leadingAnchor.constraint(equalTo: leadingAnchor),
            ngan.trailingAnchor.constraint(equalTo: trailingAnchor), ngan.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        ngan.addArrangedSubview(taoNhan("SIÊU THỊ ĐANG LÀM VIỆC", dam: true))
        ngan.addArrangedSubview(taoNhan("Dữ liệu, ảnh và lịch gửi được tách riêng theo từng siêu thị. Đổi siêu thị không làm dừng lịch của nơi khác."))
        cauHinhNutChon(nutChonSieuThi)
        ngan.addArrangedSubview(nutChonSieuThi)
        let hangSieuThi = UIStackView(arrangedSubviews: [
            taoNut("＋ Thêm siêu thị", #selector(themSieuThi)),
            taoNut("🗑 Xóa siêu thị", #selector(xoaSieuThiDangChon))
        ])
        hangSieuThi.axis = .horizontal
        hangSieuThi.spacing = 8
        hangSieuThi.distribution = .fillEqually
        ngan.addArrangedSubview(hangSieuThi)
        ngan.addArrangedSubview(taoDuongKe())

        ngan.addArrangedSubview(taoNhan("KẾT NỐI TÀI KHOẢN LINE", dam: true))
        ngan.addArrangedSubview(taoNhan("Chat riêng với bot, gửi lệnh /lienket rồi nhập mã 6 số bot trả về."))
        ngan.addArrangedSubview(taoNut("📋 Sao chép lệnh /lienket", #selector(saoChepLenhLienKet)))
        ngan.addArrangedSubview(taoNut("🔢 Nhập mã liên kết 6 số", #selector(nhapMaLienKetTaiKhoan)))

        ngan.addArrangedSubview(taoDuongKe())
        ngan.addArrangedSubview(taoNhan("KẾT NỐI NHÓM LINE", dam: true))
        ngan.addArrangedSubview(taoNhan("Tạo mã rồi vào đúng nhóm LINE, gõ /gannhom MÃ. Mã chỉ dùng một lần và hết hạn sau 10 phút."))
        let nutMa = taoNut("🔗 Tạo mã gắn nhóm", #selector(taoMa))
        ngan.addArrangedSubview(nutMa)
        nhanMa.font = .monospacedDigitSystemFont(ofSize: 28, weight: .heavy)
        nhanMa.textAlignment = .center
        nhanMa.textColor = BangMauBCTD.xanhChuDao
        nhanMa.numberOfLines = 0
        nhanMa.isHidden = true
        ngan.addArrangedSubview(nhanMa)
        cauHinhNutSaoChep(nutSaoChepLenhGanNhom)
        nutSaoChepLenhGanNhom.addTarget(self, action: #selector(saoChepLenhGanNhom), for: .touchUpInside)
        nutSaoChepLenhGanNhom.isHidden = true
        ngan.addArrangedSubview(nutSaoChepLenhGanNhom)

        ngan.addArrangedSubview(taoDuongKe())
        ngan.addArrangedSubview(taoNhan("KHO ẢNH GỬI NHANH", dam: true))
        ngan.addArrangedSubview(taoNhan("Chọn kho lưu ảnh báo cáo: Cloudflare R2 (khuyên dùng — miễn phí 10GB & 0đ băng thông), API Key (ImgBB), hoặc Google Drive."))
        chonKhoAnh.addTarget(self, action: #selector(doiKhoAnh), for: .valueChanged)
        ngan.addArrangedSubview(chonKhoAnh)

        nganCauHinhApiKey.axis = .vertical
        nganCauHinhApiKey.spacing = 7
        nganCauHinhApiKey.addArrangedSubview(taoNhan("⚡ Tải ảnh trực tiếp bằng 1 API Key (lấy miễn phí tại api.imgbb.com, tốc độ ~0.4 giây/ảnh, không qua Apps Script):"))
        cauHinhO(oApiKeyImgBB, goiY: "Nhập API Key ImgBB (ví dụ: 6d207e02198a847aa98d0a2a901485a5)", baoMat: true)
        nganCauHinhApiKey.addArrangedSubview(oApiKeyImgBB)
        ngan.addArrangedSubview(nganCauHinhApiKey)

        nganCauHinhDrive.axis = .vertical
        nganCauHinhDrive.spacing = 7
        nganCauHinhDrive.addArrangedSubview(taoNhan("⚡ Cách 1 — Tải trực tiếp lên Google Drive API v3 (Nhanh gấp 4 lần, không qua Apps Script):"))
        cauHinhO(oDriveClientId, goiY: "Google OAuth Client ID (để trống nếu dùng ya29. Access Token)")
        cauHinhO(oDriveClientSecret, goiY: "Google OAuth Client Secret", baoMat: true)
        cauHinhO(oDriveRefreshToken, goiY: "Google OAuth Refresh Token (1//...) hoặc Access Token (ya29...)", baoMat: true)
        nganCauHinhDrive.addArrangedSubview(oDriveClientId)
        nganCauHinhDrive.addArrangedSubview(oDriveClientSecret)
        nganCauHinhDrive.addArrangedSubview(oDriveRefreshToken)
        nganCauHinhDrive.addArrangedSubview(taoNhan("🌐 Cách 2 — Hoặc tải qua Google Apps Script Web App (nếu không dùng OAuth ở trên):"))
        cauHinhO(oURLAppsScript, goiY: "URL Google Apps Script Web App")
        cauHinhO(oKhoaDrive, goiY: "Khóa bí mật của Apps Script", baoMat: true)
        cauHinhO(oFolderId, goiY: "ID thư mục Google Drive (dùng chung cho cả 2 cách)")
        nganCauHinhDrive.addArrangedSubview(oURLAppsScript)
        nganCauHinhDrive.addArrangedSubview(oKhoaDrive)
        nganCauHinhDrive.addArrangedSubview(oFolderId)
        ngan.addArrangedSubview(nganCauHinhDrive)

        // Nút Lưu luôn hiển thị cho mọi kho ảnh (kể cả khi chuyển từ Drive về Supabase)
        ngan.addArrangedSubview(taoNut("💾 Lưu cấu hình kho ảnh", #selector(luuCauHinhKhoAnh)))
        nhanTrangThaiKhoAnh.font = .systemFont(ofSize: 12.5, weight: .semibold)
        nhanTrangThaiKhoAnh.textColor = BangMauBCTD.xanhLaDam
        nhanTrangThaiKhoAnh.numberOfLines = 0
        ngan.addArrangedSubview(nhanTrangThaiKhoAnh)
        napCauHinhKhoAnh()

        ngan.addArrangedSubview(taoDuongKe())
        ngan.addArrangedSubview(taoNhan("LỊCH GỬI TỰ ĐỘNG", dam: true))
        cauHinhNutChon(nutChonNhom)
        ngan.addArrangedSubview(nutChonNhom)

        let nhanNhac = taoNhan("Nhắc người được tag chưa phản hồi")
        nhanNhac.font = .systemFont(ofSize: 13, weight: .semibold)
        congTacNhacPhanHoi.onTintColor = BangMauBCTD.xanhChuDao
        let dongBatNhac = UIStackView(arrangedSubviews: [nhanNhac, congTacNhacPhanHoi])
        dongBatNhac.axis = .horizontal; dongBatNhac.alignment = .center; dongBatNhac.distribution = .equalSpacing
        ngan.addArrangedSubview(dongBatNhac)
        ngan.addArrangedSubview(taoNhan("Khi tin nhắn trong nhóm tag người khác, bot sẽ chờ hết thời gian cài đặt rồi gửi tin nhắn riêng báo những người chưa phản hồi."))
        cauHinhNutChon(nutChonThoiGianNhac)
        ngan.addArrangedSubview(nutChonThoiGianNhac)
        capNhatMenuThoiGianNhac()
        ngan.addArrangedSubview(taoNut("💾 Lưu nhắc phản hồi cho nhóm", #selector(luuNhacPhanHoiNhom)))

        chonGio.datePickerMode = .time
        chonGio.locale = Locale(identifier: "vi_VN")
        chonGio.preferredDatePickerStyle = .compact
        let dongGio = UIStackView(arrangedSubviews: [taoNhan("Giờ gửi:"), chonGio])
        dongGio.axis = .horizontal; dongGio.alignment = .center; dongGio.distribution = .equalSpacing
        ngan.addArrangedSubview(dongGio)

        ngan.addArrangedSubview(taoNhan("Hình thức gửi:"))
        chonKieuGui.selectedSegmentIndex = 0
        chonKieuGui.selectedSegmentTintColor = BangMauBCTD.xanhChuDao
        chonKieuGui.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        chonKieuGui.setTitleTextAttributes([.foregroundColor: BangMauBCTD.chuChinh], for: .normal)
        ngan.addArrangedSubview(chonKieuGui)

        ngan.addArrangedSubview(taoNhan("Ngày gửi:"))
        nganThu.axis = .horizontal; nganThu.spacing = 5; nganThu.distribution = .fillEqually
        for (index, ten) in ["T2", "T3", "T4", "T5", "T6", "T7", "CN"].enumerated() {
            let nut = taoNutLuaChon(ten, tag: index + 1, action: #selector(chonThu(_:)))
            nganThu.addArrangedSubview(nut)
        }
        ngan.addArrangedSubview(nganThu)

        ngan.addArrangedSubview(taoNhan("Nội dung gửi (có thể chọn nhiều):"))
        nganNoiDung.axis = .vertical; nganNoiDung.spacing = 6
        for (index, item) in cacNoiDung.enumerated() {
            let nut = taoNutLuaChon(item.1, tag: index, action: #selector(chonNoiDung(_:)))
            nut.contentHorizontalAlignment = .left
            nganNoiDung.addArrangedSubview(nut)
        }
        ngan.addArrangedSubview(nganNoiDung)
        ngan.addArrangedSubview(taoNut("💾 Lưu lịch gửi", #selector(luuLich)))

        nhanTrangThai.font = .systemFont(ofSize: 12.5, weight: .medium)
        nhanTrangThai.textColor = BangMauBCTD.chuPhu
        nhanTrangThai.numberOfLines = 0
        ngan.addArrangedSubview(nhanTrangThai)
        ngan.addArrangedSubview(taoDuongKe())
        ngan.addArrangedSubview(taoNhan("CÁC LỊCH ĐÃ LƯU", dam: true))
        nganLich.axis = .vertical; nganLich.spacing = 8
        ngan.addArrangedSubview(nganLich)
        capNhatNutLuaChon()
    }

    func napDuLieu() {
        nhanTrangThai.text = "Đang tải cấu hình…"
        let dichVu = DichVuDongBo.dungChung
        if !dichVu.danhSachSieuThi.isEmpty {
            // Không gán lại UIMenu khi đồng bộ nền chạy, vì UIKit sẽ đóng menu
            // mà người dùng vừa mở. Danh sách cache đủ để hiển thị tức thời.
            if nutChonSieuThi.menu == nil { capNhatMenuSieuThi() }
            else { capNhatTieuDeSieuThi() }
            napNhomVaLich()
            return
        }
        guard !dangTaiDanhSachSieuThi else { return }
        dangTaiDanhSachSieuThi = true
        DichVuDongBo.dungChung.taiDanhSachSieuThi { [weak self] ketQua in
            guard let self else { return }
            self.dangTaiDanhSachSieuThi = false
            if case .success = ketQua { self.capNhatMenuSieuThi() }
            self.napNhomVaLich()
        }
    }

    private func napNhomVaLich() {
        DichVuDongBo.dungChung.taiCauHinhGuiBaoCao { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .success(let duLieu):
                self.danhSachNhom = duLieu.0
                self.danhSachLich = duLieu.1
                if !self.danhSachNhom.contains(where: { $0.lineGroupId == self.groupIdDangChon }) {
                    self.groupIdDangChon = self.danhSachNhom.first?.lineGroupId ?? ""
                }
                self.capNhatMenuNhom(); self.capNhatCauHinhNhacTheoNhom(); self.veDanhSachLich()
                self.nhanTrangThai.text = self.danhSachNhom.isEmpty ? "Chưa có nhóm. Hãy tạo mã và gắn bot vào nhóm trước." : "Dữ liệu báo cáo được đồng bộ lên Supabase ngay sau khi quét/nhập số."
            case .failure(let loi): self.hienLoi(loi.localizedDescription)
            }
        }
    }

    private func capNhatMenuSieuThi() {
        let dichVu = DichVuDongBo.dungChung
        let actions = dichVu.danhSachSieuThi.map { sieuThi in
            UIAction(
                title: "\(sieuThi.maSieuThi) — \(sieuThi.tenSieuThi)",
                state: sieuThi.id == dichVu.sieuThiDangChonId ? .on : .off
            ) { [weak self] _ in
                self?.nhanTrangThai.text = "Đang chuyển siêu thị…"
                DichVuDongBo.dungChung.chonSieuThi(id: sieuThi.id) { ketQua in
                    switch ketQua {
                    case .success:
                        self?.capNhatMenuSieuThi()
                        self?.napNhomVaLich()
                    case .failure(let loi): self?.hienLoi(loi.localizedDescription)
                    }
                }
            }
        }
        nutChonSieuThi.menu = UIMenu(title: "Chọn siêu thị", children: actions)
        nutChonSieuThi.showsMenuAsPrimaryAction = true
        capNhatTieuDeSieuThi()
    }

    private func capNhatTieuDeSieuThi() {
        let dichVu = DichVuDongBo.dungChung
        let ten = dichVu.sieuThiDangChon.map { "\($0.maSieuThi) — \($0.tenSieuThi)" } ?? "Chưa có siêu thị"
        nutChonSieuThi.setTitle("🏬 \(ten) ▾", for: .normal)
    }

    @objc private func themSieuThi() {
        guard let vc = timViewControllerCha() else { return }
        let hop = UIAlertController(title: "Thêm siêu thị", message: "Mỗi siêu thị có dữ liệu, ảnh và lịch gửi độc lập.", preferredStyle: .alert)
        hop.addTextField { $0.placeholder = "Mã siêu thị, ví dụ 76"; $0.autocapitalizationType = .allCharacters }
        hop.addTextField { $0.placeholder = "Tên siêu thị" }
        hop.addAction(UIAlertAction(title: "Thêm và chọn", style: .default) { [weak self, weak hop] _ in
            let ma = hop?.textFields?.first?.text ?? ""
            let ten = hop?.textFields?.last?.text ?? ""
            DichVuDongBo.dungChung.themSieuThi(ma: ma, ten: ten) { ketQua in
                switch ketQua {
                case .success:
                    self?.capNhatMenuSieuThi()
                    self?.napDuLieu()
                case .failure(let loi): self?.hienLoi(loi.localizedDescription)
                }
            }
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        vc.present(hop, animated: true)
    }

    @objc private func xoaSieuThiDangChon() {
        guard let vc = timViewControllerCha(), let sieuThi = DichVuDongBo.dungChung.sieuThiDangChon else { return }
        let hop = UIAlertController(
            title: "Xóa \(sieuThi.tenSieuThi)?",
            message: "Dữ liệu, ảnh và lịch gửi của riêng siêu thị này sẽ bị xóa. Các siêu thị khác vẫn hoạt động.",
            preferredStyle: .alert
        )
        hop.addAction(UIAlertAction(title: "Xóa", style: .destructive) { [weak self] _ in
            DichVuDongBo.dungChung.xoaSieuThi(id: sieuThi.id) { ketQua in
                switch ketQua {
                case .success:
                    self?.capNhatMenuSieuThi()
                    self?.napDuLieu()
                case .failure(let loi): self?.hienLoi(loi.localizedDescription)
                }
            }
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        vc.present(hop, animated: true)
    }

    @objc private func taoMa() {
        DichVuDongBo.dungChung.taoMaGanNhomLine { [weak self] ketQua in
            switch ketQua {
            case .success(let kq):
                guard let self else { return }
                self.lenhGanNhomHienTai = "/gannhom \(kq.0)"
                self.nhanMa.isHidden = false
                self.nhanMa.text = "Mã: \(kq.0)\nTrong nhóm gửi: \(self.lenhGanNhomHienTai)"
                self.nutSaoChepLenhGanNhom.setTitle("📋 Sao chép \(self.lenhGanNhomHienTai)", for: .normal)
                self.nutSaoChepLenhGanNhom.isHidden = false
            case .failure(let loi): self?.hienLoi(loi.localizedDescription)
            }
        }
    }

    @objc private func saoChepLenhLienKet() {
        UIPasteboard.general.string = "/lienket"
        nhanTrangThai.textColor = BangMauBCTD.xanhLaDam
        nhanTrangThai.text = "Đã sao chép /lienket. Mở chat riêng với bot LINE và dán lệnh này."
        hienThongBao(tieuDe: "✅ Đã sao chép", noiDung: "Đã sao chép lệnh /lienket. Mở chat riêng với bot LINE và dán lệnh này.")
    }

    @objc private func nhapMaLienKetTaiKhoan() {
        guard let vc = timViewControllerCha() else { return }
        let hop = UIAlertController(
            title: "🔗 Kết nối tài khoản LINE",
            message: "Dán mã 6 số bot gửi sau khi bạn dùng lệnh /lienket:",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Mã 6 chữ số"
            tf.keyboardType = .numberPad
            tf.textContentType = .oneTimeCode
        }
        hop.addAction(UIAlertAction(title: "Kết nối", style: .default) { [weak self, weak hop] _ in
            let ma = hop?.textFields?.first?.text ?? ""
            DichVuDongBo.dungChung.lienKetLine(ma: ma) { ketQua in
                switch ketQua {
                case .success(let thongBao):
                    self?.hienThongBao(tieuDe: "✅ Đã kết nối LINE", noiDung: thongBao)
                case .failure(let loi):
                    self?.hienThongBao(tieuDe: "Chưa kết nối được LINE", noiDung: loi.localizedDescription)
                }
            }
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        vc.present(hop, animated: true)
    }

    @objc private func saoChepLenhGanNhom() {
        guard !lenhGanNhomHienTai.isEmpty else { return }
        UIPasteboard.general.string = lenhGanNhomHienTai
        nhanTrangThai.textColor = BangMauBCTD.xanhLaDam
        nhanTrangThai.text = "Đã sao chép \(lenhGanNhomHienTai). Mở đúng nhóm LINE và dán lệnh này."
        hienThongBao(tieuDe: "✅ Đã sao chép", noiDung: "Đã sao chép \(lenhGanNhomHienTai). Mở đúng nhóm LINE và dán lệnh này.")
    }

    private func khoDangChonTrenGiaoDien() -> KhoAnhBaoCaoBot {
        let tatCa = KhoAnhBaoCaoBot.allCases
        let idx = chonKhoAnh.selectedSegmentIndex
        guard tatCa.indices.contains(idx) else { return .supabase }
        return tatCa[idx]
    }

    private func docCauHinhTuCacO() -> CauHinhKhoAnhBaoCaoBot {
        var cfg = DichVuAnhBaoCaoBot.dungChung.cauHinh
        cfg.kho = khoDangChonTrenGiaoDien()
        cfg.apiKeyImgBB = (oApiKeyImgBB.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cfg.driveClientId = (oDriveClientId.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cfg.driveClientSecret = (oDriveClientSecret.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cfg.driveRefreshToken = (oDriveRefreshToken.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cfg.urlAppsScript = (oURLAppsScript.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cfg.khoaBiMat = (oKhoaDrive.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        cfg.folderId = (oFolderId.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return cfg
    }

    @objc private func doiKhoAnh() {
        let kho = khoDangChonTrenGiaoDien()
        nganCauHinhApiKey.isHidden = kho != .apiKey
        nganCauHinhDrive.isHidden = kho != .googleDrive

        // Tự động áp dụng ngay khi chuyển về Supabase (hoặc khi kho đã đủ thông tin)
        // để tránh lỗi chọn Supabase nhưng ấn Tải ảnh vẫn đẩy lên Google Drive.
        let cfg = docCauHinhTuCacO()
        if kho == .supabase || (kho == .apiKey && cfg.apiKeyDaSanSang) || (kho == .googleDrive && cfg.driveDaSanSang) {
            DichVuAnhBaoCaoBot.dungChung.cauHinh = cfg
        }
        capNhatNhanTrangThaiKhoAnh(cfg: DichVuAnhBaoCaoBot.dungChung.cauHinh)
    }

    @objc private func luuCauHinhKhoAnh() {
        let cfg = docCauHinhTuCacO()
        switch cfg.kho {
        case .supabase:
            break
        case .apiKey:
            if !cfg.apiKeyDaSanSang {
                hienLoi("Vui lòng nhập API Key ImgBB trước khi lưu.")
                return
            }
        case .googleDrive:
            if !cfg.driveDaSanSang {
                hienLoi("Google Drive cần nhập bộ OAuth (Client ID + Secret + Refresh Token) HOẶC bộ Apps Script (URL + Khóa bí mật + Folder ID).")
                return
            }
        }
        DichVuAnhBaoCaoBot.dungChung.cauHinh = cfg
        NotificationCenter.default.post(name: .yeuCauTaoLaiAnhBaoCaoBot, object: nil)
        capNhatNhanTrangThaiKhoAnh(cfg: cfg)
        nhanTrangThai.textColor = BangMauBCTD.xanhLaDam
        nhanTrangThai.text = "✅ Đã lưu kho ảnh: \(cfg.tenKhoHieuLuc)."
        viewKetThucNhap()
    }

    private func capNhatNhanTrangThaiKhoAnh(cfg: CauHinhKhoAnhBaoCaoBot) {
        nhanTrangThaiKhoAnh.textColor = BangMauBCTD.xanhLaDam
        switch cfg.kho {
        case .supabase:
            nhanTrangThaiKhoAnh.text = "🟢 Kho đang dùng: Supabase (tải trực tiếp qua Signed URL, mỗi loại chỉ giữ 1 ảnh mới nhất)."
        case .apiKey:
            if cfg.apiKeyDaSanSang {
                nhanTrangThaiKhoAnh.text = "🟢 Kho đang dùng: API Key (ImgBB) — tải nhị phân trực tiếp siêu tốc, tự dự phòng sang Supabase nếu lỗi."
            } else {
                nhanTrangThaiKhoAnh.textColor = .systemOrange
                nhanTrangThaiKhoAnh.text = "🟠 Đang chọn API Key (ImgBB) nhưng chưa lưu API Key (tạm dùng Supabase)."
            }
        case .googleDrive:
            if cfg.driveTrucTiepDaSanSang {
                nhanTrangThaiKhoAnh.text = "🟢 Kho đang dùng: Google Drive (API trực tiếp — không qua Apps Script)."
            } else if cfg.driveAppsScriptDaSanSang {
                nhanTrangThaiKhoAnh.text = "🟢 Kho đang dùng: Google Drive (qua Apps Script)."
            } else {
                nhanTrangThaiKhoAnh.textColor = .systemOrange
                nhanTrangThaiKhoAnh.text = "🟠 Đang chọn Google Drive nhưng chưa đủ thông tin xác thực (tạm dùng Supabase)."
            }
        }
    }

    private func napCauHinhKhoAnh() {
        let cfg = DichVuAnhBaoCaoBot.dungChung.cauHinh
        if let idx = KhoAnhBaoCaoBot.allCases.firstIndex(of: cfg.kho) {
            chonKhoAnh.selectedSegmentIndex = idx
        } else {
            chonKhoAnh.selectedSegmentIndex = 0
        }
        oApiKeyImgBB.text = cfg.apiKeyImgBB
        oDriveClientId.text = cfg.driveClientId
        oDriveClientSecret.text = cfg.driveClientSecret
        oDriveRefreshToken.text = cfg.driveRefreshToken
        oURLAppsScript.text = cfg.urlAppsScript
        oKhoaDrive.text = cfg.khoaBiMat
        oFolderId.text = cfg.folderId
        let kho = khoDangChonTrenGiaoDien()
        nganCauHinhApiKey.isHidden = kho != .apiKey
        nganCauHinhDrive.isHidden = kho != .googleDrive
        capNhatNhanTrangThaiKhoAnh(cfg: cfg)
    }

    private func viewKetThucNhap() {
        oApiKeyImgBB.resignFirstResponder()
        oDriveClientId.resignFirstResponder()
        oDriveClientSecret.resignFirstResponder()
        oDriveRefreshToken.resignFirstResponder()
        oURLAppsScript.resignFirstResponder()
        oKhoaDrive.resignFirstResponder()
        oFolderId.resignFirstResponder()
    }

    @objc private func chonThu(_ sender: UIButton) {
        if cacThuDangChon.contains(sender.tag) { cacThuDangChon.remove(sender.tag) } else { cacThuDangChon.insert(sender.tag) }
        capNhatNutLuaChon()
    }

    @objc private func chonNoiDung(_ sender: UIButton) {
        let ma = cacNoiDung[sender.tag].0
        if noiDungDangChon.contains(ma) { noiDungDangChon.remove(ma) } else { noiDungDangChon.insert(ma) }
        capNhatNutLuaChon()
    }

    @objc private func luuLich() {
        guard !groupIdDangChon.isEmpty else { hienLoi("Hãy gắn ít nhất một nhóm LINE trước."); return }
        guard !cacThuDangChon.isEmpty, !noiDungDangChon.isEmpty else { hienLoi("Hãy chọn ngày và nội dung cần gửi."); return }
        let f = DateFormatter(); f.dateFormat = "HH:mm"
        let kieuGui = chonKieuGui.selectedSegmentIndex == 1 ? "text" : "anh"
        let idTam = "tam-\(UUID().uuidString)"
        let lichTam = LichGuiBaoCaoDMX(
            id: idTam, lineGroupId: groupIdDangChon, gio: f.string(from: chonGio.date),
            cacThu: cacThuDangChon.sorted(), cacNoiDung: Array(noiDungDangChon).sorted(),
            kieuGui: kieuGui, dangHoatDong: true
        )
        danhSachLich.append(lichTam)
        danhSachLich.sort { $0.gio < $1.gio }
        veDanhSachLich()
        nhanTrangThai.textColor = BangMauBCTD.xanhLaDam
        nhanTrangThai.text = "Đã thêm lịch. Đang đồng bộ nền…"

        DichVuDongBo.dungChung.luuLichGuiBaoCao(groupId: groupIdDangChon, gio: f.string(from: chonGio.date), cacThu: cacThuDangChon.sorted(), cacNoiDung: Array(noiDungDangChon).sorted(), kieuGui: kieuGui) { [weak self] kq in
            guard let self else { return }
            switch kq {
            case .success(let lichDaLuu):
                if let i = self.danhSachLich.firstIndex(where: { $0.id == idTam }) { self.danhSachLich[i] = lichDaLuu }
                self.danhSachLich.sort { $0.gio < $1.gio }
                self.veDanhSachLich()
                self.nhanTrangThai.text = "Đã đồng bộ lịch gửi."
            case .failure(let loi):
                self.danhSachLich.removeAll { $0.id == idTam }
                self.veDanhSachLich()
                self.hienLoi(loi.localizedDescription)
            }
        }
    }

    @objc private func xoaLich(_ sender: UIButton) {
        guard danhSachLich.indices.contains(sender.tag) else { return }
        let viTri = sender.tag
        let lichDaXoa = danhSachLich.remove(at: viTri)
        veDanhSachLich()
        nhanTrangThai.textColor = BangMauBCTD.xanhLaDam
        nhanTrangThai.text = "Đã xóa lịch. Đang đồng bộ nền…"
        let id = lichDaXoa.id
        DichVuDongBo.dungChung.xoaLichGuiBaoCao(id: id) { [weak self] kq in
            guard let self else { return }
            if case .failure(let loi) = kq {
                self.danhSachLich.insert(lichDaXoa, at: min(viTri, self.danhSachLich.count))
                self.veDanhSachLich()
                self.hienLoi(loi.localizedDescription)
            } else {
                self.nhanTrangThai.text = "Đã đồng bộ việc xóa lịch."
            }
        }
    }

    private func capNhatMenuNhom() {
        let actions = danhSachNhom.map { nhom in
            UIAction(title: nhom.tenNhom, state: nhom.lineGroupId == groupIdDangChon ? .on : .off) { [weak self] _ in
                self?.groupIdDangChon = nhom.lineGroupId
                self?.capNhatMenuNhom()
                self?.capNhatCauHinhNhacTheoNhom()
            }
        }
        nutChonNhom.menu = UIMenu(title: "Nhóm nhận báo cáo", children: actions)
        nutChonNhom.showsMenuAsPrimaryAction = true
        let ten = danhSachNhom.first(where: { $0.lineGroupId == groupIdDangChon })?.tenNhom ?? "Chưa có nhóm LINE"
        nutChonNhom.setTitle("Nhóm nhận: \(ten) ▾", for: .normal)
    }

    private func capNhatCauHinhNhacTheoNhom() {
        guard let nhom = danhSachNhom.first(where: { $0.lineGroupId == groupIdDangChon }) else {
            congTacNhacPhanHoi.isOn = false
            soPhutChoPhanHoi = 30
            capNhatMenuThoiGianNhac()
            return
        }
        congTacNhacPhanHoi.isOn = nhom.batNhacPhanHoi ?? false
        soPhutChoPhanHoi = nhom.soPhutCho ?? 30
        capNhatMenuThoiGianNhac()
    }

    private func capNhatMenuThoiGianNhac() {
        let cacMoc = [1, 5, 10, 15, 30, 45, 60, 90, 120]
        let actions = cacMoc.map { phut in
            UIAction(title: tenThoiGianCho(phut),
                     state: phut == soPhutChoPhanHoi ? .on : .off) { [weak self] _ in
                self?.soPhutChoPhanHoi = phut
                self?.capNhatMenuThoiGianNhac()
            }
        }
        nutChonThoiGianNhac.menu = UIMenu(title: "Thời gian chờ phản hồi", children: actions)
        nutChonThoiGianNhac.showsMenuAsPrimaryAction = true
        nutChonThoiGianNhac.setTitle("⏱ Thời gian chờ: \(tenThoiGianCho(soPhutChoPhanHoi)) ▾", for: .normal)
    }

    private func tenThoiGianCho(_ phut: Int) -> String {
        guard phut >= 60 else { return "\(phut) phút" }
        let phutLe = phut % 60
        return phutLe == 0 ? "\(phut / 60) giờ" : "\(phut / 60) giờ \(phutLe) phút"
    }

    @objc private func luuNhacPhanHoiNhom() {
        guard !groupIdDangChon.isEmpty else { hienLoi("Hãy chọn một nhóm LINE trước."); return }
        let groupId = groupIdDangChon
        let bat = congTacNhacPhanHoi.isOn
        let phut = soPhutChoPhanHoi
        nhanTrangThai.text = "Đang lưu nhắc phản hồi…"
        DichVuDongBo.dungChung.luuNhacPhanHoiNhom(groupId: groupId, bat: bat, soPhutCho: phut) { [weak self] ketQua in
            guard let self else { return }
            switch ketQua {
            case .success:
                if let index = self.danhSachNhom.firstIndex(where: { $0.lineGroupId == groupId }) {
                    self.danhSachNhom[index].batNhacPhanHoi = bat
                    self.danhSachNhom[index].soPhutCho = phut
                }
                self.nhanTrangThai.textColor = BangMauBCTD.xanhLaDam
                self.nhanTrangThai.text = bat
                    ? "✅ Đã bật nhắc phản hồi sau \(phut) phút cho nhóm này."
                    : "✅ Đã tắt nhắc phản hồi cho nhóm này."
            case .failure(let loi): self.hienLoi(loi.localizedDescription)
            }
        }
    }

    private func veDanhSachLich() {
        nganLich.arrangedSubviews.forEach { nganLich.removeArrangedSubview($0); $0.removeFromSuperview() }
        if danhSachLich.isEmpty { nganLich.addArrangedSubview(taoNhan("Chưa có lịch gửi tự động.")); return }
        let tenThu = [1:"T2",2:"T3",3:"T4",4:"T5",5:"T6",6:"T7",7:"CN"]
        for (index, lich) in danhSachLich.enumerated() {
            let tenNhom = danhSachNhom.first(where: { $0.lineGroupId == lich.lineGroupId })?.tenNhom ?? "Nhóm LINE"
            let noiDung = lich.cacNoiDung.compactMap { ma in cacNoiDung.first(where: { $0.0 == ma })?.1 }.joined(separator: ", ")
            let hinhThuc = lich.kieuGui == "text" ? "📝 Văn bản" : "🖼️ Ảnh"
            let nhan = taoNhan("⏰ \(String(lich.gio.prefix(5))) • \(lich.cacThu.compactMap { tenThu[$0] }.joined(separator: ", ")) • \(hinhThuc)\n\(tenNhom)\n\(noiDung)")
            let xoa = UIButton(type: .system); xoa.setImage(UIImage(systemName: "trash"), for: .normal); xoa.tintColor = .systemRed; xoa.tag = index
            xoa.addTarget(self, action: #selector(xoaLich(_:)), for: .touchUpInside); xoa.widthAnchor.constraint(equalToConstant: 42).isActive = true
            let dong = UIStackView(arrangedSubviews: [nhan, xoa]); dong.axis = .horizontal; dong.alignment = .center; dong.spacing = 8
            dong.isLayoutMarginsRelativeArrangement = true; dong.layoutMargins = UIEdgeInsets(top: 9, left: 10, bottom: 9, right: 8)
            dong.backgroundColor = BangMauBCTD.nenThePhu; dong.layer.cornerRadius = 10; dong.layer.borderWidth = 1; dong.layer.borderColor = BangMauBCTD.vienThe.cgColor
            nganLich.addArrangedSubview(dong)
        }
    }

    private func capNhatNutLuaChon() {
        for case let nut as UIButton in nganThu.arrangedSubviews { datTrangThai(nut, chon: cacThuDangChon.contains(nut.tag)) }
        for case let nut as UIButton in nganNoiDung.arrangedSubviews { datTrangThai(nut, chon: noiDungDangChon.contains(cacNoiDung[nut.tag].0)) }
    }

    private func datTrangThai(_ nut: UIButton, chon: Bool) {
        nut.backgroundColor = chon ? BangMauBCTD.xanhChuDao : BangMauBCTD.nenThePhu
        nut.setTitleColor(chon ? .white : BangMauBCTD.chuChinh, for: .normal)
        nut.layer.borderColor = (chon ? BangMauBCTD.xanhChuDao : BangMauBCTD.vienDam).cgColor
    }

    private func taoNhan(_ text: String, dam: Bool = false) -> UILabel {
        let l = UILabel(); l.text = text; l.numberOfLines = 0; l.textColor = BangMauBCTD.chuChinh
        l.font = .systemFont(ofSize: dam ? 14 : 13, weight: dam ? .bold : .regular); return l
    }

    private func taoNut(_ text: String, _ action: Selector) -> UIButton {
        let b = UIButton(type: .system); b.setTitle(text, for: .normal); b.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        b.setTitleColor(.white, for: .normal); b.backgroundColor = BangMauBCTD.xanhChuDao; b.layer.cornerRadius = 10
        b.contentEdgeInsets = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10); b.addTarget(self, action: action, for: .touchUpInside); return b
    }

    private func cauHinhNutSaoChep(_ b: UIButton) {
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        b.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        b.backgroundColor = BangMauBCTD.nenHeaderBang
        b.layer.cornerRadius = 10
        b.layer.borderWidth = 1
        b.layer.borderColor = BangMauBCTD.xanhChuDao.cgColor
        b.contentEdgeInsets = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
    }

    private func taoNutLuaChon(_ text: String, tag: Int, action: Selector) -> UIButton {
        let b = UIButton(type: .system); b.setTitle(text, for: .normal); b.tag = tag; b.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        b.layer.cornerRadius = 8; b.layer.borderWidth = 1; b.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        b.addTarget(self, action: action, for: .touchUpInside); return b
    }

    private func cauHinhNutChon(_ b: UIButton) {
        b.contentHorizontalAlignment = .left; b.backgroundColor = BangMauBCTD.nenThePhu; b.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        b.layer.cornerRadius = 9; b.layer.borderWidth = 1; b.layer.borderColor = BangMauBCTD.vienDam.cgColor
        b.contentEdgeInsets = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
    }

    private func cauHinhO(_ o: UITextField, goiY: String, baoMat: Bool = false) {
        o.placeholder = goiY
        o.font = .systemFont(ofSize: 13)
        o.textColor = BangMauBCTD.chuChinh
        o.backgroundColor = BangMauBCTD.nenThePhu
        o.layer.cornerRadius = 8
        o.layer.borderWidth = 1
        o.layer.borderColor = BangMauBCTD.vienDam.cgColor
        o.isSecureTextEntry = baoMat
        o.autocapitalizationType = .none
        o.autocorrectionType = .no
        o.heightAnchor.constraint(equalToConstant: 42).isActive = true
        let dem = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        o.leftView = dem
        o.leftViewMode = .always
    }

    private func taoDuongKe() -> UIView { let v = UIView(); v.backgroundColor = BangMauBCTD.vienThe; v.heightAnchor.constraint(equalToConstant: 1).isActive = true; return v }
    private func hienThongBao(tieuDe: String, noiDung: String) {
        guard let vc = timViewControllerCha() else { return }
        let tb = UIAlertController(title: tieuDe, message: noiDung, preferredStyle: .alert)
        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
        vc.present(tb, animated: true)
    }

    private func hienLoi(_ text: String) { nhanTrangThai.text = "⚠️ \(text)"; nhanTrangThai.textColor = .systemRed }
}
