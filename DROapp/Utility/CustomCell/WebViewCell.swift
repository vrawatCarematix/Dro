//
//  WebViewCell.swift
//  DROapp
//
//  Created by Carematix on 26/10/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import WebKit

@objc protocol WebViewCellDelegate {
    @objc func heightChange(cell: WebViewCell , height : CGFloat)
}

class WebViewCell: UITableViewCell {
    let webView = WKWebView()
    var htmlContent : String?
    weak var delegate: WebViewCellDelegate?
    var cellIndexpath : Int?
    var loadCss = true

    @IBOutlet var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.webView.frame = self.backView.bounds
        }

        webView.scrollView.delegate = self
        webView.navigationDelegate = self
        backView.addSubview(self.webView)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
    }

    deinit {
        // Without this, it'll crash when your MyClass instance is deinit'd
        webView.scrollView.delegate = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure() {

//        if let css = kUserDefault.value(forKey: pCDMCss) as? String{
//            htmlContent = "<html><head>" +  "<style>" + css + "</style>" + "</head><body>" + (htmlContent ?? "") + "</body></html>"
//        }
        webView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        
        if let htmlFile = Bundle.main.path(forResource: "training", ofType: "html") {
            
            if let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8){
                webView.loadHTMLString(html.replacingOccurrences(of: "vikas", with: htmlContent!), baseURL: nil)
                webView.evaluateJavaScript(html.replacingOccurrences(of: "vikas", with: htmlContent!), completionHandler: nil)

            }
            
            //webView.loadHTMLString(html!, baseURL: nil)
            
        }
        //webViewHeightConstraint.constant = webView.scrollView.contentSize.height

    }

}

extension WebViewCell : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //webView.frame.size.height = 1
       // webView.frame.size = webView.scrollView.contentSize
       // webView.scrollView.isScrollEnabled = false
       // webView.sizeToFit()
//
//       // webViewHeightConstraint.constant = webView.scrollView.contentSize.height
        webView.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true

        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                    if let webHeight = height as? CGFloat {
                       // if  self.webViewHeightConstraint.constant != webHeight {
                           // self.webViewHeightConstraint.constant = webHeight
                            if let delegate = self.delegate {
                                delegate.heightChange(cell: self ,  height : webHeight)
                            }
                       // }
                       // self.webViewHeightConstraint.constant = webHeight

                    }
                })
            }
            
        })

    }
}
extension WebViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
