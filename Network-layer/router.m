function router(timeout, neighbors)
    disp(['Маршрутизатор ', num2str(labindex - 1), ': включён']);
    
    labSend(neighbors, 1);

    disp(['Маршрутизатор ', num2str(labindex - 1), ': отправлены соседи выделенному маршрутизатору']);

    while ~labProbe(1)
    end

    topology = labReceive(1);
    routers_number = size(topology, 1);

    disp(['Маршрутизатор ', num2str(labindex - 1), ': получена топология']);

    optimal_routes = SPF(topology, labindex - 1);

    disp(['Маршрутизатор ', num2str(labindex - 1), ': построены оптимальные маршруты:']);
    disp(optimal_routes);

    neighbors_tics = zeros([1, length(neighbors)], 'uint64');
    for neighbor_index = 1 : length(neighbors)
        neighbors_tics(neighbor_index) = tic;
    end
    
    for k = 1 : 10 ^ (routers_number + 1)
        neighbor_index = 1;
        while neighbor_index <= length(neighbors)
            neighbor = neighbors(neighbor_index);
            if labProbe(neighbor + 1)
                labReceive(neighbor + 1);
                neighbors_tics(neighbor_index) = tic;
            elseif toc(neighbors_tics(neighbor_index)) >= timeout
                disp(['Маршрутизатор ', num2str(labindex - 1), ': маршрутизатор ', num2str(neighbor), ' недоступен']);
                neighbors(neighbor_index) = [];
                neighbors_tics(neighbor_index) = [];
                neighbor_index = neighbor_index - 1;
                labSend(neighbor, 1);
                disp(['Маршрутизатор ', num2str(labindex - 1), ': отправлен недоступный маршрутизатор ', num2str(neighbor), ' выделенному маршрутизатору']);
            end
            neighbor_index = neighbor_index + 1;
        end
        if labProbe(1)
            topology = labReceive(1);
            disp(['Маршрутизатор ', num2str(labindex - 1), ': получена перестроенная топология']);

            optimal_routes = SPF(topology, labindex - 1);

            disp(['Маршрутизатор ', num2str(labindex - 1), ': перестроены оптимальные маршруты:']);
            disp(optimal_routes);
        end
    end

    disp(['Маршрутизатор ', num2str(labindex - 1), ': отключён']);

    labBarrier();
    for router_index = 1 : (routers_number + 1)
        if router_index ~= labindex
            while labProbe(router_index)
                labReceive(router_index);
            end
        end
    end
end
