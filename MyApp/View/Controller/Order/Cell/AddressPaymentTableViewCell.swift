//
//  AddressPaymentTableViewCell.swift
//  MyApp
//
//  Created by Thien Luong Q on 12/26/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

class AddressPaymentTableViewCell: TableCell {

    @IBOutlet private weak var addressLabel: UILabel!

    var address: NewAddressOrder? {
        didSet {
            updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Private
    private func updateCell() {
        guard let address = address else { return }
        var addressStr = ""
        addressStr += address.street.isEmpty ? "" : addressStr.isEmpty ? address.street : ", \(address.street)"
        addressStr += address.district.isEmpty ? "" : addressStr.isEmpty ? address.district : ", \(address.district)"
        addressStr += address.city.isEmpty ? "" : addressStr.isEmpty ? address.city : ", \(address.city)"
        addressStr += address.country.isEmpty ? "" : addressStr.isEmpty ? address.country : ", \(address.country)"
        addressLabel.text = addressStr
    }
}
