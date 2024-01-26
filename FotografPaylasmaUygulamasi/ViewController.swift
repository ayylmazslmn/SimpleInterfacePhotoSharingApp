//
//  ViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Süleyman Ayyılmaz on 18.01.2024.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func giriTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text! , password: sifreTextField.text!){
                (AuthDataResult, error) in
                if error != nil{
                    self.hataMesajı(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız, Lütfen Tekrar Deneyiniz")
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            // kayıt olma işlemleri
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) {
                (authdataresult, error) in
                if error != nil{
                    self.hataMesajı(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata aldınız, Lütfen Tekrar Deneyiniz")
                    
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            
            hataMesajı(titleInput: "Hata", messageInput: "Email  ve Parola Giriniz")
        }
        
 
    }
    
    func hataMesajı(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

