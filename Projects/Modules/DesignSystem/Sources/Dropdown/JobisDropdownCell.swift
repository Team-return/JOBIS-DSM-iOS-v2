import UIKit

class JobisDropdownCell: UITableViewCell {

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
