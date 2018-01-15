# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import agents
import tensorflow as tf


# TODO: Lots of repetition. There can be a base hparam set and extensions.


class Registry(object):

  def get_hparams(self, hparam_set_name):

    if hparam_set_name in globals():
      return agents.tools.AttrDict(globals()[hparam_set_name]())
    else:
      raise ValueError('unrecognized hparam set name: %s' % hparam_set_name)


def pybullet_kuka_ff():
  # General
  algorithm = agents.ppo.PPOAlgorithm
  num_agents = 30
  eval_episodes = 25
  use_gpu = False

  # Environment
  env = 'KukaBulletEnv-v0'
  max_length = 1000
  steps = 4e7

  # Network
  network = agents.scripts.networks.feed_forward_gaussian
  weight_summaries = dict(
      all=r'.*',
      policy=r'.*/policy/.*',
      value=r'.*/value/.*')
  policy_layers = 200, 100
  value_layers = 200, 100
  init_mean_factor = 0.1
  init_logstd = -1

  # Optimization
  update_every = 30
  update_epochs = 25
  optimizer = tf.train.AdamOptimizer
  optimizer_pre_initialize = True
  learning_rate = 1e-4

  # Losses
  discount = 0.995
  kl_target = 1e-2
  kl_cutoff_factor = 2
  kl_cutoff_coef = 1000
  kl_init_penalty = 1

  return locals()


def pybullet_ant_ff():

  # General
  algorithm = agents.ppo.PPOAlgorithm
  num_agents = 30
  eval_episodes = 25
  use_gpu = False

  # Environment
  env = 'AntBulletEnv-v0'
  max_length = 1000
  steps = 4e7  # 10M

  # Network
  network = agents.scripts.networks.feed_forward_gaussian
  weight_summaries = dict(
      all=r'.*',
      policy=r'.*/policy/.*',
      value=r'.*/value/.*')
  policy_layers = 200, 100
  value_layers = 200, 100
  init_mean_factor = 0.1
  init_logstd = -1

  # Optimization
  update_every = 30
  update_epochs = 25
  optimizer = tf.train.AdamOptimizer
  learning_rate = 1e-4

  # Losses
  discount = 0.995
  kl_target = 1e-2
  kl_cutoff_factor = 2
  kl_cutoff_coef = 1000
  kl_init_penalty = 1

  return locals()


def pybullet_cheetah_ff():

  # General
  algorithm = agents.ppo.PPOAlgorithm
  num_agents = 30
  eval_episodes = 25
  use_gpu = False

  # Environment
  env = 'HalfCheetahBulletEnv-v0'
  max_length = 1000
  steps = 4e7  # 10M

  # Network
  network = agents.scripts.networks.feed_forward_gaussian
  weight_summaries = dict(
      all=r'.*',
      policy=r'.*/policy/.*',
      value=r'.*/value/.*')
  policy_layers = 200, 100
  value_layers = 200, 100
  init_mean_factor = 0.1
  init_logstd = -1

  # Optimization
  update_every = 30
  update_epochs = 25
  optimizer = tf.train.AdamOptimizer
  learning_rate = 1e-4

  # Losses
  discount = 0.995
  kl_target = 1e-2
  kl_cutoff_factor = 2
  kl_cutoff_coef = 1000
  kl_init_penalty = 1

  return locals()


def pybullet_pendulum_ff():

  # General
  algorithm = agents.ppo.PPOAlgorithm
  num_agents = 30
  eval_episodes = 25
  use_gpu = False

  # Environment
  env = 'InvertedPendulumBulletEnv-v0'
  max_length = 1000
  steps = 4e7  # 10M

  # Network
  network = agents.scripts.networks.feed_forward_gaussian
  weight_summaries = dict(
      all=r'.*',
      policy=r'.*/policy/.*',
      value=r'.*/value/.*')
  policy_layers = 200, 100
  value_layers = 200, 100
  init_mean_factor = 0.1
  init_logstd = -1

  # Optimization
  update_every = 30
  update_epochs = 25
  optimizer = tf.train.AdamOptimizer
  learning_rate = 1e-4

  # Losses
  discount = 0.995
  kl_target = 1e-2
  kl_cutoff_factor = 2
  kl_cutoff_coef = 1000
  kl_init_penalty = 1

  return locals()


if __name__ == '__main__':
  registry = Registry()
  print(registry.get_hparams('pybullet_ant_ff'))
