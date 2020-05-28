//
//  DropDown.swift
//  DropDown
//
//  Created by Kevin Hirsch on 28/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public typealias Indexe = Int
public typealias Closure = () -> Void
public typealias SelectionClosure = (Indexe, String) -> Void
public typealias MultiSelectionClosure = ([Indexe], [String]) -> Void
public typealias ConfigurationClosure = (Indexe, String) -> String
public typealias CellConfigurationClosure = (Indexe, String, DropDownCell) -> Void
private typealias ComputeLayoutTuple = (x: CGFloat, y: CGFloat, width: CGFloat, offscreenHeight: CGFloat)

/// Can be `UIView` or `UIBarButtonItem`.
@objc
public protocol AnchorView: class {
    
    var plainView: UIView { get }
    
}

extension UIView: AnchorView {
    
    public var plainView: UIView {
        return self
    }
    
}

extension UIBarButtonItem: AnchorView {
    
    public var plainView: UIView {
        return value(forKey: "view") as! UIView
    }
    
}

/// A Material Design drop down in replacement for `UIPickerView`.
public final class DropDown: UIView {
    
    //TODO: handle iOS 7 landscape mode
    
    /// The dismiss mode for a drop down.
    public enum DismissMode {
        
        /// A tap outside the drop down is required to dismiss.
        case onTap
        
        /// No tap is required to dismiss, it will dimiss when interacting with anything else.
        case automatic
        
        /// Not dismissable by the user.
        case manual
        
    }
    
    /// The direction where the drop down will show from the `anchorView`.
    public enum Direction {
        
        /// The drop down will show below the anchor view when possible, otherwise above if there is more place than below.
        case any
        
        /// The drop down will show above the anchor view or will not be showed if not enough space.
        case top
        
        /// The drop down will show below or will not be showed if not enough space.
        case bottom
        
    }
    
    //MARK: - Properties
    
    /// The current visible drop down. There can be only one visible drop down at a time.
    public static weak var VisibleDropDown: DropDown?
    
    //MARK: UI
    fileprivate let dismissableView = UIView()
    fileprivate let tableViewContainer = UIView()
    public var searchBar: AnimatableTextField?
    fileprivate let tableView = UITableView()
    fileprivate var templateCell: DropDownCell!
    fileprivate lazy var arrowIndication: UIImageView = {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 10), false, 0)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 10))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 10))
        UIColor.black.setFill()
        path.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let tintImg = img?.withRenderingMode(.alwaysTemplate)
        let imgv = UIImageView(image: tintImg)
        imgv.frame = CGRect(x: 0, y: -10, width: 15, height: 10)
        return imgv
    }()
    
    
    /// The view to which the drop down will displayed onto.
    public weak var anchorView: AnchorView? {
        didSet { setNeedsUpdateConstraints() }
    }
    
    /**
     The possible directions where the drop down will be showed.
     
     See `Direction` enum for more info.
     */
    public var direction = Direction.any
    
    /**
     The offset point relative to `anchorView` when the drop down is shown above the anchor view.
     
     By default, the drop down is showed onto the `anchorView` with the top
     left corner for its origin, so an offset equal to (0, 0).
     You can change here the default drop down origin.
     */
    public var topOffset: CGPoint = .zero {
        didSet { setNeedsUpdateConstraints() }
    }
    
    /**
     The offset point relative to `anchorView` when the drop down is shown below the anchor view.
     
     By default, the drop down is showed onto the `anchorView` with the top
     left corner for its origin, so an offset equal to (0, 0).
     You can change here the default drop down origin.
     */
    public var bottomOffset: CGPoint = .zero {
        didSet { setNeedsUpdateConstraints() }
    }
    
    /**
     The offset from the bottom of the window when the drop down is shown below the anchor view.
     DropDown applies this offset only if keyboard is hidden.
     */
    public var offsetFromWindowBottom = CGFloat(0) {
        didSet { setNeedsUpdateConstraints() }
    }
    
    /**
     The width of the drop down.
     
     Defaults to `anchorView.bounds.width - offset.x`.
     */
    public var width: CGFloat? {
        didSet { setNeedsUpdateConstraints() }
    }
    
    public var searchText : String?
    
    public var isSearchEnable = false {
        didSet{
            if(/isSearchEnable) {
                createSearchBar()
            }
        }
    }
    
    public var isMultipleSelection: Bool = false
    
    public var arrSelectedIndexs : [Int] = [Int]()
    
    /**
     arrowIndication.x
     
     arrowIndication will be add to tableViewContainer when configured
     */
    public var arrowIndicationX: CGFloat? {
        didSet {
            if let arrowIndicationX = arrowIndicationX {
                tableViewContainer.addSubview(arrowIndication)
                arrowIndication.tintColor = tableViewBackgroundColor
                arrowIndication.frame.origin.x = arrowIndicationX
            } else {
                arrowIndication.removeFromSuperview()
            }
        }
    }
    
    //MARK: Constraints
    fileprivate var heightConstraint: NSLayoutConstraint!
    fileprivate var widthConstraint: NSLayoutConstraint!
    fileprivate var xConstraint: NSLayoutConstraint!
    fileprivate var yConstraint: NSLayoutConstraint!
    
    //MARK: Appearance
    @objc public dynamic var cellHeight = DPDConstant.UI.RowHeight {
        willSet { tableView.rowHeight = newValue }
        didSet { reloadAllComponents() }
    }
    
    @objc fileprivate dynamic var tableViewBackgroundColor = DPDConstant.UI.BackgroundColor {
        willSet {
            tableView.backgroundColor = newValue
            if arrowIndicationX != nil { arrowIndication.tintColor = newValue }
        }
    }
    
    public override var backgroundColor: UIColor? {
        get { return tableViewBackgroundColor }
        set { tableViewBackgroundColor = newValue! }
    }
    
    /**
     The color of the dimmed background (behind the drop down, covering the entire screen).
     */
    public var dimmedBackgroundColor = UIColor.clear {
        willSet { super.backgroundColor = newValue }
    }
    
    /**
     The background color of the selected cell in the drop down.
     
     Changing the background color automatically reloads the drop down.
     */
    @objc public dynamic var selectionBackgroundColor = DPDConstant.UI.SelectionBackgroundColor
    
    /**
     The separator color between cells.
     
     Changing the separator color automatically reloads the drop down.
     */
    @objc public dynamic var separatorColor = DPDConstant.UI.SeparatorColor {
        willSet { tableView.separatorColor = newValue }
        didSet { reloadAllComponents() }
    }
    
    /**
     The corner radius of DropDown.
     
     Changing the corner radius automatically reloads the drop down.
     */
    @objc public dynamic var cornerRadius = DPDConstant.UI.CornerRadius {
        willSet {
            tableViewContainer.layer.cornerRadius = newValue
            tableView.layer.cornerRadius = newValue
        }
        didSet { reloadAllComponents() }
    }
    
    /**
     Alias method for `cornerRadius` variable to avoid ambiguity.
     */
    @objc public dynamic func setupCornerRadius(_ radius: CGFloat) {
        tableViewContainer.layer.cornerRadius = radius
        tableView.layer.cornerRadius = radius
        reloadAllComponents()
    }
    
    /**
     The masked corners of DropDown.
     
     Changing the masked corners automatically reloads the drop down.
     */
    @available(iOS 11.0, *)
    @objc public dynamic func setupMaskedCorners(_ cornerMask: CACornerMask) {
        tableViewContainer.layer.maskedCorners = cornerMask
        tableView.layer.maskedCorners = cornerMask
        reloadAllComponents()
    }
    
    /**
     The color of the shadow.
     
     Changing the shadow color automatically reloads the drop down.
     */
    @objc public dynamic var shadowColor = DPDConstant.UI.Shadow.Color {
        willSet { tableViewContainer.layer.shadowColor = newValue.cgColor }
        didSet { reloadAllComponents() }
    }
    
    /**
     The offset of the shadow.
     
     Changing the shadow color automatically reloads the drop down.
     */
    @objc public dynamic var shadowOffset = DPDConstant.UI.Shadow.Offset {
        willSet { tableViewContainer.layer.shadowOffset = newValue }
        didSet { reloadAllComponents() }
    }
    
    /**
     The opacity of the shadow.
     
     Changing the shadow opacity automatically reloads the drop down.
     */
    @objc public dynamic var shadowOpacity = DPDConstant.UI.Shadow.Opacity {
        willSet { tableViewContainer.layer.shadowOpacity = newValue }
        didSet { reloadAllComponents() }
    }
    
    /**
     The radius of the shadow.
     
     Changing the shadow radius automatically reloads the drop down.
     */
    @objc public dynamic var shadowRadius = DPDConstant.UI.Shadow.Radius {
        willSet { tableViewContainer.layer.shadowRadius = newValue }
        didSet { reloadAllComponents() }
    }
    
    /**
     The duration of the show/hide animation.
     */
    @objc public dynamic var animationduration = DPDConstant.Animation.Duration
    
    /**
     The option of the show animation. Global change.
     */
    static var animationEntranceOptions = DPDConstant.Animation.EntranceOptions
    
    /**
     The option of the hide animation. Global change.
     */
    static var animationExitOptions = DPDConstant.Animation.ExitOptions
    
    /**
     The option of the show animation. Only change the caller. To change all drop down's use the static var.
     */
    var animationEntranceOptions: UIView.AnimationOptions = DropDown.animationEntranceOptions
    
    /**
     The option of the hide animation. Only change the caller. To change all drop down's use the static var.
     */
    var animationExitOptions: UIView.AnimationOptions = DropDown.animationExitOptions
    
    /**
     The downScale transformation of the tableview when the DropDown is appearing
     */
    public var downScaleTransform = DPDConstant.Animation.DownScaleTransform {
        willSet { tableViewContainer.transform = newValue }
    }
    
    /**
     The color of the text for each cells of the drop down.
     
     Changing the text color automatically reloads the drop down.
     */
    @objc public dynamic var textColor = DPDConstant.UI.TextColor {
        didSet { reloadAllComponents() }
    }
    
    /**
     The color of the text for selected cells of the drop down.
     
     Changing the text color automatically reloads the drop down.
     */
    @objc public dynamic var selectedTextColor = DPDConstant.UI.SelectedTextColor {
        didSet { reloadAllComponents() }
    }
    
    /**
     The font of the text for each cells of the drop down.
     
     Changing the text font automatically reloads the drop down.
     */
    @objc public dynamic var textFont = Font.fontRegular(size: 16) ?? UIFont.systemFont(ofSize: 16) {
        didSet { reloadAllComponents() }
    }
    
    /**
     The NIB to use for DropDownCells
     
     Changing the cell nib automatically reloads the drop down.
     */
    public var cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self)) {
        didSet {
            tableView.register(cellNib, forCellReuseIdentifier: DPDConstant.ReusableIdentifier.DropDownCell)
            templateCell = nil
            reloadAllComponents()
        }
    }
    
    //MARK: Content
    
    /**
     The data source for the drop down.
     
     Changing the data source automatically reloads the drop down.
     */
    public var dataSource = [String]() {
        didSet {
            deselectRows(at: selectedRowIndices)
            reloadAllComponents()
        }
    }
    
    fileprivate var filteredList = [String]()
    
    /**
     The localization keys for the data source for the drop down.
     
     Changing this value automatically reloads the drop down.
     This has uses for setting accibility identifiers on the drop down cells (same ones as the localization keys).
     */
    public var localizationKeysDataSource = [String]() {
        didSet {
            dataSource = localizationKeysDataSource.map { NSLocalizedString($0, comment: "") }
        }
    }
    
    /// The indicies that have been selected
    fileprivate var selectedRowIndices = Set<Indexe>()
    
    /**
     The format for the cells' text.
     
     By default, the cell's text takes the plain `dataSource` value.
     Changing `cellConfiguration` automatically reloads the drop down.
     */
    public var cellConfiguration: ConfigurationClosure? {
        didSet { reloadAllComponents() }
    }
    
    /**
     A advanced formatter for the cells. Allows customization when custom cells are used
     
     Changing `customCellConfiguration` automatically reloads the drop down.
     */
    public var customCellConfiguration: CellConfigurationClosure? {
        didSet { reloadAllComponents() }
    }
    
    /// The action to execute when the user selects a cell.
    public var selectionAction: SelectionClosure?
    
    /**
     The action to execute when the user selects multiple cells.
     
     Providing an action will turn on multiselection mode.
     The single selection action will still be called if provided.
     */
    public var multiSelectionAction: MultiSelectionClosure?
    
    /// The action to execute when the drop down will show.
    public var willShowAction: Closure?
    
    /// The action to execute when the user cancels/hides the drop down.
    public var cancelAction: Closure?
    
    /// The dismiss mode of the drop down. Default is `OnTap`.
    public var dismissMode = DismissMode.onTap {
        willSet {
            if newValue == .onTap {
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
                dismissableView.addGestureRecognizer(gestureRecognizer)
            } else if let gestureRecognizer = dismissableView.gestureRecognizers?.first {
                dismissableView.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    fileprivate var minHeight: CGFloat {
        return tableView.rowHeight
    }
    
    fileprivate var didSetupConstraints = false
    
    //MARK: - Init's
    
    deinit {
        stopListeningToNotifications()
    }
    
    /**
     Creates a new instance of a drop down.
     Don't forget to setup the `dataSource`,
     the `anchorView` and the `selectionAction`
     at least before calling `show()`.
     */
    public convenience init() {
        self.init(frame: .zero)
    }
    
    /**
     Creates a new instance of a drop down.
     
     - parameter anchorView:        The view to which the drop down will displayed onto.
     - parameter selectionAction:   The action to execute when the user selects a cell.
     - parameter dataSource:        The data source for the drop down.
     - parameter topOffset:         The offset point relative to `anchorView` used when drop down is displayed on above the anchor view.
     - parameter bottomOffset:      The offset point relative to `anchorView` used when drop down is displayed on below the anchor view.
     - parameter cellConfiguration: The format for the cells' text.
     - parameter cancelAction:      The action to execute when the user cancels/hides the drop down.
     
     - returns: A new instance of a drop down customized with the above parameters.
     */
    public convenience init(anchorView: AnchorView, selectionAction: SelectionClosure? = nil, dataSource: [String] = [], topOffset: CGPoint? = nil, bottomOffset: CGPoint? = nil, cellConfiguration: ConfigurationClosure? = nil, cancelAction: Closure? = nil) {
        self.init(frame: .zero)
        
        self.anchorView = anchorView
        self.selectionAction = selectionAction
        self.dataSource = dataSource
        self.topOffset = topOffset ?? .zero
        self.bottomOffset = bottomOffset ?? .zero
        self.cellConfiguration = cellConfiguration
        self.cancelAction = cancelAction
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}

//MARK: - Setup

private extension DropDown {
    
    func setup() {
        
        tableView.register(cellNib, forCellReuseIdentifier: DPDConstant.ReusableIdentifier.DropDownCell)
        //Bhavya
        if /isSearchEnable { }
        
        DispatchQueue.main.async {
            //HACK: If not done in dispatch_async on main queue `setupUI` will have no effect
            self.updateConstraintsIfNeeded()
            self.setupUI()
        }
        
        tableView.rowHeight = cellHeight
        setHiddentState()
        isHidden = true
        
        dismissMode = .onTap
        
        tableView.delegate = self
        tableView.dataSource = self
        
        startListeningToKeyboard()
        
        accessibilityIdentifier = "drop_down"
    }
    
    
    //MARK:- Create Search Bar
    private func createSearchBar() {
        
        if self.tableView.tableHeaderView == nil {
            
            searchBar = AnimatableTextField.init(frame: CGRect.init(x: 4, y: 0, width: /tableView.frame.width - 16, height: 40))
            searchBar?.leftView?.frame = CGRect(x: 0, y: 15, width: 16, height:16)
            searchBar?.leftView?.clipsToBounds = true
            searchBar?.paddingLeft = 36
            searchBar?.paddingRight = 8
            searchBar?.leftViewMode = .always
            searchBar?.leftView =  UIImageView.init(image: #imageLiteral(resourceName: "magnifying-glass"))
            searchBar?.leftViewMode = UITextField.ViewMode.always
            searchBar?.cornerRadius = 4
            searchBar?.borderColor = UIColor.white
            searchBar?.borderWidth = 4
            searchBar?.font = Font.fontRegular(size: 14) ?? UIFont.systemFont(ofSize: 14)
            searchBar?.delegate = self
            searchBar?.placeholder = searchText ?? "SearchPlaceHolder".localized
            searchBar?.placeholderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            searchBar?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            
            //            tableView.tableHeaderView?.semanticContentAttribute = /UserSingleton.shared.languageID == LanguageCode.Arabic.get() ? .forceLeftToRight : .forceLeftToRight
            //            searchController.searchBar.placeholder = /UserSingleton.shared.languageID == LanguageCode.Arabic.get() ? "بحث"  : "Search"
            //            searchController.searchBar.setValue(/UserSingleton.shared.languageID == LanguageCode.Arabic.get() ? "إلغاء" : "Cancel", forKey: "_cancelButtonText")
            self.tableView.tableHeaderView?.isUserInteractionEnabled = true
            tableView.tableHeaderView = searchBar
        }
    }
    
    //MARK:- Update Search
    @objc func textFieldDidChange(_ textField: UITextField) {
        _ = filter(/textField.text)
        self.tableView.reloadData()
    }
    
    @objc private func textFiledTap() {
    }
    
    @objc private func textFiledTap2() {
    }
    
    private func filter(_ searchText: String) -> [String] {
        filteredList = []
        
        _ =  dataSource.filter { (string)  in
            if string.count >= searchText.count {
                if string.range(of: searchText, options: [.caseInsensitive, .diacriticInsensitive]) != nil {
                    filteredList.append(string)
                    
                }
            }
            return true
        }
        
        //        dataSource.forEach ({ (string) -> () in
        //
        //            if string.count >= searchText.count {
        //                let result = string.compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.startIndex ..< searchText.endIndex)
        //                if result == .orderedSame {
        //                    filteredList.append(string)
        //                }
        //            }
        //        })
        
        //        sections.forEach { (section) -> () in
        //            section.countries.forEach({ (country) -> () in
        //                if country.name.characters.count >= searchText.characters.count {
        //                    let result = country.name.compare(searchText, options: [.caseInsensitive, .diacriticInsensitive], range: searchText.characters.startIndex ..< searchText.characters.endIndex)
        //                    if result == .orderedSame {
        //                        filteredList.append(country)
        //                    }
        //                }
        //            })
        //        }
        return filteredList
    }
    
    func setupUI() {
        super.backgroundColor = dimmedBackgroundColor
        
        tableViewContainer.layer.masksToBounds = false
        tableViewContainer.layer.cornerRadius = cornerRadius
        tableViewContainer.layer.shadowColor = shadowColor.cgColor
        tableViewContainer.layer.shadowOffset = shadowOffset
        tableViewContainer.layer.shadowOpacity = shadowOpacity
        tableViewContainer.layer.shadowRadius = shadowRadius
        
        tableView.backgroundColor = tableViewBackgroundColor
        tableView.separatorColor = separatorColor
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.masksToBounds = true
    }
    
}

//MARK: - UI

extension DropDown {
    
    public override func updateConstraints() {
        if !didSetupConstraints {
            setupConstraints()
        }
        
        didSetupConstraints = true
        
        let layout = computeLayout()
        
        if !layout.canBeDisplayed {
            super.updateConstraints()
            hide()
            
            return
        }
        
        xConstraint.constant = layout.x
        yConstraint.constant = layout.y
        widthConstraint.constant = layout.width
        heightConstraint.constant = layout.visibleHeight
        
        tableView.isScrollEnabled = layout.offscreenHeight > 0
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.flashScrollIndicators()
        }
        
        super.updateConstraints()
    }
    
    fileprivate func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Dismissable view
        addSubview(dismissableView)
        dismissableView.translatesAutoresizingMaskIntoConstraints = false
        
        addUniversalConstraints(format: "|[dismissableView]|", views: ["dismissableView": dismissableView])
        
        
        // Table view container
        addSubview(tableViewContainer)
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        xConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 0)
        addConstraint(xConstraint)
        
        yConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0)
        addConstraint(yConstraint)
        
        widthConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0)
        tableViewContainer.addConstraint(widthConstraint)
        
        heightConstraint = NSLayoutConstraint(
            item: tableViewContainer,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0)
        tableViewContainer.addConstraint(heightConstraint)
        
        // Table view
        tableViewContainer.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableViewContainer.addUniversalConstraints(format: "|[tableView]|", views: ["tableView": tableView])
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // When orientation changes, layoutSubviews is called
        // We update the constraint to update the position
        setNeedsUpdateConstraints()
        
        let shadowPath = UIBezierPath(roundedRect: tableViewContainer.bounds, cornerRadius: cornerRadius)
        tableViewContainer.layer.shadowPath = shadowPath.cgPath
    }
    
    fileprivate func computeLayout() -> (x: CGFloat, y: CGFloat, width: CGFloat, offscreenHeight: CGFloat, visibleHeight: CGFloat, canBeDisplayed: Bool, Direction: Direction) {
        var layout: ComputeLayoutTuple = (0, 0, 0, 0)
        var direction = self.direction
        
        guard let window = UIWindow.visibleWindow() else { return (0, 0, 0, 0, 0, false, direction) }
        
        barButtonItemCondition: if let anchorView = anchorView as? UIBarButtonItem {
            let isRightBarButtonItem = anchorView.plainView.frame.minX > window.frame.midX
            
            guard isRightBarButtonItem else { break barButtonItemCondition }
            
            let width = self.width ?? fittingWidth()
            let anchorViewWidth = anchorView.plainView.frame.width
            let x = -(width - anchorViewWidth)
            
            bottomOffset = CGPoint(x: x, y: 0)
        }
        
        if anchorView == nil {
            layout = computeLayoutBottomDisplay(window: window)
            direction = .any
        } else {
            switch direction {
            case .any:
                layout = computeLayoutBottomDisplay(window: window)
                direction = .bottom
                
                if layout.offscreenHeight > 0 {
                    let topLayout = computeLayoutForTopDisplay(window: window)
                    
                    if topLayout.offscreenHeight < layout.offscreenHeight {
                        layout = topLayout
                        direction = .top
                    }
                }
            case .bottom:
                layout = computeLayoutBottomDisplay(window: window)
                direction = .bottom
            case .top:
                layout = computeLayoutForTopDisplay(window: window)
                direction = .top
            }
        }
        
        constraintWidthToFittingSizeIfNecessary(layout: &layout)
        constraintWidthToBoundsIfNecessary(layout: &layout, in: window)
        
        let visibleHeight = tableHeight - layout.offscreenHeight
        let canBeDisplayed = visibleHeight >= minHeight
        
        return (layout.x, layout.y, layout.width, layout.offscreenHeight, visibleHeight, canBeDisplayed, direction)
    }
    
    fileprivate func computeLayoutBottomDisplay(window: UIWindow) -> ComputeLayoutTuple {
        var offscreenHeight: CGFloat = 0
        
        let width = self.width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - bottomOffset.x
        
        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? window.frame.midX - (width / 2)
        let anchorViewY = anchorView?.plainView.windowFrame?.minY ?? window.frame.midY - (tableHeight / 2)
        
        let x = anchorViewX + bottomOffset.x
        let y = anchorViewY + bottomOffset.y
        
        let maxY = y + tableHeight
        let windowMaxY = window.bounds.maxY - DPDConstant.UI.HeightPadding - offsetFromWindowBottom
        
        let keyboardListener = KeyboardListener.sharedInstance
        let keyboardMinY = keyboardListener.keyboardFrame.minY - DPDConstant.UI.HeightPadding
        
        if keyboardListener.isVisible && maxY > keyboardMinY {
            offscreenHeight = abs(maxY - keyboardMinY)
        } else if maxY > windowMaxY {
            offscreenHeight = abs(maxY - windowMaxY)
        }
        
        return (x, y, width, offscreenHeight)
    }
    
    fileprivate func computeLayoutForTopDisplay(window: UIWindow) -> ComputeLayoutTuple {
        var offscreenHeight: CGFloat = 0
        
        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? 0
        let anchorViewMaxY = anchorView?.plainView.windowFrame?.maxY ?? 0
        
        let x = anchorViewX + topOffset.x
        var y = (anchorViewMaxY + topOffset.y) - tableHeight
        
        let windowY = window.bounds.minY + DPDConstant.UI.HeightPadding
        
        if y < windowY {
            offscreenHeight = abs(y - windowY)
            y = windowY
        }
        
        let width = self.width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - topOffset.x
        
        return (x, y, width, offscreenHeight)
    }
    
    fileprivate func fittingWidth() -> CGFloat {
        if templateCell == nil {
            templateCell = (cellNib.instantiate(withOwner: nil, options: nil)[0] as! DropDownCell)
        }
        
        var maxWidth: CGFloat = 0
        var dataSourceVal = [String]()
        
        if searchBar?.text?.count ?? 0 > 0 {
            dataSourceVal = filteredList
        } else {
            dataSourceVal = dataSource
        }
        
        for Indexe in 0..<dataSourceVal.count {
            configureCell(templateCell, at: Indexe)
            templateCell.bounds.size.height = cellHeight
            let width = templateCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            //systemLayoutSizeFitting(UIView.UILayoutFittingCompressedSize).width
            
            if width > maxWidth {
                maxWidth = width
            }
        }
        
        return maxWidth
    }
    
    fileprivate func constraintWidthToBoundsIfNecessary(layout: inout ComputeLayoutTuple, in window: UIWindow) {
        let windowMaxX = window.bounds.maxX
        let maxX = layout.x + layout.width
        
        if maxX > windowMaxX {
            let delta = maxX - windowMaxX
            let newOrigin = layout.x - delta
            
            if newOrigin > 0 {
                layout.x = newOrigin
            } else {
                layout.x = 0
                layout.width += newOrigin // newOrigin is negative, so this operation is a substraction
            }
        }
    }
    
    fileprivate func constraintWidthToFittingSizeIfNecessary(layout: inout ComputeLayoutTuple) {
        guard width == nil else { return }
        
        if layout.width < fittingWidth() {
            layout.width = fittingWidth()
        }
    }
    
}

//MARK: - Actions

extension DropDown {
    
    /**
     An Objective-C alias for the show() method which converts the returned tuple into an NSDictionary.
     
     - returns: An NSDictionary with a value for the "canBeDisplayed" Bool, and possibly for the "offScreenHeight" Optional(CGFloat).
     */
    @objc(show)
    public func objc_show() -> NSDictionary {
        let (canBeDisplayed, offScreenHeight) = show()
        
        var info = [AnyHashable: Any]()
        info["canBeDisplayed"] = canBeDisplayed
        if let offScreenHeight = offScreenHeight {
            info["offScreenHeight"] = offScreenHeight
        }
        
        return NSDictionary(dictionary: info)
    }
    
    /**
     Shows the drop down if enough height.
     
     - returns: Wether it succeed and how much height is needed to display all cells at once.
     */
    @discardableResult
    public func show(onTopOf window: UIWindow? = nil, beforeTransform transform: CGAffineTransform? = nil, anchorPoint: CGPoint? = nil) -> (canBeDisplayed: Bool, offscreenHeight: CGFloat?) {
        if self == DropDown.VisibleDropDown && DropDown.VisibleDropDown?.isHidden == false { // added condition - DropDown.VisibleDropDown?.isHidden == false -> to resolve forever hiding dropdown issue when continuous taping on button - Kartik Patel - 2016-12-29
            return (true, 0)
        }
        
        if let visibleDropDown = DropDown.VisibleDropDown {
            visibleDropDown.cancel()
        }
        
        willShowAction?()
        
        DropDown.VisibleDropDown = self
        
        setNeedsUpdateConstraints()
        
        let visibleWindow = window != nil ? window : UIWindow.visibleWindow()
        visibleWindow?.addSubview(self)
        visibleWindow?.bringSubviewToFront(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])
        
        let layout = computeLayout()
        
        if !layout.canBeDisplayed {
            hide()
            return (layout.canBeDisplayed, layout.offscreenHeight)
        }
        
        isHidden = false
        
        if anchorPoint != nil {
            tableViewContainer.layer.anchorPoint = anchorPoint!
        }
        
        if transform != nil {
            tableViewContainer.transform = transform!
        } else {
            tableViewContainer.transform = downScaleTransform
        }
        
        layoutIfNeeded()
        
        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationEntranceOptions,
            animations: { [weak self] in
                self?.setShowedState()
            },
            completion: nil)
        
        accessibilityViewIsModal = true
        //        UIAccessibility.post(notification: .screenChanged, argument: self)
        
        //deselectRows(at: selectedRowIndices)
        selectRows(at: selectedRowIndices)
        //MARK:- Change
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        self.searchBar?.text = ""
        self.tableView.reloadData()
        return (layout.canBeDisplayed, layout.offscreenHeight)
    }
    
    public override func accessibilityPerformEscape() -> Bool {
        switch dismissMode {
        case .automatic, .onTap:
            cancel()
            return true
        case .manual:
            return false
        }
    }
    
    /// Hides the drop down.
    public func hide() {
        if self == DropDown.VisibleDropDown {
            /*
             If one drop down is showed and another one is not
             but we call `hide()` on the hidden one:
             we don't want it to set the `VisibleDropDown` to nil.
             */
            DropDown.VisibleDropDown = nil
        }
        
        if isHidden {
            return
        }
        
        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            options: animationExitOptions,
            animations: { [weak self] in
                self?.setHiddentState()
            },
            completion: { [weak self] finished in
                guard let `self` = self else { return }
                
                self.isHidden = true
                self.removeFromSuperview()
                //                UIAccessibility.post(notification: .screenChanged, argument: nil)
        })
    }
    
    fileprivate func cancel() {
        hide()
        cancelAction?()
    }
    
    fileprivate func setHiddentState() {
        alpha = 0
    }
    
    fileprivate func setShowedState() {
        alpha = 1
        tableViewContainer.transform = CGAffineTransform.identity
    }
    
}

//MARK: - UITableView

extension DropDown {
    
    /**
     Reloads all the cells.
     
     It should not be necessary in most cases because each change to
     `dataSource`, `textColor`, `textFont`, `selectionBackgroundColor`
     and `cellConfiguration` implicitly calls `reloadAllComponents()`.
     */
    public func reloadAllComponents() {
        DispatchQueue.executeOnMainThread {
            self.tableView.reloadData()
            self.setNeedsUpdateConstraints()
        }
    }
    
    public func reloadDropDown() {
        DispatchQueue.executeOnMainThread {
//            self.dataSource =
//                self.
            self.searchBar?.text = ""
            self.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
            self.tableView.reloadData()
            self.setNeedsUpdateConstraints()
        }
    }
    
    /// (Pre)selects a row at a certain Indexe.
    public func selectRow(at index: Indexe?, scrollPosition: UITableView.ScrollPosition = .none) {
        if let index = index {
            tableView.selectRow(
                at: IndexPath(row: index, section: 0), animated: true, scrollPosition: scrollPosition
            )
            selectedRowIndices.insert(index)
        } else {
            deselectRows(at: selectedRowIndices)
            selectedRowIndices.removeAll()
        }
    }
    
    public func selectRows(at indices: Set<Indexe>?) {
        indices?.forEach {
            selectRow(at: $0)
        }
        
        // if we are in multi selection mode then reload data so that all selections are shown
        if multiSelectionAction != nil {
            tableView.reloadData()
        }
    }
    
    public func deselectRow(at index: Indexe?) {
        guard let index = index
            , index >= 0
            else { return }
        
        // remove from indices
        if let selectedRowIndex = selectedRowIndices.index(where: { $0 == index  }) {
            selectedRowIndices.remove(at: selectedRowIndex)
        }
        
        tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
    }
    
    // de-selects the rows at the indices provided
    public func deselectRows(at indices: Set<Indexe>?) {
        indices?.forEach {
            deselectRow(at: $0)
        }
    }
    
    /// Returns the Indexe of the selected row.
    public var IndexeForSelectedRow: Indexe? {
        return (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
    }
    
    /// Returns the selected item.
    public var selectedItem: String? {
        guard let row = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row else { return nil }
        
        return dataSource[row]
    }
    
    /// Returns the height needed to display all cells.
    fileprivate var tableHeight: CGFloat {
        if(/isSearchEnable) {
            return (tableView.rowHeight * CGFloat(dataSource.count) + 42)

        }else {
            return tableView.rowHeight * CGFloat(dataSource.count)

        }
    }
    
    //MARK: Objective-C methods for converting the Swift type Indexe
    
    //MARK: Objective-C methods for converting the Swift type Index
    @objc public func selectRow(_ index: Int, scrollPosition: UITableView.ScrollPosition = .none) {
        self.selectRow(at:Indexe(index), scrollPosition: scrollPosition)
    }
    
    @objc public func clearSelection() {
        self.selectRow(at:nil)
    }
    
    @objc public func deselectRow(_ index: Int) {
        tableView.deselectRow(at: IndexPath(row: Indexe(index), section: 0), animated: true)
    }
    
    @objc public var indexPathForSelectedRow: NSIndexPath? {
        return tableView.indexPathForSelectedRow as NSIndexPath?
    }
}

//MARK: - UITableViewDataSource - UITableViewDelegate

extension DropDown: UITableViewDataSource, UITableViewDelegate {
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchBar?.text?.count ?? 0 > 0 {
            return filteredList.count
        }
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DPDConstant.ReusableIdentifier.DropDownCell, for: indexPath) as! DropDownCell
        let index = (indexPath as NSIndexPath).row
        
        configureCell(cell, at: index)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: DropDownCell, at Indexe: Int) {
        if Indexe >= 0 && Indexe < localizationKeysDataSource.count {
            cell.accessibilityIdentifier = localizationKeysDataSource[Indexe]
        }
        
        cell.optionLabel.textColor = textColor
        cell.optionLabel.font = textFont
        cell.selectedBackgroundColor = selectionBackgroundColor
        cell.highlightTextColor = selectedTextColor
        cell.normalTextColor = textColor
        var dataSourceVal = [String]()
        
        if searchBar?.text?.count ?? 0 > 0 {
            dataSourceVal = filteredList
        } else {
            dataSourceVal = dataSource
        }
        
        if let cellConfiguration = cellConfiguration {
            
            cell.optionLabel.text = cellConfiguration(Indexe, dataSourceVal[Indexe] )
        } else {
            cell.optionLabel.text = dataSourceVal[Indexe]
        }
        
        
        if /isMultipleSelection {
            if selectedRowIndices.contains(Indexe) {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
        }else{
            cell.accessoryType = .none
        }
        
        customCellConfiguration?(Indexe, dataSourceVal[Indexe], cell)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = selectedRowIndices.first{ $0 == (indexPath as NSIndexPath).row } != nil
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowIndex = (indexPath as NSIndexPath).row
        

        // are we in multi-selection mode?
        
        var dataSourceVal = [String]()
        
        if searchBar?.text?.count ?? 0 > 0 {
            dataSourceVal = filteredList
        } else {
            dataSourceVal = dataSource
        }
        
        if let multiSelectionCallback = multiSelectionAction {
            
            // if already selected then deselect
            
            if selectedRowIndices.first(where: { $0 == selectedRowIndex}) != nil {
                deselectRow(at: selectedRowIndex)
                
                let selectedRowIndicesArray = Array(selectedRowIndices)
                let selectedRows = selectedRowIndicesArray.map { dataSourceVal[$0] }
                if selectedRowIndices.contains(indexPath.row) {
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                }else{
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                }
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                return
            }
            else {
                selectedRowIndices.insert(selectedRowIndex)
                
                let selectedRowIndicesArray = Array(selectedRowIndices)
                let selectedRows = selectedRowIndicesArray.map { dataSourceVal[$0] }
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                selectionAction?(selectedRowIndex, dataSourceVal[selectedRowIndex])
                multiSelectionCallback(selectedRowIndicesArray, selectedRows)
                tableView.reloadData()
                return
            }
        }
        
        // Perform single selection logic
        selectedRowIndices.removeAll()
        selectedRowIndices.insert(selectedRowIndex)
        selectionAction?(selectedRowIndex, dataSourceVal[selectedRowIndex])
        
        if let _ = anchorView as? UIBarButtonItem {
            // DropDown's from UIBarButtonItem are menus so we deselect the selected menu right after selection
            deselectRow(at: selectedRowIndex)
        }
        
        hide()
        
    }
    
//    private override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        // Invoked so we can prepare for a change in selection.
//        // Remove previous selection, if any.
//        if let selectedIndex = self.tableView.indexPathForSelectedRow {
//            // Note: Programmatically deslecting does NOT invoke tableView(:didSelectRowAt:), so no risk of infinite loop.
//            self.tableView.deselectRow(at: selectedIndex, animated: false)
//            // Remove the visual selection indication.
//            self.tableView.cellForRow(at: selectedIndex)?.accessoryType = .none
//        }
//        return indexPath
//    }
//
}

//MARK: - Auto dismiss

extension DropDown {
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        if dismissMode == .automatic && view === dismissableView {
            cancel()
            return nil
        } else {
            return view
        }
    }
    
    @objc
    fileprivate func dismissableViewTapped() {
        cancel()
    }
    
}

//MARK:- Keyboard events

extension DropDown {
    
    /**
     Starts listening to keyboard events.
     Allows the drop down to display correctly when keyboard is showed.
     */
    @objc public static func startListeningToKeyboard() {
        KeyboardListener.sharedInstance.startListeningToKeyboard()
    }
    
    fileprivate func startListeningToKeyboard() {
        KeyboardListener.sharedInstance.startListeningToKeyboard()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardUpdate),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardUpdate),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    fileprivate func stopListeningToNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    fileprivate func keyboardUpdate() {
        self.setNeedsUpdateConstraints()
    }
    
}

private extension DispatchQueue {
    static func executeOnMainThread(_ closure: @escaping Closure) {
        if Thread.isMainThread {
            closure()
        } else {
            main.async(execute: closure)
        }
    }
}




import UIKit

extension DropDown {
    
    public class func setupDefaultAppearance() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = DPDConstant.UI.RowHeight
        appearance.backgroundColor = DPDConstant.UI.BackgroundColor
        appearance.selectionBackgroundColor = DPDConstant.UI.SelectionBackgroundColor
        appearance.separatorColor = DPDConstant.UI.SeparatorColor
        appearance.cornerRadius = DPDConstant.UI.CornerRadius
        appearance.shadowColor = DPDConstant.UI.Shadow.Color
        appearance.shadowOffset = DPDConstant.UI.Shadow.Offset
        appearance.shadowOpacity = DPDConstant.UI.Shadow.Opacity
        appearance.shadowRadius = DPDConstant.UI.Shadow.Radius
        appearance.animationduration = DPDConstant.Animation.Duration
        appearance.textColor = DPDConstant.UI.TextColor
        appearance.selectedTextColor = DPDConstant.UI.SelectedTextColor
        appearance.textFont = DPDConstant.UI.TextFont
    }
    
}



open class DropDownCell: UITableViewCell {
    
    //UI
    @IBOutlet open weak var optionLabel: UILabel!
    
    var selectedBackgroundColor: UIColor?
    var highlightTextColor: UIColor?
    var normalTextColor: UIColor?
    
}

//MARK: - UI

extension DropDownCell {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
    
    override open var isSelected: Bool {
        willSet {
            setSelected(newValue, animated: false)
        }
    }
    
    override open var isHighlighted: Bool {
        willSet {
            setSelected(newValue, animated: false)
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        setSelected(highlighted, animated: animated)
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        let executeSelection: () -> Void = { [weak self] in
            guard let `self` = self else { return }
            
            if let selectedBackgroundColor = self.selectedBackgroundColor {
                if selected {
                    self.backgroundColor = selectedBackgroundColor
                    self.optionLabel.textColor = self.highlightTextColor
                } else {
                    self.backgroundColor = .clear
                    self.optionLabel.textColor = self.normalTextColor
                }
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                executeSelection()
            })
        } else {
            executeSelection()
        }
        
        //        DropDownCell.accessibilityTraits()
        //        accessibilityTraits = selected ? .selected : .none
    }
    
}


internal struct DPDConstant {
    
    internal struct KeyPath {
        
        static let Frame = "frame"
        
    }
    
    internal struct ReusableIdentifier {
        
        static let DropDownCell = "DropDownCell"
        
    }
    
    internal struct UI {
        
        static let TextColor = UIColor.black
        static let SelectedTextColor = UIColor.black
        static let TextFont = UIFont.systemFont(ofSize: 15)
        static let BackgroundColor = UIColor(white: 0.94, alpha: 1)
        static let SelectionBackgroundColor = UIColor(white: 0.89, alpha: 1)
        static let SeparatorColor = UIColor.clear
        static let CornerRadius: CGFloat = 2
        static let RowHeight: CGFloat = 44
        static let HeightPadding: CGFloat = 20
        
        struct Shadow {
            
            static let Color = UIColor.darkGray
            static let Offset = CGSize.zero
            static let Opacity: Float = 0.4
            static let Radius: CGFloat = 8
            
        }
        
    }
    
    internal struct Animation {
        
        static let Duration = 0.15
        static let EntranceOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
        static let ExitOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseIn]
        static let DownScaleTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
    }
    
}
internal final class KeyboardListener {
    
    static let sharedInstance = KeyboardListener()
    
    fileprivate(set) var isVisible = false
    fileprivate(set) var keyboardFrame = CGRect.zero
    fileprivate var isListening = false
    
    deinit {
        stopListeningToKeyboard()
    }
    
}

//MARK: - Notifications

extension KeyboardListener {
    
    func startListeningToKeyboard() {
        if isListening {
            return
        }
        
        isListening = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    func stopListeningToKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    fileprivate func keyboardWillShow(_ notification: Notification) {
        isVisible = true
        keyboardFrame = keyboardFrame(fromNotification: notification)
    }
    
    @objc
    fileprivate func keyboardWillHide(_ notification: Notification) {
        isVisible = false
        keyboardFrame = keyboardFrame(fromNotification: notification)
    }
    
    fileprivate func keyboardFrame(fromNotification notification: Notification) -> CGRect {
        return ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? CGRect.zero
    }
    
}


internal extension UIView {
    
    func addConstraints(format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
    }
    
    func addUniversalConstraints(format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
        addConstraints(format: "H:\(format)", options: options, metrics: metrics, views: views)
        addConstraints(format: "V:\(format)", options: options, metrics: metrics, views: views)
    }
    
}



//MARK: - Bounds

internal extension UIView {
    
    var windowFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }
    
}

internal extension UIWindow {
    
    static func visibleWindow() -> UIWindow? {
        var currentWindow = UIApplication.shared.keyWindow
        
        if currentWindow == nil {
            let frontToBackWindows = Array(UIApplication.shared.windows.reversed())
            
            for window in frontToBackWindows {
                if  window.windowLevel == .normal {
//                if window.windowLevel.isNormal {
                    currentWindow = window
                    break
                }
            }
        }
        
        return currentWindow
    }
    
}

//// MARK: - UISearchDisplayDelegate
//
//extension DropDown : UISearchResultsUpdating {
//
//    public func updateSearchResults(for searchController: UISearchController) {
//        _ = filter(searchController.searchBar.text!)
//        self.reloadAllComponents()
//    }
//}

// MARK: - UISearchDisplayDelegate

//extension DropDown : UISearchBarDelegate {
//
//    private func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        _ = filter(searchBar.text!)
//        self.reloadAllComponents()
//    }
//
//    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    }
//
//   private  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//
//    }
//
//    public func updateSearchResults(for searchController: UISearchController) {
//        _ = filter(searchController.searchBar.text!)
//        self.reloadAllComponents()
//    }
//}
extension DropDown : UITextFieldDelegate {
    
    private func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //    private func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //
    //        _ = filter(searchBar.text!)
    //        self.reloadAllComponents()
    //    }
    //
    //    private func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //
    //    }
    //
    //    private  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //
    //    }
    //
    //    public func updateSearchResults(for searchController: UISearchController) {
    //        _ = filter(searchController.searchBar.text!)
    //        self.reloadAllComponents()
    //    }
}
