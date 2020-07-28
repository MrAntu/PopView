# PopView
完全可自定义UI,大小的Pop组件。目前支持三种样式（alert, sheet, activity类型）

###  具体使用如下：
####  1.创建view继承自 PopContainerView 即可
```swift 
class ActivityTestView: PopContainerView  {
    //1. 重写style，选择需要的样式
    override var style: PopContainerStyle {
        return .alert
    }
    //2.重写此接口
    override func setInterFace() {
        super.setInterFace()
        //3.获取自定义的子view
        if let testTitle = Bundle.main.loadNibNamed("TestTitle", owner: nil, options: nil)?.first as? TestTitle {
            testTitle.closeAction = { [weak self] in
                self?.dismiss()
            }
            //5.添加到pop弹窗中
            contentView.addSubview(testTitle)
            //6.设置自定义view的frame
            testTitle.snp.makeConstraints { (make) in
               make.edges.equalTo(self.contentView)
           }
    
            contentView.cornerRadii = CornerRadii(topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10)
        }
        
        // 6.设置当前需要展示的size
        preferredContentSize = CGSize(width: 300, height: 400)
    }

}

```

####  2.调用

```swift 
    let testV = ActivityTestView()
    testV.show(in: view)
```

####  3.其他属性介绍

```swift
    /// 动画时长
    open var animDuration: TimeInterval { 0.25 }
    /// 蒙版颜色
    open var bgBackgroudColor: UIColor { #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.45) }
    /// 是否允许点击空白区域关闭弹窗
    open var isEnableTapDissmiss: Bool { true }
    // dismiss回调
    var dismissCompleted: (() -> ())?
```

####  4.弹窗样式简介
*  1 **sheet** 

<img src="https://github.com/MrAntu/PopView/blob/master/PopView/07-28%2010_50_24.gif?raw=true" width=200 height=400 />

* 2 **activity**

<img src="https://github.com/MrAntu/PopView/blob/master/PopView/2020-07-28%2010_51_15.gif?raw=true" width=200 height=400 />

* 3 **alert**

<img src="https://github.com/MrAntu/PopView/blob/master/PopView/2020-07-28%2010_51_39.gif?raw=true" width=200 height=400 />

# CornerRadii 
**基于oc封装实现的切圆角方法，可实现四个角，任意大小的切圆角。
实现原理为CAShapeLayer绘制path实现，高效，低成本**

* swift使用方法：在项目的bridging-header中添加。

```swift
    #import "UIView+CornerRadii.h"
```

```swift
    imageView.cornerRadii = CornerRadiiMake(10, 0, 0, 10)
```
* oc直接导入头文件即可
