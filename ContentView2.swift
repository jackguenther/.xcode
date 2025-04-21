//
//  ContentView.swift
//  Meal Plan
//
//  Created by Jack Guenther on 3/10/25.
//
import SwiftUI

struct Meal: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var image: String
    var description: String
    var isFavorite: Bool
}

func loadMeals() -> [Meal] {
    if let savedData = UserDefaults.standard.data(forKey: "savedMeals") {
        if let decoded = try? JSONDecoder().decode([Meal].self, from: savedData) {
            return decoded
        }
    }
    return [
        Meal(name: "Grilled Chicken Salad", category: "Lunch", image: "salad", description: "A healthy and light grilled chicken salad with fresh greens and vinaigrette.", isFavorite: false),
        Meal(name: "Spaghetti Bolognese", category: "Dinner", image: "spaghetti", description: "Classic Italian pasta dish with rich, meaty tomato sauce.", isFavorite: false),
        Meal(name: "Omelette", category: "Breakfast", image: "omelette", description: "Fluffy omelette with cheese and peppers, perfect for a protein-packed breakfast.", isFavorite: false),
        Meal(name: "Tacos", category: "Dinner", image: "tacos", description: "Spicy and flavorful tacos with seasoned meat and fresh toppings.", isFavorite: false),
        Meal(name: "Pancakes", category: "Breakfast", image: "pancakes", description: "Soft and fluffy pancakes served with syrup and fresh berries.", isFavorite: false),
        Meal(name: "Grilled Salmon", category: "Dinner", image: "salmon", description: "A delicious and healthy grilled salmon fillet served with steamed vegetables.", isFavorite: false),
        Meal(name: "Caesar Salad", category: "Lunch", image: "caesar_salad", description: "Crispy romaine lettuce with creamy caesar dressing, croutons, and parmesan cheese.", isFavorite: false)
    ]
}

func saveMeals(mealsToBeSaved: [Meal]) {
    if let encoded = try? JSONEncoder().encode(mealsToBeSaved) {
        UserDefaults.standard.set(encoded, forKey: "savedMeals")
    }
}

struct ContentView: View {
    @State var meals = loadMeals()
    @State private var newMealName = ""
    @State private var newMealCategory = ""
    @State private var newMealDescription = ""
    @State private var showAddMealView = false
    @State private var searchText = ""
    
    var filteredMeals: [Meal] {
        if searchText.isEmpty {
            return meals
        } else {
            return meals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Meal Planner")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Search Meals", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List(filteredMeals.indices, id: \ .self) { index in
                    NavigationLink(destination: SwiftUIView(selectedMeal: $meals[index])) {
                        HStack {
                            Image(meals[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 100)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(meals[index].name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text(meals[index].category)
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Meal Planner")
                
                Button("Add Meal") {
                    showAddMealView.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .sheet(isPresented: $showAddMealView) {
                    AddMealView(meals: $meals)
                }
            }
        }
    }
}

struct AddMealView: View {
    @Binding var meals: [Meal]
    @State private var name = ""
    @State private var category = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Details")) {
                    TextField("Meal Name", text: $name)
                    TextField("Category", text: $category)
                    TextField("description", text: $description)
                }
            }
            .navigationBarItems(trailing: Button("Save") {
                let newMeal = Meal(name: name, category: category, image: "default", description: description, isFavorite: false)
                meals.append(newMeal)
                saveMeals(mealsToBeSaved: meals)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
