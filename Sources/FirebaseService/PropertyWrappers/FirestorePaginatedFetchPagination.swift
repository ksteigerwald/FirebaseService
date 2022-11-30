//
//  FirestorePaginatedFetchPagination.swift
//  
//
//  Created by Alex Nagy on 22.11.2022.
//

import Foundation

public struct FirestorePaginatedFetchPagination<U: Codable & Firestorable & Equatable, E: Comparable> {
    public let orderBy: String
    public let descending: Bool
    public let limit: Int
    public let sortedBy: ((U, U) throws -> Bool)
    
    public init(orderBy: String,
                orderByType: E.Type,
                descending: Bool,
                limit: Int) {
        self.orderBy = orderBy
        self.descending = descending
        self.limit = limit
        self.sortedBy = { e0, e1 in
            guard let e0Dict = e0.dictionary,
                  let e1Dict = e1.dictionary,
                  let sortPredicateE0 = e0Dict[orderBy] as? E,
                  let sortPredicateE1 = e1Dict[orderBy] as? E else { return false }
            
            if descending {
                return sortPredicateE0 > sortPredicateE1
            } else {
                return sortPredicateE0 < sortPredicateE1
            }
        }
    }
}

import FirebaseFirestore

public struct FirestorePaginatedFetchPaginationTimestamp<U: Codable & Firestorable & Equatable> {
    public let orderBy: String
    public let descending: Bool
    public let limit: Int
    public let sortedBy: ((U, U) throws -> Bool)
    
    public init(orderBy: String,
                descending: Bool,
                limit: Int) {
        self.orderBy = orderBy
        self.descending = descending
        self.limit = limit
        self.sortedBy = { e0, e1 in
            guard let e0Dict = e0.dictionary,
                  let e1Dict = e1.dictionary,
                  let sortPredicateE0 = e0Dict[orderBy] as? Timestamp,
                  let sortPredicateE1 = e1Dict[orderBy] as? Timestamp else { return false }
            
            if descending {
                return sortPredicateE0.dateValue() > sortPredicateE1.dateValue()
            } else {
                return sortPredicateE0.dateValue() < sortPredicateE1.dateValue()
            }
        }
    }
}
