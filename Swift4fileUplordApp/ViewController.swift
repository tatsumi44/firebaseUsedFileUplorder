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
    }
    //画面が表示されるたびに呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getmainArray = [StorageReference]()
        //ストレージ接続
        let storage = Storage.storage().reference()
        //db接続
        db = Database.database().reference()
        //データメースに更新がかかった時に呼ばれる
        db.ref.child("photo").observe(.value) { (snap) in
            //            self.getMainArray = [[String]]()
            for item in snap.children {
                //ここは非常にハマるfirebaseはjson形式なので変換が必要
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                //imageのpath
                self.getArray = dic["path"]! as! String
                //StorageReference型に変換
                var ref = storage.child("image/\(self.getArray!)")
                self.getmainArray.append(ref)
            }
            //path全てをこの配列に入れる
            print(self.getmainArray)
            //リロード
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getmainArray.count
    }
    //セルの内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //セルの中にあるimageViewを指定tag = 1
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        //getmainArrayにあるpathをurl型に変換しimageViewに描画
         getmainArray[indexPath.row].downloadURL { url, error in
            if let error = error {
                // Handle any errors
            } else {
                //imageViewに描画、SDWebImageライブラリを使用して描画
                imageView.sd_setImage(with: url!, completed: nil)
            }
        }
        //セルの中にあるlabelを指定tag = 1,labelを描画
        let text = cell.contentView.viewWithTag(2) as! UILabel
        text.text = "tatsumi"
        
        return cell
    }
    //cellを押した時に呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    //投稿ボタンを押した時の処理
    @IBAction func postButton(_ sender: Any) {
        performSegue(withIdentifier: "goPost", sender: nil)
    }
    
    
}

