import UIKit
import Domain
import SnapKit
import Then
import RxGesture
import RxSwift
import RxCocoa
import DesignSystem

class MajorTypeStackView: UIStackView {
    public var majorDidTap = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 0
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTech(majorList: [String]) {
        self.subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        majorList.forEach { data in
            let majorTypeStackViewCell = MajorTypeStackViewCell()

            majorTypeStackViewCell.snp.makeConstraints {
                $0.height.equalTo(48)
            }

            majorTypeStackViewCell.adapt(majorType: data)
            majorTypeStackViewCell.dismiss = {
                self.majorDidTap.accept($0)
            }
            self.addArrangedSubview(majorTypeStackViewCell)
        }
    }
}
