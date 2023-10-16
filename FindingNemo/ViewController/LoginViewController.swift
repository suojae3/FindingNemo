
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth
import AuthenticationServices


//MARK: - Properties & Deinit
final class LoginViewController: UIViewController {
    
    //0. Title Label
    private lazy var titleLabel = UILabel()
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
    
    private lazy var appleLoginButton = UIButton()
        .styledWithBlurEffect()
        .withCornerRadius(25)
        .withIcon(named: "apple.logo", isSystemIcon: true, pointSize: 27.0, color: .black)
        .withTarget(self, action: #selector(appleLoginButtonTapped))
    
    private lazy var kakaoLoginButton = UIButton()
    
    //4. Keyboard Handling
    private var emailTextFieldCenterYConstraint: Constraint?
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}


//MARK: - ViewCycle
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addNotificationObserver()
        view.addGestureRecognizer(tapGesture)
        
    }
}


//MARK: - SetupUI

private extension LoginViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        view.withBackgroundImage(named: "Spline", at: CGPoint(x: 1.0, y: 0.8), size: CGSize(width: 700, height: 1000))
        view.addSubviews(riveView,emailTextField,titleLabel,passwordTextField,loginButton,appleLoginButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        riveView.fullScreen()
        
        emailTextField
            .centerX()
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
        
        appleLoginButton
            .below(loginButton, 20)
            .centerX()
            .size(70, 70)
    }
}


//MARK: - Button Action
private extension LoginViewController {
    
    @objc func loginButtonTapped() {
        guard hasValidInput else {
            showAlertButtonTapped()
            return
        }
        authenticateUser()
    }
    
    @objc func appleLoginButtonTapped() {
        loginAppleID()
    }
}


//MARK: - Authenticate User
private extension LoginViewController {
    
    var hasValidInput: Bool {
        return !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    }
    
    func authenticateUser() {
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

//MARK: - Apple Social Login
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private func loginAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Firebase authentication
            let appleIDToken = appleIDCredential.identityToken
            let appleIDProviderCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                    idToken: String(data: appleIDToken!, encoding: .utf8) ?? "",
                                                                    rawNonce: nil)
            
            Auth.auth().signIn(with: appleIDProviderCredential) { (authResult, error) in
                if let error = error {
                    print("Error authenticating with Firebase: \(error.localizedDescription)")
                    return
                }
                
                // Successfully authenticated with Firebase
                print("Successfully authenticated with Firebase using Apple Sign In!")
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let delegate = windowScene.delegate as? SceneDelegate {
                    let successVC = SucccessViewController()
                    delegate.window?.rootViewController = successVC
                    self.present(successVC, animated: true)
                }
            }
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id: \(userIdentifier) \n Full Name: \(String(describing: fullName)) \n Email: \(String(describing: email))")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error with Apple Sign In: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
    
}

//MARK: - Alert
private extension LoginViewController {
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
private extension LoginViewController {
    
    func addNotificationObserver() {
        emailTextFieldCenterYConstraint = emailTextField.centerY()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            emailTextFieldCenterYConstraint?.update(offset: -keyboardHeight/2)
            
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
