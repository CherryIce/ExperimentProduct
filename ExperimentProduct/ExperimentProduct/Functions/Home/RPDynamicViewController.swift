//
//  RPDynamicViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/1.
//

import UIKit

enum RPDynamicViewControllerType {
    case pictures
    case video
}

class RPDynamicViewController: RPBaseViewController {
    
    var transitionView:UIView?
    var type:RPDynamicViewControllerType = .pictures
    private lazy var pictureMainView = RPPicturesDynamicView()
    private lazy var videoMainView = RPVideoDynamicView()
    var model = RPNiceModel()
    
    public convenience init(dynamicType:RPDynamicViewControllerType = .pictures,model:RPNiceModel) {
        self.init()
        self.type = dynamicType
        self.model = model
        initUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func initUI()  {
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: RPTools.NAV_HEIGHT))
        self.view.addSubview(topView)
        
        let leftItem = UIButton.init(type: .custom)
        leftItem.setImage(RPImage.NavBackImage, for: .normal)
        leftItem.addTarget(self, action: #selector(leftClick), for: .touchUpInside)
        topView.addSubview(leftItem)
        
        leftItem.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
            make.left.equalToSuperview().offset(16)
        }
        
        
        let mainFrame = CGRect.init(x: 0, y: topView.frame.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - topView.frame.maxY)
        
        switch type {
        case .pictures:
            pictureMainView = RPPicturesDynamicView.init(frame: mainFrame)
            pictureMainView.model = model
            self.view.addSubview(pictureMainView)
            break
        case .video:
            videoMainView = RPVideoDynamicView.init(frame: mainFrame)
            self.view.addSubview(videoMainView)
            break
        }
    }
    
    @objc func leftClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
