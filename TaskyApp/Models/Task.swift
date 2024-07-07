//
//  Task.swift
//  TaskyApp
//
//  Created by Yuri Correa on 05/07/24.
//

import Foundation

struct Task: Codable {
    var title: String
    var description: String?
    var isCompleted: Bool = false
}

