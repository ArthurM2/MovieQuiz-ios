import UIKit

protocol AlertPresenterProtocol {
    func show(model: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {

    weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func show(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
    
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()
            }

        alert.view.accessibilityIdentifier = "AlertResult"
        alert.addAction(action)
    
        delegate?.present(alert, animated: true, completion: nil)
    }
}
