//
//  Meal_PlanApp.swift
//  Meal Plan
//
//  Created by Jack Guenther on 3/10/25.
//
import SwiftUI

@main
struct Meal_AppPlan: App {
    @State private var meals = loadMeals()
    var body: some Scene {
        WindowGroup {
            ContentView(meals: meals)
        }
    }
}

#Preview {
    ContentView()
}
   
