import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import Kingfisher
import DesignSystem
import Domain

public final class MyPageViewController: BaseViewController<MyPageViewModel> {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let studentInfoView = StudentInfoView()
    private let editButton = UIButton(type: .system).then {
        $0.setJobisText("수정", font: .subHeadLine, color: .Primary.blue20)
    }
    private let reviewNavigateStackView = ReviewNavigateStackView()
    private let notificationSettingSectionView = NotificationSettingSectionView()
    private let accountSectionView = AccountSectionView()
    private let bugSectionView = BugSectionView()
    private let helpSectionView = HelpSectionView()
    private let selectedImage = PublishRelay<UploadFileModel>()
    private let picker = UIImagePickerController()
    private let logoutPublisher = PublishRelay<Void>()
    private let withdrawalPublisher = PublishRelay<Void>()
    private let changedImageURL = PublishRelay<String>()

    public override func addView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        [
            studentInfoView,
            editButton,
            reviewNavigateStackView,
            notificationSettingSectionView,
            helpSectionView,
            accountSectionView,
            bugSectionView
        ].forEach { self.contentView.addSubview($0) }
    }

    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.top.width.equalToSuperview()
            $0.bottom.equalTo(bugSectionView).offset(60)
        }

        studentInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(studentInfoView)
            $0.trailing.equalToSuperview().offset(-28)
        }

        reviewNavigateStackView.snp.updateConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(studentInfoView.snp.bottom)
        }

        notificationSettingSectionView.snp.makeConstraints {
            $0.top.equalTo(reviewNavigateStackView.snp.bottom)
//            $0.top.equalTo(studentInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        helpSectionView.snp.makeConstraints {
            $0.top.equalTo(notificationSettingSectionView.snp.bottom)
//            $0.top.equalTo(studentInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        accountSectionView.snp.makeConstraints {
            $0.top.equalTo(helpSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        bugSectionView.snp.makeConstraints {
            $0.top.equalTo(accountSectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }

    public override func bind() {
        let input = MyPageViewModel.Input(
            viewAppear: viewWillAppearPublisher,
            reviewNavigate: reviewNavigateStackView.reviewNavigateButtonDidTap,
            selectedImage: selectedImage,
            notificationSettingSectionDidTap: notificationSettingSectionView.getSelectedItem(type:
                    .notificationSetting),
            helpSectionDidTap: helpSectionView.getSelectedItem(type: .announcement),
            bugReportSectionDidTap: bugSectionView.getSelectedItem(type: .reportBug),
//            bugReportListSectionDidTap: bugSectionView.getSelectedItem(type: .bugList),
            changePasswordSectionDidTap: accountSectionView.getSelectedItem(type: .changePassword),
            logoutPublisher: logoutPublisher,
            withdrawalPublisher: withdrawalPublisher,
            changedImageURL: changedImageURL
        )

        input.changePasswordSectionDidTap.asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.hideTabbar()
            })
            .disposed(by: disposeBag)

        let output = viewModel.transform(input)

        output.studentInfo.asObservable()
            .bind(onNext: { [weak self] in
                self?.studentInfoView.setStudentInfo(
                    profileImageUrl: $0.profileImageUrl,
                    gcn: $0.studentGcn,
                    name: $0.studentName,
                    department: $0.department.localizedString()
                )
            }).disposed(by: disposeBag)

        output.writableReviewList
            .bind(onNext: { [weak self] in
                self?.reviewNavigateStackView.setList(writableReviewCompanylist: $0)
            }).disposed(by: disposeBag)
    }

    public override func configureViewController() {
        self.picker.delegate = self
        self.viewWillAppearPublisher.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.showTabbar()
            })
            .disposed(by: disposeBag)

        self.accountSectionView.getSelectedItem(type: .logout)
            .asObservable()
            .subscribe(onNext: {_ in
                AlertBuilder(viewController: self)
                    .setTitle("JOBIS에서 로그아웃 하시겠어요?")
                    .setMessage("JOBIS에서 로그아웃 하면,\n로그인 할 때 까지 사용하지 못해요")
                    .addActionConfirm("로그아웃") {
                        self.withdrawalPublisher.accept(())
                    }
                    .show()
            })
            .disposed(by: disposeBag)

        self.accountSectionView.getSelectedItem(type: .withDraw)
            .asObservable()
            .subscribe(onNext: {_ in
                AlertBuilder(viewController: self)
                    .setTitle("JOBIS에서 탈퇴하시겠어요?")
                    .setMessage("JOBIS에서 탈퇴하면,\n다시 가입 할 때 까지 사용하지 못해요")
                    .addActionConfirm("회원탈퇴") {
                        self.logoutPublisher.accept(())
                    }
                    .show()
            })
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        self.setLargeTitle(title: "마이페이지")
    }
}

extension MyPageViewController: UIImagePickerControllerDelegate {
     func openLibrary() {
         picker.sourceType = .photoLibrary
         present(picker, animated: true, completion: nil)
     }
 }

 extension MyPageViewController: UINavigationControllerDelegate {
     public func imagePickerController(
         _ picker: UIImagePickerController,
         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
     ) {
         if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             guard let imageData = image.pngData() else { return }
             self.selectedImage.accept(.init(file: imageData, fileName: "profile.png"))
             dismiss(animated: true, completion: nil)
         }
     }
 }
