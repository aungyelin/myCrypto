//
//  ErrorResponse.swift
//  myCrypto
//
//  Created by Ye Lin Aung on 26/9/2568 BE.
//

import Foundation

typealias  APIErrorResponse =  APIErrorDto

struct APIErrorDto: Decodable {
    let status: APIErrorStatusDto
}

struct APIErrorStatusDto: Decodable {
    let error_code: Int?
    let error_message: String?
}
