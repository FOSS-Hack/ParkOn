import requests

def get_directions(api_key, origin, destination):
    url = 'https://api.olamaps.io/routing/v1/directions'
    params = {
        'origin': f'{origin[0]},{origin[1]}',
        'destination': f'{destination[0]},{destination[1]}',
        'api_key': api_key
    }
    
    headers = {
        'Authorization': f'Bearer {api_key}'
    }
    
    response = requests.post(url, headers=headers, params=params)
    
    if response.status_code == 200:
        return response.json()
    else:
        response.raise_for_status()

def get_closest_destination_by_road(api_key, origin, destinations):
    closest_distance = float('inf')
    closest_destination = None
    
    for destination in destinations:
        directions_response = get_directions(api_key, origin, destination)
        
        if directions_response['status'] == 'SUCCESS':
            route = directions_response['routes'][0]
            leg = route['legs'][0]
            distance = leg['distance']
            duration = leg['duration']
            print(f"Distance to {destination}: {distance / 1000:.2f} km, Duration: {duration / 60:.2f} minutes")
            
            if distance < closest_distance:
                closest_distance = distance
                closest_destination = destination
    
    return closest_destination, closest_distance / 1000


api_key = '1STBbQXttmW177ShozkBLUszWf6FGgimtn5sQa4S'
origin = (12.969400, 80.208381)  
destinations = [
    (12.971961, 80.219393),  
    (12.839568, 80.153549)   
]

closest_destination, closest_distance = get_closest_destination_by_road(api_key, origin, destinations)
print(f"The closest destination by road is {closest_destination} with a distance of {closest_distance:.2f} km.")
