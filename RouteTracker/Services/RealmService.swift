//
//  RealmService.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 06.11.2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let deleteIfMigration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    func save <T: Object>(items: [T],
                          configuration: Realm.Configuration = deleteIfMigration,
                          update: Realm.UpdatePolicy = .modified) throws {
        
        let realm = try Realm(configuration: configuration)
        print("Realm URL. File: \(String(describing: configuration.fileURL)) | Key: \(String(describing: configuration.encryptionKey))")
        try realm.write{
            realm.add(items, update: update)
        }
    }
    
    func load <T: Object>(_: T) -> [T] {
        do {
            let realm = try Realm()
            let objects = realm.objects(T.self)
            return Array(objects)
        } catch {
            print(error)
            return [T]()
        }
    }
    
    func deleteAllClassObjects <T: Object>(_: T) throws {
        
        let realm = try Realm()
        let objects = realm.objects(T.self)
        try realm.write {
            realm.delete(objects)
        }
        
    }
    
}
