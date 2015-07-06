#include "mex.h"
#include "math.h"
# include "limits.h"

void mexFunction (int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{   /*input:N,B,alpha*/
    /*c++ starts array from 0!*/
    /*1/2 equals zero! use 1.0/2.0*/
    int i, start_node, end_node, size, position_i, position_j;
    long double x_i, y_i, x_j, y_j, l, temp;
    double *d1;
    long double alpha, stiff; ;
    /*the second input B has two field, start and end*/
    
    alpha=mxGetScalar(prhs[2]);  /*stretching stiffness*/
    
    size=mxGetNumberOfElements(prhs[0]);
        
    plhs[0] = mxCreateDoubleMatrix (2*size+2, 1, mxREAL );    /*create output*/
    d1=mxGetPr(plhs[0]);
    d1[2*size]=0.0;
    d1[2*size+1]=0.0;
    
    for (i = 0; i < mxGetNumberOfElements (prhs[1]); i++)
    {
        start_node=mxGetScalar(mxGetField(prhs[1],i,"start"));  /*mxGetField returns a type of mxarray, we have to use mxGetScalar to convert it into double or int.*/
        end_node=mxGetScalar(mxGetField(prhs[1],i,"end"));
        
        x_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"x"));
        y_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"y"));
        x_j=mxGetScalar(mxGetField(prhs[0],end_node-1,"x"));
        y_j=mxGetScalar(mxGetField(prhs[0],end_node-1,"y"));
        
        l=sqrt((x_i-x_j)*(x_i-x_j)+(y_i-y_j)*(y_i-y_j))+LDBL_EPSILON;
        temp=1-l;
        
        stiff=alpha;
        /*printf("n:%d\n", mxGetNumberOfElements (prhs[1]));
        printf("i:%f,%f, j:%f,%f\n", x_i, y_i, x_j, y_j);*/
        position_j=2*end_node-2;
        d1[position_j]=d1[position_j]+temp*((x_i - x_j)/l)*stiff;
        d1[position_j+1]=d1[position_j+1]+temp*((y_i - y_j)/l)*stiff;
        
        position_i=2*start_node-2;
        d1[position_i]=d1[position_i]+temp*(-(x_i - x_j)/l)*stiff;
        d1[position_i+1]=d1[position_i+1]+temp*(-(y_i - y_j)/l)*stiff;
    }
    
}
