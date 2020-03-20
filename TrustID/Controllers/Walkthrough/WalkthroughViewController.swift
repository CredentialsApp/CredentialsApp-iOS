//
//  ViewController.swift
//  TrustID
//
//  Created by Berk Turan on 12/18/19.
//  Copyright © 2019 GatePay. All rights reserved.
//

import UIKit
import NFCPassportReader
class WalkthroughViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: TrustButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let slides = createSlides()
        setupSlideScrollView(slides: slides)
    }
    
    // MARK: - Function
    func createSlides() -> [Slide] {
        let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "rectangle1")
        slide1.titleLabel.text = "A warehouse for certificates"
        slide1.descriptionLabel.text = "Alumni can confirm your educational records with the press of a button."
        slide1.frame = scrollView.frame
        
        let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "rectangle2")
        slide2.titleLabel.text = "Healthcare"
        slide2.descriptionLabel.text = "Allows P2P transmission of health data for dating and other social purposes"
        slide2.frame = scrollView.frame
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "rectangle3")
        slide3.titleLabel.text = "Employment"
        slide3.descriptionLabel.text = "Alumni can confirm your work records with the press of a button."
        slide3.frame = scrollView.frame
        
        return [slide1, slide2, slide3]
    }
    func setupSlideScrollView(slides : [Slide]) {
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 0)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    // MARK: - Actions
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "CredentialsPageSegue", sender: nil)
    }
}

extension WalkthroughViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
            pageControl.currentPage = Int(pageIndex)
    }
}



