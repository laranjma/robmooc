from roblib import *

def draw_pools(x):
    x=x.flatten()
    plot([0,0],[10,1],'black',linewidth=2)    
    plot([-7,23],[0,0],'black',linewidth=5)    
    plot([16,16],[1,10],'black',linewidth=2)    
    plot([4,4,6,6],[10,1,1,10],'black',linewidth=2)    
    plot([10,10,12,12],[10,1,1,10],'black',linewidth=2)    
    P=array([[0,x[0]],[0,1],[-6,0],[22,0],[16,1],[16,x[2]],[12,x[2]],[12,1]
            ,[10,1],[10,x[1]],[6,x[1]],[6,1],[4,1],[4,x[0]]])
    draw_polygon(P,ax,'blue')       
    P=array([[1,10],[1,x[0]],[1+0.1*u[0],x[0]],[1+0.1*u[0],10]])            
    draw_polygon(P,ax,'blue')
    P=array([[13,10],[13,x[2]],[13+0.1*u[1],x[2]],[13+0.1*u[1],10]])            
    draw_polygon(P,ax,'blue')


dt = 0.05
x = array([[4],[5],[2]])
u = array([[1],[2]])

def q(h):
	a = 0.4 # pool area
	g = 9.81 # gravite
	qh = a*np.sign(h)*sqrt(2*g*abs(h))
	return qh
	
	
def regulation(x,w,dw,ei,dt):
	y = array([[x[0,0]],[x[2,0]]])
	b = array([[-q(x[0,0]) - q(x[0,0]-x[1,0])], [-q(x[2,0]) + q(x[1,0]-x[2,0])]])
	e = np.subtract(w,y)
	ei = ei + e*dt
	v = ei + 2*e + dw
	u = v - b
	return u

def f(x,u):
	xdot = array([[-q(x[0,0]) - q(x[0,0]-x[1,0]) + u[0,0]],
	              [q(x[0,0]-x[1,0]) - q(x[1,0]-x[2,0])],
	              [-q(x[2,0]) + q(x[1,0]-x[2,0]) + u[1,0]]])
	return xdot
    

fig = figure(0)    
ax = fig.add_subplot(111, aspect='equal')

for t in arange(0,10,dt) :
	pause(0.01)
	cla()
	ax.set_xlim(-10,25)
	ax.set_ylim(-2,12)
	draw_pools(x)
	# consigne
	w = array([[3],[3]])
	dw = array([[0],[0]])
	# initialisation de l'erreur integrale
	ei = 0
	u = regulation(x,w,dw,ei,dt)
	x = x + dt*f(x,u)  
show()
