//
//  CommentHeaderCollectionView.swift
//  MyApp
//
//  Created by TanHuynh on 11/30/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import SwiftUtils
import MVVM
import Cosmos

protocol CommentHeaderCollectionViewDelegate: class {

    func view(_ headerView: CommentHeaderCollectionView, needPerform action: CommentHeaderCollectionView.Action)
}

class CommentHeaderCollectionView: UICollectionReusableView, View {

    enum Action {
        case getDataCommentToPost(title: String, content: String, rating: Int)
        case addImage()
    }

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var ratingView: CosmosView!

    weak var delegate: CommentHeaderCollectionViewDelegate?
    var rating = 10
    var isPosting = false {
        didSet {
            if isPosting == true {
                guard let title = titleTextField.text,
                    let contentText = commentTextView.text else { return }
                let content = contentText == App.Comment.placeHolderMessage ? "" : contentText
                delegate?.view(self, needPerform: .getDataCommentToPost(title: title, content: content, rating: rating))
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    private func configUI() {
        commentTextView.textColor = .lightGray
        commentTextView.text = App.Comment.placeHolderMessage
        commentTextView.delegate = self

        ratingView.settings.disablePanGestures = true
        ratingView.didTouchCosmos = { [weak self] star in
            guard let this = self else { return }
            this.rating = Int(star * 2)
        }
        ratingView.didFinishTouchingCosmos = { [weak self] star in
            guard let this = self else { return }
            this.rating = Int(star * 2)
        }
    }

    @IBAction func uploadImagesButtonTouchUpInside(_ sender: Any) {
        delegate?.view(self, needPerform: .addImage())
    }
}

extension CommentHeaderCollectionView: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 200 // Limit value
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = App.Comment.placeHolderMessage
            textView.textColor = UIColor.lightGray
        }
    }
}
