//
//  LoginViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/30/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
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
        
        let loginForm = UIView(frame: CGRect(x: frameWidth/10, y: frameHeight/5, width: 4*frameWidth/5, height: frameHeight/2))
        loginForm.backgroundColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        loginForm.layer.cornerRadius = 10.0
        
        let textFieldWidth = CGFloat(4.0*loginForm.frame.width/5.0)
        let textFieldHeight = CGFloat(40.0)
        let textFieldXPos = CGFloat(loginForm.frame.width/10.0)
        let loginViewMidpoint = loginForm.frame.height/2.0
        
        let labelHeight = CGFloat(15.0)
        
        let usernameLabel = UILabel(frame: CGRect(x: textFieldXPos, y: loginViewMidpoint-120.0, width: textFieldWidth, height: labelHeight))
        usernameLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        usernameLabel.text = "Username"
        
        let usernameField = UITextField(frame: CGRect(x: textFieldXPos, y: loginViewMidpoint-100.0, width: textFieldWidth
            , height: textFieldHeight))
        //usernameField.placeholder = "Username"
        usernameField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        
        let passwordLabel = UILabel(frame: CGRect(x: textFieldXPos, y: loginViewMidpoint, width: textFieldWidth, height: labelHeight))
        passwordLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        passwordLabel.text = "Password"
        
        let passwordField = UITextField(frame: CGRect(x: textFieldXPos, y: loginViewMidpoint+20.0, width: textFieldWidth, height: textFieldHeight))
        passwordField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        
        let loginButton = UIButton(frame: CGRect(x: 2.0*loginForm.frame.width/5.0, y: loginViewMidpoint+120.0, width: loginForm.frame.width/5.0, height: 40.0))
        loginButton.backgroundColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        loginButton.layer.cornerRadius = loginButton.frame.height/3
        loginButton.setTitle("Login", for: UIControl.State.normal)
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        
        loginForm.addSubview(usernameLabel)
        loginForm.addSubview(usernameField)
        loginForm.addSubview(passwordLabel)
        loginForm.addSubview(passwordField)
        loginForm.addSubview(loginButton)
        
        self.view.addSubview(loginForm)
    }
    
    @objc func loginUser(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
        self.present(viewController, animated: true, completion: nil)
    }
    
    
}
