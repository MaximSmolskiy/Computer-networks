function frames_sent_number = go_back_n_sender(frames_to_send_number, sliding_window_size)
    frames_sent_number = 0;
    last_ack_index = 0;
    while last_ack_index < frames_to_send_number
        first_frame_to_send_index = last_ack_index + 1;
        last_frame_to_send_index = min(frames_to_send_number, first_frame_to_send_index + sliding_window_size - 1);
        queue = first_frame_to_send_index : last_frame_to_send_index;
        frames_sent_number = frames_sent_number + length(queue);
        labSend(queue, 2);
        last_ack_index = labReceive(2);
    end
    labSend([], 2);
end
