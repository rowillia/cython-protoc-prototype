# distutils: language = c++

from libcpp.string cimport string
from pb.people.models.people_pb_externs cimport Person
from common cimport Message

cdef extern from "pb/addressbook/models/addressbook.pb.h" namespace "pb::addressbook::models":
    cdef cppclass AddressBook(Message):
        AddressBook()
        int people_size() const
        Person* mutable_people(int index) except +
        Person* add_people()