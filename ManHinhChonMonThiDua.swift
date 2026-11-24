import UIKit

/// Bảng chọn nhiều môn thi đua, dùng cùng kiểu trình bày với bảng chọn nhân viên trong ca.
final class ManHinhChonMonThiDua: UIViewController {
    struct Muc {
        let khoa: String
        let ten: String
    }

    var khiThayDoi: ((Set<String>) -> Void)?

    private let cacMuc: [Muc]
    private var dangChon: Set<String>
    private let cheDo: LoaiCheDoDoanhThu
    private let nhanMoTa = UILabel()
    private var cacNutHang: [(Muc, UIButton, UIView)] = []

    init(cacMuc: [Muc], dangChon: Set<String>, cheDo: LoaiCheDoDoanhThu) {
        self.cacMuc = cacMuc
        self.dangChon = dangChon
        self.cheDo = cheDo
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) { fatalError("Khong ho tro coder") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.12)

        let khung = UIView()
        khung.backgroundColor = BangMauBCTD.xanhChuDao
        khung.layer.cornerRadius = 18
        khung.layer.borderWidth = 2.5
        khung.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        khung.clipsToBounds = true
        khung.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(khung)

        let vachTrai = UIView()
        vachTrai.backgroundColor = BangMauBCTD.vangSang
        vachTrai.translatesAutoresizingMaskIntoConstraints = false
        khung.addSubview(vachTrai)

        let tieuDe = UILabel()
        tieuDe.text = "🏆 CHỌN MÔN THI ĐUA \(cheDo.tieuDe.uppercased())"
        tieuDe.font = .systemFont(ofSize: 15, weight: .heavy)
        tieuDe.textColor = BangMauBCTD.vangSang
        tieuDe.numberOfLines = 0

        let nutXong = taoNut("Xong", nen: BangMauBCTD.vangSang, mauChu: BangMauBCTD.chuChinh)
        nutXong.addAction(UIAction { [weak self] _ in self?.dismiss(animated: true) }, for: .touchUpInside)
        nutXong.setContentHuggingPriority(.required, for: .horizontal)

        let hangDau = UIStackView(arrangedSubviews: [tieuDe, nutXong])
        hangDau.axis = .horizontal
        hangDau.spacing = 8
        hangDau.alignment = .center

        nhanMoTa.font = .systemFont(ofSize: 12.5, weight: .semibold)
        nhanMoTa.textColor = .white
        nhanMoTa.numberOfLines = 0

        let nutTatCa = taoNut("✅ Chọn tất cả (\(cacMuc.count))", nen: BangMauBCTD.vangSang, mauChu: BangMauBCTD.chuChinh)
        let nutBoTatCa = taoNut("⬜ Bỏ chọn tất cả", nen: .white, mauChu: BangMauBCTD.xanhChuDaoDam)
        let hangNut = UIStackView(arrangedSubviews: [nutTatCa, nutBoTatCa])
        hangNut.axis = .horizontal
        hangNut.spacing = 8
        hangNut.distribution = .fillEqually

        let khungDanhSach = UIView()
        khungDanhSach.backgroundColor = .white
        khungDanhSach.layer.cornerRadius = 12
        khungDanhSach.layer.borderWidth = 1.8
        khungDanhSach.layer.borderColor = BangMauBCTD.vangSang.cgColor
        khungDanhSach.clipsToBounds = true

        let cuon = UIScrollView()
        cuon.alwaysBounceVertical = true
        cuon.translatesAutoresizingMaskIntoConstraints = false
        khungDanhSach.addSubview(cuon)

        let ngan = UIStackView()
        ngan.axis = .vertical
        ngan.spacing = 7
        ngan.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(ngan)

        for muc in cacMuc {
            let nut = UIButton(type: .system)
            nut.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            nut.titleLabel?.numberOfLines = 0
            nut.titleLabel?.lineBreakMode = .byWordWrapping
            nut.contentHorizontalAlignment = .left
            nut.contentEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 12)
            nut.layer.cornerRadius = 10
            nut.clipsToBounds = true

            let vach = UIView()
            vach.isUserInteractionEnabled = false
            vach.translatesAutoresizingMaskIntoConstraints = false
            nut.addSubview(vach)
            NSLayoutConstraint.activate([
                vach.topAnchor.constraint(equalTo: nut.topAnchor),
                vach.bottomAnchor.constraint(equalTo: nut.bottomAnchor),
                vach.leadingAnchor.constraint(equalTo: nut.leadingAnchor),
                vach.widthAnchor.constraint(equalToConstant: 5)
            ])
            nut.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                if self.dangChon.contains(muc.khoa) { self.dangChon.remove(muc.khoa) }
                else { self.dangChon.insert(muc.khoa) }
                self.capNhatTrangThai()
                self.khiThayDoi?(self.dangChon)
            }, for: .touchUpInside)
            cacNutHang.append((muc, nut, vach))
            ngan.addArrangedSubview(nut)
        }

        nutTatCa.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.dangChon = Set(self.cacMuc.map(\.khoa))
            self.capNhatTrangThai()
            self.khiThayDoi?(self.dangChon)
        }, for: .touchUpInside)
        nutBoTatCa.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.dangChon = []
            self.capNhatTrangThai()
            self.khiThayDoi?(self.dangChon)
        }, for: .touchUpInside)

        [hangDau, nhanMoTa, hangNut, khungDanhSach].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            khung.addSubview($0)
        }
        NSLayoutConstraint.activate([
            khung.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            khung.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            khung.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            khung.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            vachTrai.topAnchor.constraint(equalTo: khung.topAnchor), vachTrai.bottomAnchor.constraint(equalTo: khung.bottomAnchor),
            vachTrai.leadingAnchor.constraint(equalTo: khung.leadingAnchor), vachTrai.widthAnchor.constraint(equalToConstant: 5),
            hangDau.topAnchor.constraint(equalTo: khung.topAnchor, constant: 12),
            hangDau.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            hangDau.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),
            nhanMoTa.topAnchor.constraint(equalTo: hangDau.bottomAnchor, constant: 6),
            nhanMoTa.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            nhanMoTa.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),
            hangNut.topAnchor.constraint(equalTo: nhanMoTa.bottomAnchor, constant: 10),
            hangNut.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 12),
            hangNut.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -12),
            khungDanhSach.topAnchor.constraint(equalTo: hangNut.bottomAnchor, constant: 10),
            khungDanhSach.leadingAnchor.constraint(equalTo: vachTrai.trailingAnchor, constant: 10),
            khungDanhSach.trailingAnchor.constraint(equalTo: khung.trailingAnchor, constant: -10),
            khungDanhSach.bottomAnchor.constraint(equalTo: khung.bottomAnchor, constant: -10),
            cuon.topAnchor.constraint(equalTo: khungDanhSach.topAnchor), cuon.leadingAnchor.constraint(equalTo: khungDanhSach.leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: khungDanhSach.trailingAnchor), cuon.bottomAnchor.constraint(equalTo: khungDanhSach.bottomAnchor),
            ngan.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor, constant: 10),
            ngan.leadingAnchor.constraint(equalTo: cuon.frameLayoutGuide.leadingAnchor, constant: 10),
            ngan.trailingAnchor.constraint(equalTo: cuon.frameLayoutGuide.trailingAnchor, constant: -10),
            ngan.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor, constant: -14)
        ])
        capNhatTrangThai()
    }

    private func taoNut(_ tieuDe: String, nen: UIColor, mauChu: UIColor) -> UIButton {
        let nut = UIButton(type: .system)
        nut.setTitle(tieuDe, for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: 12.5, weight: .heavy)
        nut.titleLabel?.numberOfLines = 0
        nut.backgroundColor = nen
        nut.setTitleColor(mauChu, for: .normal)
        nut.layer.cornerRadius = 9
        nut.layer.borderWidth = 1.5
        nut.layer.borderColor = BangMauBCTD.vangChuDao.cgColor
        nut.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        return nut
    }

    private func capNhatTrangThai() {
        nhanMoTa.text = "Đang chọn \(dangChon.count)/\(cacMuc.count) môn • Chỉ các môn tích chọn được hiển thị, xuất ảnh và gửi bot:"
        for (muc, nut, vach) in cacNutHang {
            let chon = dangChon.contains(muc.khoa)
            nut.setTitle("\(chon ? "☑️" : "⬜")  \(muc.ten)", for: .normal)
            nut.backgroundColor = chon ? BangMauBCTD.vangNhatNen : BangMauBCTD.nenThe
            nut.layer.borderWidth = chon ? 1.8 : 1
            nut.layer.borderColor = (chon ? BangMauBCTD.xanhChuDao : BangMauBCTD.vienXanhNhat).cgColor
            nut.setTitleColor(chon ? BangMauBCTD.xanhChuDaoDam : BangMauBCTD.chuPhu, for: .normal)
            vach.backgroundColor = BangMauBCTD.vangChuDao
            vach.isHidden = !chon
        }
    }
}
