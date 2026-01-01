import UIKit
import SnapKit
import Then

public final class ProgressBarView: UIView {
    private let progressStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.distribution = .fillEqually
        $0.alignment = .center
    }

    private var progressBars: [UIView] = []
    private var currentTotalSteps: Int = 0
    private var currentDisplayStep: Int = 0

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        addSubview(progressStackView)

        progressStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(6)
        }
        progressStackView.backgroundColor = .clear
    }

    public func configure(totalSteps: Int, currentStep: Int) {
        guard totalSteps > 0 else { return }

        let safeCurrentStep = max(1, min(currentStep, totalSteps))

        if currentTotalSteps != totalSteps || currentDisplayStep != safeCurrentStep {
            currentTotalSteps = totalSteps
            currentDisplayStep = safeCurrentStep

            if progressBars.count != totalSteps {
                recreateProgressBars(totalSteps: totalSteps)
            }

            updateProgressColors(currentStep: safeCurrentStep)
        }
    }

    private func recreateProgressBars(totalSteps: Int) {
        progressBars.forEach { bar in
            bar.removeFromSuperview()
        }
        progressBars.removeAll()

        for _ in 0..<totalSteps {
            let bar = createProgressBar()
            progressStackView.addArrangedSubview(bar)
            progressBars.append(bar)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }

    private func createProgressBar() -> UIView {
        let bar = UIView()
        bar.backgroundColor = .systemGray4
        bar.layer.cornerRadius = 3
        bar.clipsToBounds = true

        bar.snp.makeConstraints {
            $0.height.equalTo(6)
        }

        return bar
    }

    private func updateProgressColors(currentStep: Int) {
        for (index, bar) in progressBars.enumerated() {
            let stepNumber = index + 1
            let isCurrent = stepNumber == currentStep

            let targetColor: UIColor = isCurrent ? .systemBlue : .systemGray4

            if bar.backgroundColor != targetColor {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) {
                    bar.backgroundColor = targetColor
                }
            }
        }
    }

    public func getCurrentStep() -> Int {
        return currentDisplayStep
    }

    public func getTotalSteps() -> Int {
        return currentTotalSteps
    }

    deinit {
        progressBars.forEach { $0.removeFromSuperview() }
        progressBars.removeAll()
    }
}
