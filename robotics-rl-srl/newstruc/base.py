base

def __init__(self, env_name, num_episodes, alpha, gamma, policy, report_freq=100, **kwargs):
        """
        base class for RL using lookup table
        :param env_name: see https://github.com/openai/gym/wiki/Table-of-environments
        :param num_episodes: int, number of episode for training
        :param alpha: float, learning rate
        :param gamma: float, discount rate
        :param policy: str
        :param report_freq: int, by default 100
        :param kwargs: other arguments
        """
        self.env = gym.make(env_name)
        self.num_episodes = num_episodes
        self.alpha = alpha
        self.gamma = gamma
        self.state = None
        self._rewards = None
        self._policy = policy
        self.report_freq = report_freq
        for k, v in kwargs.items():
            setattr(self, str(k), v) 

wrapper

def make_atari(env_id, noop=True, max_and_skip=True, episode_life=True, clip_rewards=True, frame_stack=True,
               scale=True):
    """Configure environment for DeepMind-style Atari.
    """
    env = gym.make(env_id)
    assert 'NoFrameskip' in env.spec.id
    if noop:
        env = NoopResetEnv(env, noop_max=30)
    if max_and_skip:
        env = MaxAndSkipEnv(env, skip=4)
    if episode_life:
        env = EpisodicLifeEnv(env)
    if 'FIRE' in env.unwrapped.get_action_meanings():
        env = FireResetEnv(env)
    env = WarpFrame(env)
    if scale:
        env = ScaledFloatFrame(env)
    if clip_rewards:
        env = ClipRewardEnv(env)
    if frame_stack:
        env = FrameStack(env, 4)
    return env 
