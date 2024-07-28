//
//  GetStartedViewController.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit

final class GetStartedViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "coinrates"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let getStratedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.titleColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .buttonBacgrndColor
        button.layer.cornerRadius = 15
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewConfigure()
        configureAddButton()
        setCircleDecoration()
    }
    
    private func viewConfigure() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.tintColor = .titleColor
        navigationController.navigationBar.barTintColor = .backgroundColor
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.titleColor]
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.titleColor]
        configureGetStartesVC()
    }
    
    private func configureAddButton() {
        let action = UIAction(handler: { _ in
            self.navigationController?.pushViewController(SelectionViewController(), animated: true)
        })
        getStratedButton.addAction(action, for: .touchUpInside)
        
        view.addSubview(getStratedButton)
        
        getStratedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            getStratedButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            getStratedButton.heightAnchor.constraint(equalToConstant: 50),
            getStratedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStratedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIScreen.main.bounds.height / 4)
        ])
    }
    
    private func setCircleDecoration() {
        let circleArray = [configureCircleView(icon: "$", frame: CGRect(x: 220, y: 200, width: 150, height: 150),
                               bcgrndColor: .circleColor1, titleColor: .circleColor3),
                           configureCircleView(icon: "€", frame: CGRect(x: 30, y: 60, width: 120, height: 120), bcgrndColor: .circleColor2, titleColor: .circleColor1),
                           configureCircleView(icon: "¥", frame: CGRect(x: 40, y: 430, width: 100, height: 100), bcgrndColor: .circleColor3, titleColor: .circleColor2)]
        circleArray.forEach { circleView in
            view.addSubview(circleView)
        }
    }
    
    private func configureGetStartesVC() {
        view.backgroundColor = .backgroundColor
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
    }
    
    private func configureCircleView(icon: String, frame: CGRect, bcgrndColor: UIColor, titleColor: UIColor) -> UIView {
        let circle = UIView(frame: frame)
        circle.layer.cornerRadius = frame.width / 2
        circle.backgroundColor = bcgrndColor
        let label = UILabel()
        label.text = icon
        label.textColor = titleColor
        label.font = .systemFont(ofSize: frame.width / 2, weight: .regular)
        circle.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
        return circle
    }
}

