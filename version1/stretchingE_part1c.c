#include "mex.h"
#include "math.h"

void mexFunction (int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{   /*input:N,B,alpha
    c++ starts array from 0!
    1/2 equals zero! use 1.0/2.0*/
    int i, start_node, end_node; 
    long double energy,x_i,y_i,x_j,y_j, factor1,temp, alpha,stiff;
    double *y_pointer;
    /*the second input B has two field, start and end*/
    
    energy=0.0;
    alpha=mxGetScalar(prhs[2]);
    
    for (i = 0; i < mxGetNumberOfElements (prhs[1]); i++)
    {
        start_node=mxGetScalar(mxGetField(prhs[1],i,"start"));  /*mxGetField returns a type of mxarray, we have to use mxGetScalar to convert it into double or int.*/
        end_node=mxGetScalar(mxGetField(prhs[1],i,"end"));
        
        x_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"x"));
        y_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"y"));
        x_j=mxGetScalar(mxGetField(prhs[0],end_node-1,"x"));
        y_j=mxGetScalar(mxGetField(prhs[0],end_node-1,"y"));
        
        /*printf("n:%d\n", mxGetNumberOfElements (prhs[1]));*/
        /*printf("i:%f,%f, j:%f,%f\n", x_i, y_i, x_j, y_j);*/
        factor1=1.0/2.0;
        temp=(1-sqrt((x_i-x_j)*(x_i-x_j)+(y_i-y_j)*(y_i-y_j)));
        stiff=alpha;
        
        energy=energy+factor1*stiff*temp*temp;
    }
    
    plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL );
    y_pointer = mxGetPr ( plhs[0] );
    *y_pointer= energy;
    
}
