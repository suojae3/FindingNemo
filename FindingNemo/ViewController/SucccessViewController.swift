//
//  ViewController.swift
//  FindingNemo
//
//  Created by ㅣ on 2023/10/15.
//

import UIKit
import FirebaseAuth


//MARK: Properties & Deinit
class SucccessViewController: UIViewController {
    
    //1. Firebase login setting
    private var handle: AuthStateDidChangeListenerHandle?

    
    deinit {
        print("Successfully SuccessVC has been deinitialized")
    }
}


//MARK: - ViewCycle
extension SucccessViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .yellow
    
    
        
    }
}


//MARK: - SetupUI

extension SucccessViewController {
    
}
