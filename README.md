# Depencies
  you will need SystemC, verilator and build-essentials

  verilator and build-essentials can be installed using:
  ```
  $ sudo apt install verilator build-essentials
  ```

  for systemC you will need to download the library and set it up on your device, this is a good tutorial:
  https://gist.github.com/bagheriali2001/0736fabf7da95fb02bbe6777d53fabf7

  note: the systemC version used is 3.0.0
##Enviroment Variables
  set SYSTEMC_HOME to your installation directory:
  ```
  $ export SYSTEMC_HOME=/systemC/installation/directory
  ```
  you need to also set SYSTEMC_LIBDIR as well LD_LIBRARY_PATH
  ```
  $ export SYSTEMC_LIBDIR=/systemC/installation/directory/lib-linux64
  $ export LD_LIBRARY_PATH=/systemC/installation/directory/lib-linux64
  ```
It is recommended to have these comamnds in your .bashrc file, this way you don't have to set all these variable each time you run the program.

## UVM
after completing all previous steps, make sure to download a copy of UVM implementation and extract it.
edit the make file to change the variable UVM_HOME at the top of the make file:
```
7  UVM_HOME = UVM/files/directory
```
# run command

  simply run the following commands from the base directory

  ```
  $ make all
  $ make run
  ```
  
