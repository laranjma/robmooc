function ex_dubins

%  --------------Main----------------
x=[0;0;0.1];
clf; axis([-20,20,-20,20]); axis square; hold on;
draw_tank(x,'blue');
drawnow();
end