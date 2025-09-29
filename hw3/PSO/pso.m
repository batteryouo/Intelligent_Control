clear;clc;

global Kp Ki Kd t y;

fitFunction=@psoFitFunction;
generation = 30;
particleSize = 60;
particleInfoSize = [2, 3];

initialParticle = 2 * rand( particleSize, particleInfoSize(1), particleInfoSize(2) );
initialParticle(:, 2, :) = 1 * rand(particleSize, 1, 3);

bestParticle = pso_pid(initialParticle, generation, fitFunction, true);

figure()
sim('psoPID');
plot(t,y)
title('Step Response')
xlabel('time')
ylabel('y')
hold on

figure()
plot(t,u)
title('Control Energy')
xlabel('time')
ylabel('u')
hold on