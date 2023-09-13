//
//  CustomPhotoPickerViewController.swift
//  MultipleImagePicker
//
//  Created by Bảo on 17/01/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//

import Foundation
import TLPhotoPicker

class CustomPhotoPickerViewController: TLPhotosPickerViewController, ViewerControllerDataSource {
    var viewerController: ViewerController?

    func numberOfItemsInViewerController(_: ViewerController) -> Int {
        var count = 0

        for section in 0 ..< collectionView.numberOfSections {
            count += collectionView.numberOfItems(inSection: section)
        }

        return count
    }

    func viewerController(_: ViewerController, viewableAt indexPath: IndexPath) -> Viewable {
        let viewable = PreviewItem(id: UUID().uuidString)

        if let cell = collectionView?.cellForItem(at: indexPath) as? Cell, let placeholder = cell.imageView?.image, let asset = cell.asset {
            viewable.assetID = asset.localIdentifier

            if asset.duration > 0 {
                viewable.type = .video
            }

            viewable.placeholder = placeholder
        }

        return viewable
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleCellLongPress(_:)), name: Cell.longPressNotification, object: nil)
    }

    deinit {
        // Hủy đăng ký khi ViewController bị giải phóng
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleCellLongPress(_ notification: Notification) {
        if let cell = notification.object as? Cell {
            if let indexPath = collectionView.indexPath(for: cell) {
                self.viewerController = ViewerController(initialIndexPath: indexPath, collectionView: collectionView)

                self.viewerController!.dataSource = self

                self.viewerController?.viewSafeAreaInsetsDidChange()

                let headerView = PreviewHeaderView()
                headerView.viewDelegate = self

                headerView.backgroundColor = .white

                self.viewerController!.headerView = headerView

                self.present(self.viewerController!, animated: true, completion: nil)
            }
        }
    }

    override func makeUI() {
        super.makeUI()
        self.collectionView.backgroundColor = .white
        self.customNavItem.leftBarButtonItem?.tintColor = .black
        self.customNavItem.rightBarButtonItem?.tintColor = config.selectedColor

        for subview in self.view.subviews {
            guard let navbar = subview as? UINavigationBar else {
                break
            }
            if #available(iOS 13.0, *) {
                navbar.barTintColor = .systemBackground
            } else {
                navbar.barTintColor = UIColor.white
            }
        }

        if #available(iOS 13.0, *) {
            self.customNavItem.leftBarButtonItem?.tintColor = .label
            self.collectionView.backgroundColor = .systemBackground
            self.view.backgroundColor = .systemBackground
        }
    }

    func cellOnLongPress(_: Cell) {
        //
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension CustomPhotoPickerViewController: PreviewHeaderViewDelegate {
    func headerView(_: PreviewHeaderView, didPressClearButton _: UIButton) {
        self.viewerController?.dismiss(nil)
    }

    func headerView(_: PreviewHeaderView, didPressDoneButton _: UIButton) {
        DispatchQueue.main.async {
            self.viewerController?.dismiss(animated: false, completion: {
                self.dismiss(animated: true)
            })
        }
    }
}
