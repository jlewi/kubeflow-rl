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

import baselines
import pybullet_envs

flags = tf.app.flags

flags.DEFINE_string("algorithm", "ppo2",
                    "The OpenAI baselines algorithm to train.")
flags.DEFINE_string("config", None,
                    "The hparam ID corresponding to hparams to use for this run.")
flags.DEFINE_string("logdir", None,
                    "The base directory in which to write logs and "
                    "checkpoints.")
flags.DEFINE_string("run_base_tag",
                    datetime.datetime.now().strftime('%Y%m%dT%H%M%S'),
                    "Base tag to prepend to logs dir folder name. Defaults "
                    "to timestamp.")
FLAGS = flags.FLAGS


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

  FLAGS.logdir = os.path.join(
    FLAGS.logdir, '{}-{}'.format(FLAGS.run_base_tag, FLAGS.config))


if __name__ == '__main__':
  tf.app.run()
