import UIKit
import Domain
import SnapKit
import Then
import RxGesture
import RxSwift
import RxCocoa
import DesignSystem

public class TechCodeStackView: UIStackView {
    private let techCodeView = TechCodeView()
    public var techDidTap: ((CodeEntity) -> Void)?
    private let disposeBag = DisposeBag()
    private var selectedCell: TechCodeStackViewCell?

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

        techList.enumerated().forEach { index, data in
            let techCodeStackViewCell = TechCodeStackViewCell()
            techCodeStackViewCell.adapt(model: data)

            techCodeStackViewCell.techCheckBoxDidTap = { [weak self] code in
                guard let self = self else { return }

                if let selectedCell = self.selectedCell, selectedCell != techCodeStackViewCell {
                    selectedCell.isCheck = false
                }

                self.selectedCell = techCodeStackViewCell
                self.techDidTap?(code ?? CodeEntity(code: 0, keyword: ""))
                self.techCodeView.area.accept(data.keyword)
            }
            self.addArrangedSubview(techCodeStackViewCell)
        }
    }

    func cellAtIndex(_ index: Int) -> TechCodeStackViewCell? {
        guard index >= 0 && index < self.arrangedSubviews.count else {
            return nil
        }
        return self.arrangedSubviews[index] as? TechCodeStackViewCell
    }
}
