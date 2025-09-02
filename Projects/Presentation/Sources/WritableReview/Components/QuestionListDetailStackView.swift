import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

public final class QuestionListDetailStackView: BaseView {
    private let backStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.layoutMargins = .init(top: 4, left: 0, bottom: 4, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    public override func addView() {
        [
            backStackView
        ].forEach(self.addSubview(_:))
    }

    public override func setLayout() {
        backStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func setFieldType(_ list: [QnAEntity]) {
        backStackView.arrangedSubviews.forEach { view in
            backStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        list.forEach { data in
            let attachmentView = QuestionListDetailView().then {
                $0.configureView(model: data)
            }
            backStackView.addArrangedSubview(attachmentView)
        }
    }
}
