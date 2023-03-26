function f = chi2inv_rvc(confidence, n)
%CHI2INV_RVC Inverse chi-squared function for 2 DoF
%   X = CHI2INV_RVC(P, N) returns an approximation of the inverse 
%   chi-squared CDF function for confidence P for N-degrees of freedom.
%   This function only works for N = 2.
%
%   The function uses a lookup table with around 6 figure accuracy.
%   This is an approximation of the chi2inv function in Statistics & 
%   Machine Learning Toolbox. The lookup table can be regenerated with the
%   following code:
%
%     x = chi2inv(c,2);
%     fprintf("%f ",x);
%
%   See also chi2inv.

narginchk(1,2);
assert(n == 2, "chi2inv_rvc:badarg", "This function is only valid for N=2.");

c = linspace(0,1,101);

% use the lookup table
x = [0.000000 0.020101 0.040405 0.060918 0.081644 0.102587 0.123751 0.145141 0.166763 0.188621 0.210721 0.233068 0.255667 0.278524 0.301646 0.325038 0.348707 0.372659 0.396902 0.421442 0.446287 0.471445 0.496923 0.522730 0.548874 0.575364 0.602210 0.629421 0.657008 0.684981 0.713350 0.742127 0.771325 0.800955 0.831031 0.861566 0.892574 0.924071 0.956072 0.988593 1.021651 1.055265 1.089454 1.124238 1.159637 1.195674 1.232372 1.269757 1.307853 1.346689 1.386294 1.426700 1.467938 1.510045 1.553058 1.597015 1.641961 1.687940 1.735001 1.783196 1.832581 1.883217 1.935168 1.988505 2.043302 2.099644 2.157619 2.217325 2.278869 2.342366 2.407946 2.475749 2.545931 2.618667 2.694147 2.772589 2.854233 2.939352 3.028255 3.121295 3.218876 3.321462 3.429597 3.543914 3.665163 3.794240 3.932226 4.080442 4.240527 4.414550 4.605170 4.815891 5.051457 5.318520 5.626821 5.991465 6.437752 7.013116 7.824046 9.210340 Inf];

f = interp1(c, x, confidence);

end
