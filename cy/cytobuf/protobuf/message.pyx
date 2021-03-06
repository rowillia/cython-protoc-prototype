# distutils: language = c++
# distutils: extra_link_args = -lprotobuf
# distutils: include_dirs = /usr/local/include
# distutils: library_dirs = /usr/local/lib
# distutils: extra_compile_args= -std=c++11


from libcpp.string cimport string

from cytobuf.protobuf.common cimport MessageDifferencer
from cytobuf.protobuf.common cimport MessageToJsonString


cdef class Message:

    def __cinit__(self, bint _init = True):
        self._ptr_owner = _init

    def __dealloc__(self):
        if self._internal is not NULL and self._ptr_owner is True:
            del self._internal
            self._internal = NULL

    def SerializeToString(self):
        cdef string result = string()
        self._internal.SerializeToString(&result)
        return result

    def to_json(self):
        cdef string result = string()
        MessageToJsonString(self._internal[0], &result)
        return result

    def ParseFromString(self, bytes data):
        self._internal.ParseFromString(data)

    def __repr__(self):
        return self.DebugString()

    def __str__(self):
        return self.DebugString()

    def __eq__(self, other):
        cdef MessageDifferencer differencer
        cdef Message _other_message
        if isinstance(other, Message):
            _other_message = <Message> other
            return differencer.Equals(self._internal[0], _other_message._internal[0])
        return False