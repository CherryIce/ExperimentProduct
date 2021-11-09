//
//  RPTopicVideoView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/8.
//

import UIKit
import AVFoundation
import KTVHTTPCache

class RPTopicVideoView: UIView {
    public typealias ClickVideoCallBack = (_ view:UIView)->()
    public var clickVideoCallBack: ClickVideoCallBack?
    private lazy var player = AVPlayer()
    private lazy var playerLayer = AVPlayerLayer(player: player)
    private lazy var contentView = UIView()
    var itemSize:CGSize = .zero {
        didSet {
            contentView.frame = CGRect.init(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            playerLayer.frame = contentView.bounds
        }
    }

    var path = URL.init(string: "") {
        didSet {
            let url = KTVHTTPCache.proxyURL(withOriginalURL:path)
            self.playerLayer.player?.replaceCurrentItem(with: AVPlayerItem.init(url: url!))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView = UIView.init()
        addSubview(contentView)
        
        player = AVPlayer.init()
        if #available(iOS 10.0, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }
        playerLayer = AVPlayerLayer.init(player: player)
        contentView.layer.addSublayer(playerLayer)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func tapClick() {
        self.clickVideoCallBack?(contentView)
    }
    
    func clickCallBack(_ block:@escaping ClickVideoCallBack) {
        self.clickVideoCallBack = block
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

}
