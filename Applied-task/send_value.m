function send_value(m, previous_commander, commander, lieutenant)
    send({'send_value', m, previous_commander, lieutenant}, commander);
end
