//
//  TodosDetailViewController.swift
//  todo
//
//  Created by Alejandro Mendoza on 07/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit
import CoreData

class TodosDetailViewController: UIViewController {

    
    @IBOutlet weak var addTodoView: AddTodo!
    @IBOutlet weak var toolbarView: Toolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTodoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var todoDatePickerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var addTodoBackgroundView: UIView!
    @IBOutlet weak var segmentedControllerCompactBackground: UIView! {
        didSet {
            segmentedControllerCompactBackground.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    @IBOutlet weak var todoDatePickerView: TodoDatePicker! {
        didSet {
            todoDatePickerView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    
    let keyboardHandler = KeyboardEvents()
    
    let sortTodosOptions: [SortOptions] = [.ByTag, .ByDateCreated, .ByDateScheduled]
    var detailCompactSelectedSort: SortOptions = .ByTag {
        willSet {
            TodoManager.sharedInstance.sortTodosBy = newValue
        }
        didSet {
            detailTableView.reloadData()
        }
    }
    
    var actualTodoDetailState: TodoState = .discard {
        didSet {
            updateUIToState(actualTodoDetailState)
        }
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Todo>? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.registerForKeyboardEvents()
        
        addTodoView.delegate = self
        keyboardHandler.delegate = self
        toolbarView.delegate = self
        todoDatePickerView.delegate = self
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.allowsMultipleSelectionDuringEditing = false
        
        TodoManager.sharedInstance.detailDelegate = self
        
        if let todos = fetchedResultsController.fetchedObjects {
            TodoManager.sharedInstance.todos = todos
        }
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForStyle(style: traitCollection.horizontalSizeClass)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler.unregisterFromKeyboardEvents()
    }
    
    func setupUI(){
        let discardTap = UITapGestureRecognizer(target: self, action: #selector(discardActionWasSelected))
        addTodoBackgroundView.addGestureRecognizer(discardTap)
        
        detailTableView.register(UINib(nibName: "TodoWithTagAndDateTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DetailTodoCellWithTagIdentifier)
        detailTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DetailTodoCellIdentifier)
    }
    
    @IBAction func addTodoButtonTapped(_ sender: UIButton?) {
        HapticFeedbackManager.sharedInstance.excecuteSelectionFeedback()
        actualTodoDetailState = .present
        addTodoView.todoScheduleDate = nil
    }
    
    @IBAction func segmentedSortedOptionsChangedValueTo(_ sender: UISegmentedControl) {
        
        HapticFeedbackManager.sharedInstance.excecuteSelectionFeedback()
        
        let sortOptionIndex = sender.selectedSegmentIndex
        let sortOption = sortTodosOptions[sortOptionIndex]
        
        detailCompactSelectedSort = sortOption
    }
    
    
    func insertNewTodo(_ configuration: TodoConfiguration){
        let context = self.fetchedResultsController.managedObjectContext
        let newTodo = Todo(context: context)
             
        newTodo.compleated = configuration.completed
        newTodo.tagName = configuration.tagName
        newTodo.todoDescription = configuration.todoDescription
        newTodo.dateCreation = configuration.dateCreation
        newTodo.dateScheduled = configuration.dateScheduled
        newTodo.tagColor = configuration.tagColor
        
        do {
            try context.save()
        } catch {
            assert(true, error.localizedDescription)
        }
        
        discardActionWasSelected()
    }
    
}

// MARK: -Handle UI State Change
extension TodosDetailViewController {
    func updateUIToState(_ state: TodoState){
        
        let animationDuration = Constants.defaultAnimationDuration
        
        switch state {
            
        case .present:
            addTodoView.alpha = 0
            toolbarView.alpha = 0
            addTodoView.isHidden = false
            toolbarView.isHidden = false
            
            addTodoBackgroundView.alpha = 0
            addTodoBackgroundView.isHidden = false
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.addTodoView.alpha = 1
                self.addTodoBackgroundView.alpha = 0.8
                self.toolbarView.alpha = 1
                
                self.todoDatePickerBottomConstraint.constant = -self.todoDatePickerView.frame.height
                self.toolbarBottomConstraint.constant = self.view.safeAreaInsets.bottom
                self.addTodoBottomConstraint.constant = self.toolbarView.frame.height + 75
                self.view.layoutIfNeeded()
            }) { (_) in
                self.addTodoView.setAsFirstResponder()
                HapticFeedbackManager.sharedInstance.excecuteImpactFeedback(intensity: .medium)
            }
            
            
        case .discard:
            UIView.animate(withDuration: animationDuration, animations: {
                self.addTodoBottomConstraint.constant = 0
                self.todoDatePickerBottomConstraint.constant = -self.todoDatePickerView.frame.height
                self.addTodoView.alpha = 0
                self.addTodoBackgroundView.alpha = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                self.addTodoView.resignAsFirstResponder()
                self.addTodoView.isHidden = true
                
                UIView.animate(withDuration: 0.25) {
                    self.toolbarView.alpha = 0
                    self.toolbarBottomConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }
                
            }
            
            addTodoView.resetValues()
            
            
        case .schedule:
            UIView.animate(withDuration: animationDuration, animations: {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
                self.todoDatePickerView.alpha = 1
                self.todoDatePickerBottomConstraint.constant = 0
                self.addTodoBottomConstraint.constant = self.todoDatePickerView.frame.height + 25
                self.view.layoutIfNeeded()
            })
        }
        
    }
}

// MARK: - Handle Keyboard Events
extension TodosDetailViewController: KeyboardHandlingDelegate {
    func keyboardDidShow(_ notification: Notification) {
         
    }
    
    func keyboardDidHide(_ notification: Notification) {
         
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
         
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
         
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let keyboardSize = notification.keyboardSize
        let offsetFromDeviceScreenToApplicationFrame = (UIScreen.main.bounds.height - UIApplication.shared.windows[0].frame.height)/2
        
        if let keyboardHeight = keyboardSize?.height, let animationDuration = notification.keyboardAnimationDuration {
            UIView.animate(withDuration: animationDuration, animations: {
                self.addTodoBottomConstraint.constant = keyboardHeight + 75.0
                let bottomSafeInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
                self.toolbarBottomConstraint.constant = keyboardHeight - bottomSafeInset - offsetFromDeviceScreenToApplicationFrame
                self.todoDatePickerBottomConstraint.constant = 0
                self.todoDatePickerView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
        
    }

    func keyboardWillHide(_ notification: Notification) {
        
        if let animationDuration = notification.keyboardAnimationDuration, actualTodoDetailState == .present {
            UIView.animate(withDuration: animationDuration) {
                self.toolbarBottomConstraint.constant = 0
                self.addTodoBottomConstraint.constant = self.toolbarView.frame.height + 75
                self.view.layoutIfNeeded()
            }
        }

    }
    
    
}

//MARK: -Handle AddTodo Events
extension TodosDetailViewController: AddTodoDelegate {
    func addTodoDidBecameFirstResponder() {
        if actualTodoDetailState == .schedule {
            actualTodoDetailState = .present
        }
    }
}

// MARK: - Handle Toolbar Events
extension TodosDetailViewController: ToolbarDelegate {
    func addActionWasSelected() {
        
        let todoConfiguration = TodoConfiguration(tagName: addTodoView.todoTagName,
                                                  tagColor: addTodoView.tagColor.rawValue,
                                                  todoDescription: addTodoView.todoDescription,
                                                  dateCreation: Date(),
                                                  dateScheduled: addTodoView.todoScheduleDate)
        insertNewTodo(todoConfiguration)
        HapticFeedbackManager.sharedInstance.excecuteImpactFeedback(intensity: .soft)
    }
    
    func scheduleActionWasSelected() {
        actualTodoDetailState = .schedule
        addTodoView.resignAsFirstResponder()
        HapticFeedbackManager.sharedInstance.excecuteSelectionFeedback()
    }
    
    @objc
    func discardActionWasSelected() {
        HapticFeedbackManager.sharedInstance.excecuteNotificationFeedBack(notification: .warning)
        actualTodoDetailState = .discard
    }
    
    
}

// MARK: - Handle View Updates
extension TodosDetailViewController {
    
    enum TodoState {
        case present
        case discard
        case schedule
    }
    
}

//MARK: - Segmented Controller Events
extension TodosDetailViewController {
    @objc func detailSortedCompactSegmentedControllerChangedValueTo(_ sender: UISegmentedControl){
        let selectedValueIndex = sender.selectedSegmentIndex
        let selectedValue = sender.titleForSegment(at: selectedValueIndex)
        
        if  let title = selectedValue,
            let sortedOption = SortOptions(rawValue: title) {
            detailCompactSelectedSort = sortedOption
        }
        
    }
}


// MARK: - Fetched Results Controller
extension TodosDetailViewController: NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<Todo> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "dateCreation", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            assert(true, error.localizedDescription)
        }
        
        return _fetchedResultsController!
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let todos = fetchedResultsController.fetchedObjects {
            TodoManager.sharedInstance.todos = todos
        }
    }
}


// MARK: Handle UserInterfaceStyle
extension TodosDetailViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection == previousTraitCollection {
            return
        }
        updateUIForStyle(style: traitCollection.horizontalSizeClass)
        
    }
    
    func updateUIForStyle(style: UIUserInterfaceSizeClass) {
        
        switch style {
            
        case .compact, .unspecified:
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.isTranslucent = true
            navigationItem.setHidesBackButton(true, animated: true)
            toolbarView.layer.cornerRadius = 0
            toolbarView.containerView.layer.cornerRadius = 0
            
        case .regular:
            navigationItem.titleView = nil
            navigationItem.setHidesBackButton(false, animated: true)
            toolbarView.layer.cornerRadius = Constants.TodoCornerRadius
            toolbarView.containerView.layer.cornerRadius = Constants.TodoCornerRadius
            
        @unknown default:
            break
        }
        
    }
}

//MARK: -Handle TodoManager Delegate
extension TodosDetailViewController: TodoManagerDelegate {
    func didChangeFocusTo(option: FocusOptions) {
        detailTableView.reloadData()
    }
    
    func didFinishSortingTodos() {
        detailTableView.reloadData()
    }
}

//MARK: -Handle TodoDatePicker Delegate
extension TodosDetailViewController: TodoDatePickerDelegate {
    func acceptActionWasSelectedWithDate(date: Date) {
        addTodoView.todoScheduleDate = date
        actualTodoDetailState = .present
        addTodoView.setAsFirstResponder()
        HapticFeedbackManager.sharedInstance.excecuteSelectionFeedback()
    }
    
    func cancelActionWasSelected() {
        addTodoView.todoScheduleDate = nil
        HapticFeedbackManager.sharedInstance.excecuteNotificationFeedBack(notification: .warning)
        actualTodoDetailState = .present
        addTodoView.setAsFirstResponder()
    }
    
    
}

//MARK: -Header Actions Delegate
extension TodosDetailViewController: HeaderViewDelegate {
    func addActionSelected(_ tag: String) {
        addTodoView.setInitialTagValueWith("\(tag) ")
        addTodoButtonTapped(nil)
    }
    
    func shareActionSelected(_ shareViewController: UIActivityViewController) {
        present(shareViewController, animated: true)
    }
    
}
