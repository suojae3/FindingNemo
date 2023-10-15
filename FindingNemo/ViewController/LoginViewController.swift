//
//  ViewController.swift
//  FindingNemo
//
//  Created by ㅣ on 2023/10/15.
//

import UIKit
import SnapKit
import RiveRuntime


//MARK: Properties & Deinit
class LoginViewController: UIViewController {

    //1. Background
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .styledWithBlurEffect()
        .withViewModel(viewModel)
    
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
        view.addSubviews(riveView)
        setupConstraints()
    }
    
    func setupConstraints() {
        riveView.fullScreen()
    }
}


