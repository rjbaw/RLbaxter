"""
Retraining script for RL algorithms, this script overwrites the previous logs
"""

import inspect
import json
import os
import sys
import time
from functools import partial
from datetime import datetime
from pprint import pprint
import argparse

import yaml
from stable_baselines.common import set_global_seeds
from visdom import Visdom

#For anyone using mpi4py and tensorflow
# GPU processing
#import multiprocessing
#import platform
#import tensorflow as tf
#from mpi4py import MPI
#from tensorflow.python.client import device_lib
#from baselines import logger

# pytorch multiprocessing
import torch.multiprocessing as mp
import torch

# Environment variables
from environments.registry import registered_env
from environments.srl_env import SRLGymEnv
from environments.arguments import get_args
from environments.utils import make_vec_envs, get_vec_normalize

# Baselines
from rl_baselines import AlgoType, ActionType
from rl_baselines.registry import registered_rl
from rl_baselines.utils import computeMeanReward
from rl_baselines.utils import filterJSONSerializableObjects
from rl_baselines.visualize import timestepsPlot, episodePlot

from srl_zoo.utils import printGreen, printYellow

from state_representation import SRLType
from state_representation.registry import registered_srl



# Retrained logs, refer to google drive
#--srl-model srl_combination --num-stack 16 --shape-reward --algo ppo2 --env Baxter-v0 --log-dir logs_real/Baxter-v0/srl_combination/ppo2/19-03-11_10h26_36/ --cuda --num-processes 16
#--srl-model raw_pixels --num-stack 16 --shape-reward --algo ppo2 --env Baxter-v0 --log-dir logs_real/Baxter-v0/raw_pixels/ppo2/19-03-28_19h25_59/ --cuda --num-processes 16
#--srl-model srl_splits --num-stack 16 --shape-reward --algo ppo2 --env Baxter-v0 --log-dir logs_real/Baxter-v0/srl_splits/ppo2/19-03-08_15h58_01/ --cuda --num-processes 16


# Setup constants
VISDOM_PORT = 8097
LOG_INTERVAL = 0  # initialised during loading of the algorithm
LOG_DIR = ""
ALGO = None
ALGO_NAME = ""
ENV_NAME = ""
PLOT_TITLE = ""
EPISODE_WINDOW = 40  # For plotting moving average
viz = None
n_steps = 0
SAVE_INTERVAL = 0  # initialised during loading of the algorithm
N_EPISODES_EVAL = 100  # Evaluate the performance on the last 100 episodes
MIN_EPISODES_BEFORE_SAVE = 100  # Number of episodes to train on before saving best model
params_saved = True
best_mean_reward = -10000

win, win_smooth, win_episodes = None, None, None

#os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # used to remove debug info of tensorflow


#def saveEnvParams(kuka_env_globals, env_kwargs):

def saveEnvParams(global_env_param, env_kwargs):
    """
    :param kuka_env_globals: (dict)
    :param env_kwargs: (dict) The extra arguments for the environment
    """
    params = filterJSONSerializableObjects({**global_env_param, **env_kwargs})
    with open(LOG_DIR + "env_globals.json", "w") as f:
        json.dump(params, f)


def latestPath(path):
    """
    :param path: path to the log folder (defined in srl_model.yaml) (str)
    :return: path to latest learned model in the same dataset folder (str)
    """
    return max(
        [path + "/" + d for d in os.listdir(path) if not d.startswith('baselines') and os.path.isdir(path + "/" + d)],
        key=os.path.getmtime) + '/srl_model.pth'


def configureEnvAndLogFolder(args, env_kwargs, all_models):
    """
    :param args: (ArgumentParser object)
    :param env_kwargs: (dict) The extra arguments for the environment
    :param all_models: (dict) The location of all the trained SRL models
    :return: (ArgumentParser object, dict)
    """
    global PLOT_TITLE, LOG_DIR
    # Reward sparse or shaped
    env_kwargs['shape_reward'] = args.shape_reward
    # Actions in joint space or relative position space
    env_kwargs['action_joints'] = args.action_joints
#    args.log_dir += args.env + "/"

    models = all_models[args.env]
    PLOT_TITLE = args.srl_model
    path = models.get(args.srl_model)
#    args.log_dir += args.srl_model + "/"

    env_kwargs['srl_model'] = args.srl_model
    if registered_srl[args.srl_model][0] == SRLType.SRL:
        env_kwargs['use_srl'] = True
        if args.latest:
            printYellow("Using latest srl model in {}".format(models['log_folder']))
            env_kwargs['srl_model_path'] = latestPath(models['log_folder'])
        else:
            assert path is not None, "Error: SRL path not defined for {} in {}".format(args.srl_model,
                                                                                       args.srl_config_file)
            # Path depending on whether to load the latest model or not
            srl_model_path = models['log_folder'] + path
            env_kwargs['srl_model_path'] = srl_model_path

    # Add date + current time
    if not params_saved:
        args.log_dir += args.env + "/"
        args.log_dir += args.srl_model + "/"
        args.log_dir += "{}/{}/".format(ALGO_NAME, datetime.now().strftime("%y-%m-%d_%Hh%M_%S"))

    LOG_DIR = args.log_dir
    # wait one second if the folder exist to avoid overwritting logs
    time.sleep(1)
    os.makedirs(args.log_dir, exist_ok=True)

    return args, env_kwargs


def callback(_locals, _globals):
    """
    Callback called at each step (for DQN an others) or after n steps (see ACER or PPO2)
    :param _locals: (dict)
    :param _globals: (dict)
    """
    global win, win_smooth, win_episodes, n_steps, viz, params_saved, best_mean_reward
    # Create vizdom object only if needed
    if viz is None:
        viz = Visdom(port=VISDOM_PORT)

    is_es = registered_rl[ALGO_NAME][1] == AlgoType.EVOLUTION_STRATEGIES

    # Save RL agent parameters
    if not params_saved:
        # Filter locals
        params = filterJSONSerializableObjects(_locals)
        with open(LOG_DIR + "rl_locals.json", "w") as f:
            json.dump(params, f)
        params_saved = True

    # Save the RL model if it has improved
    if (n_steps + 1) % SAVE_INTERVAL == 0:
        # Evaluate network performance
        ok, mean_reward = computeMeanReward(LOG_DIR, N_EPISODES_EVAL, is_es=is_es, return_n_episodes=True)
        if ok:
            # Unpack mean reward and number of episodes
            mean_reward, n_episodes = mean_reward
            print(
                "Best mean reward: {:.2f} - Last mean reward per episode: {:.2f}".format(best_mean_reward, mean_reward))
        else:
            # Not enough episode
            mean_reward = -10000
            n_episodes = 0

        # Save Best model
        if mean_reward > best_mean_reward and n_episodes >= MIN_EPISODES_BEFORE_SAVE:
            # Try saving the running average (only valid for mlp policy)
            try:
                if 'env' in _locals:
                    _locals['env'].save_running_average(LOG_DIR)
                else:
                    _locals['self'].env.save_running_average(LOG_DIR)
            except AttributeError:
                pass

            best_mean_reward = mean_reward
            printGreen("Saving new best model")
            ALGO.save(LOG_DIR + ALGO_NAME + "_model.pkl", _locals)

    # Plots in visdom
    if viz and (n_steps + 1) % LOG_INTERVAL == 0:
        win = timestepsPlot(viz, win, LOG_DIR, ENV_NAME, ALGO_NAME, bin_size=1, smooth=0, title=PLOT_TITLE, is_es=is_es)
        win_smooth = timestepsPlot(viz, win_smooth, LOG_DIR, ENV_NAME, ALGO_NAME, title=PLOT_TITLE + " smoothed",
                                   is_es=is_es)
        win_episodes = episodePlot(viz, win_episodes, LOG_DIR, ENV_NAME, ALGO_NAME, window=EPISODE_WINDOW,
                                   title=PLOT_TITLE + " [Episodes]", is_es=is_es)
    n_steps += 1
    return True

# Multithreading fix, of tensorflow and MPI4py, does not work in our case
#
#def guess_available_gpus(n_gpus=None):
#
#    local_device_protos = device_lib.list_local_devices()
#    return [x.name for x in local_device_protos if x.device_type == 'GPU']
#
#def setup_mpi_gpus():
#    """
#    Set CUDA_VISIBLE_DEVICES using MPI.
#    """
#    available_gpus = guess_available_gpus()
#
#    node_id = platform.node()
#    nodes_ordered_by_rank = MPI.COMM_WORLD.allgather(node_id)
#    processes_outranked_on_this_node = [n for n in nodes_ordered_by_rank[:MPI.COMM_WORLD.Get_rank()] if n == node_id]
#    local_rank = len(processes_outranked_on_this_node)
#    os.environ['CUDA_VISIBLE_DEVICES'] = str(available_gpus[local_rank])
#    os.environ['CUDA_VISIBLE_DEVICES'] = '0'
#
#def guess_available_cpus():
#    return int(multiprocessing.cpu_count())
#
#def setup_tensorflow_session():
#    num_cpu = guess_available_cpus()
#
#    tf_config = tf.ConfigProto(
#        inter_op_parallelism_threads=num_cpu,
#        intra_op_parallelism_threads=num_cpu
#    )
#    return tf.Session(config=tf_config)
#
#def get_experiment_environment():
#
#    setup_mpi_gpus()
#    tf_context = setup_tensorflow_session()
#    return tf_context
#tf_sess = get_experiment_environment()

def main():
#    torch.set_num_threads(1)
#    setup_mpi_gpus()

    parser = argparse.ArgumentParser(description="Train script for RL algorithms")
    parser.add_argument('--algo', default='ppo2', choices=list(registered_rl.keys()), help='RL algo to use',
                        type=str)
    parser.add_argument('--env', type=str, help='environment ID', default='KukaButtonGymEnv-v0',
                        choices=list(registered_env.keys()))
    parser.add_argument('--seed', type=int, default=0, help='random seed (default: 0)')
    parser.add_argument('--episode_window', type=int, default=40,
                        help='Episode window for moving average plot (default: 40)')
    parser.add_argument('--log-dir', default='/tmp/gym/', type=str,
                        help='directory to save agent logs and model (default: /tmp/gym)')
    parser.add_argument('--num-timesteps', type=int, default=int(1e6))
    parser.add_argument('--srl-model', type=str, default='raw_pixels', choices=list(registered_srl.keys()),
                        help='SRL model to use')
    parser.add_argument('--num-stack', type=int, default=1, help='number of frames to stack (default: 1)')
    parser.add_argument('--action-repeat', type=int, default=1,
                        help='number of times an action will be repeated (default: 1)')
    parser.add_argument('--port', type=int, default=8097, help='visdom server port (default: 8097)')
    parser.add_argument('--no-vis', action='store_true', default=False, help='disables visdom visualization')
    parser.add_argument('--shape-reward', action='store_true', default=False,
                        help='Shape the reward (reward = - distance) instead of a sparse reward')
    parser.add_argument('-c', '--continuous-actions', action='store_true', default=False)
    parser.add_argument('-joints', '--action-joints', action='store_true', default=False,
                        help='set actions to the joints of the arm directly, instead of inverse kinematics')
    parser.add_argument('-r', '--random-target', action='store_true', default=False,
                        help='Set the button to a random position')
    parser.add_argument('--srl-config-file', type=str, default="config/srl_models.yaml",
                        help='Set the location of the SRL model path configuration.')
    parser.add_argument('--hyperparam', type=str, nargs='+', default=[])
    parser.add_argument('--min-episodes-save', type=int, default=100,
                        help="Min number of episodes before saving best model")
    parser.add_argument('--latest', action='store_true', default=False,
                        help='load the latest learned model (location:srl_zoo/logs/DatasetName/)')
    parser.add_argument('--cuda', action='store_true', default=False, 
                        help='enables CUDA training')
    parser.add_argument('--num-processes', type=int, default=1, help='number of workers')

    # Global variables for callback
    global ENV_NAME, ALGO, ALGO_NAME, LOG_INTERVAL, VISDOM_PORT, viz
    global SAVE_INTERVAL, EPISODE_WINDOW, MIN_EPISODES_BEFORE_SAVE

    # Ignore unknown args for now
#    args = get_args() ; needs separation of unknown and input argparse
    env_kwargs = {}
    args, unknown = parser.parse_known_args()

    # LOAD SRL models list
    assert os.path.exists(args.srl_config_file), \
        "Error: cannot load \"--srl-config-file {}\", file not found!".format(args.srl_config_file)
    with open(args.srl_config_file, 'rb') as f:
        all_models = yaml.load(f)

    # Sanity check
    assert args.episode_window >= 1, "Error: --episode_window cannot be less than 1"
    assert args.num_timesteps >= 1, "Error: --num-timesteps cannot be less than 1"
    assert args.num_stack >= 1, "Error: --num-stack cannot be less than 1"
    assert args.action_repeat >= 1, "Error: --action-repeat cannot be less than 1"
    assert 0 <= args.port < 65535, "Error: invalid visdom port number {}, ".format(args.port) + \
                                   "port number must be an unsigned 16bit number [0,65535]."
    assert registered_srl[args.srl_model][0] == SRLType.ENVIRONMENT or args.env in all_models, \
        "Error: the environment {} has no srl_model defined in 'srl_models.yaml'. Cannot continue.".format(args.env)
    # check that all the SRL_model can be run on the environment
    if registered_srl[args.srl_model][1] is not None:
        found = False
        for compatible_class in registered_srl[args.srl_model][1]:
            if issubclass(compatible_class, registered_env[args.env][0]):
                found = True
                break
        assert found, "Error: srl_model {}, is not compatible with the {} environment.".format(args.srl_model, args.env)

    ENV_NAME = args.env
    ALGO_NAME = args.algo
    VISDOM_PORT = args.port
    EPISODE_WINDOW = args.episode_window
    MIN_EPISODES_BEFORE_SAVE = args.min_episodes_save

    if args.no_vis:
        viz = False

    algo_class, algo_type, action_type = registered_rl[args.algo]
    algo = algo_class()
    ALGO = algo

    # if callback frequency needs to be changed
    LOG_INTERVAL = algo.LOG_INTERVAL
    SAVE_INTERVAL = algo.SAVE_INTERVAL

    if not args.continuous_actions and ActionType.DISCRETE not in action_type:
        raise ValueError(args.algo + " does not support discrete actions, please use the '--continuous-actions' " +
                         "(or '-c') flag.")
    if args.continuous_actions and ActionType.CONTINUOUS not in action_type:
        raise ValueError(args.algo + " does not support continuous actions, please remove the '--continuous-actions' " +
                         "(or '-c') flag.")

    env_kwargs['is_discrete'] = not args.continuous_actions

    printGreen("\nAgent = {} \n".format(args.algo))


    env_kwargs["action_repeat"] = args.action_repeat
#    env_kwargs = {'action_repeat': args.action_repeat} ; has the same effect
    # Random init position for button
    env_kwargs['random_target'] = args.random_target
    # Allow up action
    # env_kwargs["force_down"] = False

    # allow multi-view
    env_kwargs['multi_view'] = args.srl_model == "multi_view_srl"
    parser = algo.customArguments(parser)
    args = parser.parse_args()

    args, env_kwargs = configureEnvAndLogFolder(args, env_kwargs, all_models)
    args_dict = filterJSONSerializableObjects(vars(args))
    # Save args
    with open(LOG_DIR + "args.json", "w") as f:
        json.dump(args_dict, f)

    env_class = registered_env[args.env][0]
    # env default kwargs
    default_env_kwargs = {k: v.default
                          for k, v in inspect.signature(env_class.__init__).parameters.items()
                          if v is not None}

    globals_env_param = sys.modules[env_class.__module__].getGlobals()

    super_class = registered_env[args.env][1]
    # reccursive search through all the super classes of the asked environment, in order to get all the arguments.
    rec_super_class_lookup = {dict_class: dict_super_class for _, (dict_class, dict_super_class, _, _) in
                              registered_env.items()}
    while super_class != SRLGymEnv:
        assert super_class in rec_super_class_lookup, "Error: could not find super class of {}".format(super_class) + \
                                                      ", are you sure \"registered_env\" is correctly defined?"
        super_env_kwargs = {k: v.default
                            for k, v in inspect.signature(super_class.__init__).parameters.items()
                            if v is not None}
        default_env_kwargs = {**super_env_kwargs, **default_env_kwargs}

        globals_env_param = {**sys.modules[super_class.__module__].getGlobals(), **globals_env_param}

        super_class = rec_super_class_lookup[super_class]


    # Print Variables
    printYellow("Arguments:")
    pprint(args_dict)
    printYellow("Env Globals:")
    pprint(filterJSONSerializableObjects({**globals_env_param, **default_env_kwargs, **env_kwargs}))

    # Save env params
    saveEnvParams(globals_env_param, {**default_env_kwargs, **env_kwargs})

    # Seed tensorflow, python and numpy random generator
    set_global_seeds(args.seed)

    # Augment the number of timesteps (when using multiprocessing this number is not reached) (limit time steps)
    args.num_timesteps = int(1.1 * args.num_timesteps)

    # Get the hyperparameter, if given (Hyperband)
    hyperparams = {param.split(":")[0]: param.split(":")[1] for param in args.hyperparam}
    hyperparams = algo.parserHyperParam(hyperparams)

    # Train the agent
    algo.train(args, callback, env_kwargs=env_kwargs, train_kwargs=hyperparams)

# Example of multiple device implementation
#    def to(self, device):
#        self.obs = self.obs.to(device)
#        self.recurrent_hidden_states = self.recurrent_hidden_states.to(device)
#        self.rewards = self.rewards.to(device)
#        self.value_preds = self.value_preds.to(device)
#        self.returns = self.returns.to(device)
#        self.action_log_probs = self.action_log_probs.to(device)
#        self.actions = self.actions.to(device)
#        self.masks = self.masks.to(device)


# Prevent subprocess importing the main function
if __name__ == '__main__':

# Parse Arguments gets called from another file as a work around
    args=get_args()
# Does not need this but it is called as a safe guard 
    mp.freeze_support()
    torch.set_default_tensor_type(torch.cuda.FloatTensor)

# Can still be run with out file system sharing but it prevents the user from using too much file descriptors and crashing the OS 
    torch.multiprocessing.set_sharing_strategy('file_system')

    use_cuda = args.cuda and torch.cuda.is_available()
    device = torch.device("cuda" if use_cuda else "cpu")

# Experimental, still does not work but loading with pin memory will speed up training
    dataloader_kwargs = {'pin_memory': True} if use_cuda else {}

    torch.manual_seed(args.seed)

# Forking does not work for CUDA devices, for alternatives use forkserver instead
    mp.set_start_method('spawn', force=True)
    model = main().to(device)
    model.share_memory() # gradients are allocated lazily, so they are not shared here

# Simple Hogwild implementation
    processes = []
    for rank in range(args.num-processes):

        p = mp.Process(target=main, args=(rank, args, model, device, dataloader_kwargs))
    # We first train the model across `num_processes` processes
        p.start()
        processes.append(p)
    for p in processes:
        p.join()
