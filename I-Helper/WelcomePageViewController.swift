//
//  WelcomePageViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 02/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController {
    
    // MARK: - Instance Properties
    public let childIdentifiers = ["Page1", "Page2", "Page3","Page4"]
    internal lazy var childPages: [UIViewController] = { [unowned self] in
        return self.childIdentifiers.map { identifier in
            return self.storyboard!.instantiateViewController(withIdentifier: identifier)
        }
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPager()
        
    }
    
    private func setupPager() {
        dataSource = self
        setViewControllers([childPages.first!], direction: .forward, animated: false, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = childPages.index(of: viewController), currentIndex > 0 else {
            return nil
        }
        return childPages[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = childPages.index(of: viewController),
            currentIndex < (childPages.count - 1) else { return nil }
        return childPages[currentIndex + 1]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return childPages.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
