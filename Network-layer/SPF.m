function p = SPF(G, a)
    n = size(G, 1);
    d(a) = 0;
    p = cell([n, 1]);
    p{a} = [];
    V = 1 : n;
    for u = V
        if u ~= a
            d(u) = Inf;
        end
    end
    U = [];
    while length(U) < n
        V_diff_U = setdiff(V, U);
        [~, i] = min(d(V_diff_U));
        v = V_diff_U(i);
        U = [U, v];
        for u = G{v}
            if d(u) > d(v) + 1
                d(u) = d(v) + 1;
                p{u} = [p{v}, u];
            end
        end
    end
end
