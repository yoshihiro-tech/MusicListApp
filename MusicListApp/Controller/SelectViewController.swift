//
//  SelectViewController.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/18.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
//tinderのようなライブラリ
import VerticalCardSwiper
//画像のURLからimageViewへ表示するため
import SDWebImage
//インディケーター綺麗に作成
import PKHUD
import Firebase
import ChameleonFramework


class SelectViewController: UIViewController,VerticalCardSwiperDelegate,VerticalCardSwiperDatasource {
    
    //受け取り用の配列(全て入ってくる)
    var artistNameArray = [String]()
    var musicNameArray = [String]()
    var previewURLArray = [String]()
    var imageStringArray = [String]()
    
    var indexNumber = Int()
    var userID = String()
    var userName = String()
    
    //右にスワイプ時に好きなものを入れる配列（選別後）
    var likeArtistNameArray = [String]()
    var likeMusicNameArray = [String]()
    var likePreviewURLArray = [String]()
    var likeImageStringArray = [String]()
    var likeArtistViewUrlArray = [String]()
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardSwiper.delegate = self
        cardSwiper.datasource = self
        //xibファイルを呼び出し
        cardSwiper.register(nib:UINib(nibName: "CardViewCell", bundle: nil), forCellWithReuseIdentifier: "CardViewCell")
        
        cardSwiper.reloadData()
        
    }
    
    
    //カードの数だけ
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        
        return artistNameArray.count
        
    }
    
    //ここが呼ばれる
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        //CardViewCellがあれば
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: index) as? CardViewCell{
            
            //カードの後ろもランダムで色を表示
            verticalCardSwiperView.backgroundColor = UIColor.randomFlat()
            view.backgroundColor = verticalCardSwiperView.backgroundColor
            
            //セル（カード)に配列を表示させる
            let artistName = artistNameArray[index]
            let musicName = musicNameArray[index]
            cardCell.setRandomBackgroundColor()
            cardCell.artistNameLabel.text = artistName
            cardCell.artistNameLabel.textColor = UIColor.white
            cardCell.musicNameLabel.text = musicName
            cardCell.musicNameLabel.textColor = UIColor.white
            
            //imageViewを拾ってくる
            cardCell.artWorkImageView.sd_setImage(with: URL(string: imageStringArray[index]), completed: nil)
            
            return cardCell
            
        }
        //CardViewCellがなくてもCardCellを返す
        return CardCell()
        
    }
    
    
    //スワイプした時に配列の中からスワイプしたものを消去する(配列が崩れるのを防ぐ)
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
          indexNumber = index

              if swipeDirection == .Right {

                  likeArtistNameArray.append(artistNameArray[indexNumber])
                  likeMusicNameArray.append(musicNameArray[indexNumber])
                  likePreviewURLArray.append(previewURLArray[indexNumber])
                  likeImageStringArray.append(imageStringArray[indexNumber])

                  if likeArtistNameArray.count != 0 && likeMusicNameArray.count != 0 && likePreviewURLArray.count != 0 && likeImageStringArray.count != 0 {

                      let musicDataModel = MusicDataModel(artistName: artistNameArray[indexNumber], musicName: musicNameArray[indexNumber], preViewURL: previewURLArray[indexNumber], imageString: imageStringArray[indexNumber], userID: userID, userName: userName)

                      musicDataModel.save()

                  }

              }

              artistNameArray.remove(at: index)
              musicNameArray.remove(at: index)
              previewURLArray.remove(at: index)
              imageStringArray.remove(at: index)
        
    }

    
    
    //スワイプ対応のメソッド
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        
        //何番目がスワイプされたか検知、indexNumberに入れる
        indexNumber = index
        
        //右にスワイプした時に呼ばれる箇所
        if swipeDirection == .Right{
            
            //右にスワイプしたときに好きなものとして新しい配列に入れる
            likeArtistNameArray.append(artistNameArray[indexNumber])
            likeMusicNameArray.append(musicNameArray[indexNumber])
            likePreviewURLArray.append(previewURLArray[indexNumber])
            likeImageStringArray.append(imageStringArray[indexNumber])
            
            //上記配列が0以外の場合DBへ入れる
            if likeArtistNameArray.count != 0 && likeMusicNameArray.count != 0 && likePreviewURLArray.count != 0 && likeImageStringArray.count != 0 {
                
                let musicDataModel = MusicDataModel(artistName: artistNameArray[indexNumber], musicName: musicNameArray[indexNumber], preViewURL: previewURLArray[indexNumber], imageString: imageStringArray[indexNumber], userID: userID, userName: userName)
                
                musicDataModel.save()
                
            }
        }
    }

    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    

}
