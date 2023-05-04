//
//  ContentModel.swift
//  Learning
//
//  Created by Donizetti de Souza on 4/29/23.
//

import Foundation

class ContentModel: ObservableObject {
    
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
        
        // Parse local included json data
        getLocalData()
        
        // Download remote json file and parse data
        getRemoteData()
        
    }
    
    // MARK: - Data methods
    
    func getLocalData() {
        
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
    
    func beginModule(_ moduleid: Int) { // Seleciona dentro do json o modulo/nome do curso atual
        
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
       
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
    func beginTest(_ moduleId: Int) {
        
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
