function [D,C,G,B] = dyn_mod_BallBot_v02(q,dq)
%DYN_MOD_BALLBOT_V02

%24-May-2023 16:58:28


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
thBot=q(1);thBall=q(2);
dthBot=dq(1);dthBall=dq(2);
%
%
%
%
D=zeros(2,2);
D(1,1)=Jball + (2*(mBall/2 + mBot/2)*(R*mBall + R*mBot + L*mBot*...
         cos(thBot))^2)/(mBall + mBot)^2 + (L^2*mBot^2*...
         sin(thBot)^2)/(mBall + mBot);
D(1,2)=Jball + R^2*mBall + R^2*mBot + L*R*mBot*cos(thBot);
D(2,1)=Jball + R^2*mBall + R^2*mBot + L*R*mBot*cos(thBot);
D(2,2)=(Jwheels*R^2 + Jball*r^2 + R^2*mBall*r^2 + R^2*mBot*...
         r^2)/r^2;
%
%
%
C=zeros(2,2);
C(1,1)=-L*R*dthBot*mBot*sin(thBot);
C(2,1)=-L*R*dthBot*mBot*sin(thBot);
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
B(2)=-R/r;
%
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