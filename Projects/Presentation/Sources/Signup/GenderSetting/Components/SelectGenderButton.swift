import UIKit
import Domain
import DesignSystem
import RxSwift
import RxCocoa

class SelectGenderButton: UIButton {
    private let disposeBag = DisposeBag()
    private var genderIconView = UIImageView()
    private var genderLabel = UILabel()

    var isSelectedGender: Bool = false {
        didSet { self.configureUI() }
    }

    override var isHighlighted: Bool {
        didSet { self.configureUI() }
    }

    init(_ type: GenderType) {
        super.init(frame: .zero)

        self.configureUI()
        self.layer.cornerRadius = 12
        self.clipsToBounds = true

        genderIconView.image = type.image
        genderLabel.setJobisText(type.text, font: .headLine, color: .GrayScale.gray90)

        self.rx.tap.asObservable()
            .bind {
                self.isSelectedGender.toggle()
            }
            .disposed(by: disposeBag)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        [
            genderIconView,
            genderLabel
        ].forEach(self.addSubview(_:))

        genderIconView.snp.makeConstraints {
            $0.width.height.equalTo(48)
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }

        genderLabel.snp.makeConstraints {
            $0.centerX.equalTo(genderIconView)
            $0.top.equalTo(genderIconView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    private func configureUI() {
        self.backgroundColor = isHighlighted ?
            .Primary.blue20: isSelectedGender ?
            .Primary.blue30: .GrayScale.gray30

        self.genderLabel.textColor = isSelectedGender || isHighlighted ?
            .white:
            .GrayScale.gray90
        self.genderIconView.tintColor = isSelectedGender || isHighlighted ?
            .white:
            .GrayScale.gray60
    }
}

private extension GenderType {
    var image: UIImage {
        switch self {
        case .man:
            UIImage.jobisIcon(.male)

        case .woman:
            UIImage.jobisIcon(.female)
        }
    }

    var text: String {
        switch self {
        case .man:
            "남"

        case .woman:
            "여"
        }
    }
}
