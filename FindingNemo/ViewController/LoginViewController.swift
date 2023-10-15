
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth


//MARK: - Properties & Deinit
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
        
        guard hasValidInput else {
            showAlertButtonTapped()
            return
        }
        authenticateUser()
    }
}


//MARK: - Authenticate User
extension LoginViewController {
    
    var hasValidInput: Bool {
        return !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    }
    
    private func authenticateUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlertButtonTapped()
                print(error.localizedDescription)
                return
            }
            print("Successfully logged in!")
        }
    }
}


//MARK: - Alert
extension LoginViewController {
    func showAlertButtonTapped() {
        Alert.show(on: self,
                   title: "Alert Title",
                   message: "This is an alert with a blurred background.",
                   actions: [
                    AlertAction(title: "Cancel", style: .cancel, handler: nil),
                    AlertAction(title: "OK", style: .default, handler: {
                        print("OK pressed")
                    })
                   ]
        )
    }
    
}
