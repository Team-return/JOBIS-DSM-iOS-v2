import UIKit
import DesignSystem
import RxSwift

typealias SectionModel = (title: String, icon: UIImage)

final class SectionView: BaseView {
    private let sectionTableView = UITableView().then {
        $0.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 52
        $0.isScrollEnabled = false
    }
    private var items: [SectionModel] = []
    private var titleLabel: JobisMenuLabel = .init(text: "")

    init(menuText: String, items: [SectionModel]) {
        super.init()
        self.titleLabel = .init(text: menuText)
        self.items = items
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        [
            titleLabel,
            sectionTableView
        ].forEach(self.addSubview(_:))
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview()
        }

        sectionTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52 * items.count)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    override func configureView() {
        self.sectionTableView.dataSource = self
    }

    func getSelectedItem(index: Int) -> Observable<IndexPath> {
        sectionTableView.rx.itemSelected.filter { $0.row == index }
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
        cell.adapt(model: items[indexPath.row])

        return cell
    }
}
