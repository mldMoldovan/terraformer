//
//  newsViewController.swift
//  Exp0900
//
//  Created by Mihai Moldovan on 25/07/2018.
//  Copyright © 2018 MLD Software. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class newViewController:UIViewController{
    
    var backImage:UIImageView!
    
    var topStack:UIStackView!
    var topHeight:CGFloat = 150
    
    var leftButton:UIButton!
    var rightButton:UIButton!
    
    var webView:WKWebView!
    
    
    
    
    
    func initView(){
        
        
        
        backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        backImage.image = UIImage(named: "newsBackground")
        backImage.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        self.view.addSubview(backImage)
        
        
        
        
        
        topStack = UIStackView(frame: CGRect(x: 0, y: self.view.bounds.height - topHeight, width: self.view.bounds.width, height: topHeight))
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.distribution = .fillEqually
        topStack.spacing = 0
        
        leftButton = UIButton(type: .roundedRect)
        leftButton.setTitle("Left", for: .normal)
        leftButton.contentHorizontalAlignment = .fill
        leftButton.contentVerticalAlignment = .fill
        
        rightButton = UIButton(type: .roundedRect)
        rightButton.setTitle("Right", for: .normal)
        rightButton.contentHorizontalAlignment = .fill
        rightButton.contentVerticalAlignment = .fill
        
        topStack.addSubview(leftButton)
        topStack.addSubview(rightButton)
        
        self.view.addSubview(topStack)
        
        
        
        
        
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - topHeight))
        
        webView.load(URLRequest(url: URL(string: "https://www.turbosquid.com/3d-model/character")!))
        
        self.view.addSubview(webView)
        
        
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
