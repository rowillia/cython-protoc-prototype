from cytobuf.protobuf.message cimport Message
from cy_pb.people.models.people_pb cimport Person
from cy_pb.addressbook.models.addressbook_pb_externs cimport AddressBook as CppAddressBook


cdef class AddressBook(Message):
    cdef CppAddressBook* _message(self)

    @staticmethod
    cdef from_cpp(CppAddressBook* other)