import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import PhotosUI

public final class BugReportViewController: BaseReactorViewController<BugReportReactor> {
    var imageStringList: [String] = []
    var imageList: [UIImage] = []

    private let bugReportMajorView = BugReportMajorView()
    private let bugReportTitleTextField = JobisTextField().then {
        $0.setTextField(title: "제보 제목", placeholder: "제목을 입력해주세요")
    }
    private let bugReportContentTextView = JobisTextView().then {
        $0.setTextField(title: "제보 내용", placeholder: "버그의 내용을 입력해주세요")
    }
    private let attachImageMenuLabel = JobisMenuLabel(text: "첨부 사진 (최대 5장)")
    private let layout = LeftAlignedCollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = UICollectionViewFlowLayout.automaticSize
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.sectionInset = .init(top: 4, left: 4, bottom: 4, right: 4)
    }
    private lazy var bugImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.register(
            BugImageCollectionViewCell.self,
            forCellWithReuseIdentifier: BugImageCollectionViewCell.identifier
        )
        $0.register(
            AddImageCollectionViewCell.self,
            forCellWithReuseIdentifier: AddImageCollectionViewCell.identifier
        )
        $0.showsHorizontalScrollIndicator = false
    }
    private let emptyImageButton = UIButton().then {
        $0.isHidden = true
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
    }
    private let emptyLabel = UILabel().then {
        $0.text = "클릭하여 이미지를 첨부해주세요"
        $0.font = .jobisFont(.headLine)
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .GrayScale.gray60
    }
    private let emptyImageView = UIImageView().then {
        $0.image = UIImage.jobisIcon(.addPhoto)
    }
    private let bugReportButton = JobisButton(style: .main).then {
        $0.setText("내용을 전부 입력해주세요")
        $0.isEnabled = false
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    private let contentView = UIView()

    public override func addView() {
        [
            scrollView,
            bugReportButton
        ].forEach(self.view.addSubview(_:))
        scrollView.addSubview(contentView)

        [
            bugReportMajorView,
            bugReportTitleTextField,
            bugReportContentTextView,
            attachImageMenuLabel,
            bugImageCollectionView,
            emptyImageButton
        ].forEach(contentView.addSubview(_:))

        [
            emptyImageView,
            emptyLabel
        ].forEach(emptyImageButton.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bugReportButton.snp.top)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(bugImageCollectionView.snp.bottom).offset(20)
        }

        bugReportMajorView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        bugReportTitleTextField.snp.makeConstraints {
            $0.top.equalTo(bugReportMajorView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        bugReportContentTextView.snp.makeConstraints {
            $0.top.equalTo(bugReportTitleTextField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        attachImageMenuLabel.snp.makeConstraints {
            $0.top.equalTo(bugReportContentTextView.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }

        bugImageCollectionView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(attachImageMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        bugReportButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        emptyImageButton.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.top.equalTo(attachImageMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        emptyImageView.snp.makeConstraints {
            $0.height.width.equalTo(36)
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }

    public override func bindAction() {
        bugReportTitleTextField.textField.rx.text.orEmpty
            .map { BugReportReactor.Action.updateTitle($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bugReportContentTextView.textView.rx.text.orEmpty
            .map { BugReportReactor.Action.updateContent($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bugReportMajorView.majorViewDidTap
            .map { BugReportReactor.Action.majorViewDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bugReportButton.rx.tap
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.reactor.action.onNext(.updateImageList(self.imageStringList))
            })
            .map { BugReportReactor.Action.bugReportButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.isBugReportButtonEnabled }
            .distinctUntilChanged()
            .bind(to: bugReportButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.majorType }
            .distinctUntilChanged()
            .bind(to: bugReportMajorView.majorLabel.rx.text)
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        bugImageCollectionView.delegate = self
        bugImageCollectionView.dataSource = self

        self.emptyImageButton.isHidden = !imageList.isEmpty
        emptyImageButton.rx.tap.asObservable()
            .subscribe(onNext: {
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 0
                configuration.filter = .any(of: [.images, .videos])
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isBugReportCompleted }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(onNext: { [weak self] _ in
                self?.showJobisToast(text: "버그제보가 완료되었습니다.", inset: 70)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setLargeTitle(title: "버그 제보하기")
        self.hideTabbar()
    }
}

extension BugReportViewController: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            self.imageList.removeAll()

            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _ ) in
                        if let uiImage = image as? UIImage {
                            self?.imageList.append(uiImage)
                            self?.imageStringList.append(uiImage.toURLString())
                        }
                    }
                }
            }
        }

        picker.dismiss(animated: true, completion: {
            if !self.imageList.isEmpty {
                self.emptyImageButton.isHidden = true
            }
            self.bugImageCollectionView.reloadData()
        })
    }
}

extension BugReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageList.isEmpty {
            return self.imageList.count
        } else {
            return self.imageList.count + 1
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item == imageList.count {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddImageCollectionViewCell.identifier,
                for: indexPath) as? AddImageCollectionViewCell

            cell?.layer.cornerRadius = 8
            cell?.layer.borderWidth = 1
            cell?.layer.borderColor = UIColor.GrayScale.gray40.cgColor

            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BugImageCollectionViewCell.identifier,
                for: indexPath
            ) as? BugImageCollectionViewCell

            let image = self.imageList[indexPath.row].bugReportResize(to: CGSize(width: 92, height: 92))
            cell?.bugImageView.image = image

            return cell!
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 92, height: 92)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == imageList.count {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 0
            configuration.filter = .any(of: [.images, .videos])
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
}
