import UIKit

final class ManHinhDieuChinhTarget: UIViewController {
    var khiLuu: ((Double) -> Void)?

    private let cheDo: LoaiCheDoDoanhThu
    private let targetGoc: ThongTinDoanhThu
    private let phanTramBanDau: Double
    private let nhanGiaTri = UILabel()
    private let thanhTruot = UISlider()

    init(cheDo: LoaiCheDoDoanhThu, phanTram: Double, targetGoc: ThongTinDoanhThu) {
        self.cheDo = cheDo
        self.targetGoc = targetGoc
        self.phanTramBanDau = min(200, max(50, phanTram))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Target \(cheDo.tieuDe)"
        view.backgroundColor = BangMauBCTD.nenTrang
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(dong))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lưu", style: .done, target: self, action: #selector(luu))

        let nhanHuongDan = UILabel()
        nhanHuongDan.text = "Target quét gốc vẫn được lưu nguyên vẹn. Thanh trượt chỉ thay đổi target dùng để hiển thị, xuất ảnh và báo cáo."
        nhanHuongDan.font = .systemFont(ofSize: 14)
        nhanHuongDan.textColor = BangMauBCTD.chuPhu
        nhanHuongDan.numberOfLines = 0

        let nhanGoc = UILabel()
        nhanGoc.text = "Target quét: DT thực \(targetGoc.targetThuc.chuoiSoGonVN)  •  QĐ \(targetGoc.targetQuyDoi.chuoiSoGonVN)"
        nhanGoc.font = .systemFont(ofSize: 14, weight: .semibold)
        nhanGoc.textColor = BangMauBCTD.chuChinh
        nhanGoc.numberOfLines = 0

        nhanGiaTri.font = .monospacedDigitSystemFont(ofSize: 30, weight: .heavy)
        nhanGiaTri.textColor = BangMauBCTD.xanhChuDao
        nhanGiaTri.textAlignment = .center

        thanhTruot.minimumValue = 50
        thanhTruot.maximumValue = 200
        thanhTruot.value = Float(phanTramBanDau)
        thanhTruot.minimumTrackTintColor = BangMauBCTD.xanhChuDao
        thanhTruot.addTarget(self, action: #selector(thayDoiThanhTruot), for: .valueChanged)

        let nhanMin = UILabel(); nhanMin.text = "50%"; nhanMin.font = .systemFont(ofSize: 12); nhanMin.textColor = BangMauBCTD.chuPhu
        let nhanMax = UILabel(); nhanMax.text = "200%"; nhanMax.font = .systemFont(ofSize: 12); nhanMax.textColor = BangMauBCTD.chuPhu
        let hangMoc = UIStackView(arrangedSubviews: [nhanMin, UIView(), nhanMax])
        hangMoc.axis = .horizontal

        let nutMacDinh = UIButton(type: .system)
        nutMacDinh.setTitle("Đặt lại 100%", for: .normal)
        nutMacDinh.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        nutMacDinh.backgroundColor = BangMauBCTD.nenThePhu
        nutMacDinh.layer.cornerRadius = 10
        nutMacDinh.layer.borderWidth = 1
        nutMacDinh.layer.borderColor = BangMauBCTD.vienDam.cgColor
        nutMacDinh.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nutMacDinh.addTarget(self, action: #selector(datLai), for: .touchUpInside)

        let ngan = UIStackView(arrangedSubviews: [nhanHuongDan, nhanGoc, nhanGiaTri, thanhTruot, hangMoc, nutMacDinh])
        ngan.axis = .vertical
        ngan.spacing = 14
        ngan.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ngan)
        NSLayoutConstraint.activate([
            ngan.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            ngan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ngan.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        capNhatNhan()
    }

    @objc private func thayDoiThanhTruot() {
        thanhTruot.value = round(thanhTruot.value / 5) * 5
        capNhatNhan()
    }

    private func capNhatNhan() {
        let pt = Double(thanhTruot.value)
        nhanGiaTri.text = "\(Int(pt))%"
    }

    @objc private func datLai() { thanhTruot.value = 100; capNhatNhan() }
    @objc private func dong() { dismiss(animated: true) }
    @objc private func luu() {
        khiLuu?(Double(thanhTruot.value))
        dismiss(animated: true)
    }
}
