//
//  Controller.swift
//  BottomSheetDemo
//
//  Created by ugur on 19.04.2020.
//  Copyright © 2020 Sobe. All rights reserved.
//

import UIKit

public enum SheetTranslationState {
    case progressing(_ minYPosition: CGFloat, _ percent: CGFloat) //currently updating
    case willFinish(_ minYPosition: CGFloat, _ percent: CGFloat) //animation start
    case finished(_ minYPosition: CGFloat, _ percent: CGFloat) //animation end
}

public class UBottomSheetCoordinator: NSObject {
    public weak var parent22: UIViewController?
    private var container22: UIView?
    public weak var dataSource22: UBottomSheetCoordinatorDataSource? {
        didSet {
            guard let dataSource = dataSource22,
                  let availableHeight = availableHeight
            else {
                minSheetPosition22 = nil
                maxSheetPosition22 = nil
                return
            }
            minSheetPosition22 = dataSource.sheetPositions(availableHeight).min()
            maxSheetPosition22 = dataSource.sheetPositions(availableHeight).max()
        }
    }
    public weak var delegate: UBottomSheetCoordinatorDelegate?
    private var minSheetPosition22: CGFloat?
    private var maxSheetPosition22: CGFloat?
    ///View controllers which conform to Draggable protocol
    public var draggables: [DraggableItem] = []
    ///Drop shadow view behind container.
    private var dropShadowView: PassThroughView?
    /// accept difference equal if in tolerance
    private var tolerance: CGFloat = 0.0000001
    ///set true if sheet view controller is embedded in a UINavigationController
    public var usesNavigationController: Bool = false

    public var availableHeight: CGFloat? {
        return parent22?.view.frame.height
    }
    
    private var cornerRadius: CGFloat = 0 {
        didSet {
            applyDefaultShadowParams()
            clearShadowBackground()
        }
    }

    /**
     Creates UBottomSheetCoordinator object.
     
     Calling this in ```viewWillLayoutSubviews``` recommended. So the parent frame will be ready to calculate sheet params. Otherwise sheet may show up with a wrong position and frame.
     
     ```
     override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         // put your other stuff here
     
         guard sheetCoordinator == nil else {return}
         sheetCoordinator = UBottomSheetCoordinator(parent: self)
     }
     ```

     - parameter parent: UIViewController
     - parameter delegate: UBottomSheetCoordinatorDelegate
     */
    public init(parent: UIViewController, delegate: UBottomSheetCoordinatorDelegate? = nil) {
        super.init()
        self.parent22 = parent
        self.dataSource22 = parent
        self.delegate = delegate
        
        minSheetPosition22 = parent.sheetPositions(parent.view.frame.height).min()
        maxSheetPosition22 = parent.sheetPositions(parent.view.frame.height).max()
    }
    
    /**
     Creates a container view, sets contraints, set initial position, add background view if needed.
     
     You must handle add child on your own. This lets you apply your custom presenting animation.

     # Example #

     Call below code in parent view controller swift file.
     
     ```
     let sheetCoordinator = UBottomSheetCoordinator(parent: self)
     sheetCoordinator.createContainer(with: { (container) in
         container.layer.shadowColor = UIColor.black.cgColor
         container.layer.shadowRadius = 20
         container.layer.shadowOpacity = 0.5
         container.layer.shadowOffset = CGSize(width: -1, height: 1)
         container.layer.masksToBounds = false
         self.view.addSubview(container)
         addChild(child)
         child.view.frame = container.bounds.offsetBy(dx: 0, dy: container.bounds.height)
         container.addSubview(child.view)
         child.didMove(toParent: self)
         
         UIView.animate(withDuration: 0.3) {
             child.view.frame = container.bounds
         }
     })
     
     ```
     
     - parameter config: Called after container created. So you can customize the view, like shadow, corner radius, border, etc.
     */
    public func createContainer(with config: @escaping (UIView) -> Void) {
        guard let parent = parent22,
              let dataSource = dataSource22,
              let availableHeight = availableHeight
        else { return }
        let view = PassThroughView()
        self.container22 = view
        config(view)
        view.pinToEdges(to: parent.view)
        view.constraint(parent, for: .top)?.constant = dataSource.sheetPositions(availableHeight)[0]
        setPosition(dataSource.initialPosition(availableHeight), animated: false)
    }
    
    /**
     Creates a container view, adds it as a child to the parent, sets contraints, set initial position, add background view if needed.
     
     # Example #

     Call below code in parent view controller swift file.
     
     ```
     let sheetCoordinator = UBottomSheetCoordinator(parent: self)
     sheetCoordinator.addSheet(vc, to: self, didContainerCreate: { container in
         container.layer.shadowColor = UIColor.black.cgColor
         container.layer.shadowRadius = 10
         container.layer.shadowOpacity = 0.5
         container.layer.shadowOffset = .zero
         container.layer.masksToBounds = false
     })
     ```
     - parameter item: view controller which conforms to the Draggable or navigation controller which contains draggable view controllers.
     - parameter parent: parent view controller
     - parameter animated: if true, the sheet is being added to the view controller using an animation (default is true).
     - parameter didContainerCreate: triggered when container view created so you can modify the container if needed.
     - parameter completion: called upon the completion of adding item
     */
    public func addSheet(_ item: UIViewController,
                         to parent: UIViewController,
                         animated: Bool = true,
                         didContainerCreate: ((UIView) -> Void)? = nil,
                         completion: (() -> Void)? = nil) {
        self.usesNavigationController = item is UINavigationController
        let container = PassThroughView()
        self.container22 = container
        parent.view.addSubview(container)
        guard let dataSource = dataSource22,
              let availableHeight = availableHeight
        else { return }
        let position = dataSource.initialPosition(availableHeight)
        parent.ub_add(item, in: container, animated: animated, topInset: position) { [weak self] in
            guard let sSelf = self else { return }
            guard let percent = sSelf.calculatePercent(at: position) else {
                completion?()
                return
            }
            sSelf.delegate?.bottomSheet(container, didPresent: .finished(position, percent))
            completion?()
        }
        didContainerCreate?(container)
        setPosition(dataSource.initialPosition(availableHeight), animated: false)
    }
    
    /**
     Adds a new view child controller to the current container view
     
     - parameter item: view controller which conforms to the Draggable protocol
     - parameter completion: called upon completion of animation
     */
    public func addSheetChild(_ item: DraggableItem, completion:  ((Bool) -> Void)? = nil) {
        guard let parent = parent22,
              let container = container22,
              let availableHeight = availableHeight
        else { return }
        parent.addChild(item)
        container.addSubview(item.view)
        item.didMove(toParent: parent)
        item.view.frame = container.bounds.offsetBy(dx: 0, dy: availableHeight)

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            guard let container = self.container22 else { return }
            item.view.frame = container.bounds
        } completion: { finished in
            completion?(finished)
        }
    }
    
    /**
     Frame of the sheet when added.
     */
    private func getInitialFrame() -> CGRect {
        guard let parent = parent22,
              let dataSource = dataSource22,
              let availableHeight = availableHeight
        else {
            return CGRectMake(0, 0, 1, 1)
        }
        let minY = parent.view.bounds.minY + dataSource.initialPosition(availableHeight)
        return CGRect(x: parent.view.bounds.minX,
                      y: minY,
                      width: parent.view.bounds.width,
                      height: parent.view.bounds.maxY - minY)
    }
    
    /**
     Adds a drop shadow to the sheet.
     
     Use  ```removeDropShadow()``` to remove drop shadow.
     */
    public func addDropShadowIfNotExist(_ config: ((UIView) -> Void)? = nil) {
        guard dropShadowView == nil,
              let parent = parent22
        else { return }
        let dropShadowView = PassThroughView()
        self.dropShadowView = dropShadowView
        guard let container = container22 else { return }
        parent.view.insertSubview(dropShadowView, belowSubview: container)
        dropShadowView.pinToEdges(
            to: container,
            insets: UIEdgeInsets(
                top: -getInitialFrame().minY,
                left: 0,
                bottom: 0,
                right: 0
            )
        )
        dropShadowView.layer.masksToBounds = false
        if config == nil {
            applyDefaultShadowParams()
            clearShadowBackground()
        } else {
            config?(dropShadowView)
        }
    }
    
    /**
     Removes drop shadow added withfunc  ```addDropShadowIfNotExist()```.
     */
    public func removeDropShadow() {
        dropShadowView?.removeFromSuperview()
    }
    
    /**
     Applies default drop shadow params. i.e. color, radius, offset...
     */
    private func applyDefaultShadowParams() {
        dropShadowView?.layer.shadowPath = UIBezierPath(roundedRect: getInitialFrame(),
                                                        cornerRadius: cornerRadius).cgPath
        dropShadowView?.layer.shadowColor = UIColor.black.cgColor
        dropShadowView?.layer.shadowRadius = CGFloat.init(10)
//        dropShadowView?.layer.shadowOpacity = Float.init(0.5)
        dropShadowView?.layer.shadowOffset = CGSize.init(width: 0.0, height: 4.0)
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.0
        animation.toValue = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 0.3
        dropShadowView?.layer.add(animation, forKey: "fadeout")
    }
    
    /**
     If you are using UIVisualEffectView or transparent sheet background. You need to cut shadow part which intersects the sheet frame with this.
     */
    private func clearShadowBackground() {
        guard let parent = parent22,
              let availableHeight = availableHeight
        else { return }
        let p = CGMutablePath()
        p.addRect(parent.view.bounds.insetBy(dx: 0, dy: -availableHeight))
        p.addPath(UIBezierPath(roundedRect: getInitialFrame(), cornerRadius: cornerRadius).cgPath)
        let mask = CAShapeLayer()
        mask.path = p
        mask.fillRule = .evenOdd
        dropShadowView?.layer.mask = mask
    }
    
    /**
     Adjust drop shadow corner radius if exists.
     
     - parameter radius: corner radius
     */
    public func setCornerRadius(_ radius: CGFloat) {
        self.cornerRadius = radius
    }
    
    /**
      Set sheet top constraint value to the given new y position.

      - parameter minYPosition: new y position.
      - parameter animated: pass true to animate sheet position change; false otherwise.
      */
     public func setPosition(_ minYPosition: CGFloat, animated: Bool) {
         self.endTranslate(to: minYPosition, animated: animated)
     }

     /**
      Set sheet top constraint value to the nearest sheet positions to given y position.

      - parameter minYPosition: new y position.
      - parameter animated: pass true to animate sheet position change; false otherwise.
      */
     public func setToNearest(_ pos: CGFloat, animated: Bool) {
         guard let dataSource = dataSource22,
               let availableHeight = availableHeight,
               let y = dataSource.sheetPositions(availableHeight).nearest(to: pos)
         else { return }
         setPosition(y, animated: animated)
     }
    
    /**
     Remove child view controller from the container.
     
     - parameter item: view controller which conforms to the Draggable protocol
     - parameter completion: called upon completion of animation
     */
    public func removeSheetChild<T: DraggableItem>(item: T, completion: ((Bool) -> Void)? = nil) {
        stopTracking(item: item)
        guard let _item = (usesNavigationController ? item.navigationController : .some(item)) else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            _item.view.frame = _item.view.frame.offsetBy(dx: 0, dy: _item.view.frame.height)
        }) { (finished) in
            _item.ub_remove()
            completion?(finished)
        }
    }
    
    /**
     Remove sheet from the parent.
     
     - parameter block: use this closure to apply custom sheet dismissal animation
     - parameter completion: called upon completion of animation
     
     */
    public func removeSheet(_ block: ((_ container: UIView?) -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        guard let container = container22 else { return }
        self.draggables.removeAll()
        guard block == nil else {
            block?(container)
            return
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let sSelf = self,
                  let container = sSelf.container22,
                  let parent = sSelf.parent22
            else {
                return
            }
            container.frame = container.frame.offsetBy(dx: 0, dy:  parent.view.frame.height)
        }) { [weak self ] finished in
            self?.container22?.removeFromSuperview()
            self?.removeDropShadow()
            completion?(finished)
        }
    }
    
    
    /**
     Pan gesture recognizer already set up
     
     - parameter item: view controller which conforms to the Draggable protocol
     */
    private func isTracking<T: DraggableItem>(item: T) -> Bool {
        return draggables.contains { (vc) -> Bool in
            vc == item
        }
    }

    /**
     Add pan gesture recognizer to the view controller.
     
     - parameter item: view controller which conforms to the Draggable protocol
     */
    public func startTracking<T: DraggableItem>(item: T) {
        guard !isTracking(item: item) else {
            return
        }
        item.draggableView()?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollPan(_:)))
        let pan = UIPanGestureRecognizer(target: self, action:  #selector(handleViewPan(_:)))
        item.view.addGestureRecognizer(pan)
        let navBarPan = UIPanGestureRecognizer(target: self, action:  #selector(handleViewPan(_:)))
        pan.delegate = self
        navBarPan.delegate = self
        item.navigationController?.navigationBar.addGestureRecognizer(navBarPan)
//        item.draggableView()?.gestureRecognizers?.forEach({ (recognizer) in
//            print("log: ", recognizer.classForCoder, " ", recognizer.isEnabled)
//            let clazz = recognizer.classForCoder.description()
//            if (clazz.contains("_UISwipeDismissalGestureRecognizer")
//                    || !clazz.contains("UIScrollViewPanGestureRecognizer")){
//                pan.require(toFail: recognizer)
//                navBarPan.require(toFail: recognizer)
//            }
//        })
        draggables.append(item)
    }
    
    func stopTracking<T: DraggableItem>(item: T){
        draggables.removeAll { (vc) -> Bool in
            vc == item
        }
    }
    
    /**
     Container view pan gesture event
     - parameter recognizer: view pan gesture  object.
    */
    @objc private func handleViewPan(_ recognizer: UIPanGestureRecognizer) {
        handlePan(recognizer)
    }

    /**
     Scrollable view pan gesture event
     - parameter recognizer: scroll view pan gesture object.
    */
    @objc private func handleScrollPan(_ recognizer: UIPanGestureRecognizer) {
        guard let scrollView = recognizer.view as? UIScrollView else {
            return
        }
        handlePan(recognizer, scrollView: scrollView)
    }
    
    /// Holds last scroll view content offset to stop scrolling while driving the view
    private var lastContentOffset: CGPoint = .zero
    /// As recognizer.setTranslation(.zero, ...) breaks scrollView functionality when driving with scroll view last y translation is used to find the change in y position (dy).
    private var lastY: CGFloat = 0
    
    /**
     Common handler for view and scroll view pan gesture event. drives the sheet according to the container view or scroll view gesture events.
     
     - parameter recognizer: Pan gesture recognizer object.
     - parameter scrollView: set if scrollView gesture event
    */
    private func handlePan(_ recognizer: UIPanGestureRecognizer, scrollView: UIScrollView? = nil) {
        let dy = recognizer.translation(in: recognizer.view).y
        let vel = recognizer.velocity(in: recognizer.view)

        switch recognizer.state {
        case .began:
            lastY = 0
            if let scroll = scrollView {
                //set last contentOffset y value by adding 'dy' i.e. pre pan gesture happened.
                lastContentOffset.y = scroll.contentOffset.y + dy
            }
            guard let minSheetPosition = minSheetPosition22,
                  let maxSheetPosition = maxSheetPosition22
            else { return }
            totalTranslationMinY22 = minSheetPosition
            totalTranslationMaxY22 = maxSheetPosition
            translate(with: vel, dy: dy, scrollView: scrollView)
        case .changed:
            translate(with: vel, dy: dy, scrollView: scrollView)
        case .ended,
             .cancelled,
             .failed:
            guard let container = container22 else { return }
            guard let scroll = scrollView else {
                self.finishDragging(with: vel, position: container.frame.minY + dy - lastY)
                return
            }
            let minY = container.frame.minY
            guard let minSheetPosition = minSheetPosition22 else { return }
            switch dragDirection(vel) {
            case .up where minY - minSheetPosition > tolerance:
                scroll.setContentOffset(lastContentOffset, animated: false)
                self.finishDragging(with: vel, position: minY)
            default:
                if !isSheetPosition(minY) {
                    self.finishDragging(with: vel, position: minY)
                }
            }
        default: break
        }
        
    }

    /**
     Move view according to the pan gestur recognizer parameters
     
     - parameter velocity: draging velocity of scroll view recognizer
     - parameter dy: change in the y direction of pan gesture realtive to the gesture began position
     - parameter scrollView: set if scrollView gesture event
     */
    func translate(with velocity: CGPoint, dy: CGFloat, scrollView: UIScrollView? = nil) {
        guard let container = container22,
              let minSheetPosition = minSheetPosition22
        else { return }
        if let scroll = scrollView {
            switch dragDirection(velocity) {
            case .up where (container.frame.minY - minSheetPosition > tolerance):
                applyTranslation(dy: dy - lastY)
                scroll.contentOffset.y = lastContentOffset.y
            case .down where scroll.contentOffset.y <= 0 /*&& !scroll.isDecelerating*/:
                applyTranslation(dy: dy - lastY)
                scroll.contentOffset.y = 0
                lastContentOffset = .zero
            default:
                break
            }
        } else {
            applyTranslation(dy: dy - lastY)
        }
        lastY = dy
    }
    
    
    /**
     Check if current top y position is one of the UBottomSheetCoordinatorDataSource#sheetPositions(availableHeight)
     
     - parameter point: current top y position
     */
    private func isSheetPosition(_ point: CGFloat) -> Bool {
        guard let dataSource = dataSource22,
              let availableHeight = availableHeight
        else { return false }
        return dataSource.sheetPositions(availableHeight).first(where: { (p) -> Bool in
            abs(p - point) < tolerance
        }) != nil
    }
    
    /// Scroll view pan direction state: up, down or idle
    private enum DraggingState {
        case up, down, idle
    }
    
    /**
     Find the scroll pan direction; dragging up or down.
     
     - parameter velocity: draging velocity of scroll view recognizer
     */
    private func dragDirection(_ velocity: CGPoint) -> DraggingState {
        if velocity.y < 0 {
            return .up
        } else if velocity.y > 0 {
            return .down
        } else {
            return .idle
        }
    }
    
    /**
     It helps when finishing dragging to the nearest sheet position in the direction of movement.
     
     i.e. for the given sheet positions ```[0.1, 0.5, 0.8].map{$0*availableHeight}``` if recognizer finishes while dragging up at  ```0.45*availableHeight``` the positions lower than 0.45 wiill be filtered and sheet will move to the ```0.1*availableHeight```.
     
     - parameter velocity: draging velocity of recognizer
     - parameter currentPosition: current top constraint value of container view
     */
    private func filteredPositions(_ velocity: CGPoint, currentPosition: CGFloat) -> [CGFloat] {
        guard let dataSource = dataSource22,
              let availableHeight = availableHeight
        else { return [] }
        if velocity.y < -100 { /// dragging up
            let data = dataSource.sheetPositions(availableHeight).filter { (p) -> Bool in
                p < currentPosition
            }
            
            if data.isEmpty {
                return dataSource.sheetPositions(availableHeight)
            } else {
                return data
            }
        } else if velocity.y > 100 { /// dragging down
            let data = dataSource.sheetPositions(availableHeight).filter { (p) -> Bool in
                p > currentPosition
            }
            if data.isEmpty {
                return dataSource.sheetPositions(availableHeight)
            } else {
                return data
            }
        } else {
            return dataSource.sheetPositions(availableHeight)
        }
    }
    
    /// y translation value for top rubber banding calculation
    private var totalTranslationMinY22: CGFloat?
    ///  y translation value for bottom rubber banding calculation
    private var totalTranslationMaxY22: CGFloat?
    
    /**
     Drives container view according the given value
     
     - parameter dy: change in the y direction of pan gesture
     */
    private func applyTranslation(dy: CGFloat) {
        guard let dataSource = dataSource22,
              let container = container22,
              let availableHeight = availableHeight
        else { return }
        guard dy != 0 else {
            return
        }

        guard let topLimit = minSheetPosition22,
              let bottomLimit = maxSheetPosition22
        else { return }
        
        let oldFrame = container.frame
        var newY = oldFrame.minY
        
        if hasExceededTopLimit(oldFrame.minY + dy, topLimit) {
            let yy = min(0 , topLimit - oldFrame.minY)
            totalTranslationMinY22 = totalTranslationMinY22.map{ $0 - (dy - yy) }
            guard let maxSheetPosition = maxSheetPosition22 else { return }
            totalTranslationMaxY22 = maxSheetPosition
            guard let totalTranslationMinY = totalTranslationMinY22 else { return }
            newY = dataSource.rubberBandLogicTop(totalTranslationMinY, topLimit)
        } else if hasExceededBottomLimit(oldFrame.minY + dy, bottomLimit) {
            let yy = max(0 , bottomLimit - oldFrame.minY)
            guard let minSheetPosition = minSheetPosition22 else { return }
            totalTranslationMinY22 = minSheetPosition
            totalTranslationMaxY22 = totalTranslationMaxY22.map{ $0 + (dy - yy) }
            guard let totalTranslationMaxY = totalTranslationMaxY22 else { return }
            newY = dataSource.rubberBandLogicBottom(totalTranslationMaxY, bottomLimit)
        } else {
            guard let minSheetPosition = minSheetPosition22,
                  let maxSheetPosition = maxSheetPosition22
            else { return }
            totalTranslationMinY22 = minSheetPosition
            totalTranslationMaxY22 = maxSheetPosition
            newY += dy
        }
        guard let minSheetPosition = minSheetPosition22 else { return }
        let height = max(availableHeight - minSheetPosition, availableHeight - newY)
        let frame = CGRect(x: 0, y: newY, width: oldFrame.width, height: height)
        container.frame = frame
        guard let percent = calculatePercent(at: frame.minY) else { return }
        self.delegate?.bottomSheet(container, didChange: .progressing(frame.minY, percent))
    }
    
    /**
     Pan gesture finish event
     
     - parameter velocity: Pan gesture velocity
     - parameter position: new top constraint value
     */
    private func finishDragging(with velocity: CGPoint, position: CGFloat) {
        guard let y = filteredPositions(velocity, currentPosition: position).nearest(to: position) else { return }
        endTranslate(to: y, animated: true)
    }
    
    //to ignore previous animation completion events
    private var lastAnimatedValue: CGFloat = 0.0
    
    /**
     Drives the view to the given position with animation option
     
     - parameter position: new top constraint value
     - parameter animated: Pass true to animate the y position change; otherwise pass false.
     */
    private func endTranslate(to position: CGFloat, animated: Bool = false) {
        guard position != 0,
              let container = container22,
              let minSheetPosition = minSheetPosition22,
              let availableHeight = availableHeight
        else { return }
        let oldFrame = container.frame
        let height = max(availableHeight - minSheetPosition, availableHeight - position)
        let frame = CGRect(x: 0, y: position, width: oldFrame.width, height: height)

        guard let container = self.container22,
              let percentage = self.calculatePercent(at: position)
        else { return }
        self.delegate?.bottomSheet(container, didChange: .willFinish(position, percentage))

        if animated {
            self.lastAnimatedValue = position
            dataSource22?.animator?.animate(animations: {
                self.delegate?.bottomSheet(self.container22, finishTranslateWith: { (anim) in
                    guard let percent = self.calculatePercent(at: position) else { return }
                    anim(percent)
                })
                container.frame = frame
                self.parent22?.view.layoutIfNeeded()
            }, completion: { finished in
                if self.lastAnimatedValue != position {
                    return
                }
                guard let percent = self.calculatePercent(at: position)
                else { return }
                self.delegate?.bottomSheet(container, didChange: .finished(position, percent))
                if position >= availableHeight {
                    self.removeSheet()
                }
            })
        } else {
            container.frame = frame
            guard let percentage = self.calculatePercent(at: position) else { return }
            self.delegate?.bottomSheet(container, didChange: .finished(position, percentage))
        }
    }
    
    //MARK: Utility functions
    
    /**
     Sheet translation in precent.
     
     Lowest top sheet y position is 100. Highest bottom sheet y position is 0 percent.
     
     - parameter pos: current top constraint value
     */
    private func calculatePercent(at pos: CGFloat) -> CGFloat? {
        guard let minSheetPosition = minSheetPosition22,
              let availableHeight = availableHeight
        else { return nil }
        return (availableHeight - pos) / (availableHeight - minSheetPosition) * 100
    }

    /**
     Top sheet position limit has exceeded while dragging
     
     - parameter constant: current top constraint value
     - parameter limit: min sheet y position
     */
    private func hasExceededTopLimit(_ constant: CGFloat, _ limit: CGFloat) -> Bool {
        return (constant - limit) < tolerance
    }
    
    /**
     Bottom sheet position limit has exceeded while dragging
     
     - parameter constant: current top constraint value
     - parameter limit: max sheet y position
     */
    private func hasExceededBottomLimit(_ constant: CGFloat, _ limit: CGFloat) -> Bool {
        return (constant - limit) > tolerance
    }
    
}

// MARK: UIGestureRecognizerDelegate

extension UBottomSheetCoordinator: UIGestureRecognizerDelegate{
    
    /// Ignore back view pan gesture recognizers if there is a scrollview and alwaysBounceVertical is set to true.
    /// See https://github.com/OfTheWolf/UBottomSheet/issues/50
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView{
            return scrollView.alwaysBounceVertical
        }else{
            return true
        }
    }
}
