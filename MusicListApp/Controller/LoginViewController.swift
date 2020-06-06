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
//ボタンの背景を綺麗に作成
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
    

    //リターンキーが押された時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        //textFieldの値が空でない場合、
        if textField.text?.isEmpty != true{
            //textFieldの値をアプリ内に保存
            UserDefaults.standard.set(textField.text, forKey: "userName")
            
        }else{
            //空ならば振動させる
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        }
        
        //匿名サインイン メソッドがerrorでなければresultに値が入ってくる(Authentication)。ただDBへは入っていない。
        Auth.auth().signInAnonymously { (result, error) in
            
            if error == nil{
                
                guard let user = result?.user else{ return }
                let userID = user.uid
                
                //アプリ内にも保持
                UserDefaults.standard.set(userID, forKey: "userID")
                
                //DBの中へIDとNameを入れる(Model作成)
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
