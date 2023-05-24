[D,C,G,B,JacG] = dyn_mod_BallBot(zeros(2,1),zeros(2,1))

A= [zeros(2,2) eye(2); -inv(D)*JacG zeros(2,2)]
B = [zeros(2,1); inv(D)*B]
Cx = [0 1 0 0]
Cth = [1 0 0 0]

syms s

Gx = Cx*inv(s*eye(4)-A)*B;

Gth = Cth*inv(s*eye(4)-A)*B;

Gxoverth = Gx/Gth

[num,den]=numden(Gxoverth)


% Gx = 1.223e+15/(s^2*(5.6295e+14*s^2 - 8.0095e+15)) - 0.089505/s^2

% Gx = vpa(1/(s^2*((5.6295e+14/1.223e+15)*s^2 - 8.0095e+15/1.223e+15)) - 0.089505/s^2, 5)

Gs = simplify(Gs)

[num,den]=numden(Gs)

num = vpa(num/1e30,5)

den=vpa(den/1e30,5)