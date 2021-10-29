//
//  RPNiceViewCell.swift
//  ExperimentProduct
//
//  Created by YuMao on 2021/10/29.
//

import UIKit

class RPNiceViewCell: UICollectionViewCell {
    
    @IBOutlet weak var converImgV: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var headImgV: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesButton: UIButton!
    var model: RPNiceModel{
        didSet {
            self.converImgV.setImageWithURL(model.converUrl, placeholder: UIImage.init(color: RPColor.RandomColor)!)
            self.contentLabel.text = model.content
            self.headImgV.setImageWithURL(model.headImgUrl, placeholder: UIImage.init(color: RPColor.RandomColor)!, closure: nil)
            self.userNameLabel.text = model.userName
            self.likesButton.setTitle(String(Int(model.likes)), for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layercornerRadius(cornerRadius: 4)
        self.contentView.clipsToBounds = true
        self.headImgV.layercornerRadius(cornerRadius: 10)
        self.headImgV.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        self.model = RPNiceModel.init()
        super.init(coder: coder)
    }
}
