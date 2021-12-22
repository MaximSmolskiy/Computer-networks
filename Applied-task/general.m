function general(timeout, n, loyalty)
    start = tic;
    while toc(start) < timeout
        data = receive(n + 1);
        if ~isempty(data)
            type = data{1};
            if strcmp(type, 'send_value')
                [~, m, previous_commander, lieutenant] = data{:};
                value = loyalty;
                if previous_commander ~= -1
                    value = values(m + 2, previous_commander);
                end
                send({m, value}, lieutenant);
            elseif strcmp(type, 'use_value')
                [~, m, commander] = data{:};
                v = values(m + 1, commander);
                v = [v, nonzeros(values(m, :))'];
                values(m + 1, commander) = majority(v);
                values(m, :) = zeros([1, length(values(m, :))]);
            end
            start = tic;
        end
        for commander = setdiff(1 : n, labindex)
            data = receive(commander);
            if ~isempty(data)
                [m, value] = data{:};
                if loyalty == 2
                    value = loyalty;
                end
                values(m + 1, commander) = value;
                start = tic;
            end
        end
    end
    if labindex > 1
        disp(['Лейтенант ', num2str(labindex - 1), ' использует значение ', num2str(values(end, 1))]);
    end
end
