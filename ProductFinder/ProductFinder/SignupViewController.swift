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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        setupBackground()
        setupLoginForm()
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        //view.addGestureRecognizer(tap)
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    
    func setupBackground(){
        self.view.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
    }
    
    func setupLoginForm(){
        /*let frameWidth = self.view.frame.width
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
        passwordField.isSecureTextEntry = true
        
        
        let confirmPasswordLabel = UILabel(frame: CGRect(x: textFieldXPos, y: signupViewMidpoint, width: textFieldWidth, height: labelHeight))
        confirmPasswordLabel.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        confirmPasswordLabel.text = "Confirm Password"
        
        confirmPasswordField = UITextField(frame: CGRect(x: textFieldXPos, y: (8.5*signupViewMidpoint)/7.0, width: textFieldWidth, height: textFieldHeight))
        confirmPasswordField.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        confirmPasswordField.textColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        confirmPasswordField.isSecureTextEntry = true
        
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
        
        self.view.addSubview(signupForm)*/
        
        //Upper section white coloring
        let upperLayer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: (351*view.frame.height)/812.0))
        upperLayer.backgroundColor = UIColor.white
        self.view.addSubview(upperLayer)
        //Super light brown lower part
        let lowerLayer = UIView(frame: CGRect(x: 0, y: (351*view.frame.height)/812.0, width: view.frame.width, height: (461*view.frame.height)/812.0))
        lowerLayer.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.93, alpha:1)
        self.view.addSubview(lowerLayer)
        //Purple Furnish Logo
        let textLayer = UILabel(frame: CGRect(x: 0.0, y: (82.0*view.frame.height)/812.0, width: (143.0*view.frame.width)/375.0, height: (32.0*view.frame.height)/812.0))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor(red:0.47, green:0.29, blue:0.47, alpha:1)
        textLayer.textAlignment = .center
        let textContent = "Furnish"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 34)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 1.16, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        textLayer.center.x = view.center.x
        self.view.addSubview(textLayer)
        //Slogan Above the Logo Image
        let sloganLayer = UILabel(frame: CGRect(x: 0.0, y: (154.0*view.frame.height)/812.0, width: (325*view.frame.width)/375, height: (42.0*view.frame.height)/812.0))
        sloganLayer.numberOfLines = 0
        sloganLayer.textColor = UIColor.black
        let sloganContent = "Touch and feel a couch at places nearby!"
        let sloganString = NSMutableAttributedString(string: sloganContent, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 22)!])
        let sloganRange = NSRange(location: 0, length: sloganString.length)
        let sloganStyle = NSMutableParagraphStyle()
        sloganStyle.lineSpacing = 1
        sloganString.addAttribute(NSAttributedString.Key.paragraphStyle, value:sloganStyle, range: sloganRange)
        sloganString.addAttribute(NSAttributedString.Key.kern, value: 0.96, range: sloganRange)
        sloganLayer.attributedText = sloganString
        sloganLayer.lineBreakMode = .byWordWrapping
        sloganLayer.textAlignment = .center
        sloganLayer.sizeToFit()
        sloganLayer.center.x = view.center.x
        self.view.addSubview(sloganLayer)
        //Central Wayfair Type Logo
        let circleLayer = UIImageView(frame: CGRect(x: 0.0, y: (238.0*view.frame.height)/812.0, width: (226.0*view.frame.height)/812.0, height: (226.0*view.frame.height)/812.0))
        circleLayer.center.x = view.center.x
        circleLayer.layer.shadowOffset = CGSize(width: 0, height: 2)
        circleLayer.layer.shadowColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:0.5).cgColor
        circleLayer.layer.shadowOpacity = 1
        circleLayer.layer.shadowRadius = 4
        circleLayer.image = UIImage(named: "signupimage")
        self.view.addSubview(circleLayer)
        //Username Field
        let usernameLayer = UIView(frame: CGRect(x: 0.0, y: (514.0*view.frame.height)/812.0, width: (334.0*view.frame.width)/375.0, height: (53.0*view.frame.height)/812.0))
        usernameLayer.layer.cornerRadius = 3
        usernameLayer.backgroundColor = UIColor.white
        usernameLayer.layer.borderWidth = 2
        usernameLayer.layer.borderColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1).cgColor
        usernameLayer.center.x = view.center.x
        usernameLayer.addSubview(usernameField)
        usernameField.anchor(top: usernameLayer.topAnchor, left: usernameLayer.leftAnchor, bottom: usernameLayer.bottomAnchor, right: usernameLayer.rightAnchor, paddingTop: 0.0, paddingLeft: (57.5*view.frame.height)/812.0, paddingBottom: 0.0, paddingRight: 0.0)
        let usernamePlaceholderContent = "User Name"
        let usernamePlaceholderString = NSMutableAttributedString(string: usernamePlaceholderContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)])
        usernameField.attributedPlaceholder = usernamePlaceholderString
        self.view.addSubview(usernameLayer)
        //Username Field Logo
        let usernameLogoLayer = UIImageView(frame: CGRect(x: 30, y: 587, width: (33.0*view.frame.height)/812.0, height: (33.0*view.frame.height)/812.0))
        usernameLogoLayer.backgroundColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1)
        usernameLayer.addSubview(usernameLogoLayer)
        usernameLogoLayer.anchor(top: usernameLayer.topAnchor, left: usernameLayer.leftAnchor, bottom: usernameLayer.bottomAnchor, right: nil, paddingTop: 17, paddingLeft: 15, paddingBottom: -16, paddingRight: 0.0)
        usernameLogoLayer.image = UIImage(named: "usernameLogo")
        //Password Field
        let passwordLayer = UIView(frame: CGRect(x: 0.0, y: (577.0*view.frame.height)/812.0, width: (334.0*view.frame.width)/375.0, height: (53.0*view.frame.height)/812.0))
        passwordLayer.layer.cornerRadius = 3
        passwordLayer.backgroundColor = UIColor.white
        passwordLayer.layer.borderWidth = 2
        passwordLayer.layer.borderColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1).cgColor
        passwordLayer.center.x = view.center.x
        passwordLayer.addSubview(passwordField)
        passwordField.anchor(top: passwordLayer.topAnchor, left: passwordLayer.leftAnchor, bottom: passwordLayer.bottomAnchor, right: passwordLayer.rightAnchor, paddingTop: 0.0, paddingLeft: (57.5*view.frame.height)/812.0, paddingBottom: 0.0, paddingRight: 0.0)
        passwordField.isSecureTextEntry = true
        let passwordPlaceholderContent = "Password"
        let passwordPlaceholderString = NSMutableAttributedString(string: passwordPlaceholderContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)])
        passwordField.attributedPlaceholder = passwordPlaceholderString
        self.view.addSubview(passwordLayer)
        //Password Field Logo
        let passwordLogoLayer = UIImageView(frame: CGRect(x: 30, y: 587, width: (33.0*view.frame.height)/812.0, height: (33.0*view.frame.height)/812.0 ))
        passwordLogoLayer.backgroundColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1)
        passwordLayer.addSubview(passwordLogoLayer)
        passwordLogoLayer.anchor(top: passwordLayer.topAnchor, left: passwordLayer.leftAnchor, bottom: passwordLayer.bottomAnchor, right: nil, paddingTop: 17, paddingLeft: 15, paddingBottom: -16, paddingRight: 0.0)
        passwordLogoLayer.image = UIImage(named: "passwordLogo")
        //Confirm Password Field
        let confirmPasswordLayer = UIView(frame: CGRect(x: 0.0, y: (640.0*view.frame.height)/812.0, width: (334.0*view.frame.width)/375.0, height: (53.0*view.frame.height)/812.0))
        confirmPasswordLayer.layer.cornerRadius = 3
        confirmPasswordLayer.backgroundColor = UIColor.white
        confirmPasswordLayer.layer.borderWidth = 2
        confirmPasswordLayer.layer.borderColor = UIColor(red:0.81, green:0.81, blue:0.81, alpha:1).cgColor
        confirmPasswordLayer.center.x = view.center.x
        confirmPasswordLayer.addSubview(confirmPasswordField)
        confirmPasswordField.anchor(top: confirmPasswordLayer.topAnchor, left: confirmPasswordLayer.leftAnchor, bottom: confirmPasswordLayer.bottomAnchor, right: confirmPasswordLayer.rightAnchor, paddingTop: 0.0, paddingLeft: (57.5*view.frame.height)/812.0, paddingBottom: 0.0, paddingRight: 0.0)
        confirmPasswordField.isSecureTextEntry = true
        let confirmPasswordPlaceholderContent = "Confirm Password"
        let confirmPasswordPlaceholderString = NSMutableAttributedString(string: confirmPasswordPlaceholderContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)])
        confirmPasswordField.attributedPlaceholder = confirmPasswordPlaceholderString
        self.view.addSubview(confirmPasswordLayer)
        //Confirm Password Field Logo
        let confirmPasswordLogoLayer = UIImageView(frame: CGRect(x: 30, y: 587, width: (33.0*view.frame.height)/812.0, height: (33.0*view.frame.height)/812.0))
        confirmPasswordLogoLayer.backgroundColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1)
        confirmPasswordLayer.addSubview(confirmPasswordLogoLayer)
        confirmPasswordLogoLayer.anchor(top: confirmPasswordLayer.topAnchor, left: confirmPasswordLayer.leftAnchor, bottom: confirmPasswordLayer.bottomAnchor, right: nil, paddingTop: 17, paddingLeft: 15, paddingBottom: -16, paddingRight: 0.0)
        confirmPasswordLogoLayer.image = UIImage(named: "passwordLogo")
        //Sign Up Button
        let signUpButtonLayer = UIButton(frame: CGRect(x: 21, y: (725.0*view.frame.height)/812.0, width: (334.0*view.frame.width)/375, height: (53.0*view.frame.height)/812.0))
        signUpButtonLayer.layer.cornerRadius = 3
        signUpButtonLayer.backgroundColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1)
        signUpButtonLayer.center.x = view.center.x
        self.view.addSubview(signUpButtonLayer)
        //Sign Up View in Button
        let signUpButtonTextLayer = UILabel(frame: CGRect(x: 0.0, y: (744.0*view.frame.height)/812.0, width: (61.0*view.frame.width)/375.0, height: (16.0*view.frame.height)/812.0))
        signUpButtonTextLayer.lineBreakMode = .byWordWrapping
        signUpButtonTextLayer.numberOfLines = 0
        signUpButtonTextLayer.textColor = UIColor.white
        signUpButtonTextLayer.textAlignment = .center
        let signUpButtonTextContent = "Sign up"
        let signUpButtonTextString = NSMutableAttributedString(string: signUpButtonTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 16)!
            ])
        let signUpButtonTextRange = NSRange(location: 0, length: signUpButtonTextString.length)
        let signUpButtonStyle = NSMutableParagraphStyle()
        signUpButtonStyle.lineSpacing = 1.06
        signUpButtonTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:signUpButtonStyle, range: signUpButtonTextRange)
        signUpButtonTextString.addAttribute(NSAttributedString.Key.kern, value: 0.75, range: signUpButtonTextRange)
        signUpButtonTextLayer.attributedText = signUpButtonTextString
        signUpButtonTextLayer.sizeToFit()
        signUpButtonTextLayer.center.x = signUpButtonLayer.center.x
        self.view.addSubview(signUpButtonTextLayer)
        signUpButtonLayer.addTarget(self, action: #selector(signupUser), for: .touchUpInside)
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
    
    /*@objc func dimissKeyboard() {
        view.endEditing(true)
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
