import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class RecruitmentFilterViewController: BaseViewController<RecruitmentFilterViewModel> {
    private let collectionViewDidTap = PublishRelay<String>()
    private let selectJobsCode = PublishRelay<Void>()
    private let filterApplyButtonDidTap = PublishRelay<Void>()
    private var jobsCodeString: String = ""
    private var techCodeArray: [Int] = []

    private let searchTextField = JobisSearchTextField().then {
        $0.setTextField(placeholder: "검색어를 입력해주세요")
    }
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
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
    private lazy var techTableView = UITableView().then {
        $0.register(TechTableViewCell.self, forCellReuseIdentifier: TechTableViewCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.showsVerticalScrollIndicator = false
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    private let filterApplyButton = JobisButton(style: .main).then {
        $0.setText("적용하기")
    }

    public override func addView() {
        [
            searchTextField,
            scrollView,
            filterApplyButton
        ].forEach(self.view.addSubview(_:))
        scrollView.addSubview(contentStackView)
        [
            jobsCollectionView,
            techTableView
        ].forEach(self.contentStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(filterApplyButton.snp.top).inset(-12)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }

        jobsCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(jobsCollectionView.contentSize.height)
        }

        techTableView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(techTableView.contentSize.height)
        }

        filterApplyButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }

    public override func bind() {
        let input = RecruitmentFilterViewModel.Input(
            viewWillAppear: viewWillAppearPublisher,
            selectJobsCode: selectJobsCode,
            filterApplyButtonDidTap: filterApplyButtonDidTap
        )

        let output = viewModel.transform(input)
        output.jobList
            .bind(to: jobsCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                self.jobsCollectionView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)

        output.techList
            .bind(to: techTableView.rx.items(
                cellIdentifier: TechTableViewCell.identifier,
                cellType: TechTableViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                self.techTableView.layoutIfNeeded()
                cell.techCheckBoxDidTap = {
                    cell.isCheck ? self.techCodeArray.append(cell.model?.code ?? 0) :
                    self.techCodeArray.removeAll { $0 == cell.model?.code }
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
                cell.isCheck ? (self.viewModel.jobCode = String(cell.model?.code ?? 0)) : (self.viewModel.jobCode = "")
                self.selectJobsCode.accept(())
            }
            .disposed(by: disposeBag)

        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "필터 설정")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)

        filterApplyButton.rx.tap.asObservable()
            .subscribe(onNext: {
                print("------------------ Filter! ---------------------")
                dump(self.jobsCodeString)
                dump(self.techCodeArray.toString())
                print("------------------ ------- ---------------------")
                self.viewModel.techCode = self.techCodeArray.toString()
                self.filterApplyButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}

extension Array {
        func toString() -> String {
            let stringArray = self.map { String(describing: $0) }
            return stringArray.joined(separator: ", ")
        }
}
