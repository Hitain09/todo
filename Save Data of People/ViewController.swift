//
//  ViewController.swift
//  Save Data of People
//
//  Created by Rishav on 26/04/17.
//  Copyright © 2017 Rishav. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passkeyText: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginSpinner.isHidden = true
        emailText.delegate = self
        passkeyText.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        showActivitySpinner(self.loginSpinner, style: .gray)
        udacityclient.sharedInstance().authenticateUser(username: emailText.text!, password: passkeyText.text!) { (result, error) in
            if error != nil {
                self.showAlert(error!)
                self.hideActivitySpinner(self.loginSpinner)
            } else {
                DispatchQueue.main.async {
                    
                    self.completeLogin()
                    self.hideActivitySpinner(self.loginSpinner)
                }
            }
            
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: udacityconstants.SignUpUrl)!, options: [:], completionHandler: nil)
    }
    
    func completeLogin() {
        emailText.text = ""
        passkeyText.text = ""
        if let mapAndTableTabController = storyboard?.instantiateViewController(withIdentifier: "tableController") {
            present(mapAndTableTabController, animated: true, completion: nil)
        }
        
    }
    
    func showActivitySpinner(_ spinner: UIActivityIndicatorView!, style: UIActivityIndicatorViewStyle) {
        DispatchQueue.main.async {
            let activitySpinner = spinner
            activitySpinner?.activityIndicatorViewStyle = style
            activitySpinner?.hidesWhenStopped = true
            activitySpinner?.isHidden = false
            activitySpinner?.startAnimating()
        }
    }
    
    func hideActivitySpinner(_ spinner: UIActivityIndicatorView!) {
        DispatchQueue.main.async {
            let activitySpinner = spinner
            activitySpinner?.isHidden = true
            activitySpinner?.stopAnimating()
        }
    }
    
    func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func canVerifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}

