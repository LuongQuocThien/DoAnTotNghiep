//
//  CommentViewController.swift
//  MyApp
//
//  Created by Thien Luong Q on 11/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import Firebase
import FirebaseStorage

protocol CommentViewControllerDelegate: class {

    func controller(_ controller: CommentViewController, needPerform action: CommentViewController.Action)
}

final class CommentViewController: ViewController {

    enum Action {
        case reloadDataComments
    }

    @IBOutlet private weak var collectionView: UICollectionView!

    var venueId = ""
    var images: [UIImage] = []
    var headerView: CommentHeaderCollectionView?
    weak var delegate: CommentViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        title = "Bình luận"
        collectionView.register(header: CommentHeaderCollectionView.self)
        collectionView.register(ImageUploadCollectionViewCell.self)
        collectionView.dataSource = self

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = Config.sizeForItem
        layout.sectionInset = Config.insetForSection
        layout.headerReferenceSize = Config.headerCollectionSize
        collectionView.collectionViewLayout = layout
    }

    // Show alert
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(_: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Bộ sưu tập", style: .default, handler: {(_: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Huỷ", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func uploadMedia(title: String, content: String, rating: Int) {
        HUD.show()
        guard !images.isEmpty else {
            HUD.dismiss()
            saveCommentData(title: title, content: content, rating: rating, imagesURLString: [])
            return
        }

        var imagesURLString: [String] = []
        for image in images {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("images/comments/\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
                storageRef.putData(uploadData, metadata: nil) { [weak self] (_, error) in
                    HUD.dismiss()
                    guard let this = self else { return }
                    if let error = error {
                        this.alert(error: error)
                        return
                    } else {
                        storageRef.downloadURL(completion: { (url, _) in
                            guard let urlString = url?.absoluteString else { return }
                            imagesURLString.append(urlString)
                            // Check finish upload image to save database
                            if imagesURLString.count == this.images.count {
                                this.saveCommentData(title: title, content: content, rating: rating, imagesURLString: imagesURLString)
                                HUD.dismiss()
                            }
                        })
                    }
                }
            }
        }
    }

    func saveCommentData(title: String, content: String, rating: Int, imagesURLString: [String]) {
        var imagesJS: [String: Any] = [:]
        for i in 0..<imagesURLString.count {
            imagesJS["\(i)"] = imagesURLString[i]
        }
        var userJS: [String: Any] = [:]
        userJS["userId"] = Session.shared.userId
        userJS["firstName"] = Session.shared.firstName
        userJS["lastName"] = Session.shared.lastName
        userJS["avatar"] = Session.shared.avatarUrlSring

        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateString = formatter.string(from: currentDateTime)

        var ref: DatabaseReference!
        ref = Database.database().reference()
        let id = NSUUID().uuidString
        let data = ["id": id,
                    "createdAt": currentDateString,
                    "venueId": venueId,
                    "title": title,
                    "content": content,
                    "rating": rating,
                    "user": userJS,
                    "images": imagesJS] as [String : Any]
        ref.child("response").child("comment").child(id).setValue(data)

        // Reload data
        delegate?.controller(self, needPerform: .reloadDataComments)
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func postCommentButtonTouchUpInside(_ sender: Any) {
        guard let view = headerView else { return }
        view.isPosting = true
    }
}

// MARK: - UICollectionViewDataSource
extension CommentViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < images.count else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(ImageUploadCollectionViewCell.self, forIndexPath: indexPath)
        cell.item = ImageUploadCollectionViewCell.Item(image: images[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            headerView = collectionView.dequeue(header: CommentHeaderCollectionView.self, forIndexPath: indexPath)
            guard let view = headerView else { return UICollectionReusableView() }
            view.delegate = self
            return view
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - CommentHeaderCollectionViewDelegate
extension CommentViewController: CommentHeaderCollectionViewDelegate {

    func view(_ headerView: CommentHeaderCollectionView, needPerform action: CommentHeaderCollectionView.Action) {
        switch action {
        case .getDataCommentToPost(let title, let content, let rating):
            if title.isEmpty || content.isEmpty {
                showAlert(title: "", message: "Vui lòng nhập đầy đủ tiêu đề và nội dung bình luận!", buttons: ["OK"], handler: nil)
            } else {
                uploadMedia(title: title, content: content, rating: rating)
            }
        case .addImage:
            showAlert()
        }
    }
}

extension CommentViewController: ImageUploadCollectionViewCellDelegate {

    func cell(_ cell: ImageUploadCollectionViewCell, needPerform action: ImageUploadCollectionViewCell.Action) {
        switch action {
        case .deleteImage(let index):
            images.remove(at: index)
            collectionView.reloadData()
        }
    }
}

extension CommentViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.allowsEditing = true
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(image)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension HomeViewController
extension CommentViewController {

    struct Config {
        static let sizeForItem = CGSize(width: (UIScreen.main.bounds.width - 20) / 2, height: (UIScreen.main.bounds.width - 20) / 2)
        static let insetForSection = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        static let headerCollectionHeight: CGFloat = 220
        static let buttonContainViewheightConstraintWhenHidden: CGFloat = 0
        static let buttonContainViewheightConstraintWhenShow: CGFloat = 35
        static let headerCollectionSize = CGSize(width: UIScreen.main.bounds.width, height: 335.5)
        static let heightLocationView: CGFloat = UIApplication.shared.statusBarFrame.height + 40
        static let buttonNormalFont = UIFont.systemFont(ofSize: 14)
        static let buttonSelectedFont = UIFont.boldSystemFont(ofSize: 15)
    }
}
