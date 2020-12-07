cp ../MPB_test.py .
docker build -t fastmeep . && docker run -ti fastmeep bash -xc "source /MEEP_setup_env.sh; ldd \$(which meep) | grep -i blas; sleep 5; python3 /MPB_test.py"
