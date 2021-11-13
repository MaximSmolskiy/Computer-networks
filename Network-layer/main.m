designated_router_timeout = 0.1;
router_timeout = 0.01;
routers_number = 5;

c = parcluster();
c.NumWorkers = routers_number + 1;
saveProfile(c);

parpool(routers_number + 1);

disp('Линейная топология');

neighbors = cell([routers_number, 1]);
neighbors{1} = 2;
neighbors{2} = [1, 3];
neighbors{3} = [2, 4];
neighbors{4} = [3, 5];
neighbors{5} = 4;

spmd
    if labindex == 1
        designated_router(designated_router_timeout, routers_number);
    elseif labindex > 1
        router(router_timeout, neighbors{labindex - 1});
    end
end

disp('Кольцо');

neighbors = cell([routers_number, 1]);
neighbors{1} = [5, 2];
neighbors{2} = [1, 3];
neighbors{3} = [2, 4];
neighbors{4} = [3, 5];
neighbors{5} = [4, 1];

spmd
    if labindex == 1
        designated_router(designated_router_timeout, routers_number);
    elseif labindex > 1
        router(router_timeout, neighbors{labindex - 1});
    end
end

disp('Звезда');

neighbors = cell([routers_number, 1]);
neighbors{1} = [2, 3, 4, 5];
neighbors{2} = 1;
neighbors{3} = 1;
neighbors{4} = 1;
neighbors{5} = 1;

spmd
    if labindex == 1
        designated_router(designated_router_timeout, routers_number);
    elseif labindex > 1
        router(router_timeout, neighbors{labindex - 1});
    end
end

delete(gcp('nocreate'));
