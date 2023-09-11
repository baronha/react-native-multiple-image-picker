import UIKit

extension IndexPath {

    enum Direction {
        case forward
        case backward
        case same
    }

    func indexPaths(_ collectionView: UICollectionView) -> [IndexPath] {
        var indexPaths = [IndexPath]()

        let sections = collectionView.numberOfSections
        for section in 0 ..< sections {
            let rows = collectionView.numberOfItems(inSection: section)
            for row in 0 ..< rows {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        }

        return indexPaths
    }

    func next(_ collectionView: UICollectionView) -> IndexPath? {
        var found = false
        let indexPaths = self.indexPaths(collectionView)
        for indexPath in indexPaths {
            if found {
                return indexPath
            }

            if indexPath == self {
                found = true
            }
        }

        return nil
    }

    func previous(_ collectionView: UICollectionView) -> IndexPath? {
        var previousIndexPath: IndexPath?
        let indexPaths = self.indexPaths(collectionView)
        for indexPath in indexPaths {
            if indexPath == self {
                return previousIndexPath
            }

            previousIndexPath = indexPath
        }

        return nil
    }

    static func indexPathForIndex(_ collectionView: UICollectionView, index: Int) -> IndexPath? {
        var count = 0
        let sections = collectionView.numberOfSections
        for section in 0 ..< sections {
            let rows = collectionView.numberOfItems(inSection: section)
            if index >= count && index < count + rows {
                let foundRow = index - count
                return IndexPath(row: foundRow, section: section)
            }
            count += rows
        }

        return nil
    }

    func totalRow(_ collectionView: UICollectionView) -> Int {
        var count = 0
        let sections = collectionView.numberOfSections
        for section in 0 ..< sections {
            if section < self.section {
                let rows = collectionView.numberOfItems(inSection: section)
                count += rows
            }
        }

        return count + self.row
    }

    func compareDirection(_ indexPath: IndexPath) -> Direction {
        let current = self.row * self.section
        let coming = indexPath.row * indexPath.section

        if current == coming {
            return .same
        } else if current < coming {
            return .forward
        } else {
            return .backward
        }
    }
}
