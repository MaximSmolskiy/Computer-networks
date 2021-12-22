function OM(m, previous_commander, commander, lieutenants)
    for lieutenant = lieutenants
        send_value(m, previous_commander, commander, lieutenant);
    end
    if m > 0
        for i = lieutenants
            OM(m - 1, commander, i, setdiff(lieutenants, i));
        end
        for i = lieutenants
            use_value(m, commander, i);
        end
    end
end
