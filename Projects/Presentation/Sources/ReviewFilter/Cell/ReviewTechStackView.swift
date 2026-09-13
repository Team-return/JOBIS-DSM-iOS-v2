import UIKit
import RxSwift
import RxCocoa
import Domain

final class ReviewTechStackView: UIStackView {
    private let disposeBag = DisposeBag()
    private var selectedCell: ReviewTechStackViewCell?
    private let selectedTechRelay = PublishRelay<CodeEntity>()

    var selectedTechObservable: Observable<CodeEntity> {
        return selectedTechRelay.asObservable()
    }

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
        selectedCell = nil
        techList.forEach { data in
            let techStackViewCell = ReviewTechStackViewCell()
            techStackViewCell.adapt(model: data)

            techStackViewCell.techCheckBoxDidTap = { [weak self] code in
                guard let self = self else { return }
                self.handleSelection(of: techStackViewCell, with: code)
            }
            self.addArrangedSubview(techStackViewCell)
        }
    }

    private func handleSelection(of tappedCell: ReviewTechStackViewCell, with code: CodeEntity?) {
        if self.selectedCell != tappedCell {
            self.selectedCell?.isCheck = false
            tappedCell.isCheck = true
            self.selectedCell = tappedCell

            if let code = code {
                self.selectedTechRelay.accept(code)
            }
        } else {
            tappedCell.isCheck = false
            self.selectedCell = nil
        }
    }
}
