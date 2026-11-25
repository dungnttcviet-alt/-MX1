import XCTest
@testable import TongHopDMX

final class DaoTaoHuanLuyenTests: XCTestCase {

    func testCaiDatDMXTuongThichNguocKhiThieuNhatKyDaoTao() throws {
        let jsonCu = """
        {
          "soCotXuatAnh": 3,
          "phanTramTargetLuyKe": 100
        }
        """
        let data = try XCTUnwrap(jsonCu.data(using: .utf8))
        let caiDat = try JSONDecoder().decode(CaiDatDMX.self, from: data)
        XCTAssertTrue(caiDat.nhatKyDaoTao.isEmpty)
    }

    func testPhienKemCapCodableDayDu() throws {
        let phien = PhienKemCapNhanVien(
            maNV: "116719",
            hoTenNV: "Đinh Thị Quỳnh Nga",
            ngayTao: "2026-11-25",
            hanKiemTra: "2026-12-02",
            nganhHangMucTieu: "Máy lạnh",
            nguyenNhan: .tuVanTraGop,
            hanhDongCamKet: "Thực hành tư vấn gói 0% mỗi ca",
            maNVMentor: "34922",
            hoTenNVMentor: "Đỗ Thị Chanh",
            trangThai: .dangTheoDoi
        )

        let encoded = try JSONEncoder().encode(phien)
        let decoded = try JSONDecoder().decode(PhienKemCapNhanVien.self, from: encoded)
        XCTAssertEqual(decoded.maNV, "116719")
        XCTAssertEqual(decoded.nganhHangMucTieu, "Máy lạnh")
        XCTAssertEqual(decoded.nguyenNhan, .tuVanTraGop)
        XCTAssertEqual(decoded.hoTenNVMentor, "Đỗ Thị Chanh")
        XCTAssertTrue(decoded.coMentor)
    }

    func testTinhGoiYMentorChonDungNguoiGioiNhatVaLoaiTruChinhNV() {
        let monMayLanhYeu = MonThiDuaNhanVien(
            khoaNganh: "may lanh",
            tenNganhHang: "Máy lạnh",
            loaiChiTieu: .soLuong,
            thucHien: 2,
            targetCaNhan: 10,
            phanTramHT: 20,
            phanTramSieuThi: 80
        )
        let monMayLanhGioi = MonThiDuaNhanVien(
            khoaNganh: "may lanh",
            tenNganhHang: "Máy lạnh",
            loaiChiTieu: .soLuong,
            thucHien: 14,
            targetCaNhan: 10,
            phanTramHT: 140,
            phanTramSieuThi: 80
        )
        let monMayLanhKha = MonThiDuaNhanVien(
            khoaNganh: "may lanh",
            tenNganhHang: "Máy lạnh",
            loaiChiTieu: .soLuong,
            thucHien: 11,
            targetCaNhan: 10,
            phanTramHT: 110,
            phanTramSieuThi: 80
        )

        let ds: [TongHopNhanVien] = [
            TongHopNhanVien(
                nhanVien: NhanVienQuanLy(maNV: "1001", hoTen: "NV Yếu"),
                soMonDat: 0, tongMonGiao: 1, phanTramHTTB: 20, doanhThuQD: 0, soLuongDon: 0,
                dtQDKhoanVay: 0, dtTraThangQD: 0, cacMonGiao: [monMayLanhYeu], doanhThuCaNhan: nil
            ),
            TongHopNhanVien(
                nhanVien: NhanVienQuanLy(maNV: "1002", hoTen: "NV Khá"),
                soMonDat: 1, tongMonGiao: 1, phanTramHTTB: 110, doanhThuQD: 0, soLuongDon: 0,
                dtQDKhoanVay: 0, dtTraThangQD: 0, cacMonGiao: [monMayLanhKha], doanhThuCaNhan: nil
            ),
            TongHopNhanVien(
                nhanVien: NhanVienQuanLy(maNV: "1003", hoTen: "NV Xuất Sắc"),
                soMonDat: 1, tongMonGiao: 1, phanTramHTTB: 140, doanhThuQD: 0, soLuongDon: 0,
                dtQDKhoanVay: 0, dtTraThangQD: 0, cacMonGiao: [monMayLanhGioi], doanhThuCaNhan: nil
            )
        ]

        let goiY = DichVuDaoTao.tinhGoiYMentor(tu: ds, choNganhHang: "Máy lạnh", loaiTruMaNV: "1001", gioiHan: 2)
        XCTAssertEqual(goiY.count, 2)
        XCTAssertEqual(goiY.first?.nhanVien.maNV, "1003")
        XCTAssertEqual(goiY.first?.phanTramHT ?? 0, 140, accuracy: 0.001)
        XCTAssertFalse(goiY.contains { $0.nhanVien.maNV == "1001" })
    }

    func testTongHopHieuQuaTruocSauChinhXacVaKhongBiaSo() {
        let hqDu = DichVuDaoTao.tongHopHieuQua(diemTruoc: [40, 50, 60], diemSau: [65, 75])
        XCTAssertEqual(hqDu.soNgayTruoc, 3)
        XCTAssertEqual(hqDu.soNgaySau, 2)
        XCTAssertEqual(hqDu.phanTramTruoc ?? 0, 50.0, accuracy: 0.001)
        XCTAssertEqual(hqDu.phanTramSau ?? 0, 70.0, accuracy: 0.001)
        XCTAssertEqual(hqDu.chenhLech ?? 0, 20.0, accuracy: 0.001)

        let hqThieuSau = DichVuDaoTao.tongHopHieuQua(diemTruoc: [45, 55], diemSau: [])
        XCTAssertEqual(hqThieuSau.phanTramTruoc ?? 0, 50.0, accuracy: 0.001)
        XCTAssertNil(hqThieuSau.phanTramSau)
        XCTAssertNil(hqThieuSau.chenhLech)
    }
}
