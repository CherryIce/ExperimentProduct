//
//  UUTakePhoto.swift
//  Admins
//
//  Created by hubin on 2021/10/26.
//

import UIKit
import JPImageresizerView

protocol UUTakePhotoDelegate:AnyObject {
    func imagePicker(_ imagePicker :UUTakePhoto,didFinished editedImage:UIImage?)
    func imagePickerDidCancel(_ imagePicker :UUTakePhoto)
}

class UUTakePhoto: NSObject {
    static let shared = UUTakePhoto()
    private var tailoringImgVC:UUTailoringImgViewController?
    private var imagePickerController:UIImagePickerController?
    private var configure:JPImageresizerConfigure?
    weak var delegate:UUTakePhotoDelegate?
    var needEditing:Bool = false
    
    override init() {
        log.warning("⚠️⚠️ Use \"shared\" , otherwise the agent that will UIImagePickerController will not execute")
    }
    
    func showImagePickerWithType(_ type:UIImagePickerController.SourceType,
                                 viewController:UIViewController,
                                 needEditing:Bool = false){
        DispatchQueue.main.async {
            self.needEditing = needEditing
            self.imagePickerController = UIImagePickerController.init()
            self.imagePickerController?.delegate = self
            self.imagePickerController?.sourceType =  type
            if #available(iOS 11, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .automatic
            }
            self.imagePickerController?.modalPresentationStyle = .fullScreen
            viewController.present(self.imagePickerController!, animated: true,completion: nil)
        }
    }
}

extension UUTakePhoto : UUTailoringImgViewControllerDelegate {
    func cdmOptionalPhotoEditVC(_ controller: UIViewController, didFinishCroppingImage croppedImage: UIImage?) {
        if (self.delegate) != nil {
            self.delegate?.imagePicker(self, didFinished: croppedImage)
        }
        if #available(iOS 11, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        controller.dismiss(animated: true) {
            self.configure = nil
            self.tailoringImgVC = nil
        }
    }
    
    func cdmCancelPhotoEditVC(_ controller :UIViewController) {
        self.imagePickerController?.delegate = self
        let pickerVC = controller.navigationController as! UIImagePickerController
        if (pickerVC.sourceType == .camera) {
            controller.navigationController?.dismiss(animated: true, completion: {
                self.configure = nil
                self.tailoringImgVC = nil
            })
        }else{
            controller.navigationController?.popViewController(animated: true)
        }
    }
}

extension UUTakePhoto : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if (self.delegate) != nil {
            self.delegate?.imagePickerDidCancel(self)
        }
        picker.dismiss(animated: true) {
            self.imagePickerController = nil//回收资源
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = UIImage()
        if ((info[UIImagePickerController.InfoKey.editedImage]) != nil) {
            selectedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        }else if((info[UIImagePickerController.InfoKey.originalImage]) != nil){
            selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        }
        self.configure = JPImageresizerConfigure.defaultConfigure(with: selectedImage, make: { (configure) in
            configure.frameType = JPImageresizerFrameType.classicFrameType
        })
        
        if needEditing {
            self.tailoringImgVC = UUTailoringImgViewController.init()
            self.tailoringImgVC?.configure = self.configure!
            self.tailoringImgVC?.delegate = self
            picker.pushViewController(self.tailoringImgVC!, animated: true)
        }else{
            if (self.delegate) != nil {
                self.delegate?.imagePicker(self, didFinished: selectedImage)
            }
            if #available(iOS 11, *) {
                UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            }
            picker.dismiss(animated: true) {
                self.imagePickerController = nil
            }
        }
    }
}
