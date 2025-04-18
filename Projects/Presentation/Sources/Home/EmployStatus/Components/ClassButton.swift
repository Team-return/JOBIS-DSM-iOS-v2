import UIKit
import Domain
import SnapKit
import Then
import DesignSystem

final class ClassButton: UIButton {
    private let circleView = UIView().then {
        $0.layer.cornerRadius = 40
        $0.backgroundColor = .GrayScale.gray10
    }
    private let iconLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 40, weight: UIFont.Weight.bold)
    }
    private let classLabel = UILabel().then {
        $0.setJobisText("", font: .boldcaption, color: .GrayScale.gray10)
        $0.textAlignment = .center
        $0.backgroundColor = .GrayScale.gray90
        $0.alpha = 0.3
        $0.textColor = .GrayScale.gray10
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    init(icon: String, classNumber: Int) {
        super.init(frame: .zero)
        iconLabel.text = icon
        classLabel.text = "\(classNumber)반"
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews()
        setLayout()
        configureView()
    }

    private func addSubviews() {
        [
            circleView,
            classLabel
        ].forEach { self.addSubview($0) }
        circleView.addSubview(iconLabel)
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(180)
        }

        circleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(30)
            $0.height.width.equalTo(80)
        }

        iconLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        classLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(34)
            $0.width.equalTo(48)
        }
    }

    private func configureView() {
        self.backgroundColor = .GrayScale.gray30
        self.layer.cornerRadius = 8

        circleView.isUserInteractionEnabled = false
        iconLabel.isUserInteractionEnabled = false
    }
}
