
function z=Mutation(z,x,b,dim) %         New_pop(i,:)=Mutation(New_pop(i,:),pop(i,:),best,dim);
for j=1:dim
    if rand<0.05
        z(j)=x(j);
    end
    if rand<0.2
        z(j)=b(j);
    end
end
end