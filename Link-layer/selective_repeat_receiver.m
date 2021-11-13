function non_ack_indices = selective_repeat_receiver(transmission_error_probability)
    while true
        queue = labReceive(1);
        if isempty(queue)
            break;
        end
        non_ack_indices = [];
        for frame_index = queue
            if rand() <= transmission_error_probability
                non_ack_indices = [non_ack_indices, frame_index];
            end
        end
        labSend(non_ack_indices, 1);
    end
end
