import UIKit

// MARK: - Trung tâm Đào tạo & Huấn luyện nhân sự (Dành cho Quản lý & Đào tạo)

final class ManHinhDaoTaoHuanLuyen: UIViewController {
    private let ngay: Date
    private var cheDo: LoaiCheDoDoanhThu
    private let locTheoMaNV: String?

    private let thanhChonTab = UISegmentedControl(items: ["🎯 Cần kèm cặp", "📋 Nhật ký & Hiệu quả"])
    private let thanhChonCheDo = UISegmentedControl(items: ["Lũy kế", "Realtime"])
    private let thanhLocTrangThai = UISegmentedControl(items: ["Tất cả", "Đang theo dõi", "Hoàn thành", "Kèm lại"])
    private let cuonDoc = UIScrollView()
    private let nganNoiDung = UIStackView()

    private var baoCaoSucKhoe: BaoCaoSucKhoeDoiNgu?

    init(ngay: Date = Date(), cheDo: LoaiCheDoDoanhThu = .luyKe, locTheoMaNV: String? = nil) {
        self.ngay = ngay
        self.cheDo = cheDo
        self.locTheoMaNV = locTheoMaNV
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = locTheoMaNV == nil ? "Đào tạo & Huấn luyện" : "Hồ sơ kèm cặp nhân viên"
        view.backgroundColor = BangMauBCTD.nenTrang

        let nutTaoMoi = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(bamTaoPhieuMoi)
        )
        let nutXuatAnh = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(bamXuatAnhBaoCaoDaoTao)
        )
        navigationItem.rightBarButtonItems = [nutTaoMoi, nutXuatAnh]

        taoGiaoDien()
        if locTheoMaNV != nil {
            thanhChonTab.selectedSegmentIndex = 1
        }
        napDuLieu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        napDuLieu()
    }

    private func taoGiaoDien() {
        let thanhDieuKhien = UIStackView()
        thanhDieuKhien.axis = .vertical
        thanhDieuKhien.spacing = 8
        thanhDieuKhien.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thanhDieuKhien)

        thanhChonTab.selectedSegmentIndex = 0
        thanhChonTab.selectedSegmentTintColor = BangMauBCTD.xanhChuDao
        thanhChonTab.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 13.5, weight: .bold)], for: .selected)
        thanhChonTab.setTitleTextAttributes([.foregroundColor: BangMauBCTD.chuChinh, .font: UIFont.systemFont(ofSize: 13.5, weight: .semibold)], for: .normal)
        thanhChonTab.addTarget(self, action: #selector(doiTabHienThi), for: .valueChanged)

        thanhChonCheDo.selectedSegmentIndex = (cheDo == .luyKe) ? 0 : 1
        thanhChonCheDo.addTarget(self, action: #selector(doiCheDoSoLieu), for: .valueChanged)

        thanhLocTrangThai.selectedSegmentIndex = 0
        thanhLocTrangThai.addTarget(self, action: #selector(doiBoLocTrangThai), for: .valueChanged)

        thanhDieuKhien.addArrangedSubview(thanhChonTab)
        thanhDieuKhien.addArrangedSubview(thanhChonCheDo)
        thanhDieuKhien.addArrangedSubview(thanhLocTrangThai)

        cuonDoc.alwaysBounceVertical = true
        cuonDoc.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuonDoc)

        nganNoiDung.axis = .vertical
        nganNoiDung.spacing = 12
        nganNoiDung.translatesAutoresizingMaskIntoConstraints = false
        cuonDoc.addSubview(nganNoiDung)

        NSLayoutConstraint.activate([
            thanhDieuKhien.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            thanhDieuKhien.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            thanhDieuKhien.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),

            cuonDoc.topAnchor.constraint(equalTo: thanhDieuKhien.bottomAnchor, constant: 10),
            cuonDoc.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuonDoc.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuonDoc.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nganNoiDung.topAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.topAnchor, constant: 4),
            nganNoiDung.leadingAnchor.constraint(equalTo: cuonDoc.frameLayoutGuide.leadingAnchor, constant: 14),
            nganNoiDung.trailingAnchor.constraint(equalTo: cuonDoc.frameLayoutGuide.trailingAnchor, constant: -14),
            nganNoiDung.bottomAnchor.constraint(equalTo: cuonDoc.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    @objc private func doiTabHienThi() {
        napDuLieu()
    }

    @objc private func doiCheDoSoLieu() {
        cheDo = (thanhChonCheDo.selectedSegmentIndex == 0) ? .luyKe : .realtime
        napDuLieu()
    }

    @objc private func doiBoLocTrangThai() {
        napDuLieu()
    }

    private func napDuLieu() {
        let dangXemNhatKy = (thanhChonTab.selectedSegmentIndex == 1)
        thanhLocTrangThai.isHidden = !dangXemNhatKy

        baoCaoSucKhoe = KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: cheDo)

        nganNoiDung.arrangedSubviews.forEach {
            nganNoiDung.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // 1. Cụm 4 chỉ số tổng quan đào tạo
        nganNoiDung.addArrangedSubview(taoCumChiSoTongQuan())

        // 2. Nội dung theo tab đang chọn
        if !dangXemNhatKy {
            hienThiDanhSachCanKemCap()
        } else {
            hienThiNhatKyVaHieuQua()
        }

        view.damBaoHienThiDayDuText()
    }

    private func taoCumChiSoTongQuan() -> UIView {
        let tatCaPhien = DichVuDaoTao.dungChung.danhSachPhien(locMaNV: locTheoMaNV)
        let soNVYeu = baoCaoSucKhoe?.soNVYeu ?? 0
        let soDangTheoDoi = tatCaPhien.filter { $0.trangThai == .dangTheoDoi || $0.trangThai == .canKemLai }.count
        let soHoanThanh = tatCaPhien.filter { $0.trangThai == .daHoanThanh }.count

        let cacDelta: [Double] = tatCaPhien.compactMap {
            DichVuDaoTao.dungChung.tinhHieuQuaKemCap(cho: $0, cheDo: cheDo).chenhLech
        }
        let chuoiCaiThien: String
        let mauCaiThien: UIColor
        if cacDelta.isEmpty {
            chuoiCaiThien = "—"
            mauCaiThien = BangMauBCTD.chuMo
        } else {
            let tb = cacDelta.reduce(0, +) / Double(cacDelta.count)
            let dau = tb >= 0 ? "+" : ""
            chuoiCaiThien = String(format: "%@%.1f%%", dau, tb)
            mauCaiThien = tb >= 0 ? BangMauBCTD.xanhDatChu : BangMauBCTD.doYeuChu
        }

        let hang1 = UIStackView(arrangedSubviews: [
            taoTheChiSo(tieuDe: "NV cần kèm (<55%)", giaTri: "\(soNVYeu)", mauChu: soNVYeu > 0 ? BangMauBCTD.doYeuChu : BangMauBCTD.xanhDatChu),
            taoTheChiSo(tieuDe: "Phiếu đang kèm", giaTri: "\(soDangTheoDoi)", mauChu: BangMauBCTD.xanhChuDaoDam)
        ])
        hang1.axis = .horizontal
        hang1.spacing = 10
        hang1.distribution = .fillEqually

        let hang2 = UIStackView(arrangedSubviews: [
            taoTheChiSo(tieuDe: "Đã hoàn thành", giaTri: "\(soHoanThanh)", mauChu: BangMauBCTD.xanhDatChu),
            taoTheChiSo(tieuDe: "Cải thiện TB (Sau-Trước)", giaTri: chuoiCaiThien, mauChu: mauCaiThien)
        ])
        hang2.axis = .horizontal
        hang2.spacing = 10
        hang2.distribution = .fillEqually

        let cot = UIStackView(arrangedSubviews: [hang1, hang2])
        cot.axis = .vertical
        cot.spacing = 10
        return cot
    }

    private func taoTheChiSo(tieuDe: String, giaTri: String, mauChu: UIColor) -> UIView {
        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 12
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let lbSo = UILabel()
        lbSo.text = giaTri
        lbSo.font = .systemFont(ofSize: 22, weight: .heavy)
        lbSo.textColor = mauChu
        lbSo.numberOfLines = 0
        lbSo.lineBreakMode = .byWordWrapping
        lbSo.adjustsFontSizeToFitWidth = false

        let lbTen = UILabel()
        lbTen.text = tieuDe
        lbTen.font = .systemFont(ofSize: 12.5, weight: .semibold)
        lbTen.textColor = BangMauBCTD.chuPhu
        lbTen.numberOfLines = 0
        lbTen.lineBreakMode = .byWordWrapping
        lbTen.adjustsFontSizeToFitWidth = false

        let ngan = UIStackView(arrangedSubviews: [lbSo, lbTen])
        ngan.axis = .vertical
        ngan.spacing = 4
        ngan.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: the.topAnchor, constant: 12),
            ngan.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 12),
            ngan.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -12),
            ngan.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -12)
        ])
        return the
    }

    // MARK: - Tab 1: Danh sách cần kèm cặp & ghép Mentor

    private func hienThiDanhSachCanKemCap() {
        guard let bc = baoCaoSucKhoe else { return }

        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let lbTieuDe = UILabel()
        lbTieuDe.text = "Ưu tiên kèm cặp (\(cheDo.tieuDe) · ngày \(ngayStr) · theo dõi \(bc.soNgayDaTheoDoi) ngày)"
        lbTieuDe.font = .systemFont(ofSize: 14, weight: .bold)
        lbTieuDe.textColor = BangMauBCTD.chuChinh
        nganNoiDung.addArrangedSubview(lbTieuDe)

        var danhSachUuTien = bc.top5CanhBaoYeu
        if let maLoc = locTheoMaNV, !maLoc.isEmpty {
            let maChuan = KhoDuLieu.chuanHoaMaNV(maLoc)
            danhSachUuTien = bc.danhSachTatCa.filter { KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV) == maChuan }
        } else if danhSachUuTien.isEmpty {
            danhSachUuTien = Array(bc.danhSachTatCa.sorted { $0.diemSucKhoe < $1.diemSucKhoe }.prefix(5))
        }

        if danhSachUuTien.isEmpty {
            nganNoiDung.addArrangedSubview(taoTheThongBaoTrong(
                "Chưa có dữ liệu sức khỏe nhân viên cho ngày \(ngayStr). Hãy đổ số liệu Thi đua hoặc Doanh thu nhân viên trước để hệ thống xác định chính xác nhóm cần kèm cặp."
            ))
            return
        }

        for hoSo in danhSachUuTien {
            nganNoiDung.addArrangedSubview(taoTheNhanVienCanKemCap(hoSo))
        }
    }

    private func taoTheNhanVienCanKemCap(_ hoSo: HoSoSucKhoeNhanVien) -> UIView {
        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 12
        the.layer.borderWidth = 1
        the.layer.borderColor = (hoSo.laCanhBaoTop5 ? BangMauBCTD.doYeuVach : BangMauBCTD.vienThe).cgColor

        let lbTen = UILabel()
        lbTen.text = "\(hoSo.nhanVien.hoTen) (\(hoSo.nhanVien.maNV))"
        lbTen.font = .systemFont(ofSize: 15.5, weight: .bold)
        lbTen.textColor = BangMauBCTD.chuChinh

        let lbCanhBao = UILabel()
        lbCanhBao.text = "\(hoSo.chuoiCanhBaoYeu) · Điểm SK: \(String(format: "%.1f%%", hoSo.diemSucKhoe)) · \(hoSo.nhanXuHuong)"
        lbCanhBao.font = .systemFont(ofSize: 13, weight: .semibold)
        lbCanhBao.textColor = hoSo.diemSucKhoe < 55 ? BangMauBCTD.doYeuChu : BangMauBCTD.vangKhaChu

        let nganhYeuChinh = hoSo.cacMonYeuNhat.first ?? ""
        let chuoiNganhYeu = hoSo.cacMonYeuNhat.isEmpty
            ? "Chưa có dữ liệu ngành hàng yếu cụ thể trong ngày này"
            : hoSo.cacMonYeuNhat.prefix(3).joined(separator: ", ")

        let lbNganhYeu = UILabel()
        lbNganhYeu.text = "Ngành hàng yếu nhất: \(chuoiNganhYeu)"
        lbNganhYeu.font = .systemFont(ofSize: 13.5, weight: .regular)
        lbNganhYeu.textColor = BangMauBCTD.chuPhu

        let dsMentor = DichVuDaoTao.dungChung.goiYMentor(
            choNganhHang: nganhYeuChinh,
            loaiTruMaNV: hoSo.nhanVien.maNV,
            den: ngay,
            cheDo: cheDo,
            gioiHan: 2
        )
        let lbMentor = UILabel()
        if dsMentor.isEmpty {
            lbMentor.text = "Gợi ý ghép cặp Mentor: Chưa đủ dữ liệu ngành hàng để đề xuất"
            lbMentor.textColor = BangMauBCTD.chuMo
        } else {
            let tenMentors = dsMentor.map(\.moTaNgan).joined(separator: " · ")
            lbMentor.text = "Gợi ý ghép cặp Mentor: \(tenMentors)"
            lbMentor.textColor = BangMauBCTD.xanhLaDam
        }
        lbMentor.font = .systemFont(ofSize: 13.5, weight: .semibold)

        let nutLapPhieu = UIButton(type: .system)
        nutLapPhieu.setTitle("+ Lập phiếu kèm cặp cho \(hoSo.nhanVien.hoTen)", for: .normal)
        nutLapPhieu.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutLapPhieu.setTitleColor(.white, for: .normal)
        nutLapPhieu.backgroundColor = BangMauBCTD.xanhChuDao
        nutLapPhieu.layer.cornerRadius = 9
        nutLapPhieu.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        nutLapPhieu.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.moManHinhTaoPhieu(
                nhanVienMacDinh: hoSo.nhanVien,
                nganhHangMacDinh: nganhYeuChinh,
                mentorMacDinh: dsMentor.first?.nhanVien
            )
        }, for: .touchUpInside)

        let ngan = UIStackView(arrangedSubviews: [lbTen, lbCanhBao, lbNganhYeu, lbMentor, nutLapPhieu])
        ngan.axis = .vertical
        ngan.spacing = 6
        ngan.setCustomSpacing(10, after: lbMentor)
        ngan.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: the.topAnchor, constant: 12),
            ngan.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 12),
            ngan.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -12),
            ngan.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -12)
        ])
        return the
    }

    // MARK: - Tab 2: Nhật ký & Hiệu quả Before / After

    private func hienThiNhatKyVaHieuQua() {
        let locTrangThai: TrangThaiKemCap?
        switch thanhLocTrangThai.selectedSegmentIndex {
        case 1: locTrangThai = .dangTheoDoi
        case 2: locTrangThai = .daHoanThanh
        case 3: locTrangThai = .canKemLai
        default: locTrangThai = nil
        }

        let danhSach = DichVuDaoTao.dungChung.danhSachPhien(locMaNV: locTheoMaNV, trangThai: locTrangThai)

        if danhSach.isEmpty {
            nganNoiDung.addArrangedSubview(taoTheThongBaoTrong(
                "Chưa có phiếu kèm cặp nào khớp bộ lọc hiện tại. Bấm nút dấu cộng (+) ở góc trên phải hoặc chọn nhân viên ở tab \"Cần kèm cặp\" để tạo phiếu huấn luyện 1-1 đầu tiên."
            ))
            return
        }

        for phien in danhSach {
            nganNoiDung.addArrangedSubview(taoThePhienKemCap(phien))
        }
    }

    private func taoThePhienKemCap(_ phien: PhienKemCapNhanVien) -> UIView {
        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 12
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let hieuQua = DichVuDaoTao.dungChung.tinhHieuQuaKemCap(cho: phien, cheDo: cheDo)

        let lbDau = UILabel()
        lbDau.text = "\(phien.hoTenNV) (\(phien.maNV)) · \(phien.trangThai.tieuDe)"
        lbDau.font = .systemFont(ofSize: 15, weight: .bold)
        switch phien.trangThai {
        case .daHoanThanh: lbDau.textColor = BangMauBCTD.xanhDatChu
        case .canKemLai: lbDau.textColor = BangMauBCTD.doYeuChu
        case .dangTheoDoi: lbDau.textColor = BangMauBCTD.xanhChuDaoDam
        }

        let lbThoiGian = UILabel()
        lbThoiGian.text = "Ngày kèm: \(phien.ngayTao) · Hạn kiểm tra: \(phien.hanKiemTra)"
        lbThoiGian.font = .systemFont(ofSize: 12.5, weight: .medium)
        lbThoiGian.textColor = BangMauBCTD.chuMo

        let lbChiTiet = UILabel()
        var dong: [String] = [
            "Mục tiêu: \(phien.tenMucTieuHienThi)",
            "Nguyên nhân: \(phien.nguyenNhan.tieuDe)"
        ]
        if phien.coMentor {
            dong.append("Mentor ghép cặp: \(phien.hoTenNVMentor)")
        }
        if !phien.hanhDongCamKet.isEmpty {
            dong.append("Hành động cam kết: \(phien.hanhDongCamKet)")
        }
        if !phien.ketQuaGhiChu.isEmpty {
            dong.append("Ghi nhận kết quả: \(phien.ketQuaGhiChu)")
        }
        lbChiTiet.text = dong.joined(separator: "\n")
        lbChiTiet.font = .systemFont(ofSize: 13.5, weight: .regular)
        lbChiTiet.textColor = BangMauBCTD.chuChinh

        let khungHieuQua = UIView()
        khungHieuQua.layer.cornerRadius = 8
        let lbHieuQua = UILabel()
        lbHieuQua.text = "Hiệu quả thực tế: \(hieuQua.moTaHieuQua)"
        lbHieuQua.font = .systemFont(ofSize: 13, weight: .semibold)
        if let delta = hieuQua.chenhLech {
            khungHieuQua.backgroundColor = delta >= 0 ? BangMauBCTD.xanhDatNenDong : BangMauBCTD.doYeuNenDong
            lbHieuQua.textColor = delta >= 0 ? BangMauBCTD.xanhDatChu : BangMauBCTD.doYeuChu
        } else {
            khungHieuQua.backgroundColor = BangMauBCTD.nenThePhu
            lbHieuQua.textColor = BangMauBCTD.chuPhu
        }
        lbHieuQua.translatesAutoresizingMaskIntoConstraints = false
        khungHieuQua.addSubview(lbHieuQua)
        NSLayoutConstraint.activate([
            lbHieuQua.topAnchor.constraint(equalTo: khungHieuQua.topAnchor, constant: 8),
            lbHieuQua.leadingAnchor.constraint(equalTo: khungHieuQua.leadingAnchor, constant: 10),
            lbHieuQua.trailingAnchor.constraint(equalTo: khungHieuQua.trailingAnchor, constant: -10),
            lbHieuQua.bottomAnchor.constraint(equalTo: khungHieuQua.bottomAnchor, constant: -8)
        ])

        let nutCapNhat = UIButton(type: .system)
        nutCapNhat.setTitle("Cập nhật / Đánh giá", for: .normal)
        nutCapNhat.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nutCapNhat.setTitleColor(BangMauBCTD.xanhChuDaoDam, for: .normal)
        nutCapNhat.backgroundColor = BangMauBCTD.nenHeaderPhu
        nutCapNhat.layer.cornerRadius = 8
        nutCapNhat.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        nutCapNhat.addAction(UIAction { [weak self] _ in
            self?.moSuaPhien(phien)
        }, for: .touchUpInside)

        let nutXoa = UIButton(type: .system)
        nutXoa.setTitle("Xóa", for: .normal)
        nutXoa.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .semibold)
        nutXoa.setTitleColor(BangMauBCTD.doYeuChu, for: .normal)
        nutXoa.backgroundColor = BangMauBCTD.doYeuNenDong
        nutXoa.layer.cornerRadius = 8
        nutXoa.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        nutXoa.addAction(UIAction { [weak self] _ in
            self?.xacNhanXoaPhien(phien)
        }, for: .touchUpInside)

        let hangNut = UIStackView(arrangedSubviews: [nutCapNhat, nutXoa])
        hangNut.axis = .horizontal
        hangNut.spacing = 8

        let ngan = UIStackView(arrangedSubviews: [lbDau, lbThoiGian, lbChiTiet, khungHieuQua, hangNut])
        ngan.axis = .vertical
        ngan.spacing = 6
        ngan.setCustomSpacing(8, after: khungHieuQua)
        ngan.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(ngan)

        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: the.topAnchor, constant: 12),
            ngan.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 12),
            ngan.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -12),
            ngan.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -12)
        ])
        return the
    }

    private func taoTheThongBaoTrong(_ noiDung: String) -> UIView {
        let the = UIView()
        the.backgroundColor = BangMauBCTD.nenThe
        the.layer.cornerRadius = 12
        the.layer.borderWidth = 1
        the.layer.borderColor = BangMauBCTD.vienThe.cgColor

        let lb = UILabel()
        lb.text = noiDung
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.textColor = BangMauBCTD.chuPhu
        lb.translatesAutoresizingMaskIntoConstraints = false
        the.addSubview(lb)

        NSLayoutConstraint.activate([
            lb.topAnchor.constraint(equalTo: the.topAnchor, constant: 16),
            lb.leadingAnchor.constraint(equalTo: the.leadingAnchor, constant: 14),
            lb.trailingAnchor.constraint(equalTo: the.trailingAnchor, constant: -14),
            lb.bottomAnchor.constraint(equalTo: the.bottomAnchor, constant: -16)
        ])
        return the
    }

    // MARK: - Hành động tạo / sửa / xóa / xuất ảnh báo cáo

    @objc private func bamTaoPhieuMoi() {
        let nvMacDinh: NhanVienQuanLy?
        if let ma = locTheoMaNV {
            let maChuan = KhoDuLieu.chuanHoaMaNV(ma)
            nvMacDinh = KhoDuLieu.dungChung.caiDat.danhSachNhanVien.first { KhoDuLieu.chuanHoaMaNV($0.maNV) == maChuan }
        } else {
            nvMacDinh = baoCaoSucKhoe?.top5CanhBaoYeu.first?.nhanVien ?? KhoDuLieu.dungChung.caiDat.danhSachNhanVien.first
        }
        moManHinhTaoPhieu(nhanVienMacDinh: nvMacDinh, nganhHangMacDinh: "", mentorMacDinh: nil)
    }

    private func moManHinhTaoPhieu(
        nhanVienMacDinh: NhanVienQuanLy?,
        nganhHangMacDinh: String,
        mentorMacDinh: NhanVienQuanLy?
    ) {
        let vc = ManHinhTaoPhieuKemCap(
            ngay: ngay,
            cheDo: cheDo,
            phienCanSua: nil,
            nhanVienMacDinh: nhanVienMacDinh,
            nganhHangMacDinh: nganhHangMacDinh,
            mentorMacDinh: mentorMacDinh
        ) { [weak self] in
            self?.thanhChonTab.selectedSegmentIndex = 1
            self?.napDuLieu()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    private func moSuaPhien(_ phien: PhienKemCapNhanVien) {
        let vc = ManHinhTaoPhieuKemCap(
            ngay: ngay,
            cheDo: cheDo,
            phienCanSua: phien,
            nhanVienMacDinh: nil,
            nganhHangMacDinh: phien.nganhHangMucTieu,
            mentorMacDinh: nil
        ) { [weak self] in
            self?.napDuLieu()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    private func xacNhanXoaPhien(_ phien: PhienKemCapNhanVien) {
        hienMenuChon(
            tieuDe: "Xóa phiếu kèm cặp?",
            thongDiep: "\(phien.hoTenNV) · \(phien.tenMucTieuHienThi) (\(phien.ngayTao))",
            cacMuc: [
                MucChonDMX(tieuDe: "Xóa vĩnh viễn phiếu này", kieu: .nguyHiem) { [weak self] in
                    DichVuDaoTao.dungChung.xoaPhienKemCap(id: phien.id)
                    self?.napDuLieu()
                },
                MucChonDMX(tieuDe: "Hủy", kieu: .huy)
            ]
        )
    }

    @objc private func bamXuatAnhBaoCaoDaoTao() {
        let anh = taoAnhBaoCaoDaoTao()
        let vc = UIActivityViewController(activityItems: [anh], applicationActivities: nil)
        if let pop = vc.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(vc, animated: true)
    }

    /// Xuất ảnh PNG báo cáo Đào tạo & Huấn luyện tính chiều cao động theo boundingRect (tuyệt đối không cắt chữ)
    private func taoAnhBaoCaoDaoTao() -> UIImage {
        let chieuRong: CGFloat = 1080
        let leNgang: CGFloat = 40
        let rongNoiDung: CGFloat = chieuRong - leNgang * 2

        let ngayStr = TienIchNgay.hienThiNgay.string(from: ngay)
        let bc = baoCaoSucKhoe ?? KhoDuLieu.dungChung.tinhBaoCaoSucKhoeNhanVien(den: ngay, cheDo: cheDo)
        let dsPhien = Array(DichVuDaoTao.dungChung.danhSachPhien(locMaNV: locTheoMaNV).prefix(8))

        let fontTieuDe = UIFont.systemFont(ofSize: 32, weight: .heavy)
        let fontPhuDe = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let fontMuc = UIFont.systemFont(ofSize: 24, weight: .bold)
        let fontNoiDung = UIFont.systemFont(ofSize: 20, weight: .regular)

        func doChieuCao(_ text: String, font: UIFont, rong: CGFloat) -> CGFloat {
            let rect = (text as NSString).boundingRect(
                with: CGSize(width: rong, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            )
            return ceil(rect.height)
        }

        let tieuDeChinh = "BÁO CÁO ĐÀO TẠO & HUẤN LUYỆN NHÂN SỰ"
        let phuDe = "Ngày \(ngayStr) · Chế độ \(cheDo.tieuDe) · NV yếu (<55%): \(bc.soNVYeu) · Tổng phiếu: \(dsPhien.count)"

        var dongCanKem: [String] = []
        for hoSo in bc.top5CanhBaoYeu {
            let nganhYeu = hoSo.cacMonYeuNhat.first ?? ""
            let mentor = DichVuDaoTao.dungChung.goiYMentor(
                choNganhHang: nganhYeu,
                loaiTruMaNV: hoSo.nhanVien.maNV,
                den: ngay,
                cheDo: cheDo,
                gioiHan: 1
            ).first
            let chuoiMentor = mentor.map { " | Mentor: \($0.moTaNgan)" } ?? ""
            let chuoiNganh = nganhYeu.isEmpty ? "Tổng thể" : nganhYeu
            dongCanKem.append("• \(hoSo.nhanVien.hoTen) (\(hoSo.nhanVien.maNV)) — SK \(String(format: "%.1f%%", hoSo.diemSucKhoe)) · \(hoSo.chuoiCanhBaoYeu) · Yếu nhất: \(chuoiNganh)\(chuoiMentor)")
        }
        if dongCanKem.isEmpty {
            dongCanKem.append("• Chưa có nhân viên nằm trong nhóm cảnh báo yếu.")
        }

        var dongPhien: [String] = []
        for p in dsPhien {
            let hq = DichVuDaoTao.dungChung.tinhHieuQuaKemCap(cho: p, cheDo: cheDo)
            let mentorStr = p.coMentor ? " · Mentor: \(p.hoTenNVMentor)" : ""
            dongPhien.append("• [\(p.trangThai.tieuDe)] \(p.hoTenNV) — \(p.tenMucTieuHienThi) (\(p.ngayTao))\(mentorStr)\n   Nguyên nhân: \(p.nguyenNhan.tieuDe) · \(hq.moTaHieuQua)")
        }
        if dongPhien.isEmpty {
            dongPhien.append("• Chưa có phiếu kèm cặp nào được ghi nhận.")
        }

        var tongCao: CGFloat = 44
        tongCao += doChieuCao(tieuDeChinh, font: fontTieuDe, rong: rongNoiDung) + 10
        tongCao += doChieuCao(phuDe, font: fontPhuDe, rong: rongNoiDung) + 30
        tongCao += doChieuCao("1. NHÓM NHÂN VIÊN ƯU TIÊN KÈM CẶP", font: fontMuc, rong: rongNoiDung) + 14
        for s in dongCanKem {
            tongCao += doChieuCao(s, font: fontNoiDung, rong: rongNoiDung - 24) + 14
        }
        tongCao += 22
        tongCao += doChieuCao("2. NHẬT KÝ KÈM CẶP & HIỆU QUẢ TRƯỚC / SAU", font: fontMuc, rong: rongNoiDung) + 14
        for s in dongPhien {
            tongCao += doChieuCao(s, font: fontNoiDung, rong: rongNoiDung - 24) + 16
        }
        tongCao += 40

        let renderer = UIGraphicsImageRenderer(size: CGSize(width: chieuRong, height: max(480, tongCao)))
        return renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: chieuRong, height: max(480, tongCao)))

            var y: CGFloat = 36
            let attrTieuDe: [NSAttributedString.Key: Any] = [.font: fontTieuDe, .foregroundColor: BangMauBCTD.xanhChuDaoDam]
            let hTD = doChieuCao(tieuDeChinh, font: fontTieuDe, rong: rongNoiDung)
            (tieuDeChinh as NSString).draw(in: CGRect(x: leNgang, y: y, width: rongNoiDung, height: hTD), withAttributes: attrTieuDe)
            y += hTD + 10

            let attrPhuDe: [NSAttributedString.Key: Any] = [.font: fontPhuDe, .foregroundColor: BangMauBCTD.chuPhu]
            let hPD = doChieuCao(phuDe, font: fontPhuDe, rong: rongNoiDung)
            (phuDe as NSString).draw(in: CGRect(x: leNgang, y: y, width: rongNoiDung, height: hPD), withAttributes: attrPhuDe)
            y += hPD + 26

            let attrMuc: [NSAttributedString.Key: Any] = [.font: fontMuc, .foregroundColor: BangMauBCTD.chuChinh]
            let attrNoiDung: [NSAttributedString.Key: Any] = [.font: fontNoiDung, .foregroundColor: BangMauBCTD.chuChinh]

            let m1 = "1. NHÓM NHÂN VIÊN ƯU TIÊN KÈM CẶP"
            let hM1 = doChieuCao(m1, font: fontMuc, rong: rongNoiDung)
            (m1 as NSString).draw(in: CGRect(x: leNgang, y: y, width: rongNoiDung, height: hM1), withAttributes: attrMuc)
            y += hM1 + 12

            for s in dongCanKem {
                let h = doChieuCao(s, font: fontNoiDung, rong: rongNoiDung - 24)
                (s as NSString).draw(in: CGRect(x: leNgang + 12, y: y, width: rongNoiDung - 24, height: h), withAttributes: attrNoiDung)
                y += h + 14
            }

            y += 18
            let m2 = "2. NHẬT KÝ KÈM CẶP & HIỆU QUẢ TRƯỚC / SAU"
            let hM2 = doChieuCao(m2, font: fontMuc, rong: rongNoiDung)
            (m2 as NSString).draw(in: CGRect(x: leNgang, y: y, width: rongNoiDung, height: hM2), withAttributes: attrMuc)
            y += hM2 + 12

            for s in dongPhien {
                let h = doChieuCao(s, font: fontNoiDung, rong: rongNoiDung - 24)
                (s as NSString).draw(in: CGRect(x: leNgang + 12, y: y, width: rongNoiDung - 24, height: h), withAttributes: attrNoiDung)
                y += h + 16
            }
        }
    }
}

// MARK: - Form Tạo / Cập nhật Phiếu Kèm Cặp 1-1

final class ManHinhTaoPhieuKemCap: UIViewController {
    private let ngay: Date
    private let cheDo: LoaiCheDoDoanhThu
    private let phienCanSua: PhienKemCapNhanVien?
    private let khiLuuXong: () -> Void

    private var nhanVienDangChon: NhanVienQuanLy?
    private var nganhHangDangChon: String
    private var nguyenNhanDangChon: NguyenNhanKemCap
    private var mentorDangChon: NhanVienQuanLy?
    private var trangThaiDangChon: TrangThaiKemCap
    private var hanKiemTraDangChon: String

    private let nutChonNV = UIButton(type: .system)
    private let nutChonNganh = UIButton(type: .system)
    private let nutChonNguyenNhan = UIButton(type: .system)
    private let nutChonMentor = UIButton(type: .system)
    private let nutChonHan = UIButton(type: .system)
    private let nutChonTrangThai = UIButton(type: .system)
    private let oHanhDong = UITextView()
    private let oKetQua = UITextView()

    init(
        ngay: Date,
        cheDo: LoaiCheDoDoanhThu,
        phienCanSua: PhienKemCapNhanVien?,
        nhanVienMacDinh: NhanVienQuanLy?,
        nganhHangMacDinh: String,
        mentorMacDinh: NhanVienQuanLy?,
        khiLuuXong: @escaping () -> Void
    ) {
        self.ngay = ngay
        self.cheDo = cheDo
        self.phienCanSua = phienCanSua
        self.khiLuuXong = khiLuuXong

        if let sua = phienCanSua {
            self.nhanVienDangChon = NhanVienQuanLy(maNV: sua.maNV, hoTen: sua.hoTenNV)
            self.nganhHangDangChon = sua.nganhHangMucTieu
            self.nguyenNhanDangChon = sua.nguyenNhan
            self.mentorDangChon = sua.coMentor ? NhanVienQuanLy(maNV: sua.maNVMentor, hoTen: sua.hoTenNVMentor) : nil
            self.trangThaiDangChon = sua.trangThai
            self.hanKiemTraDangChon = sua.hanKiemTra
        } else {
            self.nhanVienDangChon = nhanVienMacDinh
            self.nganhHangDangChon = nganhHangMacDinh
            self.nguyenNhanDangChon = .kienThucSanPham
            self.mentorDangChon = mentorMacDinh
            self.trangThaiDangChon = .dangTheoDoi
            self.hanKiemTraDangChon = DichVuDaoTao.congNgay(ngay, them: 7)
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = phienCanSua == nil ? "Lập phiếu kèm cặp 1-1" : "Cập nhật phiếu kèm cặp"
        view.backgroundColor = BangMauBCTD.nenTrang

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Đóng", style: .plain, target: self, action: #selector(bamDong))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(bamLuu))

        taoGiaoDien()
        capNhatNhanNut()
    }

    private func taoGiaoDien() {
        let cuon = UIScrollView()
        cuon.keyboardDismissMode = .interactive
        cuon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cuon)

        let ngan = UIStackView()
        ngan.axis = .vertical
        ngan.spacing = 12
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        cauHinhNutChon(nutChonNV, action: #selector(bamChonNV))
        cauHinhNutChon(nutChonNganh, action: #selector(bamChonNganh))
        cauHinhNutChon(nutChonNguyenNhan, action: #selector(bamChonNguyenNhan))
        cauHinhNutChon(nutChonMentor, action: #selector(bamChonMentor))
        cauHinhNutChon(nutChonHan, action: #selector(bamChonHan))
        cauHinhNutChon(nutChonTrangThai, action: #selector(bamChonTrangThai))

        cauHinhONhap(oHanhDong, noiDung: phienCanSua?.hanhDongCamKet ?? "")
        cauHinhONhap(oKetQua, noiDung: phienCanSua?.ketQuaGhiChu ?? "")

        ngan.addArrangedSubview(taoNhomTruong("Nhân viên được kèm cặp", nutChonNV))
        ngan.addArrangedSubview(taoNhomTruong("Ngành hàng mục tiêu", nutChonNganh))
        ngan.addArrangedSubview(taoNhomTruong("Nguyên nhân gốc", nutChonNguyenNhan))
        ngan.addArrangedSubview(taoNhomTruong("Mentor ghép cặp (gợi ý theo số liệu thực tế)", nutChonMentor))
        ngan.addArrangedSubview(taoNhomTruong("Hạn kiểm tra lại", nutChonHan))
        ngan.addArrangedSubview(taoNhomTruong("Trạng thái theo dõi", nutChonTrangThai))
        ngan.addArrangedSubview(taoNhomTruong("Hành động cam kết cho ca / tuần tới", oHanhDong))
        ngan.addArrangedSubview(taoNhomTruong("Ghi nhận kết quả đánh giá", oKetQua))

        NSLayoutConstraint.activate([
            cuon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cuon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 14),
            ngan.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 16),
            ngan.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -16),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -32),

            oHanhDong.heightAnchor.constraint(equalToConstant: 88),
            oKetQua.heightAnchor.constraint(equalToConstant: 88)
        ])
        view.damBaoHienThiDayDuText()
    }

    private func taoNhomTruong(_ tieuDe: String, _ control: UIView) -> UIView {
        let lb = UILabel()
        lb.text = tieuDe
        lb.font = .systemFont(ofSize: 13, weight: .bold)
        lb.textColor = BangMauBCTD.chuPhu
        let ngan = UIStackView(arrangedSubviews: [lb, control])
        ngan.axis = .vertical
        ngan.spacing = 6
        return ngan
    }

    private func cauHinhNutChon(_ nut: UIButton, action: Selector) {
        nut.contentHorizontalAlignment = .left
        nut.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        nut.setTitleColor(BangMauBCTD.chuChinh, for: .normal)
        nut.backgroundColor = BangMauBCTD.nenThe
        nut.layer.cornerRadius = 10
        nut.layer.borderWidth = 1
        nut.layer.borderColor = BangMauBCTD.vienThe.cgColor
        nut.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        nut.addTarget(self, action: action, for: .touchUpInside)
    }

    private func cauHinhONhap(_ tv: UITextView, noiDung: String) {
        tv.text = noiDung
        tv.font = .systemFont(ofSize: 15, weight: .regular)
        tv.textColor = BangMauBCTD.chuChinh
        tv.backgroundColor = BangMauBCTD.nenThe
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = BangMauBCTD.vienThe.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    }

    private func capNhatNhanNut() {
        let tenNV = nhanVienDangChon.map { "\($0.hoTen) (\($0.maNV))" } ?? "Chọn nhân viên..."
        nutChonNV.setTitle(tenNV, for: .normal)
        nutChonNganh.setTitle(nganhHangDangChon.isEmpty ? "Tổng thể sức khỏe nhân viên" : nganhHangDangChon, for: .normal)
        nutChonNguyenNhan.setTitle(nguyenNhanDangChon.tieuDe, for: .normal)
        nutChonMentor.setTitle(mentorDangChon.map { "\($0.hoTen) (\($0.maNV))" } ?? "Chưa ghép Mentor", for: .normal)
        nutChonHan.setTitle(hanKiemTraDangChon, for: .normal)
        nutChonTrangThai.setTitle(trangThaiDangChon.tieuDe, for: .normal)
        view.damBaoHienThiDayDuText()
    }

    @objc private func bamChonNV() {
        let ds = KhoDuLieu.dungChung.caiDat.danhSachNhanVien
        var muc: [MucChonDMX] = ds.map { nv in
            MucChonDMX(
                tieuDe: "\(nv.hoTen) (\(nv.maNV))",
                dangChon: nv.maNV == nhanVienDangChon?.maNV
            ) { [weak self] in
                self?.nhanVienDangChon = nv
                self?.capNhatNhanNut()
            }
        }
        muc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: "Chọn nhân viên", cacMuc: muc)
    }

    @objc private func bamChonNganh() {
        var muc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "Tổng thể sức khỏe nhân viên", dangChon: nganhHangDangChon.isEmpty) { [weak self] in
                self?.nganhHangDangChon = ""
                self?.capNhatNhanNut()
            }
        ]
        let dsTongHop = KhoDuLieu.dungChung.tongHopNhanVien(den: ngay, sapXep: .soMonHoanThanh, cheDo: cheDo)
        if let ma = nhanVienDangChon?.maNV,
           let nv = dsTongHop.first(where: { KhoDuLieu.chuanHoaMaNV($0.nhanVien.maNV) == KhoDuLieu.chuanHoaMaNV(ma) }) {
            let monSapXep = nv.cacMonGiao.sorted { $0.phanTramHT < $1.phanTramHT }
            for mon in monSapXep {
                let tieuDe = "\(mon.tenNganhHang) (\(String(format: "%.1f%%", mon.phanTramHT)))"
                muc.append(MucChonDMX(tieuDe: tieuDe, dangChon: mon.tenNganhHang == nganhHangDangChon) { [weak self] in
                    self?.nganhHangDangChon = mon.tenNganhHang
                    self?.capNhatNhanNut()
                })
            }
        }
        muc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: "Chọn ngành hàng mục tiêu", cacMuc: muc)
    }

    @objc private func bamChonNguyenNhan() {
        var muc: [MucChonDMX] = NguyenNhanKemCap.allCases.map { nn in
            MucChonDMX(tieuDe: nn.tieuDe, dangChon: nn == nguyenNhanDangChon) { [weak self] in
                self?.nguyenNhanDangChon = nn
                self?.capNhatNhanNut()
            }
        }
        muc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: "Chọn nguyên nhân gốc", cacMuc: muc)
    }

    @objc private func bamChonMentor() {
        var muc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "Không ghép Mentor", dangChon: mentorDangChon == nil) { [weak self] in
                self?.mentorDangChon = nil
                self?.capNhatNhanNut()
            }
        ]
        let maLoaiTru = nhanVienDangChon?.maNV ?? ""
        let goiY = DichVuDaoTao.dungChung.goiYMentor(
            choNganhHang: nganhHangDangChon,
            loaiTruMaNV: maLoaiTru,
            den: ngay,
            cheDo: cheDo,
            gioiHan: 5
        )
        var daThemMa = Set<String>()
        for g in goiY {
            daThemMa.insert(KhoDuLieu.chuanHoaMaNV(g.nhanVien.maNV))
            muc.append(MucChonDMX(
                tieuDe: "⭐ Gợi ý: \(g.moTaNgan)",
                dangChon: g.nhanVien.maNV == mentorDangChon?.maNV
            ) { [weak self] in
                self?.mentorDangChon = g.nhanVien
                self?.capNhatNhanNut()
            })
        }
        for nv in KhoDuLieu.dungChung.caiDat.danhSachNhanVien {
            let ma = KhoDuLieu.chuanHoaMaNV(nv.maNV)
            guard ma != KhoDuLieu.chuanHoaMaNV(maLoaiTru), !daThemMa.contains(ma) else { continue }
            muc.append(MucChonDMX(tieuDe: "\(nv.hoTen) (\(nv.maNV))", dangChon: nv.maNV == mentorDangChon?.maNV) { [weak self] in
                self?.mentorDangChon = nv
                self?.capNhatNhanNut()
            })
        }
        muc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: "Chọn Mentor ghép cặp", cacMuc: muc)
    }

    @objc private func bamChonHan() {
        let moc = phienCanSua.flatMap { TienIchNgay.khoa.date(from: $0.ngayTao) } ?? ngay
        let cacMuc: [MucChonDMX] = [
            MucChonDMX(tieuDe: "Sau 3 ngày (\(DichVuDaoTao.congNgay(moc, them: 3)))") { [weak self] in
                self?.hanKiemTraDangChon = DichVuDaoTao.congNgay(moc, them: 3)
                self?.capNhatNhanNut()
            },
            MucChonDMX(tieuDe: "Sau 7 ngày (\(DichVuDaoTao.congNgay(moc, them: 7)))") { [weak self] in
                self?.hanKiemTraDangChon = DichVuDaoTao.congNgay(moc, them: 7)
                self?.capNhatNhanNut()
            },
            MucChonDMX(tieuDe: "Sau 14 ngày (\(DichVuDaoTao.congNgay(moc, them: 14)))") { [weak self] in
                self?.hanKiemTraDangChon = DichVuDaoTao.congNgay(moc, them: 14)
                self?.capNhatNhanNut()
            },
            MucChonDMX(tieuDe: "Đóng", kieu: .huy)
        ]
        hienMenuChon(tieuDe: "Chọn hạn kiểm tra lại", cacMuc: cacMuc)
    }

    @objc private func bamChonTrangThai() {
        var muc: [MucChonDMX] = TrangThaiKemCap.allCases.map { tt in
            MucChonDMX(tieuDe: tt.tieuDe, dangChon: tt == trangThaiDangChon) { [weak self] in
                self?.trangThaiDangChon = tt
                self?.capNhatNhanNut()
            }
        }
        muc.append(MucChonDMX(tieuDe: "Đóng", kieu: .huy))
        hienMenuChon(tieuDe: "Chọn trạng thái theo dõi", cacMuc: muc)
    }

    @objc private func bamDong() {
        dismiss(animated: true)
    }

    @objc private func bamLuu() {
        guard let nv = nhanVienDangChon else {
            let tb = UIAlertController(title: "Thiếu thông tin", message: "Vui lòng chọn nhân viên cần kèm cặp.", preferredStyle: .alert)
            tb.addAction(UIAlertAction(title: "Đã hiểu", style: .default))
            present(tb, animated: true)
            return
        }

        let phien = PhienKemCapNhanVien(
            id: phienCanSua?.id ?? UUID(),
            maNV: nv.maNV,
            hoTenNV: nv.hoTen,
            ngayTao: phienCanSua?.ngayTao ?? TienIchNgay.khoa.string(from: ngay),
            hanKiemTra: hanKiemTraDangChon,
            nganhHangMucTieu: nganhHangDangChon,
            nguyenNhan: nguyenNhanDangChon,
            hanhDongCamKet: oHanhDong.text ?? "",
            maNVMentor: mentorDangChon?.maNV ?? "",
            hoTenNVMentor: mentorDangChon?.hoTen ?? "",
            trangThai: trangThaiDangChon,
            ketQuaGhiChu: oKetQua.text ?? "",
            nguoiTao: phienCanSua?.nguoiTao ?? DichVuDongBo.dungChung.tenDangNhap
        )

        DichVuDaoTao.dungChung.luuPhienKemCap(phien)
        dismiss(animated: true) { [weak self] in
            self?.khiLuuXong()
        }
    }
}
