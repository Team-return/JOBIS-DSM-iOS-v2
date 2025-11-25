import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NoticeDetailViewController: BaseReactorViewController<NoticeDetailReactor> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let noticeTitleLabel = UILabel().then {
        $0.setJobisText("공지사항 불러오는 중.....", font: .headLine, color: .GrayScale.gray80)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let noticeDateLabel = UILabel()
    private let noticeContentLabel = UILabel().then {
        $0.setJobisText("-", font: .body, color: .GrayScale.gray80)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    public override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            noticeTitleLabel,
            noticeDateLabel,
            noticeContentLabel
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(noticeContentLabel.snp.bottom).offset(20)
        }

        noticeTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(24)
        }

        noticeDateLabel.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom)
            $0.left.equalToSuperview().inset(24)
        }

        noticeContentLabel.snp.makeConstraints {
            $0.top.equalTo(noticeDateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        viewWillAppearPublisher
            .map { NoticeDetailReactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.compactMap { $0.noticeDetail }
            .subscribe(onNext: { [weak self] detail in
                self?.noticeTitleLabel.text = detail.title
                self?.noticeDateLabel.setJobisText(
                    detail.createdAt,
                    font: .description,
                    color: .GrayScale.gray60
                )
                self?.noticeContentLabel.text = detail.content
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() { }

    public override func configureNavigation() {
        setSmallTitle(title: "공지사항")
        navigationItem.largeTitleDisplayMode = .never
    }
}
