//
//  ViewController.swift
//  Swift4fileUplordApp
//
//  Created by tatsumi kentaro on 2018/02/19.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var db: DatabaseReference!
    var getmainArray = [StorageReference]()
    var getArray: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getmainArray = [StorageReference]()
        let storage = Storage.storage().reference()
//        let storage = Storage.storage().reference()
        db = Database.database().reference()
        db.ref.child("photo").observe(.value) { (snap) in
            //            self.getMainArray = [[String]]()
            for item in snap.children {
                //ここは非常にハマるfirebaseはjson形式なので変換が必要
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                self.getArray = dic["path"]! as! String
                var ref = storage.child("image/\(self.getArray!)")
                
                self.getmainArray.append(ref)
            }
            print(self.getmainArray)
            self.collectionView.reloadData()
            //            print(self.getmainArray)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getmainArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        
         getmainArray[indexPath.row].downloadURL { url, error in
            if let error = error {
                // Handle any errors
            } else {
               
                //                print("これは\(String(describing: type(of: url!)))")
                imageView.sd_setImage(with: url!, completed: nil)
                //                self.testImage.sd_setImage(with: url!, placeholderImage: nil)
                // Get the download URL for 'images/stars.jpg'
            }
        }
        //        imageView.image = UIImage(named:"tatsumi-syashinn.jpg")
        let text = cell.contentView.viewWithTag(2) as! UILabel
        text.text = "tatsumi"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    @IBAction func postButton(_ sender: Any) {
        performSegue(withIdentifier: "goPost", sender: nil)
    }
    
    
}

