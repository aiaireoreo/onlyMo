//
//  indexViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/14.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit
import Photos
import GoogleMobileAds

class indexViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var myMovieCollection: UICollectionView!
    
    var movieListTmp =
        [["title":"TOYSTORY3","image":"","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    var selectedIndex = -1
    
    //ナビバー新規追加ボタン
    var addBtn: UIBarButtonItem!
    
    // AdMob ID
    let AdMobID = "ca-app-pub-3530000000000000/0123456789"
    let TEST_DEVICE_ID = "61b0154xxxxxxxxxxxxxxxxxxxxxxxe0"
    let AdMobTest:Bool = true
    let SimulatorTest:Bool = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Shelf"
        // addBtnを設置
        addBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onClick")
        self.navigationItem.rightBarButtonItem = addBtn
        
        
//        配列から辞書型に変更したので一度だけユーザーデフォルトを全削除する
//        var appDomain:String = NSBundle.mainBundle().bundleIdentifier!
//        myDefault.removePersistentDomainForName(appDomain)
        //ここまで書いたら一度プレビュー再生して、コメントアウト
        
        // admob挿入
        var admobView: GADBannerView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        
        //位置を指定
        //        admobView.frame.origin = CGPointMake(0, 20)
        //        下に表示
        admobView.frame.origin = CGPointMake(0, self.view.frame.size.height - admobView.frame.height)
        
        
        //サイズを指定
        admobView.frame.size = CGSizeMake(self.view.frame.width, admobView.frame.height)
        admobView.adUnitID = AdMobID
//        admobView.delegate = self
        admobView.rootViewController = self
        
        let admobRequest:GADRequest = GADRequest()
        
        if AdMobTest {
            if SimulatorTest {
                admobRequest.testDevices = [kGADSimulatorID]
            }
            else {
                admobRequest.testDevices = [TEST_DEVICE_ID]
            }
            
        }
        
        admobView.loadRequest(admobRequest)
        
        self.view.addSubview(admobView)

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //ユーザーデフォルトから保存した配列を取り出して上書きする
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        if (myDefault.objectForKey("movieList") != nil){
            movieListTmp = myDefault.objectForKey("movieList") as! [Dictionary]
        }
        
        print(movieListTmp)
        
        myMovieCollection.reloadData()
    }
    
    
    
    
    // addBtnをタップしたときのアクション
    func onClick() {
        let addView = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController")
        self.navigationController?.pushViewController(addView!, animated: true)
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
        
        
        
//        if dic["image"] as! String! == ""{
//            
//            self.detailImage.image = UIImage(named: "toystory.jpeg")
//            
//        } else {
//            let asset: PHAsset = fetchResult.firstObject as! PHAsset
//            let manager: PHImageManager = PHImageManager()
//            manager.requestImageForAsset(asset,targetSize: CGSizeMake(500, 500),contentMode: .AspectFill,options: nil) { (image, info) -> Void in
//                self.detailImage.image = image
//                //クロージャだから別世界の出来事なのでselfつけないとわかってもらえない
//            }
//        }

        // 写真を表示させる
        if movieListTmp[indexPath.row]["image"] as! String! != "" && movieListTmp[indexPath.row]["image"] != nil{
            var url = NSURL(string: movieListTmp[indexPath.row]["image"] as! String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([url!], options: nil)
            let asset: PHAsset = fetchResult.firstObject as! PHAsset
            let manager: PHImageManager = PHImageManager()
            manager.requestImageForAsset(asset,targetSize: CGSizeMake(5, 500),contentMode: .AspectFill,options: nil) { (image, info) -> Void in
                cell.indexImage.image = image
            }
        }else{
                cell.indexImage.image = UIImage(named: "toystory.jpeg")

            }
        return cell

        }
    
    
    // 選択された時に行う処理
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("\(indexPath.row)個目を選択")
        selectedIndex = indexPath.row
       // performSegueWithIdentifier("showDetail",sender: nil)
        
        return true
    }
    
    
    // Segueで画面遷移する時
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var detailVC = segue.destinationViewController as! detailViewController
            detailVC.detailSelectedIndex = selectedIndex
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
