//
//  detailViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/14.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit
import Photos

class detailViewController: UIViewController {
    
    var detailSelectedIndex = -1

    @IBOutlet weak var detailMovieTitle: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailStamp: UILabel!
    @IBOutlet weak var detailComment: UITextView!
    @IBOutlet weak var detailImage: UIImageView!
    
    var movieListTmp =
        [["title":"タイタニック","image":"","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    
    //ナビバーに削除ボタンを設置
    var deleteBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //削除ボタン
        deleteBtn = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "onClick")
        self.navigationItem.rightBarButtonItem = deleteBtn

        //ユーザーデフォルトから保存した配列を取り出して上書きする
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        
        
        //保存ボタンが押されなかった場合にnilが入るタイミングがある
        //その場合は、if文を書いてあげる必要がある
        if (myDefault.objectForKey("movieList") != nil){
            
            movieListTmp = myDefault.objectForKey("movieList") as! [Dictionary]
        }
        
        
    var dic = movieListTmp[detailSelectedIndex]
        detailMovieTitle.text = dic["title"] as String!
        detailDate.text = dic["date"] as String!
        detailStamp.text = dic["stamp"] as String!
        detailComment.text = dic["comment"] as String!
        
        // 写真を表示させる
        var url = NSURL(string: dic["image"] as! String!)
        let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([url!], options: nil)
        if dic["image"] as! String! != "" {
            let asset: PHAsset = fetchResult.firstObject as! PHAsset
            let manager: PHImageManager = PHImageManager()
            manager.requestImageForAsset(asset,targetSize: CGSizeMake(100, 100),contentMode: .AspectFill,options: nil) { (image, info) -> Void in
                self.detailImage.image = image
                //クロージャだから別世界の出来事なのでselfつけないとわかってもらえない
            }
        }
    }
    
    // deleteBtnをタップしたときのアクション
    func onClick() {
        movieListTmp.removeAtIndex(detailSelectedIndex)
        
    }


    
    
//        movieTitle.text = dic["title"] as! String!
//        date.text = dic["date"] as! String!
//        star.text = dic["star"] as! String!
//        stamp.text = dic["stamp"] as! String!
//
    
    

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
