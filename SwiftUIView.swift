//
//  SwiftUIView.swift
//  FinalMealPlanApp
//
//  Created by Jack Guenther on 4/21/25.
//

import SwiftUI

struct MealDetailView: View {
    @Binding var meal: Meal
    @Binding var meals: [Meal]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(meal.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(15)
                
                Text(meal.name)
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Category: \(meal.category)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Meal Time: \(meal.mealTime)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            Text(formattedDate(meal.date))
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 2)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                Text(meal.description)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
                    
                
                Button(action: {
                    meal.isFavorite.toggle()
                    
                    // Update in the main array
                    if let idx = meals.firstIndex(where: { $0.id == meal.id }) {
                        meals[idx].isFavorite = meal.isFavorite
                        saveMeals(mealsToBeSaved: meals)
                    }
                }, label: {
                    HStack {
                        Image(systemName: meal.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(meal.isFavorite ? .red : .gray)
                        Text(meal.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                
           ) }
            .padding()
        }
        .navigationTitle(meal.name)
    }
    
  
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
