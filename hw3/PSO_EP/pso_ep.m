clear;clc;

global Kp Ki Kd t y;

fitFunction=@psoEPFitFunction;
generation = 30;
particleSize = 60;
particleInfoSize = [2, 3];
mutation_rate = 0.05;

initialParticle = 2 * rand( particleSize, particleInfoSize(1), particleInfoSize(2) );
initialParticle(:, 2, :) = 1 * rand(particleSize, 1, 3);

bestParticle = pso_ep_pid(initialParticle, generation, mutation_rate, fitFunction, true);

figure()
sim('psoepPID');
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