import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Core
import Kingfisher
import DesignSystem

class BugReportMajorView: BaseView {
    public let majorViewDidTap = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let titleLabel = JobisMenuLabel(text: "버그 제보 분야")
    private let majorView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
    }
    private let majorLabel = UILabel().then {
        $0.setJobisText("전체", font: .subHeadLine, color: .GrayScale.gray90)
    }
    private let arrowImageView = UIImageView().then {
        $0.image = .jobisIcon(.arrowDown)
    }
    override func addView() {
        [
            titleLabel,
            majorView
        ].forEach(self.addSubview(_:))

        [
            majorLabel,
            arrowImageView
        ].forEach(majorView.addSubview(_:))
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview()
        }

        majorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }

        majorLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
        }

        arrowImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        majorView.rx.tapGesture()
            .bind { _ in
                self.majorViewDidTap.accept(())
            }
            .disposed(by: disposeBag)
    }
}
