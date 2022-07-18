//
//  BaseModel.swift
//  social-network-app
//
//  Created by user on 29/6/22.
//

import Foundation

protocol BaseModel {
    var id: String { get set }
    var updatedAt: Date { get set }
    var createdAt: Date { get set }
}
