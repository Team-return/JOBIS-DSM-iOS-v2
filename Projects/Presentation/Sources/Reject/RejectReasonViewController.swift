import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class RejectReasonViewController: BaseBottomSheetReactorViewController<RejectReasonReactor> {
    private var attachmentDisposeBag = DisposeBag()
    private let titleLabel = UILabel().then {
        $0.setJobisText("반려 사유", font: .subBody, color: .GrayScale.gray60)
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let scrollContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let contentLabel = UILabel().then {
        $0.setJobisText("반려 사유 불러오는중...", font: .body, color: .GrayScale.gray90)
        $0.numberOfLines = 0
    }
    private let attachmentTitleLabel = UILabel().then {
        $0.setJobisText("첨부파일", font: .subBody, color: .GrayScale.gray60)
        $0.isHidden = true
    }
    private let attachmentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.isHidden = true
    }
    private let reApplyButton = JobisButton(style: .main).then {
        $0.setText("재지원 하기")
    }
    private var s3BaseURL: URL {
        URL(
            string: Bundle.main.object(forInfoDictionaryKey: "S3_BASE_URL") as? String ?? ""
        ) ?? URL(string: "https://www.google.com")!
    }

    public override func addView() {
        [
            contentLabel,
            attachmentTitleLabel,
            attachmentStackView
        ].forEach(scrollContentStackView.addArrangedSubview(_:))
        scrollContentStackView.setCustomSpacing(20, after: contentLabel)
        scrollView.addSubview(scrollContentStackView)

        [
            titleLabel,
            scrollView,
            reApplyButton
        ].forEach(self.contentView.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(reApplyButton.snp.top).offset(-16)
        }
        scrollContentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        reApplyButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottomMargin.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        viewWillAppearPublisher
            .map { RejectReasonReactor.Action.fetchRejectReason }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reApplyButton.rx.tap
            .map { RejectReasonReactor.Action.reApplyButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.rejectReason }
            .distinctUntilChanged()
            .bind(to: contentLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.attachments }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, attachments in
                owner.configureAttachments(attachments)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewDidLoadPublisher.asObservable()
            .bind {
                self.hideTabbar()
            }
            .disposed(by: disposeBag)
    }
}

private extension RejectReasonViewController {
    func configureAttachments(_ attachments: [AttachmentsEntity]) {
        attachmentDisposeBag = DisposeBag()
        attachmentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        attachmentTitleLabel.isHidden = attachments.isEmpty
        attachmentStackView.isHidden = attachments.isEmpty

        attachments.forEach { attachment in
            let button = makeAttachmentButton(fileName: fileName(of: attachment.url))

            button.rx.tap
                .bind(with: self, onNext: { owner, _ in
                    UIApplication.shared.open(owner.fileURL(of: attachment.url))
                })
                .disposed(by: attachmentDisposeBag)

            attachmentStackView.addArrangedSubview(button)
        }
    }

    func makeAttachmentButton(fileName: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = "📎 \(fileName)"
        config.baseForegroundColor = .GrayScale.gray90
        config.background.backgroundColor = .GrayScale.gray10
        config.background.cornerRadius = 8
        config.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.titleLineBreakMode = .byTruncatingMiddle
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var attributes = $0
            attributes.font = UIFont.jobisFont(.subBody)
            return attributes
        }

        return UIButton(configuration: config).then {
            $0.contentHorizontalAlignment = .leading
        }
    }

    func fileName(of url: String) -> String {
        url.components(separatedBy: "/").last?
            .components(separatedBy: "-").dropFirst().joined(separator: "-")
            ?? url
    }

    func fileURL(of url: String) -> URL {
        if url.hasPrefix("http") {
            return URL(string: url) ?? s3BaseURL
        }
        return s3BaseURL.appendingPathComponent(url)
    }
}
