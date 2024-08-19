import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MajorTableViewCell: BaseTableViewCell<Any> {
    static let identifier = "MajorTableViewCell"
    public var majorListDidTap = PublishRelay<String>()
    private var disposeBag = DisposeBag()

    public let majorButton = UIButton().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
    }

    override func addView() {
        [
            majorButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        majorButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
    }
}
