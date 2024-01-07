import UIKit
import SnapKit
import Then
import DesignSystem

public class BaseTabBarController: UITabBarController,
                                   SetLayoutable,
                                   AddViewable {
    private let stroke = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .GrayScale.gray90
        self.tabBar.unselectedItemTintColor = .GrayScale.gray50
        self.tabBar.backgroundColor = .GrayScale.gray10

        addView()
        setLayout()
    }

    public func addView() {
        self.tabBar.addSubview(stroke)
    }

    public func setLayout() {
        stroke.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
