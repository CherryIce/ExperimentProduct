//
//  RPYaCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/15.
//

import UIKit

class RPYaCell: UITableViewCell {
    
    weak var delegate:RPListViewCellEventDelegate?
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

extension RPYaCell:RPListCellDataDelegate {
    
    func setCellData(cellData: AnyObject, delegate: RPListViewCellEventDelegate, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        if cellData is RPTableViewCellItem {
            let xx = cellData as! RPTableViewCellItem
            if xx.cellData is String {
                dict = xx.cellData as! String
                self.textLabel?.text = dict
                self.imageView?.image = UIImage.init(color: RPColor.ShallowColor)?.roundedCornerImageWithCornerRadius(8)
            }
        }
    }
}
