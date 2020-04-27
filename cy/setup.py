import sys

sys.path.append('cy/')  # noqa

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

setup(
  name = 'Test app',
  ext_modules=cythonize(
    [
      'cytobuf/protobuf/message.pyx',
      'cy_pb/people/models/people_pb.pyx',
      'cy_pb/addressbook/models/addressbook_pb.pyx',
    ],
    language_level = "3"
  ),
)