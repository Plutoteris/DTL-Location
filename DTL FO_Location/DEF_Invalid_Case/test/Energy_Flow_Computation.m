function energy_flow = Energy_Flow_Computation(P,Q,U,f,t1)

W = 0;
deltaP = P(:,1)-P(1,1);
deltaQ = Q(:,1)-Q(1,1);
lnU = log(U(:,1));
deltalnU = lnU(:,1)-lnU(1,1);
deltaf = f(:,1)-f(1,1);
len = length(t1);

for i = 1:1:len
    if deltalnU(i)~= -inf
        deltaW(i) = deltaP(i)*2*pi*deltaf(i)+deltaQ(i)*deltalnU(i);
    else
        deltaW(i) = 0;
    end
    W = W+deltaW(i);
    energy_flow(i) = W;
end
end