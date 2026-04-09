import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NoticeDetailViewController: BaseReactorViewController<NoticeDetailReactor> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let noticeTitleLabel = UILabel().then {
        $0.setJobisText("공지사항 불러오는 중.....", font: .headLine, color: .GrayScale.gray80)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let noticeDateLabel = UILabel()
    private let noticeContentLabel = UILabel().then {
        $0.setJobisText("-", font: .body, color: .GrayScale.gray80)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let attachmentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.isHidden = true
    }
    private let attachmentTitleLabel = UILabel().then {
        $0.setJobisText("첨부파일", font: .headLine, color: .GrayScale.gray80)
    }

    private var s3BaseURL: URL {
        URL(
            string: Bundle.main.object(forInfoDictionaryKey: "S3_BASE_URL") as? String ?? ""
        ) ?? URL(string: "https://www.google.com")!
    }

    public override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            noticeTitleLabel,
            noticeDateLabel,
            noticeContentLabel,
            attachmentTitleLabel,
            attachmentStackView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(attachmentStackView.snp.bottom).offset(20)
        }

        noticeTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(24)
        }

        noticeDateLabel.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom)
            $0.left.equalToSuperview().inset(24)
        }

        noticeContentLabel.snp.makeConstraints {
            $0.top.equalTo(noticeDateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        attachmentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(noticeContentLabel.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(24)
        }

        attachmentStackView.snp.makeConstraints {
            $0.top.equalTo(attachmentTitleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher
            .map { NoticeDetailReactor.Action.fetchNoticeDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.compactMap { $0.noticeDetail }
            .subscribe(onNext: { [weak self] detail in
                guard let self else { return }
                self.noticeTitleLabel.text = detail.title
                self.noticeDateLabel.setJobisText(
                    detail.createdAt,
                    font: .description,
                    color: .GrayScale.gray60
                )
                self.noticeContentLabel.text = detail.content
                self.configureAttachments(detail.attachments)
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() { }

    public override func configureNavigation() {
        setSmallTitle(title: "공지사항")
        navigationItem.largeTitleDisplayMode = .never
    }

    private func configureAttachments(_ attachments: [AttachmentsEntity]) {
        attachmentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard !attachments.isEmpty else {
            attachmentTitleLabel.isHidden = true
            attachmentStackView.isHidden = true
            return
        }

        attachmentTitleLabel.isHidden = false
        attachmentStackView.isHidden = false

        for attachment in attachments {
            let fileName = attachment.url.components(separatedBy: "/").last?
                .components(separatedBy: "-").dropFirst().joined(separator: "-")
                ?? attachment.url

            let button = UIButton(type: .system).then {
                $0.setTitle("📎 \(fileName)", for: .normal)
                $0.titleLabel?.font = .systemFont(ofSize: 14)
                $0.contentHorizontalAlignment = .left
                $0.backgroundColor = .GrayScale.gray20
                $0.layer.cornerRadius = 8
                $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            }

            let fileURL: URL
            if attachment.url.hasPrefix("http") {
                fileURL = URL(string: attachment.url) ?? s3BaseURL
            } else {
                fileURL = s3BaseURL.appendingPathComponent(attachment.url)
            }

            button.rx.tap
                .subscribe(onNext: { _ in
                    UIApplication.shared.open(fileURL)
                })
                .disposed(by: disposeBag)

            attachmentStackView.addArrangedSubview(button)
        }
    }
}
