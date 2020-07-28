//
//  main.swift
//  PopView
//
//  Created by weiwei.li on 2020/7/10.
//  Copyright © 2020 dd01.leo. All rights reserved.
//

import Foundation
import UIKit

autoreleasepool {
    UIApplicationMain(
        CommandLine.argc,
        UnsafeMutableRawPointer(CommandLine.unsafeArgv)
            .bindMemory(
                to: UnsafeMutablePointer<Int8>.self,
                capacity: Int(CommandLine.argc)),
        nil,
        NSStringFromClass(AppDelegate.self)
    )
}
