//
//  SelectViewController.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/18.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import SDWebImage
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
    
    //右にスワイプ時に好きなものを入れる配列
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
        
        cardSwiper.reloadData()
        
        
        
    }
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        <#code#>
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        <#code#>
    }
    
    

    
    
    

}
