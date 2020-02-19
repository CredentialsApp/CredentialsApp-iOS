//
//  SignUpViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var firstNameTextField: TrustTextField!
    @IBOutlet weak var lastNameTextField: TrustTextField!
    @IBOutlet weak var birthDateTextField: TrustTextField!
    @IBOutlet weak var genderTextField: TrustTextField!
    @IBOutlet weak var socialSecurityNumberTextField: TrustTextField!
    @IBOutlet weak var nextButton: TrustButton!
    
    // MARK: - properties
    var datePickerView: UIDatePicker = UIDatePicker()
    var genderPickerView: UIPickerView = UIPickerView()
    let dateFormatter = DateFormatter()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "dd MM YYYY"
        dateFormatter.locale = Locale.current
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        genderTextField.inputView = genderPickerView
        birthDateTextField.inputView = datePickerView
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        datePickerView.addTarget(self, action: #selector(datePicked(_:)), for: .valueChanged)
    }
    // MARK: - Function
    func areFieldsFilled() -> Bool {
        for view in self.view.subviews {
            if let textField = view as? TrustTextField {
                if textField.text == "" {
                    return false
                }
            }
        }
        return true
    }
    func createUser() -> User? {
        if areFieldsFilled() {
            return User(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, birthDate: datePickerView.date, gender: Gender(rawValue: genderTextField.text!)!, socialSecurityNumber: socialSecurityNumberTextField.text!, pincode: nil)
        }
        return nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? PincodeViewController else { return }
        guard let user = createUser() else { return }
        viewController.user = user
        viewController.userDelegate = self
    }
    // MARK: - Actions
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if areFieldsFilled() {
            performSegue(withIdentifier: "goToPincodeSegue", sender: nil)
        }else {
            present(AlertService().createAlert(type: .fillAllFields)!, animated: true, completion: nil)
        }
    }
    @objc func datePicked(_ sender: UIDatePicker) {
        let date = sender.date
        birthDateTextField.text = dateFormatter.string(from: date)
    }
}

extension SignUpViewController: UserDelegate {
    func getUser() -> User? {
        if let user = createUser() {
            return user
        } else {
            return nil
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SignUpViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Gender.allCases.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Gender.allCases[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = Gender.allCases[row].rawValue
    }
}
