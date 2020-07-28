//
//  PopBaseView.swift
//  PopView
//
//  Created by weiwei.li on 2020/7/10.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

import UIKit
import SnapKit

//活动类型弹窗，显示在最中间，从下到上

enum PopContainerStyle: Int {
    case activity
    case sheet
    case alert
}

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class PopBaseView: UIView {
    static let containerTag = 1024
    /// 弹出方式，效果和 UIAlertController 一致
    open var style: PopContainerStyle { .activity }
    /// 动画时长
    open var animDuration: TimeInterval { 0.25 }
    /// 蒙版颜色
    open var bgBackgroudColor: UIColor { #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.45) }
    /// 是否允许点击空白区域关闭弹窗
    open var isEnableTapDissmiss: Bool { true }
    
    var dismissCompleted: (() -> ())?
    
    var parentView: UIView? {
        didSet {
            self.removeFromSuperview()
            if let parentView = parentView {
                isHidden = true
                alpha = 0
                parentView.addSubview(self)
                self.snp.makeConstraints { (make) in
                    make.left.right.top.bottom.equalTo(parentView)
                }
                updateContentViewConstraint(false)
            }
        }
    }
    
    private lazy var bgView: UIView  = {
       let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInterFace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self)
    }

    func setInterFace() {
       addSubview(bgView)
       bgView.backgroundColor = bgBackgroudColor
       bgView.snp.makeConstraints { (make) in
           make.left.right.top.bottom.equalTo(self)
       }
       
       let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
       bgView.addGestureRecognizer(tap)
       isUserInteractionEnabled = true
       alpha = 0
    }
    
    //子类实现
    func updateContentViewConstraint(_ isShow: Bool) {
        
    }
}

extension PopBaseView {
    // 不传入view，加在window上面
    public func show(in view: UIView?) {
        parentView = getCurrentView(view)
        show(true)
    }
    
    private func show(_ flag: Bool) {
        //由于一开始添加到view上，则需要先让其隐藏，所以show的时候，需要让其显示
        if flag {
            isHidden = false
            if parentView == nil {
                removeFromSuperview()
                return
            }
        } else {
            if superview == nil {
                return
            }
            
        }
        
        let alpha: CGFloat = flag ? 1 : 0
        layoutIfNeeded() //先调用一次，是因为用的是约束，不先调用，会出现从左上角拉升的动画效果 不好
        updateContentViewConstraint(flag)

        if style == .alert {
            alertAnimation(flag)
            return
        }
        
        UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = alpha
            self.layoutIfNeeded()
        }, completion: { finished in
             if flag {
               self.superview?.bringSubviewToFront(self)
             } else {
               self.parentView = nil
               self.dismissCompleted?()
               self.removeFromSuperview()
            }
        })
    }
    
    private func alertAnimation(_ flag: Bool) {
        let contentView = viewWithTag(PopBaseView.containerTag)
        if flag {
            contentView?.alpha = 0
            contentView?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.alpha = 1
                contentView?.alpha = 1
                contentView?.transform = .identity
                self.layoutIfNeeded()
                
            }, completion: { finished in
                self.superview?.bringSubviewToFront(self)
            })
        } else {
            UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.alpha = 0
                contentView?.alpha = 0
                contentView?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                self.layoutIfNeeded()
            }, completion: { finished in
                self.parentView = nil
                self.dismissCompleted?()
                self.removeFromSuperview()
            })
        }
    }
    
    private func getCurrentView(_ view: UIView?) -> UIView {
        if let view = view {
            if view.next != nil,
                view.next?.isKind(of: UIViewController.self) == true {
                let responder = view.next as? UIViewController
                if responder?.isViewLoaded == false {
                    return UIApplication.shared.keyWindow ?? UIView()
                }
                return view
            }
        }
        return UIApplication.shared.keyWindow ?? UIView()
    }
    
    @objc func dismiss() {
        if !isEnableTapDissmiss {
           return
        }
        show(false)
    }
}
