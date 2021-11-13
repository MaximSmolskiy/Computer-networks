function go_back_n_receiver(transmission_error_probability)
    last_ack_index = 0;
    while true
        queue = labReceive(1);
        if isempty(queue)
            break;
        end
        for frame_index = queue
            if frame_index == last_ack_index + 1 && rand() > transmission_error_probability
                last_ack_index = last_ack_index + 1;
            else
                break;
            end
        end
        labSend(last_ack_index, 1);
    end
end
