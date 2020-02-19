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
    
    var actualTodoDetailState: TodoState = .discard
    var actualKeyboardState: KeyboardState = .hidden
    
    var _fetchedResultsController: NSFetchedResultsController<Todo>? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.registerForKeyboardEvents()
        
        keyboardHandler.delegate = self
        toolbarView.delegate = self
        todoDatePickerView.delegate = self
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.allowsMultipleSelectionDuringEditing = false
        
        TodoManager.sharedInstance.delegate = self
        
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
        let discardTap = UITapGestureRecognizer(target: self, action: #selector(addTodoBackgroundViewWasSelected))
        addTodoBackgroundView.addGestureRecognizer(discardTap)
        
        detailTableView.register(UINib(nibName: "TodoWithTagAndDateTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DetailTodoCellWithTagIdentifier)
        detailTableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.DetailTodoCellIdentifier)
    }
    
    @IBAction func addTodoButtonTapped(_ sender: UIButton?) {
        actualTodoDetailState = .present
        let animationDuration: TimeInterval = 0.25
        
        addTodoView.todoScheduleDate = nil
        addTodoView.alpha = 0
        addTodoView.isHidden = false
        
        addTodoBackgroundView.alpha = 0
        addTodoBackgroundView.isHidden = false
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.addTodoView.alpha = 1
            self.addTodoBackgroundView.alpha = 0.8
            self.addTodoBottomConstraint.constant = self.view.frame.height * 0.4
            self.view.layoutIfNeeded()
        }) { (_) in
            self.addTodoView.setAsFirstResponder()
        }
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
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        discardActionWasSelected()
    }
    
    @objc func addTodoBackgroundViewWasSelected(){
        discardActionWasSelected()
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
        
        toolbarView.isHidden = false
        toolbarView.alpha = 0
        
        let keyboardSize = notification.keyboardSize
        
        if let keyboardHeight = keyboardSize?.height, let animationDuration = notification.keyboardAnimationDuration {
            UIView.animate(withDuration: animationDuration, animations: {
                self.addTodoBottomConstraint.constant = keyboardHeight + 75.0
                self.toolbarView.alpha = 1
                let bottomSafeInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
                self.toolbarBottomConstraint.constant = keyboardHeight - bottomSafeInset
                self.todoDatePickerBottomConstraint.constant = 0
                self.todoDatePickerView.alpha = 0
                self.view.layoutIfNeeded()
            }) { (_) in
                
            }
        }
        
    }

    func keyboardWillHide(_ notification: Notification) {
        if actualTodoDetailState == .discard {
            UIView.animate(withDuration: 0.25) {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        else if actualTodoDetailState == .schedule {
            let animationDuration = notification.keyboardAnimationDuration ?? 0.25
            UIView.animate(withDuration: animationDuration, animations: {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
                self.todoDatePickerView.alpha = 1
                self.todoDatePickerBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
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
    }
    
    func scheduleActionWasSelected() {
        actualTodoDetailState = .schedule
        
        addTodoView.resignAsFirstResponder()
    }
    
    func discardActionWasSelected() {
        
        actualTodoDetailState = .discard
        let animationDuration: TimeInterval = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.addTodoBottomConstraint.constant = 0
            self.addTodoView.alpha = 0
            self.addTodoBackgroundView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.addTodoView.resignAsFirstResponder()
            self.addTodoView.isHidden = true
        }
        
        addTodoView.resetValues()
    }
    
    
}

// MARK: - Handle View Updates
extension TodosDetailViewController {
    
    enum TodoState {
        case present
        case keyboardHidden
        case discard
        case schedule
    }
    
    enum KeyboardState{
        case hidden
        case presented
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
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        detailTableView.beginUpdates()
    }
//
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//            case .insert:
//                detailTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//            case .delete:
//                detailTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//            default:
//                return
//        }
    }
//
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

//        switch type {
//            case .insert:
//                detailTableView.insertRows(at: [newIndexPath!], with: .fade)
//            case .delete:
//                detailTableView.deleteRows(at: [indexPath!], with: .fade)
//            case .update:
//                return
//            case .move:
//                return
//            default:
//                return
//        }
    }
//
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        detailTableView.endUpdates()
        if let todos = fetchedResultsController.fetchedObjects {
            TodoManager.sharedInstance.todos = todos
        }
    }
}




// MARK: TraitCollection
extension TodosDetailViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection == previousTraitCollection {
            return
        }
        
        updateUIForStyle(style: traitCollection.horizontalSizeClass)
        
    }
}


// MARK: Handle UserInterfaceStyle
extension TodosDetailViewController {
    func updateUIForStyle(style: UIUserInterfaceSizeClass) {
        
        switch style {
            
        case .compact, .unspecified:
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.isTranslucent = true
            navigationItem.setHidesBackButton(true, animated: true)
            
        case .regular:
            navigationItem.titleView = nil
            navigationItem.setHidesBackButton(false, animated: true)
            
        @unknown default:
            break
        }
        
    }
}

//MARK: -Handle TodoManager Delegate
extension TodosDetailViewController: TodoManagerDelegate {
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
    }
    
    func cancelActionWasSelected() {
        addTodoView.todoScheduleDate = nil
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
