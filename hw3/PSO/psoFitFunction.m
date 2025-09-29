function [fitness] = psoFitFunction(particle)
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

        sim("psoPID");
        %{
        e = y - 1;
        idx = find(abs(e) > 1*settling_rate, 1, 'last');
        if isempty(idx)
            ts = 0;
        else
            ts = t(idx);
        end
        Ess = abs(e( end ));
        Mp = max( e );
        
        tr = t( find(y > 1*0.9, 1, "first") ) - t( find(y > 1*0.1, 1, "first") );
        if isempty(tr)
            tr = t(end);
        end
        
        penalty = 0;
        if Mp > 1*(overshoot_tolerance)
            penalty = penalty + 1500;
        end

        if ts > settlingTime
            penalty = penalty + 2000;
        end

        if tr > risingTime_tolerance
            penalty = penalty + 200;
        end

        if Ess ~= 0
            penalty = penalty + 500;
        end
        
        fitness(i) = -(50*Ess^2 + 50*Mp + 1*tr + 50*ts + penalty);
        %}
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