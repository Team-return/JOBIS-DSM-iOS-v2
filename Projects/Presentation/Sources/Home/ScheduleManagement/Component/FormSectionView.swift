import UIKit
import Then
import DesignSystem

final class FormSectionView: UIStackView {

    init(title: String, content: UIView) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 8
        let label = UILabel().then {
            $0.setJobisText(title, font: .description, color: .GrayScale.gray80)
        }
        addArrangedSubview(label)
        addArrangedSubview(content)
    }

    required init(coder: NSCoder) { fatalError() }
}
