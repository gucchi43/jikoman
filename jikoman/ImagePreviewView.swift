/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

protocol ImagePreviewViewDelegate: NSObject {
    func deleteImage(selectedINndex: Int)
}

class ImagePreviewView: UIView {
    private weak var contentView: UIView?
    private var layoutSize: CGSize
    
    weak var delegate: AnyObject ImagePreviewViewDelegate?
    func setLayoutHeight(height: CGFloat) {
        _layoutSize.height = height
        _layoutSize.width = _contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).width
        _layoutSize.width = round(_layoutSize.width)
        self.invalidateIntrinsicContentSize()
    }
    
    init() {
        self = super()
        if self {
            self.commonInit()
        }
        return self
    }
    
    init(aDecoder: NSCoder) {
        self = super(coder: aDecoder)
        if self {
            self.commonInit()
        }
        return self
    }
    
    init(frame: CGRect) {
        self = super(frame: frame)
        if self {
            self.commonInit()
        }
        return self
    }
    
    func commonInit() {
        self.contentView = self.loadAndAddContentViewFromNibNamed(NSStringFromClass(self.class()))
    }
    
    func loadAndAddContentViewFromNibNamed(nibNamed: String) -> UIView {
        print("nibNamed = \(nibNamed)")
        var view = NSBundle.mainBundle().loadNibNamed(nibNamed, owner: self, options: nil).firstObject()
        view.frame = self.bounds
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
        self.addSubview(view)
        return view
    }
    
    @IBAction func deleteImageAction(sender: UIButton) {
        self.delegate.deleteImage(sender.tag - 21)
        print("\(sender.tag)")
    }
    
    func intrinsicContentSize() -> CGSize {
        return _layoutSize
    }
}
