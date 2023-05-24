function [D,C,G,B,JacG] = dyn_mod_BallBot(q,dq)
%DYN_MOD_BALLBOT

%24-May-2023 18:22:00


%
% Author(s): Grizzle
%
%
% Model NOTATION: Spong and Vidyasagar, page 142, Eq. (6.3.12)
%                 D(q)ddq + C(q,dq)*dq + G(q) = B*tau
%
%
%
%
[g L R r mBot mBall Jbot Jball Jwheels] = modelParams();
%
thBot=q(1);x=q(2);
dthBot=dq(1);dx=dq(2);
%
%
%
%
D=zeros(2,2);
D(1,1)=(L^2*mBot^2*r^2 + Jwheels*R^2*mBall + Jwheels*R^2*...
         mBot)/(r^2*(mBall + mBot));
D(1,2)=L*mBot*cos(thBot) - (Jwheels*R)/r^2;
D(2,1)=L*mBot*cos(thBot) - (Jwheels*R)/r^2;
D(2,2)=mBall + mBot + Jball/R^2 + Jwheels/r^2;
%
%
%
C=zeros(2,2);
C(2,1)=-L*dthBot*mBot*sin(thBot);
%
%
%
%
G=zeros(2,1);
G(1)=-L*g*mBot*sin(thBot);
G(2)=0;
%
%
%
%
B=zeros(2,1);
B(1)=R/r;
B(2)=-1/r;
%
%
%
%
JacG=zeros(2,2);
JacG(1,1)=-L*g*mBot*cos(thBot);
%
%
%
return