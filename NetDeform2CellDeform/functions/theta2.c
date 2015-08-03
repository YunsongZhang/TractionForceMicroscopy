# include "mex.h"
# include "math.h"
# include "stdio.h"

void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  double x_i;
  double y_i;
  double x_j;
  double y_j;
  double x_k;
  double y_k;
  double *y_pointer0;
  double *y_pointer1;
  double output0;
  double output1;
  
  x_i = mxGetScalar ( prhs[0] );
  y_i = mxGetScalar ( prhs[1] );
  x_j = mxGetScalar ( prhs[2] );
  y_j = mxGetScalar ( prhs[3] );
  x_k = mxGetScalar ( prhs[4] );
  y_k = mxGetScalar ( prhs[5] );

  plhs[0] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
  plhs[1] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
  
  y_pointer0 = mxGetPr ( plhs[0] );
  y_pointer1 = mxGetPr ( plhs[1] );  
  
  output1= ((x_j-x_i)*(x_j-x_k)+(y_j-y_i)*(y_j-y_k))/(sqrt(pow(x_j-x_i,2)+pow(y_j-y_i,2))*sqrt(pow(x_j-x_k,2)+pow(y_j-y_k,2)));
  
  /*printf("%f\n", output0);*/
  if (output1<-1.0){
        output1=-1.0;}
  else if (output1>1.0)
  {
      output1=1.0;
  }
      
  output0= acos(output1)-M_PI;

      
  *y_pointer0 = output0;
  *y_pointer1 = output1;
  
  return;
}
