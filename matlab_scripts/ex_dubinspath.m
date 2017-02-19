function ex_dubinspath


%----------    Main    ------------
init; 
a=[-20;10;-3]; b=[20;-10;2]; ech=40;  %simu1
axis([-ech ech -ech ech]); axis square; hold on;
draw_tank(a,'black'); draw_tank(b,'blue');
end