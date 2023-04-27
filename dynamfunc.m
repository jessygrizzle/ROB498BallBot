function dynamics = dynamfunc(t,in2,u1)
%DYNAMFUNC
%    DYNAMICS = DYNAMFUNC(T,IN2,U1)

%    This function was generated by the Symbolic Math Toolbox version 8.6.
%    26-Apr-2023 18:58:25

q2 = in2(2,:);
q3 = in2(3,:);
q4 = in2(4,:);
t2 = cos(q3);
t3 = sin(q3);
t4 = q4.^2;
t5 = t2.^2;
t6 = q3.*t4;
t8 = t2.*5.012440875e-5;
t7 = sin(t6);
t9 = t5.*7.5919536225e-4;
t10 = -t9;
t11 = t8+t10+5.57299569888425e-3;
t12 = 1.0./t11;
dynamics = [q2;t12.*(t3.*9.44103263688e-4+t7.*4.71552462057456e-3+u1.*2.133800952e-2-t2.*t3.*2.85991929741024e-2+t2.*u1.*1.65321e-3).*(2.5e+1./1.2e+1);q4;t12.*(t3.*(-2.0282813078697e-3)-t7.*1.5037322625e-6+u1.*1.104253125e-4+t2.*t7.*4.5551721735e-5+t2.*u1.*2.0665125e-4).*(-5.0e+1./3.0)];
