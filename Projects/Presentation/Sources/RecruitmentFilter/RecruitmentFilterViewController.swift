import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class RecruitmentFilterViewController: BaseViewController<RecruitmentFilterViewModel> {
    private let searchTextField = JobisSearchTextField().then {
        $0.setTextField(placeholder: "검색어를 입력해주세요")
    }
    private let layout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.scrollDirection = .vertical
        $0.itemSize = UICollectionViewFlowLayout.automaticSize
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.sectionInset = .init(top: 8, left: 24, bottom: 8, right: 24)
    }
    private lazy var jobsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.isScrollEnabled = false
        $0.register(
            JobsCollectionViewCell.self,
            forCellWithReuseIdentifier: JobsCollectionViewCell.identifier
        )
    }
    public override func addView() {
        [
            searchTextField,
            jobsCollectionView
        ].forEach(self.view.addSubview(_:))
    }

    public override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        jobsCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(jobsCollectionView.contentSize.height)
        }
    }

    public override func bind() {
        let input = RecruitmentFilterViewModel.Input(viewWillAppear: viewWillAppearPublisher)
        let output = viewModel.transform(input)
        output.jobList
            .bind(to: jobsCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                cell.layoutIfNeeded()
                self.jobsCollectionView.snp.updateConstraints {
                    $0.height.greaterThanOrEqualTo(self.jobsCollectionView.contentSize.height)
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        jobsCollectionView.rx.itemSelected.asObservable()
            .bind {
                guard let cell = self.jobsCollectionView.cellForItem(
                    at: IndexPath(row: $0.row, section: 0)
                ) as? JobsCollectionViewCell else { return }
                cell.isCheck.toggle()
            }
            .disposed(by: disposeBag)

        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "필터 설정")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}
