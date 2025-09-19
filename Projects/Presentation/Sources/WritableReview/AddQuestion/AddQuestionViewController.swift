import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class AddQuestionViewController: BaseViewController<AddQuestionViewModel> {
    private let questionLabel = UILabel().then {
        $0.setJobisText(
            "받았던 면접 질문을 추가해주세요!",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }
}
