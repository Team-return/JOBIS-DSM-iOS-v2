import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class ApplyViewController: BaseViewController<ApplyViewModel> {
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

    public override func bind() {
        let input = ApplyViewModel.Input(
            documentAddButtonDidTap: documents,
            urlsAddButtonDidTap: attachmentUrlsStackView.addAttachmentButton.rx.tap.asSignal(),
            urlsWillChanged: attachmentUrlsStackView.urlWillChanged,
            applyButtonDidTap: applyButton.rx.tap.asSignal(),
            removeUrlsButtonDidTap: attachmentUrlsStackView.removeButtonDidTap.asSignal(),
            removeDocsButtonDidTap: attachmentDocsStackView.removeButtonDidTap.asSignal()
        )
        let output = viewModel.transform(input)

        output.documents.asObservable()
            .bind {
                self.attachmentDocsStackView.updateList($0)
            }
            .disposed(by: disposeBag)

        output.urls.asObservable()
            .bind {
                self.attachmentUrlsStackView.updateList($0)
            }
            .disposed(by: disposeBag)

        output.applyButtonEnabled
            .bind {
                self.applyButton.isEnabled = $0
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        docsPicker.delegate = self
        attachmentDocsStackView.addAttachmentButton.rx.tap
            .bind { [self] in
                present(docsPicker, animated: true)
            }
            .disposed(by: disposeBag)

        companyLogoImageView.setJobisImage(urlString: viewModel.companyImageURL ?? "")
        companyLabel.text = viewModel.companyName
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
