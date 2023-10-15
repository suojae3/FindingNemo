
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth


//MARK: - Properties & Deinit
class LoginViewController: UIViewController {
    
    //0. Title Label
    private let titleLabel = UILabel()
        .withText("Finding Nemo")
        .withFont(40)
        .withFontWeight(.bold)
        .withTextColor(.black)
    
    //1. Background animation
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .styledWithBlurEffect()
        .withViewModel(viewModel)
    
    //2. TextField for Login
    private lazy var emailTextField = UITextField()
        .withPlaceholder("  Email")
        .styledWithBlurEffect()
    
    private lazy var passwordTextField = UITextField()
        .withPlaceholder("  Password")
        .secured()
        .styledWithBlurEffect()
    
    //3. Button for Login
    private lazy var loginButton = UIButton()
        .withTitle("Login")
        .withTextColor(.black)
        .withTarget(self, action: #selector(loginButtonTapped))
        .styledWithBlurEffect()
        .withCornerRadius(20)
    
    //4. Button for Social Login
    private lazy var appleLoginButton = UIButton()
        .styledWithBlurEffect()
        .withCornerRadius(25)
        .withIcon(named: "apple.logo", isSystemIcon: true, pointSize: 27.0)
        .withTarget(self, action: #selector(appleLoginButtonTapped))

    
    //4. Keyboard Handling
    private var emailTextFieldCenterYConstraint: Constraint?
    
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}


//MARK: - ViewCycle
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }    
}


//MARK: - SetupUI

extension LoginViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubviews(riveView,emailTextField,titleLabel,passwordTextField,loginButton,appleLoginButton)
        view.withBackgroundImage(named: "Spline", at: CGPoint(x: 1.0, y: 0.8), size: CGSize(width: 700, height: 1000))
        setupConstraints()
    }
    
    func setupConstraints() {
        
        
        riveView.fullScreen()
        
        emailTextField
            .centerX()
            .size(250, 40)
        emailTextFieldCenterYConstraint = emailTextField.centerY()
        
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
        
        appleLoginButton
            .below(loginButton, 20)
            .centerX()
            .size(70, 70)
        
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
    
    @objc func appleLoginButtonTapped() {
        
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


//MARK: - Keyboard Handling
extension LoginViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            emailTextFieldCenterYConstraint?.update(offset: -keyboardHeight/4)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        emailTextFieldCenterYConstraint?.update(offset: 0)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
