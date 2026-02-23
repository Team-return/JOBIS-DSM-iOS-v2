import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core
import DesignSystem

public final class AddScheduleViewController: BaseReactorViewController<AddScheduleReactor> {

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.keyboardDismissMode = .onDrag
    }
    private let formStackView = UIStackView().then {
        $0.axis = .vertical; $0.spacing = 16
    }
    let companyTextField = makeInputField(padding: 16)
    private let typeTextViewContainer = UIView().then {
        $0.backgroundColor = .GrayScale.gray30; $0.layer.cornerRadius = 12
    }
    let typeTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = .jobisFont(.body)
        $0.textColor = .GrayScale.gray90
        $0.textContainerInset = .init(top: 14, left: 12, bottom: 14, right: 12)
    }
    private let typePlaceholderLabel = UILabel()
    let locationTextField = makeInputField(padding: 16)
    private let singleDateContainer = makeDateContainer()
    let singleDateField = makeInputField(padding: 16)
    private let singleCalendarBtn = makeCalendarButton()
    private let periodDateHStack = UIStackView().then {
        $0.axis = .horizontal; $0.spacing = 8; $0.alignment = .center; $0.isHidden = true
    }
    private let startDateContainer = makeDateContainer()
    let startDateField = makeInputField(padding: 12)
    private let startCalendarBtn = makeCalendarButton()
    private let endDateContainer = makeDateContainer()
    let endDateField = makeInputField(padding: 12)
    private let endCalendarBtn = makeCalendarButton()
    private let inlineCalendar = CalendarView().then {
        $0.isHidden = true; $0.layer.cornerRadius = 12; $0.clipsToBounds = true
    }
    private var calendarYear = Calendar.current.component(.year, from: Date())
    private var calendarMonth = Calendar.current.component(.month, from: Date())
    private var activeCalendarField: UITextField?
    private var isPickerShowing = false
    private let periodRowView = UIStackView().then {
        $0.axis = .horizontal; $0.spacing = 8; $0.alignment = .center
    }
    let periodCheckBox = JobisCheckBox()
    let timeTextField = makeInputField(padding: 16)
    private let addButton = JobisButton(style: .main).then {
        $0.setText("추가하기"); $0.isEnabled = false
    }
    private var hasSetupLayout = false

    public override func addView() {
        guard !hasSetupLayout else { return }
        view.addSubview(scrollView)
        view.addSubview(addButton)
        scrollView.addSubview(formStackView)

        typeTextViewContainer.addSubview(typeTextView)
        typeTextViewContainer.addSubview(typePlaceholderLabel)

        [singleDateField, singleCalendarBtn].forEach(singleDateContainer.addSubview(_:))
        [startDateField, startCalendarBtn].forEach(startDateContainer.addSubview(_:))
        [endDateField, endCalendarBtn].forEach(endDateContainer.addSubview(_:))

        let tilde = UILabel().then {
            $0.text = "~"; $0.font = .jobisFont(.body)
            $0.textColor = .GrayScale.gray60
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
        [startDateContainer, tilde, endDateContainer].forEach(periodDateHStack.addArrangedSubview(_:))

        let dateContent = UIStackView().then { $0.axis = .vertical; $0.spacing = 8 }
        [singleDateContainer, periodDateHStack, inlineCalendar].forEach(dateContent.addArrangedSubview(_:))

        let periodLabel = UILabel().then { $0.setJobisText("면접기간", font: .description, color: .GrayScale.gray80) }
        [periodLabel, periodCheckBox].forEach(periodRowView.addArrangedSubview(_:))

        [FormSectionView(title: "기업", content: companyTextField),
         FormSectionView(title: "면접 종류", content: typeTextViewContainer),
         FormSectionView(title: "면접 장소", content: locationTextField),
         FormSectionView(title: "면접 일자", content: dateContent),
         periodRowView,
         FormSectionView(title: "면접시간", content: timeTextField)
        ].forEach(formStackView.addArrangedSubview(_:))
    }

    public override func setLayout() {
        guard !hasSetupLayout else { return }
        hasSetupLayout = true
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(addButton.snp.top)
        }
        formStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(scrollView).offset(-48)
        }
        [companyTextField, locationTextField, timeTextField].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(52) }
        }
        typeTextView.snp.makeConstraints { $0.edges.equalToSuperview() }
        typePlaceholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14); $0.leading.equalToSuperview().inset(16)
        }
        typeTextViewContainer.snp.makeConstraints { $0.height.equalTo(120) }
        layoutDateField(field: singleDateField, button: singleCalendarBtn, container: singleDateContainer, iconSize: 24, iconInset: 16)
        layoutDateField(field: startDateField, button: startCalendarBtn, container: startDateContainer, iconSize: 20, iconInset: 10)
        layoutDateField(field: endDateField, button: endCalendarBtn, container: endDateContainer, iconSize: 20, iconInset: 10)
        endDateContainer.snp.makeConstraints { $0.width.equalTo(startDateContainer) }
        inlineCalendar.snp.makeConstraints { $0.height.equalTo(380) }
        periodCheckBox.snp.makeConstraints { $0.width.height.equalTo(24) }
        periodRowView.snp.makeConstraints { $0.height.equalTo(36) }
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16); $0.height.equalTo(52)
        }
    }

    public override func configureViewController() {
        companyTextField.setPlaceholder("면접을 보는 기업을 알려주세요")
        typePlaceholderLabel.setJobisText("면접 종류를 입력해주세요", font: .body, color: .GrayScale.gray60)
        typeTextView.rx.text.orEmpty.map { !$0.isEmpty }
            .bind(to: typePlaceholderLabel.rx.isHidden).disposed(by: disposeBag)
        locationTextField.setPlaceholder("면접 장소를 입력해주세요")
        [singleDateField, startDateField, endDateField].forEach { $0.setPlaceholder("YYYY.MM.DD") }
        timeTextField.setPlaceholder("hh.mm")
        bindCalendar()
    }

    public override func bindAction() {
        companyTextField.rx.text.orEmpty
            .map { AddScheduleReactor.Action.companyChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        typeTextView.rx.text.orEmpty
            .map { AddScheduleReactor.Action.typeChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        locationTextField.rx.text.orEmpty
            .map { AddScheduleReactor.Action.locationChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        timeTextField.rx.text.orEmpty
            .map { AddScheduleReactor.Action.timeChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    public override func bindState() {
        reactor.state.map { $0.isAddButtonEnabled }
            .distinctUntilChanged()
            .bind(to: addButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    public override func configureNavigation() { setSmallTitle(title: "면접 일정 추가") }

    private func bindCalendar() {
        periodCheckBox.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.periodCheckBox.isCheck.toggle()
                self.reactor.action.onNext(.periodToggled(self.periodCheckBox.isCheck))
                self.hidePicker()
                UIView.animate(withDuration: 0.25) {
                    self.singleDateContainer.isHidden = self.periodCheckBox.isCheck
                    self.periodDateHStack.isHidden = !self.periodCheckBox.isCheck
                    self.formStackView.layoutIfNeeded()
                }
            }).disposed(by: disposeBag)

        [(singleCalendarBtn, singleDateField),
         (startCalendarBtn, startDateField),
         (endCalendarBtn, endDateField)].forEach { btn, field in
            btn.rx.tap
                .subscribe(onNext: { [weak self] in self?.togglePicker(for: field) })
                .disposed(by: disposeBag)
        }

        inlineCalendar.prevMonthTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.calendarMonth == 1
                    ? { self.calendarYear -= 1; self.calendarMonth = 12 }()
                    : { self.calendarMonth -= 1 }()
                self.refreshCalendar()
            }).disposed(by: disposeBag)

        inlineCalendar.nextMonthTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.calendarMonth == 12
                    ? { self.calendarYear += 1; self.calendarMonth = 1 }()
                    : { self.calendarMonth += 1 }()
                self.refreshCalendar()
            }).disposed(by: disposeBag)

        inlineCalendar.daySelected
            .subscribe(onNext: { [weak self] day in
                guard let self, let field = self.activeCalendarField else { return }
                let dateString = String(format: "%04d.%02d.%02d", self.calendarYear, self.calendarMonth, day)
                field.text = dateString
                let action: AddScheduleReactor.Action
                if field === self.singleDateField {
                    action = .singleDateChanged(dateString)
                } else if field === self.startDateField {
                    action = .startDateChanged(dateString)
                } else {
                    action = .endDateChanged(dateString)
                }
                self.reactor.action.onNext(action)
                self.inlineCalendar.configure(
                    year: self.calendarYear, month: self.calendarMonth,
                    today: Calendar.current.component(.day, from: Date()), selectedDay: day
                )
                self.hidePicker()
            }).disposed(by: disposeBag)
    }

    private func refreshCalendar() {
        inlineCalendar.configure(
            year: calendarYear, month: calendarMonth,
            today: Calendar.current.component(.day, from: Date()), selectedDay: nil
        )
    }

    private func togglePicker(for field: UITextField) {
        if isPickerShowing && activeCalendarField === field { hidePicker(); return }
        activeCalendarField = field
        isPickerShowing = true
        refreshCalendar()
        inlineCalendar.isHidden = false
        UIView.animate(withDuration: 0.25) { self.formStackView.layoutIfNeeded() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let rect = self.inlineCalendar.convert(self.inlineCalendar.bounds, to: self.scrollView)
            self.scrollView.scrollRectToVisible(rect, animated: true)
        }
    }

    private func hidePicker() {
        isPickerShowing = false
        UIView.animate(withDuration: 0.25) {
            self.inlineCalendar.isHidden = true
            self.formStackView.layoutIfNeeded()
        }
    }

    private func layoutDateField(
        field: UITextField, button: UIButton,
        container: UIView, iconSize: CGFloat, iconInset: CGFloat
    ) {
        field.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(button.snp.leading).offset(-4)
        }
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(iconInset)
            $0.centerY.equalToSuperview(); $0.width.height.equalTo(iconSize)
        }
        container.snp.makeConstraints { $0.height.equalTo(52) }
    }
}

private extension AddScheduleViewController {
    static func makeInputField(padding: CGFloat) -> UITextField {
        UITextField().then {
            $0.backgroundColor = .GrayScale.gray30
            $0.layer.cornerRadius = 12
            $0.font = .jobisFont(.body)
            $0.textColor = .GrayScale.gray90
            $0.addLeftPadding(size: padding)
        }
    }
    static func makeDateContainer() -> UIView {
        UIView().then { $0.backgroundColor = .GrayScale.gray30; $0.layer.cornerRadius = 12 }
    }
    static func makeCalendarButton() -> UIButton {
        UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "calendar"), for: .normal)
            $0.tintColor = .GrayScale.gray60
        }
    }
}

private extension UITextField {
    func setPlaceholder(_ text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.jobisFont(.body),
                .foregroundColor: UIColor.GrayScale.gray60
            ]
        )
    }
}
