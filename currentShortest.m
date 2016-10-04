function [steps, distance, stdDistances, shortestAnt] = currentShortest( ants, distances )
    
    stepDistances = zeros( length(distances), length(ants) );
   
    for i = 1 : length(ants)
        for j = 1 : length(ants(i).Steps)
           stepDistances(j, i) = distances(ants(i).Steps(j,1), ants(i).Steps(j,2)); 
        end 
    end
    
    totalDistances = sum(stepDistances);
    stdDistances = mean(totalDistances);
    distance = min(totalDistances);
    
    shortestAnt = find( totalDistances == distance );
    shortestAnt = shortestAnt(1);
    
    steps = ants(shortestAnt).Steps;
end

