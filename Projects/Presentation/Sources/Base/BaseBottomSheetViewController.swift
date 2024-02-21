import UIKit
import Then
import SnapKit
import RxGesture
import RxSwift
import RxCocoa
import DesignSystem

public enum BottomSheetViewState {
    case normal
    case custom(height: CGFloat)
}

public class BaseBottomSheetViewController<ViewModel: BaseViewModel>: UIViewController,
                                           ViewControllable,
                                           LifeCyclePublishable,
                                           HasDisposeBag,
                                           AddViewable,
                                           SetLayoutable,
                                           Bindable,
                                           ViewControllerConfigurable,
                                           NavigationConfigurable {
    public let viewModel: ViewModel
    public var disposeBag = DisposeBag()
    public var viewDidLoadPublisher = PublishRelay<Void>()
    public var viewWillAppearPublisher = PublishRelay<Void>()
    public var viewDidAppearPublisher = PublishRelay<Void>()
    public var viewWillDisappearPublisher = PublishRelay<Void>()
    public var viewDidDisappearPublisher = PublishRelay<Void>()
    private lazy var dimmedView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }
    private let bottomSheetView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let dragIndicatorView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 2
    }
    public let contentView = UIView().then {
        $0.backgroundColor = .GrayScale.gray30
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.clipsToBounds = true
    }
    private let state: BottomSheetViewState
    private let bottomSheetPanMinTopInset: CGFloat = 50
    private let dragHeight = 28.0
    private var defaultHeight: CGFloat = 500
    private lazy var maxTopInset =
    (view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height)
    private lazy var bottomSheetViewTopInset: CGFloat = maxTopInset
    private lazy var bottomSheetPanStartingTopInset: CGFloat = bottomSheetPanMinTopInset

    public init(_ viewModel: ViewModel, state: BottomSheetViewState = .normal) {
        self.viewModel = viewModel
        self.state = state
        super .init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.addView()
        self.setLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configureNavigation()
        self.configureViewController()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearPublisher.accept(())
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewDidAppearPublisher.accept(())
        self.showBottomSheet(atState: state)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewWillDisappearPublisher.accept(())
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewDidDisappearPublisher.accept(())
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    public func addView() {
        [
            dimmedView,
            bottomSheetView
        ].forEach { view.addSubview($0) }
        [
            dragIndicatorView,
            contentView
        ].forEach { bottomSheetView.addSubview($0) }
    }

    public func setLayout() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheetView.snp.updateConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(bottomSheetViewTopInset)
        }
        dragIndicatorView.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(64)
            $0.height.lessThanOrEqualTo(4)
            $0.centerX.equalToSuperview()
            $0.top.lessThanOrEqualToSuperview().inset(12)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(dragIndicatorView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    public func bind() {}

    public func configureViewController() {
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissBottomSheet()
            }).disposed(by: disposeBag)

        bottomSheetView.rx.panGesture()
            .skip(1)
            .bind(with: self, onNext: { owner, gesture in
                let translation = gesture.translation(in: owner.view)
                let defaultPadding = owner.maxTopInset - owner.defaultHeight

                switch gesture.state {
                case .began:
                    owner.bottomSheetPanStartingTopInset = owner.bottomSheetViewTopInset

                case .changed:
                    if translation.y > 0 {
                        owner.bottomSheetViewTopInset = owner
                            .bottomSheetPanStartingTopInset + translation.y
                    }
                    owner.bottomSheetView.snp.updateConstraints {
                        $0.top.equalTo(owner.view.safeAreaLayoutGuide)
                            .inset(owner.bottomSheetViewTopInset)
                    }

                case .ended:
                    let nearestValue = owner.nearest(
                        to: owner.bottomSheetViewTopInset,
                        inValues: [defaultPadding, owner.maxTopInset]
                    )

                    if nearestValue == defaultPadding {
                        owner.showBottomSheet(atState: owner.state)
                    } else {
                        owner.dismissBottomSheet()
                    }

                default:
                    return
                }
            }).disposed(by: disposeBag)
    }

    public func configureNavigation() {}
}

extension BaseBottomSheetViewController {
    private func showBottomSheet(atState: BottomSheetViewState) {
        switch atState {
        case .normal:
            bottomSheetViewTopInset = maxTopInset - defaultHeight - dragHeight
        case let .custom(customHegiht):
            defaultHeight = customHegiht
            let topInset = maxTopInset - customHegiht - dragHeight
            if topInset > 0 {
                bottomSheetViewTopInset = topInset
            } else {
                bottomSheetViewTopInset = bottomSheetPanMinTopInset
                defaultHeight = maxTopInset - bottomSheetPanMinTopInset
            }
        }

        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(bottomSheetViewTopInset)
        }

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.dimmedView.alpha = 1
            }
        )

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.76,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                self.view.layoutIfNeeded()
            }
        )
    }

    public func dismissBottomSheet() {
        bottomSheetViewTopInset = maxTopInset
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(bottomSheetViewTopInset)
        }

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.dimmedView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.dismiss(animated: false)
            }
        )
    }

    // 가까이 있는 숫자 반환해주는 함수
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
}
