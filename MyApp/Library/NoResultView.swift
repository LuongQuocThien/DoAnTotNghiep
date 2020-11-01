//
//  NoResultView.swift
//  MyApp
//
//  Created by PCI0001 on 3/12/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

final class NoResultView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = Bundle.main.loadNibNamed("NoResultView", owner: self)?.last as? UIView else { return }
        addSubview(view)
        view.frame = bounds
    }
}
