//
//  ViewController.swift
//  ProductFinder
//
//  Created by Karim Arem on 10/30/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupButtons()
    }
    
    func setupButtons(){
        let loginButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-200, width: self.view.frame.width, height: 100))
        loginButton.backgroundColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        loginButton.setTitleColor(UIColor(displayP3Red: 0.0, green: 0.67843, blue: 0.70980, alpha: 1.0), for: UIControl.State.normal)
        loginButton.setTitle("Login", for: UIControl.State.normal)
        loginButton.addTarget(self, action: #selector(toLoginPage), for: .touchUpInside)
        
        let registerButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width, height: 100))
        registerButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        registerButton.setTitleColor(UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0), for: UIControl.State.normal)
        registerButton.setTitle("Sign Up", for: UIControl.State.normal)
        registerButton.addTarget(self, action: #selector(toSignupPage), for: .touchUpInside)
        
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
    }
    
    @objc func toLoginPage(sender: UIButton!){
        print("Login Button Tapped!")
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @objc func toSignupPage(sender: UIButton){
        print("Signup Button Tapped!")
        let signupViewController = SignupViewController()
        self.present(signupViewController, animated: true, completion: nil)
    }

}

