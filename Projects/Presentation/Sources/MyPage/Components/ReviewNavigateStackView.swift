import UIKit
import Domain
import DesignSystem
import RxSwift
import RxCocoa

final class ReviewNavigateStackView: UIStackView {
    let reviewNavigateButtonDidTap = PublishRelay<Int>()
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        self.spacing = 12
        self.isLayoutMarginsRelativeArrangement = true
        self.axis = .vertical
    }

    func setList(writableReviewCompanylist: [WritableReviewCompanyEntity]) {
        if writableReviewCompanylist.isEmpty {
            self.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            self.layoutMargins = .init(top: 12, left: 0, bottom: 12, right: 0)
        }
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            NSLayoutConstraint.deactivate($0.constraints)
            $0.removeFromSuperview()
        }
        writableReviewCompanylist.forEach { writableReviewCompany in
            let reviewNavigateTableViewCell = ReviewNavigateView().then {
                $0.titleLabel.text = "\(writableReviewCompany.name) 면접 후기를 적어주세요!"
                $0.reviewID = writableReviewCompany.reviewID
            }
            reviewNavigateTableViewCell.reviewNavigateButton.rx.tap
                .bind(onNext: { [weak self] in
                    self?.reviewNavigateButtonDidTap.accept(reviewNavigateTableViewCell.reviewID)
                })
                .disposed(by: disposeBag)
            self.addArrangedSubview(reviewNavigateTableViewCell)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
