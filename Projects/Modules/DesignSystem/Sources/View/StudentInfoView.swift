import UIKit
import SnapKit
import Then
import Kingfisher

public final class StudentInfoView: UIView {
    private let profileImageView = UIImageView().then {
        $0.image = .jobisIcon(.profile)
        $0.asCircle()
    }
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    private let userInfoLabel = UILabel().then {
        $0.setJobisText("0000 가가가", font: .subHeadLine, color: .GrayScale.gray90)
    }
    private let departmentLabel = UILabel().then {
        $0.setJobisText("가가가가가가가가", font: .description, color: .GrayScale.gray70)
    }
    private let editButton = UIButton(type: .system).then {
        $0.setJobisText("수정", font: .subHeadLine, color: .Primary.blue20)
    }

    public init() {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStudentInfo(
        profileImageUrl: String,
        gcn: String,
        name: String,
        department: String
    ) {
        profileImageView.setJobisImage(
            urlString: profileImageUrl,
            placeholder: UIImage.jobisIcon(.profile)
        )
        profileImageView.asCircle()
        userInfoLabel.setJobisText("\(gcn) \(name)", font: .subHeadLine, color: .GrayScale.gray90)
        departmentLabel.setJobisText(department, font: .description, color: .GrayScale.gray70)
    }

    private func configureView() {
        [
            profileImageView,
            labelStackView,
            editButton
        ].forEach(addSubview(_:))

        [
            userInfoLabel,
            departmentLabel
        ].forEach(labelStackView.addArrangedSubview(_:))

        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.height.width.equalTo(48)
            $0.leading.equalToSuperview().inset(24)
        }
        labelStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
        }
    }
}
