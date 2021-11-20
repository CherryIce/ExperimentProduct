//
//  RPVideoBrowserCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/20.
//

import UIKit
import JXPhotoBrowser
import AVFoundation
import KTVHTTPCache

class RPVideoBrowserCell: UIView, JXPhotoBrowserCell {
    
    weak var photoBrowser: JXPhotoBrowser?
    lazy var player = AVPlayer()
    lazy var playerLayer = AVPlayerLayer(player: player)
    var path = URL.init(string: "") {
        didSet {
            let url = KTVHTTPCache.proxyURL(withOriginalURL:path)
            self.playerLayer.player?.replaceCurrentItem(with: AVPlayerItem.init(url: url!))
        }
    }
    
    static func generate(with browser: JXPhotoBrowser) -> Self {
        let instance = Self.init(frame: .zero)
        instance.photoBrowser = browser
        return instance
    }
    
    required override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(click))
        addGestureRecognizer(tap)
        
        player = AVPlayer.init()
        if #available(iOS 10.0, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }
        playerLayer = AVPlayerLayer.init(player: player)
        layer.addSublayer(playerLayer)
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
        playerLayer.frame = bounds
    }
    
    @objc private func click() {
        photoBrowser?.dismiss()
    }
    
}
