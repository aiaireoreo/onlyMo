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
    var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ユーザーデフォルトから保存した配列を取り出して上書きする
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        if (myDefault.objectForKey("movieList") != nil){
            
            movieListTmp = myDefault.objectForKey("movieList") as! [Dictionary]
            
        }
        print(movieListTmp)


    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieListTmp.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:customCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! customCell
        cell.indexMovieTitle.text = movieListTmp[indexPath.row]["title"] as! String!
        cell.indexStamp.text = movieListTmp[indexPath.row]["stamp"] as! String!
        return cell
    }
    
    // 選択された時に行う処理
    func collectionView(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)個目を選択")
        selectedIndex = indexPath.row
        print(selectedIndex)
        performSegueWithIdentifier("showDetail",sender: nil)
    }
//    
//    // Segueで画面遷移する時
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//        var detailVC = segue.destinationViewController as! detailViewController
//            
//            detailVC.detailSelectedIndex = selectedIndex
//        }
//    }
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
