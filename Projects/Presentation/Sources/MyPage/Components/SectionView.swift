import UIKit
import DesignSystem

final class SectionView: UIView {
    var items: [(title: String, icon: UIImage)] = []
    private var titleLabel: JobisMenuLabel = .init(text: "")

    private let sectionTableView = UITableView().then {
        $0.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.identifier)
        $0.rowHeight = 52
        $0.isScrollEnabled = false
    }

    init(menuText: String) {
        super.init(frame: .zero)
        self.sectionTableView.dataSource = self
        self.titleLabel = JobisMenuLabel(text: menuText)
    }

    override func layoutSubviews() {
        [
            titleLabel,
            sectionTableView
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview()
        }
        sectionTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52 * items.count)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SectionTableViewCell.identifier,
            for: indexPath
        ) as? SectionTableViewCell else { return UITableViewCell() }
        cell.sectionImageView.image = items[indexPath.row].icon.resize(.init(width: 28, height: 28))
        cell.titleLabel.setJobisText(items[indexPath.row].title, font: .body, color: .GrayScale.gray90)
        return cell
    }
}
