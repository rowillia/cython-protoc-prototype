import sys

sys.path.append('cy/')  # noqa

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
  name = 'Test app',
  ext_modules=[
    Extension('addressbook',
              sources=[
                'addressbook.pyx',
                '../cc/pb/addressbook/models/addressbook.pb.cc',
                '../cc/pb/people/models/people.pb.cc',
              ],
              extra_compile_args=['-std=c++11'],
              include_dirs=[
                "/usr/local/include",
                "../cc/"
              ],
              library_dirs=["/usr/local/lib"],
              extra_link_args=['-lprotobuf'],
              language='c++')
    ],
  cmdclass = {'build_ext': build_ext}
)