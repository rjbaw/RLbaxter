How to add new environments to Gym, within this repo (not recommended for new environments)

    Write your environment in an existing collection or a new collection. All collections are subfolders of `/gym/envs'.
    Import your environment into the __init__.py file of the collection. This file will be located at /gym/envs/my_collection/__init__.py. Add from gym.envs.my_collection.my_awesome_env import MyEnv to this file.
    Register your env in /gym/envs/__init__.py:

register(
   	id='MyEnv-v0',
   	entry_point='gym.envs.my_collection:MyEnv',
)

    Add your environment to the scoreboard in /gym/scoreboard/__init__.py:

add_task(
   	id='MyEnv-v0',
   	summary="Super cool environment",
   	group='my_collection',
   	contributor='mygithubhandle',
)

