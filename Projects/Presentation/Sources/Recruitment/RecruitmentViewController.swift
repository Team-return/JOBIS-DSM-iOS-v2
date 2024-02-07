import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class RecruitmentViewController: BaseViewController<RecruitmentViewModel> {
    private let bookmarkButtonDidClicked = PublishRelay<Int>()
    private let cellClick = PublishRelay<Int>()
    private let pageCount = PublishRelay<Int>()
    var page: Int = 1
    var isFetching: Bool = false
    private let recruitmentTableView = UITableView().then {
        $0.register(
            RecruitmentTableViewCell.self,
            forCellReuseIdentifier: RecruitmentTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 96
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
    }

    public override func setLayout() {
        recruitmentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func bind() {
        let input = RecruitmentViewModel.Input(
            viewAppear: self.viewWillAppearPublisher,
            bookMarkButtonDidTap: bookmarkButtonDidClicked,
            pageChange: pageCount
        )

        let output = viewModel.transform(input)

        output.recruitmentList
            .subscribe(onNext: { [weak self] elements in
                if elements.isEmpty {
                    self?.isFetching = true
                } else {
                    var currentElements = self?.recruitmentData.value ?? []
                    currentElements.append(contentsOf: elements)
                    self?.recruitmentData.accept(currentElements)
                }
            })
            .disposed(by: disposeBag)

        recruitmentData
            .bind(
                to: recruitmentTableView.rx.items(
                    cellIdentifier: RecruitmentTableViewCell.identifier,
                    cellType: RecruitmentTableViewCell.self
                )) { _, element, cell in
                    cell.adapt(model: element)
                    cell.bookmarkButtonDidTap = {
                        self.bookmarkButtonDidClicked.accept(cell.recruitmentID)
                    }
                }
                .disposed(by: disposeBag)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page = 2
        isFetching = false
        recruitmentData.accept([])
    }

    public override func configureViewController() {
        recruitmentTableView.delegate = self
        searchButton.rx.tap
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: filterButton),
            UIBarButtonItem(customView: searchButton)
        ]
        setLargeTitle(title: "모집의뢰서")
    }
}

extension RecruitmentViewController: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = recruitmentTableView.contentOffset.y
        let contentHeight = recruitmentTableView.contentSize.height

        if offsetY > (contentHeight - recruitmentTableView.frame.height) {
            Task {
                if !isFetching {
                    isFetching = true
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    pageCount.accept(page)
                    page += 1
                    isFetching = false
                }
            }
        }
    }
}
