//
//  ViewController.swift
//  b24-reports
//
//  Created by leomac on 09.04.2021.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    /*
     var signup: Bool = true {
     willSet{
     if newValue {
     titleLabel.text = "Sign up"
     nameField.isHidden = false
     enterButton.setTitle("Sign up", for: .normal)
     haveAccountLabel.text = "You have an accaunt?"
     switchButton.setTitle("Sign in", for: .normal)
     } else {
     titleLabel.text = "Welcom back"
     nameField.isHidden = true
     enterButton.setTitle("Continue", for: .normal)
     haveAccountLabel.text = "Don't have an accaunt?"
     switchButton.setTitle("Sign up", for: .normal)
     }
     }
     }
     */
    
    
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    //@IBOutlet weak var haveAccountLabel: UILabel!
    //@IBOutlet weak var switchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cornerRadius: Int = 20
        //nameField.layer.cornerRadius = CGFloat(cornerRadius)
        emailField.layer.cornerRadius = CGFloat(cornerRadius)
        passwordField.layer.cornerRadius = CGFloat(cornerRadius)
        enterButton.layer.cornerRadius = CGFloat(cornerRadius)
        //        nameField.delegate = self
        //        emailField.delegate = self
        //        passwordField.delegate = self
        //signup = false
    }
    
    /*
     @IBAction func switchLogin(_ sender: UIButton) {
     signup = !signup
     }
     */
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill in all fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signAction(_ sender: Any) {
        
        //let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        /*
         if signup {
         if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
         Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
         if error == nil {
         //print("Created user with UID: \(result!.user.uid)")
         FIRFirestoreService.shared.addUpdateDocument(collection: "users",
         idDocement: result!.user.uid,
         data: ["name":name, "email":email])
         
         }
         }
         } else {
         showAlert()
         }
         } else {
         */
        if (email.isEmpty && password.isEmpty) {
            showAlert()
            return
        }
        
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            guard error == nil else { return self.displayError(error) }
//        }
//
//        self.transitionToTabBarViewController()
        
        logIn(email: email, password: password) { (firebaseUser: FirebaseAuth.User?) in
          // Your result is saved in firebaseUser variable
          if firebaseUser != nil{
            self.transitionToCallsTableViewController()
          }

        }
    }
    //}
    
    func logIn(email: String, password: String, callbacK: @escaping (FirebaseAuth.User?) -> ()) {
      Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        if error != nil {
          //print(error!)
            callbacK(nil)
        }
        callbacK(user?.user)
      }
    }
    
    private func transitionToCallsTableViewController() {
        /*
         guard let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {return}
         self.view.window?.rootViewController = TabBarController
         self.view.window?.makeKeyAndVisible()
         */

        guard let callsVC = storyboard?.instantiateViewController(identifier: "NavigationController") as? UINavigationController else {return}
        view.window?.rootViewController = callsVC
        view.window?.makeKeyAndVisible()
    }
}



















