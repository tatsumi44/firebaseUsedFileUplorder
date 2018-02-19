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

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let datePath = format.string(from: date as Date)
        print(datePath)
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upLordButton(_ sender: Any) {
        num = num + 1
        let ref = storage.reference()
        let data1:UIImage = UIImage(named:"sample55.jpg")!
        let data: Data = UIImageJPEGRepresentation(data1, 1)!
        let path = ref.child("image").child("sample\(num).jpg")
        let uploadTask = path.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print(downloadURL)
        }
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
        let date = NSDate()
        let format = DateFormatter()
        format.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let datePath = format.string(from: date as Date)
        
        let data: Data = UIImageJPEGRepresentation(images, 0.5)!
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
        dismiss(animated: true, completion: nil)
    }
    

}
