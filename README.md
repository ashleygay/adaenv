# AdaEnv

+ Ada development environment
	* Uses Docker for portability

+ The idea is to not have to add/install GNAT toolchain

+ The script will clone your repository in the project directory
  it will then copy the Dockerfile in it and launch a docker container
  with the selected toolchain as your Ada compiler

+ Tools required:
	* dialog 
	* bash (or equivalent)
	* docker
