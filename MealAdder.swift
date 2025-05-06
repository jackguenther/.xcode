//
//  MealAdder.swift
//  FinalMealPlanApp
//
//  Created by Jack Guenther on 4/21/25.
//


import SwiftUI

struct AddMealView: View {
    @Binding var meals: [Meal]
    @State private var name = ""
    @State private var category = ""
    @State private var description = ""
    @State private var selectedDate = Date()
    @State private var mealTime = "Lunch"
    @Environment(\.presentationMode) var presentationMode
    
    let mealTimes = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    TextField("Meal Name", text: $name)
                    TextField("Category", text: $category)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Date and Time")) {
                    DatePicker("Meal Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.vertical)
                    
                    Picker("Meal Time", selection: $mealTime) {
                        ForEach(mealTimes, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarItems(trailing: Button("Save") {
                let newMeal = Meal(
                    name: name,
                    category: category,
                    image: "placeholder",
                    description: description,
                    isFavorite: false,
                    date: selectedDate,
                    mealTime: mealTime
                )
                meals.append(newMeal)
                saveMeals(mealsToBeSaved: meals)
                presentationMode.wrappedValue.dismiss()
            })
            .navigationTitle("Add Meal")
        }
    }
}
