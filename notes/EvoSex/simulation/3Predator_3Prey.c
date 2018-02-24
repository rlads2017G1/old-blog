#include <stdio.h>
#include <stdlib.h>
#include <math.h>    // Gauss operator
#include <time.h>
#include "../dSFMT-src-2.2.3/dSFMT.c"

// Functions
double floor(double x); // Gauss operator
double r2(){
	return (double)rand() / (double)RAND_MAX ;} // random number between 0, 1
void message_error(char error_text[]);
double *d_vector(long size); //vector creator
double **d_matrix(long size_row, long size_column); //matrix creater
void free_d_vector(double *x);
void free_d_matrix(double **x);
void rk4(double p[], double k1[],int n, double t, double h, double pout[],void(*diff)(double,double[],double[]));
void differential_ggg(double time,double in[],double out[]); //state 1
void differential_ggh(double time,double in[],double out[]); //state 2
void differential_ghg(double time,double in[],double out[]); //state 3
void differential_hgg(double time,double in[],double out[]); //state 4
void differential_ghh(double time,double in[],double out[]); //state 1
void differential_hgh(double time,double in[],double out[]); //state 2
void differential_hhg(double time,double in[],double out[]); //state 3
void differential_hhh(double time,double in[],double out[]); //state 4

double dN1_dt(double time, double vr[]);
double dN2_dt(double time, double vr[]);
double dN3_dt(double time, double vr[]);
double dPr1_dt_g(double time, double vr[]); //abundant prey 1
double dPr1_dt_h(double time, double vr[]); //abundant prey 1
double dPr2_dt_g(double time, double vr[]); //abundant prey 2
double dPr2_dt_h(double time, double vr[]); //abundant prey 2
double dPr3_dt_g(double time, double vr[]); //abundant prey 2
double dPr3_dt_h(double time, double vr[]); //abundant prey 2


// Global variables
int i_N1= 1; //index of sex population
int i_N2= 2; //index of asex population
int i_N3= 3; //index of asex population

int i_Pr1= 4; //index of prey 1
int i_Pr2= 5; //index of prey 2
int i_Pr3= 6; //index of prey 2

double b1= 0.8; // birth rate of sex
double b2= 1.6; // birth rate of asex
double b3= 1.6; // birth rate of asex
double d1= 0.5; // death rate of sex
double d2= 0.5; // death rate of asex
double d3= 0.5; // death rate of asex

double c11= 0.19; // consumption matrix parameter
double c12= 0.19; // consumption matrix parameter
double c13= 0.19; // consumption matrix parameter

double c21= 0.0; // consumption matrix parameter
double c22= 0.6; // consumption matrix parameter
double c23= 0.0; // consumption matrix parameter

double c31= 0.6; // consumption matrix parameter
double c32= 0.0; // consumption matrix parameter
double c33= 0.0; // consumption matrix parameter

double Ndeath=1E-6;
double Sdeath=1E-6;


double k1_g= 100; // carrying capacity of prey 1: good year
double k2_g= 100; // carrying capacity of prey 2: good year
double k3_g= 100; // carrying capacity of prey 2: good year

double k1_h= 10; // carrying capacity of prey 1: harsh year
double k2_h= 10; // carrying capacity of prey 2: harsh year
double k3_h= 10; // carrying capacity of prey 2: harsh year

double p1=0.125; //threshold probability. 0~p1: gg
double p2=0.25; //threshold probability. p1~p2: gh
double p3=0.375; //threshold probability. p2~p3: hg    p3~1: hh
double p4=0.5; //threshold probability. p2~p3: hg    p3~1: hh
double p5=0.625; //threshold probability. p2~p3: hg    p3~1: hh
double p6=0.75; //threshold probability. p2~p3: hg    p3~1: hh
double p7=0.875; //threshold probability. p2~p3: hg    p3~1: hh



double suc=1; //length of successive years of same state

double a1= 1; // growth rate of prey 1
double a2= 1; // growth rate of prey 2
double a3= 1; // growth rate of prey 2
int state; //initial state gg: 1  gh:2  hg:3  hh:4 


// Main function
int main (void)
{
	// Initialize parameters
		int i,j;  // add gen
		double gen=0.0, t=0.0;
		int T= 1000000; // number of calculations
		double deltat= 2000.0/T; // length of time step
		double *p= d_vector(6);
		double *dfdt= d_vector(6);
		double rd1; //random number for determining differentials
	
	// Random Number generator
		int seed;
		dsfmt_t dsfmt;
		seed= time(NULL);
		if(seed==0)seed= 1;
		dsfmt_init_gen_rand(&dsfmt,seed);
	
	// Output data
		FILE *out;
		out= fopen("./data/3Predator_3Pr.txt","w");
	// Initial Condition
		p[i_N1]= 1;
		p[i_N2]= 1;
		p[i_N3]= 1;		
		p[i_Pr1]= 1.5;
		p[i_Pr2]= 1.5;
		p[i_Pr3]= 1.5;
		state=1;
    fprintf(out, "time\tN1\tN2\tN3\tPr1\tPr2\tPr3\n");
    fprintf(out, "%lf\t%lf\t%lf\t%lf\t%lf\t%lf\t%lf\n", t, p[i_N1], p[i_N2], p[i_N3], p[i_Pr1], p[i_Pr2], p[i_Pr3]);
/*
	log[0][i_x]= 1;// initial population of x
	log[0][i_y]= 1;// initial population of y
	log[0][i_p]= 1;// initial population of p
	log[0][4]= t;// initial time 
*/
	//for (i=1;i<=3;i++) printf("%lf ",log[0][i]);// check initialization
	//printf("\n");// check initialization

	srand(time(NULL)); // clear random number generator for rand()
	
	for (i=1;i<=T;i++){//create for loop
		if(gen-floor(t/suc)<0){  // New generation
			gen=gen+1.0;
			rd1 = dsfmt_genrand_open_open(&dsfmt);  // random number variable pp			
			//rd1=r2();
			// rd2=r2();
			
			if(rd1>=0 && rd1<p1){   //state: 1
				differential_ggg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ggg);
				t+=deltat;	
				state=1;
				//printf("state: 0\n");
			} else if(rd1>=p1 && rd1<p2){ // state: 2
				differential_ggh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ggh);
				t+=deltat;	
				state=2;
			} else if(rd1>=p2 && rd1<p3){ // state: 3
				differential_ghg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ghg);
				t+=deltat;	
				state=3;
			} else if(rd1>=p3 && rd1<p4){ // state: 4
				differential_hgg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hgg);
				t+=deltat;	
				state=4;
			} else if(rd1>=p4 && rd1<p5){ // state: 5
				differential_ghh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ghh);
				t+=deltat;	
				state=5;
			} else if(rd1>=p5 && rd1<p6){ // state: 6
				differential_hgh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hgh);
				t+=deltat;	
				state=6;
			} else if(rd1>=p6 && rd1<p7){ // state: 7
				differential_hhg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hhg);
				t+=deltat;	
				state=7;
			} else if(rd1>=p7 && rd1<=1){ // state: 8
				differential_hhh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hhh);
				t+=deltat;	
				state=8;
			} else {printf("state: error\n");}	
		
		}
		else {
			if(state==1){   //state: 1
				differential_ggg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ggg);
				t+=deltat;	
			} else if(state==2){ // state: 2
				differential_ggh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ggh);
				t+=deltat;	
			} else if(state==3){ // state: 3
				differential_ghg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ghg);
				t+=deltat;	
			} else if(state==4){ // state: 4
				differential_hgg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hgg);
				t+=deltat;	
			} else if(state==5){ // state: 5
				differential_ghh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_ghh);
				t+=deltat;	
			} else if(state==6){ // state: 6
				differential_hgh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hgh);
				t+=deltat;	
			} else if(state==7){ // state: 7
				differential_hhg(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hhg);
				t+=deltat;	
			} else if(state==8){ // state: 8
				differential_hhh(t,p,dfdt);
				rk4(p, dfdt, 6, t, deltat, p, differential_hhh);
				t+=deltat;	
			} else {printf("state: error\n");}
			
		}		

		// Print the values
		fprintf(out,"%lf\t%lf\t%lf\t%lf\t%lf\t%lf\t%lf\n", t, p[i_N1], p[i_N2], p[i_N3], p[i_Pr1], p[i_Pr2], p[i_Pr3]);
		
		if(p[i_N1]<Ndeath||p[i_N2]<Ndeath||p[i_N3]<Ndeath||p[i_Pr1]<Sdeath||p[i_Pr2]<Sdeath||p[i_Pr3]<Sdeath) {
			printf("dynamics crashed\n");
			printf("%lf\t%lf\t%lf\t%lf\t%lf\t%lf\t%lf\n", t, p[i_N1], p[i_N2], p[i_N3], p[i_Pr1], p[i_Pr2], p[i_Pr3]);
			exit(2);
		}		
		
	}
	free_d_vector(p);
	free_d_vector(dfdt);
	fclose(out);

	return 0;
}

void message_error(char error_text[]) //standard error handler
{
	printf("There are some errors...\n");
	printf("%s\n",error_text);
	printf("...now existing to system...\n");
	exit(1);
}

double dN1_dt(double time, double vr[])
{return b1*vr[i_N1]*(vr[i_Pr3]*c13 + vr[i_Pr2]*c12 + vr[i_Pr1]*c11) - d1*vr[i_N1];}

double dN2_dt(double time, double vr[])
{return b2*vr[i_N2]*(vr[i_Pr3]*c23 + vr[i_Pr2]*c22 + vr[i_Pr1]*c21) - d2*vr[i_N2];}

double dN3_dt(double time, double vr[])
{return b3*vr[i_N3]*(vr[i_Pr3]*c33 + vr[i_Pr2]*c32 + vr[i_Pr1]*c31) - d3*vr[i_N3];}

double dPr1_dt_g(double time, double vr[])
{return a1*vr[i_Pr1]*(1 - vr[i_Pr1]/k1_g) - vr[i_Pr1]*(vr[i_N3]*c31 + vr[i_N2]*c21 + vr[i_N1]*c11);} // Prey 1: good year

double dPr1_dt_h(double time, double vr[])
{return a1*vr[i_Pr1]*(1 - vr[i_Pr1]/k1_h) - vr[i_Pr1]*(vr[i_N3]*c31 + vr[i_N2]*c21 + vr[i_N1]*c11);} // Prey 1: harsh year

double dPr2_dt_g(double time, double vr[])
{return a2*vr[i_Pr2]*(1-vr[i_Pr2]/k2_g)-vr[i_Pr2]*(vr[i_N3]*c32+vr[i_N2]*c22+vr[i_N1]*c12);} // Prey 2: good year

double dPr2_dt_h(double time, double vr[])
{return a2*vr[i_Pr3]*(1-vr[i_Pr2]/k2_h)-vr[i_Pr2]*(vr[i_N3]*c32+vr[i_N2]*c22+vr[i_N1]*c12);} // Prey 2: harsh year

double dPr3_dt_g(double time, double vr[])
{return a3*vr[i_Pr3]*(1-vr[i_Pr3]/k3_g)-vr[i_Pr3]*(vr[i_N3]*c33+vr[i_N2]*c23+vr[i_N1]*c13);} // Prey 2: good year

double dPr3_dt_h(double time, double vr[])
{return a3*vr[i_Pr3]*(1-vr[i_Pr3]/k3_h)-vr[i_Pr3]*(vr[i_N3]*c33+vr[i_N2]*c23+vr[i_N1]*c13);} // Prey 2: harsh year


void differential_ggg(double time, double in[], double out[]) // state:1
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_g(time,in);
    out[i_Pr2]= dPr2_dt_g(time,in);
	out[i_Pr3]= dPr3_dt_g(time,in);
}

void differential_ggh(double time, double in[], double out[]) // state:2
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_g(time,in);
	out[i_Pr2]= dPr2_dt_g(time,in);
	out[i_Pr3]= dPr3_dt_h(time,in);
}

void differential_ghg(double time, double in[], double out[]) // state:3
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_g(time,in);
	out[i_Pr2]= dPr2_dt_h(time,in);
	out[i_Pr3]= dPr3_dt_g(time,in);
}

void differential_hgg(double time, double in[], double out[]) // state:4
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_h(time,in);	
	out[i_Pr2]= dPr2_dt_g(time,in);
	out[i_Pr3]= dPr3_dt_g(time,in);
}

void differential_ghh(double time, double in[], double out[]) // state:5
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_g(time,in);	
	out[i_Pr2]= dPr2_dt_h(time,in);
	out[i_Pr3]= dPr3_dt_h(time,in);
}

void differential_hgh(double time, double in[], double out[]) // state:6
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_h(time,in);	
	out[i_Pr2]= dPr2_dt_g(time,in);
	out[i_Pr3]= dPr3_dt_h(time,in);
}

void differential_hhg(double time, double in[], double out[]) // state:7
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_h(time,in);	
	out[i_Pr2]= dPr2_dt_h(time,in);
	out[i_Pr3]= dPr3_dt_g(time,in);
}

void differential_hhh(double time, double in[], double out[]) // state:8
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_N3]= dN3_dt(time,in);
	out[i_Pr1]= dPr1_dt_h(time,in);	
	out[i_Pr2]= dPr2_dt_h(time,in);
	out[i_Pr3]= dPr3_dt_h(time,in);
}

void rk4(double p[], double k1[],int n, double t, double h, double pout[],void(*diff)(double,double[],double[]))
{
	int i;
	double tt,*k2,*k3,*k4,*pp;

	k2= d_vector(n);
	k3= d_vector(n);
	k4= d_vector(n);
	pp= d_vector(n);

	for (i=1;i<=n;i++) pp[i]= p[i]+ k1[i]*h/2;
	(*diff)(t+h/2,pp,k2);
	for (i=1;i<=n;i++) pp[i]= p[i]+ k2[i]*h/2;
	(*diff)(t+h/2,pp,k3);
	for (i=1;i<=n;i++) pp[i]= p[i]+ k3[i]*h;
	(*diff)(t+h,pp,k4);
	
	for(i=1;i<=n;i++) pout[i]= p[i]+ (k1[i]+2.0*k2[i]+2.0*k3[i]+k4[i])*h/6;

	free_d_vector(k2);
	free_d_vector(k3);
	free_d_vector(k4);
	free_d_vector(pp);
}
double *d_vector(long size) 
{
	double *x;
	x= (double *) malloc((size_t)((size+1)*sizeof(double)));
	if(x==NULL) message_error("Allocation failure in d_vector()");
	return x;
}
double **d_matrix(long size_row, long size_column)
{
	double **x;
	long i;
	long size_row_P= size_row+1;
	long size_column_P= size_column+1;

	x= (double **) malloc((size_t)(size_row_P*sizeof(double *))); //first dimension
	if (x==NULL) message_error("Allocation failure in d_vector()");
	x[0]= (double *) malloc((size_t)(size_row_P*size_column_P*sizeof(double))); //second dimension
	if (x[0]==NULL) message_error("Allocation failure in d_vector()");
	for(i=1;i<size_row_P;i++) x[i]= x[0]+ i*size_column_P;
	return x;
}
void free_d_matrix(double **x)
{
	free(x[0]);
	free(x);
}
void free_d_vector(double *x) {	free(x);}



//gcc p2.c -o p2.out
//./p2.out>p2.dat
//gnuplot
//plot 'p2.dat' using 4:1 title 'R1' with lines lc 2,\
//'p2.dat' using 4:2 title 'R2' with lines lc 3,\
//'p2.dat' using 4:3 title 'P' with lines lc 7

//set terminal jpeg
//set output '5.jpg'
//replot
//exit