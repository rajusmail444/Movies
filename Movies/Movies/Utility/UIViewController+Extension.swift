//
//  UIViewController+Extension.swift
//  Movies
//
//  Created by Rajesh Billakanti on 20/10/21.
//

import UIKit

public protocol ViewControllerProtocol {
    associatedtype ViewModelT
    var viewModel: ViewModelT! { get set }
}

extension UIViewController {
    public static func make<T: ViewControllerProtocol>(viewController: T.Type,
                                                       viewModel: T.ViewModelT) -> T {
        var viewController = make(viewController: viewController)
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func make<T>(viewController: T.Type) -> T {
        let viewControllerName = String(describing: viewController)
        
        let storyboard = UIStoryboard(name: viewControllerName,
                                      bundle: Bundle(for: viewController as! AnyClass))
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Unable to create ViewController: \(viewControllerName) from storyboard: \(storyboard)")
        }
        return viewController
    }
}
