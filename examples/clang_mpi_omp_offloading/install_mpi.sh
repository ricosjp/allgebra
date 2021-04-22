apt update -y
apt install -y autoconf m4 automake libtool flex
apt install -y libnccl2 libnccl-dev --allow-change-held-packages
apt install -y ssh

git clone -b v4.1.0 https://github.com/open-mpi/ompi.git /tmp/ompi 
cd /tmp/ompi
./autogen.pl
./configure CC=clang CXX=clang++ --with-cuda --disable-mpi-fortran
make -j
make install -j
cd -

# enable Fortran is fail
#===
#checking if Fortran compiler supports CHARACTER... yes
#checking size of Fortran CHARACTER... configure: WARNING: Could not determine size of CHARACTER
#configure: WARNING: See config.log for details
#configure: error: Cannot continue
#===
#./configure CC=clang CXX=clang++ F77=gfortran FC=gfortran --with-cuda
