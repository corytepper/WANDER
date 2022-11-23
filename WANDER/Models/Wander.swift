//
//  Wander.swift
//  WANDER
//
//  Created by Cory Tepper on 11/22/22.
//

import Foundation
import RealmSwift

final class Wander: Object {
    
    @objc dynamic public private(set) var id = UUID().uuidString.lowercased()
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    @objc dynamic public private(set) var date = Date()
    
    public private(set) var locations = List<Location>()
 
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    override class func indexedProperties() -> [String] {
        return [
            "pace",
            "date",
            "duration"
        ]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        self.init()
        self.date = Date()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    
    static func addWanderToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
        Constants.realmQueue.sync {
            do {
                let realm = try Realm()
                try realm.write({
                    realm.add(Wander(pace: pace, distance: distance, duration: duration, locations: locations))
                    try realm.commitWrite()
                })
            } catch {
                debugPrint("Error adding WANDER to realm")
            }
        }
    }
    
    
    static func getAllWanders() -> Results<Wander>? {
        do {
            let realm = try Realm()
            var wanderCollection = realm.objects(Wander.self)
            wanderCollection = wanderCollection.sorted(byKeyPath: "date", ascending: false)
            return wanderCollection
            
        } catch {
            return nil
        }
    }
}

