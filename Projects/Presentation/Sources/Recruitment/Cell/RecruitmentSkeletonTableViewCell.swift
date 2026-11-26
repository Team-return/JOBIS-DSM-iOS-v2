import UIKit
import DesignSystem
import SnapKit
import Then

final class RecruitmentSkeletonTableViewCell: BaseTableViewCell<Any> {
    static let identifier = "RecruitmentSkeletonTableViewCell"

    private static let shimmerAnimationKey = "shimmer"
    private static let shimmerDuration: CFTimeInterval = 1.2

    private let logoView = UIView().then {
        $0.backgroundColor = .GrayScale.gray40
        $0.layer.cornerRadius = 8
    }
    private let titleBarView = UIView().then {
        $0.backgroundColor = .GrayScale.gray40
        $0.layer.cornerRadius = 4
    }
    private let subtitleBarView = UIView().then {
        $0.backgroundColor = .GrayScale.gray40
        $0.layer.cornerRadius = 4
    }
    private let trailingBoxView = UIView().then {
        $0.backgroundColor = .GrayScale.gray40
        $0.layer.cornerRadius = 6
    }
    private let shimmerLayer = CAGradientLayer().then {
        $0.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor
        ]
        $0.locations = [0.35, 0.5, 0.65]
        $0.startPoint = CGPoint(x: 0, y: 0.5)
        $0.endPoint = CGPoint(x: 1, y: 0.5)
    }
    private let shimmerMaskLayer = CAShapeLayer()

    override func configureView() {
        backgroundColor = .GrayScale.gray10
        selectionStyle = .none
        isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startShimmer),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    override func addView() {
        [
            logoView,
            titleBarView,
            subtitleBarView,
            trailingBoxView
        ].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.addSublayer(shimmerLayer)
    }

    override func setLayout() {
        logoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(48)
        }
        titleBarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(logoView.snp.trailing).offset(12)
            $0.width.equalTo(140)
            $0.height.equalTo(18)
        }
        subtitleBarView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalTo(logoView.snp.trailing).offset(12)
            $0.width.equalTo(88)
            $0.height.equalTo(14)
        }
        trailingBoxView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.height.equalTo(24)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()

        shimmerLayer.frame = contentView.bounds
        let path = UIBezierPath()
        [logoView, titleBarView, subtitleBarView, trailingBoxView].forEach {
            path.append(UIBezierPath(roundedRect: $0.frame, cornerRadius: $0.layer.cornerRadius))
        }
        shimmerMaskLayer.path = path.cgPath
        shimmerLayer.mask = shimmerMaskLayer

        if shimmerLayer.animation(forKey: Self.shimmerAnimationKey) == nil {
            startShimmer()
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            startShimmer()
        }
    }

    @objc private func startShimmer() {
        shimmerLayer.removeAnimation(forKey: Self.shimmerAnimationKey)

        let startPoint = CABasicAnimation(keyPath: "startPoint")
        startPoint.fromValue = CGPoint(x: -1, y: 0.5)
        startPoint.toValue = CGPoint(x: 1, y: 0.5)

        let endPoint = CABasicAnimation(keyPath: "endPoint")
        endPoint.fromValue = CGPoint(x: 0, y: 0.5)
        endPoint.toValue = CGPoint(x: 2, y: 0.5)

        let group = CAAnimationGroup()
        group.animations = [startPoint, endPoint]
        group.duration = Self.shimmerDuration
        group.repeatCount = .infinity
        group.timingFunction = CAMediaTimingFunction(name: .linear)

        let now = CACurrentMediaTime()
        let alignedNow = now - now.truncatingRemainder(dividingBy: Self.shimmerDuration)
        group.beginTime = shimmerLayer.convertTime(alignedNow, from: nil)

        shimmerLayer.add(group, forKey: Self.shimmerAnimationKey)
    }
}
