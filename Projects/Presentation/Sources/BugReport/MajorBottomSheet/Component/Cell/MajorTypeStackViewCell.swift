import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MajorTypeStackViewCell: BaseView {
    public var dismiss: ((String) -> Void)?
    public var majorName = ""

    public let majorTypeButton = UIButton().then {
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
    }

    override func setLayout() {
        majorTypeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
    }

    override func configureView() {
        majorTypeButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.dismiss?(
                    self.majorName
                )
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
