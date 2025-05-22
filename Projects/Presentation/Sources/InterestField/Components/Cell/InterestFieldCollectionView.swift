import UIKit
import RxSwift
import RxCocoa
import Core
import DesignSystem
import Domain

final class InterestFieldCollectionView: UICollectionView {
    private var selectedIndexes: Set<IndexPath> = []
    private var interests: [CodeEntity] = []
    private let selectedInterestsRelay = BehaviorRelay<[CodeEntity]>(value: [])

    var selectedInterests: Observable<[CodeEntity]> {
        return selectedInterestsRelay.asObservable()
    }

    init() {
        let layout = AlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        super.init(frame: .zero, collectionViewLayout: layout)

        backgroundColor = .clear
        register(MajorCollectionViewCell.self, forCellWithReuseIdentifier: MajorCollectionViewCell.identifier)
        dataSource = self
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateInterests(_ newInterests: [CodeEntity]) {
        interests = newInterests
        reloadData()
        selectedInterestsRelay.accept(getSelectedInterests())
    }
}

extension InterestFieldCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: MajorCollectionViewCell.identifier, for: indexPath) as? MajorCollectionViewCell else {
            return UICollectionViewCell()
        }

        let codeEntity = interests[indexPath.item]
        cell.adapt(model: codeEntity)
        cell.isCheck = selectedIndexes.contains(indexPath)
        return cell
    }
}

extension InterestFieldCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = interests[indexPath.item].keyword
        let font = UIFont.jobisFont(.body)
        let padding: CGFloat = 32
        let height: CGFloat = 40
        let textWidth = (text as NSString).size(withAttributes: [.font: font]).width
        let maxWidth = frame.width - 32
        let width = min(textWidth + padding, maxWidth)

        let cellWidth = ceil(width / 8) * 8
        return CGSize(width: cellWidth, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension InterestFieldCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexes.contains(indexPath) {
            selectedIndexes.remove(indexPath)
        } else {
            selectedIndexes.insert(indexPath)
        }
        reloadData()
        selectedInterestsRelay.accept(getSelectedInterests())
    }
}

private extension InterestFieldCollectionView {
    func getSelectedInterests() -> [CodeEntity] {
        return selectedIndexes.map { interests[$0.item] }
    }
}
