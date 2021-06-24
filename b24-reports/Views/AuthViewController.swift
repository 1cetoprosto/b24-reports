//
//  ViewController.swift
//  b24-reports
//
//  Created by leomac on 09.04.2021.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
   
    //MARK: Private properties
    private enum UIConstants {
        static let topInset: CGFloat = 100
        static let leftRightInset: CGFloat = 16
        static let spacing: CGFloat = 20
        static let cornerRadius: CGFloat = 10
        static let height: CGFloat = 50
        static let sizeOfImage: CGFloat = 250
    }
    
    private lazy var headerImage: UIImageView = {
        let img = UIImage(named: "Header")
        let imgV = UIImageView(image: img)
        imgV.contentMode = .scaleAspectFit
        
        return imgV
    }()
    
    private lazy var welcomLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Welcome back"
        lbl.font = UIFont(name: "Arial", size: 30)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private lazy var emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.layer.cornerRadius = CGFloat(UIConstants.cornerRadius)
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private lazy var passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.layer.cornerRadius = CGFloat(UIConstants.cornerRadius)
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private lazy var continueButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.7294304967, blue: 0, alpha: 1)
        btn.addTarget(self, action: #selector(signAction), for: .touchUpInside)
        btn.layer.cornerRadius = CGFloat(UIConstants.cornerRadius)
        
        return btn
    }()
    
    lazy var emptyView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var stackView_Main: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.headerImage,
                                                       self.stackView_TF])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.spacing
        
        return stackView
    }()
    
    private lazy var stackView_TF: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.welcomLabel,
                                                       self.emailField,
                                                       self.passwordField,
                                                       self.continueButton,
                                                       self.emptyView])
        stackView.axis = .vertical
        stackView.spacing = UIConstants.spacing
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializer()
    }
    
    private func initializer() {
        view.backgroundColor = .white
        view.addSubview(stackView_Main)
        stackView_Main.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(UIConstants.topInset)
            maker.leading.trailing.equalToSuperview().inset(UIConstants.leftRightInset)
        }
        
        headerImage.snp.makeConstraints { maker in
            maker.height.equalTo(UIConstants.sizeOfImage)
        }
        
        welcomLabel.snp.makeConstraints { maker in
            maker.height.equalTo(UIConstants.height)
        }
        
        emailField.snp.makeConstraints { maker in
            maker.height.equalTo(UIConstants.height)
        }
        
        passwordField.snp.makeConstraints { maker in
            maker.height.equalTo(UIConstants.height)
        }
        
        continueButton.snp.makeConstraints { maker in
            maker.height.equalTo(UIConstants.height)
        }
        
        emptyView.snp.makeConstraints { maker in
            //maker.bottom.equalTo(20)
            maker.height.equalTo(UIConstants.height)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill in all fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func signAction(_ sender: Any) {
        
        let email = emailField.text!
        let password = passwordField.text!
        
        if (email.isEmpty && password.isEmpty) {
            showAlert()
            return
        }
        
        logIn(email: email, password: password) { (firebaseUser: FirebaseAuth.User?) in
          // Your result is saved in firebaseUser variable
          if firebaseUser != nil{
            self.transitionToCallsTableViewController()
          }

        }
    }
    
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

        let callsVC = CallsViewController()  //storyboard?.instantiateViewController(identifier: "NavigationController") as? UINavigationController else {return}
        let navi =  UINavigationController.init(rootViewController: callsVC)
        view.window?.rootViewController = navi
        view.window?.makeKeyAndVisible()
    }
}



















