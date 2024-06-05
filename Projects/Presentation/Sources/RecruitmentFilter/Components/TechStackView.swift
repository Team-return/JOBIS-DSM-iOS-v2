import UIKit
import Domain
import SnapKit
import Then
import RxGesture
import RxSwift
import DesignSystem

class TechStackView: UIStackView {
    public var techDidTap: ((String) -> Void)?
    private let disposeBag = DisposeBag()

    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 0
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTech(techList: [CodeEntity]) {
        self.subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        techList.forEach { data in
            let techStackViewCell = TechStackViewCell()
            techStackViewCell.adapt(model: data)

            techStackViewCell.techCheckBoxDidTap = {
                self.techDidTap?("\($0 ?? 0)")
            }
            self.addArrangedSubview(techStackViewCell)
        }
    }
}
