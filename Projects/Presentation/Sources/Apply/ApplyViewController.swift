import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class ApplyViewController: BaseReactorViewController<ApplyReactor> {
    private let backStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    private let companyView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 12, left: 24, bottom: 12, right: 24)
    }
    private let companyLogoImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.GrayScale.gray30.cgColor
        $0.layer.cornerRadius = 8
    }
    private let companyLabel = UILabel().then {
        $0.setJobisText(
            "회사 불러오는중...",
            font: .headLine,
            color: .GrayScale.gray90
        )
    }
    private let attachmentDocsMenuLabel = JobisMenuLabel(text: "첨부파일")
    private let attachmentDocsStackView = AttachmentStackView().then {
        $0.configureView(.docs)
    }
    private let attachmentUrlsMenuLabel = JobisMenuLabel(text: "URL")
    private let attachmentUrlsStackView = AttachmentStackView().then {
        $0.configureView(.urls)
    }
    private let applyButton = JobisButton(style: .main).then {
        $0.setText("지원하기")
        $0.isEnabled = false
    }
    private let docsPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
        .pdf,
        .png,
        .jpeg,
        .init(filenameExtension: "doc")!,
        .init(filenameExtension: "docx")!,
        .init(filenameExtension: "hwp")!,
        .init(filenameExtension: "pptx")!
    ])

    private let documents = PublishRelay<AttachmentsRequestQuery>()
    private let urls = BehaviorRelay<[AttachmentsRequestQuery]>(value: [])
    private let urlsWillChanged = PublishRelay<(Int, String)>()

    public override func addView() {
        [
            backStackView,
            applyButton
        ].forEach(self.view.addSubview(_:))
        [
            companyView,
            attachmentDocsMenuLabel,
            attachmentDocsStackView,
            attachmentUrlsMenuLabel,
            attachmentUrlsStackView
        ].forEach(self.backStackView.addArrangedSubview(_:))
        [
            companyLogoImageView,
            companyLabel
        ].forEach(self.companyView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        backStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        companyLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }

        applyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        documents
            .map { ApplyReactor.Action.documentDidAdd($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        attachmentUrlsStackView.addAttachmentButton.rx.tap
            .map { ApplyReactor.Action.urlAddButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        attachmentUrlsStackView.urlWillChanged
            .map { ApplyReactor.Action.urlDidChange($0.0, $0.1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        applyButton.rx.tap
            .map { ApplyReactor.Action.applyButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        attachmentUrlsStackView.removeButtonDidTap
            .map { ApplyReactor.Action.removeUrl($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        attachmentDocsStackView.removeButtonDidTap
            .map { ApplyReactor.Action.removeDocument($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state
            .map { $0.documents }
            .distinctUntilChanged { $0.count == $1.count }
            .bind(onNext: { [weak self] documents in
                self?.attachmentDocsStackView.updateList(documents)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.urls }
            .distinctUntilChanged { $0.count == $1.count }
            .bind(onNext: { [weak self] urls in
                self?.attachmentUrlsStackView.updateList(urls)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.applyButtonEnabled }
            .distinctUntilChanged()
            .bind(to: applyButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        docsPicker.delegate = self
        attachmentDocsStackView.addAttachmentButton.rx.tap
            .bind { [self] in
                present(docsPicker, animated: true)
            }
            .disposed(by: disposeBag)

        companyLogoImageView.setJobisImage(urlString: reactor.companyImageURL ?? "")
        companyLabel.text = reactor.companyName
        viewWillAppearPublisher.asObservable()
            .bind(with: self, onNext: { owner, _ in
                owner.hideTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "지원하기")
    }
}

extension ApplyViewController: UIDocumentPickerDelegate {
    public func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        documents.accept(.init(url: urls.first?.lastPathComponent ?? "", type: .file))
    }
}
