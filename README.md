# Kiến Trúc & Hướng Dẫn Phát Triển — Dự Án `TongHopDMX` (V2 ĐMX)

Ứng dụng iOS hỗ trợ quản lý siêu thị Điện Máy Xanh tổng hợp số liệu doanh thu, thi đua ngành hàng, theo dõi sức khỏe nhân viên, lập bản tin phân tích và tự động gửi báo cáo định kỳ.

---

## 1. Kiến Trúc Tổng Thể (3 Thành Phần)

| Thành phần | Thư mục | Công nghệ | Vai trò |
| :--- | :--- | :--- | :--- |
| **Ứng dụng iOS** | `MaNguon/` (21 tệp Swift) | iOS 16.0+, Swift 5, UIKit thuần, XcodeGen | Quét ảnh OCR/Gemini, tính KPI & sức khỏe NV, quản lý tồn kho, xuất ảnh/CSV/XLSX/PPTX |
| **Kiểm thử tự động** | `MaNguonTests/` | XCTest | Kiểm thử đơn vị cho mô hình dữ liệu, công thức KPI và chuẩn hóa tên ngành hàng |
| **Cloudflare Worker** | `cloudflare/` | Cloudflare Workers, R2 (`dmx-anh-bao-cao`), Cron | Webhook LINE Bot, lưu ảnh báo cáo R2, đẩy báo cáo định kỳ |
| **Dịch vụ VPS LINE** | `line-report-vps/` | Node.js ESM, `@evex-dev/linejs`, systemd | Kênh gửi báo cáo định kỳ dự phòng qua tài khoản LINE |

---

## 2. Bản Đồ 21 Tệp Mã Nguồn Trong `MaNguon/`

| Nhóm | Tệp | Vai trò chính |
| :--- | :--- | :--- |
| **Khởi chạy & Siêu thị** | `UyQuyenUngDung.swift` | Điểm vào `@main`, điều hướng Đăng nhập / Màn hình chính |
| | `QuanLySieuThiDMX.swift` | Quản lý bối cảnh đa siêu thị |
| **Mô hình & Lưu trữ** | `MoHinh.swift` | Models, `ThuMucDuLieu`, `KhoDuLieu`, tính dự báo, xếp hạng & sức khỏe NV, `HopChonDMXController` |
| **Màn hình chính & Thi đua** | `ManHinhChinh.swift` | Điều phối giao diện chính, chọn ngày, quét ảnh, menu xuất báo cáo |
| | `BangThiDuaView.swift` | 8 thẻ KPI, bảng/thẻ thi đua, biểu đồ Realtime tháng & biểu đồ sức khỏe NV |
| | `ManHinhChonMonThiDua.swift` | Chọn nhóm ngành hàng thi đua theo dõi |
| | `ManHinhDieuChinhTarget.swift` | Điều chỉnh % target tổng quan |
| | `ManHinhDieuChinhTargetThiDua.swift` | Điều chỉnh target từng môn thi đua |
| **Nhân sự & Quản trị** | `ManHinhNhanVien.swift` | Bảng xếp hạng NV, chi tiết ngành hàng theo NV, báo cáo sức khỏe cá nhân |
| | `ManHinhQuanLyNhanVien.swift` | Thêm/sửa/xóa NV, nhập nhanh danh sách, chia target mặt hàng |
| | `ManHinhDangNhap.swift` | Đăng nhập nội bộ |
| | `ManHinhCaiDat.swift` | Cài đặt hiển thị, lọc cụm từ, quản trị tài khoản Admin |
| **Tồn kho, Bản tin & Báo cáo** | `ManHinhTonKho.swift` | Theo dõi tồn kho & đồng bộ Google Sheets |
| | `BanTinPhanTich.swift` | Phân tích dữ liệu & xuất báo cáo Excel (`.xlsx`), PowerPoint (`.pptx`) |
| | `ManHinhBanTin.swift` | Giao diện xem và tạo bản tin phân tích |
| | `ManHinhGuiBaoCao.swift` | Giao diện cấu hình & gửi báo cáo tự động qua Bot |
| | `ManHinhTrinhDuyet.swift` | Trình duyệt tích hợp (mở Microsoft Teams / tài nguyên nội bộ) |
| **Dịch vụ OCR, Đồng bộ & Bot** | `DichVuDocAnh.swift` | Nhận diện chữ OCR offline bằng Apple Vision |
| | `DichVuQuetAnhGemini.swift` | Phân tích ảnh báo cáo bằng Gemini Vision & chuẩn hóa JSON |
| | `DichVuDongBo.swift` | Xác thực Keychain, đồng bộ bất đồng bộ Supabase & gom nhóm chống dội |
| | `DichVuAnhBaoCaoBot.swift` | Tải ảnh báo cáo lên R2 / dịch vụ lưu trữ cho Bot |

---

## 3. Quy Tắc Phát Triển & CI/CD Chuẩn

1. **Quy trình Git (khuyến nghị thay cho chép đè `.zip`)**:
   - Tạo nhánh tính năng từ `main` (ví dụ `git checkout -b feat/dao-tao-nhan-su`), chỉnh sửa và mở Pull Request.
   - Khi mở PR vào `main`, GitHub Actions (`.github/workflows/tao-ipa.yml`) tự động chạy trên Apple Silicon (`macos-15`): **SwiftLint** → **XcodeGen** → **Unit Tests (`TongHopDMXTests`)** → **Build Release**.
   - Khi gộp PR vào `main`, hệ thống tự động đóng gói `TongHopDMX-unsigned.ipa` và tạo GitHub Release.
2. **Quy tắc giao diện bắt buộc**:
   - Không cắt chữ bằng `...`: mọi `UILabel`/`UIButton`/Cell dùng `numberOfLines = 0`, `lineBreakMode = .byWordWrapping`, `adjustsFontSizeToFitWidth = false`; menu chọn hành động luôn dùng `hienMenuChon(...)` (`HopChonDMXController`).
   - Không chặn Main Thread: luôn dùng `ghiNgayBatDongBo` / `ghiCaiDatBatDongBo` và đồng bộ qua `DichVuDongBo`.
   - An toàn biên dịch Swift 5 / Xcode 16+: luôn viết tường minh `CGFloat.greatestFiniteMagnitude` trong `boundingRect`.
3. **Bảo mật (ưu tiên thực hiện ở Giai đoạn 1)**:
   - Tuyệt đối không lưu khóa `service_role` hoặc API key trả phí trực tiếp trong mã nguồn iOS/Git. Dùng biến môi trường (`wrangler secret put`, `.env`) trên Backend Proxy và bật Supabase RLS.
