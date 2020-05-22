//
//  NoticeViewController.swift
//  iOS
//
//  Created by 林翰 on 2020/5/22.
//  Copyright © 2020 linhey.pod.template.ios. All rights reserved.
//

import UIKit
import Stem

extension NoticeType {

    class DidEnterBackground: NoticeNotificationParsable {

        static let noticeName: Notification.Name = UIApplication.didEnterBackgroundNotification

        unowned var application: UIApplication

        init() {
            application = .shared
        }

        required init(from notification: Notification) {
            application = notification.object as! UIApplication
        }

        var notification: (object: Any?, userInfo: [String : Any]?) {
            return (application, nil)
        }

    }

}

class NoticeViewController: UIViewController {

    let voidEvent = Notice<NoticeType.Void>(key: UIApplication.willTerminateNotification)
    let didEnterBackgroundEvent = Notice(use: NoticeType.DidEnterBackground.self)
    var index = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.st.random
        index = navigationController?.viewControllers.count ?? -1
        didEnterBackgroundEvent.subscribe(by: self) { [weak self] not in
            guard let self = self else {
                return
            }
            print("subscribe: \(self.index) - \(self.st.memoryAddress)")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didEnterBackgroundEvent.accept(.init())
        self.st.push(vc: Self.init())
    }

    deinit {
        print("deinit: \(index)")
    }

}
