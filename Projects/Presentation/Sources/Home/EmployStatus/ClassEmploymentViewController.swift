import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem
import ReactorKit

public final class ClassEmploymentViewController: BaseReactorViewController<ClassEmploymentReactor> {
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
    private let companyDataRelay = BehaviorRelay<[EmploymentCompany?]>(value: Array(repeating: nil, count: 16))

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
            $0.height.equalTo(UIScreen.main.bounds.width * 1.3)
        }
        totalStatsValueLabel.snp.makeConstraints {
            $0.top.equalTo(companyCollectionView.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(31)
        }
    }

    public override func bindAction() {
        viewDidLoadPublisher.asObservable()
            .map { ClassEmploymentReactor.Action.fetchClassEmployment }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        companyDataRelay
            .asDriver()
            .drive(companyCollectionView.rx.items(
                cellIdentifier: ClassCollectionViewCell.identifier,
                cellType: ClassCollectionViewCell.self
            )) { _, company, cell in
                cell.adapt(model: company)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.classInfo }
            .skip(1)
            .bind(onNext: { [weak self] info in
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
        companyDataRelay.accept(allCompanies)
    }

    public override func configureNavigation() {
        let classNumber = reactor.currentState.classNumber
        let title = ClassCategory(rawValue: classNumber)?.title
        setSmallTitle(title: title ?? "\(classNumber)반")
    }
}
