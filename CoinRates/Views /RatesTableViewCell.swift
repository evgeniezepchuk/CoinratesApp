//
//  RatesTableViewCell.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit
import Combine

final class RatesTableViewCell: UITableViewCell {
    var combineModel = PassthroughSubject<Model, Never>()
    private var subscriptions = Set<AnyCancellable>()
    static let identifire = "Cell"
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAllView()
        backgroundColor = .buttonBacgrndColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Private methods
    private func stackCreator(arrangedSubviews: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func labelCreator(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = text
        label.textColor = .titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func configureAllView() {
        let currencyUSD = labelCreator(text: "USD $ 🇺🇸")
        let usdSellPrice = labelCreator(text: "")
        let usdBuyPrice = labelCreator(text: "")
        let usdStack = stackCreator(arrangedSubviews: [currencyUSD, usdSellPrice, usdBuyPrice])

        let currencyEUR = labelCreator(text: "EUR € 🇪🇺")
        let eurSellPrice = labelCreator(text: "")
        let eurBuyPrice = labelCreator(text: "")
        let eurStack = stackCreator(arrangedSubviews: [currencyEUR, eurSellPrice, eurBuyPrice])
        
        let titleCurrency = labelCreator(text: "Валюта")
        let sellTitle = labelCreator(text: "Сдать")
        let buyTitle = labelCreator(text: "Купить")
        let titleStack = stackCreator(arrangedSubviews: [titleCurrency, sellTitle, buyTitle])

        let generalStack = stackCreator(arrangedSubviews: [titleStack, usdStack, eurStack])
        generalStack.axis = .vertical
        addSubview(generalStack)
        
        configureConstraints(titleStack: titleStack, usdStack: usdStack, eurStack: eurStack, generalStack: generalStack)
        setSubscription(usdSellPrice: usdSellPrice, usdBuyPrice: usdBuyPrice, eurSellPrice: eurSellPrice, eurBuyPrice: eurBuyPrice)
    }
    
    // MARK: - Set subscriptions
    private func setSubscription(usdSellPrice: UILabel,
                                 usdBuyPrice: UILabel,
                                 eurSellPrice: UILabel,
                                 eurBuyPrice: UILabel) {
        
        combineModel
            .map({ $0.USD_in ?? "" })
            .assign(to: \.text, on: usdSellPrice)
            .store(in: &subscriptions)
    
        combineModel
            .map({ $0.USD_out ?? "" })
            .assign(to: \.text, on: usdBuyPrice)
            .store(in: &subscriptions)
        
        combineModel
            .map({ $0.EUR_out ?? "" })
            .assign(to: \.text, on: eurSellPrice)
            .store(in: &subscriptions)
        
        combineModel
            .map({ $0.EUR_in ?? "" })
            .assign(to: \.text, on: eurBuyPrice)
            .store(in: &subscriptions)
    }
    
    private func configureConstraints(titleStack: UIStackView,
                                      usdStack: UIStackView,
                                      eurStack: UIStackView,
                                      generalStack: UIStackView) {
        
        // MARK: - Configure constraints single hStack
        NSLayoutConstraint.activate([
            titleStack.heightAnchor.constraint(equalToConstant: 30),
            titleStack.rightAnchor.constraint(equalTo: generalStack.rightAnchor),
            titleStack.leftAnchor.constraint(equalTo: generalStack.leftAnchor),
        ])
        
        NSLayoutConstraint.activate([
            usdStack.heightAnchor.constraint(equalToConstant: 30),
            usdStack.rightAnchor.constraint(equalTo: generalStack.rightAnchor),
            usdStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor),
            usdStack.leftAnchor.constraint(equalTo: generalStack.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            eurStack.heightAnchor.constraint(equalToConstant: 30),
            eurStack.rightAnchor.constraint(equalTo: generalStack.rightAnchor),
            eurStack.topAnchor.constraint(equalTo: usdStack.bottomAnchor),
            eurStack.leftAnchor.constraint(equalTo: generalStack.leftAnchor),
            eurStack.bottomAnchor.constraint(equalTo: generalStack.bottomAnchor)
        ])
        
        // MARK: - Configure constraints general vStack
        NSLayoutConstraint.activate([
            generalStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25),
            generalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            generalStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50),
            generalStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 25)
        ])
    }
}

