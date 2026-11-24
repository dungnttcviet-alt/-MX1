import UIKit
@main final class UyQuyenUngDung: UIResponder, UIApplicationDelegate {
    var cuaSo: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = DichVuDongBo.dungChung.daDangNhap
            ? UINavigationController(rootViewController: ManHinhChinh())
            : ManHinhDangNhap()
        w.tintColor = .systemBlue
        w.makeKeyAndVisible(); cuaSo = w
        return true
    }

    func hienThiManHinhChinh() {
        UIView.transition(with: cuaSo!, duration: 0.3, options: .transitionCrossDissolve) {
            self.cuaSo?.rootViewController = UINavigationController(rootViewController: ManHinhChinh())
        }
    }

    func hienThiDangNhap() {
        UIView.transition(with: cuaSo!, duration: 0.3, options: .transitionCrossDissolve) {
            self.cuaSo?.rootViewController = ManHinhDangNhap()
        }
    }
}
