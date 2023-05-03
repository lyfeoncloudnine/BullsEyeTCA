//
//  RecordService.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/02.
//

import Foundation

struct RecordService: RecordServiceType {
    private let userDefaults = UserDefaults.standard
    private let key = "recordServiceKey"
    
    func records() -> [Record] {
        if let data = userDefaults.data(forKey: key), let records = try? PropertyListDecoder().decode([Record].self, from: data) {
            return records
        } else {
            return []
        }
    }
    
    @discardableResult func create(record: Record) -> [Record] {
        var records = records()
        records.append(record)
        records.sort { $0.score > $1.score }
        
        userDefaults.set(try? PropertyListEncoder().encode(records), forKey: key)
        
        return records
    }
    
    func delete(index: IndexSet) -> [Record] {
        var records = records()
        records.remove(atOffsets: index)
        
        userDefaults.set(try? PropertyListEncoder().encode(records), forKey: key)
        
        return records
    }
    
    func clear() {
        userDefaults.set(nil, forKey: key)
    }
}
