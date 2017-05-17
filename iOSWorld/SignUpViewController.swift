//
//  SignUpViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/4/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var _name: UITextField!
    @IBOutlet weak var _email: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _cpassword: UITextField!
    @IBOutlet weak var _signup: UIButton!
    @IBAction func do_signup(_ sender: Any) {
        print("I work -signup")
        let name = _name.text
        let email = _email.text
        let password = _password.text
        let cpassword = _cpassword.text
        if(name == "" || email == "" || password == "" || password != cpassword){
            return
        }
        DoSignup(name!, email!, password!)
    }
    
    func DoSignup(_ nm:String, _ em:String, _ psw:String){
        print("doing signup")
        let url = URL(string: "https://www.learncomputing.io/api/iossignup")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let paramToSend = "name=" + nm + "&email=" + em + "&password=" + psw
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler:{
            (data, response, error) in
            guard let _:Data = data else{
                print("something with the data didn't work")
                return
            }
            
            let json:Any?
            
            do{
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch{
                print("json failed")
                print("\(data! as NSData)")
                return
            }
            
            guard let server_response = json as? NSDictionary else {
                print("something with the response didn't work")
                return
            }
            
            if let data_block = server_response["data"] as? NSDictionary{
                if let session_data = data_block["session"] as? String{
                    print("we found the session value")
                    let preferences = UserDefaults.standard
                    preferences.set(session_data, forKey:  "session")
                    DispatchQueue.main.async(
                        execute:self.SignupDone
                    )
                }
                
            }
        })
        task.resume()
    }
    
    func SignupDone(){
        print("SignupDone running")
        self.dismiss(animated: false, completion: nil)
        let lawViewController = storyBoard.instantiateViewController(withIdentifier: "LawViewController")
        self.present(lawViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func backHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
