//
//  SpeakViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/8/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit

class SpeakViewController: UIViewController{
    var latitudePassed = ""
    var longitudePassed = ""
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let preferences = UserDefaults.standard
    @IBOutlet weak var textBox: UITextView!
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func speakOutLoud(_ sender: Any) {
        print("speak out loud")
        let content = textBox.text!
        let userId = preferences.string(forKey: "session")!
        let url = URL(string: "https://www.learncomputing.io/api/iospost")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let paramToSend = "content=" + content + "&id=" + userId + "&latitude=" + latitudePassed + "&longitude=" + longitudePassed
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
            
            if let data_block = server_response["data"] as? String{
                print(data_block)
                DispatchQueue.main.async(execute: self.finishPost)
                
            }
        })
        task.resume()
    }
    
    
    func finishPost(){
        //let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController")
        //self.present(mapViewController, animated: true, completion: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
