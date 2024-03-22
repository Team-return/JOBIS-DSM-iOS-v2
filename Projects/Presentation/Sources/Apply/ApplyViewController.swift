import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class ApplyViewController: BaseViewController<ApplyViewModel> {
    public var companyID: Int?
    public var companyName: String?
    public var companyImageURL: String?

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
    private let attachmentDocsTableView = UITableView().then {
        $0.register(AttachmentDocsTableViewCell.self, forCellReuseIdentifier: AttachmentDocsTableViewCell.identifier)
        $0.rowHeight = 56
        $0.showsHorizontalScrollIndicator = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    private let attachmentUrlMenuLabel = JobisMenuLabel(text: "첨부파일")
    private let attachmentUrlTableView = UITableView().then {
        $0.register(AttachmentURLsTableViewCell.self, forCellReuseIdentifier: AttachmentURLsTableViewCell.identifier)
        $0.rowHeight = 56
        $0.showsHorizontalScrollIndicator = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    private let applyButton = JobisButton(style: .main).then {
        $0.setText("지원하기")
    }
    let addDocsButton = AddAttachmentButton(.docs)
    let addUrlsButton = AddAttachmentButton(.urls)
    private let docsPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
        .pdf,
        .png,
        .jpeg,
        .init(filenameExtension: "doc")!,
        .init(filenameExtension: "docx")!,
        .init(filenameExtension: "hwp")!,
        .init(filenameExtension: "pptx")!
    ])

    private let documents = PublishRelay<AttachmentsEntity>()
    private let urls = BehaviorRelay<[AttachmentsEntity]>(value: [])
    private let urlsWillChanged = PublishRelay<(Int, String)>()
    private let removeDidTap = PublishRelay<Int>()

    public override func addView() {
        [
            companyView,
            attachmentDocsMenuLabel,
            attachmentDocsTableView,
            attachmentUrlMenuLabel,
            attachmentUrlTableView,
            applyButton
        ].forEach(self.view.addSubview(_:))
        [
            companyLogoImageView,
            companyLabel
        ].forEach(self.companyView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        companyView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        companyLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }

        attachmentDocsMenuLabel.snp.makeConstraints {
            $0.top.equalTo(companyView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        attachmentDocsTableView.snp.makeConstraints {
            $0.top.equalTo(attachmentDocsMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(attachmentDocsTableView.contentSize.height).priority(1)
            $0.height.lessThanOrEqualTo(168).priority(2)
        }

        attachmentUrlMenuLabel.snp.makeConstraints {
            $0.top.equalTo(attachmentDocsTableView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        attachmentUrlTableView.snp.makeConstraints {
            $0.top.equalTo(attachmentUrlMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(attachmentUrlTableView.contentSize.height).priority(1)
            $0.height.lessThanOrEqualTo(168).priority(2)
        }

        applyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = ApplyViewModel.Input(
            documentAddButtonDidTap: documents,
            urlsAddButtonDidTap: addUrlsButton.rx.tap.asSignal(),
            urlsWillChanged: urlsWillChanged,
            applyButtonDidTap: applyButton.rx.tap.asSignal(),
            removeButtonDidTap: removeDidTap.asSignal()
        )
        let output = viewModel.transform(input)

        output.documents.asObservable()
            .bind(to: attachmentDocsTableView.rx
                .items(
                    cellIdentifier: AttachmentDocsTableViewCell.identifier,
                    cellType: AttachmentDocsTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                    self.attachmentDocsTableView.snp.updateConstraints {
                        $0.height.greaterThanOrEqualTo(self.attachmentDocsTableView.contentSize.height).priority(1)
                    }
                }
                .disposed(by: disposeBag)

        output.urls.asObservable()
            .bind(to: attachmentUrlTableView.rx
                .items(
                cellIdentifier: AttachmentURLsTableViewCell.identifier,
                cellType: AttachmentURLsTableViewCell.self
            )) { index, element, cell in
                cell.adapt(model: element)
                self.attachmentUrlTableView.snp.updateConstraints {
                    $0.height.greaterThanOrEqualTo(self.attachmentUrlTableView.contentSize.height).priority(1)
                }
                cell.textFieldWillChanged = { text in
                    self.urlsWillChanged.accept((index, text))
                }
                cell.removeButtonDidTap = {
                    self.removeDidTap.accept(index)
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        docsPicker.delegate = self
        attachmentDocsTableView.delegate = self
        attachmentUrlTableView.delegate = self
        addDocsButton.rx.tap
            .bind { [self] in
                present(docsPicker, animated: true)
            }
            .disposed(by: disposeBag)

        guard let companyImageURL,
              let companyName
        else { return }
        companyLogoImageView.setJobisImage(urlString: companyImageURL)
        companyLabel.text = companyName
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

extension ApplyViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: 0) >= 3 {
            return UIView()
        } else {
            if tableView == attachmentDocsTableView {
                return addDocsButton
            } else {
                return addUrlsButton
            }
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.numberOfRows(inSection: 0) >= 3 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
}
