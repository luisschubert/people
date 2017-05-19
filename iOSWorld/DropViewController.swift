//
//  DropViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/18/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit

class DropViewController: UIViewController,UIWebViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var webviewObject: UIWebView!
    var imageName = ""
    
    @IBAction func backToWorld(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let url = URL(string: "https://s3-us-west-1.amazonaws.com/worlddata/\(imageName).png")
        let request = URLRequest(url: url!)
        webviewObject.loadRequest(request)
        webviewObject.scalesPageToFit = true
        webviewObject.scrollView.delegate = self
        webviewObject.scrollView.isScrollEnabled = false
        
        
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        if (scrollView.contentOffset.y == 0) {
//            //Do what you want.
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
