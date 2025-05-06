//
//  ContentView.swift
//  FinalMealPlanApp
//
//  Created by Jack Guenther on 4/21/25.
//

import SwiftUI

struct Meal: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var image: String
    var description: String
    var isFavorite: Bool
    var date: Date
    var mealTime: String
}


func loadMeals() -> [Meal] {
    if let savedData = UserDefaults.standard.data(forKey: "savedMeals") {
        if let decoded = try? JSONDecoder().decode([Meal].self, from: savedData) {
            return decoded
        }
    }
    return [
        Meal(name: "Grilled Chicken Salad", category: "Lunch", image: "salad", description: "A healthy and light grilled chicken salad with fresh greens and vinaigrette.", isFavorite: false, date: Date(), mealTime: "Lunch"),
        Meal(name: "Spaghetti Bolognese", category: "Dinner", image: "spaghetti", description: "Classic Italian pasta dish with rich, meaty tomato sauce.", isFavorite: false, date: Date().addingTimeInterval(86400), mealTime: "Dinner"),
        Meal(name: "Omelette", category: "Breakfast", image: "omelette", description: "Fluffy omelette with cheese and peppers, perfect for a protein-packed breakfast.", isFavorite: false, date: Date().addingTimeInterval(-86400), mealTime: "Breakfast"),
        Meal(name: "Tacos", category: "Dinner", image: "tacos", description: "Spicy and flavorful tacos with seasoned meat and fresh toppings.", isFavorite: false, date: Date().addingTimeInterval(172800), mealTime: "Dinner"),
        Meal(name: "Pancakes", category: "Breakfast", image: "pancakes", description: "Soft and fluffy pancakes served with syrup and fresh berries.", isFavorite: false, date: Date(), mealTime: "Breakfast")
    ]
}

func saveMeals(mealsToBeSaved: [Meal]) {
    if let encoded = try? JSONEncoder().encode(mealsToBeSaved) {
        UserDefaults.standard.set(encoded, forKey: "savedMeals")
    }
}

struct ContentView: View {
    @State private var meals = loadMeals()
    @State private var showAddMealView = false
    @State private var searchText = ""
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var filterByDate = false

    
    
    var filteredMeals: [Meal] {
        var result = meals
        
     
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
       
        if filterByDate {
            let calendar = Calendar.current
            result = result.filter {
                calendar.isDate($0.date, inSameDayAs: selectedDate)
            }
        }
        
      
        return result.sorted {
            if calendar.isDate($0.date, inSameDayAs: $1.date) {
                let mealTimes = ["Breakfast", "Lunch", "Dinner", "Snack"]
                let time0Index = mealTimes.firstIndex(of: $0.mealTime) ?? 0
                let time1Index = mealTimes.firstIndex(of: $1.mealTime) ?? 0
                return time0Index < time1Index
            }
            return $0.date < $1.date
        }
    }
    
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Meal Planner")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                HStack {
                    TextField("Search Meals", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        showDatePicker.toggle()
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(filterByDate ? .blue : .gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                if showDatePicker {
                    VStack {
                        DatePicker("Filter by date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(height: 300)
                            .padding()
                        
                        HStack {
                            Toggle("Filter by this date", isOn: $filterByDate)
                                .padding(.horizontal)
                            
                            Button("Close") {
                                showDatePicker = false
                            }
                            .padding(.trailing)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
                
                if filterByDate {
                    Text("Showing meals for \(formattedDateOnly(selectedDate))")
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)
                }
                
                List {
                    ForEach(filteredMeals.indices, id: \.self) { index in
                        NavigationLink(
                            destination: MealDetailView(meal: binding(for: filteredMeals[index]), meals: $meals)
                        ) {
                            HStack {
                                Image(filteredMeals[index].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 100)
                                    .cornerRadius(10)

                                VStack(alignment: .leading) {
                                    Text(filteredMeals[index].name)
                                        .font(.title3)
                                        .fontWeight(.semibold)

                                    Text(filteredMeals[index].category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Text(filteredMeals[index].mealTime)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(mealTimeColor(filteredMeals[index].mealTime).opacity(0.2))
                                            .cornerRadius(5)
                                        
                                        Text(formattedDate(filteredMeals[index].date))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                                
                                if filteredMeals[index].isFavorite {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Button("Add Meal") {
                    showAddMealView.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom)
                .sheet(isPresented: $showAddMealView) {
                    AddMealView(meals: $meals)
                }
            }
            .navigationTitle("Meal Planner")
        }
    }
    

    private func mealTimeColor(_ mealTime: String) -> Color {
        switch mealTime {
        case "Breakfast": return .orange
        case "Lunch": return .green
        case "Dinner": return .blue
        default: return .purple // Snack
        }
    }

 
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
  
    private func formattedDateOnly(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }


    private func binding(for meal: Meal) -> Binding<Meal> {
        guard let index = meals.firstIndex(where: { $0.id == meal.id }) else {
            fatalError("Meal not found")
        }
        return $meals[index]
    }
}
