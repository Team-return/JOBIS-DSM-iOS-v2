import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

class AreaReviewView: BaseView {
    private let disposeBag = DisposeBag()
    public let nextButtonDidTap = PublishRelay<Void>()
    public let selectedLocation = BehaviorRelay<LocationType?>(value: nil)

    private let locationFormats: [LocationType] = [.daejeon, .seoul, .gyeonggi, .other]
    private var selectedIndexPath: IndexPath?

    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "면접 지역",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }

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
            addReviewTitleLabel,
            collectionView,
            nextButton
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        addReviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(24)
            $0.leading.equalTo(24)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(addReviewTitleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(240)
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
}

extension AreaReviewView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationFormats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InterviewFormatCollectionViewCell.identifier,
            for: indexPath
        ) as? InterviewFormatCollectionViewCell else {
            return UICollectionViewCell()
        }

        let location = locationFormats[indexPath.item]
        cell.adapt(location: location)
        cell.isCheck = selectedIndexPath == indexPath

        return cell
    }
}

extension AreaReviewView: UICollectionViewDelegate {
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

        let selectedLocationValue = locationFormats[indexPath.item]
        self.selectedLocation.accept(selectedLocationValue)
        nextButton.isEnabled = true
    }
}

extension AreaReviewView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = collectionViewWidth > 0 ? collectionViewWidth : UIScreen.main.bounds.width - 48
        return CGSize(width: cellWidth, height: 51)
    }
}
