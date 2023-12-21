import UIKit
import SnapKit
import Then

public class BaseTabBarController: UITabBarController {
    public override func viewDidLoad() {
        self.tabBar.tintColor = .GrayScale.gray90
        self.tabBar.unselectedItemTintColor = .GrayScale.gray50
        self.tabBar.backgroundColor = .GrayScale.gray10

        let stroke = UIView().then {
            $0.backgroundColor = .GrayScale.gray30
        }

        self.tabBar.addSubview(stroke)

        stroke.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
