#!/bin/sh

ITERATIONS=7
RELWMAX="4e-3"
SUFFIX="3layer"
DATASET="../data/processed-pythia82-lhc13-all-pt1-50k-r1_h022_e0175_t220_nonu_truth.z"
MODEL="train_3layer/KERAS_check_best_model.h5"
CONFIG_FILE="train_config_threelayer.yml"

for (( i=1; i<=$ITERATIONS; i++ ))
do 
   PRUNE_DIR="prune_"$SUFFIX"_iter"$i"_relwmax"$RELWMAX
   EVAL_DIR="eval_"$SUFFIX"_iter"$i"_relwmax"$RELWMAX
   EVAL_RETRAIN_DIR="eval_retrain_"$SUFFIX"_iter"$i"_relwmax"$RELWMAX

   rm -rf $PRUNE_DIR 
   mkdir $PRUNE_DIR
   if [ $i -eq 1 ]
   then
       python prune.py -m $MODEL --relative-weight-max $RELWMAX -o $PRUNE_DIR/pruned_model.h5
   else
       RETRAIN_DIR="retrain_"$SUFFIX"_iter"$((i-1))"_relwmax"$RELWMAX
       python prune.py -m $RETRAIN_DIR/KERAS_check_best_model.h5 --relative-weight-max $RELWMAX -o $PRUNE_DIR/pruned_model.h5
   fi

   rm -rf $EVAL_DIR
   python eval.py -t t_allpar_new -i $DATASET -m $PRUNE_DIR/pruned_model.h5 -c $CONFIG_FILE -o $EVAL_DIR/

   RETRAIN_DIR="retrain_"$SUFFIX"_iter"$i"_relwmax"$RELWMAX   
   rm -rf $RETRAIN_DIR
   python retrain.py -t t_allpar_new -i $DATASET -o $RETRAIN_DIR -m $PRUNE_DIR/pruned_model.h5 -c $CONFIG_FILE -d $PRUNE_DIR/pruned_model_drop_weights.h5

   rm -rf $EVAL_RETRAIN_DIR
   python eval.py -t t_allpar_new -i $DATASET -m $RETRAIN_DIR/KERAS_check_best_model.h5 -c $CONFIG_FILE -o $EVAL_RETRAIN_DIR/
    
done
 
