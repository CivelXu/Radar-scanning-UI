# iOS 雷达扫描效果

> 最近闲的时候实现了一个雷达扫描的效果
> 效果如下图 

![整体效果](http://upload-images.jianshu.io/upload_images/1805099-4ae2a76265b8e598.gif?imageMogr2/auto-orient/strip)

## 前言
* swift 3.0 实现
* 了解 Layer **anchorPoint** 的使用
* 两种实现方式 
  - CABasicAnimation
  - CGAffineTransform rotationAngle 



### 背景设置

 背景可以是自己 用 **view** 来实现 或者 **draw** 一个 圆环 都不是什么事情
 如果要追求 和设计一样的效果 就让美工 来 设计一套图
 我这里就是一套图片; 然后 frame 设置 间隔 就可以 
  
**效果如下**

![背景效果](http://upload-images.jianshu.io/upload_images/1805099-46e82bd9689914ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)

### 扇形区域

 扇形区域是负责来旋转的, 肯定一张图片啦 
 我这里是一张正方形的图片 
 
 **如下**

![扇形图](http://upload-images.jianshu.io/upload_images/1805099-6cbc975c80fe2361.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

把图片添加进去 并不难, 看起来就是 : 扇形图片的左上角是围绕 背景的圆心 来旋转的, 所以 左上角 是对应圆心 

一开始 我就是这样的思路
让 **origin** x , y 为扇形图片的 x y 不就好了, 这样一下就能达到 预期效果 (下图) 但是做旋转的时候 就发现 陷入误区了

**思考一下是为啥呢?**

 我们在处理 扇形图片 进行旋转的时候, 图片的旋转 是围绕 图片 自身 的中心点 来进行旋转的

而 如果按照上面 做的 扇形图片的 **center**  按照本身 图片旋转的效果 肯定不是这样

**所以 我们是要 如何 做到 让扇形图 以自己的左上角 来进行旋转的呢 ?**

查阅资料 **Layer** 有个 **anchorPoint** 属性

### anchorPoint

> anchorPoint 是相对于自身的位置 
> 称为“定位点”、“锚点”
> 决定着CALayer身上的哪个点会在position属性所指的位置
> 它的x、y取值范围都是0~1，默认值为（0.5, 0.5）
> 也就是 默认的旋转以 自身 center 点 来进行


借用 [浅谈Layer两个属性position和anchorPoint](http://www.jianshu.com/p/7703e6fc6191) 一张图片 大家来分析

![](http://upload-images.jianshu.io/upload_images/1805099-f7e2396ee2bd1032.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)

根据分析这里的扇形图片进行旋转 就是 根据 锚点 进行的 
所以我只需要需改 锚点 为 左上角 anchorPoint (0, 0)
旋转 就会 以左上角 来进行

[position和anchorPoint](http://blog.csdn.net/sinat_27706697/article/details/46489105)的详细研究 可以参考这篇文章

研究完 anchorPoint 后就恍然大悟 设置 anchorPoint (0, 0) 之后
扇形图的目前 center 是以左上角点 来进行 参考 
这时 我只需要让它的 center 等于 背景圆环中心 即可
就达到了 如下的效果图 
而且这里我们 做旋转也是以这个 左上角来进行的 

![扇形图效果图](http://upload-images.jianshu.io/upload_images/1805099-19bc9aa09ed9816e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)

### 旋转动画 - CABasicAnimation


```
        /// CABasicAnimation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 2
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = HUGE
        pie_Pic.layer.add(rotationAnimation, forKey: "rotationAnimation")
```

直接上代码 这里好像也没有什么可以说的了

**需要注意的有** 

* 旋转是以 Z 轴 旋转 
* Double.pi swift 3.0 的写法 当然 也有 Float.pi 之类的 根据你取的类型
* repeatCount 设置 -1 居然 不会 无限 repeat , 我这里也是很无奈 用了个 HUGE 不知道 还能怎么写 ?  HUGE 很大就是了

### 旋转动画 - CGAffineTransform


```
    func raderAnimation()  {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.tempImage?.transform = CGAffineTransform.init(rotationAngle: CGFloat.init(Double.pi / 180 * self.angle))
        }) { [unowned self] (true) in
            self.angle += 15
            self.raderAnimation()
        }
    }
```

这里大致的思路是 每次进行 一定幅度 的旋转
angle 值得 累加
动画结束 的 时候 继续 调用函数 就能 持续 执行动画函数了
这里的 angle 可以进行调整 动画就会 执行的 比较平顺


#### 雨点效果

> 雨点的效果比较简单 
> 几张图片的 播放 

```
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
```

最后 添加个头像 最终的 效果就出来啦 

![最终效果](http://upload-images.jianshu.io/upload_images/1805099-e4ead4dd48ca73c5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)


### 结尾

实现这个效果并不难
主要是温习一下 CABasicAnimation 和 CGAffineTransform 一些 基本使用 
同时 又学到了 anchorPoint 的使用 偶尔 再写写 文章 让自己 巩固 一下
关于这个动画 如果有更好 的实现效果方式
欢迎 给我留言 留下链接 我会去看的 
如果本篇文章有错误的地方 还请麻烦指正 
 
### Link 

* [个人博客](http://civelxu.com/2017/09/10/iOS%20雷达扫描效果/)
* [简书](http://www.jianshu.com/p/75498fdc2974)
* [GitHub Code](https://github.com/CivelXu/Radar-scanning-UI)
