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

    public init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(progressStackView)

        progressStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(6)
        }
    }

    public func configure(totalSteps: Int, currentStep: Int) {
        progressBars.forEach { $0.removeFromSuperview() }
        progressBars.removeAll()

        let displayStep = max(1, currentStep)

        for index in 1...totalSteps {
            let bar = UIView()
            let isCurrent = index == displayStep

            if isCurrent {
                bar.backgroundColor = .systemBlue
            } else {
                bar.backgroundColor = .systemGray4
            }

            bar.layer.cornerRadius = 3
            bar.clipsToBounds = true

            progressStackView.addArrangedSubview(bar)
            progressBars.append(bar)

            bar.snp.makeConstraints {
                $0.height.equalTo(6)
            }
        }

        self.backgroundColor = .clear
        progressStackView.backgroundColor = .clear
    }
}
