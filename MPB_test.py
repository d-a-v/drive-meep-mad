#### Discretisation IBZ maille hexagonale repere hexagonale 

import meep as mp
from meep import mpb
import math as math
import numpy as np
import matplotlib.pyplot as plt
import h5py
import os, sys
import re
import subprocess


## Parametres de maille
n_lo = 1
n_hi = 3.25
Nbands = 16
ra = 0.20
resolution = 64

## Definition discretisation traits horizontaux
nbr_points_x = 4
nbr_points_y = 4

## Repere direct carree 45
geometry_lattice = mp.Lattice()
geometry_lattice.basis_size = mp.Vector3(1,1,1)
geometry_lattice.size = mp.Vector3(1,1,0)
geometry_lattice.basis1 = mp.Vector3(math.sqrt(2)/2,-math.sqrt(2)/2)
geometry_lattice.basis2 = mp.Vector3(math.sqrt(2)/2,+math.sqrt(2)/2)
			
## Definition motif
default_material = mp.Medium(index=n_hi)
C_0 = [mp.Cylinder(ra,material=mp.Medium(index=n_lo))]
				
## Limites IBZ REPERE RECIPROQUE
k_point_gamma = mp.Vector3(0,0)
k_point_M_rec = mp.Vector3(1/2,1/2)
k_point_K_rec = mp.Vector3(1/2,0)
k_point_K_cart = mp.Vector3(math.sqrt(2)/2,0)
k_point_M_cart = mp.Vector3(math.sqrt(2)/4,math.sqrt(2)/4)



dk_x = (math.sqrt(2)/2)/(nbr_points_x+1)	
dk_y = (math.sqrt(2)/4)/(nbr_points_y+1)


seg = []


for j in range(0, nbr_points_y+2):
	k_point_gamma_dk_cart = k_point_gamma + mp.Vector3(0,j*dk_y)
	k_point_K_dk_cart = k_point_K_cart + mp.Vector3(0,j*dk_y)
	k_point_gamma_dk_rec = mp.cartesian_to_reciprocal(k_point_gamma_dk_cart,geometry_lattice)
	k_point_K_dk_rec = mp.cartesian_to_reciprocal(k_point_K_dk_cart,geometry_lattice)
	seg_temp = mp.interpolate(nbr_points_x,[k_point_gamma_dk_rec,k_point_K_dk_rec])
	seg = seg + seg_temp
		
def outputgv(ms):
	global gv
	gv.append(ms.compute_group_velocities())			
gv=[]

ms = mpb.ModeSolver()
ms.geometry = C_0
ms.geometry_lattice = geometry_lattice
ms.resolution = resolution
ms.num_bands = Nbands
ms.k_points = seg
ms.default_material = default_material
ms.run_te(outputgv)
ms.output_epsilon()

		
te_freqs = ms.all_freqs
		



