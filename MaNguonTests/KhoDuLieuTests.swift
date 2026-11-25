import XCTest
@testable import TongHopDMX

final class KhoDuLieuTests: XCTestCase {

    func testSapXepAZLoaiBoTrungVaGiuTenDayDu() {
        let danhSach = [
            NhanVienQuanLy(maNV: "12345", hoTen: "An"),
            NhanVienQuanLy(maNV: "12345", hoTen: "Nguyễn Văn An"),
            NhanVienQuanLy(maNV: "67890", hoTen: "Trần Thị Bình"),
            NhanVienQuanLy(maNV: "  ", hoTen: "   ")
        ]

        let ketQua = NhanVienQuanLy.sapXepAZ(danhSach)

        XCTAssertEqual(ketQua.count, 2, "Phải gộp bản ghi trùng mã NV và bỏ dòng rỗng")
        XCTAssertEqual(ketQua.first?.maNV, "12345")
        XCTAssertEqual(ketQua.first?.hoTen, "Nguyễn Văn An", "Khi trùng mã NV phải giữ tên đầy đủ hơn")
        XCTAssertEqual(ketQua.last?.maNV, "67890")
    }

    func testDongThiDuaTargetGocVaPhanTramDieuChinh() {
        let dongCu = DongThiDua(
            tenNganhHang: "Máy lạnh",
            loaiChiTieu: .doanhThu,
            thucHien: 120,
            target: 100
        )
        XCTAssertEqual(dongCu.targetGocHieuLuc, 100, accuracy: 0.001)
        XCTAssertEqual(dongCu.phanTramDieuChinhTargetHieuLuc, 100, accuracy: 0.001)

        let dongDieuChinh = DongThiDua(
            tenNganhHang: "Tủ lạnh",
            loaiChiTieu: .soLuong,
            thucHien: 15,
            target: 24,
            targetGoc: 20,
            phanTramDieuChinhTarget: 120
        )
        XCTAssertEqual(dongDieuChinh.targetGocHieuLuc, 20, accuracy: 0.001)
        XCTAssertEqual(dongDieuChinh.phanTramDieuChinhTargetHieuLuc, 120, accuracy: 0.001)
    }

    func testDongThiDuaCodableTuongThichNguocDuLieuCu() throws {
        let jsonDT = """
        {
          "tenNganhHang": "Tivi",
          "loaiChiTieu": "DT",
          "thucHien": 50.5,
          "target": 80.0
        }
        """
        let dongDT = try JSONDecoder().decode(DongThiDua.self, from: try XCTUnwrap(jsonDT.data(using: .utf8)))
        XCTAssertEqual(dongDT.tenNganhHang, "Tivi")
        XCTAssertEqual(dongDT.loaiChiTieu, .doanhThu)
        XCTAssertEqual(dongDT.thucHien, 50.5, accuracy: 0.001)
        XCTAssertEqual(dongDT.targetGocHieuLuc, 80.0, accuracy: 0.001)

        let jsonSL = """
        {
          "tenNganhHang": "Máy giặt",
          "loaiChiTieu": "SLLK",
          "thucHien": 10,
          "target": 15
        }
        """
        let dongSL = try JSONDecoder().decode(DongThiDua.self, from: try XCTUnwrap(jsonSL.data(using: .utf8)))
        XCTAssertEqual(dongSL.loaiChiTieu, .soLuong)
    }

    func testApDungLocTuCaiDatKhongTraVeChuoiRong() {
        let ketQua = KhoDuLieu.apDungLocTuCaiDat("  --- | Gia dụng | ---  ")
        XCTAssertFalse(ketQua.isEmpty)
        XCTAssertEqual(ketQua, "Gia dụng")
    }
}
