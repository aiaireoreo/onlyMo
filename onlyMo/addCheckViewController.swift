//
//  addCheckViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/14.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit

class addCheckViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countMovie: UILabel!
    @IBOutlet weak var titleRanking: UILabel!
    
    var movieListTmp =
        [["title":"タイタニック","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myDefault = NSUserDefaults.standardUserDefaults()
        if (myDefault.objectForKey("movieList") != nil){
            
            movieListTmp = myDefault.objectForKey("movieList") as! [Dictionary]
        
        }
        var dic = movieListTmp.last
        var cntMovie = movieListTmp.count

//        print(dic)
//        print(cntMovie)
        
        titleLabel.text = dic!["title"] as! String!
        countMovie.text = "現在\(cntMovie)本の映画がコレクションされています。"
        
        switch(cntMovie) {
        case 1...10:
            titleRanking.text = "まだまだ映画好きとは言えません"
        case 11...30:
            titleRanking.text = "たまには違うジャンルにチャレンジ"
        default:
            titleRanking.text = "映画監督になれますな"

        }
        
        
        //ナビバーのボタン設定
        var addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "clickaddButton")
        
        var refreshButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "clickRefreshButton")
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
        self.navigationItem.setLeftBarButtonItems([refreshButton], animated: true)
        self.navigationItem.hidesBackButton = true
    }
    
    
    
    func clickaddButton(){
        //searchButtonを押した際の処理を記述
        let add_new: UIViewController = ViewController()
        self.navigationController?.pushViewController(add_new, animated: true)
        
        
    }
    
    func clickRefreshButton(){
        //refreshButtonを押した際の処理を記述
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
