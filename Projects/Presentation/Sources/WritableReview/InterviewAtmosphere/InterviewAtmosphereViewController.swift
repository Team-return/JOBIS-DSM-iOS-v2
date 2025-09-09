import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class InterviewAtmosphereViewController: BaseViewController<InterviewAtmosphereViewModel> {
    private let nextButtonDidTap = PublishRelay<Void>()
    private let atmosphereTextView = UITextView().then {
        $0.font = UIFont.jobisFont(.body)
        $0.textColor = UIColor.GrayScale.gray90
        $0.backgroundColor = UIColor.GrayScale.gray10
        $0.layer.cornerRadius = 12
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.isScrollEnabled = true
    }
    private let placeholderLabel = UILabel().then {
        $0.text = "면접 분위기에 대해 자세히 알려주세요"
        $0.font = UIFont.jobisFont(.body)
        $0.textColor = UIColor.GrayScale.gray60
        $0.isHidden = false
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    
    private let contentView = UIView()
    
    private let questionLabel = UILabel().then {
        $0.setJobisText(
            "Q. 면접 분위기는 어땠나요?",
            font: .pageTitle,
            color: .GrayScale.gray90
        )
        $0.numberOfLines = 0
    }
    
    private let nextButton = JobisButton(style: .main).then {
        $0.setText("다음")
        $0.isEnabled = false
    }
    
    private let characterCountLabel = UILabel().then {
        $0.setJobisText(
            "0/500",
            font: .caption,
            color: .GrayScale.gray60
        )
        $0.textAlignment = .right
    }
    
    public override func addView() {
        [
            scrollView
        ].forEach { view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            questionLabel,
            atmosphereTextView,
            characterCountLabel,
            nextButton
        ].forEach { contentView.addSubview($0) }
        
        atmosphereTextView.addSubview(placeholderLabel)
    }
    
    public override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        atmosphereTextView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(atmosphereTextView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(characterCountLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    public override func bind() {
        let input = InterviewAtmosphereViewModel.Input(
            viewWillAppear: viewWillAppearPublisher.asObservable(),
            atmosphereText: atmosphereTextView.rx.text.orEmpty.asObservable(),
            nextButtonDidTap: nextButtonDidTap.asObservable()  // 수정: .asObservable() 추가
        )
        
        let output = viewModel.transform(input)
        
        output.isNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.characterCount
            .map { "\($0)/500" }
            .bind(to: characterCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    public override func configureViewController() {
        self.hideTabbar()
        
        atmosphereTextView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: nextButtonDidTap)  // 수정: .asObservable() 제거 (이미 PublishRelay에 바인딩)
            .disposed(by: disposeBag)
        
        // 키보드 처리
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            }
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.adjustForKeyboard(height: keyboardHeight, isShowing: true)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] _ in
                self?.adjustForKeyboard(height: 0, isShowing: false)
            })
            .disposed(by: disposeBag)
    }
    
    public override func configureNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func adjustForKeyboard(height: CGFloat, isShowing: Bool) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if isShowing {
            // 텍스트뷰가 보이도록 스크롤
            let textViewFrame = atmosphereTextView.frame
            let visibleRect = CGRect(
                x: textViewFrame.origin.x,
                y: textViewFrame.origin.y,
                width: textViewFrame.width,
                height: textViewFrame.height + 100
            )
            scrollView.scrollRectToVisible(visibleRect, animated: true)
        }
    }
}
