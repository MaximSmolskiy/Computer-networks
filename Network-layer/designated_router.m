function designated_router(timeout, routers_number)
    disp('Выделенный маршрутизатор: включён');

    topology = cell([routers_number, 1]);

    routers_count = 0;
    while routers_count < routers_number
        for router_index = 1 : routers_number
            if isempty(topology{router_index}) && labProbe(router_index + 1)
                topology{router_index} = labReceive(router_index + 1);
                disp(['Выделенный маршрутизатор: получены соседи от маршрутизатора ', num2str(router_index)]);
                routers_count = routers_count + 1;
            end
        end
    end

    disp('Выделенный маршрутизатор: построена топология:');
    disp(topology);

    for router_index = 1 : routers_number
        labSend(topology, router_index + 1);
        disp(['Выделенный маршрутизатор: отправлена топология маршрутизатору ', num2str(router_index)]);
    end

    is_router_enabled = true([1, routers_number]);
    topology_tic = tic;
    while true
        for router_index = 1 : routers_number
            if is_router_enabled(router_index) && labProbe(router_index + 1)
                disabled_router_index = labReceive(router_index + 1);
                disp(['Выделенный маршрутизатор: получен недоступный маршрутизатор ', num2str(disabled_router_index), ' от маршрутизатора ', num2str(router_index)]);
                if ~is_router_enabled(disabled_router_index)
                    disp('Выделенный маршрутизатор: топология уже была перестроена');
                else
                    topology_tic = tic;
                    is_router_enabled(disabled_router_index) = false;
                    topology{disabled_router_index} = [];
                    for i = 1 : routers_number
                        if is_router_enabled(i)
                            topology{i}(topology{i} == disabled_router_index) = [];
                        end
                    end
                    disp('Выделенный маршрутизатор: перестроена топология:');
                    disp(topology);
                    for i = 1 : routers_number
                        if is_router_enabled(i)
                            labSend(topology, i + 1);
                            disp(['Выделенный маршрутизатор: отправлена перестроенная топология маршрутизатору ', num2str(i)]);
                        end
                    end
                end
            end
        end
        if toc(topology_tic) >= timeout
            break
        end
    end

    disp('Выделенный маршрутизатор: отключён');

    labBarrier();
    for router_index = 1 : (routers_number + 1)
        if router_index ~= labindex
            while labProbe(router_index)
                labReceive(router_index);
            end
        end
    end
end
