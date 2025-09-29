function [bestParticle] = pso_rga_pid(initialParticle, generation, mutation_rate, fitFunction, show_fitness)
    
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
        %RGA
        fitness_prob_cum = cumsum(fitness/sum(fitness));
        parent_index = arrayfun(@(x) find(fitness_prob_cum > x, 1, 'first'), rand(particleSize, 1));
        new_particle = particle; 

        %crossover
        for j = 1:2:particleSize-1
            p1 = parent_index(j);
            p2 = parent_index(j+1);
            crossover_prob = rand(1, 3);
            parent1 = reshape(particle(p1, 1, :), [1, 3]);
            parent2 = reshape(particle(p2, 1, :), [1, 3]);
            child1 = crossover_prob .* parent1 + (1-crossover_prob) .* parent2;
            child2 = (1-crossover_prob) .* parent1 + crossover_prob .* parent2;
            new_particle(p1, 1, :) = child1;
            new_particle(p2, 1, :) = child2;
        end
        %mutation
        mutation_mask = rand(particleSize, 3) < mutation_rate;
        mutation_values = rand(sum(mutation_mask, "all"), 1);
        tmp_pos = new_particle(:,1,:);
        tmp_pos(mutation_mask) = mutation_values;
        new_particle(:,1,:) = tmp_pos;
        %selection
        new_fitness = fitFunction(new_particle(:, 1, :));
        replace_mask = new_fitness > fitness;
        particle(replace_mask, 1, :) = new_particle(replace_mask, 1, :);    

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