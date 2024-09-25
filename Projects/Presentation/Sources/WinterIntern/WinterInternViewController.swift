import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class WinterInternViewController: BaseViewController<WinterInternVieModel> {
    public var viewWillappearWithTap: (() -> Void)?
    public var isTabNavigation: Bool = true
    private let bookmarkButtonDidClicked = PublishRelay<Int>()
    private let pageCount = PublishRelay<Int>()
    private let listEmptyView = ListEmptyView().then {
        $0.setEmptyView(title: "아직 등록된 모집의뢰서가 없어요")
        $0.isHidden = true
    }
    private let recruitmentTableView = UITableView().then {
        $0.register(
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 72
        $0.showsVerticalScrollIndicator = false
    }
    private let filterButton = UIButton().then {
        $0.setImage(.jobisIcon(.filterIcon), for: .normal)
    }
    private let searchButton = UIButton().then {
        $0.setImage(.jobisIcon(.searchIcon), for: .normal)
    }

    public override func addView() {
        self.view.addSubview(recruitmentTableView)
        recruitmentTableView.addSubview(listEmptyView)
    }

    public override func setLayout() {
        recruitmentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        listEmptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(80)
        }
    }

    public override func bind() {
        let input = WinterInternVieModel.Input(
            viewAppear: self.viewDidLoadPublisher,
            bookMarkButtonDidTap: bookmarkButtonDidClicked,
            pageChange: recruitmentTableView.rx.willDisplayCell
                .filter {
                    $0.indexPath.row == self.recruitmentTableView.numberOfRows(
                        inSection: $0.indexPath.section
                    ) - 1
                },
            recruitmentTableViewDidTap: recruitmentTableView.rx
                .modelSelected(RecruitmentEntity.self)
                .asObservable()
                .map { $0.recruitID }
                .do(onNext: { _ in
                    self.isTabNavigation = false
                }),
            searchButtonDidTap: searchButton.rx.tap.asSignal(),
            filterButtonDidTap: filterButton.rx.tap.asSignal()
        )

        let output = viewModel.transform(input)

        output.recruitmentData
            .skip(1)
            .do(onNext: {
                self.listEmptyView.isHidden = !$0.isEmpty
            })
            .bind(
                to: recruitmentTableView.rx.items(
                    cellIdentifier: RecruitmentTableViewCell.identifier,
                    cellType: RecruitmentTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                    cell.bookmarkButtonDidTap = {
                        self.bookmarkButtonDidClicked.accept(cell.model!.recruitID)
                    }
                }
                .disposed(by: disposeBag)
    }

    public override func configureViewController() {
        viewWillAppearPublisher.asObservable()
            .bind {
                self.hideTabbar()
                if self.isTabNavigation {
                    self.viewWillappearWithTap?()
                }
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "체험형 현장실습")
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: searchButton),
            UIBarButtonItem(customView: filterButton)
        ]
    }
}
