//
//  CouponVC.swift
//  School Chest
//
//  Created by Josh Oettinger on 11/2/17.
//  Copyright © 2017 Josh Oettinger. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class CouponVC: UIViewController {
    @IBOutlet var couponName: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var couponImageRef = StorageReference()
    var isPDF = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!isPDF){
            imageView.sd_setImage(with: couponImageRef)
        } else{
            couponImageRef.downloadURL{url, error in
                if error != nil {
                    
                } else {
                    self.imageView.image = self.drawPDFfromURL(url: url!)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
