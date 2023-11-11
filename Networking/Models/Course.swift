//
//  Course.swift
//  Networking
//
//  Created by Alexandr Baranov on 11.11.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import Foundation

struct Course: Decodable {
    let name: String?
    let link: String?
    let imageUrl: String?
    let number_of_lessons: Int?
    let number_of_tests: Int?
}

struct SwiftbookInfo: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName : String?
}
