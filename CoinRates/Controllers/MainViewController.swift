//
//  MainViewController.swift
//  CoinRates
//
//  Created by Евгений Езепчук on 27.07.24.
//

import UIKit
import Combine
import Lottie

final class ViewController: UIViewController {
    
    private var town: String = ""
    private lazy var model: [Model] = []
    private lazy var filialsData: [Model] = []
    private lazy var city: [Cities] = []
    var subscribtions = Set<AnyCancellable>()
    
    private var loadingView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .white
        let imageView = LottieAnimationView()
        imageView.backgroundColor = .backgroundColor
        imageView.animation = LottieAnimation.named("LoadingAnimation1")
        imageView.loopMode = .loop
        imageView.play()
        view = imageView
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .grouped)
        tv.register(RatesTableViewCell.self, forCellReuseIdentifier: RatesTableViewCell.identifire)
        tv.backgroundColor = .backgroundColor
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    init(town: String) {
        self.town = town
        super .init(nibName: nil, bundle: nil)
        getCitiesData()
        startCityDataRequest()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoadingView()
        startAPIRequest()
    }
    
    private func configureLoadingView() {
        view.backgroundColor = .backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        self.view = loadingView
    }
    
    private func getCitiesData() {
        APICaller.shared.getCitiesDataPublisher(cityName: town)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showAlert(error)
                case .finished:
                    print("finished...")
                }
            } receiveValue: { city in
                self.city = city
            }
            .store(in: &subscribtions)
    }
    
    private func showAlert(_ error: ErrorHandler) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alert, animated: true)
        }
    }
    
    private func startAPIRequest() {
        APICaller.shared.fetchRatesPublisher(with: town)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showAlert(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { model in
                if model.isEmpty {
                    self.showAlert(ErrorHandler.informationIsEmpty)
                }
                self.model = model
                self.view.addSubview(self.tableView)
            }
            .store(in: &subscribtions)
    }
    
    private func startCityDataRequest() {
        APICaller.shared.fetchDataPublisher(with: town)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showAlert(error)
                    print(error)
                case .finished:
                    print("finished")
                }
            } receiveValue: { model in
                self.filialsData = model
            }
            .store(in: &subscribtions)
    }
    
    private func setViewForHeader(_ section: Int) -> UIView {
        let view = UIView()
        let header = UILabel()
        view.addSubview(header)
        
        header.text = ("\(model[section].street_type ?? "") \(model[section].street ?? "") \(model[section].home_number ?? ""). \(model[section].filials_text ?? "")")
        header.font = UIFont.systemFont(ofSize: 18,weight: .medium)
        header.textColor = .titleColor
        header.frame = CGRect(x: 10, y: 0, width: Int(view.frame.width) / 2, height: 15)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        return view
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RatesTableViewCell.identifire) as? RatesTableViewCell else { return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.combineModel.send(model[indexPath.section])
        title = town
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !city.isEmpty else { return }
        navigationController?.pushViewController(BranchViewController(model: self.model[indexPath.section], city: self.city[0], filialsData: self.filialsData[indexPath.section]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setViewForHeader(section)
    }
}
