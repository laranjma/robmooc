function ex_tank_line
close all;
clear all;
clc;

function xdot=f(x,u)
    theta=x(3);
    xdot=[cos(theta);sin(theta);u];
end

function xdot=f2(x,u)
    theta=x(3);
    v=x(4);
    xdot=[v*cos(theta);v*sin(theta);u;0];
end

function u=commandLeader(x,a,b)
    phi = atan2(b(2)-a(2),b(1)-a(1));
    e = det([b-a,x(1:2)-a])/norm(b-a); % distance a ligne
    thetabar = phi - atan(e);
    u=atan(tan((thetabar - x(3))/2));
end

function u=command(X,k,a,b,w,t)
    phi = atan2(b(2)-a(2),b(1)-a(1));
    el = det([b-a,X(1:2,k)-a])/norm(b-a); % distance a ligne
    ec = norm(-X(1:2,k-1)+X(1:2,k));
    thetabar = phi - atan(el);
    u1 = atan(tan((thetabar - X(3,k))/2)); % suivre la ligne
    K=10;
    w=0.1;
    u2 = K*(1/ec)*cos(w*t);
    u=u1 + u2;
end

% ---------- main ---------- %
% Consigne
l = 20; % square half-width
A=[-l,-l, l, l;-l, l, l, -l];
B=[-l, l, l,-l; l, l,-l, -l];
% Init robots
x0=[-20;-20;4;1];  % x,y,theta,v #
m=5; % nombre des robots
dr=10; % initial distance between robots
S=ones(1,m); % robot line # to follow
X=x0*ones(1,m);
for r=1:m
    x0 = x0 + [-dr;-dr;0;0.3];
    X(:,r) = x0;
end
dt=0.1;
t=0;
[imax,lmax] = size(A);
while(true)
    clf(); hold on; axis([-40 40 -40 40]); axis square;
    % for all robots...
    for k=1:m
        % take line path
        li=S(k); % line to follow
        a = A(1:2,li);
        b = B(1:2,li);
        while((b-a).'*(b-X(1:2,k)) < 0)
            % Take next line
            li = li +1;
             S(k)=li;
            if(li <= lmax)
                a = A(1:2,li);
                b = B(1:2,li);
            else
                return;
            end
        end
        if(k ==1)
            % Leader command
            u=commandLeader(X(:,k),a,b);
            color = 'green';
        else
            w=3;
            u=command(X,k,a,b,w,t);
            color = 'blue';
        end
        % Draw
        %X(1:3,k)=X(1:3,k)+f2(X(1:3,k),u)*dt;
        X(:,k)=X(:,k)+f2(X(:,k),u)*dt;
        t=t+dt;
        draw_tank(X(1:3,k),color);
    end
    plot([A(1,:);B(1,:)],[A(2,:);B(2,:)],'red');
    drawnow();
end
end


