//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    @IBOutlet weak var fromTF: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var fromAmount: UITextField!
    @IBOutlet weak var toAmount: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    ///Local
    internal lazy var viewModel: CurrencyConverterViewModel = {
        return CurrencyConverterViewModel()
    }()
        
    internal lazy var pickerView: ToolbarPickerView = {
        let picker = ToolbarPickerView()
        picker.toolbarDelegate = self
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getCurrenciesList()
        self.setUpPickerView()
        self.title = "Currency Converter"
    }
    
    func setUpPickerView() {
        self.fromTF.didMoveToSuperview()
        self.fromTF.inputView = self.pickerView
        self.fromTF.inputAccessoryView = self.pickerView.toolbar
        self.toTF.inputView = self.pickerView
        self.toTF.inputAccessoryView = self.pickerView.toolbar
    }
    
    
    @IBAction func convertBtn(_ sender: Any) {
        
    }
    
    @IBAction func detailesBtn(_ sender: Any) {
        
    }
    
    
}

extension CurrencyConverterViewController : ToolbarPickerViewDelegate {
    func didTapDone() {
        
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
        return viewModel.currencyCount
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = viewModel.getCellViewModel( at: row )
        return "\(model.name) (\(model.code))"
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.fromLabel.text = viewModel.getCellViewModel( at: row ).code
    }
}
