import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Core
import DesignSystem

public final class ProfileSettingViewController: BaseViewController<ProfileSettingViewModel> {
    public var name: String = ""
    public var gcn: Int = 0
    public var email: String = ""
    public var password: String = ""
    public var isMan: Bool = false
    private let picker = UIImagePickerController()
    private let profileImageView = UIImageView().then {
        $0.image = .jobisIcon(.profile).resize(size: 80)
    }
    private let editProfileButton = EditProfileButton()
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("완료")
    }
    private let selectedImage = PublishRelay<UIImage>()

    public override func addView() {
        [
            profileImageView,
            editProfileButton,
            nextButton
        ].forEach { self.view.addSubview($0) }
    }

    public override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(80)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        editProfileButton.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView)
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bind() {
        let input = ProfileSettingViewModel.Input(
            name: name,
            gcn: gcn,
            email: email,
            password: password,
            isMan: isMan,
            profileImage: .init(), // TODO: profile
            nextButtonDidTap: nextButton.rx.tap.asSignal()
        )
        _ = viewModel.transform(input)
    }

    public override func configureViewController() {
        self.picker.delegate = self
        editProfileButton.rx.tapGesture()
            .when(.recognized)
            .asObservable()
            .bind { [weak self] _ in
                self?.openLibrary()
            }
            .disposed(by: disposeBag)

        selectedImage.asObservable()
            .bind { [weak self] image in
                self?.profileImageView.image = image
                self?.profileImageView.asCircle()
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() {
        setLargeTitle(title: "프로필 사진을 등록해주세요")
    }
}

extension ProfileSettingViewController: UIImagePickerControllerDelegate {
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
}

extension ProfileSettingViewController: UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage.accept(image)
            dismiss(animated: true, completion: nil)
        }
    }
}
