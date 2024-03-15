import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Kingfisher
import DesignSystem

public final class MyPageViewController: BaseViewController<MyPageViewModel> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.layoutMargins = .init(top: 0, left: 0, bottom: 60, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    private let studentInfoView = StudentInfoView()
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 12
        $0.itemSize = .init(width: UIScreen.main.bounds.width - 48, height: 76)
        $0.sectionInset = .init(top: 12, left: 24, bottom: 12, right: 24)
    }
    private lazy var reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.register(
            ReviewCollectionViewCell.self,
            forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier
        )
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .init(top: 12, left: 24, bottom: 12, right: 24)
        $0.contentInsetAdjustmentBehavior = .never
    }
    private let accountSectionView = AccountSectionView()
    private let bugSectionView = BugSectionView()
    private let helpSectionView = HelpSectionView()

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        [
            studentInfoView,
            reviewCollectionView,
            helpSectionView,
            accountSectionView,
            bugSectionView
        ].forEach { self.stackView.addArrangedSubview($0) }
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.top.width.equalToSuperview()
        }

        reviewCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo((reviewCollectionView.numberOfItems(inSection: 0) * 88) + 12)
        }
    }

    public override func bind() {
        let input = MyPageViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            reviewNavigate: reviewCollectionView.rx.itemSelected
                .map {
                    guard let cell = self.reviewCollectionView.cellForItem(at: $0) as? ReviewCollectionViewCell
                    else { return 0 }
                    return cell.model?.reviewID ?? 0
                },
            helpSectionDidTap: helpSectionView.getSelectedItem(type: .announcement),
            changePasswordSectionDidTap: accountSectionView.getSelectedItem(type: .changePassword),
            logoutSectionDidTap: accountSectionView.getSelectedItem(type: .logout),
            withdrawalSectionDidTap: accountSectionView.getSelectedItem(type: .withDraw)
        )

        input.changePasswordSectionDidTap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)

        let output = viewModel.transform(input)

        output.studentInfo.asObservable()
            .bind(onNext: { [weak self] in
                self?.studentInfoView.setStudentInfo(
                    profileImageUrl: $0.profileImageUrl,
                    gcn: $0.studentGcn,
                    name: $0.studentName,
                    department: $0.department.localizedString()
                )
            }).disposed(by: disposeBag)

        output.writableReviewList.asObservable()
            .filter {
                self.reviewCollectionView.isHidden = $0.isEmpty
                return !$0.isEmpty
            }
            .bind(to: reviewCollectionView.rx.items(
                cellIdentifier: ReviewCollectionViewCell.identifier,
                cellType: ReviewCollectionViewCell.self
            )) { _, element, cell in
                cell.adapt(model: element)
            }
            .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showTabbar()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setLargeTitle(title: "마이페이지")
    }
}
