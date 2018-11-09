//
//  SignupViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
    var usernameField = UITextField()
    var passwordField = UITextField()
    var confirmPasswordField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLoginForm()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
    }
    
    func setupBackground(){
        self.view.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
    }
    
    func setupLoginForm(){
        
        let frameWidth = self.view.frame.width
        let frameHeight = self.view.frame.height
        
        let signupForm = UIView(frame: CGRect(x: frameWidth/10, y: frameHeight/5, width: 4*frameWidth/5, height: frameHeight/2))
        signupForm.backgroundColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        signupForm.layer.cornerRadius = 10.0
        
        let textFieldWidth = CGFloat(4.0*signupForm.frame.width/5.0)
        let textFieldHeight = signupForm.frame.height/10.0
        let textFieldXPos = CGFloat(signupForm.frame.width/10.0)
        let signupViewMidpoint = signupForm.frame.height/2.0
        
        let labelHeight = signupForm.frame.height/7.0
        
        let usernameLabel = UILabel(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint/7.0, width: textFieldWidth, height: labelHeight))
        usernameLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        usernameLabel.text = "Username"
        
        usernameField = UITextField(frame: CGRect(x: textFieldXPos, y: (2.5*signupViewMidpoint)/7.0, width: textFieldWidth
            , height: textFieldHeight))
        usernameField.textColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        //usernameField.placeholder = "Username"
        usernameField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        
        let passwordLabel = UILabel(frame: CGRect(x: textFieldXPos, y: (4*signupViewMidpoint)/7.0, width: textFieldWidth, height: labelHeight))
        passwordLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        passwordLabel.text = "Password"
        
        passwordField = UITextField(frame: CGRect(x: textFieldXPos, y: (5.5*signupViewMidpoint)/7.0, width: textFieldWidth, height: textFieldHeight))
        passwordField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        passwordField.textColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        
        
        let confirmPasswordLabel = UILabel(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint, width: textFieldWidth, height: labelHeight))
        confirmPasswordLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        confirmPasswordLabel.text = "Confirm Password"
        
        confirmPasswordField = UITextField(frame: CGRect(x: textFieldXPos, y: (8.5*signupViewMidpoint)/7.0, width: textFieldWidth, height: textFieldHeight))
        confirmPasswordField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        confirmPasswordField.textColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        
        let signupButton = UIButton(frame: CGRect(x: 2.0*signupForm.frame.width/5.0, y: (11.5*signupViewMidpoint)/7.0, width: signupForm.frame.width/5.0, height: signupForm.frame.height/10.0))
        signupButton.backgroundColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        signupButton.layer.cornerRadius = signupButton.frame.height/3
        signupButton.setTitle("Login", for: UIControl.State.normal)
        signupButton.addTarget(self, action: #selector(signupUser), for: .touchUpInside)
        
        signupForm.addSubview(usernameLabel)
        signupForm.addSubview(usernameField)
        signupForm.addSubview(passwordLabel)
        signupForm.addSubview(passwordField)
        signupForm.addSubview(confirmPasswordLabel)
        signupForm.addSubview(confirmPasswordField)
        signupForm.addSubview(signupButton)
        
        self.view.addSubview(signupForm)
    }
    
    @objc func signupUser(sender: UIButton){
        if(passwordField.text != confirmPasswordField.text){
            return
        }
        Auth.auth().createUser(withEmail: usernameField.text!+"@furnish.com", password: passwordField.text!) { (user, error) in
            if error != nil{
                //There was some error
                print(error!)
            }else{
                //Successful - Registration Successful
                print("Successfully Registered")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
                self.present(viewController, animated: true, completion: nil)
                UserDefaults.standard.set(true, forKey: "IsUserLoggedIn")
                UserDefaults.standard.set([], forKey: "cart")
                UserDefaults.standard.set(self.usernameField.text!, forKey: "username")
                UserDefaults.standard.synchronize()
                //let databaseRef = Database.database().reference()
                //let currentUID = Auth.auth().currentUser?.uid
                
                //databaseRef.child("users").child((user?.user.uid)!).child("Username").setValue(self.usernameField.text!)
                //databaseRef.child("users").child((user?.user.uid)!).child("cart").setValue([])
            }
        }
    }
    
    @objc func dimissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
