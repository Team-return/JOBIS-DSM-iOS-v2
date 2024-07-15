import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class MajorBottomSheetViewController: BaseBottomSheetViewController<MajorBottomSheetViewModel> {
    private let list: [String] = ["iOS", "Android", "Server", "Web", "전체"]
    private var majorType: String = ""
    private let majorSelectMenuLabel = JobisMenuLabel(text: "분야 선택")
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    private lazy var majorTypeStackView = MajorTypeStackView()
//    private let majorTableView = UITableView().then {
//        $0.register(
//            MajorTableViewCell.self,
//            forCellReuseIdentifier: MajorTableViewCell.identifier
//        )
//        $0.separatorStyle = .none
//        $0.rowHeight = 48
//        $0.showsVerticalScrollIndicator = false
//        $0.isScrollEnabled = false
//    }

    public override func addView() {
        [
            majorSelectMenuLabel,
            scrollView
//            majorTableView
        ].forEach(self.contentView.addSubview(_:))
        scrollView.addSubview(contentStackView)
        [
            majorTypeStackView
        ].forEach(self.contentStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        majorSelectMenuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
//            $0.bottom.equalTo(majorTableView.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

//        majorTableView.snp.makeConstraints {
//            $0.top.equalTo(majorSelectMenuLabel.snp.bottom)
//            $0.leading.trailing.bottom.equalToSuperview()// inset
//        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(majorSelectMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }

    public override func bind() {
        let input = MajorBottomSheetViewModel.Input(

        )
        let output = viewModel.transform(input)
//        self.majorTypeStackView.setTech(majorList: output.list)
    }

    public override func configureViewController() {
//        majorTableView.dataSource = self
//        majorTableView.delegate = self

        viewDidLoadPublisher.asObservable()
            .bind {
                self.hideTabbar()
            }
            .disposed(by: disposeBag)

        self.majorTypeStackView.setTech(majorList: list)
    }
}

//extension MajorBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: MajorTableViewCell.identifier,
//            for: indexPath
//        ) as? MajorTableViewCell else { return UITableViewCell() }
//        cell.selectionStyle = .none
//
//        cell.majorButton.setTitle(self.list[indexPath.row], for: .normal)
////        cell.majorLabel.text = self.list[indexPath.row]
//        cell.majorListDidTap.accept(self.list[indexPath.row])
////        print("cell.majorListDidTap.value: ", cell.majorListDidTap.value)
//        return cell
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: MajorTableViewCell.identifier,
//            for: indexPath
//        ) as? MajorTableViewCell else { return }
//
////        cell.majorListDidTap.asObservable()
////            .bind(onNext: {
////                self.majorType = $0
////                print($0)
////            })
////            .disposed(by: disposeBag)
//
////        self.majorType = cell.majorListDidTap.value
////        print("majorType: ", self.majorType)
////        print("cell.majorListDidTap.value: ", cell.majorListDidTap.value)
////        print("index: ", indexPath.row)
//    }
//}
