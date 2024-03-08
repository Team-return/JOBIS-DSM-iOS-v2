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
        $0.setJobisText("[중요] 신입생 오리엔테이션 안내", font: .headLine, color: .GrayScale.gray80)
    }
    private let noticeDateLabel = JobisMenuLabel(text: "2023-12-05")
    private let noticeContentLabel = UILabel().then {
        $0.setJobisText(
            "신입생 오리엔테이션 책자에 있는 입학전 과제의 양식입니다. 첨부파일을 다운받아 사용하시고, 영어와 전공은 특별한 양식이 없으니 내용에 맞게 작성하여 학교 홈페이지에 제출하시기 바랍니다.\n\n■ 과제 제출 마감: 2024년 2월 20일 화요일\n■ 학교 홈페이지 학생 회원가입 -> 학교 담당자가 승인",
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
            $0.left.equalToSuperview()
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

    public override func bind() { }

    public override func configureViewController() {
        attachedFileTableView.dataSource = self
        attachedFileTableView.delegate = self
    }

    public override func configureNavigation() {
        self.setSmallTitle(title: "공지사항")
        self.navigationItem.largeTitleDisplayMode = .never
    }
}

extension NoticeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = attachedFileTableView.dequeueReusableCell(withIdentifier: AttachedFileTableViewCell.identifier, for: indexPath)
        return cell
    }
}
