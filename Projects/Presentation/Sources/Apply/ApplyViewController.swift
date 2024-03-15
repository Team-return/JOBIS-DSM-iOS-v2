import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class ApplyViewController: BaseViewController<ApplyViewModel> {
    public var companyID: Int?
    public var companyName: String?
    public var companyImageURL: String?

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
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 8
        $0.itemSize = .init(width: UIScreen.main.bounds.size.width - 48, height: 48)
        $0.sectionInset = .init(top: 4, left: 24, bottom: 4, right: 24)
    }
    private let docsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private lazy var attachedDocsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.register(
            AttachmentDocsCollectionViewCell.self,
            forCellWithReuseIdentifier: AttachmentDocsCollectionViewCell.identifier
        )
        $0.showsHorizontalScrollIndicator = false
    }
    private let attachmentURLsMenuLabel = JobisMenuLabel(text: "URL")
    private let urlsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private lazy var attachedURLsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.register(
            AttachmentURLsCollectionViewCell.self,
            forCellWithReuseIdentifier: AttachmentURLsCollectionViewCell.identifier
        )
        $0.showsHorizontalScrollIndicator = false
    }
    private let addDocsButton = AddAttachmentButton(.docs)
    private let addURLsButton = AddAttachmentButton(.urls)
    private let applyButton = JobisButton(style: .main).then {
        $0.setText("지원하기")
    }
    let docsPicker = UIDocumentPickerViewController(forOpeningContentTypes: [
        .pdf,
        .png,
        .jpeg,
        .init(filenameExtension: "doc")!,
        .init(filenameExtension: "docx")!,
        .init(filenameExtension: "hwp")!,
        .init(filenameExtension: "pptx")!
    ])

    private let documents = BehaviorRelay<[URL]>(value: [])
    private let urls = BehaviorRelay<[String]>(value: [])

    public override func addView() {
        [
            companyLogoImageView,
            companyLabel,
            attachmentDocsMenuLabel,
            docsStackView,
            attachmentURLsMenuLabel,
            urlsStackView,
            applyButton
        ].forEach(self.view.addSubview(_:))

        [
            attachedDocsCollectionView,
            addDocsButton
        ].forEach(docsStackView.addArrangedSubview(_:))

        [
            attachedURLsCollectionView,
            addURLsButton
        ].forEach(urlsStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        companyLogoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }

        companyLabel.snp.makeConstraints {
            $0.leading.equalTo(companyLogoImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(companyLogoImageView)
        }

        attachmentDocsMenuLabel.snp.makeConstraints {
            $0.top.equalTo(companyLogoImageView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        docsStackView.snp.makeConstraints {
            $0.top.equalTo(attachmentDocsMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        attachedDocsCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(attachedDocsCollectionView.contentSize.height)
        }

//        addDocsButton.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(24)
//        }

        attachmentURLsMenuLabel.snp.makeConstraints {
            $0.top.equalTo(docsStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        urlsStackView.snp.makeConstraints {
            $0.top.equalTo(attachmentURLsMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        attachedURLsCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(attachedURLsCollectionView.contentSize.height)
        }

//        addURLsButton.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview().inset(24)
//        }

        applyButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = ApplyViewModel.Input()
        let output = viewModel.transform(input)
    }

    public override func configureViewController() {
        docsPicker.delegate = self

        self.addDocsButton.rx.tap
            .asObservable()
            .bind { [self] _ in
                present(docsPicker, animated: true)
            }
            .disposed(by: disposeBag)

        self.addURLsButton.rx.tap
            .asObservable()
            .bind { [self] in
                urls.accept(urls.value + [""])
            }
            .disposed(by: disposeBag)

        self.documents.asObservable()
            .do(onNext: { [weak self] urls in
                self?.addDocsButton.isHidden = urls.count >= 3
            })
            .bind(to: attachedDocsCollectionView.rx
                .items(
                cellIdentifier: AttachmentDocsCollectionViewCell.identifier,
                cellType: AttachmentDocsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)

        self.urls.asObservable()
            .do(onNext: { [weak self] urls in
                self?.addURLsButton.isHidden = urls.count >= 3
            })
            .bind(to: attachedURLsCollectionView.rx
                .items(
                cellIdentifier: AttachmentURLsCollectionViewCell.identifier,
                cellType: AttachmentURLsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
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
        documents.accept(documents.value + urls)
    }
}
