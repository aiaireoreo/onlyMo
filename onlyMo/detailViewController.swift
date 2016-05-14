//
//  detailViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/14.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    var detailSelectedIndex = -1

    @IBOutlet weak var detailMovieTitle: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailStamp: UILabel!
    @IBOutlet weak var detailComment: UITextView!
    
    var movieListTmp =
        [["title":"タイタニック","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
