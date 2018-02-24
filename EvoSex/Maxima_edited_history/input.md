## General Form Lotka-Volterra Predator-Prey Equations
```maxima
'diff(N[i],t,1) = (C . S)[i]*N[i]*b[i]-N[i]*d[i];
'diff(S[j],t,1) = S[j]*a[j]*(1-S[j]/k[j])-(C_trans . N)[j]*S[j];
```

## Convert to Competition Equations

### Solve for Equilibrium $S_j$
```maxima
eq_s1: S_1*a_1*(1-S_1/k_1)-S_1*(N_2*c_21+N_1*c_11) = 0;
eq_s2: S_2*a_2*(1-S_2/k_2)-S_2*(N_2*c_22+N_1*c_12) = 0;
```

#### Equilibrium $S_j$
```maxima
S_1e : -((N_2*c_21+N_1*c_11-a_1)*k_1)/a_1;
S_2e : -((N_2*c_22+N_1*c_12-a_2)*k_2)/a_2;
```
$$\left[ {\it S\__1}=-{{\left({\it N\__2}\,{\it c\__{21}}+{\it N\__1}
 \,{\it c\__{11}}-{\it a\__1}\right)\,{\it k\__1}}\over{{\it a\__1}}}
  , {\it S\__1}=0 \right] $$

$$\left[ {\it S\__2}=-{{\left({\it N\__2}\,{\it c\__{22}}+{\it N\__1}
 \,{\it c\__{12}}-{\it a\__2}\right)\,{\it k\__2}}\over{{\it a\__2}}}
  , {\it S\__2}=0 \right] $$

### Competition Equations
```maxima
eq_n1: 'diff(N_1,t,1) = N_1*b_1*(S_2*c_12+S_1*c_11)-N_1*d_1;
eq_n2: 'diff(N_2,t,1) = N_2*b_2*(S_2*c_22+S_1*c_21)-N_2*d_2;
```

```maxima
com_eq_n1: eq_n1, S_1=S_1e, S_2=S_2e;
com_eq_n2: eq_n1, S_1=S_1e, S_2=S_2e;
```

```maxima
'diff(N_1,t,1) = N_1*b_1*((-(c_12*(N_2*c_22+N_1*c_12-a_2)*k_2)/a_2)-(c_11*(N_2*c_21+N_1*c_11-a_1)*k_1)/a_1)-N_1*d_1;
'diff(N_1,t,1) = N_2*b_2*((-(c_22*(N_2*c_22+N_1*c_12-a_2)*k_2)/a_2)-(c_21*(N_2*c_21+N_1*c_11-a_1)*k_1)/a_1)-N_2*d_2;
```

$${{d}\over{d\,t}}\,{\it N_1}={\it N_1}\,{\it b_1}\,\left(-{{
 {\it c_{12}}\,\left({\it N_2}\,{\it c_{22}}+{\it N_1}\,
 {\it c_{12}}-{\it a_2}\right)\,{\it k_2}}\over{{\it a_2}}}-
 {{{\it c_{11}}\,\left({\it N_2}\,{\it c_{21}}+{\it N_1}\,
 {\it c_{11}}-{\it a_1}\right)\,{\it k_1}}\over{{\it a_1}}}
 \right)-{\it N_1}\,{\it d_1}$$

$${{d}\over{d\,t}}\,{\it N_1}={\it N_2}\,{\it b_2}\,\left(-{{
 {\it c_{22}}\,\left({\it N_2}\,{\it c_{22}}+{\it N_1}\,
 {\it c_{12}}-{\it a_2}\right)\,{\it k_2}}\over{{\it a_2}}}-
 {{{\it c_{21}}\,\left({\it N_2}\,{\it c_{21}}+{\it N_1}\,
 {\it c_{11}}-{\it a_1}\right)\,{\it k_1}}\over{{\it a_1}}}
 \right)-{\it N_2}\,{\it d_2}$$

#### Set Consumption Matrix

$\pmatrix{c_{11}&c_{12}\cr c_{21}&c_{22}\cr }$ with $c_{21}=0$, gives $\pmatrix{c_{11}&c_{12}\cr 0&c_{22}\cr }$

$${{d}\over{d\,t}}\,{\it N_1}={\it N_1}\,{\it b_1}\,\left(-{{
 {\it c_{12}}\,\left({\it N_2}\,{\it c_{22}}+{\it N_1}\,
 {\it c_{12}}-{\it a_2}\right)\,{\it k_2}}\over{{\it a_2}}}-
 {{{\it c_{11}}\,\left({\it N_2}\,{\it c_{21}}+{\it N_1}\,
 {\it c_{11}}-{\it a_1}\right)\,{\it k_1}}\over{{\it a_1}}}
 \right)-{\it N_1}\,{\it d_1}$$
 
$${{d}\over{d\,t}}\,{\it N_2}=-{{{\it N_2}\,{\it b_2}\,
 {\it c_{22}}\,\left({\it N_2}\,{\it c_{22}}+{\it N_1}\,
 {\it c_{12}}-{\it a_2}\right)\,{\it k_2}}\over{{\it a_2}}}-
 {\it N_2}\,{\it d_2}$$

## Classical LK Compitition

```maxima
'diff(N_1,t) = r_1*(1-(N_1+alpha_12*N_2)/K_1)*N_1 - d_1*N_1;
'diff(N_2,t) = r_2*(1-(N_2+alpha_21*N_1)/K_2)*N_2 - d_2*N_2;
```

$${{d}\over{d\,t}}\,{\it N_1}={\it r_1}{\it N_1} \left(1-{{{\it N_1} + {\it N_2}{\it \alpha_{12}}}\over{{\it K_1}}}\right)\,
  - {\it d_1}{\it N_1}$$



