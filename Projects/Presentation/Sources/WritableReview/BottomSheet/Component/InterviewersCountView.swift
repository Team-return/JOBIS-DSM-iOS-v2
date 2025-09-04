import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem
import Domain

public final class InterviewersCountView: BaseView {
    private let disposeBag = DisposeBag()
    private let addReviewTitleLabel = UILabel().then {
        $0.setJobisText(
            "면접관 수",
            font: .headLine,
            color: .GrayScale.gray60
        )
    }
    private let countTextField = JobisTextField().then {
        $0.setTextField(
            title: "답변",
            placeholder: "면접관수를 작성해주세요.",
            textFieldType: .none
        )
    }

}
