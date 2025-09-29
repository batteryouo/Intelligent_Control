function [fitness] = psoRGAFitFunction(particle)
    global Kp Ki Kd t y;

    particleSize = size(particle, 1);
    fitness = zeros(particleSize, 1);

    settlingTime = 2;
    settling_rate = 0.02;
    overshoot_tolerance = 0.2;
    risingTime_tolerance = 1;

    for i = 1:particleSize
        Kp = particle(i, 1, 1);
        Ki = particle(i, 1, 2);
        Kd = particle(i, 1, 3);

        sim("pso_rga_PID");

        settling_time = 2;
        settling_percent = 0.02;
        overshoot = 0.2;
        
        minus_score = 0;
    
        time_range = find(t>settling_time);
        minus_score = minus_score - sum(abs(5*(1-y(time_range))));
        
        if max(y(time_range)) < 1*(1+settling_percent) && min(y(time_range)) > 1*(1-settling_percent)
            minus_score = minus_score + 9000;
        elseif max(y(time_range)) > 1*(1+settling_percent) && min(y(time_range)) > 1*(1-settling_percent)
            minus_score = minus_score + 3000;
        elseif max(y(time_range)) < 1*(1+settling_percent) && min(y(time_range)) < 1*(1-settling_percent)
            minus_score = minus_score + 3000;
        elseif max(y(time_range)) > 1*(1+settling_percent) && min(y(time_range)) < 1*(1-settling_percent)
            minus_score = minus_score - 9000;
        end
        
        if max(y) < 1*(1+overshoot) && max(y) > 1*(1-overshoot)
            minus_score = minus_score + 5000;
        else
            minus_score = minus_score - 5000;
        end

        fitness(i) = minus_score;
        
    end

end