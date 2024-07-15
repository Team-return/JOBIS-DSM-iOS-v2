import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MajorTypeStackViewCell: BaseView {
    public var majorTypeButtonDidTap: (() -> String)?
    private var majorName = ""
//    public var isCheck: Bool = false {
//        didSet {
//            techCheckBoxDidTap?(code)
//            techCheckBox.isCheck = isCheck
//        }
//    }
//    private let backStackView = UIStackView().then {
//        $0.spacing = 8
//        $0.axis = .horizontal
//        $0.isLayoutMarginsRelativeArrangement = true
//        $0.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 24)
//    }
    private let majorTypeButton = UIButton().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
    }
    private var disposeBag = DisposeBag()

    override func addView() {
        [
            majorTypeButton
        ].forEach(self.addSubview(_:))
//        self.addSubview(backStackView)
//        [
//            techCheckBox,
//            techLabel
//        ].forEach(self.backStackView.addArrangedSubview(_:))
    }

    override func setLayout() {
        majorTypeButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureView() {
        majorTypeButton.rx.tap.asObservable()
            .subscribe(onNext: {
                print("MajorTypeStackViewCell!")
            })
            .disposed(by: disposeBag)
    }

    func adapt(majorType: String) {
        self.majorTypeButton.setJobisText(
            majorType,
            font: .body,
            color: .GrayScale.gray80
        )
        self.majorName = majorType
    }
}
