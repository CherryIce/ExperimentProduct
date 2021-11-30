//
//  RPDynamicVideoPlyerContainerView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/3.
//

import UIKit
import AVFoundation
import KTVHTTPCache

class RPDynamicVideoPlyerContainerView: UIView {
    weak var delegate:RPDynamicViewEventDelegate?
    private lazy var player = AVPlayer()
    private lazy var playerLayer = AVPlayerLayer(player: player)
    private lazy var topView = RPDynamicTopView()
    var path = URL.init(string: "") {
        didSet {
            let url = KTVHTTPCache.proxyURL(withOriginalURL:path)
            self.playerLayer.player?.replaceCurrentItem(with: AVPlayerItem.init(url: url!))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        player = AVPlayer.init()
        if #available(iOS 10.0, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }
        playerLayer = AVPlayerLayer.init(player: player)
        layer.addSublayer(playerLayer)
        
        topView = RPDynamicTopView.init()
        topView.delegate = self
        topView.leftItem.setImage(UIImage.loadImage("back_white"), for: .normal)
        topView.rightItem.setImage(UIImage.loadImage("share_white"), for: .normal)
        self.addSubview(topView)
    }
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: RPTools.NAV_HEIGHT)
        playerLayer.frame = bounds
    }
}

extension RPDynamicVideoPlyerContainerView: RPDynamicViewEventDelegate {
    func clickEventCallBack(_ type: RPDynamicViewEventType, _ index: Int?) {
        if self.delegate != nil {
            self.delegate?.clickEventCallBack(type, index)
        }
    }
}
