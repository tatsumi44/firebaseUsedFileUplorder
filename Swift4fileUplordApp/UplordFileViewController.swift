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
        let date = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let datePath = format.string(from: date as Date)
        print(datePath)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        images = info[UIImagePickerControllerEditedImage] as! UIImage
        let ref = storage.reference()
        db = Database.database().reference()
        let date = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        
        let datePath = format.string(from: date as Date)
        db.ref.child("photo").childByAutoId().setValue(["path": "\(datePath).jpg"])
        let data: Data = UIImageJPEGRepresentation(images, 0.1)!
        let imagePath = ref.child("image").child("\(datePath).jpg")
        let uploadTask = imagePath.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print(downloadURL)
        }
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        var m_data = [
//            "customMetadata": [
//                "location": "Yosemite, CA, USA",
//                "activity": "Hiking"
//            ]
//        ]
//        m_data.data(using: .utf8)
//        imagePath.putData(m_data, metadata: metadata)
        
        
        dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
