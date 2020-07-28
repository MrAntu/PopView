//
//  TestView.swift
//  PopView
//
//  Created by weiwei.li on 2020/7/10.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

import UIKit

class ActivityTestView: PopContainerView  {
    
    override var style: PopContainerStyle {
        return .alert
    }
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }()
    var scrollerView: UIScrollView?
    var isDragScrollView = false
    var lastDrapDistance: CGFloat = 0
    var container: UIView?
    
    override func setInterFace() {
        super.setInterFace()
        if let testTitle = Bundle.main.loadNibNamed("TestTitle", owner: nil, options: nil)?.first as? TestTitle {
            testTitle.closeAction = { [weak self] in
                self?.dismiss()
            }
            contentView.addSubview(testTitle)
            testTitle.snp.makeConstraints { (make) in
               make.edges.equalTo(self.contentView)
           }
            container = testTitle
            contentView.cornerRadii = CornerRadii(topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10)
            //            addPanGesture(testTitle)
        }
        
        preferredContentSize = CGSize(width: 300, height: 400)
    }

}


extension ActivityTestView: UIGestureRecognizerDelegate {
    private func addPanGesture(_ container: UIView) {
        panGestureRecognizer.addTarget(self, action: #selector(pan(_:)))
        container.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
    
    @objc func pan(_ panGesture: UIPanGestureRecognizer) {
        // 获取手指的偏移量
        let transP: CGPoint = panGesture.translation(in: container)
        if isDragScrollView  {
            //如果当前拖拽的是tableView
            let contentOffsetY: CGFloat = scrollerView?.contentOffset.y ?? 0
            if contentOffsetY <= 0.0 {
                //如果tableView置于顶端
                if transP.y > 0 {
                    //如果向下拖拽
                    scrollerView?.contentOffset = CGPoint(x: 0, y: 0)
                    scrollerView?.panGestureRecognizer.isEnabled = false
                    scrollerView?.panGestureRecognizer.isEnabled = true
                    isDragScrollView = false
                    //向下拖
                    contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y + transP.y, width: contentView.frame.size.width, height: contentView.frame.size.height)
                                
                } else {
                    //如果向上拖拽
                }
            }
        } else {
            if transP.y > 0 {
                contentView.frame = CGRect(x: contentView.frame.origin.x, y: contentView.frame.origin.y + transP.y, width: contentView.frame.size.width, height: contentView.frame.size.height)
            } else if ((transP.y < 0) && (contentView.frame.origin.y > (frame.size.height - contentView.frame.size.height))) {
                //向上拖
                let originY: CGFloat = (contentView.frame.origin.y + transP.y) > (self.frame.size.height - contentView.frame.size.height) ? (contentView.frame.origin.y + transP.y) : (self.frame.size.height - contentView.frame.size.height)
                contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: originY, width: contentView.frame.width, height: contentView.frame.height)
            }
        }
        
        panGesture.setTranslation(CGPoint.zero, in: contentView)
        if panGesture.state == .ended {
            if lastDrapDistance > 10 && isDragScrollView == false {
                //如果是类似轻扫的那种
                dismiss()
            } else {
                //如果是普通拖拽
                if contentView.frame.origin.y >= SCREEN_HEIGHT - contentView.frame.size.height / 2 {
                    dismiss()
                } else {
                    UIView.animate(withDuration: 0.25, animations: {
                        var frame = self.contentView.frame
                        frame.origin.y = self.frame.size.height - self.contentView.frame.size.height
                        self.contentView.frame = frame
                    }, completion: { finished in
                        print("结束")
                    })
                }
            }
        }
        lastDrapDistance = transP.y;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            var touchView = touch.view
            while touchView != nil {
                if touchView?.isKind(of: UIScrollView.self) == true {
                    isDragScrollView = true
                    scrollerView = touchView as? UIScrollView
                    break
                } else if touchView == container {
                    isDragScrollView = false
                    break
                }
                touchView = touchView?.next as? UIView
            }
        }
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGestureRecognizer {
            if let scrolleGesClass = NSClassFromString("UIScrollViewPanGestureRecognizer"),
                otherGestureRecognizer.isKind(of: scrolleGesClass) {
                if otherGestureRecognizer.view?.isKind(of: UIScrollView.self) == true {
                    return true
                }
            } else if let panGesClass = NSClassFromString("UIPanGestureRecognizer"),
                otherGestureRecognizer.isKind(of: panGesClass) {
                if otherGestureRecognizer.view?.isKind(of: UIScrollView.self) == true {
                    return true
                }
            }
            
        }
        return false
    }
}
