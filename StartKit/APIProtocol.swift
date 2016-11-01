//
//  BaseAPIProtocol.swift
//  StartKit
//
//  Created by XueliangZhu on 10/16/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import Foundation

enum RequestMethod {
    case get
    case post
    case delete
}

enum RequestEncoding {
    case json
    case url
}

protocol APIProtocol {
    func request(_ url: String, method: RequestMethod, encoding: RequestEncoding, params: Dictionary<String, Any>?, headers: Dictionary<String, String>?, success: @escaping (_ result: Any) -> Void, failure: @escaping (_ error: Error) -> Void)
}
