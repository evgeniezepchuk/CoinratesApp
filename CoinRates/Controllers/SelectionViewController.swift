//
//  SelectionViewController.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit

final class SelectionViewController: UIViewController {

    // MARK: - Private properties
    private var model: Model?
    private var town: String = "Александрия"
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Александрия"
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.textColor = .titleColor
        textField.backgroundColor = .buttonBacgrndColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        picker.setValue(UIColor.titleColor, forKey: "textColor")
        picker.layer.cornerRadius = 15
        return picker
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.titleColor, for: .normal)
        btn.backgroundColor = .buttonBacgrndColor
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var getLocalityLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a location"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .titleColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle view controller
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllMethods()
    }
    
    // MARK: - Private methods
    private func loadAllMethods() {
        view.addSubview(picker)
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(getLocalityLabel)
        picker.isHidden = true
        picker.delegate = self
        picker.dataSource = self
        picker.center = view.center
        tapButton()
        view.backgroundColor = .white
        setConstraints()
        addActionTextField()
        viewAddAction()
        view.backgroundColor = .backgroundColor
    }
    
    private func addActionTextField() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        textField.addGestureRecognizer(tapGesture)
    }
    
    private func viewAddAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func tapButton() {
        let action: UIAction? = UIAction { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(ViewController(town: town), animated: true)
        }
        self.button.addAction(action ?? UIAction.init(handler: { _ in }), for: .touchUpInside)
    }
    
    // MARK: - @objc methods for gesture
    @objc func tapView() {
        picker.isHidden = true
        textField.isHidden = false
    }
    
    @objc func tap() {
        picker.isHidden = false
        textField.isHidden = true
    }
    
    // MARK: - Configure constraints
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            getLocalityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getLocalityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            getLocalityLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            getLocalityLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(UIScreen.main.bounds.height / 6)),
        ])
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 70),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - Extensions
extension SelectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CitiesList.shared.helpersArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.placeholder = CitiesList.shared.helpersArray[row]
        self.town = CitiesList.shared.helpersArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CitiesList.shared.helpersArray[row]
    }
}
