//
//  RPFollowViewCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/23.
//

import UIKit

class RPFollowViewCell: UITableViewCell {
    
    @IBOutlet weak var authorBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var decrLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.backgroundColor = RPColor.RandomColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
