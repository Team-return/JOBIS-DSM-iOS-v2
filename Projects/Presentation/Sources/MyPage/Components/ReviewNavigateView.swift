import UIKit
import DesignSystem

class ReviewNavigateView: UIView {
    let reviewNavigateTableView = UITableView().then {
        $0.register(ReviewNavigateTableViewCell.self, forCellReuseIdentifier: ReviewNavigateTableViewCell.identifier)
        $0.rowHeight = 76
        $0.isScrollEnabled = false
    }
    init() {
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        addSubview(reviewNavigateTableView)
        reviewNavigateTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(reviewNavigateTableView.numberOfRows(inSection: 0) == 0 ? 0 : 12)
            $0.height.equalTo(76 * reviewNavigateTableView.numberOfRows(inSection: 0))
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
