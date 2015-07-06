# include "mex.h"
# include "math.h"
# include "limits.h"

void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] );
long double cal_phi( long double x_i, long double y_i, long double x_j, long double y_j, long double x_k, long double y_k  );

/* ----------------------------------------------*/
void mexFunction ( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{   /*input:N, S, k*/
    int i, start_node, mid_node, end_node,size; 
    long double x_i,y_i,x_j,y_j, x_k, y_k,k;
    double *d1;
    long double c1,c2, c3, c4,c5, c6,c7,c8, common_factor, xij, yij, xkj, ykj, yik, delta_theta, phi;
    int position_i, position_j, position_k;
    
    k=mxGetScalar(prhs[2]);  /*bending stiffness*/
    
    size=mxGetNumberOfElements(prhs[0]);
    
    plhs[0] = mxCreateDoubleMatrix (2*size+2, 1, mxREAL );    /*create output*/
    
    d1=mxGetPr(plhs[0]);
    d1[2*size]=0;
    d1[2*size+1]=0;
    
    for (i = 0; i < mxGetNumberOfElements (prhs[1]); i++)
    {
        start_node=mxGetScalar(mxGetField(prhs[1],i,"start"));  /*mxGetField returns a type of mxarray, we have to use mxGetScalar to convert it into double or int*/
        mid_node=mxGetScalar(mxGetField(prhs[1],i,"mid"));
        end_node=mxGetScalar(mxGetField(prhs[1],i,"end"));
        
        x_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"x"));
        y_i=mxGetScalar(mxGetField(prhs[0],start_node-1,"y"));
        x_j=mxGetScalar(mxGetField(prhs[0],mid_node-1,"x"));
        y_j=mxGetScalar(mxGetField(prhs[0],mid_node-1,"y"));
        x_k=mxGetScalar(mxGetField(prhs[0],end_node-1,"x"));
        y_k=mxGetScalar(mxGetField(prhs[0],end_node-1,"y"));
        
        phi=cal_phi(x_i,y_i,x_j,y_j,x_k,y_k);
        delta_theta=acos(phi)-M_PI;
        
        common_factor=-k*delta_theta/(sqrt(1-pow(phi,2))+LDBL_EPSILON);
        
        xij=x_i-x_j;
        yij=y_i-y_j;
        xkj=x_k-x_j;
        ykj=y_k-y_j;
        yik=y_i-y_k;

        c1=x_k*(-yij)+x_j*(yik)+x_i*(ykj);    /*simplifed expression known from mathematica*/
        c2=xij*xij+yij*yij+LDBL_EPSILON;
        c3=xkj*xkj+ykj*ykj+LDBL_EPSILON;
        c4=(-c1)/(c2*sqrt(c2)*sqrt(c3));
        c5=x_k*x_k*yij+x_j*x_j*yik+(x_i*x_i+yij*yik)*(-ykj)+2*x_j*(x_k*(-yij)+x_i*ykj);
        c6=x_i*x_i*(-xkj)+x_j*x_j*x_k-x_k*yij*yij+x_i*(-x_j*x_j+x_k*x_k+ykj*ykj)-x_j*(x_k*x_k-yik*(yij+ykj));
        c7=c2*sqrt(c2)*c3*sqrt(c3);
        c8=(-c1)/(sqrt(c2)*c3*sqrt(c3));
       
        /*printf("n:%d\n", mxGetNumberOfElements (prhs[1]));
        printf("i:%f,%f, j:%f,%f\n", x_i, y_i, x_j, y_j);*/
        position_i=2*start_node-2;
        d1[position_i]=d1[position_i]+common_factor*(yij)*c4;
    
                                                /*derivatives with respect to y_i*/
        d1[position_i+1]=d1[position_i+1]-common_factor*(xij)*c4;  
	
        position_j=2*mid_node-2;
        d1[position_j]=d1[position_j]+common_factor*c1*c5/c7;
    
                                                /*derivatives with respect to y_j*/
        d1[position_j+1]=d1[position_j+1]+common_factor*(-c1)*c6/c7;
	
        position_k=2*end_node-2;   /*derivatives with respect to x_k*/
        d1[position_k]=d1[position_k]+common_factor*(-ykj)*c8;
    
                                                /*derivatives with respect to y_k*/
        d1[position_k+1]=d1[position_k+1]+common_factor*(-xkj)*(-c8);
    }
   
}
/* -----------------------------------------*/
long double cal_phi ( long double x_i, long double y_i, long double x_j, long double y_j, long double x_k, long double y_k )
{
    long double temp;
    
    temp=((x_j-x_i)*(x_j-x_k)+(y_j-y_i)*(y_j-y_k))/((sqrt((x_j-x_i)*(x_j-x_i)+(y_j-y_i)*(y_j-y_i))+LDBL_EPSILON)*(sqrt((x_j-x_k)*(x_j-x_k)+(y_j-y_k)*(y_j-y_k))+LDBL_EPSILON));
    
    if (temp<-1.0){
        temp=-1.0;}
    else if (temp>1.0)
    {
        temp=1.0;
    }
    
    return temp;
}
