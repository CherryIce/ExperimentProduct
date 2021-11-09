//
//  RPYaCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/15.
//

import UIKit

class RPYaCell: UITableViewCell {
    
    weak var delegate:RPListViewCellEventDelegate?
    private var indexPath = IndexPath()
    private var model = RPYaModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        imageView?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        imageView!.addGestureRecognizer(tap)
    }
    
    @objc private func tapClick() {
        if self.delegate != nil {
            self.delegate?.cellSubviewsClickAction(indexPath, cellData: model)
        }
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
            if xx.cellData is RPYaModel {
                model = xx.cellData as! RPYaModel
                self.textLabel?.text = model.title
                self.textLabel?.font = model.titleFont
                self.textLabel?.textColor = model.titleColor
                if model.image.count != 0 {
                    self.imageView?.image = RPTools.getPngImage(forResource: model.image).roundedCornerImageWithCornerRadius(8)
                }
                self.accessoryType = model.needArrow ? .disclosureIndicator : .none
                self.detailTextLabel?.text = model.detail
                self.detailTextLabel?.font = model.detailFont
                self.detailTextLabel?.textColor = model.detailColor
            }
        }
    }
}
