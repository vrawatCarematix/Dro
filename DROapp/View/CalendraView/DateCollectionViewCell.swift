

import UIKit

class DateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var viewIndex: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLbl.font = UIFont.init(name: kSFRegular, size: 16)
        dateLbl.sizeToFit()
        dateLbl.setCustomFont()
        // Initialization code
    }

}
