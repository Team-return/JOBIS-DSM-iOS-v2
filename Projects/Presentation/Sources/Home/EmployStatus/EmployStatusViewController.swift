import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Domain
import DesignSystem
import Charts

public final class EmployStatusViewController: BaseViewController<EmployStatusViewModel> {
    private let chartView = ChartView()

    public override func addView() {
        [
            chartView
        ].forEach { self.view.addSubview($0) }
    }
    public override func setLayout() {
        chartView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(100)
        }
    }
    public override func configureNavigation() {
        setSmallTitle(title: "취업 현황")
    }
    public override func configureViewController() {
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: {
                self.hideTabbar()
            })
            .disposed(by: disposeBag)
    }
}
