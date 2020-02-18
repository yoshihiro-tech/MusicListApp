//
//  MusicDataModel.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/18.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import Foundation
import Firebase
import PKHUD

class MusicDataModel{
    
    var artistName:String! = ""
    var musicName:String! = ""
    var preViewURL:String! = ""
    var imageString:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    var artistViewUrl:String! = ""
    let ref:DatabaseReference!
    
    var key:String = ""
    
    init(artistName:String,musicName:String,preViewURL:String,imageString:String,userID:String,userName:String) {
        
        self.artistName = artistName
        self.musicName = musicName
        self.preViewURL = preViewURL
        self.imageString = imageString
        self.userID = userID
        self.userName = userName
        
        //ログインの時に拾えるuidを先頭につけて送信、受信する時もuidから拾ってくる
        ref = Database.database().reference().child("users").child(userID).childByAutoId()
        
        
    }
    
    //受信時
    init(snapshot:DataSnapshot){
        
        ref = snapshot.ref
        if let value = snapshot.value as? [String:Any]{
            
            artistName = value["artistName"] as? String
            musicName = value["musicName"] as? String
            imageString = value["imageString"] as? String
            preViewURL = value["preViewURL"] as? String
            userID = value["userID"] as? String
            userName = value["userName"] as? String
            
        }
    }
    
    
    func toContens() ->[String:Any]{
        
        return ["artistName":artistName!,"musicName":musicName!,"preViewURL":preViewURL!,"imageString":imageString!,"userID":userID!,"userName":userName!]
        
    }
    
    
    func save(){
        
        ref.setValue(toContens())
        
    }
    
    
    
    
}
