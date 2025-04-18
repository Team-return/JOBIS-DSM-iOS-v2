import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class HomeViewController: BaseViewController<HomeViewModel> {
    private let rejectButtonDidTap = PublishRelay<ApplicationEntity>()
    private let reApplyButtonDidTap = PublishRelay<ApplicationEntity>()
    private let navigateToAlarmButton = UIButton().then {
        $0.setImage(.jobisIcon(.bell).resize(size: 28), for: .normal)
    }
    private let titleImageView = UIImageView(image: .jobisIcon(.jobisLogo))
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let bannerView = BannerView()
    private let studentInfoView = StudentInfoView()
    private let careerMenuLabel = JobisMenuLabel(text: "정보 조회")
    private let applicationStatusMenuLabel = JobisMenuLabel(
        text: "지원 현황",
        subText: "승인요청 및 반려 상태엔 재지원 가능"
    )
    private let applicationStatusTableView = UITableView().then {
        $0.register(
            ApplicationStatusTableViewCell.self,
            forCellReuseIdentifier: ApplicationStatusTableViewCell.identifier
        )
        $0.rowHeight = 72
        $0.separatorStyle = .none
        $0.estimatedSectionHeaderHeight = 64
        $0.sectionHeaderTopPadding = 0
        $0.isScrollEnabled = false
        $0.setEmptyHeaderView()
    }
    private let careerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    private var findCompanysCard = CareerNavigationCard()
    private var findWinterRecruitmentsCard = CareerNavigationCard()
    private var navigateToEasterEggDidTap = PublishRelay<Void>()
    private let employStatusButtonTap = PublishRelay<Void>()
    private var cellDisposeBag = DisposeBag()
    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            findCompanysCard,
            findWinterRecruitmentsCard
        ].forEach(careerStackView.addArrangedSubview(_:))
        [
            bannerView,
            studentInfoView,
            careerMenuLabel,
            careerStackView,
            applicationStatusMenuLabel,
            applicationStatusTableView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(applicationStatusTableView.snp.bottom).offset(62)
        }

        bannerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
        }

        studentInfoView.snp.makeConstraints {
            $0.top.equalTo(bannerView.snp.bottom)
        }

        careerMenuLabel.snp.makeConstraints {
            $0.top.equalTo(studentInfoView.snp.bottom).offset(12)
        }

        careerStackView.snp.makeConstraints {
            $0.top.equalTo(careerMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(176)
        }

        applicationStatusMenuLabel.snp.makeConstraints {
            $0.top.equalTo(careerStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        applicationStatusTableView.snp.makeConstraints {
            $0.top.equalTo(applicationStatusMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(applicationStatusTableView.contentSize.height + 4)
        }
    }

    public override func bind() {
        let input = HomeViewModel.Input(
            viewAppear: viewWillAppearPublisher,
            viewDisappear: viewWillDisappearPublisher,
            navigateToAlarmButtonDidTap: navigateToAlarmButton.rx.tap.asSignal(),
            navigateToEasterEggDidTap: navigateToEasterEggDidTap,
            navigateToCompanyButtonDidTap: findCompanysCard.rx.tap.asSignal(),
            navigateToWinterInternButtonDidTap: findWinterRecruitmentsCard.rx.tap.asSignal(),
            rejectButtonDidTap: rejectButtonDidTap,
            reApplyButtonDidTap: reApplyButtonDidTap,
            applicationStatusTableViewDidTap: applicationStatusTableView.rx
                .modelSelected(ApplicationEntity.self)
                .asObservable()
                .map { ($0.recruitmentID, $0.applicationStatus) },
            employStatusButtonDidTap: employStatusButtonTap.asSignal()
        )

        titleImageView.rx.tapGesture().when(.recognized).asObservable()
            .bind { [weak self] _ in
                self?.navigateToEasterEggDidTap.accept(())
            }
            .disposed(by: disposeBag)

        let output = viewModel.transform(input)

        output.studentInfo
            .bind { [weak self] studentInfo in
                self?.studentInfoView.setStudentInfo(
                    profileImageUrl: studentInfo.profileImageUrl,
                    gcn: studentInfo.studentGcn,
                    name: studentInfo.studentName,
                    department: studentInfo.department.localizedString()
                )
            }
            .disposed(by: disposeBag)

        output.applicationList
            .do(onNext: { [weak self] applicationList in
                if applicationList.isEmpty {
                    self?.applicationStatusTableView.setEmptyHeaderView()
                    self?.applicationStatusTableView.estimatedSectionHeaderHeight = 64
                } else {
                    self?.applicationStatusTableView.estimatedSectionHeaderHeight = 0
                    self?.applicationStatusTableView.tableHeaderView = nil
                    self?.applicationStatusTableView.reloadData()
                }
            })
            .bind(
                to: applicationStatusTableView.rx.items(
                    cellIdentifier: ApplicationStatusTableViewCell.identifier,
                    cellType: ApplicationStatusTableViewCell.self
                )
            ) { _, element, cell in
                cell.adapt(model: element)
                cell.selectionStyle = .none
                cell.rejectReasonButtonDidTap = {
                    self.rejectButtonDidTap.accept($0)
                }
                cell.reApplyButtonDidTap = {
                    self.reApplyButtonDidTap.accept($0)
                }
            }
            .disposed(by: disposeBag)

        let totalPassBannerModel = output.totalPassStudentInfo.value

        let combinedBanners = output.bannerList
            .map { banners in
                return [totalPassBannerModel] + banners
            }

        combinedBanners
            .do(onNext: { [weak self] _ in
                self?.cellDisposeBag = DisposeBag()
            })
            .do(onNext: { banners in
                self.bannerView.setPageControl(count: banners.count)
            })
            .bind(to: bannerView.collectionView.rx.items(
                cellIdentifier: BannerCollectionViewCell.identifier,
                cellType: BannerCollectionViewCell.self
            )) { [weak self] index, element, cell in
                guard let self = self else { return }

                if index == 0, let cell = cell as? BannerCollectionViewCell {
                    cell.totalPassAdapt(model: output.totalPassStudentInfo.value)
                    cell.employStatusButton.rx.tap
                        .map { _ in () }
                        .bind(to: self.employStatusButtonTap)
                        .disposed(by: self.cellDisposeBag)
                } else {
                    if let fetchBanner = element as? FetchBannerEntity,
                       let cell = cell as? BannerCollectionViewCell {
                        cell.adapt(model: fetchBanner)
                    }
                }
            }
            .disposed(by: disposeBag)

        output.isWinterInternSeason
            .bind { [weak self] in
                self?.findCompanysCard.setCard(style: $0 ? .small(type: .findCompanys) : .large)
                self?.findWinterRecruitmentsCard.setCard(style: .small(type: .findWinterRecruitments))
                self?.findWinterRecruitmentsCard.isHidden = !$0
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher
            .bind {
                self.showTabbar()
            }.disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.navigationItem.rightBarButtonItem = .init(customView: navigateToAlarmButton)
        self.navigationItem.leftBarButtonItem = .init(customView: titleImageView)
    }
}

extension UITableView {
    func setEmptyHeaderView() {
        let headerView = EmptyApplicationView()
        self.tableHeaderView = headerView
    }
}
