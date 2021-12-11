//
//  RPVideoDynamicCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/3.
//

import UIKit
import IGListKit

class RPVideoDynamicCell: UICollectionViewCell {
    weak var delegate:RPDynamicViewEventDelegate?
    lazy var playerContainerView = RPDynamicVideoPlyerContainerView()
    var path = URL.init(string: "") {
        didSet {
            self.playerContainerView.path = path
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        playerContainerView = RPDynamicVideoPlyerContainerView.init(frame: frame)
        playerContainerView.delegate = self
        self.addSubview(playerContainerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerContainerView.frame = bounds
    }
    
    func playVideo() {
        self.playerContainerView.play()
    }
    
    func pauseVideo() {
        self.playerContainerView.pause()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RPVideoDynamicCell: RPDynamicViewEventDelegate {
    func clickEventCallBack(_ type: RPDynamicViewEventType, _ index: Int?) {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(type, index)
        }
    }
}

extension RPVideoDynamicCell : ListBindable {
    func bindViewModel(_ viewModel: Any) {
//        guard let viewModel = viewModel as? RPUserModel else { return }
//        userButton.setImage(UIImage.loadImage("mine_nor"), for: .normal)
//        userButton.setTitle(viewModel.name, for: .normal)
    }
}
