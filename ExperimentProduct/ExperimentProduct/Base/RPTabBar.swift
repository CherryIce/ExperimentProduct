//
//  RPTabBar.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/24.
//

import UIKit
import Then

protocol RPTabBarwEventDelegate:NSObjectProtocol {
    func clickTabBarEventCallBack(_ index:Int)
}

class RPTabBar: UIView {
    weak var delegate:RPTabBarwEventDelegate?
    var selectedBtn:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(_ titles:[String]) {
        self.init()
        
        for title in titles {
            let btn = UIButton.init(type: .custom).then {
                $0.setTitle(title, for: .normal)
                $0.setTitleColor(.lightGray, for: .normal)
                $0.setTitleColor(RPColor.redWine, for: .selected)
                $0.tag = self.subviews.count
                $0.titleLabel?.font = .systemFont(ofSize: 15)
            }
            self.addSubview(btn)
            
            btn.addTarget(self, action: #selector(tabbarClick), for: .touchUpInside)
            
            if btn.tag == 0 {
                btn.isSelected = true
                selectedBtn = btn
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabbarClick(_ sender:UIButton) {
        if sender.tag == selectedBtn?.tag {
            return
        }
        selectedBtn?.isSelected = false
        sender.isSelected = true
        selectedBtn = sender
        
        if self.delegate != nil {
            self.delegate?.clickTabBarEventCallBack(sender.tag)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let btnW = bounds.width/CGFloat(self.subviews.count)
        let btnH = bounds.height
        let btnY = 0.0
        
        for i in 0..<self.subviews.count {
            let btn = self.subviews[i]
            btn.frame = CGRect(x: btnW*CGFloat(i), y: btnY, width: btnW, height: btnH)
        }
    }
}
