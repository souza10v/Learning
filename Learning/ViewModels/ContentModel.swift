//
//  ContentModel.swift
//  Learning
//
//  Created by Donizetti de Souza on 4/29/23.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject {
    
    // Authentication
    @Published var loggedIn = false
    
    // Reference to Cloud Firestore database
    let db = Firestore.firestore()
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    init() {
        
    }
    
    // MARK: - Authentication methods
    
    func checkLogin() {
        
        // Check if there`s a current user to determine logged in status
        loggedIn = Auth.auth().currentUser != nil ? true : false
    }
    
    // MARK: - Data methods
    
    func getLessons(module: Module, completion: @escaping () -> Void) { //completion: @escaping () -> Void Usado para executar outro comenado somente quando este concluido
            
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to track lessons
                var lessonsInside = [Lesson]()
                
                // Loop through the documents and build array of lessons
                for doc in snapshot!.documents{
                    
                    // New lesson
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add lesson to the array
                    lessonsInside.append(l)
                    
                }
                
                // Setting the lessons to the module
                // modules.content.lessons = lessons // if the model was a class it would be possible do it. As it not this is the way:
                
                // Loop through publised modules array and find the one that matches the id of the copy that got passed in
                for (index, m) in self.modules.enumerated() {
                    
                    //Find the module we want
                    if m.id == module.id {
                        
                        // Set the lessons
                        self.modules[index].content.lessons = lessonsInside
                        
                        // Call the completion closure
                        completion()
                    }
                }
            }
        }
    }
    
    func getQuestion(module: Module, completion: @escaping () -> Void) {
        
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to track lessons
                var questionsInside = [Question]()
                
                // Loop through the documents and build array of lessons
                for doc in snapshot!.documents{
                    
                    // New lesson
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? [String]()
                    
                    // Add lesson to the array
                    questionsInside.append(q)
                    
                }
            
                for (index, m) in self.modules.enumerated() {
                    
                    //Find the module we want
                    if m.id == module.id {
                        
                        // Set the lessons
                        self.modules[index].test.questions = questionsInside
                        
                        // Call the completion closure
                        completion()
                    }
                }
            }
        }
    }
    
    func getDatabaseData() {
        
        // Parse local included json data
        getLocalStyles()
        
        // Specify path
        let collection = db.collection("modules")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Create an array for the modules
                var modulesInside = [Module]()
                
                // Loop through the documents returned
                for doc in snapshot!.documents {
                    
                    // Create a new module instance
                    var m = Module()
                    
                    // Parse out the values from the document into the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.image = contentMap["time"] as? String ?? ""
                    
                    // Parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    // Add it to our array
                    modulesInside.append(m)
                }
                
                //Assign our modules to the published property
                DispatchQueue.main.async {
                    
                    self.modules = modulesInside
                    
                }
            }
        }
    }
    
    func getLocalStyles() {
        /*
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            
            try modules = jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
            
        }
        catch {
            // Todo log error
            print("Couln`t parse local data")
        }
        */
        // Parse the style data
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            //Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
            
        }
        
        catch {
            
            print("Couln`t parse style data")
            
        }
    }
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://souza10v.github.io/app-data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn`t create url
            return
        }
        
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) {(data, response, error) in
            
            // Check if there is an error
            guard error == nil else {
                // There was an error
                return
            }
            
            do {
                
                // Create json decoder
                let decoder = JSONDecoder()
                
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into property
                self.modules += modules 
                
            }
            catch {
            }
        }
        
        // Kick off data task
        dataTask.resume()
        
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid: String) { // Seleciona dentro do json o modulo/nome do curso atual
        
        // Find the index for this module id
        
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
                
                // Found the matching module
                currentModuleIndex = index
            }
        }
        
        // Set the current module
        
        currentModule = modules[currentModuleIndex] // Verifica todos modulos, e salva os modulo atual selecionado
    }
    
    func beginLesson(_ lessonIndex: Int) { // Seleciona dentro do modulo/nome a lesson atual
        
        // Check the lessons index is with range of module lesson
        
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex] // Conforme o modulo selecionado anteriormente, seleciona a lesson
        codeText = addStyling(currentLesson!.explanation)
    }
    
    
    func nextLesson() {
        
        // Advance a lesson
        currentLessonIndex += 1
        
        // Check that it is with range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    
    func hasNextLesson() -> Bool {
       
        guard currentModule != nil else {
            return false
        }
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
    func beginTest(_ moduleId: String) {
        
        // Set the current module
        beginModule(moduleId)
        
        //Set the current question index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)  
        }
    }
    
    func nextQuestion () {
    
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check thatit`s within the rangae question
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else {
        // If not, reset the state
            currentQuestionIndex = 0
            currentQuestion = nil
        }   
    }
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        return resultString
    }
}
