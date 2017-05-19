//
//  ViewController.swift
//  iOSWorld
//
//  Created by Luis Schubert on 5/4/17.
//  Copyright © 2017 Luis Schubert. All rights reserved.
//

import UIKit
import MapKit
import AWSCore
import AWSS3

extension UIImage{
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}

class MapViewController: UIViewController, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate{
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let SJSUCENTER = CLLocation(latitude: 37.335482, longitude: -121.881382)
    var updateNum = 0
    let preferences = UserDefaults.standard
    
    
    @IBOutlet weak var messageArea: UITextView!
    @IBOutlet weak var howMuchCloser: UILabel!
    
    
    //MAPDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            annotationView!.canShowCallout = false
            
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? MyPointAnnotation {
            
            if let imageName = annotation.title{
                if imageName == "USER"{
                    annotationView?.pinTintColor = .red
                }else{
                    annotationView?.pinTintColor = annotation.pinTintColor

                }
                
                
            }
        }
        
        
        
        
        return annotationView
    }
    
    //MKAnnotation is clicked
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        print("chill")
        print(view)

        if (view.annotation?.isKind(of: MKUserLocation.self))!{
            print("userlocation clicked")
        }else{
//            let pin = view as! MKAnnotation
            print("myannotation is clicked")

            if let imagePinAnnotation = view.annotation{
                if let imageName = imagePinAnnotation.title as? String{
                    if imageName != "USER"{
                        let dropViewController = storyBoard.instantiateViewController(withIdentifier: "DropViewController") as! DropViewController
                        dropViewController.imageName = imageName
                        self.present(dropViewController,animated: true, completion: nil)
//                        let imageAddress = "https://s3-us-west-1.amazonaws.com/worlddata/\(String(describing: imageName)).png"
//                        UIApplication.shared.open(NSURL(string: imageAddress)! as URL)
                    }
                        
                    
                }
            }
            
            
        }
       
    }
    
    //SPEAK FUNCTIONALITY
    @IBAction func touchDownOnSpeak(_ sender: Any) {
        DispatchQueue.main.async{
            self.speakButton.alpha = 1
        }
    }
    @IBOutlet weak var speakButton: UIButton!
    @IBAction func showSpeak(_ sender: UIButton) {
        speakButton.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.speakButton.alpha = 0.45
            self.speakButton.alpha = 0.2
        }
    }
    @IBAction func speakPressed(_ sender: UIButton) {
        let speakViewController = storyBoard.instantiateViewController(withIdentifier: "SpeakViewController") as! SpeakViewController
        speakViewController.latitudePassed = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
        speakViewController.longitudePassed = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
        self.present(speakViewController, animated: true, completion: nil)
    }
    
    
    //DROP FUNCTIONALITY
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var dropButton: UIButton!
    @IBAction func showDrop(_ sender: Any) {
        dropButton.alpha = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.dropButton.alpha = 0.45
            self.dropButton.alpha = 0.2
        }
    }
    @IBAction func dropPressed(_ sender: Any) {
        print("drop Pressed")
        
        let alertController = UIAlertController(title: "DROP", message: nil, preferredStyle: .actionSheet)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        let cameraAction = UIAlertAction(title: "Use Camera", style: .default){(action) in
            //self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            //self.imagePicker.mediaTypes = ["KTUTypeImage" ]
            

            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true,completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Use Photo Library", style: .default){(action) in
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true,completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        alertController.popoverPresentationController?.sourceView = view;
        alertController.popoverPresentationController?.sourceRect = CGRect(x:0,y:0,width:1.0,height:1.0);
        present(alertController,animated: true, completion: nil)
    }
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //AWSDDLog.setLevel(.verbose, for: .)
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
        //let fileURL = documentsUrl.appendingPathComponent(fileName)
//        if let imageData = UIImageJPEGRepresentation(chosenImage, 1.0) {
//            try? imageData.write(to: fileURL, options: .atomic)
//
//        }
//        
//        let imageURL = Bundle.main.url(forResource: "Default-568h@2x", withExtension: "png")!
//        let S3DownloadKeyName: String = "S3DownloadKeyName" // an image in the specified S3 Bucket
//        let S3UploadKeyName: String = "Default-568h2x.png"
//        
//        // Configure AWS Cognito Credentials
//        let myIdentityPoolId = "us-west-2:7207e044-ecfc-4fda-9d77-c6d253706d37"
//        
//        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId: myIdentityPoolId)
//        
//        let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:credentialsProvider)
//        
//        AWSServiceManager.default().defaultServiceConfiguration = configuration
//        
//        // Set up AWS Transfer Manager Request
//        let S3BucketName = "worlddata"
//        
//        
//        let uploadRequest = AWSS3TransferManagerUploadRequest()
//        uploadRequest?.body = imageURL
//        uploadRequest?.key = S3UploadKeyName
//        uploadRequest?.bucket = S3BucketName
//        uploadRequest?.contentType = "image/png"
//        
//        
//        let transferManager = AWSS3TransferManager.default()
//        
//        // Perform file upload
//        transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject! in
//            
//        
//            
//            if let error = task.error {
//                print("Upload failed with error: (\(error.localizedDescription))")
//            }
//            
//            
//            
//            if task.result != nil {
//                
//                let s3URL = NSURL(string: "https://s3.amazonaws.com/\(S3BucketName)/\(S3DownloadKeyName)")!
//                print("Uploaded to:\n\(s3URL)")
//                
//            }
//            else {
//                print("Unexpected empty result.")
//            }
//            return nil
//        }

        let reducedFileImage = chosenImage.resized(withPercentage: 0.5)
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("TestImage.png")
//        let imageData = UIImagePNGRepresentation(chosenImage)
        let imageData = UIImagePNGRepresentation(reducedFileImage!)
        fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        let imageName = UUID().uuidString
        let fileUrl = NSURL(fileURLWithPath: path)
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "worlddata"
        uploadRequest?.key = imageName + ".png"
        uploadRequest?.contentType = "image/png"
        uploadRequest?.body = fileUrl as URL!
//        uploadRequest?.serverSideEncryption = AWSS3ServerSideEncryption.awsKms
        uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            DispatchQueue.main.async(execute: {
                print(totalBytesSent) // To show the updating data status in label.
                print(totalBytesExpectedToSend)
            })
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith { (task) -> AnyObject! in
            if let error = task.error {
                // Error.
                print("Upload failed with error: (\(error.localizedDescription))")
            } else {
                // Do something with your result.
            }
            return nil
        }
        let latitude = String(format: "%f", (self.manager.location?.coordinate.latitude)!)
        let longitude = String(format: "%f", (self.manager.location?.coordinate.longitude)!)
        let userId = preferences.string(forKey: "session")!
        let url = URL(string: "https://www.learncomputing.io/api/iosdrop")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let paramToSend = "latitude=" + latitude + "&longitude=" + longitude + "&id=" + userId + "&name=" + imageName
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
                if(data_block == "success"){
                    print("\(chosenImage) photo was uploaded")
                }else{
                    print("\(chosenImage) photo was not uploaded")
                    if let reason = server_response["reason"]{
                        print(reason)
                    }else{
                        print("something was wrong with the reason")
                    }

                }
            }
        })
        task.resume()


        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //LOGOUT FUNCTIONALITY
    @IBOutlet weak var _home: UIButton!
    @IBAction func go_home(_ sender: Any) {
        manager.stopUpdatingLocation()
//        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController")
//        self.present(homeViewController, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    //MAPVIEW
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        map.camera.heading = newHeading.magneticHeading
        self.lastHeading = newHeading.magneticHeading
        map.setCamera(map.camera, animated: true)
    }
    var firstUpdate = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
//        let currentHeading = manager.heading
        let distanceFromCampus = SJSUCENTER.distance(from: currentLocation)
        
        if(updateNum % 5 == 0){
            if( distanceFromCampus > 450){
                let howMuchTooFar = distanceFromCampus - 450
                let howMuchTooFarRounded = howMuchTooFar.rounded()
                howMuchCloser.text = "GO \(howMuchTooFarRounded)M TOWARDS SJSU"
                map.isHidden = true
                dropButton.isHidden = true
                speakButton.isHidden = true
            }else{
                map.isHidden = false
                dropButton.isHidden = false
                speakButton.isHidden = false
                //let mapCamera = MKMapCamera()
                //let currentSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.001,0.001)
                let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                //let myRegion:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, currentSpan)
                map.camera.pitch = 45
                map.camera.altitude = 200
                map.camera.heading = lastHeading
                map.camera.centerCoordinate = myLocation
                //map.camera = mapCamera
                map.centerCoordinate = myLocation
                
                
                //map.setRegion(myRegion, animated: false)
                map.showsUserLocation = true
                
//                if firstUpdate{
//                    firstUpdate = false
//                    
//
//                }else{
//                    map.isHidden = false
//                    dropButton.isHidden = false
//                    speakButton.isHidden = false
//                    let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
//                    let currentSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.001,0.001)
//                    self.map.setVisibleMapRect(currentSpan, animated: true)
//                    self.map.centerCoordinate = myLocation
//                
//                }
                            }
            updateLocation(String(format: "%f", currentLocation.coordinate.latitude), String(format: "%f", currentLocation.coordinate.longitude))
        }
        
        
        
        
        //print(SJSUCENTER.distance(from: currentLocation))
        //use 450m as max from center
    }
    var globalCount = 0
    var isHeadingAvailable = false
    var lastHeading = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        dropButton.alpha = 0.2
        speakButton.alpha = 0.2
        let mapCamera = MKMapCamera()
        mapCamera.pitch = 45
        mapCamera.altitude = 200
        mapCamera.heading = 45
        
        map.camera = mapCamera
        map.isZoomEnabled = false
        map.isPitchEnabled = true
        map.isRotateEnabled = true
        map.isScrollEnabled = false
        map.mapType = .satelliteFlyover
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //manager.startUpdatingHeading()
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        
        //UI VIEW WITH GESTURE RECOGNIZERS
//        let drop = UITapGestureRecognizer(target: self, action:#selector(self.drop(_:)))
//        drop.delegate = self
//        drop_area.addGestureRecognizer(drop)
//        
//        let message = UITapGestureRecognizer(target: self, action:#selector(self.message(_:)))
//        message.delegate = self
//        message_area.addGestureRecognizer(message)
        
        //SHOW PIN LOCATION
        
        //let span = MKCoordinateSpanMake(0.2,0.2)
        //let region = MKCoordinateRegion(center: location, span: span)
        //map.setRegion(region, animated: true)
//        let dropPin = MKPointAnnotation()
//        dropPin.coordinate = location
//        dropPin.title = "WELCOME TO SJSU"
//        dropPin.subtitle = "https://www.apple.com"
//        map.addAnnotation(dropPin)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateLocation(_ lat:String, _ lng:String){
        //send the newly updated location
        //receive the new locations of all the other users.
        let userId = preferences.string(forKey: "session")!
        let url = URL(string: "https://www.learncomputing.io/api/iosupdateLocation")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let paramToSend = "lat=" + lat + "&lng=" + lng + "&id=" + userId
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
                if let user_messages = data_block["userMessages"] as? NSArray {
                    print("we have message data")
                    print(user_messages)
                    DispatchQueue.main.async {
                        self.showMessages(user_messages)
                    }
                }
                if let user_locations = data_block["userLocations"] as? NSArray{
                    print("we found the user locations")
                    print(user_locations)
                    DispatchQueue.main.async {
                        self.showPlayers(user_locations)
                    }
                }
                if let user_drops = data_block["userDrops"] as? NSArray{
                    print("we have drops")
                    print(user_drops)
                    DispatchQueue.main.async {
                        self.showDrops(user_drops)
                    }
                }
                
                self.globalCount = self.globalCount + 1
                print(self.globalCount)
                
            }
        })
        task.resume()
    }
    
//    func getLocations(){
//        let locations:[MKAnnotation] = []
//        for _ in 1...5{
//            let dropPin = MKPointAnnotation()
//            dropPin.coordinate = CLLocationCoordinate2DMake(37.335730, -121.881364)
//            
//        }
//        
//        map.addAnnotations(locations)
//    }
    
    func showPlayers(_ players:NSArray){
        let annotationsToRemove = map.annotations.filter { $0 !== map.userLocation }
        map.removeAnnotations(annotationsToRemove)
        for player in players{
            let dict = player as! NSDictionary
            let playerPin = MyPointAnnotation()
            playerPin.coordinate = CLLocationCoordinate2DMake(dict["lat"] as! Double, dict["lng"] as! Double)
            playerPin.title = "USER"
            playerPin.pinTintColor = .red
            map.addAnnotation(playerPin)
        }
    }
    
    func showMessages(_ messages:NSArray){
        var newMessages = ""
        for message in messages{
            let messageDict = message as! NSDictionary
            newMessages.append(messageDict["content"] as! String)
            newMessages.append("\n")
        }
        messageArea.text = newMessages
    }
    
    func showDrops(_ drops:NSArray){
        let curlat = manager.location?.coordinate.latitude
        let curlong = manager.location?.coordinate.longitude
        let curLocation = CLLocation(latitude: curlat!, longitude: curlong!)
        for drop in drops{
            let dict = drop as! NSDictionary
            let dropPin = MyPointAnnotation()
            let dropPinCoordinate = CLLocationCoordinate2DMake(dict["lat"] as! Double, dict["lng"] as! Double)
            let dropPinLocation = CLLocation(latitude: dict["lat"] as! Double, longitude: dict["lng"] as! Double)
            let pinDistance = curLocation.distance(from: dropPinLocation)
            if(pinDistance < 25.0){
                print(pinDistance)
            }
            dropPin.coordinate = dropPinCoordinate
            dropPin.title = dict["name"] as? String
            dropPin.pinTintColor = .blue
//            dropPin.ad
            map.addAnnotation(dropPin)
        }
    }
    
    
    // UIVIEW GESTURE RECOGNIZER HANDLERS
//    func drop(_ gestureRecognizer: UITapGestureRecognizer){
//        print("tryna drop")
//        
//        let dropViewController = storyBoard.instantiateViewController(withIdentifier: "DropViewController")
//        self.present(dropViewController, animated: true, completion: nil)
//    }
//    
//    func message(_ gestureRecognizer: UITapGestureRecognizer){
//        print("tryna message")
//    }
    
}
