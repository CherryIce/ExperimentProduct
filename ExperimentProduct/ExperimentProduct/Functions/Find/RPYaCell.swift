//
//  RPYaCell.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/15.
//

import UIKit

class RPYaCell: UITableViewCell {
    
    weak var delegate:RPTableViewCellEventDelegate?
    var dict = NSDictionary()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RPYaCell:RPCellDataDelegate {
    func setData(data: RPCellDataItem, delegate: RPTableViewCellEventDelegate) {
        self.delegate = delegate
        if data.cellData is NSDictionary {
            self.textLabel?.text = "成功"
            self.imageView?.image = UIImage.init(color: RPColor.ShallowColor)?.roundedCornerImageWithCornerRadius(8)
        }
    }
}
