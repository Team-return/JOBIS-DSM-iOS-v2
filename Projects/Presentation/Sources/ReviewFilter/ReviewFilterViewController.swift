import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class ReviewFilterViewController: BaseViewController<ReviewFilterViewModel> {
    private let filterApplyButtonDidTap = PublishRelay<Void>()
    private var selectedYear: String = ""
    private let selectedYearRelay = BehaviorRelay<String>(value: "")
    private var selectedJobIndex: Int? = nil
    private var selectedYearIndex: Int? = nil

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }

    private let layout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = CGSize(width: 100, height: 40)
        $0.sectionInset = .init(top: 8, left: 24, bottom: 8, right: 24)
    }

    private let majorSectionView = UIView()
    private let majorLabel = UILabel().then {
        $0.setJobisText("전공", font: .subHeadLine, color: UIColor.GrayScale.gray70)
    }
    private lazy var jobsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.isScrollEnabled = false
        $0.register(
            ReviewMajorCollectionViewCell.self,
            forCellWithReuseIdentifier: ReviewMajorCollectionViewCell.identifier
        )
    }

    private let yearSectionView = UIView()
    private let yearLabel = UILabel().then {
        $0.setJobisText("연도", font: .subHeadLine, color: UIColor.GrayScale.gray70)
    }

    private let yearLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = CGSize(width: 80, height: 40)
        $0.sectionInset = .init(top: 8, left: 24, bottom: 8, right: 24)
    }

    private lazy var yearsCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: yearLayout
    ).then {
        $0.isScrollEnabled = false
        $0.register(
            ReviewMajorCollectionViewCell.self,
            forCellWithReuseIdentifier: ReviewMajorCollectionViewCell.identifier
        )
    }

    private let interviewSectionView = UIView()
    private let interviewLabel = UILabel().then {
        $0.setJobisText("면접 구분", font: .subHeadLine, color: UIColor.GrayScale.gray70)
    }
    private lazy var interviewStackView = ReviewTechStackView()
    private let regionSectionView = UIView()
    private let regionLabel = UILabel().then {
        $0.setJobisText("지역", font: .subHeadLine, color: UIColor.GrayScale.gray70)
    }
    private lazy var regionStackView = ReviewTechStackView()
    private let filterApplyButton = JobisButton(style: .main).then {
        $0.setText("적용하기")
    }

    public override func addView() {
        [
            scrollView,
            filterApplyButton
        ].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStackView)
        [
            majorSectionView,
            yearSectionView,
            interviewSectionView,
            regionSectionView
        ].forEach(self.contentStackView.addArrangedSubview(_:))
        [
            majorLabel,
            jobsCollectionView
        ].forEach { majorSectionView.addSubview($0) }
        [
            yearLabel,
            yearsCollectionView
        ].forEach { yearSectionView.addSubview($0) }
        [
            interviewLabel,
            interviewStackView
        ].forEach { interviewSectionView.addSubview($0) }
        [
            regionLabel,
            regionStackView
        ].forEach { regionSectionView.addSubview($0) }
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(filterApplyButton.snp.top).offset(-12)
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        majorLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        jobsCollectionView.snp.makeConstraints {
            $0.top.equalTo(majorLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(jobsCollectionView.contentSize.height)
        }

        yearLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        yearsCollectionView.snp.makeConstraints {
            $0.top.equalTo(yearLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.greaterThanOrEqualTo(yearsCollectionView.contentSize.height)
        }

        interviewLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        interviewStackView.snp.makeConstraints {
            $0.top.equalTo(interviewLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        regionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        regionStackView.snp.makeConstraints {
            $0.top.equalTo(regionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        filterApplyButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }

    public override func bind() {
        let input = ReviewFilterViewModel.Input(
            viewWillAppear: viewWillAppearPublisher,
            selectJobsCode: jobsCollectionView.rx
                .modelSelected(CodeEntity.self).asObservable(),
            selectYear: selectedYearRelay.asObservable(),
            filterApplyButtonDidTap: filterApplyButtonDidTap
        )

        let output = viewModel.transform(input)
        output.jobList
            .bind(to: jobsCollectionView.rx.items(
                cellIdentifier: ReviewMajorCollectionViewCell.identifier,
                cellType: ReviewMajorCollectionViewCell.self
            )) { [weak self] index, element, cell in
                cell.adapt(model: element)
                cell.isCheck = Int(self?.viewModel.jobCode ?? "") == element.code
                if cell.isCheck {
                    self?.selectedJobIndex = index
                }
            }
            .disposed(by: disposeBag)

        jobsCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.handleJobSelection(at: indexPath)
            })
            .disposed(by: disposeBag)

        output.interviewTypeList
            .bind { [weak self] interviewTypes in
                self?.interviewStackView.setTech(techList: interviewTypes)
            }
            .disposed(by: disposeBag)

        output.regionList
            .bind { [weak self] regions in
                self?.regionStackView.setTech(techList: regions)
            }
            .disposed(by: disposeBag)
    }

    private func handleJobSelection(at indexPath: IndexPath) {

        if let previousIndex = selectedJobIndex,
           let previousCell = jobsCollectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? ReviewMajorCollectionViewCell {
            previousCell.isCheck = false
        }

        if let cell = jobsCollectionView.cellForItem(at: indexPath) as? ReviewMajorCollectionViewCell {
            cell.isCheck = true
            selectedJobIndex = indexPath.item
        }
    }

    private func handleYearSelection(at indexPath: IndexPath) {
        if let previousIndex = selectedYearIndex,
           let previousCell = yearsCollectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? ReviewMajorCollectionViewCell {
            previousCell.isCheck = false
        }

        if let cell = yearsCollectionView.cellForItem(at: indexPath) as? ReviewMajorCollectionViewCell {
            cell.isCheck = true
            selectedYearIndex = indexPath.item

            let years = (2020...2026).map { String($0) }
            if indexPath.item < years.count {
                selectedYear = years[indexPath.item]
                selectedYearRelay.accept(selectedYear)
            }
        }
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                self.setSmallTitle(title: "필터 설정")
                self.navigationController?.navigationBar.prefersLargeTitles = false
            }
            .disposed(by: disposeBag)

        let years = (2020...2026).map { String($0) }

        Observable.just(years)
            .bind(to: yearsCollectionView.rx.items(
                cellIdentifier: ReviewMajorCollectionViewCell.identifier,
                cellType: ReviewMajorCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(value: element)
                cell.isCheck = false
            }
            .disposed(by: disposeBag)

        yearsCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.handleYearSelection(at: indexPath)
            })
            .disposed(by: disposeBag)

        filterApplyButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.filterApplyButtonDidTap.accept(())
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
