//
//  addCheckViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/14.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit
import Photos

class addCheckViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countMovie: UILabel!
    @IBOutlet weak var titleRanking: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var movieListTmp =
        [["title":"タイタニック","image":"","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]

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
        
        // 写真を表示させる
        var url = NSURL(string: dic!["image"] as! String!)
        let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([url!], options: nil)
        if dic!["image"] as! String! != "" {
            let asset: PHAsset = fetchResult.firstObject as! PHAsset
            let manager: PHImageManager = PHImageManager()
            manager.requestImageForAsset(asset,targetSize: CGSizeMake(100, 100),contentMode: .AspectFill,options: nil) { (image, info) -> Void in
                self.imageView.image = image
                //クロージャだから別世界の出来事なのでselfつけないとわかってもらえない
            }
        }
        
        
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
        var doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "clickDoneButton")
        
        
        //ナビゲーションバーの右側にボタン付与
        self.navigationItem.setRightBarButtonItems([addButton,doneButton], animated: true)
        self.navigationItem.hidesBackButton = true
    }
    
    //searchButtonを押した際の処理を記述
    func clickaddButton(){
        let add_new: UIViewController = ViewController()
        self.navigationController?.pushViewController(add_new, animated: true)
    }
    
    //DoneButtonを押した際の処理を記述
    func clickDoneButton(){
        let index: UIViewController = indexViewController()
        self.navigationController?.popToRootViewControllerAnimated(true)
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
