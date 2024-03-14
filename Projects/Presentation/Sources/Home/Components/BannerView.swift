import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift

final class BannerView: BaseView {
    private let disposeBag = DisposeBag()
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 12
        $0.minimumInteritemSpacing = 0
        $0.footerReferenceSize = .zero
        $0.headerReferenceSize = .zero
    }
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.isScrollEnabled = true
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 16, left: 24, bottom: 10, right: 24)
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
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(collectionView.numberOfItems(inSection: 0) == 0 ? 0 : 206)
        }

        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
    }

    override func configureView() {
        self.collectionView.delegate = self
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

    public func setPageControl(count: Int) {
        self.pageControl.numberOfPages = count
        self.pageControl.setIndicatorImage(.jobisIcon(.currentPageControl), forPage: 0)
    }
}

extension BannerView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = round(scrollView.contentOffset.x / (scrollView.bounds.size.width - 48))

        self.pageControl.currentPage = Int(value)
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

extension BannerView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        return .init(
            width: collectionView.bounds.width - 48,
            height: 180
        )
    }
}
