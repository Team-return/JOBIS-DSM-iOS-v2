import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem

public final class ClassEmploymentViewController: BaseViewController<ClassEmploymentViewModel> {
    private let classNumber: Int
    private let companyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ClassEmploymentCollectionViewLayout()
    ).then {
        $0.register(
            ClassCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassCollectionViewCell.identifier
        )
    }
    private let totalStatsValueLabel = UILabel().then {
        $0.setJobisText("0/0", font: .body, color: .Primary.blue20)
        $0.textAlignment = .center
    }

    public init(viewModel: ClassEmploymentViewModel, classNumber: Int) {
        self.classNumber = classNumber
        super.init(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func addView() {
        [
            companyCollectionView,
            totalStatsValueLabel
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        companyCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 1.2)
        }
        totalStatsValueLabel.snp.makeConstraints {
            $0.top.equalTo(companyCollectionView.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(31)
        }
    }

    public override func bind() {
        let input = ClassEmploymentViewModel.Input(
            viewAppear: viewWillAppearPublisher
        )

        let output = viewModel.transform(input)

        output.classInfo
            .drive(onNext: { [weak self] info in
                self?.updateUI(with: info)
            })
            .disposed(by: disposeBag)
    }

    private func updateUI(with info: EmploymentEntity) {
        updateTotalStats(info)
        updateCompanyList(info)
    }

    private func updateTotalStats(_ info: EmploymentEntity) {
        totalStatsValueLabel.setJobisText(
            "\(info.passedStudents)/\(info.totalStudents)",
            font: .body,
            color: .Primary.blue20
        )
    }

    private func updateCompanyList(_ info: EmploymentEntity) {
        let companies = info.employmentRateResponseList
        let allCompanies: [EmploymentCompany?] = companies + Array(
            repeating: nil,
            count: max(0, 16 - companies.count)
        )

        Observable.just(allCompanies)
            .asDriver(onErrorJustReturn: [])
            .drive(companyCollectionView.rx.items(
                cellIdentifier: ClassCollectionViewCell.identifier,
                cellType: ClassCollectionViewCell.self
            )) { _, company, cell in
                cell.adapt(model: company)
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        let title = ClassCategory(rawValue: classNumber)?.title
        setSmallTitle(title: title ?? "\(classNumber)반")
    }
}
