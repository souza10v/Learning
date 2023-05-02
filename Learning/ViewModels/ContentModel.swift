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
    
    // Current lesson explanation
    @Published var lessonDescription = NSAttributedString()
    var currentDescriptionIndex = 0
    
    var styleData: Data?
    
    
    init() {
        
        getLocalData()
        
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
        lessonDescription = addStyling(currentLesson!.explanation)
    }
    
    
    func nextLesson() {
        
        // Advance a lesson
        currentLessonIndex += 1
        
        // Check that it is with range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(currentLesson!.explanation)
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
