# Tổng Hợp Số Liệu ĐMX (iOS 16+ & Đồng Bộ duongnt.io.vn/dmx)

Ứng dụng iPhone iOS 16+, UIKit thuần. GitHub Actions tạo IPA chưa ký (`TongHopDMX-unsigned.ipa`) để ký/cài bằng ESign.

## Tính năng chính (Đồng bộ 100% với nhánh `duongnt.io.vn/dmx`)
1. **Tài khoản & Đồng bộ Đám mây (Supabase)**:
   - Đăng nhập / Tạo tài khoản mới và tự động đồng bộ hai chiều dữ liệu cài đặt, danh sách nhân viên, chia target và dữ liệu báo cáo các ngày với `duongnt.io.vn/dmx` (`/api/dmx/dong-bo`).
2. **Đọc ảnh trực tiếp trên thiết bị bằng Apple Vision OCR (Offline 100%, không dùng AI bên ngoài)**:
   - **Ảnh Doanh thu hợp nhất (DT thực & DT quy đổi)**: Đọc tự động thanh tiến độ tháng và 8 thẻ chỉ số chính (`Doanh thu thực`, `Doanh thu QĐ`, `% Trả góp`, `Lượt khách`, `% HT QĐ dự kiến`, `% Quy đổi`, `Thi đua hoàn thành`, `Tăng/Giảm cùng kỳ`).
   - **Ảnh Thi đua siêu thị**: Đọc tự động các khối chương trình thi đua (`SL` / `DT`), khử trùng lặp khi chụp cuộn trang và áp dụng bộ lọc cụm từ trong Cài đặt.
   - **Ảnh Thực hiện Nhân viên theo Ngành hàng**: Bấm vào từng ngành hàng trong bảng Thi đua để xem xếp hạng nhân viên, nhập/sửa tay thực hiện, quét ảnh thực hiện nhân viên và xuất ảnh bảng xếp hạng ngành hàng.
   - **Ảnh Doanh thu hợp nhất theo Nhân viên**: Hỗ trợ cả bảng lưới 5 cột và bảng rộng 11 cột trong mục **Nhân viên**.
3. **Quản lý Nhân viên & Chia Target Mặt hàng**:
   - Thêm, sửa, xoá, dán nhanh danh sách nhiều nhân viên hoặc nạp 16 nhân viên mẫu siêu thị.
   - Tích chọn nhân viên nhận Target cho từng mặt hàng từ ngày 1 đầu tháng đến hiện tại, tự động chia đều Target cá nhân.
   - Bảng xếp hạng nhân viên 8 cột (kèm huy chương 🥇🥈🥉, lọc/sắp xếp theo Số môn hoàn thành, Doanh thu QĐ, % HT thi đua TB) và màn hình **Sức khoẻ chi tiết cá nhân nhân viên**.
4. **Xuất Báo cáo**:
   - Xuất ảnh báo cáo sắc nét theo 2 mẫu (`Bảng 8 cột chi tiết` hoặc `Thẻ tiến độ gọn 1–4 cột`).
   - Xuất ảnh bảng xếp hạng nhân viên của từng ngành hàng.
   - Xuất file Excel (`.csv` chuẩn UTF-8 BOM).
