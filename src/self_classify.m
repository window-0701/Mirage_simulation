function out = self_classify(y,w)
global n;
wi = w/(100*n);
for j = 1:1000
    if y >= wi*(j-1) && y <= wi*j
        out = j;
        return               
    end
    out = 0;
end