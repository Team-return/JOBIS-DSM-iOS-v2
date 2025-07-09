import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterestFieldViewController: BaseViewController<InterestFieldViewModel> {
    private let selectedIndexesRelay = BehaviorRelay<Set<IndexPath>>(value: [])
    private let interestsRelay = BehaviorRelay<[CodeEntity]>(value: [])
    private let selectedInterestsRelay = BehaviorRelay<[CodeEntity]>(value: [])

    private let interestFieldTitleLabel = UILabel().then {
        $0.setJobisText(
            "님의\n관심사를 선택해주세요",
            font: .smallBody,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }

    private let interestFieldDescriptionLabel = UILabel().then {
        $0.setJobisText(
            "관심사에 맞는 모집 의뢰서가 업로드되면 알림을 드립니다!",
            font: .description,
            color: .GrayScale.gray80
        )
    }

    private let layout = AlignedCollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = CGSize(width: 100, height: 31)
        $0.sectionInset = .zero
    }

    private lazy var majorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(
            MajorCollectionViewCell.self,
            forCellWithReuseIdentifier: MajorCollectionViewCell.identifier
        )
    }

    private let selectButton = JobisButton(style: .main).then {
        $0.setText("관심 분야를 선택해 주세요!")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            interestFieldTitleLabel,
            interestFieldDescriptionLabel,
            majorCollectionView,
            selectButton
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        interestFieldTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        interestFieldDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(interestFieldTitleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
        majorCollectionView.snp.makeConstraints {
            $0.top.equalTo(interestFieldDescriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(selectButton.snp.top).offset(-24)
        }
        selectButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = InterestFieldViewModel.Input(
            viewAppear: viewWillAppearPublisher,
            selectButtonDidTap: selectButton.rx.tap.asSignal(),
            selectedInterests: selectedInterestsRelay.asObservable()
        )

        let output = viewModel.transform(input)

        output.availableInterests
            .bind(to: interestsRelay)
            .disposed(by: disposeBag)

        interestsRelay
            .bind(to: majorCollectionView.rx.items(
                cellIdentifier: MajorCollectionViewCell.identifier,
                cellType: MajorCollectionViewCell.self
            )) { [weak self] index, codeEntity, cell in
                let indexPath = IndexPath(item: index, section: 0)
                let isSelected = self?.selectedIndexesRelay.value.contains(indexPath) ?? false

                cell.adapt(model: codeEntity)
                cell.isCheck = isSelected
            }
            .disposed(by: disposeBag)

        majorCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, indexPath in
                var currentSelected = owner.selectedIndexesRelay.value

                if currentSelected.contains(indexPath) {
                    currentSelected.remove(indexPath)
                } else {
                    currentSelected.insert(indexPath)
                }

                owner.selectedIndexesRelay.accept(currentSelected)
                owner.updateSelectedInterests()

                DispatchQueue.main.async {
                    owner.majorCollectionView.reloadItems(at: [indexPath])
                }
            }
            .disposed(by: disposeBag)

        output.selectedInterests
            .map { $0.count }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] count in
                if count == 0 {
                    self?.selectButton.setText("관심 분야를 선택해 주세요!")
                    self?.selectButton.isEnabled = false
                } else {
                    self?.selectButton.setText("\(count)개 선택")
                    self?.selectButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)

        output.studentName
            .drive(onNext: { [weak self] name in
                self?.interestFieldTitleLabel.setJobisText(
                    "\(name)님의\n관심사를 선택해주세요",
                    font: .smallBody,
                    color: .GrayScale.gray90
                )
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "관심 분야 선택")
        navigationItem.largeTitleDisplayMode = .never
        hideTabbar()
    }

    private func updateSelectedInterests() {
        let currentInterests = interestsRelay.value
        let currentSelectedIndexes = selectedIndexesRelay.value
        let selectedInterests = currentSelectedIndexes.map { currentInterests[$0.item] }
        selectedInterestsRelay.accept(selectedInterests)
    }
}
