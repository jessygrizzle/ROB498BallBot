% generate_dynamic_model_2DOF.m
%
% File to automatically build up the .m-files needed for our simualtor
%

%load Mat/work_symb_model_abs;

fcn_name = 'dyn_mod_BallBot_v02';

disp(['[creating ',upper(fcn_name),'.m]']);
fid = fopen([fcn_name,'.m'],'w');
n=max(size(q));
fprintf(fid,['function [D,C,G,B] =' ...
        ' %s(q,dq)\n'],fcn_name);
fprintf(fid,'%%%s\n\n',upper(fcn_name));
fprintf(fid,'%%%s\n\n',datestr(now));
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','% Author(s): Grizzle');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','% Model NOTATION: Spong and Vidyasagar, page 142, Eq. (6.3.12)');
fprintf(fid,'\n%s','%                 D(q)ddq + C(q,dq)*dq + G(q) = B*tau');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');

fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','[g L R r mBot mBall Jbot Jball Jwheels] = modelParams();');
fprintf(fid,'\n%s','%');

fprintf(fid,'\n%s','thBot=q(1);thBall=q(2);');
fprintf(fid,'\n%s','dthBot=dq(1);dthBall=dq(2);');

fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s',['D=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=D(i,j);
        if Temp0 ~= 0
            Temp1=char(Temp0);
            Temp2=['D(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
% fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s',['C=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=C(i,j);
        if Temp0 ~= 0
            %ttt = char(vectorize(jac_P(2)));
            Temp1=char(Temp0);
            Temp2=['C(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s',['G=zeros(',num2str(n),',1);']);
for i=1:n
    Temp1=char(G(i));
    Temp2=['G(',num2str(i),')=',Temp1,';'];
    Temp3=fixlength(Temp2,'*+-',65,'         ');
    fprintf(fid,'\n%s',Temp3);
end
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
[n,m]=size(B);
fprintf(fid,'\n%s',['B=zeros(',num2str(n),',',num2str(m),');']);
for i=1:n
    for j=1:m
        Temp0=B(i,j);
        if Temp0 ~= 0
            Temp1=char(Temp0);
            Temp2=['B(',num2str(i),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s',['JacG=zeros(',num2str(n),',',num2str(n),');']);
for i=1:n
    for j=1:n
        Temp0=JacG(i,j);
        if Temp0 ~= 0
            Temp1=char(Temp0);
            Temp2=['JacG(',num2str(i),',',num2str(j),')=',Temp1,';'];
            Temp3=fixlength(Temp2,'*+-',65,'         ');
            fprintf(fid,'\n%s',Temp3);
        end
    end
end
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','%');
fprintf(fid,'\n%s','return');
status = fclose(fid)
