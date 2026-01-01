import UIKit
import Then
import SnapKit
import RxGesture
import RxSwift
import RxCocoa
import DesignSystem

public class BaseBottomSheetReactorViewController<Reactor: BaseReactor>: UIViewController,
                                                                         ViewControllable,
                                                                         LifeCyclePublishable,
                                                                         HasDisposeBag,
                                                                         AddViewable,
                                                                         SetLayoutable,
                                                                         ReactorBindable,
                                                                         ViewControllerConfigurable,
                                                                         NavigationConfigurable {
    public let reactor: Reactor
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
    private lazy var maxTopInset = (
        view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
    )
    private lazy var bottomSheetViewTopInset: CGFloat = maxTopInset
    private lazy var bottomSheetPanStartingTopInset: CGFloat = bottomSheetPanMinTopInset

    public init(_ reactor: Reactor, state: BottomSheetViewState = .normal) {
        self.reactor = reactor
        self.state = state
        super .init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayoutButtonSheet()
        self.addView()
        self.setLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButtonSheet()
        self.bindAction()
        self.bindState()
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

    public func addView() {}

    public func setLayout() {}

    public func bindAction() {}

    public func bindState() {}

    public func configureViewController() {}

    public func configureNavigation() {}

    private func setLayoutButtonSheet() {
        [
            dimmedView,
            bottomSheetView
        ].forEach(view.addSubview(_:))
        [
            dragIndicatorView,
            contentView
        ].forEach(bottomSheetView.addSubview(_:))

        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheetView.snp.updateConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(bottomSheetViewTopInset)
        }
        dragIndicatorView.snp.makeConstraints {
            $0.width.equalTo(64)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.top.lessThanOrEqualToSuperview().inset(12)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(dragIndicatorView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureButtonSheet() {
        dimmedView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.dismissBottomSheet()
            }
            .disposed(by: disposeBag)

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
            })
            .disposed(by: disposeBag)
    }

    @objc open func dismissBottomSheet() {
        performDismissBottomSheet()
    }

    private func performDismissBottomSheet() {
        bottomSheetViewTopInset = maxTopInset
        bottomSheetView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(bottomSheetViewTopInset)
        }

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.dimmedView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
}

extension BaseBottomSheetReactorViewController {
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
            options: .curveEaseInOut
        ) { self.dimmedView.alpha = 1 }

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.76,
            initialSpringVelocity: 0.0
        ) { self.view.layoutIfNeeded() }
    }
}
