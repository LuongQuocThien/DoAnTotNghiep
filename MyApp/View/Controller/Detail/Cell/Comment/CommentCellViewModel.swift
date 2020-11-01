//
//  CommentCellViewModel.swift
//  MyApp
//
//  Created by PCI0010 on 2/15/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MVVM

final class CommentCellViewModel: ViewModel {

    // MARK: - Properties
    var id = ""
    var title = ""
    var content = ""
    var dateTimeText = ""
    var avatar = ""
    var username = ""
    var images: [String] = []
    var rating = 0

    private let formatter: DateFormatter = {
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fm
    }()

    // MARK: - Init
    init(comment: Comment) {
        id = comment.id
        title = comment.title
        content = comment.content
        avatar = comment.avatar
        username = comment.lastName + " " + comment.firstName
        dateTimeText = comment.createdAt
        images = comment.images
        rating = comment.rating
    }
}
