//
//  CurrencySelectionPageViewController.swift
//  Currency
//
//  Created by kuanwei on 2022/5/11.
//

import Foundation
import UIKit

final class CurrencySelectionPageViewController: UIViewController {
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: .zero)
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    private lazy var currencyTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.placeholder = "USD"
        textField.textAlignment = .center
        textField.addDoneButtonToKeyboard(action: #selector(textField.resignFirstResponder))
        textField.inputView = pickerView
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.delegate = self
        textField.placeholder = "Input number"
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.addDoneButtonToKeyboard(action: #selector(textField.resignFirstResponder))
        return textField
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private var inputNumber: Double = 1.0 {
        didSet {
            collectionView.reloadData()
        }
    }

    private let viewModel: CurrencySelectionPageViewModel

    init(viewModel: CurrencySelectionPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Currency Selection"

        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupViews()
        setupBindings()

        let currencyName = viewModel.lastViewedCurrencyName ?? Config.defaultCurrency
        viewModel.fetchCurrencyLiveInfo(with: currencyName) { error in
            guard let error = error else {
                return
            }
            print(error)
        }
    }

    private func setupNavigationBar() {
        let defaultCurrencyBarButtonItem = UIBarButtonItem(title: Config.defaultCurrency, style: .plain, target: self, action: #selector(selectDefaultCurrency))
        navigationItem.rightBarButtonItem = defaultCurrencyBarButtonItem
    }

    @objc
    private func selectDefaultCurrency() {
        let currencyName = Config.defaultCurrency
        setupPickerViewRowPosition(with: currencyName)
        currencyTextField.text = currencyName
        viewModel.fetchCurrencyLiveInfoForDisplay(with: currencyName)
        viewModel.setLastViewedCurrencyName(currencyName)
    }

    func setupViews() {
        currencyTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currencyTextField)
        NSLayoutConstraint.activate([
            currencyTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            currencyTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])

        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: currencyTextField.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
        ])

        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: String(describing: CurrencyCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func setupBindings() {
        viewModel.currencyExchangeRates.observe = { [weak self] _ in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        viewModel.currencyList.observe = { [weak self] currencyList in
            guard let self = self else {
                return
            }

            let currencyName = self.viewModel.lastViewedCurrencyName ?? Config.defaultCurrency

            self.setupPickerViewRowPosition(with: currencyName)
            self.currencyTextField.text = currencyName
            self.currencyTextField.isUserInteractionEnabled = true
        }
    }

    private func setupPickerViewRowPosition(with currencyName: String) {
        let index = viewModel.currencyList.value.firstIndex { currencyDescription in
            currencyDescription.name == currencyName
        } ?? 0

        pickerView.selectRow(index, inComponent: 0, animated: true)
    }
}

extension CurrencySelectionPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currencyExchangeRates.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CurrencyCell.self), for: indexPath) as? CurrencyCell else {
            return UICollectionViewCell()
        }

        let currencyQuote = viewModel.currencyExchangeRates.value[indexPath.row]
        cell.currencyName = currencyQuote.name
        cell.rate = currencyQuote.rate * inputNumber

        return cell
    }
}

extension CurrencySelectionPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currencyQuote = viewModel.currencyExchangeRates.value[indexPath.row]
        textField.text = String(currencyQuote.rate)
    }
}

extension CurrencySelectionPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 50) / 3.0
        let height: CGFloat = 75
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

/// https://developer.apple.com/documentation/uikit/uitextfielddelegate
extension CurrencySelectionPageViewController: UITextFieldDelegate {

    /// If you do not implement this method, the text field acts as if this method had returned true.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    /// This can happen when the user selects another control or when you call the text field’s resignFirstResponder() method
    /// If you do not implement this method, the text field resigns the first responder status as if this method had returned true.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if var text = textField.text {
            if string.isEmpty {
                text.removeLast()
            } else {
                text.append(string)
            }

            inputNumber = Double(text) ?? 1.0
        }

        return true
    }

    /// If you do not implement this method, the text field clears the text as if the method had returned true.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension CurrencySelectionPageViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencyName = viewModel.currencyList.value[row].name
        currencyTextField.text = currencyName

        viewModel.fetchCurrencyLiveInfoForDisplay(with: currencyName)
        viewModel.setLastViewedCurrencyName(currencyName)
    }
}

extension CurrencySelectionPageViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencyList.value.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyCode = viewModel.currencyList.value[row].name
        let currencyDescription = viewModel.currencyList.value[row].detailDescription
        return "\(currencyCode): \(currencyDescription)"
    }
}
