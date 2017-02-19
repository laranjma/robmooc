function ex_bezier
    function  xdot  = f(x,u)
        xdot=[x(4)*cos(x(3)); x(4)*sin(x(3)); u(1); u(2)];
    end
%----------      Main     -----------------
axis([-1 11 -1 11]); axis square; hold on;
A1=[2 4 2 ; 0 2 7 ];
A2=[7 8 3 ; 2 3 10];
fill(A1(1,:),A1(2,:),'black');
fill(A2(1,:),A2(2,:),'black');
x=[0;0;0;1]; 
draw_tank(x,'blue',0.1);
drawnow();
end
