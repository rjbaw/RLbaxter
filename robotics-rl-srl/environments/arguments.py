import argparse
import torch
import os

from state_representation import SRLType
from state_representation.registry import registered_srl

from environments.registry import registered_env
from environments.srl_env import SRLGymEnv
from rl_baselines import AlgoType, ActionType
from rl_baselines.registry import registered_rl


def get_args():
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
    args = parser.parse_args()

    return args
