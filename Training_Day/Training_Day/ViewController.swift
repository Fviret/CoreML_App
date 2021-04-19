//
//  ViewController.swift
//  Training_Day
//
//  Created by Florian  on 13/04/2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var WaitView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(hide), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authWithBiometrics), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func hide(){
        WaitView.isHidden = false
    }
    
    @objc func authWithBiometrics(){
        if !WaitView.isHidden {
            let context = LAContext()
            let policy : LAPolicy = .deviceOwnerAuthenticationWithBiometrics
            let reason : String = "Acceder à l appli"
            var error : NSError?
            if context.canEvaluatePolicy(policy, error: &error){
                context.evaluatePolicy(policy, localizedReason: reason) { (success, error) in
                    DispatchQueue.main.async {
                        if let e = error{
                            let controller = UIAlertController(title: "Erreur", message: e.localizedDescription, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                            controller.addAction(ok)
                            self.present(controller, animated: true, completion: nil)
                                }
                        self.WaitView.isHidden = success
                    }
                }
            }
        }
    }


}

