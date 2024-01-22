import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift

final class BannerView: BaseView {
    private let disposeBag = DisposeBag()
    private var totalPassStudent = TotalPassStudentEntity(
        totalStudentCount: 0,
        passedCount: 0,
        approvedCount: 0
    )
    private var bannerList: [UIImage] = []
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 0
        $0.footerReferenceSize = .zero
        $0.headerReferenceSize = .zero
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        $0.register(
            EmploymentCollectionViewCell.self,
            forCellWithReuseIdentifier: EmploymentCollectionViewCell.identifier
        )
        $0.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.identifier
        )
    }
    private let pageControl = UIPageControl().then {
        $0.backgroundStyle = .minimal
        $0.preferredIndicatorImage = .jobisIcon(.defaultPageControl)
        $0.allowsContinuousInteraction = false
        $0.pageIndicatorTintColor = .GrayScale.gray40
        $0.currentPageIndicatorTintColor = .Primary.blue20
    }

    override func addView() {
        [
            collectionView,
            pageControl
        ].forEach {
            self.addSubview($0)
        }
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(180)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let currentPage = self?.pageControl.currentPage else { return }
                self?.collectionView.scrollToItem(
                    at: IndexPath.init(row: currentPage, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
            }).disposed(by: disposeBag)

    }

    public func setTotalPassStudent(_ entity: TotalPassStudentEntity) {
        self.totalPassStudent = entity
        self.collectionView.reloadData()
    }

    public func setBanner(_ images: [UIImage]) {
        self.bannerList = images
        self.collectionView.reloadData()
    }

    private func setPageControl() {
        self.pageControl.numberOfPages = self.bannerList.count + 1
        self.pageControl.setIndicatorImage(.jobisIcon(.currentPageControl), forPage: 0)
    }
}

extension BannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = (scrollView.contentOffset.x / scrollView.bounds.size.width)

        self.pageControl.currentPage = Int(round(value))
        for index in 0..<self.pageControl.numberOfPages {
            if index == Int(round(value)) {
                self.pageControl.setIndicatorImage(.jobisIcon(.currentPageControl), forPage: index)
            } else {
                self.pageControl.setIndicatorImage(.jobisIcon(.defaultPageControl), forPage: index)
            }
        }
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = self.collectionView.bounds.width - 36
        let index = round(scrolledOffsetX / cellWidth)

        targetContentOffset.pointee = CGPoint(
            x: index * cellWidth - scrollView.contentInset.left,
            y: scrollView.contentInset.top
        )
    }
}

extension BannerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.setPageControl()

        return self.bannerList.count + 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmploymentCollectionViewCell.identifier,
                for: indexPath
            ) as? EmploymentCollectionViewCell else { return UICollectionViewCell() }

            cell.adapt(model: self.totalPassStudent)

            return cell

        default:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BannerCollectionViewCell.identifier,
                for: indexPath
            ) as? BannerCollectionViewCell else { return UICollectionViewCell() }

            cell.adapt(model: bannerList[indexPath.row - 1])

            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return .init(
            width: collectionView.bounds.width - 48,
            height: collectionView.bounds.height
        )
    }
}