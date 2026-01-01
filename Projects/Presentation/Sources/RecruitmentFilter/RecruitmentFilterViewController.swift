import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class RecruitmentFilterViewController: BaseReactorViewController<RecruitmentFilterReactor> {
    private let collectionViewDidTap = PublishRelay<String>()
    private let filterApplyButtonDidTap = PublishRelay<Void>()
    private var appendTechCode = PublishRelay<CodeEntity>()
    private var resetTechCode = PublishRelay<Void>()
    private let yearList = Array((2023...RecruitmentFilterViewController.currentYear()).reversed())
    private let stateList = [
        CodeEntity(code: 0, keyword: "모집중"),
        CodeEntity(code: 1, keyword: "모집 종료")
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
            stateLabel,
            stateCollectionView,
            jobsLabel,
            jobsCollectionView,
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

        stateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
        }

        stateCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(stateCollectionView.contentSize.height)
        }

        jobsLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
        }

        jobsCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(jobsCollectionView.contentSize.height)
        }

        filterApplyButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }

    public override func bindAction() {
        viewWillAppearPublisher
            .map { RecruitmentFilterReactor.Action.fetchCodeLists }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        jobsCollectionView.rx.modelSelected(CodeEntity.self)
            .do(onNext: { [weak self] _ in
                self?.resetTechCode.accept(())
            })
            .map { RecruitmentFilterReactor.Action.selectJobCode($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        yearCollectionView.rx.modelSelected(CodeEntity.self)
            .do(onNext: { [weak self] _ in
                self?.yearCollectionView.reloadData()
            })
            .map { RecruitmentFilterReactor.Action.selectYear($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        stateCollectionView.rx.modelSelected(CodeEntity.self)
            .do(onNext: { [weak self] _ in
                self?.stateCollectionView.reloadData()
            })
            .map { RecruitmentFilterReactor.Action.selectStatus($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        filterApplyButtonDidTap
            .map { RecruitmentFilterReactor.Action.filterApplyButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appendTechCode
            .map { RecruitmentFilterReactor.Action.appendTechCode($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        resetTechCode
            .map { RecruitmentFilterReactor.Action.resetTechCode }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.jobList }
            .bind(to: jobsCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { [weak self] _, element, cell in
                guard let self = self else { return }
                cell.adapt(model: element)
                cell.isCheck = Int(self.reactor.currentState.jobCode) == cell.model?.code
                self.jobsCollectionView.layoutIfNeeded()
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.techList }
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
            )) { [weak self] _, element, cell in
                guard let self = self else { return }
                cell.adapt(model: element)
                cell.isCheck = self.reactor.currentState.years.contains("\(element.code)")
            }
            .disposed(by: disposeBag)

        Observable.just(stateList)
            .bind(to: stateCollectionView.rx.items(
                cellIdentifier: JobsCollectionViewCell.identifier,
                cellType: JobsCollectionViewCell.self
            )) { [weak self] _, element, cell in
                guard let self = self else { return }
                cell.adapt(model: element)
                let mappedStatus = self.mapStatus(code: element.code)
                cell.isCheck = self.reactor.currentState.status == mappedStatus
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

    private func mapStatus(code: Int) -> String {
        switch code {
        case 0:
            return "RECRUITING"
        case 1:
            return "DONE"
        default:
            return ""
        }
    }
}
