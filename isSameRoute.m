function isSameRoute = isSameRoute( ants )
    isSameRoute = 1;
  
    route = ants(1).TabuList;
    
    for i = 2:length(ants)
       route2 = ants(i).TabuList;
       idx = find(route2 == route(1));
       route2 = [route2(idx:end); route2(1:idx-1)];
        if isequal(route, route2) == 0
           isSameRoute = 0;
           break
        end

    end

end

