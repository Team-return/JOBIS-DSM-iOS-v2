import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InfoCheckView: BaseView {
    private let disposeBag = DisposeBag()
    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "확인",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }
    private let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .GrayScale.gray60
    }
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .fill
    }
    private let formatItem = InfoCheckItemView(title: "면접 구분")
    private let locationItem = InfoCheckItemView(title: "면접 지역")
    private let companyItem = InfoCheckItemView(title: "업체명")
    private let techItem = InfoCheckItemView(title: "지원 직무")
    private let interviewerCountItem = InfoCheckItemView(title: "면접관 수")
    public let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = true
    }
    public let nextButtonDidTap = PublishRelay<Void>()

    public override func addView() {
        [
            backButton,
            addReviewTitleLabel,
            contentStackView,
            nextButton
        ].forEach(self.addSubview(_:))

        [
            formatItem,
            locationItem,
            companyItem,
            techItem,
            interviewerCountItem
        ].forEach(contentStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(20)
        }

        addReviewTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(addReviewTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }

    public override func configureView() {
        nextButton.rx.tap
            .bind(to: nextButtonDidTap)
            .disposed(by: disposeBag)
    }

    public func setInfo(
        format: InterviewFormat?,
        location: LocationType?,
        tech: CodeEntity,
        interviewersCount: String,
        companyName: String?
    ) {
        formatItem.setValue(displayName(for: format))
        locationItem.setValue(displayName(for: location))
        companyItem.setValue((companyName?.isEmpty == false) ? companyName! : "-")
        techItem.setValue(tech.keyword)
        interviewerCountItem.setValue("\(interviewersCount)(명)")
    }

    private func displayName(for format: InterviewFormat?) -> String {
        guard let format = format else { return "-" }
        switch format {
        case .individual: return "개인"
        case .group: return "그룹"
        case .other: return "기타"
        }
    }

    private func displayName(for location: LocationType?) -> String {
        guard let location = location else { return "-" }
        switch location {
        case .daejeon: return "대전"
        case .seoul: return "서울"
        case .gyeonggi: return "경기"
        case .other: return "기타"
        }
    }
}

private final class InfoCheckItemView: UIView {
    private let titleLabel = UILabel().then {
        $0.setJobisText("", font: .subBody, color: .GrayScale.gray60)
    }
    private let valueLabel = UILabel().then {
        $0.setJobisText("", font: .headLine, color: .Primary.blue20)
        $0.numberOfLines = 0
    }

    init(title: String) {
        super.init(frame: .zero)
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
        titleLabel.text = title

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { return nil }

    func setValue(_ text: String) {
        valueLabel.text = text
        valueLabel.textColor = .Primary.blue20
    }
}
