frames_to_send_number = 85;
sliding_window_size = 3;

go_back_n_frames_sent_numbers = [];
selective_repeat_frames_sent_numbers = [];
transmission_error_probabilities = 0:0.001:0.999;
parpool(2);
for transmission_error_probability = transmission_error_probabilities
    spmd
        if labindex == 1
            go_back_n_frames_sent_number = go_back_n_sender(frames_to_send_number, sliding_window_size);
        elseif labindex == 2
            rng('default');
            go_back_n_receiver(transmission_error_probability);
        end
    end
    go_back_n_frames_sent_numbers = [go_back_n_frames_sent_numbers, go_back_n_frames_sent_number{1}];

    spmd
        if labindex == 1
            selective_repeat_frames_sent_number = selective_repeat_sender(frames_to_send_number, sliding_window_size);
        elseif labindex == 2
            rng('default');
            selective_repeat_receiver(transmission_error_probability);
        end
    end
    selective_repeat_frames_sent_numbers = [selective_repeat_frames_sent_numbers, selective_repeat_frames_sent_number{1}];
end
delete(gcp('nocreate'));

plot(transmission_error_probabilities, frames_to_send_number ./ go_back_n_frames_sent_numbers);
grid on;
hold on;
plot(transmission_error_probabilities, frames_to_send_number ./ selective_repeat_frames_sent_numbers);
title('Меры эффективности E при FTSN = 85 и w = 3');
xlabel('Вероятность ошибки передачи p');
ylabel('Мера эффективности E');
legend('Go-Back-N', 'Selective Repeat');
