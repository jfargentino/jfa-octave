function [out1, out2] = adaptArguments (in1, in2)

in1 = in1 (:);
in2 = in2 (:);

n1 = length (in1); 
n2 = length (in2); 

out1 = repmat (in1, n2, 1);
out2 = repmat (in2, 1, n1)';
out2 = out2 (:);
