classdef Ant < handle
    
    properties
        TabuList
        Cities
        Steps
    end
    
    methods
        function ant = Ant(cities)
            if nargin > 0
                ant.TabuList = zeros(length(cities),1);
                ant.Steps = [];
                ant.Cities = cities;
            end
        end
        
        function emptyTabuList(obj)
           obj.TabuList = zeros(length(obj.Cities),1);
        end
        
        function randomStartPosition(obj)
            emptyTabuList(obj);
            r = floor( rand() * length(obj.Cities) ) + 1;
            obj.TabuList(r) = 1;
        end
        
        function backToStartPosition(obj)
            obj.Steps = [];
            obj.TabuList(obj.TabuList~=1) = 0;
        end
        
        function tao = travel(obj, tao, eta, beta, q, rho, gamma, init_tao)
            while obj.notAllVisited()
              tao = obj.nextCity(tao, eta, beta, q, rho, gamma, init_tao);
            end
   
            lastCity = find(obj.TabuList == max(obj.TabuList));
            firstCity = find(obj.TabuList == min(obj.TabuList));
            obj.Steps = [obj.Steps; lastCity, firstCity];
        end
        
        function tao = nextCity(obj, tao, eta, beta, q, rho, gamma, init_tao)
            currentStep = max(obj.TabuList);
            if currentStep == 0
                obj.randomStartPosition();
            end
            
            currentCity = find(obj.TabuList == currentStep);
            notVisitedCity = find(obj.TabuList == 0);
            
            probabilities = tao(currentCity, notVisitedCity) .* (eta(currentCity, notVisitedCity) .^ beta);
            
            sum_p = sum(probabilities);
            if sum_p ~= 0
                probabilities = probabilities ./ sum_p;
            else
                probabilities = ones(length(probabilities), 1) ./ length(probabilities);
            end
            
            qr = rand();
            if qr <= q
                probabilities = tao(currentCity, notVisitedCity) .* (eta(currentCity, notVisitedCity) .^ beta);
                chosenCity = notVisitedCity( probabilities == max(probabilities) );
                chosenCity = chosenCity(1);
                obj.TabuList(chosenCity) = currentStep + 1;
                obj.Steps = [obj.Steps; currentCity, chosenCity];
            else
                %pemilihan sesuai probabilitas
                c = cumsum(probabilities);
                rn = rand();
                cc = c(c >= rn);
                chosenCity = notVisitedCity( c == cc(1) );
                chosenCity = chosenCity(1);
                obj.TabuList(chosenCity) = currentStep + 1;
                obj.Steps = [obj.Steps; currentCity, chosenCity];
            end
            
            %local pheromone
%             delta_tao = gamma * max(tao(currentCity, notVisitedCity));
            delta_tao = init_tao;
            tao(currentCity, chosenCity) = (1 - rho) * tao(currentCity, chosenCity) + rho * delta_tao;
            tao(chosenCity, currentCity) = (1 - rho) * tao(chosenCity, currentCity) + rho * delta_tao;
        end
        
        function r = notAllVisited(obj)
            r = isempty( find( obj.TabuList == 0, 1 ) ) ~= 1;
        end
        
        function tao = globalUpdatePheromones(obj, tao, distances, alpha)
           
            stepDistances = zeros(length(obj.Steps), 1);
            for i = 1 : length(obj.Steps)
               stepDistances(i) = distances(obj.Steps(i,1), obj.Steps(i,2)); 
            end
           
            updateValue = 1 / sum(stepDistances) * alpha;
            
            for i = 1 : length(obj.Steps)
               tao(obj.Steps(i,1), obj.Steps(i,2)) = (1-alpha) * tao(obj.Steps(i,1), obj.Steps(i,2)) + updateValue; 
               tao(obj.Steps(i,2), obj.Steps(i,1)) = (1-alpha) *tao(obj.Steps(i,2), obj.Steps(i,1)) + updateValue; 
            end
        end
    end
end