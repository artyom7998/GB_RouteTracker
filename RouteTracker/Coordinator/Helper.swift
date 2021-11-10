//
//  Helper.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardId: String { get }
}

extension UIViewController: StoryboardIdentifiable { }

extension StoryboardIdentifiable where Self: UIViewController {

    static var storyboardId: String {
        String(describing: self)
    }
}

extension UIStoryboard {
    func initViewContoller<T: UIViewController>(_: T.Type) -> T {
        guard let vc = self.instantiateViewController(withIdentifier: T.storyboardId) as? T else {
            fatalError("Not found")
        }

        return vc
    }
}
