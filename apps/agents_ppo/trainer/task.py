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

from __future__ import absolute_import, division, print_function

import argparse
import datetime
import logging
import os
import pprint

import tensorflow as tf

import agents
import pybullet_envs

flags = tf.app.flags


flags.DEFINE_string("mode", "train",
                    "Run mode, one of [train, render, train_and_render].")
flags.DEFINE_string("logdir", None,
                    "The base directory in which to write logs and "
                    "checkpoints.")
flags.DEFINE_string("config", "pybullet_kuka",
                    "The name of the config object to be used to parameterize "
                    "the run.")
flags.DEFINE_string("run_base_tag",
                    datetime.datetime.now().strftime('%Y%m%dT%H%M%S'),
                    "Base tag to prepend to logs dir folder name. Defaults "
                    "to timestamp.")
flags.DEFINE_boolean("env_processes", True,
                     "Step environments in separate processes to circumvent "
                     "the GIL.")
flags.DEFINE_boolean("sync_replicas", False,
                     "Use the sync_replicas (synchronized replicas) mode, "
                     "wherein the parameter updates from workers are "
                     "aggregated before applied to avoid stale gradients.")
flags.DEFINE_integer("num_gpus", 0,
                     "Total number of gpus for each machine."
                     "If you don't use GPU, please set it to '0'")
flags.DEFINE_integer("save_checkpoint_secs", 600,
                     "Number of seconds between checkpoint save.")
flags.DEFINE_boolean("use_monitored_training_session", True,
                     "Whether to use tf.train.MonitoredTrainingSession to "
                     "manage the training session. If not, use "
                     "tf.train.Supervisor.")
flags.DEFINE_boolean("log_device_placement", False,
                     "Whether to output logs listing the devices on which "
                     "variables are placed.")
flags.DEFINE_boolean("debug", True,
                     "Run in debug mode.")
flags.DEFINE_string("debug_ui_type", "curses",
                    "Command-line user interface type (curses | readline)")

# Algorithm
flags.DEFINE_boolean("algorithm", "agents.ppo.PPOAlgorithm",
                     "The name of the algorithm to use.")
flags.DEFINE_boolean("num_agents", 30,
                     "The number of agents to use.")
flags.DEFINE_boolean("num_agents", 25,
                     "The number of eval episodes to use.")
flags.DEFINE_boolean("env", "KukaBulletEnv-v0",
                     "The gym / bullet simulation environment to use.")
flags.DEFINE_boolean("max_length", 1000,
                     "The maximum length of an episode.")
flags.DEFINE_boolean("steps", 1e7,
                     "The number of steps.")

# Network
flags.DEFINE_boolean("network", 'agents.scripts.networks.feed_forward_gaussian',
                     "The registered network name to use for policy and value.")
flags.DEFINE_boolean("policy_layers", "200,100",
                     "A comma-separates list of the size of a series of layers "
                     "to comprise the policy network.")
flags.DEFINE_boolean("value_layers", "200,100",
                     "A comma-separates list of the size of a series of layers "
                     "to comprise the value network.")
flags.DEFINE_boolean("init_mean_factor", 0.1,
                     "unk")
flags.DEFINE_boolean("init_logstd", -1,
                     "unk")

# Optimization
flags.DEFINE_boolean("learning_rate", 1e-4,
                     "The learning rate of the optimizer.")
flags.DEFINE_boolean("optimizer", "tf.train.AdamOptimizer",
                     "The import path of the optimizer to use.")
flags.DEFINE_boolean("update_epochs", 25,
                     "The number of update epochs.")
flags.DEFINE_boolean("update_every", 30,
                     "The update frequency.")

# Losses
flags.DEFINE_boolean("discount", 0.995,
                     "The discount.")
flags.DEFINE_boolean("kl_target", 1e-2,
                     "the KL target.")
flags.DEFINE_boolean("kl_cutoff_factor", 2,
                     "The KL cutoff factor.")
flags.DEFINE_boolean("kl_cutoff_coef", 1000,
                     "The KL cutoff coefficient.")
flags.DEFINE_boolean("kl_init_penalty", 1,
                     "The initial KL penalty?.")

FLAGS = flags.FLAGS


def _realize_import_attrs(obj, attribute_names):
    """Given array of attribute names, loops over those attributes of obj
    converting the string attribute to an imported python object, failing if
    such an import cannot be performed."""
    pass


def _get_agents_configuration(log_dir, is_chief=False):
  """Load hyperparameter config."""
  try:
    # Try to resume training.
    hparams = agents.scripts.utility.load_config(log_dir)
  except IOError:
    from .hparams import realize
    hparams = _realize_import_attrs(FLAGS,
                                    ["network", "algorithm", "optimizer"])

    # HACK: Extend with weight summaries
    hparams.weight_summaries = dict(all=r'.*',
                               policy=r'.*/policy/.*',
                               value=r'.*/value/.*')

    hparams = hp.as_dict()

    if is_chief:
      # Write the hyperparameters for this run to a config YAML for posteriority
      #hparams = agents.scripts.utility.save_config(hparams, log_dir)
      hparams = agents.scripts.utility.save_config(hp, log_dir)
  return hparams


def main(unused_argv):
  """Run training.

  Raises:
    ValueError: If the arguments are invalid.
  """
  tf.logging.set_verbosity(tf.logging.INFO)
  tf.logging.info("Tensorflow version: %s", tf.__version__)
  tf.logging.info("Tensorflow git version: %s", tf.__git_version__)

  if FLAGS.debug:
    tf.logging.set_verbosity(tf.logging.DEBUG)

  run_config = tf.contrib.learn.RunConfig()

  log_dir = FLAGS.logdir

  agents_config = _get_agents_configuration(
      FLAGS.config, log_dir, run_config.is_chief)

  if (FLAGS.mode == 'train' or FLAGS.mode == 'train_and_render'):
    if run_config.is_chief:
      for score in agents.scripts.train.train(agents_config, env_processes=True):
        logging.info('Score {}.'.format(score))
  if (FLAGS.mode == 'render' or FLAGS.mode == 'train_and_render'):
    agents.scripts.visualize.visualize(
        logdir=FLAGS.logdir, outdir=log_dir, num_agents=1, num_episodes=1,
        checkpoint=None, env_processes=True)
  if FLAGS.mode not in ['train', 'render', 'train_and_render']:
    raise ValueError('Unrecognized mode, please set the run mode with --mode '
                     'to train, render, or train_and_render.')


if __name__ == '__main__':
  tf.app.run()
