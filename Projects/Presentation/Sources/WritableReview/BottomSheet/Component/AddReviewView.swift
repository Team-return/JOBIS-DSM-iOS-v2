import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

class AddReviewView: BaseView {
    private let disposeBag = DisposeBag()
    public let nextButtonDidTap = PublishRelay<Void>()
    public let backButtonDidTap = PublishRelay<Void>()
    public let selectedFormat = BehaviorRelay<InterviewFormat?>(value: nil)

    private let interviewFormats: [InterviewFormat] = [.individual, .group, .other]
    private var selectedIndexPath: IndexPath?

    private let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .GrayScale.gray60
    }

    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "면접 구분",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }

    private let progressBarView = ProgressBarView()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(InterviewFormatCollectionViewCell.self,
                   forCellWithReuseIdentifier: InterviewFormatCollectionViewCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsets.zero
        cv.scrollIndicatorInsets = UIEdgeInsets.zero
        return cv
    }()

    public let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            backButton,
            addReviewTitleLabel,
            progressBarView,
            collectionView,
            nextButton
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(20)
        }

        addReviewTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton) // 버튼과 세로 맞춤
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
        }

        progressBarView.snp.makeConstraints {
            $0.top.equalTo(addReviewTitleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(backButton)
            $0.width.equalTo(70)
            $0.height.equalTo(6)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(181)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
        }
    }

    public override func configureView() {
        progressBarView.configure(totalSteps: 4, currentStep: 1)

        nextButton.rx.tap
            .bind(to: nextButtonDidTap)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(to: backButtonDidTap)
            .disposed(by: disposeBag)
    }

    public func updateProgress(currentStep: Int) {
        progressBarView.configure(totalSteps: 4, currentStep: currentStep)
    }
}

extension AddReviewView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interviewFormats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InterviewFormatCollectionViewCell.identifier,
            for: indexPath
        ) as? InterviewFormatCollectionViewCell else {
            return UICollectionViewCell()
        }

        let format = interviewFormats[indexPath.item]
        cell.adapt(format: format)
        cell.isCheck = selectedIndexPath == indexPath

        return cell
    }
}

extension AddReviewView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath {
            if let previousCell = collectionView.cellForItem(at: previousIndexPath) as? InterviewFormatCollectionViewCell {
                previousCell.isCheck = false
            }
        }

        selectedIndexPath = indexPath
        if let cell = collectionView.cellForItem(at: indexPath) as? InterviewFormatCollectionViewCell {
            cell.isCheck = true
        }

        let selectedFormat = interviewFormats[indexPath.item]
        self.selectedFormat.accept(selectedFormat)

        nextButton.isEnabled = true
    }
}

extension AddReviewView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth > 0 ? collectionViewWidth : UIScreen.main.bounds.width - 48
        return CGSize(width: cellWidth, height: 51)
    }
}
