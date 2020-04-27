from cytobuf.protobuf.message cimport Message
from cy_pb.people.models.people_pb_externs cimport Person as CppPerson
from cy_pb.people.models.people_pb_externs cimport Person_PhoneNumber as CppPerson_PhoneNumber


cdef class _Person_PhoneNumber(Message):
    cdef CppPerson_PhoneNumber* _message(self)

    @staticmethod
    cdef _Person_PhoneNumber from_cpp(CppPerson_PhoneNumber* other)


cdef class Person(Message):
    cdef CppPerson* _message(self)

    @staticmethod
    cdef Person from_cpp(CppPerson* other)