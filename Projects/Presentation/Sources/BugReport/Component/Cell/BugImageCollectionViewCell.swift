import UIKit
import Domain
import DesignSystem
import SnapKit
import Then
import RxSwift
import RxCocoa

final class BugImageCollectionViewCell: BaseCollectionViewCell<Any> {
    static let identifier = "BugImageCollectionViewCell"

    var bugImageView = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray40.cgColor
    }
    override func addView() {
        [
            bugImageView
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        bugImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
    }
}
