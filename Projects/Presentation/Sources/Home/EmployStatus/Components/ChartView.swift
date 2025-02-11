import UIKit
import Domain
import SnapKit
import Then
import DesignSystem
import RxSwift
import DGCharts

final class ChartView: BaseView {
    private let disposeBag = DisposeBag()

    public override func configureView() {
        super.configureView()
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.GrayScale.gray30.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor(red: 112/255, green: 144/255, blue: 176/255, alpha: 0.12).cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 1
        clipsToBounds = false
    }
}
