//
//  RPFromTableVerificationCell.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/12.
//

import UIKit

class RPFromTableVerificationCell: UITableViewCell {
    weak var delegate:RPFromTableCellActionDelegate?
    private var indexPath = IndexPath()
    private var model = RPFromTableModel()
    private var titleLabel = UILabel()
    private var verifiBtn = UIButton()
    private var textfiled = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        titleLabel = UILabel.init()
        contentView.addSubview(titleLabel)
        
        textfiled = UITextField.init()
        textfiled.keyboardType = .numberPad
        contentView.addSubview(textfiled)
        textfiled.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        verifiBtn = UIButton.init()
        verifiBtn.setTitle("获取验证码", for: .normal)
        verifiBtn.backgroundColor = .init(hexString: "#2697FF")
        verifiBtn.titleLabel?.font = .systemFont(ofSize: 14)
        verifiBtn.addTarget(self, action: #selector(verifiBtnClick), for: .touchUpInside)
        contentView.addSubview(verifiBtn)
        verifiBtn.layercornerRadius(cornerRadius: 4)
    }
    
    @objc private func verifiBtnClick() {
        //调接口 成功开始倒计时
        verifiBtn.countDown(count: 60)
    }
    
    //文本变化拦截
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        let textLength = Int.init(text?.count ?? 0)
        if  textLength  > model.maxLength {
            textField.text = String(text?.prefix(model.maxLength) ??  "")
        }
        model.info = textfiled.text ?? ""
        if self.delegate != nil {
            self.delegate?.textfiledDidChangeValue(indexPath, cellData: model)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch model.type {
        case .verification:
            titleLabel.frame = CGRect.init(x: 16, y: 0, width: 100, height: 25)
            titleLabel.center.y = bounds.size.height * 0.5
            
            verifiBtn.isHidden = false
            verifiBtn.frame = CGRect.init(x: bounds.size.width - 16 - 100, y: 0, width: 100, height: 30)
            verifiBtn.center.y = bounds.size.height * 0.5
            
            textfiled.frame = CGRect.init(x: titleLabel.frame.maxX + 10, y: 0, width: verifiBtn.frame.minX - titleLabel.frame.minX - 20, height: 25)
            textfiled.center.y = bounds.size.height * 0.5
            break
        case .inputMid,.inputRight:
            titleLabel.frame = CGRect.init(x: 16, y: 0, width: 100, height: 25)
            titleLabel.center.y = bounds.size.height * 0.5
            textfiled.frame = CGRect.init(x: titleLabel.frame.maxX + 10, y: 0, width:bounds.size.width - titleLabel.frame.minX - 20, height: 25)
            textfiled.center.y = bounds.size.height * 0.5
            
            verifiBtn.isHidden = true
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        //warning ⚠️
        verifiBtn.countdownCancel()
    }
}

extension RPFromTableVerificationCell:RPFromTableCellDataDelegate {
    func setCellData(cellData: RPFromTableModel, delegate: RPFromTableCellActionDelegate, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.model = cellData
        self.titleLabel.text = model.title
        self.titleLabel.font = model.titleFont
        self.titleLabel.textColor = model.titleColor
        
        self.textfiled.text = model.info
        self.textfiled.placeholder = model.textfiledPlaceholder
        self.textfiled.font = model.textfiledFont
        self.textfiled.textColor = model.textfiledColor
        //...
        self.textfiled.textAlignment =  model.type == .inputRight ? .right : .left
    }
}

