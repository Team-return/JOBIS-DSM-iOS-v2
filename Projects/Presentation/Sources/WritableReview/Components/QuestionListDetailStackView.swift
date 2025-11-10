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

    private var emptyView: ListEmptyView?

    public override func addView() {
        self.addSubview(backStackView)
    }

    public override func setLayout() {
        backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setFieldType(_ list: [QnAEntity]) {
        backStackView.arrangedSubviews.forEach { view in
            backStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        emptyView?.removeFromSuperview()
        emptyView = nil

        let validList = list.filter { !$0.question.isEmpty && !$0.answer.isEmpty }

        if validList.isEmpty {
            let empty = ListEmptyView().then {
                $0.setEmptyView(
                    title: "받은 질문을 작성하지 않았어요!",
                    subTitle: "다른 학생의 전공 후기를 봐주세요!"
                )
            }
            self.addSubview(empty)
            empty.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            self.emptyView = empty
            backStackView.isHidden = true
        } else {
            backStackView.isHidden = false

            validList.forEach { data in
                let attachmentView = QuestionListDetailView().then {
                    $0.configureView(model: data)
                }
                backStackView.addArrangedSubview(attachmentView)
            }
        }
    }
}
