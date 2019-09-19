//
//  BottomSheetController.swift
//  NestedScrollView
//
//  Created by ugur on 12.08.2018.
//  Copyright © 2018 me. All rights reserved.
//

import UIKit

enum SheetLevel{
    case top, bottom, middle
}

open class BottomSheetController: UIViewController {
    
    //1 : full height, 0 : minimum height default is 1
    open var topYPercentage: CGFloat = 1
    
    //1 : full height, 0 : minimum height default is 0.5
    open var middleYPercentage: CGFloat = 0.5
    
    //1 : full height, 0 : minimum height default is 0.1
    open var bottomYPercentage: CGFloat = 0.1
    
    //using superview bottom inset is recommended default is 0
    open var bottomInset: CGFloat = 0
    
    //using safe area top inset is recommended default is 80
    open var topInset: CGFloat = 80
    
    
    var topY: CGFloat{
        return (1 - topYPercentage) * fullHeight + topInset - bottomInset
    }
    
    var middleY: CGFloat{
        return (1 - middleYPercentage) * fullHeight + topInset - bottomInset
    }
    
    var bottomY: CGFloat{
        return (1 - bottomYPercentage) * fullHeight + topInset - bottomInset
    }
    
    var panView: UIView!{
        return view
    }
    
    var containerView = UIView()

    var pan: UIPanGestureRecognizer!
    
    var parentView: UIView!
    
    var lastPosition: SheetLevel = .middle
    
    var fullHeight: CGFloat{
        return (parent?.view.frame.height ?? UIScreen.main.bounds.height) - topInset - bottomInset
    }
    
    var lastOffset: CGPoint = .zero
    var startLocation: CGPoint = .zero
    var freezeContentOffset = false
    
    //tableview variables
    var listItems: [Any] = []
    var headerItems: [Any] = []
    
    open var scrollView: UIScrollView?
    
    func findScrollView(from view: UIView) -> UIView?{
        return view.ub_firstSubView(ofType: UIScrollView.self)
    }
    
    
    var topConstraint: NSLayoutConstraint?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestures()
        addObserver()

    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        panView.frame = containerView.bounds
    }
    
    func addObserver(){
        scrollView?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
    }
    
    func setupGestures(){
        if scrollView == nil{
            scrollView = findScrollView(from: self.view) as? UIScrollView
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.view.addGestureRecognizer(pan)
        self.scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollPan(_:)))
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if let scroll = scrollView, scroll.contentOffset.y < 0{
                scrollView?.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began: break
        case .changed:
            dragView(recognizer)
        default:
            snapTo(level: nextLevel(recognizer: recognizer))
        }
        
    }
    
    @objc func handleScrollPan(_ recognizer: UIPanGestureRecognizer){
        let vel = recognizer.velocity(in: self.panView)
        
        if scrollView!.contentOffset.y > 0 && vel.y >= 0{
            lastOffset = scrollView!.contentOffset
            self.startLocation = recognizer.translation(in: self.scrollView!)
            return
        }
        
        switch recognizer.state {
        case .began:
            freezeContentOffset = false
            lastOffset = scrollView!.contentOffset
            self.startLocation = recognizer.translation(in: self.scrollView!)
        case .changed:
            let dy = recognizer.translation(in: self.scrollView!).y - startLocation.y
            let f = getFrame(for: dy)
            topConstraint?.constant = f.minY

            startLocation = recognizer.translation(in: self.scrollView!)
            
            if containerView.frame.minY > topY && vel.y < 0{
                freezeContentOffset = true
                scrollView!.setContentOffset(lastOffset, animated: false)
            }else{
                lastOffset = scrollView!.contentOffset
            }
        default:
            snapTo(level: nextLevel(recognizer: recognizer))
        }
    }
    
    func dragView(_ recognizer: UIPanGestureRecognizer){
        let dy = recognizer.translation(in: self.panView).y
        //        panView.frame = getFrame(for: dy)
        topConstraint?.constant = getFrame(for: dy).minY
        
        recognizer.setTranslation(.zero, in: self.panView)
    }
    
    func getFrame(for dy: CGFloat) -> CGRect{
        let f = containerView.frame
        let minY =  min(max(topY, f.minY + dy), bottomY)
        let h = f.maxY - minY
        return CGRect(x: f.minX, y: minY, width: f.width, height: h)
    }
    
    func snapTo(level: SheetLevel){
         let f = containerView.frame
        var minY = topY
        
        switch level {
        case .top:
            minY = topY
            lastPosition = .top
        case .middle:
            minY = middleY
            lastPosition = .middle
        case .bottom:
            minY = bottomY
            lastPosition = .bottom
        }
        
        guard minY != f.minY else{return}

        
        if freezeContentOffset && scrollView!.panGestureRecognizer.state == .ended{
            scrollView!.setContentOffset(lastOffset, animated: false)
        }
        

        let h = f.maxY - minY
        let rect = CGRect(x: f.minX, y: minY, width: f.width, height: h)
        self.topConstraint?.constant = rect.minY
        
        animate(animations: {
            self.parent?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    open func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil){
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: animations, completion: completion)
    }
    
    func nextLevel(recognizer: UIPanGestureRecognizer) -> SheetLevel{
        let y = self.containerView.frame.minY
        let velY = recognizer.velocity(in: self.view).y
        if velY < -150{
            return y > middleY ? .middle : .top
        }else if velY > 150{
            return y < (middleY + 1) ? .middle : .bottom
        }else{
            if y > middleY {
                return (y - middleY) < (bottomY - y) ? .middle : .bottom
            }else{
                return (y - topY) < (middleY - y) ? .top : .middle
            }
        }
    }
}

extension BottomSheetController: Pannable{

    public func attach(to parent: UIViewController) {
        parent.ub_add(self, in: containerView)

        containerView.edges([.left, .right, .top, .bottom], to: parent.view, offset: .zero)
        
        topConstraint = parent.view.constraints.first { (c) -> Bool in
            c.firstItem as? UIView == self.containerView && c.firstAttribute == .top
        }
        
        let bottomConstraint = parent.view.constraints.first { (c) -> Bool in
            c.firstItem as? UIView == self.containerView && c.firstAttribute == .bottom
        }
        
        bottomConstraint?.constant = -bottomInset
        
    }
    
    public func detach() {
        self.ub_remove()
    }
    
}

