import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MajorTableViewCell: BaseTableViewCell<Any> {
    static let identifier = "MajorTableViewCell"
//    public var majorType: String = ""
    public var majorListDidTap = PublishRelay<String>()
//    public var majorButtonDidTap: (() -> String)?
    private var disposeBag = DisposeBag()

//    public let majorLabel = UILabel().then {
//        $0.text = "-"
//    }
    public let majorButton = UIButton().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
//        $0.setTitle("-", for: .normal)
//        $0.setTitleColor(, for: <#T##UIControl.State#>)
    }

    override func addView() {
        [
//            majorLabel,
            majorButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
//        majorLabel.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(24)
//            $0.centerY.equalToSuperview()
//        }
        majorButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30

        self.majorListDidTap.asObservable()
            .bind(onNext: { majorType in
                print("majorType")
            })
            .disposed(by: disposeBag)
//        majorButton.rx.tap.asObservable()
//            .subscribe(onNext: {
//                
//            })
//            .disposed(by: disposeBag)
    }
}
