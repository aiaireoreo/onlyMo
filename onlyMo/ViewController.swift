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
    
    
    let nowDate = NSDate()
    let dateFormat = NSDateFormatter()
    let inputDatePicker = UIDatePicker()
    
    
    //絵文字選択
    var data = ["-","💖", "😭", "😡","👻","👍"]
    var picker = UIPickerView()
    
    var movieList =
        [["title":"タイタニック","image":"","date":"2016-05-15","star":"5","stamp":"💖","comment":"love!"]]
    
    //選択したカメラロールの写真の場所
    var selectAssetsUrl = ""
//    var selectedIndex = -1


    override func viewDidLoad() {
        super.viewDidLoad()
        //ユーザーデフォルトに保存
        var myDefault = NSUserDefaults.standardUserDefaults()
        if (myDefault.objectForKey("movieList") != nil){
            movieList = myDefault.objectForKey("movieList") as! [Dictionary]
            
            ImageView.contentMode = .ScaleAspectFit
            
            
            //配列から辞書型に変更したので一度だけユーザーデフォルトを全削除する
//            var appDomain:String = NSBundle.mainBundle().bundleIdentifier!
//            myDefault.removePersistentDomainForName(appDomain)
            //ここまで書いたら一度プレビュー再生して、コメントアウト


        }
        
        print(movieList)
        
        //キーボード閉じる
        titleTextField.delegate = self
        commentField.delegate = self
        
        //テキストビューの完了ボタン
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
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
        
        //日付フィールドの設定
        dateFormat.dateFormat = "yyyy/MM/dd"
        dateTextField.text = dateFormat.stringFromDate(nowDate)
        self.dateTextField.delegate = self
        
        
        // DatePickerの設定(日付用)
        inputDatePicker.datePickerMode = UIDatePickerMode.Date
        dateTextField.inputView = inputDatePicker
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .BlackTranslucent
        pickerToolBar.tintColor = UIColor.whiteColor()
        pickerToolBar.backgroundColor = UIColor.blackColor()
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,target: self,action: "")
        
        //日付選択の完了ボタン
        let toolBarBtn      = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "toolBarBtnPush:")
        
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
        
        //ボタンの設定
        //右寄せのためのスペース設定
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
            //以下はカメラロールの例
            //.Cameraを指定した場合はカメラを呼び出し(シミュレーター不可)
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //トリミングの指示
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
//         */
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
//
    
    
    @IBAction func tapImage(sender: UITapGestureRecognizer) {
        print("タップされてる")
        pickImageFromLibrary()  //ライブラリから写真を選択する


    }
    
    //        movieList.append(["title":titleTextField.text!,"date":dateTextField.text!,"stamp":feelingField.text!,"comment":commentField.text!])
//        
//        print(movieList)
//        
//        var myDefault = NSUserDefaults.standardUserDefaults()
//        myDefault.setObject(movieList, forKey: "movieList")
//        myDefault.synchronize()
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAddCheck" {
            movieList.append(["title":titleTextField.text!,"image":selectAssetsUrl,"date":dateTextField.text!,"stamp":feelingField.text!,"comment":commentField.text!])
            
            print(movieList)
            
            var myDefault = NSUserDefaults.standardUserDefaults()
            myDefault.setObject(movieList, forKey: "movieList")
            myDefault.synchronize()

            
            //var addCheckVC = segue.destinationViewController as! addCheckViewController
            
           // addCheckVC.selectedIndex = selectedIndex
            
        }
    }

    
    
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
    
    //タイトル入力完了リターン
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    //コメント入力完了ボタン
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    func toolBarBtnPush(sender: UIBarButtonItem){
        var pickerDate = inputDatePicker.date
        dateTextField.text = dateFormat.stringFromDate(pickerDate)
        self.view.endEditing(true)
    }
    
    
    
    //ここから画像処理
    // 撮影が完了時した時・ライブラリを選択した後に呼ばれる
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
            let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]!
            selectAssetsUrl=assetURL.description
        
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
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.contentMode = .ScaleAspectFit
            ImageView.image = pickedImage
        }

            //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
            
//            // テキストフィールドと写真を登録すると次へ進める
//            if memberName.text != "" && imageView.image != "noImage.png" {
//                nextBtn.enabled = true
//                createBtn.enabled = true
//            }
//            
//            
//            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//                imageView.contentMode = .ScaleAspectFit
//                imageView.image = pickedImage
//            }
            
//        }
        
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

