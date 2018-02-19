//
//  ViewController.swift
//  Swift4fileUplordApp
//
//  Created by tatsumi kentaro on 2018/02/19.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named:"tatsumi-syashinn.jpg")
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

