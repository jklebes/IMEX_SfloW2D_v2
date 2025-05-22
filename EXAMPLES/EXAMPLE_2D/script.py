import sys
import netCDF4
import matplotlib.pyplot as plt

file1 = sys.argv[1]
var = sys.argv[2]
time = int(sys.argv[3])

data1 = netCDF4.Dataset(file1, mode='r')
try:
    plt.imshow((data1.variables[var][time,:,:]))
except KeyError:
    print("choose varaible (arg2) from: ", data1.variables.keys())
plt.colorbar()
plt.show()
