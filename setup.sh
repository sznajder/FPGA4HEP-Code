# added by Miniconda2 4.5.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/centos/fpga4hep/miniconda2/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/centos/fpga4hep/miniconda2/etc/profile.d/conda.sh" ]; then
        . "/home/centos/fpga4hep/miniconda2/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/centos/fpga4hep/miniconda2/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

source activate keras-training
export PYTHONPATH=`pwd`/models:`pwd`/layers:$PYTHONPATH
export KERASTRAINING=`pwd`
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
