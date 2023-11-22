import UIKit

public extension UIViewController {
    func setLargeTitle(title: String) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
}
