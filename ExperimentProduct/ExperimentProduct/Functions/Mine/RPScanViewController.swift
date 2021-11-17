//
//  RPScanViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/15.
//

import UIKit
import AVFoundation

protocol RPScanViewControllerDelegate: NSObjectProtocol {
    func didOutput(_ code:String)
    func didReceiveError(_ error: String)
}

//从SwiftScan里面剥离出的一个简单的版本 要多功能还是选SwiftScan现成的
class RPScanViewController: RPBaseViewController {
    
    weak var delegate:RPScanViewControllerDelegate?
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer = AVCaptureVideoPreviewLayer()
    private lazy var scanView = RPScanView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    private var scanCornerColor:UIColor?
    private var scanAnimationImage:UIImage?
    
    convenience init(cornerColor: UIColor?,scanAnimationImage: UIImage?) {
        self.init()
        self.scanCornerColor = cornerColor
        self.scanAnimationImage = scanAnimationImage
        //☁️ 我不理解 ☁️
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        showScanCode()
        
        scanView.cornerColor = self.scanCornerColor ?? RPColor.redWine
        scanView.scanAnimationImage = self.scanAnimationImage ?? UIImage(named: "ScanLine")!
        view.addSubview(scanView)
        
        customNavBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanView.startAnimation()
    }
    
    //创建流区范围
    private func showScanCode() {
        let devices = AVCaptureDevice.devices()
        //1.1默认获取后置摄像头
        guard let captureDevice = devices.filter({$0.position == .back}).first else {
            log.debug("get front video AVCaptureDevice  failed!")
            return
        }
        //输出流
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            log.debug("failed loading input")
            return
        }
        self.captureSession = AVCaptureSession()
        let output = AVCaptureMetadataOutput()
        // 1.判断是否能够将输入添加到会话中
        if !captureSession.canAddInput(input)
        {
            log.debug("failed add input")
            return
        }
        // 2.判断是否能够将输出添加到会话中
        if !captureSession.canAddOutput(output)
        {
            log.debug("failed add output")
            return
        }
        // 3.将输入和输出都添加到会话中
        captureSession.addInput(input)
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //设置扫码类型
        output.metadataObjectTypes = [.ean13,.ean8,.code128,.code39,.code93,.qr]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        output.rectOfInterest = self.calculateScanRect()
        view.layer.addSublayer(videoPreviewLayer)
        // 添加预览图层,必须要插入到最下层的图层
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        // 放大
        do {
            try captureDevice.lockForConfiguration()
        } catch {
            return
        }
        let maxZoomFactor = captureDevice.activeFormat.videoMaxZoomFactor
        let zoomFactor = maxZoomFactor < 2.0 ? maxZoomFactor : 2.0
        captureDevice.videoZoomFactor = zoomFactor
        captureDevice.unlockForConfiguration()
        self.captureSession.startRunning()
    }
    
    private func calculateScanRect() -> CGRect {
        let previewSize: CGSize = self.videoPreviewLayer.frame.size
        let scanSize: CGSize = CGSize(width: previewSize.width * 3/4, height: previewSize.height * 3/4)
        var scanRect:CGRect = CGRect(x: (previewSize.width-scanSize.width)/2,
                                     y: (previewSize.height-scanSize.height)/2, width: scanSize.width, height: scanSize.height);
        // AVCapture输出的图片大小都是横着的，而iPhone的屏幕是竖着的，那么我把它旋转90°
        scanRect = CGRect(x: scanRect.origin.y/previewSize.height,
                          y: scanRect.origin.x/previewSize.width,
                          width: scanRect.size.height/previewSize.height,
                          height: scanRect.size.width/previewSize.width);
        return scanRect
    }
    
    func customNavBar(){
        var navView = UIView()
        navView = UIView.init()
        navView.backgroundColor = .clear
        self.view.addSubview(navView)
        navView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: RPTools.NAV_HEIGHT)
        
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: navView.frame.height - 44, width:navView.frame.width, height: 44))
        navView.addSubview(titleView)
        
        let leftItem = UIButton.init(type: .custom)
        leftItem.frame = CGRect.init(x: 16, y: (titleView.frame.height-30)/2, width: 30, height: 30)
        leftItem.setImage(RPTools.getPngImage(forResource: "back_white@2x"), for: .normal)
        titleView.addSubview(leftItem)
        
        let rightItem = UIButton.init(type: .custom)
        rightItem.frame = CGRect.init(x: titleView.frame.width - 60 - 16, y: (titleView.frame.height-30)/2, width: 60, height: 30)
        rightItem.setTitle("相册", for: .normal)
        rightItem.setTitleColor(.white, for: .normal)
        rightItem.titleLabel?.font = .systemFont(ofSize: 15)
        titleView.addSubview(rightItem)
        
        leftItem.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        rightItem.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        
        let titleLabel = UILabel.init()
        titleLabel.frame = CGRect.init(x: 100, y: (titleView.frame.height-30)/2, width:titleView.frame.width - 200, height: 30)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = "扫一扫"
        titleView.addSubview(titleLabel)
    }
    
    @objc func leftClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rightClick() {
        scanView.pausedAnimation()
        requestPhotoPermission()
    }
    
    //请求相册权限
    func requestPhotoPermission() {
        RPPermissions.request(.photoLibrary) { (status) in
            switch status {
            case .unknown,.restricted,.denied:
                let alert = RPAlertViewController.init(title: "没有相册权限", message: "去设置打开相关权限?", cancel: "取消", confirm: "确定") { (index) in
                    if index == 1 {
                        RPTools.jumpToSystemPrivacySetting()
                    }
                }
                self.present(alert, animated: false,completion: nil)
                break
            case .notDetermined:
                self.requestPhotoPermission()
                break
            case .authorized,.provisional:
                let imagePicker = UUTakePhoto.shared
                imagePicker.delegate = self
                imagePicker.showImagePickerWithType(.photoLibrary, viewController: self,needEditing:false)
                break
            case .noSupport:
                //设备不支持
                self.navigationController?.view.makeToast("设备不支持",
                                                          duration: 3.0,
                                                          position: .top,
                                                          style: RPTools.RPToastStyle)
                break
            }
        }
    }
    
    deinit {
        scanView.stopAnimation()
        log.debug("RPScanViewController deinit")
    }
}

extension RPScanViewController:AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
                return
            }
            self.captureSession.stopRunning()
            delegate?.didOutput(object.stringValue ?? "")
            leftClick()
        }
    }
}

extension RPScanViewController : UUTakePhotoDelegate {
    func imagePicker(_ imagePicker: UUTakePhoto, didFinished editedImage: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            if editedImage != nil {
                let imageData = editedImage!.pngData()
                let ciImage:CIImage = CIImage(data: imageData!)!
                let detector = CIDetector(ofType: CIDetectorTypeQRCode, context:nil,options:[CIDetectorAccuracy:CIDetectorAccuracyHigh])
                let feature = detector?.features(in: ciImage)
                if feature?.count ?? 0 > 0{
                    let f = feature?.first as! CIQRCodeFeature
                    self?.delegate?.didOutput(f.messageString ?? "")
                }else{
                    self?.delegate?.didReceiveError("no result")
                }
            }
            self?.leftClick()
        }
    }
    
    func imagePickerDidCancel(_ imagePicker: UUTakePhoto) {
        scanView.startAnimation()
    }
}
