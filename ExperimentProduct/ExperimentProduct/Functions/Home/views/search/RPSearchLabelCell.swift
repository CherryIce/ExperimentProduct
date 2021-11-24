//
//  RPSearchLabelCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/24.
//

import UIKit

class RPSearchLabelCell: UITableViewCell {
    
    lazy var rounderLevel = UIView()
    lazy var descrLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        rounderLevel = UIView.init()
        rounderLevel.layercornerRadius(cornerRadius: 5)
        contentView.addSubview(rounderLevel)
        
        descrLabel = UILabel.init()
        descrLabel.font = .systemFont(ofSize: 13)
        contentView.addSubview(descrLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rounderLevel.frame.origin.x = 16
        rounderLevel.frame.size = CGSize(width: 10, height: 10)
        rounderLevel.center.y = bounds.height * 0.5
        
        descrLabel.frame = CGRect(x: rounderLevel.frame.maxX + 10, y: bounds.height/2 - 10, width: bounds.width - rounderLevel.frame.maxX - 26, height: 20)
    }
    
    func setText(_ text:String,andIndexPath indexPath:IndexPath) {
        descrLabel.text = text
        if indexPath.row == 0 {
            rounderLevel.backgroundColor = .red
        }else if indexPath.row == 1{
            rounderLevel.backgroundColor = .orange
        }else if indexPath.row == 2{
            rounderLevel.backgroundColor = .blue
        }else{
            rounderLevel.backgroundColor = .lightGray
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
