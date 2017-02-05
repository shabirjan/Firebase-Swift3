//
//  FacebookLoginViewController.swift
//  FirebaseTutorial
//
//  Created by Shabir Jan on 05/02/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
class FacebookLoginViewController: UIViewController {
    
    @IBOutlet weak var btnFb: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSignInFb(_ sender: Any) {
        if FIRAuth.auth()?.currentUser == nil{
            let fbLoginManager = FBSDKLoginManager()
            if FBSDKAccessToken.current() == nil
            {
                fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                }
            }
            guard let accessToken = FBSDKAccessToken.current() else{
                print("Failed to get access token")
                return
            }
            
            let creds = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //Calling Login by using Firebase Api
            FIRAuth.auth()?.signIn(with: creds, completion: { [weak self](user, error) in
                if error != nil {
                    print("Login error: \(error?.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self?.present(alertController, animated: true, completion: nil)
                    
                    return
                }else{
                    self?.btnFb.setTitle("Sign out", for:.normal)
                    if let currentUser = FIRAuth.auth()?.currentUser
                    {
                        let alertController = UIAlertController(title: "Login Success", message: "Welcome \(currentUser.displayName!)", preferredStyle: .alert)
                        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        }else{
             self?.btnFb.setTitle("SIGN IN WITH FACEBOOK", for:.normal)
            do{
                try FIRAuth.auth()?.signOut()
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    
    
}
