# distutils: language = c++
# distutils: extra_link_args = -lprotobuf
# distutils: include_dirs = /usr/local/include
# distutils: include_dirs = ../cc
# distutils: library_dirs = /usr/local/lib
# distutils: extra_compile_args= -std=c++11
# distutils: sources = ../cc/pb/addressbook/models/addressbook.pb.cc


from cytobuf.protobuf.message cimport Message
from cy_pb.people.models.people_pb cimport Person
from cy_pb.addressbook.models.addressbook_pb_externs cimport AddressBook as CppAddressBook


cdef class AddressBook(Message):
    def __cinit__(self, _init = True):
        if _init:
            self._internal = new CppAddressBook()

    cdef CppAddressBook* _message(self):
        return <CppAddressBook*>self._internal

    @staticmethod
    cdef from_cpp(CppAddressBook* other):
        result = AddressBook(_init=False)
        result._internal = other
        return result

    @property
    def people(self):
        cdef int i
        cdef CppAddressBook* _message = self._message()
        for i in range(_message.people_size()):
            yield Person.from_cpp(_message.mutable_people(i))