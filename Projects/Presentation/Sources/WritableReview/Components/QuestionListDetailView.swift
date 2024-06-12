import UIKit
import SnapKit
import Then
import Domain
import DesignSystem
import RxSwift

final class QuestionListDetailView: BaseView {
    public var interviewReviewID: Int?
    public var isOpen = false {
        didSet {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: .transitionCrossDissolve
            ) { [self] in
                print("뷰 업데이트")
                detailView.arrangedSubviews.forEach { $0.isHidden = !isOpen }
                detailView.arrangedSubviews.forEach { $0.alpha = isOpen ? 1 : 0 }
                interviewReviewArrowImageView.image = .jobisIcon(isOpen ? .arrowUp : .arrowDown)
                self.layoutIfNeeded()
            }
        }
    }
    private let disposeBag = DisposeBag()
    private let backStackView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    private let titleHeadView = UIStackView().then {
        $0.axis = .horizontal
    }
    private let titleView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.spacing = 8
    }
    private let titleSubView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }
    private let qSymbolLabel = UILabel().then {
        $0.setJobisText(
            "Q",
            font: .subHeadLine,
            color: .Primary.blue20
        )
    }
    private let questionLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .subHeadLine,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }
    private let codeLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .description,
            color: .Sub.skyBlue20
        )
    }
    private let interviewReviewArrowImageView = UIImageView().then {
        $0.image = .jobisIcon(.arrowDown)
    }
    private let detailView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    private let aSymbolLabel = UILabel().then {
        $0.setJobisText(
            "A",
            font: .subHeadLine,
            color: .Primary.blue20
        )
        $0.isHidden = true
    }
    private let answerLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .description,
            color: .GrayScale.gray70
        )
        $0.numberOfLines = 0
        $0.isHidden = true
    }

    override func addView() {
        self.addSubview(backStackView)

        [
            titleHeadView,
            detailView
        ].forEach(self.backStackView.addSubview(_:))

        [
            questionLabel,
            codeLabel
        ].forEach(self.titleSubView.addArrangedSubview(_:))

        [
            qSymbolLabel,
            titleSubView
        ].forEach(self.titleView.addArrangedSubview(_:))

        [
            titleView,
            interviewReviewArrowImageView
        ].forEach(self.titleHeadView.addArrangedSubview(_:))

        [
            aSymbolLabel,
            answerLabel
        ].forEach(self.detailView.addArrangedSubview(_:))
    }

    override func setLayout() {
        titleHeadView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        detailView.snp.updateConstraints {
            $0.top.equalTo(titleHeadView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(isOpen ? 16 : 0)
        }

        interviewReviewArrowImageView.snp.makeConstraints {
            $0.width.equalTo(24)
        }

        [
            aSymbolLabel,
            answerLabel
        ].forEach { detailView.setCustomSpacing(12, after: $0)}

        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureView(model: QnaEntity) {
        super.configureView()
        questionLabel.text = model.question
        codeLabel.text = model.area
        answerLabel.text = model.answer
        self.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.isOpen.toggle()
            }
            .disposed(by: disposeBag)
    }
}
