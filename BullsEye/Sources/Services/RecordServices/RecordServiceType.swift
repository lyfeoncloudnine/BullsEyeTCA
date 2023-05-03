//
//  RecordServiceType.swift
//  BullsEye
//
//  Created by lyfeoncloudnine on 2023/05/02.
//

import Foundation

protocol RecordServiceType {
    func records() -> [Record]
    @discardableResult func create(record: Record) -> [Record]
    func delete(index: IndexSet) -> [Record]
    func clear()
}
