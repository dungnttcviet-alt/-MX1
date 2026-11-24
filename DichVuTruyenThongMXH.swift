import UIKit

// MARK: - 1. Mô Hình Dữ Liệu Công Cụ AI Truyền Thông & Tự Đăng Mạng Xã Hội (FB, Zalo OA, TikTok)

enum NenTangMXH: String, CaseIterable, Codable {
    case facebook = "facebook"
    case zaloOA = "zalo_oa"
    case tiktok = "tiktok"

    var tieuDe: String {
        switch self {
        case .facebook: return "Facebook Page"
        case .zaloOA: return "Zalo OA"
        case .tiktok: return "TikTok"
        }
    }

    var tieuDeNgan: String {
        switch self {
        case .facebook: return "Facebook"
        case .zaloOA: return "Zalo OA"
        case .tiktok: return "TikTok"
        }
    }

    var bieuTuongSF: String {
        switch self {
        case .facebook: return "f.square.fill"
        case .zaloOA: return "message.badge.filled.fill"
        case .tiktok: return "music.note"
        }
    }

    var mauChuDao: UIColor {
        switch self {
        case .facebook: return UIColor(red: 0.09, green: 0.47, blue: 0.95, alpha: 1.0) // #1877F2
        case .zaloOA: return UIColor(red: 0.00, green: 0.41, blue: 1.00, alpha: 1.0)   // #0068FF
        case .tiktok: return UIColor(red: 0.09, green: 0.11, blue: 0.16, alpha: 1.0)   // #171C29
        }
    }

    var tyLeAnhMacDinh: TyLeAnhMXH {
        switch self {
        case .facebook: return .vuong1x1
        case .zaloOA: return .vuong1x1
        case .tiktok: return .doc9x16
        }
    }
}

enum TyLeAnhMXH: String, CaseIterable, Codable {
    case vuong1x1 = "1:1"
    case doc4x5 = "4:5"
    case doc9x16 = "9:16"

    var tieuDe: String {
        switch self {
        case .vuong1x1: return "1:1 Vuông (FB / Zalo)"
        case .doc4x5: return "4:5 Feed (Facebook)"
        case .doc9x16: return "9:16 Dọc (TikTok / Reel)"
        }
    }

    var kichThuocPixel: CGSize {
        switch self {
        case .vuong1x1: return CGSize(width: CGFloat(1080), height: CGFloat(1080))
        case .doc4x5: return CGSize(width: CGFloat(1080), height: CGFloat(1350))
        case .doc9x16: return CGSize(width: CGFloat(1080), height: CGFloat(1920))
        }
    }
}

enum PhongCachThietKeAnh: String, CaseIterable, Codable {
    case chuanDMX = "chuan_dmx"
    case flashSale = "flash_sale"
    case caoCap = "cao_cap"
    case batTrend = "bat_trend"

    var tieuDe: String {
        switch self {
        case .chuanDMX: return "💙 Chuẩn ĐMX (Xanh - Vàng)"
        case .flashSale: return "⚡ Flash Sale (Đỏ - Vàng Sốc)"
        case .caoCap: return "✨ Sang Trọng (Xanh Đêm - Vàng Kim)"
        case .batTrend: return "🔥 Bắt Trend TikTok (Tương Phản Mạnh)"
        }
    }

    var tieuDeNgan: String {
        switch self {
        case .chuanDMX: return "Chuẩn ĐMX"
        case .flashSale: return "Flash Sale"
        case .caoCap: return "Cao Cấp"
        case .batTrend: return "Bắt Trend"
        }
    }
}

struct CauHinhLienKetMXH: Codable {
    // Facebook Page Graph API
    var fbTenTrang: String = ""
    var fbPageId: String = ""
    var fbAccessToken: String = ""
    var fbBatDang: Bool = true

    // Zalo OA Open API
    var zaloTenOA: String = ""
    var zaloOAId: String = ""
    var zaloAccessToken: String = ""
    var zaloBatDang: Bool = true

    // TikTok Content Posting API
    var tiktokTenKenh: String = ""
    var tiktokAccessToken: String = ""
    var tiktokBatDang: Bool = true

    // Webhook trung gian tùy chọn (Make / n8n / Cloudflare Worker) để đẩy đa kênh 1 chạm
    var webhookUrl: String = ""
    var webhookSecret: String = ""

    // Thông tin siêu thị mặc định in lên chân ảnh poster & cuối bài viết
    var tenSieuThiMacDinh: String = "ĐIỆN MÁY XANH"
    var hotlineMacDinh: String = ""
    var diaChiMacDinh: String = ""

    func daLienKet(_ nenTang: NenTangMXH) -> Bool {
        let coWebhook = !webhookUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        switch nenTang {
        case .facebook:
            return (!fbPageId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                    !fbAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) || coWebhook
        case .zaloOA:
            return !zaloAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || coWebhook
        case .tiktok:
            return !tiktokAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || coWebhook
        }
    }

    func tenHienThi(_ nenTang: NenTangMXH) -> String {
        switch nenTang {
        case .facebook:
            let t = fbTenTrang.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { return t }
            return fbPageId.isEmpty ? "Chưa liên kết" : "Page #\(fbPageId)"
        case .zaloOA:
            let t = zaloTenOA.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { return t }
            return zaloOAId.isEmpty ? "Chưa liên kết" : "OA #\(zaloOAId)"
        case .tiktok:
            let t = tiktokTenKenh.trimmingCharacters(in: .whitespacesAndNewlines)
            if !t.isEmpty { return t }
            return tiktokAccessToken.isEmpty ? "Chưa liên kết" : "Kênh TikTok"
        }
    }

    func dangBat(_ nenTang: NenTangMXH) -> Bool {
        switch nenTang {
        case .facebook: return fbBatDang
        case .zaloOA: return zaloBatDang
        case .tiktok: return tiktokBatDang
        }
    }

    mutating func datBat(_ nenTang: NenTangMXH, bat: Bool) {
        switch nenTang {
        case .facebook: fbBatDang = bat
        case .zaloOA: zaloBatDang = bat
        case .tiktok: tiktokBatDang = bat
        }
    }
}

struct DeXuatBaiDangMXH: Identifiable, Codable {
    var id: String = UUID().uuidString
    var tenPhuongAn: String
    var gocTiepCan: String
    var phongCach: PhongCachThietKeAnh
    var tieuDeAnh: String
    var phuDeAnh: String
    var nhanNoiBat: String
    var giaHienThi: String
    var ctaAnh: String
    var noiDungFacebook: String
    var noiDungZaloOA: String
    var noiDungTikTok: String
    var daDuyet: Bool = false

    func noiDung(cho nenTang: NenTangMXH) -> String {
        switch nenTang {
        case .facebook: return noiDungFacebook
        case .zaloOA: return noiDungZaloOA
        case .tiktok: return noiDungTikTok
        }
    }

    mutating func capNhatNoiDung(_ vanBan: String, cho nenTang: NenTangMXH) {
        switch nenTang {
        case .facebook: noiDungFacebook = vanBan
        case .zaloOA: noiDungZaloOA = vanBan
        case .tiktok: noiDungTikTok = vanBan
        }
    }
}

struct BanGhiLichSuDangMXH: Identifiable, Codable {
    var id: String = UUID().uuidString
    var thoiGian: Date = Date()
    var tieuDeAnh: String
    var tenPhuongAn: String
    var cacNenTang: [String]
    var ketQuaChiTiet: [String]
    var thanhCongHet: Bool
}

struct KhoLuuTruMXH: Codable {
    var cauHinh: CauHinhLienKetMXH = CauHinhLienKetMXH()
    var lichSuDang: [BanGhiLichSuDangMXH] = []
}

// MARK: - 2. Quản Lý Lưu Trữ Bất Đồng Bộ (Không Chặn Main Thread)

final class QuanLyDuLieuMXH {
    static let dungChung = QuanLyDuLieuMXH()

    private let hangDoiIO = DispatchQueue(label: "dmx.truyenthong.mxh.io", qos: .utility)
    private let khoa = NSLock()
    private var duLieu: KhoLuuTruMXH = KhoLuuTruMXH()
    private var congViecLuu: DispatchWorkItem?

    private var duongDanFile: URL {
        let thuMuc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("DuLieuDMX", isDirectory: true)
        if !FileManager.default.fileExists(atPath: thuMuc.path) {
            try? FileManager.default.createDirectory(at: thuMuc, withIntermediateDirectories: true)
        }
        return thuMuc.appendingPathComponent("truyen-thong-mxh-v1.json")
    }

    private init() {
        taiDongBoBanDau()
    }

    private func taiDongBoBanDau() {
        guard let data = try? Data(contentsOf: duongDanFile),
              let giaiMa = try? JSONDecoder().decode(KhoLuuTruMXH.self, from: data) else {
            return
        }
        khoa.lock()
        duLieu = giaiMa
        khoa.unlock()
    }

    var cauHinh: CauHinhLienKetMXH {
        get {
            khoa.lock()
            defer { khoa.unlock() }
            return duLieu.cauHinh
        }
        set {
            khoa.lock()
            duLieu.cauHinh = newValue
            let banSao = duLieu
            khoa.unlock()
            luuBatDongBo(banSao)
        }
    }

    var lichSuDang: [BanGhiLichSuDangMXH] {
        khoa.lock()
        defer { khoa.unlock() }
        return duLieu.lichSuDang
    }

    func themLichSu(_ banGhi: BanGhiLichSuDangMXH) {
        khoa.lock()
        duLieu.lichSuDang.insert(banGhi, at: 0)
        if duLieu.lichSuDang.count > 30 {
            duLieu.lichSuDang = Array(duLieu.lichSuDang.prefix(30))
        }
        let banSao = duLieu
        khoa.unlock()
        luuBatDongBo(banSao)
    }

    private func luuBatDongBo(_ banSao: KhoLuuTruMXH) {
        let url = duongDanFile
        congViecLuu?.cancel()
        let item = DispatchWorkItem {
            guard let data = try? JSONEncoder().encode(banSao) else { return }
            try? data.write(to: url, options: [.atomic])
        }
        congViecLuu = item
        hangDoiIO.asyncAfter(deadline: .now() + 0.25, execute: item)
    }
}

// MARK: - 3. Bộ Thiết Kế Hình Ảnh Quảng Cáo Tự Động (Poster Hấp Dẫn Chuẩn ĐMX)

enum BoThietKeAnhQuangCaoDMX {

    static func veAnhQuangCao(
        anhGoc: UIImage,
        deXuat: DeXuatBaiDangMXH,
        phongCach: PhongCachThietKeAnh,
        tyLe: TyLeAnhMXH,
        tenSieuThi: String,
        hotline: String
    ) -> UIImage {
        let kichThuoc = tyLe.kichThuocPixel
        let w = kichThuoc.width
        let h = kichThuoc.height

        let dinhDang = UIGraphicsImageRendererFormat()
        dinhDang.scale = 1.0
        dinhDang.opaque = true

        let renderer = UIGraphicsImageRenderer(size: kichThuoc, format: dinhDang)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            let mau = bangMauPhongCach(phongCach)

            // 1. Nền Gradient sống động thu hút ánh nhìn ngay lập tức
            veNenGradient(cg: cg, rect: CGRect(x: 0, y: 0, width: w, height: h), mauTren: mau.nenTren, mauDuoi: mau.nenDuoi)

            // 2. Vòng sáng & họa tiết trang trí tạo chiều sâu thị giác
            cg.saveGState()
            cg.setFillColor(mau.anhSangPhu.withAlphaComponent(0.16).cgColor)
            cg.fillEllipse(in: CGRect(x: -w * 0.18, y: -h * 0.10, width: w * 0.72, height: w * 0.72))
            cg.setFillColor(mau.mauNhan.withAlphaComponent(0.14).cgColor)
            cg.fillEllipse(in: CGRect(x: w * 0.56, y: h * 0.62, width: w * 0.68, height: w * 0.68))

            // Dải tia sáng chéo nhẹ phía sau sản phẩm
            cg.setFillColor(UIColor.white.withAlphaComponent(0.06).cgColor)
            let duongCheo = UIBezierPath()
            duongCheo.move(to: CGPoint(x: w * 0.15, y: 0))
            duongCheo.addLine(to: CGPoint(x: w * 0.42, y: 0))
            duongCheo.addLine(to: CGPoint(x: w * 0.08, y: h))
            duongCheo.addLine(to: CGPoint(x: -w * 0.15, y: h))
            duongCheo.close()
            duongCheo.fill()
            cg.restoreGState()

            let leNgang: CGFloat = 52
            let rongNoiDung = w - leNgang * 2

            // 3. Thanh thương hiệu trên cùng + Nhãn HOT DEAL nổi bật
            let yTop: CGFloat = tyLe == .doc9x16 ? 78 : 44
            let tenThuongHieu = tenSieuThi.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "ĐIỆN MÁY XANH"
                : tenSieuThi.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            let pillBrandFont = UIFont.systemFont(ofSize: 28, weight: .heavy)
            let kichThuocBrand = doChieuCaoVanBan(tenThuongHieu, font: pillBrandFont, maxRong: rongNoiDung * 0.58)
            let rectBrand = CGRect(
                x: leNgang,
                y: yTop,
                width: min(rongNoiDung * 0.62, kichThuocBrand.width + 44),
                height: max(54, kichThuocBrand.height + 20)
            )
            veHinhChuNhatBoTron(cg: cg, rect: rectBrand, banKinh: 16, mauNen: mau.nenPillBrand, mauVien: mau.vienPillBrand, doDayVien: 2.5)
            veVanBan(
                tenThuongHieu,
                trong: rectBrand.insetBy(dx: 16, dy: 8),
                font: pillBrandFont,
                mau: mau.chuPillBrand,
                canLe: .center
            )

            // Nhãn nổi bật bên phải (VD: GIẢM SỐC / TRẢ GÓP 0% / HOT DEAL)
            let nhanText = (deXuat.nhanNoiBat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "ƯU ĐÃI HOT"
                : deXuat.nhanNoiBat.trimmingCharacters(in: .whitespacesAndNewlines)).uppercased()
            let fontBadge = UIFont.systemFont(ofSize: 26, weight: .black)
            let ktBadge = doChieuCaoVanBan(nhanText, font: fontBadge, maxRong: rongNoiDung * 0.42)
            let rongBadge = min(rongNoiDung * 0.45, ktBadge.width + 42)
            let caoBadge = max(54, ktBadge.height + 20)
            let rectBadge = CGRect(x: w - leNgang - rongBadge, y: yTop, width: rongBadge, height: caoBadge)
            veHinhChuNhatBoTron(cg: cg, rect: rectBadge, banKinh: 27, mauNen: mau.mauNhan, mauVien: UIColor.white.withAlphaComponent(0.85), doDayVien: 2.5)
            veVanBan(
                nhanText,
                trong: rectBadge.insetBy(dx: 14, dy: 8),
                font: fontBadge,
                mau: mau.chuTrenMauNhan,
                canLe: .center
            )

            let ySauHeader = max(rectBrand.maxY, rectBadge.maxY) + (tyLe == .doc9x16 ? 34 : 22)

            // 4. Tiêu đề chính (Headline) & Phụ đề (Subheadline) — đo chiều cao động bằng boundingRect, không bao giờ cắt chữ
            let tieuDe = deXuat.tieuDeAnh.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "ƯU ĐÃI CỰC SỐC HÔM NAY!"
                : deXuat.tieuDeAnh.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            let coChuTieuDe: CGFloat = tyLe == .doc9x16 ? 62 : (tieuDe.count > 34 ? 48 : 54)
            let fontTieuDe = UIFont.systemFont(ofSize: coChuTieuDe, weight: .black)
            let ktTieuDe = doChieuCaoVanBan(tieuDe, font: fontTieuDe, maxRong: rongNoiDung)
            let rectTieuDe = CGRect(x: leNgang, y: ySauHeader, width: rongNoiDung, height: ktTieuDe.height + 6)
            veVanBanCoBong(tieuDe, trong: rectTieuDe, font: fontTieuDe, mau: mau.chuTieuDe, canLe: .center)

            let phuDe = deXuat.phuDeAnh.trimmingCharacters(in: .whitespacesAndNewlines)
            var yBatDauKhungAnh = rectTieuDe.maxY + 18
            if !phuDe.isEmpty {
                let fontPhuDe = UIFont.systemFont(ofSize: tyLe == .doc9x16 ? 32 : 28, weight: .bold)
                let ktPhuDe = doChieuCaoVanBan(phuDe, font: fontPhuDe, maxRong: rongNoiDung)
                let rectPhuDe = CGRect(x: leNgang, y: rectTieuDe.maxY + 10, width: rongNoiDung, height: ktPhuDe.height + 6)
                veVanBan(phuDe, trong: rectPhuDe, font: fontPhuDe, mau: mau.chuPhuDe, canLe: .center)
                yBatDauKhungAnh = rectPhuDe.maxY + (tyLe == .doc9x16 ? 32 : 20)
            }

            // 5. Thanh CTA dưới cùng (tính trước chiều cao để khung ảnh sản phẩm tự co giãn cân đối tuyệt đối)
            let ctaText = deXuat.ctaAnh.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "NHẮN TIN / GỌI NGAY ĐỂ NHẬN ƯU ĐÃI"
                : deXuat.ctaAnh.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            let hotlineSach = hotline.trimmingCharacters(in: .whitespacesAndNewlines)
            let dongFooter = hotlineSach.isEmpty ? ctaText : "\(ctaText)  •  📞 \(hotlineSach)"
            let fontCTA = UIFont.systemFont(ofSize: 28, weight: .heavy)
            let ktCTA = doChieuCaoVanBan(dongFooter, font: fontCTA, maxRong: rongNoiDung - 44)
            let caoCTA = max(76, ktCTA.height + 32)
            let leDuoi: CGFloat = tyLe == .doc9x16 ? 78 : 42
            let rectCTA = CGRect(x: leNgang, y: h - leDuoi - caoCTA, width: rongNoiDung, height: caoCTA)

            // 6. Khung trưng bày ảnh sản phẩm ở trung tâm (có viền sáng, đổ bóng, giữ nguyên tỷ lệ ảnh gốc sắc nét)
            let khoangCachDuoiAnh: CGFloat = 24
            let caoKhungAnh = max(260, rectCTA.minY - khoangCachDuoiAnh - yBatDauKhungAnh)
            let rectKhungAnh = CGRect(x: leNgang, y: yBatDauKhungAnh, width: rongNoiDung, height: caoKhungAnh)

            // Đổ bóng khung sản phẩm
            cg.saveGState()
            cg.setShadow(offset: CGSize(width: CGFloat(0), height: CGFloat(14)), blur: 28, color: UIColor.black.withAlphaComponent(0.28).cgColor)
            let pathKhung = UIBezierPath(roundedRect: rectKhungAnh, cornerRadius: 30)
            UIColor.white.setFill()
            pathKhung.fill()
            cg.restoreGState()

            // Ảnh sản phẩm bên trong (nền mờ nhẹ phía sau + ảnh chính sắc nét đúng tỷ lệ để không bị cắt mất chi tiết sản phẩm)
            let rectAnhTrong = rectKhungAnh.insetBy(dx: 12, dy: 12)
            cg.saveGState()
            UIBezierPath(roundedRect: rectAnhTrong, cornerRadius: 22).addClip()

            // Lớp nền mềm phủ kín khung
            veAnhFill(anhGoc, trong: rectAnhTrong, alpha: 0.22)
            UIColor.white.withAlphaComponent(0.70).setFill()
            UIRectFillUsingBlendMode(rectAnhTrong, .normal)

            // Lớp ảnh sản phẩm chính hiển thị đầy đủ
            veAnhFit(anhGoc, trong: rectAnhTrong.insetBy(dx: 8, dy: 8))
            cg.restoreGState()

            // Viền nổi bật quanh khung ảnh
            let pathVienKhung = UIBezierPath(roundedRect: rectKhungAnh, cornerRadius: 30)
            mau.mauNhan.withAlphaComponent(0.95).setStroke()
            pathVienKhung.lineWidth = 5
            pathVienKhung.stroke()

            // 7. Tem Giá / Ưu Đãi Nổi Bật góc dưới phải khung ảnh (nếu có)
            let giaText = deXuat.giaHienThi.trimmingCharacters(in: .whitespacesAndNewlines)
            if !giaText.isEmpty {
                let fontGia = UIFont.systemFont(ofSize: 34, weight: .black)
                let ktGia = doChieuCaoVanBan(giaText, font: fontGia, maxRong: rongNoiDung * 0.72)
                let rongTem = min(rongNoiDung * 0.78, ktGia.width + 52)
                let caoTem = max(68, ktGia.height + 26)
                let rectTem = CGRect(
                    x: rectKhungAnh.maxX - rongTem - 18,
                    y: rectKhungAnh.maxY - caoTem - 18,
                    width: rongTem,
                    height: caoTem
                )
                cg.saveGState()
                cg.setShadow(offset: CGSize(width: CGFloat(0), height: CGFloat(8)), blur: 16, color: UIColor.black.withAlphaComponent(0.30).cgColor)
                veHinhChuNhatBoTron(cg: cg, rect: rectTem, banKinh: 20, mauNen: mau.nenTemGia, mauVien: UIColor.white, doDayVien: 3.5)
                cg.restoreGState()
                veVanBan(
                    giaText,
                    trong: rectTem.insetBy(dx: 16, dy: 8),
                    font: fontGia,
                    mau: mau.chuTemGia,
                    canLe: .center
                )
            }

            // 8. Vẽ thanh CTA dưới cùng
            cg.saveGState()
            cg.setShadow(offset: CGSize(width: CGFloat(0), height: CGFloat(8)), blur: 16, color: UIColor.black.withAlphaComponent(0.22).cgColor)
            veHinhChuNhatBoTron(cg: cg, rect: rectCTA, banKinh: 22, mauNen: mau.nenCTA, mauVien: mau.vienCTA, doDayVien: 2.5)
            cg.restoreGState()
            veVanBan(
                dongFooter,
                trong: rectCTA.insetBy(dx: 20, dy: 12),
                font: fontCTA,
                mau: mau.chuCTA,
                canLe: .center
            )
        }
    }

    private struct BangMauPoster {
        let nenTren: UIColor
        let nenDuoi: UIColor
        let anhSangPhu: UIColor
        let mauNhan: UIColor
        let chuTrenMauNhan: UIColor
        let nenPillBrand: UIColor
        let vienPillBrand: UIColor
        let chuPillBrand: UIColor
        let chuTieuDe: UIColor
        let chuPhuDe: UIColor
        let nenTemGia: UIColor
        let chuTemGia: UIColor
        let nenCTA: UIColor
        let vienCTA: UIColor
        let chuCTA: UIColor
    }

    private static func bangMauPhongCach(_ phongCach: PhongCachThietKeAnh) -> BangMauPoster {
        switch phongCach {
        case .chuanDMX:
            return BangMauPoster(
                nenTren: UIColor(red: 0.05, green: 0.34, blue: 0.90, alpha: 1.0),
                nenDuoi: UIColor(red: 0.01, green: 0.56, blue: 0.88, alpha: 1.0),
                anhSangPhu: UIColor.white,
                mauNhan: UIColor(red: 1.00, green: 0.84, blue: 0.05, alpha: 1.0),
                chuTrenMauNhan: UIColor(red: 0.08, green: 0.14, blue: 0.25, alpha: 1.0),
                nenPillBrand: UIColor.white.withAlphaComponent(0.18),
                vienPillBrand: UIColor.white.withAlphaComponent(0.65),
                chuPillBrand: UIColor.white,
                chuTieuDe: UIColor(red: 1.00, green: 0.90, blue: 0.16, alpha: 1.0),
                chuPhuDe: UIColor.white,
                nenTemGia: UIColor(red: 0.88, green: 0.12, blue: 0.14, alpha: 1.0),
                chuTemGia: UIColor.white,
                nenCTA: UIColor(red: 1.00, green: 0.84, blue: 0.08, alpha: 1.0),
                vienCTA: UIColor.white,
                chuCTA: UIColor(red: 0.09, green: 0.15, blue: 0.26, alpha: 1.0)
            )
        case .flashSale:
            return BangMauPoster(
                nenTren: UIColor(red: 0.82, green: 0.07, blue: 0.12, alpha: 1.0),
                nenDuoi: UIColor(red: 0.96, green: 0.35, blue: 0.05, alpha: 1.0),
                anhSangPhu: UIColor(red: 1.00, green: 0.92, blue: 0.35, alpha: 1.0),
                mauNhan: UIColor(red: 1.00, green: 0.87, blue: 0.05, alpha: 1.0),
                chuTrenMauNhan: UIColor(red: 0.55, green: 0.04, blue: 0.06, alpha: 1.0),
                nenPillBrand: UIColor(red: 0.07, green: 0.36, blue: 0.88, alpha: 1.0),
                vienPillBrand: UIColor(red: 1.00, green: 0.87, blue: 0.05, alpha: 1.0),
                chuPillBrand: UIColor.white,
                chuTieuDe: UIColor.white,
                chuPhuDe: UIColor(red: 1.00, green: 0.96, blue: 0.78, alpha: 1.0),
                nenTemGia: UIColor(red: 1.00, green: 0.84, blue: 0.05, alpha: 1.0),
                chuTemGia: UIColor(red: 0.58, green: 0.05, blue: 0.05, alpha: 1.0),
                nenCTA: UIColor.white,
                vienCTA: UIColor(red: 1.00, green: 0.84, blue: 0.05, alpha: 1.0),
                chuCTA: UIColor(red: 0.78, green: 0.08, blue: 0.10, alpha: 1.0)
            )
        case .caoCap:
            return BangMauPoster(
                nenTren: UIColor(red: 0.07, green: 0.13, blue: 0.26, alpha: 1.0),
                nenDuoi: UIColor(red: 0.13, green: 0.24, blue: 0.44, alpha: 1.0),
                anhSangPhu: UIColor(red: 0.96, green: 0.78, blue: 0.30, alpha: 1.0),
                mauNhan: UIColor(red: 0.96, green: 0.78, blue: 0.28, alpha: 1.0),
                chuTrenMauNhan: UIColor(red: 0.08, green: 0.12, blue: 0.22, alpha: 1.0),
                nenPillBrand: UIColor.white.withAlphaComponent(0.14),
                vienPillBrand: UIColor(red: 0.96, green: 0.78, blue: 0.28, alpha: 0.8),
                chuPillBrand: UIColor(red: 1.00, green: 0.93, blue: 0.72, alpha: 1.0),
                chuTieuDe: UIColor(red: 1.00, green: 0.91, blue: 0.62, alpha: 1.0),
                chuPhuDe: UIColor(red: 0.90, green: 0.94, blue: 1.00, alpha: 1.0),
                nenTemGia: UIColor(red: 0.11, green: 0.45, blue: 0.92, alpha: 1.0),
                chuTemGia: UIColor.white,
                nenCTA: UIColor(red: 0.96, green: 0.78, blue: 0.28, alpha: 1.0),
                vienCTA: UIColor.white.withAlphaComponent(0.75),
                chuCTA: UIColor(red: 0.08, green: 0.12, blue: 0.22, alpha: 1.0)
            )
        case .batTrend:
            return BangMauPoster(
                nenTren: UIColor(red: 0.07, green: 0.09, blue: 0.15, alpha: 1.0),
                nenDuoi: UIColor(red: 0.16, green: 0.09, blue: 0.34, alpha: 1.0),
                anhSangPhu: UIColor(red: 0.00, green: 0.92, blue: 0.88, alpha: 1.0),
                mauNhan: UIColor(red: 1.00, green: 0.18, blue: 0.42, alpha: 1.0),
                chuTrenMauNhan: UIColor.white,
                nenPillBrand: UIColor(red: 0.00, green: 0.82, blue: 0.82, alpha: 0.22),
                vienPillBrand: UIColor(red: 0.00, green: 0.92, blue: 0.88, alpha: 0.9),
                chuPillBrand: UIColor.white,
                chuTieuDe: UIColor.white,
                chuPhuDe: UIColor(red: 0.65, green: 0.98, blue: 0.96, alpha: 1.0),
                nenTemGia: UIColor(red: 1.00, green: 0.18, blue: 0.42, alpha: 1.0),
                chuTemGia: UIColor.white,
                nenCTA: UIColor(red: 0.00, green: 0.88, blue: 0.84, alpha: 1.0),
                vienCTA: UIColor.white,
                chuCTA: UIColor(red: 0.06, green: 0.09, blue: 0.16, alpha: 1.0)
            )
        }
    }

    private static func veNenGradient(cg: CGContext, rect: CGRect, mauTren: UIColor, mauDuoi: UIColor) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [mauTren.cgColor, mauDuoi.cgColor] as CFArray
        if let grad = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0.0, 1.0]) {
            cg.drawLinearGradient(
                grad,
                start: CGPoint(x: rect.minX, y: rect.minY),
                end: CGPoint(x: rect.maxX, y: rect.maxY),
                options: []
            )
        }
    }

    private static func veHinhChuNhatBoTron(
        cg: CGContext,
        rect: CGRect,
        banKinh: CGFloat,
        mauNen: UIColor,
        mauVien: UIColor?,
        doDayVien: CGFloat
    ) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: banKinh)
        mauNen.setFill()
        path.fill()
        if let vien = mauVien, doDayVien > 0 {
            vien.setStroke()
            path.lineWidth = doDayVien
            path.stroke()
        }
    }

    private static func doChieuCaoVanBan(_ text: String, font: UIFont, maxRong: CGFloat) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping
        let rect = (text as NSString).boundingRect(
            with: CGSize(width: maxRong, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font, .paragraphStyle: style],
            context: nil
        )
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }

    private static func veVanBan(_ text: String, trong rect: CGRect, font: UIFont, mau: UIColor, canLe: NSTextAlignment) {
        let style = NSMutableParagraphStyle()
        style.alignment = canLe
        style.lineBreakMode = .byWordWrapping
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: mau,
            .paragraphStyle: style
        ]
        let kt = (text as NSString).boundingRect(
            with: CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attrs,
            context: nil
        )
        let yCanGiua = rect.minY + max(0, (rect.height - ceil(kt.height)) / 2)
        (text as NSString).draw(
            in: CGRect(x: rect.minX, y: yCanGiua, width: rect.width, height: ceil(kt.height) + 4),
            withAttributes: attrs
        )
    }

    private static func veVanBanCoBong(_ text: String, trong rect: CGRect, font: UIFont, mau: UIColor, canLe: NSTextAlignment) {
        let style = NSMutableParagraphStyle()
        style.alignment = canLe
        style.lineBreakMode = .byWordWrapping
        let bong = NSShadow()
        bong.shadowColor = UIColor.black.withAlphaComponent(0.32)
        bong.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(4))
        bong.shadowBlurRadius = 10
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: mau,
            .paragraphStyle: style,
            .shadow: bong
        ]
        (text as NSString).draw(in: rect, withAttributes: attrs)
    }

    private static func veAnhFill(_ anh: UIImage, trong rect: CGRect, alpha: CGFloat) {
        guard anh.size.width > 0, anh.size.height > 0 else { return }
        let tiLeRong = rect.width / anh.size.width
        let tiLeCao = rect.height / anh.size.height
        let tiLe = max(tiLeRong, tiLeCao)
        let w = anh.size.width * tiLe
        let h = anh.size.height * tiLe
        let drawRect = CGRect(x: rect.midX - w / 2, y: rect.midY - h / 2, width: w, height: h)
        anh.draw(in: drawRect, blendMode: .normal, alpha: alpha)
    }

    private static func veAnhFit(_ anh: UIImage, trong rect: CGRect) {
        guard anh.size.width > 0, anh.size.height > 0 else { return }
        let tiLeRong = rect.width / anh.size.width
        let tiLeCao = rect.height / anh.size.height
        let tiLe = min(tiLeRong, tiLeCao)
        let w = anh.size.width * tiLe
        let h = anh.size.height * tiLe
        let drawRect = CGRect(x: rect.midX - w / 2, y: rect.midY - h / 2, width: w, height: h)
        anh.draw(in: drawRect)
    }
}

// MARK: - 4. Dịch Vụ AI Gemini Vision: Phân Tích Ảnh & Tạo 3 Đề Xuất Bài Viết Đa Kênh

final class DichVuAITruyenThongMXH {
    static let dungChung = DichVuAITruyenThongMXH()
    private init() {}

    private let phienMang: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 45
        cfg.timeoutIntervalForResource = 60
        return URLSession(configuration: cfg)
    }()

    private let danhSachModel: [String] = [
        "gemini-2.5-flash",
        "gemini-2.5-flash-lite",
        "gemini-2.0-flash",
        "gemini-3.1-flash-lite-preview",
        "gemini-3.5-flash-lite"
    ]

    /// Phân tích ảnh sản phẩm và trả về 3 đề xuất bài viết + câu chữ thiết kế poster cho FB, Zalo OA, TikTok.
    func taoDeXuatTuAnh(
        anh: UIImage,
        thongTinBoSung: String,
        giaUuDai: String,
        cauHinh: CauHinhLienKetMXH,
        hoanTat: @escaping (Result<[DeXuatBaiDangMXH], Error>) -> Void
    ) {
        let anhThuNho = thuNhoAnhChoAI(anh, canhToiDa: 1024)
        guard let jpegData = anhThuNho.jpegData(compressionQuality: 0.80) else {
            let macDinh = taoDeXuatDuPhong(thongTinBoSung: thongTinBoSung, giaUuDai: giaUuDai, cauHinh: cauHinh)
            DispatchQueue.main.async { hoanTat(.success(macDinh)) }
            return
        }

        let base64Anh = jpegData.base64EncodedString()
        let dsKey = KhoDuLieu.dungChung.caiDat.danhSachGeminiApiKeyHieuLuc
        let key = dsKey.first ?? CaiDatDMX.geminiKeyMacDinh

        let tenSieuThi = cauHinh.tenSieuThiMacDinh.trimmingCharacters(in: .whitespacesAndNewlines)
        let hotline = cauHinh.hotlineMacDinh.trimmingCharacters(in: .whitespacesAndNewlines)
        let diaChi = cauHinh.diaChiMacDinh.trimmingCharacters(in: .whitespacesAndNewlines)

        let prompt = """
        Bạn là chuyên gia marketing bán lẻ của hệ thống Điện Máy Xanh tại Việt Nam.
        Hãy quan sát thật kỹ hình ảnh sản phẩm đính kèm và kết hợp thông tin người dùng cung cấp:
        - Thông tin bổ sung: \(thongTinBoSung.isEmpty ? "(Tự nhận diện từ hình ảnh)" : thongTinBoSung)
        - Giá / Ưu đãi: \(giaUuDai.isEmpty ? "(Tự nhận diện nếu có trên ảnh, nếu không thì nhấn mạnh ưu đãi trả góp 0% & quà tặng)" : giaUuDai)
        - Tên siêu thị: \(tenSieuThi.isEmpty ? "Điện Máy Xanh" : tenSieuThi)
        - Hotline: \(hotline.isEmpty ? "1900 232 461" : hotline)
        - Địa chỉ: \(diaChi.isEmpty ? "Siêu thị Điện Máy Xanh gần nhất" : diaChi)

        Hãy tạo ĐÚNG 3 phương án truyền thông khác nhau để quản lý siêu thị chọn lựa trước khi duyệt đăng:
        1. Phương án 1 (phongCach: "flash_sale"): Đánh mạnh vào giá sốc, ưu đãi nóng, thúc giục chốt đơn ngay hôm nay.
        2. Phương án 2 (phongCach: "chuan_dmx"): Chuẩn thương hiệu Điện Máy Xanh — nhấn mạnh lợi ích thực tế cho gia đình, bảo hành chính hãng, giao lắp tận nhà.
        3. Phương án 3 (phongCach: "bat_trend"): Bắt trend trẻ trung, đánh vào cảm xúc / review chân thật, tối ưu giữ chân người xem trên TikTok & Reels.

        Trả về DUY NHẤT một JSON hợp lệ (không thêm markdown ```json, không giải thích ngoài JSON) theo cấu trúc sau:
        {
          "deXuat": [
            {
              "tenPhuongAn": "Phương án 1: Săn Deal Sốc Hôm Nay",
              "gocTiepCan": "Tập trung giá tốt, ưu đãi có hạn, tạo cảm giác cấp bách",
              "phongCach": "flash_sale",
              "tieuDeAnh": "Tối đa 7 từ in hoa cực bắt mắt để in lên poster",
              "phuDeAnh": "1 dòng ngắn dưới 12 từ nêu điểm ăn tiền nhất",
              "nhanNoiBat": "2-3 từ ngắn VD: GIẢM SỐC / TRẢ GÓP 0%",
              "giaHienThi": "Giá hoặc mức ưu đãi ngắn gọn VD: CHỈ TỪ 6.990K hoặc TRẢ GÓP 0%",
              "ctaAnh": "Câu kêu gọi hành động ngắn dưới 9 từ",
              "noiDungFacebook": "Bài viết Facebook hoàn chỉnh có hook mở đầu, 3-4 gạch đầu dòng lợi ích, CTA, hotline/địa chỉ và 4-5 hashtag",
              "noiDungZaloOA": "Bài viết Zalo OA lịch sự, súc tích, dễ đọc trên điện thoại, có lời mời nhắn tin nhận báo giá",
              "noiDungTikTok": "Caption TikTok ngắn gọn, bắt trend, cuốn hút trong 2 dòng đầu + 5 hashtag viral"
            }
          ]
        }
        """

        goiGeminiDaModel(
            danhSachModel: danhSachModel,
            chiSo: 0,
            apiKey: key,
            prompt: prompt,
            base64Anh: base64Anh
        ) { ketQua in
            DispatchQueue.main.async {
                switch ketQua {
                case .success(let dsDeXuat) where !dsDeXuat.isEmpty:
                    hoanTat(.success(dsDeXuat))
                default:
                    // Nếu Gemini bận hoặc hết quota, tự sinh 3 phương án chuẩn ĐMX để người dùng vẫn làm việc mượt mà
                    let duPhong = self.taoDeXuatDuPhong(
                        thongTinBoSung: thongTinBoSung,
                        giaUuDai: giaUuDai,
                        cauHinh: cauHinh
                    )
                    hoanTat(.success(duPhong))
                }
            }
        }
    }

    private func goiGeminiDaModel(
        danhSachModel: [String],
        chiSo: Int,
        apiKey: String,
        prompt: String,
        base64Anh: String,
        hoanTat: @escaping (Result<[DeXuatBaiDangMXH], Error>) -> Void
    ) {
        guard chiSo < danhSachModel.count else {
            let err = NSError(domain: "AITruyenThongMXH", code: 503, userInfo: [NSLocalizedDescriptionKey: "Không thể kết nối AI Gemini lúc này."])
            hoanTat(.failure(err))
            return
        }

        let model = danhSachModel[chiSo]
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)") else {
            goiGeminiDaModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, base64Anh: base64Anh, hoanTat: hoanTat)
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Anh
                            ]
                        ]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.75,
                "maxOutputTokens": 4096
            ]
        ]

        guard let bodyData = try? JSONSerialization.data(withJSONObject: payload) else {
            goiGeminiDaModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, base64Anh: base64Anh, hoanTat: hoanTat)
            return
        }
        req.httpBody = bodyData

        phienMang.dataTask(with: req) { data, response, error in
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            if error != nil || code < 200 || code >= 300 || data == nil {
                self.goiGeminiDaModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, base64Anh: base64Anh, hoanTat: hoanTat)
                return
            }

            if let data = data, let ds = self.giaiMaPhanHoiGemini(data) {
                hoanTat(.success(ds))
            } else {
                self.goiGeminiDaModel(danhSachModel: danhSachModel, chiSo: chiSo + 1, apiKey: apiKey, prompt: prompt, base64Anh: base64Anh, hoanTat: hoanTat)
            }
        }.resume()
    }

    private struct PhanHoiDeXuatJSON: Decodable {
        struct Muc: Decodable {
            let tenPhuongAn: String?
            let gocTiepCan: String?
            let phongCach: String?
            let tieuDeAnh: String?
            let phuDeAnh: String?
            let nhanNoiBat: String?
            let giaHienThi: String?
            let ctaAnh: String?
            let noiDungFacebook: String?
            let noiDungZaloOA: String?
            let noiDungTikTok: String?
        }
        let deXuat: [Muc]?
    }

    private func giaiMaPhanHoiGemini(_ data: Data) -> [DeXuatBaiDangMXH]? {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = root["candidates"] as? [[String: Any]],
              let first = candidates.first,
              let content = first["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]] else {
            return nil
        }

        let vanBan = parts.compactMap { $0["text"] as? String }.joined(separator: "\n")
        guard let jsonSach = trichXuatJSON(tu: vanBan),
              let jsonData = jsonSach.data(using: .utf8),
              let ketQua = try? JSONDecoder().decode(PhanHoiDeXuatJSON.self, from: jsonData),
              let cacMuc = ketQua.deXuat,
              !cacMuc.isEmpty else {
            return nil
        }

        return cacMuc.enumerated().map { idx, muc in
            let pc = PhongCachThietKeAnh(rawValue: muc.phongCach ?? "") ?? (idx == 0 ? .flashSale : (idx == 1 ? .chuanDMX : .batTrend))
            return DeXuatBaiDangMXH(
                tenPhuongAn: muc.tenPhuongAn ?? "Phương án \(idx + 1)",
                gocTiepCan: muc.gocTiepCan ?? "Tối ưu thu hút khách hàng trên đa nền tảng",
                phongCach: pc,
                tieuDeAnh: muc.tieuDeAnh ?? "ƯU ĐÃI CỰC SỐC HÔM NAY",
                phuDeAnh: muc.phuDeAnh ?? "Trả góp 0% • Giao lắp tận nhà nhanh chóng",
                nhanNoiBat: muc.nhanNoiBat ?? "HOT DEAL",
                giaHienThi: muc.giaHienThi ?? "TRẢ GÓP 0%",
                ctaAnh: muc.ctaAnh ?? "NHẮN TIN NHẬN GIÁ TỐT NGAY",
                noiDungFacebook: muc.noiDungFacebook ?? "",
                noiDungZaloOA: muc.noiDungZaloOA ?? "",
                noiDungTikTok: muc.noiDungTikTok ?? ""
            )
        }
    }

    private func trichXuatJSON(tu raw: String) -> String? {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("```") {
            s = s.replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }
        guard let start = s.firstIndex(of: "{"), let end = s.lastIndex(of: "}") else { return nil }
        return String(s[start...end])
    }

    private func thuNhoAnhChoAI(_ anh: UIImage, canhToiDa: CGFloat) -> UIImage {
        let maxSide = max(anh.size.width, anh.size.height)
        guard maxSide > canhToiDa, maxSide > 0 else { return anh }
        let tiLe = canhToiDa / maxSide
        let ktMoi = CGSize(width: floor(anh.size.width * tiLe), height: floor(anh.size.height * tiLe))
        let renderer = UIGraphicsImageRenderer(size: ktMoi)
        return renderer.image { _ in
            anh.draw(in: CGRect(origin: .zero, size: ktMoi))
        }
    }

    func taoDeXuatDuPhong(
        thongTinBoSung: String,
        giaUuDai: String,
        cauHinh: CauHinhLienKetMXH
    ) -> [DeXuatBaiDangMXH] {
        let tenSP = thongTinBoSung.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Siêu Phẩm Điện Máy Chính Hãng"
            : thongTinBoSung.trimmingCharacters(in: .whitespacesAndNewlines)
        let gia = giaUuDai.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "TRẢ GÓP 0% LÃI SUẤT"
            : giaUuDai.trimmingCharacters(in: .whitespacesAndNewlines)
        let tenST = cauHinh.tenSieuThiMacDinh.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Điện Máy Xanh"
            : cauHinh.tenSieuThiMacDinh.trimmingCharacters(in: .whitespacesAndNewlines)
        let hotline = cauHinh.hotlineMacDinh.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "1900 232 461"
            : cauHinh.hotlineMacDinh.trimmingCharacters(in: .whitespacesAndNewlines)
        let diaChi = cauHinh.diaChiMacDinh.trimmingCharacters(in: .whitespacesAndNewlines)
        let dongDiaChi = diaChi.isEmpty ? "" : "\n📍 Địa chỉ: \(diaChi)"

        return [
            DeXuatBaiDangMXH(
                tenPhuongAn: "Phương án 1: Flash Sale Chốt Đơn Nhanh",
                gocTiepCan: "Đánh mạnh vào ưu đãi nóng, giá tốt trong ngày và kêu gọi nhắn tin ngay",
                phongCach: .flashSale,
                tieuDeAnh: "SĂN DEAL SỐC — \(tenSP.uppercased())",
                phuDeAnh: "Ưu đãi cực hời chỉ có tại \(tenST) hôm nay!",
                nhanNoiBat: "FLASH SALE",
                giaHienThi: gia,
                ctaAnh: "INBOX NGAY GIỮ SUẤT ƯU ĐÃI",
                noiDungFacebook: """
                🔥 DEAL SỐC HÔM NAY TẠI \(tenST.uppercased())!
                \(tenSP) đang có mức ưu đãi cực hời: \(gia) 💥

                ✅ Cam kết hàng chính hãng 100%, bảo hành tận tâm
                ✅ Hỗ trợ trả góp 0% lãi suất — duyệt hồ sơ nhanh gọn
                ✅ Giao hàng & lắp đặt tận nhà hoàn toàn tiện lợi
                ✅ Số lượng suất ưu đãi có hạn trong ngày

                👉 Bình luận "TƯ VẤN" hoặc nhắn tin ngay cho \(tenST) để giữ giá tốt nhất!
                📞 Hotline: \(hotline)\(dongDiaChi)

                #DienMayXanh #SanDealSoc #KhuyenMaiHomNay #TraGop0PhanTram
                """,
                noiDungZaloOA: """
                [ƯU ĐÃI HÔM NAY] \(tenSP) — \(gia)

                Kính chào Quý khách hàng của \(tenST),
                Hiện tại siêu thị đang áp dụng chương trình ưu đãi đặc biệt cho \(tenSP):
                • Ưu đãi nổi bật: \(gia)
                • Hỗ trợ trả góp 0% thủ tục đơn giản
                • Giao lắp nhanh tận nhà, bảo hành chính hãng

                Quý khách vui lòng nhắn tin trực tiếp tại Zalo OA này hoặc gọi \(hotline) để nhân viên tư vấn và giữ suất ưu đãi ngay hôm nay.
                """,
                noiDungTikTok: """
                Chậm tay là hết suất ưu đãi \(tenSP) hôm nay nha cả nhà ơi 🔥 \(gia) — giao lắp tận nhà, bảo hành chính hãng tại \(tenST)! Nhắn ngay để chốt đơn liền tay 👇 #DienMayXanh #DealHot #ReviewDienMay #SanSale #TikTokShopVN
                """
            ),
            DeXuatBaiDangMXH(
                tenPhuongAn: "Phương án 2: Chuẩn Thương Hiệu ĐMX",
                gocTiepCan: "Tạo niềm tin bằng dịch vụ giao lắp, bảo hành chính hãng và tiện ích gia đình",
                phongCach: .chuanDMX,
                tieuDeAnh: "NÂNG TẦM TIỆN NGHI CÙNG \(tenSP.uppercased())",
                phuDeAnh: "Chính hãng 100% • Trả góp 0% • Giao lắp tận nhà",
                nhanNoiBat: "CHÍNH HÃNG",
                giaHienThi: gia,
                ctaAnh: "GHÉ NGAY \(tenST.uppercased()) TRẢI NGHIỆM",
                noiDungFacebook: """
                💙 Chọn \(tenSP) cho gia đình — an tâm trọn vẹn cùng \(tenST)!

                Không chỉ đẹp mắt và bền bỉ, sản phẩm còn đi kèm loạt đặc quyền mua sắm:
                🔹 Mức ưu đãi hấp dẫn: \(gia)
                🔹 Hỗ trợ trả góp 0% nhẹ nhàng chi phí mỗi tháng
                🔹 Đội ngũ kỹ thuật giao hàng & lắp đặt tận nơi chu đáo
                🔹 Bảo hành chính hãng rõ ràng, hỗ trợ nhanh khi cần

                💬 Nhắn tin ngay cho Fanpage hoặc ghé \(tenST) để xem thực tế sản phẩm!
                📞 Hotline hỗ trợ: \(hotline)\(dongDiaChi)

                #DienMayXanh #GiaDinhHienDai #ChinhHang #DichVuTanTam
                """,
                noiDungZaloOA: """
                Gợi ý nâng cấp tiện nghi gia đình: \(tenSP)

                Tại \(tenST), Quý khách dễ dàng sở hữu \(tenSP) với ưu đãi \(gia), trả góp 0% và dịch vụ giao lắp tận nhà chuyên nghiệp.
                Nhấn "Quan tâm" và gửi tin nhắn ngay để nhận báo giá chi tiết kèm quà tặng đang áp dụng trong tuần này. Hotline: \(hotline).
                """,
                noiDungTikTok: """
                Nhà nào đang định sắm \(tenSP) thì ghé ngay \(tenST) xem mẫu này nhé 💙 Hàng chính hãng, ưu đãi \(gia), giao lắp tận cửa luôn! #DienMayXanh #NhaDep #MeoGiaDinh #DienMayChinhHang
                """
            ),
            DeXuatBaiDangMXH(
                tenPhuongAn: "Phương án 3: Bắt Trend Cuốn Hút",
                gocTiepCan: "Giọng văn tự nhiên, bắt mắt từ câu đầu, kích thích tương tác bình luận",
                phongCach: .batTrend,
                tieuDeAnh: "NHÌN LÀ MÊ — \(tenSP.uppercased())",
                phuDeAnh: "Đẹp từng chi tiết • Giá quá êm • Chốt đơn không cần nghĩ!",
                nhanNoiBat: "SIÊU HOT",
                giaHienThi: gia,
                ctaAnh: "CHẤM (.) NHẬN BÁO GIÁ LIỀN TAY",
                noiDungFacebook: """
                ✨ Phải công nhận \(tenSP) nhìn ngoài đời còn mê hơn trong ảnh!

                Ai đang tìm một mẫu vừa đẹp, vừa bền, lại có deal cực êm thì đừng bỏ qua đợt này tại \(tenST):
                ⭐ Ưu đãi hiện tại: \(gia)
                ⭐ Có sẵn hàng trưng bày để xem trực tiếp
                ⭐ Trả góp 0%, giao lắp tận nhà cực nhanh

                👇 Để lại dấu chấm (.) bên dưới hoặc inbox ngay, nhân viên \(tenST) gửi bảng giá chi tiết trong 1 phút!
                📞 Hotline: \(hotline)\(dongDiaChi)

                #DienMayXanh #XuHuong #ReviewThat #DealNgon
                """,
                noiDungZaloOA: """
                ✨ Mẫu \(tenSP) đang được nhiều khách hàng tại \(tenST) săn đón nhất tuần này!

                Với ưu đãi \(gia) cùng chính sách trả góp 0% và giao lắp tận nhà, đây là thời điểm rất đẹp để lên đời cho gia đình.
                Quý khách chỉ cần phản hồi tin nhắn này, \(tenST) sẽ gửi ngay thông số & ưu đãi tốt nhất!
                """,
                noiDungTikTok: """
                Thật sự luôn, thấy \(tenSP) ở \(tenST) mà không chốt là tiếc lắm 🔥 \(gia) — vừa đẹp vừa xịn, ai cần báo giá bình luận bên dưới mình rep liền nha! #DienMayXanh #TrendingVN #ReviewSanPham #DealHoi
                """
            )
        ]
    }
}

// MARK: - 5. Dịch Vụ Tự Động Đăng Bài Lên Facebook Page, Zalo OA, TikTok (+ Webhook)

struct KetQuaDangNenTang {
    let nenTang: NenTangMXH
    let thanhCong: Bool
    let thongBao: String
}

final class DichVuDangBaiMXH {
    static let dungChung = DichVuDangBaiMXH()
    private init() {}

    private let phienMang: URLSession = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 45
        cfg.timeoutIntervalForResource = 90
        return URLSession(configuration: cfg)
    }()

    /// Đăng đồng thời lên tất cả các nền tảng đã chọn và đã liên kết sau khi người dùng duyệt.
    func dangDaNenTang(
        cacNenTang: [NenTangMXH],
        deXuat: DeXuatBaiDangMXH,
        anhTheoNenTang: [NenTangMXH: UIImage],
        cauHinh: CauHinhLienKetMXH,
        hoanTat: @escaping ([KetQuaDangNenTang]) -> Void
    ) {
        let nhom = DispatchGroup()
        let khoaKQ = NSLock()
        var danhSachKQ: [KetQuaDangNenTang] = []

        let webhook = cauHinh.webhookUrl.trimmingCharacters(in: .whitespacesAndNewlines)

        for nenTang in cacNenTang {
            nhom.enter()
            let anh = anhTheoNenTang[nenTang] ?? anhTheoNenTang.values.first
            let noiDung = deXuat.noiDung(cho: nenTang)

            guard let anhDang = anh, let jpegData = anhDang.jpegData(compressionQuality: 0.88) else {
                khoaKQ.lock()
                danhSachKQ.append(KetQuaDangNenTang(nenTang: nenTang, thanhCong: false, thongBao: "Thiếu dữ liệu ảnh thiết kế."))
                khoaKQ.unlock()
                nhom.leave()
                continue
            }

            let ghiKQ: (KetQuaDangNenTang) -> Void = { kq in
                khoaKQ.lock()
                danhSachKQ.append(kq)
                khoaKQ.unlock()
                nhom.leave()
            }

            switch nenTang {
            case .facebook:
                if !cauHinh.fbPageId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !cauHinh.fbAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    dangLenFacebookPage(
                        pageId: cauHinh.fbPageId.trimmingCharacters(in: .whitespacesAndNewlines),
                        accessToken: cauHinh.fbAccessToken.trimmingCharacters(in: .whitespacesAndNewlines),
                        noiDung: noiDung,
                        anhData: jpegData,
                        hoanTat: ghiKQ
                    )
                } else if !webhook.isEmpty {
                    dangQuaWebhook(urlString: webhook, secret: cauHinh.webhookSecret, nenTang: .facebook, tieuDe: deXuat.tieuDeAnh, noiDung: noiDung, anhData: jpegData, hoanTat: ghiKQ)
                } else {
                    ghiKQ(KetQuaDangNenTang(nenTang: .facebook, thanhCong: false, thongBao: "Chưa nhập Page ID & Access Token Facebook."))
                }

            case .zaloOA:
                if !cauHinh.zaloAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    dangLenZaloOA(
                        accessToken: cauHinh.zaloAccessToken.trimmingCharacters(in: .whitespacesAndNewlines),
                        tieuDe: deXuat.tieuDeAnh,
                        noiDung: noiDung,
                        anhData: jpegData,
                        hoanTat: ghiKQ
                    )
                } else if !webhook.isEmpty {
                    dangQuaWebhook(urlString: webhook, secret: cauHinh.webhookSecret, nenTang: .zaloOA, tieuDe: deXuat.tieuDeAnh, noiDung: noiDung, anhData: jpegData, hoanTat: ghiKQ)
                } else {
                    ghiKQ(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "Chưa nhập Access Token Zalo OA."))
                }

            case .tiktok:
                if !cauHinh.tiktokAccessToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    dangLenTikTok(
                        accessToken: cauHinh.tiktokAccessToken.trimmingCharacters(in: .whitespacesAndNewlines),
                        tieuDe: deXuat.tieuDeAnh,
                        noiDung: noiDung,
                        anhData: jpegData,
                        webhookUrl: webhook,
                        webhookSecret: cauHinh.webhookSecret,
                        hoanTat: ghiKQ
                    )
                } else if !webhook.isEmpty {
                    dangQuaWebhook(urlString: webhook, secret: cauHinh.webhookSecret, nenTang: .tiktok, tieuDe: deXuat.tieuDeAnh, noiDung: noiDung, anhData: jpegData, hoanTat: ghiKQ)
                } else {
                    ghiKQ(KetQuaDangNenTang(nenTang: .tiktok, thanhCong: false, thongBao: "Chưa nhập Access Token TikTok hoặc Webhook."))
                }
            }
        }

        nhom.notify(queue: .main) {
            let thuTu = NenTangMXH.allCases
            let sapXep = danhSachKQ.sorted { a, b in
                (thuTu.firstIndex(of: a.nenTang) ?? 0) < (thuTu.firstIndex(of: b.nenTang) ?? 0)
            }
            hoanTat(sapXep)
        }
    }

    // MARK: - Facebook Graph API (POST /{page-id}/photos)

    private func dangLenFacebookPage(
        pageId: String,
        accessToken: String,
        noiDung: String,
        anhData: Data,
        hoanTat: @escaping (KetQuaDangNenTang) -> Void
    ) {
        guard let url = URL(string: "https://graph.facebook.com/v20.0/\(pageId)/photos") else {
            hoanTat(KetQuaDangNenTang(nenTang: .facebook, thanhCong: false, thongBao: "Page ID Facebook không hợp lệ."))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        themTruongMultipart(&body, boundary: boundary, ten: "access_token", giaTri: accessToken)
        themTruongMultipart(&body, boundary: boundary, ten: "message", giaTri: noiDung)
        themTruongMultipart(&body, boundary: boundary, ten: "published", giaTri: "true")
        themFileMultipart(&body, boundary: boundary, tenTruong: "source", tenFile: "dmx_poster.jpg", mime: "image/jpeg", data: anhData)
        body.append("--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        req.httpBody = body

        phienMang.dataTask(with: req) { data, response, error in
            if let error = error {
                hoanTat(KetQuaDangNenTang(nenTang: .facebook, thanhCong: false, thongBao: "Lỗi mạng: \(error.localizedDescription)"))
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            if code >= 200 && code < 300 {
                var postId = ""
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    postId = (json["post_id"] as? String) ?? (json["id"] as? String) ?? ""
                }
                let tb = postId.isEmpty ? "Đã đăng bài & ảnh thành công lên Facebook Page." : "Đã đăng thành công (Mã bài: \(postId))."
                hoanTat(KetQuaDangNenTang(nenTang: .facebook, thanhCong: true, thongBao: tb))
            } else {
                let loiChiTiet = self.trichLoiJSON(data) ?? "Mã lỗi HTTP \(code)"
                hoanTat(KetQuaDangNenTang(nenTang: .facebook, thanhCong: false, thongBao: "Facebook từ chối: \(loiChiTiet)"))
            }
        }.resume()
    }

    // MARK: - Zalo OA API (Upload Ảnh -> Tạo Bài Viết OA)

    private func dangLenZaloOA(
        accessToken: String,
        tieuDe: String,
        noiDung: String,
        anhData: Data,
        hoanTat: @escaping (KetQuaDangNenTang) -> Void
    ) {
        guard let uploadURL = URL(string: "https://openapi.zalo.me/v2.0/oa/upload/image") else {
            hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "URL Zalo OA không hợp lệ."))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var uploadReq = URLRequest(url: uploadURL)
        uploadReq.httpMethod = "POST"
        uploadReq.setValue(accessToken, forHTTPHeaderField: "access_token")
        uploadReq.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        themFileMultipart(&body, boundary: boundary, tenTruong: "file", tenFile: "dmx_zalo.jpg", mime: "image/jpeg", data: anhData)
        body.append("--\(boundary)--\r\n".data(using: .utf8) ?? Data())
        uploadReq.httpBody = body

        phienMang.dataTask(with: uploadReq) { data, response, error in
            if let error = error {
                hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "Lỗi tải ảnh Zalo OA: \(error.localizedDescription)"))
                return
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "Phản hồi Zalo OA không đọc được."))
                return
            }

            let errCode = json["error"] as? Int ?? -1
            guard errCode == 0,
                  let dataObj = json["data"] as? [String: Any],
                  let attachmentId = dataObj["attachment_id"] as? String else {
                let msg = (json["message"] as? String) ?? "Lỗi mã \(errCode)"
                hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "Zalo OA upload ảnh lỗi: \(msg)"))
                return
            }

            // Bước 2: Đăng bài viết lên Zalo OA Article API
            guard let articleURL = URL(string: "https://openapi.zalo.me/v2.0/oa/article/create") else {
                hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "URL tạo bài Zalo OA không hợp lệ."))
                return
            }
            var artReq = URLRequest(url: articleURL)
            artReq.httpMethod = "POST"
            artReq.setValue(accessToken, forHTTPHeaderField: "access_token")
            artReq.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let tieuDeSach = String(tieuDe.prefix(150))
            let moTaNgan = String(noiDung.replacingOccurrences(of: "\n", with: " ").prefix(280))
            let payload: [String: Any] = [
                "type": "normal",
                "title": tieuDeSach.isEmpty ? "Ưu đãi mới từ Điện Máy Xanh" : tieuDeSach,
                "author": "Điện Máy Xanh",
                "cover": [
                    "cover_type": "photo",
                    "photo_url": "",
                    "attachment_id": attachmentId,
                    "status": "show"
                ],
                "description": moTaNgan,
                "body": [
                    [
                        "type": "text",
                        "content": noiDung
                    ]
                ],
                "status": "show",
                "comment": "show"
            ]
            artReq.httpBody = try? JSONSerialization.data(withJSONObject: payload)

            self.phienMang.dataTask(with: artReq) { artData, _, artErr in
                if let artErr = artErr {
                    hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "Lỗi tạo bài Zalo OA: \(artErr.localizedDescription)"))
                    return
                }
                if let artData = artData,
                   let artJson = try? JSONSerialization.jsonObject(with: artData) as? [String: Any],
                   (artJson["error"] as? Int ?? -1) == 0 {
                    hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: true, thongBao: "Đã đăng bài viết & ảnh thành công lên Zalo OA."))
                } else {
                    let msg = self.trichLoiJSON(artData) ?? "Zalo OA không chấp nhận bài viết."
                    hoanTat(KetQuaDangNenTang(nenTang: .zaloOA, thanhCong: false, thongBao: "Zalo OA: \(msg)"))
                }
            }.resume()
        }.resume()
    }

    // MARK: - TikTok Content Posting API v2 (Photo Post)

    private func dangLenTikTok(
        accessToken: String,
        tieuDe: String,
        noiDung: String,
        anhData: Data,
        webhookUrl: String,
        webhookSecret: String,
        hoanTat: @escaping (KetQuaDangNenTang) -> Void
    ) {
        // TikTok Photo Posting API yêu cầu URL ảnh công khai (PULL_FROM_URL).
        // Nếu người dùng đã cấu hình Webhook trung gian, ưu tiên đẩy qua Webhook kèm ảnh base64.
        if !webhookUrl.isEmpty {
            dangQuaWebhook(urlString: webhookUrl, secret: webhookSecret, nenTang: .tiktok, tieuDe: tieuDe, noiDung: noiDung, anhData: anhData, hoanTat: hoanTat)
            return
        }

        // Thử đẩy ảnh lên kho ảnh bot (ImgBB/Drive/Supabase) rồi gọi TikTok Content Posting API v2
        guard let anhUI = UIImage(data: anhData) else {
            hoanTat(KetQuaDangNenTang(nenTang: .tiktok, thanhCong: false, thongBao: "Không đọc được dữ liệu ảnh để tải lên TikTok."))
            return
        }
        let khoaNgay = TienIchNgay.khoa.string(from: Date())
        DichVuAnhBaoCaoBot.dungChung.taiAnh(anhUI, loai: "tiktok_mxh", ngay: khoaNgay, buocDungSupabase: false) { ketQuaTaiAnh in
            switch ketQuaTaiAnh {
            case .failure(let loi):
                hoanTat(KetQuaDangNenTang(
                    nenTang: .tiktok,
                    thanhCong: false,
                    thongBao: "TikTok API cần link ảnh công khai (hãy cấu hình Kho ảnh ở mục Gởi báo cáo hoặc điền Webhook, hoặc dùng nút Chia sẻ nhanh). Chi tiết: \(loi.localizedDescription)"
                ))
            case .success(let linkAnh):
                guard let url = URL(string: "https://open.tiktokapis.com/v2/post/publish/content/init/") else {
                    hoanTat(KetQuaDangNenTang(nenTang: .tiktok, thanhCong: false, thongBao: "URL TikTok API không hợp lệ."))
                    return
                }
                var req = URLRequest(url: url)
                req.httpMethod = "POST"
                req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                req.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

                let payload: [String: Any] = [
                    "post_info": [
                        "title": String(tieuDe.prefix(90)),
                        "description": String(noiDung.prefix(2200)),
                        "privacy_level": "SELF_ONLY",
                        "disable_comment": false
                    ],
                    "source_info": [
                        "source": "PULL_FROM_URL",
                        "photo_cover_index": 0,
                        "photo_images": [linkAnh]
                    ],
                    "post_mode": "MEDIA_UPLOAD",
                    "media_type": "PHOTO"
                ]
                req.httpBody = try? JSONSerialization.data(withJSONObject: payload)

                self.phienMang.dataTask(with: req) { data, response, error in
                    if let error = error {
                        hoanTat(KetQuaDangNenTang(nenTang: .tiktok, thanhCong: false, thongBao: "Lỗi kết nối TikTok: \(error.localizedDescription)"))
                        return
                    }
                    let code = (response as? HTTPURLResponse)?.statusCode ?? 0
                    if code >= 200 && code < 300 {
                        hoanTat(KetQuaDangNenTang(nenTang: .tiktok, thanhCong: true, thongBao: "Đã đẩy ảnh & caption vào hộp nháp TikTok để hoàn tất đăng."))
                    } else {
                        let msg = self.trichLoiJSON(data) ?? "Mã lỗi HTTP \(code)"
                        hoanTat(KetQuaDangNenTang(nenTang: .tiktok, thanhCong: false, thongBao: "TikTok từ chối: \(msg)"))
                    }
                }.resume()
            }
        }
    }

    // MARK: - Webhook Trung Gian (Make / n8n / Cloudflare Worker)

    private func dangQuaWebhook(
        urlString: String,
        secret: String,
        nenTang: NenTangMXH,
        tieuDe: String,
        noiDung: String,
        anhData: Data,
        hoanTat: @escaping (KetQuaDangNenTang) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            hoanTat(KetQuaDangNenTang(nenTang: nenTang, thanhCong: false, thongBao: "Địa chỉ Webhook không hợp lệ."))
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !secret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            req.setValue(secret.trimmingCharacters(in: .whitespacesAndNewlines), forHTTPHeaderField: "X-DMX-Webhook-Secret")
        }

        let payload: [String: Any] = [
            "platform": nenTang.rawValue,
            "platform_name": nenTang.tieuDe,
            "title": tieuDe,
            "caption": noiDung,
            "image_base64": anhData.base64EncodedString(),
            "image_mime": "image/jpeg"
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        phienMang.dataTask(with: req) { data, response, error in
            if let error = error {
                hoanTat(KetQuaDangNenTang(nenTang: nenTang, thanhCong: false, thongBao: "Lỗi gọi Webhook: \(error.localizedDescription)"))
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            if code >= 200 && code < 300 {
                hoanTat(KetQuaDangNenTang(nenTang: nenTang, thanhCong: true, thongBao: "Đã gửi bài & ảnh qua Webhook tự động đăng \(nenTang.tieuDeNgan)."))
            } else {
                let msg = self.trichLoiJSON(data) ?? "Mã lỗi HTTP \(code)"
                hoanTat(KetQuaDangNenTang(nenTang: nenTang, thanhCong: false, thongBao: "Webhook lỗi: \(msg)"))
            }
        }.resume()
    }

    private func themTruongMultipart(_ body: inout Data, boundary: String, ten: String, giaTri: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
        body.append("Content-Disposition: form-data; name=\"\(ten)\"\r\n\r\n".data(using: .utf8) ?? Data())
        body.append("\(giaTri)\r\n".data(using: .utf8) ?? Data())
    }

    private func themFileMultipart(_ body: inout Data, boundary: String, tenTruong: String, tenFile: String, mime: String, data: Data) {
        body.append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
        body.append("Content-Disposition: form-data; name=\"\(tenTruong)\"; filename=\"\(tenFile)\"\r\n".data(using: .utf8) ?? Data())
        body.append("Content-Type: \(mime)\r\n\r\n".data(using: .utf8) ?? Data())
        body.append(data)
        body.append("\r\n".data(using: .utf8) ?? Data())
    }

    private func trichLoiJSON(_ data: Data?) -> String? {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        if let err = json["error"] as? [String: Any], let msg = err["message"] as? String {
            return msg
        }
        if let msg = json["message"] as? String {
            return msg
        }
        return nil
    }
}
