//
//  PopContainerView.swift
//  PopView
//
//  Created by weiwei.li on 2020/7/10.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

import UIKit


class PopContainerView: PopBaseView {
    lazy var contentView: UIView = {
       let view = UIView()
        view.tag = PopBaseView.containerTag
        return view
    }()

    
    var preferredContentSize: CGSize = CGSize.zero {
        didSet {
            setFrame()
        }
    }
    
    override func setInterFace() {
        super.setInterFace()
        contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(contentView)
    }
    
    override func updateContentViewConstraint(_ isShow: Bool) {
        switch style {
        case .activity:
            contentView.snp.updateConstraints { (make) in
                make.centerY.equalTo(self).offset(isShow ? 0 : SCREEN_HEIGHT)
            }
        case .sheet:
            contentView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self).offset(isShow ? 0 : preferredContentSize.height)
            }
        case .alert:
            if isShow {
                return
            }
            contentView.center = self.parentView?.center ?? CGPoint.zero
            break
        }
    }
}

extension PopContainerView {
    private func setFrame() {
       // contentview设置约束条件
       switch style {
       case .activity:
           contentView.snp.makeConstraints { (make) in
               make.centerX.equalTo(self)
               make.centerY.equalTo(self).offset(SCREEN_HEIGHT)
               make.size.equalTo(preferredContentSize)
           }
       case .sheet:
           contentView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(preferredContentSize.height)
           }
       case .alert:
            contentView.frame = CGRect(x: 0, y: 0, width: preferredContentSize.width, height: preferredContentSize.height)
       }
       
   }
}
