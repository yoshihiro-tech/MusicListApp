//
//  ListTableViewController.swift
//  MusicListApp
//
//  Created by Yoshihiro Uda on 2020/02/20.
//  Copyright © 2020 Yoshihiro Uda. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class ListTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var listRef = Database.database().reference()
    var indexNumber = Int()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        HUD.show(.success)
        //コンテンツを取得する
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           <#code#>
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           <#code#>
       }
   
    
    
    
    
    
    

}
