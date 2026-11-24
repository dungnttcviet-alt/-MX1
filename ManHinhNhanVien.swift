import UIKit
import PhotosUI
import UniformTypeIdentifiers

// MARK: - 1. Màn hình Chi tiết Ngành hàng -> Xếp hạng nhân viên, Nhập ảnh thực hiện NV, Chia Target & Xuất ảnh

final class ManHinhChiTietNganhHang: UIViewController, UITableViewDataSource, UITableViewDelegate, PHPickerViewControllerDelegate, UIDocumentPickerDelegate {
    private var dong: DongThiDua
    private let ngay: Date
    private let cheDo: LoaiCheDoDoanhThu
    private var danhSachXepHang: [DongXepHangNhanVienNganh] = []

    var khiCapNhatDuLieu: (() -> Void)?
    var khiYeuCauSuaDong: ((DongThiDua) -> Void)?

    private let nhanPhuDe = UILabel()
    private let nhanThongTinTarget = UILabel()
    private let bang = UITableView(frame: .zero, style: .plain)
    private let khungTongCong = UIView()
    private let nhanTongCongTrai = UILabel()
    private let nhanTongCongPhai = UILabel()
    private let khungTrong = UIView()
    private let lopPhuTai = UIView()
    private let nhanTienTrinh = UILabel()
    private let vongQuay = UIActivityIndicatorView(style: .large)

    init(dong: DongThiDua, ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) {
        self.dong = dong
        self.ngay = ngay
        self.cheDo = cheDo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func capNhatTieuDeThanhDieuHuong(_ chu: String) {
        title = chu
        let nhan = UILabel()
        nhan.text = chu
        nhan.font = .systemFont(ofSize: 13.5, weight: .bold)
        nhan.textColor = .label
        nhan.textAlignment = .center
        nhan.numberOfLines = 0
        nhan.lineBreakMode = .byWordWrapping
        nhan.adjustsFontSizeToFitWidth = false
        navigationItem.titleView = nhan
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        capNhatTieuDeThanhDieuHuong("\(dong.tenNganhHang) (\(cheDo.tieuDe))")
        view.backgroundColor = .systemGroupedBackground

        let nutSua = UIBarButtonItem(
            image: UIImage(systemName: "pencil.circle"),
            style: .plain,
            target: self,
            action: #selector(bamSuaNganhHang)
        )
        let nutXuatAnh = UIBarButtonItem(
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            style: .plain,
            target: self,
            action: #selector(bamXuatAnhBangNganhHang)
        )
        navigationItem.rightBarButtonItems = [nutXuatAnh, nutSua]

        taoGiaoDien()
        napDuLieu()
        NotificationCenter.default.addObserver(self, selector: #selector(napDuLieu), name: .duLieuDMXDaDongBo, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        napDuLieu()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func taoGiaoDien() {
        view.backgroundColor = BangMauBCTD.nenTrang

        let khungDau = UIView()
        khungDau.backgroundColor = BangMauBCTD.nenMenuToi
        khungDau.layer.cornerRadius = 12
        khungDau.layer.borderWidth = 1
        khungDau.layer.borderColor = BangMauBCTD.vangChuDao.withAlphaComponent(0.35).cgColor

        nhanPhuDe.font = .systemFont(ofSize: 11.5, weight: .heavy)
        nhanPhuDe.textColor = BangMauBCTD.vangChuDao
        nhanPhuDe.numberOfLines = 0
        nhanPhuDe.lineBreakMode = .byWordWrapping
        nhanPhuDe.adjustsFontSizeToFitWidth = false

        nhanThongTinTarget.font = .systemFont(ofSize: 13.5, weight: .bold)
        nhanThongTinTarget.textColor = .white
        nhanThongTinTarget.numberOfLines = 0
        nhanThongTinTarget.lineBreakMode = .byWordWrapping
        nhanThongTinTarget.adjustsFontSizeToFitWidth = false

        let nutQuetAnhNV = UIButton(type: .system)
        nutQuetAnhNV.setImage(UIImage(systemName: "camera.viewfinder"), for: .normal)
        nutQuetAnhNV.setTitle(" Nhập ảnh thực hiện NV (\(cheDo.tieuDe))", for: .normal)
        nutQuetAnhNV.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nutQuetAnhNV.titleLabel?.numberOfLines = 1
        nutQuetAnhNV.titleLabel?.lineBreakMode = .byTruncatingTail
        nutQuetAnhNV.titleLabel?.textAlignment = .center
        nutQuetAnhNV.titleLabel?.adjustsFontSizeToFitWidth = true
        nutQuetAnhNV.titleLabel?.minimumScaleFactor = 0.72
        nutQuetAnhNV.backgroundColor = BangMauBCTD.indigoChuDao
        nutQuetAnhNV.tintColor = .white
        nutQuetAnhNV.setTitleColor(.white, for: .normal)
        nutQuetAnhNV.layer.cornerRadius = 9
        nutQuetAnhNV.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutQuetAnhNV.addTarget(self, action: #selector(bamQuetAnhNV), for: .touchUpInside)

        let nutChiaTarget = UIButton(type: .system)
        nutChiaTarget.setImage(UIImage(systemName: "person.2.badge.gearshape"), for: .normal)
        nutChiaTarget.setTitle(" Chia Target", for: .normal)
        nutChiaTarget.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        nutChiaTarget.titleLabel?.numberOfLines = 0
        nutChiaTarget.titleLabel?.lineBreakMode = .byWordWrapping
        nutChiaTarget.titleLabel?.textAlignment = .center
        nutChiaTarget.titleLabel?.adjustsFontSizeToFitWidth = false
        nutChiaTarget.backgroundColor = BangMauBCTD.nenDongChonMenu
        nutChiaTarget.tintColor = BangMauBCTD.vangChuDao
        nutChiaTarget.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
        nutChiaTarget.layer.cornerRadius = 9
        nutChiaTarget.layer.borderWidth = 1
        nutChiaTarget.layer.borderColor = BangMauBCTD.vangChuDao.withAlphaComponent(0.55).cgColor
        nutChiaTarget.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutChiaTarget.addTarget(self, action: #selector(bamMoChiaTarget), for: .touchUpInside)

        let nutXoaDuLieuMon = UIButton(type: .system)
        let cfgTrash = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        nutXoaDuLieuMon.setImage(UIImage(systemName: "trash.fill", withConfiguration: cfgTrash), for: .normal)
        nutXoaDuLieuMon.backgroundColor = BangMauBCTD.doYeuPill
        nutXoaDuLieuMon.tintColor = BangMauBCTD.doYeuChu
        nutXoaDuLieuMon.layer.cornerRadius = 9
        nutXoaDuLieuMon.layer.borderWidth = 1
        nutXoaDuLieuMon.layer.borderColor = BangMauBCTD.doYeuChu.withAlphaComponent(0.55).cgColor
        nutXoaDuLieuMon.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutXoaDuLieuMon.accessibilityLabel = "Xóa dữ liệu thi đua môn này"
        nutXoaDuLieuMon.translatesAutoresizingMaskIntoConstraints = false
        nutXoaDuLieuMon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        nutXoaDuLieuMon.addTarget(self, action: #selector(bamXoaDuLieuThiDuaMon), for: .touchUpInside)

        let hangNutChinh = UIStackView(arrangedSubviews: [nutQuetAnhNV, nutChiaTarget])
        hangNutChinh.axis = .horizontal
        hangNutChinh.spacing = 8
        hangNutChinh.distribution = .fillEqually

        let hangNut = UIStackView(arrangedSubviews: [hangNutChinh, nutXoaDuLieuMon])
        hangNut.axis = .horizontal
        hangNut.spacing = 8
        hangNut.distribution = .fill

        let nganDau = UIStackView(arrangedSubviews: [nhanPhuDe, nhanThongTinTarget, hangNut])
        nganDau.axis = .vertical
        nganDau.spacing = 6
        nganDau.translatesAutoresizingMaskIntoConstraints = false
        khungDau.addSubview(nganDau)

        bang.dataSource = self
        bang.delegate = self
        bang.separatorStyle = .none
        bang.backgroundColor = .secondarySystemGroupedBackground
        bang.layer.cornerRadius = 12
        bang.clipsToBounds = true
        if #available(iOS 15.0, *) {
            bang.sectionHeaderTopPadding = 0
        }

        khungTongCong.backgroundColor = BangMauBCTD.nenMenuToi
        khungTongCong.layer.cornerRadius = 10
        khungTongCong.layer.borderWidth = 1
        khungTongCong.layer.borderColor = BangMauBCTD.vangChuDao.withAlphaComponent(0.4).cgColor
        nhanTongCongTrai.font = .systemFont(ofSize: 12.5, weight: .bold)
        nhanTongCongTrai.textColor = .white
        nhanTongCongTrai.numberOfLines = 0
        nhanTongCongTrai.lineBreakMode = .byWordWrapping
        nhanTongCongTrai.adjustsFontSizeToFitWidth = false

        nhanTongCongPhai.font = .systemFont(ofSize: 12.5, weight: .heavy)
        nhanTongCongPhai.textColor = BangMauBCTD.vangChuDao
        nhanTongCongPhai.textAlignment = .right
        nhanTongCongPhai.numberOfLines = 0
        nhanTongCongPhai.lineBreakMode = .byWordWrapping
        nhanTongCongPhai.adjustsFontSizeToFitWidth = false
        nhanTongCongPhai.setContentCompressionResistancePriority(.required, for: .horizontal)

        [nhanTongCongTrai, nhanTongCongPhai].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khungTongCong.addSubview($0)
        }

        khungTrong.backgroundColor = .secondarySystemGroupedBackground
        khungTrong.layer.cornerRadius = 12
        let nhanTrong = UILabel()
        nhanTrong.text = "Chưa chọn nhân viên nhận Target cho mặt hàng này.\nHãy bấm \"Chia Target\" để tích chọn các nhân viên phụ trách hoặc \"Nhập ảnh thực hiện NV\"."
        nhanTrong.font = .systemFont(ofSize: 13.5)
        nhanTrong.textColor = .secondaryLabel
        nhanTrong.textAlignment = .center
        nhanTrong.numberOfLines = 0
        nhanTrong.lineBreakMode = .byWordWrapping
        nhanTrong.adjustsFontSizeToFitWidth = false
        nhanTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nhanTrong)

        [khungDau, bang, khungTrong, khungTongCong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            khungDau.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            khungDau.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            khungDau.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            nganDau.topAnchor.constraint(equalTo: khungDau.topAnchor, constant: 10),
            nganDau.leadingAnchor.constraint(equalTo: khungDau.leadingAnchor, constant: 12),
            nganDau.trailingAnchor.constraint(equalTo: khungDau.trailingAnchor, constant: -12),
            nganDau.bottomAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: -10),

            khungTongCong.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            khungTongCong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            khungTongCong.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            khungTongCong.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),

            nhanTongCongTrai.leadingAnchor.constraint(equalTo: khungTongCong.leadingAnchor, constant: 12),
            nhanTongCongTrai.topAnchor.constraint(equalTo: khungTongCong.topAnchor, constant: 8),
            nhanTongCongTrai.bottomAnchor.constraint(equalTo: khungTongCong.bottomAnchor, constant: -8),
            nhanTongCongTrai.trailingAnchor.constraint(lessThanOrEqualTo: nhanTongCongPhai.leadingAnchor, constant: -8),

            nhanTongCongPhai.trailingAnchor.constraint(equalTo: khungTongCong.trailingAnchor, constant: -12),
            nhanTongCongPhai.centerYAnchor.constraint(equalTo: khungTongCong.centerYAnchor),

            bang.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 8),
            bang.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            bang.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            bang.bottomAnchor.constraint(equalTo: khungTongCong.topAnchor, constant: -8),

            khungTrong.topAnchor.constraint(equalTo: khungDau.bottomAnchor, constant: 8),
            khungTrong.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            khungTrong.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            khungTrong.bottomAnchor.constraint(equalTo: khungTongCong.topAnchor, constant: -8),

            nhanTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nhanTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nhanTrong.leadingAnchor.constraint(equalTo: khungTrong.leadingAnchor, constant: 20),
            nhanTrong.trailingAnchor.constraint(equalTo: khungTrong.trailingAnchor, constant: -20)
        ])

        taoLopPhuTienTrinh()
    }

    private func taoLopPhuTienTrinh() {
        lopPhuTai.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        lopPhuTai.isHidden = true
        lopPhuTai.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lopPhuTai)

        let hop = UIView()
        hop.backgroundColor = .systemBackground
        hop.layer.cornerRadius = 16
        hop.translatesAutoresizingMaskIntoConstraints = false
        lopPhuTai.addSubview(hop)

        vongQuay.color = .systemBlue
        vongQuay.translatesAutoresizingMaskIntoConstraints = false
        nhanTienTrinh.font = .systemFont(ofSize: 14, weight: .semibold)
        nhanTienTrinh.textAlignment = .center
        nhanTienTrinh.numberOfLines = 0
        nhanTienTrinh.lineBreakMode = .byWordWrapping
        nhanTienTrinh.adjustsFontSizeToFitWidth = false
        nhanTienTrinh.translatesAutoresizingMaskIntoConstraints = false

        hop.addSubview(vongQuay)
        hop.addSubview(nhanTienTrinh)

        NSLayoutConstraint.activate([
            lopPhuTai.topAnchor.constraint(equalTo: view.topAnchor),
            lopPhuTai.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lopPhuTai.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lopPhuTai.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hop.centerXAnchor.constraint(equalTo: lopPhuTai.centerXAnchor),
            hop.centerYAnchor.constraint(equalTo: lopPhuTai.centerYAnchor),
            hop.widthAnchor.constraint(equalToConstant: 250),
            vongQuay.topAnchor.constraint(equalTo: hop.topAnchor, constant: 18),
            vongQuay.centerXAnchor.constraint(equalTo: hop.centerXAnchor),
            nhanTienTrinh.topAnchor.constraint(equalTo: vongQuay.bottomAnchor, constant: 12),
            nhanTienTrinh.leadingAnchor.constraint(equalTo: hop.leadingAnchor, constant: 14),
            nhanTienTrinh.trailingAnchor.constraint(equalTo: hop.trailingAnchor, constant: -14),
            nhanTienTrinh.bottomAnchor.constraint(equalTo: hop.bottomAnchor, constant: -18)
        ])
    }

    @objc private func napDuLieu() {
        let dl = KhoDuLieu.dungChung.duLieu(cho: ngay)
        let dsTheoCheDo = dl.danhSachThiDua(theo: cheDo)
        if let capNhatDong = dsTheoCheDo.first(where: {
            $0.id == dong.id || KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) == KhoDuLieu.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        }) ?? dl.danhSachThiDua.first(where: {
            $0.id == dong.id || KhoDuLieu.chuanHoaKhoaSoSanh($0.tenNganhHang) == KhoDuLieu.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        }) {
            dong = capNhatDong
            capNhatTieuDeThanhDieuHuong("\(dong.tenNganhHang) (\(cheDo.tieuDe))")
        }

        danhSachXepHang = KhoDuLieu.dungChung.danhSachXepHangNhanVien(cho: dong, den: ngay, cheDo: cheDo)
        let soNV = danhSachXepHang.count
        let targetMoiNV = soNV > 0 ? dong.target / Double(soNV) : 0
        let donVi = dl.thongTinDonVi.isEmpty ? "ĐIỆN MÁY XANH" : dl.thongTinDonVi

        nhanPhuDe.text = "\(donVi) • \(cheDo.tieuDe) • Ngày \(TienIchNgay.hienThiNgay.string(from: ngay))"
        nhanThongTinTarget.text = "Target ST: \(dong.target.chuoiSoGonVN) (\(dong.loaiChiTieu.maBang))  •  Chia đều \(soNV) NV: \(soNV > 0 ? targetMoiNV.chuoiSoGonVN : "--")/NV"

        let tongTH = danhSachXepHang.reduce(0.0) { $0 + $1.thucHien }
        let tyLeChung = dong.target > 0 ? Int(round(tongTH / dong.target * 100.0)) : 0
        nhanTongCongTrai.text = "TỔNG (\(cheDo.tieuDe)): \(tongTH.chuoiSoGonVN) / \(dong.target.chuoiSoGonVN) • \(soNV) NV"
        nhanTongCongPhai.text = "Tỷ lệ HT: \(tyLeChung)%"

        khungTrong.isHidden = !danhSachXepHang.isEmpty
        bang.isHidden = danhSachXepHang.isEmpty
        bang.reloadData()
    }

    @objc private func bamQuetAnhNV() {
        hienMenuChon(
            tieuDe: "Nhập ảnh Thực hiện Nhân viên",
            cacMuc: [
                MucChonDMX(tieuDe: "🖼️ Chọn ảnh từ Thư viện Ảnh") { [weak self] in
                    guard let self else { return }
                    var cauHinh = PHPickerConfiguration()
                    cauHinh.filter = .images
                    cauHinh.selectionLimit = 50
                    if #available(iOS 15.0, *) {
                        cauHinh.selection = .ordered
                    }
                    let picker = PHPickerViewController(configuration: cauHinh)
                    picker.delegate = self
                    self.present(picker, animated: true)
                },
                MucChonDMX(tieuDe: "📁 Nhập ảnh từ Tệp (Files)") { [weak self] in
                    guard let self else { return }
                    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
                    picker.delegate = self
                    picker.allowsMultipleSelection = true
                    self.present(picker, animated: true)
                },
                MucChonDMX(tieuDe: "Đóng", kieu: .huy)
            ]
        )
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        guard !urls.isEmpty else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var cacAnh: [UIImage] = []
            for url in urls {
                let ok = url.startAccessingSecurityScopedResource()
                defer { if ok { url.stopAccessingSecurityScopedResource() } }
                if let d = try? Data(contentsOf: url), let img = UIImage(data: d) {
                    cacAnh.append(img)
                } else if let img = UIImage(contentsOfFile: url.path) {
                    cacAnh.append(img)
                }
            }
            DispatchQueue.main.async {
                guard let self = self, !cacAnh.isEmpty else { return }
                self.xuLyQuetAnhNV(cacAnh)
            }
        }
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let nhom = DispatchGroup()
        let khoaAnh = NSLock()
        var danhSach = Array<UIImage?>(repeating: nil, count: results.count)
        for (i, r) in results.enumerated() {
            guard r.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            nhom.enter()
            r.itemProvider.loadObject(ofClass: UIImage.self) { obj, _ in
                if let img = obj as? UIImage {
                    khoaAnh.lock()
                    danhSach[i] = img
                    khoaAnh.unlock()
                }
                nhom.leave()
            }
        }

        nhom.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let cacAnh = danhSach.compactMap { $0 }
            self.xuLyQuetAnhNV(cacAnh)
        }
    }

    private func xuLyQuetAnhNV(_ cacAnh: [UIImage]) {
        guard !cacAnh.isEmpty else { return }
        if true {
            self.nhanTienTrinh.text = "Đang đọc \(cacAnh.count) ảnh Thực hiện NV (\(self.cheDo.tieuDe))..."
            self.lopPhuTai.isHidden = false
            self.vongQuay.startAnimating()

            let khoaMacDinh = KhoDuLieu.chuanHoaKhoaSoSanh(self.dong.tenNganhHang)
            DichVuDocAnh.dungChung.quetAnhThiDuaNhanVien(
                danhSachAnh: cacAnh,
                tenNganhGoiY: self.dong.tenNganhHang,
                tienTrinh: { [weak self] tt in
                    self?.nhanTienTrinh.text = tt
                },
                hoanTat: { [weak self] cacKhoi in
                    guard let self = self else { return }
                    self.vongQuay.stopAnimating()
                    self.lopPhuTai.isHidden = true

                    if cacKhoi.isEmpty {
                        let loi = DichVuDocAnh.dungChung.loiGeminiGanNhat
                        let tb = UIAlertController(
                            title: loi != nil ? "Quét Gemini thất bại" : "Chưa đọc được dòng nhân viên",
                            message: loi ?? "Hãy chụp rõ cột mã - tên nhân viên và cột số thực hiện rồi thử lại.",
                            preferredStyle: .alert
                        )
                        tb.addAction(UIAlertAction(title: "Đóng", style: .default))
                        self.present(tb, animated: true)
                        return
                    }

                    var cacKhoiCapNhat = cacKhoi
                    for i in cacKhoiCapNhat.indices {
                        if self.dong.thucHien > 0 && cacKhoiCapNhat[i].thucHienNganhGoiY <= 0 {
                            cacKhoiCapNhat[i].thucHienNganhGoiY = self.dong.thucHien
                        } else if self.dong.thucHien <= 0 && cacKhoiCapNhat[i].thucHienNganhGoiY > 0 {
                            self.dong.thucHien = cacKhoiCapNhat[i].thucHienNganhGoiY
                        }
                        if self.dong.target > 0 && cacKhoiCapNhat[i].targetNganhGoiY <= 0 {
                            cacKhoiCapNhat[i].targetNganhGoiY = self.dong.target
                        } else if self.dong.target <= 0 && cacKhoiCapNhat[i].targetNganhGoiY > 0 {
                            self.dong.target = cacKhoiCapNhat[i].targetNganhGoiY
                            KhoDuLieu.dungChung.capNhatTargetNganhHang(
                                dongGoc: self.dong,
                                targetMoi: cacKhoiCapNhat[i].targetNganhGoiY,
                                cho: self.ngay,
                                cheDo: self.cheDo
                            )
                        }
                    }

                    var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
                    KhoDuLieu.dungChung.boSungDanhSachThiDuaTuKhoiNhanVien(
                        mangKhoiNV: cacKhoiCapNhat,
                        vao: &dl,
                        cheDo: self.cheDo
                    )
                    let bangMoi = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                        hienTai: dl.thiDuaNhanVien(theo: self.cheDo),
                        mangKhoiNV: cacKhoiCapNhat,
                        ngay: self.ngay,
                        cheDo: self.cheDo,
                        khoaNganhMacDinh: khoaMacDinh
                    )
                    dl.ganThiDuaNhanVien(bangMoi, theo: self.cheDo)
                    KhoDuLieu.dungChung.luu(dl)
                    self.napDuLieu()
                    self.khiCapNhatDuLieu?()
                }
            )
        }
    }

    @objc private func bamXoaDuLieuThiDuaMon() {
        let hop = UIAlertController(
            title: "Xóa dữ liệu thi đua môn này?",
            message: "Bạn có chắc muốn xóa toàn bộ số liệu thi đua nhân viên của môn \"\(dong.tenNganhHang)\" (\(cheDo.tieuDe)) không?",
            preferredStyle: .alert
        )
        hop.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        hop.addAction(UIAlertAction(title: "Xóa dữ liệu", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            KhoDuLieu.dungChung.xoaThiDuaNhanVienTheoMon(
                dong: self.dong,
                ngay: self.ngay,
                cheDo: self.cheDo
            )
            self.napDuLieu()
            self.khiCapNhatDuLieu?()
        })
        present(hop, animated: true)
    }

    @objc private func bamMoChiaTarget() {
        let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(dong.tenNganhHang)
        let vc = ManHinhChiaTarget(ngay: ngay, khoaNganhChonMacDinh: khoa)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func bamSuaNganhHang() {
        khiYeuCauSuaDong?(dong)
    }

    // MARK: - Bảng xếp hạng nhân viên của ngành hàng

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSachXepHang.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = danhSachXepHang[indexPath.row]
        let chuoiTen = "\(item.hoTen) - \(item.maNV)"
        let rongTen = max(100, tableView.bounds.width - 230)
        let fontTen = UIFont.systemFont(ofSize: 12, weight: .bold)
        let rect = (chuoiTen as NSString).boundingRect(
            with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTen],
            context: nil
        )
        return max(54, ceil(rect.height) + 22)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        header.backgroundColor = BangMauBCTD.nenHeaderBang

        let nhanTrai = UILabel()
        nhanTrai.text = "#  NHÂN VIÊN (Chạm sửa)"
        nhanTrai.font = .systemFont(ofSize: 11, weight: .bold)
        nhanTrai.textColor = BangMauBCTD.vangChuDao
        nhanTrai.numberOfLines = 0
        nhanTrai.lineBreakMode = .byWordWrapping
        nhanTrai.adjustsFontSizeToFitWidth = false

        let nhanPhai = UILabel()
        nhanPhai.text = "THỰC HIỆN • CÒN/VƯỢT • % HT"
        nhanPhai.font = .systemFont(ofSize: 11, weight: .bold)
        nhanPhai.textColor = .white
        nhanPhai.textAlignment = .right
        nhanPhai.numberOfLines = 0
        nhanPhai.lineBreakMode = .byWordWrapping
        nhanPhai.adjustsFontSizeToFitWidth = false

        [nhanTrai, nhanPhai].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview($0)
        }
        NSLayoutConstraint.activate([
            nhanTrai.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10),
            nhanTrai.topAnchor.constraint(equalTo: header.topAnchor, constant: 4),
            nhanTrai.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -4),
            nhanPhai.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -10),
            nhanPhai.topAnchor.constraint(equalTo: header.topAnchor, constant: 4),
            nhanPhai.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -4),
            nhanTrai.trailingAnchor.constraint(lessThanOrEqualTo: nhanPhai.leadingAnchor, constant: -6)
        ])
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "XepHangNVNganhCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let item = danhSachXepHang[indexPath.row]
        let hang = indexPath.row + 1
        let dat = item.daDat
        let kha = item.phanTramHT >= 80.0

        let nenKhung = UIView()
        nenKhung.layer.cornerRadius = 8
        nenKhung.clipsToBounds = true
        nenKhung.backgroundColor = dat
            ? UIColor(red: 0.94, green: 0.99, blue: 0.96, alpha: 1)
            : (kha ? UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1) : UIColor(red: 1.0, green: 0.99, blue: 0.92, alpha: 1))
        nenKhung.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(nenKhung)

        let thanhTienDo = UIView()
        thanhTienDo.backgroundColor = dat
            ? UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1)
            : (kha ? UIColor(red: 0.86, green: 0.92, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.94, blue: 0.54, alpha: 0.65))
        thanhTienDo.translatesAutoresizingMaskIntoConstraints = false
        nenKhung.addSubview(thanhTienDo)

        let fontDongNhat = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: .bold)

        let nhanHang = UILabel()
        nhanHang.text = KhoDuLieu.huyChuongHang(hang)
        nhanHang.font = fontDongNhat
        nhanHang.textAlignment = .center
        nhanHang.numberOfLines = 0
        nhanHang.lineBreakMode = .byWordWrapping
        nhanHang.adjustsFontSizeToFitWidth = false

        let nhanTen = UILabel()
        nhanTen.text = "\(item.hoTen) - \(item.maNV)"
        nhanTen.font = .systemFont(ofSize: 12, weight: .bold)
        nhanTen.textColor = .label
        nhanTen.numberOfLines = 0
        nhanTen.lineBreakMode = .byWordWrapping
        nhanTen.adjustsFontSizeToFitWidth = false

        let nhanThucHien = UILabel()
        nhanThucHien.text = "\(item.thucHien.chuoiSoGonVN) / \(item.targetCaNhan.chuoiSoGonVN)"
        nhanThucHien.font = fontDongNhat
        nhanThucHien.textAlignment = .right
        nhanThucHien.numberOfLines = 0
        nhanThucHien.lineBreakMode = .byWordWrapping
        nhanThucHien.adjustsFontSizeToFitWidth = false

        let vuot = item.thucHien - item.targetCaNhan
        let nhanChenh = UILabel()
        nhanChenh.text = vuot >= -0.005 ? "+\(max(0, vuot).chuoiSoGonVN)" : "-\(abs(vuot).chuoiSoGonVN)"
        nhanChenh.font = fontDongNhat
        nhanChenh.textColor = vuot >= -0.005 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : .secondaryLabel
        nhanChenh.textAlignment = .right
        nhanChenh.numberOfLines = 0
        nhanChenh.lineBreakMode = .byWordWrapping
        nhanChenh.adjustsFontSizeToFitWidth = false

        let nhanBadge = UILabel()
        nhanBadge.text = "\(Int(round(item.phanTramHT)))%"
        nhanBadge.font = fontDongNhat
        nhanBadge.textAlignment = .center
        nhanBadge.numberOfLines = 0
        nhanBadge.lineBreakMode = .byWordWrapping
        nhanBadge.adjustsFontSizeToFitWidth = false
        nhanBadge.layer.cornerRadius = 6
        nhanBadge.clipsToBounds = true
        nhanBadge.backgroundColor = dat
            ? UIColor(red: 0.80, green: 0.96, blue: 0.85, alpha: 1)
            : (kha ? UIColor(red: 0.82, green: 0.89, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.92, blue: 0.75, alpha: 1))
        nhanBadge.textColor = dat
            ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
            : (kha ? UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1) : UIColor(red: 0.71, green: 0.33, blue: 0.04, alpha: 1))

        [nhanHang, nhanTen, nhanThucHien, nhanChenh, nhanBadge].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            nenKhung.addSubview($0)
        }

        let tyLe = CGFloat(min(1.0, max(0.03, item.phanTramHT / 100.0)))
        NSLayoutConstraint.activate([
            nenKhung.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 3),
            nenKhung.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -3),
            nenKhung.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 6),
            nenKhung.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -6),

            thanhTienDo.leadingAnchor.constraint(equalTo: nenKhung.leadingAnchor),
            thanhTienDo.topAnchor.constraint(equalTo: nenKhung.topAnchor),
            thanhTienDo.bottomAnchor.constraint(equalTo: nenKhung.bottomAnchor),
            thanhTienDo.widthAnchor.constraint(equalTo: nenKhung.widthAnchor, multiplier: tyLe),

            nhanHang.leadingAnchor.constraint(equalTo: nenKhung.leadingAnchor, constant: 6),
            nhanHang.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanHang.widthAnchor.constraint(equalToConstant: 26),

            nhanBadge.trailingAnchor.constraint(equalTo: nenKhung.trailingAnchor, constant: -6),
            nhanBadge.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanBadge.widthAnchor.constraint(equalToConstant: 48),
            nhanBadge.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),

            nhanChenh.trailingAnchor.constraint(equalTo: nhanBadge.leadingAnchor, constant: -6),
            nhanChenh.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanChenh.widthAnchor.constraint(equalToConstant: 56),

            nhanThucHien.trailingAnchor.constraint(equalTo: nhanChenh.leadingAnchor, constant: -6),
            nhanThucHien.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor),
            nhanThucHien.widthAnchor.constraint(greaterThanOrEqualToConstant: 68),

            nhanTen.leadingAnchor.constraint(equalTo: nhanHang.trailingAnchor, constant: 4),
            nhanTen.trailingAnchor.constraint(lessThanOrEqualTo: nhanThucHien.leadingAnchor, constant: -6),
            nhanTen.centerYAnchor.constraint(equalTo: nenKhung.centerYAnchor)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < danhSachXepHang.count else { return }
        let item = danhSachXepHang[indexPath.row]
        let thucHienMon = dong.thucHien
        let hop = UIAlertController(
            title: "\(item.hoTen) (\(item.maNV))",
            message: "Môn \(dong.tenNganhHang) • Đã thực hiện: \(thucHienMon.chuoiSoGonVN) • Target chia: \(item.targetCaNhan.chuoiSoGonVN)\nNhập % đóng góp của nhân viên (tự tính = Đã thực hiện ÷ 100 × %) hoặc nhập trực tiếp số lượng:",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Nhập % (VD: 24) hoặc số thực hiện"
            tf.keyboardType = .decimalPad
            if abs(item.thucHien) > 0.0001 {
                tf.text = item.thucHien.chuoiSoGonVN.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
            }
        }
        hop.addAction(UIAlertAction(title: "Lưu theo % của môn (÷100 × %)", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let chu = (hop.textFields?.first?.text ?? "")
                .replacingOccurrences(of: "%", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ",", with: ".")
            let phanTram = Double(chu) ?? 0
            let giaTri = self.dong.thucHien > 0 ? (((self.dong.thucHien / 100.0) * phanTram * 10000.0).rounded() / 10000.0) : phanTram
            let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(self.dong.tenNganhHang)
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
            var bangNV = dl.thiDuaNhanVien(theo: self.cheDo)
            bangNV[khoa, default: [:]][item.maNV] = giaTri
            dl.ganThiDuaNhanVien(bangNV, theo: self.cheDo)
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
            self.khiCapNhatDuLieu?()
        })
        hop.addAction(UIAlertAction(title: "Lưu số lượng trực tiếp", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let chuGoc = (hop.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let coDauPhanTram = chuGoc.contains("%")
            let chu = chuGoc
                .replacingOccurrences(of: "%", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: ",", with: ".")
            let soNhap = Double(chu) ?? 0
            let giaTri = (coDauPhanTram && self.dong.thucHien > 0)
                ? (((self.dong.thucHien / 100.0) * soNhap * 10000.0).rounded() / 10000.0)
                : soNhap
            let khoa = KhoDuLieu.chuanHoaKhoaSoSanh(self.dong.tenNganhHang)
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
            var bangNV = dl.thiDuaNhanVien(theo: self.cheDo)
            bangNV[khoa, default: [:]][item.maNV] = giaTri
            dl.ganThiDuaNhanVien(bangNV, theo: self.cheDo)
            KhoDuLieu.dungChung.luu(dl)
            self.napDuLieu()
            self.khiCapNhatDuLieu?()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(hop, animated: true)
    }

    // MARK: - Xuất ảnh Bảng xếp hạng nhân viên của ngành hàng

    @objc private func bamXuatAnhBangNganhHang() {
        guard !danhSachXepHang.isEmpty else { return }
        guard let anh = taoAnhBangNganhHang() else { return }
        let vc = UIActivityViewController(activityItems: [anh], applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.first
        }
        present(vc, animated: true)
    }

    private func taoAnhBangNganhHang() -> UIImage? {
        let soNV = danhSachXepHang.count
        guard soNV > 0 else { return nil }
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let targetMoiNV = dong.target / Double(soNV)
        let tongTH = danhSachXepHang.reduce(0.0) { $0 + $1.thucHien }
        let tyLeChung = dong.target > 0 ? Int(round(tongTH / dong.target * 100.0)) : 0

        let rong: CGFloat = 780
        let le: CGFloat = 22
        let fontTieuDe = UIFont.systemFont(ofSize: 18, weight: .heavy)
        let fontDong = UIFont.monospacedDigitSystemFont(ofSize: 12.5, weight: .bold)
        let fontTen = UIFont.systemFont(ofSize: 12.5, weight: .bold)

        let caoTenNganh = max(26, ceil((dong.tenNganhHang as NSString).boundingRect(
            with: CGSize(width: rong - le * 2 - 280, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTieuDe],
            context: nil
        ).height))
        let caoHeader: CGFloat = 30 + caoTenNganh + 12
        let caoTieuDeCot: CGFloat = 34
        let cacCaoDong: [CGFloat] = danhSachXepHang.map { item in
            let chuoiTen = "\(item.hoTen) - \(item.maNV)"
            let rect = (chuoiTen as NSString).boundingRect(
                with: CGSize(width: CGFloat(340), height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: fontTen],
                context: nil
            )
            return max(44, ceil(rect.height) + 22)
        }
        let tongCaoDong = cacCaoDong.reduce(0, +)
        let caoChan: CGFloat = 52
        let cao = le * 2 + caoHeader + caoTieuDeCot + tongCaoDong + caoChan

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = 2.0
        return UIGraphicsImageRenderer(size: CGSize(width: rong, height: cao), format: fmt).image { ctx in
            let cg = ctx.cgContext
            UIColor.white.setFill()
            cg.fill(CGRect(x: 0, y: 0, width: rong, height: cao))

            let pLeft = NSMutableParagraphStyle(); pLeft.alignment = .left; pLeft.lineBreakMode = .byWordWrapping
            let pRight = NSMutableParagraphStyle(); pRight.alignment = .right; pRight.lineBreakMode = .byWordWrapping
            let pCenter = NSMutableParagraphStyle(); pCenter.alignment = .center; pCenter.lineBreakMode = .byWordWrapping

            (cheDo.tieuDe.uppercased() as NSString).draw(at: CGPoint(x: le, y: le + 4), withAttributes: [
                .font: UIFont.systemFont(ofSize: 12.5, weight: .bold),
                .foregroundColor: UIColor.darkGray
            ])
            (dong.tenNganhHang as NSString).draw(in: CGRect(x: le, y: le + 24, width: rong - le * 2 - 280, height: caoTenNganh + 4), withAttributes: [
                .font: fontTieuDe,
                .foregroundColor: UIColor.black,
                .paragraphStyle: pLeft
            ])
            let subRight = "Ngày \(ngayStr) • Chia đều \(soNV) NV (\(targetMoiNV.chuoiSoGonVN)/NV)"
            (subRight as NSString).draw(in: CGRect(x: rong - le - 270, y: le + 18, width: 270, height: 42), withAttributes: [
                .font: UIFont.systemFont(ofSize: 12.5, weight: .semibold),
                .foregroundColor: UIColor.darkGray,
                .paragraphStyle: pRight
            ])

            var y = le + caoHeader
            let headerAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
                .foregroundColor: UIColor.gray
            ]
            ("#" as NSString).draw(at: CGPoint(x: le + 10, y: y + 8), withAttributes: headerAttr)
            ("NHÂN VIÊN" as NSString).draw(at: CGPoint(x: le + 46, y: y + 8), withAttributes: headerAttr)
            ("THỰC HIỆN" as NSString).draw(in: CGRect(x: rong - le - 300, y: y + 8, width: 110, height: 18), withAttributes: headerAttr.merging([.paragraphStyle: pRight]) { $1 })
            ("CÒN / VƯỢT" as NSString).draw(in: CGRect(x: rong - le - 180, y: y + 8, width: 96, height: 18), withAttributes: headerAttr.merging([.paragraphStyle: pRight]) { $1 })
            ("% HT" as NSString).draw(in: CGRect(x: rong - le - 68, y: y + 8, width: 62, height: 18), withAttributes: headerAttr.merging([.paragraphStyle: pCenter]) { $1 })

            y += caoTieuDeCot

            for (idx, item) in danhSachXepHang.enumerated() {
                let caoDong = cacCaoDong[idx]
                let hang = idx + 1
                let dat = item.daDat
                let kha = item.phanTramHT >= 80.0
                let bgTrack = dat ? UIColor(red: 0.94, green: 0.99, blue: 0.96, alpha: 1) : (kha ? UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1) : UIColor(red: 0.99, green: 0.99, blue: 0.91, alpha: 1))
                let bgFill = dat ? UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1) : (kha ? UIColor(red: 0.86, green: 0.92, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.94, blue: 0.54, alpha: 1))

                let rectRow = CGRect(x: le, y: y + 3, width: rong - le * 2, height: caoDong - 6)
                bgTrack.setFill()
                UIBezierPath(roundedRect: rectRow, cornerRadius: 8).fill()

                let pctW = CGFloat(min(1.0, max(0.03, item.phanTramHT / 100.0))) * rectRow.width
                bgFill.setFill()
                UIBezierPath(roundedRect: CGRect(x: le, y: y + 3, width: pctW, height: caoDong - 6), cornerRadius: 8).fill()

                let yGiua = y + (caoDong - 20) / 2
                (KhoDuLieu.huyChuongHang(hang) as NSString).draw(in: CGRect(x: le + 6, y: yGiua, width: 28, height: 22), withAttributes: [
                    .font: fontDong,
                    .foregroundColor: UIColor.darkGray,
                    .paragraphStyle: pCenter
                ])
                ("\(item.hoTen) - \(item.maNV)" as NSString).draw(in: CGRect(x: le + 46, y: y + 10, width: 340, height: caoDong - 20), withAttributes: [
                    .font: fontTen,
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: pLeft
                ])
                ("\(item.thucHien.chuoiSoGonVN) / \(item.targetCaNhan.chuoiSoGonVN)" as NSString).draw(in: CGRect(x: rong - le - 315, y: yGiua, width: 125, height: 22), withAttributes: [
                    .font: fontDong,
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: pRight
                ])
                let vuot = item.thucHien - item.targetCaNhan
                let strDiff = vuot >= -0.005 ? "Vượt +\(max(0, vuot).chuoiSoGonVN)" : "Còn \(abs(vuot).chuoiSoGonVN)"
                (strDiff as NSString).draw(in: CGRect(x: rong - le - 184, y: yGiua, width: 100, height: 22), withAttributes: [
                    .font: fontDong,
                    .foregroundColor: vuot >= -0.005 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : UIColor.darkGray,
                    .paragraphStyle: pRight
                ])

                let badgeRect = CGRect(x: rong - le - 68, y: y + (caoDong - 24) / 2, width: 62, height: 24)
                let badgeBg = dat ? UIColor(red: 0.86, green: 0.99, blue: 0.90, alpha: 1) : (kha ? UIColor(red: 0.86, green: 0.92, blue: 0.99, alpha: 1) : UIColor(red: 0.99, green: 0.95, blue: 0.78, alpha: 1))
                let badgeFg = dat ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : (kha ? UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1) : UIColor(red: 0.71, green: 0.33, blue: 0.04, alpha: 1))
                badgeBg.setFill()
                UIBezierPath(roundedRect: badgeRect, cornerRadius: 6).fill()
                ("\(Int(round(item.phanTramHT)))%" as NSString).draw(in: CGRect(x: badgeRect.minX, y: badgeRect.minY + 4, width: badgeRect.width, height: 18), withAttributes: [
                    .font: fontDong,
                    .foregroundColor: badgeFg,
                    .paragraphStyle: pCenter
                ])

                y += caoDong
            }

            UIColor.lightGray.setFill()
            cg.fill(CGRect(x: le, y: y + 8, width: rong - le * 2, height: 1))
            ("TỔNG CỘNG:  \(tongTH.chuoiSoGonVN) / \(dong.target.chuoiSoGonVN)   •   \(soNV) nhân viên" as NSString).draw(at: CGPoint(x: le, y: y + 20), withAttributes: [
                .font: UIFont.systemFont(ofSize: 13.5, weight: .heavy),
                .foregroundColor: UIColor.black
            ])
            ("Tỷ lệ HT: \(tyLeChung)%" as NSString).draw(in: CGRect(x: rong - le - 160, y: y + 20, width: 160, height: 22), withAttributes: [
                .font: UIFont.systemFont(ofSize: 13.5, weight: .heavy),
                .foregroundColor: UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1),
                .paragraphStyle: pRight
            ])
        }
    }
}

// MARK: - 2. BangNhanVienView (Tab Nhân viên trên màn hình chính: 2 nút nhập ảnh đã được gom lên cùng 1 hàng phía trên)

final class BangNhanVienView: UIView, UITableViewDataSource, UITableViewDelegate {
    var khiChonNhanVien: ((TongHopNhanVien) -> Void)?
    var khiBamQuetDoanhThuNV: (() -> Void)?
    var khiBamMoCaiDatNV: (() -> Void)?
    var khiBamChiaSeAnhNV: (() -> Void)?

    private static let khoaKieuSapXepNhanVien = "dmx.nhanVien.kieuSapXep"
    private var ngayHienTai = Date()
    private(set) var cheDoDoanhThu: LoaiCheDoDoanhThu = .luyKe
    private var kieuSapXep: KieuSapXepNhanVien = {
        if UserDefaults.standard.object(forKey: BangNhanVienView.khoaKieuSapXepNhanVien) != nil,
           let luu = KieuSapXepNhanVien(rawValue: UserDefaults.standard.integer(forKey: BangNhanVienView.khoaKieuSapXepNhanVien)) {
            return luu
        }
        return .doanhThuQD
    }()
    private var danhSach: [TongHopNhanVien] = []
    private var danhSachDaNapUI: [TongHopNhanVien]?
    private var cheDoDaNapUI: LoaiCheDoDoanhThu?
    private var khoaNgayDaNapUI: String = ""
    private var phienBanDaNapUI: Int = -1
    private var sapXepDaNapUI: KieuSapXepNhanVien?

    private var chieuRongCot: [CGFloat] {
        if cheDoDoanhThu == .realtime {
            return [44, 185, 84, 108, 108, 92]
        } else {
            return [44, 178, 78, 92, 84, 78, 96, 88, 88, 92]
        }
    }
    private var tongChieuRongBang: CGFloat { chieuRongCot.reduce(0, +) }
    private var rangBuocRongBang: NSLayoutConstraint?

    private let nhanTieuDe = UILabel()
    private let nutChiaSeAnh = UIButton(type: .system)
    private let nutSapXep = UIButton(type: .system)
    private let cuonNgang = UIScrollView()
    private let bang = UITableView(frame: .zero, style: .plain)
    private let khungTrong = UIControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func taoGiaoDien() {
        backgroundColor = .clear

        nhanTieuDe.font = .systemFont(ofSize: 12.5, weight: .bold)
        nhanTieuDe.textColor = BangMauBCTD.chuChinh
        nhanTieuDe.text = "🏆 Bảng Xếp Hạng Nhân Viên"
        nhanTieuDe.numberOfLines = 0
        nhanTieuDe.lineBreakMode = .byWordWrapping
        nhanTieuDe.adjustsFontSizeToFitWidth = false

        nutSapXep.setTitle(" ⇅ \(kieuSapXep.nhanNgan)", for: .normal)
        nutSapXep.titleLabel?.font = .systemFont(ofSize: 11.5, weight: .bold)
        nutSapXep.titleLabel?.numberOfLines = 0
        nutSapXep.titleLabel?.lineBreakMode = .byWordWrapping
        nutSapXep.titleLabel?.textAlignment = .center
        nutSapXep.titleLabel?.adjustsFontSizeToFitWidth = false
        nutSapXep.backgroundColor = BangMauBCTD.nenMenuToi
        nutSapXep.tintColor = BangMauBCTD.vangChuDao
        nutSapXep.setTitleColor(BangMauBCTD.vangChuDao, for: .normal)
        nutSapXep.layer.cornerRadius = 8
        nutSapXep.layer.borderWidth = 1
        nutSapXep.layer.borderColor = BangMauBCTD.vangChuDao.withAlphaComponent(0.5).cgColor
        nutSapXep.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutSapXep.setContentHuggingPriority(.required, for: .horizontal)
        nutSapXep.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutSapXep.addTarget(self, action: #selector(bamMoMenuSapXep), for: .touchUpInside)

        nhanTieuDe.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nhanTieuDe.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        nutChiaSeAnh.isHidden = true

        let thanhDieuKhien = UIStackView(arrangedSubviews: [nhanTieuDe, nutSapXep])
        thanhDieuKhien.axis = .horizontal
        thanhDieuKhien.spacing = 8
        thanhDieuKhien.alignment = .center

        cuonNgang.showsHorizontalScrollIndicator = true
        cuonNgang.showsVerticalScrollIndicator = false
        cuonNgang.bounces = false
        cuonNgang.layer.cornerRadius = 12
        cuonNgang.clipsToBounds = true
        cuonNgang.backgroundColor = .systemBackground

        bang.dataSource = self
        bang.delegate = self
        bang.rowHeight = 56
        bang.sectionHeaderHeight = 42
        bang.separatorStyle = .singleLine
        bang.separatorInset = .zero
        bang.backgroundColor = .systemBackground
        if #available(iOS 15.0, *) {
            bang.sectionHeaderTopPadding = 0
        }
        bang.translatesAutoresizingMaskIntoConstraints = false
        cuonNgang.addSubview(bang)

        khungTrong.backgroundColor = .secondarySystemGroupedBackground
        khungTrong.layer.cornerRadius = 14
        khungTrong.addTarget(self, action: #selector(bamMoCaiDat), for: .touchUpInside)

        let nhanTrong = UILabel()
        nhanTrong.text = "Chưa có nhân viên trong danh sách quản lý.\nChạm vào đây để thêm nhân viên."
        nhanTrong.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nhanTrong.textColor = .secondaryLabel
        nhanTrong.textAlignment = .center
        nhanTrong.numberOfLines = 0
        nhanTrong.lineBreakMode = .byWordWrapping
        nhanTrong.adjustsFontSizeToFitWidth = false
        nhanTrong.isUserInteractionEnabled = false
        nhanTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nhanTrong)

        [thanhDieuKhien, cuonNgang, khungTrong].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            thanhDieuKhien.topAnchor.constraint(equalTo: topAnchor),
            thanhDieuKhien.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thanhDieuKhien.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thanhDieuKhien.heightAnchor.constraint(greaterThanOrEqualToConstant: 32),

            cuonNgang.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 6),
            cuonNgang.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cuonNgang.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cuonNgang.bottomAnchor.constraint(equalTo: bottomAnchor),

            bang.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
            bang.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
            bang.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
            bang.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
            bang.heightAnchor.constraint(equalTo: cuonNgang.frameLayoutGuide.heightAnchor),

            khungTrong.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 6),
            khungTrong.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            khungTrong.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            khungTrong.bottomAnchor.constraint(equalTo: bottomAnchor),

            nhanTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nhanTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nhanTrong.leadingAnchor.constraint(equalTo: khungTrong.leadingAnchor, constant: 20),
            nhanTrong.trailingAnchor.constraint(equalTo: khungTrong.trailingAnchor, constant: -20)
        ])
        let rgRong = bang.widthAnchor.constraint(equalToConstant: tongChieuRongBang)
        rgRong.isActive = true
        rangBuocRongBang = rgRong
    }

    @objc private func bamMoMenuSapXep() {
        guard let vc = timViewControllerCha() else { return }
        var cacMuc: [MucChonDMX] = KieuSapXepNhanVien.allCases.map { kieu in
            MucChonDMX(tieuDe: kieu.nhan, dangChon: kieu == kieuSapXep) { [weak self] in
                guard let self = self else { return }
                self.kieuSapXep = kieu
                UserDefaults.standard.set(kieu.rawValue, forKey: Self.khoaKieuSapXepNhanVien)
                self.nutSapXep.setTitle(" ⇅ \(kieu.nhanNgan)", for: .normal)
                self.danhSachDaNapUI = nil
                self.capNhat(cho: self.ngayHienTai, cheDo: self.cheDoDoanhThu)
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        vc.hienMenuChon(tieuDe: "Sắp xếp nhân viên", cacMuc: cacMuc)
    }

    @objc private func bamMoCaiDat() {
        khiBamMoCaiDatNV?()
    }

    @objc private func bamChiaSeAnh() {
        khiBamChiaSeAnhNV?()
    }

    func capNhat(cho ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) {
        ngayHienTai = ngay
        cheDoDoanhThu = cheDo
        let kho = KhoDuLieu.dungChung
        let khoaNgay = TienIchNgay.khoa.string(from: ngay)
        if phienBanDaNapUI == kho.phienBanDuLieu,
           khoaNgayDaNapUI == khoaNgay,
           cheDoDaNapUI == cheDo,
           sapXepDaNapUI == kieuSapXep,
           danhSachDaNapUI != nil {
            return
        }
        phienBanDaNapUI = kho.phienBanDuLieu
        khoaNgayDaNapUI = khoaNgay
        cheDoDaNapUI = cheDo
        sapXepDaNapUI = kieuSapXep

        let moi = kho.tongHopNhanVien(den: ngay, sapXep: kieuSapXep, cheDo: cheDo)
        if cheDo == .realtime {
            nhanTieuDe.text = "⚡ Doanh Thu Nhân Viên Realtime (\(moi.count) NV)"
        } else {
            let soMonThang = kho.danhSachMatHangThang(den: ngay, cheDo: cheDo).count
            nhanTieuDe.text = "🏆 Xếp Hạng \(cheDo.tieuDe) (\(moi.count) NV • \(soMonThang) môn)"
        }
        rangBuocRongBang?.constant = tongChieuRongBang

        let trong = moi.isEmpty
        khungTrong.isHidden = !trong
        cuonNgang.isHidden = trong

        danhSach = moi
        danhSachDaNapUI = moi
        bang.reloadData()
    }

    func gan(_ moi: [TongHopNhanVien]) {
        danhSach = moi
        danhSachDaNapUI = moi
        let trong = danhSach.isEmpty
        khungTrong.isHidden = !trong
        cuonNgang.isHidden = trong
        bang.reloadData()
    }

    private func tinhChieuCaoDongNV(_ row: TongHopNhanVien) -> CGFloat {
        let rongTen = chieuRongCot[1] - 16
        let fontTen = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        let fontMa = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        let rectTen = (row.nhanVien.hoTen as NSString).boundingRect(
            with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTen],
            context: nil
        )
        let coGioCong = (cheDoDoanhThu == .luyKe) && (row.gioCongTaiST > 0.001 || row.gioCongHoTro > 0.001)
        let chuoiMa = coGioCong
            ? "id: \(row.nhanVien.maNV) • ⏱️ \(row.gioCongTaiST.chuoiSoMotLeVN)h (+\(row.gioCongHoTro.chuoiSoMotLeVN)h)"
            : "id: \(row.nhanVien.maNV)"
        let rectMa = (chuoiMa as NSString).boundingRect(
            with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontMa],
            context: nil
        )
        return max(56, ceil(rectTen.height) + ceil(rectMa.height) + 16)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        danhSach.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tinhChieuCaoDongNV(danhSach[indexPath.row])
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cacRong = chieuRongCot
        let rongBang = tongChieuRongBang
        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongBang, height: 42))
        khung.backgroundColor = BangMauBCTD.nenHeaderBang

        let laRT = (cheDoDoanhThu == .realtime)
        let tieuDe: [String] = laRT
            ? ["HẠNG", "NHÂN VIÊN", "SỐ LƯỢNG", "DOANH THU QĐ", "DT QĐ KHOẢN VAY", "% TỈ TRỌNG"]
            : ["HẠNG", "NHÂN VIÊN (CHẠM XEM SK)", "% TỈ TRỌNG", "DOANH THU QĐ", "% HT TB", "SỐ LƯỢNG", "SỐ MÔN ĐẠT", "GIỜ CÔNG TẠI ST", "GIỜ CÔNG HỖ TRỢ", "DT KHOẢN VAY"]

        var xHienTai: CGFloat = 0
        for (i, chu) in tieuDe.enumerated() {
            let w = cacRong[i]
            let nhan = UILabel(frame: CGRect(x: xHienTai + 4, y: 2, width: w - 8, height: 37))
            nhan.text = chu
            nhan.font = .systemFont(ofSize: 10.5, weight: .bold)
            nhan.textColor = (i == 3 || (!laRT && (i == 6 || i == 7 || i == 8))) ? BangMauBCTD.vangChuDao : .white
            nhan.numberOfLines = 0
            nhan.lineBreakMode = .byWordWrapping
            nhan.adjustsFontSizeToFitWidth = false
            if laRT {
                nhan.textAlignment = (i == 1) ? .left : (i == 0 ? .center : .right)
            } else {
                nhan.textAlignment = (i == 1) ? .left : ((i == 0 || i == 4 || i == 6) ? .center : .right)
            }
            khung.addSubview(nhan)

            xHienTai += w
            if i < tieuDe.count - 1 {
                let vach = UIView(frame: CGRect(x: xHienTai, y: 0, width: 0.5, height: 42))
                vach.backgroundColor = UIColor.white.withAlphaComponent(0.14)
                khung.addSubview(vach)
            }
        }
        let vachDuoi = UIView(frame: CGRect(x: 0, y: 39.5, width: rongBang, height: 2.5))
        vachDuoi.backgroundColor = BangMauBCTD.vangChuDao
        khung.addSubview(vachDuoi)
        return khung
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ma = "DongTongHopNV8Cot"
        let cell = tableView.dequeueReusableCell(withIdentifier: ma) ?? UITableViewCell(style: .default, reuseIdentifier: ma)
        cell.selectionStyle = .default
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let row = danhSach[indexPath.row]
        let caoDong = tinhChieuCaoDongNV(row)
        let hang = indexPath.row + 1
        let laTop3 = hang <= 3
        let cacRong = chieuRongCot
        let rongBang = tongChieuRongBang
        let laRT = (cheDoDoanhThu == .realtime)

        let khung = UIView(frame: CGRect(x: 0, y: 0, width: rongBang, height: caoDong))
        khung.backgroundColor = laTop3
            ? BangMauBCTD.xanhDatNenDong
            : ((indexPath.row % 2 == 1) ? BangMauBCTD.nenThePhu : BangMauBCTD.nenThe)
        let vachTrai = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: caoDong))
        vachTrai.backgroundColor = hang == 1
            ? BangMauBCTD.vangChuDao
            : (laTop3 ? BangMauBCTD.xanhDatVach : BangMauBCTD.indigoChuDao.withAlphaComponent(0.45))
        khung.addSubview(vachTrai)
        cell.contentView.addSubview(khung)

        let fontDongNhat = UIFont.monospacedDigitSystemFont(ofSize: 12.5, weight: .bold)
        let fontChuDongNhat = UIFont.systemFont(ofSize: 12.5, weight: .bold)

        var x: CGFloat = 0
        for i in 0..<cacRong.count {
            let w = cacRong[i]
            let rect = CGRect(x: x, y: 0, width: w, height: caoDong)

            if laRT {
                switch i {
                case 0: // HẠNG
                    let lb = UILabel(frame: rect)
                    lb.text = KhoDuLieu.huyChuongHang(hang)
                    lb.font = fontDongNhat
                    lb.textAlignment = .center
                    khung.addSubview(lb)
                case 1: // NHÂN VIÊN
                    let rongTen = w - 16
                    let rectTen = (row.nhanVien.hoTen as NSString).boundingRect(
                        with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                        attributes: [.font: fontChuDongNhat],
                        context: nil
                    )
                    let caoTen = max(20, ceil(rectTen.height))
                    let caoMa = max(18, caoDong - caoTen - 12)

                    let lbTen = UILabel(frame: CGRect(x: x + 8, y: 5, width: rongTen, height: caoTen))
                    lbTen.text = row.nhanVien.hoTen
                    lbTen.font = fontChuDongNhat
                    lbTen.numberOfLines = 0
                    lbTen.lineBreakMode = .byWordWrapping

                    let lbMa = UILabel(frame: CGRect(x: x + 8, y: 5 + caoTen + 2, width: rongTen, height: caoMa))
                    lbMa.text = "id: \(row.nhanVien.maNV)"
                    lbMa.font = .systemFont(ofSize: 12.0, weight: .medium)
                    lbMa.textColor = .secondaryLabel
                    khung.addSubview(lbTen)
                    khung.addSubview(lbMa)
                case 2: // SỐ LƯỢNG
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.soLuongDon.chuoiSoNguyenVN
                    lb.font = fontDongNhat
                    lb.textColor = row.soLuongDon < 0 ? .systemRed : BangMauBCTD.chuChinh
                    lb.textAlignment = .right
                    khung.addSubview(lb)
                case 3: // DOANH THU QĐ
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.doanhThuQD.chuoiSoLieu
                    lb.font = fontDongNhat
                    lb.textColor = row.doanhThuQD < 0 ? .systemRed : UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
                    lb.textAlignment = .right
                    khung.addSubview(lb)
                case 4: // DT QĐ KHOẢN VAY
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.dtQDKhoanVay > 0 ? row.dtQDKhoanVay.chuoiSoLieu : "0"
                    lb.font = fontDongNhat
                    lb.textColor = .secondaryLabel
                    lb.textAlignment = .right
                    khung.addSubview(lb)
                case 5: // % TỈ TRỌNG
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = String(format: "%.1f%%", row.phanTramTiTrong)
                    lb.font = fontDongNhat
                    lb.textColor = row.phanTramTiTrong < 0 ? .systemRed : BangMauBCTD.chuChinh
                    lb.textAlignment = .right
                    khung.addSubview(lb)
                default:
                    break
                }
            } else {
                switch i {
                case 0:
                    let lb = UILabel(frame: rect)
                    lb.text = KhoDuLieu.huyChuongHang(hang)
                    lb.font = fontDongNhat
                    lb.textAlignment = .center
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 1:
                    let rongTen = w - 16
                    let rectTen = (row.nhanVien.hoTen as NSString).boundingRect(
                        with: CGSize(width: rongTen, height: CGFloat.greatestFiniteMagnitude),
                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                        attributes: [.font: fontChuDongNhat],
                        context: nil
                    )
                    let caoTen = max(20, ceil(rectTen.height))
                    let caoMa = max(18, caoDong - caoTen - 12)

                    let lbTen = UILabel(frame: CGRect(x: x + 8, y: 5, width: rongTen, height: caoTen))
                    lbTen.text = row.nhanVien.hoTen
                    lbTen.font = fontChuDongNhat
                    lbTen.numberOfLines = 0
                    lbTen.lineBreakMode = .byWordWrapping
                    lbTen.adjustsFontSizeToFitWidth = false

                    let lbMa = UILabel(frame: CGRect(x: x + 8, y: 5 + caoTen + 2, width: rongTen, height: caoMa))
                    if row.gioCongTaiST > 0.001 || row.gioCongHoTro > 0.001 {
                        lbMa.text = "id: \(row.nhanVien.maNV) • ⏱️ \(row.gioCongTaiST.chuoiSoMotLeVN)h (+\(row.gioCongHoTro.chuoiSoMotLeVN)h)"
                    } else {
                        lbMa.text = "id: \(row.nhanVien.maNV)"
                    }
                    lbMa.font = .systemFont(ofSize: 11.5, weight: .medium)
                    lbMa.textColor = .secondaryLabel
                    lbMa.numberOfLines = 0
                    lbMa.lineBreakMode = .byWordWrapping
                    lbMa.adjustsFontSizeToFitWidth = false

                    khung.addSubview(lbTen)
                    khung.addSubview(lbMa)
                case 2:
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = String(format: "%.1f%%", row.phanTramTiTrong)
                    lb.font = fontDongNhat
                    lb.textColor = row.phanTramTiTrong < 0 ? .systemRed : BangMauBCTD.chuChinh
                    lb.textAlignment = .right
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 3:
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.doanhThuQD.chuoiSoLieu
                    lb.font = fontDongNhat
                    lb.textColor = row.doanhThuQD < 0 ? .systemRed : UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1)
                    lb.textAlignment = .right
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 4:
                    let lb = UILabel(frame: rect.insetBy(dx: 4, dy: 2))
                    lb.text = row.tongMonGiao > 0 ? String(format: "%.1f%%", row.phanTramHTTB) : "--"
                    lb.font = fontDongNhat
                    lb.textAlignment = .center
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 5:
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.soLuongDon.chuoiSoNguyenVN
                    lb.font = fontDongNhat
                    lb.textColor = row.soLuongDon < 0 ? .systemRed : .secondaryLabel
                    lb.textAlignment = .right
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 6:
                    let pill = UILabel(frame: rect.insetBy(dx: 5, dy: max(6, (caoDong - 34) / 2)))
                    pill.text = "🏆 \(row.soMonDat)/\(row.tongMonGiao) môn"
                    pill.font = fontChuDongNhat
                    pill.textAlignment = .center
                    pill.numberOfLines = 0
                    pill.lineBreakMode = .byWordWrapping
                    pill.adjustsFontSizeToFitWidth = false
                    pill.layer.cornerRadius = 8
                    pill.clipsToBounds = true
                    pill.backgroundColor = row.soMonDat > 0 ? UIColor.systemGreen.withAlphaComponent(0.16) : UIColor.systemRed.withAlphaComponent(0.14)
                    pill.textColor = row.soMonDat > 0 ? UIColor(red: 0.08, green: 0.50, blue: 0.24, alpha: 1) : UIColor(red: 0.78, green: 0.14, blue: 0.14, alpha: 1)
                    khung.addSubview(pill)
                case 7: // GIỜ CÔNG TẠI ST LÀM VIỆC
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.gioCongTaiST > 0.001 ? "\(row.gioCongTaiST.chuoiSoMotLeVN)h" : "0,0h"
                    lb.font = fontDongNhat
                    lb.textColor = row.gioCongTaiST > 0.001
                        ? UIColor(red: 0.05, green: 0.44, blue: 0.72, alpha: 1)
                        : .secondaryLabel
                    lb.textAlignment = .right
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 8: // GIỜ CÔNG HỖ TRỢ ST KHÁC
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.gioCongHoTro > 0.001 ? "\(row.gioCongHoTro.chuoiSoMotLeVN)h" : "0,0h"
                    lb.font = fontDongNhat
                    lb.textColor = row.gioCongHoTro > 0.001
                        ? UIColor(red: 0.56, green: 0.24, blue: 0.82, alpha: 1)
                        : .secondaryLabel
                    lb.textAlignment = .right
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                case 9: // DT KHOẢN VAY
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = row.dtQDKhoanVay > 0 ? row.dtQDKhoanVay.chuoiSoLieu : "0"
                    lb.font = fontDongNhat
                    lb.textColor = .secondaryLabel
                    lb.textAlignment = .right
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.adjustsFontSizeToFitWidth = false
                    khung.addSubview(lb)
                default:
                    break
                }
            }

            x += w
            if i < cacRong.count - 1 {
                let vach = UIView(frame: CGRect(x: x, y: 0, width: 0.5, height: caoDong))
                vach.backgroundColor = .separator
                khung.addSubview(vach)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < danhSach.count else { return }
        khiChonNhanVien?(danhSach[indexPath.row])
    }

    // MARK: - Xuất Ảnh Bảng Xếp Hạng Tổng Hợp Nhân Viên

    func taoAnhBaoCaoNhanVien(
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu? = nil,
        thongTinDonVi: String = "",
        capNhatLuc: String = ""
    ) -> UIImage? {
        let cheDoXuat = cheDo ?? cheDoDoanhThu
        let cheDoCu = self.cheDoDoanhThu
        self.cheDoDoanhThu = cheDoXuat
        defer { self.cheDoDoanhThu = cheDoCu }

        let ds = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: kieuSapXep, cheDo: cheDoXuat)
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let soMonThang = KhoDuLieu.dungChung.danhSachMatHangThang(den: ngay, cheDo: cheDoXuat).count

        let tongDTQD = ds.reduce(0.0) { $0 + $1.doanhThuQD }
        let tongDon = ds.reduce(0.0) { $0 + $1.soLuongDon }
        let tongVay = ds.reduce(0.0) { $0 + $1.dtQDKhoanVay }
        let tongGioCongST = ds.reduce(0.0) { $0 + $1.gioCongTaiST }
        let tongGioCongHT = ds.reduce(0.0) { $0 + $1.gioCongHoTro }
        let tbHT = ds.isEmpty ? 0.0 : (ds.reduce(0.0) { $0 + $1.phanTramHTTB } / Double(ds.count))

        let le: CGFloat = 18
        let rongBang = tongChieuRongBang
        let rongAnh = rongBang + le * 2

        let chuPhu = "\(cheDoXuat.tieuDe.uppercased())  •  Ngày \(ngayStr)\(capNhatLuc.isEmpty ? "" : "  •  Cập nhật: \(capNhatLuc)")"
        let fontPhu = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        let caoPhu = max(20, ceil((chuPhu as NSString).boundingRect(
            with: CGSize(width: rongBang, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontPhu],
            context: nil
        ).height))

        let chuChinh = (cheDoXuat == .realtime)
            ? "⚡ BẢNG DOANH THU NHÂN VIÊN - REALTIME (\(ds.count) NV)"
            : "🏆 BẢNG XẾP HẠNG NHÂN VIÊN - \(cheDoXuat.tieuDe.uppercased()) (\(ds.count) NV • \(soMonThang) MÔN)"
        let fontChinh = UIFont.systemFont(ofSize: 18.5, weight: .heavy)
        let caoChinh = max(28, ceil((chuChinh as NSString).boundingRect(
            with: CGSize(width: rongBang, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontChinh],
            context: nil
        ).height))

        let chuTomTat = (cheDoXuat == .realtime)
            ? "Tổng DT Quy đổi (Realtime): \(tongDTQD.chuoiSoGonVN)   •   Tổng số lượng: \(tongDon.chuoiSoNguyenVN)   •   DT QĐ Khoản vay: \(tongVay.chuoiSoGonVN)"
            : "Tổng DT Quy đổi (\(cheDoXuat.tieuDe)): \(tongDTQD.chuoiSoGonVN)   •   Tổng đơn: \(tongDon.chuoiSoNguyenVN)   •   Giờ công tại ST: \(tongGioCongST.chuoiSoMotLeVN)h (Hỗ trợ ST khác: \(tongGioCongHT.chuoiSoMotLeVN)h)   •   % HT TB: \(String(format: "%.1f%%", tbHT))"
        let fontTomTat = UIFont.systemFont(ofSize: 12.5, weight: .bold)
        let caoTextTomTat = max(24, ceil((chuTomTat as NSString).boundingRect(
            with: CGSize(width: rongBang - 24, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTomTat],
            context: nil
        ).height))
        let caoTomTat = caoTextTomTat + 14

        let caoHeader = caoPhu + 4 + caoChinh
        let caoTieuDeCot: CGFloat = 42
        let cacCaoDong: [CGFloat] = ds.isEmpty ? [56] : ds.map { tinhChieuCaoDongNV($0) }
        let tongCaoDong = cacCaoDong.reduce(0, +)
        let caoBang = caoTieuDeCot + tongCaoDong
        let caoAnh = le * 2 + caoHeader + 8 + caoTomTat + 10 + caoBang

        let khungBaoCao = UIView(frame: CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))
        khungBaoCao.backgroundColor = .white
        khungBaoCao.overrideUserInterfaceStyle = .light

        let lbPhu = UILabel(frame: CGRect(x: le, y: le, width: rongBang, height: caoPhu))
        lbPhu.text = chuPhu
        lbPhu.font = fontPhu
        lbPhu.textColor = .darkGray
        lbPhu.numberOfLines = 0
        lbPhu.lineBreakMode = .byWordWrapping
        lbPhu.adjustsFontSizeToFitWidth = false
        khungBaoCao.addSubview(lbPhu)

        let lbChinh = UILabel(frame: CGRect(x: le, y: le + caoPhu + 4, width: rongBang, height: caoChinh))
        lbChinh.text = chuChinh
        lbChinh.font = fontChinh
        lbChinh.textColor = .black
        lbChinh.numberOfLines = 0
        lbChinh.lineBreakMode = .byWordWrapping
        lbChinh.adjustsFontSizeToFitWidth = false
        khungBaoCao.addSubview(lbChinh)

        var y = le + caoHeader + 8

        let hopTomTat = UIView(frame: CGRect(x: le, y: y, width: rongBang, height: caoTomTat))
        hopTomTat.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        hopTomTat.layer.cornerRadius = 8
        let lbTomTat = UILabel(frame: CGRect(x: 12, y: 7, width: rongBang - 24, height: caoTextTomTat))
        lbTomTat.text = chuTomTat
        lbTomTat.font = fontTomTat
        lbTomTat.textColor = .systemBlue
        lbTomTat.numberOfLines = 0
        lbTomTat.lineBreakMode = .byWordWrapping
        lbTomTat.adjustsFontSizeToFitWidth = false
        hopTomTat.addSubview(lbTomTat)
        khungBaoCao.addSubview(hopTomTat)

        y += caoTomTat + 10

        let khungBang = UIView(frame: CGRect(x: le, y: y, width: rongBang, height: caoBang))
        khungBang.layer.borderWidth = 1
        khungBang.layer.borderColor = UIColor.systemGray4.cgColor
        khungBang.layer.cornerRadius = 8
        khungBang.clipsToBounds = true
        khungBaoCao.addSubview(khungBang)

        if let header = self.tableView(bang, viewForHeaderInSection: 0) {
            header.frame = CGRect(x: 0, y: 0, width: rongBang, height: caoTieuDeCot)
            khungBang.addSubview(header)
        }

        if ds.isEmpty {
            let lbTrong = UILabel(frame: CGRect(x: 0, y: caoTieuDeCot, width: rongBang, height: 56))
            lbTrong.text = "Chưa có dữ liệu nhân viên."
            lbTrong.font = .systemFont(ofSize: 12.5, weight: .medium)
            lbTrong.textColor = .gray
            lbTrong.textAlignment = .center
            lbTrong.numberOfLines = 0
            lbTrong.lineBreakMode = .byWordWrapping
            khungBang.addSubview(lbTrong)
        } else {
            let cu = self.danhSach
            self.danhSach = ds
            var yDong = caoTieuDeCot
            for i in 0..<ds.count {
                let caoDong = cacCaoDong[i]
                let cell = self.tableView(bang, cellForRowAt: IndexPath(row: i, section: 0))
                let vDong = cell.contentView
                vDong.frame = CGRect(x: 0, y: yDong, width: rongBang, height: caoDong)
                let vach = UIView(frame: CGRect(x: 0, y: caoDong - 0.5, width: rongBang, height: 0.5))
                vach.backgroundColor = .systemGray4
                vDong.addSubview(vach)
                khungBang.addSubview(vDong)
                yDong += caoDong
            }
            self.danhSach = cu
        }

        let anh = khungBaoCao.ketXuatAnhChuanSang(scale: 3.0)
        bang.reloadData()
        return anh
    }
}

// MARK: - 3. Bảng Thông Số Sức Khoẻ Nhân Viên (Chuẩn mẫu 27 điểm: Doanh thu, Năng suất, Hiệu quả khai thác, Thi đua, Đơn giá, Tỷ trọng ngành hàng & Doanh thu QĐ từng tháng)

final class VongTronDiemSucKhoeView: UIView {
    var diemDat: Int = 0 { didSet { setNeedsDisplay() } }
    var tongDiem: Int = 27 { didSet { setNeedsDisplay() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let canh = min(rect.width, rect.height)
        let doDay: CGFloat = 6.0
        let banKinh = (canh - doDay * 2) / 2.0
        let tam = CGPoint(x: rect.midX, y: rect.midY)

        // Vòng nền xám nhạt
        ctx.setLineWidth(doDay)
        ctx.setStrokeColor(UIColor(red: 0.88, green: 0.91, blue: 0.95, alpha: 1).cgColor)
        ctx.addArc(center: tam, radius: banKinh, startAngle: 0, endAngle: .pi * 2, clockwise: false)
        ctx.strokePath()

        // Cung tiến độ xanh dương
        let tyLe = CGFloat(min(1.0, max(0.0, Double(diemDat) / Double(max(1, tongDiem)))))
        if tyLe > 0.001 {
            let gocBatDau = -CGFloat.pi / 2.0
            let gocKetThuc = gocBatDau + tyLe * (.pi * 2.0)
            ctx.setLineWidth(doDay)
            ctx.setLineCap(.round)
            ctx.setStrokeColor(UIColor(red: 0.11, green: 0.36, blue: 0.91, alpha: 1).cgColor)
            ctx.addArc(center: tam, radius: banKinh, startAngle: gocBatDau, endAngle: gocKetThuc, clockwise: false)
            ctx.strokePath()
        }

        let pCenter = NSMutableParagraphStyle()
        pCenter.alignment = .center

        let chuDiem = "\(diemDat)" as NSString
        let fontDiem = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .heavy)
        let attrDiem: [NSAttributedString.Key: Any] = [
            .font: fontDiem,
            .foregroundColor: UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1),
            .paragraphStyle: pCenter
        ]
        let szDiem = chuDiem.size(withAttributes: attrDiem)

        let chuTong = "/\(tongDiem)" as NSString
        let fontTong = UIFont.monospacedDigitSystemFont(ofSize: 10.5, weight: .bold)
        let attrTong: [NSAttributedString.Key: Any] = [
            .font: fontTong,
            .foregroundColor: UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1),
            .paragraphStyle: pCenter
        ]
        let szTong = chuTong.size(withAttributes: attrTong)

        let tongCaoChu = szDiem.height + szTong.height - 2
        let yDau = tam.y - tongCaoChu / 2.0
        chuDiem.draw(in: CGRect(x: 0, y: yDau, width: rect.width, height: szDiem.height), withAttributes: attrDiem)
        chuTong.draw(in: CGRect(x: 0, y: yDau + szDiem.height - 2, width: rect.width, height: szTong.height), withAttributes: attrTong)
    }
}

final class TheChiSoSucKhoeView: UIControl {
    enum TrangThaiThe {
        case dat
        case chuaDat
        case chuaCoSo
    }

    private let vachTrai = UIView()
    private let nhanTieuDe = UILabel()
    private let nhanTB = UILabel()
    private let nhanPhu = UILabel()
    private let nhanGiaTri = UILabel()
    private var xuLyBam: (() -> Void)?

    init(
        tieuDe: String,
        giaTri: String,
        chuoiTB: String,
        chuoiPhu: String? = nil,
        trangThai: TrangThaiThe,
        khiBam: (() -> Void)? = nil
    ) {
        self.xuLyBam = khiBam
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.89, green: 0.92, blue: 0.96, alpha: 1).cgColor
        clipsToBounds = true

        switch trangThai {
        case .dat:
            vachTrai.backgroundColor = UIColor(red: 0.06, green: 0.65, blue: 0.38, alpha: 1) // #10A661
        case .chuaDat:
            vachTrai.backgroundColor = UIColor(red: 0.88, green: 0.18, blue: 0.18, alpha: 1) // #E02E2E
        case .chuaCoSo:
            vachTrai.backgroundColor = UIColor(red: 0.78, green: 0.82, blue: 0.88, alpha: 1) // #C7D1E0
        }
        vachTrai.isUserInteractionEnabled = false
        vachTrai.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vachTrai)

        nhanTieuDe.text = tieuDe.uppercased()
        nhanTieuDe.font = .systemFont(ofSize: 10.5, weight: .bold)
        nhanTieuDe.textColor = UIColor(red: 0.35, green: 0.42, blue: 0.52, alpha: 1)
        nhanTieuDe.numberOfLines = 2
        nhanTieuDe.lineBreakMode = .byWordWrapping
        nhanTieuDe.isUserInteractionEnabled = false

        nhanTB.font = .systemFont(ofSize: 10.0, weight: .bold)
        nhanTB.layer.cornerRadius = 5
        nhanTB.clipsToBounds = true
        nhanTB.textAlignment = .center
        nhanTB.numberOfLines = 1
        nhanTB.isUserInteractionEnabled = false
        switch trangThai {
        case .dat:
            nhanTB.text = " ↑ \(chuoiTB) "
            nhanTB.backgroundColor = UIColor(red: 0.84, green: 0.97, blue: 0.90, alpha: 1)
            nhanTB.textColor = UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1)
        case .chuaDat:
            nhanTB.text = " ↓ \(chuoiTB) "
            nhanTB.backgroundColor = UIColor(red: 0.99, green: 0.88, blue: 0.88, alpha: 1)
            nhanTB.textColor = UIColor(red: 0.74, green: 0.12, blue: 0.12, alpha: 1)
        case .chuaCoSo:
            nhanTB.text = " \(chuoiTB) "
            nhanTB.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1)
            nhanTB.textColor = UIColor(red: 0.42, green: 0.48, blue: 0.58, alpha: 1)
        }
        nhanTB.setContentHuggingPriority(.required, for: .horizontal)
        nhanTB.setContentCompressionResistancePriority(.required, for: .horizontal)

        nhanPhu.font = .systemFont(ofSize: 9.5, weight: .semibold)
        nhanPhu.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1)
        nhanPhu.textColor = UIColor(red: 0.38, green: 0.44, blue: 0.54, alpha: 1)
        nhanPhu.layer.cornerRadius = 5
        nhanPhu.clipsToBounds = true
        nhanPhu.textAlignment = .center
        nhanPhu.numberOfLines = 1
        nhanPhu.isUserInteractionEnabled = false
        if let phu = chuoiPhu, !phu.isEmpty {
            nhanPhu.text = " \(phu) "
            nhanPhu.isHidden = false
        } else {
            nhanPhu.isHidden = true
        }
        nhanPhu.setContentHuggingPriority(.required, for: .horizontal)

        nhanGiaTri.text = giaTri
        nhanGiaTri.font = .monospacedDigitSystemFont(ofSize: 17.5, weight: .heavy)
        nhanGiaTri.textColor = trangThai == .chuaCoSo
            ? UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1)
            : UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1)
        nhanGiaTri.textAlignment = .right
        nhanGiaTri.numberOfLines = 1
        nhanGiaTri.adjustsFontSizeToFitWidth = true
        nhanGiaTri.minimumScaleFactor = 0.75
        nhanGiaTri.isUserInteractionEnabled = false
        nhanGiaTri.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hangBadge = UIStackView(arrangedSubviews: [nhanTB, nhanPhu, UIView()])
        hangBadge.axis = .horizontal
        hangBadge.spacing = 4
        hangBadge.alignment = .center
        hangBadge.isUserInteractionEnabled = false

        let hangDuoi = UIStackView(arrangedSubviews: [hangBadge, nhanGiaTri])
        hangDuoi.axis = .horizontal
        hangDuoi.spacing = 6
        hangDuoi.alignment = .bottom
        hangDuoi.isUserInteractionEnabled = false

        let ngan = UIStackView(arrangedSubviews: [nhanTieuDe, hangDuoi])
        ngan.axis = .vertical
        ngan.spacing = 8
        ngan.distribution = .equalSpacing
        ngan.isUserInteractionEnabled = false
        ngan.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ngan)

        NSLayoutConstraint.activate([
            vachTrai.leadingAnchor.constraint(equalTo: leadingAnchor),
            vachTrai.topAnchor.constraint(equalTo: topAnchor),
            vachTrai.bottomAnchor.constraint(equalTo: bottomAnchor),
            vachTrai.widthAnchor.constraint(equalToConstant: 4.0),

            nhanTB.heightAnchor.constraint(equalToConstant: 20),
            nhanPhu.heightAnchor.constraint(equalToConstant: 20),

            ngan.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            ngan.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            ngan.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 9),
            ngan.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 66)
        ])

        if khiBam != nil {
            addTarget(self, action: #selector(bamThe), for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func bamThe() {
        xuLyBam?()
    }
}

final class ThanhHieuQuaKhaiThacView: UIControl {
    private var xuLyBam: (() -> Void)?

    init(tenMuc: String, giaTriPhanTram: Double?, mucTieuTB: Double = 50.0, khiBam: (() -> Void)? = nil) {
        self.xuLyBam = khiBam
        super.init(frame: .zero)
        backgroundColor = .clear

        let lbTen = UILabel()
        lbTen.text = tenMuc
        lbTen.font = .systemFont(ofSize: 11.5, weight: .semibold)
        lbTen.textColor = UIColor(red: 0.15, green: 0.20, blue: 0.28, alpha: 1)
        lbTen.isUserInteractionEnabled = false

        let lbGiaTri = UILabel()
        lbGiaTri.font = .monospacedDigitSystemFont(ofSize: 11.5, weight: .bold)
        lbGiaTri.textAlignment = .right
        lbGiaTri.isUserInteractionEnabled = false

        let khungThanh = UIView()
        khungThanh.isUserInteractionEnabled = false
        khungThanh.translatesAutoresizingMaskIntoConstraints = false

        let ranhNen = UIView()
        ranhNen.backgroundColor = UIColor(red: 0.86, green: 0.89, blue: 0.93, alpha: 1)
        ranhNen.layer.cornerRadius = 3
        ranhNen.clipsToBounds = true
        ranhNen.translatesAutoresizingMaskIntoConstraints = false
        khungThanh.addSubview(ranhNen)

        let thanhLap = UIView()
        thanhLap.layer.cornerRadius = 3
        thanhLap.translatesAutoresizingMaskIntoConstraints = false
        ranhNen.addSubview(thanhLap)

        // Vạch mốc giữa "| = 100% TB"
        let vachGiua = UIView()
        vachGiua.backgroundColor = UIColor(red: 0.25, green: 0.30, blue: 0.38, alpha: 1)
        vachGiua.layer.cornerRadius = 1
        vachGiua.translatesAutoresizingMaskIntoConstraints = false
        khungThanh.addSubview(vachGiua)

        let tyLeFill: CGFloat
        if let val = giaTriPhanTram {
            lbGiaTri.text = "\(Int(round(val)))%"
            let datTB = val >= mucTieuTB - 0.001
            lbGiaTri.textColor = datTB
                ? UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1)
                : UIColor(red: 0.76, green: 0.12, blue: 0.12, alpha: 1)
            thanhLap.backgroundColor = datTB
                ? UIColor(red: 0.06, green: 0.65, blue: 0.38, alpha: 1)
                : UIColor(red: 0.86, green: 0.16, blue: 0.16, alpha: 1)
            // Mốc giữa (0.5 chiều rộng thanh) tương ứng 100% TB
            let chuanTB = max(10.0, mucTieuTB)
            tyLeFill = CGFloat(min(1.0, max(0.0, (val / chuanTB) * 0.5)))
        } else {
            lbGiaTri.text = "--%"
            lbGiaTri.textColor = UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1)
            thanhLap.backgroundColor = .clear
            tyLeFill = 0
        }

        let hangChu = UIStackView(arrangedSubviews: [lbTen, lbGiaTri])
        hangChu.axis = .horizontal
        hangChu.distribution = .equalSpacing
        hangChu.isUserInteractionEnabled = false

        let ngan = UIStackView(arrangedSubviews: [hangChu, khungThanh])
        ngan.axis = .vertical
        ngan.spacing = 4
        ngan.isUserInteractionEnabled = false
        ngan.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            ngan.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            ngan.leadingAnchor.constraint(equalTo: leadingAnchor),
            ngan.trailingAnchor.constraint(equalTo: trailingAnchor),

            khungThanh.heightAnchor.constraint(equalToConstant: 12),
            ranhNen.leadingAnchor.constraint(equalTo: khungThanh.leadingAnchor),
            ranhNen.trailingAnchor.constraint(equalTo: khungThanh.trailingAnchor),
            ranhNen.centerYAnchor.constraint(equalTo: khungThanh.centerYAnchor),
            ranhNen.heightAnchor.constraint(equalToConstant: 6),

            thanhLap.leadingAnchor.constraint(equalTo: ranhNen.leadingAnchor),
            thanhLap.topAnchor.constraint(equalTo: ranhNen.topAnchor),
            thanhLap.bottomAnchor.constraint(equalTo: ranhNen.bottomAnchor),
            thanhLap.widthAnchor.constraint(equalTo: ranhNen.widthAnchor, multiplier: max(0.001, tyLeFill)),

            vachGiua.centerXAnchor.constraint(equalTo: khungThanh.centerXAnchor),
            vachGiua.centerYAnchor.constraint(equalTo: khungThanh.centerYAnchor),
            vachGiua.widthAnchor.constraint(equalToConstant: 2),
            vachGiua.heightAnchor.constraint(equalToConstant: 12)
        ])

        if khiBam != nil {
            addTarget(self, action: #selector(bamThanh), for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func bamThanh() {
        xuLyBam?()
    }
}

final class TheMiniMonThiDuaSKView: UIControl {
    private var xuLyBam: (() -> Void)?

    init(mon: MonThiDuaNhanVien, khiBam: (() -> Void)? = nil) {
        self.xuLyBam = khiBam
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.92, green: 0.94, blue: 0.97, alpha: 1).cgColor

        let pt = Int(round(mon.phanTramHT))
        let mauThanh: UIColor
        let mauChu: UIColor
        if mon.phanTramHT >= 99.995 {
            mauThanh = UIColor(red: 0.95, green: 0.65, blue: 0.05, alpha: 1) // Vàng cam / xanh đạt như ảnh mẫu
            mauChu = UIColor(red: 0.78, green: 0.48, blue: 0.03, alpha: 1)
        } else if mon.phanTramHT >= 80.0 {
            mauThanh = UIColor(red: 0.95, green: 0.65, blue: 0.05, alpha: 1)
            mauChu = UIColor(red: 0.78, green: 0.48, blue: 0.03, alpha: 1)
        } else {
            mauThanh = UIColor(red: 0.86, green: 0.16, blue: 0.16, alpha: 1)
            mauChu = UIColor(red: 0.76, green: 0.12, blue: 0.12, alpha: 1)
        }

        let lbTen = UILabel()
        lbTen.text = mon.tenNganhHang
        lbTen.font = .systemFont(ofSize: 10.5, weight: .bold)
        lbTen.textColor = UIColor(red: 0.12, green: 0.16, blue: 0.24, alpha: 1)
        lbTen.numberOfLines = 2
        lbTen.lineBreakMode = .byWordWrapping
        lbTen.isUserInteractionEnabled = false

        let lbPT = UILabel()
        lbPT.text = "\(pt)%"
        lbPT.font = .monospacedDigitSystemFont(ofSize: 10.5, weight: .heavy)
        lbPT.textColor = mauChu
        lbPT.textAlignment = .right
        lbPT.setContentHuggingPriority(.required, for: .horizontal)
        lbPT.setContentCompressionResistancePriority(.required, for: .horizontal)
        lbPT.isUserInteractionEnabled = false

        let hangTren = UIStackView(arrangedSubviews: [lbTen, lbPT])
        hangTren.axis = .horizontal
        hangTren.spacing = 4
        hangTren.alignment = .top
        hangTren.isUserInteractionEnabled = false

        let track = UIView()
        track.backgroundColor = UIColor(red: 0.88, green: 0.91, blue: 0.95, alpha: 1)
        track.layer.cornerRadius = 2.5
        track.clipsToBounds = true
        track.isUserInteractionEnabled = false
        track.translatesAutoresizingMaskIntoConstraints = false

        let fill = UIView()
        fill.backgroundColor = mauThanh
        fill.layer.cornerRadius = 2.5
        fill.translatesAutoresizingMaskIntoConstraints = false
        track.addSubview(fill)

        let tyLe = CGFloat(min(1.0, max(0.04, mon.phanTramHT / 100.0)))

        let ngan = UIStackView(arrangedSubviews: [hangTren, track])
        ngan.axis = .vertical
        ngan.spacing = 6
        ngan.distribution = .equalSpacing
        ngan.isUserInteractionEnabled = false
        ngan.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            ngan.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            ngan.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            ngan.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            track.heightAnchor.constraint(equalToConstant: 5),
            fill.leadingAnchor.constraint(equalTo: track.leadingAnchor),
            fill.topAnchor.constraint(equalTo: track.topAnchor),
            fill.bottomAnchor.constraint(equalTo: track.bottomAnchor),
            fill.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: tyLe),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 46)
        ])

        if khiBam != nil {
            addTarget(self, action: #selector(bamThe), for: .touchUpInside)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func bamThe() {
        xuLyBam?()
    }
}

final class BieuDoTronTyTrongNganhHangView: UIView {
    var cacPhan: [(mau: UIColor, tyLe: Double)] = [] {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let canh = min(rect.width, rect.height)
        let doDay: CGFloat = max(14, canh * 0.22)
        let banKinh = (canh - doDay - 4) / 2.0
        let tam = CGPoint(x: rect.midX, y: rect.midY)

        let tong = cacPhan.reduce(0.0) { $0 + max(0, $1.tyLe) }
        if tong <= 0.001 {
            // Khung chờ bổ sung dữ liệu: vẽ vòng tròn mẫu phân 8 cung nhẹ nhàng
            let mauMacDinh: [(UIColor, Double)] = [
                (UIColor(red: 0.21, green: 0.49, blue: 0.85, alpha: 0.85), 55),
                (UIColor(red: 0.53, green: 0.31, blue: 0.82, alpha: 0.85), 14),
                (UIColor(red: 0.14, green: 0.62, blue: 0.35, alpha: 0.85), 11),
                (UIColor(red: 0.89, green: 0.56, blue: 0.13, alpha: 0.85), 8),
                (UIColor(red: 0.84, green: 0.20, blue: 0.24, alpha: 0.85), 5),
                (UIColor(red: 0.12, green: 0.63, blue: 0.64, alpha: 0.85), 3),
                (UIColor(red: 0.33, green: 0.38, blue: 0.45, alpha: 0.85), 2),
                (UIColor(red: 0.65, green: 0.70, blue: 0.77, alpha: 0.85), 2)
            ]
            var goc = -CGFloat.pi / 2.0
            for (mau, pt) in mauMacDinh {
                let quet = CGFloat(pt / 100.0) * (.pi * 2.0)
                ctx.setLineWidth(doDay)
                ctx.setStrokeColor(mau.cgColor)
                ctx.addArc(center: tam, radius: banKinh, startAngle: goc, endAngle: goc + quet, clockwise: false)
                ctx.strokePath()
                goc += quet
            }
            return
        }

        var goc = -CGFloat.pi / 2.0
        for phan in cacPhan where phan.tyLe > 0 {
            let quet = CGFloat(phan.tyLe / tong) * (.pi * 2.0)
            ctx.setLineWidth(doDay)
            ctx.setStrokeColor(phan.mau.cgColor)
            ctx.addArc(center: tam, radius: banKinh, startAngle: goc, endAngle: goc + quet, clockwise: false)
            ctx.strokePath()
            goc += quet
        }
    }
}

final class BieuDoCotDoanhThuThangNVView: UIView {
    var duLieuThang: [(nhan: String, giaTri: Double?)] = [] {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext(), !duLieuThang.isEmpty else { return }
        let soCot = duLieuThang.count
        let leTraiPhai: CGFloat = 8
        let yDinhSo: CGFloat = 6
        let yChanCot: CGFloat = rect.height - 24
        let caoToiDaCot = max(30, yChanCot - yDinhSo - 20)

        let maxVal = max(100.0, duLieuThang.compactMap(\.giaTri).max() ?? 500.0)
        let buocX = (rect.width - leTraiPhai * 2) / CGFloat(max(1, soCot))
        let rongCot = min(38, buocX * 0.58)

        let pCenter = NSMutableParagraphStyle()
        pCenter.alignment = .center

        let fontSo = UIFont.monospacedDigitSystemFont(ofSize: 9.5, weight: .bold)
        let fontThang = UIFont.monospacedDigitSystemFont(ofSize: 9.5, weight: .medium)

        for (i, muc) in duLieuThang.enumerated() {
            let tamX = leTraiPhai + buocX * (CGFloat(i) + 0.5)
            let xCot = tamX - rongCot / 2.0

            if let val = muc.giaTri, val > 0 {
                let tyLe = CGFloat(min(1.0, max(0.08, val / maxVal)))
                let caoCot = caoToiDaCot * tyLe
                let yCot = yChanCot - caoCot
                let rectCot = CGRect(x: xCot, y: yCot, width: rongCot, height: caoCot)
                UIColor(red: 0.08, green: 0.37, blue: 0.94, alpha: 1).setFill()
                UIBezierPath(roundedRect: rectCot, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5)).fill()

                let chuSo = String(format: "%.1f", val) as NSString
                chuSo.draw(
                    in: CGRect(x: tamX - buocX / 2.0, y: yDinSo(yCot: yCot), width: buocX, height: 15),
                    withAttributes: [
                        .font: fontSo,
                        .foregroundColor: UIColor(red: 0.18, green: 0.24, blue: 0.34, alpha: 1),
                        .paragraphStyle: pCenter
                    ]
                )
            } else {
                // Khung cột chờ bổ sung dữ liệu cho các tháng trước
                let caoKhung: CGFloat = 18
                let rectKhung = CGRect(x: xCot, y: yChanCot - caoKhung, width: rongCot, height: caoKhung)
                UIColor(red: 0.85, green: 0.89, blue: 0.95, alpha: 1).setFill()
                UIBezierPath(roundedRect: rectKhung, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4, height: 4)).fill()

                ("--" as NSString).draw(
                    in: CGRect(x: tamX - buocX / 2.0, y: yChanCot - caoKhung - 15, width: buocX, height: 14),
                    withAttributes: [
                        .font: fontSo,
                        .foregroundColor: UIColor(red: 0.52, green: 0.58, blue: 0.68, alpha: 1),
                        .paragraphStyle: pCenter
                    ]
                )
            }

            (muc.nhan as NSString).draw(
                in: CGRect(x: tamX - buocX / 2.0, y: yChanCot + 5, width: buocX, height: 16),
                withAttributes: [
                    .font: fontThang,
                    .foregroundColor: UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1),
                    .paragraphStyle: pCenter
                ]
            )
        }

        // Đường kẻ chân biểu đồ
        ctx.setStrokeColor(UIColor(red: 0.84, green: 0.88, blue: 0.94, alpha: 1).cgColor)
        ctx.setLineWidth(1)
        ctx.move(to: CGPoint(x: leTraiPhai, y: yChanCot))
        ctx.addLine(to: CGPoint(x: rect.width - leTraiPhai, y: yChanCot))
        ctx.strokePath()
    }

    private func yDinSo(yCot: CGFloat) -> CGFloat {
        max(2, yCot - 16)
    }
}

/// Thẻ KPI Gradient gọn gàng dùng cho Bảng Sức Khỏe Chi Tiết Nhân Viên (không bao giờ bị cắt chữ trên cả màn hình nhỏ lẫn khi xuất ảnh)
private final class TheKPISucKhoeGonView: UIView {
    private let lopGradient = CAGradientLayer()
    private let nenDauThe = UIView()
    private let vachTrai = UIView()
    private let lbTieuDe = UILabel()
    private let lbGiaTri = UILabel()
    private let vachKe = UIView()
    private let lbPhuDe = UILabel()

    override var frame: CGRect {
        didSet { capNhatBoCuc() }
    }

    override var bounds: CGRect {
        didSet { capNhatBoCuc() }
    }

    init(
        tieuDe: String,
        giaTri: String,
        phuDe: String,
        mauBatDau: UIColor,
        mauKetThuc: UIColor,
        laXuatAnh: Bool
    ) {
        super.init(frame: .zero)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = mauBatDau.withAlphaComponent(0.55).cgColor
        clipsToBounds = true

        lopGradient.colors = [mauBatDau.cgColor, mauKetThuc.cgColor]
        lopGradient.startPoint = CGPoint(x: 0, y: 0)
        lopGradient.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(lopGradient, at: 0)

        nenDauThe.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        vachTrai.backgroundColor = UIColor.white.withAlphaComponent(0.72)
        vachKe.backgroundColor = UIColor.white.withAlphaComponent(0.26)

        lbTieuDe.text = tieuDe
        lbTieuDe.font = .systemFont(ofSize: laXuatAnh ? 11.5 : 9.2, weight: .bold)
        lbTieuDe.textColor = UIColor.white.withAlphaComponent(0.96)
        lbTieuDe.textAlignment = .center
        lbTieuDe.numberOfLines = 1
        lbTieuDe.adjustsFontSizeToFitWidth = true
        lbTieuDe.minimumScaleFactor = 0.62

        lbGiaTri.text = giaTri
        lbGiaTri.font = .systemFont(ofSize: laXuatAnh ? 22.0 : 16.5, weight: .heavy)
        lbGiaTri.textColor = .white
        lbGiaTri.textAlignment = .center
        lbGiaTri.numberOfLines = 1
        lbGiaTri.adjustsFontSizeToFitWidth = true
        lbGiaTri.minimumScaleFactor = 0.68

        lbPhuDe.text = phuDe
        lbPhuDe.font = .systemFont(ofSize: laXuatAnh ? 10.5 : 8.5, weight: .bold)
        lbPhuDe.textColor = UIColor.white.withAlphaComponent(0.92)
        lbPhuDe.textAlignment = .center
        lbPhuDe.numberOfLines = 1
        lbPhuDe.adjustsFontSizeToFitWidth = true
        lbPhuDe.minimumScaleFactor = 0.62

        [nenDauThe, vachTrai, lbTieuDe, lbGiaTri, vachKe, lbPhuDe].forEach {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        capNhatBoCuc()
    }

    private func capNhatBoCuc() {
        let w = bounds.width
        let h = bounds.height
        guard w > 10, h > 10 else { return }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        lopGradient.frame = bounds
        CATransaction.commit()

        let yTieuDe: CGFloat = 3
        let caoTieuDe = round(h * 0.27)
        let yGiaTri = yTieuDe + caoTieuDe
        let caoGiaTri = round(h * 0.38)
        let yVach = yGiaTri + caoGiaTri + 1
        let yPhu = yVach + 2
        let caoPhu = max(12, h - yPhu - 3)

        vachTrai.frame = CGRect(x: 0, y: 0, width: 3.5, height: h)
        nenDauThe.frame = CGRect(x: 3.5, y: 0, width: max(4, w - 3.5), height: yGiaTri)
        lbTieuDe.frame = CGRect(x: 5, y: yTieuDe, width: max(8, w - 8), height: caoTieuDe)
        lbGiaTri.frame = CGRect(x: 5, y: yGiaTri, width: max(8, w - 8), height: caoGiaTri)
        vachKe.frame = CGRect(x: 6, y: yVach, width: max(8, w - 10), height: 1)
        lbPhuDe.frame = CGRect(x: 5, y: yPhu, width: max(8, w - 8), height: caoPhu)
    }
}

/// Giao diện Bảng Sức Khỏe Chi Tiết Nhân Viên gọn gàng, hiện đại (chuẩn bố cục 4 thẻ KPI màu + Tiến độ tháng + Bảng chi tiết các môn thi đua)
final class BangThongSoSucKhoeNhanVienView: UIView {
    var khiYeuCauCapNhat: (() -> Void)?

    private var tongHop: TongHopNhanVien
    private var ngay: Date
    private var cheDo: LoaiCheDoDoanhThu
    private let laCheDoXuatAnhRong: Bool
    private let nganChinh = UIStackView()

    // Bộ lọc & sắp xếp nhanh khi xem trực tiếp trên ứng dụng
    private var boLocMon: Int = 0 // 0: Tất cả, 1: Đạt, 2: Gần đạt (>=70%), 3: Chưa đạt
    private var kieuSapXepMon: Int = 0 // 0: Mặc định, 1: % HT Cao -> Thấp, 2: % HT Thấp -> Cao
    private var chieuCaoBangMonHienTai: CGFloat = 0

    private var chieuRongCot: [CGFloat] {
        if laCheDoXuatAnhRong {
            return [36, 232, 86, 86, 84, 78, 88, 106] // Tổng = 796pt (khung 820pt)
        } else {
            return [28, 150, 62, 62, 68, 60, 64, 80]  // Tổng = 574pt (hiển thị ngay tới cột % HT trên màn hình ĐT)
        }
    }
    private var tongChieuRongBang: CGFloat { chieuRongCot.reduce(0, +) }

    init(
        tongHop: TongHopNhanVien,
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu = .luyKe,
        laCheDoXuatAnhRong: Bool = false
    ) {
        self.tongHop = tongHop
        self.ngay = ngay
        self.cheDo = cheDo
        self.laCheDoXuatAnhRong = laCheDoXuatAnhRong
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = laCheDoXuatAnhRong ? 0 : 12
        nganChinh.axis = .vertical
        nganChinh.spacing = 10
        nganChinh.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nganChinh)
        let le: CGFloat = laCheDoXuatAnhRong ? 12 : 10
        NSLayoutConstraint.activate([
            nganChinh.topAnchor.constraint(equalTo: topAnchor, constant: le),
            nganChinh.leadingAnchor.constraint(equalTo: leadingAnchor, constant: le),
            nganChinh.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -le),
            nganChinh.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -le)
        ])
        dungGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func capNhat(tongHop: TongHopNhanVien, ngay: Date, cheDo: LoaiCheDoDoanhThu) {
        self.tongHop = tongHop
        self.ngay = ngay
        self.cheDo = cheDo
        dungGiaoDien()
    }

    private func danhSachMonHienThi() -> [MonThiDuaNhanVien] {
        var ds = tongHop.cacMonGiao
        if !laCheDoXuatAnhRong {
            switch boLocMon {
            case 1: ds = ds.filter(\.daDat)
            case 2: ds = ds.filter { !$0.daDat && $0.phanTramHT >= 70.0 }
            case 3: ds = ds.filter { !$0.daDat }
            default: break
            }
            switch kieuSapXepMon {
            case 1:
                ds.sort {
                    if abs($0.phanTramHT - $1.phanTramHT) > 0.01 { return $0.phanTramHT > $1.phanTramHT }
                    return $0.tenNganhHang < $1.tenNganhHang
                }
            case 2:
                ds.sort {
                    if abs($0.phanTramHT - $1.phanTramHT) > 0.01 { return $0.phanTramHT < $1.phanTramHT }
                    return $0.tenNganhHang < $1.tenNganhHang
                }
            default:
                break
            }
        }
        return ds
    }

    private func dungGiaoDien() {
        nganChinh.arrangedSubviews.forEach {
            nganChinh.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let kho = KhoDuLieu.dungChung
        let dl = kho.duLieu(cho: ngay)
        let dtST = (cheDo == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        let dsTatCaNV = kho.tongHopNhanVien(den: ngay, sapXep: .doanhThuQD, cheDo: cheDo)
        let soNVQuanLy = max(1, dsTatCaNV.count)
        let hangNV = (dsTatCaNV.firstIndex(where: { $0.nhanVien.maNV == tongHop.nhanVien.maNV }) ?? 0) + 1

        let lich = TienIchNgay.lich
        let soNgayQua = dtST.soNgayDaQua > 0 ? dtST.soNgayDaQua : max(1, lich.component(.day, from: ngay))
        let tongNgayThang = dtST.tongSoNgay > 0 ? dtST.tongSoNgay : (lich.range(of: .day, in: .month, for: ngay)?.count ?? 30)
        let ptTienDo = dtST.phanTramTienDoThang > 0
            ? dtST.phanTramTienDoThang
            : (Double(soNgayQua) / Double(max(1, tongNgayThang)) * 100.0)

        let donVi = dl.thongTinDonVi.isEmpty
            ? (DichVuDongBo.dungChung.sieuThiDangChon.map { "ĐMX \($0.tenSieuThi.uppercased())" } ?? "ĐIỆN MÁY XANH")
            : dl.thongTinDonVi.uppercased()
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)

        // ==================== 1. HEADER GỌN GÀNG & THANH TIẾN ĐỘ THÁNG ====================
        let lbPhu = UILabel()
        lbPhu.text = "\(donVi)  •  Mã NV: \(tongHop.nhanVien.maNV)  •  Ngày \(ngayStr)"
        lbPhu.font = .systemFont(ofSize: 11.5, weight: .bold)
        lbPhu.textColor = UIColor(red: 0.40, green: 0.46, blue: 0.55, alpha: 1)
        lbPhu.numberOfLines = 0

        let lbHangBadge = UILabel()
        lbHangBadge.text = " 🏆 Hạng \(hangNV)/\(soNVQuanLy) • \(cheDo.tieuDe) "
        lbHangBadge.font = .systemFont(ofSize: 11.0, weight: .heavy)
        lbHangBadge.textColor = BangMauBCTD.xanhChuDaoDam
        lbHangBadge.backgroundColor = UIColor(red: 0.91, green: 0.95, blue: 1.0, alpha: 1)
        lbHangBadge.layer.cornerRadius = 6
        lbHangBadge.clipsToBounds = true
        lbHangBadge.setContentHuggingPriority(.required, for: .horizontal)
        lbHangBadge.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hangPhu = UIStackView(arrangedSubviews: [lbPhu, UIView(), lbHangBadge])
        hangPhu.axis = .horizontal
        hangPhu.spacing = 6
        hangPhu.alignment = .center

        let lbChinh = UILabel()
        lbChinh.text = "SỨC KHỎE CHI TIẾT: \(tongHop.nhanVien.hoTen.uppercased())"
        lbChinh.font = .systemFont(ofSize: laCheDoXuatAnhRong ? 19.0 : 16.5, weight: .heavy)
        lbChinh.textColor = UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1)
        lbChinh.numberOfLines = 0

        let nganTieuDe = UIStackView(arrangedSubviews: [hangPhu, lbChinh])
        nganTieuDe.axis = .vertical
        nganTieuDe.spacing = 3
        nganChinh.addArrangedSubview(nganTieuDe)

        // Thanh tiến độ tháng chuẩn mẫu
        let khungTienDo = UIView()
        khungTienDo.backgroundColor = .white
        khungTienDo.layer.cornerRadius = 10
        khungTienDo.layer.borderWidth = 1
        khungTienDo.layer.borderColor = UIColor(red: 0.86, green: 0.89, blue: 0.94, alpha: 1).cgColor

        let lbTDTrai = UILabel()
        let attrTD = NSMutableAttributedString(
            string: "Tiến độ tháng   ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
                .foregroundColor: UIColor(red: 0.35, green: 0.42, blue: 0.52, alpha: 1)
            ]
        )
        attrTD.append(NSAttributedString(
            string: "Ngày \(soNgayQua) / \(tongNgayThang)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12.0, weight: .heavy),
                .foregroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1)
            ]
        ))
        lbTDTrai.attributedText = attrTD

        let lbTDPhai = UILabel()
        lbTDPhai.text = String(format: "%.1f%%", ptTienDo)
        lbTDPhai.font = .monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy)
        lbTDPhai.textColor = UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1)
        lbTDPhai.textAlignment = .right

        let trackTD = UIView()
        trackTD.backgroundColor = UIColor(red: 0.91, green: 0.93, blue: 0.97, alpha: 1)
        trackTD.layer.cornerRadius = 3
        trackTD.clipsToBounds = true
        trackTD.translatesAutoresizingMaskIntoConstraints = false

        let fillTD = UIView()
        fillTD.backgroundColor = UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1)
        fillTD.layer.cornerRadius = 3
        fillTD.translatesAutoresizingMaskIntoConstraints = false
        trackTD.addSubview(fillTD)

        let tyLeTD = CGFloat(min(1.0, max(0.02, ptTienDo / 100.0)))
        let hangChuTD = UIStackView(arrangedSubviews: [lbTDTrai, UIView(), lbTDPhai])
        hangChuTD.axis = .horizontal
        hangChuTD.alignment = .center

        let nganTD = UIStackView(arrangedSubviews: [hangChuTD, trackTD])
        nganTD.axis = .vertical
        nganTD.spacing = 6
        nganTD.translatesAutoresizingMaskIntoConstraints = false
        khungTienDo.addSubview(nganTD)

        NSLayoutConstraint.activate([
            nganTD.topAnchor.constraint(equalTo: khungTienDo.topAnchor, constant: 8),
            nganTD.bottomAnchor.constraint(equalTo: khungTienDo.bottomAnchor, constant: -8),
            nganTD.leadingAnchor.constraint(equalTo: khungTienDo.leadingAnchor, constant: 12),
            nganTD.trailingAnchor.constraint(equalTo: khungTienDo.trailingAnchor, constant: -12),
            trackTD.heightAnchor.constraint(equalToConstant: 6),
            fillTD.leadingAnchor.constraint(equalTo: trackTD.leadingAnchor),
            fillTD.topAnchor.constraint(equalTo: trackTD.topAnchor),
            fillTD.bottomAnchor.constraint(equalTo: trackTD.bottomAnchor),
            fillTD.widthAnchor.constraint(equalTo: trackTD.widthAnchor, multiplier: tyLeTD)
        ])
        nganChinh.addArrangedSubview(khungTienDo)

        // ==================== 1B. KHỐI DOANH THU Ở ĐẦU (ĐỦ 6 MỤC DƯỚI TÊN NHÂN VIÊN) ====================
        let skNV: DuLieuSucKhoeBoSungNV? = (cheDo == .luyKe)
            ? (dl.sucKhoeBoSungNhanVien[tongHop.nhanVien.maNV] ?? kho.sucKhoeBoSungNhanVienThang(cho: ngay)[tongHop.nhanVien.maNV])
            : nil

        let khungDoanhThu6Muc = taoKhungDoanhThu6Muc(sk: skNV, dsTatCaNV: dsTatCaNV)
        nganChinh.addArrangedSubview(khungDoanhThu6Muc)

        // ==================== 1B-2. KHỐI GIỜ CÔNG LŨY KẾ (2 MỤC: GIỜ CÔNG TẠI ST LÀM VIỆC & GIỜ CÔNG HỖ TRỢ ST KHÁC) ====================
        if cheDo == .luyKe || tongHop.gioCongTaiST > 0.001 || tongHop.gioCongHoTro > 0.001 {
            let khungGioCong2Muc = taoKhungGioCong2Muc(sk: skNV, dsTatCaNV: dsTatCaNV)
            nganChinh.addArrangedSubview(khungGioCong2Muc)
        }

        // ==================== 1C. KHỐI NĂNG SUẤT (3 MỤC · CÓ TÙY CHỌN HIỂN THỊ HOẶC ĐỂ DẤU *) ====================
        let khungNangSuat3Muc = taoKhungNangSuat3Muc(sk: skNV)
        nganChinh.addArrangedSubview(khungNangSuat3Muc)

        // ==================== 2. TỔNG HỢP NHANH KẾT QUẢ THI ĐUA CÁ NHÂN ====================
        let tongMon = tongHop.tongMonGiao
        let soMonDat = tongHop.soMonDat
        let soMonGanDat = tongHop.cacMonGiao.filter { !$0.daDat && $0.phanTramHT >= 70.0 }.count
        let soMonChua = max(0, tongMon - soMonDat - soMonGanDat)
        let tyLeMon = tongMon > 0 ? Int(round(Double(soMonDat) / Double(tongMon) * 100.0)) : 0

        let the2 = taoTheKPISucKhoe(
            tieuDe: "🏆 MÔN THI ĐUA HOÀN THÀNH",
            giaTri: "\(soMonDat)/\(tongMon)",
            phuDe: "HOÀN THÀNH: \(tyLeMon)% SỐ MÔN",
            mauBatDau: UIColor(red: 0.95, green: 0.56, blue: 0.05, alpha: 1),
            mauKetThuc: UIColor(red: 0.86, green: 0.44, blue: 0.02, alpha: 1)
        )
        let the4 = taoTheKPISucKhoe(
            tieuDe: "📈 % HT THI ĐUA TRUNG BÌNH",
            giaTri: tongHop.phanTramHTTB.chuoiPhanTramVN,
            phuDe: "ĐẠT \(soMonDat) • GẦN ĐẠT \(soMonGanDat) • CHƯA \(soMonChua)",
            mauBatDau: UIColor(red: 0.55, green: 0.31, blue: 0.95, alpha: 1),
            mauKetThuc: UIColor(red: 0.45, green: 0.22, blue: 0.88, alpha: 1)
        )

        let hangThe = UIStackView(arrangedSubviews: [the2, the4])
        hangThe.axis = .horizontal
        hangThe.spacing = laCheDoXuatAnhRong ? 8 : 6
        hangThe.distribution = .fillEqually
        hangThe.heightAnchor.constraint(equalToConstant: laCheDoXuatAnhRong ? 76 : 68).isActive = true
        nganChinh.addArrangedSubview(hangThe)

        // ==================== 3. THANH LỌC & SẮP XẾP NHANH (CHỈ HIỆN TRÊN APP) ====================
        if !laCheDoXuatAnhRong {
            let chonLoc = UISegmentedControl(items: [
                "Tất cả (\(tongMon))",
                "Đạt (\(soMonDat))",
                "Gần đạt (\(soMonGanDat))",
                "Chưa (\(soMonChua))"
            ])
            chonLoc.selectedSegmentIndex = boLocMon
            chonLoc.selectedSegmentTintColor = BangMauBCTD.xanhChuDao
            chonLoc.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 10.5, weight: .bold)], for: .selected)
            chonLoc.setTitleTextAttributes([.foregroundColor: BangMauBCTD.chuPhu, .font: UIFont.systemFont(ofSize: 10.5, weight: .semibold)], for: .normal)
            chonLoc.damBaoHienThiDayDuText()
            chonLoc.heightAnchor.constraint(equalToConstant: 32).isActive = true
            chonLoc.addTarget(self, action: #selector(doiBoLocMon(_:)), for: .valueChanged)

            let nutSapXep = UIButton(type: .system)
            let nhanSX: String
            switch kieuSapXepMon {
            case 1: nhanSX = "⇅ % HT Cao↓"
            case 2: nhanSX = "⇅ % HT Thấp↑"
            default: nhanSX = "⇅ Mặc định"
            }
            nutSapXep.setTitle(" \(nhanSX) ", for: .normal)
            nutSapXep.titleLabel?.font = .systemFont(ofSize: 10.5, weight: .bold)
            nutSapXep.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
            nutSapXep.backgroundColor = UIColor(red: 0.93, green: 0.96, blue: 1.0, alpha: 1)
            nutSapXep.layer.cornerRadius = 8
            nutSapXep.layer.borderWidth = 1
            nutSapXep.layer.borderColor = BangMauBCTD.xanhChuDao.withAlphaComponent(0.3).cgColor
            nutSapXep.contentEdgeInsets = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
            nutSapXep.setContentHuggingPriority(.required, for: .horizontal)
            nutSapXep.setContentCompressionResistancePriority(.required, for: .horizontal)
            nutSapXep.addTarget(self, action: #selector(bamDoiSapXepMon), for: .touchUpInside)

            let hangCongCu = UIStackView(arrangedSubviews: [chonLoc, nutSapXep])
            hangCongCu.axis = .horizontal
            hangCongCu.spacing = 6
            hangCongCu.alignment = .center
            nganChinh.addArrangedSubview(hangCongCu)
        }

        // ==================== 4. BẢNG CHI TIẾT CÁC MÔN THI ĐUA ====================
        let bangNoiDung = taoKhungBangMonThiDua(danhSachMon: danhSachMonHienThi())
        chieuCaoBangMonHienTai = bangNoiDung.chieuCao
        if laCheDoXuatAnhRong {
            let vBang = bangNoiDung.view
            vBang.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vBang.heightAnchor.constraint(equalToConstant: bangNoiDung.chieuCao),
                vBang.widthAnchor.constraint(equalToConstant: tongChieuRongBang)
            ])
            nganChinh.addArrangedSubview(vBang)
        } else {
            let cuonNgang = UIScrollView()
            cuonNgang.showsHorizontalScrollIndicator = true
            cuonNgang.bounces = false
            cuonNgang.layer.cornerRadius = 10
            cuonNgang.layer.borderWidth = 1
            cuonNgang.layer.borderColor = UIColor(red: 0.86, green: 0.89, blue: 0.94, alpha: 1).cgColor
            cuonNgang.clipsToBounds = true
            cuonNgang.backgroundColor = .white
            cuonNgang.translatesAutoresizingMaskIntoConstraints = false

            let vBang = bangNoiDung.view
            vBang.translatesAutoresizingMaskIntoConstraints = false
            cuonNgang.addSubview(vBang)

            NSLayoutConstraint.activate([
                cuonNgang.heightAnchor.constraint(equalToConstant: bangNoiDung.chieuCao),
                vBang.topAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.topAnchor),
                vBang.bottomAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.bottomAnchor),
                vBang.leadingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.leadingAnchor),
                vBang.trailingAnchor.constraint(equalTo: cuonNgang.contentLayoutGuide.trailingAnchor),
                vBang.heightAnchor.constraint(equalToConstant: bangNoiDung.chieuCao),
                vBang.widthAnchor.constraint(equalToConstant: tongChieuRongBang)
            ])
            nganChinh.addArrangedSubview(cuonNgang)
        }
    }

    @objc private func doiBoLocMon(_ sender: UISegmentedControl) {
        boLocMon = sender.selectedSegmentIndex
        dungGiaoDien()
    }

    @objc private func bamDoiSapXepMon() {
        kieuSapXepMon = (kieuSapXepMon + 1) % 3
        dungGiaoDien()
    }

    private func taoTheKPISucKhoe(
        tieuDe: String,
        giaTri: String,
        phuDe: String,
        mauBatDau: UIColor,
        mauKetThuc: UIColor
    ) -> UIView {
        TheKPISucKhoeGonView(
            tieuDe: tieuDe,
            giaTri: giaTri,
            phuDe: phuDe,
            mauBatDau: mauBatDau,
            mauKetThuc: mauKetThuc,
            laXuatAnh: laCheDoXuatAnhRong
        )
    }

    private func tinhChieuCaoDongMon(_ m: MonThiDuaNhanVien, rongCotTen: CGFloat) -> CGFloat {
        let chuoiTen = "\(m.tenNganhHang) (\(m.loaiChiTieu.maThe))"
        let fontTen = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        let rectTen = (chuoiTen as NSString).boundingRect(
            with: CGSize(width: max(60, rongCotTen - 12), height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: fontTen],
            context: nil
        )
        return max(44, ceil(rectTen.height) + 16)
    }

    private func taoKhungBangMonThiDua(danhSachMon: [MonThiDuaNhanVien]) -> (view: UIView, chieuCao: CGFloat) {
        let cacRong = chieuRongCot
        let rongBang = tongChieuRongBang
        let caoHeader: CGFloat = 38
        let cacCaoDong: [CGFloat] = danhSachMon.isEmpty
            ? [52]
            : danhSachMon.map { tinhChieuCaoDongMon($0, rongCotTen: cacRong[1]) }
        let tongCao = caoHeader + cacCaoDong.reduce(0, +)

        let khungBang = UIView(frame: CGRect(x: 0, y: 0, width: rongBang, height: tongCao))
        khungBang.backgroundColor = .white
        if laCheDoXuatAnhRong {
            khungBang.layer.cornerRadius = 10
            khungBang.layer.borderWidth = 1
            khungBang.layer.borderColor = UIColor(red: 0.85, green: 0.88, blue: 0.93, alpha: 1).cgColor
            khungBang.clipsToBounds = true
        }

        // Dòng Header bảng
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: rongBang, height: caoHeader))
        headerView.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1)
        let tieuDeCot = ["#", "MÔN THI ĐUA", "THỰC HIỆN", "TARGET", "% HT", "% HT ST", "CÒN LẠI", "TIẾN ĐỘ"]
        var xH: CGFloat = 0
        for (i, chu) in tieuDeCot.enumerated() {
            let w = cacRong[i]
            let lb = UILabel(frame: CGRect(x: xH + 4, y: 2, width: w - 8, height: caoHeader - 4))
            lb.text = chu
            lb.font = .systemFont(ofSize: 10.5, weight: .heavy)
            lb.textColor = UIColor(red: 0.25, green: 0.31, blue: 0.40, alpha: 1)
            lb.numberOfLines = 2
            lb.textAlignment = (i == 1) ? .left : (i == 2 || i == 3 || i == 6 ? .right : .center)
            headerView.addSubview(lb)
            xH += w
        }
        let vachDuoiHeader = UIView(frame: CGRect(x: 0, y: caoHeader - 1, width: rongBang, height: 1))
        vachDuoiHeader.backgroundColor = UIColor(red: 0.84, green: 0.88, blue: 0.93, alpha: 1)
        headerView.addSubview(vachDuoiHeader)
        khungBang.addSubview(headerView)

        if danhSachMon.isEmpty {
            let lbTrong = UILabel(frame: CGRect(x: 0, y: caoHeader, width: rongBang, height: 52))
            lbTrong.text = "Không có môn thi đua nào trong bộ lọc này."
            lbTrong.font = .systemFont(ofSize: 12.5, weight: .medium)
            lbTrong.textColor = UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1)
            lbTrong.textAlignment = .center
            khungBang.addSubview(lbTrong)
            return (khungBang, tongCao)
        }

        let fontSo = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .bold)
        var yDong: CGFloat = caoHeader

        for (idx, m) in danhSachMon.enumerated() {
            let caoDong = cacCaoDong[idx]
            let dongControl = UIControl(frame: CGRect(x: 0, y: yDong, width: rongBang, height: caoDong))
            dongControl.tag = idx
            if m.daDat {
                dongControl.backgroundColor = UIColor(red: 0.93, green: 0.99, blue: 0.95, alpha: 1)
            } else if m.phanTramHT >= 70.0 {
                dongControl.backgroundColor = UIColor(red: 1.0, green: 0.98, blue: 0.92, alpha: 1)
            } else {
                dongControl.backgroundColor = (idx % 2 == 0)
                    ? UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 0.65)
                    : UIColor(red: 1.0, green: 0.94, blue: 0.95, alpha: 0.85)
            }
            if !laCheDoXuatAnhRong {
                dongControl.addAction(UIAction { [weak self] _ in
                    self?.moSuaMonThiDuaCaNhan(m)
                }, for: .touchUpInside)
            }

            var x: CGFloat = 0
            for i in 0..<cacRong.count {
                let w = cacRong[i]
                let rect = CGRect(x: x, y: 0, width: w, height: caoDong)
                switch i {
                case 0: // #
                    let lb = UILabel(frame: rect)
                    lb.text = "\(idx + 1)"
                    lb.font = fontSo
                    lb.textColor = UIColor(red: 0.42, green: 0.48, blue: 0.56, alpha: 1)
                    lb.textAlignment = .center
                    lb.isUserInteractionEnabled = false
                    dongControl.addSubview(lb)

                case 1: // MÔN THI ĐUA
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 4))
                    lb.text = "\(m.tenNganhHang) (\(m.loaiChiTieu.maThe))"
                    lb.font = .systemFont(ofSize: 12.0, weight: .bold)
                    lb.textColor = UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1)
                    lb.numberOfLines = 0
                    lb.lineBreakMode = .byWordWrapping
                    lb.isUserInteractionEnabled = false
                    dongControl.addSubview(lb)

                case 2: // THỰC HIỆN
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = m.thucHien.chuoiSoVN
                    lb.font = fontSo
                    lb.textColor = UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1)
                    lb.textAlignment = .right
                    lb.isUserInteractionEnabled = false
                    dongControl.addSubview(lb)

                case 3: // TARGET
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    lb.text = m.targetCaNhan.chuoiSoVN
                    lb.font = fontSo
                    lb.textColor = UIColor(red: 0.40, green: 0.46, blue: 0.55, alpha: 1)
                    lb.textAlignment = .right
                    lb.isUserInteractionEnabled = false
                    dongControl.addSubview(lb)

                case 4: // % HT (Pill badge)
                    let pill = UILabel(frame: rect.insetBy(dx: 5, dy: max(6, (caoDong - 26) / 2)))
                    pill.text = m.phanTramHT.chuoiPhanTramVN
                    pill.font = UIFont.monospacedDigitSystemFont(ofSize: 11.5, weight: .heavy)
                    pill.textAlignment = .center
                    pill.layer.cornerRadius = 6
                    pill.clipsToBounds = true
                    pill.isUserInteractionEnabled = false
                    if m.daDat {
                        pill.backgroundColor = UIColor(red: 0.82, green: 0.96, blue: 0.87, alpha: 1)
                        pill.textColor = UIColor(red: 0.05, green: 0.48, blue: 0.24, alpha: 1)
                    } else if m.phanTramHT >= 70.0 {
                        pill.backgroundColor = UIColor(red: 0.99, green: 0.92, blue: 0.76, alpha: 1)
                        pill.textColor = UIColor(red: 0.72, green: 0.36, blue: 0.04, alpha: 1)
                    } else {
                        pill.backgroundColor = UIColor(red: 0.98, green: 0.84, blue: 0.86, alpha: 1)
                        pill.textColor = UIColor(red: 0.76, green: 0.12, blue: 0.16, alpha: 1)
                    }
                    dongControl.addSubview(pill)

                case 5: // % HT ST
                    let lb = UILabel(frame: rect.insetBy(dx: 4, dy: 2))
                    lb.text = m.phanTramSieuThi.chuoiPhanTramVN
                    lb.font = fontSo
                    lb.textColor = UIColor(red: 0.42, green: 0.48, blue: 0.56, alpha: 1)
                    lb.textAlignment = .center
                    lb.isUserInteractionEnabled = false
                    dongControl.addSubview(lb)

                case 6: // CÒN LẠI
                    let lb = UILabel(frame: rect.insetBy(dx: 6, dy: 2))
                    if m.conLai <= 0.005 {
                        let vuot = abs(m.conLai)
                        lb.text = vuot > 0.005 ? "+\(vuot.chuoiSoVN)" : "0,00"
                        lb.textColor = UIColor(red: 0.05, green: 0.50, blue: 0.24, alpha: 1)
                    } else {
                        lb.text = m.conLai.chuoiSoVN
                        lb.textColor = UIColor(red: 0.78, green: 0.12, blue: 0.16, alpha: 1)
                    }
                    lb.font = fontSo
                    lb.textAlignment = .right
                    lb.isUserInteractionEnabled = false
                    dongControl.addSubview(lb)

                case 7: // TIẾN ĐỘ (Thanh + chấm tròn đầu thanh như ảnh mẫu)
                    let leThanh: CGFloat = 10
                    let rongTrack = w - leThanh * 2
                    let yTrack = (caoDong - 6) / 2
                    let track = UIView(frame: CGRect(x: x + leThanh, y: yTrack, width: rongTrack, height: 6))
                    track.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.95, alpha: 1)
                    track.layer.cornerRadius = 3
                    track.clipsToBounds = true
                    track.isUserInteractionEnabled = false

                    let mauTienDo: UIColor = m.daDat
                        ? UIColor(red: 0.08, green: 0.62, blue: 0.30, alpha: 1)
                        : (m.phanTramHT >= 70.0
                            ? UIColor(red: 0.95, green: 0.56, blue: 0.05, alpha: 1)
                            : UIColor(red: 0.84, green: 0.16, blue: 0.20, alpha: 1))
                    let pct = CGFloat(min(1.0, max(0.04, m.phanTramHT / 100.0)))
                    let fill = UIView(frame: CGRect(x: 0, y: 0, width: rongTrack * pct, height: 6))
                    fill.backgroundColor = mauTienDo
                    fill.layer.cornerRadius = 3
                    track.addSubview(fill)
                    dongControl.addSubview(track)

                    let cham = UIView(frame: CGRect(x: x + leThanh - 2, y: (caoDong - 8) / 2, width: 8, height: 8))
                    cham.backgroundColor = mauTienDo
                    cham.layer.cornerRadius = 4
                    cham.isUserInteractionEnabled = false
                    dongControl.addSubview(cham)

                default:
                    break
                }
                x += w
            }

            let vachNgang = UIView(frame: CGRect(x: 0, y: caoDong - 0.5, width: rongBang, height: 0.5))
            vachNgang.backgroundColor = UIColor(red: 0.88, green: 0.90, blue: 0.94, alpha: 1)
            vachNgang.isUserInteractionEnabled = false
            dongControl.addSubview(vachNgang)

            khungBang.addSubview(dongControl)
            yDong += caoDong
        }

        return (khungBang, tongCao)
    }

    private func docSo(_ text: String?) -> Double? {
        let s = (text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: ",", with: ".")
        guard !s.isEmpty else { return nil }
        return Double(s)
    }

    private static func dinhDangPhanTramSucKhoe(_ v: Double) -> String {
        if abs(v - round(v)) >= 0.05 {
            return String(format: "%.1f%%", v).replacingOccurrences(of: ".", with: ",")
        }
        return "\(Int(round(v)))%"
    }

    private func taoKhungDoanhThu6Muc(sk: DuLieuSucKhoeBoSungNV?, dsTatCaNV: [TongHopNhanVien]) -> UIView {
        let khung = UIView()
        khung.backgroundColor = UIColor(red: 0.94, green: 0.97, blue: 1.0, alpha: 1)
        khung.layer.cornerRadius = 12
        khung.layer.borderWidth = 1
        khung.layer.borderColor = UIColor(red: 0.82, green: 0.89, blue: 0.98, alpha: 1).cgColor

        let dsCoDT = dsTatCaNV.filter { abs($0.doanhThuQD) > 0.001 || abs($0.soLuongDon) > 0.001 }
        let tbDTQDTuBang: Double? = !dsCoDT.isEmpty
            ? (dsCoDT.map(\.doanhThuQD).reduce(0, +) / Double(dsCoDT.count))
            : nil
        let tbBillTuBang: Double? = !dsCoDT.isEmpty
            ? (dsCoDT.map(\.soLuongDon).reduce(0, +) / Double(dsCoDT.count))
            : nil
        let tbQuyDoiTuBang: Double? = !dsCoDT.isEmpty
            ? (dsCoDT.map(\.phanTramTiTrong).reduce(0, +) / Double(dsCoDT.count))
            : nil

        let dtQD: Double = {
            if abs(tongHop.doanhThuQD) > 0.0001 { return tongHop.doanhThuQD }
            if let v = sk?.doanhThuQDSucKhoe, abs(v) > 0.0001 { return v }
            return 0
        }()
        let tbDTQD = sk?.tbDoanhThuQDSieuThi ?? tbDTQDTuBang

        let mtQD = (sk?.mucTieuTargetQD ?? 0) > 40 ? (sk?.mucTieuTargetQD ?? 0) : ((tongHop.doanhThuCaNhan?.target ?? 0) > 40 ? (tongHop.doanhThuCaNhan?.target ?? 0) : 0)
        let ptTarget: Double = {
            if let v = sk?.phanTramTarget, abs(v) > 0.0001 { return v }
            if mtQD > 0 && abs(dtQD) > 0.0001 { return (dtQD / mtQD) * 100.0 }
            return tongHop.doanhThuCaNhan?.phanTramHT ?? 0
        }()
        let tbTarget = sk?.tbPhanTramTarget

        let soBill: Double = {
            if abs(tongHop.soLuongDon) > 0.0001 { return tongHop.soLuongDon }
            if let v = sk?.soLuotBillBanHang, abs(v) > 0.0001 { return v }
            return 0
        }()
        let tbBill = sk?.tbSoLuotBillBanHang ?? tbBillTuBang

        let ptQuyDoi: Double = {
            if abs(tongHop.phanTramTiTrong) > 0.0001 { return tongHop.phanTramTiTrong }
            if let v = sk?.phanTramQuyDoi, abs(v) > 0.0001 { return v }
            return 0
        }()
        let tbQuyDoi = sk?.tbPhanTramQuyDoi ?? tbQuyDoiTuBang

        let ptTraCham = (sk?.phanTramTraCham ?? 0) > 0 ? (sk?.phanTramTraCham ?? 0) : max(0, tongHop.doanhThuCaNhan?.phanTramTraGop ?? 0)
        let tbTraCham = sk?.tbPhanTramTraCham

        let ptBanKem = max(0, sk?.phanTramBanKem ?? 0)
        let tbBanKem = sk?.tbPhanTramBanKem

        func trangThaiSoVoiTB(_ giaTri: Double, _ tb: Double?) -> TheChiSoSucKhoeView.TrangThaiThe {
            if let tb = tb, tb > 0 {
                return giaTri >= tb - 0.001 ? .dat : .chuaDat
            }
            return giaTri > 0 ? .dat : (giaTri < 0 ? .chuaDat : .chuaCoSo)
        }

        let tt1 = trangThaiSoVoiTB(dtQD, tbDTQD)
        let tt2 = trangThaiSoVoiTB(ptTarget, tbTarget)
        let tt3 = trangThaiSoVoiTB(soBill, tbBill)
        let tt4 = trangThaiSoVoiTB(ptQuyDoi, tbQuyDoi)
        let tt5 = trangThaiSoVoiTB(ptTraCham, tbTraCham)
        let tt6 = trangThaiSoVoiTB(ptBanKem, tbBanKem)
        let soMucDat = [tt1, tt2, tt3, tt4, tt5, tt6].filter { $0 == .dat }.count

        let lbTieuDe = UILabel()
        lbTieuDe.text = "DOANH THU (\(cheDo.tieuDe.uppercased()))"
        lbTieuDe.font = .systemFont(ofSize: 12.0, weight: .heavy)
        lbTieuDe.textColor = UIColor(red: 0.08, green: 0.32, blue: 0.78, alpha: 1)

        let lbDem = UILabel()
        lbDem.text = " \(soMucDat)/6 "
        lbDem.font = .monospacedDigitSystemFont(ofSize: 11.0, weight: .heavy)
        lbDem.textColor = UIColor(red: 0.08, green: 0.32, blue: 0.78, alpha: 1)
        lbDem.backgroundColor = UIColor.white
        lbDem.layer.cornerRadius = 6
        lbDem.clipsToBounds = true

        let hangDau = UIStackView(arrangedSubviews: [lbTieuDe, lbDem, UIView()])
        hangDau.axis = .horizontal
        hangDau.spacing = 6
        hangDau.alignment = .center

        let phuKhoanVay: String? = abs(tongHop.dtQDKhoanVay) > 0.001 ? "Vay: \(tongHop.dtQDKhoanVay.chuoiSoMotLeVN) tr" : nil
        let the1 = TheChiSoSucKhoeView(
            tieuDe: "DOANH THU QĐ",
            giaTri: "\(dtQD.chuoiSoMotLeVN) tr",
            chuoiTB: tbDTQD != nil ? "TB \(tbDTQD!.chuoiSoMotLeVN) tr" : "TB 0 tr",
            chuoiPhu: phuKhoanVay,
            trangThai: tt1
        )
        let the2 = TheChiSoSucKhoeView(
            tieuDe: "% TARGET",
            giaTri: Self.dinhDangPhanTramSucKhoe(ptTarget),
            chuoiTB: tbTarget != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbTarget!))" : "TB 0%",
            chuoiPhu: mtQD > 0 ? "MT \(mtQD.chuoiSoMotLeVN) tr" : nil,
            trangThai: tt2
        )
        let the3 = TheChiSoSucKhoeView(
            tieuDe: "SỐ LƯỢT BILL BÁN HÀNG",
            giaTri: soBill.chuoiSoNguyenVN,
            chuoiTB: tbBill != nil ? "TB \(tbBill!.chuoiSoNguyenVN)" : "TB 0",
            trangThai: tt3
        )
        let the4 = TheChiSoSucKhoeView(
            tieuDe: "% TỈ TRỌNG / QĐ",
            giaTri: Self.dinhDangPhanTramSucKhoe(ptQuyDoi),
            chuoiTB: tbQuyDoi != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbQuyDoi!))" : "TB 0%",
            trangThai: tt4
        )
        let the5 = TheChiSoSucKhoeView(
            tieuDe: "% TRẢ CHẬM",
            giaTri: Self.dinhDangPhanTramSucKhoe(ptTraCham),
            chuoiTB: tbTraCham != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbTraCham!))" : "TB 0%",
            trangThai: tt5
        )
        let the6 = TheChiSoSucKhoeView(
            tieuDe: "% BÁN KÈM",
            giaTri: Self.dinhDangPhanTramSucKhoe(ptBanKem),
            chuoiTB: tbBanKem != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbBanKem!))" : "TB 0%",
            trangThai: tt6
        )

        let nganLuoi = UIStackView()
        nganLuoi.axis = .vertical
        nganLuoi.spacing = 6

        if laCheDoXuatAnhRong {
            let hang1 = UIStackView(arrangedSubviews: [the1, the2, the3])
            hang1.axis = .horizontal
            hang1.spacing = 8
            hang1.distribution = .fillEqually

            let hang2 = UIStackView(arrangedSubviews: [the4, the5, the6])
            hang2.axis = .horizontal
            hang2.spacing = 8
            hang2.distribution = .fillEqually

            nganLuoi.addArrangedSubview(hang1)
            nganLuoi.addArrangedSubview(hang2)
        } else {
            for cap in [[the1, the2], [the3, the4], [the5, the6]] {
                let h = UIStackView(arrangedSubviews: cap)
                h.axis = .horizontal
                h.spacing = 6
                h.distribution = .fillEqually
                nganLuoi.addArrangedSubview(h)
            }
        }

        let ngan = UIStackView(arrangedSubviews: [hangDau, nganLuoi])
        ngan.axis = .vertical
        ngan.spacing = 8
        ngan.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: khung.topAnchor, constant: 10),
            ngan.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -10),
            ngan.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -10)
        ])
        return khung
    }

    private func taoKhungGioCong2Muc(sk: DuLieuSucKhoeBoSungNV?, dsTatCaNV: [TongHopNhanVien]) -> UIView {
        let khung = UIView()
        khung.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1)
        khung.layer.cornerRadius = 12
        khung.layer.borderWidth = 1
        khung.layer.borderColor = UIColor(red: 0.80, green: 0.86, blue: 0.98, alpha: 1).cgColor

        let gcTaiST: Double = {
            if tongHop.gioCongTaiST > 0.0001 { return tongHop.gioCongTaiST }
            if let v = sk?.gioCongTaiST, v > 0.0001 { return v }
            if let v = tongHop.doanhThuCaNhan?.gioCong, v > 0.0001 { return v }
            return 0
        }()
        let gcHoTro: Double = {
            if tongHop.gioCongHoTro > 0.0001 { return tongHop.gioCongHoTro }
            if let v = sk?.gioCongHoTroSTKhac, v > 0.0001 { return v }
            if let v = tongHop.doanhThuCaNhan?.gioCongHoTro, v > 0.0001 { return v }
            return 0
        }()
        let tongGC = gcTaiST + gcHoTro

        let dsCoGC = dsTatCaNV.filter { $0.gioCongTaiST > 0.001 || $0.gioCongHoTro > 0.001 }
        let tbGCTaiST: Double? = !dsCoGC.isEmpty
            ? (dsCoGC.map(\.gioCongTaiST).reduce(0, +) / Double(dsCoGC.count))
            : nil
        let tbGCHoTro: Double? = !dsCoGC.isEmpty
            ? (dsCoGC.map(\.gioCongHoTro).reduce(0, +) / Double(dsCoGC.count))
            : nil

        let tt1: TheChiSoSucKhoeView.TrangThaiThe = {
            guard gcTaiST > 0.001 else { return .chuaCoSo }
            if let tb = tbGCTaiST, tb > 0 {
                return gcTaiST >= tb - 0.001 ? .dat : .chuaDat
            }
            return .dat
        }()
        let tt2: TheChiSoSucKhoeView.TrangThaiThe = {
            if gcHoTro > 0.001 { return .dat }
            if gcTaiST > 0.001 { return .chuaCoSo }
            return .chuaCoSo
        }()

        let lbTieuDe = UILabel()
        lbTieuDe.text = "⏱️ GIỜ CÔNG (\(cheDo.tieuDe.uppercased()))"
        lbTieuDe.font = .systemFont(ofSize: 12.0, weight: .heavy)
        lbTieuDe.textColor = UIColor(red: 0.14, green: 0.30, blue: 0.76, alpha: 1)

        let lbTong = UILabel()
        lbTong.text = " Tổng: \(tongGC.chuoiSoMotLeVN) giờ "
        lbTong.font = .monospacedDigitSystemFont(ofSize: 11.0, weight: .heavy)
        lbTong.textColor = UIColor(red: 0.14, green: 0.30, blue: 0.76, alpha: 1)
        lbTong.backgroundColor = .white
        lbTong.layer.cornerRadius = 6
        lbTong.clipsToBounds = true

        let hangDau = UIStackView(arrangedSubviews: [lbTieuDe, lbTong, UIView()])
        hangDau.axis = .horizontal
        hangDau.spacing = 6
        hangDau.alignment = .center

        let the1 = TheChiSoSucKhoeView(
            tieuDe: "GIỜ CÔNG TẠI ST LÀM VIỆC",
            giaTri: "\(gcTaiST.chuoiSoMotLeVN) giờ",
            chuoiTB: tbGCTaiST != nil ? "TB \(tbGCTaiST!.chuoiSoMotLeVN)h" : "TB 0,0h",
            chuoiPhu: "ST làm việc",
            trangThai: tt1
        )
        let the2 = TheChiSoSucKhoeView(
            tieuDe: "GIỜ CÔNG HỖ TRỢ ST KHÁC",
            giaTri: "\(gcHoTro.chuoiSoMotLeVN) giờ",
            chuoiTB: tbGCHoTro != nil ? "TB \(tbGCHoTro!.chuoiSoMotLeVN)h" : "TB 0,0h",
            chuoiPhu: "Tổng: \(tongGC.chuoiSoMotLeVN)h",
            trangThai: tt2
        )

        let hangThe = UIStackView(arrangedSubviews: [the1, the2])
        hangThe.axis = .horizontal
        hangThe.spacing = laCheDoXuatAnhRong ? 8 : 6
        hangThe.distribution = .fillEqually

        let ngan = UIStackView(arrangedSubviews: [hangDau, hangThe])
        ngan.axis = .vertical
        ngan.spacing = 8
        ngan.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: khung.topAnchor, constant: 10),
            ngan.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -10),
            ngan.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -10)
        ])
        return khung
    }

    private func taoKhungNangSuat3Muc(sk: DuLieuSucKhoeBoSungNV?) -> UIView {
        let khung = UIView()
        khung.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.96, alpha: 1)
        khung.layer.cornerRadius = 12
        khung.layer.borderWidth = 1
        khung.layer.borderColor = UIColor(red: 0.78, green: 0.92, blue: 0.85, alpha: 1).cgColor

        let hienThiNS = KhoDuLieu.dungChung.caiDat.hienThiNangSuatNhanVien

        let erp = max(0, sk?.diemThuongERP ?? 0)
        let tbErp = sk?.tbDiemThuongERP
        let erpGC = max(0, sk?.diemThuongTrenGioCong ?? 0)
        let tbErpGC = sk?.tbDiemThuongTrenGioCong
        let gcTaiST = tongHop.gioCongTaiST > 0.001 ? tongHop.gioCongTaiST : (sk?.gioCongTaiST ?? 0)
        let dtGC: Double = {
            if let v = sk?.dtqdTrenGioCong, v > 0.0001 { return v }
            if tongHop.doanhThuQD > 0.001 && gcTaiST > 0.001 {
                return ((tongHop.doanhThuQD / gcTaiST) * 100.0).rounded() / 100.0
            }
            return 0
        }()
        let tbDtGC = sk?.tbDtqdTrenGioCong

        func trangThaiNS(_ giaTri: Double, _ tb: Double?) -> TheChiSoSucKhoeView.TrangThaiThe {
            guard hienThiNS else { return .chuaCoSo }
            if let tb = tb, tb > 0 {
                return giaTri >= tb - 0.001 ? .dat : .chuaDat
            }
            return giaTri > 0 ? .dat : .chuaCoSo
        }

        let tt1 = trangThaiNS(erp, tbErp)
        let tt2 = trangThaiNS(erpGC, tbErpGC)
        let tt3 = trangThaiNS(dtGC, tbDtGC)
        let soDat = [tt1, tt2, tt3].filter { $0 == .dat }.count

        let lbTieuDe = UILabel()
        lbTieuDe.text = "NĂNG SUẤT"
        lbTieuDe.font = .systemFont(ofSize: 12.0, weight: .heavy)
        lbTieuDe.textColor = UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1)

        let lbDem = UILabel()
        lbDem.text = hienThiNS ? " \(soDat)/3 " : " * "
        lbDem.font = .monospacedDigitSystemFont(ofSize: 11.0, weight: .heavy)
        lbDem.textColor = UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1)
        lbDem.backgroundColor = UIColor.white
        lbDem.layer.cornerRadius = 6
        lbDem.clipsToBounds = true

        let hangDau = UIStackView(arrangedSubviews: [lbTieuDe, lbDem, UIView()])
        hangDau.axis = .horizontal
        hangDau.spacing = 6
        hangDau.alignment = .center

        if !laCheDoXuatAnhRong {
            let nutAnHien = UIButton(type: .system)
            nutAnHien.setTitle(hienThiNS ? "☑️ Hiển thị Năng suất" : "⬜ Ẩn Năng suất (*)", for: .normal)
            nutAnHien.titleLabel?.font = .systemFont(ofSize: 11.0, weight: .bold)
            nutAnHien.setTitleColor(hienThiNS ? UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1) : UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1), for: .normal)
            nutAnHien.backgroundColor = .white
            nutAnHien.layer.cornerRadius = 7
            nutAnHien.layer.borderWidth = 1
            nutAnHien.layer.borderColor = UIColor(red: 0.72, green: 0.86, blue: 0.78, alpha: 1).cgColor
            nutAnHien.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            nutAnHien.addTarget(self, action: #selector(bamChuyenAnHienNangSuat), for: .touchUpInside)
            hangDau.addArrangedSubview(nutAnHien)
        }

        let the1 = TheChiSoSucKhoeView(
            tieuDe: "ĐIỂM THƯỞNG ERP",
            giaTri: hienThiNS ? erp.chuoiSoNguyenVN : "*",
            chuoiTB: hienThiNS ? (tbErp != nil ? "TB \(tbErp!.chuoiSoNguyenVN)" : "TB 0") : "TB *",
            trangThai: tt1
        )
        let the2 = TheChiSoSucKhoeView(
            tieuDe: "ĐIỂM THƯỞNG / GIỜ CÔNG",
            giaTri: hienThiNS ? erpGC.chuoiSoNguyenVN : "*",
            chuoiTB: hienThiNS ? (tbErpGC != nil ? "TB \(tbErpGC!.chuoiSoNguyenVN)" : "TB 0") : "TB *",
            trangThai: tt2
        )
        let the3 = TheChiSoSucKhoeView(
            tieuDe: "DTQĐ / GIỜ CÔNG",
            giaTri: hienThiNS ? dtGC.chuoiSoVN : "*",
            chuoiTB: hienThiNS ? (tbDtGC != nil ? "TB \(tbDtGC!.chuoiSoVN)" : "TB 0") : "TB *",
            trangThai: tt3
        )

        let hangThe = UIStackView(arrangedSubviews: [the1, the2, the3])
        hangThe.axis = .horizontal
        hangThe.spacing = laCheDoXuatAnhRong ? 8 : 6
        hangThe.distribution = .fillEqually

        let ngan = UIStackView(arrangedSubviews: [hangDau, hangThe])
        ngan.axis = .vertical
        ngan.spacing = 8
        ngan.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: khung.topAnchor, constant: 10),
            ngan.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -10),
            ngan.leadingAnchor.constraint(equalTo: khung.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -10)
        ])
        return khung
    }

    @objc private func bamChuyenAnHienNangSuat() {
        var cd = KhoDuLieu.dungChung.caiDat
        cd.hienThiNangSuatNhanVien.toggle()
        KhoDuLieu.dungChung.luuCaiDat(cd)
        dungGiaoDien()
        khiYeuCauCapNhat?()
    }

    private func moSuaMonThiDuaCaNhan(_ mon: MonThiDuaNhanVien) {
        guard let vc = timViewControllerCha() else { return }
        let hop = UIAlertController(
            title: "\(mon.tenNganhHang)",
            message: "Target cá nhân: \(mon.targetCaNhan.chuoiSoVN) (\(mon.loaiChiTieu.maBang)). Nhập số Thực hiện mới (hoặc kèm dấu % nếu nhập % HT) cho \(tongHop.nhanVien.hoTen):",
            preferredStyle: .alert
        )
        hop.addTextField { tf in
            tf.placeholder = "Thực hiện (VD: 1.5 hoặc 88%)"
            tf.keyboardType = .decimalPad
            if abs(mon.thucHien) > 0.0001 { tf.text = String(mon.thucHien) }
            else if abs(mon.phanTramHT) > 0.0001 { tf.text = "\(Int(round(mon.phanTramHT)))%" }
        }
        hop.addAction(UIAlertAction(title: "Lưu", style: .default) { [weak self] _ in
            guard let self else { return }
            let raw = (hop.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            guard let val = self.docSo(raw) else { return }
            var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
            var bangNV = dl.thiDuaNhanVien(theo: self.cheDo)
            let ma = self.tongHop.nhanVien.maNV
            let kLM = KhoDuLieu.chuanHoaKhoaLienMachThiDua(mon.tenNganhHang)

            if raw.contains("%") {
                var sk = dl.sucKhoeBoSungNhanVien[ma] ?? DuLieuSucKhoeBoSungNV()
                var mapPT = sk.phanTramThiDuaCaNhan ?? [:]
                if !kLM.isEmpty { mapPT[kLM] = val }
                mapPT[mon.khoaNganh] = val
                sk.phanTramThiDuaCaNhan = mapPT
                dl.sucKhoeBoSungNhanVien[ma] = sk
                if mon.targetCaNhan > 0.0001 {
                    bangNV[mon.khoaNganh, default: [:]][ma] = ((mon.targetCaNhan * val / 100.0) * 100.0).rounded() / 100.0
                } else {
                    bangNV[mon.khoaNganh, default: [:]][ma] = 0
                }
            } else {
                bangNV[mon.khoaNganh, default: [:]][ma] = val
                if var sk = dl.sucKhoeBoSungNhanVien[ma], var mapPT = sk.phanTramThiDuaCaNhan {
                    let ptMoi = mon.targetCaNhan > 0.0001 ? ((val / mon.targetCaNhan) * 100.0) : 0
                    if !kLM.isEmpty { mapPT[kLM] = ptMoi }
                    mapPT[mon.khoaNganh] = ptMoi
                    sk.phanTramThiDuaCaNhan = mapPT
                    dl.sucKhoeBoSungNhanVien[ma] = sk
                }
            }
            dl.ganThiDuaNhanVien(bangNV, theo: self.cheDo)
            KhoDuLieu.dungChung.luu(dl)
            if let capNhatTH = KhoDuLieu.dungChung.tongHopNhanVien(den: self.ngay, sapXep: .tenAZ, cheDo: self.cheDo)
                .first(where: { $0.nhanVien.maNV == self.tongHop.nhanVien.maNV }) {
                self.tongHop = capNhatTH
            }
            self.dungGiaoDien()
            self.khiYeuCauCapNhat?()
        })
        hop.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        vc.present(hop, animated: true)
    }

    static func taoAnhBaoCao(cho tongHop: TongHopNhanVien, ngay: Date, cheDo: LoaiCheDoDoanhThu) -> UIImage? {
        let rongAnh: CGFloat = 820
        let le: CGFloat = 12
        let rongNoiDung: CGFloat = rongAnh - le * 2 // 796pt
        let cacRong: [CGFloat] = [36, 232, 86, 86, 84, 78, 88, 106]

        let kho = KhoDuLieu.dungChung
        let dl = kho.duLieu(cho: ngay)
        let dtST = (cheDo == .luyKe) ? dl.doanhThu : dl.doanhThuRealtime
        let dsTatCaNV = kho.tongHopNhanVien(den: ngay, sapXep: .doanhThuQD, cheDo: cheDo)
        let soNVQuanLy = max(1, dsTatCaNV.count)
        let hangNV = (dsTatCaNV.firstIndex(where: { $0.nhanVien.maNV == tongHop.nhanVien.maNV }) ?? 0) + 1

        let lich = TienIchNgay.lich
        let soNgayQua = dtST.soNgayDaQua > 0 ? dtST.soNgayDaQua : max(1, lich.component(.day, from: ngay))
        let tongNgayThang = dtST.tongSoNgay > 0 ? dtST.tongSoNgay : (lich.range(of: .day, in: .month, for: ngay)?.count ?? 30)
        let ptTienDo = dtST.phanTramTienDoThang > 0
            ? dtST.phanTramTienDoThang
            : (Double(soNgayQua) / Double(max(1, tongNgayThang)) * 100.0)

        let donVi = dl.thongTinDonVi.isEmpty
            ? (DichVuDongBo.dungChung.sieuThiDangChon.map { "ĐMX \($0.tenSieuThi.uppercased())" } ?? "ĐIỆN MÁY XANH")
            : dl.thongTinDonVi.uppercased()
        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)

        let skRaw = dl.sucKhoeBoSungNhanVien[tongHop.nhanVien.maNV]
            ?? kho.sucKhoeBoSungNhanVienThang(cho: ngay)[tongHop.nhanVien.maNV]
        let sk: DuLieuSucKhoeBoSungNV? = {
            guard var s = skRaw else { return nil }
            let sl = s.soLuotBillBanHang ?? 0
            if abs(sl - sl.rounded()) > 0.01 {
                s.doanhThuQDSucKhoe = nil
                s.soLuotBillBanHang = nil
                s.phanTramQuyDoi = nil
            }
            return s
        }()
        let hienThiNS = kho.caiDat.hienThiNangSuatNhanVien
        let danhSachMon = tongHop.cacMonGiao

        let fontTenMon = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        let caoHeaderBang: CGFloat = 38
        let cacCaoDong: [CGFloat] = danhSachMon.isEmpty
            ? [52]
            : danhSachMon.map { m in
                let chuoiTen = "\(m.tenNganhHang) (\(m.loaiChiTieu.maThe))"
                let rectTen = (chuoiTen as NSString).boundingRect(
                    with: CGSize(width: max(60, cacRong[1] - 12), height: CGFloat.greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: [.font: fontTenMon],
                    context: nil
                )
                return max(44, ceil(rectTen.height) + 16)
            }
        let tongCaoBang = caoHeaderBang + cacCaoDong.reduce(0, +)

        let hienKhungGioCong = (cheDo == .luyKe || tongHop.gioCongTaiST > 0.001 || tongHop.gioCongHoTro > 0.001)
        let caoHeader: CGFloat = 48
        let caoTienDo: CGFloat = 46
        let caoKhungDT: CGFloat = 196
        let caoKhungGC: CGFloat = hienKhungGioCong ? 116 : 0
        let caoKhungNS: CGFloat = 120
        let caoHangKPI: CGFloat = 76
        let khoangCach: CGFloat = 10

        let caoAnh = le + caoHeader + khoangCach + caoTienDo + khoangCach + caoKhungDT + (hienKhungGioCong ? (khoangCach + caoKhungGC) : 0) + khoangCach + caoKhungNS + khoangCach + caoHangKPI + khoangCach + tongCaoBang + le

        let pLeft = NSMutableParagraphStyle()
        pLeft.alignment = .left
        pLeft.lineBreakMode = .byWordWrapping

        let pRight = NSMutableParagraphStyle()
        pRight.alignment = .right
        pRight.lineBreakMode = .byTruncatingTail

        let pCenter = NSMutableParagraphStyle()
        pCenter.alignment = .center
        pCenter.lineBreakMode = .byWordWrapping

        func veTheChiSo(
            in cg: CGContext,
            rect: CGRect,
            tieuDe: String,
            giaTri: String,
            chuoiTB: String,
            chuoiPhu: String?,
            trangThai: TheChiSoSucKhoeView.TrangThaiThe
        ) {
            cg.saveGState()
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
            UIColor.white.setFill()
            path.fill()
            UIColor(red: 0.90, green: 0.93, blue: 0.96, alpha: 1).setStroke()
            path.lineWidth = 1
            path.stroke()
            path.addClip()

            let mauVach: UIColor
            let chuTB: String
            let mauNenTB: UIColor
            let mauChuTB: UIColor
            switch trangThai {
            case .dat:
                mauVach = UIColor(red: 0.06, green: 0.65, blue: 0.38, alpha: 1)
                chuTB = " ↑ \(chuoiTB) "
                mauNenTB = UIColor(red: 0.84, green: 0.97, blue: 0.90, alpha: 1)
                mauChuTB = UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1)
            case .chuaDat:
                mauVach = UIColor(red: 0.86, green: 0.16, blue: 0.16, alpha: 1)
                chuTB = " ↓ \(chuoiTB) "
                mauNenTB = UIColor(red: 0.99, green: 0.88, blue: 0.88, alpha: 1)
                mauChuTB = UIColor(red: 0.74, green: 0.12, blue: 0.12, alpha: 1)
            case .chuaCoSo:
                mauVach = UIColor(red: 0.75, green: 0.80, blue: 0.86, alpha: 1)
                chuTB = " \(chuoiTB) "
                mauNenTB = UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1)
                mauChuTB = UIColor(red: 0.42, green: 0.48, blue: 0.58, alpha: 1)
            }

            mauVach.setFill()
            cg.fill(CGRect(x: rect.minX, y: rect.minY, width: 4, height: rect.height))

            let fontTD = UIFont.systemFont(ofSize: 10.5, weight: .bold)
            (tieuDe as NSString).draw(
                in: CGRect(x: rect.minX + 12, y: rect.minY + 9, width: rect.width - 20, height: 24),
                withAttributes: [
                    .font: fontTD,
                    .foregroundColor: UIColor(red: 0.35, green: 0.42, blue: 0.52, alpha: 1),
                    .paragraphStyle: pLeft
                ]
            )

            let fontTB = UIFont.systemFont(ofSize: 10.0, weight: .bold)
            let sizeTB = (chuTB as NSString).size(withAttributes: [.font: fontTB])
            let wTB = min(rect.width * 0.56, ceil(sizeTB.width) + 8)
            let rTB = CGRect(x: rect.minX + 12, y: rect.maxY - 28, width: wTB, height: 20)
            mauNenTB.setFill()
            UIBezierPath(roundedRect: rTB, cornerRadius: 5).fill()
            (chuTB as NSString).draw(
                in: CGRect(x: rTB.minX, y: rTB.minY + 4, width: rTB.width, height: 14),
                withAttributes: [
                    .font: fontTB,
                    .foregroundColor: mauChuTB,
                    .paragraphStyle: pCenter
                ]
            )

            if let phu = chuoiPhu, !phu.isEmpty {
                let chuPhu = " \(phu) "
                let fontPhu = UIFont.systemFont(ofSize: 9.5, weight: .semibold)
                let sizePhu = (chuPhu as NSString).size(withAttributes: [.font: fontPhu])
                let wPhu = ceil(sizePhu.width) + 6
                let rPhu = CGRect(x: rTB.maxX + 4, y: rect.maxY - 28, width: wPhu, height: 20)
                UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1).setFill()
                UIBezierPath(roundedRect: rPhu, cornerRadius: 5).fill()
                (chuPhu as NSString).draw(
                    in: CGRect(x: rPhu.minX, y: rPhu.minY + 4, width: rPhu.width, height: 14),
                    withAttributes: [
                        .font: fontPhu,
                        .foregroundColor: UIColor(red: 0.38, green: 0.44, blue: 0.54, alpha: 1),
                        .paragraphStyle: pCenter
                    ]
                )
            }

            let fontGT = UIFont.monospacedDigitSystemFont(ofSize: 17.5, weight: .heavy)
            let mauGT = trangThai == .chuaCoSo
                ? UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1)
                : UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1)
            (giaTri as NSString).draw(
                in: CGRect(x: rect.minX + 80, y: rect.maxY - 31, width: rect.width - 90, height: 24),
                withAttributes: [
                    .font: fontGT,
                    .foregroundColor: mauGT,
                    .paragraphStyle: pRight
                ]
            )
            cg.restoreGState()
        }

        func veTheKPI(
            in cg: CGContext,
            rect: CGRect,
            tieuDe: String,
            giaTri: String,
            phuDe: String,
            mauBatDau: UIColor,
            mauKetThuc: UIColor
        ) {
            cg.saveGState()
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
            path.addClip()
            if let grad = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [mauBatDau.cgColor, mauKetThuc.cgColor] as CFArray,
                locations: [0.0, 1.0]
            ) {
                cg.drawLinearGradient(
                    grad,
                    start: CGPoint(x: rect.minX, y: rect.minY),
                    end: CGPoint(x: rect.maxX, y: rect.maxY),
                    options: []
                )
            } else {
                mauBatDau.setFill()
                cg.fill(rect)
            }

            let yTieuDe: CGFloat = rect.minY + 4
            let caoTieuDe = round(rect.height * 0.27)
            let yGiaTri = yTieuDe + caoTieuDe
            let caoGiaTri = round(rect.height * 0.38)
            let yVach = yGiaTri + caoGiaTri + 1
            let yPhu = yVach + 3

            UIColor.white.withAlphaComponent(0.12).setFill()
            cg.fill(CGRect(x: rect.minX + 3.5, y: rect.minY, width: rect.width - 3.5, height: caoTieuDe + 4))
            UIColor.white.withAlphaComponent(0.72).setFill()
            cg.fill(CGRect(x: rect.minX, y: rect.minY, width: 3.5, height: rect.height))
            UIColor.white.withAlphaComponent(0.26).setFill()
            cg.fill(CGRect(x: rect.minX + 6, y: yVach, width: rect.width - 12, height: 1))

            (tieuDe as NSString).draw(
                in: CGRect(x: rect.minX + 6, y: yTieuDe + 2, width: rect.width - 12, height: caoTieuDe),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.96),
                    .paragraphStyle: pCenter
                ]
            )
            (giaTri as NSString).draw(
                in: CGRect(x: rect.minX + 6, y: yGiaTri + 1, width: rect.width - 12, height: caoGiaTri),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 22.0, weight: .heavy),
                    .foregroundColor: UIColor.white,
                    .paragraphStyle: pCenter
                ]
            )
            (phuDe as NSString).draw(
                in: CGRect(x: rect.minX + 6, y: yPhu, width: rect.width - 12, height: max(14, rect.maxY - yPhu - 2)),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 10.5, weight: .bold),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.92),
                    .paragraphStyle: pCenter
                ]
            )
            cg.restoreGState()
        }

        let fmt = UIGraphicsImageRendererFormat.default()
        fmt.scale = 2.0
        fmt.opaque = true
        if #available(iOS 12.0, *) {
            fmt.preferredRange = .standard
        }

        return UIGraphicsImageRenderer(size: CGSize(width: rongAnh, height: caoAnh), format: fmt).image { rendererCtx in
            let cg = rendererCtx.cgContext
            UIColor.white.setFill()
            cg.fill(CGRect(x: 0, y: 0, width: rongAnh, height: caoAnh))

            var y: CGFloat = le

            // ==================== 1. HEADER ====================
            let chuPhuHeader = "\(donVi)  •  Mã NV: \(tongHop.nhanVien.maNV)  •  Ngày \(ngayStr)"
            (chuPhuHeader as NSString).draw(
                in: CGRect(x: le, y: y + 2, width: rongNoiDung - 210, height: 18),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 11.5, weight: .bold),
                    .foregroundColor: UIColor(red: 0.40, green: 0.46, blue: 0.55, alpha: 1),
                    .paragraphStyle: pLeft
                ]
            )

            let chuHangBadge = " 🏆 Hạng \(hangNV)/\(soNVQuanLy) • \(cheDo.tieuDe) "
            let fontHang = UIFont.systemFont(ofSize: 11.0, weight: .heavy)
            let sizeHang = (chuHangBadge as NSString).size(withAttributes: [.font: fontHang])
            let wHang = ceil(sizeHang.width) + 10
            let rHang = CGRect(x: le + rongNoiDung - wHang, y: y, width: wHang, height: 22)
            UIColor(red: 0.91, green: 0.95, blue: 1.0, alpha: 1).setFill()
            UIBezierPath(roundedRect: rHang, cornerRadius: 6).fill()
            (chuHangBadge as NSString).draw(
                in: CGRect(x: rHang.minX, y: rHang.minY + 4, width: rHang.width, height: 16),
                withAttributes: [
                    .font: fontHang,
                    .foregroundColor: BangMauBCTD.xanhChuDaoDam,
                    .paragraphStyle: pCenter
                ]
            )

            let chuTieuDeChinh = "SỨC KHỎE CHI TIẾT: \(tongHop.nhanVien.hoTen.uppercased())"
            (chuTieuDeChinh as NSString).draw(
                in: CGRect(x: le, y: y + 23, width: rongNoiDung, height: 25),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 19.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1),
                    .paragraphStyle: pLeft
                ]
            )
            y += caoHeader + khoangCach

            // ==================== 1A. THANH TIẾN ĐỘ THÁNG ====================
            let rTienDo = CGRect(x: le, y: y, width: rongNoiDung, height: caoTienDo)
            let pathTD = UIBezierPath(roundedRect: rTienDo, cornerRadius: 10)
            UIColor.white.setFill()
            pathTD.fill()
            UIColor(red: 0.86, green: 0.89, blue: 0.94, alpha: 1).setStroke()
            pathTD.lineWidth = 1
            pathTD.stroke()

            let attrTD = NSMutableAttributedString(
                string: "Tiến độ tháng   ",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12.0, weight: .semibold),
                    .foregroundColor: UIColor(red: 0.35, green: 0.42, blue: 0.52, alpha: 1)
                ]
            )
            attrTD.append(NSAttributedString(
                string: "Ngày \(soNgayQua) / \(tongNgayThang)",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1)
                ]
            ))
            attrTD.draw(in: CGRect(x: rTienDo.minX + 12, y: rTienDo.minY + 8, width: 320, height: 18))

            let chuPTTD = String(format: "%.1f%%", ptTienDo)
            (chuPTTD as NSString).draw(
                in: CGRect(x: rTienDo.maxX - 112, y: rTienDo.minY + 8, width: 100, height: 18),
                withAttributes: [
                    .font: UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1),
                    .paragraphStyle: pRight
                ]
            )

            let rTrackTD = CGRect(x: rTienDo.minX + 12, y: rTienDo.minY + 31, width: rTienDo.width - 24, height: 6)
            UIColor(red: 0.91, green: 0.93, blue: 0.97, alpha: 1).setFill()
            UIBezierPath(roundedRect: rTrackTD, cornerRadius: 3).fill()

            let tyLeTD = CGFloat(min(1.0, max(0.02, ptTienDo / 100.0)))
            let rFillTD = CGRect(x: rTrackTD.minX, y: rTrackTD.minY, width: rTrackTD.width * tyLeTD, height: 6)
            UIColor(red: 0.14, green: 0.39, blue: 0.92, alpha: 1).setFill()
            UIBezierPath(roundedRect: rFillTD, cornerRadius: 3).fill()

            y += caoTienDo + khoangCach

            // ==================== 1B. KHỐI DOANH THU 6 MỤC ====================
            let rKhungDT = CGRect(x: le, y: y, width: rongNoiDung, height: caoKhungDT)
            let pathDT = UIBezierPath(roundedRect: rKhungDT, cornerRadius: 12)
            UIColor(red: 0.94, green: 0.97, blue: 1.0, alpha: 1).setFill()
            pathDT.fill()
            UIColor(red: 0.82, green: 0.89, blue: 0.98, alpha: 1).setStroke()
            pathDT.lineWidth = 1
            pathDT.stroke()

            let dsCoDT = dsTatCaNV.filter { abs($0.doanhThuQD) > 0.001 || abs($0.soLuongDon) > 0.001 }
            let tbDTQDTuBang: Double? = !dsCoDT.isEmpty
                ? (dsCoDT.map(\.doanhThuQD).reduce(0, +) / Double(dsCoDT.count))
                : nil
            let tbBillTuBang: Double? = !dsCoDT.isEmpty
                ? (dsCoDT.map(\.soLuongDon).reduce(0, +) / Double(dsCoDT.count))
                : nil
            let tbQuyDoiTuBang: Double? = !dsCoDT.isEmpty
                ? (dsCoDT.map(\.phanTramTiTrong).reduce(0, +) / Double(dsCoDT.count))
                : nil

            let dtQD: Double = {
                if abs(tongHop.doanhThuQD) > 0.0001 { return tongHop.doanhThuQD }
                if let v = sk?.doanhThuQDSucKhoe, abs(v) > 0.0001 { return v }
                return 0
            }()
            let tbDTQD = sk?.tbDoanhThuQDSieuThi ?? tbDTQDTuBang
            let mtQD = (sk?.mucTieuTargetQD ?? 0) > 40 ? (sk?.mucTieuTargetQD ?? 0) : ((tongHop.doanhThuCaNhan?.target ?? 0) > 40 ? (tongHop.doanhThuCaNhan?.target ?? 0) : 0)
            let ptTarget: Double = {
                if let v = sk?.phanTramTarget, abs(v) > 0.0001 { return v }
                if mtQD > 0 && abs(dtQD) > 0.0001 { return (dtQD / mtQD) * 100.0 }
                return tongHop.doanhThuCaNhan?.phanTramHT ?? 0
            }()
            let tbTarget = sk?.tbPhanTramTarget
            let soBill: Double = {
                if abs(tongHop.soLuongDon) > 0.0001 { return tongHop.soLuongDon }
                if let v = sk?.soLuotBillBanHang, abs(v) > 0.0001 { return v }
                return 0
            }()
            let tbBill = sk?.tbSoLuotBillBanHang ?? tbBillTuBang
            let ptQuyDoi: Double = {
                if abs(tongHop.phanTramTiTrong) > 0.0001 { return tongHop.phanTramTiTrong }
                if let v = sk?.phanTramQuyDoi, abs(v) > 0.0001 { return v }
                return 0
            }()
            let tbQuyDoi = sk?.tbPhanTramQuyDoi ?? tbQuyDoiTuBang
            let ptTraCham = (sk?.phanTramTraCham ?? 0) > 0 ? (sk?.phanTramTraCham ?? 0) : max(0, tongHop.doanhThuCaNhan?.phanTramTraGop ?? 0)
            let tbTraCham = sk?.tbPhanTramTraCham
            let ptBanKem = max(0, sk?.phanTramBanKem ?? 0)
            let tbBanKem = sk?.tbPhanTramBanKem

            func trangThaiSoVoiTB(_ giaTri: Double, _ tb: Double?) -> TheChiSoSucKhoeView.TrangThaiThe {
                if let tb = tb, tb > 0 {
                    return giaTri >= tb - 0.001 ? .dat : .chuaDat
                }
                return giaTri > 0 ? .dat : (giaTri < 0 ? .chuaDat : .chuaCoSo)
            }

            let ttDT1 = trangThaiSoVoiTB(dtQD, tbDTQD)
            let ttDT2 = trangThaiSoVoiTB(ptTarget, tbTarget)
            let ttDT3 = trangThaiSoVoiTB(soBill, tbBill)
            let ttDT4 = trangThaiSoVoiTB(ptQuyDoi, tbQuyDoi)
            let ttDT5 = trangThaiSoVoiTB(ptTraCham, tbTraCham)
            let ttDT6 = trangThaiSoVoiTB(ptBanKem, tbBanKem)
            let soMucDatDT = [ttDT1, ttDT2, ttDT3, ttDT4, ttDT5, ttDT6].filter { $0 == .dat }.count

            ("DOANH THU (\(cheDo.tieuDe.uppercased()))" as NSString).draw(
                in: CGRect(x: rKhungDT.minX + 10, y: rKhungDT.minY + 11, width: 170, height: 18),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 12.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.08, green: 0.32, blue: 0.78, alpha: 1),
                    .paragraphStyle: pLeft
                ]
            )
            let rDemDT = CGRect(x: rKhungDT.minX + 184, y: rKhungDT.minY + 10, width: 32, height: 18)
            UIColor.white.setFill()
            UIBezierPath(roundedRect: rDemDT, cornerRadius: 6).fill()
            ("\(soMucDatDT)/6" as NSString).draw(
                in: CGRect(x: rDemDT.minX, y: rDemDT.minY + 2, width: rDemDT.width, height: 15),
                withAttributes: [
                    .font: UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.08, green: 0.32, blue: 0.78, alpha: 1),
                    .paragraphStyle: pCenter
                ]
            )

            let gapThe: CGFloat = 8
            let rongThe3 = (rKhungDT.width - 20 - gapThe * 2) / 3.0
            let caoTheChiSo: CGFloat = 68
            let yHangDT1 = rKhungDT.minY + 34
            let yHangDT2 = yHangDT1 + caoTheChiSo + 8

            let phuKhoanVay: String? = abs(tongHop.dtQDKhoanVay) > 0.001 ? "Vay: \(tongHop.dtQDKhoanVay.chuoiSoMotLeVN) tr" : nil
            let dsTheDT: [(String, String, String, String?, TheChiSoSucKhoeView.TrangThaiThe)] = [
                ("DOANH THU QĐ", "\(dtQD.chuoiSoMotLeVN) tr", tbDTQD != nil ? "TB \(tbDTQD!.chuoiSoMotLeVN) tr" : "TB 0 tr", phuKhoanVay, ttDT1),
                ("% TARGET", Self.dinhDangPhanTramSucKhoe(ptTarget), tbTarget != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbTarget!))" : "TB 0%", mtQD > 0 ? "MT \(mtQD.chuoiSoMotLeVN) tr" : nil, ttDT2),
                ("SỐ LƯỢT BILL BÁN HÀNG", soBill.chuoiSoNguyenVN, tbBill != nil ? "TB \(tbBill!.chuoiSoNguyenVN)" : "TB 0", nil, ttDT3),
                ("% TỈ TRỌNG / QĐ", Self.dinhDangPhanTramSucKhoe(ptQuyDoi), tbQuyDoi != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbQuyDoi!))" : "TB 0%", nil, ttDT4),
                ("% TRẢ CHẬM", Self.dinhDangPhanTramSucKhoe(ptTraCham), tbTraCham != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbTraCham!))" : "TB 0%", nil, ttDT5),
                ("% BÁN KÈM", Self.dinhDangPhanTramSucKhoe(ptBanKem), tbBanKem != nil ? "TB \(Self.dinhDangPhanTramSucKhoe(tbBanKem!))" : "TB 0%", nil, ttDT6)
            ]

            for (idx, item) in dsTheDT.enumerated() {
                let cot = idx % 3
                let hang = idx / 3
                let xThe = rKhungDT.minX + 10 + CGFloat(cot) * (rongThe3 + gapThe)
                let yThe = hang == 0 ? yHangDT1 : yHangDT2
                veTheChiSo(
                    in: cg,
                    rect: CGRect(x: xThe, y: yThe, width: rongThe3, height: caoTheChiSo),
                    tieuDe: item.0,
                    giaTri: item.1,
                    chuoiTB: item.2,
                    chuoiPhu: item.3,
                    trangThai: item.4
                )
            }

            y += caoKhungDT + khoangCach

            // ==================== 1B-2. KHỐI GIỜ CÔNG 2 MỤC (GIỜ CÔNG TẠI ST LÀM VIỆC & GIỜ CÔNG HỖ TRỢ ST KHÁC) ====================
            let gcTaiST: Double = {
                if tongHop.gioCongTaiST > 0.0001 { return tongHop.gioCongTaiST }
                if let v = sk?.gioCongTaiST, v > 0.0001 { return v }
                if let v = tongHop.doanhThuCaNhan?.gioCong, v > 0.0001 { return v }
                return 0
            }()
            let gcHoTro: Double = {
                if tongHop.gioCongHoTro > 0.0001 { return tongHop.gioCongHoTro }
                if let v = sk?.gioCongHoTroSTKhac, v > 0.0001 { return v }
                if let v = tongHop.doanhThuCaNhan?.gioCongHoTro, v > 0.0001 { return v }
                return 0
            }()
            if hienKhungGioCong {
                let rKhungGC = CGRect(x: le, y: y, width: rongNoiDung, height: caoKhungGC)
                let pathGC = UIBezierPath(roundedRect: rKhungGC, cornerRadius: 12)
                UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1).setFill()
                pathGC.fill()
                UIColor(red: 0.80, green: 0.86, blue: 0.98, alpha: 1).setStroke()
                pathGC.lineWidth = 1
                pathGC.stroke()

                let tongGC = gcTaiST + gcHoTro
                let dsCoGC = dsTatCaNV.filter { $0.gioCongTaiST > 0.001 || $0.gioCongHoTro > 0.001 }
                let tbGCTaiST: Double? = !dsCoGC.isEmpty
                    ? (dsCoGC.map(\.gioCongTaiST).reduce(0, +) / Double(dsCoGC.count))
                    : nil
                let tbGCHoTro: Double? = !dsCoGC.isEmpty
                    ? (dsCoGC.map(\.gioCongHoTro).reduce(0, +) / Double(dsCoGC.count))
                    : nil

                let ttGC1: TheChiSoSucKhoeView.TrangThaiThe = {
                    guard gcTaiST > 0.001 else { return .chuaCoSo }
                    if let tb = tbGCTaiST, tb > 0 {
                        return gcTaiST >= tb - 0.001 ? .dat : .chuaDat
                    }
                    return .dat
                }()
                let ttGC2: TheChiSoSucKhoeView.TrangThaiThe = gcHoTro > 0.001 ? .dat : .chuaCoSo

                ("⏱️ GIỜ CÔNG (\(cheDo.tieuDe.uppercased()))" as NSString).draw(
                    in: CGRect(x: rKhungGC.minX + 10, y: rKhungGC.minY + 11, width: 175, height: 18),
                    withAttributes: [
                        .font: UIFont.systemFont(ofSize: 12.0, weight: .heavy),
                        .foregroundColor: UIColor(red: 0.14, green: 0.30, blue: 0.76, alpha: 1),
                        .paragraphStyle: pLeft
                    ]
                )
                let chuTongGC = " Tổng: \(tongGC.chuoiSoMotLeVN) giờ "
                let fontTongGC = UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .heavy)
                let wTongGC = ceil((chuTongGC as NSString).size(withAttributes: [.font: fontTongGC]).width) + 10
                let rDemGC = CGRect(x: rKhungGC.minX + 188, y: rKhungGC.minY + 10, width: wTongGC, height: 18)
                UIColor.white.setFill()
                UIBezierPath(roundedRect: rDemGC, cornerRadius: 6).fill()
                (chuTongGC as NSString).draw(
                    in: CGRect(x: rDemGC.minX, y: rDemGC.minY + 2, width: rDemGC.width, height: 15),
                    withAttributes: [
                        .font: fontTongGC,
                        .foregroundColor: UIColor(red: 0.14, green: 0.30, blue: 0.76, alpha: 1),
                        .paragraphStyle: pCenter
                    ]
                )

                let rongThe2 = (rKhungGC.width - 20 - gapThe) / 2.0
                let yHangGC = rKhungGC.minY + 36
                veTheChiSo(
                    in: cg,
                    rect: CGRect(x: rKhungGC.minX + 10, y: yHangGC, width: rongThe2, height: caoTheChiSo),
                    tieuDe: "GIỜ CÔNG TẠI ST LÀM VIỆC",
                    giaTri: "\(gcTaiST.chuoiSoMotLeVN) giờ",
                    chuoiTB: tbGCTaiST != nil ? "TB \(tbGCTaiST!.chuoiSoMotLeVN)h" : "TB 0,0h",
                    chuoiPhu: "ST làm việc",
                    trangThai: ttGC1
                )
                veTheChiSo(
                    in: cg,
                    rect: CGRect(x: rKhungGC.minX + 10 + rongThe2 + gapThe, y: yHangGC, width: rongThe2, height: caoTheChiSo),
                    tieuDe: "GIỜ CÔNG HỖ TRỢ ST KHÁC",
                    giaTri: "\(gcHoTro.chuoiSoMotLeVN) giờ",
                    chuoiTB: tbGCHoTro != nil ? "TB \(tbGCHoTro!.chuoiSoMotLeVN)h" : "TB 0,0h",
                    chuoiPhu: "Tổng: \(tongGC.chuoiSoMotLeVN)h",
                    trangThai: ttGC2
                )

                y += caoKhungGC + khoangCach
            }

            // ==================== 1C. KHỐI NĂNG SUẤT 3 MỤC ====================
            let rKhungNS = CGRect(x: le, y: y, width: rongNoiDung, height: caoKhungNS)
            let pathNS = UIBezierPath(roundedRect: rKhungNS, cornerRadius: 12)
            UIColor(red: 0.93, green: 0.98, blue: 0.96, alpha: 1).setFill()
            pathNS.fill()
            UIColor(red: 0.78, green: 0.92, blue: 0.85, alpha: 1).setStroke()
            pathNS.lineWidth = 1
            pathNS.stroke()

            let erp = max(0, sk?.diemThuongERP ?? 0)
            let tbErp = sk?.tbDiemThuongERP
            let erpGC = max(0, sk?.diemThuongTrenGioCong ?? 0)
            let tbErpGC = sk?.tbDiemThuongTrenGioCong
            let dtGC: Double = {
                if let v = sk?.dtqdTrenGioCong, v > 0.0001 { return v }
                if dtQD > 0.001 && gcTaiST > 0.001 {
                    return ((dtQD / gcTaiST) * 100.0).rounded() / 100.0
                }
                return 0
            }()
            let tbDtGC = sk?.tbDtqdTrenGioCong

            func trangThaiNS(_ giaTri: Double, _ tb: Double?) -> TheChiSoSucKhoeView.TrangThaiThe {
                guard hienThiNS else { return .chuaCoSo }
                if let tb = tb, tb > 0 {
                    return giaTri >= tb - 0.001 ? .dat : .chuaDat
                }
                return giaTri > 0 ? .dat : .chuaCoSo
            }

            let ttNS1 = trangThaiNS(erp, tbErp)
            let ttNS2 = trangThaiNS(erpGC, tbErpGC)
            let ttNS3 = trangThaiNS(dtGC, tbDtGC)
            let soDatNS = [ttNS1, ttNS2, ttNS3].filter { $0 == .dat }.count

            ("NĂNG SUẤT" as NSString).draw(
                in: CGRect(x: rKhungNS.minX + 10, y: rKhungNS.minY + 11, width: 78, height: 18),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 12.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1),
                    .paragraphStyle: pLeft
                ]
            )
            let rDemNS = CGRect(x: rKhungNS.minX + 90, y: rKhungNS.minY + 10, width: 32, height: 18)
            UIColor.white.setFill()
            UIBezierPath(roundedRect: rDemNS, cornerRadius: 6).fill()
            ((hienThiNS ? "\(soDatNS)/3" : "*") as NSString).draw(
                in: CGRect(x: rDemNS.minX, y: rDemNS.minY + 2, width: rDemNS.width, height: 15),
                withAttributes: [
                    .font: UIFont.monospacedDigitSystemFont(ofSize: 11.0, weight: .heavy),
                    .foregroundColor: UIColor(red: 0.05, green: 0.48, blue: 0.28, alpha: 1),
                    .paragraphStyle: pCenter
                ]
            )

            let dsTheNS: [(String, String, String, TheChiSoSucKhoeView.TrangThaiThe)] = [
                ("ĐIỂM THƯỞNG ERP", hienThiNS ? erp.chuoiSoNguyenVN : "*", hienThiNS ? (tbErp != nil ? "TB \(tbErp!.chuoiSoNguyenVN)" : "TB 0") : "TB *", ttNS1),
                ("ĐIỂM THƯỞNG / GIỜ CÔNG", hienThiNS ? erpGC.chuoiSoNguyenVN : "*", hienThiNS ? (tbErpGC != nil ? "TB \(tbErpGC!.chuoiSoNguyenVN)" : "TB 0") : "TB *", ttNS2),
                ("DTQĐ / GIỜ CÔNG", hienThiNS ? dtGC.chuoiSoVN : "*", hienThiNS ? (tbDtGC != nil ? "TB \(tbDtGC!.chuoiSoVN)" : "TB 0") : "TB *", ttNS3)
            ]

            let yHangNS = rKhungNS.minY + 36
            for (idx, item) in dsTheNS.enumerated() {
                let xThe = rKhungNS.minX + 10 + CGFloat(idx) * (rongThe3 + gapThe)
                veTheChiSo(
                    in: cg,
                    rect: CGRect(x: xThe, y: yHangNS, width: rongThe3, height: caoTheChiSo),
                    tieuDe: item.0,
                    giaTri: item.1,
                    chuoiTB: item.2,
                    chuoiPhu: nil,
                    trangThai: item.3
                )
            }

            y += caoKhungNS + khoangCach

            // ==================== 2. HAI THẺ KPI THI ĐUA ====================
            let tongMon = tongHop.tongMonGiao
            let soMonDat = tongHop.soMonDat
            let soMonChua = max(0, tongMon - soMonDat)
            let soMonGanDat = tongHop.cacMonGiao.filter { !$0.daDat && $0.phanTramHT >= 70.0 }.count
            let tyLeMon = tongMon > 0 ? Int(round(Double(soMonDat) / Double(tongMon) * 100.0)) : 0

            let rongKPI = (rongNoiDung - 8) / 2.0
            veTheKPI(
                in: cg,
                rect: CGRect(x: le, y: y, width: rongKPI, height: caoHangKPI),
                tieuDe: "🏆 MÔN THI ĐUA HOÀN THÀNH",
                giaTri: "\(soMonDat)/\(tongMon)",
                phuDe: "HOÀN THÀNH: \(tyLeMon)% SỐ MÔN",
                mauBatDau: UIColor(red: 0.95, green: 0.56, blue: 0.05, alpha: 1),
                mauKetThuc: UIColor(red: 0.86, green: 0.44, blue: 0.02, alpha: 1)
            )
            veTheKPI(
                in: cg,
                rect: CGRect(x: le + rongKPI + 8, y: y, width: rongKPI, height: caoHangKPI),
                tieuDe: "📈 % HT THI ĐUA TRUNG BÌNH",
                giaTri: tongHop.phanTramHTTB.chuoiPhanTramVN,
                phuDe: "ĐẠT \(soMonDat) • GẦN ĐẠT \(soMonGanDat) • CHƯA \(soMonChua)",
                mauBatDau: UIColor(red: 0.55, green: 0.31, blue: 0.95, alpha: 1),
                mauKetThuc: UIColor(red: 0.45, green: 0.22, blue: 0.88, alpha: 1)
            )

            y += caoHangKPI + khoangCach

            // ==================== 3. BẢNG CHI TIẾT CÁC MÔN THI ĐUA ====================
            let rBang = CGRect(x: le, y: y, width: rongNoiDung, height: tongCaoBang)
            cg.saveGState()
            let pathBang = UIBezierPath(roundedRect: rBang, cornerRadius: 10)
            UIColor.white.setFill()
            pathBang.fill()
            pathBang.addClip()

            let rHeader = CGRect(x: rBang.minX, y: rBang.minY, width: rBang.width, height: caoHeaderBang)
            UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1).setFill()
            cg.fill(rHeader)

            let tieuDeCot = ["#", "MÔN THI ĐUA", "THỰC HIỆN", "TARGET", "% HT", "% HT ST", "CÒN LẠI", "TIẾN ĐỘ"]
            let fontHeaderCot = UIFont.systemFont(ofSize: 10.5, weight: .heavy)
            let mauHeaderCot = UIColor(red: 0.25, green: 0.31, blue: 0.40, alpha: 1)
            var xH: CGFloat = rBang.minX
            for (i, chu) in tieuDeCot.enumerated() {
                let w = cacRong[i]
                let align: NSMutableParagraphStyle = (i == 1) ? pLeft : (i == 2 || i == 3 || i == 6 ? pRight : pCenter)
                (chu as NSString).draw(
                    in: CGRect(x: xH + 4, y: rHeader.minY + 11, width: w - 8, height: 18),
                    withAttributes: [
                        .font: fontHeaderCot,
                        .foregroundColor: mauHeaderCot,
                        .paragraphStyle: align
                    ]
                )
                xH += w
            }
            UIColor(red: 0.84, green: 0.88, blue: 0.93, alpha: 1).setFill()
            cg.fill(CGRect(x: rBang.minX, y: rHeader.maxY - 1, width: rBang.width, height: 1))

            if danhSachMon.isEmpty {
                ("Không có môn thi đua nào." as NSString).draw(
                    in: CGRect(x: rBang.minX, y: rHeader.maxY + 16, width: rBang.width, height: 22),
                    withAttributes: [
                        .font: UIFont.systemFont(ofSize: 12.5, weight: .medium),
                        .foregroundColor: UIColor(red: 0.45, green: 0.51, blue: 0.60, alpha: 1),
                        .paragraphStyle: pCenter
                    ]
                )
            } else {
                let fontSo = UIFont.monospacedDigitSystemFont(ofSize: 12.0, weight: .bold)
                var yDong: CGFloat = rHeader.maxY
                for (idx, m) in danhSachMon.enumerated() {
                    let caoDong = cacCaoDong[idx]
                    let rDong = CGRect(x: rBang.minX, y: yDong, width: rBang.width, height: caoDong)

                    let mauNenDong: UIColor
                    if m.daDat {
                        mauNenDong = UIColor(red: 0.93, green: 0.99, blue: 0.95, alpha: 1)
                    } else if m.phanTramHT >= 70.0 {
                        mauNenDong = UIColor(red: 1.0, green: 0.98, blue: 0.92, alpha: 1)
                    } else {
                        mauNenDong = (idx % 2 == 0)
                            ? UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 0.65)
                            : UIColor(red: 1.0, green: 0.94, blue: 0.95, alpha: 0.85)
                    }
                    mauNenDong.setFill()
                    cg.fill(rDong)

                    var xCot: CGFloat = rBang.minX
                    let ySo = yDong + (caoDong - 16) / 2.0

                    for i in 0..<cacRong.count {
                        let w = cacRong[i]
                        switch i {
                        case 0:
                            ("\(idx + 1)" as NSString).draw(
                                in: CGRect(x: xCot, y: ySo, width: w, height: 18),
                                withAttributes: [
                                    .font: fontSo,
                                    .foregroundColor: UIColor(red: 0.42, green: 0.48, blue: 0.56, alpha: 1),
                                    .paragraphStyle: pCenter
                                ]
                            )
                        case 1:
                            let chuTen = "\(m.tenNganhHang) (\(m.loaiChiTieu.maThe))" as NSString
                            let rText = chuTen.boundingRect(
                                with: CGSize(width: w - 12, height: caoDong),
                                options: [.usesLineFragmentOrigin, .usesFontLeading],
                                attributes: [.font: fontTenMon],
                                context: nil
                            )
                            let yTen = yDong + max(4, (caoDong - ceil(rText.height)) / 2.0)
                            chuTen.draw(
                                in: CGRect(x: xCot + 6, y: yTen, width: w - 12, height: ceil(rText.height) + 2),
                                withAttributes: [
                                    .font: fontTenMon,
                                    .foregroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1),
                                    .paragraphStyle: pLeft
                                ]
                            )
                        case 2:
                            (m.thucHien.chuoiSoVN as NSString).draw(
                                in: CGRect(x: xCot + 6, y: ySo, width: w - 12, height: 18),
                                withAttributes: [
                                    .font: fontSo,
                                    .foregroundColor: UIColor(red: 0.08, green: 0.12, blue: 0.20, alpha: 1),
                                    .paragraphStyle: pRight
                                ]
                            )
                        case 3:
                            (m.targetCaNhan.chuoiSoVN as NSString).draw(
                                in: CGRect(x: xCot + 6, y: ySo, width: w - 12, height: 18),
                                withAttributes: [
                                    .font: fontSo,
                                    .foregroundColor: UIColor(red: 0.40, green: 0.46, blue: 0.55, alpha: 1),
                                    .paragraphStyle: pRight
                                ]
                            )
                        case 4:
                            let rPill = CGRect(x: xCot + 5, y: yDong + (caoDong - 24) / 2.0, width: w - 10, height: 24)
                            let mauNenPill: UIColor
                            let mauChuPill: UIColor
                            if m.daDat {
                                mauNenPill = UIColor(red: 0.82, green: 0.96, blue: 0.87, alpha: 1)
                                mauChuPill = UIColor(red: 0.05, green: 0.48, blue: 0.24, alpha: 1)
                            } else if m.phanTramHT >= 70.0 {
                                mauNenPill = UIColor(red: 0.99, green: 0.92, blue: 0.76, alpha: 1)
                                mauChuPill = UIColor(red: 0.72, green: 0.36, blue: 0.04, alpha: 1)
                            } else {
                                mauNenPill = UIColor(red: 0.98, green: 0.84, blue: 0.86, alpha: 1)
                                mauChuPill = UIColor(red: 0.76, green: 0.12, blue: 0.16, alpha: 1)
                            }
                            mauNenPill.setFill()
                            UIBezierPath(roundedRect: rPill, cornerRadius: 6).fill()
                            (m.phanTramHT.chuoiPhanTramVN as NSString).draw(
                                in: CGRect(x: rPill.minX, y: rPill.minY + 5, width: rPill.width, height: 16),
                                withAttributes: [
                                    .font: UIFont.monospacedDigitSystemFont(ofSize: 11.5, weight: .heavy),
                                    .foregroundColor: mauChuPill,
                                    .paragraphStyle: pCenter
                                ]
                            )
                        case 5:
                            (m.phanTramSieuThi.chuoiPhanTramVN as NSString).draw(
                                in: CGRect(x: xCot + 4, y: ySo, width: w - 8, height: 18),
                                withAttributes: [
                                    .font: fontSo,
                                    .foregroundColor: UIColor(red: 0.42, green: 0.48, blue: 0.56, alpha: 1),
                                    .paragraphStyle: pCenter
                                ]
                            )
                        case 6:
                            let chuConLai: String
                            let mauConLai: UIColor
                            if m.conLai <= 0.005 {
                                let vuot = abs(m.conLai)
                                chuConLai = vuot > 0.005 ? "+\(vuot.chuoiSoVN)" : "0,00"
                                mauConLai = UIColor(red: 0.05, green: 0.50, blue: 0.24, alpha: 1)
                            } else {
                                chuConLai = m.conLai.chuoiSoVN
                                mauConLai = UIColor(red: 0.78, green: 0.12, blue: 0.16, alpha: 1)
                            }
                            (chuConLai as NSString).draw(
                                in: CGRect(x: xCot + 6, y: ySo, width: w - 12, height: 18),
                                withAttributes: [
                                    .font: fontSo,
                                    .foregroundColor: mauConLai,
                                    .paragraphStyle: pRight
                                ]
                            )
                        case 7:
                            let leThanh: CGFloat = 10
                            let rongTrack = w - leThanh * 2
                            let yTrack = yDong + (caoDong - 6) / 2.0
                            let rTrack = CGRect(x: xCot + leThanh, y: yTrack, width: rongTrack, height: 6)
                            UIColor(red: 0.89, green: 0.91, blue: 0.95, alpha: 1).setFill()
                            UIBezierPath(roundedRect: rTrack, cornerRadius: 3).fill()

                            let mauTienDo: UIColor = m.daDat
                                ? UIColor(red: 0.08, green: 0.62, blue: 0.30, alpha: 1)
                                : (m.phanTramHT >= 70.0
                                    ? UIColor(red: 0.95, green: 0.56, blue: 0.05, alpha: 1)
                                    : UIColor(red: 0.84, green: 0.16, blue: 0.20, alpha: 1))
                            let pct = CGFloat(min(1.0, max(0.04, m.phanTramHT / 100.0)))
                            let rFill = CGRect(x: rTrack.minX, y: rTrack.minY, width: rongTrack * pct, height: 6)
                            mauTienDo.setFill()
                            UIBezierPath(roundedRect: rFill, cornerRadius: 3).fill()

                            let rCham = CGRect(x: xCot + leThanh - 2, y: yDong + (caoDong - 8) / 2.0, width: 8, height: 8)
                            UIBezierPath(ovalIn: rCham).fill()
                        default:
                            break
                        }
                        xCot += w
                    }

                    UIColor(red: 0.88, green: 0.90, blue: 0.94, alpha: 1).setFill()
                    cg.fill(CGRect(x: rBang.minX, y: yDong + caoDong - 0.5, width: rBang.width, height: 0.5))
                    yDong += caoDong
                }
            }

            cg.restoreGState()
            UIColor(red: 0.85, green: 0.88, blue: 0.93, alpha: 1).setStroke()
            pathBang.lineWidth = 1
            pathBang.stroke()
        }
    }
}

// MARK: - 4. Màn hình Chi tiết Sức khoẻ Cá nhân Nhân viên (Tích hợp Bảng Thông Số Sức Khỏe 27 điểm + Chuyển nhanh NV)

final class ManHinhChiTietNhanVien: UIViewController, PHPickerViewControllerDelegate, UIDocumentPickerDelegate {
    private var tongHop: TongHopNhanVien
    private let ngay: Date
    private var cheDo: LoaiCheDoDoanhThu

    private let nutChonNV = UIButton(type: .system)
    private let nutNVTruoc = UIButton(type: .system)
    private let nutNVSau = UIButton(type: .system)
    private let chonCheDo = UISegmentedControl(items: ["Lũy kế", "Realtime"])
    private let nutUploadAnhNV = UIButton(type: .system)
    private let nutXoaDuLieuNV = UIButton(type: .system)
    private let cuonDoc = UIScrollView()
    private var bangThongSoView: BangThongSoSucKhoeNhanVienView!

    init(_ tongHop: TongHopNhanVien, ngay: Date = Date(), cheDo: LoaiCheDoDoanhThu = .luyKe) {
        self.ngay = ngay
        self.cheDo = cheDo
        self.tongHop = tongHop
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        capNhatTieuDe()
        view.backgroundColor = BangMauBCTD.nenTrang
        let nutChiaSe = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(bamChiaSeAnhSucKhoe)
        )
        let nutQuetAnh = UIBarButtonItem(
            image: UIImage(systemName: "camera.viewfinder"),
            style: .plain,
            target: self,
            action: #selector(bamQuetAnhSucKhoeNV)
        )
        navigationItem.rightBarButtonItems = [nutChiaSe, nutQuetAnh]
        taoGiaoDien()
    }

    private func capNhatTieuDe() {
        title = "Sức khỏe: \(tongHop.nhanVien.hoTen)"
    }

    private func taoGiaoDien() {
        let thanhDieuKhien = UIView()
        thanhDieuKhien.backgroundColor = .white
        thanhDieuKhien.layer.cornerRadius = 12
        thanhDieuKhien.layer.borderWidth = 1
        thanhDieuKhien.layer.borderColor = BangMauBCTD.vienThe.cgColor

        for (nut, icon, action) in [
            (nutNVTruoc, "chevron.left", #selector(bamNVTruoc)),
            (nutNVSau, "chevron.right", #selector(bamNVSau))
        ] {
            nut.setImage(UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
            nut.tintColor = BangMauBCTD.xanhChuDaoDam
            nut.backgroundColor = BangMauBCTD.nenThePhu
            nut.layer.cornerRadius = 8
            nut.layer.borderWidth = 1
            nut.layer.borderColor = BangMauBCTD.vienDam.cgColor
            nut.widthAnchor.constraint(equalToConstant: 34).isActive = true
            nut.heightAnchor.constraint(equalToConstant: 34).isActive = true
            nut.addTarget(self, action: action, for: .touchUpInside)
        }

        nutChonNV.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        nutChonNV.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nutChonNV.backgroundColor = BangMauBCTD.nenThePhu
        nutChonNV.layer.cornerRadius = 8
        nutChonNV.layer.borderWidth = 1
        nutChonNV.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutChonNV.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        nutChonNV.addTarget(self, action: #selector(bamMoDanhSachChonNV), for: .touchUpInside)

        chonCheDo.selectedSegmentIndex = (cheDo == .realtime) ? 1 : 0
        chonCheDo.selectedSegmentTintColor = BangMauBCTD.xanhChuDao
        chonCheDo.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 11.5, weight: .bold)], for: .selected)
        chonCheDo.setTitleTextAttributes([.foregroundColor: BangMauBCTD.chuPhu, .font: UIFont.systemFont(ofSize: 11.5, weight: .semibold)], for: .normal)
        chonCheDo.addTarget(self, action: #selector(doiCheDo), for: .valueChanged)
        chonCheDo.widthAnchor.constraint(equalToConstant: 132).isActive = true

        chonCheDo.isHidden = false
        let hangTren = UIStackView(arrangedSubviews: [nutNVTruoc, nutChonNV, nutNVSau])
        hangTren.axis = .horizontal
        hangTren.spacing = 6
        hangTren.alignment = .center

        nutUploadAnhNV.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        nutUploadAnhNV.setTitle(" Nhập ảnh NV", for: .normal)
        nutUploadAnhNV.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutUploadAnhNV.titleLabel?.numberOfLines = 1
        nutUploadAnhNV.titleLabel?.lineBreakMode = .byTruncatingTail
        nutUploadAnhNV.titleLabel?.adjustsFontSizeToFitWidth = true
        nutUploadAnhNV.titleLabel?.minimumScaleFactor = 0.75
        nutUploadAnhNV.backgroundColor = BangMauBCTD.xanhChuDao
        nutUploadAnhNV.tintColor = .white
        nutUploadAnhNV.setTitleColor(.white, for: .normal)
        nutUploadAnhNV.layer.cornerRadius = 8
        nutUploadAnhNV.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutUploadAnhNV.addTarget(self, action: #selector(bamQuetAnhSucKhoeNV), for: .touchUpInside)

        nutXoaDuLieuNV.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        nutXoaDuLieuNV.setTitle(" Xoá", for: .normal)
        nutXoaDuLieuNV.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        nutXoaDuLieuNV.backgroundColor = BangMauBCTD.doYeuPill
        nutXoaDuLieuNV.tintColor = BangMauBCTD.doYeuChu
        nutXoaDuLieuNV.setTitleColor(BangMauBCTD.doYeuChu, for: .normal)
        nutXoaDuLieuNV.layer.cornerRadius = 8
        nutXoaDuLieuNV.layer.borderWidth = 1
        nutXoaDuLieuNV.layer.borderColor = BangMauBCTD.doYeuVach.withAlphaComponent(0.35).cgColor
        nutXoaDuLieuNV.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutXoaDuLieuNV.setContentHuggingPriority(.required, for: .horizontal)
        nutXoaDuLieuNV.setContentCompressionResistancePriority(.required, for: .horizontal)
        nutXoaDuLieuNV.addTarget(self, action: #selector(bamXoaDuLieuCuaNV), for: .touchUpInside)

        let hangNutUpload = UIStackView(arrangedSubviews: [chonCheDo, nutUploadAnhNV, nutXoaDuLieuNV])
        hangNutUpload.axis = .horizontal
        hangNutUpload.spacing = 6
        hangNutUpload.alignment = .fill

        let nganDieuKhien = UIStackView(arrangedSubviews: [hangTren, hangNutUpload])
        nganDieuKhien.axis = .vertical
        nganDieuKhien.spacing = 6
        nganDieuKhien.translatesAutoresizingMaskIntoConstraints = false
        thanhDieuKhien.addSubview(nganDieuKhien)

        cuonDoc.alwaysBounceVertical = true
        cuonDoc.showsVerticalScrollIndicator = true
        cuonDoc.translatesAutoresizingMaskIntoConstraints = false

        bangThongSoView = BangThongSoSucKhoeNhanVienView(tongHop: tongHop, ngay: ngay, cheDo: cheDo)
        bangThongSoView.translatesAutoresizingMaskIntoConstraints = false
        bangThongSoView.khiYeuCauCapNhat = { [weak self] in
            self?.napLaiDuLieuHienTai()
        }
        cuonDoc.addSubview(bangThongSoView)

        thanhDieuKhien.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thanhDieuKhien)
        view.addSubview(cuonDoc)

        NSLayoutConstraint.activate([
            thanhDieuKhien.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            thanhDieuKhien.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            thanhDieuKhien.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            nganDieuKhien.topAnchor.constraint(equalTo: thanhDieuKhien.topAnchor, constant: 6),
            nganDieuKhien.bottomAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: -6),
            nganDieuKhien.leadingAnchor.constraint(equalTo: thanhDieuKhien.leadingAnchor, constant: 8),
            nganDieuKhien.trailingAnchor.constraint(equalTo: thanhDieuKhien.trailingAnchor, constant: -8),

            cuonDoc.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 4),
            cuonDoc.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuonDoc.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuonDoc.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            bangThongSoView.topAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.topAnchor),
            bangThongSoView.leadingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.leadingAnchor),
            bangThongSoView.trailingAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.trailingAnchor),
            bangThongSoView.bottomAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.bottomAnchor),
            bangThongSoView.widthAnchor.constraint(equalTo: cuonDoc.frameLayoutGuide.widthAnchor)
        ])

        capNhatNutChonNV()
    }

    private func danhSachNVHienTai() -> [TongHopNhanVien] {
        KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .doanhThuQD, cheDo: cheDo)
    }

    private func capNhatNutChonNV() {
        let ds = danhSachNVHienTai()
        let idx = ds.firstIndex(where: { $0.nhanVien.maNV == tongHop.nhanVien.maNV }) ?? 0
        nutChonNV.setTitle("👤 \(idx + 1)/\(max(1, ds.count)). \(tongHop.nhanVien.hoTen) ▾", for: .normal)
        capNhatTieuDe()
    }

    private func napLaiDuLieuHienTai() {
        let ds = danhSachNVHienTai()
        if let moi = ds.first(where: { $0.nhanVien.maNV == tongHop.nhanVien.maNV }) ?? ds.first {
            tongHop = moi
        }
        capNhatNutChonNV()
        bangThongSoView.capNhat(tongHop: tongHop, ngay: ngay, cheDo: cheDo)
    }

    @objc private func doiCheDo() {
        cheDo = (chonCheDo.selectedSegmentIndex == 1) ? .realtime : .luyKe
        napLaiDuLieuHienTai()
    }

    @objc private func bamNVTruoc() {
        let ds = danhSachNVHienTai()
        guard !ds.isEmpty else { return }
        let idx = ds.firstIndex(where: { $0.nhanVien.maNV == tongHop.nhanVien.maNV }) ?? 0
        let moiIdx = (idx - 1 + ds.count) % ds.count
        tongHop = ds[moiIdx]
        capNhatNutChonNV()
        bangThongSoView.capNhat(tongHop: tongHop, ngay: ngay, cheDo: cheDo)
    }

    @objc private func bamNVSau() {
        let ds = danhSachNVHienTai()
        guard !ds.isEmpty else { return }
        let idx = ds.firstIndex(where: { $0.nhanVien.maNV == tongHop.nhanVien.maNV }) ?? 0
        let moiIdx = (idx + 1) % ds.count
        tongHop = ds[moiIdx]
        capNhatNutChonNV()
        bangThongSoView.capNhat(tongHop: tongHop, ngay: ngay, cheDo: cheDo)
    }

    @objc private func bamMoDanhSachChonNV() {
        let ds = danhSachNVHienTai()
        guard !ds.isEmpty else { return }
        var cacMuc: [MucChonDMX] = ds.enumerated().map { i, item in
            let dtStr = item.doanhThuQD > 0 ? "\(item.doanhThuQD.chuoiSoGonVN) tr" : "--"
            let gcStr = (item.gioCongTaiST > 0.001 || item.gioCongHoTro > 0.001)
                ? " • ⏱️ \(item.gioCongTaiST.chuoiSoMotLeVN)h (+\(item.gioCongHoTro.chuoiSoMotLeVN)h)"
                : ""
            return MucChonDMX(
                tieuDe: "\(i + 1). \(item.nhanVien.hoTen) (id: \(item.nhanVien.maNV)) • DT QĐ: \(dtStr)\(gcStr)",
                dangChon: item.nhanVien.maNV == tongHop.nhanVien.maNV
            ) { [weak self] in
                guard let self else { return }
                self.tongHop = item
                self.capNhatNutChonNV()
                self.bangThongSoView.capNhat(tongHop: item, ngay: self.ngay, cheDo: self.cheDo)
            }
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: "Chọn nhân viên xem Sức khỏe", cacMuc: cacMuc)
    }

    // MARK: - Xuất / Chia sẻ ảnh Sức khoẻ chi tiết

    @objc private func bamXoaDuLieuCuaNV() {
        let tenNV = tongHop.nhanVien.hoTen
        let maNV = tongHop.nhanVien.maNV
        hienMenuChon(
            tieuDe: "Xoá dữ liệu nhân viên?",
            thongDiep: "Chọn phạm vi dữ liệu muốn xoá:",
            cacMuc: [
                MucChonDMX(tieuDe: "🗑️ Xoá dữ liệu đã quét của \(tenNV) (\(maNV))", kieu: .nguyHiem) { [weak self] in
                    guard let self else { return }
                    KhoDuLieu.dungChung.xoaDuLieuMotNhanVien(maNV: maNV, cho: self.ngay)
                    self.napLaiDuLieuHienTai()
                },
                MucChonDMX(tieuDe: "🗑️ Xoá TOÀN BỘ dữ liệu của tất cả nhân viên", kieu: .nguyHiem) { [weak self] in
                    guard let self else { return }
                    KhoDuLieu.dungChung.xoaDoanhThuNhanVienLuyKeThang(cho: self.ngay, xoaCaThiDuaNV: true)
                    self.napLaiDuLieuHienTai()
                },
                MucChonDMX(tieuDe: "Huỷ", kieu: .huy)
            ]
        )
    }

    @objc private func bamQuetAnhSucKhoeNV() {
        hienMenuChon(
            tieuDe: "Nhập ảnh Sức khỏe & Thi đua NV",
            cacMuc: [
                MucChonDMX(tieuDe: "🖼️ Chọn ảnh từ Thư viện Ảnh") { [weak self] in
                    guard let self else { return }
                    var cauHinh = PHPickerConfiguration()
                    cauHinh.filter = .images
                    cauHinh.selectionLimit = 50
                    if #available(iOS 15.0, *) {
                        cauHinh.selection = .ordered
                    }
                    let picker = PHPickerViewController(configuration: cauHinh)
                    picker.delegate = self
                    self.present(picker, animated: true)
                },
                MucChonDMX(tieuDe: "📁 Nhập ảnh từ Tệp (Files)") { [weak self] in
                    guard let self else { return }
                    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
                    picker.delegate = self
                    picker.allowsMultipleSelection = true
                    self.present(picker, animated: true)
                },
                MucChonDMX(tieuDe: "Đóng", kieu: .huy)
            ]
        )
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        guard !urls.isEmpty else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var cacAnh: [UIImage] = []
            for url in urls {
                let ok = url.startAccessingSecurityScopedResource()
                defer { if ok { url.stopAccessingSecurityScopedResource() } }
                if let d = try? Data(contentsOf: url), let img = UIImage(data: d) {
                    cacAnh.append(img)
                } else if let img = UIImage(contentsOfFile: url.path) {
                    cacAnh.append(img)
                }
            }
            DispatchQueue.main.async {
                guard let self = self, !cacAnh.isEmpty else { return }
                self.thucHienQuetAnhSucKhoe(cacAnh)
            }
        }
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let nhom = DispatchGroup()
        let khoaAnh = NSLock()
        var danhSach = Array<UIImage?>(repeating: nil, count: results.count)
        for (i, r) in results.enumerated() {
            guard r.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            nhom.enter()
            r.itemProvider.loadObject(ofClass: UIImage.self) { obj, _ in
                if let img = obj as? UIImage {
                    khoaAnh.lock()
                    danhSach[i] = img
                    khoaAnh.unlock()
                }
                nhom.leave()
            }
        }
        nhom.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let cacAnh = danhSach.compactMap { $0 }
            self.thucHienQuetAnhSucKhoe(cacAnh)
        }
    }

    private func thucHienQuetAnhSucKhoe(_ cacAnh: [UIImage]) {
        guard !cacAnh.isEmpty else { return }
        var skQuetDuoc: [String: DuLieuSucKhoeBoSungNV] = [:]
        DichVuDocAnh.dungChung.quetAnhDoanhThuNhanVien(
            danhSachAnh: cacAnh,
            cheDo: cheDo,
            uuTienPhieuSucKhoe: true,
            tienTrinh: nil,
            hoanTatSucKhoe: { bangSK in
                skQuetDuoc = bangSK
            },
            hoanTat: { [weak self] dsQuet in
                guard let self else { return }
                var dl = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
                let dsQuanLy = KhoDuLieu.dungChung.caiDat.danhSachNhanVien
                let chiLaAnhGioCong = !dsQuet.isEmpty && dsQuet.allSatisfy {
                    abs($0.doanhThuQD) < 0.0001 && abs($0.soLuong) < 0.0001 && ($0.gioCong > 0.0001 || $0.gioCongHoTro > 0.0001)
                }
                if chiLaAnhGioCong {
                    KhoDuLieu.dungChung.apDungGioCongNhanVienQuetDuoc(
                        dsQuet,
                        vao: &dl,
                        ngay: self.ngay,
                        cheDo: self.cheDo
                    )
                } else if !dsQuet.isEmpty {
                    var mapDTNV: [String: DoanhThuNhanVienItem] = [:]
                    for item in KhoDuLieu.locSachDanhSachDTNV(dl.doanhThuNhanVien(theo: self.cheDo)) {
                        let ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                        if !ma.isEmpty { mapDTNV[ma] = item }
                    }
                    var daQuetTrongDot = Set<String>()
                    for item in dsQuet {
                        let ma: String
                        let ten: String
                        if !dsQuanLy.isEmpty {
                            guard let nvKhop = KhoDuLieu.khopNhanVienQuetVoiQuanLy(maQuet: item.maNV, tenQuet: item.hoTen, dsQuanLy: dsQuanLy) else { continue }
                            ma = nvKhop.maNV
                            ten = nvKhop.hoTen
                        } else {
                            ma = KhoDuLieu.chuanHoaMaNV(item.maNV)
                            ten = item.hoTen
                        }
                        guard !ma.isEmpty else { continue }
                        var capNhat = item
                        capNhat.maNV = ma
                        capNhat.hoTen = ten
                        if daQuetTrongDot.contains(ma), let daCo = mapDTNV[ma] {
                            if abs(daCo.doanhThuQD) > abs(capNhat.doanhThuQD) { continue }
                        }
                        daQuetTrongDot.insert(ma)
                        mapDTNV[ma] = capNhat
                        if self.cheDo == .luyKe {
                            var skNV = dl.sucKhoeBoSungNhanVien[ma] ?? DuLieuSucKhoeBoSungNV()
                            skNV.doanhThuQDSucKhoe = capNhat.doanhThuQD
                            skNV.soLuotBillBanHang = capNhat.soLuong
                            if abs(capNhat.phanTramQuyDoi) > 0.0001 {
                                skNV.phanTramQuyDoi = capNhat.phanTramQuyDoi
                            }
                            dl.sucKhoeBoSungNhanVien[ma] = skNV
                        }
                    }
                    dl.ganDoanhThuNhanVien(Array(mapDTNV.values), theo: self.cheDo)
                }
                if !skQuetDuoc.isEmpty {
                    let maDangXem = self.tongHop.nhanVien.maNV
                    if cacAnh.count == 1, skQuetDuoc[maDangXem] == nil, let skDau = skQuetDuoc.values.first {
                        skQuetDuoc[maDangXem] = skDau
                    }
                    KhoDuLieu.dungChung.apDungSucKhoeNhanVienQuetDuoc(
                        skQuetDuoc,
                        vao: &dl,
                        ngay: self.ngay,
                        cheDo: self.cheDo
                    )
                }
                KhoDuLieu.dungChung.luu(dl)
                self.napLaiDuLieuHienTai()

                guard dsQuet.isEmpty || cacAnh.count > 1 else { return }
                var skThiDua: [String: DuLieuSucKhoeBoSungNV] = [:]
                DichVuDocAnh.dungChung.quetAnhThiDuaNhanVien(
                    danhSachAnh: cacAnh,
                    tenNganhGoiY: nil,
                    maNVGoiY: self.tongHop.nhanVien.maNV,
                    tienTrinh: nil,
                    hoanTatSucKhoe: { bangSK in
                        skThiDua = bangSK
                    },
                    hoanTat: { [weak self] cacKhoi in
                        guard let self else { return }
                        var dl2 = KhoDuLieu.dungChung.duLieu(cho: self.ngay)
                        if !cacKhoi.isEmpty {
                            KhoDuLieu.dungChung.boSungDanhSachThiDuaTuKhoiNhanVien(
                                mangKhoiNV: cacKhoi,
                                vao: &dl2,
                                cheDo: self.cheDo
                            )
                            let bangNVMoi = KhoDuLieu.dungChung.gopKetQuaThiDuaNhanVien(
                                hienTai: dl2.thiDuaNhanVien(theo: self.cheDo),
                                mangKhoiNV: cacKhoi,
                                ngay: self.ngay,
                                cheDo: self.cheDo
                            )
                            dl2.ganThiDuaNhanVien(bangNVMoi, theo: self.cheDo)
                        }
                        if !skThiDua.isEmpty {
                            KhoDuLieu.dungChung.apDungSucKhoeNhanVienQuetDuoc(
                                skThiDua,
                                vao: &dl2,
                                ngay: self.ngay,
                                cheDo: self.cheDo
                            )
                        }
                        KhoDuLieu.dungChung.luu(dl2)
                        self.napLaiDuLieuHienTai()
                    }
                )
            }
        )
    }

    @objc private func bamChiaSeAnhSucKhoe() {
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .tenAZ, cheDo: cheDo)
        let hienNS = KhoDuLieu.dungChung.caiDat.hienThiNangSuatNhanVien

        var cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "📷 Quét ảnh Phiếu Sức khỏe / Thi đua NV") { [weak self] in
                self?.bamQuetAnhSucKhoeNV()
            },
            MucChonDMX(tieuDe: hienNS ? "☑️ Năng suất: Đang hiện số (Chạm để ẩn *)" : "⬜ Năng suất: Đang ẩn * (Chạm để hiện số)", dangChon: hienNS) { [weak self] in
                guard let self else { return }
                var cd = KhoDuLieu.dungChung.caiDat
                cd.hienThiNangSuatNhanVien.toggle()
                KhoDuLieu.dungChung.luuCaiDat(cd)
                self.napLaiDuLieuHienTai()
            },
            MucChonDMX(tieuDe: "👤 Xuất ảnh nhân viên: \(tongHop.nhanVien.hoTen)") { [weak self] in
                guard let self = self, let anh = self.taoAnhSucKhoeNhanVien() else { return }
                self.hienChiaSe([anh])
            }
        ]

        if !dsNV.isEmpty {
            cacMuc.append(MucChonDMX(tieuDe: "📚 Xuất bộ \(dsNV.count) ảnh rời tất cả NV") { [weak self] in
                guard let self = self else { return }
                let cacAnh = Self.taoTatCaAnhSucKhoe(cho: self.ngay, cheDo: self.cheDo)
                guard !cacAnh.isEmpty else { return }
                self.hienChiaSe(cacAnh)
            })
            cacMuc.append(MucChonDMX(tieuDe: "🖼️ Xuất 1 ảnh gộp tất cả \(dsNV.count) NV") { [weak self] in
                guard let self = self, let anhGop = Self.taoAnhGopTatCaSucKhoe(cho: self.ngay, cheDo: self.cheDo) else { return }
                self.hienChiaSe([anhGop])
            })
        }
        cacMuc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))

        hienMenuChon(
            tieuDe: "Xuất ảnh Sức khoẻ Nhân viên (\(cheDo.tieuDe))",
            cacMuc: cacMuc
        )
    }

    private func hienChiaSe(_ muc: [Any]) {
        let vc = UIActivityViewController(activityItems: muc, applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            if let barItem = navigationItem.rightBarButtonItems?.first ?? navigationItem.rightBarButtonItem {
                pop.barButtonItem = barItem
            } else {
                pop.sourceView = view
                pop.sourceRect = CGRect(x: view.bounds.midX, y: 80, width: 1, height: 1)
            }
        }
        present(vc, animated: true)
    }

    static func taoAnhSucKhoe(cho tongHop: TongHopNhanVien, ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> UIImage? {
        BangThongSoSucKhoeNhanVienView.taoAnhBaoCao(cho: tongHop, ngay: ngay, cheDo: cheDo)
    }

    static func taoTatCaAnhSucKhoe(cho ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> [UIImage] {
        let dsNV = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .tenAZ, cheDo: cheDo)
        return dsNV.compactMap { taoAnhSucKhoe(cho: $0, ngay: ngay, cheDo: cheDo) }
    }

    static func taoAnhGopTatCaSucKhoe(cho ngay: Date, cheDo: LoaiCheDoDoanhThu = .luyKe) -> UIImage? {
        let cacAnh = taoTatCaAnhSucKhoe(cho: ngay, cheDo: cheDo)
        guard !cacAnh.isEmpty else { return nil }
        if cacAnh.count == 1 { return cacAnh[0] }

        let soCot = cacAnh.count >= 4 ? 2 : 1
        let khoangCach: CGFloat = 16
        let rongMoiAnh = cacAnh.map { $0.size.width }.max() ?? 820
        let rong = CGFloat(soCot) * rongMoiAnh + CGFloat(soCot - 1) * khoangCach

        var cacHang: [[UIImage]] = []
        var idx = 0
        while idx < cacAnh.count {
            let cuoi = min(idx + soCot, cacAnh.count)
            cacHang.append(Array(cacAnh[idx..<cuoi]))
            idx = cuoi
        }

        let caoCacHang = cacHang.map { hang in hang.map { $0.size.height }.max() ?? 0 }
        let tongCao = caoCacHang.reduce(0, +) + CGFloat(max(0, cacHang.count - 1)) * khoangCach

        let fmt = UIGraphicsImageRendererFormat.default()
        fmt.scale = tongCao > 6000 ? 1.0 : 1.5
        fmt.opaque = true
        return UIGraphicsImageRenderer(size: CGSize(width: rong, height: tongCao), format: fmt).image { ctx in
            UIColor(red: 0.94, green: 0.95, blue: 0.97, alpha: 1).setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: rong, height: tongCao))
            var y: CGFloat = 0
            for (hIdx, hang) in cacHang.enumerated() {
                for (cIdx, anh) in hang.enumerated() {
                    let x = CGFloat(cIdx) * (rongMoiAnh + khoangCach)
                    anh.draw(in: CGRect(x: x, y: y, width: anh.size.width, height: anh.size.height))
                }
                y += caoCacHang[hIdx] + khoangCach
            }
        }
    }

    func taoAnhSucKhoeNhanVien() -> UIImage? {
        BangThongSoSucKhoeNhanVienView.taoAnhBaoCao(cho: tongHop, ngay: ngay, cheDo: cheDo)
    }
}
