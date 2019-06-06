//
//  Stem
//
//  Copyright (c) 2017 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE


import UIKit

public extension Stem where Base: CALayer {

    var set: StemSetChain<Base> { return StemSetChain(base) }

}

public extension StemSetChain where Base: CALayer {

    /* The bounds of the layer. Defaults to CGRectZero. Animatable. */

    /** Geometry and layer hierarchy properties. **/
    @discardableResult
    func bounds(_ value: CGRect) -> StemSetChain<Base> {
        base.bounds = value
        return StemSetChain(base)
    }


    /* The position in the superlayer that the anchor point of the layer's
     * bounds rect is aligned to. Defaults to the zero point. Animatable. */

    @discardableResult
    func position(_ value: CGPoint) -> StemSetChain<Base> {
        base.position = value
        return StemSetChain(base)
    }


    /* The Z component of the layer's position in its superlayer. Defaults
     * to zero. Animatable. */

    @discardableResult
    func zPosition(_ value: CGFloat) -> StemSetChain<Base> {
        base.zPosition = value
        return StemSetChain(base)
    }


    /* Defines the anchor point of the layer's bounds rect, as a point in
     * normalized layer coordinates - '(0, 0)' is the bottom left corner of
     * the bounds rect, '(1, 1)' is the top right corner. Defaults to
     * '(0.5, 0.5)', i.e. the center of the bounds rect. Animatable. */

    @discardableResult
    func anchorPoint(_ value: CGPoint) -> StemSetChain<Base> {
        base.anchorPoint = value
        return StemSetChain(base)
    }


    /* The Z component of the layer's anchor point (i.e. reference point for
     * position and transform). Defaults to zero. Animatable. */

    @discardableResult
    func anchorPointZ(_ value: CGFloat) -> StemSetChain<Base> {
        base.anchorPointZ = value
        return StemSetChain(base)
    }


    /* A transform applied to the layer relative to the anchor point of its
     * bounds rect. Defaults to the identity transform. Animatable. */

    @discardableResult
    func transform(_ value: CATransform3D) -> StemSetChain<Base> {
        base.transform = value
        return StemSetChain(base)
    }


    /* Convenience methods for accessing the `transform' property as an
     * affine transform. */

    // open func affineTransform() -> CGAffineTransform

    func setAffineTransform(_ value: CGAffineTransform) -> StemSetChain<Base> {
        base.setAffineTransform(value)
        return StemSetChain(base)
    }

    /* Unlike NSView, each Layer in the hierarchy has an implicit frame
     * rectangle, a function of the `position', `bounds', `anchorPoint',
     * and `transform' properties. When setting the frame the `position'
     * and `bounds.size' are changed to match the given frame. */

    @discardableResult
    func frame(_ value: CGRect) -> StemSetChain<Base> {
        base.frame = value
        return StemSetChain(base)
    }


    /* When true the layer and its sublayers are not displayed. Defaults to
     * NO. Animatable. */

    @discardableResult
    func isHidden(_ value: Bool) -> StemSetChain<Base> {
        base.isHidden = value
        return StemSetChain(base)
    }


    /* When false layers facing away from the viewer are hidden from view.
     * Defaults to YES. Animatable. */

    @discardableResult
    func isDoubleSided(_ value: Bool) -> StemSetChain<Base> {
        base.isDoubleSided = value
        return StemSetChain(base)
    }


    /* Whether or not the geometry of the layer (and its sublayers) is
     * flipped vertically. Defaults to NO. Note that even when geometry is
     * flipped, image orientation remains the same (i.e. a CGImageRef
     * stored in the `contents' property will display the same with both
     * flipped=NO and flipped=YES, assuming no transform on the layer). */

    @discardableResult
    func isGeometryFlipped(_ value: Bool) -> StemSetChain<Base> {
        base.isGeometryFlipped = value
        return StemSetChain(base)
    }


    /* Returns true if the contents of the contents property of the layer
     * will be implicitly flipped when rendered in relation to the local
     * coordinate space (e.g. if there are an odd number of layers with
     * flippedGeometry=YES from the receiver up to and including the
     * implicit container of the root layer). Subclasses should not attempt
     * to redefine this method. When this method returns true the
     * CGContextRef object passed to -drawInContext: by the default
     * -display method will have been y- flipped (and rectangles passed to
     * -setNeedsDisplayInRect: will be similarly flipped). */

    // open func contentsAreFlipped() -> Bool


    /* The receiver's superlayer object. Implicitly changed to match the
     * hierarchy described by the `sublayers' properties. */

    // open var superlayer: CALayer? { get }


    /* Removes the layer from its superlayer, works both if the receiver is
     * in its superlayer's `sublayers' array or set as its `mask' value. */

    func removeFromSuperlayer() -> StemSetChain<Base> {
        base.removeFromSuperlayer()
        return StemSetChain(base)
    }


    /* The array of sublayers of this layer. The layers are listed in back
     * to front order. Defaults to nil. When setting the value of the
     * property, any newly added layers must have nil superlayers, otherwise
     * the behavior is undefined. Note that the returned array is not
     * guaranteed to retain its elements. */

    @discardableResult
    func sublayers(_ value: [CALayer]?) -> StemSetChain<Base> {
        base.sublayers = value
        return StemSetChain(base)
    }


    /* Add 'layer' to the end of the receiver's sublayers array. If 'layer'
     * already has a superlayer, it will be removed before being added. */

    func addSublayer(_ layer: CALayer) -> StemSetChain<Base> {
        base.addSublayer(layer)
        return StemSetChain(base)
    }


    /* Insert 'layer' at position 'idx' in the receiver's sublayers array.
     * If 'layer' already has a superlayer, it will be removed before being
     * inserted. */

    func insertSublayer(_ layer: CALayer, at idx: UInt32) -> StemSetChain<Base> {
        base.insertSublayer(layer, at: idx)
        return StemSetChain(base)
    }


    /* Insert 'layer' either above or below the specified layer in the
     * receiver's sublayers array. If 'layer' already has a superlayer, it
     * will be removed before being inserted. */

    func insertSublayer(_ layer: CALayer, below sibling: CALayer?) -> StemSetChain<Base> {
        base.insertSublayer(layer, below: sibling)
        return StemSetChain(base)
    }

    func insertSublayer(_ layer: CALayer, above sibling: CALayer?) -> StemSetChain<Base> {
        base.insertSublayer(layer, above: sibling)
        return StemSetChain(base)
    }


    /* Remove 'oldLayer' from the sublayers array of the receiver and insert
     * 'newLayer' if non-nil in its position. If the superlayer of 'oldLayer'
     * is not the receiver, the behavior is undefined. */

    func replaceSublayer(_ oldLayer: CALayer, with newLayer: CALayer) -> StemSetChain<Base> {
        base.replaceSublayer(oldLayer, with: newLayer)
        return StemSetChain(base)
    }


    /* A transform applied to each member of the `sublayers' array while
     * rendering its contents into the receiver's output. Typically used as
     * the projection matrix to add perspective and other viewing effects
     * into the model. Defaults to identity. Animatable. */

    @discardableResult
    func sublayerTransform(_ value: CATransform3D) -> StemSetChain<Base> {
        base.sublayerTransform = value
        return StemSetChain(base)
    }


    /* A layer whose alpha channel is used as a mask to select between the
     * layer's background and the result of compositing the layer's
     * contents with its filtered background. Defaults to nil. When used as
     * a mask the layer's `compositingFilter' and `backgroundFilters'
     * properties are ignored. When setting the mask to a new layer, the
     * new layer must have a nil superlayer, otherwise the behavior is
     * undefined. Nested masks (mask layers with their own masks) are
     * unsupported. */

    @discardableResult
    func mask(_ value: CALayer?) -> StemSetChain<Base> {
        base.mask = value
        return StemSetChain(base)
    }


    /* When true an implicit mask matching the layer bounds is applied to
     * the layer (including the effects of the `cornerRadius' property). If
     * both `mask' and `masksToBounds' are non-nil the two masks are
     * multiplied to get the actual mask values. Defaults to NO.
     * Animatable. */

    @discardableResult
    func masksToBounds(_ value: Bool) -> StemSetChain<Base> {
        base.masksToBounds = value
        return StemSetChain(base)
    }



    /** Mapping between layer coordinate and time spaces. **/
    //    open func convert(_ p: CGPoint, from l: CALayer?) -> CGPoint
    //
    //    open func convert(_ p: CGPoint, to l: CALayer?) -> CGPoint
    //
    //    open func convert(_ r: CGRect, from l: CALayer?) -> CGRect
    //
    //    open func convert(_ r: CGRect, to l: CALayer?) -> CGRect
    //
    //
    //    open func convertTime(_ t: CFTimeInterval, from l: CALayer?) -> CFTimeInterval
    //
    //    open func convertTime(_ t: CFTimeInterval, to l: CALayer?) -> CFTimeInterval



    /* Returns the farthest descendant of the layer containing point 'p'.
     * Siblings are searched in top-to-bottom order. 'p' is defined to be
     * in the coordinate space of the receiver's nearest ancestor that
     * isn't a CATransformLayer (transform layers don't have a 2D
     * coordinate space in which the point could be specified). */

    /** Hit testing methods. **/
    func hitTest(_ p: CGPoint) -> StemSetChain<Base>? {
        guard let layer: Base = base.hitTest(p) as? Base else { return nil }
        return StemSetChain(layer)
    }


    /* Returns true if the bounds of the layer contains point 'p'. */

    // open func contains(_ p: CGPoint) -> Bool

    /* An object providing the contents of the layer, typically a CGImageRef,
     * but may be something else. (For example, NSImage objects are
     * supported on Mac OS X 10.6 and later.) Default value is nil.
     * Animatable. */

    /** Layer content properties and methods. **/
    @discardableResult
    func contents(_ value: Any?) -> StemSetChain<Base> {
        base.contents = value
        return StemSetChain(base)
    }


    /* A rectangle in normalized image coordinates defining the
     * subrectangle of the `contents' property that will be drawn into the
     * layer. If pixels outside the unit rectangles are requested, the edge
     * pixels of the contents image will be extended outwards. If an empty
     * rectangle is provided, the results are undefined. Defaults to the
     * unit rectangle [0 0 1 1]. Animatable. */

    @discardableResult
    func contentsRect(_ value: CGRect) -> StemSetChain<Base> {
        base.contentsRect = value
        return StemSetChain(base)
    }


    /* A string defining how the contents of the layer is mapped into its
     * bounds rect. Options are `center', `top', `bottom', `left',
     * `right', `topLeft', `topRight', `bottomLeft', `bottomRight',
     * `resize', `resizeAspect', `resizeAspectFill'. The default value is
     * `resize'. Note that "bottom" always means "Minimum Y" and "top"
     * always means "Maximum Y". */

    @discardableResult
    func contentsGravity(_ value: CALayerContentsGravity) -> StemSetChain<Base> {
        base.contentsGravity = value
        return StemSetChain(base)
    }


    /* Defines the scale factor applied to the contents of the layer. If
     * the physical size of the contents is '(w, h)' then the logical size
     * (i.e. for contentsGravity calculations) is defined as '(w /
     * contentsScale, h / contentsScale)'. Applies to both images provided
     * explicitly and content provided via -drawInContext: (i.e. if
     * contentsScale is two -drawInContext: will draw into a buffer twice
     * as large as the layer bounds). Defaults to one. Animatable. */

    @available(iOS 4.0, *)
    @discardableResult
    func contentsScale(_ value: CGFloat) -> StemSetChain<Base> {
        base.contentsScale = value
        return StemSetChain(base)
    }


    /* A rectangle in normalized image coordinates defining the scaled
     * center part of the `contents' image.
     *
     * When an image is resized due to its `contentsGravity' property its
     * center part implicitly defines the 3x3 grid that controls how the
     * image is scaled to its drawn size. The center part is stretched in
     * both dimensions; the top and bottom parts are only stretched
     * horizontally; the left and right parts are only stretched
     * vertically; the four corner parts are not stretched at all. (This is
     * often called "9-slice scaling".)
     *
     * The rectangle is interpreted after the effects of the `contentsRect'
     * property have been applied. It defaults to the unit rectangle [0 0 1
     * 1] meaning that the entire image is scaled. As a special case, if
     * the width or height is zero, it is implicitly adjusted to the width
     * or height of a single source pixel centered at that position. If the
     * rectangle extends outside the [0 0 1 1] unit rectangle the result is
     * undefined. Animatable. */

    @discardableResult
    func contentsCenter(_ value: CGRect) -> StemSetChain<Base> {
        base.contentsCenter = value
        return StemSetChain(base)
    }


    /* A hint for the desired storage format of the layer contents provided by
     * -drawLayerInContext. Defaults to kCAContentsFormatRGBA8Uint. Note that this
     * does not affect the interpretation of the `contents' property directly. */

    @available(iOS 10.0, *)
    @discardableResult
    func contentsFormat(_ value: CALayerContentsFormat) -> StemSetChain<Base> {
        base.contentsFormat = value
        return StemSetChain(base)
    }


    /* The filter types to use when rendering the `contents' property of
     * the layer. The minification filter is used when to reduce the size
     * of image data, the magnification filter to increase the size of
     * image data. Currently the allowed values are `nearest' and `linear'.
     * Both properties default to `linear'. */

    @discardableResult
    func minificationFilter(_ value: CALayerContentsFilter) -> StemSetChain<Base> {
        base.minificationFilter = value
        return StemSetChain(base)
    }

    @discardableResult
    func magnificationFilter(_ value: CALayerContentsFilter) -> StemSetChain<Base> {
        base.magnificationFilter = value
        return StemSetChain(base)
    }


    /* The bias factor added when determining which levels of detail to use
     * when minifying using trilinear filtering. The default value is 0.
     * Animatable. */

    @discardableResult
    func minificationFilterBias(_ value: Float) -> StemSetChain<Base> {
        base.minificationFilterBias = value
        return StemSetChain(base)
    }


    /* A hint marking that the layer contents provided by -drawInContext:
     * is completely opaque. Defaults to NO. Note that this does not affect
     * the interpretation of the `contents' property directly. */

    @discardableResult
    func isOpaque(_ value: Bool) -> StemSetChain<Base> {
        base.isOpaque = value
        return StemSetChain(base)
    }


    /* Reload the content of this layer. Calls the -drawInContext: method
     * then updates the `contents' property of the layer. Typically this is
     * not called directly. */

    func display() -> StemSetChain<Base> {
        base.display()
        return StemSetChain(base)
    }


    /* Marks that -display needs to be called before the layer is next
     * committed. If a region is specified, only that region of the layer
     * is invalidated. */

    func setNeedsDisplay() -> StemSetChain<Base> {
        base.setNeedsDisplay()
        return StemSetChain(base)
    }

    func setNeedsDisplay(_ r: CGRect) -> StemSetChain<Base> {
        base.setNeedsDisplay(r)
        return StemSetChain(base)
    }


    /* Returns true when the layer is marked as needing redrawing. */

    // open func needsDisplay() -> Bool


    /* Call -display if receiver is marked as needing redrawing. */

    func displayIfNeeded() -> StemSetChain<Base> {
        base.displayIfNeeded()
        return StemSetChain(base)
    }


    /* When true -setNeedsDisplay will automatically be called when the
     * bounds of the layer changes. Default value is NO. */

    @discardableResult
    func needsDisplayOnBoundsChange(_ value: Bool) -> StemSetChain<Base> {
        base.needsDisplayOnBoundsChange = value
        return StemSetChain(base)
    }


    /* When true, the CGContext object passed to the -drawInContext: method
     * may queue the drawing commands submitted to it, such that they will
     * be executed later (i.e. asynchronously to the execution of the
     * -drawInContext: method). This may allow the layer to complete its
     * drawing operations sooner than when executing synchronously. The
     * default value is NO. */

    @available(iOS 6.0, *)
    @discardableResult
    func drawsAsynchronously(_ value: Bool) -> StemSetChain<Base> {
        base.drawsAsynchronously = value
        return StemSetChain(base)
    }


    /* Called via the -display method when the `contents' property is being
     * updated. Default implementation does nothing. The context may be
     * clipped to protect valid layer content. Subclasses that wish to find
     * the actual region to draw can call CGContextGetClipBoundingBox(). */

    func draw(in ctx: CGContext) -> StemSetChain<Base> {
        base.draw(in: ctx)
        return StemSetChain(base)
    }



    /* Renders the receiver and its sublayers into 'ctx'. This method
     * renders directly from the layer tree. Renders in the coordinate space
     * of the layer.
     *
     * WARNING: currently this method does not implement the full
     * CoreAnimation composition model, use with caution. */

    /** Rendering properties and methods. **/
    func render(in ctx: CGContext) -> StemSetChain<Base> {
        base.render(in: ctx)
        return StemSetChain(base)
    }


    /* Defines how the edges of the layer are rasterized. For each of the
     * four edges (left, right, bottom, top) if the corresponding bit is
     * set the edge will be antialiased. Typically this property is used to
     * disable antialiasing for edges that abut edges of other layers, to
     * eliminate the seams that would otherwise occur. The default value is
     * for all edges to be antialiased. */

    @discardableResult
    func edgeAntialiasingMask(_ value: CAEdgeAntialiasingMask) -> StemSetChain<Base> {
        base.edgeAntialiasingMask = value
        return StemSetChain(base)
    }


    /* When true this layer is allowed to antialias its edges, as requested
     * by the value of the edgeAntialiasingMask property.
     *
     * The default value is read from the boolean UIViewEdgeAntialiasing
     * property in the main bundle's Info.plist. If no value is found in
     * the Info.plist the default value is NO. */

    @available(iOS 2.0, *)
    @discardableResult
    func allowsEdgeAntialiasing(_ value: Bool) -> StemSetChain<Base> {
        base.allowsEdgeAntialiasing = value
        return StemSetChain(base)
    }


    /* The background color of the layer. Default value is nil. Colors
     * created from tiled patterns are supported. Animatable. */

    @discardableResult
    func backgroundColor(_ value: CGColor?) -> StemSetChain<Base> {
        base.backgroundColor = value
        return StemSetChain(base)
    }


    /* When positive, the background of the layer will be drawn with
     * rounded corners. Also effects the mask generated by the
     * `masksToBounds' property. Defaults to zero. Animatable. */

    @discardableResult
    func cornerRadius(_ value: CGFloat) -> StemSetChain<Base> {
        base.cornerRadius = value
        return StemSetChain(base)
    }


    /* Defines which of the four corners receives the masking when using
     * `cornerRadius' property. Defaults to all four corners. */

    @available(iOS 11.0, *)
    @discardableResult
    func maskedCorners(_ value: CACornerMask) -> StemSetChain<Base> {
        base.maskedCorners = value
        return StemSetChain(base)
    }


    /* The width of the layer's border, inset from the layer bounds. The
     * border is composited above the layer's content and sublayers and
     * includes the effects of the `cornerRadius' property. Defaults to
     * zero. Animatable. */

    @discardableResult
    func borderWidth(_ value: CGFloat) -> StemSetChain<Base> {
        base.borderWidth = value
        return StemSetChain(base)
    }


    /* The color of the layer's border. Defaults to opaque black. Colors
     * created from tiled patterns are supported. Animatable. */

    @discardableResult
    func borderColor(_ value: CGColor?) -> StemSetChain<Base> {
        base.borderColor = value
        return StemSetChain(base)
    }


    /* The opacity of the layer, as a value between zero and one. Defaults
     * to one. Specifying a value outside the [0,1] range will give undefined
     * results. Animatable. */

    @discardableResult
    func opacity(_ value: Float) -> StemSetChain<Base> {
        base.opacity = value
        return StemSetChain(base)
    }


    /* When true, and the layer's opacity property is less than one, the
     * layer is allowed to composite itself as a group separate from its
     * parent. This gives the correct results when the layer contains
     * multiple opaque components, but may reduce performance.
     *
     * The default value of the property is read from the boolean
     * UIViewGroupOpacity property in the main bundle's Info.plist. If no
     * value is found in the Info.plist the default value is YES for
     * applications linked against the iOS 7 SDK or later and NO for
     * applications linked against an earlier SDK. */

    @available(iOS 2.0, *)
    @discardableResult
    func allowsGroupOpacity(_ value: Bool) -> StemSetChain<Base> {
        base.allowsGroupOpacity = value
        return StemSetChain(base)
    }


    /* A filter object used to composite the layer with its (possibly
     * filtered) background. Default value is nil, which implies source-
     * over compositing. Animatable.
     *
     * Note that if the inputs of the filter are modified directly after
     * the filter is attached to a layer, the behavior is undefined. The
     * filter must either be reattached to the layer, or filter properties
     * should be modified by calling -setValue:forKeyPath: on each layer
     * that the filter is attached to. (This also applies to the `filters'
     * and `backgroundFilters' properties.) */

    @discardableResult
    func compositingFilter(_ value: Any?) -> StemSetChain<Base> {
        base.compositingFilter = value
        return StemSetChain(base)
    }


    /* An array of filters that will be applied to the contents of the
     * layer and its sublayers. Defaults to nil. Animatable. */

    @discardableResult
    func filters(_ value: [Any]?) -> StemSetChain<Base> {
        base.filters = value
        return StemSetChain(base)
    }


    /* An array of filters that are applied to the background of the layer.
     * The root layer ignores this property. Animatable. */

    @discardableResult
    func backgroundFilters(_ value: [Any]?) -> StemSetChain<Base> {
        base.backgroundFilters = value
        return StemSetChain(base)
    }


    /* When true, the layer is rendered as a bitmap in its local coordinate
     * space ("rasterized"), then the bitmap is composited into the
     * destination (with the minificationFilter and magnificationFilter
     * properties of the layer applied if the bitmap needs scaling).
     * Rasterization occurs after the layer's filters and shadow effects
     * are applied, but before the opacity modulation. As an implementation
     * detail the rendering engine may attempt to cache and reuse the
     * bitmap from one frame to the next. (Whether it does or not will have
     * no affect on the rendered output.)
     *
     * When false the layer is composited directly into the destination
     * whenever possible (however, certain features of the compositing
     * model may force rasterization, e.g. adding filters).
     *
     * Defaults to NO. Animatable. */

    @discardableResult
    func shouldRasterize(_ value: Bool) -> StemSetChain<Base> {
        base.shouldRasterize = value
        return StemSetChain(base)
    }


    /* The scale at which the layer will be rasterized (when the
     * shouldRasterize property has been set to YES) relative to the
     * coordinate space of the layer. Defaults to one. Animatable. */

    @discardableResult
    func rasterizationScale(_ value: CGFloat) -> StemSetChain<Base> {
        base.rasterizationScale = value
        return StemSetChain(base)
    }



    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */

    /** Shadow properties. **/
    @discardableResult
    func shadowColor(_ value: CGColor?) -> StemSetChain<Base> {
        base.shadowColor = value
        return StemSetChain(base)
    }


    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */

    @discardableResult
    func shadowOpacity(_ value: Float) -> StemSetChain<Base> {
        base.shadowOpacity = value
        return StemSetChain(base)
    }


    /* The shadow offset. Defaults to (0, -3). Animatable. */

    @discardableResult
    func shadowOffset(_ value: CGSize) -> StemSetChain<Base> {
        base.shadowOffset = value
        return StemSetChain(base)
    }


    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */

    @discardableResult
    func shadowRadius(_ value: CGFloat) -> StemSetChain<Base> {
        base.shadowRadius = value
        return StemSetChain(base)
    }


    /* When non-null this path defines the outline used to construct the
     * layer's shadow instead of using the layer's composited alpha
     * channel. The path is rendered using the non-zero winding rule.
     * Specifying the path explicitly using this property will usually
     * improve rendering performance, as will sharing the same path
     * reference across multiple layers. Upon assignment the path is copied.
     * Defaults to null. Animatable. */

    @discardableResult
    func shadowPath(_ value: CGPath?) -> StemSetChain<Base> {
        base.shadowPath = value
        return StemSetChain(base)
    }



    /* Returns the preferred frame size of the layer in the coordinate
     * space of the superlayer. The default implementation calls the layout
     * manager if one exists and it implements the -preferredSizeOfLayer:
     * method, otherwise returns the size of the bounds rect mapped into
     * the superlayer. */

    /** Layout methods. **/
    // open func preferredFrameSize() -> CGSize


    /* Marks that -layoutSublayers needs to be invoked on the receiver
     * before the next update. If the receiver's layout manager implements
     * the -invalidateLayoutOfLayer: method it will be called.
     *
     * This method is automatically invoked on a layer whenever its
     * `sublayers' or `layoutManager' property is modified, and is invoked
     * on the layer and its superlayer whenever its `bounds' or `transform'
     * properties are modified. Implicit calls to -setNeedsLayout are
     * skipped if the layer is currently executing its -layoutSublayers
     * method. */

    func setNeedsLayout() -> StemSetChain<Base> {
        base.setNeedsLayout()
        return StemSetChain(base)
    }


    /* Returns true when the receiver is marked as needing layout. */
    // open func needsLayout() -> Bool


    /* Traverse upwards from the layer while the superlayer requires layout.
     * Then layout the entire tree beneath that ancestor. */

    func layoutIfNeeded() -> StemSetChain<Base> {
        base.layoutIfNeeded()
        return StemSetChain(base)
    }


    /* Called when the layer requires layout. The default implementation
     * calls the layout manager if one exists and it implements the
     * -layoutSublayersOfLayer: method. Subclasses can override this to
     * provide their own layout algorithm, which should set the frame of
     * each sublayer. */

    func layoutSublayers() -> StemSetChain<Base> {
        base.layoutSublayers()
        return StemSetChain(base)
    }

    /* An "action" is an object that responds to an "event" via the
     * CAAction protocol (see below). Events are named using standard
     * dot-separated key paths. Each layer defines a mapping from event key
     * paths to action objects. Events are posted by looking up the action
     * object associated with the key path and sending it the method
     * defined by the CAAction protocol.
     *
     * When an action object is invoked it receives three parameters: the
     * key path naming the event, the object on which the event happened
     * (i.e. the layer), and optionally a dictionary of named arguments
     * specific to each event.
     *
     * To provide implicit animations for layer properties, an event with
     * the same name as each property is posted whenever the value of the
     * property is modified. A suitable CAAnimation object is associated by
     * default with each implicit event (CAAnimation implements the action
     * protocol).
     *
     * The layer class also defines the following events that are not
     * linked directly to properties:
     *
     * onOrderIn
     *      Invoked when the layer is made visible, i.e. either its
     *      superlayer becomes visible, or it's added as a sublayer of a
     *      visible layer
     *
     * onOrderOut
     *      Invoked when the layer becomes non-visible. */

    /* Returns the default action object associated with the event named by
     * the string 'event'. The default implementation returns a suitable
     * animation object for events posted by animatable properties, nil
     * otherwise. */

    /** Action methods. **/
    // open class func defaultAction(forKey event: String) -> CAAction?


    /* Returns the action object associated with the event named by the
     * string 'event'. The default implementation searches for an action
     * object in the following places:
     *
     * 1. if defined, call the delegate method -actionForLayer:forKey:
     * 2. look in the layer's `actions' dictionary
     * 3. look in any `actions' dictionaries in the `style' hierarchy
     * 4. call +defaultActionForKey: on the layer's class
     *
     * If any of these steps results in a non-nil action object, the
     * following steps are ignored. If the final result is an instance of
     * NSNull, it is converted to `nil'. */

    // open func action(forKey event: String) -> CAAction?


    /* A dictionary mapping keys to objects implementing the CAAction
     * protocol. Default value is nil. */
    @discardableResult
    func actions(_ value: [String : CAAction]?) -> StemSetChain<Base> {
        base.actions = value
        return StemSetChain(base)
    }


    /* Attach an animation object to the layer. Typically this is implicitly
     * invoked through an action that is an CAAnimation object.
     *
     * 'key' may be any string such that only one animation per unique key
     * is added per layer. The special key 'transition' is automatically
     * used for transition animations. The nil pointer is also a valid key.
     *
     * If the `duration' property of the animation is zero or negative it
     * is given the default duration, either the value of the
     * `animationDuration' transaction property or .25 seconds otherwise.
     *
     * The animation is copied before being added to the layer, so any
     * subsequent modifications to `anim' will have no affect unless it is
     * added to another layer. */

    /** Animation methods. **/
    func add(_ anim: CAAnimation, forKey key: String?) -> StemSetChain<Base> {
        base.add(anim, forKey: key)
        return StemSetChain(base)
    }


    /* Remove all animations attached to the layer. */
    func removeAllAnimations() -> StemSetChain<Base> {
        base.removeAllAnimations()
        return StemSetChain(base)
    }

    /* Remove any animation attached to the layer for 'key'. */
    func removeAnimation(forKey key: String) -> StemSetChain<Base> {
        base.removeAnimation(forKey: key)
        return StemSetChain(base)
    }


    /* Returns an array containing the keys of all animations currently
     * attached to the receiver. The order of the array matches the order
     * in which animations will be applied. */

    // open func animationKeys() -> [String]?


    /* Returns the animation added to the layer with identifier 'key', or nil
     * if no such animation exists. Attempting to modify any properties of
     * the returned object will result in undefined behavior. */

    // open func animation(forKey key: String) -> CAAnimation?



    /* The name of the layer. Used by some layout managers. Defaults to nil. */

    /** Miscellaneous properties. **/
    @discardableResult
    func name(_ value: String?) -> StemSetChain<Base> {
        base.name = value
        return StemSetChain(base)
    }


    /* An object that will receive the CALayer delegate methods defined
     * below (for those that it implements). The value of this property is
     * not retained. Default value is nil. */

    // weak open var delegate: CALayerDelegate?


    /* When non-nil, a dictionary dereferenced to find property values that
     * aren't explicitly defined by the layer. (This dictionary may in turn
     * have a `style' property, forming a hierarchy of default values.)
     * If the style dictionary doesn't define a value for an attribute, the
     * +defaultValueForKey: method is called. Defaults to nil.
     *
     * Note that if the dictionary or any of its ancestors are modified,
     * the values of the layer's properties are undefined until the `style'
     * property is reset. */
    @discardableResult
    func style(_ value: [AnyHashable : Any]?) -> StemSetChain<Base> {
        base.style = value
        return StemSetChain(base)
    }

}
