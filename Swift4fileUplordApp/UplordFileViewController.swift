//
//  UplordFileViewController.swift
//  Swift4fileUplordApp
//
//  Created by tatsumi kentaro on 2018/02/19.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class UplordFileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let storage = Storage.storage()
    var num: Int = 10
    var images: UIImage!
    var db: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ライブラリを使用する時
    @IBAction func selectImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }else{
            print("エラー")
        }
    }
    //画像が選択し終わった時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        images = info[UIImagePickerControllerEditedImage] as! UIImage
        //ストレージ接続
        let ref = storage.reference()
        //db接続
        db = Database.database().reference()
        //時間を取得
        let date = NSDate()
        //時間を文字列に整形
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        //整形した文字列を画像のpathに整形
        let datePath = format.string(from: date as Date)
        db.ref.child("photo").childByAutoId().setValue(["path": "\(datePath).jpg"])
        //画像をjpgのデータ形式に変換
        let data: Data = UIImageJPEGRepresentation(images, 0.1)!
        //ストレージの保存先のpathを指定
        let imagePath = ref.child("image").child("\(datePath).jpg")
        //ストレージにデータ形式で画像を保存
        let uploadTask = imagePath.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print(downloadURL)
        }
        dismiss(animated: true, completion: nil)
    }
    //写真を撮る時に呼ばれる
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }else{
            print("エラー")
        }
        
    }
    //戻るボタンが押された時に呼ばれる
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
