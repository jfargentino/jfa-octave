function c = daub_coefficients_solve ( n )

%*****************************************************************************80
%
%% DAUB_COEFFICIENTS_SOLVE computes the Daubechies scaling coefficients.
%
%  Discussion:
%
%    This function is not accurate for 20 < N.
%
%  Modified:
%
%    17 August 2011
%
%  Author:
%
%    Jan Odegard, Ivan Selesnick
%
%  Reference:
%
%    Sidney Burrus, Ramesh Gopinath, Haitao Guo,
%    Introduction to Wavelets and Wavelet Transforms,
%    Prentice Hall, 1998,
%    ISBN: 0-13-489600-9,
%    LC: QA403.3.B87.
%
%  Parameters
%
%    Input, integer N, the order of the Daubechies filter.
%    N should be even.
%
%    Output, real C(N), the Daubechies scaling coefficients.
%
  if ( mod ( n, 2 ) ~= 0 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'DAUB_COEFFICIENTS_SOLVE - Fatal error!\n' );
    fprintf ( 1, '  N must be even.\n' );
    error ( 'DAUB_COEFFICIENTS_SOLVE - Fatal error!\n' )
  end

  n2 = floor ( n / 2 );

  a = 1;
  p = 1;
  q = 1;
  c = [ 1.0 1.0 ];

  for j = 1 : n2 - 1
    c = conv ( c, [ 1, 1 ] );
    a = - a * 0.25 * ( j + n2 - 1 ) / j;
    p = conv ( p, [ 1, -2, 1 ] );
    q = [ 0, q, 0 ] + a * p;
  end

  q = sort ( roots ( q ) );
  c = conv ( c, real ( poly ( q(1:n2-1) ) ) );
%
%  Rescale so that sum ( C ) = sqrt ( 2.0 ).
%
  c = c * sqrt ( 2.0 ) / sum ( c );

  return
end
