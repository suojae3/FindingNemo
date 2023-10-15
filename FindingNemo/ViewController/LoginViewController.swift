
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth


//MARK: - Properties & Deinit
class LoginViewController: UIViewController {
    
    //0 Title Label
    private let titleLabel = UILabel()
        .withText("Finding Nemo")
        .withFont(40)
        .withFontWeight(.bold)
        .withTextColor(.black)
    
    //1. Background
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .styledWithBlurEffect()
        .withViewModel(viewModel)
    
    //2. TextField for Login
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .styledWithBlurEffect()
    
    private lazy var passwordTextField = UITextField()
        .withPlaceholder("Password")
        .secured()
        .styledWithBlurEffect()
    
    private lazy var loginButton = UIButton()
    
        .withTitle("Login")
        .withTextColor(.black)
        .withTarget(self, action: #selector(loginButtonTapped))
        .styledWithBlurEffect()
        .withCornerRadius(20)
    
    
    //3. Firebase login setting
    private var handle: AuthStateDidChangeListenerHandle?
    
    deinit {
        print("Successfully LoginVC has been deinitialized")
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
    }
    
}


//MARK: - SetupUI

extension LoginViewController {
    
    func setupUI() {
        view.addSubviews(riveView,emailTextField,titleLabel,passwordTextField,loginButton)
        view.withBackgroundImage(named: "Spline", at: CGPoint(x: 1.0, y: 0.8), size: CGSize(width: 700, height: 1000))
        setupConstraints()
    }
    
    func setupConstraints() {
        
        riveView.fullScreen()
        
        emailTextField
            .centerX()
            .centerY()
            .size(250, 40)
        
        titleLabel
            .centerX()
            .above(emailTextField, 50)
        
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
        print("button")
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
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = windowScene.delegate as? SceneDelegate {
                let successVC = SucccessViewController()
                delegate.window?.rootViewController = successVC
                present(successVC, animated: true)
            }
        
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

