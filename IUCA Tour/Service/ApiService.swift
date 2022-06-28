//
//  ApiService.swift
//  IUCA Tour
//
//  Created by User on 2/17/22.
//

import Foundation

class ApiService {
    
    static let shared = ApiService()
    
    private var baseURL = "http://tour.iuca.kg/api/place/1/?lang=RUS"
    
    func fetchPlaceOfTour(idOfPlace: Int, language: String, completion: @escaping(Place) -> Void) {
        
        baseURL = "http://tour.iuca.kg/api/place/\(idOfPlace)/?lang=\(language.uppercased())"
        
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error is \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let place = try JSONDecoder().decode(Place.self, from: data)
                
                completion(place)
                
            } catch let error {
                print("Failed to create json with error", error.localizedDescription)
            }
        }.resume()
        
    }
    
    
    func fetchPresetOfTour(idOfPreset: Int,  completion: @escaping(Preset) -> Void) {
        baseURL = "http://tour.iuca.kg/api/preset/\(idOfPreset)/"
        
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error is \(error.localizedDescription)")
                
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let preset = try JSONDecoder().decode(Preset.self, from: data)
                
                completion(preset)
                
            } catch let error {
                print("Failed to create json with error", error.localizedDescription)
            }
        }.resume()
        
    }
    
    func fetchPlacesOfTour(language: String, completion: @escaping([Place]) -> Void) {
        baseURL = "http://tour.iuca.kg/api/place/?lang=\(language.uppercased())"
        
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error is \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let preset = try JSONDecoder().decode([Place].self, from: data)
                
                completion(preset)
                
            } catch let error {
                print("Failed to create json with error", error.localizedDescription)
            }
        }.resume()
        
    }
    
    
}
