//
//  CredentialService.swift
//  TrustID
//
//  Created by Berk Turan on 1/1/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import Foundation


class CredentialService: NSObject {
    let fourByteField = "01000000"
    let subcategoryLength = "01"
    let doctorName = "111161686d6574"
    let doctorNameLength = "07"
    
    func createCredential(publicKey: String, identifiers: [String], credentialCategory: CredentialCategory, subcredentialCategory: SubcredentialCategory) -> String {
        var credential = fourByteField + subcategoryLength + credentialCategory.rawValue + subcategoryLength + subcredentialCategory.rawValue + publicKey + doctorNameLength + doctorName + "0\(identifiers.count)"
        for identifier in identifiers {
            var hash = "0101"
            for identifierHash in STDIdentifierHash.allCases {
                let variableName = (Mirror(reflecting: identifierHash).children)
                variableName.forEach{
                    if identifier == $0.label ?? "" {
                        hash += identifierHash.rawValue + "0001"
                    }
                }
            }
            credential += hash
        }
        return credential
    }
}



