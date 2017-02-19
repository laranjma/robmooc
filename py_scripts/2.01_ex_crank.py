from roblib import *

def draw_crank(x): 
    θ1=x[0,0]
    θ2=x[1,0]
    z=L1*array([[cos(θ1)],[sin(θ1)]])
    y=z+L2*array([[cos(θ1+θ2)],[sin(θ1+θ2)]])
    plot( [0,z[0,0],y[0,0]],[0,z[1,0],y[1,0]],'magenta', linewidth = 2)   
    draw_disk(c,r,ax,"cyan")

L1,L2 = 4,3
c = array([[1],[2]])
r=4
dt = 0.05

x = array([[-1],[1]])

def consigne(r,c,t):
	w = c + r*array([[cos(t)],[sin(t)]])
	dw = array([[-r*sin(t)], [r*cos(t)]])
	return w,dw

def regulation(l1,l2,θ1,θ2,w,dw):
	# Observation
	z=l1*array([[cos(θ1)],[sin(θ1)]])
	y=z+l2*array([[cos(θ1+θ2)],[sin(θ1+θ2)]])
    # Regulation
	A = array([[1.,2.],[3.,4.]])
	A[0][0] = -y[1,0] #-l1*sin(θ1) - l2*sin(θ1+θ2)
	A[0][1] = -l2*sin(θ1+θ2)
	A[1][0] =  y[0,0] #l1*cos(θ1) + l2*cos(θ1+θ2)
	A[1][1] =  l2*cos(θ1+θ2)	
	Ainv = inv(A)
	v = w-y +dw
	u = dot(Ainv,v)
	return u

def f(x,w,dw):
    θ1=x[0,0]
    θ2=x[1,0]    
    u = regulation(L1,L2,θ1,θ2,w,dw)
    dθ1=u[0,0]
    dθ2=u[1,0]
    return(array([[dθ1],[dθ2]]))
    

fig = figure(0)    
ax = fig.add_subplot(111, aspect='equal')

for t in arange(0,10,dt) :
    pause(0.01) 
    cla()       
    ax.set_xlim(-4,8)
    ax.set_ylim(-4,8)         
    draw_crank(x)
    w, dw = consigne(r,c,t)
    x = x + dt*f(x,w,dw)  
show()  

