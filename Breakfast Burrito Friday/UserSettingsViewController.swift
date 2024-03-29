//
//  UserSettingsViewController.swift
//  Breakfast Burrito Friday
//
//  Created by Mackenzie Fernandez on 6/4/15.
//  Copyright (c) 2015 Mackenzie Fernandez. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsViewController: UIViewController {

    
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newNameTextField: UITextField!
    
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    let ref = Constants.fireRef
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func logOutButtonPressed(sender: UIButton) {
        // Log out the user
        ref.unauth()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeNameButtonPressed(sender: UIButton) {
        // Edit the name that is stored in the user section of the database
        self.changeNameButton.setTitle("Changing ...", forState: .Normal)
        
        // Search for the user with the uid of the current users uid
        ref.childByAppendingPath("users/" + ref.authData.uid).updateChildValues(["name":newNameTextField.text!], withCompletionBlock: {(error:NSError?, ref:Firebase!) in
            if (error != nil) {
                print("Data could not be saved.")
                
            } else {
                print("Data saved successfully!")
                self.changeNameButton.setTitle("Name changed!", forState: .Normal)
                self.newNameTextField.text = ""
            }
        })
    }
    
    @IBAction func changeEmailButtonPressed(sender: UIButton) {
        // Prompt for the current password
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter Your Password", message: "To change your email, you need to provide your password.", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Some default text."
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] 
//            println("Text field: \(textField.text)")
            let userPassword = textField.text
                    self.changeEmailFunction(userPassword!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func changeEmailFunction(userPassword:NSString) {
        print("Trying to change the user's email with password: \(userPassword)")
                ref.changeEmailForUser(ref.authData.providerData["email"]! as! String, password: userPassword as String,
                    toNewEmail: newEmailTextField.text, withCompletionBlock: { error in
                        if error != nil {
                            // There was an error processing the request
                            print("Error: \(error)")
                        } else {
                            // Email changed successfully
                            print("Yay, it worked!")
                            
                            // Re-log the user in so we have that new auth data
                            self.login(self.newEmailTextField.text!, userPassword: userPassword as String)
                        }
                })
    }
    
    func changePasswordFunction(userPassword:NSString) {
        ref.changePasswordForUser(ref.authData.providerData["email"]! as! String, fromOld: userPassword as String,
            toNew: newPasswordTextField.text, withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                    print("Error: \(error)")
                } else {
                    // Password changed successfully
                    print("Yay, it worked!")
                }
        })
    }
    
    func login(userEmail:String, userPassword:String) {
        ref.authUser(userEmail, password: userPassword,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                } else {
                    // We are now logged in
                }
        })
    }
    
    @IBAction func changePasswordButtonPressed(sender: UIButton) {
        // Change the users password
        
        // Prompt for the current password
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter Your Password", message: "To change your password, you need to provide your old password.", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Some default text."
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] 
            //            println("Text field: \(textField.text)")
            let userPassword = textField.text
            self.changeEmailFunction(userPassword!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
