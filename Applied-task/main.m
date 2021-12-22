timeout = 1;

m = 1;
n = 4;

c = parcluster();
c.NumWorkers = n + 1;
saveProfile(c);

parpool(n + 1);

disp('Лейтенант 3 - предатель');

loyalty = ones([1, n]);
loyalty(end) = 2;

spmd
    if labindex <= n
        general(timeout, n, loyalty(labindex));
    elseif labindex == n + 1
        OM(m, -1, 1, 2 : n);
    end
end

disp('Командир - предатель');

loyalty = ones([1, n]);
loyalty(1) = 2;

spmd
    if labindex <= n
        general(timeout, n, loyalty(labindex));
    elseif labindex == n + 1
        OM(m, -1, 1, 2 : n);
    end
end

delete(gcp('nocreate'));
