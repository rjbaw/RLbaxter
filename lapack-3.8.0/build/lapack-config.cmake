# Load lapack targets from the build tree if necessary.
set(_LAPACK_TARGET "blas")
if(_LAPACK_TARGET AND NOT TARGET "${_LAPACK_TARGET}")
  include("/home/nvidia/Downloads/lapack-3.8.0/build/lapack-targets.cmake")
endif()
unset(_LAPACK_TARGET)

# Report the blas and lapack raw or imported libraries.
set(LAPACK_blas_LIBRARIES "blas")
set(LAPACK_lapack_LIBRARIES "lapack")
