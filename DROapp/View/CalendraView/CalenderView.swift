


import UIKit

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.white
    static var monthViewBtnRightColor = UIColor.black
    static var monthViewBtnLeftColor = UIColor.black
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor.black
    static var themeColor = UIColor.init(red: 0.1333, green: 0.1569, blue: 0.1843, alpha: 1.0)
    static var previuosDateColor = UIColor.init(red: 0.3922, green: 0.4078, blue: 0.4235, alpha: 1.0)
    static var selectedDateColor = UIColor.white
    static var selectedDateTextColor = UIColor.init(red: 0.0000, green: 0.6235, blue: 0.8314, alpha: 1.0)

    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    var delegate: CalenderDelegate?
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 7   //(Sunday-Saturday 1-7)
  
    var bookedSlotDate = [33]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        self.backgroundColor = Style.themeColor
        myCollectionView.delegate=self
        myCollectionView.backgroundColor = Style.themeColor
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        
        cell.backgroundColor = UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            let calcDate = indexPath.row-firstWeekDayOfMonth+2
            cell.isHidden=false
            cell.dateLbl.text="\(calcDate)"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.current// TimeZone(abbreviation: "UTC")
            //let utcTimeZoneStr = formatter.string(from: "\(currentYear)-\(currentMonthIndex)-\(calcDate)")
            let newDate = formatter.date(from: "\(currentYear)-\(currentMonthIndex)-\(calcDate)")
            let epoch = (newDate?.timeIntervalSince1970)! * 1000
            if calcDate == todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex , collectionView.indexPathsForSelectedItems?.count  == 0 {
                // cell.backgroundColor = UIColor(red: 0.9255, green: 0.7686, blue: 0.1843, alpha: 1.0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                cell.backgroundColor = UIColor.white
                cell.dateLbl.textColor = UIColor.appButtonColor
                cell.isUserInteractionEnabled=true
            }else if  bookedSlotDate.contains(Int(epoch)) {
                   // cell.backgroundColor = UIColor.white
                cell.isUserInteractionEnabled=true
                cell.dateLbl.textColor = UIColor.white
            }else{
                    cell.isUserInteractionEnabled=false
                    cell.dateLbl.textColor = Style.previuosDateColor
            }

             //   else if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex  {
//                cell.isUserInteractionEnabled=true
//                cell.dateLbl.textColor = Style.previuosDateColor
//            }  else {
//                cell.isUserInteractionEnabled=true
//                cell.dateLbl.textColor = Style.selectedDateColor
//            }
            
            /* else if bookedSlotDate.contains(calcDate){
             cell.isUserInteractionEnabled=true
             cell.dateLbl.textColor = UIColor.red
             }
             */
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        //let utcTimeZoneStr = formatter.string(from: "\(currentYear)-\(currentMonthIndex)-\(calcDate)")
        let newDate = formatter.date(from: "\(currentYear)-\(currentMonthIndex)-\(calcDate)")
        
        let epoch = (newDate?.timeIntervalSince1970)! * 1000
        
        if  bookedSlotDate.contains(Int(epoch)) {
            cell?.backgroundColor=UIColor.clear
            if let lbl = cell?.subviews[1] as? UILabel {
                lbl.textColor=UIColor.appButtonColor
            }
            cell?.backgroundColor = UIColor.white

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
           // selectedDate = dateFormatter.string(from: newDate)
           // delegate?.didTapDate(date: "Date:\(calcDate)/\(currentMonthIndex)/\(currentYear)", available: true)
            delegate?.didTapDate(date: dateFormatter.string(from: newDate!), available: true)
        } else {
//            cell?.backgroundColor = UIColor.white
//            let lbl = cell?.subviews[1] as! UILabel
//            lbl.textColor=Style.selectedDateTextColor
//            delegate?.didTapDate(date: "", available: false)

        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        let calcDate = indexPath.row-firstWeekDayOfMonth+2
        if  bookedSlotDate.contains(calcDate) {
            cell?.backgroundColor=UIColor.clear
            if  let lbl = cell?.subviews[1] as? UILabel {
                lbl.textColor=UIColor.red
            }
        } else {
            cell?.backgroundColor=UIColor.clear
            if  let lbl = cell?.subviews[1] as? UILabel {
                lbl.textColor = UIColor.white

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        //let height: CGFloat = 40
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 7 ? 7 : day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
     
      //  myCollectionView.reloadData()
        
       // monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
        delegate?.didChangeMonth(monthIndex: monthIndex, year: year, calender: self)
     
    }
    
    func setupViews() {
        addSubview(monthView)
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            monthView.heightAnchor.constraint(equalToConstant: 80).isActive=true
        }else{
            monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        }
        // monthView.topAnchor.constraint(equalTo: topAnchor, constant: 10 ).isActive = true
        
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        // monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        if UIDevice.current.userInterfaceIdiom == .pad{
            weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 10 ).isActive = true
        }else{
            weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        }
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        if UIDevice.current.userInterfaceIdiom == .pad{
            myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 10).isActive=true
        }else{
            myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        }
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


protocol CalenderDelegate {
    func didTapDate(date:String, available:Bool)
    func didChangeMonth(monthIndex: Int, year: Int , calender : CalenderView)
}
class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height / 2
            self.layer.masksToBounds=true
        }
        setupViews()
    }
    
    func setupViews() {
        addSubview(dateLbl)
        dateLbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        dateLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        dateLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        dateLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
      
    }
    
    let dateLbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.init(name: kSFRegular, size: 15)
        label.sizeToFit()
        label.setCustomFont()
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}













