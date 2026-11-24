import UIKit

final class ManHinhDieuChinhTargetThiDua: UIViewController {
    var khiLuu: (([UUID: Double]) -> Void)?

    private let cheDo: LoaiCheDoDoanhThu
    private let danhSach: [DongThiDua]
    private let ngan = UIStackView()
    private var thanhTheoId: [UUID: UISlider] = [:]
    private var nhanTheoId: [UUID: UILabel] = [:]
    private let thanhTong = UISlider()
    private let nhanTong = UILabel()

    init(cheDo: LoaiCheDoDoanhThu, danhSach: [DongThiDua]) {
        self.cheDo = cheDo
        self.danhSach = danhSach
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Target môn — \(cheDo.tieuDe)"
        view.backgroundColor = BangMauBCTD.nenTrang
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(dong))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(luu))

        let cuon = UIScrollView()
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
            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 16),
            ngan.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 18),
            ngan.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -18),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        let huongDan = UILabel()
        huongDan.text = "Thanh Tổng áp dụng cùng tỷ lệ cho tất cả môn. Sau đó có thể chỉnh riêng từng môn. Dữ liệu thực hiện không thay đổi."
        huongDan.font = .systemFont(ofSize: 13.5)
        huongDan.textColor = BangMauBCTD.chuPhu
        huongDan.numberOfLines = 0
        ngan.addArrangedSubview(huongDan)

        nhanTong.font = .systemFont(ofSize: 16, weight: .heavy)
        nhanTong.textColor = BangMauBCTD.xanhChuDao
        ngan.addArrangedSubview(nhanTong)
        let cacTyLeDaLuu = danhSach.map { Int(round($0.phanTramDieuChinhTargetHieuLuc)) }
        let tyLeTongBanDau: Float = {
            if let dau = cacTyLeDaLuu.first, cacTyLeDaLuu.allSatisfy({ $0 == dau }) {
                return Float(min(200, max(50, dau)))
            }
            return 100
        }()
        cauHinh(thanhTong, giaTri: tyLeTongBanDau)
        thanhTong.addTarget(self, action: #selector(thayDoiTong), for: .valueChanged)
        ngan.addArrangedSubview(thanhTong)

        for mon in danhSach {
            let nhan = UILabel()
            nhan.font = .systemFont(ofSize: 13.5, weight: .semibold)
            nhan.textColor = BangMauBCTD.chuChinh
            nhan.numberOfLines = 0
            nhanTheoId[mon.id] = nhan
            ngan.addArrangedSubview(nhan)

            let thanh = UISlider()
            cauHinh(thanh, giaTri: Float(min(200, max(50, mon.phanTramDieuChinhTargetHieuLuc))))
            thanh.addTarget(self, action: #selector(thayDoiMotMon(_:)), for: .valueChanged)
            thanhTheoId[mon.id] = thanh
            ngan.addArrangedSubview(thanh)
        }
        capNhatNhan()
    }

    private func cauHinh(_ thanh: UISlider, giaTri: Float = 100) {
        thanh.minimumValue = 50
        thanh.maximumValue = 200
        thanh.value = min(200, max(50, giaTri))
        thanh.minimumTrackTintColor = BangMauBCTD.xanhChuDao
    }

    @objc private func thayDoiTong() {
        let giaTri = round(thanhTong.value / 5) * 5
        thanhTong.value = giaTri
        for thanh in thanhTheoId.values { thanh.value = giaTri }
        capNhatNhan()
    }

    @objc private func thayDoiMotMon(_ sender: UISlider) {
        sender.value = round(sender.value / 5) * 5
        capNhatNhan()
    }

    private func capNhatNhan() {
        nhanTong.text = "TỔNG TẤT CẢ MÔN: \(Int(thanhTong.value))%"
        for mon in danhSach {
            let pt = Double(thanhTheoId[mon.id]?.value ?? 100)
            let goc = mon.targetGocHieuLuc
            let targetMoi = goc * pt / 100.0
            nhanTheoId[mon.id]?.text = "\(mon.tenNganhHang): \(Int(pt))%  •  \(goc.chuoiSoVN) → \(targetMoi.chuoiSoVN)"
        }
    }

    @objc private func dong() { dismiss(animated: true) }

    @objc private func luu() {
        var ketQua: [UUID: Double] = [:]
        for mon in danhSach { ketQua[mon.id] = Double(thanhTheoId[mon.id]?.value ?? 100) }
        khiLuu?(ketQua)
        dismiss(animated: true)
    }
}
