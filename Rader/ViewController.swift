//
//  ViewController.swift
//  Rader
//
//  Created by xuxiwen on 2017/9/9.
//  Copyright © 2017年 xuxiwen. All rights reserved.
//

import UIKit

let MIN_SIZE = 120
let avatarSize = 80

class ViewController: UIViewController {

    var tempImage:UIImageView?
    var angle:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        /// background images
        let screenFrame = self.view.bounds
        for index in 1 ... 6 {
             let imageView = UIImageView.init(frame: screenFrame)
             let imageName = "radar\(index)_6"
             imageView.image = UIImage.init(named: imageName)
            self.view .addSubview(imageView)
         }
        
        let pie_Pic_Size = screenFrame.size.width / 2
        let pie_Pic = UIImageView.init(frame: CGRect(x: 0, y: 0, width: pie_Pic_Size, height: pie_Pic_Size))
        pie_Pic.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
         pie_Pic.center = self.view.center
        pie_Pic.image = UIImage.init(named: "radar_6")
        self.view.addSubview(pie_Pic)
        
        /// point images
        let point_Pic = UIImageView.init(frame: screenFrame)
        let imagesArray = NSMutableArray()
        for i in 1 ... 7 {
            let imageName = "radarpoint\(i)_6.png"
            let image = UIImage.init(named: imageName)
            if (image != nil) {
             imagesArray.add(image!)
            }
        }
        point_Pic.animationImages = imagesArray as? [UIImage]
        point_Pic.animationDuration = 1
        point_Pic.animationRepeatCount = -1
        point_Pic.startAnimating()
        self.view.addSubview(point_Pic)

        /// avatar
        let avatar = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: avatarSize, height: avatarSize))
        avatar.center = self.view.center
        pie_Pic.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
        avatar.contentMode = .scaleAspectFill
        avatar.image = UIImage.init(named: "35191504961669_.pic_hd.jpg")
        avatar.layer.cornerRadius = CGFloat(avatarSize / 2)
        avatar.layer.masksToBounds = true
        self.view.addSubview(avatar)
        
#if false
        /// CABasicAnimation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 2
         rotationAnimation.repeatCount = HUGE
        pie_Pic.layer.add(rotationAnimation, forKey: "rotationAnimation")
#else
       /// CGAffineTransform
        self.tempImage = pie_Pic;
        raderAnimation()
#endif
    }

    func raderAnimation()  {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.tempImage?.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(Double.pi / 180 * self.angle))
        }) { [unowned self] (true) in
            self.angle += 15
            self.raderAnimation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

