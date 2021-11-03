//
//  RPVideoDynamicCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/3.
//

import UIKit

class RPVideoDynamicCell: UICollectionViewCell {
    weak var delegate:RPDynamicViewEventDelegate?
    private var imageView = UIImageView()
    // 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    // 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
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
        
        imageView = UIImageView.init()
        imageView.isHidden = true
        self.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerContainerView.frame = bounds
        imageView.frame = bounds
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
