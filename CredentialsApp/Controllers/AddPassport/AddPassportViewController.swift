//
//  AddPassportViewController.swift
//  TrustID
//
//  Created by Berk Turan on 3/18/20.
//  Copyright © 2020 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
import LocalAuthentication
import CryptoKit
import CryptorECC



extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return UInt8(self[start..<end], radix: 16)
        }
    }
}



class AddPassportViewController: UIViewController {
    // MARK: - UI Elements
    @IBOutlet weak var scanPassportButton: UIButton!
    @IBOutlet weak var nfcScannerButton: UIButton!
    @IBOutlet weak var facialAuthenticationButton: UIButton!
    @IBOutlet weak var addCredentialUITitle: UILabel!
    
    
    // MARK: - properties
    var window: UIWindow?
    var mrzKey = ""
    private var passportReader: PassportReader!
    private var passportDetails = PassportDetails()
    var credential = Credential(title: "", description: "", color: .none)
    var model = NFCPassportModel()
    let dataProvider = DataProvider()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nfcScannerButton.isEnabled = false
        facialAuthenticationButton.isEnabled = false
        passportReader = PassportReader()
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        var eMRTD_type:String = UserDefaults.standard.object(forKey: "currenteMRTDtypeToAdd") as! String
        print("eMRTD_type")
        print(eMRTD_type)
        
        addCredentialUITitle.text = "Add " + eMRTD_type
        
        /*
        let eccPrivateKey = try! ECPrivateKey.make(for: .secp521r1)
        
        debugPrint("prikey")
        debugPrint(eccPrivateKey.pemString)
        
        let eccPublicKey = try! eccPrivateKey.extractPublicKey()
        
        debugPrint("pubkey")
        debugPrint(eccPublicKey.pemString)
        
        debugPrint("pubkeybytes")
        debugPrint(eccPublicKey)
        
        
        let message = "hello world"
        let signature = try! message.sign(with: eccPrivateKey)
        
        debugPrint("signature")
        debugPrint(signature.asn1.hexEncodedString())
        
        debugPrint("rsig")
        debugPrint(signature.r.hexEncodedString())
        
        debugPrint("ssig")
        debugPrint(signature.s.hexEncodedString())
        
        
        let verified = signature.verify(plaintext: message, using: eccPublicKey)
        if verified {
            print("Signature is valid for provided plaintext")
        }
        
        */
        
        
        let imza_str = "MIGHAkIBqKmNH31O0fCjeuxOAMDQqxG0CLVSnRXGOIIxJ/+Z4VqxS0UGGJ0w3c12jFtJk3aWHE0izOVEixuBQLUlal0elrkCQTyKUuKm+SOGGTrOmtEi1OgUAVEl7Q+tiLhhf0EkZGKKuTVB9yQqhDjcBgBBrMtf8JYLKf9eNN4zW2uvszn8t7Or"
        //let imza_hex = imza_str.hexaData
       
         //let imza_data = Data(imza_hex)
        
        
        
        //let base64Sig = "MEYCIQCvgBLn+tQoBDBR3D2G3485GloYGNxuk6PqR4qjr5GDqAIhAKNvsqvesVBD/MLub/KAyzLLNGtUZyQDxYZj/4vmHwWF"
        //let signature = try! ECSignature(asn1: Data(base64Encoded: base64Sig)!)
        
        
        debugPrint("imza_data is ")
       //debugPrint(imza_data)
        
        
        let imza = try! ECSignature.init(asn1: Data(base64Encoded: imza_str)!)
        

        debugPrint("imza asn1")
        debugPrint(imza.asn1.base64EncodedString())
        
        debugPrint("imza r degeri")
        debugPrint(imza.r.hexEncodedString())
        
        debugPrint("imza s degeri")
        debugPrint(imza.s.hexEncodedString())
        
        
        
        let imzalanmis_data_str = "308201BE020100300B0609608648016503040203308201AA30450201010440948CD0552C8E952154499468BF9DF449CB6671136645AFA9ECCE164590FA4DA7A96B5A084AD2B2B3346AD057EA1E960E1F621D8C339C60E3AE65477C5E96D14A3045020102044029904D5838B2C7055B9455E564F3AA8C2814FB9E611F62E3AE3F82DFD05AA8045AB48CA5D019D52940ED5BB64A0E6BF5C5B49279E5A42EC832BD8D5F09DDCEB3304502010304409969EACB0E1C54918D8321D5DBABE798BC0EDA404D294D1A515E33C9C517312441FDCD79A0571C4D49A79CBD79056092C76F335619B7466FDDC2A8C425B8BAB7304502010B0440AB7DBF1932B9E98854A49F51ABDFDE620F64F3B57B4D806AE4BC74D5252DDB99EE48760240365F3824EBF82F0D2FEC830AAC63CC7C66D1EFA8231C3FA85FE2A2304502010C0440375F1D8C7C821914E09F8FC83D3970AFB18B2A24505C03B2B24DDB9B08162660EA4805BCF69941302BEE7CC87453A81C792C6D71C0F80B7DA1EB55BF96C4076C304502010E044061A5933B6A21AF46842E2C8D31AF053BB5468C13FF09F3E2C69F4C5A49A40CC00834B97DE9BBE29AA39C1754C690DC8A25AC12222174D3C3D7B124618A6BA988"
        let imzalanmis_data_hex = imzalanmis_data_str.hexaData
        
        let imzalanmis_data = Data(imzalanmis_data_hex)
        
        debugPrint("imzalanmis_data len ")
        debugPrint(imzalanmis_data)
        
        debugPrint("imzalanmis_data is ")
        debugPrint(imzalanmis_data.hexEncodedString())
        
        let tr_acik_anahtar_str = "30819B301006072A8648CE3D020106052B8104002303818600040179678B810B6889B41AC38C95E439A25890ED069780CDC45A64AAB25D12CBFB13A125B8EA12DF0BA0BF122998BD6BCD2F2D21E1959C4D1F8BD14799E24462A9967F01AD6F80AA3A4B825CA81A980A27810009F32CD182E27D5A2EC18E3F9599C0BCD8F3EDDAFD1401EB5DB63791860150C800764B80654A178AAB597D4DA1F9A66F6084"
        let tr_acik_anahtar_hex = tr_acik_anahtar_str.hexaData
        
        let tr_acik_anahtar_data = Data(tr_acik_anahtar_hex)
        
        let tr_acik_anahtar_pem = tr_acik_anahtar_data.base64EncodedString()
        
        let lines = tr_acik_anahtar_pem.split(by: 64)
        // Join those lines with a new line...
        let joinedLines = lines.joined(separator: "\n")
        
        let tr_acik_anahtar_pem_final = "-----BEGIN PUBLIC KEY-----\n" + joinedLines + "\n-----END PUBLIC KEY-----"

        let tr_acik_anahtar = try! ECPublicKey(key:tr_acik_anahtar_pem_final)
        
        debugPrint("tr_acik_anahtar_pem_final")
        debugPrint(tr_acik_anahtar.pemString)
        
        debugPrint("tr_acik_anahtar_pem_final curve")
        debugPrint(tr_acik_anahtar.curve)
        
        debugPrint("tr_acik_anahtar_pem_final curveidd")
        debugPrint(tr_acik_anahtar.curveId)
        
        let imza_dogru_mu = imza.verify(plaintext: Data(imzalanmis_data_str.utf8), using: tr_acik_anahtar)
        
        debugPrint("imza_dogru_mu?:")
        debugPrint(imza_dogru_mu)
        
   
    }
    

    
    

    
    // MARK: - Function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MRZScannerViewController {
            destination.mrzDelegate = self
        }
        if let destination = segue.destination as? HomeViewController {
            destination.passportModel = model
        }
    }
    func bytesConvertToHexstring(byte : [UInt8]) -> String {
        var string = ""
        for val in byte {
            //getBytes(&byte, range: NSMakeRange(i, 1))
            string = string + String(format: "%02X", val)
        }
        return string
    }
    // MARK: - Actions
    @IBAction func scanPassportButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ScannerViewSegue", sender: nil)
    }
    @IBAction func nfcScannerButtonTapped(_ sender: UIButton) {
        
        print("nfcScannerButtonTapped")
        print(self.mrzKey)
        
        //self.mrzKey = "A00Y54560074012712701080"

        passportReader.readPassport(mrzKey: self.mrzKey) { (model, error) in
            if error == nil {
                self.credential = Credential(title: "Passport", description: model!.nationality, color: .blue)
                self.model = model!
                
                /*
                debugPrint("cert")
                debugPrint(try! model?.yuumi()[0].cert)
                debugPrint("certToPEM")
                debugPrint(try! model?.yuumi()[0].certToPEM())
                debugPrint("getFingerprint")
                debugPrint(try! model?.yuumi()[0].getFingerprint())
                debugPrint("getIssuerName")
                debugPrint(try! model?.yuumi()[0].getIssuerName())
                debugPrint("getItemsAsDict")
                debugPrint(try! model?.yuumi()[0].getItemsAsDict())
                debugPrint("getNotAfterDate")
                debugPrint(try! model?.yuumi()[0].getNotAfterDate())
                debugPrint("getNotBeforeDate")
                debugPrint(try! model?.yuumi()[0].getNotBeforeDate())
                debugPrint("getPublicKeyAlgorithm")
                debugPrint(try! model?.yuumi()[0].getPublicKeyAlgorithm())
                debugPrint("getSerialNumber")
                debugPrint(try! model?.yuumi()[0].getSerialNumber())
                debugPrint("getSignatureAlgorithm")
                debugPrint(try! model?.yuumi()[0].getSignatureAlgorithm())
                debugPrint("getSubjectName")
                debugPrint(try! model?.yuumi()[0].getSubjectName())
                */

                
                try! model?.ensureReadDataNotBeenTamperedWith()
                

                let dg1Hash = ""

                
                UserDefaults.standard.set(dg1Hash, forKey: "dg1Hash")
                
                
                
                
                
                
                
                

                
                
                var passportModelDictionary = [String: String]()
                
                
                
                
                
                let ds_cert_x509 = try! model?.extractDSCertificate()
                
              
                passportModelDictionary["signedData"] = model?.EFSODsignedData
                
                debugPrint(" signedData ")
                debugPrint(passportModelDictionary["signedData"])
                
                
                
                
                passportModelDictionary["signedDataDigest"] = try! model?.parseSignedDataHash()
                
                debugPrint("signedDataDigest")
                debugPrint(passportModelDictionary["signedDataDigest"])
                
                
                
                passportModelDictionary["digitalSignature"] = try! model?.parseSignedDataSignature()
                
                debugPrint("digitalSignature")
                debugPrint(passportModelDictionary["digitalSignature"])
                
                
                passportModelDictionary["digitalSignatureAlgo"] = try! model?.parseSignedDataSignatureAlgo()
                
                debugPrint("digitalSignatureAlgo")
                debugPrint(passportModelDictionary["digitalSignatureAlgo"])
                

                
                
                
                
                passportModelDictionary["DScertificate"] = ds_cert_x509?.certToPEM()
                
                
                debugPrint("DScertificate")
                debugPrint(passportModelDictionary["DScertificate"])
                
                
                passportModelDictionary["DGhashAlgo"] = model?.EFSODHashAlgo

                passportModelDictionary["DG1hash"] = model?.dataGroupHashes[.DG1]?.computedHash
                passportModelDictionary["DG2hash"] = model?.dataGroupHashes[.DG2]?.computedHash
                passportModelDictionary["DG3hash"] = model?.dataGroupHashes[.DG3]?.computedHash
                passportModelDictionary["DG4hash"] = model?.dataGroupHashes[.DG4]?.computedHash
                passportModelDictionary["DG5hash"] = model?.dataGroupHashes[.DG5]?.computedHash
                passportModelDictionary["DG6hash"] = model?.dataGroupHashes[.DG6]?.computedHash
                passportModelDictionary["DG7hash"] = model?.dataGroupHashes[.DG7]?.computedHash
                passportModelDictionary["DG8hash"] = model?.dataGroupHashes[.DG8]?.computedHash
                passportModelDictionary["DG9hash"] = model?.dataGroupHashes[.DG9]?.computedHash
                passportModelDictionary["DG10hash"] = model?.dataGroupHashes[.DG10]?.computedHash
                passportModelDictionary["DG11hash"] = model?.dataGroupHashes[.DG11]?.computedHash
                passportModelDictionary["DG12hash"] = model?.dataGroupHashes[.DG12]?.computedHash
                passportModelDictionary["DG13hash"] = model?.dataGroupHashes[.DG13]?.computedHash
                passportModelDictionary["DG14hash"] = model?.dataGroupHashes[.DG14]?.computedHash
                passportModelDictionary["DG15hash"] = model?.dataGroupHashes[.DG15]?.computedHash
                passportModelDictionary["DG16hash"] = model?.dataGroupHashes[.DG16]?.computedHash
                

                    passportModelDictionary["SODbody"] = Data((model?.dataGroupsRead[.SOD]!.body)!).hexEncodedString()
                    
                    let SODbodyPEM = Data((model?.dataGroupsRead[.SOD]!.body)!).base64EncodedString()
                    
                    let SODbodyPEM_lines = SODbodyPEM.split(by: 64)
                    let SODbodyPEM_joinedLines = SODbodyPEM_lines.joined(separator: "\n")
                    
                    let SODbodyPKCS7 = "-----BEGIN PKCS7-----\n" + SODbodyPEM_joinedLines + "\n-----END PKCS7-----"

                    
                    passportModelDictionary["SODbodyPKCS7"] = SODbodyPKCS7

                    passportModelDictionary["COMbody"] = Data((model?.dataGroupsRead[.COM]!.body)!).hexEncodedString()
                    passportModelDictionary["DG1body"] = Data((model?.dataGroupsRead[.DG1]!.body)!).hexEncodedString()
                    passportModelDictionary["DG2body"] = Data((model?.dataGroupsRead[.DG2]!.body)!).hexEncodedString()

                if model?.dataGroupHashes[.DG3]?.computedHash != nil {
                    passportModelDictionary["DG3body"] = Data((model?.dataGroupsRead[.DG3]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG4]?.computedHash != nil {
                    passportModelDictionary["DG4body"] = Data((model?.dataGroupsRead[.DG4]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG5]?.computedHash != nil {
                    passportModelDictionary["DG5body"] = Data((model?.dataGroupsRead[.DG5]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG6]?.computedHash != nil {
                    passportModelDictionary["DG6body"] = Data((model?.dataGroupsRead[.DG6]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG7]?.computedHash != nil {
                    passportModelDictionary["DG7body"] = Data((model?.dataGroupsRead[.DG7]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG8]?.computedHash != nil {
                    passportModelDictionary["DG8body"] = Data((model?.dataGroupsRead[.DG8]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG9]?.computedHash != nil {
                    passportModelDictionary["DG9body"] = Data((model?.dataGroupsRead[.DG9]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG10]?.computedHash != nil {
                    passportModelDictionary["DG10body"] = Data((model?.dataGroupsRead[.DG10]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG11]?.computedHash != nil {
                    passportModelDictionary["DG11body"] = Data((model?.dataGroupsRead[.DG11]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG12]?.computedHash != nil {
                    passportModelDictionary["DG12body"] = Data((model?.dataGroupsRead[.DG12]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG13]?.computedHash != nil {
                    passportModelDictionary["DG13body"] = Data((model?.dataGroupsRead[.DG13]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG14]?.computedHash != nil {
                    passportModelDictionary["DG14body"] = Data((model?.dataGroupsRead[.DG14]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG15]?.computedHash != nil {
                    passportModelDictionary["DG15body"] = Data((model?.dataGroupsRead[.DG15]!.body)!).hexEncodedString()
                }
                if model?.dataGroupHashes[.DG16]?.computedHash != nil {
                    passportModelDictionary["DG16body"] = Data((model?.dataGroupsRead[.DG16]!.body)!).hexEncodedString()
                }
                
                
       
                
                    debugPrint("DG1body")
                    debugPrint(passportModelDictionary["DG1body"])
                    debugPrint("DG2body")
                    debugPrint(passportModelDictionary["DG2body"])
                    debugPrint("DG3body")
                    debugPrint(passportModelDictionary["DG3body"])
                    debugPrint("DG4body")
                    debugPrint(passportModelDictionary["DG4body"])
                    debugPrint("DG5body")
                    debugPrint(passportModelDictionary["DG5body"])
                    debugPrint("DG6body")
                    debugPrint(passportModelDictionary["DG6body"])
                debugPrint("DG7body")
                debugPrint(passportModelDictionary["DG7body"])
                debugPrint("DG8body")
                debugPrint(passportModelDictionary["DG8body"])
                debugPrint("DG9body")
                debugPrint(passportModelDictionary["DG9body"])
                debugPrint("DG10body")
                debugPrint(passportModelDictionary["DG10body"])
                debugPrint("DG11body")
                debugPrint(passportModelDictionary["DG11body"])
                debugPrint("DG12body")
                debugPrint(passportModelDictionary["DG12body"])
                debugPrint("DG13body")
                debugPrint(passportModelDictionary["DG13body"])
                debugPrint("DG14body")
                debugPrint(passportModelDictionary["DG14body"])
                debugPrint("DG15body")
                debugPrint(passportModelDictionary["DG15body"])
                debugPrint("DG16body")
                debugPrint(passportModelDictionary["DG16body"])
                
                
                
                
                
                debugPrint("SODbody")
                debugPrint(passportModelDictionary["SODbody"])
                
                debugPrint("SODbodyPKCS7")
                debugPrint(passportModelDictionary["SODbodyPKCS7"])
    
                debugPrint("passportModelDictionary DGhashAlgo ")
                debugPrint(passportModelDictionary["DGhashAlgo"])
                
                debugPrint("passportModelDictionary dg1 hash")
                debugPrint(passportModelDictionary["DG1hash"])
                
                debugPrint("passportModelDictionary dg2 hash")
                debugPrint(passportModelDictionary["DG2hash"])
                
                debugPrint("passportModelDictionary dg3 hash")
                debugPrint(passportModelDictionary["DG3hash"])
                
                debugPrint("passportModelDictionary dg4 hash")
                debugPrint(passportModelDictionary["DG4hash"])
                
                passportModelDictionary["firstName"] = model?.firstName
                passportModelDictionary["lastName"] = model?.lastName
                
                
                
                print("newnamesorun1 5c085f0e5f105f2b5f115f0e")

                if passportModelDictionary["DG11body"]?.prefix(28) == "5c0a5f0e5f105f2b5f115f425f0e" {
                    
                    print("newnamesorun2")
                    
                    var fullNameArr = passportModelDictionary["DG11body"]?.components(separatedBy: "5c0a5f0e5f105f2b5f115f425f0e")[1]
                    
              
                    
                    var fullNameArr2 = fullNameArr!.components(separatedBy: "5f")[0]
          
                    var str = String(decoding: Data(fullNameArr2.hexaData), as: UTF8.self)
                    
                    str = String(str)
                    
           
      
                    str.removeFirst(min(str.count, 1))
                    
                    
                    var new_last_name = str.components(separatedBy: "<<")[0]
                    var new_first_name = str.components(separatedBy: "<<")[1].replacingOccurrences(of: "<", with: " ", options: .literal, range: nil)
                    
                    debugPrint(new_first_name)
            
                    if new_last_name.count >= 1 {
                        print("newnamesorun3")
                        passportModelDictionary["firstName"] = new_first_name
                        passportModelDictionary["lastName"] = new_last_name
                    }

                }
                else if passportModelDictionary["DG11body"]?.prefix(24) == "5c085f0e5f105f2b5f115f0e" {
                              
                              print("newnamesorun2")
                              
                              var fullNameArr_2 = passportModelDictionary["DG11body"]?.components(separatedBy: "5c085f0e5f105f2b5f115f0e")[1]
                              
                        
                              
                              var fullNameArr2_2 = fullNameArr_2!.components(separatedBy: "5f")[0]
                    
                              var str_2 = String(decoding: Data(fullNameArr2_2.hexaData), as: UTF8.self)
                              
                              str_2 = String(str_2)
                              
                     
                
                              str_2.removeFirst(min(str_2.count, 1))
                              
                              
                              var new_last_name_2 = str_2.components(separatedBy: "<<")[0]
                              var new_first_name_2 = str_2.components(separatedBy: "<<")[1].replacingOccurrences(of: "<", with: " ", options: .literal, range: nil)
                              
                              debugPrint(new_first_name_2)
                      
                              if new_last_name_2.count >= 1 {
                                  print("newnamesorun3")
                                  passportModelDictionary["firstName"] = new_first_name_2
                                  passportModelDictionary["lastName"] = new_last_name_2
                              }

                          }
                
            
                passportModelDictionary["birthDate"] = model?.dateOfBirth
                passportModelDictionary["documentNumber"] = model?.documentNumber
                passportModelDictionary["mrzKey"] = model?.passportMRZ
                passportModelDictionary["nationality"] = model?.nationality
                passportModelDictionary["issuingAuthority"] = model?.issuingAuthority
                passportModelDictionary["gender"] = model?.gender
                passportModelDictionary["documentType"] = model?.documentType
                passportModelDictionary["documentNumber"] = model?.documentNumber
                passportModelDictionary["documentExpiryDate"] = model?.documentExpiryDate
               
                
                passportModelDictionary["DS_certToPEM"] = ""
                passportModelDictionary["DS_Fingerprint"] = ""
                passportModelDictionary["DS_IssuerName"] = ""
                passportModelDictionary["DS_NotAfterDate"] = ""
                passportModelDictionary["DS_NotBeforeDate"] = ""
                passportModelDictionary["DS_PublicKeyAlgorithm"] = ""
                passportModelDictionary["DS_SerialNumber"] = ""
                passportModelDictionary["DS_SignatureAlgorithm"] = ""
                passportModelDictionary["DS_SubjectName"] = ""
                
                
                
                
                
                
                var totalCredentialsCount:Int = 0
            
                guard let storageCredentialsCount = UserDefaults.standard.object(forKey: "credentialsCount") else {return}
                
                
                debugPrint("sorun2")
                
                guard let storageCredentialsCount_ = storageCredentialsCount as? Int else {return}
                
                debugPrint("sorun3")
                
                if storageCredentialsCount_ != nil {
                    debugPrint("sorun4")
                    totalCredentialsCount = storageCredentialsCount_
                }
                
                
                
                
                
                
                var credentialConflictBoo = false
                
                
                for i in 0...totalCredentialsCount {
                    
                    if i != totalCredentialsCount {
                    
                        var storageDate_forKey = "credentialDictionary" + String(i + 1)
                        
                let storageDate = UserDefaults.standard.object(forKey: storageDate_forKey)
                guard let encodedData = storageDate as? Data else {return}
                if encodedData != nil {
                    let decodedDic = try? JSONDecoder().decode([[String:String]].self, from: encodedData as! Data)
                    if decodedDic != nil {
                        for decodedDic in decodedDic! {
                            
                            if passportModelDictionary["DG1hash"] == decodedDic["DG1hash"]!{
                                credentialConflictBoo = true
                                
                                
                                DispatchQueue.main.async {
                                    
                                        let ac = UIAlertController(title: "Error", message: "You have already added this credential.", preferredStyle: .alert)
                                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                              self.dismiss(animated: true, completion: nil)
                                        }))
                                    self.present(ac, animated: true)
                                    
                                }
                                
                                
                                
                                print("conflict")
                               
                                
                            }
                            
                        }
                    }
                        }
                    }
                }
                
                
           
                if credentialConflictBoo == false {
     
                debugPrint("sorun6")
                
                var encodedDictionary_forKey_nonce:Int = 0
                var encodedDictionary_forKey:String = ""
                var encodedDictionary_forKey_image:String = ""
  
                encodedDictionary_forKey_nonce = encodedDictionary_forKey_nonce + Int(totalCredentialsCount) + 1
                
                UserDefaults.standard.set(totalCredentialsCount + 1, forKey: "credentialsCount")
  
                encodedDictionary_forKey = "credentialDictionary" + String(encodedDictionary_forKey_nonce)
                encodedDictionary_forKey_image = "credentialImage" + String(encodedDictionary_forKey_nonce)
                
                debugPrint("encodedDictionary_forKey")
                debugPrint(encodedDictionary_forKey)
                
                
                self.dataProvider.store(image: (model?.passportImage)!, forKey: encodedDictionary_forKey_image, withStorageType: .userDefaults)
                

                let encoder = JSONEncoder()
                var newDictionary: [[String:String]] = []
                newDictionary.append(passportModelDictionary)
                let encodedDictionary = try! JSONEncoder().encode(newDictionary)
                UserDefaults.standard.set(encodedDictionary, forKey: encodedDictionary_forKey)
                guard let storageDate = UserDefaults.standard.object(forKey: encodedDictionary_forKey) else { return }
                guard let encodedData = storageDate as? Data else {return}
                if encodedData != nil {
                    var decodedDictionary = try! JSONDecoder().decode([[String:String]].self, from: storageDate as! Data)
                    if decodedDictionary.contains(passportModelDictionary) == false {
                        decodedDictionary.append(passportModelDictionary)
                        let encodedPassportModelDic = try! encoder.encode(decodedDictionary)
                        UserDefaults.standard.set(encodedPassportModelDic, forKey: encodedDictionary_forKey)
                    }
                }
                
                
            
                
                
                
                
       
                
                DispatchQueue.main.async {
                    self.nfcScannerButton.isEnabled = false
                    self.nfcScannerButton.setBackgroundImage(#imageLiteral(resourceName: "button2_done"), for: .disabled)
                    self.facialAuthenticationButton.isEnabled = true
                }
                }
            
                
                }
                
            
        }
    }
    

    
    @IBAction func facialAuthButtonTapped (_sender: UIButton) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(true, forKey: "isPassportAdded")
                        self!.facialAuthenticationButton.setBackgroundImage(UIImage(named: "button_3_done"), for: .disabled)
                        self!.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self!.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

extension AddPassportViewController: MRZDelegate {
    func passKey(with mrzKey: String) {
        self.mrzKey = mrzKey
        scanPassportButton.setBackgroundImage(UIImage(named: "button_1_done"), for: .disabled)
        scanPassportButton.isEnabled = false
        nfcScannerButton.isEnabled = true
    }
}
