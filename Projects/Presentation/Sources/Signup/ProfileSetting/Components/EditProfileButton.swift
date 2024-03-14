import UIKit
import DesignSystem
import RxSwift
import RxGesture

class EditProfileButton: BaseView {
    private let disposeBag = DisposeBag()
    private let editImageView = UIImageView().then {
        $0.image = .jobisIcon(.edit)
        $0.tintColor = .Primary.blue20
    }
    private let editLabel = UILabel().then {
        $0.setJobisText("이미지 수정하기", font: .subHeadLine, color: .Primary.blue30)
    }

    override func addView() {
        [editImageView, editLabel].forEach(addSubview(_:))
    }

    override func setLayout() {
        editImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview().inset(8)
            $0.width.height.equalTo(24)
        }

        editLabel.snp.makeConstraints {
            $0.leading.equalTo(editImageView.snp.trailing).offset(4)
            $0.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        self.backgroundColor = .Primary.blue10
        self.layer.cornerRadius = 12
        self.clipsToBounds = true

        self.rx.touchDownGesture()
            .when(.began)
            .asObservable()
            .bind { [weak self] _ in
                self?.backgroundColor = .Primary.blue20
            }
            .disposed(by: disposeBag)

        self.rx.touchDownGesture()
            .when(.ended)
            .asObservable()
            .bind { [weak self] _ in
                self?.backgroundColor = .Primary.blue10
            }
            .disposed(by: disposeBag)
    }
}
