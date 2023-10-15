//
//  ViewController.swift
//  FindingNemo
//
//  Created by ㅣ on 2023/10/15.
//

import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth


//MARK: Properties & Deinit
class LoginViewController: UIViewController {
    
    //1. Background
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .styledWithBlurEffect()
        .withViewModel(viewModel)
    
    //2. TextField for Login
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
    
    private lazy var passwordTextField = UITextField()
        .withPlaceholder("Password")
        .secured()
    
    private lazy var loginButton = UIButton()
        .withBackgroundColor(.white)
        .withCornerRadius(20)
        .withTitle("Login")
        .withTextColor(.black)
        .withTarget(self, action: #selector(loginButtonTapped))
    
    
    
    //3. Firebase login setting
    private var handle: AuthStateDidChangeListenerHandle?
    
    deinit {
        print("\(self) has been deinitialized")
    }
}




//MARK: - ViewCycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View frame: \(view.frame)")
    }
    
}


//MARK: - SetupUI

extension LoginViewController {
    func setupUI() {
        view.addSubviews(riveView,emailTextField,passwordTextField,loginButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        riveView.fullScreen()
        
        emailTextField
            .centerX()
            .centerY()
            .size(250, 40)
        
        passwordTextField
            .below(emailTextField, 20)
            .centerX()
            .size(250, 40)
        
        loginButton
            .below(passwordTextField, 20)
            .centerX()
            .size(150, 40)
    }
}


//MARK: - Button Action
extension LoginViewController {
    @objc func loginButtonTapped() {
        authenticateUser()
    }
}


//MARK: - Authenticate User
extension LoginViewController {
    
    func authenticateUser() {
        Auth.auth().signIn(
            withEmail: emailTextField.text!,
            password: passwordTextField.text!) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    return
                }
                
                if authResult != nil {
                    print("로그인 성공")
                }
            }
    }
}
