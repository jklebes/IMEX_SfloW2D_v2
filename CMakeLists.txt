
cmake_minimum_required(VERSION 3.22)
project(IMEX_SfloW2D
	LANGUAGES Fortran)
enable_language(Fortran)

add_executable(IMEX_SfloW2D src/IMEX_SfloW2D.f90)
add_subdirectory(src)
target_link_libraries(IMEX_SfloW2D m lapack)
