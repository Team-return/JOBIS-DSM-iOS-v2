import UIKit
import SnapKit
import Then

class RecruitmentDropdownView: UIButton {
    
    // MARK: - Properties
    private let dropdownOptions = ["기본순", "매출", "직원 ↓", "직원 ↑", "공고마감 ↓", "공고마감 ↑"]
    private var selectedIndex = 0
    
    private lazy var dropdownTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.backgroundColor = .white
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.isScrollEnabled = false
        $0.alpha = 0
        $0.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
    }
    
    private let chevronImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.down")
        $0.tintColor = .systemGray
        $0.contentMode = .scaleAspectFit
    }
    
    private var isDropdownOpen = false
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        setTitle("기본순", for: .normal)
        setTitleColor(.systemGray, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        contentHorizontalAlignment = .center
        
        addSubview(chevronImageView)
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func toggleDropdown() {
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
        
        let tableHeight: CGFloat = CGFloat(dropdownOptions.count) * 48
        
        dropdownTableView.snp.makeConstraints {
            $0.top.equalTo(window.snp.top).offset(buttonFrame.maxY + 8)
            $0.leading.equalTo(window.snp.leading).offset(buttonFrame.minX)
            $0.width.equalTo(200)
            $0.height.equalTo(tableHeight)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.dropdownTableView.alpha = 1
            self.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    private func hideDropdown() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dropdownTableView.alpha = 0
            self.chevronImageView.transform = .identity
        }) { _ in
            self.dropdownTableView.removeFromSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RecruitmentDropdownView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        let option = dropdownOptions[indexPath.row]
        cell.configure(with: option, isSelected: indexPath.row == selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        setTitle(dropdownOptions[indexPath.row], for: .normal)
        hideDropdown()
        isDropdownOpen = false
        tableView.reloadData()
    }
}

// MARK: - Dropdown Cell
class DropdownCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        textLabel?.font = .systemFont(ofSize: 16)
        textLabel?.textAlignment = .center
        selectionStyle = .none
        backgroundColor = .white
    }
    
    func configure(with text: String, isSelected: Bool) {
        textLabel?.text = text
        textLabel?.textColor = isSelected ? .systemBlue : .black
    }
}
