import SwiftUI
import MapKit

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
    let trail: String
}

let data = [
    Item(name: "Ringtail Ridge Natural Area", neighborhood: "San Marcos", desc: "Less than 3 miles. Includes dirt, man-made, and rocky trails. With many prickly pears and a pond.", lat: 29.903501281027275, long: -97.96820722571542, imageName: "ridge_dirt_1", trail: "running"),
    Item(name: "Pugatory Creek Natural Area", neighborhood: "San Marcos", desc: "Upper and lower purgatory nearby the highway extend to 5 miles of hills and flat trails.", lat: 29.87758507735378, long: -97.97883308499719, imageName: "pugatory_bridge", trail: "walking"),
    Item(name: "Schulle Canyon Natural Area", neighborhood: "San Marcos", desc: "Quick 2 mile dirt trails in a loop, many wildlife.", lat: 29.894234904392146, long: -97.95523005640366, imageName: "schuelle-trail-1", trail: "walking"),
    Item(name: "5 Mile Dam Park", neighborhood: "San Marcos", desc: "Nearby a soccer field.", lat: 29.941628328544372, long: -97.90077384343863, imageName: "5mile", trail: "running"),
    Item(name: "Spring Lake Natural Area", neighborhood: "San Marcos", desc: ".5 miles of dirt trail surrounded by forest.", lat:29.902010387797482, long: -97.93982880851942, imageName: "springlake-dirt", trail: "running"),
    Item(name: "Prospect Park Trail Head", neighborhood: "San Marcos", desc: "3 miles of trails, man-made trails for running and dirt trails alongside vast areas of empty grassland.", lat: 29.874371316719873, long: -97.96341687442195, imageName: "prospect-pebbles", trail: "walking")
]

struct ContentView: View {
    @State private var searchText = ""
    @State private var selectedTrailType = "All" // New state for selected trail type
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.902010387797482, longitude:  -97.93982880851942), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    
    var filteredItems: [Item] {
        if searchText.isEmpty && selectedTrailType == "All" {
            return data
        } else {
            return data.filter { item in
                (searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)) &&
                (selectedTrailType == "All" || item.trail == selectedTrailType)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search TextField
                TextField("Search", text: $searchText)
                    .padding()
                
                // Trail Type Picker
                Picker("Trail Type", selection: $selectedTrailType) {
                    Text("All").tag("All")
                    Text("Running").tag("running")
                    Text("Walking").tag("walking")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // List of filtered items
                List(filteredItems) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        ItemRow(item: item)
                    }
                }
                Map(coordinateRegion: $region, annotationItems: data) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                         .font(.title)
                         .overlay(
                         Text(item.name)
                             .font(.subheadline)
                             .foregroundColor(.black)
                             .fixedSize(horizontal: true, vertical: false)
                             .offset(y: 25)
                        )
                        }
                } // end map
                .frame(height: 300)
                .padding(.bottom, -30)
            }
            .navigationTitle("Trails")
        }
    }
}

struct ItemRow: View {
    let item: Item
    
    var body: some View {
        HStack {
            Image(item.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.neighborhood)
                    .font(.subheadline)
            }
        }
    }
}

struct DetailView: View {
    let item: Item
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200)
            Text("Neighborhood: \(item.neighborhood)")
                .font(.subheadline)
            Text("Description: \(item.desc)")
                .font(.subheadline)
                .padding(10)
            MapView(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long))
                .frame(height: 300)
        }
        .navigationTitle(item.name)
    }
}

struct MapView: View {
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))))
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


