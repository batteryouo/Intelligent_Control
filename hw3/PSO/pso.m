clear;clc;

fitFunction=@psoFitFunction;
generation = 30;
particleSize = 50;
particleInfoSize = [2, 3];

initialParticle = rand( particleSize, particleInfoSize(1), particleInfoSize(2) );

bestParticle = pso_pid(initialParticle, generation, fitFunction);