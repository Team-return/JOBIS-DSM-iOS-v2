import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

public final class FieldTypeDetailStackView: BaseView {
    private let fieldTypeMenuLabel = JobisMenuLabel(text: "모집분야")
    private let backStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layoutMargins = .init(top: 4, left: 24, bottom: 4, right: 24)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    public override func addView() {
        [
            fieldTypeMenuLabel,
            backStackView
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        fieldTypeMenuLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview()
        }

        backStackView.snp.makeConstraints {
            $0.top.equalTo(fieldTypeMenuLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func setFieldType(_ list: [AreaEntity]) {
        list.forEach { data in
            let attachmentView = FieldTypeDetailView().then {
                $0.configureView(model: data)
            }
            self.backStackView.addArrangedSubview(attachmentView)
        }
    }
}
