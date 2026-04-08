import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem
import ReactorKit

public final class HomeViewController: BaseReactorViewController<HomeReactor> {
    private let rejectButtonDidTap = PublishRelay<ApplicationEntity>()
    private let reApplyButtonDidTap = PublishRelay<ApplicationEntity>()
    private let navigateToAlarmButton = UIButton().then {
        $0.setImage(.jobisIcon(.bell).resize(size: 28), for: .normal)
    }
    private let titleImageView = UIImageView(image: .jobisIcon(.jobisWhiteLogo))
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let bannerView = BannerView()
    private let recentCompanyMenuLabel = JobisMenuLabel(text: "최근 본 기업")
    private let recentCompanyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 20
            $0.sectionInset = .init(top: 7, left: 24, bottom: 7, right: 24)
            $0.itemSize = CGSize(width: 184, height: 163)
        }
    ).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(
            RecentCompanyCollectionViewCell.self,
            forCellWithReuseIdentifier: RecentCompanyCollectionViewCell.identifier
        )
    }
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
            recentCompanyMenuLabel,
            recentCompanyCollectionView,
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

        recentCompanyMenuLabel.snp.makeConstraints {
            $0.top.equalTo(bannerView.snp.bottom).offset(16)
        }

        recentCompanyCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentCompanyMenuLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(177)
        }

        careerMenuLabel.snp.makeConstraints {
            $0.top.equalTo(recentCompanyCollectionView.snp.bottom).offset(12)
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

    public override func bindAction() {
        viewDidLoadPublisher.asObservable()
            .map { HomeReactor.Action.fetchInitialData }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        navigateToAlarmButton.rx.tap
            .map { HomeReactor.Action.navigateToAlarmButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        titleImageView.rx.tapGesture().when(.recognized).asObservable()
            .map { _ in HomeReactor.Action.navigateToEasterEggDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        findCompanysCard.rx.tap
            .map { HomeReactor.Action.navigateToCompanyButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        findWinterRecruitmentsCard.rx.tap
            .map { HomeReactor.Action.navigateToWinterInternButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rejectButtonDidTap.asObservable()
            .map { HomeReactor.Action.rejectButtonDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reApplyButtonDidTap.asObservable()
            .map { HomeReactor.Action.reApplyButtonDidTap($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        applicationStatusTableView.rx.modelSelected(ApplicationEntity.self)
            .map { HomeReactor.Action.applicationStatusTableViewDidTap(
                recruitmentID: $0.recruitmentID,
                status: $0.applicationStatus
            )}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        employStatusButtonTap.asObservable()
            .map { HomeReactor.Action.employStatusButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        viewWillAppearPublisher.asObservable()
            .map { _ in HomeReactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.applicationList }
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

        reactor.state.map { $0.banners }
            .do(onNext: { [weak self] _ in
                self?.cellDisposeBag = DisposeBag()
            })
            .do(onNext: { [weak self] banners in
                self?.bannerView.setPageControl(count: banners.count)
            })
            .bind(to: bannerView.collectionView.rx.items(
                cellIdentifier: BannerCollectionViewCell.identifier,
                cellType: BannerCollectionViewCell.self
            )) { [weak self] _, element, cell in
                guard let self = self else { return }
                cell.adapt(model: element)
                if case .totalPass = element {
                    cell.employStatusButton.rx.tap
                        .map { _ in () }
                        .bind(to: self.employStatusButtonTap)
                        .disposed(by: self.cellDisposeBag)
                }
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isWinterInternSeason }
            .bind { [weak self] in
                self?.findCompanysCard.setCard(style: $0 ? .small(type: .findCompanys) : .large)
                self?.findCompanysCard.isEnabled = false
                self?.findWinterRecruitmentsCard.setCard(style: .small(type: .findWinterRecruitments))
                self?.findWinterRecruitmentsCard.isHidden = !$0
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.recentCompanyList }
            .distinctUntilChanged()
            .bind(to: recentCompanyCollectionView.rx.items(
                cellIdentifier: RecentCompanyCollectionViewCell.identifier,
                cellType: RecentCompanyCollectionViewCell.self
            )) { _, item, cell in
                cell.adapt(model: item)
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
