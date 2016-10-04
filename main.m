function main(cities, alpha, beta, rho, q, ant_quantity, max_cycle, init_tao, gamma, hObject, handles)
    %euclidean distance antar kota (kota i,j)
    distances = round( squareform(pdist(cities)) );
    eta = 1 ./ distances;
    
    scatter(cities(:,1), cities(:,2), 'parent', handles.axes8);
    guidata(hObject, handles);
    drawnow;
    
    rng('shuffle');

    %inisialisasi tao kota i,j
    tao = eye(length(cities));
    tao(tao~=1) = init_tao;
    tao(tao==1) = 0;


    ants(ant_quantity,1) = Ant(cities);
    for i = 1 : length(ants)
        ants(i) = Ant(cities);
        % random ant
        % ants(i).randomStartPosition();
        % sebar ant di masing - masing kota
        ants(i).TabuList( mod(i-1,length(cities))+1 ) = 1;
    end

    distance = intmax;
    distance_ = intmax;
    steps = [];
    best_distances = zeros(max_cycle, 1);
    result_distances = zeros(max_cycle, 1);

    cycle = 1;
    while cycle <= max_cycle
        fl = get(handles.chkFinishNow, 'Value');
        if fl == 0
            break
        end
        for i = 1 : length(ants)
           tao = ants(i).travel(tao, eta, beta, q, rho, gamma, init_tao);
        end

        [steps_, distance_, stdDistances, shortestAnt] = currentShortest(ants, distances);
        if distance_ <= distance
           distance = distance_;
           steps = steps_;
        end
                
        tao = ants(shortestAnt).globalUpdatePheromones(tao, distances, alpha);
        
        fprintf('cycle: %d/%d, current shortest distance: %f, current distance: %f\n', cycle, max_cycle, distance, distance_);

        best_distances(cycle) = distance;
        result_distances(cycle) = stdDistances;

        if mod(cycle, 10) == 0
            cla;
            
            plot(1:cycle, best_distances(1:cycle), 'parent', handles.axes1);
            axis([0 cycle min(best_distances(best_distances > 0))-100 max(best_distances(2:end))+100]);
            guidata(hObject, handles);
            
    
            plot(1:cycle, result_distances(1:cycle), 'parent', handles.axes6);
            axis([0 cycle min(result_distances(result_distances > 0))-100 max(result_distances(2:end))+100]);
            guidata(hObject, handles);
            
            set( handles.text11,'string', sprintf('best distance:%d',distance));
            
            hold on;
            scatter(cities(:,1), cities(:,2), 'parent', handles.axes8);
            line( cities(steps(:,1),1), cities(steps(:,1), 2) );
            axis([0 max(cities(:,1)) 0 max(cities(:,2))]);
            guidata(hObject, handles);
            hold off;
            drawnow;
            
        end

        if isSameRoute(ants)
            disp('same route');
            break
        end

        for i = 1 : length(ants)
           ants(i).backToStartPosition();
        end

        cycle = cycle + 1;
    end

    plot(1:cycle, best_distances(1:cycle), 'parent', handles.axes1);
    axis([0 cycle min(best_distances(best_distances > 0))-100 max(best_distances(2:end))+100]);
    guidata(hObject, handles);

    handles = guidata(hObject);
    plot(1:cycle, result_distances(1:cycle), 'parent', handles.axes6);
    axis([0 cycle min(result_distances(result_distances > 0))-100 max(result_distances(2:end))+100]);
    guidata(hObject, handles);

    set( handles.text11,'string', sprintf('best distance:%d',distance));

    drawnow;
    disp(steps);
    disp(distance);
end
