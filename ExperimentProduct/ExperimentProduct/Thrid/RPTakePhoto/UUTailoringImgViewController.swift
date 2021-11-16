//
//  UUTailoringImgViewController.swift
//  Admins
//
//  Created by hubin on 2021/10/26.
//

import UIKit
import JPImageresizerView

public protocol UUTailoringImgViewControllerDelegate:AnyObject {
    func cdmOptionalPhotoEditVC(_ controller :UIViewController,didFinishCroppingImage croppedImage:UIImage?)
    func cdmCancelPhotoEditVC(_ controller :UIViewController)
}

class UUTailoringImgViewController: UIViewController {
    
    private var imageresizerView = JPImageresizerView()
    var configure = JPImageresizerConfigure()
    weak var delegate:UUTailoringImgViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        imageresizerView = JPImageresizerView.init(configure: self.configure, imageresizerIsCanRecovery: nil, imageresizerIsPrepareToScale: nil)
        imageresizerView.resizeWHScale = 15.0 / 15.0
        self.view.addSubview(imageresizerView)
        
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.view.bounds.size.height - 60, width: self.view.bounds.size.width, height: 60))
        view.backgroundColor = UIColor.init(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 0.7)
        self.view.addSubview(view)
        
        let cancelButton = UIButton.init(type: .custom)
        cancelButton.frame = CGRect.init(x: 16, y: 0, width: 60, height: 60)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelButton.addTarget(self, action:#selector(cancelTailor), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let completelButton = UIButton.init(type: .custom)
        completelButton.frame = CGRect.init(x: self.view.bounds.size.width - 60 - 16, y: 0, width: 60, height: 60)
        completelButton.setTitle("完成", for: .normal)
        completelButton.setTitleColor(.white, for: .normal)
        completelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        completelButton.addTarget(self, action:#selector(rightBtnClick), for: .touchUpInside)
        view.addSubview(completelButton)
    }
    
    func prefersStatusBarHidden()->Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 禁用返回手势
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @objc func cancelTailor()  {
        if self.delegate != nil {
            self.delegate?.cdmCancelPhotoEditVC(self)
        }
    }
    
    @objc func rightBtnClick()  {
        self.imageresizerView.cropPicture(withCacheURL: nil) { (cacheURL, reason) in
            
        } complete: { (result) in
            if self.delegate != nil {
                self.delegate?.cdmOptionalPhotoEditVC(self, didFinishCroppingImage: result?.image)
            }
        }
    }
}

extension UUTailoringImgViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is UUTailoringImgViewController {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
