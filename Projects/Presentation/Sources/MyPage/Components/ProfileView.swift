import UIKit
import DesignSystem

class ProfileView: UIView {
    let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }
    let userInfoLabel = UILabel().then {
        $0.setJobisText("4210 홍길동", font: .subHeadLine, color: .GrayScale.gray90)
    }
    let departmentLabel = UILabel().then {
        $0.setJobisText("소프트웨어 개발과", font: .description, color: .GrayScale.gray70)
    }
    let editButton = UIButton(type: .system).then {
        $0.setJobisText("수정", font: .subHeadLine, color: .Main.blue1)
    }
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        [
            profileImageView,
            userInfoLabel,
            departmentLabel,
            editButton
        ].forEach { self.addSubview($0) }

        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.height.width.equalTo(48)
            $0.leading.equalToSuperview().inset(24)
        }
        userInfoLabel.snp.makeConstraints {
            $0.bottom.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        departmentLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(4)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(24)
            $0.width.equalTo(28)
            $0.trailing.equalToSuperview().inset(28)
        }
    }
}
