//
//  RPYaCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/15.
//

import UIKit

class RPYaCell: UITableViewCell {
    
    weak var delegate:RPTableViewCellEventDelegate?
    var indexPath = IndexPath()
    var dict = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
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
    func setData(data: RPTableViewCellItem,
                 delegate: RPTableViewCellEventDelegate,
                 indexPath:IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        if data.cellData is String {
            dict = data.cellData as! String
            self.textLabel?.text = dict
            self.imageView?.image = UIImage.init(color: RPColor.ShallowColor)?.roundedCornerImageWithCornerRadius(8)
        }
    }
}
