# distutils: language = c++

from libcpp.string cimport string
from cytobuf.protobuf.common cimport Message
from cy_pb.people.models.people_pb_externs cimport Person

cdef extern from "pb/addressbook/models/addressbook.pb.h" namespace "pb::addressbook::models":
    cdef cppclass AddressBook(Message):
        AddressBook()
        int people_size() const
        Person* mutable_people(int index) except +
        Person* add_people()