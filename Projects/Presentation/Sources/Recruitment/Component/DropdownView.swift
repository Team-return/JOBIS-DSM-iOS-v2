import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class DropdownView: UIButton {

    private let options: [String]
    private var selectedIndex = 0
    private let disposeBag = DisposeBag()

    private lazy var dropdownTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.GrayScale.gray50.cgColor
        $0.backgroundColor = .GrayScale.gray10
        $0.isScrollEnabled = false
        $0.alpha = 0
        $0.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
        $0.separatorStyle = .none
    }

    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .GrayScale.gray60
        $0.contentMode = .scaleAspectFit
    }

    private var isDropdownOpen = false

    init(options: [String]) {
        self.options = options
        super.init(frame: .zero)
        setupButton()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        setTitle(options.first, for: .normal)
        setTitleColor(UIColor.GrayScale.gray60, for: .normal)
        titleLabel?.font = .jobisFont(.description)
        contentHorizontalAlignment = .center

        addSubview(chevronImageView)

        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
    }

    private func bind() {
        self.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleDropdown()
            })
            .disposed(by: disposeBag)
    }

    private func toggleDropdown() {
        isDropdownOpen.toggle()

        if isDropdownOpen {
            showDropdown()
        } else {
            hideDropdown()
        }
    }

    private func showDropdown() {
        guard let window = window else { return }

        let buttonFrame = convert(bounds, to: window)

        window.addSubview(dropdownTableView)

        let tableHeight: CGFloat = CGFloat(options.count) * 48

        dropdownTableView.snp.makeConstraints {
            $0.top.equalTo(window.snp.top).offset(buttonFrame.maxY + 8)
            $0.leading.equalTo(window.snp.leading).offset(buttonFrame.minX)
            $0.width.equalTo(110)
            $0.height.equalTo(tableHeight)
        }

        UIView.animate(withDuration: 0.2) {
            self.dropdownTableView.alpha = 1
        }
    }

    private func hideDropdown() {
        isDropdownOpen = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.dropdownTableView.alpha = 0
        }) { _ in
            self.dropdownTableView.removeFromSuperview()
        }
    }
}

extension DropdownView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        let option = options[indexPath.row]
        cell.configure(with: option, isSelected: indexPath.row == selectedIndex)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        setTitle(options[indexPath.row], for: .normal)
        hideDropdown()
        tableView.reloadData()
    }
}

class DropdownCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        textLabel?.font = .jobisFont(.description)
        textLabel?.textAlignment = .center
        selectionStyle = .gray
        backgroundColor = .white
    }

    func configure(with text: String, isSelected: Bool) {
        textLabel?.text = text
        textLabel?.textColor = isSelected ? .Primary.blue20 : .GrayScale.gray60
    }
}


