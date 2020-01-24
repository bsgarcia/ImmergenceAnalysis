% This function updates q-values in the OCRL model
%-------------------------------------------------

function  [updatedQ, qYellow, qPink] = socialCF_update(i, s, cfs, r, cfr, a, Q, alpha, alphaC, actualExchange)



if s(i) ~= 2 && s(i) ~= 4 && s(i) ~= 7 && s(i) ~= 12
    
    
    % Operant Conditionning
    %______________________
      
    deltaI =  r(i) - Q(s(i),a(i));
    
    Q(s(i),a(i)) = Q(s(i),a(i)) + alpha * deltaI;
    
   
end

updatedQ = Q;

end
