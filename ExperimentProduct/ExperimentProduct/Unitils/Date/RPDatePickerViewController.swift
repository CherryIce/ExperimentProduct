//
//  RPDatePickerViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/11/17.
//

import UIKit
import Then

enum RPDatePickerMode {
    case year
    case yearMonth
    case yearMonthDay
}

class RPDatePickerViewController: RPBaseViewController {

    public typealias SelectedDateCallBack = (_ date:Date)->()
    public var selectedDateCallBack: SelectedDateCallBack?
    private var datePickerMode:RPDatePickerMode = .year
    private var minimumDate = Date()
    private var maximumDate = Date()
    private var currentDate = Date()
    private var datePicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.modalPresentationStyle = .overFullScreen
        datePickerAction()
    }
    
    func datePickerAction()
    {
        //创建日期选择器
        datePicker = UIPickerView.init()
        datePicker.backgroundColor = .white
        datePicker.delegate = self
        datePicker.dataSource = self
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()//.offset(-RPTools.BottomPadding)
            make.height.equalTo(300+RPTools.BottomPadding)
        }
        scroll()
        
        let topV = UIView.init()
        topV.backgroundColor = .white
        view.addSubview(topV)
        topV.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(datePicker.snp_top)
            make.height.equalTo(45)
        }
        
        let cancelBtn = UIButton.init(type: .custom).then {
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.setTitle("取消", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        cancelBtn.addTarget(self, action: #selector(miss), for: .touchUpInside)
        topV.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        let okBtn = UIButton.init(type: .custom).then {
            $0.titleLabel?.font = .systemFont(ofSize: 16)
            $0.setTitle("确认", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        okBtn.addTarget(self, action: #selector(dateChanged), for: .touchUpInside)
        topV.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc func miss(){
        dismiss(animated: true, completion: nil)
    }

    @objc func dateChanged(){
        let year = datePicker.selectedRow(inComponent: 0)
        var final = String(getYears()[year])+"年"
        var date = Date.init()
        switch datePickerMode {
        case .year:
            date = final.toDate("yyyy年")
            break
        case .yearMonth:
            let month = datePicker.selectedRow(inComponent: 1)
            final = String(format: "%@%d月", final,getMonths()[month])
            date = final.toDate("yyyy年MM月")
            break
        case .yearMonthDay:
            let month = datePicker.selectedRow(inComponent: 1)
            let day = datePicker.selectedRow(inComponent: 2)
            final = String(format: "%@%d月", final,getMonths()[month])
            final = String(format: "%@%d日", final,getDays()[day])
            date = final.toDate("yyyy年MM月dd日")
            break
        }
//         NSCalendar.current.dateComponents([.year,.month,.day], from: date)
        self.selectedDateCallBack?(date)
        miss()
    }

    public convenience init(datePickerMode:RPDatePickerMode = .year,
                            minimumDate:Date = .init(timeIntervalSince1970: 0),
                            maximumDate:Date = .init(),
                            currentDate:Date = .init(),
                            clickCallBack: SelectedDateCallBack?) {
        self.init()
        self.datePickerMode = datePickerMode
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.currentDate = currentDate
        self.selectedDateCallBack = clickCallBack
        self.modalPresentationStyle = .overFullScreen
    }
    
    //初始位置
    func scroll()  {
        var year = 0
        var month = 0
        var day = 0
        for i in 0 ..< getYears().count {
            if currentDate.calculateYear() == getYears()[i] {
                year = i
            }
        }
        for i in 0 ..< getMonths().count {
            if currentDate.calculateMonth() == getMonths()[i] {
                month = i
            }
        }
        for i in 0 ..< getDays().count {
            if currentDate.calculateDay() == getDays()[i] {
                day = i
            }
        }
        switch datePickerMode {
        case .year:
            datePicker.selectRow(year, inComponent: 0, animated: true)
            break
        case .yearMonth:
            datePicker.selectRow(year, inComponent: 0, animated: true)
            datePicker.selectRow(month, inComponent: 1, animated: true)
            break
        case .yearMonthDay:
            datePicker.selectRow(year, inComponent: 0, animated: true)
            datePicker.selectRow(month, inComponent: 1, animated: true)
            datePicker.selectRow(day, inComponent: 2, animated: true)
            break
        }
    }
}

extension RPDatePickerViewController {
    //年
    func getYears() -> [Int] {
        let years = NSMutableArray.init()
        for i in minimumDate.calculateYear() ... maximumDate.calculateYear() {
            years.add(i)
        }
        return years as! [Int]
    }
    //月
    func getMonths() -> [Int] {
//        let result = NSCalendar.current.range(of: .month, in: .year, for: currentDate)
        //一年固定12个月就不去计算了
        let months = NSMutableArray.init()
        var min = 1
        var max = 12
        if currentDate.calculateYear() == minimumDate.calculateYear() {
            min = minimumDate.calculateMonth()
        }
        if currentDate.calculateYear() == maximumDate.calculateYear() {
            max = maximumDate.calculateMonth()
        }
        for i in min ... max {
            months.add(i)
        }
        return months as! [Int]
    }
    //日
    func getDays() -> [Int] {
        var day = currentDate.calculateOneMonthDays()
        let days = NSMutableArray.init()
        var min = 1
        if currentDate.isSameMonth(minimumDate) {
            min = minimumDate.calculateDay()
        }
        if currentDate.isSameMonth(maximumDate) {
            day = maximumDate.calculateDay()
        }
        for i in min ... day {
            days.add(i)
        }
        return days as! [Int]
    }
    //时
    func getHours() -> [Int] {
//        let result = NSCalendar.current.range(of: .hour, in: .day, for: currentDate)
        //一天24小时固定 不去计算
        let hours = NSMutableArray.init()
        var min = 0
        var max = 23
        if currentDate.isSameDay(minimumDate) {
            min = NSCalendar.current.component(.hour, from: minimumDate)
        }
        if currentDate.isSameDay(maximumDate) {
            max = NSCalendar.current.component(.hour, from: maximumDate)
        }
        for i in min ... max {
            hours.add(i)
        }
        return hours as! [Int]
    }
    //分
    func getMinutes() -> [Int] {
//        let result = NSCalendar.current.range(of: .minute, in: .hour, for: currentDate)
        //一个小时固定60分 不去计算
        let mins = NSMutableArray.init()
        var min = 0
        var max = 59
        if currentDate.isSameDay(minimumDate) {
            min = NSCalendar.current.component(.minute, from: minimumDate)
        }
        if currentDate.isSameDay(maximumDate) {
            max = NSCalendar.current.component(.minute, from: maximumDate)
        }
        for i in min ... max {
            mins.add(i)
        }
        return mins as! [Int]
    }
    //秒
    func getSeconds() -> [Int] {
//        let result = NSCalendar.current.range(of: .second, in: .minute, for: currentDate)
        //一分钟固定60秒 不去计算
        let seconds = NSMutableArray.init()
        var min = 0
        var max = 59
        if currentDate.isSameDay(minimumDate) {
            min = NSCalendar.current.component(.second, from: minimumDate)
        }
        if currentDate.isSameDay(maximumDate) {
            max = NSCalendar.current.component(.second, from: maximumDate)
        }
        for i in min ... max {
            seconds.add(i)
        }
        return seconds as! [Int]
    }
    //计算有多少列
    func calculateNumbersOfComponents() -> Int {
        var nums = 1
        switch datePickerMode {
        case .year:
            nums = 1
            break
        case .yearMonth:
            nums  = 2
            break
        case .yearMonthDay:
            nums = 3
            break
        }
        return nums
    }
    //计算一列有多少行
    func calculateNumberRowsInComponent(_ component:Int) -> [Int] {
        switch datePickerMode {
        case .year:
            return getYears()
        case .yearMonth:
            return component == 0 ? getYears() : getMonths()
        case .yearMonthDay:
            if component == 0 {
                return getYears()
            }else if component == 1 {
                return getMonths()
            }else{
                return getDays()
            }
        }
    }
    //纠正时间
    func adjustDate() {
        if currentDate.compare(minimumDate) == .orderedAscending {
            currentDate = minimumDate
        }
        if currentDate.compare(maximumDate) == .orderedDescending {
            currentDate = maximumDate
        }
    }
    //纠正范围
    func adjustRange(_ index:Int,min:Int,max:Int) -> Int {
        if index < min {
            return min
        }
        if index > max {
            return max
        }
        return index
    }
}

extension RPDatePickerViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return calculateNumbersOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calculateNumberRowsInComponent(component).count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(calculateNumberRowsInComponent(component)[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch datePickerMode {
        case .year:
            let tmp = String(format: "%d年", getYears()[row])
            currentDate = tmp.toDate("yyyy年")
            adjustDate()
            break
        case .yearMonth:
            if component == 0 {
                let tmp = String(format: "%d年%d月", getYears()[row])
                currentDate = tmp.toDate("yyyy年MM月")
                pickerView.reloadComponent(1)
            }else{
                let tmp = String(format: "%d年%d月", currentDate.calculateYear(),getMonths()[row])
                currentDate = tmp.toDate("yyyy年MM月")
                adjustDate()
            }
            break
        case .yearMonthDay:
            let format = "yyyy年MM月dd日"
            let xxx = currentDate.toString(format)
            if component == 0 {
                let xxx = currentDate.toString(format)
                let tt = xxx.components(separatedBy: "年")
                let newX = String(getYears()[row])+"年"+tt.last!
                currentDate = newX.toDate(format)
                adjustDate()
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
            }else if component == 1 {
                //先处理月份 再去处理月份里面的日期
                let aaa = String(currentDate.calculateYear())+"年"+String(getMonths()[row])+"月"
                let axc = aaa.toDate("yyyy年MM月")
                var ad = currentDate.calculateDay()
                currentDate = axc
                ad = adjustRange(ad, min: getDays().first!, max: getDays().last!)
                let tmp = String(format: "%d年%d月%d日", currentDate.calculateYear(),currentDate.calculateMonth(),ad)
                currentDate = tmp.toDate(format)
                adjustDate()
                pickerView.reloadComponent(2)
            }else{
                let tt = xxx.components(separatedBy: "月")
                let newX = tt.first!+"月"+String(getDays()[row])+"日"
                currentDate = newX.toDate(format)
                adjustDate()
            }
            scroll()
            break
        }
    }
}
