import UIKit

final class KhungXemAnhZoom: UIView, UIScrollViewDelegate {
    var khiBamChonAnh: (() -> Void)?
    var khiBamDanAnh: (() -> Void)?
    var khiBamChiaSeAnh: ((UIImage) -> Void)?
    var khiBamXoaAnh: (() -> Void)?

    private let tieuDeMuc: String
    private let cuon = UIScrollView()
    private let khungAnh = UIImageView()
    private let khungTrong = UIControl()
    private let nhanTieuDeTrong = UILabel()
    private let nhanPhuTrong = UILabel()
    private let nutChiaSe = UIButton(type: .system)
    private let nutXoa = UIButton(type: .system)
    private let nhanGoiYZoom = UILabel()

    init(tieuDeMuc: String) {
        self.tieuDeMuc = tieuDeMuc
        super.init(frame: .zero)
        taoGiaoDien()
    }

    required init?(coder: NSCoder) {
        fatalError("Khong ho tro coder")
    }

    private func taoGiaoDien() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 16
        clipsToBounds = true

        // Thanh công cụ phía trên
        let nutChon = taoNutCongCu(tieuDe: "Chọn ảnh", bieuTuong: "photo.badge.plus", mauChinh: true)
        nutChon.addTarget(self, action: #selector(bamChon), for: .touchUpInside)

        let nutDan = taoNutCongCu(tieuDe: "Dán ảnh", bieuTuong: "doc.on.clipboard", mauChinh: false)
        nutDan.addTarget(self, action: #selector(bamDan), for: .touchUpInside)

        nutChiaSe.setTitle(" Chia sẻ", for: .normal)
        nutChiaSe.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        nutChiaSe.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        nutChiaSe.backgroundColor = .tertiarySystemFill
        nutChiaSe.layer.cornerRadius = 8
        nutChiaSe.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutChiaSe.addTarget(self, action: #selector(bamChiaSe), for: .touchUpInside)

        nutXoa.setImage(UIImage(systemName: "trash"), for: .normal)
        nutXoa.tintColor = .systemRed
        nutXoa.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        nutXoa.layer.cornerRadius = 8
        nutXoa.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        nutXoa.addTarget(self, action: #selector(bamXoa), for: .touchUpInside)

        let thanhCongCu = UIStackView(arrangedSubviews: [nutChon, nutDan, UIView(), nutChiaSe, nutXoa])
        thanhCongCu.axis = .horizontal
        thanhCongCu.spacing = 8
        thanhCongCu.alignment = .center

        let vachNgan = UIView()
        vachNgan.backgroundColor = .separator

        // Vùng cuộn phóng to / thu nhỏ ảnh
        cuon.delegate = self
        cuon.minimumZoomScale = 1.0
        cuon.maximumZoomScale = 5.0
        cuon.showsHorizontalScrollIndicator = true
        cuon.showsVerticalScrollIndicator = true
        cuon.backgroundColor = .systemBackground
        cuon.bouncesZoom = true

        khungAnh.contentMode = .scaleAspectFit
        khungAnh.isUserInteractionEnabled = true
        khungAnh.translatesAutoresizingMaskIntoConstraints = false
        cuon.addSubview(khungAnh)

        let chamDup = UITapGestureRecognizer(target: self, action: #selector(xuLyChamDup(_:)))
        chamDup.numberOfTapsRequired = 2
        cuon.addGestureRecognizer(chamDup)

        // Khung hiển thị khi chưa có ảnh
        khungTrong.backgroundColor = .systemBackground
        khungTrong.addTarget(self, action: #selector(bamChon), for: .touchUpInside)

        let bieuTuongTrong = UIImageView(image: UIImage(systemName: "photo.on.rectangle.angled"))
        bieuTuongTrong.tintColor = .systemBlue
        bieuTuongTrong.contentMode = .scaleAspectFit
        bieuTuongTrong.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 52, weight: .regular)

        nhanTieuDeTrong.text = "Chưa có ảnh \(tieuDeMuc)"
        nhanTieuDeTrong.font = .systemFont(ofSize: 17, weight: .bold)
        nhanTieuDeTrong.textColor = .label
        nhanTieuDeTrong.textAlignment = .center
        nhanTieuDeTrong.numberOfLines = 0

        nhanPhuTrong.text = "Chạm vào đây để chọn ảnh chụp màn hình từ máy,\nhoặc bấm \"Dán ảnh\" nếu đã sao chép ảnh."
        nhanPhuTrong.font = .systemFont(ofSize: 14, weight: .regular)
        nhanPhuTrong.textColor = .secondaryLabel
        nhanPhuTrong.textAlignment = .center
        nhanPhuTrong.numberOfLines = 0

        let nutChonLon = UIButton(type: .system)
        nutChonLon.setTitle("  Chọn ảnh chụp màn hình  ", for: .normal)
        nutChonLon.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        nutChonLon.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        nutChonLon.backgroundColor = .systemBlue
        nutChonLon.tintColor = .white
        nutChonLon.layer.cornerRadius = 12
        nutChonLon.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        nutChonLon.isUserInteractionEnabled = false

        let nganXepTrong = UIStackView(arrangedSubviews: [bieuTuongTrong, nhanTieuDeTrong, nhanPhuTrong, nutChonLon])
        nganXepTrong.axis = .vertical
        nganXepTrong.spacing = 12
        nganXepTrong.alignment = .center
        nganXepTrong.isUserInteractionEnabled = false
        nganXepTrong.translatesAutoresizingMaskIntoConstraints = false
        khungTrong.addSubview(nganXepTrong)

        nhanGoiYZoom.text = "Chạm đúp hoặc dùng 2 ngón tay để phóng to / thu nhỏ"
        nhanGoiYZoom.font = .systemFont(ofSize: 11, weight: .medium)
        nhanGoiYZoom.textColor = .white
        nhanGoiYZoom.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        nhanGoiYZoom.textAlignment = .center
        nhanGoiYZoom.layer.cornerRadius = 10
        nhanGoiYZoom.clipsToBounds = true

        [thanhCongCu, vachNgan, cuon, khungTrong, nhanGoiYZoom].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            thanhCongCu.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            thanhCongCu.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thanhCongCu.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thanhCongCu.heightAnchor.constraint(equalToConstant: 36),

            vachNgan.topAnchor.constraint(equalTo: thanhCongCu.bottomAnchor, constant: 6),
            vachNgan.leadingAnchor.constraint(equalTo: leadingAnchor),
            vachNgan.trailingAnchor.constraint(equalTo: trailingAnchor),
            vachNgan.heightAnchor.constraint(equalToConstant: 0.5),

            cuon.topAnchor.constraint(equalTo: vachNgan.bottomAnchor),
            cuon.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuon.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuon.bottomAnchor.constraint(equalTo: bottomAnchor),

            khungAnh.widthAnchor.constraint(equalTo: cuon.frameLayoutGuide.widthAnchor),
            khungAnh.heightAnchor.constraint(equalTo: cuon.frameLayoutGuide.heightAnchor),
            khungAnh.topAnchor.constraint(equalTo: cuon.contentLayoutGuide.topAnchor),
            khungAnh.leadingAnchor.constraint(equalTo: cuon.contentLayoutGuide.leadingAnchor),
            khungAnh.trailingAnchor.constraint(equalTo: cuon.contentLayoutGuide.trailingAnchor),
            khungAnh.bottomAnchor.constraint(equalTo: cuon.contentLayoutGuide.bottomAnchor),

            khungTrong.topAnchor.constraint(equalTo: vachNgan.bottomAnchor),
            khungTrong.leadingAnchor.constraint(equalTo: leadingAnchor),
            khungTrong.trailingAnchor.constraint(equalTo: trailingAnchor),
            khungTrong.bottomAnchor.constraint(equalTo: bottomAnchor),

            nganXepTrong.centerXAnchor.constraint(equalTo: khungTrong.centerXAnchor),
            nganXepTrong.centerYAnchor.constraint(equalTo: khungTrong.centerYAnchor),
            nganXepTrong.leadingAnchor.constraint(greaterThanOrEqualTo: khungTrong.leadingAnchor, constant: 24),
            nganXepTrong.trailingAnchor.constraint(lessThanOrEqualTo: khungTrong.trailingAnchor, constant: -24),

            nhanGoiYZoom.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            nhanGoiYZoom.centerXAnchor.constraint(equalTo: centerXAnchor),
            nhanGoiYZoom.widthAnchor.constraint(equalToConstant: 300),
            nhanGoiYZoom.heightAnchor.constraint(equalToConstant: 22)
        ])

        ganAnh(nil)
    }

    func ganAnh(_ anh: UIImage?) {
        cuon.setZoomScale(1.0, animated: false)
        khungAnh.image = anh
        let coAnh = (anh != nil)
        khungTrong.isHidden = coAnh
        cuon.isHidden = !coAnh
        nutChiaSe.isHidden = !coAnh
        nutXoa.isHidden = !coAnh
        nhanGoiYZoom.isHidden = !coAnh
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        khungAnh
    }

    @objc private func xuLyChamDup(_ gesture: UITapGestureRecognizer) {
        if cuon.zoomScale > 1.05 {
            cuon.setZoomScale(1.0, animated: true)
        } else {
            let diem = gesture.location(in: khungAnh)
            let kichThuoc = CGSize(
                width: cuon.bounds.width / 2.5,
                height: cuon.bounds.height / 2.5
            )
            let hinhChuNhat = CGRect(
                x: diem.x - kichThuoc.width / 2,
                y: diem.y - kichThuoc.height / 2,
                width: kichThuoc.width,
                height: kichThuoc.height
            )
            cuon.zoom(to: hinhChuNhat, animated: true)
        }
    }

    @objc private func bamChon() { khiBamChonAnh?() }
    @objc private func bamDan() { khiBamDanAnh?() }
    @objc private func bamChiaSe() {
        guard let anh = khungAnh.image else { return }
        khiBamChiaSeAnh?(anh)
    }
    @objc private func bamXoa() { khiBamXoaAnh?() }

    private func taoNutCongCu(tieuDe: String, bieuTuong: String, mauChinh: Bool) -> UIButton {
        let nut = UIButton(type: .system)
        nut.setTitle(" \(tieuDe)", for: .normal)
        nut.setImage(UIImage(systemName: bieuTuong), for: .normal)
        nut.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        nut.backgroundColor = mauChinh ? .systemBlue : .tertiarySystemFill
        nut.tintColor = mauChinh ? .white : .label
        nut.layer.cornerRadius = 8
        nut.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        return nut
    }
}
