


import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 2
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Style.themeColor
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
        //btnLeft.isEnabled=false
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnRight {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupViews() {
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.addSubview(lblName)
          // lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
            //lblName.topAnchor.constraint(equalTo: topAnchor, constant: 10 ).isActive = true
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

            lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
            lblName.widthAnchor.constraint(equalToConstant: 350).isActive=true
           // lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
            lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
           // lblName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10 ).isActive = true

            self.addSubview(btnRight)
           // btnRight.translatesAutoresizingMaskIntoConstraints = true

        //btnRight.topAnchor.constraint(equalTo: topAnchor, constant: 10 ).isActive = true
            btnRight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
           // btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
           // btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
            btnRight.rightAnchor.constraint(equalTo: rightAnchor, constant: -30 ).isActive = true

            btnRight.widthAnchor.constraint(equalToConstant: 35).isActive=true
            btnRight.heightAnchor.constraint(equalToConstant: 35).isActive=true
         //   btnRight.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10 ).isActive = true
           // btnRight.translatesAutoresizingMaskIntoConstraints = false
           // [_button setTranslatesAutoresizingMaskIntoConstraints:YES];

            self.addSubview(btnLeft)
          //  btnLeft.topAnchor.constraint(equalTo: topAnchor, constant: 10 ).isActive = true
            btnLeft.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

           // btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
            btnLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: 30 ).isActive = true

           // btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
            btnLeft.widthAnchor.constraint(equalToConstant: 35).isActive=true
            btnLeft.heightAnchor.constraint(equalToConstant: 35).isActive=true
           // btnLeft.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10 ).isActive = true

        }else{
            self.addSubview(lblName)
           // lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
            lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
            lblName.widthAnchor.constraint(equalToConstant: 180).isActive=true
           // lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

            lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)"
            
            self.addSubview(btnRight)
           // btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
            btnRight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

           // btnRight.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
            btnRight.widthAnchor.constraint(equalToConstant: 20).isActive=true
            btnRight.heightAnchor.constraint(equalToConstant: 20).isActive=true
            btnRight.rightAnchor.constraint(equalTo: rightAnchor, constant: -5 ).isActive = true
            self.addSubview(btnLeft)
           // btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
           // btnLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
            btnLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: 5 ).isActive = true
            btnLeft.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            btnLeft.widthAnchor.constraint(equalToConstant: 20).isActive=true
            btnLeft.heightAnchor.constraint(equalToConstant: 20).isActive=true
        }
        
    }
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.init(name: kSFRegular, size: 18)
        lbl.sizeToFit()
        lbl.setCustomFont()
       // lbl.font=  lbl.getCustomFontSize(size: 16) UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRight: UIButton = {
        let btn = UIButton(type: .custom)
      //  btn.setImage(#imageLiteral(resourceName: "rightArrowWhite"), for: UIControlState.normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "right"), for: .normal)
        //btn.imageView?.tintColor = UIColor.black
       // btn.imageView?.contentMode = .scaleAspectFit
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(#imageLiteral(resourceName: "left"), for: .normal)
       // btn.imageView?.tintColor = UIColor.black
        btn.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 11.0, *) {
            btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        } else {
            // Fallback on earlier versions
        }
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

