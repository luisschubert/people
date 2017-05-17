    //
//  HomeViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/4/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //super.view.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 122/255, alpha: 1)
    
    
    
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var values: UIButton!
    
    var authComplete = false
    let preferences = UserDefaults.standard
    
    @IBAction func showText(_ sender: Any) {
        DispatchQueue.main.async {
            self.login.alpha = 1
            self.signup.alpha = 1
            self.values.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.login.alpha = 0
            self.signup.alpha = 0
            self.values.alpha = 0
        }    }
 
    @IBAction func loginClicked(_ sender: Any) {
        if(authComplete){
            //Logout
            preferences.removeObject(forKey: "session")
            authComplete = false
            DispatchQueue.main.async {
                self.login.setTitle("Login", for: .normal)
                self.signup.setTitle("Sign Up", for: .normal)
            }
            
        }
        else{
            //login
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginViewController, animated: true, completion: nil)
        }
        
    }
    @IBAction func signupClicked(_ sender: Any) {
        
        if(authComplete){
            //world
            let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController")
            self.present(mapViewController, animated: true, completion: nil)
        }else{
            //signup
            let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.present(signUpViewController, animated: true, completion: nil)
        }
        
    }
    @IBAction func valuesClicked(_ sender: Any) {
        let valuesViewController = storyBoard.instantiateViewController(withIdentifier: "ValuesViewController") as! ValuesViewController
        self.present(valuesViewController, animated:true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.login.alpha = 0
            self.signup.alpha = 0
            self.values.alpha = 0
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        let userId = preferences.string(forKey: "session")
        if (userId != nil){
            DispatchQueue.main.async {
                self.login.setTitle("Logout", for: .normal)
                self.signup.setTitle("World", for: .normal)
            }
            authComplete = true
        }else{
            DispatchQueue.main.async {
                self.login.setTitle("Login", for: .normal)
                self.signup.setTitle("Sign Up", for: .normal)
            }
            
            authComplete = false
        }
    }
}
