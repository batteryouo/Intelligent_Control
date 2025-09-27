function [fitness] = psoFitFunction(particle)
    fitness = rand(50, 1);
    particleSize = size(particle, 1);

    for i = 1:particleSize
        Kp = particle(1, 1, 1);
        Ki = particle(1, 1, 2);
        Kd = particle(1, 1, 3);

        sim("psoPID.slx");
        
        settling_time = 2;
        settling_percent = 0.02;
        overshoot = 0.2;
    end
end