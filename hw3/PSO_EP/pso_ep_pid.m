function [bestParticle] = pso_ep_pid(initialParticle, generation, mutation_rate, fitFunction, show_fitness)
    
    particleSize = size(initialParticle, 1);
    particle = initialParticle(:, :, :);

    gbestParticle = initialParticle(1, 1, :);
    pbestParticle = initialParticle(:, 1, :);
    gbestFitness = fitFunction(particle(1, 1, :));
    pbestFitness = zeros(particleSize, 1);
    
    w = 0.7;
    c1 = 0.6;
    c2 = 0.4;
    fitness_history = zeros(generation, 1);
    for i = 1:generation
        fitness = fitFunction(particle(:, 1, :));
    

        [currentMaxFitness, currentMaxIndex] = max(fitness);

        if currentMaxFitness > gbestFitness
            gbestFitness = currentMaxFitness;
            gbestParticle(1, :, :) = particle(currentMaxIndex, 1, :);
        end
        
        pbestMask = fitness > pbestFitness;
        pbestFitness(pbestMask) = fitness(pbestMask);
        pbestParticle(pbestMask, 1, :) = particle(pbestMask, 1, :);

        fitness_history(i) = gbestFitness;

        clc;
        i
        pid = reshape(gbestParticle(1, 1, :), [1, 3])
        gbestFitness
        
        particle(:, 2, :) = w*particle(:, 2, :) + c1*rand()*( pbestParticle - particle(:, 1, :) ) + c2*rand()*( gbestParticle(1, :, :) - particle(:, 1, :) );
        particle(:, 1, :) = particle(:, 1, :) + particle(:, 2, :);
        %tmp_particle_vel = particle(:, 2, :);

        mutation_prob = rand(size(particle));
        mutation_index = mutation_prob < mutation_rate;
        particle(mutation_index) = rand([sum(mutation_index, "all"), 1]);
        %particle(:, 2, :) = tmp_particle_vel;

    end

    bestParticle = gbestParticle;
    if show_fitness
        figure()
        plot(1:generation,fitness_history)
        title('fitness')
        xlabel('generation')
        ylabel('y')
        hold on
    end
end