import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ReviewMajorCollectionViewCell: BaseCollectionViewCell<CodeEntity> {
    static let identifier = "ReviewMajorCollectionViewCell"
    public var isCheck: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    private var disposeBag = DisposeBag()
    private let jobLabel = UILabel()

    override var model: CodeEntity? {
        didSet {
            if let model = model {
                displayedText = model.keyword
                updateAppearance()
            }
        }
    }
    private var displayedText: String?

    override func addView() {
        self.contentView.addSubview(jobLabel)
    }

    override func setLayout() {
        jobLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        self.layer.cornerRadius = 16
        updateAppearance()
    }

    private func updateAppearance() {
        self.backgroundColor = isCheck ? .Primary.blue20 : .GrayScale.gray30
        let textColor: UIColor = isCheck ? .GrayScale.gray10 : .Primary.blue40

        if let text = displayedText {
            jobLabel.setJobisText(text, font: .body, color: textColor)
        } else if let model = model {
            jobLabel.setJobisText(model.keyword, font: .body, color: textColor)
        }
    }

    override func adapt(model: CodeEntity) {
        super.adapt(model: model)
        displayedText = model.keyword
        updateAppearance()
    }

    func adapt(value: String) {
        displayedText = value
        updateAppearance()
    }

    func resetSelection() {
        isCheck = false
    }
}
