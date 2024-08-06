import UIKit
import Domain
import SnapKit
import Then
import RxGesture
import RxSwift
import DesignSystem

class MajorTypeStackView: UIStackView {
    public var techDidTap: ((String) -> Void)?
    private let disposeBag = DisposeBag()
//    public lazy var majorTypeStackViewCell = MajorTypeStackViewCell()

    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 0
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTech(majorList: [String]) {
        self.subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        majorList.forEach { data in
            let majorTypeStackViewCell = MajorTypeStackViewCell()

            majorTypeStackViewCell.snp.makeConstraints {
                $0.height.equalTo(48)
            }

            majorTypeStackViewCell.adapt(majorType: data)
//            self.techDidTap?(data)
//            techStackViewCell.techCheckBoxDidTap = {
//                self.techDidTap?("\($0 ?? 0)")
//            }
            self.addArrangedSubview(majorTypeStackViewCell)
        }
    }
}
