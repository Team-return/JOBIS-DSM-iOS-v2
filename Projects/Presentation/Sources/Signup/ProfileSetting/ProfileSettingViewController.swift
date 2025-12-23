import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then
import Core
import DesignSystem
import Photos
import Domain
import ReactorKit

public final class ProfileSettingViewController: BaseReactorViewController<ProfileSettingReactor> {
    private let picker = UIImagePickerController()
    private let profileImageView = UIImageView().then {
        $0.image = .jobisIcon(.profile).resize(size: 80)
        $0.contentMode = .scaleAspectFill
    }
    private let editProfileButton = EditProfileButton()
    private let laterButton = LaterButton()
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("완료")
        $0.isEnabled = false
    }

    public override func addView() {
        [
            profileImageView,
            editProfileButton,
            laterButton,
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

        laterButton.snp.makeConstraints {
            $0.centerX.equalTo(nextButton)
            $0.bottom.equalTo(nextButton.snp.top).offset(-10)
        }

        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

    public override func bindAction() {
        laterButton.rx.tap
            .map { ProfileSettingReactor.Action.laterButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .map { ProfileSettingReactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.profileImage }
            .compactMap { $0 }
            .distinctUntilChanged { lhs, rhs in
                lhs.fileName == rhs.fileName
            }
            .bind { [weak self] model in
                self?.profileImageView.image = .init(data: model.file)
                self?.profileImageView.asCircle()
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isNextButtonEnabled }
            .distinctUntilChanged()
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
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
    }

    public override func configureNavigation() {
        setLargeTitle(title: "프로필 사진을 등록해주세요")
    }

    private func selectProfileImage(_ model: UploadFileModel) {
        self.reactor.action.onNext(.selectProfileImage(model))
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
            guard let imageData = image.pngData() else { return }
            self.selectProfileImage(.init(file: imageData, fileName: "profile.png"))
            dismiss(animated: true, completion: nil)
        }
    }
}
