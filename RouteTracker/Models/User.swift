//
//  User.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 10.11.2021.
//

import Foundation
import RealmSwift

class User: Object {

    @objc dynamic var login = ""
    @objc dynamic var password = ""
    @objc dynamic var authorized = false
    
    override static func primaryKey() -> String? {
        return "login"
    }

    convenience init(_ login: String, _ password: String, _ authorized: Bool) {
        self.init()
        self.login = login
        self.password = password
        self.authorized = authorized
    }
}
