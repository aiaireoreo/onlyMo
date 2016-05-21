//
//  ViewController.swift
//  onlyMo
//
//  Created by AI Matsubara on 2016/05/13.
//  Copyright © 2016年 AI Matsubara. All rights reserved.
//

import UIKit
import AssetsLibrary


class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var feelingField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var addNewBtn: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var starZone: CosmosView!
    
    
    
    let nowDate = NSDate()
    let dateFormat = NSDateFormatter()
    let inputDatePicker = UIDatePicker()
    
    
    //絵文字選択
    var data = ["-","💖", "😭", "😡","👻","👍"]
    var picker = UIPickerView()
    
    var movieList =
        [["title":"TOY STORY3","image":"","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    
    //選択したカメラロールの写真の場所
    var selectAssetsUrl = ""
//    var selectedIndex = -1
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageView.image = UIImage(named: "image.png")

        //ユーザーデフォルトに保存
        var myDefault = NSUserDefaults.standardUserDefaults()
        if (myDefault.objectForKey("movieList") != nil){
            movieList = myDefault.objectForKey("movieList") as! [Dictionary]
            
            ImageView.contentMode = .ScaleAspectFit
            
//            //配列から辞書型に変更したので一度だけユーザーデフォルトを全削除する
            var appDomain:String = NSBundle.mainBundle().bundleIdentifier!
            myDefault.removePersistentDomainForName(appDomain)
//            //ここまで書いたら一度プレビュー再生して、コメントアウト
        }
        
        print(movieList)
        
        //キーボード閉じる
        titleTextField.delegate = self
        commentField.delegate = self
        
        //テキストビューの完了ボタン
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        kbToolBar.barStyle = UIBarStyle.Default
        kbToolBar.sizeToFit()
        kbToolBar.barStyle = .BlackTranslucent
        kbToolBar.tintColor = UIColor.whiteColor()
        kbToolBar.backgroundColor = UIColor.blackColor()
        
        commentField.layer.borderWidth = 0.5
        commentField.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentField.layer.cornerRadius = 8
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "commitButtonTapped")
        kbToolBar.items = [spacer, commitButton]
        commentField.inputAccessoryView = kbToolBar
        
        // DatePickerの設定(日付用)
        dateFormat.dateFormat = "yyyy/MM/dd"
        dateTextField.text = dateFormat.stringFromDate(nowDate)
        self.dateTextField.delegate = self
        inputDatePicker.datePickerMode = UIDatePickerMode.Date
        dateTextField.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .BlackTranslucent
        pickerToolBar.tintColor = UIColor.whiteColor()
        pickerToolBar.backgroundColor = UIColor.blackColor()
        
        //入力完了ボタン右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,target: self,action: "")
        
        //日付選択の完了ボタン
        let toolBarBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "toolBarBtnPush:")
        
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        dateTextField.inputAccessoryView = pickerToolBar
        
        
        //フィーリング絵文字選択
        picker.delegate = self
        picker.dataSource = self
        feelingField.inputView = picker
        
        let feelingToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        feelingToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        feelingToolBar.barStyle = .BlackTranslucent
        feelingToolBar.tintColor = UIColor.whiteColor()
        feelingToolBar.backgroundColor = UIColor.blackColor()
        
        //入力完了ボタン・右寄せのためのスペース設定
        let spaceBarBtn2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,target: self,action: "")
        
        //絵文字選択の完了ボタン
        let feelingToolBarBtn = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "toolBarBtnPush:")
        feelingToolBar.items = [spaceBarBtn,feelingToolBarBtn]
        feelingField.inputAccessoryView = feelingToolBar
    }
    
        
    func pickImageFromLibrary() {
            
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {    //追記
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言しているという理解
            let controller = UIImagePickerController()
            //おまじないという認識で今は良いと思う
            controller.delegate = self
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.presentViewController(controller, animated: true, completion: nil)
            
        }
    }
    
//        /**
//         写真を選択した時に呼ばれる (swift2.0対応)
//         
//         :param: picker:おまじないという認識で今は良いと思う
//         :param: didFinishPickingMediaWithInfo:おまじないという認識で今は良いと思う
////         */
//        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String: AnyObject]) {
//            
//            //このif条件はおまじないという認識で今は良いと思う
//            if didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] != nil {
//                
//                //didFinishPickingMediaWithInfo通して渡された情報(選択された画像情報が入っている？)をUIImageにCastする
//                //そしてそれを宣言済みのimageViewへ放り込む
//                ImageView.image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage
//            }
//
//            
//            //写真選択後にカメラロール表示ViewControllerを引っ込める動作
//            picker.dismissViewControllerAnimated(true, completion: nil)
//        }

    
    
    @IBAction func tapImage(sender: UITapGestureRecognizer) {
        print("タップされてる")
        pickImageFromLibrary()  //ライブラリから写真を選択する
    }
    
//
//    @IBAction func tapAdd(sender: UIButton) {
//        if titleTextField.text!.isEmpty {
//            let alertController = UIAlertController(title: "タイトルが入力されていません。", message: "タイトルの入力は必須です。", preferredStyle: .Alert)
//            
//            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alertController.addAction(defaultAction)
//            
//            presentViewController(alertController, animated: true, completion: nil);            return
//        }
//
//     }
    
    //登録完了ボタンが押されたら条件分岐してセグエにデータを渡す
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if titleTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "タイトルが入力されていません。", message: "タイトルの入力は必須です。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return false
            
        } else {
            
            if ImageView.image == UIImage(named: "image.png") {//もしサンプル画像のままだったら
                let alertController = UIAlertController(title: "画像が登録されていません。", message: "画像の登録は必須です。", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
                return false

                
            } else {
        movieList.append(["title":titleTextField.text!,"image":selectAssetsUrl,"date":dateTextField.text!,"star":starZone.rating.description,"stamp":feelingField.text!,"comment":commentField.text!])
            var myDefault = NSUserDefaults.standardUserDefaults()
            myDefault.setObject(movieList, forKey: "movieList")
            myDefault.synchronize()
            
//            var addCheckVC = segue.destinationViewController as! addCheckViewController
//            addCheckVC.selectedIndex = selectedIndex

            
            return true
                
            }
            
        }
    }
    
    
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "showAddCheck" {
//            movieList.append(["title":titleTextField.text!,"image":selectAssetsUrl,"date":dateTextField.text!,"stamp":feelingField.text!,"comment":commentField.text!])
//            
//            print(movieList)
//            
//            var myDefault = NSUserDefaults.standardUserDefaults()
//            myDefault.setObject(movieList, forKey: "movieList")
//            myDefault.synchronize()
//
//            //var addCheckVC = segue.destinationViewController as! addCheckViewController
//           // addCheckVC.selectedIndex = selectedIndex
//            
//        }
//    }

    
    
    //絵文字選択
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        feelingField.text = data[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data[row]
    }
    
    //タイトル入力時、リターン押すとキーボード下がる
    func commitButtonTapped (){
        self.view.endEditing(true)
        commentField.tag = 0
    }
    
    //コメント入力完了時、キーボードを下げる
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        commentField.tag = 0
        return true
    }
    
    //キーボードで入力画面が隠れないためのスクロール
    @IBOutlet weak var scvBackGround: UIScrollView!
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        commentField = textView
        commentField.tag = 200
        return true
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        if commentField.tag == 200{

            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
            
            let txtLimit = commentField.frame.origin.y + commentField.frame.height + 8.0
            let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
            
            print("テキストフィールドの下辺：(txtLimit)")
            print("キーボードの上辺：(kbdLimit)")
            
            if txtLimit >= kbdLimit {
                scvBackGround.contentOffset.y = txtLimit - kbdLimit
            }
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        scvBackGround.contentOffset.y = -64 //ここでスクロールの上がり値を微調整する
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    
    //日付選択時、Doneを押すとピッカーの値をテキストフィールドに挿入して、ピッカーを閉じる
    func toolBarBtnPush(sender: UIBarButtonItem){
        var pickerDate = inputDatePicker.date
        dateTextField.text = dateFormat.stringFromDate(pickerDate)
        commentField.tag = 0
        self.view.endEditing(true)
    }
    
    
    //ここから画像処理
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
//        if  info[UIImagePickerControllerReferenceURL] == nil {
//            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//                ImageView.contentMode = .ScaleAspectFit
//                ImageView.image = pickedImage
//                //                let image:UIImage! = imageView.image
//                //                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
//            }
//            
//            
//            //メタデータを保存するためにはAssetsLibraryを使用する
//            var library : ALAssetsLibrary = ALAssetsLibrary()
//            library.writeImageToSavedPhotosAlbum(ImageView.image!.CGImage,metadata: info[UIImagePickerControllerMediaMetadata] as! [NSObject : AnyObject], completionBlock:{
//                (assetURL: NSURL!, error: NSError!) -> Void in
//                
//                let url = NSURL(string: assetURL.description)
//                
//                //ユーザーデフォルトを用意する
//                var myDefault = NSUserDefaults.standardUserDefaults()
//                
//                var peopleList:[NSDictionary] = []
//                
//                if myDefault.arrayForKey("myString2") != nil {
//                    var myStr:Array = myDefault.arrayForKey("myString2")!
//                    
//                    if myStr.count > 0 {
//                        peopleList = myStr as! NSArray as! [NSDictionary]
//                    }
//                }
//                
////                var data:NSDictionary = ["name":self.memberName.text!, "image":assetURL.description]
////                peopleList.append(data)
//                
//                
//                //データを書き込んで
////                myDefault.setObject(peopleList, forKey: "myString2")
//                //即反映させる
//                myDefault.synchronize()
//            })
//            
//            //閉じる処理
//            imagePicker.dismissViewControllerAnimated(true, completion: nil)
//            
//        } else {
//            let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]!
//            selectAssetsUrl=assetURL.description
        let editImage:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        ALAssetsLibrary().writeImageToSavedPhotosAlbum(editImage.CGImage, orientation: ALAssetOrientation(rawValue: editImage.imageOrientation.rawValue)!, completionBlock: { (path:NSURL!, error:NSError!) -> Void in
            print("\(path)")
            self.selectAssetsUrl=path.description
        
        })
        
        
        //            let url = NSURL(string: assetURL.description)
        
//            //ユーザーデフォルトを用意する
//            var myDefault = NSUserDefaults.standardUserDefaults()
//            
////            var peopleList:[NSDictionary] = []
//            
//            if myDefault.arrayForKey("myString2") != nil {
//                var myStr:Array = myDefault.arrayForKey("myString2")!
////                
////                if myStr.count > 0 {
////                    peopleList = myStr as! NSArray as! [NSDictionary]
////                }
//                
//            }
//
//            var data:NSDictionary = ["name":memberName.text!, "image":assetURL.description]
//            peopleList.append(data)
            
            
//            //データを書き込んで
//            myDefault.setObject(peopleList, forKey: "myString2")
            //即反映させる
//            myDefault.synchronize()
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFit
            ImageView.image = pickedImage
        }
        
        

        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

