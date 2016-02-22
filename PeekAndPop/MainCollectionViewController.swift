//
//  MainCollectionViewController.swift
//  PeekAndPop
//
//  Created by Alice Aponasko on 2/21/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import UIKit
import PeekView

private let ShowDetailSegueID = "showDetail"

class MainCollectionViewController: UICollectionViewController {
    
    let photosArray = [
        UIImage(named: "1"), UIImage(named: "2"), UIImage(named: "3"),
        UIImage(named: "4"), UIImage(named: "5"), UIImage(named: "6"),
        UIImage(named: "7"), UIImage(named: "8"), UIImage(named: "9"),
        UIImage(named: "10"), UIImage(named: "11"), UIImage(named: "12"),
        UIImage(named: "13"), UIImage(named: "14"), UIImage(named: "15") ]
    
    var shouldForceTouch = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        } else {
            shouldForceTouch = false
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ShowDetailSegueID && sender is UICollectionViewCell {
            guard let controller = segue.destinationViewController as? DetailViewController else {
                return
            }
            
            if let indexPath = collectionView?.indexPathForCell(sender as! UICollectionViewCell) {
                controller.photoImage = photosArray[indexPath.item]
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MainPhotoCellID, forIndexPath: indexPath) as! MainPhotoCell
    
        cell.photoImageView.image = photosArray[indexPath.item]
        
        if !shouldForceTouch {
            let longGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: "longTouchCell:")
            cell.addGestureRecognizer(longGestureRecognizer)
        }
    
        return cell
    }
    
    func longTouchCell(gestureRecognizer: UILongPressGestureRecognizer) {
        if let cell = gestureRecognizer.view as? MainPhotoCell, indexPath = collectionView?.indexPathForCell(cell) {
            let controller = storyboard?.instantiateViewControllerWithIdentifier(PeekDetailViewControllerID) as! DetailViewController
            controller.photoImage = photosArray[indexPath.item]
            
            let frame = CGRectMake(20, 40, CGRectGetWidth(view.frame) - 40, CGRectGetHeight(view.frame) - 80)
            PeekView.viewForController(
                parentViewController: self,
                contentViewController: controller,
                expectedContentViewFrame: frame,
                fromGesture: gestureRecognizer,
                shouldHideStatusBar: true,
                withOptions: ["Open": .Default, "Close": .Destructive],
                completionHandler: { optionIndex in
                    switch optionIndex {
                    case 1:
                        self.performSegueWithIdentifier(ShowDetailSegueID, sender: cell)
                    default:
                        break
                    }
            })
        }
    }

}

// MARK: - UIViewControllerPreviewingDelegate

extension MainCollectionViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = collectionView?.indexPathForItemAtPoint(location), cellAttributes = collectionView?.layoutAttributesForItemAtIndexPath(indexPath) {
            previewingContext.sourceRect = cellAttributes.frame
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier(PeekDetailViewControllerID) as! DetailViewController
            controller.photoImage = photosArray[indexPath.item]
            return controller
        }
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        presentViewController(viewControllerToCommit, animated: true, completion: nil)
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(view.frame) / 2, CGRectGetWidth(view.frame) / 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
