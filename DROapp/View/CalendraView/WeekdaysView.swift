


import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Style.themeColor
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(rawValue: klanguagechange) , object: nil)
        setupViews()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        for _ in 0..<7 {
            let lbl=UILabel()
            // lbl.text=daysArr[i]
            lbl.textAlignment = .center
            lbl.textColor = UIColor.white
            myStackView.addArrangedSubview(lbl)
        }
        setText()
    }
    
    
    
    //MARK:- Changes Text on language Changes
    
    @objc func setText()  {
        var daysArr = ["S", "M", "T", "W", "T", "F", "S"]
        
        if let surveySchedule = kUserDefault.value(forKey: ksurvey_schedule) as? [String : Any]
        {
            daysArr.removeAll()
            if let dayString = surveySchedule["28"] as? String{
                daysArr.append(dayString)
            }
            if let dayString = surveySchedule["29"] as? String{
                daysArr.append(dayString)
            }
            if let dayString = surveySchedule["30"] as? String{
                daysArr.append(dayString)
            }
            if let dayString = surveySchedule["31"] as? String{
                daysArr.append(dayString)
            }
            if let dayString = surveySchedule["32"] as? String{
                daysArr.append(dayString)
            }
            if let dayString = surveySchedule["33"] as? String{
                daysArr.append(dayString)
            }
            if let dayString = surveySchedule["34"] as? String{
                daysArr.append(dayString)
            }
        }
        if daysArr.count < 7 {
            daysArr = ["S", "M", "T", "W", "T", "F", "S"]
        }
        var count = 0
        for view in myStackView.subviews {
            if let label = view as? UILabel{
                label.text = String(daysArr[count].prefix(3))
                label.font = UIFont.init(name: kSFRegular, size: 17)
                label.setCustomFont()
                label.textAlignment = .center

                label.sizeToFit()
                count += 1
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: klanguagechange), object: nil)
    }
    
    let myStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
