import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterestFieldViewController: BaseReactorViewController<InterestFieldReactor> {

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

    public override func bindAction() {
        viewWillAppearPublisher
            .map { InterestFieldReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        majorCollectionView.rx.itemSelected
            .compactMap { [weak self] indexPath -> CodeEntity? in
                guard let self = self else { return nil }
                return self.reactor.currentState.availableInterests[safe: indexPath.item]
            }
            .map { InterestFieldReactor.Action.toggleInterest($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selectButton.rx.tap
            .map { InterestFieldReactor.Action.selectButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.availableInterests }
            .bind(to: majorCollectionView.rx.items(
                cellIdentifier: MajorCollectionViewCell.identifier,
                cellType: MajorCollectionViewCell.self
            )) { [weak self] index, codeEntity, cell in
                guard let self = self else { return }
                let isSelected = self.reactor.currentState.selectedInterests.contains(where: { $0.code == codeEntity.code })

                cell.adapt(model: codeEntity)
                cell.isCheck = isSelected
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.selectedCount }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] count in
                if count == 0 {
                    self?.selectButton.setText("관심 분야를 선택해 주세요!")
                    self?.selectButton.isEnabled = false
                } else {
                    self?.selectButton.setText("\(count)개 선택")
                    self?.selectButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.studentName }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] name in
                self?.interestFieldTitleLabel.setJobisText(
                    "\(name)님의\n관심사를 선택해주세요",
                    font: .smallBody,
                    color: .GrayScale.gray90
                )
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.selectedInterests }
            .distinctUntilChanged { $0.map { $0.code } == $1.map { $0.code } }
            .skip(1)
            .bind(onNext: { [weak self] _ in
                self?.majorCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "관심 분야 선택")
        navigationItem.largeTitleDisplayMode = .never
        hideTabbar()
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
