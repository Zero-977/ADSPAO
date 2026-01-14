


function [Leader_pos,Convergence_curve]=ADSPAO(N,MaxFEs,lb,ub,dim,fobj)
 disp('ADSPAO is now tackling your problem')

FEs=0;
it=1;

Convergence_curve=[];

pop=initialization(N,dim,ub,lb);

for i=1:N
    Fitness(i)=fobj(pop(i,:));
    FEs=FEs+1;
end

[fmin,x]=min(Fitness);
%
Fitnorm=zeros(1,N);
New_pop=zeros(N,dim);
best=pop(x,:);
bestfitness=fmin;

while FEs<=MaxFEs
    
    
    K= 1-((FEs)^(1/6)/(MaxFEs)^(1/6));
      E =1*exp(-4*(FEs/MaxFEs));

    for i=1: N
        
        Fitnorm(i)= (Fitness(i)-min(Fitness))/(max(Fitness)-min(Fitness));
        for j=1:dim
           
            if rand<K
                if rand<0.5
                    New_pop(i,j) = pop(i,j)+E.*pop(i,j)*(-1)^FEs;
                else
                    New_pop(i,j) = pop(i,j)+E.*best(j)*(-1)^FEs;
                end
            else
                New_pop(i,j)=pop(i,j);
            end
            
            if rand<Fitnorm(i)
                A=randperm(N);
                beta=(rand/2)+0.1;
                New_pop(i,j)=pop(A(3),j)+beta.*(pop(A(1),j)-pop(A(2),j));
                
            end
        end
        
        New_pop(i,:)=Mutation(New_pop(i,:),pop(i,:),best,dim);
              New_pop(i,:)=Transborder_reset(New_pop(i,:),ub,lb,dim,best);

        tFitness=fobj(New_pop(i,:));
        FEs=FEs+1;

        if tFitness<Fitness(i)
            pop(i,:)= New_pop(i,:);
            Fitness(i)=tFitness;
        end
    end
    [fmin,x]=min(Fitness);
    if fmin<bestfitness
        best=pop(x,:);
        bestfitness=fmin;
    end

    [sorted_Fitness, sorted_indices] = sort(Fitness);

    sorted_X = pop(sorted_indices, :);

    F=spiral_motion(pop,sorted_X,FEs,MaxFEs);

    for i=1:N

        Flag4ub=F(i,:)>ub;
        Flag4lb=F(i,:)<lb;
        F(i,:)=(F(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        newFitness(1,i)=fobj(F(i,:));
        FEs=FEs+1;

        if newFitness(1,i)<Fitness(i)
            Fitness(i) = newFitness(1,i);
            pop(i,:) = F(i,:);
            if newFitness(1,i)< bestfitness
                bestfitness=Fitness(i);
                best=pop(i,:);
            end
        end
    end
    

    c1 = 2*exp(-(4*FEs/MaxFEs)^2);
    for i=1:N
        Rpv_i = pop(i,:);
        num_d = dim;
        pick = randperm(dim);
        pick = pick(1:num_d);
        kk = randperm(num_d);
        for j=1:k
            c2 = rand();
            if rand > 0.5
                Rpv_i(pick(j)) = Rpv_i(pick(j)) + c1*(lb+c2*(ub-lb));
            else
                Rpv_i(pick(j)) = Rpv_i(pick(j)) - c1*(lb+c2*(ub-lb));
            end
            if Rpv_i(pick(j)) > ub || Rpv_i(pick(j)) < lb
                Rpv_i(pick(j)) = lb+rand()*(ub-lb);
            end
        end
        for j=(kk+1):num_d
            if i==1
                Temp=best(pick(j));
            else
                Temp=pop(i-1,pick(j));
            end
            Rpv_i(pick(j))=(Temp+Rpv_i(pick(j)))/2;
        end
        F_Rpv = fobj(Rpv_i);
        FEs = FEs+1;
        if F_Rpv < Fitness(i)
            pop(i,:) = Rpv_i;
            Fitness(i) = F_Rpv;
            if F_Rpv < bestfitness
                best = Rpv_i;
                bestfitness = F_Rpv;
            end
        end
    end

    Convergence_curve(it)=bestfitness;
    Leader_pos=best;
    it=it+1;
end
end




