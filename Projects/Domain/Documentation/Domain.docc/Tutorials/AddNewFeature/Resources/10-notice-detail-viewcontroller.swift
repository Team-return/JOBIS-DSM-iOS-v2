import UIKit
import RxSwift
import SnapKit
import Then
import Core

// BaseReactorViewController를 상속하면 reactor, disposeBag, viewDidLoadPublisher가 자동 제공됩니다.
public final class NoticeDetailViewController: BaseReactorViewController<NoticeDetailReactor> {
    private let titleLabel = UILabel()
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    // MARK: - Layout
    public override func addView() {
        [titleLabel, contentLabel].forEach(view.addSubview(_:))
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }

    // MARK: - Bind Action: ViewController → Reactor
    public override func bindAction() {
        viewDidLoadPublisher
            .map { NoticeDetailReactor.Action.fetchNoticeDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    // MARK: - Bind State: Reactor → ViewController
    public override func bindState() {
        reactor.state.compactMap { $0.noticeDetail }
            .subscribe(onNext: { [weak self] detail in
                self?.titleLabel.text = detail.title
                self?.contentLabel.text = detail.content
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setSmallTitle(title: "공지사항")
    }
}
