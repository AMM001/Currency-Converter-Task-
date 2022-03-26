//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import UIKit
import RxSwift

class CurrencyConverterViewController: UIViewController {
    
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var fromAmount: UITextField!
    @IBOutlet weak var toAmount: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var countries: [String] = []
    var countriesDic: [String:String] = ["":""]
    var resultConvert :Int = 0
    var currencyDataViewModel = [CurrencyDataViewModel]()
    
    ///Local
    internal lazy var viewModel: CurrencyConverterViewModel = {
        return CurrencyConverterViewModel()
    }()
    
    internal lazy var fromPickerView: ToolbarPickerView = {
        let picker = ToolbarPickerView()
        picker.toolbarDelegate = self
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    internal lazy var toPickerView: ToolbarPickerView = {
        let picker = ToolbarPickerView()
        picker.toolbarDelegate = self
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subscribeObservers()
        self.viewModel.getCurrenciesList()
        self.setUpPickerView()
        self.title = "Currency Converter"
    }
    
    
    func subscribeObservers() {
        viewModel.currenciesObserver.asDriver(onErrorJustReturn: AvRxResult.getGenericError()).drive(onNext: { [weak self] (countries) in
            guard let self = self else { return }
            self.currencyDataViewModel = countries.successResult ?? [CurrencyDataViewModel]()
        }).disposed(by: disposeBag)
        
        viewModel.convertObserver.asDriver(onErrorJustReturn: AvRxResult.getGenericError()).drive(onNext: { [weak self] (result) in
            guard let self = self else { return }
            self.resultConvert = result.successResult ?? 0
            self.toTF.text = "\(result.successResult ?? 0)"
        }).disposed(by: disposeBag)
    }
    
    
    func setUpPickerView() {
        self.fromTF.didMoveToSuperview()
        self.fromTF.inputView = self.fromPickerView
        self.fromTF.inputAccessoryView = self.fromPickerView.toolbar
        
        self.toTF.didMoveToSuperview()
        self.toTF.inputView = self.toPickerView
        self.toTF.inputAccessoryView = self.toPickerView.toolbar
    }
    
    
    @IBAction func convertBtn(_ sender: Any) {
        let amount =  self.fromAmount.text ?? ""
        self.viewModel.convertCurrency(from: self.fromLabel.text ?? "", to: self.toLabel.text ?? "", amount:amount )
    }
    
    @IBAction func detailesBtn(_ sender: Any) {
        
    }
    
    private func viewModelClosures() {
        
        /// Naive binding
        viewModel.showAlert = { (message) in
            DispatchQueue.main.async {
                UIAlertController.showAlert(title: LocalizableStrings.error, message: message, cancelButton: LocalizableStrings.ok)
            }
        }
    }
}

extension CurrencyConverterViewController : ToolbarPickerViewDelegate {
    func didTapDone() {
        self.view.endEditing(true)
    }
    
    func didTapCancel() {
        self.view.endEditing(true)
        
    }
}

//MARK: - UIPickerView delegates
extension CurrencyConverterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyDataViewModel.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(currencyDataViewModel[row].name) (\(currencyDataViewModel[row].code))"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromPickerView {
            self.fromLabel.text = currencyDataViewModel[row].code
        }else{
            self.toLabel.text = currencyDataViewModel[row].code
        }
    }
}
