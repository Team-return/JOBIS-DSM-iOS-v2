import UIKit
import DesignSystem
import SnapKit
import Then
import Domain
import RxSwift
import RxCocoa

final class AttachmentStackView: BaseView {
    public var removeButtonDidTap = PublishRelay<Int>()
    public var urlWillChanged = PublishRelay<(Int, String)>()
    private let disposeBag = DisposeBag()
    private var list: [AttachmentsRequestQuery] = []
    private var type: AttachedType?
    private let backStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 4, left: 24, bottom: 4, right: 24)
    }
    public let addAttachmentButton = AddAttachmentButton()

    override func addView() {
        self.addSubview(backStackView)
        backStackView.addArrangedSubview(addAttachmentButton)
    }

    override func setLayout() {
        self.backStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configureView(_ type: AttachedType = .docs) {
        super.configureView()
        self.type = type
        self.addAttachmentButton.configureUI(type)
    }

    func updateList(_ list: [AttachmentsRequestQuery]) {
        addAttachmentButton.isHidden = list.count >= 3 ? true : false
        self.backStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            self.backStackView.removeArrangedSubview($0)
        }
        list.enumerated().forEach { index, data in
            let attachmentView = AttachmentView().then {
                $0.configureView(self.type ?? .docs, data: data.url, index: index)
            }
            attachmentView.removeButtonDidTap = {
                self.removeButtonDidTap.accept($0)
            }
            attachmentView.urlWillChanged = {
                self.urlWillChanged.accept($0)
            }
            self.backStackView.addArrangedSubview(attachmentView)
        }
    }
}
