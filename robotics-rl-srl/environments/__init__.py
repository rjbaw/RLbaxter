from enum import Enum

class PlottingType(Enum):
    PLOT_2D = 1
    PLOT_3D = 2


class ThreadingType(Enum):
    PROCESS = 1
    THREADING = 2
    NONE = 3

import subprocess
import os
import gym
from gym.envs.registration import register
from gym.envs import registry
from environments.gym_baxter.baxter_env import BaxterEnv
from environments.srl_env import SRLGymEnv

registered_env = {
    "Baxter-v0":                      (BaxterEnv, SRLGymEnv, PlottingType.PLOT_3D, ThreadingType.NONE),
}

for name, (env_class, _, _, _) in registered_env.items():
    register(
        id=name,
        entry_point=env_class.__module__ + ":" + env_class.__name__,
        reward_threshold=None,
        timestep_limit=None
    )
print('entry_point')
