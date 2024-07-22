
cmake_minimum_required(VERSION 3.22)

# list of sources for the binary
set(SOURCES 
                parameters_2d.f90 
                complexify.f90 
                geometry_2d.f90
                constitutive_2d.f90 
                solver_2d.f90 
                init_2d.f90 
                inpout_2d.f90 
								)

target_sources(IMEX_SfloW2D PRIVATE ${SOURCES})
