function distance = heuristic( cities, distances) 
    step = 1;
    history = zeros(size(cities,1),1);
    history(1) = step;
    distance = 0;
    
    while ~isempty( history(history == 0) )
        notVisitedCity = find(history == 0);
        currentCity = find(history == step);
        notVisitedDist = distances(currentCity, notVisitedCity);
        min_distance = min( notVisitedDist  );
        chosenCity = notVisitedCity(notVisitedDist == min_distance);
        chosenCity = chosenCity(1);
        step = step + 1;
        history(chosenCity) = step;
        distance = distance + min_distance;
    end
    currentCity = find(history == step);
    distance = distance + distances(currentCity,1);
end

