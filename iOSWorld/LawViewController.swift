//
//  LawViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/14/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit

class LawViewController: UIViewController{
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    @IBAction func understand(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
