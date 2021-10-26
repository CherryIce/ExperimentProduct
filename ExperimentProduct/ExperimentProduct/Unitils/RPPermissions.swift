//
//  RPPermissions.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/10/26.
//

import UIKit
import Photos

class RPPermissions: NSObject {
    
    enum RPPermissionType: Int {
        ///相机
        case camera = 0
        ///相册
        case photoLibrary = 1
        ///麦克风
        case microphone = 2
    }
    ///是否允许权限
    class func isAllowed(_ permission: RPPermissionType) -> Bool {
        let manager = getManagerForPermission(permission)
        return manager.isAuthorized
    }
    ///是否拒绝权限
    class func isDenied(_ permission: RPPermissionType) -> Bool {
        let manager = getManagerForPermission(permission)
        return manager.isDenied
    }
    ///请求权限
    class func request(_ permission: RPPermissionType, with сompletionCallback: ((RPAuthorizationStatus)->())? = nil) {
        let manager = getManagerForPermission(permission)
        manager.request { (status) in
            DispatchQueue.main.async {
                сompletionCallback?(status)
            }
        }
    }

}

extension RPPermissions {
    private class func getManagerForPermission(_ permission: RPPermissionType) -> RPPermissionInterface {
        switch permission {
        case .camera:
            return RPCameraPermission()
        case .photoLibrary:
            return RPPhotoLibraryPermission()
        case .microphone:
            return RPMicrophonePermission()
        }
    }
}

enum RPAuthorizationStatus {
    ///未知状态
    case unknown
    ///用户未选择
    case notDetermined
    ///用户没有权限
    case restricted
    ///拒绝
    case denied
    ///允许
    case authorized
    ///临时允许
    case provisional
    ///设备不支持
    case noSupport
    ///是否可以访问
    var isAuthorized: Bool {
        return self == .authorized || self == .provisional
    }
    ///是否不支持
    var isNoSupport: Bool {
        return self == .noSupport
    }
}

protocol RPPermissionInterface {
    ///是否允许
    var isAuthorized: Bool { get }
    ///是否拒绝
    var isDenied: Bool { get }
    ///请求权限
    func request(сompletionCallback: ((RPAuthorizationStatus)->())?)
}

extension RPPermissionInterface {
    var isAuthorized: Bool {
        return false
    }
    ///是否拒绝
    var isDenied: Bool {
        return false
    }
    ///请求权限
    func request(сompletionCallback: ((RPAuthorizationStatus) -> ())?) {
        
    }
}

/// 相册权限
struct RPPhotoLibraryPermission: RPPermissionInterface {
    
    var isAuthorized: Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    var isDenied: Bool {
        return PHPhotoLibrary.authorizationStatus() == .denied
    }
    func request(сompletionCallback: ((RPAuthorizationStatus)->())?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var authorizationStatus: RPAuthorizationStatus = .unknown
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                authorizationStatus = .authorized
            case .notDetermined:
                authorizationStatus = .notDetermined
            case .restricted:
                authorizationStatus = .restricted
            case .denied:
                authorizationStatus = .denied
            default:
                authorizationStatus = .unknown
            }
            if authorizationStatus == .notDetermined {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        authorizationStatus = .authorized
                    }else if status == .denied {
                        authorizationStatus = .denied
                    }
                    сompletionCallback?(authorizationStatus)
                }
            }else {
                сompletionCallback?(authorizationStatus)
            }
        }else {
            сompletionCallback?(.noSupport)
        }
    }
}

/// 相机权限
struct RPCameraPermission: RPPermissionInterface {
    var isAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized
    }
    var isDenied: Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.denied
    }
    func request(сompletionCallback: ((RPAuthorizationStatus)->())?) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var authorizationStatus: RPAuthorizationStatus = .unknown
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                authorizationStatus = .authorized
            case .notDetermined:
                authorizationStatus = .notDetermined
            case .restricted:
                authorizationStatus = .restricted
            case .denied:
                authorizationStatus = .denied
            default:
                authorizationStatus = .unknown
            }
            if authorizationStatus == .notDetermined {
                AVCaptureDevice.requestAccess(for: .video) { (authorized) in
                    сompletionCallback?(authorized ? .authorized : .denied)
                }
            }else {
                сompletionCallback?(authorizationStatus)
            }
        }else {
            сompletionCallback?(.noSupport)
        }
    }
}

///麦克风权限
struct RPMicrophonePermission: RPPermissionInterface {
    var isAuthorized: Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    var isDenied: Bool {
        return AVAudioSession.sharedInstance().recordPermission == .denied
    }
    func request(сompletionCallback: ((RPAuthorizationStatus)->())?) {
        if AVAudioSession.sharedInstance().isInputAvailable {
            var authorizationStatus: RPAuthorizationStatus = .unknown
            switch AVAudioSession.sharedInstance().recordPermission {
            case .undetermined:
                authorizationStatus = .notDetermined
            case .granted:
                authorizationStatus = .authorized
            case .denied:
                authorizationStatus = .denied
            default:
                authorizationStatus = .unknown
            }
            if authorizationStatus == .notDetermined {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    сompletionCallback?(granted ? .authorized : .denied)
                }
            }else {
                сompletionCallback?(authorizationStatus)
            }
        }else {
            сompletionCallback?(.noSupport)
        }
    }
}
