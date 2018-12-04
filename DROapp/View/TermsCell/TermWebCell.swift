//
//  TermWebCell.swift
//  DROapp
//
//  Created by Carematix on 29/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import WebKit
class TermWebCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet var labelDetail: UILabel!
    @IBOutlet var webBackGroundView: UIView!
    @IBOutlet var labelTitle: UILabel!
    
    //MARK:- Variables

    let webView = WKWebView()
    var webUrl = String()
    
    //MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.setCustomFont()
        labelDetail.setCustomFont()
        DispatchQueue.main.async {
            self.webView.frame = self.webBackGroundView.bounds
            self.webBackGroundView.addSubview(self.webView)
            if self.webUrl.contains("watch"){
                if  let url = URL(string: self.webUrl) {
                    self.webView.load(URLRequest(url: url))
                }
            }else{
                let scaleHeight = UIScreen.main.nativeBounds.height / UIScreen.main.bounds.height
                let scaleWidth = UIScreen.main.nativeBounds.width / UIScreen.main.bounds.width
                let str = "<iframe width=\"" + "\(Int(self.webView.frame.size.width * scaleWidth) )" + "\" height=\""  + "\(Int(self.webView.frame.size.height * scaleHeight))" + "\" src=\""  + (self.webUrl ) +  "\" frameborder=\"0\" allowfullscreen ></iframe>"
                print(self.webUrl)
                self.webView.loadHTMLString(String(format:str), baseURL: nil)
            }
        }
        // Initialization code
    }
    
}
