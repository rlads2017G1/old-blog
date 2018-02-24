#include <stdio.h>
#include <stdlib.h>
#include <math.h>    // Gauss operator
#include <time.h>

// Functions
double floor(double x); // Gauss operator
double r2()
{return (double)rand() / (double)RAND_MAX ;} // random number between 0, 1
void message_error(char error_text[]);
double *d_vector(long size); //vector creator
double **d_matrix(long size_row, long size_column); //matrix creater
void free_d_vector(double *x);
void free_d_matrix(double **x);
void rk4(double p[], double k1[],int n, double t, double h, double pout[],void(*diff)(double,double[],double[]));
void differential_g(double time,double in[],double out[]); //good year diff
void differential_h_1(double time,double in[],double out[]); //harsh year diff
void differential_h_2(double time,double in[],double out[]); //harsh year diff
void differential_h_3(double time,double in[],double out[]); //harsh year diff
double dN1_dt(double time, double vr[]);
double dN2_dt(double time, double vr[]);
double dPr1_dt_g(double time, double vr[]); //good year prey 1
double dPr1_dt_h_1(double time, double vr[]); //harsh year1 prey 1
double dPr1_dt_h_2(double time, double vr[]); //harsh year2 prey 1
double dPr1_dt_h_3(double time, double vr[]); //harsh year3 prey 1

double dPr2_dt_g(double time, double vr[]); //good year prey 2
double dPr2_dt_h_1(double time, double vr[]); //harsh year1 prey 2
double dPr2_dt_h_2(double time, double vr[]); //harsh year2 prey 2
double dPr2_dt_h_3(double time, double vr[]); //harsh year3 prey 2

//double dPr2_dt(double time, double vr[]); //vr is variable


// Global variables
int i_N1= 1; //index of sex population
int i_N2= 2; //index of asex population
int i_Pr1= 3; //index of prey 1
int i_Pr2= 4; //index of prey 2

double b1= 0.1; // birth rate of sex
double b2= 0.2; // birth rate of asex
double d1= 0.015; // death rate of sex
double d2= 0.015; // death rate of asex
double c11= 0.25; // consumption matrix parameter
double c12= 0.25; // consumption matrix parameter
double c21= 0.0; // consumption matrix parameter
double c22= 0.5; // consumption matrix parameter

double k1_g= 1; // carrying capacity of prey 1: good year
double k2_g= 1; // carrying capacity of prey 2: good year

double k1_h_1= 0.5; // carrying capacity of prey 1: harsh year
double k2_h_1= 0.1; // carrying capacity of prey 2: harsh year
double k1_h_2= 0.1; // carrying capacity of prey 1: harsh year
double k2_h_2= 0.5; // carrying capacity of prey 2: harsh year
double k1_h_3= 0.1; // carrying capacity of prey 1: harsh year
double k2_h_3= 0.1; // carrying capacity of prey 2: harsh year


double a1= 0.15; // growth rate of prey 1
double a2= 0.15; // growth rate of prey 2
double gh_rate=0.1; // good-harsh alternating rate
double h1=0.6; // 0~h1: harsh year 1
double h2=1; // h1~h2: harsh year 2  h2~1: harsh year 3

int state; //initial state good year: 1   harsh year:0


// Main function
int main (void)
{
	// Initialize parameters
		int i,j;  // add gen
		double random,random2,gen=0.0, t= 0.0;
		int T= 300000; // number of calculations
		double deltat= 900.0/T; // length of time step
		double *p= d_vector(4);
		double *dfdt= d_vector(4);
	// double **log= d_matrix(T,4); //create log matrix
	// Creating log file
		FILE *out;
		out= fopen("./data/varHarsh_fluc.txt","w");
	// Initial Condition
		p[i_N1]= 0.4;
		p[i_N2]= 0.4;
		p[i_Pr1]= 0.5;
		p[i_Pr2]= 0.5;
		state=0;
    fprintf(out, "time\tN1\tN2\tPr1\tPr2\n");
    fprintf(out, "%lf\t%lf\t%lf\t%lf\t%lf\n", t, p[i_N1], p[i_N2], p[i_Pr1], p[i_Pr2]);
/*
	log[0][i_x]= 1;// initial population of x
	log[0][i_y]= 1;// initial population of y
	log[0][i_p]= 1;// initial population of p
	log[0][4]= t;// initial time 
*/
	//for (i=1;i<=3;i++) printf("%lf ",log[0][i]);// check initialization
	//printf("\n");// check initialization

	srand(time(NULL)); // clear random number generator
	
	for (i=1;i<=T;i++){//create for loop
		if(gen-floor(t)<=0) {  // New generation
			gen=gen+1.0;
			random=r2();
			//printf("%lf", random);
			// if current state==1
			if(random<gh_rate && state==1){ //change state[1]: good -> harsh
				random2=r2();
				if(0<=random2 && random2<h1){  // harsh year 1
					differential_h_1(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_1);
					t+=deltat;	
					state=0;
					//printf("state: 0\n");
				}
				else if(h1<=random2 && random2<h2){ // harsh year 2
					differential_h_2(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_2);
					t+=deltat;	
					state=0;
				}
				else if(h2<=random2 && random2<=1){ // harsh year 3
					differential_h_3(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_3);
					t+=deltat;	
					state=0;
				}
			}
			else if(random>=gh_rate && state==1){ // retain state[1]: good -> good
				differential_g(t,p,dfdt);
				rk4(p, dfdt, 4, t, deltat, p, differential_g);
				t+=deltat;
				state=1;
				//printf("state: 1\n");
			}
			// if current state==0
			else if(random<gh_rate && state==0){ //change state[1]: harsh -> good
				differential_g(t,p,dfdt);
				rk4(p, dfdt, 4, t, deltat, p, differential_g);
				t+=deltat;
				state=1;
				//printf("state: 1\n");
			}
			else if(random>=gh_rate && state==0){ //change state[1]: harsh -> harsh
				random2=r2();
				if(0<=random2 && random2<h1){  // harsh year 1
					differential_h_1(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_1);
					t+=deltat;	
					state=0;
					//printf("state: 0\n");
				}
				else if(h1<=random2 && random2<h2){ // harsh year 2
					differential_h_2(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_2);
					t+=deltat;	
					state=0;
				}
				else if(h2<=random2 && random2<=1){ // harsh year 3
					differential_h_3(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_3);
					t+=deltat;	
					state=0;
				}
			}
		}
		else {
			if(state==1) {
				differential_g(t,p,dfdt);
				rk4(p, dfdt, 4, t, deltat, p, differential_g);
				t+=deltat;				
			}
			else {
				random2=r2();
				if(0<=random2 && random2<h1){  // harsh year 1
					differential_h_1(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_1);
					t+=deltat;	
				}
				else if(h1<=random2 && random2<h2){ // harsh year 2
					differential_h_2(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_2);
					t+=deltat;	
				}
				else if(h2<=random2 && random2<=1){ // harsh year 3
					differential_h_3(t,p,dfdt);
					rk4(p, dfdt, 4, t, deltat, p, differential_h_3);
					t+=deltat;	
				}

			}
		}

		if(p[i_N1]<0||p[i_N2]<0||p[i_Pr1]<0||p[i_Pr2]<0) {
			printf("dynamics crashed\n");
			exit(2);
		}
		// Print the values
		fprintf(out,"%lf\t%lf\t%lf\t%lf\t%lf\n", t, p[i_N1], p[i_N2], p[i_Pr1], p[i_Pr2]);
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
{return b1*vr[i_N1]*(vr[i_Pr2]*c12+vr[i_Pr1]*c11)-d1*vr[i_N1];}

double dN2_dt(double time, double vr[])
{return b2*vr[i_N2]*(vr[i_Pr2]*c22+vr[i_Pr1]*c21)-d2*vr[i_N2];}

double dPr1_dt_g(double time, double vr[])
{return a1*vr[i_Pr1]*(1-vr[i_Pr1]/k1_g)-vr[i_Pr1]*(vr[i_N2]*c21+vr[i_N1]*c11);} // Prey 1: good year
double dPr2_dt_g(double time, double vr[])
{return a2*vr[i_Pr2]*(1-vr[i_Pr2]/k2_g)-vr[i_Pr2]*(vr[i_N2]*c22+vr[i_N1]*c12);} // Prey 2: good year

double dPr1_dt_h_1(double time, double vr[])
{return a1*vr[i_Pr1]*(1-vr[i_Pr1]/k1_h_1)-vr[i_Pr1]*(vr[i_N2]*c21+vr[i_N1]*c11);} // Prey 1: harsh year 1
double dPr2_dt_h_1(double time, double vr[])
{return a2*vr[i_Pr2]*(1-vr[i_Pr2]/k2_h_1)-vr[i_Pr2]*(vr[i_N2]*c22+vr[i_N1]*c12);} // Prey 2: harsh year 1

double dPr1_dt_h_2(double time, double vr[])
{return a1*vr[i_Pr1]*(1-vr[i_Pr1]/k1_h_2)-vr[i_Pr1]*(vr[i_N2]*c21+vr[i_N1]*c11);} // Prey 1: harsh year 2
double dPr2_dt_h_2(double time, double vr[])
{return a2*vr[i_Pr2]*(1-vr[i_Pr2]/k2_h_2)-vr[i_Pr2]*(vr[i_N2]*c22+vr[i_N1]*c12);} // Prey 2: harsh year 2

double dPr1_dt_h_3(double time, double vr[])
{return a1*vr[i_Pr1]*(1-vr[i_Pr1]/k1_h_3)-vr[i_Pr1]*(vr[i_N2]*c21+vr[i_N1]*c11);} // Prey 1: harsh year 3
double dPr2_dt_h_3(double time, double vr[])
{return a2*vr[i_Pr2]*(1-vr[i_Pr2]/k2_h_3)-vr[i_Pr2]*(vr[i_N2]*c22+vr[i_N1]*c12);} // Prey 2: harsh year 3


void differential_g(double time, double in[], double out[]) // good year differential
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_Pr1]= dPr1_dt_g(time,in);
    out[i_Pr2]= dPr2_dt_g(time,in);
}

void differential_h_1(double time, double in[], double out[]) // harsh year 1 differential
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_Pr1]= dPr1_dt_h_1(time,in);
	out[i_Pr2]= dPr2_dt_h_1(time,in);
}

void differential_h_2(double time, double in[], double out[]) // harsh year 2 differential
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_Pr1]= dPr1_dt_h_2(time,in);
	out[i_Pr2]= dPr2_dt_h_2(time,in);
}

void differential_h_3(double time, double in[], double out[]) // harsh year 3 differential
{
	out[i_N1]= dN1_dt(time,in);
	out[i_N2]= dN2_dt(time,in);
	out[i_Pr1]= dPr1_dt_h_3(time,in);
	out[i_Pr2]= dPr2_dt_h_3(time,in);
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