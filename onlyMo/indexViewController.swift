//
//  indexViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/14.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit

class indexViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var movieListTmp =
        [["title":"タイタニック","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ユーザーデフォルトから保存した配列を取り出して上書きする
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        if (myDefault.objectForKey("movieList") != nil){
            
            movieListTmp = myDefault.objectForKey("movieList") as! [Dictionary]
            
        }
        print(movieListTmp)


    }
    
    //セクション数を１に設定
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListTmp.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:customCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! customCell
        
//        let url = NSURL(string: movieListTmp[indexPath.row]["title"] as! String!);
//        var err: NSError?;
////        let imageData :NSData = (try! NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe));
////        var img = UIImage(data:imageData);
        
        cell.indexMovieTitle.text = movieListTmp[indexPath.row]["title"] as! String!
        cell.indexStamp.text = movieListTmp[indexPath.row]["stamp"] as! String!

        
        //セルの背景を黒に設定
        cell.backgroundColor = UIColor.blackColor()
        return cell
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
