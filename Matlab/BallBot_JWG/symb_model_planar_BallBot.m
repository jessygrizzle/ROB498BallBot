% symb_model_planar_BallBot.m
%
clear *
%
% This is for Calculus: Planar BallBot model
%
%
% Jbot = inertia of Mbot about its own CoM; 
% Jwheels = total inertia of each wheesl about their axis of rotation, including the intertia of the rotors of the motors
% Jball = inertia of ball 
%
% mBot = mass of the Mbot, including motors, wheels, battery, etc.
% mBall = mass of the ball 
%
% R = radius of the ball
% r = radius of the Mbot's wheels
%
% L = distance from the center of the ball to the center of mass of the Mbot
%
% reference: thBot = absolute angle for the Mbot, measured clockwise from the vertical
%
% reference: thBall = relative angle of the ball's rotation w.r.t. the Mbot, measured
% clockwise from the Mbot ===> absolute angle of ball = Mbot angle +  ball angle
%
% reference: thWheel = relative angle of the Mbot's wheel rotation w.r.t. the Mbot, measured
% clockwise from the Mbot ===> r*thWheel = - R thBall
%
% reference:  x = position measured from left to right between a 'wall' and the 
% center of the ball = R * absolute angle of the ball
%
% reference: y = vertical height, set to zero at the radius of the ball = R.
%
% R*(theta + phi) = x  ==> theta = x/R  - phi
% thWheel = - (R/r) thBall

if 1 % general model
    syms g L R r mBot mBall Jbot Jball Jwheels
end


% % sigma is the angular momentum abut the contact point of the wheel
% % (xc, yc) = center of mass position of the entire robot: wheel plus body

if 1 % coordinate choices
    syms thBot dthBot x dx 
    q=[thBot x].';
    dq=[dthBot dx].';
    thBall = x/R - thBot
    dthBall = dx/R - dthBot
    model = 'One'
else
    syms thBot dthBot thBall dthBall
    q=[thBot thBall].';
    dq=[dthBot dthBall].';
    x = R*(thBall + thBot)
    dx = R*(dthBall+ dthBot)
    model = 'Two'
end

% r*thetawheel = -R*theta
thWheel = -(R/r)*thBall
dthWheel = -(R/r)*dthBall


%
% initial center of ball is set as origin
pBall=[x;0];
pBot_centermass=pBall+L*[sin(thBot);cos(thBot)];
pcm = (mBall * pBall + mBot * pBot_centermass)/(mBall+mBot)
%
%
% vBall =  jacobian(pBall,q)*dq;
% vpend_centermass = jacobian(pMbot_centermass,q)*dq;
vcm = jacobian(pcm,q)*dq;
%
%
KEcm = simplify((1/2)*(mBall+mBot)*vcm.'*vcm)

KErotation=simplify((1/2)*Jbot*(thBot)^2 + (1/2)*Jball*(dthBall+ dthBot)^2) +(1/2)*Jwheels*(dthWheel)^2
%
KE = (KEcm+KErotation);
KE = simplify(KE)
%
%
%
PE = g*(mBall+mBot)*pcm(2);
PE = simplify(PE);
%
%
% Model NOTATION: Spong and Vidyasagar, page 142, Eq. (6.3.12)
%                 D(q)ddq + C(q,dq)*dq + G(q) = B*tau
%
Lagrangian=KE-PE;

G=jacobian(PE,q).';
G=simplify(G);
D=simplify(jacobian(KE,dq).');
D=simplify(jacobian(D,dq));

% For the linearized model
JacG=jacobian(G,q).';
JacG=simplify(JacG);

syms C real
n=max(size(q));
for k=1:n
    for j=1:n
        C(k,j)=0*g;
        for i=1:n
            C(k,j)=C(k,j)+(1/2)*(diff(D(k,j),q(i))+diff(D(k,i),q(j))-diff(D(i,j),q(k)))*dq(i);
        end
    end
end
C=simplify(C);
%
% Compute the matrix for the input torque
%
E=thWheel;
B=jacobian(E,q).'
%

save work_calculus_symb_model_planar_BallBot


%
switch model
    case 'One'
        generate_dynamic_model_2DOF     % for the coordinates (thBot, x)
    otherwise
        generate_dynamic_model_2DOF_v02 % for the coordinates (thBot, thBall)
end
        
return

