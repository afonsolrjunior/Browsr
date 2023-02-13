//
//  String+Extensions.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 13/02/2023.
//

import Foundation

extension String? {
    
    var isNilOrEmpty: Bool {
        self == nil || self?.isEmpty == true
    }
    
}
