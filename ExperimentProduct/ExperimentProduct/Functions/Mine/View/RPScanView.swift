//
//  RPScanView.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/15.
//

import UIKit

class RPScanView: UIView {
    
    // 扫描动画图片
    lazy var scanAnimationImage = UIImage()
    
    // 边框线颜色，默认白色
    public lazy var borderColor = UIColor.white
    
    // 边框线宽度，默认0.2
    public lazy var borderLineWidth:CGFloat = 0.2
    
    // 边角颜色，默认红色
    public lazy var cornerColor = UIColor.red
    
    // 边角宽度，默认2.0
    public lazy var cornerWidth:CGFloat = 2.0
    
    // 扫描区周边颜色的 alpha 值，默认 0.6
    public lazy var backgroundAlpha:CGFloat = 0.6
    
    
    // 扫描区的宽度跟屏幕宽度的比
    public lazy var scanBorderWidthRadio:CGFloat = 0.6
    
    // 扫描区的宽度
    lazy var scanBorderWidth = scanBorderWidthRadio * SCREEN_WIDTH
    
    lazy var scanBorderHeight = scanBorderWidth
    
    // 扫描区的x值
    lazy var scanBorderX = 0.5 * (1 - scanBorderWidthRadio) * SCREEN_WIDTH
    
    // 扫描区的y值
    lazy var scanBorderY = 0.5 * (SCREEN_HEIGHT - scanBorderWidth)
    
    lazy var contentView = UIView(frame: CGRect(x: scanBorderX, y: scanBorderY, width: scanBorderWidth, height:scanBorderHeight))
    
    // 提示文字
    public lazy var tips = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        drawScan(rect)
        
        var rect:CGRect?
        
        let imageView = UIImageView(image: scanAnimationImage.changeColor(cornerColor))
        
        rect = CGRect(x: 0 , y: -(12 + 20), width: scanBorderWidth , height: 12)
        
        contentView.backgroundColor = .clear
        
        contentView.clipsToBounds = true
        
        addSubview(contentView)
        
        ScanAnimation.shared.startWith(rect!, contentView, imageView: imageView)
        
        setupTips()
        
    }
}

extension RPScanView{
    
    func setupTips() {
        
        if tips == "" {
            return
        }
        
        let tipsLbl = UILabel.init()
        
        tipsLbl.text = tips
        
        tipsLbl.textColor = .white
        
        tipsLbl.textAlignment = .center
        
        tipsLbl.font = UIFont.systemFont(ofSize: 13)
        
        addSubview(tipsLbl)
        
        tipsLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([tipsLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                     tipsLbl.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
                                     tipsLbl.widthAnchor.constraint(equalToConstant: SCREEN_WIDTH),
                                     tipsLbl.heightAnchor.constraint(equalToConstant: 14)])
        
    }
    
    func startAnimation() {
        ScanAnimation.shared.startAnimation()
    }
    
    func pausedAnimation() {
        ScanAnimation.shared.pausedAnimation()
    }
    
    func stopAnimation() {
        ScanAnimation.shared.stopAnimation()
    }
    
    
    /// 绘制扫码效果
    func drawScan(_ rect: CGRect) {
        
        /// 空白区域设置
        UIColor.black.withAlphaComponent(backgroundAlpha).setFill()
        
        UIRectFill(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        // 获取上下文，并设置混合模式 -> destinationOut
        context?.setBlendMode(.destinationOut)
        
        // 设置空白区
        let bezierPath = UIBezierPath(rect: CGRect(x: scanBorderX + 0.5 * borderLineWidth, y: scanBorderY + 0.5 * borderLineWidth, width: scanBorderWidth - borderLineWidth, height: scanBorderHeight - borderLineWidth))
        
        bezierPath.fill()
        
        // 执行混合模式
        context?.setBlendMode(.normal)
        
        /// 边框设置
        let borderPath = UIBezierPath(rect: CGRect(x: scanBorderX, y: scanBorderY, width: scanBorderWidth, height: scanBorderHeight))
        
        borderPath.lineCapStyle = .butt
        
        borderPath.lineWidth = borderLineWidth
        
        borderColor.set()
        
        borderPath.stroke()
        
        //角标长度
        let cornerLenght:CGFloat = 20
        
        /// 左上角角标
        let leftTopPath = UIBezierPath()
        
        leftTopPath.lineWidth = cornerWidth
        
        cornerColor.set()
        
        leftTopPath.move(to: CGPoint(x: scanBorderX, y: scanBorderY + cornerLenght))
        
        leftTopPath.addLine(to: CGPoint(x: scanBorderX, y: scanBorderY))
        
        leftTopPath.addLine(to: CGPoint(x: scanBorderX + cornerLenght, y: scanBorderY))
        
        leftTopPath.stroke()
        
        /// 左下角角标
        let leftBottomPath = UIBezierPath()
        
        leftBottomPath.lineWidth = cornerWidth
        
        cornerColor.set()
        
        leftBottomPath.move(to: CGPoint(x: scanBorderX + cornerLenght, y: scanBorderY + scanBorderHeight))
        
        leftBottomPath.addLine(to: CGPoint(x: scanBorderX, y: scanBorderY + scanBorderHeight))
        
        leftBottomPath.addLine(to: CGPoint(x: scanBorderX, y: scanBorderY + scanBorderHeight - cornerLenght))
        
        leftBottomPath.stroke()
        
        /// 右上角小图标
        let rightTopPath = UIBezierPath()
        
        rightTopPath.lineWidth = cornerWidth
        
        cornerColor.set()
        
        rightTopPath.move(to: CGPoint(x: scanBorderX + scanBorderWidth - cornerLenght, y: scanBorderY))
        
        rightTopPath.addLine(to: CGPoint(x: scanBorderX + scanBorderWidth, y: scanBorderY))
        
        rightTopPath.addLine(to: CGPoint(x: scanBorderX + scanBorderWidth, y: scanBorderY + cornerLenght))
        
        rightTopPath.stroke()
        
        /// 右下角小图标
        let rightBottomPath = UIBezierPath()
        
        rightBottomPath.lineWidth = cornerWidth
        
        cornerColor.set()
        
        rightBottomPath.move(to: CGPoint(x: scanBorderX + scanBorderWidth, y: scanBorderY + scanBorderHeight - cornerLenght))
        
        rightBottomPath.addLine(to: CGPoint(x: scanBorderX + scanBorderWidth, y: scanBorderY + scanBorderHeight))
        
        rightBottomPath.addLine(to: CGPoint(x: scanBorderX + scanBorderWidth - cornerLenght, y: scanBorderY + scanBorderHeight))
        
        rightBottomPath.stroke()
        
        
    }
    
}

class ScanAnimation:NSObject{
    
    static let shared:ScanAnimation = {
        
        let instance = ScanAnimation()
        
        return instance
    }()
    
    lazy var animationImageView = UIImageView()
    
    var displayLink:CADisplayLink?
    
    var tempFrame:CGRect?
    
    var contentHeight:CGFloat?
    
    func startWith(_ rect:CGRect, _ parentView:UIView, imageView:UIImageView) {
        
        tempFrame = rect
        
        imageView.frame = tempFrame ?? CGRect.zero
        
        animationImageView = imageView
        
        contentHeight = parentView.bounds.height
        
        parentView.addSubview(imageView)
        
        setupDisplayLink()
        
    }
    
    
    @objc func animation() {
        
        if animationImageView.frame.maxY > contentHeight! + 20 {
            animationImageView.frame = tempFrame ?? CGRect.zero
        }
        
        animationImageView.transform = CGAffineTransform(translationX: 0, y: 2).concatenating(animationImageView.transform)
        
    }
    
    
    func setupDisplayLink() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(animation))
        
        displayLink?.add(to: .current, forMode: .common)
        
        displayLink?.isPaused = true
    }
    
    
    func startAnimation() {
        displayLink?.isPaused = false
    }
    
    func pausedAnimation() {
        displayLink?.isPaused = true
    }
    
    func stopAnimation() {
        
        displayLink?.invalidate()
        
        displayLink = nil
        
    }
}
