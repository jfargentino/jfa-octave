function y = sinc_interp(x,s,u,N)
    % Interpolates x sampled sampled at "s" instants
    % Output y is sampled at "u" instants ("u" for "upsampled")

    if (nargin < 4)
        N = 0;
    end

    % Find the sampling period of the undersampled signal
    T = s(2)-s(1);

    %naive implementation
    %for i=1:length(u)
    %    y( i ) = sum( x .* sinc( (1/T)*(u(i) - s) ) );
    %end
    % Make sure y is same shape as u (row->row, col->col)
    %y = reshape(y, size(u));

    % The entries of this matrix are each u-s permutation.
    % It will be used to generate the sinc transform that will
    % be convolved below with the input signal to do the
    % interpolation.
    %
    % (recall that u(:) will be a column vector regardless
    % of the row-ness of u. So u(:) is a row, and s(:) is a
    % column)
    %sincM = repmat( u(:), 1, length(s) ) ...
    %       - repmat( s(:)', length(u), 1 );

    % When generating this matrix, remember that "s" and "u" are
    % passed as ROW vectors and "y" is expected to also be a ROW
    % vector. If everything were column vectors, we'd do.
    %
    % sincM = repmat( u, 1, length(s) ) - repmat( s', length(u), 1 );
    %
    % So that the matrix would be longer than it is wide.
    % Here, we generate the transpose of that matrix.
    sincM = repmat( u, length(s), 1 ) - repmat( s', 1, length(u) ):

    % * Sinc is the inverse Fourier transform of the boxcar in
    % the frequency domain that was used to filter out the
    % ambiguous copies of the signal generated from sampling.
    % * That sinc, which is now sampled at length(u) instants,
    % is convolved with the input signal becuse the boxcar was
    % multipled with its Fourier transform.
    % So this multiplication (which is a matrix transformation
    % of the input vector x) is an implementation of a
    % convolution.
    % (reshape is used to ensure y has same shape as upsampled u)
    %y = reshape( sinc( sincM/T )*x(:) , size(u) );
    % Equivalent to column vector math:
    % y = sinc( sincM'(N+1)/T )*x';
    y = x*( (N+1)*sinc( sincM*(N+1)/T ) - N*sinc( sincM*N/T ) );


%function [xi, y, ti] = sinc_interp (x, irate, speriod)
%k  = speriod * irate / 2;
%ti = 2*(-k:+k-1)' / irate;
%y  = sinc (ti);
%xi = zeros ((length(x) + 2)*k, 1);
%xi = zeros (1024, 1);
%n1 = 1;
%n2 = 2*k;
%for n = 1:length(x)
%    xi(n1:n2) = xi(n1:n2) + x(n) * y;
%    n1 = n1 + 2*k;
%    n2 = n2 + 2*k;
%end
%xi = crosscorr (xi(:), y, 1);
%xi = repmat (x, 1, irate)';
%xi = xi(:);
%xi = conv (xi, y, 'same');

