//
//  ServiceError.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import Foundation

public enum ServiceError: Error {
    case networkingError(error: Error)
    case parsingError
}
