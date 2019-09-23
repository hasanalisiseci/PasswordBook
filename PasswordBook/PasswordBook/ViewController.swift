//
//  ViewController.swift
//  PasswordBook
//
//  Created by Hasan Ali on 15.09.2019.
//  Copyright © 2019 Hasan Ali Şişeci. All rights reserved.
//

import UIKit
import LocalAuthentication
class ViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisClicked(_ sender: Any) {
        print("start")
        let authContext = LAContext()
        
        var error: NSError?
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Is it you?") {
                (success,error) in
                if success == true {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toTableView", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.myLabel.text = "Your fingerprint was not recognized!"
                    }
                }
            }
        }
        
        
        
    }
    
    
}

