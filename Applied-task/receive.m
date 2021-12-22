function data = receive(from)
    data = {};
    if labProbe(from)
        data = labReceive(from);
        labSend({}, from);
    end
end
