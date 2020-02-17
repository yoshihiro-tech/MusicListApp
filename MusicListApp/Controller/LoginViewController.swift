//
//  LoginViewController.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/16.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DTGradientButton


class LoginViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
       
        //ボタンの背景色
        loginButton.setGradientBackgroundColors([UIColor(hex:"E21F70"),UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        
    }
    

    //キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        //textFieldの値が空でない場合、textFieldの値をアプリ内に保存
        //空ならば振動させる
        if textField.text?.isEmpty != true{
            
            UserDefaults.standard.set(textField.text, forKey: "userName")
            
        }else{
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        }
        
        
        //firebaseAuthの中にIDと名前(textField.text)を入れる
        //匿名サインイン errorでなければresultに値が入ってくる
        Auth.auth().signInAnonymously { (result, error) in
            
            if error == nil{
                
                guard let user = result?.user else{ return }
                let userID = user.uid
                
                //アプリ内にも保持
                UserDefaults.standard.set(userID, forKey: "userID")
                
                //DBの中へIDとNameを入れる
                let saveProfile = SaveProfile(userID: userID, userName: self.textField.text!)
                saveProfile.saveProfile()
                //閉じる
                self.dismiss(animated: true, completion: nil)
                
                
            }else{
                
                print(error?.localizedDescription as Any)
                
            }
        }
        
        
        
    }
    
    
    
    
    

}
