# Modified version of https://github.com/ikostrikov/pytorch-a2c-ppo-acktr/envs.py

import importlib
import os
import pybullet_envs
import gym

from gym.envs.registration import registry, patch_deprecated_methods, load
from stable_baselines import bench
from stable_baselines.common.vec_env import VecEnvWrapper
from stable_baselines.common.vec_env.subproc_vec_env import SubprocVecEnv
from stable_baselines.common.vec_env.dummy_vec_env import DummyVecEnv
from stable_baselines.common.vec_env.vec_normalize import VecNormalize as VecNormalize_

import torch
import torch.nn as nn

import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np

# model.py

#from environments.distributions import Categorical, DiagGaussian, Bernoulli
#from environments.utils import init

# Registry gym

import re
from gym import error, logger

#class Policy(nn.Module):
#    def __init__(self, obs_shape, action_space, base=None, base_kwargs=None):
#        super(Policy, self).__init__()
#        if base_kwargs is None:
#            base_kwargs = {}
#        if base is None:
#            if len(obs_shape) == 3:
#                base = CNNBase
#            elif len(obs_shape) == 1:
#                base = MLPBase
#            else:
#                raise NotImplementedError


# Get a render function
def get_render_func(venv):
    if hasattr(venv, 'envs'):
        return venv.envs[0].render
    elif hasattr(venv, 'venv'):
        return get_render_func(venv.venv)
    elif hasattr(venv, 'env'):
        return get_render_func(venv.env)

    return None


def get_vec_normalize(venv):
    if isinstance(venv, VecNormalize):
        return venv
    elif hasattr(venv, 'venv'):
        return get_vec_normalize(venv.venv)

    return None


def init(module, weight_init, bias_init, gain=1):
    weight_init(module.weight.data, gain=gain)
    bias_init(module.bias.data)
    return module

def dynamicEnvLoad(env_id):
    """
    Get from Gym, the module where the environment is stored
    :param env_id: (str)
    :return: (module, str, str) module_env, class_name, env_module_path
    """
    # Get from the env_id, the entry_point, and distinguish if it is a callable, or a string
    entry_point = registry.spec(env_id)._entry_point
    if callable(entry_point):
        class_name = entry_point.__name__
        env_module_path = entry_point.__module__
    else:
        class_name = entry_point.split(':')[1]
        env_module_path = entry_point.split(':')[0]
    # Lets try and dynamically load the module_env, in order to fetch the globals.
    # If it fails, it means that it was unable to load the path from the entry_point
    # should this occure, it will mean that some parameters will not be correctly saved.
    try:
        module_env = importlib.import_module(env_module_path)
    except ImportError:
        raise AssertionError("Error: could not import module {}, ".format(env_module_path) +
                             "Halting execution. Are you sure this is a valid environement?")

    return module_env, class_name, env_module_path

#def makeEnv(env_id, seed, rank, log_dir, allow_early_resets=False, env_kwargs=None):
#    """
#    Instantiate gym env
#    :param env_id: (str)
#    :param seed: (int)
#    :param rank: (int)
#    :param log_dir: (str)
#    :param allow_early_resets: (bool) Allow reset before the enviroment is done
#    :param env_kwargs: (dict) The extra arguments for the environment
#    """
#
#   # define a place holder function to be returned to the caller.
#    def _thunk():
#        local_env_kwargs = dict(env_kwargs)  # copy this to avoid altering the others
#        local_env_kwargs["env_rank"] = rank
#        env = _make(env_id, env_kwargs=local_env_kwargs)
#        env.seed(seed + rank)
#        if log_dir is not None:
#            env = bench.Monitor(env, os.path.join(log_dir, str(rank)), allow_early_resets=allow_early_resets)
#        return env
#
#    return _thunk

#def makeEnv(env_id, seed, rank, log_dir, allow_early_resets=False, env_kwargs=None):
def makeEnv(env_id, seed, rank, log_dir, allow_early_resets=False, env_kwargs=None):

    def _thunk():

#        local_env_kwargs = dict(env_kwargs)
        local_kwargs = env_kwargs
#        kwargs = env_kwargs
#        kwargs["env_rank"] = rank
        local_kwargs["env_rank"] = rank 
#        env = _make(env_id, env_kwargs=local_env_kwargs)
        env = gym.make(env_id, **local_kwargs)
#        env = make(env_id, **kwargs)
        env.seed(seed + rank)

#        obs_shape = env.observation_space.shape

#        if add_timestep and len(
#                obs_shape) == 1 and str(env).find('TimeLimit') > -1:
#            env = AddTimestep(env)

        if log_dir is not None:
            env = bench.Monitor(env, os.path.join(log_dir, str(rank)),
                                allow_early_resets=allow_early_resets)
        
#        # If the input has shape (W,H,3), wrap for PyTorch convolutions
#        obs_shape = env.observation_space.shape
#        if len(obs_shape) == 3 and obs_shape[2] in [1, 3]:
#            env = TransposeImage(env, op=[2, 0, 1])

        return env

    return _thunk


def make_vec_envs(env_name, seed, num_processes, gamma, log_dir, add_timestep,
                  device, allow_early_resets, num_frame_stack=None):
    envs = [make_env(env_name, seed, i, log_dir, add_timestep, allow_early_resets)
            for i in range(num_processes)]

    if len(envs) > 1:
        envs = SubprocVecEnv(envs)
    else:
        envs = DummyVecEnv(envs)

    if len(envs.observation_space.shape) == 1:
        if gamma is None:
            envs = VecNormalize(envs, ret=False)
        else:
            envs = VecNormalize(envs, gamma=gamma)

    envs = VecPyTorch(envs, device)

#    if num_frame_stack is not None:
#        envs = VecPyTorchFrameStack(envs, num_frame_stack, device)
#    elif len(envs.observation_space.shape) == 3:
#        envs = VecPyTorchFrameStack(envs, 4, device)

    return envs


class AddTimestep(gym.ObservationWrapper):
    def __init__(self, env=None):
        super(AddTimestep, self).__init__(env)
        self.observation_space = Box(
            self.observation_space.low[0],
            self.observation_space.high[0],
            [self.observation_space.shape[0] + 1],
            dtype=self.observation_space.dtype)

    def observation(self, observation):
        return np.concatenate((observation, [self.env._elapsed_steps]))


class VecPyTorch(VecEnvWrapper):
    def __init__(self, venv, device):
        """Return only every `skip`-th frame"""
        super(VecPyTorch, self).__init__(venv)
        self.device = device
        # TODO: Fix data types

    def reset(self):
        obs = self.venv.reset()
        obs = torch.from_numpy(obs).float().to(self.device)
        return obs

    def step_async(self, actions):
        actions = actions.squeeze(1).cpu().numpy()
        self.venv.step_async(actions)

    def step_wait(self):
        obs, reward, done, info = self.venv.step_wait()
        obs = torch.from_numpy(obs).float().to(self.device)
        reward = torch.from_numpy(reward).unsqueeze(dim=1).float()
        return obs, reward, done, info


class VecNormalize(VecNormalize_):

    def __init__(self, *args, **_kwargs):
        super(VecNormalize, self).__init__(*args, **_kwargs)
        self.training = True

    def _obfilt(self, obs):
        if self.ob_rms:
            if self.training:
                self.ob_rms.update(obs)
            obs = np.clip((obs - self.ob_rms.mean) / np.sqrt(self.ob_rms.var + self.epsilon), -self.clipob, self.clipob)
            return obs
        else:
            return obs

    def train(self):
        self.training = True

    def eval(self):
        self.training = False


# Derived from
# https://github.com/openai/baselines/blob/master/baselines/common/vec_env/vec_frame_stack.py

#class VecPyTorchFrameStack(VecEnvWrapper):
#    def __init__(self, venv, nstack, device=None):
#        self.venv = venv
#        self.nstack = nstack
#
#        wos = venv.observation_space  # wrapped ob space
#        self.shape_dim0 = wos.shape[0]
#
#        low = np.repeat(wos.low, self.nstack, axis=0)
#        high = np.repeat(wos.high, self.nstack, axis=0)
#
#        if device is None:
#            device = torch.device('cpu')
#        self.stacked_obs = torch.zeros((venv.num_envs,) + low.shape).to(device)
#
#        observation_space = gym.spaces.Box(
#            low=low, high=high, dtype=venv.observation_space.dtype)
#        VecEnvWrapper.__init__(self, venv, observation_space=observation_space)
#
#    def step_wait(self):
#        obs, rews, news, infos = self.venv.step_wait()
#        self.stacked_obs[:, :-self.shape_dim0] = \
#            self.stacked_obs[:, self.shape_dim0:]
#        for (i, new) in enumerate(news):
#            if new:
#                self.stacked_obs[i] = 0
#        self.stacked_obs[:, -self.shape_dim0:] = obs
#        return self.stacked_obs, rews, news, infos
#
#    def reset(self):
#        obs = self.venv.reset()
#        if torch.backends.cudnn.deterministic:
#            self.stacked_obs = torch.zeros(self.stacked_obs.shape)
#        else:
#            self.stacked_obs.zero_()
#        self.stacked_obs[:, -self.shape_dim0:] = obs
#        return self.stacked_obs
#
#    def close(self):
#        self.venv.close()


# This format is true today, but it's *not* an official spec.
# [username/](env-name)-v(version)    env-name is group 1, version is group 2
#
# 2016-10-31: We're experimentally expanding the environment ID format
# to include an optional username.
env_id_re = re.compile(r'^(?:[\w:-]+\/)?([\w:.-]+)-v(\d+)$')

def load(name):
    import pkg_resources # takes ~400ms to load, so we import it lazily
    entry_point = pkg_resources.EntryPoint.parse('x={}'.format(name))
    result = entry_point.resolve()
    return result

class EnvSpec(object):
    """A specification for a particular instance of the environment. Used
    to register the parameters for official evaluations.

    Args:
        id (str): The official environment ID
        entry_point (Optional[str]): The Python entrypoint of the environment class (e.g. module.name:Class)
        trials (int): The number of trials to average reward over
        reward_threshold (Optional[int]): The reward threshold before the task is considered solved
        local_only: True iff the environment is to be used only on the local machine (e.g. debugging envs)
        kwargs (dict): The kwargs to pass to the environment class
        nondeterministic (bool): Whether this environment is non-deterministic even after seeding
        tags (dict[str:any]): A set of arbitrary key-value tags on this environment, including simple property=True tags

    Attributes:
        id (str): The official environment ID
        trials (int): The number of trials run in official evaluation
    """

    def __init__(self, id, entry_point=None, trials=100, reward_threshold=None, local_only=False, kwargs=None, nondeterministic=False, tags=None, max_episode_steps=None, max_episode_seconds=None, timestep_limit=None):
        self.id = id
        # Evaluation parameters
        self.trials = trials
        self.reward_threshold = reward_threshold
        # Environment properties
        self.nondeterministic = nondeterministic

        if tags is None:
            tags = {}
        self.tags = tags

        # BACKWARDS COMPAT 2017/1/18
        if tags.get('wrapper_config.TimeLimit.max_episode_steps'):
            max_episode_steps = tags.get('wrapper_config.TimeLimit.max_episode_steps')
            # TODO: Add the following deprecation warning after 2017/02/18
            # warnings.warn("DEPRECATION WARNING wrapper_config.TimeLimit has been deprecated. Replace any calls to `register(tags={'wrapper_config.TimeLimit.max_episode_steps': 200)}` with `register(max_episode_steps=200)`. This change was made 2017/1/31 and is included in gym version 0.8.0. If you are getting many of these warnings, you may need to update universe past version 0.21.3")

        tags['wrapper_config.TimeLimit.max_episode_steps'] = max_episode_steps
        ######

        # BACKWARDS COMPAT 2017/1/31
        if timestep_limit is not None:
            max_episode_steps = timestep_limit
            # TODO: Add the following deprecation warning after 2017/03/01
            # warnings.warn("register(timestep_limit={}) is deprecated. Use register(max_episode_steps={}) instead.".format(timestep_limit, timestep_limit))
        ######

        self.max_episode_steps = max_episode_steps
        self.max_episode_seconds = max_episode_seconds

        # We may make some of these other parameters public if they're
        # useful.
        match = env_id_re.search(id)
        if not match:
            raise error.Error('Attempted to register malformed environment ID: {}. (Currently all IDs must be of the form {}.)'.format(id, env_id_re.pattern))
        self._env_name = match.group(1)
        self._entry_point = entry_point
        self._local_only = local_only
        self._kwargs = {} if kwargs is None else kwargs

#def _make(id_, env_kwargs=None):
#    """
#    Recreating the gym make function from gym/envs/registration.py
#    as such as it can support extra arguments for the environment
#    :param id_: (str) The environment ID
#    :param env_kwargs: (dict) The extra arguments for the environment
#    """
#    if env_kwargs is None:
#        env_kwargs = {}
#
#    # getting the spec from the ID we want
#    spec = registry.spec(id_)
#
#    # Keeping the checks and safe guards of the old code
#    assert spec._entry_point is not None, 'Attempting to make deprecated env {}. ' \
#                                          '(HINT: is there a newer registered version of this env?)'.format(spec.id_)
#
 #   if callable(spec._entry_point):
#        env = spec._entry_point(**env_kwargs)
#    else:
#        cls = load(spec._entry_point)
#        # create the env, with the original kwargs, and the new ones overriding them if needed
#        env = cls(**{**spec._kwargs, **env_kwargs})
#    # Make the enviroment aware of which spec it came from.
#    env.unwrapped.spec = spec
#
#    # Keeping the old patching system for _reset, _step and timestep limit
#    if hasattr(env, "_reset") and hasattr(env, "_step") and not getattr(env, "_gym_disable_underscore_compat", False):
#        patch_deprecated_methods(env)
#    if (env.spec.timestep_limit is not None) and not spec.tags.get('vnc'):
#        from gym.wrappers.time_limit import TimeLimit
#        env = TimeLimit(env,
#                        max_episode_steps=env.spec.max_episode_steps,
#                        max_episode_seconds=env.spec.max_episode_seconds)
#    return env


    def make(self, **kwargs):
        """Instantiates an instance of the environment with appropriate kwargs"""
        if self._entry_point is None:
            raise error.Error('Attempting to make deprecated env {}. (HINT: is there a newer registered version of this env?)'.format(self.id))
        local_kwargs = self._kwargs.copy()
        _kwargs.update(kwargs)
        if callable(self._entry_point):
            env = self._entry_point(**_kwargs)
        else:
            cls = load(self._entry_point)
#            cls = dynamicEnvLoad(self._entry_point)
            env = cls(**_kwargs)

        # Make the enviroment aware of which spec it came from.
        env.unwrapped.spec = self

        return env

    def __repr__(self):
        return "EnvSpec({})".format(self.id)

    @property
    def timestep_limit(self):
        return self.max_episode_steps

    @timestep_limit.setter
    def timestep_limit(self, value):
        self.max_episode_steps = value


