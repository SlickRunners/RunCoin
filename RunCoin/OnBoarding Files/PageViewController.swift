//
//  PageViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 7/30/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVC(viewController: "OnBoardingOne"), self.newVC(viewController: "OnBoardingTwo"), self.newVC(viewController: "OnBoardingThree"), self.newVC(viewController: "OnBoardingFinal")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        self.dataSource = self
        self.delegate = self
        configurePageControl()
        // Do any additional setup after loading the view.
    }
    
    func newVC(viewController : String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard orderedViewControllers.count != nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentVC = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentVC)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.minY + 25, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.offBlue
        pageControl.pageIndicatorTintColor = UIColor.greyish
        pageControl.currentPageIndicatorTintColor = UIColor.offBlue
        self.view.addSubview(pageControl)
    }
    

}
