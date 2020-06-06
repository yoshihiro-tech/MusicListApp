//
//  SaveProfile.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/17.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import Foundation
import Firebase
import PKHUD

class SaveProfile {
    
    //サーバに値を飛ばす

    var userID:String! = ""
    var userName:String! = ""
    var ref:DatabaseReference!
    
    init(userID:String,userName:String){
        
        self.userID = userID
        self.userName = userName
        
        //ログイン時に拾えるuidを先頭につけて送信する。refが生成される。受信する時もuidから引っ張ってくる。
        
        ref = Database.database().reference().child("profile").childByAutoId()
        
    }
    
    init(snapShot:DataSnapshot){
        
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any]{
            
            userID = value["userID"] as? String
            userName = value["userName"] as? String
            
        }
    
    }
    
    //外部からのIDとNameを上部でselfとし、それをkey値"userID""userName"として返す
    func toContents() -> [String:Any]{
        
        return ["userID":userID!,"userName":userName as Any]
        
    }
    
    
    func saveProfile(){
        
        //toContentsメソッドでuserIDとuserNameに値を入れているものをref(DBの中のProfileのchildByAutoIdの下)にset
        ref.setValue(toContents())
        UserDefaults.standard.set(ref.key, forKey: "autoID")
        
    }
    
}
