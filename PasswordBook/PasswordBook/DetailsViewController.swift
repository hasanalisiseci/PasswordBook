//
//  DetailsViewController.swift
//  PasswordBook
//
//  Created by Hasan Ali on 15.09.2019.
//  Copyright © 2019 Hasan Ali Şişeci. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var kaydetButton: UIButton!
    
    @IBOutlet weak var appName: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var dateText: UILabel!
    
    

    
    var chosenPassword = ""
    var chosenPasswordId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        appName.placeholder = "App Name"
        userNameText.placeholder = "User Name"
        mailText.placeholder = "Mail / Phone No."
        passwordText.placeholder = "Password"
        dateText.text = "Last Updated Date"
        
        
        

        if chosenPassword != "" {
            
            kaydetButton.isHidden = true
            
            
            //coredata
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Password")
            
            let idString = chosenPasswordId?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let appname = result.value(forKey: "appname") as? String {
                            appName.text = appname
                        }
                        if let userName = result.value(forKey: "username") as? String {
                            userNameText.text = userName
                        }
                        if let mail = result.value(forKey: "mail") as? String {
                            mailText.text = mail
                        }
                        if let password = result.value(forKey: "password") as? String {
                            passwordText.text = password
                        }
                        if let date = result.value(forKey: "date") as? String {
                            dateText.text = date
                        }
                    }
                }
            } catch {
                print("error")            }
        } 
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        dateText.text = DateFormatter.localizedString(from: Date(), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPassword = NSEntityDescription.insertNewObject(forEntityName: "Password", into: context)
        
        //Attributes
        newPassword.setValue(appName.text, forKey: "appname")
        newPassword.setValue(userNameText.text, forKey: "username")
        newPassword.setValue(mailText.text, forKey: "mail")
        newPassword.setValue(passwordText.text, forKey: "password")
        newPassword.setValue(dateText.text, forKey: "date")
        
        newPassword.setValue(UUID(), forKey: "id")
        
        do{
            try context.save()
            print("Success")
        }catch {
            print("Error")

        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
  

}
