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
    private let removeButton = UIButton().then {
        $0.setImage(.jobisIcon(.close).resize(size: 14), for: .normal)
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        $0.layer.cornerRadius = 11
    }
    var removeButtonDidTap: (() -> Void)?

    override func addView() {
        [
            bugImageView,
            removeButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    override func setLayout() {
        bugImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        removeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(4)
            $0.width.height.equalTo(22)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeButtonDidTap = nil
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray30
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }

    @objc private func removeButtonTapped() {
        removeButtonDidTap?()
    }
}
