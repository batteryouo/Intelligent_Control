function [bestParticle] = pso_pid(initialParticle, generation, fitFuntion)
    
    particleSize = size(initialParticle, 1);
    particle = initialParticle(:, :, :);

    gbestParticle = initialParticle(1, 1, :);
    pbestParticle = initialParticle(:, 1, :);
    gbestFitness = 0;
    pbestFitness = zeros(particleSize, 1);
    
    w = 0.4;
    c1 = 0.6;
    c2 = 0.4;
    
    for i = 1:generation
        fitness = fitFuntion(particle(:, 1, :));
    

        [currentMaxFitness, currentMaxIndex] = max(fitness);
    
        if currentMaxFitness > gbestFitness
            gbestFitness = currentMaxFitness;
            gbestParticle(1, :, :) = particle(currentMaxIndex, 1, :);
        end
        
        pbestMask = fitness > pbestFitness;
        pbestFitness(pbestMask) = fitness(pbestMask);
        pbestParticle(pbestMask, 1, :) = particle(pbestMask, 1, :);
        
        particle(:, 2, :) = w*particle(:, 2, :) + c1*rand()*( pbestParticle - particle(:, 1, :) ) + c2*rand()*( gbestParticle(1, :, :) - particle(:, 1, :) );
        particle(:, 1, :) = particle(:, 1, :) + particle(:, 2, :);
    end

    bestParticle = gbestParticle;
end