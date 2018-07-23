function resT = minimum_error_thresholding(I,numOfBins,minSigma)
% numOfBins 100
% minSigma 0
someVar = numOfBins;
disp(numOfBins);
deltaT = 1.0 / numOfBins;

hx = zeros(1,numOfBins);
hx(1) = sum(sum(I<=deltaT));
for i = 2:numOfBins
   hx(i) = sum(sum(I<=(i*deltaT))) - (sum(sum(I<=((i-1)*deltaT))));
end
hx = hx./(size(I,1)*size(I,2));

J = zeros(1,numOfBins);
sigma1T_all = zeros(1,numOfBins);
sigma2T_all = zeros(1,numOfBins);
for i = 1:numOfBins
    pw1T = Pw1T(i*deltaT,I);
    pw2T = Pw2T(i*deltaT,I);
    
    m1T = 0;
    for x = 1:i
        m1T = m1T + (x*deltaT)*hx(x);
    end
    m1T = m1T / pw1T;
    
    m2T = 0;
    for x = (i+1):numOfBins
        m2T = m2T + (x*deltaT)*hx(x);
    end
    m2T = m2T / pw2T;
    
    sigma1T = 0;
    for x = 1:i
        sigma1T = sigma1T + ((x*deltaT-m1T)^2)*hx(x);
    end
    sigma1T = sqrt(sigma1T / pw1T);
    sigma1T_all(i) = sigma1T;
    
    sigma2T = 0;
    for x = (i+1):numOfBins
        sigma2T = sigma2T + ((x*deltaT-m2T)^2)*hx(x);
    end
    sigma2T = sqrt(sigma2T / pw2T);
    sigma2T_all(i) = sigma2T;
    
    J(i) = 1+2*(pw1T*log(sigma1T)+pw2T*log(sigma2T))-2*(pw1T*log(pw1T)+pw2T*log(pw2T));
end
% save J.mat J deltaT numOfBins
J(isinf(J)) = Inf;
J(isnan(J)) = Inf;

J(1:2) = Inf;

J(sigma1T_all<minSigma) = Inf;
J(sigma2T_all<minSigma) = Inf;

[val,index] = min(J);
resT = index*deltaT;

end

function ret = Pw1T(T,I)
    ret = sum(sum(I<=T))/(size(I,1)*size(I,2));
end

function ret = Pw2T(T,I)
    ret = sum(sum(I>T))/(size(I,1)*size(I,2));
end
