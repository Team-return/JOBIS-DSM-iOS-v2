import UIKit
import Domain
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class NoticeDetailViewController: BaseViewController<NoticeDetailViewModel> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let noticeTitleLabel = UILabel().then {
        $0.setJobisText("공지사항 불러오는 중.....", font: .headLine, color: .GrayScale.gray80)
    }
    private var noticeDateLabel = UILabel()
    private let noticeContentLabel = UILabel().then {
        $0.setJobisText(
            "-",
            font: .body,
            color: .GrayScale.gray80
        )
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    private let attachedFileMenuLabel = JobisMenuLabel(text: "첨부파일")
    private let attachedFileTableView = UITableView().then {
        $0.register(
            AttachedFileTableViewCell.self,
            forCellReuseIdentifier: AttachedFileTableViewCell.identifier
        )
        $0.separatorStyle = .none
        $0.rowHeight = 68
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    public override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            noticeTitleLabel,
            noticeDateLabel,
            noticeContentLabel,
            attachedFileMenuLabel,
            attachedFileTableView
        ].forEach(contentView.addSubview(_:))
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaInsets)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(attachedFileTableView.snp.bottom).offset(20)
        }

        noticeTitleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(24)
        }

        noticeDateLabel.snp.makeConstraints {
            $0.top.equalTo(noticeTitleLabel.snp.bottom)
            $0.left.equalToSuperview().inset(24)
        }

        noticeContentLabel.snp.makeConstraints {
            $0.top.equalTo(noticeDateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        attachedFileMenuLabel.snp.makeConstraints {
            $0.top.equalTo(noticeContentLabel.snp.bottom).offset(24)
        }

        attachedFileTableView.snp.makeConstraints {
            $0.top.equalTo(attachedFileMenuLabel.snp.bottom)
            $0.left.right.equalTo(view.safeAreaInsets)
            $0.height.greaterThanOrEqualTo(attachedFileTableView.contentSize.height + 4)
        }
    }

    public override func bind() {
        let input = NoticeDetailViewModel.Input(
            viewAppear: self.viewWillAppearPublisher
        )

        let output = viewModel.transform(input)

        output.noticeDetailInfo.asObservable()
            .bind(onNext: { noticeDetailInfo in
                self.noticeTitleLabel.text = noticeDetailInfo.title
                self.noticeDateLabel.setJobisText(
                    noticeDetailInfo.createdAt,
                    font: .description,
                    color: .GrayScale.gray60
                )
                self.noticeContentLabel.text = noticeDetailInfo.content
            })
            .disposed(by: disposeBag)
    }

    public override func configureViewController() { }

    public override func configureNavigation() {
        self.setSmallTitle(title: "공지사항")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}
