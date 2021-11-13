function frames_sent_number = selective_repeat_sender(frames_to_send_number, sliding_window_size)
    frames_sent_number = 0;
    non_ack_indices = [];
    first_frame_to_send_index = 1;
    while ~isempty(non_ack_indices) || first_frame_to_send_index <= frames_to_send_number
        last_frame_to_send_index = min(frames_to_send_number, first_frame_to_send_index + sliding_window_size - 1 - length(non_ack_indices));
        queue = [non_ack_indices, first_frame_to_send_index : last_frame_to_send_index];
        frames_sent_number = frames_sent_number + length(queue);
        labSend(queue, 2);
        non_ack_indices = labReceive(2);
        first_frame_to_send_index = last_frame_to_send_index + 1;
    end
    labSend([], 2);
end
