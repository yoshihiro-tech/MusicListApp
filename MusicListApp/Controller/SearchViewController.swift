//
//  SearchViewController.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/17.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON
import DTGradientButton
import FirebaseAuth
import Firebase
import ChameleonFramework


class SearchViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    var artistNameArray = [String]()
    var musicNameArray = [String]()
    var previewURLArray = [String]()
    var imageStringArray = [String]()
    var userID = String()
    var userName = String()
    var autoID = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ログインされていれば"autoID"を変数autoIDへ入れる
        if UserDefaults.standard.object(forKey: "autoID") != nil{
            
            autoID = UserDefaults.standard.object(forKey: "autoID") as! String
            
        }else{
            
            //ログインしていなければログイン画面を先に出す必要がある
            //storyboard指定、storyboardID指定、画面モードをfullに、遷移
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
            
        }
        
        //ログインされていれば"userID,userName"をそれぞれ変数へ入れる
        if UserDefaults.standard.object(forKey: "userID") != nil && UserDefaults.standard.object(forKey: "userName") != nil{
            
            userID = UserDefaults.standard.object(forKey: "userID") as! String
            userName = UserDefaults.standard.object(forKey: "userName") as! String
            
        }
       
        //"searchTextField"の表示と同時にキーボードを出す
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        
        //ボタンの背景色(グラデーションをつける)
        favButton.setGradientBackgroundColors([UIColor(hex:"E21F70"),UIColor(hex:"FF4D2C")], direction: .toBottom, for: .normal)
        listButton.setGradientBackgroundColors([UIColor(hex:"FF8960"),UIColor(hex:"FF62A5")], direction: .toBottom, for: .normal)
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //ナビゲーションバーの色設定
        //ナビゲーションバーのバックボタンを消す
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.flatRed()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
   
    
    //Returnキーでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Searchを行う
        
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    //TextField以外の部分をタッチした場合にキーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        searchTextField.resignFirstResponder()
        
    }
    
    
    @IBAction func moveToSelectCardView(_ sender: Any) {
        
        //パースを行う
        startParse(keyword:searchTextField.text!)
        
    }
    

    //画面遷移のメソッド
    func moveToCard(){
        
        performSegue(withIdentifier: "selectVC", sender: nil)
        
    }
    
    
    //値を渡しながら画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchTextField.text != nil && segue.identifier == "selectVC"{
            
            let selectVC = segue.destination as! SelectViewController
            selectVC.artistNameArray = self.artistNameArray
            selectVC.imageStringArray = self.imageStringArray
            selectVC.musicNameArray = self.musicNameArray
            selectVC.previewURLArray = self.previewURLArray
            selectVC.userID = self.userID
            selectVC.userName = self.userName
            
        }
        
    }
    
    
    
    func startParse(keyword:String){
        
        HUD.show(.progress)
        
        //検索かけるたびに配列に値が残るのを防ぐために初期化する
        imageStringArray = [String]()
        previewURLArray = [String]()
        artistNameArray = [String]()
        musicNameArray = [String]()
        
        let urlString = "https://itunes.apple.com/search?term=\(keyword)&country=jp"
        
        //keywordが日本語で入ってくるのでエンコードする
        let encodeURLString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        //Alamofireで通信し、JSONが返ってきたらresponseに入る
        AF.request(encodeURLString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{(response) in
            
            //JSONで表示されているものを取得
            switch response.result{
                
            case .success:
                
                let json:JSON = JSON(response.data as Any)
                //検索結果の数を入れる。"resultCount"を取得できる。
                var resultCount:Int = json["resultCount"].int!
                //検索結果数分forを回し内容を取得
                for i in 0 ..< resultCount{
                    
                    var artWorkUrl = json["results"][i]["artworkUrl60"].string
                    let previewUrl = json["results"][i]["previewUrl"].string
                    let artistName = json["results"][i]["artistName"].string
                    let trackCensoredName = json["results"][i]["trackCensoredName"].string
                    
                    //画像を拡大
                    if let range = artWorkUrl!.range(of: "60x60bb"){
                        
                        artWorkUrl?.replaceSubrange(range, with: "320x320bb")
                        
                    }
                    
                    //forで回したものを配列に入れる
                    self.imageStringArray.append(artWorkUrl!)
                    self.previewURLArray.append(previewUrl!)
                    self.artistNameArray.append(artistName!)
                    self.musicNameArray.append(trackCensoredName!)
                    
                    //全て取得したらカード画面へ遷移
                    if self.musicNameArray.count == resultCount{
                        
                        self.moveToCard()
                        
                    }
                    
                }
                
                //HUD終了
                HUD.hide()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
 
    
    @IBAction func moveToFav(_ sender: Any) {
        
        let favVC = self.storyboard?.instantiateViewController(identifier: "fav") as! FavoriteViewController
        
        self.navigationController?.pushViewController(favVC, animated: true)
        
    }
    
    
    @IBAction func moveToList(_ sender: Any) {
        
        let listVC = self.storyboard?.instantiateViewController(identifier: "list") as! ListTableViewController
               
        self.navigationController?.pushViewController(listVC, animated: true)
        
        
    }
    
}
