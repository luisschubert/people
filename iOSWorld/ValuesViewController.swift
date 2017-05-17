//
//  ValuesViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/14/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit

class ValuesViewController: UIViewController {
    @IBOutlet weak var _do: UIButton!
    @IBAction func doSomething(_ sender: Any) {
        DispatchQueue.main.async(){
            self._do.setTitle("something", for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0){
            self._do.setTitle("do", for: .normal)
        }
    }
    @IBOutlet weak var _share: UIButton!
    @IBAction func shareExperiences(_ sender: Any) {
        DispatchQueue.main.async(){
            self._share.setTitle("experiences", for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0){
            self._share.setTitle("share", for: .normal)
        }
    }
    @IBOutlet weak var _respect: UIButton!
    @IBAction func respectEachother(_ sender: Any) {
        DispatchQueue.main.async(){
            self._respect.setTitle("eachother", for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0){
            self._respect.setTitle("respect", for: .normal)
        }
    }
    @IBOutlet weak var _nurture: UIButton!
    @IBAction func nurtureCommunity(_ sender: Any) {
        DispatchQueue.main.async(){
            self._nurture.setTitle("community", for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0){
            self._nurture.setTitle("nurture", for: .normal)
        }
    }
    @IBAction func homeClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
