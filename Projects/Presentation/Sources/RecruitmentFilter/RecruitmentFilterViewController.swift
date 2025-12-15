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
    private let filterApplyButtonDidTap = PublishRelay<Void>()
    private var appendTechCode = PublishRelay<CodeEntity>()
    private var resetTechCode = PublishRelay<Void>()
    private let yearList = Array((2023...RecruitmentFilterViewController.currentYear()).reversed())
    private let stateList = [
        CodeEntity(code: 0, keyword: "모집중"),
        CodeEntity(code: 1, keyword: "모집종료")
    ]

    private let searchTextField = JobisSearchTextField().then {
        $0.setTextField(placeholder: "검색어를 입력해주세요")
    }
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let yearLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.applyDefaultLayout()
    }
    private let yearLabel = UILabel().then {
        $0.setJobisText("연도", font: .subHeadLine, color: .GrayScale.gray70)
    }
    private lazy var yearCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: yearLayout
    ).then {
        $0.isScrollEnabled = false
        $0.register(
            JobsCollectionViewCell.self,
            forCellWithReuseIdentifier: JobsCollectionViewCell.identifier
        )
    }
    private let jobsLabel = UILabel().then {
        $0.setJobisText("모집 분야", font: .subHeadLine, color: .GrayScale.gray70)
    }
    private let jobsLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.applyDefaultLayout()
    }
    private lazy var jobsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: jobsLayout
    ).then {
        $0.isScrollEnabled = false
        $0.register(
            JobsCollectionViewCell.self,
            forCellWithReuseIdentifier: JobsCollectionViewCell.identifier
        )
    }
    private let stateLabel = UILabel().then {
        $0.setJobisText("모집 상태", font: .subHeadLine, color: .GrayScale.gray70)
    }
    private let stateLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.applyDefaultLayout()
    }
    private lazy var stateCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: stateLayout
    ).then {
        $0.isScrollEnabled = false
        $0.register(
            JobsCollectionViewCell.self,
            forCellWithReuseIdentifier: JobsCollectionViewCell.identifier
        )
    }
    private lazy var techStackView = TechStackView()
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
            yearLabel,
            yearCollectionView,
            jobsLabel,
            jobsCollectionView,
            stateLabel,
            stateCollectionView,
            techStackView
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

        yearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
        }

        yearCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(yearCollectionView.contentSize.height)
        }

        jobsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
        }

        jobsCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(jobsCollectionView.contentSize.height)
        }

        stateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
        }

        stateCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(stateCollectionView.contentSize.height)
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
            selectJobsCode: jobsCollectionView.rx
                .modelSelected(CodeEntity.self).asObservable()
                .do(onNext: { _ in
                    self.viewModel.techCode.accept([])
                }),
            selectYears: yearCollectionView.rx.modelSelected(CodeEntity.self)
                .do(onNext: { _ in
                    self.yearCollectionView.reloadData()
                })
                .asObservable(),
            selectStatus: stateCollectionView.rx.modelSelected(CodeEntity.self)
                .do(onNext: { _ in
                    self.stateCollectionView.reloadData()
                }),
            filterApplyButtonDidTap: filterApplyButtonDidTap,
            appendTechCode: appendTechCode,
            resetTechCode: resetTechCode
        )

        let output = viewModel.transform(input)
        output.jobList
            .bind(to: jobsCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                cell.isCheck = Int(self.viewModel.jobCode) == cell.model?.code
                self.jobsCollectionView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)

        output.techList
            .bind { [weak self] in
                self?.techStackView.setTech(techList: $0)
                self?.techStackView.techDidTap = { code in
                    self?.appendTechCode.accept(code)
                }
            }
            .disposed(by: disposeBag)

        let yearEntities = yearList.map { CodeEntity(code: $0, keyword: "\($0)") }
        Observable.just(yearEntities)
            .bind(to: yearCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                cell.isCheck = self.viewModel.years.value.contains("\(element.code)")
            }
            .disposed(by: disposeBag)

        Observable.just(stateList)
            .bind(to: stateCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
                cell.isCheck = self.viewModel.status == self.viewModel.mapStatus(code: element.code)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {

        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "필터 설정")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)

        filterApplyButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.filterApplyButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {}
}

extension RecruitmentFilterViewController {
    fileprivate static func currentYear() -> Int {
        Calendar.current.component(.year, from: Date())
    }
}
