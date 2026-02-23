import UIKit
import SnapKit
import Then
import DesignSystem
import RxSwift
import RxCocoa

final class CalendarView: BaseView {
    let prevMonthTapped = PublishRelay<Void>()
    let nextMonthTapped = PublishRelay<Void>()
    let daySelected = PublishRelay<Int>()

    private let disposeBag = DisposeBag()

    private let prevButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .GrayScale.gray90
    }
    private let monthLabel = UILabel()
    private let nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .GrayScale.gray90
    }
    private let weekdayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 27.83
    }
    private let dateGridStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 28
    }
    private var dateButtons: [UIButton] = []
    private var circleViews: [UIView] = []

    private var currentYear = 0
    private var currentMonth = 0
    private var todayDay = 0
    private var selectedDay: Int? = nil

    private var hasSetupLayout = false

    override func addView() {
        guard !hasSetupLayout else { return }
        [prevButton, monthLabel, nextButton, weekdayStackView, dateGridStackView]
            .forEach(self.addSubview(_:))
    }

    override func setLayout() {
        guard !hasSetupLayout else { return }
        hasSetupLayout = true
        monthLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        prevButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.leading.equalToSuperview().inset(12)
            $0.width.height.equalTo(28)
        }
        nextButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(28)
        }
        weekdayStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(20)
        }
        dateGridStackView.snp.makeConstraints {
            $0.top.equalTo(weekdayStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        self.backgroundColor = .GrayScale.gray20
        self.layer.cornerRadius = 12
        self.clipsToBounds = true

        setupWeekdayLabels()
        setupDateGrid()

        prevButton.rx.tap
            .bind(to: prevMonthTapped)
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .bind(to: nextMonthTapped)
            .disposed(by: disposeBag)
    }

    func configure(year: Int, month: Int, today: Int, selectedDay: Int?) {
        self.currentYear = year
        self.currentMonth = month
        self.todayDay = today
        self.selectedDay = selectedDay

        let calendar = Calendar.current
        monthLabel.setJobisText("\(month)월", font: .headLine, color: .GrayScale.gray70)

        let days = calendarDays(year: year, month: month, calendar: calendar)
        for (index, button) in dateButtons.enumerated() {
            guard index < days.count else { break }
            let (day, isCurrentMonth) = days[index]
            let circleView = circleViews[index]
            button.setTitle("\(day)", for: .normal)
            button.tag = isCurrentMonth ? day : -1

            let col = index % 7
            let isWeekend = col == 0 || col == 6

            if !isCurrentMonth {
                button.setTitleColor(.GrayScale.gray40, for: .normal)
                circleView.backgroundColor = .clear
                circleView.layer.borderWidth = 0
            } else if day == selectedDay {
                button.setTitleColor(.white, for: .normal)
                circleView.backgroundColor = .Primary.blue30
                circleView.layer.borderWidth = 0
            } else if day == today {
                button.setTitleColor(.Primary.blue30, for: .normal)
                circleView.backgroundColor = .clear
                circleView.layer.borderColor = UIColor.Primary.blue30.cgColor
                circleView.layer.borderWidth = 1
            } else if isWeekend {
                button.setTitleColor(.GrayScale.gray40, for: .normal)
                circleView.backgroundColor = .clear
                circleView.layer.borderWidth = 0
            } else {
                button.setTitleColor(.GrayScale.gray60, for: .normal)
                circleView.backgroundColor = .clear
                circleView.layer.borderWidth = 0
            }
        }
    }

    private func setupWeekdayLabels() {
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        weekdays.enumerated().forEach { index, title in
            let label = UILabel()
            let color: UIColor = (index == 0 || index == 6) ? .GrayScale.gray40 : .GrayScale.gray60
            label.setJobisText(title, font: .subBody, color: color)
            label.textAlignment = .center
            weekdayStackView.addArrangedSubview(label)
        }
    }

    private func setupDateGrid() {
        dateButtons = []
        circleViews = []
        for _ in 0..<5 {
            let rowStack = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 27.83
            }
            for _ in 0..<7 {
                let button = UIButton().then {
                    $0.titleLabel?.font = .jobisFont(.subBody)
                }
                let circleView = UIView().then {
                    $0.layer.cornerRadius = 11
                    $0.clipsToBounds = true
                    $0.isUserInteractionEnabled = false
                }
                button.insertSubview(circleView, at: 0)
                circleView.snp.makeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.height.equalTo(22)
                }
                button.rx.tap
                    .compactMap { [weak button] _ -> Int? in
                        guard let tag = button?.tag, tag > 0 else { return nil }
                        return tag
                    }
                    .bind(to: daySelected)
                    .disposed(by: disposeBag)
                rowStack.addArrangedSubview(button)
                dateButtons.append(button)
                circleViews.append(circleView)
            }
            dateGridStackView.addArrangedSubview(rowStack)
        }
    }

    private func calendarDays(year: Int, month: Int, calendar: Calendar) -> [(Int, Bool)] {
        let components = DateComponents(year: year, month: month, day: 1)
        guard let firstDate = calendar.date(from: components) else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstDate) - 1
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDate)!.count

        let prevYear = month == 1 ? year - 1 : year
        let prevMonth = month == 1 ? 12 : month - 1
        let prevComponents = DateComponents(year: prevYear, month: prevMonth, day: 1)
        let prevDate = calendar.date(from: prevComponents) ?? firstDate
        let daysInPrev = calendar.range(of: .day, in: .month, for: prevDate)!.count

        var days: [(Int, Bool)] = []
        for offset in stride(from: firstWeekday - 1, through: 0, by: -1) {
            days.append((daysInPrev - offset, false))
        }
        for day in 1...daysInMonth {
            days.append((day, true))
        }
        let remaining = 35 - days.count
        for day in 1...max(1, remaining) {
            days.append((day, false))
        }
        return days
    }
}
