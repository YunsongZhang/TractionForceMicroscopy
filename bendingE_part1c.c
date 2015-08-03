# include "mex.h"
# include "math.h"

void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] );
long double theta ( long double x_i, long double y_i, long double x_j, long double y_j, long double x_k, long double y_k );

/*-------------------------------*/
void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{   /*input:N,S, k*/
    int i, start_node, mid_node, end_node; 
    long double energy,x_i,y_i,x_j,y_j, x_k, y_k,k, angle, factor;
    double *y_pointer;
    
    energy=0.0;
    k=mxGetScalar(prhs[2]);    /*bending stiffness*/
    
    for (i = 0; i < mxGetNumberOfElements (prhs[1]); i++)
    {
        start_node=mxGetScalar(mxGetField(prhs[1],i,"start"));  /*mxGetField returns a type of mxarray, we have to use mxGetScalar to convert it into double or int.*/
        mid_node=mxGetScalar(mxGetField(prhs[1],i,"mid"));
        end_node=mxGetScalar(mxGetField(prhs[1],i,"end"));
        
        x_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"x"));
        y_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"y"));
        x_j=mxGetScalar(mxGetField(prhs[0],mid_node-1,"x"));
        y_j=mxGetScalar(mxGetField(prhs[0],mid_node-1,"y"));
        x_k=mxGetScalar(mxGetField(prhs[0],end_node-1,"x"));
        y_k=mxGetScalar(mxGetField(prhs[0],end_node-1,"y"));
        
        /*printf("n:%d\n", mxGetNumberOfElements (prhs[1]));
        printf("i:%f,%f, j:%f,%f\n", x_i, y_i, x_j, y_j);*/
        
        angle=theta(x_i,y_i,x_j,y_j,x_k,y_k);
        
        factor=1.0/2.0;
        energy=energy+factor*k*pow(angle,2);
    }
    
    plhs[0] = mxCreateDoubleMatrix (1, 1, mxREAL );
    y_pointer = mxGetPr ( plhs[0] );
    *y_pointer= energy;
   
}

/*---------------------------------------------------------------*/

long double theta ( long double x_i, long double y_i, long double x_j, long double y_j, long double x_k, long double y_k )
{
    long double y, temp;
    
    temp=((x_j-x_i)*(x_j-x_k)+(y_j-y_i)*(y_j-y_k))/((sqrt(pow(x_j-x_i,2)+pow(y_j-y_i,2))+1e-16)*(sqrt(pow(x_j-x_k,2)+pow(y_j-y_k,2))+1e-16));
    
    if (temp<-1.0){
        temp=-1.0;}
    else if (temp>1.0)
    {
        temp=1.0;
    }
    
    y=acos(temp)-M_PI;
    return y;
}
