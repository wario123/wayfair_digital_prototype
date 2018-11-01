//
//  SignupViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupLoginForm()
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
        let textFieldHeight = CGFloat(40.0)
        let textFieldXPos = CGFloat(signupForm.frame.width/10.0)
        let signupViewMidpoint = signupForm.frame.height/2.0
        
        let labelHeight = CGFloat(15.0)
        
        let usernameLabel = UILabel(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint-175.0, width: textFieldWidth, height: labelHeight))
        usernameLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        usernameLabel.text = "Username"
        
        let usernameField = UITextField(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint-155.0, width: textFieldWidth
            , height: textFieldHeight))
        //usernameField.placeholder = "Username"
        usernameField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        
        let passwordLabel = UILabel(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint-85.0, width: textFieldWidth, height: labelHeight))
        passwordLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        passwordLabel.text = "Password"
        
        let passwordField = UITextField(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint-65.0, width: textFieldWidth, height: textFieldHeight))
        passwordField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        
        
        let confirmPasswordLabel = UILabel(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint+10.0, width: textFieldWidth, height: labelHeight))
        confirmPasswordLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        confirmPasswordLabel.text = "Confirm Password"
        
        let confirmPasswordField = UITextField(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint+30.0, width: textFieldWidth, height: textFieldHeight))
        confirmPasswordField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        
        let signupButton = UIButton(frame: CGRect(x: 2.0*signupForm.frame.width/5.0, y: signupViewMidpoint+120.0, width: signupForm.frame.width/5.0, height: 40.0))
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
        self.present(viewController, animated: true, completion: nil)
    }
}
