import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import Core

public class MainViewController: BaseViewController<MainViewModel> {
    let button = UIButton().then {
        $0.setTitle("sdf", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    public override func layout() {
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public override func addView() {
        self.view.addSubview(button)
    }
    
    public override func bind() {
        let input = MainViewModel.Input(ButtonDidTap: button.rx.tap.asSignal())
        _ = viewModel.transform(input)
    }
    
}
