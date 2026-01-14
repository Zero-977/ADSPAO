function X=spiral_motion(X,Flame,Fes,MaxFEs)
n=size(X,1);
l=round(n-fes*((n-1)/MaxFEs));
c=-1+fes*((-1)/MaxFEs);
for i=1:n
    for j=1:size(X,2)
        if i<=l 
            distance_to_flame=abs(Flames(i,j)-X(i,j));
            b=1;
            k=(c-1)*rand+1;     
            X(i,j)=distance_to_flame*exp(b.*k).*cos(k.*2*pi)+Flames(i,j);
        end
        if i>l
            distance_to_flame=abs(Flames(i,j)-X(i,j));
            b=1;
            k=(c-1)*rand+1;
            X(i,j)=distance_to_flame*exp(b.*k).*cos(k.*2*pi)+Flames(l,j);
        end
    end
end
end  
